/******************************************************************************
License:
Copyright (c) 2008 Jarrett Billingsley

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the
use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it freely,
subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software in a
	product, an acknowledgment in the product documentation would be
	appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not
	be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
******************************************************************************/

module mdcl;

import tango.io.Stdout;
import tango.io.Console;

import amigos.minid.api;
import amigos.minid.commandline;

const 
{
bool да = true;
bool нет = false;

}

pragma(lib, "amigos.lib");
pragma(lib, "tango.lib");


version(MdclAllAddons)
{
	version = MdclSdlAddon;
	version = MdclGlAddon;
	version = MdclNetAddon;
	version = MdclPcreAddon;
}

version(MdclSdlAddon)  import amigos.minid.addons.sdl;
version(MdclGlAddon)   import amigos.minid.addons.gl;
version(MdclNetAddon)  import amigos.minid.addons.net;
version(MdclPcreAddon) import amigos.minid.addons.pcre;

const char[] Usage =
"Использование:
\tминиД(\"[флаги] [имяф [арги]]\");

Флаги:
    -v        Выводит версию CLI и выходит.
    -h        Выводит данное сообщение и выходит.
    -I путь   Указывает путь импорта для поиска модулей.
    -d        Загружает отладочную библиотеку.

миниД можно использовать в двух режимах: файловом и интерактивном.

Если передано имя файла, миниД запускается в файловом режиме, загружая файл и
выполняя любую функцию main(), в нём определенную. Если у имени нет расширения,
это оценивается как имя модуля в стиле MiniD.  Так \"a.b\" означает
поиск модуля с именем b в папке a.  Флаг -I также вляет на пути поисков,
используемые для него.

При передаче имени файла, за которым следуют аргументы, все арги будут
переданы функции main().  Все эти аргументы будут типа ткст.

Если имя файла не передано, то запускается интерактивный режим.


В интерактивном режиме вы видите приглашение >>>. Нажав enter,
вы также можете получить ... приглашение. Это значит, что для
окончательности кода вам надо ввести ещё что-то.  Как только
вы ввели полноценный код, этот код выполняется. Если есть ошибка,
буфер с кодом удаляется. Для выхода из интерактивного режима
используется функция \"exit()\".\n\n
";


проц printVersion()
{
	Stdout("MiniD интерпретатор командной строки 2.0").newline;
}

проц printUsage()
{
	printVersion();
	Stdout(Usage);
}

struct Params
{
	бул justStop;
	бул debugEnabled;
	char[] inputFile;
	char[][] args;
}

Params parseArguments(MDThread* t, char[][] args)
{
	Params ret;

	for(цел i = 0; i < args.length; i++)
	{
		switch(args[i])
		{
			case "-v":
				printVersion();
				ret.justStop = да;
				break;

			case "-h":
				printUsage();
				ret.justStop = да;
				break;

			case "-I":
				i++;

				if(i >= args.length)
				{
					Stdout("-I должно сопровождаться последующим указанием пути").newline;
					printUsage();
					ret.justStop = да;
					break;
				}

				pushGlobal(t, "modules");
				field(t, -1, "path");
				pushChar(t, ';');
				pushString(t, args[i]);
				cateq(t, -3, 2);
				fielda(t, -2, "path");
				pop(t);
				continue;

			case "-d":
				ret.debugEnabled = да;
				continue;

			default:
				if(args[i].startsWith("-"))
				{
					Stdout.formatln("Неизвестный флаг '{}'", args[i]);
					printUsage();
					ret.justStop = да;
					break;
				}

				ret.inputFile = args[i];
				ret.args = args[i + 1 .. $];
				break;
		}

		break;
	}

	return ret;
}

export extern (C) цел миниД(ткст[] args)
{
	MDVM vm;
	auto t = openVM(&vm);
	loadStdlibs(t, MDStdlib.All);

	version(MdclSdlAddon)  SdlLib.init(t);
	version(MdclGlAddon)   GlLib.init(t);
	version(MdclNetAddon)  NetLib.init(t);
	version(MdclPcreAddon) PcreLib.init(t);

	auto params = parseArguments(t, args);

	if(params.justStop)
		return 0;

	if(params.debugEnabled)
		loadStdlibs(t, MDStdlib.Debug);

	try
	{
		if(params.inputFile)
		{
			mdtry(t,
			{
				foreach(arg; params.args)
					pushString(t, arg);

				runFile(t, params.inputFile, params.args.length);
			},
			(MDException e, word mdEx)
			{
				Stdout.formatln("Ошибка: {}", e);
				getTraceback(t);
				Stdout.formatln("{}", getString(t, -1));
				pop(t);
			});
		}
		else
		{
			printVersion();

			ConsoleCLI cli;
			cli.interactive(t);
		}
	}
	catch(Исключение e)
	{
		Stdout.formatln("Ну, блин!");
		e.writeOut((char[]s) { Stdout(s); });
		return 1;
	}

	closeVM(&vm);
	return 0;
}