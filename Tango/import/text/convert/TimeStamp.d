﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: May 2005      
      
        author:         Kris

        Converts between исконный и текст representations of HTTP время
        значения. Internally, время is represented as UTC with an эпоха 
        fixed at Jan 1st 1970. The текст representation is formatted in
        accordance with RFC 1123, и the парсер will прими one of 
        RFC 1123, RFC 850, or asctime форматы.

        See http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html for
        further detail.

        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import TimeStamp = text.convert.TimeStamp;

        auto t = TimeStamp.разбор ("Sun, 06 Nov 1994 08:49:37 GMT");
        ---
        
*******************************************************************************/

module text.convert.TimeStamp;

private import time.Time;

private import exception;

private import Util = text.Util;

private import time.chrono.Gregorian;

private import Целое = text.convert.Integer;

/******************************************************************************

        Parse provопрed ввод и return a UTC эпоха время. An исключение
        is raised where the provопрed ткст is not fully разобрано.

******************************************************************************/

бдол воВремя(T) (T[] ист)
{
        бцел длин;

        auto x = разбор (ист, &длин);
        if (длин < ист.length)
            throw new ИсклНелегальногоАргумента ("неизвестное время форматируй: "~ист);
        return x;
}

/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

ткст вТкст (Время время)
{
        сим[32] врем =void;
        
        return форматируй (врем, время).dup;
}
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

шим[] вТкст16 (Время время)
{
        шим[32] врем =void;
        
        return форматируй (врем, время).dup;
}
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

дим[] вТкст32 (Время время)
{
        дим[32] врем =void;
        
        return форматируй (врем, время).dup;
}
               
/******************************************************************************

        RFC1123 formatted время

        Converts в_ the форматируй "Sun, 06 Nov 1994 08:49:37 GMT", и
        returns a populated срез of the provопрed буфер. Note that
        RFC1123 форматируй is always in абсолютный GMT время, и a thirty-
        элемент буфер is sufficient for the produced вывод

        Throws an исключение where the supplied время is не_годится

******************************************************************************/

T[] форматируй(T, U=Время) (T[] вывод, U t)
{return форматируй!(T)(вывод, cast(Время) t);}

T[] форматируй(T) (T[] вывод, Время t)
{
        static T[][] Месяцы = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        static T[][] Дни   = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

        T[] преобразуй (T[] врем, дол i)
        {
                return Целое.форматёр!(T) (врем, i, 'u', 0, 8);
        }

        assert (вывод.length >= 29);
        if (t is t.макс)
            throw new ИсклНелегальногоАргумента ("TimeStamp.форматируй :: не_годится Время аргумент");

        // преобразуй время в_ field значения
        auto время = t.время;
        auto дата = Грегориан.генерный.вДату (t);

        // use the featherweight форматёр ...
        T[14] врем =void;
        return Util.выкладка (вывод, cast(T[])"%0, %1 %2 %3 %4:%5:%6 GMT", 
                            Дни[дата.деньнед],
                            преобразуй (врем[0..2], дата.день),
                            Месяцы[дата.месяц-1],
                            преобразуй (врем[2..6], дата.год),
                            преобразуй (врем[6..8], время.часы),
                            преобразуй (врем[8..10], время.минуты),
                            преобразуй (врем[10..12], время.сек)
                           );
}


/******************************************************************************

        ISO-8601 форматируй :: "2006-01-31T14:49:30Z"

        Throws an исключение where the supplied время is не_годится

******************************************************************************/

T[] format8601(T, U=Время) (T[] вывод, U t)
{return форматируй!(T)(вывод, cast(Время) t);}

T[] format8601(T) (T[] вывод, Время t)
{
        T[] преобразуй (T[] врем, дол i)
        {
                return Целое.форматёр!(T) (врем, i, 'u', 0, 8);
        }


        assert (вывод.length >= 29);
        if (t is t.макс)
            throw new ИсклНелегальногоАргумента ("TimeStamp.форматируй :: не_годится Время аргумент");

        // преобразуй время в_ field значения
        auto время = t.время;
        auto дата = Грегориан.генерный.вДату (t);

        // use the featherweight форматёр ...
        T[20] врем =void;
        return Util.выкладка (вывод, cast(T[]) "%0-%1-%2T%3%:%4:%5Z", 
                            преобразуй (врем[0..4], дата.год),
                            преобразуй (врем[4..6], дата.месяц),
                            преобразуй (врем[6..8], дата.день),
                            преобразуй (врем[8..10], время.часы),
                            преобразуй (врем[10..12], время.минуты),
                            преобразуй (врем[12..14], время.сек)
                           );
}

