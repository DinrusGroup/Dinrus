//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.data;

private import viz.common, viz.app;


export class ФорматыДанных // docmain
{
export:
	static class Формат // docmain
	{
	export:
		/// Данные format ID number.
		final цел id() // getter
		{
			return _id;
		}
		
		
		/// Данные format имя.
		final Ткст имя() // getter
		{
			return _name;
		}
		
		
		package:
		цел _id;
		Ткст _name;
		
		
		this()
		{
		}
	}
	
	
	static:
	
	/// Predefined данные formats.
	Ткст битмап() // getter
	{
		return дайФормат(CF_BITMAP).имя;
	}
	
	/+
	
	Ткст commaSeparatedValue() // getter
	{
		return дайФормат(?).имя;
	}
	+/
	
	
	Ткст dib() // getter
	{
		return дайФормат(CF_DIB).имя;
	}
	
	
	Ткст dif() // getter
	{
		return дайФормат(CF_DIF).имя;
	}
	
	
	Ткст enhandedMetaFile() // getter
	{
		return дайФормат(CF_ENHMETAFILE).имя;
	}
	
	
	Ткст fileDrop() // getter
	{
		return дайФормат(CF_HDROP).имя;
	}
	
	
	Ткст html() // getter
	{
		return дайФормат("HTML Формат").имя;
	}
	
	
	Ткст locale() // getter
	{
		return дайФормат(CF_LOCALE).имя;
	}
	
	
	Ткст metafilePict() // getter
	{
		return дайФормат(CF_METAFILEPICT).имя;
	}
	
	
	Ткст oemText() // getter
	{
		return дайФормат(CF_OEMTEXT).имя;
	}
	
	
	Ткст palette() // getter
	{
		return дайФормат(CF_PALETTE).имя;
	}
	
	
	Ткст penData() // getter
	{
		return дайФормат(CF_PENDATA).имя;
	}
	
	
	Ткст riff() // getter
	{
		return дайФормат(CF_RIFF).имя;
	}
	
	
	Ткст rtf() // getter
	{
		return дайФормат("Rich Text Format").имя;
	}
	
	
	/+
	
	Ткст serializable() // getter
	{
		return дайФормат(?).имя;
	}
	+/
	
	
	Ткст stringFormat() // getter
	{
		return utf8; // ?
	}
	
	
	Ткст utf8() // getter
	{
		return дайФормат("UTF-8").имя;
	}
	
	
	Ткст symbolicLink() // getter
	{
		return дайФормат(CF_SYLK).имя;
	}
	
	
	Ткст текст() // getter
	{
		return дайФормат(CF_TEXT).имя;
	}
	
	
	Ткст tiff() // getter
	{
		return дайФормат(CF_TIFF).имя;
	}
	
	
	Ткст текстЮникод() // getter
	{
		return дайФормат(CF_UNICODETEXT).имя;
	}
	
	
	Ткст waveAudio() // getter
	{
		return дайФормат(CF_WAVE).имя;
	}
	
	
	// Assumes _init() was already called and
	// -id- is not in -fmts-.
	private Формат _didntFindId(цел id)
	{
		Формат результат;
		результат = new Формат;
		результат._id = id;
		результат._name = дайИмя(id);
		//synchronized // _init() would need to be synchronized with it.
		{
			fmts[id] = результат;
		}
		return результат;
	}
	
	
		Формат дайФормат(цел id)
	{
		_init();
		
		if(id in fmts)
			return fmts[id];
		
		return _didntFindId(id);
	}
	
	
	// Creates the format имя if it doesn't exist.
	Формат дайФормат(Ткст имя)
	{
		_init();
		foreach(Формат onfmt; fmts)
		{
			if(!сравнлюб(имя, onfmt.имя))
				return onfmt;
		}
		// Didn't найди it.
		return _didntFindId(регистрируйФорматБуфОбмена(имя));
	}
	
	
	// Extra.
	Формат дайФормат(ИнфОТипе тип)
	{
		return дайФорматИзТипа(тип);
	}
	
	
	private:
	Формат[цел] fmts; // Indexed by identifier. Must _init() before accessing!
	
	
	проц _init()
	{
		if(fmts.length)
			return;
		
		
		проц иницфмт(цел id, Ткст имя)
		in
		{
			assert(!(id in fmts));
		}
		body
		{
			Формат фмт;
			фмт = new Формат;
			фмт._id = id;
			фмт._name = имя;
			fmts[id] = фмт;
		}
		
		
		иницфмт(CF_BITMAP, "Bitmap");
		иницфмт(CF_DIB, "DeviceIndependentBitmap");
		иницфмт(CF_DIF, "DataInterchangeFormat");
		иницфмт(CF_ENHMETAFILE, "EnhancedMetafile");
		иницфмт(CF_HDROP, "FileDrop");
		иницфмт(CF_LOCALE, "Locale");
		иницфмт(CF_METAFILEPICT, "MetaFilePict");
		иницфмт(CF_OEMTEXT, "OEMText");
		иницфмт(CF_PALETTE, "Palette");
		иницфмт(CF_PENDATA, "PenData");
		иницфмт(CF_RIFF, "RiffAudio");
		иницфмт(CF_SYLK, "SymbolicLink");
		иницфмт(CF_TEXT, "Text");
		иницфмт(CF_TIFF, "TaggedImageFileFormat");
		иницфмт(CF_UNICODETEXT, "UnicodeText");
		иницфмт(CF_WAVE, "WaveAudio");
		
		fmts.rehash;
	}
	
	
	// Does not get the имя of one of the predefined constant ones.
	Ткст дайИмя(цел id)
	{
		Ткст результат;
		результат = дайИмяФорматаБуфОбмена(id);
		if(!результат.length)
			throw new ВизИскл("Не удаётся получить формат");
		return результат;
	}
	
	
	package Формат дайФорматИзТипа(ИнфОТипе тип)
	{
		if(тип == typeid(ббайт[]))
			return дайФормат(текст);
		if(тип == typeid(Ткст))
			return дайФормат(stringFormat);
		if(тип == typeid(Шткст))
			return дайФормат(текстЮникод);
		//if(тип == typeid(Битмап))
		//	return дайФормат(битмап);
		
		if(cast(TypeInfo_Class)тип)
			throw new ВизИскл("Неизвестный формат данных");
		
		return дайФормат(дайТкстОбъекта(тип)); // ?
	}
		
