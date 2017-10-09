
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

module std.io;
import std.x.io, win, std.x.utf;


export extern(D):

ткст читайстр()
	{
		ткст buf;
		std.x.io.readln(cidrus.стдвхо, buf);
		 return buf;
		/+
	бцел  mode, get;
	ткст input[8];

	GetConsoleMode( ДайСтдДескр(ПСтд.Ввод), &mode );
	SetConsoleMode( ДайСтдДескр(ПСтд.Ввод), 0 );
	ReadConsoleA( ДайСтдДескр(ПСтд.Ввод), input, 1, &get, NULL );
	SetConsoleMode( ДайСтдДескр(ПСтд.Ввод), mode );
	return input[0];
	+/
	}

	т_мера читайстр(inout ткст буф)
	{
	/+
		DWORD i = буф.length / 4;
		const Кф = -1;
		шим[] ввод = new шим [1024 * 1];

                                   assert (i);

                                   if (i > ввод.length)
                                       i = ввод.length;

                                   // читай a chunk of wchars из_ the console
                                   if (! ReadConsoleW (ДайСтдДескр(ПСтд.Ввод), ввод.ptr, i, &i, null))
                                         exception.ошибка("Неудачное чтение консоли");

                                   // no ввод ~ go home
                                   if (i is 0)
                                       return Кф;

                                   // translate в_ utf8, directly преобр_в приёмн
                                   i = sys.WinFuncs.WideCharToMultiByte (65001, 0, ввод.ptr, i,
                                                            cast(PCHAR) буф.ptr, буф.length, null, 0);
                                   if (i is 0)
                                       exception.ошибка ("Неудачное преобразование консольного вввода");

                                   return i;
								   +/
		return читайстр(cidrus.стдвхо, буф);

	}

	т_мера читайстр(фук чф, inout ткст буф)
	{
	return std.x.io.readln(чф, буф);
	}

	проц скажи(ткст ткт)
	{
	 win.скажи(ткт);
	}
	проц скажинс(ткст ткт)
	{
	 win.скажинс(ткт);}

	проц скажи(бдол ткт)
	{
	 win.скажи(ткт);}

	проц скажинс(бдол ткт)
	{
	 win.скажинс(ткт);}

	проц нс()
	{
		win.нс();
	}

	проц таб()
	{
		win.таб();
	}

	проц пишиф(...)/////
	{
	auto args = _arguments;
	std.x.io.writefx( cidrus.стдвых, _arguments, _argptr, 0);
	}

	проц пишифнс(...)//////
	{
	std.x.io.writefx( cidrus.стдвых, _arguments, _argptr, 1);
	}

	проц скажифнс(...)//////
	{
	auto args = _arguments;
    auto argptr = _argptr;
   // ткст fmt = null;
    //разборСпискаАргументов(args, argptr, fmt);

    ткст т;

    проц putc(дим c)
    {
	std.x.utf.encode(т, c);
    }

		форматДелай(&putc, args, argptr);
		win.скажинс(т);
	}

	проц скажиф(...)///////
	{
	auto args = _arguments;
    auto argptr = _argptr;
   // ткст fmt = null;
    //разборСпискаАргументов(args, argptr, fmt);

    ткст т;

    проц putc(дим c)
    {
	std.x.utf.encode(т, c);
    }

		форматДелай(&putc, args, argptr);
		win.скажи(т);
	}

	проц пишиф_в(cidrus.фук чф, ...)//////
	{

		std.x.io.writefx( чф, _arguments, _argptr, 0);
	}

	проц пишифнс_в(cidrus.фук чф, ...)///////
	{
		std.x.io.writefx( чф, _arguments, _argptr, 1);
	}

	проц разборСпискаАргументов(ref ИнфОТипе[] args, ref спис_ва argptr, out ткст формат)
	 {
	  if (args.length == 2 && args[0] == typeid(ИнфОТипе[]) && args[1] == typeid(спис_ва)) {
		args = ва_арг!(ИнфОТипе[])(argptr);
		argptr = *cast(спис_ва*)argptr;

		if (args.length > 1 && args[0] == typeid(ткст)) {
		  формат = ва_арг!(ткст)(argptr);
		  args = args[1 .. $];
		}

		if (args.length == 2 && args[0] == typeid(ИнфОТипе[]) && args[1] == typeid(спис_ва)) {
		  разборСпискаАргументов(args, argptr, формат);
		}
	  }
	  else if (args.length > 1 && args[0] == typeid(ткст)) {
		формат = ва_арг!(ткст)(argptr);
		args = args[1 .. $];
	  }
	}

	бул выведиФайл(ткст имяф)
	{
	 скажи(cast(ткст) читайФайл(имяф)); return да;
	}

