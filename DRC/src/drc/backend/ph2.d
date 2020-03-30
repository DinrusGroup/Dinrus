/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/ph2.d, backend/ph2.d)
 */

/* This is only for dmd, not dmc.
 * It implements a heap allocator that never frees.
 */

module drc.backend.ph2;

import cidrus;

import drc.backend.cc;
import drc.backend.глоб2;

/*extern (C++):*/



/**********************************************
 * Do our own storage allocator, a replacement
 * for malloc/free.
 */

struct Heap
{
    Heap *prev;         // previous heap
    ббайт *буф;         // буфер
    ббайт *p;           // high water mark
    бцел nleft;         // number of bytes left
}

 Heap *heap=null;

проц ph_init()
{
    if (!heap) {
        heap = cast(Heap *)calloc(1,Heap.sizeof);
    }
    assert(heap);
}



проц ph_term()
{
    //printf("ph_term()\n");
debug
{
    Heap *h;
    Heap *hprev;

    for (h = heap; h; h = hprev)
    {
        hprev = h.prev;
        free(h.буф);
        free(h);
    }
}
}

проц ph_newheap(т_мера члобайт)
{   бцел newsize;
    Heap *h;

    h = cast(Heap *) malloc(Heap.sizeof);
    if (!h)
        err_nomem();

    newsize = (члобайт > 0xFF00) ? cast(бцел)члобайт : 0xFF00;
    h.буф = cast(ббайт *) malloc(newsize);
    if (!h.буф)
    {
        free(h);
        err_nomem();
    }
    h.nleft = newsize;
    h.p = h.буф;
    h.prev = heap;
    heap = h;
}

проц *ph_malloc(т_мера члобайт)
{   ббайт *p;

    члобайт += бцел.sizeof * 2;
    члобайт &= ~(бцел.sizeof - 1);

    if (члобайт >= heap.nleft)
        ph_newheap(члобайт);
    p = heap.p;
    heap.p += члобайт;
    heap.nleft -= члобайт;
    *cast(бцел *)p = cast(бцел)(члобайт - бцел.sizeof);
    p += бцел.sizeof;
    return p;
}

проц *ph_calloc(т_мера члобайт)
{   проц *p;

    p = ph_malloc(члобайт);
    return p ? memset(p,0,члобайт) : p;
}

проц ph_free(проц *p)
{
}

проц *ph_realloc(проц *p,т_мера члобайт)
{
    //printf("ph_realloc(%p,%d)\n",p,cast(цел)члобайт);
    if (!p)
        return ph_malloc(члобайт);
    if (!члобайт)
    {   ph_free(p);
        return null;
    }
    проц *newp = ph_malloc(члобайт);
    if (newp)
    {   бцел oldsize = (cast(бцел *)p)[-1];
        memcpy(newp,p,oldsize);
        ph_free(p);
    }
    return newp;
}

проц err_nomem()
{
    printf("Error: out of memory\n");
    err_exit();
}