	private Ткст[] getHDropStrings(проц[] значение)
	{
		/+
		if(значение.length != HDROP.sizeof)
			return пусто;
		
		HDROP hd;
		UINT num;
		Ткст[] результат;
		т_мера iw;
		
		hd = *cast(HDROP*)значение.ptr;
		num = dragQueryFile(hd);
		if(!num)
			return пусто;
		результат = new Ткст[num];
		for(iw = 0; iw != num; iw++)
		{
			результат[iw] = dragQueryFile(hd, iw);
		}
		return результат;
		+/
		
		if(значение.length <= DROPFILES.sizeof)
			return пусто;
		
		Ткст[] результат;
		DROPFILES* df;
		т_мера iw, стартiw;
		
		df = cast(DROPFILES*)значение.ptr;
		if(df.pFiles < DROPFILES.sizeof || df.pFiles >= значение.length)
			return пусто;
		
		if(df.fWide) // Unicode.
		{
			Шткст uni = cast(Шткст)((значение.ptr + df.pFiles)[0 .. значение.length]);
			for(iw = стартiw = 0;; iw++)
			{
				if(!uni[iw])
				{
					if(стартiw == iw)
						break;
					результат ~= изЮникода(uni.ptr + стартiw, iw - стартiw);
					assert(результат[результат.length - 1].length);
					стартiw = iw + 1;
				}
			}
		}
		else // ANSI.
		{
			Ткст ansi = cast(Ткст)((значение.ptr + df.pFiles)[0 .. значение.length]);
			for(iw = стартiw = 0;; iw++)
			{
				if(!ansi[iw])
				{
					if(стартiw == iw)
						break;
					результат ~= изАнзи(ansi.ptr + стартiw, iw - стартiw);
					assert(результат[результат.length - 1].length);
					стартiw = iw + 1;
				}
			}
		}
		
		return результат;
	}
	
	
	// Convert clipboard -значение- to Данные.
	Данные дайДанныеИзФормата(цел id, проц[] значение)
	{
		switch(id)
		{
			case CF_TEXT:
				return Данные(stopAtNull!(ббайт)(cast(ббайт[])значение));
			
			case CF_UNICODETEXT:
				return Данные(stopAtNull!(Шим)(cast(Шткст)значение));
			
			case CF_HDROP:
				return Данные(getHDropStrings(значение));
			
			default:
				if(id == дайФормат(stringFormat).id)
					return Данные(stopAtNull!(Сим)(cast(Ткст)значение));
		}
		
		//throw new ВизИскл("Unknown данные format");
		return Данные(значение); // ?
	}
	
	
	проц[] getCbFileDrop(Ткст[] фимена)
	{
		т_мера разм = DROPFILES.sizeof;
		ук p;
		DROPFILES* df;
		
		foreach(fn; фимена)
		{
			разм += (вДлинуЮникода(fn) + 1) << 1;
		}
		разм += 2;
		
		p = (new byte[разм]).ptr;
		df = cast(DROPFILES*)p;
		
		df.pFiles = DROPFILES.sizeof;
		df.fWide = TRUE;
		
		шткст0 ws = cast(шткст0)(p + DROPFILES.sizeof);
		foreach(fn; фимена)
		{
			foreach(wchar wch; fn)
			{
				*ws++ = wch;
			}
			*ws++ = 0;
		}
		*ws++ = 0;
		
		return p[0 .. разм];
	}
	
	
	// значение the clipboard wants.
	проц[] дайЗначениеБуфОбменаИзДанных(цел id, Данные данные)
	{
		//if(данные.инфо == typeid(ббайт[]))
		if(CF_TEXT == id)
		{
			// ANSI текст.
			const ббайт[] UBYTE_ZERO = [0];
			return данные.дайТекст() ~ UBYTE_ZERO;
		}
		//else if(данные.инфо == typeid(Ткст))
		//else if(дайФормат(stringFormat).id == id)
		else if((дайФормат(stringFormat).id == id) || (данные.инфо == typeid(Ткст)))
		{
			// UTF-8 string.
			Ткст str;
			str = данные.дайТкст();
			//return toStringz(str)[0 .. str.length + 1];
			//return небезопТкст0(str)[0 .. str.length + 1]; // ?
			return cast(проц[])небезопТкст0(str)[0 .. str.length + 1]; // ? Needed in D2.
		}
		//else if(данные.инфо == typeid(Шткст))
		//else if(CF_UNICODETEXT == id)
		else if((CF_UNICODETEXT == id) || (данные.инфо == typeid(Шткст)))
		{
			// Unicode string.
			//return данные.дайТекстВЮникоде() ~ cast(Шткст)\0;
			//return cast(проц[])(данные.дайТекстВЮникоде() ~ cast(Шткст)\0); // Needed in D2. Not guaranteed safe.
			return (данные.дайТекстВЮникоде() ~ cast(Шткст)\0).dup; // Needed in D2.
		}
		else if(данные.инфо == typeid(Дткст))
		{
			//return (*cast(Дткст*)данные.значение) ~ \0;
			//return cast(проц[])((*cast(Дткст*)данные.значение) ~ \0); // Needed in D2. Not guaranteed safe.
			return ((*cast(Дткст*)данные.значение) ~ \0).dup; // Needed in D2.
		}
		else if(CF_HDROP == id)
		{
			return getCbFileDrop(данные.дайТксты());
		}
		else if(данные.инфо == typeid(проц[]) || данные.инфо == typeid(Ткст)
			|| данные.инфо == typeid(ббайт[]) || данные.инфо == typeid(byte[])) // Hack ?
		{
			return *cast(проц[]*)данные.значение; // Save the массив elements, not the reference.
		}
		else
		{
			return данные.значение; // ?
		}
	}
	
	
	this()
	{
	}
}


