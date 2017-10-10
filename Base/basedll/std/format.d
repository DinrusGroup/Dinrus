
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.
module std.format;
//debug=format;		// uncomment to turn on debugging эхо's

import tpl.args, exception;

private import std.utf;
private import cidrus, sys.WinFuncs;
private import std.string;

version (Windows)
{
    version (DigitalMars)
    {
	version = DigitalMarsC;
    }
}

version (DigitalMarsC)
{
    // This is DMC's internal floating point formatting function
    extern  (C)
    {
	extern  char* function(int c, int flags, int precision, real* pdval,
	    char* buf, int* psl, int width) __pfloatfmt;
    }
}
else
{
    // Use C99 snprintf
    extern  (C) int snprintf(char* s, size_t n, char* format, ...);
}


 enum ПМангл : сим
{
    Тпроц     = 'v',
    Тбул     = 'b',
    Тбайт     = 'g',
    Тббайт    = 'h',
    Ткрат    = 's',
    Тбкрат   = 't',
    Тцел      = 'i',
    Тбцел     = 'k',
    Тдол     = 'l',
    Тбдол    = 'm',
    Тплав    = 'f',
    Тдво   = 'd',
    Треал     = 'e',

    Твплав   = 'o',
    Твдво  = 'p',
    Твреал    = 'j',
    Ткплав   = 'q',
    Ткдво  = 'r',
    Ткреал    = 'c',

    Тсим     = 'a',
    Тшим    = 'u',
    Тдим    = 'w',

    Тмассив    = 'A',
    Тсмассив   = 'G',
    Тамассив   = 'H',
    Туказатель  = 'P',
    Тфункция = 'F',
    Тидент    = 'I',
    Ткласс    = 'C',
    Тструкт   = 'S',
    Тперечень     = 'E',
    Ттипдеф  = 'T',
    Тделегат = 'D',

    Тконст    = 'x',
    Тинвариант = 'y',
}

ИнфОТипе простаяИнфОТипе(ПМангл м)
{
  ИнфОТипе ti;

  switch (м)
    {
    case ПМангл.Тпроц:
      ti = typeid(проц);break;
    case ПМангл.Тбул:
      ti = typeid(бул);break;
    case ПМангл.Тбайт:
      ti = typeid(байт);break;
    case ПМангл.Тббайт:
      ti = typeid(ббайт);break;
    case ПМангл.Ткрат:
      ti = typeid(крат);break;
    case ПМангл.Тбкрат:
      ti = typeid(бкрат);break;
    case ПМангл.Тцел:
      ti = typeid(цел);break;
    case ПМангл.Тбцел:
      ti = typeid(бцел);break;
    case ПМангл.Тдол:
      ti = typeid(дол);break;
    case ПМангл.Тбдол:
      ti = typeid(бдол);break;
    case ПМангл.Тплав:
      ti = typeid(плав);break;
    case ПМангл.Тдво:
      ti = typeid(дво);break;
    case ПМангл.Треал:
      ti = typeid(реал);break;
    case ПМангл.Твплав:
      ti = typeid(вплав);break;
    case ПМангл.Твдво:
      ti = typeid(вдво);break;
    case ПМангл.Твреал:
      ti = typeid(вреал);break;
    case ПМангл.Ткплав:
      ti = typeid(кплав);break;
    case ПМангл.Ткдво:
      ti = typeid(кдво);break;
    case ПМангл.Ткреал:
      ti = typeid(креал);break;
    case ПМангл.Тсим:
      ti = typeid(сим);break;
    case ПМангл.Тшим:
      ti = typeid(шим);break;
    case ПМангл.Тдим:
      ti = typeid(дим);break;
    default:
      ti = null;
    }
  return ti;
}

