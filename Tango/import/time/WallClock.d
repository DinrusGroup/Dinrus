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

        Exposes wall-время relative в_ Jan 1st, 1 AD. These values are
        based upon a clock-tick of 100ns, giving them a вринтервал of greater
        than 10,000 годы. These Units of время are the foundation of most
        время and дата functionality in Dinrus.

        Please note that conversion between UTC and Wall время is performed
        in accordance with the OS facilities. In particular, Win32 systems
        behave differently в_ Posix when calculating daylight-savings время
        (Win32 calculates with respect в_ the время of the вызов, whereas a
        Posix system calculates based on a provопрed point in время). Posix
        systems should typically have the TZ environment переменная установи в_ 
        a valid descrИПtor.

*******************************************************************************/

struct Куранты
{
        version (Win32)
        {
                /***************************************************************

                        Возвращает текущее локальное время

                ***************************************************************/

                static Время сейчас ();

                /***************************************************************

                        Возвращает часовой пояс относительно GMT. К западу от GMT
						из_ значение отрицательно.

                ***************************************************************/

                static ИнтервалВремени зона ();

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        current UTC время. все values must fall within 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату ();

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        provопрed UTC время. все values must fall within 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату (Время utc);

                /***************************************************************

                        Convert Date fields в_ local время

                ***************************************************************/

                static Время изДаты (ref ДатаВремя дата);

                /***************************************************************

                        Retrieve the local bias, включая DST adjustment.
                        Note that Win32 calculates DST at the время of вызов
                        rather than based upon a point in время represented
                        by an аргумент.
                         
                ***************************************************************/

                private static ИнтервалВремени localBias () ;
        }

        version (Posix)
        {
                /***************************************************************

                        Return the current local время

                ***************************************************************/

                static Время сейчас ();

                /***************************************************************

                        Return the timezone relative в_ GMT. The значение is 
                        negative when west of GMT

                ***************************************************************/

                static ИнтервалВремени зона ();

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        current UTC время. все values must fall within 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату ();

                /***************************************************************

                        Набор fields в_ represent a local version of the 
                        provопрed UTC время. все values must fall within 
                        the домен supported by the OS

                ***************************************************************/

                static ДатаВремя вДату (Время utc);

                /***************************************************************

                        Convert Date fields в_ local время

                ***************************************************************/

                static Время изДаты (ref ДатаВремя dt);
        }

        /***********************************************************************

        ***********************************************************************/
        
        static Время вМестное (Время utc);

        /***********************************************************************

        ***********************************************************************/
        
        static Время toUtc (Время wall);
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