private template stopAtNull(T)
{
	T[] stopAtNull(T[] массив)
	{
		цел i;
		for(i = 0; i != массив.length; i++)
		{
			if(!массив[i])
				return массив[0 .. i];
		}
		//return пусто;
		throw new ВизИскл("Повреждённые данные"); // ?
	}
}


/// Данные structure for holding данные in а raw format with тип информация.
export struct Данные // docmain
{
export:
	/// Information about the данные тип.
	ИнфОТипе инфо() // getter
	{
		return _info;
	}
	
	
	/// The данные's raw значение.
	проц[] значение() // getter
	{
		return _value[0 .. _info.tsize()];
	}
	
	
	/// Construct а new Данные structure.
	static Данные opCall(...)
	in
	{
		assert(_arguments.length == 1);
	}
	body
	{
		Данные результат;
		результат._info = _arguments[0];
		результат._value = _argptr[0 .. результат._info.tsize()].dup.ptr;
		return результат;
	}
	
	
		T дайЗначение(T)()
	{
		assert(_info.tsize == T.sizeof);
		return *cast(T*)_value;
	}
	
	
	// UTF-8.
	Ткст дайТкст()
	{
		assert(_info == typeid(Ткст) || _info == typeid(проц[]));
		return *cast(Ткст*)_value;
	}
	
	
	alias дайТкст дайЮ8;
	
	
	// ANSI текст.
	ббайт[] дайТекст()
	{
		assert(_info == typeid(ббайт[]) || _info == typeid(byte[]) || _info == typeid(проц[]));
		return *cast(ббайт[]*)_value;
	}
	
	
	Шткст дайТекстВЮникоде()
	{
		assert(_info == typeid(Шткст) || _info == typeid(проц[]));
		return *cast(Шткст*)_value;
	}
	
	
	цел дайЦел()
	{
		return дайЗначение!(цел)();
	}
	
	
	цел дайБцел()
	{
		return дайЗначение!(бцел)();
	}
	
	
	Ткст[] дайТксты()
	{
		assert(_info == typeid(Ткст[]));
		return *cast(Ткст[]*)_value;
	}
	
	
	Объект дайОбъект()
	{
		assert(!(cast(TypeInfo_Class)_info is пусто));
		return cast(Объект)*cast(Объект**)_value;
	}
	
	
	private:
	ИнфОТипе _info;
	ук _value;
}


