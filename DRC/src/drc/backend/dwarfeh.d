/**
 * Compiler implementation of the D programming language.
 * Implements LSDA (Language Specific Data Area) table generation
 * for Dwarf Exception Handling.
 *
 * Copyright: Copyright (C) 2015-2020 by The D Language Foundation, All Rights Reserved
 * Authors: Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/dwarfeh.d, backend/dwarfeh.d)
 */

module drc.backend.dwarfeh;

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.outbuf;

static if (ELFOBJ || MACHOBJ)
{

import drc.backend.dwarf;
import drc.backend.dwarf2;

/*extern (C++):*/



struct DwEhTableEntry
{
    бцел start;
    бцел end;           // 1 past end
    бцел lpad;          // landing pad
    бцел action;        // index into Action Table
    block *bcatch;      // catch block данные
    цел prev;           // index to enclosing entry (-1 for none)
}

struct DwEhTable
{

    DwEhTableEntry *ptr;    // pointer to table
    бцел dim;               // current amount используется
    бцел capacity;

    DwEhTableEntry *index(бцел i)
    {
        if (i >= dim) printf("i = %d dim = %d\n", i, dim);
        assert(i < dim);
        return ptr + i;
    }

    бцел сунь()
    {
        assert(dim <= capacity);
        if (dim == capacity)
        {
            capacity += capacity + 16;
            ptr = cast(DwEhTableEntry *)realloc(ptr, capacity * DwEhTableEntry.sizeof);
            assert(ptr);
        }
        memset(ptr + dim, 0, DwEhTableEntry.sizeof);
        return dim++;
    }
}

private  DwEhTable dwehtable;

/****************************
 * Generate .gcc_except_table, aka LS
 * Параметры:
 *      sfunc = function to generate table for
 *      seg = .gcc_except_table segment
 *      et = буфер to вставь table into
 *      scancode = да if there are destructors in the code (i.e. usednteh & EHcleanup)
 *      startoffset = size of function prolog
 *      retoffset = смещение from start of function to epilog
 */

проц genDwarfEh(Funcsym *sfunc, цел seg, Outbuffer *et, бул scancode, бцел startoffset, бцел retoffset)
{
    debug
    unittest_dwarfeh();

    /* LPstart = encoding of LPbase
     * LPbase = landing pad base (normally omitted)
     * TType = encoding of TTbase
     * TTbase = смещение from следщ byte to past end of Тип Table
     * CallSiteFormat = encoding of fields in Call Site Table
     * CallSiteTableSize = size in bytes of Call Site Table
     * Call Site Table[]:
     *    CallSiteStart
     *    CallSiteRange
     *    LandingPad
     *    ActionRecordPtr
     * Action Table
     *    TypeFilter
     *    NextRecordPtr
     * Тип Table
     */

    et.резервируй(100);
    block *startblock = sfunc.Sfunc.Fstartblock;
    //printf("genDwarfEh: func = %s, смещение = x%x, startblock.Boffset = x%x, scancode = %d startoffset=x%x, retoffset=x%x\n",
      //sfunc.Sident.ptr, cast(цел)sfunc.Soffset, cast(цел)startblock.Boffset, scancode, startoffset, retoffset);

static if (0)
{
    printf("------- before ----------\n");
    for (block *b = startblock; b; b = b.Bnext) WRblock(b);
    printf("-------------------------\n");
}

    бцел startsize = cast(бцел)et.size();
    assert((startsize & 3) == 0);       // should be aligned

    DwEhTable *deh = &dwehtable;
    deh.dim = 0;
    Outbuffer atbuf;
    Outbuffer cstbuf;

    /* Build deh table, and Action Table
     */
    цел index = -1;
    block *bprev = null;
    // The first entry encompasses the entire function
    {
        бцел i = deh.сунь();
        DwEhTableEntry *d = deh.index(i);
        d.start = cast(бцел)(startblock.Boffset + startoffset);
        d.end = cast(бцел)(startblock.Boffset + retoffset);
        d.lpad = 0;                    // no cleanup, no catches
        index = i;
    }
    for (block *b = startblock; b; b = b.Bnext)
    {
        if (index > 0 && b.Btry == bprev)
        {
            DwEhTableEntry *d = deh.index(index);
            d.end = cast(бцел)b.Boffset;
            index = d.prev;
            if (bprev)
                bprev = bprev.Btry;
        }
        if (b.BC == BC_try)
        {
            бцел i = deh.сунь();
            DwEhTableEntry *d = deh.index(i);
            d.start = cast(бцел)b.Boffset;

            block *bf = b.nthSucc(1);
            if (bf.BC == BCjcatch)
            {
                d.lpad = cast(бцел)bf.Boffset;
                d.bcatch = bf;
                бцел *pat = bf.actionTable;
                бцел length = pat[0];
                assert(length);
                бцел смещение = -1;
                for (бцел u = length; u; --u)
                {
                    /* Buy doing depth-first insertion into the Action Table,
                     * we can combine common tails.
                     */
                    смещение = actionTableInsert(&atbuf, pat[u], смещение);
                }
                d.action = смещение + 1;
            }
            else
                d.lpad = cast(бцел)bf.nthSucc(0).Boffset;
            d.prev = index;
            index = i;
            bprev = b.Btry;
        }
        if (scancode)
        {
            бцел coffset = cast(бцел)b.Boffset;
            цел n = 0;
            for (code *c = b.Bcode; c; c = code_next(c))
            {
                if (c.Iop == (ESCAPE | ESCdctor))
                {
                    бцел i = deh.сунь();
                    DwEhTableEntry *d = deh.index(i);
                    d.start = coffset;
                    d.prev = index;
                    index = i;
                    ++n;
                }

                if (c.Iop == (ESCAPE | ESCddtor))
                {
                    assert(n > 0);
                    --n;
                    DwEhTableEntry *d = deh.index(index);
                    d.end = coffset;
                    d.lpad = coffset;
                    index = d.prev;
                }
                coffset += calccodsize(c);
            }
            assert(n == 0);
        }
    }
    //printf("deh.dim = %d\n", (цел)deh.dim);

static if (1)
{
    /* Build Call Site Table
     * Be sure to not generate empty entries,
     * and generate nested ranges reflecting the layout in the code.
     */
    assert(deh.dim);
    бцел end = deh.index(0).start;
    for (бцел i = 0; i < deh.dim; ++i)
    {
        DwEhTableEntry *d = deh.index(i);
        if (d.start < d.end)
        {
static if (ELFOBJ)
                auto WRITE = &cstbuf.writeuLEB128;
else static if (MACHOBJ)
                auto WRITE = &cstbuf.write32;
else
                assert(0);

                бцел CallSiteStart = cast(бцел)(d.start - startblock.Boffset);
                WRITE(CallSiteStart);
                бцел CallSiteRange = d.end - d.start;
                WRITE(CallSiteRange);
                бцел LandingPad = cast(бцел)(d.lpad ? d.lpad - startblock.Boffset : 0);
                WRITE(LandingPad);
                бцел ActionTable = d.action;
                cstbuf.writeuLEB128(ActionTable);
                //printf("\t%x %x %x %x\n", CallSiteStart, CallSiteRange, LandingPad, ActionTable);
        }
    }
}
else
{
    /* Build Call Site Table
     * Be sure to not generate empty entries,
     * and generate multiple entries for one DwEhTableEntry if the latter
     * is split by nested DwEhTableEntry's. This is based on the (undocumented)
     * presumption that there may not
     * be overlapping entries in the Call Site Table.
     */
    assert(deh.dim);
    бцел end = deh.index(0).start;
    for (бцел i = 0; i < deh.dim; ++i)
    {
        бцел j = i;
        do
        {
            DwEhTableEntry *d = deh.index(j);
            //printf(" [%d] start=%x end=%x lpad=%x action=%x bcatch=%p prev=%d\n",
            //  j, d.start, d.end, d.lpad, d.action, d.bcatch, d.prev);
            if (d.start <= end && end < d.end)
            {
                бцел start = end;
                бцел dend = d.end;
                if (i + 1 < deh.dim)
                {
                    DwEhTableEntry *dnext = deh.index(i + 1);
                    if (dnext.start < dend)
                        dend = dnext.start;
                }
                if (start < dend)
                {
static if (ELFOBJ)
                    auto WRITE = &cstbuf.writeLEB128;
else static if (MACHOBJ)
                    auto WRITE = &cstbuf.write32;
else
                    assert(0);

                    бцел CallSiteStart = start - startblock.Boffset;
                    WRITE(CallSiteStart);
                    бцел CallSiteRange = dend - start;
                    WRITE(CallSiteRange);
                    бцел LandingPad = d.lpad - startblock.Boffset;
                    cstbuf.WRITE(LandingPad);
                    бцел ActionTable = d.action;
                    WRITE(ActionTable);
                    //printf("\t%x %x %x %x\n", CallSiteStart, CallSiteRange, LandingPad, ActionTable);
                }

                end = dend;
            }
        } while (j--);
    }
}

    /* Write LSDT header */
    const ббайт LPstart = DW_EH_PE_omit;
    et.пишиБайт(LPstart);
    бцел LPbase = 0;
    if (LPstart != DW_EH_PE_omit)
        et.writeuLEB128(LPbase);

    const ббайт TType = (config.flags3 & CFG3pic)
                                ? DW_EH_PE_indirect | DW_EH_PE_pcrel | DW_EH_PE_sdata4
                                : DW_EH_PE_absptr | DW_EH_PE_udata4;
    et.пишиБайт(TType);

    /* Compute TTbase, which is the sum of:
     *  1. CallSiteFormat
     *  2. encoding of CallSiteTableSize
     *  3. Call Site Table size
     *  4. Action Table size
     *  5. 4 byte alignment
     *  6. Types Table
     * Iterate until it converges.
     */
    бцел TTbase = 1;
    бцел CallSiteTableSize = cast(бцел)cstbuf.size();
    бцел oldTTbase;
    do
    {
        oldTTbase = TTbase;
        бцел start = cast(бцел)((et.size() - startsize) + uLEB128size(TTbase));
        TTbase = cast(бцел)(
                1 +
                uLEB128size(CallSiteTableSize) +
                CallSiteTableSize +
                atbuf.size());
        бцел sz = start + TTbase;
        TTbase += -sz & 3;      // align to 4
        TTbase += sfunc.Sfunc.typesTable.length * 4;
    } while (TTbase != oldTTbase);

    if (TType != DW_EH_PE_omit)
        et.writeuLEB128(TTbase);
    бцел TToffset = cast(бцел)(TTbase + et.size() - startsize);

static if (ELFOBJ)
    const ббайт CallSiteFormat = DW_EH_PE_absptr | DW_EH_PE_uleb128;
else static if (MACHOBJ)
    const ббайт CallSiteFormat = DW_EH_PE_absptr | DW_EH_PE_udata4;
else
    assert(0);

    et.пишиБайт(CallSiteFormat);
    et.writeuLEB128(CallSiteTableSize);


    /* Insert Call Site Table */
    et.пиши(&cstbuf);

    /* Insert Action Table */
    et.пиши(&atbuf);

    /* Align to 4 */
    for (бцел n = (-et.size() & 3); n; --n)
        et.пишиБайт(0);

    /* Write out Types Table in reverse */
    auto typesTable = sfunc.Sfunc.typesTable[];
    for (цел i = cast(цел)typesTable.length; i--; )
    {
        Symbol *s = typesTable[i];
        /* MACHOBJ 64: pcrel 1 length 1 extern 1 RELOC_GOT
         *         32: [0] address x004c pcrel 0 length 2 значение x224 тип 4 RELOC_LOCAL_SECTDIFF
         *             [1] address x0000 pcrel 0 length 2 значение x160 тип 1 RELOC_PAIR
         */
        dwarf_reftoident(seg, et.size(), s, 0);
    }
    assert(TToffset == et.size() - startsize);
}


/****************************
 * Insert action (ttindex, смещение) in Action Table
 * if it is not already there.
 * Параметры:
 *      atbuf = Action Table
 *      ttindex = Types Table index (1..)
 *      смещение = смещение of следщ action, -1 for none
 * Возвращает:
 *      смещение of inserted action
 */
цел actionTableInsert(Outbuffer *atbuf, цел ttindex, цел nextoffset)
{
    //printf("actionTableInsert(%d, %d)\n", ttindex, nextoffset);
    ббайт *p;
    for (p = atbuf.буф; p < atbuf.p; )
    {
        цел смещение = cast(цел)(p - atbuf.буф);
        цел TypeFilter = sLEB128(&p);
        цел nrpoffset = cast(цел)(p - atbuf.буф);
        цел NextRecordPtr = sLEB128(&p);

        if (ttindex == TypeFilter &&
            nextoffset == nrpoffset + NextRecordPtr)
            return смещение;
    }
    assert(p == atbuf.p);
    цел смещение = cast(цел)atbuf.size();
    atbuf.writesLEB128(ttindex);
    if (nextoffset == -1)
        nextoffset = 0;
    else
        nextoffset -= atbuf.size();
    atbuf.writesLEB128(nextoffset);
    return смещение;
}

debug
проц unittest_actionTableInsert()
{
    Outbuffer atbuf;
    static const цел[3] tt1 = [ 1,2,3 ];
    static const цел[1] tt2 = [ 2 ];

    цел смещение = -1;
    for (т_мера i = tt1.length; i--; )
    {
        смещение = actionTableInsert(&atbuf, tt1[i], смещение);
    }
    смещение = -1;
    for (т_мера i = tt2.length; i--; )
    {
        смещение = actionTableInsert(&atbuf, tt2[i], смещение);
    }

    static const ббайт[8] результат = [ 3,0,2,0x7D,1,0x7D,2,0 ];
    //for (цел i = 0; i < atbuf.size(); ++i) printf(" %02x\n", atbuf.буф[i]);
    assert(результат.sizeof == atbuf.size());
    цел r = memcmp(результат.ptr, atbuf.буф, atbuf.size());
    assert(r == 0);
}


/******************************
 * Decode Unsigned LEB128.
 * Параметры:
 *      p = pointer to данные pointer, *p is updated
 *      to point past decoded значение
 * Возвращает:
 *      decoded значение
 * See_Also:
 *      https://en.wikipedia.org/wiki/LEB128
 */
бцел uLEB128(ббайт **p)
{
    ббайт *q = *p;
    бцел результат = 0;
    бцел shift = 0;
    while (1)
    {
        ббайт byte_ = *q++;
        результат |= (byte_ & 0x7F) << shift;
        if ((byte_ & 0x80) == 0)
            break;
        shift += 7;
    }
    *p = q;
    return результат;
}

/******************************
 * Decode Signed LEB128.
 * Параметры:
 *      p = pointer to данные pointer, *p is updated
 *      to point past decoded значение
 * Возвращает:
 *      decoded значение
 * See_Also:
 *      https://en.wikipedia.org/wiki/LEB128
 */
цел sLEB128(ббайт **p)
{
    ббайт *q = *p;
    ббайт byte_;

    цел результат = 0;
    бцел shift = 0;
    while (1)
    {
        byte_ = *q++;
        результат |= (byte_ & 0x7F) << shift;
        shift += 7;
        if ((byte_ & 0x80) == 0)
            break;
    }
    if (shift < результат.sizeof * 8 && (byte_ & 0x40))
        результат |= -(1 << shift);
    *p = q;
    return результат;
}

/******************************
 * Determine size of Signed LEB128 encoded значение.
 * Параметры:
 *      значение = значение to be encoded
 * Возвращает:
 *      length of decoded значение
 * See_Also:
 *      https://en.wikipedia.org/wiki/LEB128
 */
бцел sLEB128size(цел значение)
{
    бцел size = 0;
    while (1)
    {
        ++size;
        ббайт b = значение & 0x40;

        значение >>= 7;            // arithmetic right shift
        if (значение == 0 && !b ||
            значение == -1 && b)
        {
             break;
        }
    }
    return size;
}

/******************************
 * Determine size of Unsigned LEB128 encoded значение.
 * Параметры:
 *      значение = значение to be encoded
 * Возвращает:
 *      length of decoded значение
 * See_Also:
 *      https://en.wikipedia.org/wiki/LEB128
 */
бцел uLEB128size(бцел значение)
{
    бцел size = 1;
    while ((значение >>= 7) != 0)
        ++size;
    return size;
}

debug
проц unittest_LEB128()
{
    Outbuffer буф;

    static const цел[16] values =
    [
        0,1,2,3,300,4000,50000,600000,
        -0,-1,-2,-3,-300,-4000,-50000,-600000,
    ];

    for (т_мера i = 0; i < values.length; ++i)
    {
        const цел значение = values[i];

        буф.сбрось();
        буф.writeuLEB128(значение);
        assert(буф.size() == uLEB128size(значение));
        ббайт *p = буф.буф;
        цел результат = uLEB128(&p);
        assert(p == буф.p);
        assert(результат == значение);

        буф.сбрось();
        буф.writesLEB128(значение);
        assert(буф.size() == sLEB128size(значение));
        p = буф.буф;
        результат = sLEB128(&p);
        assert(p == буф.p);
        assert(результат == значение);
    }
}


debug
проц unittest_dwarfeh()
{
     бул run = нет;
    if (run)
        return;
    run = да;

    unittest_LEB128();
    unittest_actionTableInsert();
}

}
