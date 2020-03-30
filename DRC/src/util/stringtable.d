/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/stringtable.d, root/_stringtable.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_stringtable.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/stringtable.d
 */

module util.stringtable;

import cidrus;
import util.rmem, util.хэш;

private const POOL_BITS = 12;
private const POOL_SIZE = (1U << POOL_BITS);

/*
Возвращает the smallest integer power of 2 larger than val.
if val > 2^^63 on 64-bit targets or val > 2^^31 on 32-bit targets it enters an
endless loop because of overflow.
*/
private т_мера nextpow2(т_мера val)   
{
    т_мера res = 1;
    while (res < val)
        res <<= 1;
    return res;
}

unittest
{
    assert(nextpow2(0) == 1);
    assert(nextpow2(0xFFFF) == (1 << 16));
    assert(nextpow2(т_мера.max / 2) == т_мера.max / 2 + 1);
    // note: nextpow2((1UL << 63) + 1) результатs in an endless loop
}

private const loadFactorNumerator = 8;
private const loadFactorDenominator = 10;        // for a load factor of 0.8

private struct StringEntry
{
    бцел хэш;
    бцел vptr;
}

// StringValue is a variable-length structure. It has neither proper c'tors nor a
// factory method because the only thing which should be creating these is ТаблицаСтрок.
struct StringValue(T)
{
    T значение; //T is/should typically be a pointer or a slice
    private т_мера length;

    ткст0 lstring()
    {
        return cast(сим*)(&this + 1);
    }

    т_мера len()
    {
        return length;
    }

    ткст0 toDchars()
    {
        return cast(сим*)(&this + 1);
    }

    /// Возвращает: The content of this entry as a D slice
    ткст вТкст()
    {
        return (cast(сим*)(&this + 1))[0 .. length];
    }
}

struct ТаблицаСтрок(T)
{
private:
    StringEntry[] table;
    ббайт*[] pools;
    т_мера nfill;
    т_мера count;
    т_мера countTrigger;   // amount which will trigger growing the table

public:
    проц _иниц(т_мера size = 0)
    {
        size = nextpow2((size * loadFactorDenominator) / loadFactorNumerator);
        if (size < 32)
            size = 32;
        table = (cast(StringEntry*)mem.xcalloc(size, (table[0]).sizeof))[0 .. size];
        countTrigger = (table.length * loadFactorNumerator) / loadFactorDenominator;
        pools = null;
        nfill = 0;
        count = 0;
    }

    проц сбрось(т_мера size = 0)
    {
        freeMem();
        _иниц(size);
    }

    static ~this() 
    {
        freeMem();
    }

    /**
    Looks up the given ткст in the ткст table and returns its associated
    значение.

    Параметры:
     s = the ткст to look up
     length = the length of $(D_PARAM s)
     str = the ткст to look up

    Возвращает: the ткст's associated значение, or `null` if the ткст doesn't
     exist in the ткст table
    */
    StringValue!(T)* lookup(ткст str) 
    {
        т_мера хэш = calcHash(str);
        т_мера i = findSlot(хэш, str);
        // printf("lookup %.*s %p\n", cast(цел)str.length, str.ptr, table[i].значение ?: null);
        return дайЗначение(table[i].vptr);
    }

    /// ditto
    StringValue!(T)* lookup(ткст0 s, т_мера length) 
    {
        return lookup(s[0 .. length]);
    }

    /**
    Inserts the given ткст and the given associated значение into the ткст
    table.

    Параметры:
     s = the ткст to вставь
     length = the length of $(D_PARAM s)
     ptrvalue = the значение to associate with the inserted ткст
     str = the ткст to вставь
     значение = the значение to associate with the inserted ткст

    Возвращает: the newly inserted значение, or `null` if the ткст table already
     содержит the ткст
    */
    StringValue!(T)* вставь(ткст str, T значение)  
    {
        т_мера хэш = calcHash(str);
        т_мера i = findSlot(хэш, str);
        if (table[i].vptr)
            return null; // already in table
        if (++count > countTrigger)
        {
            grow();
            i = findSlot(хэш, str);
        }
        table[i].хэш = хэш;
        table[i].vptr = allocValue(str, значение);
        // printf("вставь %.*s %p\n", cast(цел)str.length, str.ptr, table[i].значение ?: NULL);
        return дайЗначение(table[i].vptr);
    }