/+
interface IDataFormat
{
	
}
+/


export class ОбъектДанных: ИОбъектДанных // docmain
{
export:
		Данные получитьДанные(Ткст фмт)
	{
		return получитьДанные(фмт, да);
	}
	
	
	Данные получитьДанные(ИнфОТипе тип)
	{
		return получитьДанные(ФорматыДанных.дайФормат(тип).имя);
	}
	
	
	Данные получитьДанные(Ткст фмт, бул doConvert)
	{
		// doConvert ...
		
		//скажиф("Looking for format '%.*s'.\n", фмт);
		цел i;
		i = найди(фмт);
		if(i == -1)
			throw new ВизИскл("Формат данных отсутствует");
		return все[i].объ;
	}
	
	
		бул дайИмеющиесяДанные(Ткст фмт)
	{
		return дайИмеющиесяДанные(фмт, да);
	}
	
	
	бул дайИмеющиесяДанные(ИнфОТипе тип)
	{
		return дайИмеющиесяДанные(ФорматыДанных.дайФормат(тип).имя);
	}
	
	
	бул дайИмеющиесяДанные(Ткст фмт, бул можноПреобразовать)
	{
		// можноПреобразовать ...
		return найди(фмт) != -1;
	}
	
	
		Ткст[] дайФорматы()
	{
		Ткст[] результат;
		результат = new Ткст[все.length];
		foreach(цел i, inout Ткст фмт; результат)
		{
			фмт = все[i].фмт;
		}
		return результат;
	}
	
	
	// TO-DO: удали...
	deprecated final Ткст[] дайФорматы(бул onlyNative)
	{
		return дайФорматы();
	}
	
	
	package final проц _setData(Ткст фмт, Данные объ, бул replace = да)
	{
		цел i;
		i = найди(фмт, нет);
		if(i != -1)
		{
			if(replace)
				все[i].объ = объ;
		}
		else
		{
			Пара pair;
			pair.фмт = фмт;
			pair.объ = объ;
			все ~= pair;
		}
	}
	
	
	проц установиДанные(Данные объ)
	{
		установиДанные(ФорматыДанных.дайФормат(объ.инфо).имя, объ);
	}	
	
	проц установиДанные(Ткст фмт, Данные объ)
	{
		установиДанные(фмт, да, объ);
	}	
	
	проц установиДанные(ИнфОТипе тип, Данные объ)
	{
		установиДанные(ФорматыДанных.дайФорматИзТипа(тип).имя, да, объ);
	}	
	
	проц установиДанные(Ткст фмт, бул можноПреобразовать, Данные объ)
	{
		/+
		if(объ.инфо == typeid(Данные))
		{
			проц[] objv;
			objv = объ.значение;
			assert(objv.length == Данные.sizeof);
			объ = *(cast(Данные*)objv.ptr);
		}
		+/
		
		_setData(фмт, объ);
		if(можноПреобразовать)
		{
			Данные cdat;
			cdat = Данные(*(cast(_DataConvert*)&объ));
			_canConvertFormats(фмт,
				(Ткст cfmt)
				{
					_setData(cfmt, cdat, нет);
				});
		}
	}
	
	
	private:
	struct Пара
	{
		Ткст фмт;
		Данные объ;
	}
	
	
	Пара[] все;
	
	
	проц исправьЗаписьПары(inout Пара pr)
	{
		assert(pr.объ.инфо == typeid(_DataConvert));
		Данные объ;
		проц[] objv;
		objv = pr.объ.значение;
		assert(objv.length == Данные.sizeof);
		объ = *(cast(Данные*)objv.ptr);
		pr.объ = _doConvertFormat(объ, pr.фмт);
	}
	
	
	цел найди(Ткст фмт, бул fix = да)
	{
		цел i;
		for(i = 0; i != все.length; i++)
		{
			if(!сравнлюб(все[i].фмт, фмт))
			{
				if(fix && все[i].объ.инфо == typeid(_DataConvert))
					исправьЗаписьПары(все[i]);
				return i;
			}
		}
		return -1;
	}
}


