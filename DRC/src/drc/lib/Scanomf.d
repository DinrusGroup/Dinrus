/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/scanomf.d, _scanomf.d)
 * Documentation:  https://dlang.org/phobos/dmd_scanomf.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/scanomf.d
 */

module drc.lib.Scanomf;

version(Windows):

import cidrus;
import dmd.globals;
import util.rmem;
import util.outbuffer;
import util.string;
import dmd.arraytypes;
import dmd.errors;

private const LOG = нет;

/*****************************************
 * Reads an объект module from base[] and passes the имена
 * of any exported symbols to (*pAddSymbol)().
 * Параметры:
 *      pAddSymbol =  function to pass the имена to
 *      base =        массив of contents of объект module
 *      module_name = имя of the объект module (используется for error messages)
 *      место =         location to use for error printing
 */
проц scanOmfObjModule(проц delegate(ткст имя, цел pickAny) pAddSymbol,
        ббайт[] base, ткст0 module_name, Место место)
{
    static if (LOG)
    {
        printf("scanOmfObjModule(%s)\n", module_name);
    }
    цел easyomf;
    сим[LIBIDMAX + 1] имя;
    Strings имена;
    scope(exit)
        for (т_мера u = 1; u < имена.dim; u++)
            free(cast(ук)имена[u]);
    имена.сунь(null); // don't use index 0
    easyomf = 0; // assume not EASY-OMF
    auto pend = cast(ббайт*)base.ptr + base.length;
    const ббайт* pnext;
    for (auto p = cast(ббайт*)base.ptr; 1; p = pnext)
    {
        assert(p < pend);
        ббайт recTyp = *p++;
        ushort recLen = *cast(ushort*)p;
        p += 2;
        pnext = p + recLen;
        recLen--; // forget the checksum
        switch (recTyp)
        {
        case LNAMES:
        case LLNAMES:
            while (p + 1 < pnext)
            {
                parseName(&p, имя.ptr);
                ткст0 копируй = cast(сим*)Пам.check(strdup(имя.ptr));
                имена.сунь(копируй);
            }
            break;
        case PUBDEF:
            if (easyomf)
                recTyp = PUB386; // convert to MS format
            goto case;
        case PUB386:
            if (!(parseIdx(&p) | parseIdx(&p)))
                p += 2; // skip seg, grp, frame
            while (p + 1 < pnext)
            {
                parseName(&p, имя.ptr);
                p += (recTyp == PUBDEF) ? 2 : 4; // skip смещение
                parseIdx(&p); // skip тип index
                pAddSymbol(имя[0 .. strlen(имя.ptr)], 0);
            }
            break;
        case COMDAT:
            if (easyomf)
                recTyp = COMDAT + 1; // convert to MS format
            goto case;
        case COMDAT + 1:
            {
                цел pickAny = 0;
                if (*p++ & 5) // if continuation or local comdat
                    break;
                ббайт attr = *p++;
                if (attr & 0xF0) // attr: if multiple instances allowed
                    pickAny = 1;
                p++; // align
                p += 2; // enum данные смещение
                if (recTyp == COMDAT + 1)
                    p += 2; // enum данные смещение
                parseIdx(&p); // тип index
                if ((attr & 0x0F) == 0) // if explicit allocation
                {
                    parseIdx(&p); // base group
                    parseIdx(&p); // base segment
                }
                бцел idx = parseIdx(&p); // public имя index
                if (idx == 0 || idx >= имена.dim)
                {
                    //debug(printf("[s] имя idx=%d, uCntNames=%d\n", idx, uCntNames));
                    выведиОшибку(место, "corrupt COMDAT");
                    return;
                }
                //printf("[s] имя='%s'\n",имя);
                ткст0 n = имена[idx];
                pAddSymbol(n.вТкстД(), pickAny);
                break;
            }
        case COMDEF:
            {
                while (p + 1 < pnext)
                {
                    parseName(&p, имя.ptr);
                    parseIdx(&p); // тип index
                    skipDataType(&p); // данные тип
                    pAddSymbol(имя[0 .. strlen(имя.ptr)], 1);
                }
                break;
            }
        case ALIAS:
            while (p + 1 < pnext)
            {
                parseName(&p, имя.ptr);
                pAddSymbol(имя[0 .. strlen(имя.ptr)], 0);
                parseName(&p, имя.ptr);
            }
            break;
        case MODEND:
        case M386END:
            return;
        case COMENT:
            // Recognize Phar Lap EASY-OMF format
            {
                 ббайт* omfstr1 = [0x80, 0xAA, '8', '0', '3', '8', '6'];
                if (recLen == (omfstr1).sizeof)
                {
                    for (бцел i = 0; i < (omfstr1).sizeof; i++)
                        if (*p++ != omfstr1[i])
                            goto L1;
                    easyomf = 1;
                    break;               
                }
            }
             L1:
            // Recognize .IMPDEF Импорт Definition Records
            {
                 ббайт* omfstr2 = [0, 0xA0, 1];
                if (recLen >= 7)
                {
                    p++;
                    for (бцел i = 1; i < (omfstr2).sizeof; i++)
                        if (*p++ != omfstr2[i])
                            goto L2;
                    p++; // skip OrdFlag field
                    parseName(&p, имя.ptr);
                    pAddSymbol(имя[0 .. strlen(имя.ptr)], 0);
                    break;
               
                }
            }
             L2:
            break;
        default:
            // ignore
        }
    }
}

