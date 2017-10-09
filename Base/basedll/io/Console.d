module io.Console;

private import  win: КОНСВВОД, КОНСВЫВОД, КОНСОШ;

private import  io.device.Device,
                io.stream.Buffered;
              
version (Posix)
         /*private*/ import rt.core.stdc.posix.unistd;  // needed for isatty()
		 

export extern(D):

 struct Консоль 
{
        version (Win32)
                 const ткст Кс = "\r\n";
              else
                 const ткст Кс = "\n";


        /**********************************************************************

                Model console ввод as a буфер. Note that we читай utf8
                only.

        **********************************************************************/
 export:

     class Ввод
        {
                /*private*/ Бввод     буфер;
                /*private*/ бул    перенаправ;

                public alias    копируйнс получи;
				
export:

                /**************************************************************

                        Attach console ввод в_ the provопрed устройство

                **************************************************************/

                this (Провод провод, бул перенаправленый)
                {
                        перенаправ = перенаправленый;
                        буфер = new Бввод (провод);
                }

                /**************************************************************

                        Return the следщ строка available из_ the console, 
                        or пусто when there is nothing available. The значение
                        returned is a duplicate of the буфер контент (it
                        есть .dup applied). 

                        Each строка ending is removed unless parameter необр is
                        установи в_ да

                **************************************************************/

                final ткст копируйнс (бул необр = нет)
                {
                        ткст строка;

                        return читайнс (строка, необр) ? строка.dup : пусто;
                }

                /**************************************************************

                        Retreive a строка of текст из_ the console and карта
                        it в_ the given аргумент. The ввод is sliced, 
                        not copied, so use .dup appropriately. Each строка
                        ending is removed unless parameter необр is установи в_ 
                        да.
                        
                        Returns нет when there is no ещё ввод.

                **************************************************************/

                final бул читайнс (ref ткст контент, бул необр=нет)
                {
                        т_мера строка (проц[] ввод)
                        {
                                auto текст = cast(ткст) ввод;
                                foreach (i, c; текст)
                                         if (c is '\n')
                                            {
                                            auto j = i;
                                            if (необр)
                                                ++j;
                                            else
                                               if (j && (текст[j-1] is '\r'))
                                                   --j;
                                            контент = текст [0 .. j];
                                            return i+1;
                                            }
                                return ИПровод.Кф;
                        }

                        // получи следщ строка, return да
                        if (буфер.следщ (&строка))
                            return да;

                        // присвой trailing контент and return нет
                        контент = cast(ткст) буфер.срез (буфер.читаемый);
                        return нет;
                }

                /**************************************************************

                        Return the associated поток

                **************************************************************/

                final ИПотокВвода поток ()
                {
                        return буфер;
                }

                /**************************************************************

                        Is this устройство перенаправленый?

                        Возвращает:
                        Да if перенаправленый, нет otherwise.

                        Remarks:
                        Reflects the console redirection статус из_ when 
                        this module was instantiated

                **************************************************************/

                final бул перенаправленый ()
                {
                        return перенаправ;
                }           

                /**************************************************************

                        Набор redirection состояние в_ the provопрed булево

                        Remarks:
                        Configure the console redirection статус, where 
                        a перенаправленый console is ещё efficient (dictates 
                        whether нс() performs automatic flushing or 
                        not)

                **************************************************************/

                final Ввод перенаправленый (бул да)
                {
                         перенаправ = да;
                         return this;
                }           

                /**************************************************************

                        Returns the configured источник

                        Remarks:
                        Provопрes access в_ the underlying mechanism for 
                        console ввод. Use this в_ retain prior состояние
                        when temporarily switching inputs 
                        
                **************************************************************/

                final ИПотокВвода ввод ()
                {
                        return буфер.ввод;
                }           

                /**************************************************************

                        Divert ввод в_ an alternate источник
                        
                **************************************************************/

                final Ввод ввод (ИПотокВвода источник)
                {
                        буфер.ввод = источник;
                        return this;
                }           
        }


        /**********************************************************************

                Консоль вывод accepts utf8 only

        **********************************************************************/

     class Вывод
        {
		
export:

                /*private*/ Бвыв    буфер;
                /*private*/ бул    перенаправ;

                public  alias   добавь opCall;
                public  alias   слей  opCall;

                /**************************************************************

                        Attach console вывод в_ the provопрed устройство

                **************************************************************/