export extern(D)
проц форматДелай(проц delegate(дим) putc, ИнфОТипе[] arguments, спис_ва argptr)
	{
	цел j;
    ИнфОТипе ti;
    ПМангл m;
    бцел флаги;
    цел ширина_поля;
    цел точность;

    enum : бцел
    {
	FLdash = 1,
	FLplus = 2,
	FLspace = 4,
	FLhash = 8,
	FLlngdbl = 0x20,
	FL0pad = 0x40,
	FLprecision = 0x80,
    }

    static ИнфОТипе skipCI(ИнфОТипе типзнач)
    {
      while (1)
      {
	if (типзнач.classinfo.name.length == 18 &&  типзнач.classinfo.name[9..18] == "Invariant")
	    типзнач =	(cast(TypeInfo_Invariant)типзнач).следщ;
	else if (типзнач.classinfo.name.length == 14 && типзнач.classinfo.name[9..14] == "Const")
	    типзнач =	(cast(TypeInfo_Const)типзнач).следщ;
	else
	    break;
      }
      return типзнач;
    }

    проц formatArg(сим fc)
    {
	бул vbit;
	бдол vnumber;
	сим vchar;
	дим vdchar;
	Объект vobject;
	реал vreal;
	креал vcreal;
	ПМангл m2;
	цел signed = 0;
	бцел base = 10;
	цел uc;
	сим[бдол.sizeof * 8] tmpbuf;	// дол enough to print дол in binary
	сим* prefix = "";
	ткст т;

	проц putstr(ткст т)
	{
	    //эхо("флаги = x%x\n", флаги);
		//win.скажинс(т);
	    цел prepad = 0;
	    цел postpad = 0;
		цел padding = ширина_поля - (cidrus.strlen(prefix) + т.length);//toUCSindex(т, т.length));
	    if (padding > 0)
	    {
		if (флаги & FLdash)
		    postpad = padding;
		else
		    prepad = padding;
	    }

	    if (флаги & FL0pad)
	    {
		while (*prefix)
		    putc(*prefix++);
		while (prepad--)
		    putc('0');
	    }
	    else
	    {
		while (prepad--)
		    putc(' ');
		while (*prefix)
		    putc(*prefix++);
	    }

	    foreach (дим c; т)
		putc(c);

	    while (postpad--)
		putc(' ');
	}

	проц putreal(реал v)
	{
	    //эхо("putreal %Lg\n", vreal);

	    switch (fc)
	    {
		case 's':
		    fc = 'g';
		    break;

		case 'f', 'F', 'e', 'E', 'g', 'G', 'a', 'A':
		    break;

		default:
		    //эхо("fc = '%c'\n", fc);
		Lerror:
		    throw new ФорматИскл("плавающая запятая");
	    }
	    version (DigitalMarsC)
	    {
		цел sl;
		ткст fbuf = tmpbuf;
		if (!(флаги & FLprecision))
		    точность = 6;
		while (1)
		{
		    sl = fbuf.length;
		    prefix = (*__pfloatfmt)(fc, флаги | FLlngdbl,
			    точность, &v, cast(сим*)fbuf, &sl, ширина_поля);
		    if (sl != -1)
			break;
		    sl = fbuf.length * 2;
		    fbuf = (cast(сим*)cidrus.разместа(sl * сим.sizeof))[0 .. sl];
		}
		debug(PutStr) win.скажинс("путстр1");
		putstr(fbuf[0 .. sl]);
	    }
	    else
	    {
		цел sl;
		ткст fbuf = tmpbuf;
		сим[12] format;
		format[0] = '%';
		цел i = 1;
		if (флаги & FLdash)
		    format[i++] = '-';
		if (флаги & FLplus)
		    format[i++] = '+';
		if (флаги & FLspace)
		    format[i++] = ' ';
		if (флаги & FLhash)
		    format[i++] = '#';
		if (флаги & FL0pad)
		    format[i++] = '0';
		format[i + 0] = '*';
		format[i + 1] = '.';
		format[i + 2] = '*';
		format[i + 3] = 'L';
		format[i + 4] = fc;
		format[i + 5] = 0;
		if (!(флаги & FLprecision))
		    точность = -1;
		while (1)
		{   цел n;

		    sl = fbuf.length;
		    n = snprintf(fbuf.ptr, sl, format.ptr, ширина_поля, точность, v);
		    //эхо("format = '%s', n = %d\n", cast(сим*)format, n);
		    if (n >= 0 && n < sl)
		    {	sl = n;
			break;
		    }
		    if (n < 0)
			sl = sl * 2;
		    else
			sl = n + 1;
		    fbuf = (cast(сим*)cidrus.разместа(sl * сим.sizeof))[0 .. sl];
		}
		debug(PutStr) win.скажинс("путстр2");
		putstr(fbuf[0 .. sl]);
	    }
	    return;
	}

	static ПМангл getMan(ИнфОТипе ti)
	{
	  auto m = cast(ПМангл)ti.classinfo.name[9];
	  if (ti.classinfo.name.length == 20 &&
	      ti.classinfo.name[9..20] == "StaticArray")
		m = cast(ПМангл)'G';
	  return m;
	}

	проц putArray(ук p, т_мера длин, ИнфОТипе типзнач)
	{
	  //эхо("\nputArray(длин = %u), tsize = %u\n", длин, типзнач.tsize());
	  putc('[');
	  типзнач = skipCI(типзнач);
	  т_мера tsize = типзнач.tsize();
	  auto argptrSave = argptr;
	  auto tiSave = ti;
	  auto mSave = m;
	  ti = типзнач;
	  //эхо("\n%.*т\n", типзнач.classinfo.name);
	  m = getMan(типзнач);
	  while (длин--)
	  {
	    //doFormat(putc, (&типзнач)[0 .. 1], p);
	    argptr = адаптВхоУкз(p);
	    formatArg('s');

	    p += tsize;
	    if (длин > 0) putc(',');
	  }
	  m = mSave;
	  ti = tiSave;
	  argptr = argptrSave;
	  putc(']');
	}

	проц putAArray(ббайт[дол] vaa, ИнфОТипе типзнач, ИнфОТипе keyti)
	{
	  putc('[');
	  бул comma=нет;
	  auto argptrSave = argptr;
	  auto tiSave = ti;
	  auto mSave = m;
	  типзнач = skipCI(типзнач);
	  keyti = skipCI(keyti);
	  foreach(inout fakevalue; vaa)
	  {
	    if (comma) putc(',');
	    comma = да;
	    // the key comes before the значение
	    ббайт* key = &fakevalue - дол.sizeof;

	    //doFormat(putc, (&keyti)[0..1], key);
	    argptr = key;
	    ti = keyti;
	    m = getMan(keyti);
	    formatArg('s');

	    putc(':');
	    auto keysize = keyti.tsize;
	    keysize = (keysize + 3) & ~3;
	    ббайт* значение = key + keysize;
	    //doFormat(putc, (&типзнач)[0..1], значение);
	    argptr = значение;
	    ti = типзнач;
	    m = getMan(типзнач);
	    formatArg('s');
	  }
	  m = mSave;
	  ti = tiSave;
	  argptr = argptrSave;
	  putc(']');
	}

	//эхо("formatArg(fc = '%c', m = '%c')\n", fc, m);
	switch (m)
	{
	    case ПМангл.Тбул:
		vbit = ва_арг!(бул)(argptr);
		if (fc != 's')
		{   vnumber = vbit;
		    goto Lnumber;
		}
		debug(PutStr) win.скажинс("путстр3");
		putstr(vbit ? "да" : "нет");
		return;


	    case ПМангл.Тсим:
		vchar = ва_арг!(сим)(argptr);
		if (fc != 's')
		{   vnumber = vchar;
		    goto Lnumber;
		}
	    L2:
		debug(PutStr) win.скажинс("путстр4");
		putstr((&vchar)[0 .. 1]);
		return;

	    case ПМангл.Тшим:
		vdchar = ва_арг!(шим)(argptr);
		goto L1;

	    case ПМангл.Тдим:
		vdchar = ва_арг!(дим)(argptr);
	    L1:
		if (fc != 's')
		{   vnumber = vdchar;
		    goto Lnumber;
		}
		if (vdchar <= 0x7F)
		{   vchar = cast(сим)vdchar;
		    goto L2;
		}
		else
		{   if (!дим_ли(vdchar))
			throw new Исключение("Неверный дим в формате",__FILE__, __LINE__);
		    сим[4] vbuf;
			debug(PutStr) win.скажинс("путстр5");
		    putstr(std.utf.вЮ8(vbuf, vdchar));
		}
		return;


	    case ПМангл.Тбайт:
		signed = 1;
		vnumber = ва_арг!(байт)(argptr);
		goto Lnumber;

	    case ПМангл.Тббайт:
		vnumber = ва_арг!(ббайт)(argptr);
		goto Lnumber;

	    case ПМангл.Ткрат:
		signed = 1;
		vnumber = ва_арг!(крат)(argptr);
		goto Lnumber;

	    case ПМангл.Тбкрат:
		vnumber = ва_арг!(бкрат)(argptr);
		goto Lnumber;

	    case ПМангл.Тцел:
		signed = 1;
		vnumber = ва_арг!(цел)(argptr);
		goto Lnumber;

	    case ПМангл.Тбцел:
	    Luцел:
		vnumber = ва_арг!(бцел)(argptr);
		goto Lnumber;

	    case ПМангл.Тдол:
		signed = 1;
		vnumber = cast(бдол)ва_арг!(дол)(argptr);
		goto Lnumber;

	    case ПМангл.Тбдол:
	    Lбдол:
		vnumber = ва_арг!(бдол)(argptr);
		goto Lnumber;

	    case ПМангл.Ткласс:
		vobject = ва_арг!(Объект)(argptr);
		if (vobject is null)
		    т = "null";
		else
		    т = vobject.toString();
		goto Lputstr;

	    case ПМангл.Туказатель:
		vnumber = cast(бдол)ва_арг!(проц*)(argptr);
		if (fc != 'x' && fc != 'X')		uc = 1;
		флаги |= FL0pad;
		if (!(флаги & FLprecision))
		{   флаги |= FLprecision;
		    точность = (проц*).sizeof;
		}
		base = 16;
		goto Lnumber;


	    case ПМангл.Тплав:
	    case ПМангл.Твплав:
		if (fc == 'x' || fc == 'X')
		    goto Luцел;
		vreal = ва_арг!(плав)(argptr);
		goto Lreal;

	    case ПМангл.Тдво:
	    case ПМангл.Твдво:
		if (fc == 'x' || fc == 'X')
		    goto Lбдол;
		vreal = ва_арг!(дво)(argptr);
		goto Lreal;

	    case ПМангл.Треал:
	    case ПМангл.Твреал:
		vreal = ва_арг!(реал)(argptr);
		goto Lreal;


	    case ПМангл.Ткплав:
		vcreal = ва_арг!(кплав)(argptr);
		goto Lcomplex;

	    case ПМангл.Ткдво:
		vcreal = ва_арг!(кдво)(argptr);
		goto Lcomplex;

	    case ПМангл.Ткреал:
		vcreal = ва_арг!(креал)(argptr);
		goto Lcomplex;

	    case ПМангл.Тсмассив:
		putArray(argptr, (cast(TypeInfo_StaticArray)ti).длин, (cast(TypeInfo_StaticArray)ti).следщ);
		return;

	    case ПМангл.Тмассив:
		цел mi = 10;
	        if (ti.classinfo.name.length == 14 &&
		    ti.classinfo.name[9..14] == "Array")
		{ // array of non-primitive types
		  ИнфОТипе tn = (cast(TypeInfo_Array)ti).следщ;
		  tn = skipCI(tn);
		  switch (cast(ПМангл)tn.classinfo.name[9])
		  {
		    case ПМангл.Тсим:  goto LarrayChar;
		    case ПМангл.Тшим: goto LarrayWchar;
		    case ПМангл.Тдим: goto LarrayDchar;
		    default:
			break;
		  }
		  проц[] va = ва_арг!(проц[])(argptr);
		  putArray(va.ptr, va.length, tn);
		  return;
		}
		if (ti.classinfo.name.length == 25 &&
		    ti.classinfo.name[9..25] == "AssociativeArray")
		{ // associative array
		  ббайт[дол] vaa = ва_арг!(ббайт[дол])(argptr);
		  putAArray(vaa,
			(cast(TypeInfo_AssociativeArray)ti).следщ,
			(cast(TypeInfo_AssociativeArray)ti).key);
		  return;
		}

		while (1)
		{
		    m2 = cast(ПМангл)ti.classinfo.name[mi];
		    switch (m2)
		    {
			case ПМангл.Тсим:
			LarrayChar:
			    т = ва_арг!(ткст)(argptr);
			    goto Lputstr;

			case ПМангл.Тшим:
			LarrayWchar:
			    шим[] sw = ва_арг!(wstring)(argptr);
			    т = std.utf.вЮ8(sw);
			    goto Lputstr;

			case ПМангл.Тдим:
			LarrayDchar:
			    дим[] sd = ва_арг!(dstring)(argptr);
			    т = std.utf.вЮ8(sd);
			Lputstr:
			    if (fc != 's')
				{
				throw new ФорматИскл("ткст");
				}
			    if (флаги & FLprecision && точность < т.length)
				т = т[0 .. точность];
				debug(PutStr) win.скажинс("путстр6");
			    putstr(т);
			    break;

			case ПМангл.Тконст:
			case ПМангл.Тинвариант:
			    mi++;
			    continue;

			default:
			    ИнфОТипе ti2 = простаяИнфОТипе(m2);
			    if (!ti2)
			      goto Lerror;
			    проц[] va = ва_арг!(проц[])(argptr);
			    putArray(va.ptr, va.length, ti2);
		    }
		    return;
		}

	    case ПМангл.Ттипдеф:
		ti = (cast(TypeInfo_Typedef)ti).base;
		m = cast(ПМангл)ti.classinfo.name[9];
		formatArg(fc);
		return;

	    case ПМангл.Тперечень:
		ti = (cast(TypeInfo_Enum)ti).base;
		m = cast(ПМангл)ti.classinfo.name[9];
		formatArg(fc);
		return;

	    case ПМангл.Тструкт:
	    {	TypeInfo_Struct tis = cast(TypeInfo_Struct)ti;
		if (tis.xtoString is null)
		    throw new ФорматИскл("Не удаётся преобразовать " ~ tis.toString() ~ " в ткст: функция \"ткст вТкст()\" не определена");
		т = tis.xtoString(argptr);
		argptr += (tis.tsize() + 3) & ~3;
		goto Lputstr;
	    }

	    default:
		goto Lerror;
	}

    Lnumber:
	switch (fc)
	{
	    case 's':
	    case 'd':
		if (signed)
		{   if (cast(дол)vnumber < 0)
		    {	prefix = "-";
			vnumber = -vnumber;
		    }
		    else if (флаги & FLplus)
			prefix = "+";
		    else if (флаги & FLspace)
			prefix = " ";
		}
		break;

	    case 'b':
		signed = 0;
		base = 2;
		break;

	    case 'o':
		signed = 0;
		base = 8;
		break;

	    case 'X':
		uc = 1;
		if (флаги & FLhash && vnumber)
		    prefix = "0X";
		signed = 0;
		base = 16;
		break;

	    case 'x':
		if (флаги & FLhash && vnumber)
		    prefix = "0x";
		signed = 0;
		base = 16;
		break;

	    default:
		goto Lerror;
	}

	if (!signed)
	{
	    switch (m)
	    {
		case ПМангл.Тбайт:
		    vnumber &= 0xFF;
		    break;

		case ПМангл.Ткрат:
		    vnumber &= 0xFFFF;
		    break;

		case ПМангл.Тцел:
		    vnumber &= 0xFFFFFFFF;
		    break;

		default:
		    break;
	    }
	}

	if (флаги & FLprecision && fc != 'p')
	    флаги &= ~FL0pad;

	if (vnumber < base)
	{
	    if (vnumber == 0 && точность == 0 && флаги & FLprecision &&
		!(fc == 'o' && флаги & FLhash))
	    {
		debug(PutStr) win.скажинс("путстр7");
		putstr(null);
		return;
	    }
	    if (точность == 0 || !(флаги & FLprecision))
	    {	vchar = cast(сим)('0' + vnumber);
		if (vnumber < 10)
		    vchar = cast(сим)('0' + vnumber);
		else
		    vchar = cast(сим)((uc ? 'A' - 10 : 'a' - 10) + vnumber);
		goto L2;
	    }
	}

	цел n = tmpbuf.length;
	сим c;
	цел hexсмещение = uc ? ('A' - ('9' + 1)) : ('a' - ('9' + 1));

	while (vnumber)
	{
	    c = cast(сим)((vnumber % base) + '0');
	    if (c > '9')
		c += hexсмещение;
	    vnumber /= base;
	    tmpbuf[--n] = c;
	}
	if (tmpbuf.length - n < точность && точность < tmpbuf.length)
	{
	    цел m = tmpbuf.length - точность;
	    tmpbuf[m .. n] = '0';
	    n = m;
	}
	else if (флаги & FLhash && fc == 'o')
	    prefix = "0";
		debug(PutStr) win.скажинс("путстр8");
	putstr(tmpbuf[n .. tmpbuf.length]);
	return;

    Lreal:
	putreal(vreal);
	return;

    Lcomplex:
	putreal(vcreal.re);
	putc('+');
	putreal(vcreal.im);
	putc('i');
	return;

    Lerror:
	throw new ФорматИскл("\n\tформат аргумента неправильно указан");
    }


    for (j = 0; j < arguments.length; )
    {	ti = arguments[j++];
	//эхо("test1: '%.*т' %d\n", ti.classinfo.name, ti.classinfo.name.length);
	//ti.print();

	флаги = 0;
	точность = 0;
	ширина_поля = 0;

	ti = skipCI(ti);
	цел mi = 9;
	do
	{
	    if (ti.classinfo.name.length <= mi)
		goto Lerror;
	    m = cast(ПМангл)ti.classinfo.name[mi++];
	} while (m == ПМангл.Тконст || m == ПМангл.Тинвариант);

	if (m == ПМангл.Тмассив)
	{
	    if (ti.classinfo.name.length == 14 &&
		ti.classinfo.name[9..14] == "Array")
	    {
	      ИнфОТипе tn = (cast(TypeInfo_Array)ti).следщ;
	      tn = skipCI(tn);
	      switch (cast(ПМангл)tn.classinfo.name[9])
	      {
		case ПМангл.Тсим:
		case ПМангл.Тшим:
		case ПМангл.Тдим:
		    ti = tn;
		    mi = 9;
		    break;
		default:
		    break;
	      }
	    }
	L1:
	    ПМангл m2 = cast(ПМангл)ti.classinfo.name[mi];
	    ткст  fmt;			// format ткст
	    wstring wfmt;
	    dstring dfmt;

	    /* For performance причины, this код takes advantage of the
	     * fact that most format strings will be ASCII, and that the
	     * format specifiers are always ASCII. This means we only need
	     * to deal with UTF in a couple of isolated spots.
	     */

	    switch (m2)
	    {
		case ПМангл.Тсим:
		    fmt = ва_арг!(ткст)(argptr);
		    break;

		case ПМангл.Тшим:
		    wfmt = ва_арг!(wstring)(argptr);
		    fmt = std.utf.вЮ8(wfmt);
		    break;

		case ПМангл.Тдим:
		    dfmt = ва_арг!(dstring)(argptr);
		    fmt = std.utf.вЮ8(dfmt);
		    break;

		case ПМангл.Тконст:
		case ПМангл.Тинвариант:
		    mi++;
		    goto L1;

		default:
		    formatArg('s');
		    continue;
	    }

	    for (т_мера i = 0; i < fmt.length; )
	    {	дим c = fmt[i++];

		дим getFmtChar()
		{   // Valid format specifier символs will never be UTF
		    if (i == fmt.length)
			throw new ФорматИскл("Неверный спецификатор");
		    return fmt[i++];
		}

		цел getFmtInt()
		{   цел n;

		    while (1)
		    {
			n = n * 10 + (c - '0');
			if (n < 0)	// overflow
			    throw new ФорматИскл("Превышение размера цел");
			c = getFmtChar();
			if (c < '0' || c > '9')
			    break;
		    }
		    return n;
		}

		цел getFmtStar()
		{   ПМангл m;
		    ИнфОТипе ti;

		    if (j == arguments.length)
			throw new ФорматИскл("Недостаточно аргументов");
		    ti = arguments[j++];
		    m = cast(ПМангл)ti.classinfo.name[9];
		    if (m != ПМангл.Тцел)
			throw new ФорматИскл("Ожидался аргумент типа цел");
		    return ва_арг!(цел)(argptr);
		}

		if (c != '%')
		{
		    if (c > 0x7F)	// if UTF sequence
		    {
			i--;		// back up and decode UTF sequence
			c = std.utf.decode(fmt, i);
		    }
		Lputc:
		    putc(c);
		    continue;
		}

		// Get флаги {-+ #}
		флаги = 0;
		while (1)
		{
		    c = getFmtChar();
		    switch (c)
		    {
			case '-':	флаги |= FLdash;	continue;
			case '+':	флаги |= FLplus;	continue;
			case ' ':	флаги |= FLspace;	continue;
			case '#':	флаги |= FLhash;	continue;
			case '0':	флаги |= FL0pad;	continue;

			case '%':	if (флаги == 0)
					    goto Lputc;
			default:	break;
		    }
		    break;
		}

		// Get field width
		ширина_поля = 0;
		if (c == '*')
		{
		    ширина_поля = getFmtStar();
		    if (ширина_поля < 0)
		    {   флаги |= FLdash;
			ширина_поля = -ширина_поля;
		    }

		    c = getFmtChar();
		}
		else if (c >= '0' && c <= '9')
		    ширина_поля = getFmtInt();

		if (флаги & FLplus)
		    флаги &= ~FLspace;
		if (флаги & FLdash)
		    флаги &= ~FL0pad;

		// Get точность
		точность = 0;
		if (c == '.')
		{   флаги |= FLprecision;
		    //флаги &= ~FL0pad;

		    c = getFmtChar();
		    if (c == '*')
		    {
			точность = getFmtStar();
			if (точность < 0)
			{   точность = 0;
			    флаги &= ~FLprecision;
			}

			c = getFmtChar();
		    }
		    else if (c >= '0' && c <= '9')
			точность = getFmtInt();
		}

		if (j == arguments.length)
		    goto Lerror;
		ti = arguments[j++];
		ti = skipCI(ti);
		mi = 9;
		do
		{
		    m = cast(ПМангл)ti.classinfo.name[mi++];
		} while (m == ПМангл.Тконст || m == ПМангл.Тинвариант);

		if (c > 0x7F)		// if UTF sequence
		    goto Lerror;	// format specifiers can't be UTF
		formatArg(cast(сим)c);
	    }
	}
	else
	{
	    formatArg('s');
	}
    }
    return;

Lerror:
    throw new ФорматИскл();
}