/******************************************************************************

      Parse provопрed ввод и return a UTC эпоха время. A return значение 
      of Время.макс (or нет, respectively) indicated a разбор-failure.

      An опция is provопрed в_ return the счёт of characters разобрано - 
      an unchanged значение here also indicates не_годится ввод.

******************************************************************************/

Время разбор(T) (T[] ист, бцел* ate = пусто)
{
        т_мера длин;
        Время   значение;

        if ((длин = rfc1123 (ист, значение)) > 0 || 
            (длин = rfc850  (ист, значение)) > 0 || 
            (длин = iso8601  (ист, значение)) > 0 || 
            (длин = dostime  (ист, значение)) > 0 || 
            (длин = asctime (ист, значение)) > 0)
           {
           if (ate)
               *ate = длин;
           return значение;
           }
        return Время.макс;
}


/******************************************************************************

      Parse provопрed ввод и return a UTC эпоха время. A return значение 
      of Время.макс (or нет, respectively) indicated a разбор-failure.

      An опция is provопрed в_ return the счёт of characters разобрано - 
      an unchanged значение here also indicates не_годится ввод.

******************************************************************************/

бул разбор(T) (T[] ист, ref ВремяДня tod, ref Дата дата, бцел* ate = пусто)
{
        т_мера длин;
    
        if ((длин = rfc1123 (ист, tod, дата)) > 0 || 
           (длин = rfc850   (ист, tod, дата)) > 0 || 
           (длин = iso8601  (ист, tod, дата)) > 0 || 
           (длин = dostime  (ист, tod, дата)) > 0 || 
           (длин = asctime (ист, tod, дата)) > 0)
           {
           if (ate)
               *ate = длин;
           return да;
           }
        return нет;
}

/******************************************************************************

        RFC 822, updated by RFC 1123 :: "Sun, 06 Nov 1994 08:49:37 GMT"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера rfc1123(T) (T[] ист, ref Время значение)
{
        ВремяДня tod;
        Дата      дата;

        auto r = rfc1123!(T)(ист, tod, дата);
        if (r)   
            значение = Грегориан.генерный.воВремя(дата, tod);
        return r;
}


/******************************************************************************

        RFC 822, updated by RFC 1123 :: "Sun, 06 Nov 1994 08:49:37 GMT"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера rfc1123(T) (T[] ист, ref ВремяДня tod, ref Дата дата)
{
        T* p = ист.ptr;
        T* e = p + ист.length;

        бул dt (ref T* p)
        {
                return ((дата.день = парсируйЦел(p, e)) > 0  &&
                         *p++ == ' '                     &&
                        (дата.месяц = разбериМесяц(p)) > 0 &&
                         *p++ == ' '                     &&
                        (дата.год = парсируйЦел(p, e)) > 0);
        }

        if (разбериКороткийДень(p) >= 0 &&
            *p++ == ','           &&
            *p++ == ' '           &&
            dt (p)                &&
            *p++ == ' '           &&
            время (tod, p, e)      &&
            *p++ == ' '           &&
            p[0..3] == "GMT")
            {
            return (p+3) - ист.ptr;
            }
        return 0;
}


/******************************************************************************

        RFC 850, obsoleted by RFC 1036 :: "Воскресенье, 06-Nov-94 08:49:37 GMT"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера rfc850(T) (T[] ист, ref Время значение)
{
        ВремяДня tod;
        Дата      дата;

        auto r = rfc850!(T)(ист, tod, дата);
        if (r)
            значение = Грегориан.генерный.воВремя (дата, tod);
        return r;
}

/******************************************************************************

        RFC 850, obsoleted by RFC 1036 :: "Воскресенье, 06-Nov-94 08:49:37 GMT"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера rfc850(T) (T[] ист, ref ВремяДня tod, ref Дата дата)
{
        T* p = ист.ptr;
        T* e = p + ист.length;

        бул dt (ref T* p)
        {
                return ((дата.день = парсируйЦел(p, e)) > 0  &&
                         *p++ == '-'                     &&
                        (дата.месяц = разбериМесяц(p)) > 0 &&
                         *p++ == '-'                     &&
                        (дата.год = парсируйЦел(p, e)) > 0);
        }

        if (разбериПолныйДень(p) >= 0 &&
            *p++ == ','          &&
            *p++ == ' '          &&
            dt (p)               &&
            *p++ == ' '          &&
            время (tod, p, e)     &&
            *p++ == ' '          &&
            p[0..3] == "GMT")
            {
            if (дата.год < 70)
                дата.год += 2000;
            else
               if (дата.год < 100)
                   дата.год += 1900;

            return (p+3) - ист.ptr;
            }
        return 0;
}


/******************************************************************************

        ANSI C's asctime() форматируй :: "Sun Nov 6 08:49:37 1994"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера asctime(T) (T[] ист, ref Время значение)
{
        ВремяДня tod;
        Дата      дата;
    
        auto r = asctime!(T)(ист, tod, дата);
        if (r)
            значение = Грегориан.генерный.воВремя (дата, tod);
        return r;
}

/******************************************************************************

        ANSI C's asctime() форматируй :: "Sun Nov 6 08:49:37 1994"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера asctime(T) (T[] ист, ref ВремяДня tod, ref Дата дата)
{
        T* p = ист.ptr;
        T* e = p + ист.length;

        бул dt (ref T* p)
        {
                return ((дата.месяц = разбериМесяц(p)) > 0  &&
                         *p++ == ' '                      &&
                        ((дата.день = парсируйЦел(p, e)) > 0  ||
                        (*p++ == ' '                      &&
                        (дата.день = парсируйЦел(p, e)) > 0)));
        }

        if (разбериКороткийДень(p) >= 0 &&
            *p++ == ' '           &&
            dt (p)                &&
            *p++ == ' '           &&
            время (tod, p, e)      &&
            *p++ == ' '           &&
            (дата.год = парсируйЦел (p, e)) > 0)
            {
            return p - ист.ptr;
            }
        return 0;
}

/******************************************************************************

        DOS время форматируй :: "12-31-06 08:49AM"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера dostime(T) (T[] ист, ref Время значение)
{
        ВремяДня tod;
        Дата      дата;
    
        auto r = dostime!(T)(ист, tod, дата);
        if (r)
            значение = Грегориан.генерный.воВремя(дата, tod);
        return r;
}


/******************************************************************************

        DOS время форматируй :: "12-31-06 08:49AM"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

******************************************************************************/