/*************************************************
 * Scan a block of memory буф[0..buflen], pulling out each
 * OMF объект module in it and sending the info in it to (*pAddObjModule).
 * Возвращает:
 *      да for corrupt OMF данные
 */
бул scanOmfLib(проц delegate(ткст0 имя, ук base, т_мера length) pAddObjModule, ук буф, т_мера buflen, бцел pagesize)
{
    /* Split up the буфер буф[0..buflen] into multiple объект modules,
     * each aligned on a pagesize boundary.
     */
    ббайт* base = null;
    сим[LIBIDMAX + 1] имя;
    auto p = cast(ббайт*)буф;
    auto pend = p + buflen;
    ббайт* pnext;
    for (; p < pend; p = pnext) // for each OMF record
    {
        if (p + 3 >= pend)
            return да; // corrupt
        ббайт recTyp = *p;
        ushort recLen = *cast(ushort*)(p + 1);
        pnext = p + 3 + recLen;
        if (pnext > pend)
            return да; // corrupt
        recLen--; // forget the checksum
        switch (recTyp)
        {
        case LHEADR:
        case THEADR:
            if (!base)
            {
                base = p;
                p += 3;
                parseName(&p, имя.ptr);
                if (имя[0] == 'C' && имя[1] == 0) // old C compilers did this
                    base = pnext; // skip past THEADR
            }
            break;
        case MODEND:
        case M386END:
            {
                if (base)
                {
                    pAddObjModule(имя.ptr, cast(ббайт*)base, pnext - base);
                    base = null;
                }
                // Round up to следщ page
                бцел t = cast(бцел)(pnext - cast(ббайт*) буф);
                t = (t + pagesize - 1) & ~cast(бцел)(pagesize - 1);
                pnext = cast(ббайт*)буф + t;
                break;
            }
        default:
            // ignore
        }
    }
    return (base !is null); // missing MODEND record
}

бцел OMFObjSize(ук base, бцел length, ткст0 имя)
{
    ббайт c = *cast(ббайт*)base;
    if (c != THEADR && c != LHEADR)
    {
        т_мера len = strlen(имя);
        assert(len <= LIBIDMAX);
        length += len + 5;
    }
    return length;
}

