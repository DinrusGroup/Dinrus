/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/glue.d, _glue.d)
 * Documentation: $(LINK https://dlang.org/phobos/dmd_glue.html)
 * Coverage:    $(LINK https://codecov.io/gh/dlang/dmd/src/master/src/dmd/glue.d)
 */

module dmd.glue;

import cidrus;

import util.array;
import util.file;
import util.filename;
import util.outbuffer;
import util.rmem;
import util.string;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.code;
import drc.backend.dt;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.blockexit;
import dmd.dclass;
import dmd.declaration;
import dmd.dmangle;
import dmd.dmodule;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.e2ir;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Identifier;
import drc.lexer.Id;
import dmd.irstate;
import drc.Library;
import dmd.mtype;
import dmd.objc_glue;
import dmd.s2ir;
import dmd.инструкция;
import dmd.target;
import dmd.tocsym;
import dmd.toctype;
import dmd.toir;
import dmd.toobj;
import dmd.typesem;
import util.utils;

/*extern (C++):*/

alias  МассивДРК!(Symbol*) symbols;
alias  dmd.tocsym.toSymbol toSymbol;

//extern

public{
    elem *eictor;
    Symbol *ictorlocalgot;
    Symbol* bzeroSymbol;        /// common location for const zeros
    symbols sctors;
    StaticDtorDeclarations ectorgates;
    symbols sdtors;
    symbols stests;

    symbols ssharedctors;
    SharedStaticDtorDeclarations esharedctorgates;
    symbols sshareddtors;

    ткст0 lastmname;
}


/**************************************
 * Append s to list of объект files to generate later.
 */

 Дсимволы obj_symbols_towrite;

проц obj_append(ДСимвол s)
{
    //printf("deferred: %s\n", s.вТкст0());
    obj_symbols_towrite.сунь(s);
}

проц obj_write_deferred(Library library)
{
    for (т_мера i = 0; i < obj_symbols_towrite.dim; i++)
    {
        ДСимвол s = obj_symbols_towrite[i];
        Module m = s.getModule();

        ткст0 mname;
        if (m)
        {
            mname = m.srcfile.вТкст0();
            lastmname = mname;
        }
        else
        {
            //mname = s.идент.вТкст0();
            mname = lastmname;
            assert(mname);
        }

        obj_start(mname);

         цел count;
        count++;                // sequence for generating имена

        /* Create a module that's a doppelganger of m, with just
         * enough to be able to создай the moduleinfo.
         */
        БуфВыв idbuf;
        idbuf.printf("%s.%d", m ? m.идент.вТкст0() : mname, count);

        if (!m)
        {
            // it doesn't make sense to make up a module if we don't know where to put the symbol
            //  so output it into it's own объект файл without ModuleInfo
            objmod.initfile(idbuf.peekChars(), null, mname);
            toObjFile(s, нет);
            objmod.termfile();
        }
        else
        {
            Идентификатор2 ид = Идентификатор2.создай(idbuf.extractChars());

            Module md = new Module(mname.вТкстД, ид, 0, 0);
            md.члены = new Дсимволы();
            md.члены.сунь(s);   // its only 'member' is s
            md.doppelganger = 1;       // identify this module as doppelganger
            md.md = m.md;
            md.aimports.сунь(m);       // it only 'imports' m

            genObjFile(md, нет);
        }

        /* Set объект файл имя to be source имя with sequence number,
         * as mangled symbol имена get way too long.
         */
        ткст0 fname = ИмяФайла.removeExt(mname);
        БуфВыв namebuf;
        бцел хэш = 0;
        for (ткст0 p = s.вТкст0(); *p; p++)
            хэш += *p;
        namebuf.printf("%s_%x_%x.%.*s", fname, count, хэш,
                       cast(цел)глоб2.obj_ext.length, глоб2.obj_ext.ptr);
        ИмяФайла.free(cast(сим *)fname);
        fname = namebuf.extractChars();

        //printf("writing '%s'\n", fname);
        obj_end(library, fname);
    }
    obj_symbols_towrite.dim = 0;
}


/***********************************************
 * Generate function that calls массив of functions and gates.
 * Параметры:
 *      m = module symbol (for имя mangling purposes)
 *      sctors = массив of functions
 *      ectorgates = массив of gates
 *      ид = идентификатор ткст for generator function
 * Возвращает:
 *      function Symbol generated
 */

private Symbol *callFuncsAndGates(Module m, symbols *sctors, StaticDtorDeclarations *ectorgates,
        ткст0 ид)
{
    Symbol *sctor = null;

    if ((sctors && sctors.dim) ||
        (ectorgates && ectorgates.dim))
    {
         тип *t;
        if (!t)
        {
            /* t will be the тип of the functions generated:
             *      extern (C) проц func();
             */
            t = type_function(TYnfunc, null, нет, tstypes[TYvoid]);
            t.Tmangle = mTYman_c;
        }

        localgot = null;
        sctor = toSymbolX(m, ид, SCglobal, t, "FZv");
        cstate.CSpsymtab = &sctor.Sfunc.Flocsym;
        elem *ector = null;

        if (ectorgates)
        {
            foreach (f; *ectorgates)
            {
                Symbol *s = toSymbol(f.vgate);
                elem *e = el_var(s);
                e = el_bin(OPaddass, TYint, e, el_long(TYint, 1));
                ector = el_combine(ector, e);
            }
        }

        if (sctors)
        {
            foreach (s; *sctors)
            {
                elem *e = el_una(OPucall, TYvoid, el_var(s));
                ector = el_combine(ector, e);
            }
        }

        block *b = block_calloc();
        b.BC = BCret;
        b.Belem = ector;
        sctor.Sfunc.Fstartline.Sfilename = m.arg.xarraydup.ptr;
        sctor.Sfunc.Fstartblock = b;
        writefunc(sctor);
    }
    return sctor;
}

/**************************************
 * Prepare for generating obj файл.
 */

 Outbuffer objbuf;

проц obj_start(ткст0 srcfile)
{
    //printf("obj_start()\n");

    bzeroSymbol = null;
    rtlsym_reset();
    clearStringTab();

    version (Windows)
    {
        // Produce Ms COFF files for 64 bit code, OMF for 32 bit code
        assert(objbuf.size() == 0);
        objmod = глоб2.парамы.mscoff ? MsCoffObj_init(&objbuf, srcfile, null)
                                      :    OmfObj_init(&objbuf, srcfile, null);
    }
    else
    {
        objmod = Obj.init(&objbuf, srcfile, null);
    }

    el_reset();
    cg87_reset();
    out_reset();
}


проц obj_end(Library library, ткст0 objfilename)
{
    objmod.term(objfilename);
    //delete objmod;
    objmod = null;

    const данные = objbuf.буф[0 .. objbuf.p - objbuf.буф];
    if (library)
    {
        // Transfer image to library
        library.addObject(objfilename, данные);
    }
    else
    {
        //printf("пиши obj %s\n", objfilename);
        writeFile(Место.initial, objfilename.вТкстД, данные);
        free(objbuf.буф); // objbuf is a backend `Outbuffer` managed by C malloc/free
    }
    objbuf.буф = null;
    objbuf.pend = null;
    objbuf.p = null;
}

бул obj_includelib(ткст0 имя)
{
    return objmod.includelib(имя);
}

extern(D) бул obj_includelib(ткст имя)
{
    return имя.toCStringThen!(/*n => */obj_includelib(n.ptr));
}

проц obj_startaddress(Symbol *s)
{
    return objmod.startaddress(s);
}

бул obj_linkerdirective(ткст0 directive)
{
    return objmod.linkerdirective(directive);
}


/**************************************
 * Generate .obj файл for Module.
 */

проц genObjFile(Module m, бул multiobj)
{
    //EEcontext *ee = env.getEEcontext();

    //printf("Module.genobjfile(multiobj = %d) %s\n", multiobj, m.вТкст0());

    lastmname = m.srcfile.вТкст0();

    objmod.initfile(lastmname, null, m.toPrettyChars());

    eictor = null;
    ictorlocalgot = null;
    sctors.устДим(0);
    ectorgates.устДим(0);
    sdtors.устДим(0);
    ssharedctors.устДим(0);
    esharedctorgates.устДим(0);
    sshareddtors.устДим(0);
    stests.устДим(0);

    if (m.doppelganger)
    {
        /* Generate a reference to the moduleinfo, so the module constructors
         * and destructors get linked in.
         */
        Module mod = m.aimports[0];
        assert(mod);
        if (mod.sictor || mod.sctor || mod.sdtor || mod.ssharedctor || mod.sshareddtor)
        {
            Symbol *s = toSymbol(mod);
            //objextern(s);
            //if (!s.Sxtrnnum) objextdef(s.Sident);
            if (!s.Sxtrnnum)
            {
                //printf("%s\n", s.Sident);
//#if 0 /* This should work, but causes optlink to fail in common/newlib.asm */
//                objextdef(s.Sident);
//#else
                Symbol *sref = symbol_generate(SCstatic, type_fake(TYnptr));
                sref.Sfl = FLdata;
                auto dtb = DtBuilder(0);
                dtb.xoff(s, 0, TYnptr);
                sref.Sdt = dtb.finish();
                outdata(sref);
//#endif
            }
        }
    }

    if (глоб2.парамы.cov)
    {
        /* Create coverage идентификатор:
         *  бцел[numlines] __coverage;
         */
        m.cov = toSymbolX(m, "__coverage", SCstatic, type_fake(TYint), "Z");
        m.cov.Sflags |= SFLhidden;
        m.cov.Stype.Tmangle = mTYman_d;
        m.cov.Sfl = FLdata;

        auto dtb = DtBuilder(0);
        dtb.nzeros(4 * m.numlines);
        m.cov.Sdt = dtb.finish();

        outdata(m.cov);

        m.covb = cast(бцел *)calloc((m.numlines + 32) / 32, (*m.covb).sizeof);
    }

    for (цел i = 0; i < m.члены.dim; i++)
    {
        auto member = (*m.члены)[i];
        //printf("toObjFile %s %s\n", member.вид(), member.вТкст0());
        toObjFile(member, multiobj);
    }

    if (глоб2.парамы.cov)
    {
        /* Generate
         *  private bit[numlines] __bcoverage;
         */
        Symbol *bcov = symbol_calloc("__bcoverage");
        bcov.Stype = type_fake(TYuint);
        bcov.Stype.Tcount++;
        bcov.Sclass = SCstatic;
        bcov.Sfl = FLdata;

        auto dtb = DtBuilder(0);
        dtb.члобайт((m.numlines + 32) / 32 * (*m.covb).sizeof, cast(сим *)m.covb);
        bcov.Sdt = dtb.finish();

        outdata(bcov);

        free(m.covb);
        m.covb = null;

        /* Generate:
         *  _d_cover_register(бцел[] __coverage, МассивБит __bcoverage, ткст имяф);
         * and prepend it to the static constructor.
         */

        /* t will be the тип of the functions generated:
         *      extern (C) проц func();
         */
        тип *t = type_function(TYnfunc, null, нет, tstypes[TYvoid]);
        t.Tmangle = mTYman_c;

        m.sictor = toSymbolX(m, "__modictor", SCglobal, t, "FZv");
        cstate.CSpsymtab = &m.sictor.Sfunc.Flocsym;
        localgot = ictorlocalgot;

        elem *ecov  = el_pair(TYdarray, el_long(TYт_мера, m.numlines), el_ptr(m.cov));
        elem *ebcov = el_pair(TYdarray, el_long(TYт_мера, m.numlines), el_ptr(bcov));

        if (config.exe == EX_WIN64)
        {
            ecov  = addressElem(ecov,  Тип.tvoid.arrayOf(), нет);
            ebcov = addressElem(ebcov, Тип.tvoid.arrayOf(), нет);
        }

        elem *efilename = toEfilename(m);
        if (config.exe == EX_WIN64)
            efilename = addressElem(efilename, Тип.tstring, да);

        elem *e = el_params(
                      el_long(TYuchar, глоб2.парамы.covPercent),
                      ecov,
                      ebcov,
                      efilename,
                      null);
        e = el_bin(OPcall, TYvoid, el_var(getRtlsym(RTLSYM_DCOVER2)), e);
        eictor = el_combine(e, eictor);
        ictorlocalgot = localgot;
    }

    // If coverage / static constructor / destructor / unittest calls
    if (eictor || sctors.dim || ectorgates.dim || sdtors.dim ||
        ssharedctors.dim || esharedctorgates.dim || sshareddtors.dim || stests.dim)
    {
        if (eictor)
        {
            localgot = ictorlocalgot;

            block *b = block_calloc();
            b.BC = BCret;
            b.Belem = eictor;
            m.sictor.Sfunc.Fstartline.Sfilename = m.arg.xarraydup.ptr;
            m.sictor.Sfunc.Fstartblock = b;
            writefunc(m.sictor);
        }

        m.sctor = callFuncsAndGates(m, &sctors, &ectorgates, "__modctor");
        m.sdtor = callFuncsAndGates(m, &sdtors, null, "__moddtor");

        m.ssharedctor = callFuncsAndGates(m, &ssharedctors, cast(StaticDtorDeclarations *)&esharedctorgates, "__modsharedctor");
        m.sshareddtor = callFuncsAndGates(m, &sshareddtors, null, "__modshareddtor");
        m.stest = callFuncsAndGates(m, &stests, null, "__modtest");

        if (m.doppelganger)
            genModuleInfo(m);
    }

    if (m.doppelganger)
    {
        objc.generateModuleInfo(m);
        objmod.termfile();
        return;
    }

     /* Generate module info for templates and -cov.
     *  Don't generate ModuleInfo if `объект.ModuleInfo` is not declared or
     *  explicitly disabled through compiler switches such as `-betterC`.
     */
    if (глоб2.парамы.useModuleInfo && Module.moduleinfo /*|| needModuleInfo()*/)
        genModuleInfo(m);

    objmod.termfile();
}



/**************************************
 * Search for a druntime массив op
 */
private бул isDruntimeArrayOp(Идентификатор2 идент)
{
    /* Some of the массив op functions are written as library functions,
     * presumably to optimize them with special CPU vector instructions.
     * List those library functions here, in alpha order.
     */
     сим*[143] libArrayopFuncs =
    [
        "_arrayExpSliceAddass_a",
        "_arrayExpSliceAddass_d",
        "_arrayExpSliceAddass_f",           // T[]+=T
        "_arrayExpSliceAddass_g",
        "_arrayExpSliceAddass_h",
        "_arrayExpSliceAddass_i",
        "_arrayExpSliceAddass_k",
        "_arrayExpSliceAddass_s",
        "_arrayExpSliceAddass_t",
        "_arrayExpSliceAddass_u",
        "_arrayExpSliceAddass_w",

        "_arrayExpSliceDivass_d",           // T[]/=T
        "_arrayExpSliceDivass_f",           // T[]/=T

        "_arrayExpSliceMinSliceAssign_a",
        "_arrayExpSliceMinSliceAssign_d",   // T[]=T-T[]
        "_arrayExpSliceMinSliceAssign_f",   // T[]=T-T[]
        "_arrayExpSliceMinSliceAssign_g",
        "_arrayExpSliceMinSliceAssign_h",
        "_arrayExpSliceMinSliceAssign_i",
        "_arrayExpSliceMinSliceAssign_k",
        "_arrayExpSliceMinSliceAssign_s",
        "_arrayExpSliceMinSliceAssign_t",
        "_arrayExpSliceMinSliceAssign_u",
        "_arrayExpSliceMinSliceAssign_w",

        "_arrayExpSliceMinass_a",
        "_arrayExpSliceMinass_d",           // T[]-=T
        "_arrayExpSliceMinass_f",           // T[]-=T
        "_arrayExpSliceMinass_g",
        "_arrayExpSliceMinass_h",
        "_arrayExpSliceMinass_i",
        "_arrayExpSliceMinass_k",
        "_arrayExpSliceMinass_s",
        "_arrayExpSliceMinass_t",
        "_arrayExpSliceMinass_u",
        "_arrayExpSliceMinass_w",

        "_arrayExpSliceMulass_d",           // T[]*=T
        "_arrayExpSliceMulass_f",           // T[]*=T
        "_arrayExpSliceMulass_i",
        "_arrayExpSliceMulass_k",
        "_arrayExpSliceMulass_s",
        "_arrayExpSliceMulass_t",
        "_arrayExpSliceMulass_u",
        "_arrayExpSliceMulass_w",

        "_arraySliceExpAddSliceAssign_a",
        "_arraySliceExpAddSliceAssign_d",   // T[]=T[]+T
        "_arraySliceExpAddSliceAssign_f",   // T[]=T[]+T
        "_arraySliceExpAddSliceAssign_g",
        "_arraySliceExpAddSliceAssign_h",
        "_arraySliceExpAddSliceAssign_i",
        "_arraySliceExpAddSliceAssign_k",
        "_arraySliceExpAddSliceAssign_s",
        "_arraySliceExpAddSliceAssign_t",
        "_arraySliceExpAddSliceAssign_u",
        "_arraySliceExpAddSliceAssign_w",

        "_arraySliceExpDivSliceAssign_d",   // T[]=T[]/T
        "_arraySliceExpDivSliceAssign_f",   // T[]=T[]/T

        "_arraySliceExpMinSliceAssign_a",
        "_arraySliceExpMinSliceAssign_d",   // T[]=T[]-T
        "_arraySliceExpMinSliceAssign_f",   // T[]=T[]-T
        "_arraySliceExpMinSliceAssign_g",
        "_arraySliceExpMinSliceAssign_h",
        "_arraySliceExpMinSliceAssign_i",
        "_arraySliceExpMinSliceAssign_k",
        "_arraySliceExpMinSliceAssign_s",
        "_arraySliceExpMinSliceAssign_t",
        "_arraySliceExpMinSliceAssign_u",
        "_arraySliceExpMinSliceAssign_w",

        "_arraySliceExpMulSliceAddass_d",   // T[] += T[]*T
        "_arraySliceExpMulSliceAddass_f",
        "_arraySliceExpMulSliceAddass_r",

        "_arraySliceExpMulSliceAssign_d",   // T[]=T[]*T
        "_arraySliceExpMulSliceAssign_f",   // T[]=T[]*T
        "_arraySliceExpMulSliceAssign_i",
        "_arraySliceExpMulSliceAssign_k",
        "_arraySliceExpMulSliceAssign_s",
        "_arraySliceExpMulSliceAssign_t",
        "_arraySliceExpMulSliceAssign_u",
        "_arraySliceExpMulSliceAssign_w",

        "_arraySliceExpMulSliceMinass_d",   // T[] -= T[]*T
        "_arraySliceExpMulSliceMinass_f",
        "_arraySliceExpMulSliceMinass_r",

        "_arraySliceSliceAddSliceAssign_a",
        "_arraySliceSliceAddSliceAssign_d", // T[]=T[]+T[]
        "_arraySliceSliceAddSliceAssign_f", // T[]=T[]+T[]
        "_arraySliceSliceAddSliceAssign_g",
        "_arraySliceSliceAddSliceAssign_h",
        "_arraySliceSliceAddSliceAssign_i",
        "_arraySliceSliceAddSliceAssign_k",
        "_arraySliceSliceAddSliceAssign_r", // T[]=T[]+T[]
        "_arraySliceSliceAddSliceAssign_s",
        "_arraySliceSliceAddSliceAssign_t",
        "_arraySliceSliceAddSliceAssign_u",
        "_arraySliceSliceAddSliceAssign_w",

        "_arraySliceSliceAddass_a",
        "_arraySliceSliceAddass_d",         // T[]+=T[]
        "_arraySliceSliceAddass_f",         // T[]+=T[]
        "_arraySliceSliceAddass_g",
        "_arraySliceSliceAddass_h",
        "_arraySliceSliceAddass_i",
        "_arraySliceSliceAddass_k",
        "_arraySliceSliceAddass_s",
        "_arraySliceSliceAddass_t",
        "_arraySliceSliceAddass_u",
        "_arraySliceSliceAddass_w",

        "_arraySliceSliceMinSliceAssign_a",
        "_arraySliceSliceMinSliceAssign_d", // T[]=T[]-T[]
        "_arraySliceSliceMinSliceAssign_f", // T[]=T[]-T[]
        "_arraySliceSliceMinSliceAssign_g",
        "_arraySliceSliceMinSliceAssign_h",
        "_arraySliceSliceMinSliceAssign_i",
        "_arraySliceSliceMinSliceAssign_k",
        "_arraySliceSliceMinSliceAssign_r", // T[]=T[]-T[]
        "_arraySliceSliceMinSliceAssign_s",
        "_arraySliceSliceMinSliceAssign_t",
        "_arraySliceSliceMinSliceAssign_u",
        "_arraySliceSliceMinSliceAssign_w",

        "_arraySliceSliceMinass_a",
        "_arraySliceSliceMinass_d",         // T[]-=T[]
        "_arraySliceSliceMinass_f",         // T[]-=T[]
        "_arraySliceSliceMinass_g",
        "_arraySliceSliceMinass_h",
        "_arraySliceSliceMinass_i",
        "_arraySliceSliceMinass_k",
        "_arraySliceSliceMinass_s",
        "_arraySliceSliceMinass_t",
        "_arraySliceSliceMinass_u",
        "_arraySliceSliceMinass_w",

        "_arraySliceSliceMulSliceAssign_d", // T[]=T[]*T[]
        "_arraySliceSliceMulSliceAssign_f", // T[]=T[]*T[]
        "_arraySliceSliceMulSliceAssign_i",
        "_arraySliceSliceMulSliceAssign_k",
        "_arraySliceSliceMulSliceAssign_s",
        "_arraySliceSliceMulSliceAssign_t",
        "_arraySliceSliceMulSliceAssign_u",
        "_arraySliceSliceMulSliceAssign_w",

        "_arraySliceSliceMulass_d",         // T[]*=T[]
        "_arraySliceSliceMulass_f",         // T[]*=T[]
        "_arraySliceSliceMulass_i",
        "_arraySliceSliceMulass_k",
        "_arraySliceSliceMulass_s",
        "_arraySliceSliceMulass_t",
        "_arraySliceSliceMulass_u",
        "_arraySliceSliceMulass_w",
    ];
    ткст0 имя = идент.вТкст0();
    цел i = binary(имя, libArrayopFuncs.ptr, libArrayopFuncs.length);
    if (i != -1)
        return да;

    debug    // Make sure our массив is alphabetized
    {
        foreach (s; libArrayopFuncs)
        {
            if (strcmp(имя, s) == 0)
                assert(0);
        }
    }
    return нет;
}


/* ================================================================== */

private UnitTestDeclaration needsDeferredNested(FuncDeclaration fd)
{
    while (fd && fd.isNested())
    {
        FuncDeclaration fdp = fd.toParent2().isFuncDeclaration();
        if (!fdp)
            break;
        if (UnitTestDeclaration udp = fdp.isUnitTestDeclaration())
            return udp.semanticRun < PASS.obj ? udp : null;
        fd = fdp;
    }
    return null;
}


проц FuncDeclaration_toObjFile(FuncDeclaration fd, бул multiobj)
{
    ClassDeclaration cd = fd.родитель.isClassDeclaration();
    //printf("FuncDeclaration.toObjFile(%p, %s.%s)\n", fd, fd.родитель.вТкст0(), fd.вТкст0());

    //if (тип) printf("тип = %s\n", тип.вТкст0());
    version (none)
    {
        //printf("line = %d\n", getWhere() / LINEINC);
        EEcontext *ee = env.getEEcontext();
        if (ee.EEcompile == 2)
        {
            if (ee.EElinnum < (getWhere() / LINEINC) ||
                ee.EElinnum > (endwhere / LINEINC)
               )
                return;             // don't compile this function
            ee.EEfunc = toSymbol(this);
        }
    }

    if (fd.semanticRun >= PASS.obj) // if toObjFile() already run
        return;

    if (fd.тип && fd.тип.ty == Tfunction && (cast(TypeFunction)fd.тип).следщ is null)
        return;

    // If errors occurred compiling it, such as https://issues.dlang.org/show_bug.cgi?ид=6118
    if (fd.тип && fd.тип.ty == Tfunction && (cast(TypeFunction)fd.тип).следщ.ty == Terror)
        return;

    if (fd.semantic3Errors)
        return;

    if (глоб2.errors)
        return;

    if (!fd.fbody)
        return;

    UnitTestDeclaration ud = fd.isUnitTestDeclaration();
    if (ud && !глоб2.парамы.useUnitTests)
        return;

    if (multiobj && !fd.isStaticDtorDeclaration() && !fd.isStaticCtorDeclaration() && !fd.isCrtCtorDtor)
    {
        obj_append(fd);
        return;
    }

    if (fd.semanticRun == PASS.semanticdone)
    {
        /* What happened is this function failed semantic3() with errors,
         * but the errors were gagged.
         * Try to reproduce those errors, and then fail.
         */
        fd.выведиОшибку("errors compiling the function");
        return;
    }
    assert(fd.semanticRun == PASS.semantic3done);
    assert(fd.идент != Id.empty);

    for (FuncDeclaration fd2 = fd; fd2; )
    {
        if (fd2.inNonRoot())
            return;
        if (fd2.isNested())
            fd2 = fd2.toParent2().isFuncDeclaration();
        else
            break;
    }

    if (UnitTestDeclaration udp = needsDeferredNested(fd))
    {
        /* Can't do unittest's out of order, they are order dependent in that their
         * execution is done in lexical order.
         */
        udp.deferredNested.сунь(fd);
        //printf("%s @[%s]\n\t-. pushed to unittest @[%s]\n",
        //    fd.toPrettyChars(), fd.место.вТкст0(), udp.место.вТкст0());
        return;
    }

    if (fd.isArrayOp && isDruntimeArrayOp(fd.идент))
    {
        // Implementation is in druntime
        return;
    }

    // start code generation
    fd.semanticRun = PASS.obj;

    if (глоб2.парамы.verbose)
        message("function  %s", fd.toPrettyChars());

    Symbol *s = toSymbol(fd);
    func_t *f = s.Sfunc;

    // tunnel тип of "this" to debug info generation
    if (AggregateDeclaration ad = fd.родитель.isAggregateDeclaration())
    {
        .тип* t = Type_toCtype(ad.getType());
        if (cd)
            t = t.Tnext; // skip reference
        f.Fclass = cast(Classsym *)t;
    }

    /* This is done so that the 'this' pointer on the stack is the same
     * distance away from the function parameters, so that an overriding
     * function can call the nested fdensure or fdrequire of its overridden function
     * and the stack offsets are the same.
     */
    if (fd.isVirtual() && (fd.fensure || fd.frequire))
        f.Fflags3 |= Ffakeeh;

    if (fd.eh_none)
        // Same as config.ehmethod==EH_NONE, but only for this function
        f.Fflags3 |= Feh_none;

    s.Sclass = глоб2.парамы.isOSX ? SCcomdat : SCglobal;
    for (ДСимвол p = fd.родитель; p; p = p.родитель)
    {
        if (p.isTemplateInstance())
        {
            // functions without D or C++ имя mangling mixed in at глоб2 scope
            // shouldn't have multiple definitions
            if (p.isTemplateMixin() && (fd.компонаж == LINK.c || fd.компонаж == LINK.windows ||
                fd.компонаж == LINK.pascal || fd.компонаж == LINK.objc))
            {
                const q = p.toParent();
                if (q && q.isModule())
                {
                    s.Sclass = SCglobal;
                    break;
                }
            }
            s.Sclass = SCcomdat;
            break;
        }
    }

    /* Vector operations should be comdat's
     */
    if (fd.isArrayOp)
        s.Sclass = SCcomdat;

    if (fd.inlinedNestedCallees)
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=15333
         * If fd содержит inlined Выражения that come from
         * nested function bodies, the enclosing of the functions must be
         * generated first, in order to calculate correct frame pointer смещение.
         */
        foreach (fdc; *fd.inlinedNestedCallees)
        {
            FuncDeclaration fp = fdc.toParent2().isFuncDeclaration();
            if (fp && fp.semanticRun < PASS.obj)
            {
                toObjFile(fp, multiobj);
            }
        }
    }

    if (fd.isNested())
    {
        //if (!(config.flags3 & CFG3pic))
        //    s.Sclass = SCstatic;
        f.Fflags3 |= Fnested;

        /* The enclosing function must have its code generated first,
         * in order to calculate correct frame pointer смещение.
         */
        FuncDeclaration fdp = fd.toParent2().isFuncDeclaration();
        if (fdp && fdp.semanticRun < PASS.obj)
        {
            toObjFile(fdp, multiobj);
        }
    }
    else
    {
        specialFunctions(objmod, fd);
    }

    symtab_t *symtabsave = cstate.CSpsymtab;
    cstate.CSpsymtab = &f.Flocsym;

    // Find module m for this function
    Module m = null;
    for (ДСимвол p = fd.родитель; p; p = p.родитель)
    {
        m = p.isModule();
        if (m)
            break;
    }

    Дсимволы deferToObj;                   // пиши these to OBJ файл later
    МассивДРК!(elem*) varsInScope;
    Label*[ук] labels = null;
    IRState irs = IRState(m, fd, &varsInScope, &deferToObj, &labels, &глоб2.парамы);

    Symbol *shidden = null;
    Symbol *sthis = null;
    tym_t tyf = tybasic(s.Stype.Tty);
    //printf("компонаж = %d, tyf = x%x\n", компонаж, tyf);
    цел reverse = tyrevfunc(s.Stype.Tty);

    assert(fd.тип.ty == Tfunction);
    TypeFunction tf = cast(TypeFunction)fd.тип;
    RET retmethod = retStyle(tf, fd.needThis());
    if (retmethod == RET.stack)
    {
        // If function returns a struct, put a pointer to that
        // as the first argument
        .тип *thidden = Type_toCtype(tf.следщ.pointerTo());
        сим[5+4+1] hiddenparam = проц;
         цел hiddenparami;    // how many we've generated so far

        ткст0 имя;
        if (fd.nrvo_can && fd.nrvo_var)
            имя = fd.nrvo_var.идент.вТкст0();
        else
        {
            sprintf(hiddenparam.ptr, "__HID%d", ++hiddenparami);
            имя = hiddenparam.ptr;
        }
        shidden = symbol_name(имя, SCparameter, thidden);
        shidden.Sflags |= SFLtrue | SFLfree;
        if (fd.nrvo_can && fd.nrvo_var && fd.nrvo_var.nestedrefs.dim)
            type_setcv(&shidden.Stype, shidden.Stype.Tty | mTYvolatile);
        irs.shidden = shidden;
        fd.shidden = shidden;
    }
    else
    {
        // Register return style cannot make nrvo.
        // Auto functions keep the nrvo_can флаг up to here,
        // so we should eliminate it before entering backend.
        fd.nrvo_can = 0;
    }

    if (fd.vthis)
    {
        assert(!fd.vthis.csym);
        sthis = toSymbol(fd.vthis);
        sthis.Stype = getParentClosureType(sthis, fd);
        irs.sthis = sthis;
        if (!(f.Fflags3 & Fnested))
            f.Fflags3 |= Fmember;
    }

    // Estimate number of parameters, pi
    т_мера pi = (fd.v_arguments !is null);
    if (fd.parameters)
        pi += fd.parameters.dim;
    if (fd.selector)
        pi++; // Extra argument for Objective-C selector
    // Create a temporary буфер, парамы[], to hold function parameters
    Symbol*[10] paramsbuf = проц;
    Symbol **парамы = paramsbuf.ptr;    // размести on stack if possible
    if (pi + 2 > paramsbuf.length)      // allow extra 2 for sthis and shidden
    {
        парамы = cast(Symbol **)Пам.check(malloc((pi + 2) * (Symbol *).sizeof));
    }

    // Get the actual number of parameters, pi, and fill in the парамы[]
    pi = 0;
    if (fd.v_arguments)
    {
        парамы[pi] = toSymbol(fd.v_arguments);
        pi += 1;
    }
    if (fd.parameters)
    {
        foreach (i, v; *fd.parameters)
        {
            //printf("param[%d] = %p, %s\n", i, v, v.вТкст0());
            assert(!v.csym);
            парамы[pi + i] = toSymbol(v);
        }
        pi += fd.parameters.dim;
    }

    if (reverse)
    {
        // Reverse парамы[] entries
        foreach (i, sptmp; парамы[0 .. pi/2])
        {
            парамы[i] = парамы[pi - 1 - i];
            парамы[pi - 1 - i] = sptmp;
        }
    }

    if (shidden)
    {
        // shidden becomes last параметр
        //парамы[pi] = shidden;

        // shidden becomes first параметр
        memmove(парамы + 1, парамы, pi * (парамы[0]).sizeof);
        парамы[0] = shidden;

        pi++;
    }

    pi = objc.addSelectorParameterSymbol(fd, парамы, pi);

    if (sthis)
    {
        // sthis becomes last параметр
        //парамы[pi] = sthis;

        // sthis becomes first параметр
        memmove(парамы + 1, парамы, pi * (парамы[0]).sizeof);
        парамы[0] = sthis;

        pi++;
    }

    if (target.isPOSIX && fd.компонаж != LINK.d && shidden && sthis)
    {
        /* swap shidden and sthis
         */
        Symbol *sp = парамы[0];
        парамы[0] = парамы[1];
        парамы[1] = sp;
    }

    foreach (sp; парамы[0 .. pi])
    {
        sp.Sclass = SCparameter;
        sp.Sflags &= ~SFLspill;
        sp.Sfl = FLpara;
        symbol_add(sp);
    }

    // Determine register assignments
    if (pi)
    {
        FuncParamRegs fpr = FuncParamRegs.создай(tyf);

        foreach (sp; парамы[0 .. pi])
        {
            if (fpr.alloc(sp.Stype, sp.Stype.Tty, &sp.Spreg, &sp.Spreg2))
            {
                sp.Sclass = (config.exe == EX_WIN64) ? SCshadowreg : SCfastpar;
                sp.Sfl = (sp.Sclass == SCshadowreg) ? FLpara : FLfast;
            }
        }
    }

    // Done with парамы
    if (парамы != paramsbuf.ptr)
        free(парамы);
    парамы = null;

    localgot = null;

    Инструкция2 sbody = fd.fbody;

    Blockx bx;
    bx.startblock = block_calloc();
    bx.curblock = bx.startblock;
    bx.funcsym = s;
    bx.scope_index = -1;
    bx.classdec = cast(ук)cd;
    bx.member = cast(ук)fd;
    bx._module = cast(ук)fd.getModule();
    irs.blx = &bx;

    // Initialize argptr
    if (fd.v_argptr)
    {
        // Declare va_argsave
        if (глоб2.парамы.is64bit &&
            !глоб2.парамы.isWindows)
        {
            тип *t = type_struct_class("__va_argsave_t", 16, 8 * 6 + 8 * 16 + 8 * 3, null, null, нет, нет, да, нет);
            // The backend will pick this up by имя
            Symbol *sv = symbol_name("__va_argsave", SCauto, t);
            sv.Stype.Tty |= mTYvolatile;
            symbol_add(sv);
        }

        Symbol *sa = toSymbol(fd.v_argptr);
        symbol_add(sa);
        elem *e = el_una(OPva_start, TYnptr, el_ptr(sa));
        block_appendexp(irs.blx.curblock, e);
    }

    /* Doing this in semantic3() caused all kinds of problems:
     * 1. couldn't reliably get the final mangling of the function имя due to fwd refs
     * 2. impact on function inlining
     * 3. what to do when writing out .di files, or other pretty printing
     */
    if (глоб2.парамы.trace && !fd.isCMain() && !fd.naked)
    {
        /* The profiler requires TLS, and TLS may not be set up yet when C main()
         * gets control (i.e. OSX), leading to a crash.
         */
        /* Wrap the entire function body in:
         *   trace_pro("funcname");
         *   try
         *     body;
         *   finally
         *     _c_trace_epi();
         */
        StringExp se = StringExp.создай(Место.initial, s.Sident.ptr);
        se.тип = Тип.tstring;
        se.тип = se.тип.typeSemantic(Место.initial, null);
        Выражения *exps = new Выражения();
        exps.сунь(se);
        FuncDeclaration fdpro = FuncDeclaration.genCfunc(null, Тип.tvoid, "trace_pro");
        Выражение ec = VarExp.создай(Место.initial, fdpro);
        Выражение e = CallExp.создай(Место.initial, ec, exps);
        e.тип = Тип.tvoid;
        Инструкция2 sp = ExpStatement.создай(fd.место, e);

        FuncDeclaration fdepi = FuncDeclaration.genCfunc(null, Тип.tvoid, "_c_trace_epi");
        ec = VarExp.создай(Место.initial, fdepi);
        e = CallExp.создай(Место.initial, ec);
        e.тип = Тип.tvoid;
        Инструкция2 sf = ExpStatement.создай(fd.место, e);

        Инструкция2 stf;
        if (sbody.blockExit(fd, нет) == BE.fallthru)
            stf = CompoundStatement.создай(Место.initial, sbody, sf);
        else
            stf = TryFinallyStatement.создай(Место.initial, sbody, sf);
        sbody = CompoundStatement.создай(Место.initial, sp, stf);
    }

    if (fd.interfaceVirtual)
    {
        // Adjust the 'this' pointer instead of using a thunk
        assert(irs.sthis);
        elem *ethis = el_var(irs.sthis);
        ethis = fixEthis2(ethis, fd);
        elem *e = el_bin(OPminass, TYnptr, ethis, el_long(TYт_мера, fd.interfaceVirtual.смещение));
        block_appendexp(irs.blx.curblock, e);
    }

    buildClosure(fd, &irs);

    if (config.ehmethod == EHmethod.EH_WIN32 && fd.isSynchronized() && cd &&
        !fd.isStatic() && !sbody.usesEH() && !глоб2.парамы.trace)
    {
        /* The "jmonitor" hack uses an optimized exception handling frame
         * which is a little shorter than the more general EH frame.
         */
        s.Sfunc.Fflags3 |= Fjmonitor;
    }

    Statement_toIR(sbody, &irs);

    if (глоб2.errors)
    {
        // Restore symbol table
        cstate.CSpsymtab = symtabsave;
        return;
    }

    bx.curblock.BC = BCret;

    f.Fstartblock = bx.startblock;
//  einit = el_combine(einit,bx.init);

    if (fd.isCtorDeclaration())
    {
        assert(sthis);
        foreach (b; BlockRange(f.Fstartblock))
        {
            if (b.BC == BCret)
            {
                elem *ethis = el_var(sthis);
                ethis = fixEthis2(ethis, fd);
                b.BC = BCretexp;
                b.Belem = el_combine(b.Belem, ethis);
            }
        }
    }
    if (config.ehmethod == EHmethod.EH_NONE || f.Fflags3 & Feh_none)
        insertFinallyBlockGotos(f.Fstartblock);
    else if (config.ehmethod == EHmethod.EH_DWARF)
        insertFinallyBlockCalls(f.Fstartblock);

    // If static constructor
    if (fd.isSharedStaticCtorDeclaration())        // must come first because it derives from StaticCtorDeclaration
    {
        ssharedctors.сунь(s);
    }
    else if (fd.isStaticCtorDeclaration())
    {
        sctors.сунь(s);
    }

    // If static destructor
    if (fd.isSharedStaticDtorDeclaration())        // must come first because it derives from StaticDtorDeclaration
    {
        SharedStaticDtorDeclaration fs = fd.isSharedStaticDtorDeclaration();
        assert(fs);
        if (fs.vgate)
        {
            /* Increment destructor's vgate at construction time
             */
            esharedctorgates.сунь(fs);
        }

        sshareddtors.shift(s);
    }
    else if (fd.isStaticDtorDeclaration())
    {
        StaticDtorDeclaration fs = fd.isStaticDtorDeclaration();
        assert(fs);
        if (fs.vgate)
        {
            /* Increment destructor's vgate at construction time
             */
            ectorgates.сунь(fs);
        }

        sdtors.shift(s);
    }

    // If unit test
    if (ud)
    {
        stests.сунь(s);
    }

    if (глоб2.errors)
    {
        // Restore symbol table
        cstate.CSpsymtab = symtabsave;
        return;
    }

    writefunc(s);

    buildCapture(fd);

    // Restore symbol table
    cstate.CSpsymtab = symtabsave;

    if (fd.isExport())
        objmod.export_symbol(s, cast(бцел)Para.смещение);

    if (fd.isCrtCtorDtor & 1)
        objmod.setModuleCtorDtor(s, да);
    if (fd.isCrtCtorDtor & 2)
        objmod.setModuleCtorDtor(s, нет);

    foreach (sd; *irs.deferToObj)
    {
        toObjFile(sd, нет);
    }

    if (ud)
    {
        foreach (fdn; ud.deferredNested)
        {
            toObjFile(fdn, нет);
        }
    }

    if (irs.startaddress)
    {
        //printf("Setting start address\n");
        objmod.startaddress(irs.startaddress);
    }
}


/*******************************************
 * Detect special functions like `main()` and do special handling for them,
 * like special mangling, including libraries, setting the storage class, etc.
 * `objmod` and `fd` are updated.
 *
 * Параметры:
 *      objmod = объект module
 *      fd = function symbol
 */
private проц specialFunctions(Obj objmod, FuncDeclaration fd)
{
    const libname = глоб2.finalDefaultlibname();

    Symbol* s = fd.toSymbol();  // backend symbol corresponding to fd

    // Pull in RTL startup code (but only once)
    if (fd.isMain() && onlyOneMain(fd.место))
    {
        if (target.isPOSIX)
        {
            objmod.external_def("_main");
        }
        else if (глоб2.парамы.mscoff)
        {
            objmod.external_def("main");
        }
        else if (config.exe == EX_WIN32)
        {
            objmod.external_def("_main");
            objmod.external_def("__acrtused_con");
        }
        if (libname)
            obj_includelib(libname);
        s.Sclass = SCglobal;
    }
    else if (fd.isRtInit())
    {
        if (target.isPOSIX || глоб2.парамы.mscoff)
        {
            objmod.ehsections();   // initialize exception handling sections
        }
    }
    else if (fd.isCMain())
    {
        if (глоб2.парамы.mscoff)
        {
            if (глоб2.парамы.mscrtlib.length && глоб2.парамы.mscrtlib[0])
                obj_includelib(глоб2.парамы.mscrtlib);
            objmod.includelib("OLDNAMES");
        }
        else if (config.exe == EX_WIN32)
        {
            objmod.external_def("__acrtused_con");        // bring in C startup code
            objmod.includelib("snn.lib");          // bring in C runtime library
        }
        s.Sclass = SCglobal;
    }
    else if (глоб2.парамы.isWindows && fd.isWinMain() && onlyOneMain(fd.место))
    {
        if (глоб2.парамы.mscoff)
        {
            objmod.includelib("uuid");
            if (глоб2.парамы.mscrtlib.length && глоб2.парамы.mscrtlib[0])
                obj_includelib(глоб2.парамы.mscrtlib);
            objmod.includelib("OLDNAMES");
        }
        else
        {
            objmod.external_def("__acrtused");
        }
        if (libname)
            obj_includelib(libname);
        s.Sclass = SCglobal;
    }

    // Pull in RTL startup code
    else if (глоб2.парамы.isWindows && fd.isDllMain() && onlyOneMain(fd.место))
    {
        if (глоб2.парамы.mscoff)
        {
            objmod.includelib("uuid");
            if (глоб2.парамы.mscrtlib.length && глоб2.парамы.mscrtlib[0])
                obj_includelib(глоб2.парамы.mscrtlib);
            objmod.includelib("OLDNAMES");
        }
        else
        {
            objmod.external_def("__acrtused_dll");
        }
        if (libname)
            obj_includelib(libname);
        s.Sclass = SCglobal;
    }
}


private бул onlyOneMain(Место место)
{
     Место lastLoc;
     бул hasMain = нет;
    if (hasMain)
    {
        ткст0 msg = "";
        if (глоб2.парамы.addMain)
            msg = ", -main switch added another `main()`";
        ткст0 otherMainNames = "";
        if (config.exe == EX_WIN32 || config.exe == EX_WIN64)
            otherMainNames = ", `WinMain`, or `DllMain`";
        выведиОшибку(место, "only one `main`%s allowed%s. Previously found `main` at %s",
            otherMainNames, msg, lastLoc.вТкст0());
        return нет;
    }
    lastLoc = место;
    hasMain = да;
    return да;
}

/* ================================================================== */

/*****************************
 * Return back end тип corresponding to D front end тип.
 */

tym_t totym(Тип tx)
{
    tym_t t;
    switch (tx.ty)
    {
        case Tvoid:     t = TYvoid;     break;
        case Tint8:     t = TYschar;    break;
        case Tuns8:     t = TYuchar;    break;
        case Tint16:    t = TYshort;    break;
        case Tuns16:    t = TYushort;   break;
        case Tint32:    t = TYint;      break;
        case Tuns32:    t = TYuint;     break;
        case Tint64:    t = TYllong;    break;
        case Tuns64:    t = TYullong;   break;
        case Tfloat32:  t = TYfloat;    break;
        case Tfloat64:  t = TYdouble;   break;
        case Tfloat80:  t = TYldouble;  break;
        case Timaginary32: t = TYifloat; break;
        case Timaginary64: t = TYidouble; break;
        case Timaginary80: t = TYildouble; break;
        case Tcomplex32: t = TYcfloat;  break;
        case Tcomplex64: t = TYcdouble; break;
        case Tcomplex80: t = TYcldouble; break;
        case Tbool:     t = TYбул;     break;
        case Tchar:     t = TYchar;     break;
        case Twchar:    t = TYwchar_t;  break;
        case Tdchar:
            t = (глоб2.парамы.symdebug == 1 || !глоб2.парамы.isWindows) ? TYdchar : TYulong;
            break;

        case Taarray:   t = TYaarray;   break;
        case Tclass:
        case Treference:
        case Tpointer:  t = TYnptr;     break;
        case Tdelegate: t = TYdelegate; break;
        case Tarray:    t = TYdarray;   break;
        case Tsarray:   t = TYstruct;   break;

        case Tstruct:
            t = TYstruct;
            break;

        case Tenum:
        {
            Тип tb = tx.toBasetype();
            const ид = tx.toDsymbol(null).идент;
            if (ид == Id.__c_long)
                t = tb.ty == Tint32 ? TYlong : TYllong;
            else if (ид == Id.__c_ulong)
                t = tb.ty == Tuns32 ? TYulong : TYullong;
            else if (ид == Id.__c_long_double)
                t = TYdouble;
            else
                t = totym(tb);
            break;
        }

        case Tident:
        case Ttypeof:
        case Tmixin:
            //printf("ty = %d, '%s'\n", tx.ty, tx.вТкст0());
            выведиОшибку(Место.initial, "forward reference of `%s`", tx.вТкст0());
            t = TYint;
            break;

        case Tnull:
            t = TYnptr;
            break;

        case Tvector:
        {
            auto tv = cast(TypeVector)tx;
            const tb = tv.elementType();
            const s32 = tv.alignsize() == 32;   // if 32 byte, 256 bit vector
            switch (tb.ty)
            {
                case Tvoid:
                case Tint8:     t = s32 ? TYschar32  : TYschar16;  break;
                case Tuns8:     t = s32 ? TYuchar32  : TYuchar16;  break;
                case Tint16:    t = s32 ? TYshort16  : TYshort8;   break;
                case Tuns16:    t = s32 ? TYushort16 : TYushort8;  break;
                case Tint32:    t = s32 ? TYlong8    : TYlong4;    break;
                case Tuns32:    t = s32 ? TYulong8   : TYulong4;   break;
                case Tint64:    t = s32 ? TYllong4   : TYllong2;   break;
                case Tuns64:    t = s32 ? TYullong4  : TYullong2;  break;
                case Tfloat32:  t = s32 ? TYfloat8   : TYfloat4;   break;
                case Tfloat64:  t = s32 ? TYdouble4  : TYdouble2;  break;
                default:
                    assert(0);
            }
            break;
        }

        case Tfunction:
        {
            auto tf = cast(TypeFunction)tx;
            switch (tf.компонаж)
            {
                case LINK.windows:
                    if (глоб2.парамы.is64bit)
                        goto case LINK.c;
                    t = (tf.parameterList.varargs == ВарАрг.variadic) ? TYnfunc : TYnsfunc;
                    break;

                case LINK.pascal:
                    t = (tf.parameterList.varargs == ВарАрг.variadic) ? TYnfunc : TYnpfunc;
                    break;

                case LINK.c:
                case LINK.cpp:
                case LINK.objc:
                    t = TYnfunc;
                    if (глоб2.парамы.isWindows)
                    {
                    }
                    else if (!глоб2.парамы.is64bit && retStyle(tf, нет) == RET.stack)
                        t = TYhfunc;
                    break;

                case LINK.d:
                    t = (tf.parameterList.varargs == ВарАрг.variadic) ? TYnfunc : TYjfunc;
                    break;

                case LINK.default_:
                case LINK.system:
                    printf("компонаж = %d\n", tf.компонаж);
                    assert(0);
            }
            if (tf.isnothrow)
                t |= mTYnothrow;
            return t;
        }
        default:
            //printf("ty = %d, '%s'\n", tx.ty, tx.вТкст0());
            assert(0);
    }

    t |= modToTym(tx.mod);    // Add modifiers

    return t;
}

/**************************************
 */

Symbol *toSymbol(Тип t)
{
    if (t.ty == Tclass)
    {
        return toSymbol((cast(TypeClass)t).sym);
    }
    assert(0);
}

/*******************************************
 * Generate readonly symbol that consists of a bunch of zeros.
 * Immutable Symbol instances can be mapped over it.
 * Only one is generated per объект файл.
 * Возвращает:
 *    bzero symbol
 */
Symbol* getBzeroSymbol()
{
    Symbol* s = bzeroSymbol;
    if (s)
        return s;

    s = symbol_calloc("__bzeroBytes");
    s.Stype = type_static_array(128, type_fake(TYuchar));
    s.Stype.Tmangle = mTYman_c;
    s.Stype.Tcount++;
    s.Sclass = SCglobal;
    s.Sfl = FLdata;
    s.Sflags |= SFLnodebug;
    s.Salignment = 16;

    auto dtb = DtBuilder(0);
    dtb.nzeros(128);
    s.Sdt = dtb.finish();
    dt2common(&s.Sdt);

    outdata(s);

    bzeroSymbol = s;
    return s;
}



/**************************************
 * Generate elem that is a dynamic массив slice of the module файл имя.
 */

private elem *toEfilename(Module m)
{
    //printf("toEfilename(%s)\n", m.вТкст0());
    ткст0 ид = m.srcfile.вТкст0();
    т_мера len = strlen(ид);

    if (!m.sfilename)
    {
        // Put out as a static массив
        m.sfilename = вТкстSymbol(ид, len, 1);
    }

    // Turn static массив into dynamic массив
    return el_pair(TYdarray, el_long(TYт_мера, len), el_ptr(m.sfilename));
}

// Used in e2ir.d
elem *toEfilenamePtr(Module m)
{
    //printf("toEfilenamePtr(%s)\n", m.вТкст0());
    ткст0 ид = m.srcfile.вТкст0();
    т_мера len = strlen(ид);
    Symbol* s = вТкстSymbol(ид, len, 1);
    return el_ptr(s);
}
