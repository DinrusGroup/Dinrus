/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/массив.d, root/_array.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_array.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/массив.d
 */

module util.array;

import cidrus;

import util.rmem;
import util.string;

debug
{
    debug = stomp; // flush out dangling pointer problems by stomping on unused memory
}

 class МассивДРК(T)
{
    т_мера length;

private:
    T[] данные;
    const SMALLARRAYCAP = 1;
    T[SMALLARRAYCAP] smallarray; // inline storage for small arrays

public:
    /*******************
     * Параметры:
     *  dim = initial length of массив
     */
    this(т_мера dim) 
    {
        резервируй(dim);
        this.length = dim;
    }

    ~this() 
    {
        debug (stomp) memset(данные.ptr, 0xFF, данные.length);
        if (данные.ptr != &smallarray[0])
            mem.xfree(данные.ptr);
    }
    ///returns elements comma separated in []
    ткст вТкст() 
    {
        static ткст вТкстРеализ(alias вТкстFunc, МассивДРК)(МассивДРК* a, бул quoted = нет)
        {
            ткст[] буф = (cast(ткст*)mem.xcalloc((ткст).sizeof, a.length))[0 .. a.length];
            т_мера len = 2; // [ and ]
            const seplen = quoted ? 3 : 1; // ',' or null terminator and optionally '"'
            if (a.length == 0)
                len += 1; // null terminator
            else
            {
                foreach (u; new бцел[0 .. a.length])
                {
                    буф[u] = вТкстFunc(a.данные[u]);
                    len += буф[u].length + seplen;
                }
            }
            ткст str = (cast(сим*)mem.xmalloc_noscan(len))[0..len];

            str[0] = '[';
            ткст0 p = str.ptr + 1;
            foreach (u; new бцел[0 .. a.length])
            {
                if (u)
                    *p++ = ',';
                if (quoted)
                    *p++ = '"';
                memcpy(p, буф[u].ptr, буф[u].length);
                p += буф[u].length;
                if (quoted)
                    *p++ = '"';
            }
            *p++ = ']';
            *p = 0;
            assert(p - str.ptr == str.length - 1); // null terminator
            mem.xfree(буф.ptr);
            return str[0 .. $-1];
        }

        static if (is(typeof(T.init.вТкст())))
        {
            return вТкстРеализ!(/*a =>*/ a.вТкст)(&this);
        }
        else static if (is(typeof(T.init.вТкстД())))
        {
            return вТкстРеализ!(/*a =>*/ a.вТкстД)(&this, да);
        }
        else
        {
            assert(0);
        }
    }
    ///ditto
    ткст0 вТкст0() 
    {
        return вТкст.ptr;
    }

    МассивДРК сунь(T ptr) 
    {
        резервируй(1);
        данные[length++] = ptr;
        return this;
    }

    МассивДРК суньСрез(T[] a) 
    {
        const oldLength = length;
        устДим(oldLength + a.length);
        memcpy(данные.ptr + oldLength, a.ptr, a.length * T.sizeof);
        return this;
    }

    МассивДРК приставь(typeof(this)* a) 
    {
        вставь(length, a);
        return this;
    }

    проц резервируй(т_мера nentries)  
    {
        //printf("МассивДРК::резервируй: length = %d, данные.length = %d, nentries = %d\n", (цел)length, (цел)данные.length, (цел)nentries);
        if (данные.length - length < nentries)
        {
            if (данные.length == 0)
            {
                // Not properly initialized, someone memset it to нуль
                if (nentries <= SMALLARRAYCAP)
                {
                    данные = SMALLARRAYCAP ? smallarray[] : null;
                }
                else
                {
                    auto p = cast(T*)mem.xmalloc(nentries * T.sizeof);
                    данные = p[0 .. nentries];
                }
            }
            else if (данные.length == SMALLARRAYCAP)
            {
                const allocdim = length + nentries;
                auto p = cast(T*)mem.xmalloc(allocdim * T.sizeof);
                memcpy(p, smallarray.ptr, length * T.sizeof);
                данные = p[0 .. allocdim];
            }
            else
            {
                /* Increase size by 1.5x to avoid excessive memory fragmentation
                 */
                auto increment = length / 2;
                if (nentries > increment)       // if 1.5 is not enough
                    increment = nentries;
                const allocdim = length + increment;
                debug (stomp)
                {
                    // always move using размести-копируй-stomp-free
                    auto p = cast(T*)mem.xmalloc(allocdim * T.sizeof);
                    memcpy(p, данные.ptr, length * T.sizeof);
                    memset(данные.ptr, 0xFF, данные.length * T.sizeof);
                    mem.xfree(данные.ptr);
                }
                else
                    auto p = cast(T*)mem.xrealloc(данные.ptr, allocdim * T.sizeof);
                данные = p[0 .. allocdim];
            }

            debug (stomp)
            {
                if (length < данные.length)
                    memset(данные.ptr + length, 0xFF, (данные.length - length) * T.sizeof);
            }
            else
            {
                if (mem.смИниц_ли)
                    if (length < данные.length)
                        memset(данные.ptr + length, 0xFF, (данные.length - length) * T.sizeof);
            }
        }
    }

