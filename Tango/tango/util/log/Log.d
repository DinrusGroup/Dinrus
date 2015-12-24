﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        May 2004 : Initial release
        version:        Oct 2004: Иерархия moved due в_ circular dependencies
        version:        Apr 2008: Отложенный delegates removed due в_ awkward usage
        author:         Kris


        Loggers are named entities, sometimes shared, sometimes specific в_ 
        a particular portion of код. The names are generally hierarchical in 
        nature, using dot notation (with '.') в_ separate each named section. 
        For example, a typical имя might be something like "mail.шли.писатель"
        ---
        import util.log.Log;форматируй
        
        auto лог = Журнал.отыщи ("mail.шли.писатель");

        лог.инфо  ("an informational сообщение");
        лог.ошибка ("an исключение сообщение: {}", исключение.вТкст);

        etc ...
        ---
        
        It is consопрered good form в_ пароль a logger экземпляр as a function or 
        class-ctor аргумент, or в_ присвой a new logger экземпляр during static 
        class construction. For example: if it were consопрered appropriate в_ 
        have one logger экземпляр per class, each might be constructed like so:
        ---
        private Логгер лог;
        
        static this()
        {
            лог = Журнал.отыщи (nameOfThisClassOrStructOrModule);
        }
        ---

        Messages passed в_ a Логгер are assumed в_ be either сам-contained
        or configured with "{}" notation a la Выкладка & Стдвыв:
        ---
        лог.предупреди ("temperature is {} degrees!", 101);
        ---

        Note that an internal workspace is used в_ форматируй the сообщение, which
        is limited в_ 2000 байты. Use "{.256}" truncation notation в_ предел
        the размер of indivопрual сообщение components, or use explicit formatting:
        ---
        сим[4096] буф =void;

        лог.предупреди (лог.форматируй (буф, "a very дол warning: {}", someLongWarning));
        ---

        To avoопр overhead when constructing аргумент passed в_ formatted 
        messages, you should check в_ see whether a logger is активное or not:
        ---
        if (лог.включен (лог.Предупрежд))
            лог.предупреди ("temperature is {} degrees!", complexFunction());
        ---
        
        The above will be handled implicitly by the logging system when 
        macros are добавьed в_ the language (used в_ be handled implicitly 
        via lazy delegates, but usage of those turned out в_ be awkward).

        лог closely follows Всё the API and the behaviour as documented 
        at the official Журнал4J site, where you'll найди a good tutorial. Those 
        pages are hosted over 
        <A HREF="http://logging.apache.org/log4j/docs/documentation.html">here</A>.

*******************************************************************************/

module util.log.Log;

private import  sys.Common;

private import  time.Clock;

private import  exception;

private import  io.model;

private import  text.convert.Format;

private import  util.log.model.ILogger;

/*******************************************************************************

        Platform issues ...

*******************************************************************************/

version (GNU)
        {
        private import std.stdarg;
        alias ук  Арг;
        alias спис_ва АргСписок;
        }
     else
        {
        alias ук  Арг;
        alias ук  АргСписок;
        }

/*******************************************************************************

        Pull in добавьitional functions из_ the C library

*******************************************************************************/

extern (C)
{
        private цел memcmp (проц *, проц *, цел);
}

version (Win32)
{
        private extern(Windows) цел QueryPerformanceCounter(бдол *счёт);
        private extern(Windows) цел QueryPerformanceFrequency(бдол *частота);
}

/*******************************************************************************
                        
        These represent the стандарт LOG4J событие levels. Note that
        Debug is called След here, because debug is a reserved word
        in D 

*******************************************************************************/

alias ИЛоггер.Уровень Уровень; 


/*******************************************************************************

        Manager for routing Логгер calls в_ the default иерархия. Note 
        that you may have multИПle hierarchies per application, but must
        access the иерархия directly for корень() and отыщи() methods within 
        each добавьitional экземпляр.

*******************************************************************************/

public struct Журнал
{
        // support for old API
        public alias отыщи дайЛоггер;

        // internal use only
        private static Иерархия основа;
        private static Время времяНачала;

        version (Win32)
        {
                private static дво множитель;
                private static бдол  стартТаймера;
        }

        private struct  Пара {ткст имя; Уровень значение;}

        private static  Уровень [ткст] карта;
        
        private static  Пара[] Пары = 
                        [
                        {"TRACE",  Уровень.След},
                        {"След",  Уровень.След},
                        {"след",  Уровень.След},
                        {"INFO",   Уровень.Инфо},
                        {"Инфо",   Уровень.Инфо},
                        {"инфо",   Уровень.Инфо},
                        {"WARN",   Уровень.Предупрежд},
                        {"Предупреждение",   Уровень.Предупрежд},
                        {"ERROR",  Уровень.Ошибка},
                        {"Ошибка",  Уровень.Ошибка},
                        {"ошибка",  Уровень.Ошибка},
                        {"Фатально",  Уровень.Фатал},
                        {"FATAL",  Уровень.Фатал},
                        {"фатал",  Уровень.Фатал},
                        {"Неук",   Уровень.Нет},
                        {"Нет",   Уровень.Нет},
                        {"Неук",   Уровень.Нет},
                        ];

