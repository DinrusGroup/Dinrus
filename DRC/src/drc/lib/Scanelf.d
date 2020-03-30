/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/scanelf.d, _scanelf.d)
 * Documentation:  https://dlang.org/phobos/dmd_scanelf.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/scanelf.d
 */

module drc.lib.Scanelf;

version(Windows) {}
else version(OSX) {}
else:

version (linux)
    import core.sys.linux.elf;
else version (FreeBSD)
    import core.sys.freebsd.sys.elf;
else version (DragonFlyBSD)
    import core.sys.dragonflybsd.sys.elf;
else version (Solaris)
    import core.sys.solaris.elf;

import cidrus;
//import core.checkedint;

import dmd.globals;
import dmd.errors;

const LOG = нет;

/*****************************************
 * Reads an объект module from base[] and passes the имена
 * of any exported symbols to (*pAddSymbol)().
 * Параметры:
 *      pAddSymbol =  function to pass the имена to
 *      base =        массив of contents of объект module
 *      module_name = имя of the объект module (используется for error messages)
 *      место =         location to use for error printing
 */
проц scanElfObjModule(проц delegate(ткст имя, цел pickAny) pAddSymbol,
        ббайт[] base, ткст0 module_name, Место место)
{
    static if (LOG)
    {
        printf("scanElfObjModule(%s)\n", module_name);
    }

    проц corrupt(цел reason)
    {
        выведиОшибку(место, "corrupt ELF объект module `%s` %d", module_name, reason);
    }

    if (base.length < Elf32_Ehdr.sizeof)
        return corrupt(__LINE__); // must be at least large enough for ELF32
    static const ббайт[4] elf = [0x7F, 'E', 'L', 'F']; // ELF файл signature
    if (base[0 .. elf.length] != elf[])
        return corrupt(__LINE__);

    if (base[EI_VERSION] != EV_CURRENT)
    {
        return выведиОшибку(место, "ELF объект module `%s` has EI_VERSION = %d, should be %d",
            module_name, base[EI_VERSION], EV_CURRENT);
    }
    if (base[EI_DATA] != ELFDATA2LSB)
    {
        return выведиОшибку(место, "ELF объект module `%s` is byte swapped and unsupported", module_name);
    }
    if (base[EI_CLASS] != ELFCLASS32 && base[EI_CLASS] != ELFCLASS64)
    {
        return выведиОшибку(место, "ELF объект module `%s` is unrecognized class %d", module_name, base[EI_CLASS]);
    }

    проц scanELF(бцел model)()
    {
        static if (model == 32)
        {
            alias Elf32_Ehdr ElfXX_Ehdr;
            alias Elf32_Shdr ElfXX_Shdr;
            alias Elf32_Sym ElfXX_Sym;
        }
        else
        {
            static assert(model == 64);
            alias Elf64_Ehdr ElfXX_Ehdr;
            alias Elf64_Shdr ElfXX_Shdr;
            alias Elf64_Sym ElfXX_Sym;
        }

        if (base.length < ElfXX_Ehdr.sizeof)
            return corrupt(__LINE__);

        const eh = cast(ElfXX_Ehdr*) base.ptr;
        if (eh.e_type != ET_REL)
            return выведиОшибку(место, "ELF объект module `%s` is not relocatable", module_name);
        if (eh.e_version != EV_CURRENT)
            return corrupt(__LINE__);

        бул overflow;
        const end = addu(eh.e_shoff, mulu(eh.e_shentsize, eh.e_shnum, overflow), overflow);
        if (overflow || end > base.length)
            return corrupt(__LINE__);

        /* For each Section
         */
        const sections = (cast(ElfXX_Shdr*)(base.ptr + eh.e_shoff))[0 .. eh.e_shnum];
        foreach (ref section; sections)
        {
            if (section.sh_type != SHT_SYMTAB)
                continue;

            бул checkShdrXX(ref ElfXX_Shdr shdr)
            {
                бул overflow;
                return addu(shdr.sh_offset, shdr.sh_size, overflow) > base.length || overflow;
            }

            if (checkShdrXX(section))
                return corrupt(__LINE__);

            /* sh_link gives the particular ткст table section
             * используется for the symbol имена.
             */
            if (section.sh_link >= eh.e_shnum)
                return corrupt(__LINE__);

            const string_section = &sections[section.sh_link];
            if (string_section.sh_type != SHT_STRTAB)
                return corrupt(__LINE__);

            if (checkShdrXX(*string_section))
                return corrupt(__LINE__);

            const string_tab = (cast(ткст)base)
                [cast(т_мера)string_section.sh_offset ..
                 cast(т_мера)(string_section.sh_offset + string_section.sh_size)];

            /* Get the массив of symbols this section refers to
             */
            const symbols = (cast(ElfXX_Sym*)(base.ptr + cast(т_мера)section.sh_offset))
                [0 .. cast(т_мера)(section.sh_size / ElfXX_Sym.sizeof)];

            foreach (ref sym; symbols)
            {
                const stb = sym.st_info >> 4;
                if (stb != STB_GLOBAL && stb != STB_WEAK || sym.st_shndx == SHN_UNDEF)
                    continue; // it's extern

                if (sym.st_name >= string_tab.length)
                    return corrupt(__LINE__);

                const имя = &string_tab[sym.st_name];
                //printf("sym st_name = x%x\n", sym.st_name);
                const pend = cast(сим*) memchr(имя, 0, string_tab.length - sym.st_name);
                if (!pend)       // if didn't найди terminating 0 inside the ткст section
                    return corrupt(__LINE__);
                pAddSymbol(имя[0 .. pend - имя], 1);
            }
        }
    }

    if (base[EI_CLASS] == ELFCLASS32)
    {
        scanELF!(32);
    }
    else
    {
        assert(base[EI_CLASS] == ELFCLASS64);
        scanELF!(64);
    }
}
