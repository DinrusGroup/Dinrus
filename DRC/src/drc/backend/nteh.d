/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1994-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/nteh.d, backend/nteh.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/nteh.d
 */

// Support for NT exception handling

module drc.backend.nteh;

version (SPP)
{
}
else
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.codebuilder : CodeBuilder;
import drc.backend.dt;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.oper;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

version (SCPP)
{
    import scopeh;
}
else version (HTOD)
{
    import scopeh;
}

static if (NTEXCEPTIONS)
{

/*extern (C++):*/



цел REGSIZE();
Symbol* except_gensym();
проц except_fillInEHTable(Symbol *s);

private 
{
    Symbol *s_table;
    Symbol *s_context;
    ткст0 s_name_context_tag = "__nt_context";
    ткст0 s_name_context = "__context";
    ткст0 s_name_ecode = "__ecode";

    ткст0 text_nt =
    "struct __nt_context {" ~
        "цел esp; цел info; цел prev; цел handler; цел stable; цел sindex; цел ebp;" ~
     "};\n";
}

// member stable is not используется for Dinrus or C++

цел nteh_EBPoffset_sindex()     { return -4; }
цел nteh_EBPoffset_prev()       { return -nteh_contextsym_size() + 8; }
цел nteh_EBPoffset_info()       { return -nteh_contextsym_size() + 4; }
цел nteh_EBPoffset_esp()        { return -nteh_contextsym_size() + 0; }

цел nteh_offset_sindex()        { version (Dinrus) { return 16; } else { return 20; } }
цел nteh_offset_sindex_seh()    { return 20; }
цел nteh_offset_info()          { return 4; }

/***********************************
 */

ббайт *nteh_context_string()
{
    if (config.exe == EX_WIN32)
        return cast(ббайт *)text_nt;
    else
        return null;
}

/*******************************
 * Get symbol for scope table for current function.
 * Возвращает:
 *      symbol of table
 */

private Symbol *nteh_scopetable()
{
    Symbol *s;
    тип *t;

    if (!s_table)
    {
        t = type_alloc(TYint);
        s = symbol_generate(SCstatic,t);
        s.Sseg = UNKNOWN;
        symbol_keep(s);
        s_table = s;
    }
    return s_table;
}

/*************************************
 */

проц nteh_filltables()
{
version (Dinrus)
{
    Symbol *s = s_table;
    symbol_debug(s);
    except_fillInEHTable(s);
}
}

/****************************
 * Generate and output scope table.
 * Not called for NTEH C++ exceptions
 */

проц nteh_gentables(Symbol *sfunc)
{
    Symbol *s = s_table;
    symbol_debug(s);
version (Dinrus)
{
    //except_fillInEHTable(s);
}
else
{
    /* NTEH table for C.
     * The table consists of triples:
     *  родитель index
     *  filter address
     *  handler address
     */
    бцел fsize = 4;             // target size of function pointer
    auto dtb = DtBuilder(0);
    цел sz = 0;                     // size so far

    foreach (b; BlockRange(startblock))
    {
        if (b.BC == BC_try)
        {
            block *bhandler;

            dtb.dword(b.Blast_index);  // родитель index

            // If try-finally
            if (b.numSucc() == 2)
            {
                dtb.dword(0);           // filter address
                bhandler = b.nthSucc(1);
                assert(bhandler.BC == BC_finally);
                // To successor of BC_finally block
                bhandler = bhandler.nthSucc(0);
            }
            else // try-except
            {
                bhandler = b.nthSucc(1);
                assert(bhandler.BC == BC_filter);
                dtb.coff(bhandler.Boffset);    // filter address
                bhandler = b.nthSucc(2);
                assert(bhandler.BC == BC_except);
            }
            dtb.coff(bhandler.Boffset);        // handler address
            sz += 4 + fsize * 2;
        }
    }
    assert(sz != 0);
    s.Sdt = dtb.finish();
}

    outdata(s);                 // output the scope table
version (Dinrus)
{
    nteh_framehandler(sfunc, s);
}
    s_table = null;
}

/**************************
 * Declare frame variables.
 */

проц nteh_declarvars(Blockx *bx)
{
    Symbol *s;

    //printf("nteh_declarvars()\n");
version (Dinrus)
{
    if (!(bx.funcsym.Sfunc.Fflags3 & Fnteh)) // if haven't already done it
    {   bx.funcsym.Sfunc.Fflags3 |= Fnteh;
        s = symbol_name(s_name_context,SCbprel,tstypes[TYint]);
        s.Soffset = -5 * 4;            // -6 * 4 for C __try, __except, __finally
        s.Sflags |= SFLfree | SFLnodebug;
        type_setty(&s.Stype,mTYvolatile | TYint);
        symbol_add(s);
        bx.context = s;
    }
}
else
{
    if (!(funcsym_p.Sfunc.Fflags3 & Fnteh))   // if haven't already done it
    {   funcsym_p.Sfunc.Fflags3 |= Fnteh;
        if (!s_context)
            s_context = scope_search(s_name_context_tag, CPP ? SCTglobal : SCTglobaltag);
        symbol_debug(s_context);

        s = symbol_name(s_name_context,SCbprel,s_context.Stype);
        s.Soffset = -6 * 4;            // -5 * 4 for C++
        s.Sflags |= SFLfree;
        symbol_add(s);
        type_setty(&s.Stype,mTYvolatile | TYstruct);

        s = symbol_name(s_name_ecode,SCauto,type_alloc(mTYvolatile | TYint));
        s.Sflags |= SFLfree;
        symbol_add(s);
    }
}
}

/**************************************
 * Generate elem that sets the context index into the scope table.
 */

version (Dinrus)
{
elem *nteh_setScopeTableIndex(Blockx *blx, цел scope_index)
{
    elem *e;
    Symbol *s;

    s = blx.context;
    symbol_debug(s);
    e = el_var(s);
    e.EV.Voffset = nteh_offset_sindex();
    return el_bin(OPeq, TYint, e, el_long(TYint, scope_index));
}
}


/**********************************
 * Return pointer to context symbol.
 */

Symbol *nteh_contextsym()
{
    for (SYMIDX si = 0; 1; si++)
    {   assert(si < globsym.top);
        Symbol* sp = globsym.tab[si];
        symbol_debug(sp);
        if (strcmp(sp.Sident.ptr,s_name_context) == 0)
            return sp;
    }
}

/**********************************
 * Return size of context symbol on stack.
 */

бцел nteh_contextsym_size()
{
    цел sz;

    if (usednteh & NTEH_try)
    {
version (Dinrus)
{
        sz = 5 * 4;
}
else version (SCPP)
{
        sz = 6 * 4;
}
else version (HTOD)
{
        sz = 6 * 4;
}
else
        static assert(0);
    }
    else if (usednteh & NTEHcpp)
    {
        sz = 5 * 4;                     // C++ context record
    }
    else if (usednteh & NTEHpassthru)
    {
        sz = 1 * 4;
    }
    else
        sz = 0;                         // no context record
    return sz;
}

/**********************************
 * Return pointer to ecode symbol.
 */

Symbol *nteh_ecodesym()
{
    SYMIDX si;
    Symbol *sp;

    for (si = 0; 1; si++)
    {   assert(si < globsym.top);
        sp = globsym.tab[si];
        symbol_debug(sp);
        if (strcmp(sp.Sident.ptr, s_name_ecode) == 0)
            return sp;
    }
}

/*********************************
 * Mark EH variables as используется so that they don't get optimized away.
 */

проц nteh_usevars()
{
version (SCPP)
{
    // Turn off SFLdead and SFLunambig in Sflags
    nteh_contextsym().Sflags &= ~(SFLdead | SFLunambig);
    nteh_contextsym().Sflags |= SFLread;
    nteh_ecodesym().Sflags   &= ~(SFLdead | SFLunambig);
    nteh_ecodesym().Sflags   |= SFLread;
}
else
{
    // Turn off SFLdead and SFLunambig in Sflags
    nteh_contextsym().Sflags &= ~SFLdead;
    nteh_contextsym().Sflags |= SFLread;
}
}

/*********************************
 * Generate NT exception handling function prolog.
 */

проц nteh_prolog(ref CodeBuilder cdb)
{
    code cs;

    if (usednteh & NTEHpassthru)
    {
        /* An sindex значение of -2 is a magic значение that tells the
         * stack unwinder to skip this frame.
         */
        assert(config.exe & (EX_LINUX | EX_LINUX64 | EX_OSX | EX_OSX64 | EX_FREEBSD | EX_FREEBSD64 | EX_SOLARIS | EX_SOLARIS64 | EX_OPENBSD | EX_OPENBSD64 | EX_DRAGONFLYBSD64));
        cs.Iop = 0x68;
        cs.Iflags = 0;
        cs.Irex = 0;
        cs.IFL2 = FLconst;
        cs.IEV2.Vint = -2;
        cdb.gen(&cs);                           // PUSH -2
        return;
    }

    /* Generate instance of struct __nt_context on stack frame:
        [  ]                                    // previous ebp already there
        сунь    -1                              // sindex
        mov     EDX,FS:__except_list
        сунь    смещение FLAT:scope_table         // stable (not for Dinrus or C++)
        сунь    смещение FLAT:__except_handler3   // handler
        сунь    EDX                             // prev
        mov     FS:__except_list,ESP
        sub     ESP,8                           // info, esp for __except support
     */

//    useregs(mAX);                     // What is this for?

    cs.Iop = 0x68;
    cs.Iflags = 0;
    cs.Irex = 0;
    cs.IFL2 = FLconst;
    cs.IEV2.Vint = -1;
    cdb.gen(&cs);                 // PUSH -1

    version (Dinrus)
    {
        // PUSH &framehandler
        cs.IFL2 = FLframehandler;
        nteh_scopetable();
    }
    else
    {
    if (usednteh & NTEHcpp)
    {
        // PUSH &framehandler
        cs.IFL2 = FLframehandler;
    }
    else
    {
        // Do stable
        cs.Iflags |= CFoff;
        cs.IFL2 = FLextern;
        cs.IEV2.Vsym = nteh_scopetable();
        cs.IEV2.Voffset = 0;
        cdb.gen(&cs);                       // PUSH &scope_table

        cs.IFL2 = FLextern;
        cs.IEV2.Vsym = getRtlsym(RTLSYM_EXCEPT_HANDLER3);
        makeitextern(getRtlsym(RTLSYM_EXCEPT_HANDLER3));
    }
    }

    CodeBuilder cdb2;
    cdb2.ctor();
    cdb2.gen(&cs);                          // PUSH &__except_handler3

    if (config.exe == EX_WIN32)
    {
        makeitextern(getRtlsym(RTLSYM_EXCEPT_LIST));
    static if (0)
    {
        cs.Iop = 0xFF;
        cs.Irm = modregrm(0,6,BPRM);
        cs.Iflags = CFfs;
        cs.Irex = 0;
        cs.IFL1 = FLextern;
        cs.IEV1.Vsym = getRtlsym(RTLSYM_EXCEPT_LIST);
        cs.IEV1.Voffset = 0;
        cdb2.gen(&cs);                             // PUSH FS:__except_list
    }
    else
    {
        useregs(mDX);
        cs.Iop = 0x8B;
        cs.Irm = modregrm(0,DX,BPRM);
        cs.Iflags = CFfs;
        cs.Irex = 0;
        cs.IFL1 = FLextern;
        cs.IEV1.Vsym = getRtlsym(RTLSYM_EXCEPT_LIST);
        cs.IEV1.Voffset = 0;
        cdb.gen(&cs);                            // MOV EDX,FS:__except_list

        cdb2.gen1(0x50 + DX);                      // PUSH EDX
    }
        cs.Iop = 0x89;
        NEWREG(cs.Irm,SP);
        cdb2.gen(&cs);                             // MOV FS:__except_list,ESP
    }

    cdb.приставь(cdb2);
    cod3_stackadj(cdb, 8);
}

/*********************************
 * Generate NT exception handling function epilog.
 */

проц nteh_epilog(ref CodeBuilder cdb)
{
    if (config.exe != EX_WIN32)
        return;

    /* Generate:
        mov     ECX,__context[EBP].prev
        mov     FS:__except_list,ECX
     */
    code cs;
    reg_t reg;

version (Dinrus)
    reg = CX;
else
    reg = (tybasic(funcsym_p.Stype.Tnext.Tty) == TYvoid) ? AX : CX;

    useregs(1 << reg);

    cs.Iop = 0x8B;
    cs.Irm = modregrm(2,reg,BPRM);
    cs.Iflags = 0;
    cs.Irex = 0;
    cs.IFL1 = FLconst;
    // EBP смещение of __context.prev
    cs.IEV1.Vint = nteh_EBPoffset_prev();
    cdb.gen(&cs);

    cs.Iop = 0x89;
    cs.Irm = modregrm(0,reg,BPRM);
    cs.Iflags |= CFfs;
    cs.IFL1 = FLextern;
    cs.IEV1.Vsym = getRtlsym(RTLSYM_EXCEPT_LIST);
    cs.IEV1.Voffset = 0;
    cdb.gen(&cs);
}

/**************************
 * Set/Reset ESP from context.
 */

проц nteh_setsp(ref CodeBuilder cdb, opcode_t op)
{
    code cs;
    cs.Iop = op;
    cs.Irm = modregrm(2,SP,BPRM);
    cs.Iflags = 0;
    cs.Irex = 0;
    cs.IFL1 = FLconst;
    // EBP смещение of __context.esp
    cs.IEV1.Vint = nteh_EBPoffset_esp();
    cdb.gen(&cs);               // MOV ESP,__context[EBP].esp
}

/****************************
 * Put out prolog for BC_filter block.
 */

проц nteh_filter(ref CodeBuilder cdb, block *b)
{
    code cs;

    assert(b.BC == BC_filter);
    if (b.Bflags & BFLehcode)          // if referenced __ecode
    {
        /* Generate:
                mov     EAX,__context[EBP].info
                mov     EAX,[EAX]
                mov     EAX,[EAX]
                mov     __ecode[EBP],EAX
         */

        getregs(cdb,mAX);

        cs.Iop = 0x8B;
        cs.Irm = modregrm(2,AX,BPRM);
        cs.Iflags = 0;
        cs.Irex = 0;
        cs.IFL1 = FLconst;
        // EBP смещение of __context.info
        cs.IEV1.Vint = nteh_EBPoffset_info();
        cdb.gen(&cs);                 // MOV EAX,__context[EBP].info

        cs.Irm = modregrm(0,AX,0);
        cdb.gen(&cs);                     // MOV EAX,[EAX]
        cdb.gen(&cs);                     // MOV EAX,[EAX]

        cs.Iop = 0x89;
        cs.Irm = modregrm(2,AX,BPRM);
        cs.IFL1 = FLauto;
        cs.IEV1.Vsym = nteh_ecodesym();
        cs.IEV1.Voffset = 0;
        cdb.gen(&cs);                     // MOV __ecode[EBP],EAX
    }
}

/*******************************
 * Generate C++ or D frame handler.
 */

проц nteh_framehandler(Symbol *sfunc, Symbol *scopetable)
{
    // Generate:
    //  MOV     EAX,&scope_table
    //  JMP     __cpp_framehandler

    if (scopetable)
    {
        symbol_debug(scopetable);
        CodeBuilder cdb;
        cdb.ctor();
        cdb.gencs(0xB8+AX,0,FLextern,scopetable);  // MOV EAX,&scope_table

version (Dinrus)
        cdb.gencs(0xE9,0,FLfunc,getRtlsym(RTLSYM_D_HANDLER));      // JMP _d_framehandler
else
        cdb.gencs(0xE9,0,FLfunc,getRtlsym(RTLSYM_CPP_HANDLER));    // JMP __cpp_framehandler

        code *c = cdb.finish();
        pinholeopt(c,null);
        codout(sfunc.Sseg,c);
        code_free(c);
    }
}

/*********************************
 * Generate code to set scope index.
 */

code *nteh_patchindex(code* c, цел sindex)
{
    c.IEV2.Vт_мера = sindex;
    return c;
}

проц nteh_gensindex(ref CodeBuilder cdb, цел sindex)
{
    if (!(config.ehmethod == EHmethod.EH_WIN32 || config.ehmethod == EHmethod.EH_SEH) || funcsym_p.Sfunc.Fflags3 & Feh_none)
        return;
    // Generate:
    //  MOV     -4[EBP],sindex

    cdb.genc(0xC7,modregrm(1,0,BP),FLconst,cast(targ_uns)nteh_EBPoffset_sindex(),FLconst,sindex); // 7 bytes long
    cdb.last().Iflags |= CFvolatile;

    //assert(GENSINDEXSIZE == calccodsize(c));
}

/*********************************
 * Generate code for setjmp().
 */

проц cdsetjmp(ref CodeBuilder cdb, elem *e,regm_t *pretregs)
{
    code cs;
    regm_t retregs;
    бцел stackpushsave;
    бцел флаг;

    stackpushsave = stackpush;
version (SCPP)
{
    if (CPP && (funcsym_p.Sfunc.Fflags3 & Fcppeh || usednteh & NTEHcpp))
    {
        /*  If in C++ try block
            If the frame that is calling setjmp has a try,catch block then
            the call to setjmp3 is as follows:
              __setjmp3(environment,3,__cpp_longjmp_unwind,trylevel,funcdata);

            __cpp_longjmp_unwind is a routine in the RTL. This is a
            stdcall routine that will deal with unwinding for CPP Frames.
            trylevel is the значение that gets incremented at each catch,
            constructor invocation.
            funcdata is the same значение that you put into EAX prior to
            cppframehandler getting called.
         */
        Symbol *s;

        s = except_gensym();
        if (!s)
            goto L1;

        cdb.gencs(0x68,0,FLextern,s);                 // PUSH &scope_table
        stackpush += 4;
        cdb.genadjesp(4);

        cdb.genc1(0xFF,modregrm(1,6,BP),FLconst,cast(targ_uns)-4);
                                                // PUSH trylevel
        stackpush += 4;
        cdb.genadjesp(4);

        cs.Iop = 0x68;
        cs.Iflags = CFoff;
        cs.Irex = 0;
        cs.IFL2 = FLextern;
        cs.IEV2.Vsym = getRtlsym(RTLSYM_CPP_LONGJMP);
        cs.IEV2.Voffset = 0;
        cdb.gen(&cs);                         // PUSH &_cpp_longjmp_unwind
        stackpush += 4;
        cdb.genadjesp(4);

        флаг = 3;
        goto L2;
    }
}
    if (funcsym_p.Sfunc.Fflags3 & Fnteh)
    {
        /*  If in NT SEH try block
            If the frame that is calling setjmp has a try, except block
            then the call to setjmp3 is as follows:
              __setjmp3(environment,2,__seh_longjmp_unwind,trylevel);
            __seth_longjmp_unwind is supplied by the RTL and is a stdcall
            function. It is the имя that MSOFT uses, we should
            probably use the same one.
            trylevel is the значение that you increment at each try and
            decrement at the close of the try.  This corresponds to the
            index field of the ehrec.
         */
        цел sindex_off;

        sindex_off = 20;                // смещение of __context.sindex
        cs.Iop = 0xFF;
        cs.Irm = modregrm(2,6,BPRM);
        cs.Iflags = 0;
        cs.Irex = 0;
        cs.IFL1 = FLbprel;
        cs.IEV1.Vsym = nteh_contextsym();
        cs.IEV1.Voffset = sindex_off;
        cdb.gen(&cs);                 // PUSH scope_index
        stackpush += 4;
        cdb.genadjesp(4);

        cs.Iop = 0x68;
        cs.Iflags = CFoff;
        cs.Irex = 0;
        cs.IFL2 = FLextern;
        cs.IEV2.Vsym = getRtlsym(RTLSYM_LONGJMP);
        cs.IEV2.Voffset = 0;
        cdb.gen(&cs);                 // PUSH &_seh_longjmp_unwind
        stackpush += 4;
        cdb.genadjesp(4);

        флаг = 2;
    }
    else
    {
        /*  If the frame calling setjmp has neither a try..except, nor a
            try..catch, then call setjmp3 as follows:
            _setjmp3(environment,0)
         */
    L1:
        флаг = 0;
    }
L2:
    cs.Iop = 0x68;
    cs.Iflags = 0;
    cs.Irex = 0;
    cs.IFL2 = FLconst;
    cs.IEV2.Vint = флаг;
    cdb.gen(&cs);                     // PUSH флаг
    stackpush += 4;
    cdb.genadjesp(4);

    pushParams(cdb,e.EV.E1,REGSIZE, TYnfunc);

    getregs(cdb,~getRtlsym(RTLSYM_SETJMP3).Sregsaved & (ALLREGS | mES));
    cdb.gencs(0xE8,0,FLfunc,getRtlsym(RTLSYM_SETJMP3));      // CALL __setjmp3

    cod3_stackadj(cdb, -(stackpush - stackpushsave));
    cdb.genadjesp(-(stackpush - stackpushsave));

    stackpush = stackpushsave;
    retregs = regmask(e.Ety, TYnfunc);
    fixрезультат(cdb,e,retregs,pretregs);
}

/****************************************
 * Call _local_unwind(), which means call the __finally blocks until
 * stop_index is reached.
 * Параметры:
 *      cdb = приставь generated code to
 *      saveregs = registers to save across the generated code
 *      stop_index = index to stop at
 */

проц nteh_unwind(ref CodeBuilder cdb,regm_t saveregs,бцел stop_index)
{
    // Shouldn't this always be CX?
version (SCPP)
    const reg_t reg = AX;
else
    const reg_t reg = CX;

version (Dinrus)
    // https://github.com/dlang/druntime/blob/master/src/rt/deh_win32.d#L924
    const цел local_unwind = RTLSYM_D_LOCAL_UNWIND2;    // __d_local_unwind2()
else
    // dm/src/win32/ehsup.c
    const цел local_unwind = RTLSYM_LOCAL_UNWIND2;      // __local_unwind2()

    const regm_t desregs = (~getRtlsym(local_unwind).Sregsaved & (ALLREGS)) | (1 << reg);
    CodeBuilder cdbs;
    cdbs.ctor();
    CodeBuilder cdbr;
    cdbr.ctor();
    gensaverestore(saveregs & desregs,cdbs,cdbr);

    CodeBuilder cdbx;
    cdbx.ctor();
    getregs(cdbx,desregs);

    code cs;
    cs.Iop = LEA;
    cs.Irm = modregrm(2,reg,BPRM);
    cs.Iflags = 0;
    cs.Irex = 0;
    cs.IFL1 = FLconst;
    // EBP смещение of __context.prev
    cs.IEV1.Vint = nteh_EBPoffset_prev();
    cdbx.gen(&cs);                             // LEA  ECX,contextsym

    цел nargs = 0;
version (SCPP)
{
    const цел take_addr = 1;
    cdbx.genc2(0x68,0,take_addr);                  // PUSH take_addr
    ++nargs;
}

    cdbx.genc2(0x68,0,stop_index);                 // PUSH stop_index
    cdbx.gen1(0x50 + reg);                         // PUSH ECX            ; DEstablisherFrame
    nargs += 2;
version (Dinrus)
{
    cdbx.gencs(0x68,0,FLextern,nteh_scopetable());      // PUSH &scope_table    ; DHandlerTable
    ++nargs;
}

    cdbx.gencs(0xE8,0,FLfunc,getRtlsym(local_unwind));  // CALL _local_unwind()
    cod3_stackadj(cdbx, -nargs * 4);

    cdb.приставь(cdbs);
    cdb.приставь(cdbx);
    cdb.приставь(cdbr);
}

/*************************************************
 * Set monitor, hook monitor exception handler.
 */

version (Dinrus)
{
проц nteh_monitor_prolog(ref CodeBuilder cdb, Symbol *shandle)
{
    /*
     *  PUSH    handle
     *  PUSH    смещение _d_monitor_handler
     *  PUSH    FS:__except_list
     *  MOV     FS:__except_list,ESP
     *  CALL    _d_monitor_prolog
     */
    CodeBuilder cdbx;
    cdbx.ctor();

    assert(config.exe == EX_WIN32);    // BUG: figure out how to implement for other EX's

    if (shandle.Sclass == SCfastpar)
    {   assert(shandle.Spreg != DX);
        assert(shandle.Spreg2 == NOREG);
        cdbx.gen1(0x50 + shandle.Spreg);   // PUSH shandle
    }
    else
    {
        // PUSH shandle
        useregs(mCX);
        cdbx.genc1(0x8B,modregrm(2,CX,4),FLconst,4 * (1 + needframe) + shandle.Soffset + localsize);
        cdbx.last().Isib = modregrm(0,4,SP);
        cdbx.gen1(0x50 + CX);                      // PUSH ECX
    }

    Symbol *smh = getRtlsym(RTLSYM_MONITOR_HANDLER);
    cdbx.gencs(0x68,0,FLextern,smh);             // PUSH смещение _d_monitor_handler
    makeitextern(smh);

    code cs;
    useregs(mDX);
    cs.Iop = 0x8B;
    cs.Irm = modregrm(0,DX,BPRM);
    cs.Iflags = CFfs;
    cs.Irex = 0;
    cs.IFL1 = FLextern;
    cs.IEV1.Vsym = getRtlsym(RTLSYM_EXCEPT_LIST);
    cs.IEV1.Voffset = 0;
    cdb.gen(&cs);                   // MOV EDX,FS:__except_list

    cdbx.gen1(0x50 + DX);                  // PUSH EDX

    Symbol *s = getRtlsym(RTLSYM_MONITOR_PROLOG);
    regm_t desregs = ~s.Sregsaved & ALLREGS;
    getregs(cdbx,desregs);
    cdbx.gencs(0xE8,0,FLfunc,s);       // CALL _d_monitor_prolog

    cs.Iop = 0x89;
    NEWREG(cs.Irm,SP);
    cdbx.gen(&cs);                         // MOV FS:__except_list,ESP

    cdb.приставь(cdbx);
}

}

/*************************************************
 * Release monitor, unhook monitor exception handler.
 * Input:
 *      retregs         registers to not разрушь
 */

version (Dinrus)
{

проц nteh_monitor_epilog(ref CodeBuilder cdb,regm_t retregs)
{
    /*
     *  CALL    _d_monitor_epilog
     *  POP     FS:__except_list
     */

    assert(config.exe == EX_WIN32);    // BUG: figure out how to implement for other EX's

    Symbol *s = getRtlsym(RTLSYM_MONITOR_EPILOG);
    //desregs = ~s.Sregsaved & ALLREGS;
    regm_t desregs = 0;
    CodeBuilder cdbs;
    cdbs.ctor();
    CodeBuilder cdbr;
    cdbr.ctor();
    gensaverestore(retregs& desregs,cdbs,cdbr);
    cdb.приставь(cdbs);

    getregs(cdb,desregs);
    cdb.gencs(0xE8,0,FLfunc,s);               // CALL __d_monitor_epilog

    cdb.приставь(cdbr);

    code cs;
    cs.Iop = 0x8F;
    cs.Irm = modregrm(0,0,BPRM);
    cs.Iflags = CFfs;
    cs.Irex = 0;
    cs.IFL1 = FLextern;
    cs.IEV1.Vsym = getRtlsym(RTLSYM_EXCEPT_LIST);
    cs.IEV1.Voffset = 0;
    cdb.gen(&cs);                       // POP FS:__except_list
}

}

}
}
