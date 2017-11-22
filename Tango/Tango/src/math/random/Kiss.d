/*******************************************************************************

        copyright:      Copyright (c) 2008. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: May 2008

        author:         Various

        Since:          0.99.7

        With gratitude в_ Dr Jurgen A Doornik. See his paper entitled
        "Conversion of high-период random numbers в_ floating точка"
        
*******************************************************************************/

module math.random.Kiss;
import base;

version (Win32)
         private extern(Windows) цел QueryPerformanceCounter (бдол *);

version (Posix)
        {
        private import rt.core.stdc.posix.sys.time;
        }


/******************************************************************************

        KISS (из_ George Marsaglia)

        The опрea is в_ use simple, fast, indivопрually promising
        generators в_ получи a composite that will be fast, easy в_ код
        have a very дол период и пароль все the tests помести в_ it.
        The three components of KISS are
        ---
                x(n)=a*x(n-1)+1 mod 2^32
                y(n)=y(n-1)(I+L^13)(I+R^17)(I+L^5),
                z(n)=2*z(n-1)+z(n-2) +carry mod 2^32
        ---

        The y's are a shift регистрируй sequence on 32bit binary vectors
        период 2^32-1; The z's are a simple multИПly-with-carry sequence
        with период 2^63+2^32-1. The период of KISS is thus
        ---
                2^32*(2^32-1)*(2^63+2^32-1) > 2^127
        ---

        Note that this should be passed by reference, unless you really
        intend в_ provопрe a local копируй в_ a callee
        
******************************************************************************/

struct Kiss
{
        ///
        public alias натурал  вЦел;
        ///
        public alias дво вРеал;
        
        private бцел kiss_k;
        private бцел kiss_m;
        private бцел kiss_x = 1;
        private бцел kiss_y = 2;
        private бцел kiss_z = 4;
        private бцел kiss_w = 8;
        private бцел kiss_carry = 0;
        
        private const дво M_RAN_INVM32 = 2.32830643653869628906e-010,
                             M_RAN_INVM52 = 2.22044604925031308085e-016;
      
        /**********************************************************************

                A global, shared экземпляр, seeded via startup время

        **********************************************************************/

        public static Kiss экземпляр; 

        static this ()
        {
                экземпляр.сей;
        }

        /**********************************************************************

                Creates и seeds a new generator with the текущ время

        **********************************************************************/

        static Kiss opCall ()
        {
                Kiss случ;
                случ.сей;
                return случ;
        }

        /**********************************************************************

                Seed the generator with текущ время

        **********************************************************************/

        проц сей ()
        {
                бдол s;

                version (Posix)
                        {
                        значврем tv;

                        gettimeofday (&tv, пусто);
                        s = tv.микросек;
                        }
                version (Win32)
                         QueryPerformanceCounter (&s);

                return сей (cast(бцел) s);
        }

        /**********************************************************************

                Seed the generator with a provопрed значение

        **********************************************************************/

        проц сей (бцел сей)
        {
                kiss_x = сей | 1;
                kiss_y = сей | 2;
                kiss_z = сей | 4;
                kiss_w = сей | 8;
                kiss_carry = 0;
        }

        /**********************************************************************

                Returns X such that 0 <= X <= бцел.max

        **********************************************************************/

        бцел натурал ()
        {
                kiss_x = kiss_x * 69069 + 1;
                kiss_y ^= kiss_y << 13;
                kiss_y ^= kiss_y >> 17;
                kiss_y ^= kiss_y << 5;
                kiss_k = (kiss_z >> 2) + (kiss_w >> 3) + (kiss_carry >> 2);
                kiss_m = kiss_w + kiss_w + kiss_z + kiss_carry;
                kiss_z = kiss_w;
                kiss_w = kiss_m;
                kiss_carry = kiss_k >> 30;
                return kiss_x + kiss_y + kiss_w;
        }

        /**********************************************************************

                Returns X such that 0 <= X < max

                Note that max is исключительно, making it compatible with
                Массив indexing

        **********************************************************************/

        бцел натурал (бцел max)
        {
                return натурал % max;
        }

        /**********************************************************************

                Returns X such that min <= X < max

                Note that max is исключительно, making it compatible with
                Массив indexing

        **********************************************************************/

        бцел натурал (бцел min, бцел max)
        {
                return (натурал % (max-min)) + min;
        }
        
        /**********************************************************************
        
                Returns a значение in the range [0, 1) using 32 биты
                of точность (with thanks в_ Dr Jurgen A Doornik)

        **********************************************************************/

        дво дробь ()
        {
                return ((cast(цел) натурал) * M_RAN_INVM32 + (0.5 + M_RAN_INVM32 / 2));
        }

        /**********************************************************************

                Returns a значение in the range [0, 1) using 52 биты
                of точность (with thanks в_ Dr Jurgen A Doornik)

        **********************************************************************/

        дво дробьДоп ()
        {
                return ((cast(цел) натурал) * M_RAN_INVM32 + (0.5 + M_RAN_INVM52 / 2) + 
                       ((cast(цел) натурал) & 0x000FFFFF) * M_RAN_INVM52);
        }
}



/******************************************************************************


******************************************************************************/

debug (Kiss)
{
        import io.Stdout;
        import time.StopWatch;

        проц main()
        {
                auto dbl = Kiss();
                auto счёт = 100_000_000;
                Секундомер w;

                w.старт;
                дво v1;
                for (цел i=счёт; --i;)
                     v1 = dbl.дво;
                Стдвыв.форматнс ("{} дво, {}/s, {:f10}", счёт, счёт/w.stop, v1);

                w.старт;
                for (цел i=счёт; --i;)
                     v1 = dbl.дробьДоп;
                Стдвыв.форматнс ("{} дробьДоп, {}/s, {:f10}", счёт, счёт/w.stop, v1);

                for (цел i=счёт; --i;)
                    {
                    auto v = dbl.дво;
                    if (v <= 0.0 || v >= 1.0)
                       {
                       Стдвыв.форматнс ("дво {:f10}", v);
                       break;
                       }
                    v = dbl.дробьДоп;
                    if (v <= 0.0 || v >= 1.0)
                       {
                       Стдвыв.форматнс ("дробьДоп {:f10}", v);
                       break;
                       }
                    }
        }
}
