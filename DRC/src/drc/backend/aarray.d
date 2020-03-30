/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright), Dave Fladebo
 * License:     Distributed under the Boost Software License, Version 1.0.
 *              http://www.boost.org/LICENSE_1_0.txt
 * Source:      https://github.com/dlang/dmd/blob/master/src/dmd/backend/aarray.d
 */

module drc.backend.aarray;

import cidrus;

alias т_мера hash_t;

//

/*********************
 * This is the "bucket" используется by the AArray.
 */
private struct aaA
{
    aaA *следщ;
    hash_t хэш;        // хэш of the ключ
    /* ключ   */         // ключ значение goes here
    /* значение */         // значение значение goes here
}

/**************************
 * Associative МассивДРК тип.
 * Параметры:
 *      TKey = тип that has члены Ключ, getHash(), and равен()
 *      Значение = значение тип
 */

class AArray(TKey, Значение)
{
//
    alias  TKey.Ключ Ключ;       // ключ тип

    ~this()
    {
        разрушь();
    }

    /****
     * Frees all the данные используется by AArray
     */
    проц разрушь()
    {
        if (buckets)
        {
            foreach (e; buckets)
            {
                while (e)
                {
                    auto en = e;
                    e = e.следщ;
                    free(en);
                }
            }
            free(buckets.ptr);
            buckets = null;
            nodes = 0;
        }
    }

    /********
     * Возвращает:
     *   Number of entries in the AArray
     */
    т_мера length()
    {
        return nodes;
    }

    /*************************************************
     * Get pointer to значение in associative массив indexed by ключ.
     * Add entry for ключ if it is not already there.
     * Параметры:
     *  pKey = pointer to ключ
     * Возвращает:
     *  pointer to Значение
     */

    Значение* get(Ключ* pkey)
    {
        //printf("AArray::get()\n");
        const aligned_keysize = aligntsize(Ключ.sizeof);

        if (!buckets.length)
        {
            alias  aaA* aaAp;
            const len = prime_list[0];
            auto p = cast(aaAp*)calloc(len, aaAp.sizeof);
            assert(p);
            buckets = p[0 .. len];
        }

        hash_t key_hash = tkey.getHash(pkey);
        const i = key_hash % buckets.length;
        //printf("key_hash = %x, buckets.length = %d, i = %d\n", key_hash, buckets.length, i);
        aaA* e;
        auto pe = &buckets[i];
        while ((e = *pe) != null)
        {
            if (key_hash == e.хэш &&
                tkey.равен(pkey, cast(Ключ*)(e + 1)))
            {
                goto Lret;
            }
            pe = &e.следщ;
        }

        // Not found, создай new elem
        //printf("создай new one\n");
        e = cast(aaA *) malloc(aaA.sizeof + aligned_keysize + Значение.sizeof);
        assert(e);
        memcpy(e + 1, pkey, Ключ.sizeof);
        memset(cast(проц *)(e + 1) + aligned_keysize, 0, Значение.sizeof);
        e.хэш = key_hash;
        e.следщ = null;
        *pe = e;

        ++nodes;
        //printf("length = %d, nodes = %d\n", buckets_length, nodes);
        if (nodes > buckets.length * 4)
        {
            //printf("rehash()\n");
            rehash();
        }

    Lret:
        return cast(Значение*)(cast(ук)(e + 1) + aligned_keysize);
    }

    /*************************************************
     * Determine if ключ is in aa.
     * Параметры:
     *  pKey = pointer to ключ
     * Возвращает:
     *  null    not in aa
     *  !=null  in aa, return pointer to значение
     */

    Значение* isIn(Ключ* pkey)
    {
        //printf("AArray.isIn(), .length = %d, .ptr = %p\n", nodes, buckets.ptr);
        if (!nodes)
            return null;

        const key_hash = tkey.getHash(pkey);
        //printf("хэш = %d\n", key_hash);
        const i = key_hash % buckets.length;
        auto e = buckets[i];
        while (e != null)
        {
            if (key_hash == e.хэш &&
                tkey.равен(pkey, cast(Ключ*)(e + 1)))
            {
                return cast(Значение*)(cast(ук)(e + 1) + aligntsize(Ключ.sizeof));
            }

            e = e.следщ;
        }

        // Not found
        return null;
    }


    /*************************************************
     * Delete ключ entry in aa[].
     * If ключ is not in aa[], do nothing.
     * Параметры:
     *  pKey = pointer to ключ
     */

