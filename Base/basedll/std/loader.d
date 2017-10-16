
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

module std.loader;
	import  cidrus,win, std.io, std.process, std.string, std.file;

    export extern(D)
    {

	цел иницМодуль(){return std.loader.ExeModule_Init();}
	проц деиницМодуль(){return std.loader.ExeModule_Uninit();}
	ук загрузиМодуль(in ткст имямод){return cast(ук) адаптВыхУкз(std.loader.ExeModule_Load(имямод));}
	ук добавьСсылНаМодуль(ук умодуль){return cast(ук) std.loader.ExeModule_AddRef(cast(HXModule) умодуль);}
	проц отпустиМодуль(inout ук умодуль){return std.loader.ExeModule_Release(cast(HXModule) умодуль);}
	ук дайСимволИМодуля(inout ук умодуль, in ткст имяСимвола){return std.loader.ExeModule_GetSymbol(cast(HXModule) умодуль, имяСимвола);}
	ткст ошибкаИМодуля(){return std.loader.ExeModule_Error();}

}

	//Загрузчик от Derelict'а	........................................

char* toCString(char[] str)
{
    return std.string.toStringz(str);
}

char[] toDString(char* cstr)
{
        return std.string.toString(cstr);
}

int findStr(char[] str, char[] match)
{
        return std.string.find(str, match);
}

char[][] splitStr(char[] str, char[] delim)
{
    return std.string.split(str, delim);
}

char[] stripWhiteSpace(char[] str)
{
        return std.string.strip(str);
}


class ИсключениеЗагрузкиБиблиотеки
{

    ткст м_назвСовмБиб;

  static проц выведи(in ткст[] назвыБиб, in ткст[] причины)
    {
        ткст сооб = "Не удалось загрузить одну (или более) ДЛЛ:";
        foreach(i, n; назвыБиб)
        {
            сооб ~= "\n\t" ~ n ~ " - ";
            if(i < причины.length)
                сооб ~= причины[i];
            else
                сооб ~= "Неизвестно";
        }
        throw new Исключение(сооб);
    }

    this(ткст сооб)
    {
	м_назвСовмБиб = "";
        throw new Исключение(сооб,__FILE__, __LINE__);

    }

    this(ткст сооб, ткст назвСовмБиб)
    {
	м_назвСовмБиб = назвСовмБиб;
        throw new Исключение(сооб,__FILE__, __LINE__);

    }

    ткст имяБиб()
    {
        return м_назвСовмБиб;
    }


}

class ИсключениеНеверногоУкНаБиб
{
public:

    this(ткст назвСовмБиб)
    {
        throw new Исключение("Попытка применить указатель на незагруженную ДЛЛ " ~ назвСовмБиб,__FILE__, __LINE__);
        м_назвСовмБиб = назвСовмБиб;
    }

    ткст имяБиб()
    {
        return м_назвСовмБиб;
    }

private:
    ткст м_назвСовмБиб;
}

export ткст дайТкстОшибки()
    {
        // adapted from Tango

        бцел ошкод = ДайПоследнююОшибку();

        ткст буфСооб;
        бцел i = ФорматируйСообА(
            ПФорматСооб.РазмБуф | ПФорматСооб.ИзСист | ПФорматСооб.ИгнорВставки,
            null,
            ошкод,
            СДЕЛАЙИДЪЯЗ(ПЯзык.НЕЙТРАЛЬНЫЙ, ППодъяз.ДЕФОЛТ),
            буфСооб,
            0,
            null);

        ткст text = буфСооб;
        ОсвободиЛок(cast(лук) буфСооб);

        if(i >= 2)
            i -= 2;
        return text[0 .. i];
    }

export extern(D)
 class Биб
{
private{
    ук _укз;
    ткст _имя;
	}
export:
    ткст имя()
    {
        return _имя;
    }

  this(ук укз, ткст имя)
    {
        _укз = адаптВхоУкз(укз);
        _имя = имя;
    }
}

export extern(D)
 Биб загрузиБиб(ткст имяб)
in
{
    assert(имяб !is null);
}
body
{
    ук хэндл = ЗагрузиБиблиотекуА(имяб);
    if(хэндл is null)
        throw new Исключение("Не удалось загрузить библиотеку " ~ имяб ~ ": " ~ дайТкстОшибки(),__FILE__, __LINE__);
    return new Биб(хэндл, имяб);
}

