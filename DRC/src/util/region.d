/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Регион storage allocator implementation.
 *
 * Copyright:   Copyright (C) 2019-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/region.d, root/_region.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_region.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/region.d
 */

module util.region;

import cidrus;

import util.rmem;
import util.array;

/*****
 * Simple region storage allocator.
 */
struct Регион
{
  
  private:

    МассивДРК!(ук) массив; // массив чанков
    цел используется;            // чло чанков, используемых в массив[]
    проц[] доступно;    // срез чанка, доступный для размещения

    const ChunkSize = 4096 * 1024;
    const MaxAllocSize = ChunkSize;

    struct ПозРегиона
    {
        цел используется;
        проц[] доступно;
    }

public:

    /******
     * Allocate члобайт. Aborts on failure.
     * Параметры:
     *  члобайт = number of bytes to размести, can be 0, must be <= than MaxAllocSize
     * Возвращает:
     *  allocated данные, null for члобайт==0
     */
    ук malloc(т_мера члобайт)
    {
        if (!члобайт)
            return null;

        члобайт = (члобайт + 15) & ~15;
        if (члобайт > доступно.length)
        {
            assert(члобайт <= MaxAllocSize);
            if (используется == массив.length)
            {
                auto h = Пам.check(.malloc(ChunkSize));
                массив.сунь(h);
            }

            доступно = массив[используется][0 .. MaxAllocSize];
            ++используется;
        }

        auto p = доступно.ptr;
        доступно = (p + члобайт)[0 .. доступно.length - члобайт];
        return p;
    }

    /****************************
     * Return stack position for allocations in this region.
     * Возвращает:
     *  an opaque struct to be passed to `release()`
     */
    ПозРегиона savePos()
    {
        return ПозРегиона(используется, доступно);
    }

    /********************
     * Release the memory that was allocated after the respective call to `savePos()`.
     * Параметры:
     *  pos = position returned by `savePos()`
     */
    проц release(ПозРегиона pos)
    {
        version (all)
        {
            /* Recycle the memory. There better not be
             * any live pointers to it.
             */
            используется = pos.используется;
            доступно = pos.доступно;
        }
        else
        {
            /* Instead of recycling the memory, stomp on it
             * to flush out any remaining live pointers to it.
             */
            (cast(ббайт[])pos.доступно)[] = 0xFF;
            foreach (h; массив[pos.используется .. используется])
                (cast(ббайт*)h)[0 .. ChunkSize] = 0xFF;
        }
    }

    /****************************
     * If pointer points into Регион.
     * Параметры:
     *  p = pointer to check
     * Возвращает:
     *  да if it points into the region
     */
    бул содержит(ук p)
    {
        foreach (h; массив[0 .. используется])
        {
            if (h <= p && p < h + ChunkSize)
                return да;
        }
        return нет;
    }

    /*********************
     * Возвращает: size of Регион
     */
    т_мера size()
    {
        return используется * MaxAllocSize - доступно.length;
    }
}


unittest
{
    Регион reg;
    auto rgnpos = reg.savePos();

    ук p = reg.malloc(0);
    assert(p == null);
    assert(!reg.содержит(p));

    p = reg.malloc(100);
    assert(p !is null);
    assert(reg.содержит(p));
    memset(p, 0, 100);

    p = reg.malloc(100);
    assert(p !is null);
    assert(reg.содержит(p));
    memset(p, 0, 100);

    assert(reg.size() > 0);
    assert(!reg.содержит(&reg));

    reg.release(rgnpos);
}
