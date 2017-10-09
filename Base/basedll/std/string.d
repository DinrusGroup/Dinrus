module std.string;
import std.x.string, exception, std.format;

typedef extern (D) ткст function(дим) Обрвызов_диэксп_Дим;

export extern(D)
{

	бул вОбразце(дим с, ткст образец){return cast(бул) std.x.string.inPattern(с, образец);}
	бул вОбразце(дим с, ткст[] образец){return cast(бул) std.x.string.inPattern(с, образец);}

	
	ткст фм(...)//////
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
		return т;
	}
alias фм форматируй;

	ткст форматируйс(ткст т, ...)
	{

	т_мера i;

		проц putc(дим c)
		{
		if (c <= 0x7F)
		{
			if (i >= т.length)
			throw new ГранМасОшиб("stdrus.форматируйс", __LINE__);
			т[i] = cast(сим)c;
			++i;
		}
		else
		{   сим[4] буф;
			ткст b;

			b = std.x.utf.toUTF8(буф, c);
			if (i + b.length > т.length)
		throw new ГранМасОшиб("stdrus.форматируйс", __LINE__);
			т[i..i+b.length] = b[];
			i += b.length;
		}
		}

		форматДелай(&putc, _arguments, _argptr);
		return т[0 .. i];
	}

бул пробел_ли(дим т)
	{
	return cast(бул)(std.x.string.iswhite(cast(дим) т));
	}
	/////////////////////////////
	дол ткствцел(ткст т)
	{
	return cast(дол)(std.x.string.atoi(cast(сим[]) т));
	}
	/////////////////////////////////
	реал ткствдробь(ткст т)
	{
	return cast(реал)(std.x.string.atof(cast(сим[]) т));
	}
	/////////////////////////////////////
	цел сравни(ткст s1, ткст s2)
	{
	return cast(цел)(std.x.string.cmp(cast(сим[]) s1, cast(сим[]) s2));
	}
	///////////////////////////////////////
	цел сравнлюб(ткст s1, ткст s2)
	{
	return cast(цел)(std.x.string.icmp(cast(сим[]) s1, cast(сим[]) s2));
	}
	/////////////////////////////////////////////
	сим* вТкст0(ткст т)
	{
	return cast(сим*)(std.x.string.toStringz(cast(сим[]) т));
	}
	/////////////////////////////////////////////
	цел найди(ткст т, дим c)
	{
	return cast(цел)(std.x.string.find(cast(сим[]) т, cast(дим) c));
	}
	/////////////////////////////////////////////////
	цел найдлюб(ткст т, дим c)
	{
	return cast(цел)(std.x.string.ifind(cast(сим[]) т, cast(дим) c));
	}
	////////////////////////////////////////////////
	цел найдрек(ткст т, дим c)
	{
	return cast(цел)(std.x.string.rfind(cast(сим[]) т, cast(дим) c));
	}
	///////////////////////////////////////////////
	цел найдлюбрек(ткст т, дим c)
	{
	return cast(цел)(std.x.string.irfind(cast(сим[]) т, cast(дим) c));
	}
	/////////////////////////////////////////////////
	цел найди(ткст т, ткст тзам)
	{
	return cast(цел)(std.x.string.find(cast(сим[]) т, cast(сим[]) тзам));
	}
	/////////////////////////////////////////////////
	цел найдлюб(ткст т, ткст тзам)
	{
	return  cast(цел)(std.x.string.ifind(cast(сим[]) т, cast(сим[]) тзам));
	}
	/////////////////////////////////////////////////
	цел найдрек(ткст т, ткст тзам)
	{
	return  cast(цел)(std.x.string.rfind(cast(сим[]) т, cast(сим[]) тзам));
	}
	///////////////////////////////////////////////
	цел найдлюбрек(ткст т, ткст тзам)
	{
	return  cast(цел)(std.x.string.irfind(cast(сим[]) т, cast(сим[]) тзам));
	}
	//////////////////////////////////////////////
	ткст впроп(ткст т)
	{
	return cast(ткст)(std.x.string.tolower(cast(ткст) т));
	}
	//////////////////////////////////////////////////
	ткст взаг(ткст т)
	{
	return cast(ткст)(std.x.string.toupper(cast(ткст) т));
	}
	////////////////////////////////////////////////////
	ткст озаг(ткст т){return std.x.string.capitalize(т);}
	////////////////////////////////////////////////////
	ткст озагслова(ткст т){return std.x.string.capwords(т);}
	/////////////////////////////////////////////
	ткст повтори(ткст т, т_мера м){return std.x.string.repeat(т, м);}
	///////////////////////////////////////////
	ткст объедини(ткст[] слова, ткст разд){return  std.x.string.join(слова, разд);}
	///////////////////////////////////////
	ткст[] разбей(ткст т){ткст м_т = т; return std.x.string.split(м_т);}
	ткст[] разбейдоп(ткст т, ткст разделитель){ткст м_т = т; ткст м_разделитель = разделитель; return std.x.string.split(м_т, м_разделитель);}
	//////////////////////////////
	ткст[] разбейнастр(ткст т){return std.x.string.splitlines(т);}
	////////////////////////
	ткст уберислева(ткст т){return  std.x.string.stripl(т);}
	ткст уберисправа(ткст т){return  std.x.string.stripr(т);}
	ткст убери(ткст т){return  std.x.string.strip(т);}
	///////////////////////////
	ткст убериразгр(ткст т){return  std.x.string.chomp(т);}
	ткст уберигран(ткст т){return  std.x.string.chop(т);}
	/////////////////
	ткст полев(ткст т, цел ширина){return  std.x.string.ljustify(т, ширина);}
	ткст поправ(ткст т, цел ширина){return  std.x.string.rjustify(т, ширина);}
	ткст вцентр(ткст т, цел ширина){return  std.x.string.center(т, ширина);}
	ткст занули(ткст т, цел ширина){return  std.x.string.zfill(т, ширина);}

	ткст замени(ткст т, ткст с, ткст на){ ткст м_т = т.dup; ткст м_с = т.dup; ткст м_на = т.dup; return  std.x.string.replace(м_т, м_с, м_на);}
	ткст заменисрез(ткст т, ткст срез, ткст замена){ткст м_т = т; ткст м_срез = срез; ткст м_замена = замена; return  std.x.string.replaceSlice(м_т, м_срез, м_замена);}
	ткст вставь(ткст т, т_мера индекс, ткст подст){ return  std.x.string.insert(т, индекс, подст);}
	т_мера счесть(ткст т, ткст подст){return  std.x.string.count(т, подст);}


	ткст заменитабнапбел(ткст стр, цел размтаб=8){return std.x.string.expandtabs(стр, размтаб);}
	ткст заменипбелнатаб(ткст стр, цел размтаб=8){return std.x.string.entab(стр, размтаб);}
	ткст постройтранстаб(ткст из, ткст в){return maketrans(из, в);}
	ткст транслируй(ткст т, ткст табтранс, ткст удсим){return translate(т, табтранс, удсим);}


	т_мера посчитайсимв(ткст т, ткст образец){return  std.x.string.countchars(т, образец);}
	ткст удалисимв(ткст т, ткст образец){return  std.x.string.removechars(т, образец);}
	ткст сквиз(ткст т, ткст образец= null){return  std.x.string.squeeze(cast(сим[]) т, cast(сим[]) образец);}
	ткст следщ(ткст т){return std.x.string.succ(т);}

	ткст тз(ткст ткт, ткст из, ткст в, ткст модифф = null){return std.x.string.tr(ткт, из, в, модифф);}
	бул чис_ли(in ткст т, in бул раздВкл = false){return cast(бул) std.x.string.isNumeric(т, раздВкл);}
	т_мера колном(ткст ткт, цел размтаб=8){return std.x.string.column(ткт, размтаб);}
	ткст параграф(ткст т, цел колонки = 80, ткст первотступ = null, ткст отступ = null, цел размтаб = 8){return std.x.string.wrap(т, колонки, первотступ, отступ, размтаб);}
	ткст эладр_ли(ткст т){return  std.x.string.isEmail(т);}
	ткст урл_ли(ткст т){return  std.x.string.isURL(т);}
	ткст целВЮ8(ткст врем, бцел знач){return std.x.string.intToUtf8(врем, знач);}
	ткст бдолВЮ8(ткст врем, бцел знач){return std.x.string.ulongToUtf8(врем, знач);}

	ткст вТкст(бул с){return std.x.string.toString(с);}
	ткст вТкст(сим с)
	{
		ткст результат = new сим[2];
		результат[0] = с;
		результат[1] = 0;
		return результат[0 .. 1];
	}
	ткст вТкст(ббайт с){return std.x.string.toString(с);}
	ткст вТкст(бкрат с){return std.x.string.toString(с);}
	ткст вТкст(бцел с){return std.x.string.toString(с);}
	ткст вТкст(бдол с){return std.x.string.toString(с);}
	ткст вТкст(байт с){return std.x.string.toString(с);}
	ткст вТкст(крат с){return std.x.string.toString(с);}
	ткст вТкст(цел с){return std.x.string.toString(с);}
	ткст вТкст(дол с){return std.x.string.toString(с);}
	ткст вТкст(плав с){return std.x.string.toString(с);}
	ткст вТкст(дво с){return std.x.string.toString(с);}
	ткст вТкст(реал с){return std.x.string.toString(с);}
	ткст вТкст(вплав с){return std.x.string.toString(с);}
	ткст вТкст(вдво с){return std.x.string.toString(с);}
	ткст вТкст(вреал с){return std.x.string.toString(с);}
	ткст вТкст(кплав с){return std.x.string.toString(с);}
	ткст вТкст(кдво с){return std.x.string.toString(с);}
	ткст вТкст(креал с){return std.x.string.toString(с);}
	ткст вТкст(дол знач, бцел корень){return std.x.string.toString(знач, корень);}
	ткст вТкст(бдол знач, бцел корень){return std.x.string.toString(знач, корень);}
	ткст вТкст(сим *с){return std.x.string.toString(с);}
}/////extern D


