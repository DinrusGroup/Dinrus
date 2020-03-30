/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/libmach.d, _libmach.d)
 * Documentation:  https://dlang.org/phobos/dmd_libmach.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/libmach.d
 */

module drc.lib.Mach;

version(OSX):

import core.stdc.time;
import core.stdc.ткст;
import core.stdc.stdlib;
import core.stdc.stdio;
import core.stdc.config;

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

import drc.lib.Scanmach;

// Entry point (only public symbol in this module).
public  Library LibMach_factory()
{
    return new LibMach();
}

private: // for the remainder of this module

const LOG = нет;

struct MachObjSymbol
{
    ткст имя;         // still has a terminating 0
    MachObjModule* om;
}

alias  МассивДРК!(MachObjModule*) MachObjModules;
alias  МассивДРК!(MachObjSymbol*) MachObjSymbols;

final class LibMach : Library
{
    MachObjModules objmodules; // MachObjModule[]
    MachObjSymbols objsymbols; // MachObjSymbol[]
    ТаблицаСтрок!(MachObjSymbol*) tab;

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
    override проц addObject(ткст0 module_name,  ббайт[] буфер)
    {
        if (!module_name)
            module_name = "";
        static if (LOG)
        {
            printf("LibMach::addObject(%s)\n", module_name);
        }

        проц corrupt(цел reason)
        {
            выведиОшибку("corrupt Mach объект module %s %d", module_name, reason);
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
            бцел mstart = cast(бцел)objmodules.dim;
            while (смещение < buflen)
            {
                if (смещение + MachLibHeader.sizeof >= buflen)
                    return corrupt(__LINE__);
                MachLibHeader* header = cast(MachLibHeader*)(cast(ббайт*)буф + смещение);
                смещение += MachLibHeader.sizeof;
                ткст0 endptr = null;
                бцел size = cast(бцел)strtoul(header.file_size.ptr, &endptr, 10);
                if (endptr >= header.file_size.ptr + 10 || *endptr != ' ')
                    return corrupt(__LINE__);
                if (смещение + size > buflen)
                    return corrupt(__LINE__);
                if (memcmp(header.object_name.ptr, cast(сим*)"__.SYMDEF       ", 16) == 0 ||
                    memcmp(header.object_name.ptr, cast(сим*)"__.SYMDEF SORTED", 16) == 0)
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
                else
                {
                    auto om = new MachObjModule();
                    om.base = cast(ббайт*)буф + смещение - MachLibHeader.sizeof;
                    om.length = cast(бцел)(size + MachLibHeader.sizeof);
                    om.смещение = 0;
                    const n = cast(сим*)(om.base + MachLibHeader.sizeof);
                    om.имя = n.вТкстД();
                    om.file_time = cast(бцел)strtoul(header.file_time.ptr, &endptr, 10);
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
            бцел nsymbols = Port.readlongLE(symtab) / 8;
            ткст0 s = symtab + 4 + nsymbols * 8 + 4;
            if (4 + nsymbols * 8 + 4 > symtab_size)
                return corrupt(__LINE__);
            for (бцел i = 0; i < nsymbols; i++)
            {
                бцел soff = Port.readlongLE(symtab + 4 + i * 8);
                ткст0 имя = s + soff;
                т_мера namelen = strlen(имя);
                //printf("soff = x%x имя = %s\n", soff, имя);
                if (s + namelen + 1 - symtab > symtab_size)
                    return corrupt(__LINE__);
                бцел moff = Port.readlongLE(symtab + 4 + i * 8 + 4);
                //printf("symtab[%d] moff = x%x  x%x, имя = %s\n", i, moff, moff + sizeof(Header), имя);
                for (бцел m = mstart; 1; m++)
                {
                    if (m == objmodules.dim)
                        return corrupt(__LINE__);       // didn't найди it
                    MachObjModule* om = objmodules[m];
                    //printf("\tom смещение = x%x\n", (сим *)om.base - (сим *)буф);
                    if (moff == cast(сим*)om.base - cast(сим*)буф)
                    {
                        addSymbol(om, имя[0 .. namelen], 1);
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
        auto om = new MachObjModule();
        om.base = cast(ббайт*)буф;
        om.length = cast(бцел)buflen;
        om.смещение = 0;
        const n = cast(сим*)ИмяФайла.имя(module_name); // удали path, but not extension
        om.имя = n.вТкстД();
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
            om.file_mode = (1 << 15) | (6 << 6) | (4 << 3) | (4 << 0); // 0100644
        }
        objmodules.сунь(om);
    }

    /*****************************************************************************/

    проц addSymbol(MachObjModule* om, ткст имя, цел pickAny = 0)
    {
        static if (LOG)
        {
            printf("LibMach::addSymbol(%s, %s, %d)\n", om.имя.ptr, имя.ptr, pickAny);
        }
        version (none)
        {
            // let linker sort out duplicates
            StringValue* s = tab.вставь(имя.ptr, имя.length, null);
            if (!s)
            {
                // already in table
                if (!pickAny)
                {
                    s = tab.lookup(имя.ptr, имя.length);
                    assert(s);
                    MachObjSymbol* ос = cast(MachObjSymbol*)s.ptrvalue;
                    выведиОшибку("multiple definition of %s: %s and %s: %s", om.имя.ptr, имя.ptr, ос.om.имя.ptr, ос.имя.ptr);
                }
            }
            else
            {
                auto ос = new MachObjSymbol();
                ос.имя = xarraydup(имя);
                ос.om = om;
                s.ptrvalue = cast(ук)ос;
                objsymbols.сунь(ос);
            }
        }
        else
        {
            auto ос = new MachObjSymbol();
            ос.имя = xarraydup(имя);
            ос.om = om;
            objsymbols.сунь(ос);
        }
    }

private:
    /************************************
     * Scan single объект module for dictionary symbols.
     * Send those symbols to LibMach::addSymbol().
     */
    проц scanObjModule(MachObjModule* om)
    {
        static if (LOG)
        {
            printf("LibMach::scanObjModule(%s)\n", om.имя.ptr);
        }

        extern (D) проц addSymbol(ткст имя, цел pickAny)
        {
            this.addSymbol(om, имя, pickAny);
        }

        scanMachObjModule(&addSymbol, om.base[0 .. om.length], om.имя.ptr, место);
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
            printf("LibMach::WriteLibToBuffer()\n");
        }
         ткст0 pad = [0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A];
        /************* Scan Object Modules for Symbols ******************/
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MachObjModule* om = objmodules[i];
            if (om.scan)
            {
                scanObjModule(om);
            }
        }
        /************* Determine module offsets ******************/
        бцел moffset = 8 + MachLibHeader.sizeof + 4 + 4;
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MachObjSymbol* ос = objsymbols[i];
            moffset += 8 + ос.имя.length + 1;
        }
        moffset = (moffset + 3) & ~3;
        //if (moffset & 4)
        //    moffset += 4;
        бцел hoffset = moffset;
        static if (LOG)
        {
            printf("\tmoffset = x%x\n", moffset);
        }
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MachObjModule* om = objmodules[i];
            moffset += moffset & 1;
            om.смещение = moffset;
            if (om.scan)
            {
                const slen = om.имя.length;
                цел nzeros = 8 - ((slen + 4) & 7);
                if (nzeros < 4)
                    nzeros += 8; // emulate mysterious behavior of ar
                цел filesize = om.length;
                filesize = (filesize + 7) & ~7;
                moffset += MachLibHeader.sizeof + slen + nzeros + filesize;
            }
            else
            {
                moffset += om.length;
            }
        }
        libbuf.резервируй(moffset);
        /************* Write the library ******************/
        libbuf.пиши("!<arch>\n");
        MachObjModule om;
        om.base = null;
        om.length = cast(бцел)(hoffset - (8 + MachLibHeader.sizeof));
        om.смещение = 8;
        om.имя = "";
        .time(&om.file_time);
        om.user_id = getuid();
        om.group_id = getgid();
        om.file_mode = (1 << 15) | (6 << 6) | (4 << 3) | (4 << 0); // 0100644
        MachLibHeader h;
        MachOmToHeader(&h, &om);
        memcpy(h.object_name.ptr, cast(сим*)"__.SYMDEF", 9);
        цел len = sprintf(h.file_size.ptr, "%u", om.length);
        assert(len <= 10);
        memset(h.file_size.ptr + len, ' ', 10 - len);
        libbuf.пиши((&h)[0 .. 1]);
        сим[4] буф;
        Port.writelongLE(cast(бцел)(objsymbols.dim * 8), буф.ptr);
        libbuf.пиши(буф[0 .. 4]);
        цел stringoff = 0;
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MachObjSymbol* ос = objsymbols[i];
            Port.writelongLE(stringoff, буф.ptr);
            libbuf.пиши(буф[0 .. 4]);
            Port.writelongLE(ос.om.смещение, буф.ptr);
            libbuf.пиши(буф[0 .. 4]);
            stringoff += ос.имя.length + 1;
        }
        Port.writelongLE(stringoff, буф.ptr);
        libbuf.пиши(буф[0 .. 4]);
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MachObjSymbol* ос = objsymbols[i];
            libbuf.пишиСтр(ос.имя);
            libbuf.пишиБайт(0);
        }
        while (libbuf.length & 3)
            libbuf.пишиБайт(0);
        //if (libbuf.length & 4)
        //    libbuf.пиши(pad[0 .. 4]);
        static if (LOG)
        {
            printf("\tlibbuf.moffset = x%x\n", libbuf.length);
        }
        assert(libbuf.length == hoffset);
        /* Write out each of the объект modules
         */
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MachObjModule* om2 = objmodules[i];
            if (libbuf.length & 1)
                libbuf.пишиБайт('\n'); // module alignment
            assert(libbuf.length == om2.смещение);
            if (om2.scan)
            {
                MachOmToHeader(&h, om2);
                libbuf.пиши((&h)[0 .. 1]); // module header
                libbuf.пиши(om2.имя.ptr[0 .. om2.имя.length]);
                цел nzeros = 8 - ((om2.имя.length + 4) & 7);
                if (nzeros < 4)
                    nzeros += 8; // emulate mysterious behavior of ar
                libbuf.занули(nzeros);
                libbuf.пиши(om2.base[0 .. om2.length]); // module contents
                // obj modules are padded out to 8 bytes in length with 0x0A
                цел filealign = om2.length & 7;
                if (filealign)
                {
                    libbuf.пиши(pad[0 .. 8 - filealign]);
                }
            }
            else
            {
                libbuf.пиши(om2.base[0 .. om2.length]); // module contents
            }
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
struct MachObjModule
{
    ббайт* base; // where are we holding it in memory
    бцел length; // in bytes
    бцел смещение; // смещение from start of library
    ткст имя; // module имя (файл имя) with terminating 0
    c_long file_time; // файл time
    бцел user_id;
    бцел group_id;
    бцел file_mode;
    цел scan; // 1 means scan for symbols
}

const MACH_OBJECT_NAME_SIZE = 16;

struct MachLibHeader
{
    сим[MACH_OBJECT_NAME_SIZE] object_name;
    сим[12] file_time;
    сим[6] user_id;
    сим[6] group_id;
    сим[8] file_mode; // in octal
    сим[10] file_size;
    сим[2] trailer;
}

