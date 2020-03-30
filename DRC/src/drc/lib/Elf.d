/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/libelf.d, _libelf.d)
 * Documentation:  https://dlang.org/phobos/dmd_libelf.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/libelf.d
 */

module drc.lib.Elf;

version(Windows) {}
else version(OSX) {}
else:

import core.stdc.time;
import core.stdc.string;
import core.stdc.stdlib;
import core.stdc.stdio;
import core.sys.posix.sys.stat;
import core.sys.posix.unistd;

import dmd.globals;
import drc.Library;
import util.utils;

import util.array;
import util.file;
import util.filename;
import util.outbuffer;
import util.port;
import util.rmem;
import util.string;
import util.stringtable;

import drc.lib.Scanelf;

// Entry point (only public symbol in this module).
public  Library LibElf_factory()
{
    return new LibElf();
}

private: // for the remainder of this module

const LOG = нет;

struct ElfObjSymbol
{
    ткст имя;
    ElfObjModule* om;
}

alias  МассивДРК!(ElfObjModule*) ElfObjModules;
alias  МассивДРК!(ElfObjSymbol*) ElfObjSymbols;

final class LibElf : Library
{
    ElfObjModules objmodules; // ElfObjModule[]
    ElfObjSymbols objsymbols; // ElfObjSymbol[]
    ТаблицаСтрок!(ElfObjSymbol*) tab;

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
        if (!module_name)
            module_name = "";
        static if (LOG)
        {
            printf("LibElf::addObject(%s)\n", module_name);
        }

        проц corrupt(цел reason)
        {
            выведиОшибку("corrupt ELF объект module %s %d", module_name, reason);
        }