    проц удали(т_мера i)
    {
        if (length - i - 1)
            memmove(данные.ptr + i, данные.ptr + i + 1, (length - i - 1) * T.sizeof);
        length--;
        debug (stomp) memset(данные.ptr + length, 0xFF, T.sizeof);
    }

    проц вставь(т_мера index, typeof(this)* a)  
    {
        if (a)
        {
            т_мера d = a.length;
            резервируй(d);
            if (length != index)
                memmove(данные.ptr + index + d, данные.ptr + index, (length - index) * T.sizeof);
            memcpy(данные.ptr + index, a.данные.ptr, d * T.sizeof);
            length += d;
        }
    }

    проц вставь(т_мера index, T ptr)  
    {
        резервируй(1);
        memmove(данные.ptr + index + 1, данные.ptr + index, (length - index) * T.sizeof);
        данные[index] = ptr;
        length++;
    }

    проц устДим(т_мера newdim)  
    {
        if (length < newdim)
        {
            резервируй(newdim - length);
        }
        length = newdim;
    }

    т_мера найди(T ptr) 
    {
        foreach (i; new бцел[0 .. length])
            if (данные[i] is ptr)
                return i;
        return т_мера.max;
    }

    бул содержит(T ptr)  
    {
        return найди(ptr) != т_мера.max;
    }

    T opIndex(т_мера i) 
    {
        return данные[i];
    }

 T* tdata() 
    {
        return данные.ptr;
    }

    МассивДРК!(T)* копируй()
    {
        auto a = new МассивДРК!(T)();
        a.устДим(length);
        memcpy(a.данные.ptr, данные.ptr, length * T.sizeof);
        return a;
    }

    проц shift(T ptr)  
    {
        резервируй(1);
        memmove(данные.ptr + 1, данные.ptr, length * T.sizeof);
        данные[0] = ptr;
        length++;
    }

    проц нуль() 
    {
        данные[0 .. length] = T.init;
    }

    T вынь() 
    {
        debug (stomp)
        {
            assert(length);
            auto результат = данные[length - 1];
            удали(length - 1);
            return результат;
        }
        else
            return данные[--length];
    }

    T[] opSlice() 
    {
        return данные[0 .. length];
    }

    T[] opSlice(т_мера a, т_мера b) 
    {
        assert(a <= b && b <= length);
        return данные[a .. b];
    }

    alias length opDollar, dim;
}

unittest
{
    // Test for objects implementing вТкст()
    struct S
    {
        цел s = -1;
        ткст вТкст()
        {
            return "S";
        }
    }
    auto массив = new МассивДРК!(S)(4);
    assert(массив.вТкст() == "[S,S,S,S]");
    массив.устДим(0);
    assert(массив.вТкст() == "[]");

    // Test for вТкстД()
    auto strarray = new МассивДРК!(сим*)(2);
    strarray[0] = "hello";
    strarray[1] = "world";
    auto str = strarray.вТкст();
    assert(str == `["hello","world"]`);
    // Test presence of null terminator.
    assert(str.ptr[str.length] == '\0');
}

unittest
{
    auto массив = new МассивДРК!(double)(4);
    массив.shift(10);
    массив.сунь(20);
    массив[2] = 15;
    assert(массив[0] == 10);
    assert(массив.найди(10) == 0);
    assert(массив.найди(20) == 5);
    assert(!массив.содержит(99));
    массив.удали(1);
    assert(массив.length == 5);
    assert(массив[1] == 15);
    assert(массив.вынь() == 20);
    assert(массив.length == 4);
    массив.вставь(1, 30);
    assert(массив[1] == 30);
    assert(массив[2] == 15);
}

