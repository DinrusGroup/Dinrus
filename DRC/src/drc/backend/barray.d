/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2018-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/barrayf.d, backend/barray.d)
 * Documentation: https://dlang.org/phobos/dmd_backend_barray.html
 */

module drc.backend.barray;

import cidrus;



/*extern (C++):*/ проц err_nomem();

/*************************************
 * A reusable массив that ratchets up in capacity.
 */
class Barray(T)
{
    /**********************
     * Set useable length of массив.
     * Параметры:
     *  length = minimum number of elements in массив
     */
    проц setLength(т_мера length)
    {
        static проц enlarge(ref Barray barray, т_мера length)
        {
            pragma(inline, нет);
            auto newcap = (barray.capacity == 0) ? length : length + (length >> 1);
            barray.capacity = (newcap + 15) & ~15;
            T* p = cast(T*)realloc(barray.массив.ptr, barray.capacity * T.sizeof);
            if (length && !p)
            {
                    err_nomem();
            }
            barray.массив = p[0 .. length];
        }

        if (length <= capacity)
            массив = массив.ptr[0 .. length];     // the fast path
        else
            enlarge(this, length);              // the slow path
    }


    /*******************
     * Append element t to массив.
     * Параметры:
     *  t = element to приставь
     */
    проц сунь(T t)
    {
        const i = length;
        setLength(i + 1);
        массив[i] = t;
    }

    /**********************
     * Move the last element from the массив into [i].
     * Reduce the массив length by one.
     * Параметры:
     *  i = index of element to удали
     */
    проц удали(т_мера i)
    {
        const len = length - 1;
        if (i != len)
        {
            массив[i] = массив[len];
        }
        setLength(len);
    }

    /******************
     * Release all memory используется.
     */
    ~this()
    {
        free(массив.ptr);
        массив = null;
        capacity = 0;
    }

   // alias this массив;
    T[] массив;

  private:
    т_мера capacity;
}

unittest
{
    Barray!(цел) a;
    a.setLength(10);
    assert(a.length == 10);
    a.setLength(4);
    assert(a.length == 4);
    foreach (i, ref v; a[])
        v = cast(цел) i * 2;
    foreach (i, ref v; a[])
        assert(v == i * 2);
    a.удали(3);
    assert(a.length == 3);
    a.сунь(50);
    a.удали(1);
    assert(a[1] == 50);
}
