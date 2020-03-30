/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/aav.d, root/_aav.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_aav.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/aav.d
 */

module util.aav;

import cidrus;
import util.rmem;

private т_мера хэш(т_мера a)
{
    a ^= (a >> 20) ^ (a >> 12);
    return a ^ (a >> 7) ^ (a >> 4);
}

struct ШаблонКлючЗначение(K,V)
{
    K ключ;
    V значение;
}

alias  ук Ключ, Значение;

alias ШаблонКлючЗначение!(Ключ, Значение) КлючЗначение;

struct aaA
{
    aaA* следщ;
    КлючЗначение ключЗначение;
    alias ключЗначение opCall;
}

struct AA
{
    aaA** b;
    т_мера b_length;
    т_мера nodes; // total number of aaA nodes
    aaA*[4] binit; // initial значение of b[]
    aaA aafirst; // a lot of these AA's have only one entry
}

/****************************************************
 * Determine number of entries in associative массив.
 */
private т_мера dmd_aaLen(AA* aa) 
{
    return aa ? aa.nodes : 0;
}

/*************************************************
 * Get pointer to значение in associative массив indexed by ключ.
 * Add entry for ключ if it is not already there, returning a pointer to a null Значение.
 * Create the associative массив if it does not already exist.
 */
private Значение* dmd_aaGet(AA** paa, Ключ ключ) {
    //printf("paa = %p\n", paa);
    if (!*paa)
    {
        AA* a = cast(AA*)mem.xmalloc(AA.sizeof);
        a.b = cast(aaA**)a.binit;
        a.b_length = 4;
        a.nodes = 0;
        a.binit[0] = null;
        a.binit[1] = null;
        a.binit[2] = null;
        a.binit[3] = null;
        *paa = a;
        assert((*paa).b_length == 4);
    }
    //printf("paa = %p, *paa = %p\n", paa, *paa);
    assert((*paa).b_length);
    т_мера i = хэш(cast(т_мера)ключ) & ((*paa).b_length - 1);
    aaA** pe = &(*paa).b[i];
    aaA* e;
    while ((e = *pe) !is null)
    {
        if (ключ == e.ключ)
            return &e.значение;
        pe = &e.следщ;
    }
    // Not found, создай new elem
    //printf("создай new one\n");
    т_мера nodes = ++(*paa).nodes;
    e = (nodes != 1) ? cast(aaA*)mem.xmalloc(aaA.sizeof) : &(*paa).aafirst;
    //e = new aaA();
    e.следщ = null;
    e.ключ = ключ;
    e.значение = null;
    *pe = e;
    //printf("length = %d, nodes = %d\n", (*paa)->b_length, nodes);
    if (nodes > (*paa).b_length * 2)
    {
        //printf("rehash\n");
        dmd_aaRehash(paa);
    }
    return &e.значение;
}

/*************************************************
 * Get значение in associative массив indexed by ключ.
 * Возвращает NULL if it is not already there.
 */
private Значение dmd_aaGetRvalue(AA* aa, Ключ ключ)
{
    //printf("_aaGetRvalue(ключ = %p)\n", ключ);
    if (aa)
    {
        т_мера i;
        т_мера len = aa.b_length;
        i = хэш(cast(т_мера)ключ) & (len - 1);
        aaA* e = aa.b[i];
        while (e)
        {
            if (ключ == e.ключ)
                return e.значение;
            e = e.следщ;
        }
    }
    return null; // not found
}

/**
Gets a range of ключ/values for `aa`.

Возвращает: a range of ключ/values for `aa`.
*/
 AARange!(Ключ, Значение) asRange(AA* aa)  
{
    return AARange!(Ключ, Значение)(aa);
}

private struct AARange(K,V)
{
    AA* aa;
    // current index into bucket массив `aa.b`
    т_мера bIndex;
    aaA* current;

    static AARange opCall(AA* aa) 
    {
        if (aa)
        {
            this.aa = aa;
            toNext();
        }
    }

     бул empty() 
    {
        return current is null;
    }

     ШаблонКлючЗначение!(K,V) front() 
    {
        return cast(ШаблонКлючЗначение!(K,V)) current.ключЗначение;
    }