export extern(D)
 Биб загрузиБиб(ткст[] именаб)
in
{
   try	{
   assert(именаб !is null);
   }
   catch(Исключение пи){std.io.инфо("Не заданы имена для загрузки в функции загрузиБиб"); выход(0);}
}
body
{
    char[][] незагрБибы;
    char[][] причины;

    foreach(ткст имяб; именаб)
    {
        ук хэндл = ЗагрузиБиблиотекуА(имяб);
        if(хэндл !is null)
        {
            return new Биб(хэндл, имяб);
        }
        else
        {
            незагрБибы ~= имяб;
            причины ~= дайТкстОшибки();
        }

    }
    ИсключениеЗагрузкиБиблиотеки.выведи(незагрБибы, причины);
    return null; // to shut the compiler up
}

export extern(D)
 проц выгрузиБиб(Биб биб)
{
    if(биб !is null && биб._укз !is null)
        ОсвободиБиблиотеку(биб._укз);
        биб._укз = null;
}

export extern(D)
 ук дайПроцИзБиб(Биб биб, ткст имяПроц)
in
{
    assert(биб !is null);
    assert(имяПроц !is null);
}
body
{
    if(биб._укз is null)
        new ИсключениеНеверногоУкНаБиб(биб._имя);
		ук proc = ДайАдресПроц(биб._укз, имяПроц);
        if(null is proc)
            ОбработайНедостачуПроц(биб._имя, имяПроц);

        return proc;
}

alias бул function(ткст имяБиб, ткст имяПроц) ОбрвызНедостСимвола;
alias ОбрвызНедостСимвола ОбрвызНедостПроц;

private ОбрвызНедостСимвола обрвызНедостПроц;

проц ОбработайНедостачуПроц(ткст имяБиб, ткст имяСимвола)
{
    бул результат = нет;
    if(обрвызНедостПроц !is null)
        результат = обрвызНедостПроц(имяБиб, имяСимвола);
    if(!результат)
        new ИсключениеЗагрузкиБиблиотеки(имяБиб, имяСимвола);
}

export extern(D)
 struct ЖанБибгр {
export:

   проц заряжай(ткст винБибы, проц function(Биб) пользовательскийЗагр, ткст текстВерсии = "") {
        assert (пользовательскийЗагр !is null);
        this.винБибы = винБибы;
        this.пользовательскийЗагр = пользовательскийЗагр;
        this.текстВерсии = текстВерсии;
    }

    проц загружай(ткст текстНазвБиб = null)
    {
        if (мояБиб !is null) return;
        зарегестрированныеЗагрузчики ~= this;
        if (текстНазвБиб is null) текстНазвБиб = винБибы;

            if(текстНазвБиб is null || текстНазвБиб == "")
            {
                throw new Исключение("std.loader.ЖанБибгр.загружай: Название несуществующей библиотеки!");
            }

        ткст[] назвыБиб = текстНазвБиб.splitStr(",");
        foreach (б; назвыБиб)
			{
				б = б.stripWhiteSpace();
			}

        загружай(назвыБиб);
    }

    проц загружай(ткст[] назвыБиб)
    {
        мояБиб = загрузиБиб(назвыБиб);

        if(пользовательскийЗагр is null)
        {
            // this should never, ever, happen
            throw new Исключение("std.loader.ЖанБибгр.загружай: Кошмар! Внутренняя функция загрузки сконфигурирована с ошибками...",__FILE__, __LINE__);
        }

        пользовательскийЗагр(мояБиб);

    }

    ткст строкаВерсии()
    {
        return текстВерсии;
    }

    проц выгружай()
    {
        if (мояБиб !is null) {
            выгрузиБиб(мояБиб);
            мояБиб = null;
        }
    }

    бул загружено()
    {
        return (мояБиб !is null);
    }

    ткст имяБиб()
    {
        return загружено ? мояБиб.имя : null;
    }

    static ~this()
    {
        foreach (x; зарегестрированныеЗагрузчики) {
            x.выгружай();
        }
    }

    private {
        static ЖанБибгр*[] зарегестрированныеЗагрузчики;

        Биб мояБиб;
        ткст винБибы;
        ткст текстВерсии = "";

        проц function(Биб) пользовательскийЗагр;
    }
}

