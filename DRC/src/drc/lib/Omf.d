/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/libomf.d, _libomf.d)
 * Documentation:  https://dlang.org/phobos/dmd_libomf.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/libomf.d
 */

module drc.lib.Omf;

version(Windows):

import cidrus;

import dmd.globals;
import util.utils;
import drc.Library;

import util.array;
import util.file;
import util.filename;
import util.rmem;
import util.outbuffer;
import util.string;
import util.stringtable;

import drc.lib.Scanomf;

// Entry point (only public symbol in this module).
 Library LibOMF_factory()
{
    return new LibOMF();
}

private: // for the remainder of this module

const LOG = нет;

struct OmfObjSymbol
{
    ткст0 имя;
    OmfObjModule* om;
}

alias  МассивДРК!(OmfObjModule*) OmfObjModules;
alias  МассивДРК!(OmfObjSymbol*) OmfObjSymbols;

extern (C) бцел _rotl(бцел значение, цел shift);
extern (C) бцел _rotr(бцел значение, цел shift);

final class LibOMF : Library
{
    OmfObjModules objmodules; // OmfObjModule[]
    OmfObjSymbols objsymbols; // OmfObjSymbol[]
    ТаблицаСтрок!(OmfObjSymbol*) tab;

    this()
    {
        tab._иниц(14000);
    }

    /***************************************
     * Add объект module or library to the library.
     * Examine the буфер to see which it is.
     * If the буфер is NULL, use module_name as the файл имя
     * and load the файл.
     */
    override проц addObject(ткст0 module_name, ббайт[] буфер)
    {
        static if (LOG)
        {
            printf("LibOMF::addObject(%s)\n", module_name ? module_name : "");
        }

        проц corrupt(цел reason)
        {
            выведиОшибку("corrupt OMF объект module %s %d", module_name, reason);
        }

        auto буф = буфер.ptr;
        auto buflen = буфер.length;
        if (!буф)
        {
            assert(module_name);
            // читай файл and take буфер ownership
            auto данные = readFile(Место.initial, module_name).извлекиСрез();
            буф = данные.ptr;
            buflen = данные.length;
        }
        бцел g_page_size;
        ббайт* pstart = cast(ббайт*)буф;
        бул islibrary = нет;
        /* See if it's an OMF library.
         * Don't go by файл extension.
         */
        struct LibHeader
        {
        align(1):
            ббайт recTyp; // 0xF0
            ushort pagesize;
            бцел lSymSeek;
            ushort ndicpages;
        }

        /* Determine if it is an OMF library, an OMF объект module,
         * or something else.
         */
        if (buflen < (LibHeader).sizeof)
            return corrupt(__LINE__);
        const lh = LibHeader* буф;
        if (lh.recTyp == 0xF0)
        {
            /* OMF library
             * The modules are all at буф[g_page_size .. lh.lSymSeek]
             */
            islibrary = 1;
            g_page_size = lh.pagesize + 3;
            буф = cast(ббайт*)(pstart + g_page_size);
            if (lh.lSymSeek > buflen || g_page_size > buflen)
                return corrupt(__LINE__);
            buflen = lh.lSymSeek - g_page_size;
        }
        else if (lh.recTyp == '!' && memcmp(lh, "!<arch>\n".ptr, 8) == 0)
        {
            выведиОшибку("COFF libraries not supported");
            return;
        }
        else
        {
            // Not a library, assume OMF объект module
            g_page_size = 16;
        }
        бул firstmodule = да;

        проц addOmfObjModule(ткст0 имя, ук base, т_мера length)
        {
            auto om = new OmfObjModule();
            om.base = cast(ббайт*)base;
            om.page = cast(ushort)((om.base - pstart) / g_page_size);
            om.length = cast(бцел)length;
            /* Determine the имя of the module
             */
            if (firstmodule && module_name && !islibrary)
            {
                // Remove path and extension
                auto n = cast(сим*)Пам.check(strdup(ИмяФайла.имя(module_name)));
                om.имя = n.вТкстД();
                ткст0 ext = cast(сим*)ИмяФайла.ext(n);
                if (ext)
                    ext[-1] = 0;
            }
            else
            {
                /* Use THEADR имя as module имя,
                 * removing path and extension.
                 */
                auto n = cast(сим*)Пам.check(strdup(ИмяФайла.имя(имя)));
                om.имя = n.вТкстД();
                ткст0 ext = cast(сим*)ИмяФайла.ext(n);
                if (ext)
                    ext[-1] = 0;
            }
            firstmodule = нет;
            this.objmodules.сунь(om);
        }

        if (scanOmfLib(&addOmfObjModule, cast(ук)буф, buflen, g_page_size))
            return corrupt(__LINE__);
    }

    /*****************************************************************************/

