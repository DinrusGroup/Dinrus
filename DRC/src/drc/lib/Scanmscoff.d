/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/scanmscoff.d, _scanmscoff.d)
 * Documentation:  https://dlang.org/phobos/dmd_scanmscoff.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/scanmscoff.d
 */

module drc.lib.Scanmscoff;

version(Windows):

import cidrus, win32.winnt;

import util.rmem;
import util.string;

import dmd.globals, dmd.errors;

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
проц scanMSCoffObjModule(проц delegate(ткст имя, цел pickAny) pAddSymbol,
        ббайт[] base, ткст0 module_name, Место место)
{
    static if (LOG)
    {
        printf("scanMSCoffObjModule(%s)\n", module_name);
    }

    проц corrupt(цел reason)
    {
        выведиОшибку(место, "corrupt MS-Coff объект module `%s` %d", module_name, reason);
    }

    const буф = base.ptr;
    const buflen = base.length;
    /* First do sanity checks on объект файл
     */
    if (buflen < BIGOBJ_HEADER.sizeof)
        return corrupt(__LINE__);

    BIGOBJ_HEADER* header = cast(BIGOBJ_HEADER*)буф;
    сим is_old_coff = нет;
    if (header.Sig2 != 0xFFFF && header.Version != 2)
    {
        is_old_coff = да;
        IMAGE_FILE_HEADER* header_old;
        header_old = cast(IMAGE_FILE_HEADER*)Пам.check(malloc(IMAGE_FILE_HEADER.sizeof));
        memcpy(header_old, буф, IMAGE_FILE_HEADER.sizeof);
        header = cast(BIGOBJ_HEADER*)Пам.check(malloc(BIGOBJ_HEADER.sizeof));
        *header = BIGOBJ_HEADER.init;
        header.Machine = header_old.Machine;
        header.NumberOfSections = header_old.NumberOfSections;
        header.TimeDateStamp = header_old.TimeDateStamp;
        header.PointerToSymbolTable = header_old.PointerToSymbolTable;
        header.NumberOfSymbols = header_old.NumberOfSymbols;
        free(header_old);
    }
    switch (header.Machine)
    {
    case IMAGE_FILE_MACHINE_UNKNOWN:
    case IMAGE_FILE_MACHINE_I386:
    case IMAGE_FILE_MACHINE_AMD64:
        break;
    default:
        if (буф[0] == 0x80)
            выведиОшибку(место, "Object module `%s` is 32 bit OMF, but it should be 64 bit MS-Coff", module_name);
        else
            выведиОшибку(место, "MS-Coff объект module `%s` has magic = %x, should be %x", module_name, header.Machine, IMAGE_FILE_MACHINE_AMD64);
        return;
    }
    // Get ткст table:  string_table[0..string_len]
    т_мера off = header.PointerToSymbolTable;
    if (off == 0)
    {
        выведиОшибку(место, "MS-Coff объект module `%s` has no ткст table", module_name);
        return;
    }
    off += header.NumberOfSymbols * (is_old_coff ? SymbolTable.sizeof : SymbolTable32.sizeof);
    if (off + 4 > buflen)
        return corrupt(__LINE__);

    бцел string_len = *cast(бцел*)(буф + off);
    ткст0 string_table = cast(сим*)(буф + off + 4);
    if (off + string_len > buflen)
        return corrupt(__LINE__);

    string_len -= 4;
    for (цел i = 0; i < header.NumberOfSymbols; i++)
    {
        SymbolTable32* n;
        сим[8 + 1] s;
        ткст0 p;
        static if (LOG)
        {
            printf("Symbol %d:\n", i);
        }
        off = header.PointerToSymbolTable + i * (is_old_coff ? SymbolTable.sizeof : SymbolTable32.sizeof);
        if (off > buflen)
            return corrupt(__LINE__);

        n = cast(SymbolTable32*)(буф + off);
        if (is_old_coff)
        {
            SymbolTable* n2;
            n2 = cast(SymbolTable*)Пам.check(malloc(SymbolTable.sizeof));
            memcpy(n2, (буф + off), SymbolTable.sizeof);
            n = cast(SymbolTable32*)Пам.check(malloc(SymbolTable32.sizeof));
            memcpy(n, n2, (n2.Name).sizeof);
            n.Значение = n2.Значение;
            n.SectionNumber = n2.SectionNumber;
            n.Тип = n2.Тип;
            n.КлассХранения = n2.КлассХранения;
            n.NumberOfAuxSymbols = n2.NumberOfAuxSymbols;
            free(n2);
        }
        if (n.Zeros)
        {
            strncpy(s.ptr, cast(сим*)n.Name, 8);
            s[SYMNMLEN] = 0;
            p = s.ptr;
        }
        else
            p = string_table + n.Offset - 4;
        i += n.NumberOfAuxSymbols;
        static if (LOG)
        {
            printf("n_name    = '%s'\n", p);
            printf("n_value   = x%08lx\n", n.Значение);
            printf("n_scnum   = %d\n", n.SectionNumber);
            printf("n_type    = x%04x\n", n.Тип);
            printf("n_sclass  = %d\n", n.КлассХранения);
            printf("n_numaux  = %d\n", n.NumberOfAuxSymbols);
        }
        switch (n.SectionNumber)
        {
        case IMAGE_SYM_DEBUG:
            continue;
        case IMAGE_SYM_ABSOLUTE:
            if (strcmp(p, "@comp.ид") == 0)
                continue;
            break;
        case IMAGE_SYM_UNDEFINED:
            // A non-нуль значение indicates a common block
            if (n.Значение)
                break;
            continue;
        default:
            break;
        }
        switch (n.КлассХранения)
        {
        case IMAGE_SYM_CLASS_EXTERNAL:
            break;
        case IMAGE_SYM_CLASS_STATIC:
            if (n.Значение == 0) // if it's a section имя
                continue;
            continue;
        case IMAGE_SYM_CLASS_FUNCTION:
        case IMAGE_SYM_CLASS_FILE:
        case IMAGE_SYM_CLASS_LABEL:
            continue;
        default:
            continue;
        }
        pAddSymbol(p.вТкстД(), 1);
    }
}

