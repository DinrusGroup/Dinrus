/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/libmscoff.d, _libmscoff.d)
 * Documentation:  https://dlang.org/phobos/dmd_libmscoff.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/libmscoff.d
 */

module drc.lib.Mscoff;

version(Windows):

import cidrus;

//import win32.stat;

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

import drc.lib.Scanmscoff;

// Entry point (only public symbol in this module).
public  Library LibMSCoff_factory()
{
    return new LibMSCoff();
}

private: // for the remainder of this module

const LOG = нет;

alias struct_stat stat_t;

struct MSCoffObjSymbol
{
    ткст имя;         // still has a terminating 0
    MSCoffObjModule* om;
}

/*********
 * Do lexical comparison of MSCoffObjSymbol's for qsort()
 */
extern (C) цел MSCoffObjSymbol_cmp(ук p, ук q)
{
    MSCoffObjSymbol* s1 = *cast(MSCoffObjSymbol**)p;
    MSCoffObjSymbol* s2 = *cast(MSCoffObjSymbol**)q;
    return strcmp(s1.имя.ptr, s2.имя.ptr);
}

alias МассивДРК!(MSCoffObjModule*) MSCoffObjModules;
alias МассивДРК!(MSCoffObjSymbol*) MSCoffObjSymbols;

final class LibMSCoff : Library
{
    MSCoffObjModules objmodules; // MSCoffObjModule[]
    MSCoffObjSymbols objsymbols; // MSCoffObjSymbol[]

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
            printf("LibMSCoff::addObject(%s)\n", module_name);
        }

        проц corrupt(цел reason)
        {
            выведиОшибку("corrupt MS Coff объект module %s %d", module_name, reason);
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
        if (memcmp(буф, "!<arch>\n".ptr, 8) == 0)
        {
            /* It's a library файл.
             * Pull each объект module out of the library and add it
             * to the объект module массив.
             */
            static if (LOG)
            {
                printf("archive, буф = %p, buflen = %d\n", буф, buflen);
            }
            MSCoffLibHeader* flm = null; // first linker member
            MSCoffLibHeader* slm = null; // second linker member
            бцел number_of_members = 0;
            бцел* member_file_offsets = null;
            бцел number_of_symbols = 0;
            ushort* indices = null;
            ткст0 string_table = null;
            т_мера string_table_length = 0;
            MSCoffLibHeader* lnm = null; // longname member
            ткст0 longnames = null;
            т_мера longnames_length = 0;
            т_мера смещение = 8;
            ткст0 symtab = null;
            бцел symtab_size = 0;
            т_мера mstart = objmodules.dim;
            while (1)
            {
                смещение = (смещение + 1) & ~1; // round to even boundary
                if (смещение >= buflen)
                    break;
                if (смещение + MSCoffLibHeader.sizeof >= buflen)
                    return corrupt(__LINE__);
                MSCoffLibHeader* header = cast(MSCoffLibHeader*)(cast(ббайт*)буф + смещение);
                смещение += MSCoffLibHeader.sizeof;
                ткст0 endptr = null;
                бцел size = strtoul(cast(сим*)header.file_size, &endptr, 10);
                if (endptr >= header.file_size.ptr + 10 || *endptr != ' ')
                    return corrupt(__LINE__);
                if (смещение + size > buflen)
                    return corrupt(__LINE__);
                //printf("header.object_name = '%.*s'\n", cast(цел)MSCOFF_OBJECT_NAME_SIZE, header.object_name);
                if (memcmp(cast(сим*)header.object_name, cast(сим*)"/               ", MSCOFF_OBJECT_NAME_SIZE) == 0)
                {
                    if (!flm)
                    {
                        // First Linker Member, which is ignored
                        flm = header;
                    }
                    else if (!slm)
                    {
                        // Second Linker Member, which we require even though the format doesn't require it
                        slm = header;
                        if (size < 4 + 4)
                            return corrupt(__LINE__);
                        number_of_members = Port.readlongLE(cast(сим*)буф + смещение);
                        member_file_offsets = cast(бцел*)(cast(сим*)буф + смещение + 4);
                        if (size < 4 + number_of_members * 4 + 4)
                            return corrupt(__LINE__);
                        number_of_symbols = Port.readlongLE(cast(сим*)буф + смещение + 4 + number_of_members * 4);
                        indices = cast(ushort*)(cast(сим*)буф + смещение + 4 + number_of_members * 4 + 4);
                        string_table = cast(сим*)(cast(сим*)буф + смещение + 4 + number_of_members * 4 + 4 + number_of_symbols * 2);
                        if (size <= (4 + number_of_members * 4 + 4 + number_of_symbols * 2))
                            return corrupt(__LINE__);
                        string_table_length = size - (4 + number_of_members * 4 + 4 + number_of_symbols * 2);
                        /* The number of strings in the string_table must be number_of_symbols; check it
                         * The strings must also be in ascending lexical order; not checked.
                         */
                        т_мера i = 0;
                        for (бцел n = 0; n < number_of_symbols; n++)
                        {
                            while (1)
                            {
                                if (i >= string_table_length)
                                    return corrupt(__LINE__);
                                if (!string_table[i++])
                                    break;
                            }
                        }
                        if (i != string_table_length)
                            return corrupt(__LINE__);
                    }
                }
                else if (memcmp(cast(сим*)header.object_name, cast(сим*)"//              ", MSCOFF_OBJECT_NAME_SIZE) == 0)
                {
                    if (!lnm)
                    {
                        lnm = header;
                        longnames = cast(сим*)буф + смещение;
                        longnames_length = size;
                    }
                }
                else
                {
                    if (!slm)
                        return corrupt(__LINE__);
                    version (none)
                    {
                        // Microsoft Spec says longnames member must appear, but Microsoft Lib says otherwise
                        if (!lnm)
                            return corrupt(__LINE__);
                    }
                    auto om = new MSCoffObjModule();
                    // Include MSCoffLibHeader in base[0..length], so we don't have to repro it
                    om.base = cast(ббайт*)буф + смещение - MSCoffLibHeader.sizeof;
                    om.length = cast(бцел)(size + MSCoffLibHeader.sizeof);
                    om.смещение = 0;
                    if (header.object_name[0] == '/')
                    {
                        /* Pick long имя out of longnames[]
                         */
                        бцел foff = strtoul(cast(сим*)header.object_name + 1, &endptr, 10);
                        бцел i;
                        for (i = 0; 1; i++)
                        {
                            if (foff + i >= longnames_length)
                                return corrupt(__LINE__);
                            сим c = longnames[foff + i];
                            if (c == 0)
                                break;
                        }
                        ткст0 oname = cast(сим*)Пам.check(malloc(i + 1));
                        memcpy(oname, longnames + foff, i);
                        oname[i] = 0;
                        om.имя = oname[0 .. i];
                        //printf("\tname = '%s'\n", om.имя);
                    }
                    else
                    {
                        /* Pick short имя out of header
                         */
                        ткст0 oname = cast(сим*)Пам.check(malloc(MSCOFF_OBJECT_NAME_SIZE));
                        цел i;
                        for (i = 0; 1; i++)
                        {
                            if (i == MSCOFF_OBJECT_NAME_SIZE)
                                return corrupt(__LINE__);
                            сим c = header.object_name[i];
                            if (c == '/')
                            {
                                oname[i] = 0;
                                break;
                            }
                            oname[i] = c;
                        }
                        om.имя = oname[0 .. i];
                    }
                    om.file_time = strtoul(cast(сим*)header.file_time, &endptr, 10);
                    om.user_id = strtoul(cast(сим*)header.user_id, &endptr, 10);
                    om.group_id = strtoul(cast(сим*)header.group_id, &endptr, 10);
                    om.file_mode = strtoul(cast(сим*)header.file_mode, &endptr, 8);
                    om.scan = 0; // don't scan объект module for symbols
                    objmodules.сунь(om);
                }
                смещение += size;
            }
            if (смещение != buflen)
                return corrupt(__LINE__);
            /* Scan the library's symbol table, and вставь it into our own.
             * We use this instead of rescanning the объект module, because
             * the library's creator may have a different idea of what symbols
             * go into the symbol table than we do.
             * This is also probably faster.
             */
            if (!slm)
                return corrupt(__LINE__);
            ткст0 s = string_table;
            for (бцел i = 0; i < number_of_symbols; i++)
            {
                ткст имя = s.вТкстД();
                s += имя.length + 1;
                бцел memi = indices[i] - 1;
                if (memi >= number_of_members)
                    return corrupt(__LINE__);
                бцел moff = member_file_offsets[memi];
                for (т_мера m = mstart; 1; m++)
                {
                    if (m == objmodules.dim)
                        return corrupt(__LINE__);       // didn't найди it
                    MSCoffObjModule* om = objmodules[m];
                    //printf("\tom смещение = x%x\n", (сим *)om.base - (сим *)буф);
                    if (moff == cast(сим*)om.base - cast(сим*)буф)
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
        auto om = new MSCoffObjModule();
        om.base = cast(ббайт*)буф;
        om.length = cast(бцел)buflen;
        om.смещение = 0;
        ткст0 n = глоб2.парамы.preservePaths ? module_name : ИмяФайла.имя(module_name); // удали path, but not extension
        om.имя = n.вТкстД();
        om.scan = 1;
        if (fromfile)
        {
            stat_t statbuf;
            цел i = stat(cast(сим*)module_name, &statbuf);
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
            time_t file_time = 0;
            time(&file_time);
            om.file_time = cast(long)file_time;
            om.user_id = 0; // meaningless on Windows
            om.group_id = 0; // meaningless on Windows
            om.file_mode = (1 << 15) | (6 << 6) | (4 << 3) | (4 << 0); // 0100644
        }
        objmodules.сунь(om);
    }

    /*****************************************************************************/

    проц addSymbol(MSCoffObjModule* om, ткст имя, цел pickAny = 0)
    {
        static if (LOG)
        {
            printf("LibMSCoff::addSymbol(%s, %s, %d)\n", om.имя.ptr, имя, pickAny);
        }
        auto ос = new MSCoffObjSymbol();
        ос.имя = xarraydup(имя);
        ос.om = om;
        objsymbols.сунь(ос);
    }

private:
    /************************************
     * Scan single объект module for dictionary symbols.
     * Send those symbols to LibMSCoff::addSymbol().
     */
    проц scanObjModule(MSCoffObjModule* om)
    {
        static if (LOG)
        {
            printf("LibMSCoff::scanObjModule(%s)\n", om.имя.ptr);
        }

        extern (D) проц addSymbol(ткст имя, цел pickAny)
        {
            this.addSymbol(om, имя, pickAny);
        }

        scanMSCoffObjModule(&addSymbol, om.base[0 .. om.length], om.имя.ptr, место);
    }

    /*****************************************************************************/
    /*****************************************************************************/
    /**********************************************
     * Create and пиши library to libbuf.
     * The library consists of:
     *      !<arch>\n
     *      header
     *      1st Linker Member
     *      Header
     *      2nd Linker Member
     *      Header
     *      Longnames Member
     *      объект modules...
     */
    protected override проц WriteLibToBuffer(БуфВыв* libbuf)
    {
        static if (LOG)
        {
            printf("LibElf::WriteLibToBuffer()\n");
        }
        assert(MSCoffLibHeader.sizeof == 60);
        /************* Scan Object Modules for Symbols ******************/
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MSCoffObjModule* om = objmodules[i];
            if (om.scan)
            {
                scanObjModule(om);
            }
        }
        /************* Determine longnames size ******************/
        /* The longnames section is where we store long файл имена.
         */
        бцел noffset = 0;
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MSCoffObjModule* om = objmodules[i];
            т_мера len = om.имя.length;
            if (len >= MSCOFF_OBJECT_NAME_SIZE)
            {
                om.name_offset = noffset;
                noffset += len + 1;
            }
            else
                om.name_offset = -1;
        }
        static if (LOG)
        {
            printf("\tnoffset = x%x\n", noffset);
        }
        /************* Determine ткст table length ******************/
        т_мера slength = 0;
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MSCoffObjSymbol* ос = objsymbols[i];
            slength += ос.имя.length + 1;
        }
        /************* Offset of first module ***********************/
        т_мера moffset = 8; // signature
        т_мера firstLinkerMemberOffset = moffset;
        moffset += MSCoffLibHeader.sizeof + 4 + objsymbols.dim * 4 + slength; // 1st Linker Member
        moffset += moffset & 1;
        т_мера secondLinkerMemberOffset = moffset;
        moffset += MSCoffLibHeader.sizeof + 4 + objmodules.dim * 4 + 4 + objsymbols.dim * 2 + slength;
        moffset += moffset & 1;
        т_мера LongnamesMemberOffset = moffset;
        moffset += MSCoffLibHeader.sizeof + noffset; // Longnames Member size
        static if (LOG)
        {
            printf("\tmoffset = x%x\n", moffset);
        }
        /************* Offset of each module *************************/
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MSCoffObjModule* om = objmodules[i];
            moffset += moffset & 1;
            om.смещение = cast(бцел)moffset;
            if (om.scan)
                moffset += MSCoffLibHeader.sizeof + om.length;
            else
                moffset += om.length;
        }
        libbuf.резервируй(moffset);
        /************* Write the library ******************/
        libbuf.пиши("!<arch>\n");
        MSCoffObjModule om;
        om.name_offset = -1;
        om.base = null;
        om.length = cast(бцел)(4 + objsymbols.dim * 4 + slength);
        om.смещение = 8;
        om.имя = "";
        time_t file_time = 0;
        .time(&file_time);
        om.file_time = cast(long)file_time;
        om.user_id = 0;
        om.group_id = 0;
        om.file_mode = 0;
        /*** Write out First Linker Member ***/
        assert(libbuf.length == firstLinkerMemberOffset);
        MSCoffLibHeader h;
        MSCoffOmToHeader(&h, &om);
        libbuf.пиши((&h)[0 .. 1]);
        сим[4] буф;
        Port.writelongBE(cast(бцел)objsymbols.dim, буф.ptr);
        libbuf.пиши(буф[0 .. 4]);
        // Sort objsymbols[] in module смещение order
        qsort(objsymbols[].ptr, objsymbols.dim, (objsymbols[0]).sizeof, cast(_compare_fp_t)&MSCoffObjSymbol_offset_cmp);
        бцел lastoffset;
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MSCoffObjSymbol* ос = objsymbols[i];
            //printf("objsymbols[%d] = '%s', смещение = %u\n", i, ос.имя, ос.om.смещение);
            if (i)
            {
                // Should be sorted in module order
                assert(lastoffset <= ос.om.смещение);
            }
            lastoffset = ос.om.смещение;
            Port.writelongBE(lastoffset, буф.ptr);
            libbuf.пиши(буф[0 .. 4]);
        }
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MSCoffObjSymbol* ос = objsymbols[i];
            libbuf.пишиСтр(ос.имя);
            libbuf.пишиБайт(0);
        }
        /*** Write out Second Linker Member ***/
        if (libbuf.length & 1)
            libbuf.пишиБайт('\n');
        assert(libbuf.length == secondLinkerMemberOffset);
        om.length = cast(бцел)(4 + objmodules.dim * 4 + 4 + objsymbols.dim * 2 + slength);
        MSCoffOmToHeader(&h, &om);
        libbuf.пиши((&h)[0 .. 1]);
        Port.writelongLE(cast(бцел)objmodules.dim, буф.ptr);
        libbuf.пиши(буф[0 .. 4]);
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MSCoffObjModule* om2 = objmodules[i];
            om2.index = cast(ushort)i;
            Port.writelongLE(om2.смещение, буф.ptr);
            libbuf.пиши(буф[0 .. 4]);
        }
        Port.writelongLE(cast(бцел)objsymbols.dim, буф.ptr);
        libbuf.пиши(буф[0 .. 4]);
        // Sort objsymbols[] in lexical order
        qsort(objsymbols[].ptr, objsymbols.dim, (objsymbols[0]).sizeof, cast(_compare_fp_t)&MSCoffObjSymbol_cmp);
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MSCoffObjSymbol* ос = objsymbols[i];
            Port.writelongLE(ос.om.index + 1, буф.ptr);
            libbuf.пиши(буф[0 .. 2]);
        }
        for (т_мера i = 0; i < objsymbols.dim; i++)
        {
            MSCoffObjSymbol* ос = objsymbols[i];
            libbuf.пишиСтр(ос.имя);
            libbuf.пишиБайт(0);
        }
        /*** Write out longnames Member ***/
        if (libbuf.length & 1)
            libbuf.пишиБайт('\n');
        //printf("libbuf %x longnames %x\n", (цел)libbuf.length, (цел)LongnamesMemberOffset);
        assert(libbuf.length == LongnamesMemberOffset);
        // header
        memset(&h, ' ', MSCoffLibHeader.sizeof);
        h.object_name[0] = '/';
        h.object_name[1] = '/';
        т_мера len = sprintf(h.file_size.ptr, "%u", noffset);
        assert(len < 10);
        h.file_size[len] = ' ';
        h.trailer[0] = '`';
        h.trailer[1] = '\n';
        libbuf.пиши((&h)[0 .. 1]);
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MSCoffObjModule* om2 = objmodules[i];
            if (om2.name_offset >= 0)
            {
                libbuf.пишиСтр(om2.имя);
                libbuf.пишиБайт(0);
            }
        }
        /* Write out each of the объект modules
         */
        for (т_мера i = 0; i < objmodules.dim; i++)
        {
            MSCoffObjModule* om2 = objmodules[i];
            if (libbuf.length & 1)
                libbuf.пишиБайт('\n'); // module alignment
            //printf("libbuf %x om %x\n", (цел)libbuf.length, (цел)om2.смещение);
            assert(libbuf.length == om2.смещение);
            if (om2.scan)
            {
                MSCoffOmToHeader(&h, om2);
                libbuf.пиши((&h)[0 .. 1]); // module header
                libbuf.пиши(om2.base[0 .. om2.length]); // module contents
            }
            else
            {
                // Header is included in om.base[0..length]
                libbuf.пиши(om2.base[0 .. om2.length]); // module contents
            }
        }
        static if (LOG)
        {
            printf("moffset = x%x, libbuf.length = x%x\n", cast(бцел)moffset, cast(бцел)libbuf.length);
        }
        assert(libbuf.length == moffset);
    }
}