    проц del(Ключ *pkey)
    {
        if (!nodes)
            return;

        const key_hash = tkey.getHash(pkey);
        //printf("хэш = %d\n", key_hash);
        const i = key_hash % buckets.length;
        auto pe = &buckets[i];
        aaA* e;
        while ((e = *pe) != null)       // null means not found
        {
            if (key_hash == e.хэш &&
                tkey.равен(pkey, cast(Ключ*)(e + 1)))
            {
                *pe = e.следщ;
                --nodes;
                free(e);
                break;
            }
            pe = &e.следщ;
        }
    }


    /********************************************
     * Produce массив of keys from aa.
     * Возвращает:
     *  malloc'd массив of keys
     */

    Ключ[] keys()
    {
        if (!nodes)
            return null;

        auto p = cast(Ключ *)malloc(nodes * Ключ.sizeof);
        assert(p);
        auto q = p;
        foreach (e; buckets)
        {
            while (e)
            {
                memcpy(q, e + 1, Ключ.sizeof);
                ++q;
                e = e.следщ;
            }
        }
        return p[0 .. nodes];
    }

    /********************************************
     * Produce массив of values from aa.
     * Возвращает:
     *  malloc'd массив of values
     */

    Значение[] values()
    {
        if (!nodes)
            return null;

        const aligned_keysize = aligntsize(Ключ.sizeof);
        auto p = cast(Значение *)malloc(nodes * Значение.sizeof);
        assert(p);
        auto q = p;
        foreach (e; buckets)
        {
            while (e)
            {
                memcpy(q, cast(ук)(e + 1) + aligned_keysize, Значение.sizeof);
                ++q;
                e = e.следщ;
            }
        }
        return p[0 .. nodes];
    }

    /********************************************
     * Rehash an массив.
     */

    проц rehash()
    {
        //printf("Rehash\n");
        if (!nodes)
            return;

        т_мера newbuckets_length = prime_list[$ - 1];

        foreach (prime; prime_list[0 .. $ - 1])
        {
            if (nodes <= prime)
            {
                newbuckets_length = prime;
                break;
            }
        }
        auto newbuckets = cast(aaA**)calloc(newbuckets_length, (aaA*).sizeof);
        assert(newbuckets);

        foreach (e; buckets)
        {
            while (e)
            {
                auto en = e.следщ;
                auto b = &newbuckets[e.хэш % newbuckets_length];
                e.следщ = *b;
                *b = e;
                e = en;
            }
        }

        free(buckets.ptr);
        buckets = null;
        buckets = newbuckets[0 .. newbuckets_length];
    }

    alias цел delegate(Ключ*, Значение*) applyDg;
    /*********************************************
     * For each element in the AArray,
     * call dg(Ключ* pkey, Значение* pvalue)
     * If dg returns !=0, stop and return that значение.
     * Параметры:
     *  dg = delegate to call for each ключ/значение pair
     * Возвращает:
     *  !=0 : значение returned by first dg() call that returned non-нуль
     *  0   : no entries in aa, or all dg() calls returned 0
     */

    цел apply(applyDg dg)
    {
        if (!nodes)
            return 0;

        //printf("AArray.apply(aa = %p, keysize = %d, dg = %p)\n", &this, Ключ.sizeof, dg);

        const aligned_keysize = aligntsize(Ключ.sizeof);

        foreach (e; buckets)
        {
            while (e)
            {
                auto результат = dg(cast(Ключ*)(e + 1), cast(Значение*)(e + 1) + aligned_keysize);
                if (результат)
                    return результат;
                e = e.следщ;
            }
        }

        return 0;
    }

  private:

    aaA*[] buckets;
    т_мера nodes;               // number of nodes
    TKey tkey;
}

private:

/**********************************
 * Align to следщ pointer boundary, so значение
 * will be aligned.
 * Параметры:
 *      tsize = смещение to be aligned
 * Возвращает:
 *      aligned смещение
 */

т_мера aligntsize(т_мера tsize)
{
    // Is pointer alignment on the x64 4 bytes or 8?
    return (tsize + т_мера.sizeof - 1) & ~(т_мера.sizeof - 1);
}

const бцел[14] prime_list =
[
    97U,         389U,
    1543U,       6151U,
    24593U,      98317U,
    393241U,     1572869U,
    6291469U,    25165843U,
    100663319U,  402653189U,
    1610612741U, 4294967291U
];

/***************************************************************/

/***
 * A TKey for basic types
 * Параметры:
 *      K = a basic тип
 */
public struct Tinfo(K)
{
//
    alias  K Ключ;

    static hash_t getHash(Ключ* pk)
    {
        return cast(hash_t)*pk;
    }

    static бул равен(Ключ* pk1, Ключ* pk2)
    {
        return *pk1 == *pk2;
    }
}

