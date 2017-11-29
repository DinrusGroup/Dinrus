module time.StopWatch;

private import exception;

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
        точка в_ represent fractions. This approach is ещё flexible 
        than целое arithmetic since it migrates trivially в_ ещё
        capable таймер hardware (there no implicit granularity в_ the
        measurable intervals, except the limits of fp representation)

        Секундомер is accurate в_ the протяженность of что the underlying OS
        supports. On linux systems, this accuracy is typically 1 us at 
        best. Win32 is generally ещё precise. 

        There is some minor overhead in using Секундомер, so возьми that преобр_в 
        account

*******************************************************************************/

public struct Секундомер
{
        private бдол  пущен;
        private static дво множитель = 1.0 / 1_000_000.0;

        version (Win32)
                 private static дво микросекунда;

        /***********************************************************************
                
                Start the таймер

        ***********************************************************************/
        
        проц старт ()
        {
                пущен = таймер;
        }

        /***********************************************************************
                
                Стоп the таймер и return elapsed duration since старт()

        ***********************************************************************/
        
        дво стоп ()
        {
                return множитель * (таймер - пущен);
        }

        /***********************************************************************
                
                Return elapsed время since the последний старт() as микросекунды

        ***********************************************************************/
        
        бдол микросек ()
        {
                version (Posix)
                         return (таймер - пущен);

                version (Win32)
                         return cast(бдол) ((таймер - пущен) * микросекунда);
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
                        микросекунда = 1_000_000.0 / freq;       
                        множитель = 1.0 / freq;       
                }
        }

        /***********************************************************************
                
                Return the текущ время as an Interval

        ***********************************************************************/

        private static бдол таймер ()
        {
                version (Posix)       
                {
                        значврем tv;
                        if (gettimeofday (&tv, пусто))
                            throw new PlatformException ("Timer :: linux таймер is not available");

                        return (cast(бдол) tv.сек * 1_000_000) + tv.микросек;
                }

                version (Win32)
                {
                        бдол сейчас;

                        if (! QueryPerformanceCounter (&сейчас))
                              throw new PlatformException ("таймер высокого разрешения недоступен");

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
                Стдвыв.форматируй ("{:f9}", t.стоп).нс;
        }
}