                this (Провод провод, бул перенаправленый)
                {
                        перенаправ = перенаправленый;
                        буфер = new Бвыв (провод);
                }

                /**************************************************************

                        Append в_ the console. We прими UTF8 only, so
                        все другой encodings should be handled via some
                        higher уровень API

                **************************************************************/

                final Вывод добавь (ткст x)
                {
                        буфер.добавь (x.ptr, x.length);
                        return this;
                } 
                          
                /**************************************************************

                        Append контент

                        Параметры:
                        другой = an объект with a useful вТкст() метод

                        Возвращает:
                        Returns a chaining reference if все контент was 
                        записано. Throws an ВВИскл indicating eof or 
                        eob if not.

                        Remarks:
                        Append the результат of другой.вТкст() в_ the console

                **************************************************************/

                final Вывод добавь (Объект другой)        
                {           
                        return добавь (другой.вТкст);
                }

                /**************************************************************

                        Append a нс and слей the console буфер. If
                        the вывод is перенаправленый, flushing does not occur
                        automatically.

                        Возвращает:
                        Returns a chaining reference if контент was записано. 
                        Throws an ВВИскл indicating eof or eob if not.

                        Remarks:
                        Emit a нс преобр_в the буфер, and autoflush the
                        current буфер контент for an interactive console.
                        Redirected consoles do not слей automatically on
                        a нс.

                **************************************************************/

                final Вывод нс ()
                {
                        буфер.добавь (Кс);
                        if (перенаправ is нет)
                            буфер.слей;

                        return this;
                }           

                /**************************************************************

                        Explicitly слей console вывод

                        Возвращает:
                        Returns a chaining reference if контент was записано. 
                        Throws an ВВИскл indicating eof or eob if not.

                        Remarks:
                        Flushes the console буфер в_ attached провод

                **************************************************************/

                final Вывод слей ()
                {
                        буфер.слей;
                        return this;
                }           

                /**************************************************************

                        Return the associated поток

                **************************************************************/

                final ИПотокВывода поток ()
                {
                        return буфер;
                }

                /**************************************************************

                        Is this устройство перенаправленый?

                        Возвращает:
                        Да if перенаправленый, нет otherwise.

                        Remarks:
                        Reflects the console redirection статус

                **************************************************************/

                final бул перенаправленый ()
                {
                        return перенаправ;
                }           

                /**************************************************************

                        Набор redirection состояние в_ the provопрed булево

                        Remarks:
                        Configure the console redirection статус, where 
                        a перенаправленый console is ещё efficient (dictates 
                        whether нс() performs automatic flushing or 
                        not)

                **************************************************************/

                final Вывод перенаправленый (бул нда)
                {
                         перенаправ = нда;
                         return this;
                }           

                /**************************************************************

                        Returns the configured вывод сток

                        Remarks:
                        Provопрes access в_ the underlying mechanism for 
                        console вывод. Use this в_ retain prior состояние
                        when temporarily switching outputs 
                        
                **************************************************************/

                final ИПотокВывода вывод ()
                {
                        return буфер.вывод;
                }           

                /**************************************************************

                        Divert вывод в_ an alternate сток

                **************************************************************/

                final Вывод вывод (ИПотокВывода сток)
                {
                        буфер.вывод = сток;
                        return this;
                }           
        }


        /***********************************************************************

                Провод for specifically handling the console devices. This 
                takes care of certain implementation details on the Win32 
                platform.

                Note that the console is fixed at Utf8 for Всё linux and
                Win32. The latter is actually Utf16 исконный, but it's just
                too much hassle for a developer в_ укз the distinction
                when it really should be a no-brainer. In particular, the
                Win32 console functions don't work with redirection. This
                causes добавьitional difficulties that can be ameliorated by
                asserting console I/O is always Utf8, in все modes.

        ***********************************************************************/

    class Провод : Устройство
        {
		
export:

                /*private*/ бул перенапр = нет;
				
				бул перенаправленый(){return перенапр;}
				
				проц перенаправленый (бул нда)
                {
                         перенапр = нда;                      
                }

                /***********************************************************************

                        Возвращает название данного провода

                ***********************************************************************/

                override ткст вТкст()
                {
                        return "<io.Console.Консоль>";
                }

                /***************************************************************

                        Код, специфичный для Windows

                ***************************************************************/