т_мера dostime(T) (T[] ист, ref ВремяДня tod, ref Дата дата)
{
        T* p = ист.ptr;
        T* e = p + ист.length;

        бул dt (ref T* p)
        {
                return ((дата.месяц = парсируйЦел(p, e)) > 0 &&
                         *p++ == '-'                      &&
                        ((дата.день = парсируйЦел(p, e)) > 0  &&
                        (*p++ == '-'                      &&
                        (дата.год = парсируйЦел(p, e)) > 0)));
        }

        if (dt(p) >= 0                         &&
            *p++ == ' '                        &&
            (tod.часы = парсируйЦел(p, e)) > 0   &&
            *p++ == ':'                        &&
            (tod.минуты = парсируйЦел(p, e)) > 0 &&
            (*p == 'A' || *p == 'P'))
            {
            if (*p is 'P')
                tod.часы += 12;
            
            if (дата.год < 70)
                дата.год += 2000;
            else
               if (дата.год < 100)
                   дата.год += 1900;
            
            return (p+2) - ист.ptr;
            }
        return 0;
}

/******************************************************************************

        ISO-8601 форматируй :: "2006-01-31 14:49:30,001"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

        Quote из_ http://en.wikИПedia.org/wiki/ISO_8601 (2009-09-01):
        "Decimal fractions may also be добавьed в_ any of the three время элементы.
        A decimal point, either a comma or a dot (without any preference as
        stated most recently in resolution 10 of the 22nd General Conference
        CGPM in 2003), is использован as a разделитель between the время элемент и
        its дробь."

******************************************************************************/

т_мера iso8601(T) (T[] ист, ref Время значение)
{
        ВремяДня tod;
        Дата      дата;

        цел r = iso8601!(T)(ист, tod, дата);
        if (r)   
            значение = Грегориан.генерный.воВремя(дата, tod);
        return r;
}

/******************************************************************************

        ISO-8601 форматируй :: "2006-01-31 14:49:30,001"

        Returns the число of элементы consumed by the разбор; zero if
        the разбор неудачно

        Quote из_ http://en.wikИПedia.org/wiki/ISO_8601 (2009-09-01):
        "Decimal fractions may also be добавьed в_ any of the three время элементы.
        A decimal point, either a comma or a dot (without any preference as
        stated most recently in resolution 10 of the 22nd General Conference
        CGPM in 2003), is использован as a разделитель between the время элемент и
        its дробь."

******************************************************************************/

