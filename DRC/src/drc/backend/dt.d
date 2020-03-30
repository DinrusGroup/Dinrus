/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      https://github.com/dlang/dmd/blob/master/src/dmd/backend/dt.d
 */

module drc.backend.dt;

// Online documentation: https://dlang.org/phobos/dmd_backend_dt.html

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.глоб2;
import drc.backend.mem;
import drc.backend.ty;
import drc.backend.тип;


/*:*/

/*extern (C++):*/

/**********************************************
 * Free a данные definition struct.
 */

проц dt_free(dt_t *dt)
{
    if (dt)
    {
        dt_t *dtn = dt;
        while (1)
        {
            switch (dtn.dt)
            {
                case DT_abytes:
                case DT_nbytes:
                    mem_free(dtn.DTpbytes);
                    break;

                default:
                    break;
            }
            dt_t *dtnext = dtn.DTnext;
            if (!dtnext)
                break;
            dtn = dtnext;
        }
        dtn.DTnext = dt_freelist;
        dt_freelist = dt;
    }
}

/*********************************
 * Free free list.
 */

проц dt_term()
{
static if (0 && TERMCODE)
{
    dt_t *dtn;

    while (dt_freelist)
    {   dtn = dt_freelist.DTnext;
        mem_ffree(dt_freelist);
        dt_freelist = dtn;
    }
}
}

dt_t **dtend(dt_t **pdtend)
{
    while (*pdtend)
        pdtend = &((*pdtend).DTnext);
    return pdtend;
}


/*********************************
 */
проц dtpatchoffset(dt_t *dt, бцел смещение)
{
    dt.DToffset = смещение;
}

/**************************
 * Make a common block for s.
 */

проц init_common(Symbol *s)
{
    //printf("init_common('%s')\n", s.Sident);

    бцел size = cast(бцел)type_size(s.Stype);
    if (size)
    {
        dt_t *dt = dt_calloc(DT_common);
        dt.DTazeros = size;
        s.Sdt = dt;
    }
}

/**********************************
 * Compute size of a dt
 */

бцел dt_size(dt_t* dtstart)
{
    бцел datasize = 0;
    for (auto dt = dtstart; dt; dt = dt.DTnext)
    {
        switch (dt.dt)
        {
            case DT_abytes:
                datasize += size(dt.Dty);
                break;
            case DT_ibytes:
                datasize += dt.DTn;
                break;
            case DT_nbytes:
                datasize += dt.DTnbytes;
                break;
            case DT_azeros:
                datasize += dt.DTazeros;
                break;
            case DT_common:
                break;
            case DT_xoff:
            case DT_coff:
                datasize += size(dt.Dty);
                break;
            default:
                debug printf("dt = %p, dt = %d\n",dt,dt.dt);
                assert(0);
        }
    }
    return datasize;
}

/************************************
 * Return да if dt is all zeros.
 */

бул dtallzeros(dt_t* dt)
{
    return dt.dt == DT_azeros && !dt.DTnext;
}

/************************************
 * Return да if dt содержит pointers (requires relocations).
 */

бул dtpointers(dt_t* dtstart)
{
    for (auto dt = dtstart; dt; dt = dt.DTnext)
    {
        switch (dt.dt)
        {
            case DT_abytes:
            case DT_xoff:
            case DT_coff:
                return да;

            default:
                break;
        }
    }
    return нет;
}

/***********************************
 * Turn DT_azeros into DTcommon
 */

проц dt2common(dt_t **pdt)
{
    assert((*pdt).dt == DT_azeros);
    (*pdt).dt = DT_common;
}

/**********************************************************/

struct DtBuilder
{
private:

    dt_t* head;
    dt_t** pTail;

public:

/*:*/
    this(цел dummy)
    {
        pTail = &head;
    }

    /*************************
     * Finish and return completed данные structure.
     */
    dt_t *finish()
    {
        /* Merge all the 0s at the start of the list
         * so we can later check for dtallzeros()
         */
        if (head && head.dt == DT_azeros)
        {
            while (1)
            {
                dt_t *dtn = head.DTnext;
                if (!(dtn && dtn.dt == DT_azeros))
                    break;

                // combine head and dtn
                head.DTazeros += dtn.DTazeros;
                head.DTnext = dtn.DTnext;
                dtn.DTnext = null;
                dt_free(dtn);
            }
        }

        return head;
    }

