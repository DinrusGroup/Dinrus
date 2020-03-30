/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/bitarray.d, root/_bitarray.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_array.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/bitarray.d
 */

module util.bitarray;

import cidrus;

import util.rmem;

struct МассивБит
{


    alias  т_мера Chunk_t;
    auto ChunkSize = Chunk_t.sizeof;
    auto BitsPerChunk = ChunkSize * 8;

    т_мера length()
    {
        return len;
    }

    проц length(т_мера nlen) 
    {
        auto ochunks = chunks(len);
        auto nchunks = chunks(nlen);
        if (ochunks != nchunks)
        {
            ptr = cast(т_мера*)mem.xrealloc_noscan(ptr, nchunks * ChunkSize);
        }
        if (nchunks > ochunks)
           ptr[ochunks .. nchunks] = 0;
        if (nlen & (BitsPerChunk - 1))
           ptr[nchunks - 1] &= (cast(Chunk_t)1 << (nlen & (BitsPerChunk - 1))) - 1;
        len = nlen;
    }
/+
    проц opAssign(ref МассивБит b)
    {
        if (!len)
            length(b.len);
        assert(len == b.len);
        memcpy(ptr, b.ptr, bytes(len));
    }
    +/   
version(Dinrus) import std.intrinsic: bt;
else import core.bitop : bt;

    бул opIndex(т_мера idx) 
    {
        assert(idx < len);
        return !!bt(ptr, idx);
    }

    version(Dinrus) import std.intrinsic: btc, bts;
	else import core.bitop : btc, bts;

    проц opIndexAssign(бул val, т_мера idx)  
    {
        assert(idx < len);
        if (val)
            bts(ptr, idx);
        else
            btc(ptr, idx);
    }

    бул opEquals(ref МассивБит b) 
    {
        return len == b.len && memcmp(ptr, b.ptr, bytes(len)) == 0;
    }

    проц нуль()
    {
        memset(ptr, 0, bytes(len));
    }

    /******
     * Возвращает:
     *  да if no bits are set
     */
    бул isZero()
    {
        auto nchunks = chunks(len);
        foreach (i; new бцел[0 .. nchunks])
        {
            if (ptr[i])
                return нет;
        }
        return да;
    }

    проц or(ref МассивБит b)
    {
        assert(len == b.len);
        auto nchunks = chunks(len);
        foreach (i; new бцел[0 .. nchunks])
            ptr[i] |= b.ptr[i];
    }

    /* Swap contents of `this` with `b`
     */
    проц swap(ref МассивБит b)
    {
        assert(len == b.len);
        auto nchunks = chunks(len);
        foreach (i; new бцел[0 .. nchunks])
        {
            auto chunk = ptr[i];
            ptr[i] = b.ptr[i];
            b.ptr[i] = chunk;
        }
    }

   static ~this() 
    {
        debug
        {
            // Stomp the allocated memory
            auto nchunks = chunks(len);
            foreach (i; new бцел[0 .. nchunks])
            {
                ptr[i] = cast(Chunk_t)0xFEFEFEFE_FEFEFEFE;
            }
        }
        mem.xfree(ptr);
        debug
        {
            // Set to implausible values
            len = cast(т_мера)0xFEFEFEFE_FEFEFEFE;
            ptr = cast(т_мера*)cast(т_мера)0xFEFEFEFE_FEFEFEFE;
        }
    }

private:
    т_мера len;         // length in bits
    т_мера *ptr;

    /// Возвращает: The amount of chunks используется to store len bits
    static т_мера chunks(т_мера len) 
    {
        return (len + BitsPerChunk - 1) / BitsPerChunk;
    }

    /// Возвращает: The amount of bytes используется to store len bits
    static т_мера bytes( т_мера len)
    {
        return chunks(len) * ChunkSize;
    }
}

unittest
{
    МассивБит массив;
    массив.length = 20;
    assert(массив[19] == 0);
    массив[10] = 1;
    assert(массив[10] == 1);
    массив[10] = 0;
    assert(массив[10] == 0);
    assert(массив.length == 20);

    МассивБит a,b;
    assert(a != массив);
    a.length = 200;
    assert(a != массив);
    assert(a.isZero());
    a[100] = да;
    b.length = 200;
    b[100] = да;
    assert(a == b);

    a.length = 300;
    b.length = 300;
    assert(a == b);
    b[299] = да;
    assert(a != b);
    assert(!a.isZero());
    a.swap(b);
    assert(a[299] == да);
    assert(b[299] == нет);
    a = b;
    assert(a == b);
}



