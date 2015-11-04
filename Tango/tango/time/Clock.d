/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Feb 2007: Initial release

        author:         Kris

*******************************************************************************/

module time.Clock;

public  import  time.Time;

private import  sys.Common;

private import  exception;

/******************************************************************************

        Exposes UTC время relative в_ Jan 1st, 1 AD. These values are
        based upon a clock-tick of 100ns, giving them a вринтервал of greater
        than 10,000 годы. These units of время are the foundation of most
        время and дата functionality in Dinrus.

        Interval is другой тип of время период, used for measuring a
        much shorter duration; typically used for таймаут periods and
        for high-resolution timers. These intervals are measured in
        units of 1 сукунда, and support fractional units (0.001 = 1ms).

*******************************************************************************/

struct Часы
{
        // copied из_ Gregorian.  Used while we rely on OS for вДату.
        package static final бцел[] ДниВМесОбщ = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
        package static проц setDoy(ref ДатаВремя dt)
        {
            бцел деньгода = dt.дата.день + ДниВМесОбщ[dt.дата.месяц - 1];
            бцел год = dt.дата.год;

            if(dt.дата.месяц > 2 && (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0)))
                деньгода++;

            dt.дата.деньгода = деньгода;
        }

        version (Win32)
        {
                /***************************************************************

                        Return the current время as UTC since the эпоха

                ***************************************************************/

                static Время сейчас ()
                {
                        FILETIME fTime =void;
                        GetSystemTimeAsFileTime (&fTime);
                        return преобразуй (fTime);
                }

                /***************************************************************

                        Набор Date fields в_ represent the current время. 

                ***************************************************************/

                static ДатаВремя вДату ()
                {
                        return вДату (сейчас);
                }


                /***************************************************************

                        Набор fields в_ represent the provопрed UTC время. Note 
                        that the conversion is limited by the underlying OS,
                        and will краш в_ operate correctly with Время
                        values beyond the домен. On Win32 the earliest
                        representable дата is 1601. On linux it is 1970. Всё
                        systems have limitations upon future dates also. Date
                        is limited в_ миллисек accuracy at best.

                ***************************************************************/

                static ДатаВремя вДату (Время время)
                {
                        ДатаВремя dt =void;
                        SYSTEMTIME sTime =void;

                        auto fTime = преобразуй (время);
                        FileTimeToSystemTime (&fTime, &sTime);

                        dt.дата.год    = sTime.wYear;
                        dt.дата.месяц   = sTime.wMonth;
                        dt.дата.день     = sTime.wDay;
                        dt.дата.деньнед     = sTime.wДеньНедели;
                        dt.дата.эра     = 0;
                        dt.время.часы   = sTime.wHour;
                        dt.время.минуты = sTime.wMinute;
                        dt.время.сек = sTime.wSecond;
                        dt.время.миллисек  = sTime.wMilliseconds;

                        // Calculate the день-of-год
                        setDoy(dt);

                        return dt;
                }

                /***************************************************************

                        Convert Date fields в_ Время

                        Note that the conversion is limited by the underlying 
                        OS, and will not operate correctly with Время
                        values beyond the домен. On Win32 the earliest
                        representable дата is 1601. On linux it is 1970. Всё
                        systems have limitations upon future dates also. Date
                        is limited в_ миллисек accuracy at best.

                ***************************************************************/

                static Время изДаты (ref ДатаВремя dt)
                {
                        SYSTEMTIME sTime =void;
                        FILETIME   fTime =void;

                        sTime.wYear         = cast(бкрат) dt.дата.год;
                        sTime.wMonth        = cast(бкрат) dt.дата.месяц;
                        sTime.wДеньНедели    = 0;
                        sTime.wDay          = cast(бкрат) dt.дата.день;
                        sTime.wHour         = cast(бкрат) dt.время.часы;
                        sTime.wMinute       = cast(бкрат) dt.время.минуты;
                        sTime.wSecond       = cast(бкрат) dt.время.сек;
                        sTime.wMilliseconds = cast(бкрат) dt.время.миллисек;

                        SystemTimeToFileTime (&sTime, &fTime);
                        return преобразуй (fTime);
                }

                /***************************************************************

                        Convert FILETIME в_ a Время

                ***************************************************************/

                package static Время преобразуй (FILETIME время)
                {
                        auto t = *cast(дол*) &время;
                        t *= 100 / ИнтервалВремени.NanosecondsPerTick;
                        return Время.эпоха1601 + ИнтервалВремени(t);
                }

                /***************************************************************

                        Convert Время в_ a FILETIME

                ***************************************************************/

                package static FILETIME преобразуй (Время dt)
                {
                        FILETIME время =void;

                        ИнтервалВремени вринтервал = dt - Время.эпоха1601;
                        assert (вринтервал >= ИнтервалВремени.zero);
                        *cast(дол*) &время.dwLowDateTime = вринтервал.тики;
                        return время;
                }
        }

        version (Posix)
        {
                /***************************************************************

                        Return the current время as UTC since the эпоха

                ***************************************************************/

                static Время сейчас ()
                {
                        значврем tv =void;
                        if (gettimeofday (&tv, пусто))
                            throw new PlatformException ("Часы.сейчас :: Posix timer is not available");

                        return преобразуй (tv);
                }

                /***************************************************************

                        Набор Date fields в_ represent the current время. 

                ***************************************************************/

                static ДатаВремя вДату ()
                {
                        return вДату (сейчас);
                }

                /***************************************************************

                        Набор fields в_ represent the provопрed UTC время. Note 
                        that the conversion is limited by the underlying OS,
                        and will краш в_ operate correctly with Время
                        values beyond the домен. On Win32 the earliest
                        representable дата is 1601. On linux it is 1970. Всё
                        systems have limitations upon future dates also. Date
                        is limited в_ миллисек accuracy at best.

                **************************************************************/

                static ДатаВремя вДату (Время время)
                {
                        ДатаВремя dt =void;
                        auto значврем = преобразуй (время);
                        dt.время.миллисек = значврем.микросек / 1000;

                        tm t =void;
                        gmtime_r (&значврем.сек, &t);

                        dt.дата.год    = t.tm_year + 1900;
                        dt.дата.месяц   = t.tm_mon + 1;
                        dt.дата.день     = t.tm_mday;
                        dt.дата.деньнед     = t.tm_wday;
                        dt.дата.эра     = 0;
                        dt.время.часы   = t.tm_hour;
                        dt.время.минуты = t.tm_min;
                        dt.время.сек = t.tm_sec;

                        // Calculate the день-of-год
                        setDoy(dt);

                        return dt;
                }

                /***************************************************************

                        Convert Date fields в_ Время

                        Note that the conversion is limited by the underlying 
                        OS, and will not operate correctly with Время
                        values beyond the домен. On Win32 the earliest
                        representable дата is 1601. On linux it is 1970. Всё
                        systems have limitations upon future dates also. Date
                        is limited в_ миллисек accuracy at best.

                ***************************************************************/

                static Время изДаты (ref ДатаВремя dt)
                {
                        tm t =void;

                        t.tm_year = dt.дата.год - 1900;
                        t.tm_mon  = dt.дата.месяц - 1;
                        t.tm_mday = dt.дата.день;
                        t.tm_hour = dt.время.часы;
                        t.tm_min  = dt.время.минуты;
                        t.tm_sec  = dt.время.сек;

                        auto сек = timegm (&t);
                        return Время.epoch1970 + 
                               ИнтервалВремени.изСек(сек) + 
                               ИнтервалВремени.изМиллисек(dt.время.миллисек);
                }

                /***************************************************************

                        Convert значврем в_ a Время

                ***************************************************************/

                package static Время преобразуй (ref значврем tv)
                {
                        return Время.epoch1970 + 
                               ИнтервалВремени.изСек(tv.сек) + 
                               ИнтервалВремени.изМикросек(tv.микросек);
                }

                /***************************************************************

                        Convert Время в_ a значврем

                ***************************************************************/

                package static значврем преобразуй (Время время)
                {
                        значврем tv =void;

                        ИнтервалВремени вринтервал = время - время.epoch1970;
                        assert (вринтервал >= ИнтервалВремени.zero);
                        tv.сек  = cast(typeof(tv.сек)) вринтервал.сек;
                        tv.микросек = cast(typeof(tv.микросек)) (вринтервал.micros % 1_000_000L);
                        return tv;
                }
        }
}



debug (UnitTest)
{
        unittest 
        {
                auto время = Часы.сейчас;
                auto clock=Часы.преобразуй(время);
                assert (Часы.преобразуй(clock) is время);

                время -= ИнтервалВремени(время.тики % ИнтервалВремени.ТиковВСек);
                auto дата = Часы.вДату(время);

                assert (время is Часы.изДаты(дата));
        }
}

debug (Часы)
{
        проц main() 
        {
                auto время = Часы.сейчас;
        }
}