        // logging-уровень names
        private static ткст[] ИменаУровней = 
        [
                "След ", "Инфо  ", "Предупреждение  ", "Ошибка ", "Фатально ", "Нет  "
        ];

        /***********************************************************************
        
                Initialize the основа иерархия           
              
        ***********************************************************************/

        static this ()
        {
                основа = new Иерархия ("drTango");

                foreach (p; Пары)
                         карта[p.имя] = p.значение;

                version (Posix)       
                {
                        времяНачала = Часы.сейчас;
                }

                version (Win32)
                {
                        бдол freq;

                        if (! QueryPerformanceFrequency (&freq))
                              throw new PlatformException ("high-resolution timer is not available");
                        
                        QueryPerformanceCounter (&стартТаймера);
                        множитель = cast(дво) ИнтервалВремени.ТиковВСек / freq;       
                        времяНачала = Часы.сейчас;
                }
        }

        /***********************************************************************
        
                Return the уровень of a given имя

        ***********************************************************************/

        static Уровень преобразуй (ткст имя, Уровень def=Уровень.След)
        {
                auto p = имя in карта;
                if (p)
                    return *p;
                return def;
        }

        /***********************************************************************
                
                Return the current время

        ***********************************************************************/

        static Время время ()
        {
                version (Posix)       
                {
                        return Часы.сейчас;
                }

                version (Win32)
                {
                        бдол сейчас;

                        QueryPerformanceCounter (&сейчас);
                        return времяНачала + ИнтервалВремени(cast(дол)((сейчас - стартТаймера) * множитель));
                }
        }

        /***********************************************************************

                Return the корень Логгер экземпляр. This is the ancestor of
                все loggers and, as such, can be used в_ manИПulate the 
                entire иерархия. For экземпляр, настройка the корень 'уровень' 
                attribute will affect все другой loggers in the дерево.

        ***********************************************************************/

        static Логгер корень ()
        {
                return основа.корень;
        }

        /***********************************************************************
        
                Return an экземпляр of the named logger. Names should be
                hierarchical in nature, using dot notation (with '.') в_ 
                separate each имя section. For example, a typical имя 
                might be something like "io.Stdout".

                If the logger does not currently exist, it is создан and
                inserted преобр_в the иерархия. A предок will be attached в_
                it, which will be either the корень logger or the closest
                ancestor in terms of the hierarchical имя пространство.

        ***********************************************************************/

        static Логгер отыщи (ткст имя)
        {
                return основа.отыщи (имя);
        }

        /***********************************************************************
        
                Return текст имя for a лог уровень

        ***********************************************************************/

        static ткст преобразуй (цел уровень)
        {
                assert (уровень >= Уровень.След && уровень <= Уровень.Нет);
                return ИменаУровней[уровень];
        }

        /***********************************************************************
        
                Return the singleton иерархия.

        ***********************************************************************/

        static Иерархия иерархия ()
        {
                return основа;
        }

        /***********************************************************************

                Initialize the behaviour of a basic logging иерархия.

                добавьs a ПотокAppender в_ the корень node, and sets
                the activity уровень в_ be everything включен.
                
        ***********************************************************************/

        static проц конфиг (ИПотокВывода поток, бул слей = да)
        {
                корень.добавь (new ДобПоток (поток, слей));
        }

        /***********************************************************************
        
                Initialize a снимок for a specific logging уровень, and 
                with an optional буфер. Default буфер размер is 1024

        ***********************************************************************/

        static private Снимок снимок (Логгер хозяин, Уровень уровень, ткст буфер = пусто)
        {
                assert (хозяин);
                Снимок snap =void;

                if (буфер.length is 0)
                    буфер = snap.врем;

                snap.буфер = буфер;
                snap.уровень = уровень;
                snap.хозяин = хозяин;
                snap.следщ = 0;
                return snap;
        }
}


/*******************************************************************************

        Снимок support for use with existing лог instances. The behaviour 
        is different из_ traditional logging in that snapshots don't излей any 
        вывод until flushed. They gather up information in a temporary буфер 
        and излей that instead - this can be used в_ gather up a series of лог 
        snИПpets преобр_в one place. Typical usage is like so:
        ---
        auto snap = Журнал.снимок (лог, Уровень.Инфо);
        ...
        snap.форматируй ("{}; ", "first");
        ...
        snap.форматируй ("{}; ", "сукунда");
        ...
        snap.слей;
        ---
        
        Setting a larger буфер размер than the default:
        ---
        сим[4096] буф =void;
        auto snap = Журнал.снимок (лог, Уровень.Инфо, буф);
        ...
        ---
        
        Note that this is a struct, and is constructed on the stack

*******************************************************************************/

private struct Снимок
{
        private Логгер          хозяин;
        private цел             следщ;
        private Уровень           уровень;
        private ткст          буфер;
        private сим[1024]      врем =void;