private struct _DataConvert
{
	Данные данные;
}


package проц _canConvertFormats(Ткст фмт, проц delegate(Ткст cfmt) обрвыз)
{
	//if(!сравнлюб(фмт, ФорматыДанных.utf8))
	if(!сравнлюб(фмт, "UTF-8"))
	{
		обрвыз(ФорматыДанных.текстЮникод);
		обрвыз(ФорматыДанных.текст);
	}
	else if(!сравнлюб(фмт, ФорматыДанных.текстЮникод))
	{
		//обрвыз(ФорматыДанных.utf8);
		обрвыз("UTF-8");
		обрвыз(ФорматыДанных.текст);
	}
	else if(!сравнлюб(фмт, ФорматыДанных.текст))
	{
		//обрвыз(ФорматыДанных.utf8);
		обрвыз("UTF-8");
		обрвыз(ФорматыДанных.текстЮникод);
	}
}


package Данные _doConvertFormat(Данные dat, Ткст toFmt)
{
	Данные результат;
	//if(!сравнлюб(toFmt, ФорматыДанных.utf8))
	if(!сравнлюб(toFmt, "UTF-8"))
	{
		if(typeid(Шткст) == dat.инфо)
		{
			результат = Данные(вЮ8(dat.дайТекстВЮникоде()));
		}
		else if(typeid(ббайт[]) == dat.инфо)
		{
			ббайт[] ubs;
			ubs = dat.дайТекст();
			результат = Данные(изАнзи(cast(Ткст0)ubs.ptr, ubs.length));
		}
	}
	else if(!сравнлюб(toFmt, ФорматыДанных.текстЮникод))
	{
		if(typeid(Ткст) == dat.инфо)
		{
			результат = Данные(вЮ16(dat.дайТкст()));
		}
		else if(typeid(ббайт[]) == dat.инфо)
		{
			ббайт[] ubs;
			ubs = dat.дайТекст();
			результат = Данные(анзиВЮникод(cast(Ткст0)ubs.ptr, ubs.length));
		}
	}
	else if(!сравнлюб(toFmt, ФорматыДанных.текст))
	{
		if(typeid(Ткст) == dat.инфо)
		{
			результат = Данные(cast(ббайт[])вАнзи(dat.дайТкст()));
		}
		else if(typeid(Шткст) == dat.инфо)
		{
			Шткст wcs;
			wcs = dat.дайТекстВЮникоде();
			результат = Данные(cast(ббайт[])юникодВАнзи(wcs.ptr, wcs.length));
		}
	}
	return результат;
}