private: // for the remainder of this module

align(1)
struct BIGOBJ_HEADER
{
    WORD Sig1;                  // IMAGE_FILE_MACHINE_UNKNOWN
    WORD Sig2;                  // 0xFFFF
    WORD Version;               // 2
    WORD Machine;               // identifies тип of target machine
    DWORD TimeDateStamp;        // creation date, number of seconds since 1970
    BYTE[16]  UUID;             //  { '\xc7', '\xa1', '\xba', '\xd1', '\xee', '\xba', '\xa9', '\x4b',
                                //    '\xaf', '\x20', '\xfa', '\xf6', '\x6a', '\xa4', '\xdc', '\xb8' };
    DWORD[4] unused;            // { 0, 0, 0, 0 }
    DWORD NumberOfSections;     // number of sections
    DWORD PointerToSymbolTable; // файл смещение of symbol table
    DWORD NumberOfSymbols;      // number of entries in the symbol table
}

align(1)
struct IMAGE_FILE_HEADER
{
    WORD  Machine;
    WORD  NumberOfSections;
    DWORD TimeDateStamp;
    DWORD PointerToSymbolTable;
    DWORD NumberOfSymbols;
    WORD  SizeOfOptionalHeader;
    WORD  Characteristics;
}

const SYMNMLEN = 8;

const IMAGE_FILE_MACHINE_UNKNOWN = 0;            // applies to any machine тип
const IMAGE_FILE_MACHINE_I386    = 0x14C;        // x86
const IMAGE_FILE_MACHINE_AMD64   = 0x8664;       // x86_64

const IMAGE_SYM_DEBUG     = -2;
const IMAGE_SYM_ABSOLUTE  = -1;
const IMAGE_SYM_UNDEFINED = 0;

const IMAGE_SYM_CLASS_EXTERNAL = 2;
const IMAGE_SYM_CLASS_STATIC   = 3;
const IMAGE_SYM_CLASS_LABEL    = 6;
const IMAGE_SYM_CLASS_FUNCTION = 101;
const IMAGE_SYM_CLASS_FILE     = 103;

align(1) struct SymbolTable32
{
    union
    {
        BYTE[SYMNMLEN] Name;
        struct
        {
            DWORD Zeros;
            DWORD Offset;
        }
    }

    DWORD Значение;
    DWORD SectionNumber;
    WORD Тип;
    BYTE КлассХранения;
    BYTE NumberOfAuxSymbols;
}

align(1) struct SymbolTable
{
    BYTE[SYMNMLEN] Name;
    DWORD Значение;
    WORD SectionNumber;
    WORD Тип;
    BYTE КлассХранения;
    BYTE NumberOfAuxSymbols;
}