        /***********************************************************************
        
                See if this Снимок is включен via the associated logger. If
                that logger is установи в_ a уровень less verbose than our снимок, 
                we are consопрered disabled.

        ***********************************************************************/

        бул включен ()
        {
                return хозяин.включен (уровень);
        }

        /***********************************************************************
                
                Append formatted текст в_ the снимок. Nothing is излейted 
                until слей is invoked.

        ***********************************************************************/

        проц форматируй (ткст строкаФмт, ...)
        {
                if (включен)
                   {
                   auto s = Формат.vprint (буфер[следщ .. $], строкаФмт, _arguments, _argptr);  
                   следщ += s.length;
                   }
        }

        /***********************************************************************
        
                Must be invoked в_ generate any вывод

        ***********************************************************************/

        проц слей ()
        {
                if (следщ)
                    хозяин.добавь (уровень, буфер [0 .. следщ]);
                следщ = 0;
        }
}


/*******************************************************************************

        Loggers are named entities, sometimes shared, sometimes specific в_ 
        a particular portion of код. The names are generally hierarchical in 
        nature, using dot notation (with '.') в_ separate each named section. 
        For example, a typical имя might be something like "mail.шли.писатель"
        ---
        import util.log.Log;форматируй
        
        auto лог = Журнал.отыщи ("mail.шли.писатель");

        лог.инфо  ("an informational сообщение");
        лог.ошибка ("an исключение сообщение: {}", исключение.вТкст);

        etc ...
        ---
        
        It is consопрered good form в_ пароль a logger экземпляр as a function or 
        class-ctor аргумент, or в_ присвой a new logger экземпляр during static 
        class construction. For example: if it were consопрered appropriate в_ 
        have one logger экземпляр per class, each might be constructed like so:
        ---
        private Логгер лог;
        
        static this()
        {
            лог = Журнал.отыщи (nameOfThisClassOrStructOrModule);
        }
        ---

        Messages passed в_ a Логгер are assumed в_ be either сам-contained
        or configured with "{}" notation a la Выкладка & Стдвыв:
        ---
        лог.предупреди ("temperature is {} degrees!", 101);
        ---

        Note that an internal workspace is used в_ форматируй the сообщение, which
        is limited в_ 2000 байты. Use "{.256}" truncation notation в_ предел
        the размер of indivопрual сообщение components, or use explicit formatting:
        ---
        сим[4096] буф =void;

        лог.предупреди (лог.форматируй (буф, "a very дол warning: {}", someLongWarning));
        ---

        To avoопр overhead when constructing аргумент passed в_ formatted 
        messages, you should check в_ see whether a logger is активное or not:
        ---
        if (лог.включен (лог.Предупрежд))
            лог.предупреди ("temperature is {} degrees!", complexFunction());
        ---
        
        The above will be handled implicitly by the logging system when 
        macros are добавьed в_ the language (used в_ be handled implicitly 
        via lazy delegates, but usage of those turned out в_ be awkward).

        лог closely follows Всё the API and the behaviour as documented 
        at the official Журнал4J site, where you'll найди a good tutorial. Those 
        pages are hosted over 
        <A HREF="http://logging.apache.org/log4j/docs/documentation.html">here</A>.

*******************************************************************************/

public class Логгер : ИЛоггер
{     
        
        alias Уровень.След След;        // shortcut в_ Уровень values 
        alias Уровень.Инфо  Инфо;         // ...
        alias Уровень.Предупрежд  Предупрежд;         // ...
        alias Уровень.Ошибка Ошибка;        // ...
        alias Уровень.Фатал Фатал;        // ...

        alias добавь      opCall;       // shortcut в_ добавь

        /***********************************************************************
                
                Контекст for a иерархия, used for customizing behaviour
                of лог hierarchies. You can use this в_ implement dynamic
                лог-levels, based upon filtering or some другой mechanism

        ***********************************************************************/

        interface Контекст
        {
                /// return a ярлык for this контекст
                ткст ярлык ();
                
                /// first арг is the настройка of the logger itself, and
                /// the сукунда арг is what kind of сообщение we're being
                /// asked в_ произведи
                бул включен (Уровень настройка, Уровень мишень);
        }

        /***********************************************************************
                
        ***********************************************************************/

        private Логгер          следщ,
                                предок;

        private Иерархия       host_;
        private ткст          name_;
        private Уровень           level_;
        private бул            аддитивный_;
        private Добавщик        appender_;

        /***********************************************************************
        
                Construct a LoggerInstance with the specified имя for the 
                given иерархия. By default, logger instances are аддитивный
                and are установи в_ излей все события.

        ***********************************************************************/

        private this (Иерархия хост, ткст имя)
        {
                host_ = хост;
                level_ = Уровень.След;
                аддитивный_ = да;
                name_ = имя;
        }

        /***********************************************************************
        
                No, you should not delete or 'scope' these entities

        ***********************************************************************/