export class КомВОбъектДанных: ИОбъектДанных // package
{
export:
	this(winapi.IDataObject объДанных)
	{
		this.объДанных = объДанных;
		объДанных.AddRef();
	}
	
	
	~this()
	{
		объДанных.Release(); // Must get called...
	}
	
	
	private Данные _getData(цел id)
	{
		FORMATETC fmte;
		STGMEDIUM stgm;
		проц[] mem;
		ук plock;
		
		fmte.cfFormat = id;
		fmte.ptd = пусто;
		fmte.dwAspect = DVASPECT_CONTENT; // ?
		fmte.lindex = -1;
		fmte.tymed = TYMED_HGLOBAL; // ?
		
		if(S_OK != объДанных.GetData(&fmte, &stgm))
			throw new ВизИскл("Не удаётся получить данные");
		
		
		проц release()
		{
			//ReleaseStgMedium(&stgm);
			if(stgm.pUnkForRelease)
				stgm.pUnkForRelease.Release();
			else
				GlobalFree(stgm.hGlobal);
		}
		
		
		plock = GlobalLock(stgm.hGlobal);
		if(!plock)
		{
			release();
			throw new ВизИскл("Ошибка при получении данных");
		}
		
		mem = new ббайт[GlobalSize(stgm.hGlobal)];
		mem[] = plock[0 .. mem.length];
		GlobalUnlock(stgm.hGlobal);
		release();
		
		return ФорматыДанных.дайДанныеИзФормата(id, mem);
	}
	
	
	Данные получитьДанные(Ткст фмт)
	{
		return _getData(ФорматыДанных.дайФормат(фмт).id);
	}
	
	
	Данные получитьДанные(ИнфОТипе тип)
	{
		return _getData(ФорматыДанных.дайФорматИзТипа(тип).id);
	}
	
	
	Данные получитьДанные(Ткст фмт, бул doConvert)
	{
		return получитьДанные(фмт); // ?
	}
	
	
	private бул _getDataPresent(цел id)
	{
		FORMATETC fmte;
		
		fmte.cfFormat = id;
		fmte.ptd = пусто;
		fmte.dwAspect = DVASPECT_CONTENT; // ?
		fmte.lindex = -1;
		fmte.tymed = TYMED_HGLOBAL; // ?
		
		return S_OK == объДанных.QueryGetData(&fmte);
	}
	
	
	бул дайИмеющиесяДанные(Ткст фмт)
	{
		return _getDataPresent(ФорматыДанных.дайФормат(фмт).id);
	}
	
	
	бул дайИмеющиесяДанные(ИнфОТипе тип)
	{
		return _getDataPresent(ФорматыДанных.дайФорматИзТипа(тип).id);
	}
	
	
	бул дайИмеющиесяДанные(Ткст фмт, бул можноПреобразовать)
	{
		return дайИмеющиесяДанные(фмт); // ?
	}
		
	Ткст[] дайФорматы()
	{
		winapi.IEnumFORMATETC fenum;
		FORMATETC fmte;
		Ткст[] результат;
		ULONG nfetched = 1; // ?
		
		if(S_OK != объДанных.EnumFormatEtc(1, &fenum))
			throw new ВизИскл("Не удаётся получить форматы");
		
		fenum.AddRef(); // ?
		for(;;)
		{
			if(S_OK != fenum.Next(1, &fmte, &nfetched))
				break;
			if(!nfetched)
				break;
			//скажиф("\t\t{дайФорматы:%d}\n", fmte.cfFormat);
			результат ~= ФорматыДанных.дайФормат(fmte.cfFormat).имя;
		}
		fenum.Release(); // ?
		
		return результат;
	}
	
	
	// TO-DO: удали...
	deprecated final Ткст[] дайФорматы(бул onlyNative)
	{
		return дайФорматы();
	}
	
	
	private проц _setData(цел id, Данные объ)
	{
		/+
		FORMATETC fmte;
		STGMEDIUM stgm;
		HANDLE hmem;
		проц[] mem;
		ук pmem;
		
		mem = ФорматыДанных.дайЗначениеБуфОбменаИзДанных(id, объ);
		
		hmem = GlobalAlloc(GMEM_SHARE, mem.length);
		if(!hmem)
		{
			//скажиф("Unable to GlobalAlloc().\n");
			err_set:
			throw new ВизИскл("Unable to установи данные");
		}
		pmem = GlobalLock(hmem);
		if(!pmem)
		{
			//скажиф("Unable to GlobalLock().\n");
			GlobalFree(hmem);
			goto err_set;
		}
		pmem[0 .. mem.length] = mem;
		GlobalUnlock(hmem);
		
		fmte.cfFormat = id;
		fmte.ptd = пусто;
		fmte.dwAspect = DVASPECT_CONTENT; // ?
		fmte.lindex = -1;
		fmte.tymed = TYMED_HGLOBAL;
		
		stgm.tymed = TYMED_HGLOBAL;
		stgm.hGlobal = hmem;
		stgm.pUnkForRelease = пусто;
		
		// -объДанных- now owns the указатель.
		HRESULT hr = объДанных.SetData(&fmte, &stgm, да);
		if(S_OK != hr)
		{
			//скажиф("Unable to ИОбъектДанных::SetData() = %d (0x%X).\n", hr, hr);
			// Failed, need to free it..
			GlobalFree(hmem);
			goto err_set;
		}
		+/
		// Don't установи stuff in someone else's данные object.
	}
	
	
	проц установиДанные(Данные объ)
	{
		_setData(ФорматыДанных.дайФорматИзТипа(объ.инфо).id, объ);
	}
	
	
	проц установиДанные(Ткст фмт, Данные объ)
	{
		_setData(ФорматыДанных.дайФормат(фмт).id, объ);
	}
	
	
	проц установиДанные(ИнфОТипе тип, Данные объ)
	{
		_setData(ФорматыДанных.дайФорматИзТипа(тип).id, объ);
	}
	
	
	проц установиДанные(Ткст фмт, бул можноПреобразовать, Данные объ)
	{
		установиДанные(фмт, объ); // ?
	}
	
	
	final бул такойЖеОбъектДанных_ли(winapi.IDataObject объДанных)
	{
		return объДанных is this.объДанных;
	}
	
	
	private:
	winapi.IDataObject объДанных;
}