unittest
{
    auto arrayA = new МассивДРК!(цел)(0);
    цел[3] буф = [10, 15, 20];
    arrayA.суньСрез(буф);
    assert(arrayA[] == буф[]);
    auto arrayPtr = arrayA.копируй();
    assert(arrayPtr);
    assert((*arrayPtr)[] == arrayA[]);
    assert(arrayPtr.tdata != arrayA.tdata);

    arrayPtr.устДим(0);
    цел[2] buf2 = [100, 200];
    arrayPtr.суньСрез(buf2);

    arrayA.приставь(arrayPtr);
    assert(arrayA[3..$] == buf2[]);
    arrayA.вставь(0, arrayPtr);
    assert(arrayA[] == [100, 200, 10, 15, 20, 100, 200]);

    arrayA.нуль();
    foreach(e; arrayA)
        assert(e == 0);
}

/**
 * Exposes the given root МассивДРК as a standard D массив.
 * Параметры:
 *  массив = the массив to expose.
 * Возвращает:
 *  The given массив exposed to a standard D массив.
 */
 T[] peekSlice(T)(МассивДРК!(T)* массив)  
{
    return массив ? (*массив)[] : null;
}

/**
 * Splits the массив at $(D index) and expands it to make room for $(D length)
 * elements by shifting everything past $(D index) to the right.
 * Параметры:
 *  массив = the массив to split.
 *  index = the index to split the массив from.
 *  length = the number of elements to make room for starting at $(D index).
 */
проц split(T)(ref МассивДРК!(T) массив, т_мера index, т_мера length)  
{
    if (length > 0)
    {
        auto previousDim = массив.length;
        массив.устДим(массив.length + length);
        for (т_мера i = previousDim; i > index;)
        {
            i--;
            массив[i + length] = массив[i];
        }
    }
}
unittest
{
    auto массив = new МассивДРК!(цел)();
    массив.split(0, 0);
    assert([] == массив[]);
    массив.сунь(1).сунь(3);
    массив.split(1, 1);
    массив[1] = 2;
    assert([1, 2, 3] == массив[]);
    массив.split(2, 3);
    массив[2] = 8;
    массив[3] = 20;
    массив[4] = 4;
    assert([1, 2, 8, 20, 4, 3] == массив[]);
    массив.split(0, 0);
    assert([1, 2, 8, 20, 4, 3] == массив[]);
    массив.split(0, 1);
    массив[0] = 123;
    assert([123, 1, 2, 8, 20, 4, 3] == массив[]);
    массив.split(0, 3);
    массив[0] = 123;
    массив[1] = 421;
    массив[2] = 910;
    assert([123, 421, 910, 123, 1, 2, 8, 20, 4, 3] == (&массив).peekSlice());
}

/**
 * Reverse an массив in-place.
 * Параметры:
 *      a = массив
 * Возвращает:
 *      reversed a[]
 */
T[] reverse(T)(T[] a)  
{
    if (a.length > 1)
    {
        const mid = (a.length + 1) >> 1;
        foreach (i; new бцел[0 .. mid])
        {
            T e = a[i];
            a[i] = a[$ - 1 - i];
            a[$ - 1 - i] = e;
        }
    }
    return a;
}

unittest
{
    цел[] a1 = [];
    assert(reverse(a1) == []);
    цел[] a2 = [2];
    assert(reverse(a2) == [2]);
    цел[] a3 = [2,3];
    assert(reverse(a3) == [3,2]);
    цел[] a4 = [2,3,4];
    assert(reverse(a4) == [4,3,2]);
    цел[] a5 = [2,3,4,5];
    assert(reverse(a5) == [5,4,3,2]);
}

unittest
{
    //test вТкст/вТкст0.  Идентификатор2 is a simple объект that has a usable .вТкст
    //import drc.lexer.Identifier : Идентификатор2;
   // import core.stdc.ткст : strcmp;

    auto массив = new МассивДРК!(Идентификатор2)();
    массив.сунь(new Идентификатор2("id1"));
    массив.сунь(new Идентификатор2("id2"));

    ткст expected = "[id1,id2]";
    assert(массив.вТкст == expected);
    assert(strcmp(массив.вТкст0, expected.ptr) == 0);
}
