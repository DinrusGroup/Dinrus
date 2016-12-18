﻿/*******************************************************************************

        copyright:      Copyright (c) 2008. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: May 2008

        author:         Various

        Since:          0.99.7

        With gratitude в_ Dr Jurgen A Doornik. See his paper entitled
        "Conversion of high-период random numbers в_ floating точка"
        
*******************************************************************************/

module math.random.Kiss;


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
        public alias дробь вРеал;
        
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

        static this ();

        /**********************************************************************

                Creates и seeds a new generator with the текущ время

        **********************************************************************/

        static Kiss opCall ();

        /**********************************************************************

                Seed the generator with текущ время

        **********************************************************************/

        проц сей ();

        /**********************************************************************

                Seed the generator with a provопрed значение

        **********************************************************************/

        проц сей (бцел сей);

        /**********************************************************************

                Returns X such that 0 <= X <= бцел.max

        **********************************************************************/

        бцел натурал ();

        /**********************************************************************

                Returns X such that 0 <= X < max

                Note that max is исключительно, making it compatible with
                Массив indexing

        **********************************************************************/

        бцел натурал (бцел max);

        /**********************************************************************

                Returns X such that min <= X < max

                Note that max is исключительно, making it compatible with
                Массив indexing

        **********************************************************************/

        бцел натурал (бцел min, бцел max);
        
        /**********************************************************************
        
                Returns a значение in the range [0, 1) using 32 биты
                of точность (with thanks в_ Dr Jurgen A Doornik)

        **********************************************************************/

        дво дробь ();

        /**********************************************************************

                Returns a значение in the range [0, 1) using 52 биты
                of точность (with thanks в_ Dr Jurgen A Doornik)

        **********************************************************************/

        дво дробьДоп ();
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
                     v1 = dbl.дробь;
                Стдвыв.форматнс ("{} дробь, {}/s, {:f10}", счёт, счёт/w.stop, v1);

                w.старт;
                for (цел i=счёт; --i;)
                     v1 = dbl.дробьДоп;
                Стдвыв.форматнс ("{} дробьДоп, {}/s, {:f10}", счёт, счёт/w.stop, v1);

                for (цел i=счёт; --i;)
                    {
                    auto v = dbl.дробь;
                    if (v <= 0.0 || v >= 1.0)
                       {
                       Стдвыв.форматнс ("дробь {:f10}", v);
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