/***************************************************************/

/****
 * A TKey that is a ткст
 */
public struct TinfoChars
{
//
    alias  ткст Ключ;

    static hash_t getHash(Ключ* pk)
    {
        auto буф = *pk;
        hash_t хэш = 0;
        foreach (v; буф)
            хэш = хэш * 11 + v;
        return хэш;
    }

    static бул равен(Ключ* pk1, Ключ* pk2)
    {
        auto buf1 = *pk1;
        auto buf2 = *pk2;
        return buf1.length == buf2.length &&
               memcmp(buf1.ptr, buf2.ptr, buf1.length) == 0;
    }
}

// Interface for C++ code
public  struct AAchars
{
//
    alias AArray!(TinfoChars, бцел) AA;
    AA aa;

    static AAchars* создай()
    {
        auto a = cast(AAchars*)calloc(1, AAchars.sizeof);
        assert(a);
        return a;
    }

    static проц разрушь(AAchars* aac)
    {
        aac.aa.разрушь();
        free(aac);
    }

    бцел* get(ткст0 s, бцел len)
    {
        auto буф = s[0 .. len];
        return aa.get(&буф);
    }

    бцел length()
    {
        return cast(бцел)aa.length();
    }
}

/***************************************************************/

// Ключ is the slice specified by (*TinfoPair.pbase)[Pair.start .. Pair.end]

struct Pair { бцел start, end; }

public struct TinfoPair
{
//
    alias Pair Ключ;

    ббайт** pbase;

    hash_t getHash(Ключ* pk)
    {
        auto буф = (*pbase)[pk.start .. pk.end];
        hash_t хэш = 0;
        foreach (v; буф)
            хэш = хэш * 11 + v;
        return хэш;
    }

    бул равен(Ключ* pk1, Ключ* pk2)
    {
        const len1 = pk1.end - pk1.start;
        const len2 = pk2.end - pk2.start;

        auto buf1 = *pk1;
        auto buf2 = *pk2;
        return len1 == len2 &&
               memcmp(*pbase + pk1.start, *pbase + pk2.start, len1) == 0;
    }
}

// Interface for C++ code
public  struct AApair
{
//
    alias  AArray!(TinfoPair, бцел) AA;
    AA aa;

    static AApair* создай(ббайт** pbase)
    {
        auto a = cast(AApair*)calloc(1, AApair.sizeof);
        assert(a);
        a.aa.tkey.pbase = pbase;
        return a;
    }

    static проц разрушь(AApair* aap)
    {
        aap.aa.разрушь();
        free(aap);
    }

    бцел* get(бцел start, бцел end)
    {
        auto p = Pair(start, end);
        return aa.get(&p);
    }

    бцел length()
    {
        return cast(бцел)aa.length();
    }
}

/*************************************************************/

version (none)
{

/* Since -betterC doesn't support unittests, do it this way
 * for the time being.
 * This is a stand-alone файл anyway.
 */

цел main()
{
    testAArray();
    testAApair();

    return 0;
}

проц testAArray()
{
    цел dg(цел* pk, бул* pv) { return 3; }
    цел dgz(цел* pk, бул* pv) { return 0; }

    AArray!(Tinfo!(цел, бул)) aa;
    aa.rehash();
    assert(aa.keys() == null);
    assert(aa.values() == null);
    assert(aa.apply(&dg) == 0);

    assert(aa.length == 0);
    цел k = 8;
    aa.del(&k);
    бул v = да;
    assert(!aa.isIn(&k));
    бул *pv = aa.get(&k);
    *pv = да;
    цел j = 9;
    pv = aa.get(&j);
    *pv = нет;
    aa.rehash();

    assert(aa.length() == 2);
    assert(*aa.get(&k) == да);
    assert(*aa.get(&j) == нет);

    assert(aa.apply(&dg) == 3);
    assert(aa.apply(&dgz) == 0);

    aa.del(&k);
    assert(aa.length() == 1);
    assert(!aa.isIn(&k));
    assert(*aa.isIn(&j) == нет);

    auto keys = aa.keys();
    assert(keys.length == 1);
    assert(keys[0] == 9);

    auto values = aa.values();
    assert(values.length == 1);
    assert(values[0] == нет);
}

проц testAApair()
{
    ткст0 буф = "abcb";
    auto aap = AApair.создай(cast(ббайт**)&буф);
    auto pu = aap.get(1,2);
    *pu = 10;
    assert(aap.length == 1);
    pu = aap.get(3,4);
    assert(*pu == 10);
    AApair.разрушь(aap);
}

}