package class EnumDataObjectFORMATETC: ВизКомОбъект, winapi.IEnumFORMATETC
{
	this(ИОбъектДанных объДанных, Ткст[] fmts, ULONG старт)
	{
		this.объДанных = объДанных;
		this.fmts = fmts;
		idx = старт;
	}
	
	
	this(ИОбъектДанных объДанных)
	{
		this(объДанных, объДанных.дайФорматы(), 0);
	}
	
	
	extern(Windows):
	override HRESULT QueryInterface(IID* riid, проц** ppv)
	{
		if(*riid == cast(IID)IID_IEnumFORMATETC)
		{
			*ppv = cast(проц*)cast(winapi.IEnumFORMATETC)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == cast(IID) IID_IUnknown)
		{
			*ppv = cast(проц*)cast(winapi.IUnknown)this;
			AddRef();
			return S_OK;
		}
		else
		{
			*ppv = пусто;
			return E_NOINTERFACE;
		}
	}
	
	
	HRESULT Next(ULONG celt, FORMATETC* rgelt, ULONG* pceltFetched)
	{
		HRESULT результат;
		
		try
		{
			if(idx < fmts.length)
			{
				ULONG end;
				end = idx + celt;
				if(end > fmts.length)
				{
					результат = S_FALSE; // ?
					end = fmts.length;
					
					if(pceltFetched)
						*pceltFetched = end - idx;
				}
				else
				{
					результат = S_OK;
					
					if(pceltFetched)
						*pceltFetched = celt;
				}
				
				for(; idx != end; idx++)
				{
					rgelt.cfFormat = ФорматыДанных.дайФормат(fmts[idx]).id;
					rgelt.ptd = пусто;
					rgelt.dwAspect = DVASPECT_CONTENT; // ?
					rgelt.lindex = -1;
					//rgelt.tymed = TYMED_NULL;
					rgelt.tymed = TYMED_HGLOBAL;
					
					rgelt++;
				}
			}
			else
			{
				if(pceltFetched)
					*pceltFetched = 0;
				результат = S_FALSE;
			}
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_UNEXPECTED;
		}
		
		return результат;
	}
	
	
	HRESULT Skip(ULONG celt)
	{
		idx += celt;
		return (idx > fmts.length) ? S_FALSE : S_OK;
	}
	
	
	HRESULT Reset()
	{
		HRESULT результат;
		
		try
		{
			idx = 0;
			fmts = объДанных.дайФорматы();
			
			результат = S_OK;
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_UNEXPECTED;
		}
		
		return результат;
	}
	
	
	HRESULT Clone(winapi.IEnumFORMATETC* ppenum)
	{
		HRESULT результат;
		
		try
		{
			*ppenum = new EnumDataObjectFORMATETC(объДанных, fmts, idx);
			результат = S_OK;
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_UNEXPECTED;
		}
		
		return результат;
	}
	
	
	extern(D):
	
	private:
	ИОбъектДанных объДанных;
	Ткст[] fmts;
	ULONG idx;
}


export class DtoComDataObject: ВизКомОбъект, winapi.IDataObject // package
{


	private:
	ИОбъектДанных объДанных;
	
export:
	this(ИОбъектДанных объДанных)
	{
		this.объДанных = объДанных;
	}
	
	
	export extern(Windows):
	