проц writeOMFObj(БуфВыв* буф, ук base, бцел length, ткст0 имя)
{
    ббайт c = *cast(ббайт*)base;
    if (c != THEADR && c != LHEADR)
    {
        const len = strlen(имя);
        assert(len <= LIBIDMAX);
        ббайт[4 + LIBIDMAX + 1] header;
        header[0] = THEADR;
        header[1] = cast(ббайт)(2 + len);
        header[2] = 0;
        header[3] = cast(ббайт)len;
        assert(len <= 0xFF - 2);
        memcpy(4 + header.ptr, имя, len);
        // Compute and store record checksum
        бцел n = cast(бцел)(len + 4);
        ббайт checksum = 0;
        ббайт* p = header.ptr;
        while (n--)
        {
            checksum -= *p;
            p++;
        }
        *p = checksum;
        буф.пиши(header.ptr[0 .. len + 5]);
    }
    буф.пиши(base[0 .. length]);
}

private: // for the remainder of this module

/**************************
 * Record types:
 */
const RHEADR = 0x6E;
const REGINT = 0x70;
const REDATA = 0x72;
const RIDATA = 0x74;
const OVLDEF = 0x76;
const ENDREC = 0x78;
const BLKDEF = 0x7A;
const BLKEND = 0x7C;
const DEBSYM = 0x7E;
const THEADR = 0x80;
const LHEADR = 0x82;
const PEDATA = 0x84;
const PIDATA = 0x86;
const COMENT = 0x88;
const MODEND = 0x8A;
const M386END = 0x8B; /* 32 bit module end record */
const EXTDEF = 0x8C;
const TYPDEF = 0x8E;
const PUBDEF = 0x90;
const PUB386 = 0x91;
const LOCSYM = 0x92;
const LINNUM = 0x94;
const LNAMES = 0x96;
const SEGDEF = 0x98;
const GRPDEF = 0x9A;
const FIXUPP = 0x9C;
/*#define (none)        0x9E    */
const LEDATA = 0xA0;
const LIDATA = 0xA2;
const LIBHED = 0xA4;
const LIBNAM = 0xA6;
const LIBLOC = 0xA8;
const LIBDIC = 0xAA;
const COMDEF = 0xB0;
const LEXTDEF = 0xB4;
const LPUBDEF = 0xB6;
const LCOMDEF = 0xB8;
const CEXTDEF = 0xBC;
const COMDAT = 0xC2;
const LINSYM = 0xC4;
const ALIAS = 0xC6;
const LLNAMES = 0xCA;
const LIBIDMAX = (512 - 0x25 - 3 - 4);

// max size that will fit in dictionary
 проц parseName(ббайт** pp, ткст0 имя)
{
    auto p = *pp;
    бцел len = *p++;
    if (len == 0xFF && *p == 0) // if long имя
    {
        len = p[1] & 0xFF;
        len |= cast(бцел)p[2] << 8;
        p += 3;
        assert(len <= LIBIDMAX);
    }
    memcpy(имя, p, len);
    имя[len] = 0;
    *pp = p + len;
}

ushort parseIdx(ббайт** pp)
{
    auto p = *pp;
    const c = *p++;
    ushort idx = (0x80 & c) ? ((0x7F & c) << 8) + *p++ : c;
    *pp = p;
    return idx;
}

// skip numeric field of a данные тип of a COMDEF record
проц skipNumericField(ббайт** pp)
{
    ббайт* p = *pp;
    const c = *p++;
    if (c == 0x81)
        p += 2;
    else if (c == 0x84)
        p += 3;
    else if (c == 0x88)
        p += 4;
    else
        assert(c <= 0x80);
    *pp = p;
}

// skip данные тип of a COMDEF record
проц skipDataType(ббайт** pp)
{
    auto p = *pp;
    const c = *p++;
    if (c == 0x61)
    {
        // FAR данные
        skipNumericField(&p);
        skipNumericField(&p);
    }
    else if (c == 0x62)
    {
        // NEAR данные
        skipNumericField(&p);
    }
    else
    {
        assert(1 <= c && c <= 0x5f); // Borland segment indices
    }
    *pp = p;
}