        цел fromfile = 0;
        auto буф = буфер.ptr;
        auto buflen = буфер.length;
        if (!буф)
        {
            assert(module_name[0]);
            // читай файл and take буфер ownership
            auto данные = readFile(Место.initial, module_name).извлекиСрез();
            буф = данные.ptr;
            buflen = данные.length;
            fromfile = 1;
        }
        if (buflen < 16)
        {
            static if (LOG)
            {
                printf("буф = %p, buflen = %d\n", буф, buflen);
            }
            return corrupt(__LINE__);
        }
        if (memcmp(буф, cast(сим*)"!<arch>\n", 8) == 0)
        {
            /* Library файл.
             * Pull each объект module out of the library and add it
             * to the объект module массив.
             */
            static if (LOG)
            {
                printf("archive, буф = %p, buflen = %d\n", буф, buflen);
            }
            бцел смещение = 8;
            ткст0 symtab = null;
            бцел symtab_size = 0;
            ткст0 filenametab = null;
            бцел filenametab_size = 0;
            бцел mstart = cast(бцел)objmodules.dim;
            while (смещение < buflen)
            {
                if (смещение + ElfLibHeader.sizeof >= buflen)
                    return corrupt(__LINE__);
                ElfLibHeader* header = cast(ElfLibHeader*)(cast(ббайт*)буф + смещение);
                смещение += ElfLibHeader.sizeof;
                ткст0 endptr = null;
                бцел size = cast(бцел)strtoul(header.file_size.ptr, &endptr, 10);
                if (endptr >= header.file_size.ptr + 10 || *endptr != ' ')
                    return corrupt(__LINE__);
                if (смещение + size > buflen)
                    return corrupt(__LINE__);
                if (header.object_name[0] == '/' && header.object_name[1] == ' ')
                {
                    /* Instead of rescanning the объект modules we pull from a
                     * library, just use the already created symbol table.
                     */
                    if (symtab)
                        return corrupt(__LINE__);
                    symtab = cast(сим*)буф + смещение;
                    symtab_size = size;
                    if (size < 4)
                        return corrupt(__LINE__);
                }
                else if (header.object_name[0] == '/' && header.object_name[1] == '/')
                {
                    /* This is the файл имя table, save it for later.
                     */
                    if (filenametab)
                        return corrupt(__LINE__);
                    filenametab = cast(сим*)буф + смещение;
                    filenametab_size = size;
                }
                else
                {
                    auto om = new ElfObjModule();
                    om.base = cast(ббайт*)буф + смещение; /*- sizeof(ElfLibHeader)*/
                    om.length = size;
                    om.смещение = 0;
                    if (header.object_name[0] == '/')
                    {
                        /* Pick long имя out of файл имя table
                         */
                        бцел foff = cast(бцел)strtoul(header.object_name.ptr + 1, &endptr, 10);
                        бцел i;
                        for (i = 0; 1; i++)
                        {
                            if (foff + i >= filenametab_size)
                                return corrupt(__LINE__);
                            сим c = filenametab[foff + i];
                            if (c == '/')
                                break;
                        }
                        auto n = cast(сим*)Пам.check(malloc(i + 1));
                        memcpy(n, filenametab + foff, i);
                        n[i] = 0;
                        om.имя = n[0 .. i];
                    }
                    else
                    {
                        /* Pick short имя out of header
                         */
                        auto n = cast(сим*)Пам.check(malloc(ELF_OBJECT_NAME_SIZE));
                        for (цел i = 0; 1; i++)
                        {
                            if (i == ELF_OBJECT_NAME_SIZE)
                                return corrupt(__LINE__);
                            сим c = header.object_name[i];
                            if (c == '/')
                            {
                                n[i] = 0;
                                om.имя = n[0 .. i];
                                break;
                            }
                            n[i] = c;
                        }
                    }
                    om.name_offset = -1;
                    om.file_time = strtoul(header.file_time.ptr, &endptr, 10);
                    om.user_id = cast(бцел)strtoul(header.user_id.ptr, &endptr, 10);
                    om.group_id = cast(бцел)strtoul(header.group_id.ptr, &endptr, 10);
                    om.file_mode = cast(бцел)strtoul(header.file_mode.ptr, &endptr, 8);
                    om.scan = 0; // don't scan объект module for symbols
                    objmodules.сунь(om);
                }
                смещение += (size + 1) & ~1;
            }
            if (смещение != buflen)
                return corrupt(__LINE__);
            /* Scan the library's symbol table, and вставь it into our own.
             * We use this instead of rescanning the объект module, because
             * the library's creator may have a different idea of what symbols
             * go into the symbol table than we do.
             * This is also probably faster.
             */
            бцел nsymbols = Port.readlongBE(symtab);
            ткст0 s = symtab + 4 + nsymbols * 4;
            if (4 + nsymbols * (4 + 1) > symtab_size)
                return corrupt(__LINE__);
            for (бцел i = 0; i < nsymbols; i++)
            {
                ткст имя = s.вТкстД();
                s += имя.length + 1;
                if (s - symtab > symtab_size)
                    return corrupt(__LINE__);
                бцел moff = Port.readlongBE(symtab + 4 + i * 4);
                //printf("symtab[%d] moff = %x  %x, имя = %s\n", i, moff, moff + sizeof(Header), имя.ptr);
                for (бцел m = mstart; 1; m++)
                {
                    if (m == objmodules.dim)
                        return corrupt(__LINE__);  // didn't найди it
                    ElfObjModule* om = objmodules[m];
                    //printf("\t%x\n", (сим *)om.base - (сим *)буф);
                    if (moff + ElfLibHeader.sizeof == cast(сим*)om.base - cast(сим*)буф)
                    {
                        addSymbol(om, имя, 1);
                        //if (mstart == m)
                        //    mstart++;
                        break;
                    }
                }
            }
            return;
        }
        /* It's an объект module
         */
        auto om = new ElfObjModule();
        om.base = cast(ббайт*)буф;
        om.length = cast(бцел)buflen;
        om.смещение = 0;
        auto n = cast(сим*)ИмяФайла.имя(module_name); // удали path, but not extension
        om.имя = n.вТкстД();
        om.name_offset = -1;
        om.scan = 1;
        if (fromfile)
        {
            stat_t statbuf;
            цел i = stat(module_name, &statbuf);
            if (i == -1) // error, errno is set
                return corrupt(__LINE__);
            om.file_time = statbuf.st_ctime;
            om.user_id = statbuf.st_uid;
            om.group_id = statbuf.st_gid;
            om.file_mode = statbuf.st_mode;
        }
        else
        {
            /* Mock things up for the объект module файл that never was
             * actually written out.
             */
             uid_t uid;
             gid_t gid;
             цел _иниц;
            if (!_иниц)
            {
                _иниц = 1;
                uid = getuid();
                gid = getgid();
            }
            time(&om.file_time);
            om.user_id = uid;
            om.group_id = gid;
            om.file_mode = (1 << 15) | (6 << 6) | (4 << 3); // 0100640
        }
        objmodules.сунь(om);
    }

    /*****************************************************************************/

    проц addSymbol(ElfObjModule* om, ткст имя, цел pickAny = 0)
    {
        static if (LOG)
        {
            printf("LibElf::addSymbol(%s, %s, %d)\n", om.имя.ptr, имя.ptr, pickAny);
        }
        auto s = tab.вставь(имя.ptr, имя.length, null);
        if (!s)
        {
            // already in table
            if (!pickAny)
            {
                s = tab.lookup(имя.ptr, имя.length);
                assert(s);
                ElfObjSymbol* ос = s.значение;
                выведиОшибку("multiple definition of %s: %s and %s: %s", om.имя.ptr, имя.ptr, ос.om.имя.ptr, ос.имя.ptr);
            }
        }
        else
        {
            auto ос = new ElfObjSymbol();
            ос.имя = xarraydup(имя);
            ос.om = om;
            s.значение = ос;
            objsymbols.сунь(ос);
        }
    }