	override HRESULT QueryInterface(IID* riid, проц** ppv)
	{
		if(*riid == cast(IID) IID_IDataObject)
		{
			*ppv = cast(проц*)cast(winapi.IDataObject)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == cast(IID) IID_IUnknown)
		{
			*ppv = cast(проц*)cast(winapi.IUnknown)this;
			AddRef();
			return S_OK;
		}
		else
		{
			*ppv = пусто;
			return E_NOINTERFACE;
		}
	}
	
	
	HRESULT GetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium)
	{
		Ткст фмт;
		HRESULT результат = S_OK;
		Данные данные;
		
		try
		{
			if(pFormatetc.lindex != -1)
			{
				результат = DV_E_LINDEX;
			}
			else if(!(pFormatetc.tymed & TYMED_HGLOBAL))
			{
				// Unsupported medium тип.
				результат = DV_E_TYMED;
			}
			else if(!(pFormatetc.dwAspect & DVASPECT_CONTENT))
			{
				// What about the other aspects?
				результат = DV_E_DVASPECT;
			}
			else
			{
				ФорматыДанных.Формат dfmt;
				dfmt = ФорматыДанных.дайФормат(pFormatetc.cfFormat);
				фмт = dfmt.имя;
				данные = объДанных.получитьДанные(фмт, да); // Should this be convertable?
				
				HGLOBAL hg;
				ук pmem;
				проц[] src;
				
				//src = данные.значение;
				src = ФорматыДанных.дайЗначениеБуфОбменаИзДанных(dfmt.id, данные);
				hg = GlobalAlloc(GMEM_SHARE, src.length);
				if(!hg)
				{
					результат = STG_E_MEDIUMFULL;
				}
				else
				{
					pmem = GlobalLock(hg);
					if(!hg)
					{
						результат = E_UNEXPECTED;
						GlobalFree(hg);
					}
					else
					{
						pmem[0 .. src.length] = src;
						GlobalUnlock(hg);
						
						pmedium.tymed = TYMED_HGLOBAL;
						pmedium.hGlobal = hg;
						pmedium.pUnkForRelease = пусто; // ?
					}
				}
			}
		}
		catch(ВизИскл e)
		{
			//Приложение.приИсклНити(e);
			
			результат = DV_E_FORMATETC;
		}
		catch(ВнеПамИскл e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_OUTOFMEMORY;
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_UNEXPECTED;
		}
		
		return результат;
	}
	
	
	HRESULT GetDataHere(FORMATETC* pFormatetc, STGMEDIUM* pmedium)
	{
		return E_UNEXPECTED; // TODO: finish.
	}
	
	
	HRESULT QueryGetData(FORMATETC* pFormatetc)
	{
		Ткст фмт;
		HRESULT результат = S_OK;
		
		try
		{
			if(pFormatetc.lindex != -1)
			{
				результат = DV_E_LINDEX;
			}
			else if(!(pFormatetc.tymed & TYMED_HGLOBAL))
			{
				// Unsupported medium тип.
				результат = DV_E_TYMED;
			}
			else if(!(pFormatetc.dwAspect & DVASPECT_CONTENT))
			{
				// What about the other aspects?
				результат = DV_E_DVASPECT;
			}
			else
			{
				фмт = ФорматыДанных.дайФормат(pFormatetc.cfFormat).имя;
				
				if(!объДанных.дайИмеющиесяДанные(фмт))
					результат = S_FALSE; // ?
			}
		}
		catch(ВизИскл e)
		{
			//Приложение.приИсклНити(e);
			
			результат = DV_E_FORMATETC;
		}
		catch(ВнеПамИскл e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_OUTOFMEMORY;
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_UNEXPECTED;
		}
		
		return результат;
	}
	
	
	HRESULT GetCanonicalFormatEtc(FORMATETC* pFormatetcIn, FORMATETC* pFormatetcOut)
	{
		// TODO: finish.
		
		pFormatetcOut.ptd = пусто;
		return E_NOTIMPL;
	}
	
	
	HRESULT SetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium, BOOL fRelease)
	{
		return E_UNEXPECTED; // TODO: finish.
	}
	
	
	HRESULT EnumFormatEtc(DWORD dwDirection, winapi.IEnumFORMATETC* ppenumFormatetc)
	{
		// SHCreateStdEnumFmtEtc() requires Windows 2000 +
		
		HRESULT результат;
		
		try
		{
			if(dwDirection == DATADIR_GET)
			{
				*ppenumFormatetc = new EnumDataObjectFORMATETC(объДанных);
				результат = S_OK;
			}
			else
			{
				результат = E_NOTIMPL;
			}
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
			
			результат = E_UNEXPECTED;
		}
		
		return результат;
	}
	
	
	HRESULT DAdvise(FORMATETC* pFormatetc, DWORD advf, winapi.IAdviseSink pAdvSink, DWORD* pdwConnection)
	{
		return E_UNEXPECTED; // TODO: finish.
	}
	
	
	HRESULT DUnadvise(DWORD dwConnection)
	{
		return E_UNEXPECTED; // TODO: finish.
	}
	
	
	HRESULT EnumDAdvise(winapi.IEnumSTATDATA* ppenumAdvise)
	{
		return E_UNEXPECTED; // TODO: finish.
	}
	
	

}