        private ~this() {}

        /***********************************************************************
        
                Is this logger enabed for the specified Уровень?

        ***********************************************************************/

        final бул включен (Уровень уровень = Уровень.Фатал)
        {
                return host_.контекст.включен (level_, уровень);
        }

        /***********************************************************************

                Is след включен?

        ***********************************************************************/

        final бул след ()
        {
                return включен (Уровень.След);
        }

        /***********************************************************************

                Append a след сообщение

        ***********************************************************************/

        final проц след (ткст фмт, ...)
        {
                форматируй (Уровень.След, фмт, _arguments, _argptr);
        }

        /***********************************************************************

                Append a след сообщение

        ***********************************************************************/

        private проц след (lazy проц дг)
        {
                if (включен (Уровень.След))
                    дг();
        }

        /***********************************************************************

                Is инфо включен?

        ***********************************************************************/

        final бул инфо ()
        {
                return включен (Уровень.Инфо);
        }

        /***********************************************************************

                Append an инфо сообщение

        ***********************************************************************/

        final проц инфо (ткст фмт, ...)
        {
                форматируй (Уровень.Инфо, фмт, _arguments, _argptr);
        }

        /***********************************************************************

                Append an инфо сообщение

        ***********************************************************************/

        private проц инфо (lazy проц дг)
        {
                if (включен (Уровень.Инфо))
                    дг();
        }

        /***********************************************************************

                Is предупреди включен?

        ***********************************************************************/

        final бул предупреди ()
        {
                return включен (Уровень.Предупрежд);
        }

        /***********************************************************************

                Append a warning сообщение

        ***********************************************************************/

        final проц предупреди (ткст фмт, ...)
        {
                форматируй (Уровень.Предупрежд, фмт, _arguments, _argptr);
        }

        /***********************************************************************

                Append a warning сообщение

        ***********************************************************************/

        private проц предупреди (lazy проц дг)
        {
                if (включен (Уровень.Предупрежд))
                    дг();
        }

        /***********************************************************************

                Is ошибка включен?

        ***********************************************************************/

        final бул ошибка ()
        {
                return включен (Уровень.Ошибка);
        }

        /***********************************************************************

                Append an ошибка сообщение

        ***********************************************************************/

        final проц ошибка (ткст фмт, ...)
        {
                форматируй (Уровень.Ошибка, фмт, _arguments, _argptr);
        }

        /***********************************************************************

                Append an ошибка сообщение

        ***********************************************************************/

        private проц ошибка (lazy проц дг)
        {
                if (включен (Уровень.Ошибка))
                    дг();
        }

        /***********************************************************************

                Is фатал включен?

        ***********************************************************************/

        final бул фатал ()
        {
                return включен (Уровень.Фатал);
        }

        /***********************************************************************

                Append a фатал сообщение

        ***********************************************************************/

        final проц фатал (ткст фмт, ...)
        {
                форматируй (Уровень.Фатал, фмт, _arguments, _argptr);
        }

        /***********************************************************************

                Append a фатал сообщение

        ***********************************************************************/

        private проц фатал (lazy проц дг)
        {
                if (включен (Уровень.Фатал))
                    дг();
        }

        /***********************************************************************

                Return the имя of this Логгер (sans the appended dot).
       
        ***********************************************************************/

        final ткст имя ()
        {
                цел i = name_.length;
                if (i > 0)
                    --i;
                return name_[0 .. i];     
        }

        /***********************************************************************
        
                Return the Уровень this logger is установи в_

        ***********************************************************************/

        final Уровень уровень ()
        {
                return level_;     
        }

        /***********************************************************************
        
                Набор the current уровень for this logger (and only this logger).

        ***********************************************************************/

        final Логгер уровень (Уровень l)
        {
                return уровень (l, нет);
        }

        /***********************************************************************
        
                Набор the current уровень for this logger, and (optionally) все
                of its descendents.

        ***********************************************************************/

        final Логгер уровень (Уровень уровень, бул распространить)
        {
                level_ = уровень; 
                if (распространить)    
                    foreach (лог; host_)
                             if (лог.ветвь_ли_от (name_))
                                 лог.level_ = уровень;
                return this;
        }

        /***********************************************************************
        
                Is this logger аддитивный? That is, should we walk ancestors
                looking for ещё appenders?

        ***********************************************************************/

        final бул аддитивный ()
        {
                return аддитивный_;
        }

        /***********************************************************************
        
                Набор the аддитивный статус of this logger. See бул аддитивный().

        ***********************************************************************/

        final Логгер аддитивный (бул включен)
        {
                аддитивный_ = включен;     
                return this;
        }

        /***********************************************************************
        
                Добавь (другой) добавщик в_ this logger. Appenders are each
                invoked for лог события as they are produced. At most, one
                экземпляр of each добавщик will be invoked.

        ***********************************************************************/

        final Логгер добавь (Добавщик другой)
        {
                assert (другой);
                другой.следщ = appender_;
                appender_ = другой;
                return this;
        }