export extern(D)
 struct ЗавЖанБибгр {
export:

    проц заряжай(ЖанБибгр* dependence,  проц function(Биб) пользовательскийЗагр) {
        assert (dependence !is null);
        assert (пользовательскийЗагр !is null);

        this.dependence = dependence;
        this.пользовательскийЗагр = пользовательскийЗагр;
    }

    проц загружай()
    {
        assert (dependence.загружено);
        пользовательскийЗагр(dependence.мояБиб);
    }

    ткст строкаВерсии()
    {
        return dependence.строкаВерсии;
    }

    проц выгружай()
    {
    }

    бул загружено()
    {
        return dependence.загружено;
    }

    ткст имяБиб()
    {
        return dependence.имяБиб;
    }

    private {
        ЖанБибгр*              dependence;
        проц function(Биб)    пользовательскийЗагр;
    }
}

struct Вяз(T) {
    проц opCall(ткст n, Биб lib) {
        *fptr = дайПроцИзБиб(lib, n);
    }
        ук* fptr;
}


template вяжи(T) {
    Вяз!(T) вяжи(inout T a) {
        Вяз!(T) рез;
        рез.fptr = cast(ук*)&a;
        return рез;
    }
}

export extern(D)
 бул создайБибИзДлл(ткст имяБ, ткст имяД = null, ткст путь = null, ткст расшД = "dll")
{

if(имяД == null) имяД = имяБ;
сис(std.string.фм("implib/system %s.lib %s%s.%s", имяБ, путь, имяД, расшД));
return да;
}

export extern(D)
 бул создайЛистинг(ткст имяБ)
{
сис(std.string.фм("d:\\dinrus\\bin\\lib -l %s.lib", имяБ));
if(естьФайл(имяБ~".lst"))удалиФайл(имяБ~".lib");
	else throw new Исключение("Неудачная генерация листинга",имяБ, __LINE__);
return  да;
}