private:
    /************************************
     * Scan single объект module for dictionary symbols.
     * Send those symbols to LibElf::addSymbol().
     */
    проц scanObjModule(ElfObjModule* om)
    {
        static if (LOG)
        {
            printf("LibElf::scanObjModule(%s)\n", om.имя.ptr);
        }

        extern (D) проц addSymbol(ткст имя, цел pickAny)
        {
            this.addSymbol(om, имя, pickAny);
        }

        scanElfObjModule(&addSymbol, om.base[0 .. om.length], om.имя.ptr, место);
    }

    /*****************************************************************************/
    /*****************************************************************************/
    /**********************************************
     * Create and пиши library to libbuf.
     * The library consists of:
     *      !<arch>\n
     *      header
     *      dictionary
     *      объект modules...
     */
    protected override проц WriteLibToBuffer(БуфВыв* libbuf)
    {
        static if (LOG)
        {
            printf("LibElf::WriteLibToBuffer()\n");
        }
        /************* Scan Object Modules for Symbols ******************/
        foreach (om; objmodules)
        {
            if (om.scan)
            {
                scanObjModule(om);
            }
        }
        /************* Determine ткст section ******************/
        /* The ткст section is where we store long файл имена.
         */
        бцел noffset = 0;
        foreach (om; objmodules)
        {
            т_мера len = om.имя.length;
            if (len >= ELF_OBJECT_NAME_SIZE)
            {
                om.name_offset = noffset;
                noffset += len + 2;
            }
            else
                om.name_offset = -1;
        }
        static if (LOG)
        {
            printf("\tnoffset = x%x\n", noffset);
        }
        /************* Determine module offsets ******************/
        бцел moffset = 8 + ElfLibHeader.sizeof + 4;
        foreach (ос; objsymbols)
        {
            moffset += 4 + ос.имя.length + 1;
        }
        бцел hoffset = moffset;
        static if (LOG)
        {
            printf("\tmoffset = x%x\n", moffset);
        }
        moffset += moffset & 1;
        if (noffset)
            moffset += ElfLibHeader.sizeof + noffset;
        foreach (om; objmodules)
        {
            moffset += moffset & 1;
            om.смещение = moffset;
            moffset += ElfLibHeader.sizeof + om.length;
        }
        libbuf.резервируй(moffset);
        /************* Write the library ******************/
        libbuf.пиши("!<arch>\n");
        ElfObjModule om;
        om.name_offset = -1;
        om.base = null;
        om.length = cast(бцел)(hoffset - (8 + ElfLibHeader.sizeof));
        om.смещение = 8;
        om.имя = "";
        .time(&om.file_time);
        om.user_id = 0;
        om.group_id = 0;
        om.file_mode = 0;
        ElfLibHeader h;
        ElfOmToHeader(&h, &om);
        libbuf.пиши((&h)[0 .. 1]);
        сим[4] буф;
        Port.writelongBE(cast(бцел)objsymbols.dim, буф.ptr);
        libbuf.пиши(буф[0 .. 4]);
        foreach (ос; objsymbols)
        {
            Port.writelongBE(ос.om.смещение, буф.ptr);
            libbuf.пиши(буф[0 .. 4]);
        }
        foreach (ос; objsymbols)
        {
            libbuf.пишиСтр(ос.имя);
            libbuf.пишиБайт(0);
        }
        static if (LOG)
        {
            printf("\tlibbuf.moffset = x%x\n", libbuf.length);
        }
        /* Write out the ткст section
         */
        if (noffset)
        {
            if (libbuf.length & 1)
                libbuf.пишиБайт('\n');
            // header
            memset(&h, ' ', ElfLibHeader.sizeof);
            h.object_name[0] = '/';
            h.object_name[1] = '/';
            т_мера len = sprintf(h.file_size.ptr, "%u", noffset);
            assert(len < 10);
            h.file_size[len] = ' ';
            h.trailer[0] = '`';
            h.trailer[1] = '\n';
            libbuf.пиши((&h)[0 .. 1]);
            foreach (om2; objmodules)
            {
                if (om2.name_offset >= 0)
                {
                    libbuf.пишиСтр(om2.имя);
                    libbuf.пишиБайт('/');
                    libbuf.пишиБайт('\n');
                }
            }
        }
        /* Write out each of the объект modules
         */
        foreach (om2; objmodules)
        {
            if (libbuf.length & 1)
                libbuf.пишиБайт('\n'); // module alignment
            assert(libbuf.length == om2.смещение);
            ElfOmToHeader(&h, om2);
            libbuf.пиши((&h)[0 .. 1]); // module header
            libbuf.пиши(om2.base[0 .. om2.length]); // module contents
        }
        static if (LOG)
        {
            printf("moffset = x%x, libbuf.length = x%x\n", moffset, libbuf.length);
        }
        assert(libbuf.length == moffset);
    }
}