 проц MachOmToHeader(MachLibHeader* h, MachObjModule* om)
{
    const slen = om.имя.length;
    цел nzeros = 8 - ((slen + 4) & 7);
    if (nzeros < 4)
        nzeros += 8; // emulate mysterious behavior of ar
    т_мера len = sprintf(h.object_name.ptr, "#1/%ld", slen + nzeros);
    memset(h.object_name.ptr + len, ' ', MACH_OBJECT_NAME_SIZE - len);
    /* In the following sprintf's, don't worry if the trailing 0
     * that sprintf writes goes off the end of the field. It will
     * пиши into the следщ field, which we will promptly overwrite
     * anyway. (So make sure to пиши the fields in ascending order.)
     */
    len = sprintf(h.file_time.ptr, "%llu", cast(long)om.file_time);
    assert(len <= 12);
    memset(h.file_time.ptr + len, ' ', 12 - len);
    if (om.user_id > 999999) // yes, it happens
        om.user_id = 0; // don't really know what to do here
    len = sprintf(h.user_id.ptr, "%u", om.user_id);
    assert(len <= 6);
    memset(h.user_id.ptr + len, ' ', 6 - len);
    if (om.group_id > 999999) // yes, it happens
        om.group_id = 0; // don't really know what to do here
    len = sprintf(h.group_id.ptr, "%u", om.group_id);
    assert(len <= 6);
    memset(h.group_id.ptr + len, ' ', 6 - len);
    len = sprintf(h.file_mode.ptr, "%o", om.file_mode);
    assert(len <= 8);
    memset(h.file_mode.ptr + len, ' ', 8 - len);
    цел filesize = om.length;
    filesize = (filesize + 7) & ~7;
    len = sprintf(h.file_size.ptr, "%lu", slen + nzeros + filesize);
    assert(len <= 10);
    memset(h.file_size.ptr + len, ' ', 10 - len);
    h.trailer[0] = '`';
    h.trailer[1] = '\n';
}