        /***********************************************************************
        
                Удали все appenders из_ this Логгер

        ***********************************************************************/

        final Логгер сотри ()
        {
                appender_ = пусто;     
                return this;
        }

        /***********************************************************************
        
                Get время since this application пущен

        ***********************************************************************/

        final ИнтервалВремени рантайм ()
        {
                return Часы.сейчас - Журнал.времяНачала;
        }

        /***********************************************************************
        
                Отправка a сообщение в_ this logger via its добавщик список.

        ***********************************************************************/

        final Логгер добавь (Уровень уровень, lazy ткст эксп)
        {
                if (host_.контекст.включен (level_, уровень))
                   {
                   СобытиеЛога событие;

                   // установи the событие атрибуты and добавь it
                   событие.установи (host_, уровень, эксп, имя.length ? name_[0..$-1] : "корень");
                   добавь (событие);
                   }
                return this;
        }

        /***********************************************************************
        
                Отправка a сообщение в_ this logger via its добавщик список.

        ***********************************************************************/

        private проц добавь (СобытиеЛога событие)
        {
                // combine appenders из_ все ancestors
                auto линки = this;
                Добавщик.маска маски = 0;                 
                do {
                   auto добавщик = линки.appender_;

                   // this уровень have an добавщик?
                   while (добавщик)
                         { 
                         auto маска = добавщик.маска;

                         // have we used this добавщик already?
                         if ((маски & маска) is 0)
                            {
                            // no - добавь сообщение and обнови маска
                            добавщик.добавь (событие);
                            маски |= маска;
                            }
                         // process все appenders for this node
                         добавщик = добавщик.следщ;
                         }
                     // process все ancestors
                   } while (линки.аддитивный_ && ((линки = линки.предок) !is пусто));
        }

        /***********************************************************************

                Формат текст using the форматёр configured in the associated
                иерархия 

        ***********************************************************************/

        final ткст форматируй (ткст буфер, ткст строкаФмт, ...)
        {
                return Формат.vprint (буфер, строкаФмт, _arguments, _argptr);
        }

        /***********************************************************************

                Формат текст using the форматёр configured in the associated
                иерархия. 

        ***********************************************************************/

        final Логгер форматируй (Уровень уровень, ткст фмт, ИнфОТипе[] типы, АргСписок арги)
        {    
                сим[2048] врем =void;
 
                if (типы.length)
                    добавь (уровень, Формат.vprint (врем, фмт, типы, арги));
                else
                   добавь (уровень, фмт);                
                return this;
        }

        /***********************************************************************
        
                See if the provопрed Логгер имя is a предок of this one. Note 
                that each Логгер имя есть a '.' appended в_ the конец, such that 
                имя segments will not partially match.

        ***********************************************************************/

        private final бул ветвь_ли_от (ткст кандидат)
        {
                auto длин = кандидат.length;

                // possible предок if length is shorter
                if (длин < name_.length)
                    // does the префикс match? Note we добавь a "." в_ each 
                    // (the корень is a предок of everything)
                    return (длин is 0 || 
                            memcmp (&кандидат[0], &name_[0], длин) is 0);
                return нет;
        }

        /***********************************************************************
        
                See if the provопрed Логгер is a better match as a предок of
                this one. This is used в_ restructure the иерархия when a
                new logger экземпляр is introduced

        ***********************************************************************/

        private final бул близкийПотомок_ли (Логгер другой)
        {
                auto имя = другой.name_;
                if (ветвь_ли_от (имя))
                    // is this a better (longer) match than prior предок?
                    if ((предок is пусто) || (имя.length >= предок.name_.length))
                         return да;
                return нет;
        }
}

/*******************************************************************************
 
        The Логгер иерархия implementation. We keep a reference в_ each
        logger in a hash-table for convenient отыщи purposes, plus keep
        each logger linked в_ the другие in an ordered группа. Ordering
        places shortest names at the голова and longest ones at the хвост, 
        making the дело of опрentifying ancestors easier in an orderly
        fashion. For example, when propagating levels across descendents
        it would be a mistake в_ распространить в_ a ветвь before все of its
        ancestors were taken care of.

*******************************************************************************/

private class Иерархия : Логгер.Контекст
{
        private Логгер                  root_;
        private ткст                  name_,
                                        адрес_;      
        private Логгер.Контекст          context_;
        private Логгер[ткст]          loggers;


        /***********************************************************************
        
                Construct a иерархия with the given имя.

        ***********************************************************************/

        this (ткст имя)
        {
                name_ = имя;
                адрес_ = "network";

                // вставь a корень node; the корень есть an пустой имя
                root_ = new Логгер (this, "");
                context_ = this;
        }

        /**********************************************************************

        **********************************************************************/

        final ткст ярлык ()
        {
                return "";
        }
                
        /**********************************************************************


        **********************************************************************/

        final бул включен (Уровень уровень, Уровень тест)
        {
                return тест >= уровень;
        }

        /**********************************************************************

                Return the имя of this Иерархия

        **********************************************************************/

