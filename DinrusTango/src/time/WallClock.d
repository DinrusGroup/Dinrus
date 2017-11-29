/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2007: разбей away из_ utc

        author:         Kris

*******************************************************************************/

module time.WallClock;

public  import  time.Time;

private import  time.Clock;

private import  sys.Common;

/******************************************************************************

        Exposes wall-время relative в_ Jan 1st, 1 AD. These значения are
        based upon a clock-tick of 100ns, giving them a вринтервал of greater
        than 10,000 годы. These Units of время are the foundation of most
        время and дата functionality in Dinrus.

        Please note that conversion between UTC and Wall время is performed
        in accordance with the OS facilities. In particular, Win32 systems
        behave differently в_ Posix when calculating daylight-savings время
        (Win32 calculates with respect в_ the время of the вызов, whereas a
        Posix system calculates based on a provопрed точка in время). Posix
        systems should typically have the TZ environment переменная установи в_ 
        a valid descrИПtor.

*******************************************************************************/

struct Куранты
{
        version (Win32)
        {
                /***************************************************************

                        Return the current local время

                ***************************************************************/

                static Время сейчас ()
                {
                        return Часы.сейчас - localBias;
                }

                /***************************************************************

                        Return the timezone relative в_ GMT. The значение is 
                        негатив when west of GMT

                ***************************************************************/

                static ИнтервалВремени зона ()
                {
                        TIME_ZONE_INFORMATION tz =void;

                        auto врем = GetTimeZoneInformation (&tz);
                        return ИнтервалВремени.изМин(-tz.Bias);
                }

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        current UTC время. все значения must fall внутри 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату ()
                {
                        return вДату (Часы.сейчас);
                }

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        provопрed UTC время. все значения must fall внутри 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату (Время utc)
                {
                        return Часы.вДату (utc - localBias);
                }

                /***************************************************************

                        Convert Дата fields в_ local время

                ***************************************************************/

                static Время изДаты (ref ДатаВремя дата)
                {
                        return (Часы.изДаты(дата) + localBias);
                }

                /***************************************************************

                        Retrieve the local bias, включая DST adjustment.
                        Note that Win32 calculates DST at the время of вызов
                        rather than based upon a точка in время represented
                        by an аргумент.
                         
                ***************************************************************/

                private static ИнтервалВремени localBias () 
                { 
                       цел bias; 
                       TIME_ZONE_INFORMATION tz =void; 

                       switch (GetTimeZoneInformation (&tz)) 
                              { 
                              default: 
                                   bias = tz.Bias; 
                                   break; 
                              case 1: 
                                   bias = tz.Bias + tz.StandardBias; 
                                   break; 
                              case 2: 
                                   bias = tz.Bias + tz.DaylightBias; 
                                   break; 
                              } 

                       return ИнтервалВремени.изМин(bias); 
               }
        }

        version (Posix)
        {
                /***************************************************************

                        Return the current local время

                ***************************************************************/

                static Время сейчас ()
                {
                        tm t =void;
                        значврем tv =void;
                        gettimeofday (&tv, пусто);
                        localtime_r (&tv.сек, &t);
                        tv.сек = timegm (&t);
                        return Часы.преобразуй (tv);
                }

                /***************************************************************

                        Return the timezone relative в_ GMT. The значение is 
                        негатив when west of GMT

                ***************************************************************/

                static ИнтервалВремени зона ()
                {
                        version (darwin)
                                {
                                timezone_t tz =void;
                                gettimeofday (пусто, &tz);
                                return ИнтервалВремени.изМин(-tz.tz_minuteswest);
                                }
                             else
                                return ИнтервалВремени.изСек(-timezone);
                }

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        current UTC время. все значения must fall внутри 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату ()
                {
                        return вДату (Часы.сейчас);
                }

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        provопрed UTC время. все значения must fall внутри 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату (Время utc)
                {
                        ДатаВремя dt =void;
                        auto значврем = Часы.преобразуй (utc);
                        dt.время.миллисек = значврем.микросек / 1000;

                        tm t =void;
                        localtime_r (&значврем.сек, &t);
        
                        dt.дата.год    = t.tm_year + 1900;
                        dt.дата.месяц   = t.tm_mon + 1;
                        dt.дата.день     = t.tm_mday;
                        dt.дата.деньнед     = t.tm_wday;
                        dt.дата.эра     = 0;
                        dt.время.часы   = t.tm_hour;
                        dt.время.минуты = t.tm_min;
                        dt.время.сек = t.tm_sec;

                        Часы.setDoy(dt);
                        return dt;
                }

                /***************************************************************

                        Convert Дата fields в_ local время

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

                        auto сек = mktime (&t);
                        return Время.epoch1970 + ИнтервалВремени.изСек(сек) 
                                              + ИнтервалВремени.изМиллисек(dt.время.миллисек);
                }
        }

        /***********************************************************************

        ***********************************************************************/
        
        static Время вМестное (Время utc)
        {
                auto mod = utc.тики % ИнтервалВремени.ТиковВМиллисек;
                auto дата=вДату(utc);
                return Часы.изДаты(дата) + ИнтервалВремени(mod);
        }

        /***********************************************************************

        ***********************************************************************/
        
        static Время toUtc (Время wall)
        {
                auto mod = wall.тики % ИнтервалВремени.ТиковВМиллисек;
                auto дата=Часы.вДату(wall);
                return изДаты(дата) + ИнтервалВремени(mod);
        }
}


version (Posix)
{
    version (darwin) {}
    else
    {
        static this()
        {
            tzset();
        }
    }
}