    /***********************
     * Append данные represented by ptr[0..size]
     */
    проц члобайт(бцел size, ткст0 ptr)
    {
        if (!size)
            return;

        dt_t *dt;

        if (size < dt_t.DTibytesMax)
        {   dt = dt_calloc(DT_ibytes);
            dt.DTn = cast(ббайт)size;
            memcpy(dt.DTdata.ptr,ptr,size);
        }
        else
        {
            dt = dt_calloc(DT_nbytes);
            dt.DTnbytes = size;
            dt.DTpbytes = cast(byte *) mem_malloc(size);
            memcpy(dt.DTpbytes,ptr,size);
        }

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }

    /*****************************************
     * Write a reference to the данные ptr[0..size+nzeros]
     */
    проц abytes(tym_t ty, бцел смещение, бцел size, ткст0 ptr, бцел nzeros)
    {
        dt_t *dt = dt_calloc(DT_abytes);
        dt.DTnbytes = size + nzeros;
        dt.DTpbytes = cast(byte *) mem_malloc(size + nzeros);
        dt.Dty = cast(ббайт)ty;
        dt.DTabytes = смещение;
        memcpy(dt.DTpbytes,ptr,size);
        if (nzeros)
            memset(dt.DTpbytes + size, 0, nzeros);

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }

    проц abytes(бцел смещение, бцел size, ткст0 ptr, бцел nzeros)
    {
        abytes(TYnptr, смещение, size, ptr, nzeros);
    }

    /**************************************
     * Write 4 bytes of значение.
     */
    проц dword(цел значение)
    {
        if (значение == 0)
        {
            nzeros(4);
            return;
        }

        dt_t *dt = dt_calloc(DT_ibytes);
        dt.DTn = 4;

        union U { ткст0 cp; цел* lp; }
        U u = проц;
        u.cp = cast(сим*)dt.DTdata.ptr;
        *u.lp = значение;

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }

    /***********************
     * Write a т_мера значение.
     */
    проц size(бдол значение)
    {
        if (значение == 0)
        {
            nzeros(_tysize[TYnptr]);
            return;
        }
        dt_t *dt = dt_calloc(DT_ibytes);
        dt.DTn = _tysize[TYnptr];

        union U { ткст0 cp; цел* lp; }
        U u = проц;
        u.cp = cast(сим*)dt.DTdata.ptr;
        *u.lp = cast(цел)значение;
        if (_tysize[TYnptr] == 8)
            u.lp[1] = cast(цел)(значение >> 32);

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }

    /***********************
     * Write a bunch of zeros
     */
    проц nzeros(бцел size)
    {
        if (!size)
            return;
        assert(cast(цел) size > 0);

        dt_t *dt = dt_calloc(DT_azeros);
        dt.DTazeros = size;

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }

    /*************************
     * Write a reference to s+смещение
     */
    проц xoff(Symbol *s, бцел смещение, tym_t ty)
    {
        dt_t *dt = dt_calloc(DT_xoff);
        dt.DTsym = s;
        dt.DToffset = смещение;
        dt.Dty = cast(ббайт)ty;

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }

    /******************************
     * Create reference to s+смещение
     */
    проц xoff(Symbol *s, бцел смещение)
    {
        xoff(s, смещение, TYnptr);
    }

    /*******************************
     * Like xoff(), but returns handle with which to patch 'смещение' значение.
     */
    dt_t *xoffpatch(Symbol *s, бцел смещение, tym_t ty)
    {
        dt_t *dt = dt_calloc(DT_xoff);
        dt.DTsym = s;
        dt.DToffset = смещение;
        dt.Dty = cast(ббайт)ty;

        dt_t **pxoff = pTail;

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);