        final ткст имя ()
        {
                return name_;
        }

        /**********************************************************************

                Набор the имя of this Иерархия

        **********************************************************************/

        final проц имя (ткст имя)
        {
                name_ = имя;
        }

        /**********************************************************************

                Return the адрес of this Иерархия. This is typically
                attached when Отправкаing события в_ remote monitors.

        **********************************************************************/

        final ткст адрес ()
        {
                return адрес_;
        }

        /**********************************************************************

                Набор the адрес of this Иерархия. The адрес is attached
                used when Отправкаing события в_ remote monitors.

        **********************************************************************/

        final проц адрес (ткст адрес)
        {
                адрес_ = адрес;
        }

        /**********************************************************************

                Return the diagnostic контекст.  Useful for настройка an 
                override logging уровень.

        **********************************************************************/
        
        final Логгер.Контекст контекст ()
        {
        	return context_;
        }
        
        /**********************************************************************

                Набор the diagnostic контекст.  Not usually necessary, as a 
                default was создан.  Useful when you need в_ provопрe a 
                different implementation, such as a ThreadLocal variant.

        **********************************************************************/
        
        final проц контекст (Логгер.Контекст контекст)
        {
        	context_ = контекст;
        }
        
        /***********************************************************************
        
                Return the корень node.

        ***********************************************************************/

        final Логгер корень ()
        {
                return root_;
        }

        /***********************************************************************
        
                Return the экземпляр of a Логгер with the provопрed ярлык. If
                the экземпляр does not exist, it is создан at this время.

                Note that an пустой ярлык is consопрered illegal, and will be
                ignored.

        ***********************************************************************/

        final Логгер отыщи (ткст ярлык)
        {
                if (ярлык.length)
                    return инъекцируй (ярлык, (ткст имя)
                                          {return new Логгер (this, имя);});
                return пусто;
        }

        /***********************************************************************

                traverse the установи of configured loggers

        ***********************************************************************/

        final цел opApply (цел delegate(ref Логгер) дг)
        {
                цел ret;

                for (auto лог=корень; лог; лог = лог.следщ)
                     if ((ret = дг(лог)) != 0)
                          break;
                return ret;
        }

        /***********************************************************************
        
                Return the экземпляр of a Логгер with the provопрed ярлык. If
                the экземпляр does not exist, it is создан at this время.

        ***********************************************************************/

        private synchronized Логгер инъекцируй (ткст ярлык, Логгер delegate(ткст имя) дг)
        {
                auto имя = ярлык ~ ".";
                auto l = имя in loggers;

                if (l is пусто)
                   {
                   // создай a new logger
                   auto li = дг(имя);
                   l = &li;

                   // вставь преобр_в linked список
                   вставь (li);

                   // look for and исправь ветви
                   обнови (li, да);

                   // вставь преобр_в карта
                   loggers [имя] = li;
                   }
               
                return *l;
        }

        /***********************************************************************
        
                Loggers are maintained in a sorted linked-список. The order 
                is maintained such that the shortest имя is at the корень, 
                and the longest at the хвост.

                This is готово so that updateLoggers() will always have a
                known environment в_ manИПulate, making it much faster.

        ***********************************************************************/

        private проц вставь (Логгер l)
        {
                Логгер prev,
                       curr = корень;

                while (curr)
                      {
                      // вставь here if the new имя is shorter
                      if (l.имя.length < curr.имя.length)
                          if (prev is пусто)
                              throw new IllegalElementException ("неверная иерархия");
                          else                                 
                             {
                             l.следщ = prev.следщ;
                             prev.следщ = l;
                             return;
                             }
                      else
                         // найди best match for предок of new Запись
                         распространить (l, curr, да);

                      // remember where insertion point should be
                      prev = curr;  
                      curr = curr.следщ;  
                      }

                // добавь в_ хвост
                prev.следщ = l;
        }

        /***********************************************************************
        
                Propagate hierarchical changes across known loggers. 
                This включает changes in the иерархия itself, and в_
                the various settings of ветвь loggers with respect в_ 
                their предок(s).              

        ***********************************************************************/

        private проц обнови (Логгер изменён, бул force)
        {
                foreach (logger; this)
                         распространить (logger, изменён, force);
        }

        /***********************************************************************
        
                Propagate changes in the иерархия downward в_ ветвь Loggers.
                Note that while 'предок' and 'breakpoint' are always forced
                в_ обнови, the обнови of 'уровень' is selectable.

        ***********************************************************************/

        private проц распространить (Логгер logger, Логгер изменён, бул force)
        {
                // is the изменён экземпляр a better match for our предок?
                if (logger.близкийПотомок_ли (изменён))
                   {
                   // обнови предок (might actually be current предок)
                   logger.предок = изменён;

                   // if we don't have an explicit уровень установи, inherit it
                   // Be careful в_ avoопр recursion, or другой overhead
                   if (force)
                       logger.level_ = изменён.уровень;
                   }
        }
}



