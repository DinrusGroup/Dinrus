/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Feb 2007: Initial release
        
        author:         Kris

*******************************************************************************/

module time.StopWatch;

private import exception;

/*******************************************************************************

*******************************************************************************/

version (Win32)
{
        private extern (Windows) 
        {
        цел QueryPerformanceCounter   (бдол *счёт);
        цел QueryPerformanceFrequency (бдол *frequency);
        }
}

version (Posix)
{
        private import rt.core.stdc.posix.sys.время;
}

/*******************************************************************************

        Timer for measuring small intervals, such as the duration of a 
        subroutine or другой reasonably small период.
        ---
        Секундомер elapsed;

        elapsed.старт;

        // do something
        // ...

        дво i = elapsed.stop;
        ---

        The measured интервал is in units of сек, using floating-
        point в_ represent fractions. This approach is ещё flexible 
        than целое arithmetic since it migrates trivially в_ ещё
        capable timer hardware (there no implicit granularity в_ the
        measurable intervals, except the limits of fp representation)

        Секундомер is accurate в_ the протяженность of what the underlying OS
        supports. On linux systems, this accuracy is typically 1 us at 
        best. Win32 is generally ещё precise. 

        There is some minor overhead in using Секундомер, so take that преобр_в 
        account

*******************************************************************************/

public struct Секундомер
{
        private бдол  пущен;
        private static дво множитель = 1.0 / 1_000_000.0;

        version (Win32)
                 private static дво microsecond;

        /***********************************************************************
                
                Start the timer

        ***********************************************************************/
        
        проц старт ()
        {
                пущен = timer;
        }

        /***********************************************************************
                
                Стоп the timer and return elapsed duration since старт()

        ***********************************************************************/
        
        дво stop ()
        {
                return множитель * (timer - пущен);
        }

        /***********************************************************************
                
                Return elapsed время since the последний старт() as микросекунды

        ***********************************************************************/
        
        бдол microsec ()
        {
                version (Posix)
                         return (timer - пущен);

                version (Win32)
                         return cast(бдол) ((timer - пущен) * microsecond);
        }

        /***********************************************************************
                
                Setup timing information for later use

        ***********************************************************************/

        static this()
        {
                version (Win32)
                {
                        бдол freq;

                        QueryPerformanceFrequency (&freq);
                        microsecond = 1_000_000.0 / freq;       
                        множитель = 1.0 / freq;       
                }
        }

        /***********************************************************************
                
                Return the current время as an Interval

        ***********************************************************************/

        private static бдол timer ()
        {
                version (Posix)       
                {
                        значврем tv;
                        if (gettimeofday (&tv, пусто))
                            throw new PlatformException ("Timer :: linux timer is not available");

                        return (cast(бдол) tv.сек * 1_000_000) + tv.микросек;
                }

                version (Win32)
                {
                        бдол сейчас;

                        if (! QueryPerformanceCounter (&сейчас))
                              throw new PlatformException ("high-resolution timer is not available");

                        return сейчас;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Секундомер)
{
        import io.Stdout;

        проц main() 
        {
                Секундомер t;
                t.старт;

                for (цел i=0; i < 100_000_000; ++i)
                    {}
                Стдвыв.форматируй ("{:f9}", t.stop).нс;
        }
}