    /// ditto
    StringValue!(T)* вставь(ткст0 s, т_мера length, T значение)  
    {
        return вставь(s[0 .. length], значение);
    }

    StringValue!(T)* update(ткст str)  
    {
        т_мера хэш = calcHash(str);
        т_мера i = findSlot(хэш, str);
        if (!table[i].vptr)
        {
            if (++count > countTrigger)
            {
                grow();
                i = findSlot(хэш, str);
            }
            table[i].хэш = хэш;
            table[i].vptr = allocValue(str, T.init);
        }
        // printf("update %.*s %p\n", cast(цел)str.length, str.ptr, table[i].значение ?: NULL);
        return дайЗначение(table[i].vptr);
    }

    StringValue!(T)* update(ткст0 s, т_мера length)  
    {
        return update(s[0 .. length]);
    }

    /********************************
     * Walk the contents of the ткст table,
     * calling fp for each entry.
     * Параметры:
     *      fp = function to call. Возвращает !=0 to stop
     * Возвращает:
     *      last return значение of fp call
     */
    цел apply(цел function(StringValue!(T)*) fp) 
    {
        foreach ( se; table)
        {
            if (!se.vptr)
                continue;
            const sv = дайЗначение(se.vptr);
            цел результат = (*fp)(sv);
            if (результат)
                return результат;
        }
        return 0;
    }

    /// ditto
    extern(D) цел opApply( цел delegate(StringValue!(T)*)  dg) 
    {
        foreach (se; table)
        {
            if (!se.vptr)
                continue;
            const sv = дайЗначение(se.vptr);
            цел результат = dg(sv);
            if (результат)
                return результат;
        }
        return 0;
    }

private:
    /// Free all memory in use by this ТаблицаСтрок
    проц freeMem()  
    {
        foreach (pool; pools)
            mem.xfree(pool);
        mem.xfree(table.ptr);
        mem.xfree(pools.ptr);
        table = null;
        pools = null;
    }

    бцел allocValue(ткст str, T значение)  
    {
        т_мера члобайт = (StringValue!(T)).sizeof + str.length + 1;
        if (!pools.length || nfill + члобайт > POOL_SIZE)
        {
            pools = (cast(ббайт**) mem.xrealloc(pools.ptr, (pools.length + 1) * (pools[0]).sizeof))[0 .. pools.length + 1];
            pools[$-1] = cast(ббайт*) mem.xmalloc(члобайт > POOL_SIZE ? члобайт : POOL_SIZE);
            if (mem.смИниц_ли)
                memset(pools[$ - 1], 0xff, POOL_SIZE); // 0xff less likely to produce СМ pointer
            nfill = 0;
        }
        StringValue!(T)* sv = cast(StringValue!(T)*)&pools[$ - 1][nfill];
        sv.значение = значение;
        sv.length = str.length;
        .memcpy(sv.lstring(), str.ptr, str.length);
        sv.lstring()[str.length] = 0;
        бцел vptr = cast(бцел)(pools.length << POOL_BITS | nfill);
        nfill += члобайт + (-члобайт & 7); // align to 8 bytes
        return vptr;
    }

    StringValue!(T)* дайЗначение(бцел vptr) 
    {
        if (!vptr)
            return null;
        const т_мера idx = (vptr >> POOL_BITS) - 1;
        const т_мера off = vptr & POOL_SIZE - 1;
        return cast(StringValue!(T)*)&pools[idx][off];
    }