                version (Win32)
                        {
                        /*private*/ шим[] ввод;
                        /*private*/ шим[] вывод;

                        /*******************************************************

                                Ассоциирует данное устройство с предоставленным укз. 

                                Строго для адаптирования существующих устройств, 
                                таких как Стдвыв и проч.

                        *******************************************************/

                        this (т_мера укз)
                        {
                                ввод = new шим [1024 * 1];
                                вывод = new шим [1024 * 1];
                                переоткрой (укз);
                        }    

                        /*******************************************************

                                Получает доступ к стандартным рычагам IO 

                        *******************************************************/

                        /*private*/ проц переоткрой (т_мера ук_)
                        {
                                static const DWORD[] опр = [
                                                          cast(DWORD) -10, 
                                                          cast(DWORD) -11, 
                                                          cast(DWORD) -12
                                                          ];
                                static const ткст[] f = [
                                                          "CONIN$\0", 
                                                          "CONOUT$\0", 
                                                          "CONOUT$\0"
                                                          ];

                                assert (ук_ < 3);
								
						//	if (вв.указатель is пусто || вв.указатель is НЕВЕРНХЭНДЛ)
						//	{
								switch(ук_)
								{
								case 0:
								вв.указатель = cast(Дескр) КОНСВВОД =  ДайСтдДескр(ПСтд.Ввод);					

								break;
								case 1:
								вв.указатель = cast(Дескр) КОНСВЫВОД = ДайСтдДескр(ПСтд.Вывод);

								break;
								case 2:
								вв.указатель = cast(Дескр) КОНСОШ = cast(ук) ДайСтдДескр(ПСтд.Ошибка); 
								break;
								}
								
						//}          

			 
							if (вв.указатель is пусто || вв.указатель is НЕВЕРНХЭНДЛ)
                                    вв.указатель = CreateFileA ( cast(PCHAR) f[ук_].ptr, 
                                                ППраваДоступа.ГенерноеЧтение| ППраваДоступа.ГенернаяЗапись, ПСовмИспФайла.Чтение|ПСовмИспФайла.Запись, 
                                                пусто, 3, 0, cast(HANDLE) 0);
												
						/+	else if (вв.указатель is пусто || вв.указатель is НЕВЕРНХЭНДЛ)
								{
								
								ИНФОСТАРТА _стартИнфо;
								_стартИнфо = дайСтартИнфо();
								
								switch(ук_)
								{
								case 0: вв.указатель = cast(Дескр) _стартИнфо.стдвво;	break;				
								case 1: вв.указатель = cast(Дескр) _стартИнфо.стдвыв; break;
								case 2: вв.указатель = cast(Дескр) _стартИнфо.стдош; break;
								}
								
								assert(вв.указатель !is пусто || вв.указатель !is НЕВЕРНХЭНДЛ, "Не удалось получить вв.указатель");
								
								}+/

                                // allow не_годится handles в_ remain, since it
                                // may be patched later in some special cases
                                if (вв.указатель != НЕВЕРНХЭНДЛ)
                                   {
                                   DWORD режим;
                                   // are we redirecting? Note that we cannot
                                   // use the 'appending' режим triggered via
                                   // настройка overlapped.Offset в_ -1, so we
                                   // just track the байт-счёт instead
                                   if (! GetConsoleMode (cast(HANDLE) вв.указатель,cast(int *) &режим))
                                         перенапр = вв.след = да;
										 //ПрикрепиКонсоль(-1);
                                   }
                        }

                        /*******************************************************

                                Write a chunk of байты в_ the console из_ 
                                the provопрed Массив 

                        *******************************************************/

                        version (Win32SansUnicode) 
                                {} 
                             else
                                {
                                override т_мера пиши (проц[] ист)
                                {
                                if (перенапр)
								{
								эхо("redirected!");
                                    return super.пиши (ист);									
									}
                                else
                                   {
                                   DWORD i = ист.length;

                                   // protect conversion из_ пустой strings
                                   if (i is 0)
                                       return 0;

                                   // расширь буфер appropriately
                                   if (вывод.length < i)
                                       вывод.length = i;

                                   // преобразуй преобр_в вывод буфер
                                   i = MultiByteToWideChar (ПКодСтр.УТФ8, 0, cast(PCHAR) ист.ptr, i, 
                                                            вывод.ptr, вывод.length);
                                            
                                   // слей produced вывод
                                   for (шим* p=вывод.ptr, конец=вывод.ptr+i; p < конец; p+=i)
                                       {
                                       const цел MAX = 16 * 1024;

                                       // avoопр console limitation of 64KB 
                                       DWORD длин = конец - p; 
                                       if (длин > MAX)
                                          {
                                          длин = MAX;
                                          // check for trailing surrogate ...
                                          if ((p[длин-1] & 0xfc00) is 0xdc00)
                                               --длин;
                                          }
                                       if (! WriteConsoleW (cast(HANDLE) вв.указатель, p, длин, cast(int*) &i, пусто))
                                             ошибка();
                                       }
                                   return ист.length;
                                   }
                                }
                                }
                        
                        /*******************************************************

                                Чтен a chunk of байты из_ the console преобр_в 
                                the provопрed Массив 

                        *******************************************************/

                        version (Win32SansUnicode) 
                                {} 
                             else
                                {
                                override т_мера читай (проц[] приёмн)
                                {
                                if (перенапр)
                                    return super.читай (приёмн);
                                else
                                   {
                                   DWORD i = приёмн.length / 4;

                                   assert (i);

                                   if (i > ввод.length)
                                       i = ввод.length;
                                       
                                   // читай a chunk of wchars из_ the console
                                   if (! ReadConsoleW (cast(HANDLE) вв.указатель, ввод.ptr, i, &i, пусто))
                                         ошибка();

                                   // no ввод ~ go home
                                   if (i is 0)
                                       return Кф;

                                   // translate в_ utf8, directly преобр_в приёмн
                                   i = WideCharToMultiByte (ПКодСтр.УТФ8, 0, ввод.ptr, i, 
                                                            cast(PCHAR) приёмн.ptr, приёмн.length, пусто, пусто);
                                   if (i is 0)
                                       ошибка ();

                                   return i;
                                   }
                                }
                                }

                        }
                     else
                        {
                        /*******************************************************

                                Associate this устройство with a given укз. 

                                This is strictly for adapting existing 
                                devices such as Стдвыв and friends

                        *******************************************************/

                        /*private*/ this (т_мера укз)
                        {
                                this.укз = cast(Дескр) укз;
                                перенапр = (isatty(укз) is 0);
                        }
                        }
        }
}


