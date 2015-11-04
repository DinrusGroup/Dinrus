﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2005: начальное release
                        Mar 2009: выкиньed из_ локаль, и 
                                  преобразованый в_ a struct

        author:         John Chapman, Kris, mwarning

        Support for formatting дата/время значения, in a локаль-specific
        manner. See МестнДатаВремя.форматируй() for a descrИПtion on как 
        formatting is performed (below).

        Reference линки:
        ---
        http://www.opengroup.org/onlinepubs/007908799/xsh/strftime.html
        http://msdn.microsoft.com/en-us/library/system.globalization.datetimeformatinfo(VS.71).aspx
        ---

******************************************************************************/

module text.convert.DateTime;

private import  exception;

private import  time.WallClock;

private import  time.chrono.Calendar,
                time.chrono.Gregorian;

private import  Utf = text.convert.Utf;

private import  Целое = text.convert.Integer;

version (СРасширениями)
         private import text.convert.Extentions;

/******************************************************************************

        O/S specifics
                
******************************************************************************/

version (Windows)
         private import sys.Common;
else
{
        private import stringz;
        private import rt.core.stdc.posix.langinfo;
}

/******************************************************************************

        The default МестнДатаВремя экземпляр
                
******************************************************************************/

public МестнДатаВремя ДефДатаВремя;

static this()
{       
        ДефДатаВремя = МестнДатаВремя.создай;
version (СРасширениями)
        {
        Расширения8.добавь  (typeid(Время), &ДефДатаВремя.мост!(сим));
        Расширения16.добавь (typeid(Время), &ДефДатаВремя.мост!(шим));
        Расширения32.добавь (typeid(Время), &ДефДатаВремя.мост!(дим));
        }
}

/******************************************************************************

        How в_ форматируй локаль-specific дата/время вывод

******************************************************************************/

struct МестнДатаВремя
{       
        static ткст   rfc1123Pattern = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
        static ткст   sortableDateTimePattern = "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
        static ткст   universalSortableDateTimePattern = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'Z'";

        Календарь        назначенныйКалендарь;

        ткст          shortDatePattern,
                        shortTimePattern,
                        longDatePattern,
                        longTimePattern,
                        ПолнаяДатаTimePattern,
                        generalShortTimePattern,
                        generalLongTimePattern,
                        monthDayPattern,
                        yearMonthPattern;

        ткст          amDesignator,
                        pmDesignator;

        ткст          разделительВремени,
                        разделительДаты;

        ткст[]        dayNames,
                        monthNames,
                        abbreviatedDayNames,
                        abbreviatedMonthNames;

        /**********************************************************************

                Формат the given Время значение преобр_в the provопрed вывод, 
                using the specified выкладка. The выкладка can be a генерный
                variant or a custom one, where generics are indicated
                via a single character:
                
                <pre>
                "t" = 7:04
                "T" = 7:04:02 PM 
                "d" = 3/30/2009
                "D" = Понедельник, March 30, 2009
                "f" = Понедельник, March 30, 2009 7:04 PM
                "F" = Понедельник, March 30, 2009 7:04:02 PM
                "g" = 3/30/2009 7:04 PM
                "G" = 3/30/2009 7:04:02 PM
                "y"
                "Y" = March, 2009
                "r"
                "R" = Mon, 30 Mar 2009 19:04:02 GMT
                "s" = 2009-03-30T19:04:02
                "u" = 2009-03-30 19:04:02Z
                </pre>
        
                For the US локаль, these генерный layouts are expanded in the 
                following manner:
                
                <pre>
                "t" = "h:mm" 
                "T" = "h:mm:ss tt"
                "d" = "M/d/yyyy"  
                "D" = "dddd, MMMM d, yyyy" 
                "f" = "dddd, MMMM d, yyyy h:mm tt"
                "F" = "dddd, MMMM d, yyyy h:mm:ss tt"
                "g" = "M/d/yyyy h:mm tt"
                "G" = "M/d/yyyy h:mm:ss tt"
                "y"
                "Y" = "MMMM, yyyy"        
                "r"
                "R" = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'"
                "s" = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"      
                "u" = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'Z'"   
                </pre>

                Custom layouts are constructed using a combination of the 
                character codes indicated on the right, above. For example, 
                a выкладка of "dddd, dd MMM yyyy HH':'mm':'ss zzzz" will излей 
                something like this:
                ---
                Понедельник, 30 Mar 2009 19:04:02 -08:00
                ---

                Using these форматируй indicators with Выкладка (Стдвыв etc) is
                straightforward. Formatting целыйs, for example, is готово
                like so:
                ---
                Стдвыв.форматнс ("{:u}", 5);
                Стдвыв.форматнс ("{:b}", 5);
                Стдвыв.форматнс ("{:x}", 5);
                ---

                Formatting дата/время значения is similar, where the форматируй
                indicators are provопрed after the colon:
                ---
                Стдвыв.форматнс ("{:t}", Часы.сейчас);
                Стдвыв.форматнс ("{:D}", Часы.сейчас);
                Стдвыв.форматнс ("{:dddd, dd MMMM yyyy HH:mm}", Часы.сейчас);
                ---

        **********************************************************************/

