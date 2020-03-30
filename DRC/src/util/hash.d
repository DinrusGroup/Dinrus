/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Martin Nowak, Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/хэш.d, root/_hash.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_hash.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/хэш.d
 */

module util.хэш;

// MurmurHash2 was written by Austin Appleby, and is placed in the public
// domain. The author hereby disclaims copyright to this source code.
// https://sites.google.com/site/murmurhash/
бцел calcHash( ткст данные)    
{
    return calcHash(cast(ббайт[])данные);
}

/// ditto
бцел calcHash( ббайт[] данные)    
{
    // 'm' and 'r' are mixing constants generated offline.
    // They're not really 'magic', they just happen to work well.
    const бцел m = 0x5bd1e995;
    const цел r = 24;
    // Initialize the хэш to a 'random' значение
    бцел h = cast(бцел) данные.length;
    // Mix 4 bytes at a time into the хэш
    while (данные.length >= 4)
    {
        бцел k = данные[3] << 24 | данные[2] << 16 | данные[1] << 8 | данные[0];
        k *= m;
        k ^= k >> r;
        h = (h * m) ^ (k * m);
        данные = данные[4..$];
    }
    // Handle the last few bytes of the input массив
    switch (данные.length & 3)
    {
    case 3:
        h ^= данные[2] << 16;
        goto case;
    case 2:
        h ^= данные[1] << 8;
        goto case;
    case 1:
        h ^= данные[0];
        h *= m;
        goto default;
    default:
        break;
    }
    // Do a few final mixes of the хэш to ensure the last few
    // bytes are well-incorporated.
    h ^= h >> 13;
    h *= m;
    h ^= h >> 15;
    return h;
}

unittest
{
    сим[10] данные = "0123456789";
    assert(calcHash(данные[0..$]) ==   439_272_720);
    assert(calcHash(данные[1..$]) == 3_704_291_687);
    assert(calcHash(данные[2..$]) == 2_125_368_748);
    assert(calcHash(данные[3..$]) == 3_631_432_225);
}

// combine and mix two words (boost::hash_combine)
т_мера mixHash(т_мера h, т_мера k)    
{
    return h ^ (k + 0x9e3779b9 + (h << 6) + (h >> 2));
}

unittest
{
    // & бцел.max because mixHash output is truncated on 32-bit targets
    assert((mixHash(0xDE00_1540, 0xF571_1A47) & бцел.max) == 0x952D_FC10);
}