export extern(D)
 цел генМакетИмпорта(ткст имяМ, ткст[] список)
{
	СИСТВРЕМЯ систВремя;
	цел счёт = 1;

	ДайМестнВремя(&систВремя);
	ткст дата = std.string.вТкст(систВремя.день)~"."~std.string.вТкст(систВремя.месяц)~"."~std.string.вТкст(систВремя.год);
	ткст время = std.string.вТкст(систВремя.час)~" ч. "~std.string.вТкст(систВремя.минута)~" мин.";

	ткст заг = std.string.фм("
	/*******************************************************************************
	*  Файл генерирован автоматически с помощью либпроцессора Динрус               *
	*  Дата:%s                                           Время: %s\n
	*******************************************************************************/

", дата, время);

	ткст имп = std.string.фм("
	module lib.%s;

	import std.loader;

	проц грузи(Биб биб)
	{

	", имяМ);

	ткст связка(ткст[] список)
	{
	ткст вяз;

		foreach(выр; список)
			{
			auto рез = убери(выр);
			вяз ~= std.string.фм("
		//вяжи(функция_%s)(%s биб);\r\n", счёт, рез);
			счёт++;
			}
		return вяз;
	}

	ткст вяз = связка(список);

	ткст имя = std.string.взаг(имяМ);

	ткст закр ="
	}\r\n\r\n";


	ткст жб = std.string.фм("ЖанБибгр %s;\r\n", имя);

	ткст гр = std.string.фм("
		static this()
		{
			%s.заряжай(\"%s.dll\", &грузи );
		}\r\n",имя, имяМ);

	ткст гн = "
	extern(C)
	{\r\n\r\n";

	ткст функ()
	{
	ткст ф;
		for(цел ц = 1; ц < счёт; ц++ )
		{
		  ф ~= std.string.фм("
		//проц function() функция_%s; \r\n", ц);
		}
		return  ф;
	}

	ткст ф = функ();

	ткст итог = заг~имп~вяз~закр~жб~гр~гн~ф~закр;

	пишиФайл(имяМ~".d", итог);
	инфо(std.string.фм("Сгенерирован макет импорта динамической библиотеки %s,
			результирующий текст которого был записан в файл %s",std.string.взаг(имяМ), имяМ~".d"));
	return 0;
}

ткст удалитьДубликатыИзТМас(ткст текст)
{
    ткст строка_итог;
    ткст[] список;
	список = разбейнастр(текст);
	цел и;
	int[ткст] предшстр;
	ткст следщстр = "";
	цел проходка = 0;
	цел взято = -1;
	бул взят = нет;

	for( ; и < список.length ; )
	{
	//if(auto т = _сравни(строка, предшстр) == 0) delete список[и]; предшстр = "";

		foreach(строка; список)
		{
			while(проходка == 0){ goto старт;}


		if(строка in предшстр) {delete строка; //_скажинс("удалена предшествующая");
		}

		старт:

			if(строка == следщстр || строка != пусто)
			{
				while(!взят)
				{
				if(строка  in предшстр)
							{
								//_скажинс("А я  тоже грю, конца не будет! ");
							    следщстр = пусто;
								взят = да;
								break;
							}
				//if(строка in предшстр){ _скажинс("бряк!"); break;}
					if(auto т = сравни(строка, список[и]) == 0  )
					{
					//_скажинс(std.string.фм("да: %s = %s ; и она будет взята из списка в результат\n", строка, список[и])) ;
					строка_итог ~= строка~"\r\n";
					взято++;
					предшстр[строка] = взято;

				    	foreach(стр; список)
						{

							if(!(стр  in предшстр))
							{
									//_скажинс("Я нужен! А он? ");

									следщстр = стр;
									взят = да;
									break;
							}
						}
					//_скажинс("Бастилия взята!");
					взят = да;

					}
				}

			}
			взят = нет;
			if(!(строка in предшстр) && строка != следщстр && строка != пусто)
			{
			следщстр = строка;
			//_скажинс("Я нужен!");
			}
			else {
			     foreach(стрк; список)
						{
							if(стрк  in предшстр)
								//_скажинс("Типа конец, что ли? ");
							    следщстр = пусто;
								взят = да;
								break;
                        }
					}
			проходка++;
			и++;
			//_скажинс(std.string.фм("проходка %s\n, следщстр = %s", проходка, следщстр)) ;
		}

	}
return строка_итог;
}

ткст[] обработатьЛистинг(ткст имяЛ)
{
 ткст буф = cast(ткст) читайФайл(имяЛ~".lst");
  win.скажинс(буф);
  ткст[] список = разбейнастр(буф);
  ткст строка_итог;


  foreach(строка; список)
	{
	auto рез = убери(строка);
	if(рез == "Publics by name		module"||рез == "Publics by module"||рез == "") {рез = пусто;}
	if(рез != пусто) строка_итог ~= рез~"\n";

	}

	список = пусто;
	список = разбей(строка_итог);
	строка_итог = пусто;

	foreach(строка; список)
	{
	auto рез = убери(строка);
	if(рез != пусто) строка_итог ~= "\""~рез~"\",\r\n";

	}
	auto итог = удалитьДубликатыИзТМас(строка_итог);
	 удалиФайл(имяЛ~".lst");
	список = пусто;
	список = разбей(итог);
 return список;
}

export extern(D) проц обработай(ткст имяБ,ткст расшД = "dll", ткст путь = пусто, ткст имяД = пусто )
{
ткст[] список;
if(естьФайл(имяБ~".d")) удалиФайл(имяБ~".d");
if(создайБибИзДлл(имяБ, имяД, путь,расшД))
{
   if(естьФайл(имяБ~".lib"))создайЛистинг(имяБ);
   else exception.ошибка("Листинг файла не найден");

     if(естьФайл(имяБ~".lst"))список = обработатьЛистинг(имяБ);
	 else exception.ошибка("Листинг файла не обработан");
 }
 else exception.ошибка("Не удалось создать библиотеку импорта");
if(список != пусто) генМакетИмпорта(имяБ, список);
//_удалиФайл(имяБ~".lst");
}
///////////////////////////////////////////////////////

private import std.string, std.utf;
private import cidrus;

//import synsoft.types;
/+ + These are borrowed from synsoft.types, until such time as something similar is in Phobos ++
 +/
public alias int                    boolean;

/* /////////////////////////////////////////////////////////////////////////////
 * external function declarations
 */

version(Windows)
{
    private import sys.WinFuncs;
    private import rt.syserror;

    extern (Windows)
    {
        alias HMODULE HModule_;
    }
}
else version(Posix)
{
    private import os.posix;

    extern (C)
    {
    alias void* HModule_;
    }
}
else
{
    const int platform_not_discriminated = 0;

    static assert(platform_not_discriminated);
}

/** The platform-independent module хэндл. Note that this has to be
 * separate from the platform-dependent хэндл because different module names
 * can результат in the same module being loaded, which cannot be detected in
 * some operating systems
 */
typedef void    *HXModule;

/* /////////////////////////////////////////////////////////////////////////////
 * ExeModule functions
 */

/* These are "forward declared" here because I don't like the way D forces me
 * to provide my declaration and implementation together, and mixed in with all
 * the other implementation gunk.
 */

/** ExeModule library Initialisation
 *
 * \retval <0 Initialisation failed. Processing must gracefully terminate, 
 * without making any use of the ExeModule library
 * \retval 0 Initialisation succeeded for the first time. Any necessary resources
 * were successfully allocated
 * \retval >0 Initialisation has already succeefully completed via a prior call.
 */
public int ExeModule_Init()
{
    return ExeModule_Init_();
}

public void ExeModule_Uninit()
{
    ExeModule_Uninit_();
}

/** 
 *
 * \note The value of the хэндл returned may not be a valid хэндл for your operating
 * system, and you <b>must not</b> attempt to use it with any other operating system
 * or other APIs. It is only valid for use with the ExeModule library.
 */
public HXModule ExeModule_Load(in string moduleName)
{
    return ExeModule_Load_(moduleName);
}

public HXModule ExeModule_AddRef(HXModule hModule)
{
    return ExeModule_AddRef_(hModule);
}

/**
 *
 * \param hModule The module handler. It must not be null.
 */
public void ExeModule_Release(inout HXModule hModule)
{
    ExeModule_Release_(hModule);
}

public void *ExeModule_GetSymbol(inout HXModule hModule, in string symbolName)
{
    return ExeModule_GetSymbol_(hModule, symbolName);
}

public string ExeModule_Error()
{
    return ExeModule_Error_();
}


version(Windows)
{
    private int         s_init;
    private int         s_lastError;    // This is NOT thread-specific

    private void record_error_()
    {
        s_lastError = GetLastError();
    }


    private int ExeModule_Init_()
    {
        return ++s_init > 1;
    }

    private void ExeModule_Uninit_()
    {
        --s_init;
    }

    private HXModule ExeModule_Load_(in string moduleName)
    in
    {
        assert(null !is moduleName);
    }
    body
    {
        HXModule hmod = cast(HXModule)LoadLibraryA(toStringz(moduleName));

        if(null is hmod)
        {
            record_error_();
        }

        return hmod;
    }

    private HXModule ExeModule_AddRef_(HXModule hModule)
    in
    {
        assert(null !is hModule);
    }
    body
    {
        return ExeModule_Load_(ExeModule_GetPath_(hModule));
    }

    private void ExeModule_Release_(inout HXModule hModule)
    in
    {
        assert(null !is hModule);
    }
    body
    {
        if(!FreeLibrary(cast(HModule_)hModule))
        {
            record_error_();
        }
        hModule = null;
    }

    private void *ExeModule_GetSymbol_(inout HXModule hModule, in string symbolName)
    in
    {
        assert(null !is hModule);
    }
    body
    {
        void    *symbol = GetProcAddress(cast(HModule_)hModule, toStringz(symbolName));

        if(null is symbol)
        {
            record_error_();
        }

        return symbol;
    }

    private string ExeModule_Error_()
    {
    return sysErrorString(s_lastError);
    }

    private string ExeModule_GetPath_(HXModule hModule)
    {
        char    szFileName[260]; // Need to use a constant here

    // http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dllproc/base/getmodulefilename.asp
        uint cch = GetModuleFileNameA(cast(HModule_)hModule, szFileName.ptr, szFileName.length);

    if (cch == 0)
    {
            record_error_();
    }
        return szFileName[0 .. cch].dup;
    }
}
else version(Posix)
{
    private class ExeModuleInfo
    {
    public:
        int         m_cRefs;
        HModule_    m_hmod;
        string      m_name;

        this(HModule_ hmod, string name)
        {
            m_cRefs =   1;
            m_hmod  =   hmod;
            m_name  =   name;
        }
    };

    private int                     s_init;
    private ExeModuleInfo [string]  s_modules;
    private string                  s_lastError;    // This is NOT thread-specific

    private void record_error_()
    {
        char *err = dlerror();
        s_lastError = (null is err) ? "" : err[0 .. cidrus.strlen(err)];
    }

    private int ExeModule_Init_()
    {
        if(1 == ++s_init)
        {

            return 0;
        }

        return 1;
    }

    private void ExeModule_Uninit_()
    {
        if(0 == --s_init)
        {
        }
    }

    private HXModule ExeModule_Load_(in string moduleName)
    in
    {
        assert(null !is moduleName);
    }
    body
    {
    ExeModuleInfo*   mi_p = moduleName in s_modules;
    ExeModuleInfo   mi = mi_p is null ? null : *mi_p;

        if(null !is mi)
        {
            return (++mi.m_cRefs, cast(HXModule)mi);
        }
        else
        {
            HModule_    hmod = dlopen(toStringz(moduleName), RTLD_NOW);

            if(null is hmod)
            {
                record_error_();

                return null;
            }
            else
            {
                ExeModuleInfo   mi2  =   new ExeModuleInfo(hmod, moduleName);

                s_modules[moduleName]   =   mi2;

                return cast(HXModule)mi2;
            }
        }
    }

    private HXModule ExeModule_AddRef_(HXModule hModule)
    in
    {
        assert(null !is hModule);

        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
    }
    body
    {
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        if(null !is mi)
        {
            return (++mi.m_cRefs, hModule);
        }
        else
        {
            return null;
        }
    }

    private void ExeModule_Release_(inout HXModule hModule)
    in
    {
        assert(null !is hModule);

        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
    }
    body
    {
        ExeModuleInfo   mi      =   cast(ExeModuleInfo)hModule;

        if(0 == --mi.m_cRefs)
        {
            string      name    =   mi.m_name;

            if (dlclose(mi.m_hmod))
            {
                record_error_();
            }
            s_modules.remove(name);
            delete mi;
        }

        hModule = null;
    }

    private void *ExeModule_GetSymbol_(inout HXModule hModule, in string symbolName)
    in
    {
        assert(null !is hModule);

        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
    }
    body
    {
        ExeModuleInfo   mi      =   cast(ExeModuleInfo)hModule;
        void *symbol = dlsym(mi.m_hmod, toStringz(symbolName));

        if(null == symbol)
        {
            record_error_();
        }

        return symbol;
    }

    private string ExeModule_Error_()
    {
        return s_lastError;
    }

    private string ExeModule_GetPath_(HXModule hModule)
    in
    {
        assert(null !is hModule);

        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        assert(0 < mi.m_cRefs);
        assert(null !is mi.m_hmod);
        assert(null !is mi.m_name);
        assert(null !is s_modules[mi.m_name]);
        assert(mi is s_modules[mi.m_name]);
    }
    body
    {
        ExeModuleInfo   mi = cast(ExeModuleInfo)hModule;

        return mi.m_name;
    }
}
else
{
    const int platform_not_discriminated = 0;

    static assert(platform_not_discriminated);
}

/* /////////////////////////////////////////////////////////////////////////////
 * Classes
 */

public class ExeModuleException
    : Exception
{
public:
    this(string message)
    {
        super("Неудачное подключение к модулю:"~message,__FILE__,__LINE__);     
    }

    this(uint errcode)
    {
      version (Posix)
      {
    char[80] buf = void;
    super(std.string.toString(strerror_r(errcode, buf.ptr, buf.length)).dup);
      }
      else
      {
    super(строшиб(errcode));
      }
    }
}

/// This class represents an executable image
public scope class ExeModule
{
/// \name Construction
/// @{
public:
    /// Constructs from an existing image хэндл
    this(HXModule hModule, boolean bTakeOwnership)
    in
    {
        assert(null !is hModule);
    }
    body
    {
        if(bTakeOwnership)
        {
            m_hModule = hModule;
        }
        else
        {
        version (Windows)
        {
        string path = Path();
        m_hModule = cast(HXModule)LoadLibraryA(toStringz(path));
        if (m_hModule == null)
            throw new ExeModuleException(GetLastError());
        }
        else version (Posix)
        {
        m_hModule = ExeModule_AddRef(hModule);
        }
        else
        static assert(0);
        }
    }

    this(string moduleName)
    in
    {
        assert(null !is moduleName);
    }
    body
    {
    version (Windows)
    {
        m_hModule = cast(HXModule)LoadLibraryA(toStringz(moduleName));
        if (null is m_hModule)
        throw new ExeModuleException(GetLastError());
    }
    else version (Posix)
    {
        m_hModule = ExeModule_Load(moduleName);
        if (null is m_hModule)
        throw new ExeModuleException(ExeModule_Error());
    }
    else
    {
        static assert(0);       // unsupported system
    }
    }
    ~this()
    {
        close();
    }
/// @}

/// \name Operations
/// @{
public:
    /// Closes the library
    ///
    /// \note This is available to close the module at any time. Repeated
    /// calls do not результат in an error, and are simply ignored.
    void close()
    {
        if(null !is m_hModule)
        {
        version (Windows)
        {
        if(!FreeLibrary(cast(HModule_)m_hModule))
            throw new ExeModuleException(GetLastError());
        }
        else version (Posix)
        {
        ExeModule_Release(m_hModule);
        }
        else
        static assert(0);
        }
    }
/// @}

/// \name Accessors
/// @{
public:
    /** Retrieves the named symbol.
     *
     * \return A pointer to the symbol. There is no null return - failure to retrieve the symbol
     * results in an ExeModuleException exception being thrown.
     */
    void *getSymbol(in string symbolName)
    {
    version (Windows)
    {
        void *symbol = GetProcAddress(cast(HModule_)m_hModule, toStringz(symbolName));
        if(null is symbol)
        {
        throw new ExeModuleException(GetLastError());
        }
    }
    else version (Posix)
    {
        void *symbol = ExeModule_GetSymbol(m_hModule, symbolName);

        if(null is symbol)
        {
        throw new ExeModuleException(ExeModule_Error());
        }
    }
    else
    {
        static assert(0);
    }

        return symbol;
    }

    /** Retrieves the named symbol.
     *
     * \return A pointer to the symbol, or null if it does not exist
     */
    void *findSymbol(in string symbolName)
    {
        return ExeModule_GetSymbol(m_hModule, symbolName);
    }

/// @}

/// \name Properties
/// @{
public:
    /// The хэндл of the module
    ///
    /// \note Will be \c null if the module load in the constructor failed
    HXModule Дескр()
    {
        return m_hModule;
    }
    /// The хэндл of the module
    ///
    /// \note Will be \c null if the module load in the constructor failed
    string Path()
    {
        assert(null != m_hModule);

    version (Windows)
    {
        char szFileName[260]; // Need to use a constant here

        // http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dllproc/base/getmodulefilename.asp
        uint cch = GetModuleFileNameA(cast(HModule_)m_hModule, szFileName.ptr, szFileName.length);
        if (cch == 0)
        throw new ExeModuleException(GetLastError());

        return szFileName[0 .. cch].dup;
    }
    else version (Posix)
    {
        return ExeModule_GetPath_(m_hModule);
    }
    else
        static assert(0);
    }
/// @}

private:
    HXModule m_hModule;
};

/* ////////////////////////////////////////////////////////////////////////// */

version(TestMain)
{
    int main(string[] args)
    {
        if(args.length < 3)
        {
            эхо("USAGE: <moduleName> <symbolName>\n");
        }
        else
        {
            string  moduleName  =   args[1];
            string  symbolName  =   args[2];

            try
            {
                auto ExeModule xmod =   new ExeModule(moduleName);

                эхо("\"%.*s\" is loaded\n", moduleName);

                void    *symbol =   xmod.getSymbol(symbolName);

                if(null == symbol)
                {
                    throw new ExeModuleException(ExeModule_Error());
                }
                else
                {
                    эхо("\"%.*s\" is acquired\n", symbolName);
                }
            }
            catch(ExeModuleException x)
            {
                x.print();
            }
        }

        return 0;
    }
}

/* ////////////////////////////////////////////////////////////////////////// */