        ткст форматируй (ткст вывод, Время датаВремя, ткст выкладка)
        {
                // default в_ general форматируй
                if (выкладка.length is 0)
                    выкладка = "G"; 

                // might be one of our shortcuts
                if (выкладка.length is 1) 
                    выкладка = разверниИзвестныйФормат (выкладка);
                
                auto рез=Результат(вывод);
                return форматируйОсобо (рез, датаВремя, выкладка);
        }

        /**********************************************************************

        **********************************************************************/

        T[] шФормат(T) (T[] вывод, Время датаВремя, T[] фмт)
        {
                static if (is (T == сим))
                           return форматируй (вывод, датаВремя, фмт);
                else
                   {
                   сим[128] tmp0 =void;
                   сим[128] tmp1 =void;
                   return Utf.изТкст8(форматируй(tmp0, датаВремя, Utf.вТкст(фмт, tmp1)), вывод);
                   }
        }

        /**********************************************************************

                Return a генерный English/US экземпляр

        **********************************************************************/

        static МестнДатаВремя* генерный ()
        {
                return &EngUS;
        }

        /**********************************************************************

                Return the назначено Календарь экземпляр, using Грегориан
                as the default

        **********************************************************************/

        Календарь календарь ()
        {
                if (назначенныйКалендарь is пусто)
                    назначенныйКалендарь = Грегориан.генерный;
                return назначенныйКалендарь;
        }

        /**********************************************************************

                Return a крат день имя 

        **********************************************************************/

        ткст сокращённоеИмяДня (Календарь.ДеньНедели деньНедели)
        {
                return abbreviatedDayNames [cast(цел) деньНедели];
        }

        /**********************************************************************

                Return a дол день имя

        **********************************************************************/

        ткст имяДня (Календарь.ДеньНедели деньНедели)
        {
                return dayNames [cast(цел) деньНедели];
        }
                       
        /**********************************************************************

                Return a крат месяц имя

        **********************************************************************/

        ткст сокращённоеИмяМесяца (цел месяц)
        {
                assert (месяц > 0 && месяц < 13);
                return abbreviatedMonthNames [месяц - 1];
        }

        /**********************************************************************

                Return a дол месяц имя

        **********************************************************************/