/*****************************************************************************/
/*****************************************************************************/
struct MSCoffObjModule
{
    ббайт* base; // where are we holding it in memory
    бцел length; // in bytes
    бцел смещение; // смещение from start of library
    ushort index; // index in Second Linker Member
    ткст имя; // module имя (файл имя) terminated with 0
    цел name_offset; // if not -1, смещение into ткст table of имя
    long file_time; // файл time
    бцел user_id;
    бцел group_id;
    бцел file_mode;
    цел scan; // 1 means scan for symbols
}

/*********
 * Do module смещение comparison of MSCoffObjSymbol's for qsort()
 */
extern (C) цел MSCoffObjSymbol_offset_cmp(ук p, ук q)
{
    MSCoffObjSymbol* s1 = *cast(MSCoffObjSymbol**)p;
    MSCoffObjSymbol* s2 = *cast(MSCoffObjSymbol**)q;
    return s1.om.смещение - s2.om.смещение;
}

const MSCOFF_OBJECT_NAME_SIZE = 16;

struct MSCoffLibHeader
{
    сим[MSCOFF_OBJECT_NAME_SIZE] object_name;
    сим[12] file_time;
    сим[6] user_id;
    сим[6] group_id;
    сим[8] file_mode; // in octal
    сим[10] file_size;
    сим[2] trailer;
}

 проц MSCoffOmToHeader(MSCoffLibHeader* h, MSCoffObjModule* om)
{
    т_мера len;
    if (om.name_offset == -1)
    {
        len = om.имя.length;
        memcpy(h.object_name.ptr, om.имя.ptr, len);
        h.object_name[len] = '/';
    }
    else
    {
        len = sprintf(h.object_name.ptr, "/%d", om.name_offset);
        h.object_name[len] = ' ';
    }
    assert(len < MSCOFF_OBJECT_NAME_SIZE);
    memset(h.object_name.ptr + len + 1, ' ', MSCOFF_OBJECT_NAME_SIZE - (len + 1));
    /* In the following sprintf's, don't worry if the trailing 0
     * that sprintf writes goes off the end of the field. It will
     * пиши into the следщ field, which we will promptly overwrite
     * anyway. (So make sure to пиши the fields in ascending order.)
     */
    len = sprintf(h.file_time.ptr, "%llu", cast(long)om.file_time);
    assert(len <= 12);
    memset(h.file_time.ptr + len, ' ', 12 - len);
    // Match what MS tools do (set to all blanks)
    memset(h.user_id.ptr, ' ', (h.user_id).sizeof);
    memset(h.group_id.ptr, ' ', (h.group_id).sizeof);
    len = sprintf(h.file_mode.ptr, "%o", om.file_mode);
    assert(len <= 8);
    memset(h.file_mode.ptr + len, ' ', 8 - len);
    len = sprintf(h.file_size.ptr, "%u", om.length);
    assert(len <= 10);
    memset(h.file_size.ptr + len, ' ', 10 - len);
    h.trailer[0] = '`';
    h.trailer[1] = '\n';
}