т_мера iso8601(T) (T[] ист, ref ВремяДня tod, ref Дата дата)
{
        T* p = ист.ptr;
        T* e = p + ист.length;

        бул dt (ref T* p)
        {
                return ((дата.год = парсируйЦел(p, e)) > 0   &&
                         *p++ == '-'                       &&
                        ((дата.месяц = парсируйЦел(p, e)) > 0 &&
                        (*p++ == '-'                       &&
                        (дата.день = парсируйЦел(p, e)) > 0)));
        }

        if (dt(p) >= 0       &&
            *p++ == ' '      &&
            время (tod, p, e))
            {
            // Are there chars left? If да, разбор миллисек. If no, миллисек = 0.
            if (p - ист.ptr) {
                // проверь дробь разделитель
                T frac_sep = *p++;
                if (frac_sep is ',' || frac_sep is '.')
                    // разделитель is ok: разбор миллисек
                    tod.миллисек = парсируйЦел (p, e);
                else
                    // wrong разделитель: ошибка 
                    return 0;
            } else
                tod.миллисек = 0;
            
            return p - ист.ptr;
            }
        return 0;
}


/******************************************************************************

        Parse a время field

******************************************************************************/

private бул время(T) (ref ВремяДня время, ref T* p, T* e)
{
        return ((время.часы = парсируйЦел(p, e)) >= 0   &&
                 *p++ == ':'                         &&
                (время.минуты = парсируйЦел(p, e)) >= 0 &&
                 *p++ == ':'                         &&
                (время.сек = парсируйЦел(p, e)) >= 0);
}


/******************************************************************************

        Match a месяц из_ the ввод

******************************************************************************/

private цел разбериМесяц(T) (ref T* p)
{
        цел месяц;

        switch (p[0..3])
               {
               case "Jan":
                    месяц = 1;
                    break; 
               case "Feb":
                    месяц = 2;
                    break; 
               case "Mar":
                    месяц = 3;
                    break; 
               case "Apr":
                    месяц = 4;
                    break; 
               case "May":
                    месяц = 5;
                    break; 
               case "Jun":
                    месяц = 6;
                    break; 
               case "Jul":
                    месяц = 7;
                    break; 
               case "Aug":
                    месяц = 8;
                    break; 
               case "Sep":
                    месяц = 9;
                    break; 
               case "Oct":
                    месяц = 10;
                    break; 
               case "Nov":
                    месяц = 11;
                    break; 
               case "Dec":
                    месяц = 12;
                    break; 
               default:
                    return месяц;
               }
        p += 3;
        return месяц;
}


/******************************************************************************

        Match a день из_ the ввод

******************************************************************************/

private цел разбериКороткийДень(T) (ref T* p)
{
        цел день;

        switch (p[0..3])
               {
               case "Sun":
                    день = 0;
                    break;
               case "Mon":
                    день = 1;
                    break; 
               case "Tue":
                    день = 2;
                    break; 
               case "Wed":
                    день = 3;
                    break; 
               case "Thu":
                    день = 4;
                    break; 
               case "Fri":
                    день = 5;
                    break; 
               case "Sat":
                    день = 6;
                    break; 
               default:
                    return -1;
               }
        p += 3;
        return день;
}


/******************************************************************************

        Match a день из_ the ввод. Воскресенье is 0

******************************************************************************/

private цел разбериПолныйДень(T) (ref T* p)
{
        static  T[][] дни =
                [
                "Sunday", 
                "Monday", 
                "Tuesday", 
                "Wednesday", 
                "Thursday", 
                "Friday", 
                "Saturday", 
                ];

        foreach (i, день; дни)
                 if (день == p[0..день.length])
                    {
                    p += день.length;
                    return i;
                    }
        return -1;
}


/******************************************************************************

        Extract an целое из_ the ввод

******************************************************************************/

private static цел парсируйЦел(T) (ref T* p, T* e)
{
        цел значение;

        while (p < e && (*p >= '0' && *p <= '9'))
               значение = значение * 10 + *p++ - '0';
        return значение;
}


/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        unittest
        {
        шим[30] врем;
        шим[] тест = "Sun, 06 Nov 1994 08:49:37 GMT";
                
        auto время = разбор (тест);
        auto текст = форматируй (врем, время);
        assert (текст == тест);

        ткст garbageTest = "Wed Jun 11 17:22:07 20088";
        garbageTest = garbageTest[0..$-1];
        сим[128] tmp2;

        время = разбор(garbageTest);
        auto text2 = форматируй(tmp2, время);
        assert (text2 == "Wed, 11 Jun 2008 17:22:07 GMT");
        }
}

/******************************************************************************

******************************************************************************/

debug (TimeStamp)
{
        проц main()
        {
                Время t;

                auto dos = "12-31-06 08:49AM";
                auto iso = "2006-01-31 14:49:30,001";
                assert (dostime(dos, t) == dos.length);
                assert (iso8601(iso, t) == iso.length);

                шим[30] врем;
                шим[] тест = "Sun, 06 Nov 1994 08:49:37 GMT";
                
                auto время = разбор (тест);
                auto текст = форматируй (врем, время);
                assert (текст == тест);              
        }
}