        ткст имяМесяца (цел месяц)
        {
                assert (месяц > 0 && месяц < 13);
                return monthNames [месяц - 1];
        }

version (Windows)
        {
        /**********************************************************************

                создай и наполни an экземпляр via O/S configuration
                for the текущ пользователь

        **********************************************************************/

        static МестнДатаВремя создай ()
        {       
                static ткст вТкст (ткст приёмн, LCID опр, LCTYPE тип)
                {
                        шим[256] wide =void;

                        auto длин = GetLocaleInfoW (опр, тип, пусто, 0);
                        if (длин && длин < wide.length)
                           {
                           GetLocaleInfoW (опр, тип, wide.ptr, wide.length);
                           длин = WideCharToMultiByte (CP_UTF8, 0, wide.ptr, длин-1,
                                                      cast(PCHAR)приёмн.ptr, приёмн.length, 
                                                      пусто, пусто);
                           return приёмн [0..длин].dup;
                           }
                        throw new Исключение ("ДатаВремя :: GetLocaleInfo неудачно");
                }

                МестнДатаВремя dt;
                сим[256] врем =void;
                auto lcid = LOCALE_USER_DEFAULT;

                for (auto i=LOCALE_SDAYNAME1; i <= LOCALE_SDAYNAME7; ++i)
                     dt.dayNames ~= вТкст (врем, lcid, i);

                for (auto i=LOCALE_SABBREVDAYNAME1; i <= LOCALE_SABBREVDAYNAME7; ++i)
                     dt.abbreviatedDayNames ~= вТкст (врем, lcid, i);

                for (auto i=LOCALE_SMONTHNAME1; i <= LOCALE_SMONTHNAME12; ++i)
                     dt.monthNames ~= вТкст (врем, lcid, i);

                for (auto i=LOCALE_SABBREVMONTHNAME1; i <= LOCALE_SABBREVMONTHNAME12; ++i)
                     dt.abbreviatedMonthNames ~= вТкст (врем, lcid, i);

                dt.разделительДаты    = вТкст (врем, lcid, LOCALE_SDATE);
                dt.разделительВремени    = вТкст (врем, lcid, LOCALE_STIME);
                dt.amDesignator     = вТкст (врем, lcid, LOCALE_S1159);
                dt.pmDesignator     = вТкст (врем, lcid, LOCALE_S2359);
                dt.longDatePattern  = вТкст (врем, lcid, LOCALE_SLONGDATE);
                dt.shortDatePattern = вТкст (врем, lcid, LOCALE_SSHORTDATE);
                dt.yearMonthPattern = вТкст (врем, lcid, LOCALE_SYEARMONTH);
                dt.longTimePattern  = вТкст (врем, lcid, LOCALE_STIMEFORMAT);
                         
                // synthesize a крат время
                auto s = dt.shortTimePattern = dt.longTimePattern;
                for (auto i=s.length; i--;)
                     if (s[i] is dt.разделительВремени[0])
                        {
                        dt.shortTimePattern = s[0..i];
                        break;
                        }

                dt.ПолнаяДатаTimePattern = dt.longDatePattern ~ " " ~ 
                                         dt.longTimePattern;
                dt.generalLongTimePattern = dt.shortDatePattern ~ " " ~ 
                                            dt.longTimePattern;
                dt.generalShortTimePattern = dt.shortDatePattern ~ " " ~ 
                                             dt.shortTimePattern;
                return dt;
        }
        }
else
        {
        /**********************************************************************

                создай и наполни an экземпляр via O/S configuration
                for the текущ пользователь

        **********************************************************************/

        static МестнДатаВремя создай ()
        {
                //выкинь разделитель
                static ткст откиньРазделитель(ткст стр, ткст def)
                {
                        for (auto i = 0; i < стр.length; ++i)
                            {
                            сим c = стр[i];
                            if ((c == '%') || (c == ' ') || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
                                continue;
                            return стр[i..i+1].dup;
                            }
                        return def;
                }

                static ткст дайТкст(nl_item опр, ткст def = пусто)
                {
                        сим* p = nl_langinfo(опр);
                        return p ? изТкст0(p).dup : def;
                }

                static ткст дайТкстФормата(nl_item опр, ткст def = пусто)
                {
                        ткст posix_str = дайТкст(опр, def);
                        return преобразуй(posix_str);
                }

                МестнДатаВремя dt;

                for (auto i = DAY_1; i <= DAY_7; ++i)
                     dt.dayNames ~= дайТкст (i);

                for (auto i = ABDAY_1; i <= ABDAY_7; ++i)
                     dt.abbreviatedDayNames ~= дайТкст (i);

                for (auto i = MON_1; i <= MON_12; ++i)
                     dt.monthNames ~= дайТкст (i);

                for (auto i = ABMON_1; i <= ABMON_12; ++i)
                     dt.abbreviatedMonthNames ~= дайТкст (i);

                dt.amDesignator = дайТкст (AM_STR, "AM");
                dt.pmDesignator = дайТкст (PM_STR, "PM");

                dt.longDatePattern = "dddd, MMMM d, yyyy"; //default
                dt.shortDatePattern = дайТкстФормата(D_FMT, "M/d/yyyy");

                dt.longTimePattern = дайТкстФормата(T_FMT, "h:mm:ss tt");
                dt.shortTimePattern = "h:mm"; //default

                dt.yearMonthPattern = "MMMM, yyyy"; //no posix equivalent?
                dt.ПолнаяДатаTimePattern = дайТкстФормата(D_T_FMT, "dddd, MMMM d, yyyy h:mm:ss tt");

                dt.разделительДаты = откиньРазделитель(dt.shortDatePattern, "/");
                dt.разделительВремени = откиньРазделитель(dt.longTimePattern, ":");

                //выкинь shortTimePattern из_ longTimePattern
                for (auto i = dt.longTimePattern.length; i--;) 
                    {
                    if (dt.longTimePattern[i] == dt.разделительВремени[$-1])
                       {
                       dt.shortTimePattern = dt.longTimePattern[0..i];
                       break;
                       }
                    }

                //выкинь longDatePattern из_ ПолнаяДатаTimePattern
                auto поз = dt.ПолнаяДатаTimePattern.length - dt.longTimePattern.length - 2;
                if (поз < dt.ПолнаяДатаTimePattern.length)
                    dt.longDatePattern = dt.ПолнаяДатаTimePattern[0..поз];

                dt.ПолнаяДатаTimePattern = dt.longDatePattern ~ " " ~ dt.longTimePattern;
                dt.generalLongTimePattern = dt.shortDatePattern ~ " " ~  dt.longTimePattern;
                dt.generalShortTimePattern = dt.shortDatePattern ~ " " ~  dt.shortTimePattern;

                return dt;
        }

        /**********************************************************************

                Convert POSIX дата время форматируй в_ .NET форматируй syntax.

        **********************************************************************/

        private static ткст преобразуй(ткст фмт)
        {
                сим[32] возвр;
                т_мера длин;

                проц помести(ткст стр)
                {
                        assert((длин+стр.length) <= возвр.length);
                        возвр[длин..длин+стр.length] = стр;
                        длин += стр.length;
                }

                for (auto i = 0; i < фмт.length; ++i)
                    {
                    сим c = фмт[i];

                    if (c != '%')
                       {
                        assert((длин+1) <= возвр.length);
                        возвр[длин] = c;
                        длин += 1;
                       continue;
                       }

                    i++;
                    if (i >= фмт.length)
                        break;

                    c = фмт[i];
                    switch (c)
                           {
                           case 'a': //локаль's abbreviated weekday имя. 
                                помести("ddd"); //The abbreviated имя of the день of the week,
                                break;

                           case 'A': //локаль's full weekday имя.
                                помести("dddd");
                                break;

                           case 'b': //локаль's abbreviated месяц имя
                                помести("MMM");
                                break;

                           case 'B': //локаль's full месяц имя
                                помести("MMMM");
                                break;

                           case 'd': //день of the месяц as a decimal число [01,31]
                                помести("dd"); // The день of the месяц. Single-цифра
                                //дни will have a leading zero.
                                break;

                           case 'D': //same as %m/%d/%y. 
                                помести("MM/dd/yy");
                                break;

                           case 'e': //день of the месяц as a decimal число [1,31];
                                //a single цифра is preceded by a пространство
                                помести("d"); //The день of the месяц. Single-цифра дни
                                //will not have a leading zero.
                                break;

                           case 'h': //same as %b. 
                                помести("MMM");
                                break;

                           case 'H':
                                //час (24-час clock) as a decimal число [00,23]
                                помести("HH"); //The час in a 24-час clock. Single-цифра
                                //часы will have a leading zero.
                                break;

                           case 'I': //the час (12-час clock) as a decimal число [01,12]
                                помести("hh"); //The час in a 12-час clock.
                                //Single-цифра часы will have a leading zero.
                                break;

                           case 'm': //месяц as a decimal число [01,12]
                                помести("MM"); //The numeric месяц. Single-цифра
                                //месяцы will have a leading zero.
                                break;

                           case 'M': //минута as a decimal число [00,59]
                                помести("mm"); //The минута. Single-цифра минуты
                                //will have a leading zero.
                                break;

                           case 'n': //нс character
                                помести("\n");
                                break;

                           case 'p': //локаль's equivalent of either a.m. or p.m
                                помести("tt");
                                break;

                           case 'r': //время in a.m. и p.m. notation;
                                //equivalent в_ %I:%M:%S %p.
                                помести("hh:mm:ss tt");
                                break;

                           case 'R': //время in 24 час notation (%H:%M)
                                помести("HH:mm");
                                break;

                           case 'S': //секунда as a decimal число [00,61]
                                помести("ss"); //The секунда. Single-цифра сек
                                //will have a leading zero.
                                break;

                           case 't': //tab character.
                                помести("\t");
                                break;

                           case 'T': //equivalent в_ (%H:%M:%S)
                                помести("HH:mm:ss");
                                break;

                           case 'u': //weekday as a decimal число [1,7],
                                //with 1 representing Понедельник
                           case 'U': //week число of the год
                                //(Воскресенье as the первый день of the week) as a decimal число [00,53]
                           case 'V': //week число of the год
                                //(Понедельник as the первый день of the week) as a decimal число [01,53].
                                //If the week containing 1 January имеется four or ещё дни
                                //in the new год, then it is consопрered week 1.
                                //Otherwise, it is the последний week of the previous год, и the следщ week is week 1. 
                           case 'w': //weekday as a decimal число [0,6], with 0 representing Воскресенье
                           case 'W': //week число of the год (Понедельник as the первый день of the week)
                                //as a decimal число [00,53].
                                //все дни in a new год preceding the первый Понедельник
                                //are consопрered в_ be in week 0. 
                           case 'x': //локаль's appropriate дата representation
                           case 'X': //локаль's appropriate время representation
                           case 'c': //локаль's appropriate дата и время representation
                           case 'C': //century число (the год divопрed by 100 и
                                //truncated в_ an целое) as a decimal число [00-99]
                           case 'j': //день of the год as a decimal число [001,366]
                                assert(0);
                                break;

                           case 'y': //год without century as a decimal число [00,99]
                                помести("yy"); // The год without the century. If the год without
                                //the century is less than 10, the год is displayed with a leading zero.
                                break;

                           case 'Y': //год with century as a decimal число
                                помести("yyyy"); //The год in four цифры, включая the century.
                                break;

                           case 'Z': //timezone имя or abbreviation,
                                //or by no байты if no timezone information есть_ли
                                //assert(0);
                                break;

                           case '%':
                                помести("%");
                                break;

                           default:
                                assert(0);
                           }
                    }
                return возвр[0..длин].dup;
        }
        }

        /**********************************************************************

        **********************************************************************/

        private ткст разверниИзвестныйФормат (ткст формат)
        {
                ткст f;

                switch (формат[0])
                       {
                       case 'd':
                            f = shortDatePattern;
                            break;
                       case 'D':
                            f = longDatePattern;
                            break;
                       case 'f':
                            f = longDatePattern ~ " " ~ shortTimePattern;
                            break;
                       case 'F':
                            f = ПолнаяДатаTimePattern;
                            break;
                       case 'g':
                            f = generalShortTimePattern;
                            break;
                       case 'G':
                            f = generalLongTimePattern;
                            break;
                       case 'r':
                       case 'R':
                            f = rfc1123Pattern;
                            break;
                       case 's':
                            f = sortableDateTimePattern;
                            break;
                       case 'u':
                            f = universalSortableDateTimePattern;
                            break;
                       case 't':
                            f = shortTimePattern;
                            break;
                       case 'T':
                            f = longTimePattern;
                            break;
                       case 'y':
                       case 'Y':
                            f = yearMonthPattern;
                            break;
                       default:
                           return ("'{время в формате непригодно}'");
                       }
                return f;
        }

        /**********************************************************************

        **********************************************************************/

        private ткст форматируйОсобо (ref Результат результат, Время датаВремя, ткст форматируй)
        {
                бцел            длин,
                                деньгода,
                                деньнед,
                                эра;        
                бцел            день,
                                год,
                                месяц;
                цел             индекс;
                сим[10]        врем =void;
                auto            время = датаВремя.время;

                // выкинь дата components
                календарь.разбей (датаВремя, год, месяц, день, деньгода, деньнед, эра);

                // смети форматируй specifiers ...
                while (индекс < форматируй.length)
                      {
                      сим c = форматируй[индекс];
                      
                      switch (c)
                             {
                             // день
                             case 'd':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  if (длин <= 2)
                                      результат ~= форматируйЦел (врем, день, длин);
                                  else
                                     результат ~= форматируйДеньНедели (cast(Календарь.ДеньНедели) деньнед, длин);
                                  break;

                             // миллисек
                            case 'f':
                                длин = повториРазбор (форматируй, индекс, c);
                                auto num = Целое.itoa (врем, время.миллисек);
                                if(длин > num.length)
                                {
                                    результат ~= num;
                                    
                                    // добавь '0's
                                    static сим[8] zeros = '0';
                                    auto zc = длин - num.length;
                                    zc = (zc > zeros.length) ? zeros.length : zc;
                                    результат ~= zeros[0..zc];
                                }
                                else
                                    результат ~= num[0..длин];
                                break;

                             // миллисек, no trailing zeros
                            case 'F':
                                длин = повториРазбор (форматируй, индекс, c);
                                auto num = Целое.itoa (врем, время.миллисек);
                                auto индкс = (длин < num.length) ? длин : num.length;

                                // откинь '0's
                                while(индкс && num[индкс-1] is '0')
                                    --индкс;

                                результат ~= num[0..индкс];
                                break;

                             // месяц
                             case 'M':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  if (длин <= 2)
                                      результат ~= форматируйЦел (врем, месяц, длин);
                                  else
                                     результат ~= форматируйМесяц (месяц, длин);
                                  break;

                             // год
                             case 'y':  
                                  длин = повториРазбор (форматируй, индекс, c);

                                  // Two-цифра годы for Japanese
                                  if (календарь.опр is календарь.ЯПОНСКИЙ)
                                      результат ~= форматируйЦел (врем, год, 2);
                                  else
                                     {
                                     if (длин <= 2)
                                         результат ~= форматируйЦел (врем, год % 100, длин);
                                     else
                                        результат ~= форматируйЦел (врем, год, длин);
                                     }
                                  break;

                             // час (12-час clock)
                             case 'h':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  цел час = время.часы % 12;
                                  if (час is 0)
                                      час = 12;
                                  результат ~= форматируйЦел (врем, час, длин);
                                  break;

                             // час (24-час clock)
                             case 'H':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  результат ~= форматируйЦел (врем, время.часы, длин);
                                  break;

                             // минута
                             case 'm':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  результат ~= форматируйЦел (врем, время.минуты, длин);
                                  break;

                             // секунда
                             case 's':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  результат ~= форматируйЦел (врем, время.сек, длин);
                                  break;

                             // AM/PM
                             case 't':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  if (длин is 1)
                                     {
                                     if (время.часы < 12)
                                        {
                                        if (amDesignator.length != 0)
                                            результат ~= amDesignator[0];
                                        }
                                     else
                                        {
                                        if (pmDesignator.length != 0)
                                            результат ~= pmDesignator[0];
                                        }
                                     }
                                  else
                                     результат ~= (время.часы < 12) ? amDesignator : pmDesignator;
                                  break;

                             // timezone смещение
                             case 'z':  
                                  длин = повториРазбор (форматируй, индекс, c);
                                  auto минуты = cast(цел) (Куранты.зона.минуты);
                                  if (минуты < 0)
                                     {
                                     минуты = -минуты;
                                     результат ~= '-';
                                     }
                                  else
                                     результат ~= '+';
                                  цел часы = минуты / 60;
                                  минуты %= 60;

                                  if (длин is 1)
                                      результат ~= форматируйЦел (врем, часы, 1);
                                  else
                                     if (длин is 2)
                                         результат ~= форматируйЦел (врем, часы, 2);
                                     else
                                        {
                                        результат ~= форматируйЦел (врем, часы, 2);
                                        результат ~= форматируйЦел (врем, минуты, 2);
                                        }
                                  break;

                             // время разделитель
                             case ':':  
                                  длин = 1;
                                  результат ~= разделительВремени;
                                  break;

                             // дата разделитель
                             case '/':  
                                  длин = 1;
                                  результат ~= разделительДаты;
                                  break;

                             // ткст literal
                             case '\"':  
                             case '\'':  
                                  длин = разборКавычек (результат, форматируй, индекс);
                                  break;

                             // другой
                             default:
                                 длин = 1;
                                 результат ~= c;
                                 break;
                             }
                      индекс += длин;
                      }
                return результат.получи;
        }

        /**********************************************************************

        **********************************************************************/

        private ткст форматируйМесяц (цел месяц, цел rpt)
        {
                if (rpt is 3)
                    return сокращённоеИмяМесяца (месяц);
                return имяМесяца (месяц);
        }

        /**********************************************************************

        **********************************************************************/

        private ткст форматируйДеньНедели (Календарь.ДеньНедели деньНедели, цел rpt)
        {
                if (rpt is 3)
                    return сокращённоеИмяДня (деньНедели);
                return имяДня (деньНедели);
        }

        /**********************************************************************

        **********************************************************************/

        private T[] мост(T) (T[] результат, ук арг, T[] форматируй)
        {
                return шФормат (результат, *cast(Время*) арг, форматируй);
        }

        /**********************************************************************

        **********************************************************************/

        private static цел повториРазбор(ткст форматируй, цел поз, сим c)
        {
                цел n = поз + 1;
                while (n < форматируй.length && форматируй[n] is c)
                       n++;
                return n - поз;
        }

        /**********************************************************************

        **********************************************************************/

        private static ткст форматируйЦел (ткст врем, цел v, цел minimum)
        {
                auto num = Целое.itoa (врем, v);
                if ((minimum -= num.length) > 0)
                   {
                   auto p = врем.ptr + врем.length - num.length;
                   while (minimum--)
                          *--p = '0';
                   num = врем [p-врем.ptr .. $];
                   }
                return num;
        }

        /**********************************************************************

        **********************************************************************/

        private static цел разборКавычек (ref Результат результат, ткст форматируй, цел поз)
        {
                цел старт = поз;
                сим chQuote = форматируй[поз++];
                бул найдено;
                while (поз < форматируй.length)
                      {
                      сим c = форматируй[поз++];
                      if (c is chQuote)
                         {
                         найдено = да;
                         break;
                         }
                      else
                         if (c is '\\')
                            { // escaped
                            if (поз < форматируй.length)
                                результат ~= форматируй[поз++];
                            }
                         else
                            результат ~= c;
                      }
                return поз - старт;
        }
}

/******************************************************************************
        
        An english/usa локаль
        Used as генерный МестнДатаВремя.

******************************************************************************/

private МестнДатаВремя EngUS = 
{
        shortDatePattern                : "M/d/yyyy",
        shortTimePattern                : "h:mm",       
        longDatePattern                 : "dddd, MMMM d, yyyy",
        longTimePattern                 : "h:mm:ss tt",        
        ПолнаяДатаTimePattern             : "dddd, MMMM d, yyyy h:mm:ss tt",
        generalShortTimePattern         : "M/d/yyyy h:mm",
        generalLongTimePattern          : "M/d/yyyy h:mm:ss tt",
        monthDayPattern                 : "MMMM d",
        yearMonthPattern                : "MMMM, yyyy",
        amDesignator                    : "AM",
        pmDesignator                    : "PM",
        разделительВремени                   : ":",
        разделительДаты                   : "/",
        dayNames                        : ["Воскресенье", "Понедельник", "Вторник", "Среда", 
                                           "Четверг", "Пятница", "Суббота"],
        monthNames                      : ["January", "February", "March", "April", 
                                           "May", "June", "July", "August", "September", 
                                           "October" "November", "December"],
        abbreviatedDayNames             : ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],    
        abbreviatedMonthNames           : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                                           "Jul", "Aug", "Sep", "Oct" "Nov", "Dec"],
};