    проц addSymbol(OmfObjModule* om, ткст имя, цел pickAny = 0)
    {
        assert(имя.length == strlen(имя.ptr));
        static if (LOG)
        {
            printf("LibOMF::addSymbol(%.*s, %.*s, %d)\n",
                cast(цел)om.имя.length, om.имя.ptr,
                cast(цел)имя.length, имя.ptr, pickAny);
        }
        if (auto s = tab.вставь(имя, null))
        {
            auto ос = new OmfObjSymbol();
            ос.имя = cast(сим*)Пам.check(strdup(имя.ptr));
            ос.om = om;
            s.значение = ос;
            objsymbols.сунь(ос);
        }
        else
        {
            // already in table
            if (!pickAny)
            {
                const s2 = tab.lookup(имя);
                assert(s2);
                const ос = s2.значение;
                выведиОшибку("multiple definition of %.*s: %.*s and %.*s: %s",
                    cast(цел)om.имя.length, om.имя.ptr,
                    cast(цел)имя.length, имя.ptr,
                    cast(цел)ос.om.имя.length, ос.om.имя.ptr, ос.имя);
            }
        }
    }

private:
    /************************************
     * Scan single объект module for dictionary symbols.
     * Send those symbols to LibOMF::addSymbol().
     */
    проц scanObjModule(OmfObjModule* om)
    {
        static if (LOG)
        {
            printf("LibMSCoff::scanObjModule(%s)\n", om.имя.ptr);
        }

        extern (D) проц addSymbol(ткст имя, цел pickAny)
        {
            this.addSymbol(om, имя, pickAny);
        }

        scanOmfObjModule(&addSymbol, om.base[0 .. om.length], om.имя.ptr, место);
    }

    /***********************************
     * Calculates number of pages needed for dictionary
     * Возвращает:
     *      number of pages
     */
    ushort numDictPages(бцел padding)
    {
        ushort ndicpages;
        ushort bucksForHash;
        ushort bucksForSize;
        бцел symSize = 0;
        foreach (s; objsymbols)
        {
            symSize += (strlen(s.имя) + 4) & ~1;
        }
        foreach (om; objmodules)
        {
            т_мера len = om.имя.length;
            if (len > 0xFF)
                len += 2; // Digital Mars long имя extension
            symSize += (len + 4 + 1) & ~1;
        }
        bucksForHash = cast(ushort)((objsymbols.dim + objmodules.dim + HASHMOD - 3) / (HASHMOD - 2));
        bucksForSize = cast(ushort)((symSize + BUCKETSIZE - padding - padding - 1) / (BUCKETSIZE - padding));
        ndicpages = (bucksForHash > bucksForSize) ? bucksForHash : bucksForSize;
        //printf("ndicpages = %u\n",ndicpages);
        // Find prime number greater than ndicpages
         бцел* primes =
        [
            1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43,
            47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103,
            107, 109, 113, 127, 131, 137, 139, 149, 151, 157,
            163, 167, 173, 179, 181, 191, 193, 197, 199, 211,
            223, 227, 229, 233, 239, 241, 251, 257, 263, 269,
            271, 277, 281, 283, 293, 307, 311, 313, 317, 331,
            337, 347, 349, 353, 359, 367, 373, 379, 383, 389,
            397, 401, 409, 419, 421, 431, 433, 439, 443, 449,
            457, 461, 463, 467, 479, 487, 491, 499, 503, 509,
            //521,523,541,547,
            0
        ];
        for (т_мера i = 0; 1; i++)
        {
            if (primes[i] == 0)
            {
                // Quick and easy way is out.
                // Now try and найди first prime number > ndicpages
                бцел prime;
                for (prime = (ndicpages + 1) | 1; 1; prime += 2)
                {
                    // Determine if prime is prime
                    for (бцел u = 3; u < prime / 2; u += 2)
                    {
                        if ((prime / u) * u == prime)
                            goto L1;
                    }
                    break;                
                }
                L1:
                ndicpages = cast(ushort)prime;
                break;
            }
            if (primes[i] > ndicpages)
            {
                ndicpages = cast(ushort)primes[i];
                break;
            }
        }
        return ndicpages;
    }

