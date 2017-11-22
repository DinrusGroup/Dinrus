/*******************************************************************************

        copyright:      Copyright (C) 1997--2004, Makoto Matsumoto,
                        Takuji Nishimura, и Eric Landry; все rights reserved
        

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2008: Initial release

        author:         KeYeR (D interface) keyer@team0xf.com
      
*******************************************************************************/

module math.random.Twister;


version (Win32)
         private extern(Windows) цел QueryPerformanceCounter (бдол *);

version (Posix)
        {
        private import rt.core.stdc.posix.sys.time;
        }
        
/*******************************************************************************

        Wrapper for the Mersenne twister.
        
        The Mersenne twister is a pseudorandom число generator linked в_
        CR developed in 1997 by Makoto Matsumoto и Takuji Nishimura that
        is based on a matrix linear recurrence over a finite binary field
        F2. It provопрes for fast generation of very high quality pseudorandom
        numbers, having been designed specifically в_ rectify many of the 
        flaws найдено in older algorithms.
        
        Mersenne Твистер имеется the following desirable свойства:
        ---
        1. It was designed в_ have a период of 2^19937 - 1 (the creators
           of the algorithm proved this property).
           
        2. It имеется a very high order of dimensional equопрistribution.
           This implies that there is negligible serial correlation between
           successive значения in the вывод sequence.
           
        3. It проходки numerous tests for statistical randomness, включая
           the stringent Diehard tests.
           
        4. It is fast.
        ---

*******************************************************************************/

struct Твистер
{
        public alias натурал  вЦел;
        public alias дво вРеал;
        
        private enum : бцел                     // Period параметры
                {
                N          = 624,
                M          = 397,
                MATRIX_A   = 0x9908b0df,        // constant вектор a 
                UPPER_MASK = 0x80000000,        //  most significant w-r биты 
                LOWER_MASK = 0x7fffffff,        // least significant r биты
                }

        private бцел[N] mt;                     // the Массив for the состояние вектор  
        private бцел mti=mt.length+1;           // mti==mt.length+1 means mt[] is not инициализован 
        private бцел vLastRand;                 // The most recent random бцел returned. 

        /**********************************************************************

                A global, shared экземпляр, seeded via startup время

        **********************************************************************/

        public static Твистер экземпляр; 

        static this ()
        {
                экземпляр.сей;
        }

        /**********************************************************************

                Creates и seeds a new generator with the текущ время

        **********************************************************************/

        static Твистер opCall ()
        {
                Твистер случ;
                случ.сей;
                return случ;
        }

        /**********************************************************************

                Returns X such that 0 <= X < max
                
        **********************************************************************/

        бцел натурал (бцел max)
        {
                return натурал % max;
        }
        
        /**********************************************************************

                Returns X such that min <= X < max
                
        **********************************************************************/

        бцел натурал (бцел min, бцел max)
        {
                return (натурал % (max-min)) + min;
        }

        /**********************************************************************

                Returns X such that 0 <= X <= бцел.max 

        **********************************************************************/

        бцел натурал (бул паддЭнтропию = нет)
        {
                бцел y;
                static бцел mag01[2] =[0, MATRIX_A];

                if (mti >= mt.length) { 
                        цел kk;

                        if (паддЭнтропию || mti > mt.length)   
                        {
                                сей (5489U, паддЭнтропию); 
                        }

                        for (kk=0;kk<mt.length-M;kk++)
                        {
                                y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
                                mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 1U];
                        }
                        for (;kk<mt.length-1;kk++) {
                                y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
                                mt[kk] = mt[kk+(M-mt.length)] ^ (y >> 1) ^ mag01[y & 1U];
                        }
                        y = (mt[mt.length-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
                        mt[mt.length-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 1U];

                        mti = 0;
                }

                y = mt[mti++];

                y ^= (y >> 11);
                y ^= (y << 7)  &  0x9d2c5680U;
                y ^= (y << 15) &  0xefc60000U;
                y ^= (y >> 18);

                vLastRand = y;
                return y;
        }

        /**********************************************************************

                generates a random число on [0,1] интервал
                
        **********************************************************************/

        дво включительно ()
        {
                return натурал*(1.0/cast(дво)бцел.max);
        }

        /**********************************************************************

                генерирует случайное число в интервале (0,1) 

        **********************************************************************/

        дво исключительно ()
        {
                return ((cast(дво)натурал) + 0.5)*(1.0/(cast(дво)бцел.max+1.0));
        }

        /**********************************************************************
				генерирует случайное число в интервале [0,1) 

        **********************************************************************/

        дво дробь ()
        {
                return натурал*(1.0/(cast(дво)бцел.max+1.0));
        }

        /**********************************************************************

                генерирует случайное число в [0,1) с 53-битным разрешением

        **********************************************************************/

        дво дробьДоп ()
        {
                бцел a = натурал >> 5, b = натурал >> 6;
                return(a * 67108864.0 + b) * (1.0 / 9007199254740992.0);
        }
        
        /**********************************************************************

                "Засевает" в генератор текущее время

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

                инициализует генератор значением "семени" 

        **********************************************************************/

        проц сей (бцел s, бул паддЭнтропию = нет)
        {
                mt[0]= (s + (паддЭнтропию ? vLastRand + cast(бцел) this : 0)) & 0xffffffffU;
                for (mti=1; mti<mt.length; mti++){
                        mt[mti] = (1812433253U * (mt[mti-1] ^ (mt[mti-1] >> 30)) + mti);
                        mt[mti] &= 0xffffffffU;
                }
        }

        /**********************************************************************

                инициализуется Массивом с длиной init_key -
                Массив для инициализации ключей
                
        **********************************************************************/

        проц init (бцел[] init_key, бул паддЭнтропию = нет)
        {
                цел i, j, k;
                i=1;
                j=0;
                
                сей (19650218U, паддЭнтропию);
                for (k = (mt.length > init_key.length ? mt.length : init_key.length); k; k--)   {
                        mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1664525U))+ init_key[j] + j; 
                        mt[i] &=  0xffffffffU; 
                        i++;
                        j++;

                        if (i >= mt.length){
                                mt[0] = mt[mt.length-1];
                                i=1;
                        }

                        if (j >= init_key.length){
                                j=0;
                        }
                }

                for (k=mt.length-1; k; k--)     {
                        mt[i] = (mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1566083941U))- i; 
                        mt[i] &=  0xffffffffU; 
                        i++;

                        if (i>=mt.length){
                                mt[0] = mt[mt.length-1];
                                i=1;
                        }
                }
                mt[0] |=  0x80000000U; 
                mti=0;
        }
}


/******************************************************************************


******************************************************************************/

debug (Твистер)
{
        import io.Stdout;
        import time.StopWatch;

        проц main()
        {
                auto dbl = Твистер();
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
