/******************************************************************************
License:
Copyright (c) 2007 Jarrett Billingsley

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

module minidc;

import tango.io.device.File;
import tango.io.Stdout;

import amigos.minid.api;
import amigos.minid.compiler;
pragma(lib, "amigos.lib");
pragma(lib, "tango.lib");

const пусто = null ;

проц printUsage()
{
	Stdout.formatln("Компилятор MiniD v{}.{}", MiniDVersion >> 16, MiniDVersion & 0xFFFF).newline;
	Stdout("Использование:").newline;
	Stdout("\tмдКомпилятор(имяф)").newline;
	Stdout.newline;
	Stdout("Эта программа очень прямолинейна. Ей следует указать имя файла .md,").newline;
	Stdout("и она скомпилирует модуль, записав его в бинарный файл .mdm.").newline;
	Stdout("Выходной файл будет называться так же, как и входной,").newline;
	Stdout("только с расширением .mdm.").newline;
}

export extern (C) цел мдКомпилятор(ткст arg = пусто)
{
	if(arg == пусто)
	{
		printUsage();
		return 0;
	}

	MDVM vm;
	auto t = openVM(&vm);

	scope(exit)
		closeVM(&vm);

	scope c = new Compiler(t);
	c.compileModule(arg);

	scope fc = new File(arg ~ "m", File.WriteCreate);
	serializeModule(t, -1, fc);
	fc.close();
	return 0;
}