    /*******************************************
     * Write the module and symbol имена to the dictionary.
     * Возвращает:
     *      нет   failure
     */
    бул FillDict(ббайт* bucketsP, ushort ndicpages)
    {
        // max size that will fit in dictionary
        const LIBIDMAX = (512 - 0x25 - 3 - 4);
        ббайт[4 + LIBIDMAX + 2 + 1] entry;
        //printf("FillDict()\n");
        // Add each of the module имена
        foreach (om; objmodules)
        {
            ushort n = cast(ushort)om.имя.length;
            if (n > 255)
            {
                entry[0] = 0xFF;
                entry[1] = 0;
                *cast(ushort*)(entry.ptr + 2) = cast(ushort)(n + 1);
                memcpy(entry.ptr + 4, om.имя.ptr, n);
                n += 3;
            }
            else
            {
                entry[0] = cast(ббайт)(1 + n);
                memcpy(entry.ptr + 1, om.имя.ptr, n);
            }
            entry[n + 1] = '!';
            *(cast(ushort*)(n + 2 + entry.ptr)) = om.page;
            if (n & 1)
                entry[n + 2 + 2] = 0;
            if (!EnterDict(bucketsP, ndicpages, entry.ptr, n + 1))
                return нет;
        }
        // Sort the symbols
        qsort(objsymbols.tdata(), objsymbols.dim, (objsymbols[0]).sizeof, cast(_compare_fp_t)&NameCompare);
        // Add each of the symbols
        foreach (ос; objsymbols)
        {
            ushort n = cast(ushort)strlen(ос.имя);
            if (n > 255)
            {
                entry[0] = 0xFF;
                entry[1] = 0;
                *cast(ushort*)(entry.ptr + 2) = n;
                memcpy(entry.ptr + 4, ос.имя, n);
                n += 3;
            }
            else
            {
                entry[0] = cast(ббайт)n;
                memcpy(entry.ptr + 1, ос.имя, n);
            }
            *(cast(ushort*)(n + 1 + entry.ptr)) = ос.om.page;
            if ((n & 1) == 0)
                entry[n + 3] = 0;
            if (!EnterDict(bucketsP, ndicpages, entry.ptr, n))
            {
                return нет;
            }
        }
        return да;
    }

    /**********************************************
     * Create and пиши library to libbuf.
     * The library consists of:
     *      library header
     *      объект modules...
     *      dictionary header
     *      dictionary pages...
     */
    protected override проц WriteLibToBuffer(БуфВыв* libbuf)
    {
        /* Scan each of the объект modules for symbols
         * to go into the dictionary
         */
        foreach (om; objmodules)
        {
            scanObjModule(om);
        }
        бцел g_page_size = 16;
        /* Calculate page size so that the number of pages
         * fits in 16 bits. This is because объект modules
         * are indexed by page number, stored as an unsigned short.
         */
        while (1)
        {
        Lagain:
            static if (LOG)
            {
                printf("g_page_size = %d\n", g_page_size);
            }
            бцел смещение = g_page_size;
            foreach (om; objmodules)
            {
                бцел page = смещение / g_page_size;
                if (page > 0xFFFF)
                {
                    // Page size is too small, double it and try again
                    g_page_size *= 2;
                    goto Lagain;
                }
                смещение += OMFObjSize(om.base, om.length, om.имя.ptr);
                // Round the size of the файл up to the следщ page size
                // by filling with 0s
                бцел n = (g_page_size - 1) & смещение;
                if (n)
                    смещение += g_page_size - n;
            }
            break;
        }
        /* Leave one page of 0s at start as a dummy library header.
         * Fill it in later with the real данные.
         */
        libbuf.занули(g_page_size);
        /* Write each объект module into the library
         */
        foreach (om; objmodules)
        {
            бцел page = cast(бцел)(libbuf.length / g_page_size);
            assert(page <= 0xFFFF);
            om.page = cast(ushort)page;
            // Write out the объект module om
            writeOMFObj(libbuf, om.base, om.length, om.имя.ptr);
            // Round the size of the файл up to the следщ page size
            // by filling with 0s
            бцел n = (g_page_size - 1) & libbuf.length;
            if (n)
                libbuf.занули(g_page_size - n);
        }
        // Файл смещение of start of dictionary
        бцел смещение = cast(бцел)libbuf.length;
        // Write dictionary header, then round it to a BUCKETPAGE boundary
        ushort size = (BUCKETPAGE - (cast(short)смещение + 3)) & (BUCKETPAGE - 1);
        libbuf.пишиБайт(0xF1);
        libbuf.пишиУорд(size);
        libbuf.занули(size);
        // Create dictionary
        ббайт* bucketsP = null;
        ushort ndicpages;
        ushort padding = 32;
        for (;;)
        {
            ndicpages = numDictPages(padding);
            static if (LOG)
            {
                printf("ndicpages = %d\n", ndicpages);
            }
            // Allocate dictionary
            if (bucketsP)
                bucketsP = cast(ббайт*)Пам.check(realloc(bucketsP, ndicpages * BUCKETPAGE));
            else
                bucketsP = cast(ббайт*)Пам.check(malloc(ndicpages * BUCKETPAGE));
            memset(bucketsP, 0, ndicpages * BUCKETPAGE);
            for (бцел u = 0; u < ndicpages; u++)
            {
                // 'следщ доступно' slot
                bucketsP[u * BUCKETPAGE + HASHMOD] = (HASHMOD + 1) >> 1;
            }
            if (FillDict(bucketsP, ndicpages))
                break;
            padding += 16; // try again with more margins
        }
        // Write dictionary
        libbuf.пиши(bucketsP[0 .. ndicpages * BUCKETPAGE]);
        if (bucketsP)
            free(bucketsP);
        // Create library header
        struct Libheader
        {
        align(1):
            ббайт recTyp;
            ushort recLen;
            бцел trailerPosn;
            ushort ndicpages;
            ббайт flags;
            бцел filler;
        }

        Libheader libHeader;
        memset(&libHeader, 0, (Libheader).sizeof);
        libHeader.recTyp = 0xF0;
        libHeader.recLen = 0x0D;
        libHeader.trailerPosn = смещение + (3 + size);
        libHeader.recLen = cast(ushort)(g_page_size - 3);
        libHeader.ndicpages = ndicpages;
        libHeader.flags = 1; // always case sensitive
        // Write library header at start of буфер
        memcpy(cast(ук)(*libbuf)[].ptr, &libHeader, (libHeader).sizeof);
    }
}