/*******************************************************************************

        Contains все information about a logging событие, and is passed around
        between methods once it есть been determined that the invoking logger
        is включен for вывод.

        Note that Событие instances are maintained in a freelist rather than
        being allocated each время, and they include a scratchpad area for
        EventLayout форматёрs в_ use.

*******************************************************************************/

package struct СобытиеЛога
{
        private ткст          msg_,
                                name_;
        private Время            time_;
        private Уровень           level_;
        private Иерархия       host_;

        /***********************************************************************
                
                Набор the various атрибуты of this событие.

        ***********************************************************************/

        проц установи (Иерархия хост, Уровень уровень, ткст сооб, ткст имя)
        {
                time_ = Журнал.время;
                level_ = уровень;
                host_ = хост;
                name_ = имя;
                msg_ = сооб;
        }

        /***********************************************************************
                
                Return the сообщение attached в_ this событие.

        ***********************************************************************/

        ткст вТкст ()
        {
                return msg_;
        }

        /***********************************************************************
                
                Return the имя of the logger which produced this событие

        ***********************************************************************/

        ткст имя ()
        {
                return name_;
        }

        /***********************************************************************
                
                Return the logger уровень of this событие.

        ***********************************************************************/

        Уровень уровень ()
        {
                return level_;
        }

        /***********************************************************************
                
                Return the иерархия where the событие was produced из_

        ***********************************************************************/

        Иерархия хост ()
        {
                return host_;
        }

        /***********************************************************************
                
                Return the время this событие was produced, relative в_ the 
                старт of this executable

        ***********************************************************************/

        ИнтервалВремени вринтервал ()
        {
                return time_ - Журнал.времяНачала;
        }

        /***********************************************************************
               
                Return the время this событие was produced relative в_ Epoch

        ***********************************************************************/

        Время время ()
        {
                return time_;
        }

        /***********************************************************************
                
                Return время when the executable пущен

        ***********************************************************************/

        Время пущен ()
        {
                return Журнал.времяНачала;
        }

        /***********************************************************************
                
                Return the logger уровень имя of this событие.

        ***********************************************************************/

        ткст имяУровня ()
        {
                return Журнал.ИменаУровней[level_];
        }

        /***********************************************************************
                
                Convert a время значение (in milliseconds) в_ аски

        ***********************************************************************/

        static ткст вМилли (ткст s, ИнтервалВремени время)
        {
                assert (s.length > 0);
                дол ms = время.миллисек;

                цел длин = s.length;
                do {
                   s[--длин] = cast(сим)(ms % 10 + '0');
                   ms /= 10;
                   } while (ms && длин);
                return s[длин..s.length];                
        }
}


/*******************************************************************************

        Base class for все Appenders. These objects are responsible for
        излейting messages sent в_ a particular logger. There may be ещё
        than one добавщик attached в_ any logger. The actual сообщение is
        constructed by другой class known as an EventLayout.
        
*******************************************************************************/

public class Добавщик
{
        typedef цел маска;

        private Добавщик        next_;
        private Выкладка          layout_;
        private static Выкладка   generic;

        /***********************************************************************

                Interface for все logging выкладка instances

                Implement this метод в_ perform the formatting of  
                сообщение контент.

        ***********************************************************************/

        interface Выкладка
        {
                проц форматируй (СобытиеЛога событие, т_мера delegate(проц[]) дг);
        }

        /***********************************************************************
                
                Return the маска used в_ опрentify this Добавщик. The маска
                is used в_ figure out whether an добавщик есть already been 
                invoked for a particular logger.

        ***********************************************************************/

        abstract маска маска ();

        /***********************************************************************
                
                Return the имя of this Добавщик.

        ***********************************************************************/

        abstract ткст имя ();
                
        /***********************************************************************
                
                Append a сообщение в_ the вывод.

        ***********************************************************************/

        abstract проц добавь (СобытиеЛога событие);

        /***********************************************************************
              
              Create an Добавщик and default its выкладка в_ LayoutSimple.  

        ***********************************************************************/

        this ()
        {
                layout_ = generic;
        }

        /***********************************************************************
              
              Create an Добавщик and default its выкладка в_ LayoutSimple.  

        ***********************************************************************/

        static this ()
        {
                generic = new ТаймерВыкладки;
        }

        /***********************************************************************
                
                Static метод в_ return a маска for опрentifying the Добавщик.
                Each Добавщик class should have a unique fingerprint so that
                we can figure out which ones have been invoked for a given
                событие. A bitmask is a simple an efficient way в_ do that.

        ***********************************************************************/

        protected маска регистрируй (ткст тэг)
        {
                static маска маска = 1;
                static маска[ткст] registry;

                маска* p = тэг in registry;
                if (p)
                    return *p;
                else
                   {
                   auto ret = маска;
                   registry [тэг] = маска;

                   if (маска < 0)
                       throw new ИсклНелегальногоАргумента ("too many unique registrations");

                   маска <<= 1;
                   return ret;
                   }
        }

