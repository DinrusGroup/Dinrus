/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/scanmach.d, _scanmach.d)
 * Documentation:  https://dlang.org/phobos/dmd_scanmach.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/scanmach.d
 */

module drc.lib.Scanmach;

version(OSX):

import cidrus;
import core.sys.darwin.mach.loader;
import dmd.globals;
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
проц scanMachObjModule(проц delegate(ткст имя, цел pickAny) pAddSymbol,
        ббайт[] base, ткст0 module_name, Место место)
{
    static if (LOG)
    {
        printf("scanMachObjModule(%s)\n", module_name);
    }

    проц corrupt(цел reason)
    {
        выведиОшибку(место, "corrupt Mach-O объект module `%s` %d", module_name, reason);
    }

    const буф = base.ptr;
    const buflen = base.length;
    uint32_t ncmds;
    mach_header* header = cast(mach_header*)буф;
    mach_header_64* header64 = null;
    /* First do sanity checks on объект файл
     */
    if (buflen < mach_header.sizeof)
        return corrupt(__LINE__);

    if (header.magic == MH_MAGIC)
    {
        if (header.cputype != CPU_TYPE_I386)
        {
            выведиОшибку(место, "Mach-O объект module `%s` has cputype = %d, should be %d", module_name, header.cputype, CPU_TYPE_I386);
            return;
        }
        if (header.filetype != MH_OBJECT)
        {
            выведиОшибку(место, "Mach-O объект module `%s` has файл тип = %d, should be %d", module_name, header.filetype, MH_OBJECT);
            return;
        }
        if (buflen < mach_header.sizeof + header.sizeofcmds)
            return corrupt(__LINE__);
        ncmds = header.ncmds;
    }
    else if (header.magic == MH_MAGIC_64)
    {
        header64 = cast(mach_header_64*)буф;
        if (buflen < mach_header_64.sizeof)
            return corrupt(__LINE__);
        if (header64.cputype != CPU_TYPE_X86_64)
        {
            выведиОшибку(место, "Mach-O объект module `%s` has cputype = %d, should be %d", module_name, header64.cputype, CPU_TYPE_X86_64);
            return;
        }
        if (header64.filetype != MH_OBJECT)
        {
            выведиОшибку(место, "Mach-O объект module `%s` has файл тип = %d, should be %d", module_name, header64.filetype, MH_OBJECT);
            return;
        }
        if (buflen < mach_header_64.sizeof + header64.sizeofcmds)
            return corrupt(__LINE__);
        ncmds = header64.ncmds;
    }
    else
        return corrupt(__LINE__);

    symtab_command* symtab_commands;
    // Commands immediately follow mach_header
    ткст0 commands = cast(сим*)буф + (header.magic == MH_MAGIC_64 ? mach_header_64.sizeof : mach_header.sizeof);
    for (uint32_t i = 0; i < ncmds; i++)
    {
        load_command* command = cast(load_command*)commands;
        //printf("cmd = 0x%02x, cmdsize = %u\n", command.cmd, command.cmdsize);
        if (command.cmd == LC_SYMTAB)
            symtab_commands = cast(symtab_command*)command;
        commands += command.cmdsize;
    }

    if (!symtab_commands)
        return;

    // Get pointer to ткст table
    ткст0 strtab = cast(сим*)буф + symtab_commands.stroff;
    if (buflen < symtab_commands.stroff + symtab_commands.strsize)
        return corrupt(__LINE__);

    if (header.magic == MH_MAGIC_64)
    {
        // Get pointer to symbol table
        nlist_64* symtab = cast(nlist_64*)(cast(сим*)буф + symtab_commands.symoff);
        if (buflen < symtab_commands.symoff + symtab_commands.nsyms * nlist_64.sizeof)
            return corrupt(__LINE__);

        // For each symbol
        for (цел i = 0; i < symtab_commands.nsyms; i++)
        {
            nlist_64* s = symtab + i;
            ткст0 имя = strtab + s.n_strx;
            const namelen = strlen(имя);
            if (s.n_type & N_STAB)
            {
                // values in /usr/include/mach-o/stab.h
                //printf(" N_STAB");
                continue;
            }

            version (none)
            {
                if (s.n_type & N_PEXT)
                {
                }
                if (s.n_type & N_EXT)
                {
                }
            }
            switch (s.n_type & N_TYPE)
            {
            case N_UNDF:
                if (s.n_type & N_EXT && s.n_value != 0) // comdef
                    pAddSymbol(имя[0 .. namelen], 1);
                break;
            case N_ABS:
                break;
            case N_SECT:
                if (s.n_type & N_EXT) /*&& !(s.n_desc & N_REF_TO_WEAK)*/
                    pAddSymbol(имя[0 .. namelen], 1);
                break;
            case N_PBUD:
                break;
            case N_INDR:
                break;
            default:
                break;
            }

        }
    }
    else
    {
        // Get pointer to symbol table
        nlist* symtab = cast(nlist*)(cast(сим*)буф + symtab_commands.symoff);
        if (buflen < symtab_commands.symoff + symtab_commands.nsyms * nlist.sizeof)
            return corrupt(__LINE__);

        // For each symbol
        for (цел i = 0; i < symtab_commands.nsyms; i++)
        {
            nlist* s = symtab + i;
            ткст0 имя = strtab + s.n_strx;
            const namelen = strlen(имя);
            if (s.n_type & N_STAB)
            {
                // values in /usr/include/mach-o/stab.h
                //printf(" N_STAB");
                continue;
            }

            version (none)
            {
                if (s.n_type & N_PEXT)
                {
                }
                if (s.n_type & N_EXT)
                {
                }
            }
            switch (s.n_type & N_TYPE)
            {
            case N_UNDF:
                if (s.n_type & N_EXT && s.n_value != 0) // comdef
                    pAddSymbol(имя[0 .. namelen], 1);
                break;
            case N_ABS:
                break;
            case N_SECT:
                if (s.n_type & N_EXT) /*&& !(s.n_desc & N_REF_TO_WEAK)*/
                    pAddSymbol(имя[0 .. namelen], 1);
                break;
            case N_PBUD:
                break;
            case N_INDR:
                break;
            default:
                break;
            }
        }
    }
}

