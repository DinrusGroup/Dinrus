/*******************************************************************************

        copyright:      Copyright (c) 2004. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: April 2004

        author:         Various

        Deprecated:     Please use Kiss instead. We'll добавь a fully featured
                        Случай in a future release
        
*******************************************************************************/

module math.Random;


version (Win32)
         private extern(Windows) цел QueryPerformanceCounter (бдол *);

version (Posix)
        {
        private import rt.core.stdc.posix.sys.время;
        }


/******************************************************************************

        KISS (via George Marsaglia)

        the опрea is в_ use simple, fast, indivопрually promising
        generators в_ получи a composite that will be fast, easy в_ код
        have a very дол период and пароль все the tests помести в_ it.
        The three components of KISS are

                x(n)=a*x(n-1)+1 mod 2^32
                y(n)=y(n-1)(I+L^13)(I+R^17)(I+L^5),
                z(n)=2*z(n-1)+z(n-2) +carry mod 2^32
                
        The y's are a shift регистрируй sequence on 32bit binary vectors
        период 2^32-1; The z's are a simple multИПly-with-carry sequence
        with период 2^63+2^32-1.

        The период of KISS is thus 2^32*(2^32-1)*(2^63+2^32-1) > 2^127

******************************************************************************/

class Случай
{
        /**********************************************************************

                Shared экземпляр:
                ---
                auto random = Случай.экземпляр.следщ;
                ---

        **********************************************************************/
        public static Случай экземпляр;

        private бцел kiss_k;
        private бцел kiss_m;
        private бцел kiss_x = 1;
        private бцел kiss_y = 2;
        private бцел kiss_z = 4;
        private бцел kiss_w = 8;
        private бцел kiss_carry = 0;
        
        /**********************************************************************

                Create a static and shared экземпляр:
                ---
                auto random = Случай.экземпляр.следщ;
                ---

        **********************************************************************/

        static this ()
        {
                экземпляр = new Случай;
        }

        /**********************************************************************

                Creates and seeds a new generator with the current время

        **********************************************************************/

        this ()
        {
                this.сей;
        }

        /**********************************************************************

                Seed the generator with current время

        **********************************************************************/

        final Случай сей ()
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

        final Случай сей (бцел сей)
        {
                kiss_x = сей | 1;
                kiss_y = сей | 2;
                kiss_z = сей | 4;
                kiss_w = сей | 8;
                kiss_carry = 0;
                return this;
        }

        /**********************************************************************

                Returns X such that 0 <= X <= бцел.max

        **********************************************************************/

        deprecated final бцел следщ ()
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

        deprecated final бцел следщ (бцел max)
        {
                return следщ() % max;
        }

        /**********************************************************************

                Returns X such that min <= X < max

                Note that max is исключительно, making it compatible with
                Массив indexing

        **********************************************************************/

        deprecated final бцел следщ (бцел min, бцел max)
        {
                return следщ(max-min) + min;
        }
}