        return *pxoff;
    }

    /*************************************
     * Create a reference to another dt.
     * Возвращает: the internal symbol используется for the other dt
     */
    Symbol *dtoff(dt_t *dt, бцел смещение)
    {
        тип *t = type_alloc(TYint);
        t.Tcount++;
        Symbol *s = symbol_calloc("internal");
        s.Sclass = SCstatic;
        s.Sfl = FLextern;
        s.Sflags |= SFLnodebug;
        s.Stype = t;
        s.Sdt = dt;
        outdata(s);

        xoff(s, смещение);
        return s;
    }

    /********************************
     * Write reference to смещение in code segment.
     */
    проц coff(бцел смещение)
    {
        dt_t *dt = dt_calloc(DT_coff);

        static if (TARGET_SEGMENTED)
            dt.Dty = TYcptr;
        else
            dt.Dty = TYnptr;

        dt.DToffset = смещение;

        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        assert(!*pTail);
    }


    /**********************
     * Append dt to данные.
     */
    проц cat(dt_t *dt)
    {
        assert(!*pTail);
        *pTail = dt;
        pTail = &dt.DTnext;
        while (*pTail)
            pTail = &((*pTail).DTnext);
        assert(!*pTail);
    }

    /**********************
     * Append dtb to данные.
     */
    проц cat(ref DtBuilder dtb)
    {
        assert(!*pTail);
        *pTail = dtb.head;
        pTail = dtb.pTail;
        assert(!*pTail);
    }

    /**************************************
     * Repeat a list of dt_t's count times.
     */
    проц repeat(dt_t *dt, т_мера count)
    {
        if (!count)
            return;

        бцел size = dt_size(dt);
        if (!size)
            return;

        if (dtallzeros(dt))
        {
            if (head && dtallzeros(head))
                head.DTazeros += size * count;
            else
                nzeros(cast(бцел)(size * count));
            return;
        }

        if (dtpointers(dt))
        {
            dt_t *dtp = null;
            dt_t **pdt = &dtp;
            for (т_мера i = 0; i < count; ++i)
            {
                for (dt_t *dtn = dt; dtn; dtn = dtn.DTnext)
                {
                    dt_t *dtx = dt_calloc(dtn.dt);
                    *dtx = *dtn;
                    dtx.DTnext = null;
                    switch (dtx.dt)
                    {
                        case DT_abytes:
                        case DT_nbytes:
                            dtx.DTpbytes = cast(byte *) mem_malloc(dtx.DTnbytes);
                            memcpy(dtx.DTpbytes, dtn.DTpbytes, dtx.DTnbytes);
                            break;

                        default:
                            break;
                    }

                    *pdt = dtx;
                    pdt = &dtx.DTnext;
                }
            }
            assert(!*pTail);
            *pTail = dtp;
            assert(*pdt == null);
            pTail = pdt;
            return;
        }

        сим *p = cast(сим *)mem_malloc(size * count);
        т_мера смещение = 0;

        for (dt_t *dtn = dt; dtn; dtn = dtn.DTnext)
        {
            switch (dtn.dt)
            {
                case DT_nbytes:
                    memcpy(p + смещение, dtn.DTpbytes, dtn.DTnbytes);
                    смещение += dtn.DTnbytes;
                    break;
                case DT_ibytes:
                    memcpy(p + смещение, dtn.DTdata.ptr, dtn.DTn);
                    смещение += dtn.DTn;
                    break;
                case DT_azeros:
                    memset(p + смещение, 0, cast(бцел)dtn.DTazeros);
                    смещение += dtn.DTazeros;
                    break;
                default:
                    debug printf("dt = %p, dt = %d\n",dt,dt.dt);
                    assert(0);
            }
        }
        assert(смещение == size);

        for (т_мера i = 1; i < count; ++i)
        {
            memcpy(p + смещение, p, size);
            смещение += size;
        }

        dt_t *dtx = dt_calloc(DT_nbytes);
        dtx.DTnbytes = cast(бцел)(size * count);
        dtx.DTpbytes = cast(byte*)p;


        assert(!*pTail);
        *pTail = dtx;
        pTail = &dtx.DTnext;
        assert(!*pTail);
    }

    /***************************
     * Return size of данные.
     */
    бцел length()
    {
        return dt_size(head);
    }

    /************************
     * Return да if size of данные is 0.
     */
    бул isZeroLength()
    {
        return head == null;
    }
}

private  dt_t *dt_freelist;

/**********************************************
 * Allocate a данные definition struct.
 */

private dt_t *dt_calloc(цел dtx)
{
    dt_t *dt = dt_freelist;
    if (!dt)
    {
        const т_мера n = 4096 / dt_t.sizeof;
        dt_t *chunk = cast(dt_t *)mem_fmalloc(n * dt_t.sizeof);
        for (т_мера i = 0; i < n - 1; ++i)
        {
            chunk[i].DTnext = &chunk[i + 1];
        }
        chunk[n - 1].DTnext = null;
        dt_freelist = chunk;
        dt = chunk;
    }

    dt_freelist = dt.DTnext;
    debug memset(dt, 0xBE, (*dt).sizeof);
    dt.DTnext = null;
    dt.dt = cast(сим)dtx;
    return dt;
}


/******************************************
 * Temporary hack to initialize a dt_t* for C.
 */

dt_t* dt_get_nzeros(бцел n)
{
    dt_t *dt = dt_calloc(DT_azeros);
    dt.DTazeros = n;
    return dt;
}