private: // for the remainder of this module

const CPU_TYPE_I386 = 7;
const CPU_TYPE_X86_64 = CPU_TYPE_I386 | 0x1000000;

const MH_OBJECT = 0x1;

struct segment_command
{
    uint32_t cmd;
    uint32_t cmdsize;
    сим[16] segname;
    uint32_t vmaddr;
    uint32_t vmsize;
    uint32_t fileoff;
    uint32_t filesize;
    int32_t  maxprot;
    int32_t  initprot;
    uint32_t nsects;
    uint32_t flags;
}

struct segment_command_64
{
    uint32_t cmd;
    uint32_t cmdsize;
    сим[16] segname;
    uint64_t vmaddr;
    uint64_t vmsize;
    uint64_t fileoff;
    uint64_t filesize;
    int32_t  maxprot;
    int32_t  initprot;
    uint32_t nsects;
    uint32_t flags;
}

struct symtab_command
{
    uint32_t cmd;
    uint32_t cmdsize;
    uint32_t symoff;
    uint32_t nsyms;
    uint32_t stroff;
    uint32_t strsize;
}

struct dysymtab_command
{
    uint32_t cmd;
    uint32_t cmdsize;
    uint32_t ilocalsym;
    uint32_t nlocalsym;
    uint32_t iextdefsym;
    uint32_t nextdefsym;
    uint32_t iundefsym;
    uint32_t nundefsym;
    uint32_t tocoff;
    uint32_t ntoc;
    uint32_t modtaboff;
    uint32_t nmodtab;
    uint32_t extrefsymoff;
    uint32_t nextrefsyms;
    uint32_t indirectsymoff;
    uint32_t nindirectsyms;
    uint32_t extreloff;
    uint32_t nextrel;
    uint32_t locreloff;
    uint32_t nlocrel;
}

const LC_SEGMENT    = 1;
const LC_SYMTAB     = 2;
const LC_DYSYMTAB   = 11;
const LC_SEGMENT_64 = 0x19;

struct load_command
{
    uint32_t cmd;
    uint32_t cmdsize;
}

const N_EXT  = 1;
const N_STAB = 0xE0;
const N_PEXT = 0x10;
const N_TYPE = 0x0E;
const N_UNDF = 0;
const N_ABS  = 2;
const N_INDR = 10;
const N_PBUD = 12;
const N_SECT = 14;

struct nlist
{
    int32_t n_strx;
    uint8_t n_type;
    uint8_t n_sect;
    int16_t n_desc;
    uint32_t n_value;
}

struct nlist_64
{
    uint32_t n_strx;
    uint8_t n_type;
    uint8_t n_sect;
    uint16_t n_desc;
    uint64_t n_value;
}