/******************************************************************************

******************************************************************************/

private struct Результат
{
        private бцел    индекс;
        private ткст  target_;

        /**********************************************************************

        **********************************************************************/

        private static Результат opCall (ткст мишень)
        {
                Результат результат;

                результат.target_ = мишень;
                return результат;
        }

        /**********************************************************************

        **********************************************************************/

        private проц opCatAssign (ткст rhs)
        {
                auto конец = индекс + rhs.length;
                assert (конец < target_.length);

                target_[индекс .. конец] = rhs;
                индекс = конец;
        }

        /**********************************************************************

        **********************************************************************/

        private проц opCatAssign (сим rhs)
        {
                assert (индекс < target_.length);
                target_[индекс++] = rhs;
        }

        /**********************************************************************

        **********************************************************************/

        private ткст получи ()
        {
                return target_[0 .. индекс];
        }
}

/******************************************************************************

******************************************************************************/

debug (ДатаВремя)
{
        import io.Stdout;

        проц main()
        {
                сим[100] врем;
                auto время = Куранты.сейчас;
                auto локаль = МестнДатаВремя.создай;

                Стдвыв.форматнс ("d: {}", локаль.форматируй (врем, время, "d"));
                Стдвыв.форматнс ("D: {}", локаль.форматируй (врем, время, "D"));
                Стдвыв.форматнс ("f: {}", локаль.форматируй (врем, время, "f"));
                Стдвыв.форматнс ("F: {}", локаль.форматируй (врем, время, "F"));
                Стдвыв.форматнс ("g: {}", локаль.форматируй (врем, время, "g"));
                Стдвыв.форматнс ("G: {}", локаль.форматируй (врем, время, "G"));
                Стдвыв.форматнс ("r: {}", локаль.форматируй (врем, время, "r"));
                Стдвыв.форматнс ("s: {}", локаль.форматируй (врем, время, "s"));
                Стдвыв.форматнс ("t: {}", локаль.форматируй (врем, время, "t"));
                Стдвыв.форматнс ("T: {}", локаль.форматируй (врем, время, "T"));
                Стдвыв.форматнс ("y: {}", локаль.форматируй (врем, время, "y"));
                Стдвыв.форматнс ("u: {}", локаль.форматируй (врем, время, "u"));
                Стдвыв.форматнс ("@: {}", локаль.форматируй (врем, время, "@"));
                Стдвыв.форматнс ("{}", локаль.генерный.форматируй (врем, время, "ddd, dd MMM yyyy HH':'mm':'ss zzzz"));
        }
}