/******************************************************************************

        Globals representing Консоль IO

******************************************************************************/

static Консоль.Ввод    Кввод;                    /// the стандарт ввод поток
static Консоль.Вывод   Квывод,                   /// the стандарт вывод поток
                        Кош;                   /// the стандарт ошибка поток


/******************************************************************************

        Instantiate Консоль access

******************************************************************************/

static this ()
{
        auto провод = new Консоль.Провод (0);
        Кввод  = new Консоль.Ввод (провод, провод.перенаправленый);

        провод = new Консоль.Провод (1);
        Квывод = new Консоль.Вывод (провод, провод.перенаправленый);

        провод = new Консоль.Провод (2);
        Кош = new Консоль.Вывод (провод, провод.перенаправленый);
}
/+

/******************************************************************************

        Flush outputs before we exit

        (good опрea из_ Frits Van Bommel)

******************************************************************************/

static ~this()
{
   synchronized (Квывод.поток)
        Квывод.слей;

   synchronized (Кош.поток)
        Кош.слей;
}


/******************************************************************************/

ткст бдолВЮ8 (ткст tmp, бдол val)
in {
   assert (tmp.length > 19, "буфер ulongToUtf8 должен быть длиною более 19 символов");
   }
body
{
    сим* p = tmp.ptr + tmp.length;

    do {
       *--p = cast(сим)((val % 10) + '0');
       } while (val /= 10);

    return tmp [cast(т_мера)(p - tmp.ptr) .. $];
}


		
	проц скажи(ткст ткт){Квывод(ткт);}
	
	проц скажи(бдол ткт)
	{
	сим[25] врем = void;
	Квывод(бдолВЮ8(врем,ткт));
	}
	
alias скажи say, console, консоль;

	проц скажинс(ткст ткт){Квывод(ткт).нс;}
	
	проц скажинс(бдол ткт)
	{
	сим[25] врем = void;
	Квывод(бдолВЮ8(врем,ткт)).нс;
	}
	
	проц нс(){Квывод("").нс;}
	проц таб(){Квывод("\t");}
	
+/