    проц popFront()
    {
        if (current.следщ)
            current = current.следщ;
        else
        {
            bIndex++;
            toNext();
        }
    }

    private проц toNext() 
    {
        for (; bIndex < aa.b_length; bIndex++)
        {
            if (auto следщ = aa.b[bIndex])
            {
                current = следщ;
                return;
            }
        }
        current = null;
    }
}

unittest
{
    AA* aa = null;
    foreach(ключЗначение; aa.asRange)
        assert(0);

    const totalKeyLength = 50;
    foreach (i; new бцел[1 .. totalKeyLength + 1])
    {
        auto ключ = cast(ук)i;
        {
            auto valuePtr = dmd_aaGet(&aa, ключ);
            assert(valuePtr);
            *valuePtr = ключ;
        }
        бул[totalKeyLength] found;
        т_мера rangeCount = 0;
        foreach (ключЗначение; aa.asRange)
        {
            assert(ключЗначение.ключ <= ключ);
            assert(ключЗначение.ключ == ключЗначение.значение);
            rangeCount++;
            assert(!found[cast(т_мера)ключЗначение.ключ - 1]);
            found[cast(т_мера)ключЗначение.ключ - 1] = да;
        }
        assert(rangeCount == i);
    }
}

/********************************************
 * Рехэшировать массив.
 */
private проц dmd_aaRehash(AA** paa)  
{
    //printf("Rehash\n");
    if (*paa)
    {
        AA* aa = *paa;
        if (aa)
        {
            т_мера len = aa.b_length;
            if (len == 4)
                len = 32;
            else
                len *= 4;
            aaA** newb = cast(aaA**)mem.xmalloc(aaA.sizeof * len);
            memset(newb, 0, len * (aaA*).sizeof);
            for (т_мера k = 0; k < aa.b_length; k++)
            {
                aaA* e = aa.b[k];
                while (e)
                {
                    aaA* enext = e.следщ;
                    т_мера j = хэш(cast(т_мера)e.ключ) & (len - 1);
                    e.следщ = newb[j];
                    newb[j] = e;
                    e = enext;
                }
            }
            if (aa.b != cast(aaA**)aa.binit)
                mem.xfree(aa.b);
            aa.b = newb;
            aa.b_length = len;
        }
    }
}

unittest
{
    AA* aa = null;
    Значение v = dmd_aaGetRvalue(aa, null);
    assert(!v);
    Значение* pv = dmd_aaGet(&aa, null);
    assert(pv);
    *pv = cast(ук)3;
    v = dmd_aaGetRvalue(aa, null);
    assert(v == cast(ук)3);
}

struct AssocArray(K,V)
{
    private AA* aa;

    /**
    Возвращает: The number of ключ/значение pairs.
    */
     т_мера length() 
    {
        return dmd_aaLen(aa);
    }

    /**
    Lookup значение associated with `ключ` and return the address to it. If the `ключ`
    has not been added, it adds it and returns the address to the new значение.

    Параметры:
        ключ = ключ to lookup the значение for

    Возвращает: the address to the значение associated with `ключ`. If `ключ` does not exist, it
             is added and the address to the new значение is returned.
    */
    V* getLvalue(K ключ) 
    {
        return cast(V*)dmd_aaGet(&aa, cast(ук)ключ);
    }

    /**
    Lookup and return the значение associated with `ключ`, if the `ключ` has not been
    added, it returns null.

    Параметры:
        ключ = ключ to lookup the значение for

    Возвращает: the значение associated with `ключ` if present, otherwise, null.
    */
    V opIndex(K ключ) 
    {
        return cast(V)dmd_aaGetRvalue(aa, cast(ук)ключ);
    }

    /**
    Gets a range of ключ/values for `aa`.

    Возвращает: a range of ключ/values for `aa`.
    */
     AARange!(K,V) asRange() 
    {
        return AARange!(K,V)(aa);
    }
}

///
unittest
{
    auto foo = new Object();
    auto bar = new Object();

    AssocArray!(Object, Object) aa;

    assert(aa[foo] is null);
    assert(aa.length == 0);

    auto fooValuePtr = aa.getLvalue(foo);
    *fooValuePtr = bar;

    assert(aa[foo] is bar);
    assert(aa.length == 1);
}
