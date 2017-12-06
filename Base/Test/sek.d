import io.Stdout, time.StopWatch;

        проц main() 
        {
                Секундомер t;
                t.старт;

                for (цел i=0; i < 100_000_000; ++i)
                    {}
                Стдвыв.форматируй ("{:f9}", t.стоп).нс;
        }