    т_мера findSlot(hash_t хэш, ткст str)
    {
        // quadratic probing using triangular numbers
        // http://stackoverflow.com/questions/2348187/moving-from-linear-probing-to-quadratic-probing-хэш-collisons/2349774#2349774
        for (т_мера i = хэш & (table.length - 1), j = 1;; ++j)
        {
            StringValue!(T)* sv;
            auto vptr = table[i].vptr;
            if (!vptr || table[i].хэш == хэш && (sv = дайЗначение(vptr)).length == str.length && .memcmp(str.ptr, sv.toDchars(), str.length) == 0)
                return i;
            i = (i + j) & (table.length - 1);
        }
    }

    проц grow()  
    {
        const odim = table.length;
        auto otab = table;
        const ndim = table.length * 2;
        countTrigger = (ndim * loadFactorNumerator) / loadFactorDenominator;
        table = (cast(StringEntry*)mem.xcalloc_noscan(ndim, (table[0]).sizeof))[0 .. ndim];
        foreach ( se; otab[0 .. odim])
        {
            if (!se.vptr)
                continue;
            const sv = дайЗначение(se.vptr);
            table[findSlot(se.хэш, sv.вТкст())] = se;
        }
        mem.xfree(otab.ptr);
    }
}

unittest
{
    ТаблицаСтрок!(сим*) tab;
    tab._иниц(10);

    // construct two strings with the same text, but a different pointer
    сим[6] fooBuffer = "foofoo";
    ткст foo = fooBuffer[0 .. 3];
    ткст fooAltPtr = fooBuffer[3 .. 6];

    assert(foo.ptr != fooAltPtr.ptr);

    // first insertion returns значение
    assert(tab.вставь(foo, foo.ptr).значение == foo.ptr);

    // subsequent insertion of same ткст return null
    assert(tab.вставь(foo.ptr, foo.length, foo.ptr) == null);
    assert(tab.вставь(fooAltPtr, foo.ptr) == null);

    const lookup = tab.lookup("foo");
    assert(lookup.значение == foo.ptr);
    assert(lookup.len == 3);
    assert(lookup.вТкст() == "foo");

    assert(tab.lookup("bar") == null);
    tab.update("bar".ptr, "bar".length);
    assert(tab.lookup("bar").значение == null);

    tab.сбрось(0);
    assert(tab.lookup("foo".ptr, "foo".length) == null);
    //tab.вставь("bar");
}

unittest
{
    ТаблицаСтрок!(ук) tab;
    tab._иниц(100);

    const testCount = 2000;

    сим[2 * testCount] буф;

    foreach(i; new бцел[0 .. testCount])
    {
        буф[i * 2 + 0] = cast(сим) (i % 256);
        буф[i * 2 + 1] = cast(сим) (i / 256);
        auto toInsert = cast(ткст) буф[i * 2 .. i * 2 + 2];
        tab.вставь(toInsert, cast(ук) i);
    }

    foreach(i; new бцел[0 .. testCount])
    {
        auto toLookup = cast(ткст) буф[i * 2 .. i * 2 + 2];
        assert(tab.lookup(toLookup).значение == cast(ук) i);
    }
}

unittest
{
    ТаблицаСтрок!(цел) tab;
    tab._иниц(10);
    tab.вставь("foo",  4);
    tab.вставь("bar",  6);

    static цел результатFp = 0;
    цел результатDg = 0;
    static бул returnImmediately = нет;
/+
    цел function(StringValue!(цел)*  applyFunc = StringValue!(цел)* s)
    {
        результатFp += s.значение;
        return returnImmediately;
    }

     цел delegate(StringValue!(цел)*  applyDeleg = StringValue!(цел)* s)
    {
        результатDg += s.значение;
        return returnImmediately;
    }
+/
    tab.apply(applyFunc);
    tab.opApply(applyDeleg);

    assert(результатDg == 10);
    assert(результатFp == 10);

    returnImmediately = да;

    tab.apply(applyFunc);
    tab.opApply(applyDeleg);

    // Order of ткст table iteration is not specified, either foo or bar could
    // have been visited first.
    assert(результатDg == 14 || результатDg == 16);
    assert(результатFp == 14 || результатFp == 16);
}
