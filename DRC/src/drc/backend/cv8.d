/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:    Copyright (C) 2012-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/cv8.d, backend/cv8.d)
 */

// This module generates the .debug$S and .debug$T sections for Win64,
// which are the MS-Coff symbolic debug info and тип debug info sections.

module drc.backend.cv8;

version (Dinrus)
{

import cidrus;
//extern (C) ткст0 getcwd(сим*, т_мера);

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.cgcv;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.cv4;
import drc.backend.mem;
import drc.backend.el;
import drc.backend.exh;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;
import drc.backend.dvarstats;
import drc.backend.xmm;

/*extern (C++):*/



static if (TARGET_WINDOS)
{

цел REGSIZE();

// Determine if this Symbol is stored in a COMDAT
бул symbol_iscomdat(Symbol* s)
{
    version (Dinrus)
    {
        return s.Sclass == SCcomdat ||
            config.flags2 & CFG2comdat && s.Sclass == SCinline ||
            config.flags4 & CFG4allcomdat && s.Sclass == SCglobal;
    }
    else
    {
        return s.Sclass == SCcomdat ||
            config.flags2 & CFG2comdat && s.Sclass == SCinline ||
            config.flags4 & CFG4allcomdat && (s.Sclass == SCglobal || s.Sclass == SCstatic);
    }
}


// if symbols get longer than 65500 bytes, the linker reports corrupt debug info or exits with
// 'fatal error LNK1318: Unexpected PDB error; RPC (23) '(0x000006BA)'
const CV8_MAX_SYMBOL_LENGTH = 0xffd8;

// The "F1" section, which is the symbols
private  Outbuffer *F1_buf;

// The "F2" section, which is the line numbers
private  Outbuffer *F2_buf;

// The "F3" section, which is глоб2 and a С‚РєСЃС‚ table of source файл имена.
private  Outbuffer *F3_buf;

// The "F4" section, which is глоб2 and a lists info about source files.
private  Outbuffer *F4_buf;

/* Fixups that go into F1 section
 */
struct F1_Fixups
{
    Symbol *s;
    бцел смещение;
    бцел значение;
}

private  Outbuffer *F1fixup;      // РјР°СЃСЃРёРІ of F1_Fixups

/* Struct in which to collect per-function данные, for later emission
 * into .debug$S.
 */
struct FuncData
{
    Symbol *sfunc;
    бцел section_length;
    ткст0 srcfilename;
    бцел srcfileoff;
    бцел linepairstart;     // starting byte index of смещение/line pairs in linebuf[]
    бцел linepairbytes;     // number of bytes for смещение/line pairs
    бцел linepairsegment;   // starting byte index of имяф segment for смещение/line pairs
    Outbuffer *f1buf;
    Outbuffer *f1fixup;
}

 FuncData currentfuncdata;

private  Outbuffer *funcdata;     // РјР°СЃСЃРёРІ of FuncData's

private  Outbuffer *linepair;     // РјР°СЃСЃРёРІ of смещение/line pairs

проц cv8_writename(Outbuffer *буф, ткст0 имя, т_мера len)
{
    if(config.flags2 & CFG2gms)
    {
        ткст0 start = имя;
        ткст0 cur = strchr(start, '.');
        ткст0 end = start + len;
        while(cur != null)
        {
            if(cur >= end)
            {
                буф.writen(start, end - start);
                return;
            }
            буф.writen(start, cur - start);
            буф.пишиБайт('@');
            start = cur + 1;
            if(start >= end)
                return;
            cur = strchr(start, '.');
        }
        буф.writen(start, end - start);
    }
    else
        буф.writen(имя, len);
}

/************************************************
 * Called at the start of an объект файл generation.
 * One source файл can generate multiple объект files; this starts an объект файл.
 * Input:
 *      имяф        source файл имя
 */
проц cv8_initfile(ткст0 имяф)
{
    //printf("cv8_initfile()\n");

    // Recycle buffers; much faster than delete/renew

    if (!F1_buf)
    {
         Outbuffer f1buf;
        f1buf.enlarge(1024);
        F1_buf = &f1buf;
    }
    F1_buf.устРазм(0);

    if (!F1fixup)
    {
         Outbuffer f1fixupbuf;
        f1fixupbuf.enlarge(1024);
        F1fixup = &f1fixupbuf;
    }
    F1fixup.устРазм(0);

    if (!F2_buf)
    {
         Outbuffer f2buf;
        f2buf.enlarge(1024);
        F2_buf = &f2buf;
    }
    F2_buf.устРазм(0);

    if (!F3_buf)
    {
         Outbuffer f3buf;
        f3buf.enlarge(1024);
        F3_buf = &f3buf;
    }
    F3_buf.устРазм(0);
    F3_buf.пишиБайт(0);       // first "имяф"

    if (!F4_buf)
    {
         Outbuffer f4buf;
        f4buf.enlarge(1024);
        F4_buf = &f4buf;
    }
    F4_buf.устРазм(0);

    if (!funcdata)
    {
         Outbuffer funcdatabuf;
        funcdatabuf.enlarge(1024);
        funcdata = &funcdatabuf;
    }
    funcdata.устРазм(0);

    if (!linepair)
    {
         Outbuffer linepairbuf;
        linepairbuf.enlarge(1024);
        linepair = &linepairbuf;
    }
    linepair.устРазм(0);

    memset(&currentfuncdata, 0, currentfuncdata.sizeof);
    currentfuncdata.f1buf = F1_buf;
    currentfuncdata.f1fixup = F1fixup;

    cv_init();
}

проц cv8_termfile(ткст0 objfilename)
{
    //printf("cv8_termfile()\n");

    /* Write out the debug info sections.
     */

    цел seg = MsCoffObj_seg_debugS();

    бцел значение = 4;
    objmod.bytes(seg,0,4,&значение);

    /* Start with starting symbol in separate "F1" section
     */
    Outbuffer буф;
    буф.enlarge(1024);
    т_мера len = strlen(objfilename);
    буф.writeWord(cast(цел)(2 + 4 + len + 1));
    буф.writeWord(S_COMPILAND_V3);
    буф.write32(0);
    буф.пиши(objfilename, cast(бцел)(len + 1));

    // пиши S_COMPILE record
    буф.writeWord(2 + 1 + 1 + 2 + 1 + VERSION.length + 1);
    буф.writeWord(S_COMPILE);
    буф.пишиБайт(I64 ? 0xD0 : 6); // target machine AMD64 or x86 (Pentium II)
    буф.пишиБайт(config.flags2 & CFG2gms ? (CPP != 0) : 'D'); // language index (C/C++/D)
    буф.writeWord(0x800 | (config.inline8087 ? 0 : (1<<3)));   // 32-bit, float package
    буф.пишиБайт(VERSION.length + 1);
    буф.пишиБайт('Z');
    буф.пиши(VERSION.ptr, VERSION.length);

    cv8_writesection(seg, 0xF1, &буф);

    // Write out "F2" sections
    бцел length = cast(бцел)funcdata.size();
    ббайт *p = funcdata.буф;
    for (бцел u = 0; u < length; u += FuncData.sizeof)
    {   FuncData *fd = cast(FuncData *)(p + u);

        F2_buf.устРазм(0);

        F2_buf.write32(cast(бцел)fd.sfunc.Soffset);
        F2_buf.write32(0);
        F2_buf.write32(fd.section_length);
        F2_buf.пиши(linepair.буф + fd.linepairstart, fd.linepairbytes);

        цел f2seg = seg;
        if (symbol_iscomdat(fd.sfunc))
        {
            f2seg = MsCoffObj_seg_debugS_comdat(fd.sfunc);
            objmod.bytes(f2seg, 0, 4, &значение);
        }

        бцел смещение = cast(бцел)SegData[f2seg].SDoffset + 8;
        cv8_writesection(f2seg, 0xF2, F2_buf);
        objmod.reftoident(f2seg, смещение, fd.sfunc, 0, CFseg | CFoff);

        if (f2seg != seg && fd.f1buf.size())
        {
            // Write out "F1" section
            const бцел f1offset = cast(бцел)SegData[f2seg].SDoffset;
            cv8_writesection(f2seg, 0xF1, fd.f1buf);

            // Fixups for "F1" section
            const бцел fixupLength = cast(бцел)fd.f1fixup.size();
            ббайт *pfixup = fd.f1fixup.буф;
            for (бцел v = 0; v < fixupLength; v += F1_Fixups.sizeof)
            {   F1_Fixups *f = cast(F1_Fixups *)(pfixup + v);

                objmod.reftoident(f2seg, f1offset + 8 + f.смещение, f.s, f.значение, CFseg | CFoff);
            }
        }
    }

    // Write out "F3" section
    if (F3_buf.size() > 1)
        cv8_writesection(seg, 0xF3, F3_buf);

    // Write out "F4" section
    if (F4_buf.size() > 0)
        cv8_writesection(seg, 0xF4, F4_buf);

    if (F1_buf.size())
    {
        // Write out "F1" section
        бцел f1offset = cast(бцел)SegData[seg].SDoffset;
        cv8_writesection(seg, 0xF1, F1_buf);

        // Fixups for "F1" section
        length = cast(бцел)F1fixup.size();
        p = F1fixup.буф;
        for (бцел u = 0; u < length; u += F1_Fixups.sizeof)
        {   F1_Fixups *f = cast(F1_Fixups *)(p + u);

            objmod.reftoident(seg, f1offset + 8 + f.смещение, f.s, f.значение, CFseg | CFoff);
        }
    }

    // Write out .debug$T section
    cv_term();
}

/************************************************
 * Called at the start of a module.
 * Note that there can be multiple modules in one объект файл.
 * cv8_initfile() must be called first.
 */
проц cv8_initmodule(ткст0 имяф, ткст0 modulename)
{
    //printf("cv8_initmodule(имяф = %s, modulename = %s)\n", имяф, modulename);
}

проц cv8_termmodule()
{
    //printf("cv8_termmodule()\n");
    assert(config.objfmt == OBJ_MSCOFF);
}

/******************************************
 * Called at the start of a function.
 */
проц cv8_func_start(Symbol *sfunc)
{
    //printf("cv8_func_start(%s)\n", sfunc.Sident);
    currentfuncdata.sfunc = sfunc;
    currentfuncdata.section_length = 0;
    currentfuncdata.srcfilename = null;
    currentfuncdata.linepairstart += currentfuncdata.linepairbytes;
    currentfuncdata.linepairbytes = 0;
    currentfuncdata.f1buf = F1_buf;
    currentfuncdata.f1fixup = F1fixup;
    if (symbol_iscomdat(sfunc))
    {
        // This leaks memory
        currentfuncdata.f1buf = cast(Outbuffer*)mem_calloc(Outbuffer.sizeof);
        currentfuncdata.f1buf.enlarge(128);
        currentfuncdata.f1fixup = cast(Outbuffer*)mem_calloc(Outbuffer.sizeof);
        currentfuncdata.f1fixup.enlarge(128);
    }
    varStats_startFunction();
}

проц cv8_func_term(Symbol *sfunc)
{
    //printf("cv8_func_term(%s)\n", sfunc.Sident);

    assert(currentfuncdata.sfunc == sfunc);
    currentfuncdata.section_length = cast(бцел)sfunc.Ssize;

    funcdata.пиши(&currentfuncdata, currentfuncdata.sizeof);

    // Write function symbol
    assert(tyfunc(sfunc.ty()));
    idx_t typidx;
    func_t* fn = sfunc.Sfunc;
    if(fn.Fclass)
    {
        // generate member function тип info
        // it would be nicer if this could be in cv4_typidx, but the function info is not РґРѕСЃС‚СѓРїРЅРѕ there
        бцел nparam;
        ббайт call = cv4_callconv(sfunc.Stype);
        idx_t paramidx = cv4_arglist(sfunc.Stype,&nparam);
        бцел следщ = cv4_typidx(sfunc.Stype.Tnext);

        тип* classtype = cast(тип*)fn.Fclass;
        бцел classidx = cv4_typidx(classtype);
        тип *tp = type_allocn(TYnptr, classtype);
        бцел thisidx = cv4_typidx(tp);  // TODO
        debtyp_t *d = debtyp_alloc(2 + 4 + 4 + 4 + 1 + 1 + 2 + 4 + 4);
        TOWORD(d.данные.ptr,LF_MFUNCTION_V2);
        TOLONG(d.данные.ptr + 2,следщ);       // return тип
        TOLONG(d.данные.ptr + 6,classidx);   // class тип
        TOLONG(d.данные.ptr + 10,thisidx);   // this тип
        d.данные.ptr[14] = call;
        d.данные.ptr[15] = 0;                // reserved
        TOWORD(d.данные.ptr + 16,nparam);
        TOLONG(d.данные.ptr + 18,paramidx);
        TOLONG(d.данные.ptr + 22,0);  // this adjust
        typidx = cv_debtyp(d);
    }
    else
        typidx = cv_typidx(sfunc.Stype);

    ткст0 ид = sfunc.prettyIdent ? sfunc.prettyIdent : prettyident(sfunc);
    т_мера len = strlen(ид);
    if(len > CV8_MAX_SYMBOL_LENGTH)
        len = CV8_MAX_SYMBOL_LENGTH;
    /*
     *  2       length (not including these 2 bytes)
     *  2       S_GPROC_V3
     *  4       родитель
     *  4       pend
     *  4       pnext
     *  4       size of function
     *  4       size of function prolog
     *  4       смещение to function epilog
     *  4       тип index
     *  6       seg:смещение of function start
     *  1       flags
     *  n       0 terminated имя С‚РєСЃС‚
     */
    Outbuffer *буф = currentfuncdata.f1buf;
    буф.резервируй(cast(бцел)(2 + 2 + 4 * 7 + 6 + 1 + len + 1));
    буф.writeWordn(cast(цел)(2 + 4 * 7 + 6 + 1 + len + 1));
    буф.writeWordn(sfunc.Sclass == SCstatic ? S_LPROC_V3 : S_GPROC_V3);
    буф.write32(0);            // родитель
    буф.write32(0);            // pend
    буф.write32(0);            // pnext
    буф.write32(cast(бцел)currentfuncdata.section_length); // size of function
    буф.write32(cast(бцел)startoffset);                    // size of prolog
    буф.write32(cast(бцел)retoffset);                      // смещение to epilog
    буф.write32(typidx);

    F1_Fixups f1f;
    f1f.s = sfunc;
    f1f.смещение = cast(бцел)буф.size();
    f1f.значение = 0;
    currentfuncdata.f1fixup.пиши(&f1f, f1f.sizeof);
    буф.write32(0);
    буф.writeWordn(0);

    буф.пишиБайт(0);
    буф.writen(ид, len);
    буф.пишиБайт(0);

    struct cv8
    {
    
        // record for CV record S_BLOCK_V3
        struct block_v3_data
        {
            ushort len;
            ushort ид;
            бцел pParent;
            бцел pEnd;
            бцел length;
            бцел смещение;
            ushort seg;
            ббайт[1] имя;
        }

         static проц endArgs()
        {
            Outbuffer *буф = currentfuncdata.f1buf;
            буф.writeWord(2);
            буф.writeWord(S_ENDARG);
        }
         static проц beginBlock(цел смещение, цел length)
        {
            Outbuffer *буф = currentfuncdata.f1buf;
            бцел soffset = cast(бцел)буф.size();
            // родитель and end to be filled by linker
            block_v3_data block32 = { block_v3_data.sizeof - 2, S_BLOCK_V3, 0, 0, length, смещение, 0, [ 0 ] };
            буф.пиши(&block32, block32.sizeof);
            т_мера offOffset = cast(сим*)&block32.смещение - cast(сим*)&block32;

            F1_Fixups f1f;
            f1f.s = currentfuncdata.sfunc;
            f1f.смещение = cast(бцел)(soffset + offOffset);
            f1f.значение = смещение;
            currentfuncdata.f1fixup.пиши(&f1f, f1f.sizeof);
        }
         static проц endBlock()
        {
            Outbuffer *буф = currentfuncdata.f1buf;
            буф.writeWord(2);
            буф.writeWord(S_END);
        }
    }
    varStats_writeSymbolTable(&globsym, &cv8_outsym, &cv8.endArgs, &cv8.beginBlock, &cv8.endBlock);

    /* Put out function return record S_RETURN
     * (VC doesn't, so we won't bother, either.)
     */

    // Write function end symbol
    буф.writeWord(2);
    буф.writeWord(S_END);

    currentfuncdata.f1buf = F1_buf;
    currentfuncdata.f1fixup = F1fixup;
}

/**********************************************
 */

проц cv8_linnum(Srcpos srcpos, бцел смещение)
{
    //printf("cv8_linnum(файл = %s, line = %d, смещение = x%x)\n", srcpos.Sfilename, (цел)srcpos.Slinnum, (бцел)смещение);
    if (!srcpos.Sfilename)
        return;

    varStats_recordLineOffset(srcpos, смещение);

     бцел lastoffset;
     бцел lastlinnum;

    if (!currentfuncdata.srcfilename ||
        (currentfuncdata.srcfilename != srcpos.Sfilename && strcmp(currentfuncdata.srcfilename, srcpos.Sfilename)))
    {
        currentfuncdata.srcfilename = srcpos.Sfilename;
        бцел srcfileoff = cv8_addfile(srcpos.Sfilename);

        // new файл segment
        currentfuncdata.linepairsegment = currentfuncdata.linepairstart + currentfuncdata.linepairbytes;

        linepair.write32(srcfileoff);
        linepair.write32(0); // резервируй space for length information
        linepair.write32(12);
        currentfuncdata.linepairbytes += 12;
    }
    else if (смещение <= lastoffset || srcpos.Slinnum == lastlinnum)
        return; // avoid multiple entries for the same смещение

    lastoffset = смещение;
    lastlinnum = srcpos.Slinnum;
    linepair.write32(смещение);
    linepair.write32(srcpos.Slinnum | 0x80000000); // mark as инструкция, not Выражение

    currentfuncdata.linepairbytes += 8;

    // update segment length
    auto segmentbytes = currentfuncdata.linepairstart + currentfuncdata.linepairbytes - currentfuncdata.linepairsegment;
    auto segmentheader = cast(бцел*)(linepair.буф + currentfuncdata.linepairsegment);
    segmentheader[1] = (segmentbytes - 12) / 8;
    segmentheader[2] = segmentbytes;
}

/**********************************************
 * Add source файл, if it isn't already there.
 * Return смещение into F4.
 */

бцел cv8_addfile(ткст0 имяф)
{
    //printf("cv8_addfile('%s')\n", имяф);

    /* The algorithms here use a linear search. This is acceptable only
     * because we expect only 1 or 2 files to appear.
     * Unlike C, there won't be lots of .h source files to be accounted for.
     */

    бцел length = cast(бцел)F3_buf.size();
    ббайт *p = F3_buf.буф;
    т_мера len = strlen(имяф);

    // ensure the имяф is absolute to help the debugger to найди the source
    // without having to know the working directory during compilation
     сим[260] cwd = 0;
     бцел cwdlen;
    бул abs = (*имяф == '\\') ||
               (*имяф == '/')  ||
               (*имяф && имяф[1] == ':');

    if (!abs && cwd[0] == 0)
    {
        if (getcwd(cwd.ptr, cwd.sizeof))
        {
            cwdlen = cast(бцел)strlen(cwd.ptr);
            if(cwd[cwdlen - 1] != '\\' && cwd[cwdlen - 1] != '/')
                cwd[cwdlen++] = '\\';
        }
    }
    бцел off = 1;
    while (off + len < length)
    {
        if (!abs)
        {
            if (memcmp(p + off, cwd.ptr, cwdlen) == 0 &&
                memcmp(p + off + cwdlen, имяф, len + 1) == 0)
                goto L1;
        }
        else if (memcmp(p + off, имяф, len + 1) == 0)
        {   // Already there
            //printf("\talready there at %x\n", off);
            goto L1;
        }
        off += strlen(cast(ткст0 )(p + off)) + 1;
    }
    off = length;
    // Add it
    if(!abs)
        F3_buf.пиши(cwd.ptr, cwdlen);
    F3_buf.пиши(имяф, cast(бцел)(len + 1));

L1:
    // off is the смещение of the имяф in F3.
    // Find it in F4.

    length = cast(бцел)F4_buf.size();
    p = F4_buf.буф;

    бцел u = 0;
    while (u + 8 <= length)
    {
        //printf("\t%x\n", *(бцел *)(p + u));
        if (off == *cast(бцел *)(p + u))
        {
            //printf("\tfound %x\n", u);
            return u;
        }
        u += 4;
        ushort тип = *cast(ushort *)(p + u);
        u += 2;
        if (тип == 0x0110)
            u += 16;            // MD5 checksum
        u += 2;
    }

    // Not there. Add it.
    F4_buf.write32(off);

    /* Write 10 01 [MD5 checksum]
     *   or
     * 00 00
     */
    F4_buf.writeShort(0);

    // 2 bytes of pad
    F4_buf.writeShort(0);

    //printf("\tadded %x\n", length);
    return length;
}

проц cv8_writesection(цел seg, бцел тип, Outbuffer *буф)
{
    /* Write out as:
     *  bytes   desc
     *  -------+----
     *  4       тип
     *  4       length
     *  length  данные
     *  pad     pad to 4 byte boundary
     */
    бцел off = cast(бцел)SegData[seg].SDoffset;
    objmod.bytes(seg,off,4,&тип);
    бцел length = cast(бцел)буф.size();
    objmod.bytes(seg,off+4,4,&length);
    objmod.bytes(seg,off+8,length,буф.буф);
    // Align to 4
    бцел pad = ((length + 3) & ~3) - length;
    objmod.lidata(seg,off+8+length,pad);
}

проц cv8_outsym(Symbol *s)
{
    //printf("cv8_outsym(s = '%s')\n", s.Sident);
    //type_print(s.Stype);
    //symbol_print(s);
    if (s.Sflags & SFLnodebug)
        return;

    idx_t typidx = cv_typidx(s.Stype);
    //printf("typidx = %x\n", typidx);
    ткст0 ид = s.prettyIdent ? s.prettyIdent : prettyident(s);
    т_мера len = strlen(ид);

    if(len > CV8_MAX_SYMBOL_LENGTH)
        len = CV8_MAX_SYMBOL_LENGTH;

    F1_Fixups f1f;
    f1f.значение = 0;
    Outbuffer *буф = currentfuncdata.f1buf;

    бцел sr;
    бцел base;
    switch (s.Sclass)
    {
        case SCparameter:
        case SCregpar:
        case SCshadowreg:
            if (s.Sfl == FLreg)
            {
                s.Sfl = FLpara;
                cv8_outsym(s);
                s.Sfl = FLreg;
                goto case_register;
            }
            base = cast(бцел)(Para.size - BPoff);    // cancel out add of BPoff
            goto L1;

        case SCauto:
            if (s.Sfl == FLreg)
                goto case_register;
        case_auto:
            base = cast(бцел)Auto.size;
        L1:
            if (s.Sscope) // local variables moved into the closure cannot be emitted directly
                break;
static if (1)
{
            // Register relative addressing
            буф.резервируй(cast(бцел)(2 + 2 + 4 + 4 + 2 + len + 1));
            буф.writeWordn(cast(бцел)(2 + 4 + 4 + 2 + len + 1));
            буф.writeWordn(0x1111);
            буф.write32(cast(бцел)(s.Soffset + base + BPoff));
            буф.write32(typidx);
            буф.writeWordn(I64 ? 334 : 22);       // relative to RBP/EBP
            cv8_writename(буф, ид, len);
            буф.пишиБайт(0);
}
else
{
            // This is supposed to work, implicit BP relative addressing, but it does not
            буф.резервируй(2 + 2 + 4 + 4 + len + 1);
            буф.writeWordn( 2 + 4 + 4 + len + 1);
            буф.writeWordn(S_BPREL_V3);
            буф.write32(s.Soffset + base + BPoff);
            буф.write32(typidx);
            cv8_writename(буф, ид, len);
            буф.пишиБайт(0);
}
            break;

        case SCbprel:
            base = -BPoff;
            goto L1;

        case SCfastpar:
            if (s.Sfl != FLreg)
            {   base = cast(бцел)Fast.size;
                goto L1;
            }
            goto L2;

        case SCregister:
            if (s.Sfl != FLreg)
                goto case_auto;
            goto case;

        case SCpseudo:
        case_register:
        L2:
            буф.резервируй(cast(бцел)(2 + 2 + 4 + 2 + len + 1));
            буф.writeWordn(cast(бцел)(2 + 4 + 2 + len + 1));
            буф.writeWordn(S_REGISTER_V3);
            буф.write32(typidx);
            буф.writeWordn(cv8_regnum(s));
            cv8_writename(буф, ид, len);
            буф.пишиБайт(0);
            break;

        case SCextern:
            break;

        case SCstatic:
        case SClocstat:
            sr = S_LDATA_V3;
            goto Ldata;

        case SCglobal:
        case SCcomdat:
        case SCcomdef:
            sr = S_GDATA_V3;
        Ldata:
            /*
             *  2       length (not including these 2 bytes)
             *  2       S_GDATA_V2
             *  4       typidx
             *  6       ref to symbol
             *  n       0 terminated имя С‚РєСЃС‚
             */
            if (s.ty() & mTYthread)            // thread local storage
                sr = (sr == S_GDATA_V3) ? 0x1113 : 0x1112;

            буф.резервируй(cast(бцел)(2 + 2 + 4 + 6 + len + 1));
            буф.writeWordn(cast(бцел)(2 + 4 + 6 + len + 1));
            буф.writeWordn(sr);
            буф.write32(typidx);

            f1f.s = s;
            f1f.смещение = cast(бцел)буф.size();
            F1fixup.пиши(&f1f, f1f.sizeof);
            буф.write32(0);
            буф.writeWordn(0);

            cv8_writename(буф, ид, len);
            буф.пишиБайт(0);
            break;

        default:
            break;
    }
}


/*******************************************
 * Put out a имя for a user defined тип.
 * Input:
 *      ид      the имя
 *      typidx  and its тип
 */
проц cv8_udt(ткст0 ид, idx_t typidx)
{
    //printf("cv8_udt('%s', %x)\n", ид, typidx);
    Outbuffer *буф = currentfuncdata.f1buf;
    т_мера len = strlen(ид);

    if (len > CV8_MAX_SYMBOL_LENGTH)
        len = CV8_MAX_SYMBOL_LENGTH;
    буф.резервируй(cast(бцел)(2 + 2 + 4 + len + 1));
    буф.writeWordn(cast(бцел)(2 + 4 + len + 1));
    буф.writeWordn(S_UDT_V3);
    буф.write32(typidx);
    cv8_writename(буф, ид, len);
    буф.пишиБайт(0);
}

/*********************************************
 * Get Codeview register number for symbol s.
 */
цел cv8_regnum(Symbol *s)
{
    цел reg = s.Sreglsw;
    assert(s.Sfl == FLreg);
    if ((1 << reg) & XMMREGS)
        return reg - XMM0 + 154;
    switch (type_size(s.Stype))
    {
        case 1:
            if (reg < 4)
                reg += 1;
            else if (reg >= 4 && reg < 8)
                reg += 324 - 4;
            else
                reg += 344 - 4;
            break;

        case 2:
            if (reg < 8)
                reg += 9;
            else
                reg += 352 - 8;
            break;

        case 4:
            if (reg < 8)
                reg += 17;
            else
                reg += 360 - 8;
            break;

        case 8:
            reg += 328;
            break;

        default:
            reg = 0;
            break;
    }
    return reg;
}

/***************************************
 * Put out a forward ref for structs, unions, and classes.
 * Only put out the real definitions with toDebug().
 */
idx_t cv8_fwdref(Symbol *s)
{
    assert(config.fulltypes == CV8);
//    if (s.Stypidx && !глоб2.парамы.multiobj)
//      return s.Stypidx;
    struct_t *st = s.Sstruct;
    бцел leaf;
    бцел numidx;
    if (st.Sflags & STRunion)
    {
        leaf = LF_UNION_V3;
        numidx = 10;
    }
    else if (st.Sflags & STRclass)
    {
        leaf = LF_CLASS_V3;
        numidx = 18;
    }
    else
    {
        leaf = LF_STRUCTURE_V3;
        numidx = 18;
    }
    бцел len = numidx + cv4_numericbytes(0);
    цел idlen = cast(цел)strlen(s.Sident.ptr);

    if (idlen > CV8_MAX_SYMBOL_LENGTH)
        idlen = CV8_MAX_SYMBOL_LENGTH;

    debtyp_t *d = debtyp_alloc(len + idlen + 1);
    TOWORD(d.данные.ptr, leaf);
    TOWORD(d.данные.ptr + 2, 0);     // number of fields
    TOWORD(d.данные.ptr + 4, 0x80);  // property
    TOLONG(d.данные.ptr + 6, 0);     // field list
    if (leaf == LF_CLASS_V3 || leaf == LF_STRUCTURE_V3)
    {
        TOLONG(d.данные.ptr + 10, 0);        // dList
        TOLONG(d.данные.ptr + 14, 0);        // vshape
    }
    cv4_storenumeric(d.данные.ptr + numidx, 0);
    cv_namestring(d.данные.ptr + len, s.Sident.ptr, idlen);
    d.данные.ptr[len + idlen] = 0;
    idx_t typidx = cv_debtyp(d);
    s.Stypidx = typidx;

    return typidx;
}

/****************************************
 * Return тип index for a darray of тип E[]
 * Input:
 *      t       darray тип
 *      etypidx тип index for E
 */
idx_t cv8_darray(тип *t, idx_t etypidx)
{
    //printf("cv8_darray(etypidx = %x)\n", etypidx);
    /* Put out a struct:
     *    struct dArray {
     *      т_мера length;
     *      E* ptr;
     *    }
     */

static if (0)
{
    d = debtyp_alloc(18);
    TOWORD(d.данные.ptr, 0x100F);
    TOWORD(d.данные.ptr + 2, OEM);
    TOWORD(d.данные.ptr + 4, 1);     // 1 = dynamic РјР°СЃСЃРёРІ
    TOLONG(d.данные.ptr + 6, 2);     // count of тип indices to follow
    TOLONG(d.данные.ptr + 10, 0x23); // index тип, T_UQUAD
    TOLONG(d.данные.ptr + 14, следщ); // element тип
    return cv_debtyp(d);
}

    тип *tp = type_pointer(t.Tnext);
    idx_t ptridx = cv4_typidx(tp);
    type_free(tp);

     const ббайт[38] fl =
    [
        0x03, 0x12,             // LF_FIELDLIST_V2
        0x0d, 0x15,             // LF_MEMBER_V3
        0x03, 0x00,             // attribute
        0x23, 0x00, 0x00, 0x00, // т_мера
        0x00, 0x00,             // смещение
        'l', 'e', 'n', 'g', 't', 'h', 0x00,
        0xf3, 0xf2, 0xf1,       // align to 4-byte including length word before данные
        0x0d, 0x15,
        0x03, 0x00,
        0x00, 0x00, 0x00, 0x00, // etypidx
        0x08, 0x00,
        'p', 't', 'r', 0x00,
        0xf2, 0xf1,
    ];

    debtyp_t *f = debtyp_alloc(fl.sizeof);
    memcpy(f.данные.ptr,fl.ptr,fl.sizeof);
    TOLONG(f.данные.ptr + 6, I64 ? 0x23 : 0x22); // т_мера
    TOLONG(f.данные.ptr + 26, ptridx);
    TOWORD(f.данные.ptr + 30, _tysize[TYnptr]);
    idx_t fieldlist = cv_debtyp(f);

    ткст0 ид;
    switch (t.Tnext.Tty)
    {
        case mTYimmutable | TYchar:
            ид = "С‚РєСЃС‚";
            break;

        case mTYimmutable | TYwchar_t:
            ид = "wstring";
            break;

        case mTYimmutable | TYdchar:
            ид = "dstring";
            break;

        default:
            ид = t.Tident ? t.Tident : "dArray";
            break;
    }

    цел idlen = cast(цел)strlen(ид);

    if (idlen > CV8_MAX_SYMBOL_LENGTH)
        idlen = CV8_MAX_SYMBOL_LENGTH;

    debtyp_t *d = debtyp_alloc(20 + idlen + 1);
    TOWORD(d.данные.ptr, LF_STRUCTURE_V3);
    TOWORD(d.данные.ptr + 2, 2);     // count
    TOWORD(d.данные.ptr + 4, 0);     // property
    TOLONG(d.данные.ptr + 6, fieldlist);
    TOLONG(d.данные.ptr + 10, 0);    // dList
    TOLONG(d.данные.ptr + 14, 0);    // vtshape
    TOWORD(d.данные.ptr + 18, 2 * _tysize[TYnptr]);   // size
    cv_namestring(d.данные.ptr + 20, ид, idlen);
    d.данные.ptr[20 + idlen] = 0;

    idx_t top = cv_numdebtypes();
    idx_t debidx = cv_debtyp(d);
    if(top != cv_numdebtypes())
        cv8_udt(ид, debidx);

    return debidx;
}

/****************************************
 * Return тип index for a delegate
 * Input:
 *      t          delegate тип
 *      functypidx тип index for pointer to function
 */
idx_t cv8_ddelegate(тип *t, idx_t functypidx)
{
    //printf("cv8_ddelegate(functypidx = %x)\n", functypidx);
    /* Put out a struct:
     *    struct dDelegate {
     *      СѓРє ptr;
     *      function* funcptr;
     *    }
     */

    тип *tv = type_fake(TYnptr);
    tv.Tcount++;
    idx_t pvidx = cv4_typidx(tv);
    type_free(tv);

    тип *tp = type_pointer(t.Tnext);
    idx_t ptridx = cv4_typidx(tp);
    type_free(tp);

static if (0)
{
    debtyp_t *d = debtyp_alloc(18);
    TOWORD(d.данные.ptr, 0x100F);
    TOWORD(d.данные.ptr + 2, OEM);
    TOWORD(d.данные.ptr + 4, 3);     // 3 = delegate
    TOLONG(d.данные.ptr + 6, 2);     // count of тип indices to follow
    TOLONG(d.данные.ptr + 10, ключ);  // СѓРє тип
    TOLONG(d.данные.ptr + 14, functypidx); // function тип
}
else
{
     const ббайт[38] fl =
    [
        0x03, 0x12,             // LF_FIELDLIST_V2
        0x0d, 0x15,             // LF_MEMBER_V3
        0x03, 0x00,             // attribute
        0x00, 0x00, 0x00, 0x00, // СѓРє
        0x00, 0x00,             // смещение
        'p','t','r',0,          // "ptr"
        0xf2, 0xf1,             // align to 4-byte including length word before данные
        0x0d, 0x15,
        0x03, 0x00,
        0x00, 0x00, 0x00, 0x00, // ptrtypidx
        0x08, 0x00,
        'f', 'u','n','c','p','t','r', 0,        // "funcptr"
        0xf2, 0xf1,
    ];

    debtyp_t *f = debtyp_alloc(fl.sizeof);
    memcpy(f.данные.ptr,fl.ptr,fl.sizeof);
    TOLONG(f.данные.ptr + 6, pvidx);
    TOLONG(f.данные.ptr + 22, ptridx);
    TOWORD(f.данные.ptr + 26, _tysize[TYnptr]);
    idx_t fieldlist = cv_debtyp(f);

    ткст0 ид = "dDelegate";
    цел idlen = cast(цел)strlen(ид);
    if (idlen > CV8_MAX_SYMBOL_LENGTH)
        idlen = CV8_MAX_SYMBOL_LENGTH;

    debtyp_t *d = debtyp_alloc(20 + idlen + 1);
    TOWORD(d.данные.ptr, LF_STRUCTURE_V3);
    TOWORD(d.данные.ptr + 2, 2);     // count
    TOWORD(d.данные.ptr + 4, 0);     // property
    TOLONG(d.данные.ptr + 6, fieldlist);
    TOLONG(d.данные.ptr + 10, 0);    // dList
    TOLONG(d.данные.ptr + 14, 0);    // vtshape
    TOWORD(d.данные.ptr + 18, 2 * _tysize[TYnptr]);   // size
    memcpy(d.данные.ptr + 20, ид, idlen);
    d.данные.ptr[20 + idlen] = 0;
}
    return cv_debtyp(d);
}

/****************************************
 * Return тип index for a aarray of тип Значение[Ключ]
 * Input:
 *      t          associative РјР°СЃСЃРёРІ тип
 *      keyidx     ключ тип
 *      validx     значение тип
 */
idx_t cv8_daarray(тип *t, idx_t keyidx, idx_t validx)
{
    //printf("cv8_daarray(keyidx = %x, validx = %x)\n", keyidx, validx);
    /* Put out a struct:
     *    struct dAssocArray {
     *      СѓРє ptr;
     *      typedef ключ-тип __key_t;
     *      typedef val-тип __val_t;
     *    }
     */

static if (0)
{
    debtyp_t *d = debtyp_alloc(18);
    TOWORD(d.данные.ptr, 0x100F);
    TOWORD(d.данные.ptr + 2, OEM);
    TOWORD(d.данные.ptr + 4, 2);     // 2 = associative РјР°СЃСЃРёРІ
    TOLONG(d.данные.ptr + 6, 2);     // count of тип indices to follow
    TOLONG(d.данные.ptr + 10, keyidx);  // ключ тип
    TOLONG(d.данные.ptr + 14, validx);  // element тип
}
else
{
    тип *tv = type_fake(TYnptr);
    tv.Tcount++;
    idx_t pvidx = cv4_typidx(tv);
    type_free(tv);

     const ббайт[50] fl =
    [
        0x03, 0x12,             // LF_FIELDLIST_V2
        0x0d, 0x15,             // LF_MEMBER_V3
        0x03, 0x00,             // attribute
        0x00, 0x00, 0x00, 0x00, // СѓРє
        0x00, 0x00,             // смещение
        'p','t','r',0,          // "ptr"
        0xf2, 0xf1,             // align to 4-byte including field ид
        // смещение 18
        0x10, 0x15,             // LF_NESTTYPE_V3
        0x00, 0x00,             // padding
        0x00, 0x00, 0x00, 0x00, // ключ тип
        '_','_','k','e','y','_','t',0,  // "__key_t"
        // смещение 34
        0x10, 0x15,             // LF_NESTTYPE_V3
        0x00, 0x00,             // padding
        0x00, 0x00, 0x00, 0x00, // значение тип
        '_','_','v','a','l','_','t',0,  // "__val_t"
    ];

    debtyp_t *f = debtyp_alloc(fl.sizeof);
    memcpy(f.данные.ptr,fl.ptr,fl.sizeof);
    TOLONG(f.данные.ptr + 6, pvidx);
    TOLONG(f.данные.ptr + 22, keyidx);
    TOLONG(f.данные.ptr + 38, validx);
    idx_t fieldlist = cv_debtyp(f);

    ткст0 ид = t.Tident ? t.Tident : "dAssocArray";
    цел idlen = cast(цел)strlen(ид);
    if (idlen > CV8_MAX_SYMBOL_LENGTH)
        idlen = CV8_MAX_SYMBOL_LENGTH;

    debtyp_t *d = debtyp_alloc(20 + idlen + 1);
    TOWORD(d.данные.ptr, LF_STRUCTURE_V3);
    TOWORD(d.данные.ptr + 2, 1);     // count
    TOWORD(d.данные.ptr + 4, 0);     // property
    TOLONG(d.данные.ptr + 6, fieldlist);
    TOLONG(d.данные.ptr + 10, 0);    // dList
    TOLONG(d.данные.ptr + 14, 0);    // vtshape
    TOWORD(d.данные.ptr + 18, _tysize[TYnptr]);   // size
    memcpy(d.данные.ptr + 20, ид, idlen);
    d.данные.ptr[20 + idlen] = 0;

}
    return cv_debtyp(d);
}

}

}