/*****************************************************************************/
/*****************************************************************************/
struct ElfObjModule
{
    ббайт* base; // where are we holding it in memory
    бцел length; // in bytes
    бцел смещение; // смещение from start of library
    ткст имя; // module имя (файл имя) with terminating 0
    цел name_offset; // if not -1, смещение into ткст table of имя
    time_t file_time; // файл time
    бцел user_id;
    бцел group_id;
    бцел file_mode;
    цел scan; // 1 means scan for symbols
}

const ELF_OBJECT_NAME_SIZE = 16;

struct ElfLibHeader
{
    сим[ELF_OBJECT_NAME_SIZE] object_name;
    сим[12] file_time;
    сим[6] user_id;
    сим[6] group_id;
    сим[8] file_mode; // in octal
    сим[10] file_size;
    сим[2] trailer;
}

 проц ElfOmToHeader(ElfLibHeader* h, ElfObjModule* om)
{
    ткст0 буфер = cast(сим*)h;
    // user_id and group_id are padded on 6 characters in Header struct.
    // Squashing to 0 if more than 999999.
    if (om.user_id > 999999)
        om.user_id = 0;
    if (om.group_id > 999999)
        om.group_id = 0;
    т_мера len;
    if (om.name_offset == -1)
    {
        // "имя/           1423563789  5000  5000  100640  3068      `\n"
        //  |^^^^^^^^^^^^^^^|^^^^^^^^^^^|^^^^^|^^^^^|^^^^^^^|^^^^^^^^^|^^
        //        имя       file_time   u_id gr_id  fmode    fsize   trailer
        len = snprintf(буфер, ElfLibHeader.sizeof, "%-16s%-12llu%-6u%-6u%-8o%-10u`", om.имя.ptr, cast(long)om.file_time, om.user_id, om.group_id, om.file_mode, om.length);
        // adding '/' after the имя field
        т_мера name_length = om.имя.length;
        assert(name_length < ELF_OBJECT_NAME_SIZE);
        буфер[name_length] = '/';
    }
    else
    {
        // "/162007         1423563789  5000  5000  100640  3068      `\n"
        //  |^^^^^^^^^^^^^^^|^^^^^^^^^^^|^^^^^|^^^^^|^^^^^^^|^^^^^^^^^|^^
        //     name_offset   file_time   u_id gr_id  fmode    fsize   trailer
        len = snprintf(буфер, ElfLibHeader.sizeof, "/%-15d%-12llu%-6u%-6u%-8o%-10u`", om.name_offset, cast(long)om.file_time, om.user_id, om.group_id, om.file_mode, om.length);
    }
    assert(ElfLibHeader.sizeof > 0 && len == ElfLibHeader.sizeof - 1);
    // replace trailing \0 with \n
    буфер[len] = '\n';
}