/*****************************************************************************/
/*****************************************************************************/
struct OmfObjModule
{
    ббайт* base; // where are we holding it in memory
    бцел length; // in bytes
    ushort page; // page module starts in output файл
    ткст имя; // module имя, with terminating 0
}

/*****************************************************************************/
/*****************************************************************************/
extern (C)
{
    цел NameCompare(ук p1, ук p2)
    {
        return strcmp((*cast(OmfObjSymbol**)p1).имя, (*cast(OmfObjSymbol**)p2).имя);
    }
}

const HASHMOD = 0x25;
const BUCKETPAGE = 512;
const BUCKETSIZE = (BUCKETPAGE - HASHMOD - 1);

/*******************************************
 * Write a single entry into dictionary.
 * Возвращает:
 *      нет   failure
 */
бул EnterDict(ббайт* bucketsP, ushort ndicpages, ббайт* entry, бцел entrylen)
{
    ushort uStartIndex;
    ushort uStep;
    ushort uStartPage;
    ushort uPageStep;
    ushort uIndex;
    ushort uPage;
    ushort n;
    бцел u;
    бцел члобайт;
    ббайт* aP;
    ббайт* zP;
    aP = entry;
    zP = aP + entrylen; // point at last сим in идентификатор
    uStartPage = 0;
    uPageStep = 0;
    uStartIndex = 0;
    uStep = 0;
    u = entrylen;
    while (u--)
    {
        uStartPage = cast(ushort)_rotl(uStartPage, 2) ^ (*aP | 0x20);
        uStep = cast(ushort)_rotr(uStep, 2) ^ (*aP++ | 0x20);
        uStartIndex = cast(ushort)_rotr(uStartIndex, 2) ^ (*zP | 0x20);
        uPageStep = cast(ushort)_rotl(uPageStep, 2) ^ (*zP-- | 0x20);
    }
    uStartPage %= ndicpages;
    uPageStep %= ndicpages;
    if (uPageStep == 0)
        uPageStep++;
    uStartIndex %= HASHMOD;
    uStep %= HASHMOD;
    if (uStep == 0)
        uStep++;
    uPage = uStartPage;
    uIndex = uStartIndex;
    // number of bytes in entry
    члобайт = 1 + entrylen + 2;
    if (entrylen > 255)
        члобайт += 2;
    while (1)
    {
        aP = &bucketsP[uPage * BUCKETPAGE];
        uStartIndex = uIndex;
        while (1)
        {
            if (0 == aP[uIndex])
            {
                // n = следщ доступно position in this page
                n = aP[HASHMOD] << 1;
                assert(n > HASHMOD);
                // if off end of this page
                if (n + члобайт > BUCKETPAGE)
                {
                    aP[HASHMOD] = 0xFF;
                    break;
                    // следщ page
                }
                else
                {
                    aP[uIndex] = cast(ббайт)(n >> 1);
                    memcpy((aP + n), entry, члобайт);
                    aP[HASHMOD] += (члобайт + 1) >> 1;
                    if (aP[HASHMOD] == 0)
                        aP[HASHMOD] = 0xFF;
                    return да;
                }
            }
            uIndex += uStep;
            uIndex %= 0x25;
            /*if (uIndex > 0x25)
             uIndex -= 0x25;*/
            if (uIndex == uStartIndex)
                break;
        }
        uPage += uPageStep;
        if (uPage >= ndicpages)
            uPage -= ndicpages;
        if (uPage == uStartPage)
            break;
    }
    return нет;
}
