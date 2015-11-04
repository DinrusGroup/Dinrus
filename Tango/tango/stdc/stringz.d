/*******************************************************************************

        copyright:      Copyright (c) 2006 Keinfarbton. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: October 2006

        author:         Keinfarbton & Kris

*******************************************************************************/

module stringz;

/*********************************
 * Convert Массив of chars в_ a C-стиль 0 terminated ткст.
 * Provопрing a врем will use that instead of the куча, where
 * appropriate.
 */

сим* вТкст0 (ткст s, ткст врем=пусто)
{
        static ткст пустой = "\0";

        auto длин = s.length;
        if (s.ptr)
            if (длин is 0)
                s = пустой;
            else
               if (s[длин-1] != 0)
                  {
                  if (врем.length <= длин)
                      врем = new сим[длин+1];
                  врем [0..длин] = s;
                  врем [длин] = 0;
                  s = врем;
                  }
        return s.ptr;
}

/*********************************
 * Convert a series of ткст в_ C-стиль 0 terminated strings, using 
 * врем as a workspace and приёмн as a place в_ помести the resulting сим*'s.
 * This is handy for efficiently converting multИПle strings at once.
 *
 * Returns a populated срез of приёмн
 *
 * Since: 0.99.7
 */

сим*[] вТкст0 (ткст врем, сим*[] приёмн, ткст[] strings...)
{
        assert (приёмн.length >= strings.length);

        цел длин = strings.length;
        foreach (s; strings)
                 длин += s.length;
        if (врем.length < длин)
            врем.length = длин;

        foreach (i, s; strings)
                {
                приёмн[i] = вТкст0 (s, врем);
                врем = врем [s.length + 1 .. длин];
                }
        return приёмн [0 .. strings.length];
}

/*********************************
 * Convert a C-стиль 0 terminated ткст в_ an Массив of сим
 */

ткст изТкст0 (сим* s)
{
        return s ? s[0 .. strlenz(s)] : пусто;
}

/*********************************
 * Convert Массив of wchars s[] в_ a C-стиль 0 terminated ткст.
 */

шим* ВТкст16н (шим[] s)
{
        if (s.ptr)
            if (! (s.length && s[$-1] is 0))
                   s = s ~ "\0"w;
        return s.ptr;
}

/*********************************
 * Convert a C-стиль 0 terminated ткст в_ an Массив of шим
 */

шим[] изТкст16н (шим* s)
{
        return s ? s[0 .. strlenz(s)] : пусто;
}

/*********************************
 * Convert Массив of dchars s[] в_ a C-стиль 0 terminated ткст.
 */

дим* toString32z (дим[] s)
{
        if (s.ptr)
            if (! (s.length && s[$-1] is 0))
                   s = s ~ "\0"d;
        return s.ptr;
}

/*********************************
 * Convert a C-стиль 0 terminated ткст в_ an Массив of дим
 */

дим[] fromString32z (дим* s)
{
        return s ? s[0 .. strlenz(s)] : пусто;
}

/*********************************
 * portable strlen
 */

т_мера strlenz(T) (T* s)
{
        т_мера i;

        if (s)
            while (*s++)
                   ++i;
        return i;
}



debug (UnitTest)
{
        import rt.core.stdc.stdio;

        unittest
        {
        debug(ткст) printf("stringz.unittest\n");

        сим* p = вТкст0("foo");
        assert(strlenz(p) == 3);
        сим foo[] = "abbzxyzzy";
        p = вТкст0(foo[3..5]);
        assert(strlenz(p) == 2);

        ткст тест = "\0";
        p = вТкст0(тест);
        assert(*p == 0);
        assert(p == тест.ptr);
        }
}