        /***********************************************************************
                
                Набор the current выкладка в_ be that of the аргумент, or the
                generic выкладка where the аргумент is пусто

        ***********************************************************************/

        проц выкладка (Выкладка как)
        {
                layout_ = как ? как : generic;
        }

        /***********************************************************************
                
                Return the current Выкладка

        ***********************************************************************/

        Выкладка выкладка ()
        {
                return layout_;
        }

        /***********************************************************************
                
                Attach другой добавщик в_ this one

        ***********************************************************************/

        проц следщ (Добавщик добавщик)
        {
                next_ = добавщик;
        }

        /***********************************************************************
                
                Return the следщ добавщик in the список

        ***********************************************************************/

        Добавщик следщ ()
        {
                return next_;
        }

        /***********************************************************************
                
                Close this добавщик. This would be used for файл, СОКЕТs, 
                and such like.

        ***********************************************************************/

        проц закрой ()
        {
        }
}


/*******************************************************************************

        An добавщик that does nothing. This is useful for cutting and
        pasting, and for benchmarking the лог environment.

*******************************************************************************/

public class ДобНуль : Добавщик
{
        private маска mask_;

        /***********************************************************************
                
                Create with the given Выкладка

        ***********************************************************************/

        this (Выкладка как = пусто)
        {
                mask_ = регистрируй (имя);
                выкладка (как);
        }

        /***********************************************************************
                
                Возвращает фингерпринт для данного класса

        ***********************************************************************/

        final маска маска ()
        {
                return mask_;
        }

        /***********************************************************************
                
                Вернуть имя данного класса

        ***********************************************************************/

        final ткст имя ()
        {
                return this.classinfo.имя;
        }
                
        /***********************************************************************
                
                Append an событие в_ the вывод.
                 
        ***********************************************************************/

        final проц добавь (СобытиеЛога событие)
        {
                выкладка.форматируй (событие, (проц[]){return cast(т_мера) 0;});
        }
}


/*******************************************************************************

        Append в_ a configured ИПотокВывода

*******************************************************************************/

public class ДобПоток : Добавщик
{
        private маска            mask_;
        private бул            flush_;
        private ИПотокВывода    Поток_;

        /***********************************************************************
                
                Create with the given поток and выкладка

        ***********************************************************************/

        this (ИПотокВывода поток, бул слей = нет, Добавщик.Выкладка как = пусто)
        {
                assert (поток);

                mask_ = регистрируй (имя);
                Поток_ = поток;
                flush_ = слей;
                выкладка (как);
        }

        /***********************************************************************
                
                Возвращает фингерпринт для данного класса

        ***********************************************************************/

        final Маска маска ()
        {
                return mask_;
        }

        /***********************************************************************
                
                Вернуть имя данного класса

        ***********************************************************************/

        ткст имя ()
        {
                return this.classinfo.имя;
        }
                
        /***********************************************************************
               
                Append an событие в_ the вывод.
                 
        ***********************************************************************/

        final проц добавь (СобытиеЛога событие)
        {
                version(Win32)
                        const ткст Кс = "\r\n";
                   else
                       const ткст Кс = "\n";

                synchronized (Поток_)
                             {
                             выкладка.форматируй (событие, (проц[] контент){return Поток_.пиши(контент);});
                             Поток_.пиши (Кс);
                             if (flush_)
                                 Поток_.слей;
                             }
        }
}

/*******************************************************************************

        A simple выкладка comprised only of время(ms), уровень, имя, and сообщение

*******************************************************************************/

public class ТаймерВыкладки : Добавщик.Выкладка
{
        /***********************************************************************
                
                Subclasses should implement this метод в_ perform the
                formatting of the actual сообщение контент.

        ***********************************************************************/

        проц форматируй (СобытиеЛога событие, т_мера delegate(проц[]) дг)
        {
                сим[20] врем =void;

                дг (событие.вМилли (врем, событие.вринтервал));
                дг (" ");
//                дг (Нить.getThis.имя);
//                дг (" ");
                дг (событие.имяУровня);
                дг (событие.имя);
                дг (событие.хост.контекст.ярлык);
                дг (" - ");
                дг (событие.вТкст);
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Журнал)
{
        import io.Console;
 
        проц main()
        {
                Журнал.конфиг (Кош.поток);
                auto лог = Журнал.отыщи ("fu.bar");
                лог.уровень = лог.След;
                // traditional usage
                лог.след ("hello {}", "world");

                сим[100] буф;
                лог (лог.След, лог.форматируй(буф, "hello {}", "world"));

                // formatted вывод
/*                /
                auto форматируй = Журнал.форматируй;
                лог.инфо (форматируй ("blah{}", 1));

                // снимок
                auto snap = Журнал.снимок (лог, Уровень.Ошибка);
                snap.форматируй ("арг{}; ", 1);
                snap.форматируй ("арг{}; ", 2);
                //лог.след (snap.форматируй ("ошибка! арг{}", 3));
                snap.слей;
*/
        }
}