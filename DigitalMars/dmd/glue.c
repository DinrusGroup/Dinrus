
// Compiler implementation of the D programming language
// Copyright (c) 1999-2013 by Digital Mars
// All Rights Reserved
// written by Walter Bright
// http://www.digitalmars.com

#include <stdio.h>
#include <stddef.h>
#include <time.h>
#include <assert.h>

#include "mars.h"
#include "module.h"
#include "mtype.h"
#include "declaration.h"
#include "statement.h"
#include "enum.h"
#include "aggregate.h"
#include "init.h"
#include "attrib.h"
#include "id.h"
#include "import.h"
#include "template.h"
#include "lib.h"
#include "target.h"

#include "rmem.h"
#include "cc.h"
#include "global.h"
#include "oper.h"
#include "code.h"
#include "type.h"
#include "dt.h"
#include "cgcv.h"
#include "outbuf.h"
#include "irstate.h"

void slist_add(Symbol *s);
void slist_reset();
void clearStringTab();

elem *addressElem(elem *e, Type *t, bool alwaysCopy = false);

#define STATICCTOR      0

typedef Array<symbol> symbols;

elem *eictor;
symbol *ictorlocalgot;
symbols sctors;
StaticDtorDeclarations ectorgates;
symbols sdtors;
symbols stests;

symbols ssharedctors;
SharedStaticDtorDeclarations esharedctorgates;
symbols sshareddtors;

int dtorcount;
int shareddtorcount;

char *lastmname;

bool onlyOneMain(Loc loc);

/**************************************
 * Append s to list of object files to generate later.
 */

Dsymbols obj_symbols_towrite;

void obj_append(Dsymbol *s)
{
    //printf("deferred: %s\n", s->toChars());
    obj_symbols_towrite.push(s);
}

void obj_write_deferred(Library *library)
{
    for (size_t i = 0; i < obj_symbols_towrite.dim; i++)
    {   Dsymbol *s = obj_symbols_towrite[i];
        Module *m = s->getModule();

        char *mname;
        if (m)
        {   mname = m->srcfile->toChars();
            lastmname = mname;
        }
        else
        {
            //mname = s->ident->toChars();
            mname = lastmname;
            assert(mname);
        }

        obj_start(mname);

        static int count;
        count++;                // sequence for generating names

        /* Create a module that's a doppelganger of m, with just
         * enough to be able to create the moduleinfo.
         */
        OutBuffer idbuf;
        idbuf.printf("%s.%d", m ? m->ident->toChars() : mname, count);
        char *idstr = idbuf.toChars();

        if(!m)
        {
            // it doesn't make sense to make up a module if we don't know where to put the symbol
            //  so output it into it's own object file without ModuleInfo
            objmod->initfile(idstr, NULL, mname);
            s->toObjFile(0);
            objmod->termfile();
        }
        else
        {
            idbuf.data = NULL;
            Identifier *id = new Identifier(idstr, TOKidentifier);

            Module *md = new Module(mname, id, 0, 0);
            md->members = new Dsymbols();
            md->members->push(s);   // its only 'member' is s
            md->doppelganger = 1;       // identify this module as doppelganger
            md->md = m->md;
            md->aimports.push(m);       // it only 'imports' m
            md->massert = m->massert;
            md->munittest = m->munittest;
            md->marray = m->marray;

            md->genobjfile(0);
        }

        /* Set object file name to be source name with sequence number,
         * as mangled symbol names get way too long.
         */
        const char *fname = FileName::removeExt(mname);
        OutBuffer namebuf;
        unsigned hash = 0;
        for (char *p = s->toChars(); *p; p++)
            hash += *p;
        namebuf.printf("%s_%x_%x.%s", fname, count, hash, global.obj_ext);
        namebuf.writeByte(0);
        FileName::free((char *)fname);
        fname = (char *)namebuf.extractData();

        //printf("writing '%s'\n", fname);
        File *objfile = new File(fname);
        obj_end(library, objfile);
    }
    obj_symbols_towrite.dim = 0;
}

/***********************************************
 * Generate function that calls array of functions and gates.
 */

symbol *callFuncsAndGates(Module *m, symbols *sctors, StaticDtorDeclarations *ectorgates,
        const char *id)
{
    symbol *sctor = NULL;

    if ((sctors && sctors->dim) ||
        (ectorgates && ectorgates->dim))
    {
        static type *t;
        if (!t)
        {
            /* t will be the type of the functions generated:
             *      extern (C) void func();
             */
            t = type_function(TYnfunc, NULL, 0, false, tsvoid);
            t->Tmangle = mTYman_c;
        }

        localgot = NULL;
        sctor = m->toSymbolX(id, SCglobal, t, "FZv");
        cstate.CSpsymtab = &sctor->Sfunc->Flocsym;
        elem *ector = NULL;

        if (ectorgates)
        {
            for (size_t i = 0; i < ectorgates->dim; i++)
            {   StaticDtorDeclaration *f = (*ectorgates)[i];

                Symbol *s = f->vgate->toSymbol();
                elem *e = el_var(s);
                e = el_bin(OPaddass, TYint, e, el_long(TYint, 1));
                ector = el_combine(ector, e);
            }
        }

        if (sctors)
        {
            for (size_t i = 0; i < sctors->dim; i++)
            {   symbol *s = (*sctors)[i];
                elem *e = el_una(OPucall, TYvoid, el_var(s));
                ector = el_combine(ector, e);
            }
        }

        block *b = block_calloc();
        b->BC = BCret;
        b->Belem = ector;
        sctor->Sfunc->Fstartline.Sfilename = m->arg;
        sctor->Sfunc->Fstartblock = b;
        writefunc(sctor);
    }
    return sctor;
}

/**************************************
 * Prepare for generating obj file.
 */

Outbuffer objbuf;

void obj_start(char *srcfile)
{
    //printf("obj_start()\n");

    rtlsym_reset();
    slist_reset();
    clearStringTab();

#if TARGET_WINDOS
    // Produce Ms COFF files for 64 bit code, OMF for 32 bit code
    assert(objbuf.size() == 0);
    objmod = global.params.is64bit == 1 ? MsCoffObj::init(&objbuf, srcfile, NULL)
                                        :       Obj::init(&objbuf, srcfile, NULL);
#else
    objmod = Obj::init(&objbuf, srcfile, NULL);
#endif

    el_reset();
#if TX86
    cg87_reset();
#endif
    out_reset();
}

void obj_end(Library *library, File *objfile)
{
    const char *objfilename = objfile->name->toChars();
    objmod->term(objfilename);
    delete objmod;
    objmod = NULL;

    if (library)
    {
        // Transfer image to library
        library->addObject(objfilename, objbuf.buf, objbuf.p - objbuf.buf);
        objbuf.buf = NULL;
    }
    else
    {
        // Transfer image to file
        objfile->setbuffer(objbuf.buf, objbuf.p - objbuf.buf);
        objbuf.buf = NULL;

        FileName::ensurePathToNameExists(objfilename);

        //printf("write obj %s\n", objfilename);
        objfile->writev();
    }
    objbuf.pend = NULL;
    objbuf.p = NULL;
    objbuf.len = 0;
    objbuf.inc = 0;
}

bool obj_includelib(const char *name)
{
    return objmod->includelib(name);
}

void obj_startaddress(Symbol *s)
{
    return objmod->startaddress(s);
}


/**************************************
 * Generate .obj file for Module.
 */

void Module::genobjfile(int multiobj)
{
    //EEcontext *ee = env->getEEcontext();

    //printf("Module::genobjfile(multiobj = %d) %s\n", multiobj, toChars());

    if (ident == Id::entrypoint)
    {
        char v = global.params.verbose;
        global.params.verbose = 0;

        for (size_t i = 0; i < members->dim; i++)
        {
            Dsymbol *member = (*members)[i];
            //printf("toObjFile %s %s\n", member->kind(), member->toChars());
            member->toObjFile(global.params.multiobj);
        }

        global.params.verbose = v;
        return;
    }

    lastmname = srcfile->toChars();

    objmod->initfile(lastmname, NULL, toPrettyChars());

    eictor = NULL;
    ictorlocalgot = NULL;
    sctors.setDim(0);
    ectorgates.setDim(0);
    sdtors.setDim(0);
    ssharedctors.setDim(0);
    esharedctorgates.setDim(0);
    sshareddtors.setDim(0);
    stests.setDim(0);
    dtorcount = 0;
    shareddtorcount = 0;

    if (doppelganger)
    {
        /* Generate a reference to the moduleinfo, so the module constructors
         * and destructors get linked in.
         */
        Module *m = aimports[0];
        assert(m);
        if (m->sictor || m->sctor || m->sdtor || m->ssharedctor || m->sshareddtor)
        {
            Symbol *s = m->toSymbol();
            //objextern(s);
            //if (!s->Sxtrnnum) objextdef(s->Sident);
            if (!s->Sxtrnnum)
            {
                //printf("%s\n", s->Sident);
#if 0 /* This should work, but causes optlink to fail in common/newlib.asm */
                objextdef(s->Sident);
#else
                Symbol *sref = symbol_generate(SCstatic, type_fake(TYnptr));
                sref->Sfl = FLdata;
                dtxoff(&sref->Sdt, s, 0, TYnptr);
                outdata(sref);
#endif
            }
        }
    }

    if (global.params.cov)
    {
        /* Create coverage identifier:
         *  private uint[numlines] __coverage;
         */
        cov = symbol_calloc("__coverage");
        cov->Stype = type_fake(TYint);
        cov->Stype->Tmangle = mTYman_c;
        cov->Stype->Tcount++;
        cov->Sclass = SCstatic;
        cov->Sfl = FLdata;
        dtnzeros(&cov->Sdt, 4 * numlines);
        outdata(cov);
        slist_add(cov);

        covb = (unsigned *)calloc((numlines + 32) / 32, sizeof(*covb));
    }

    for (size_t i = 0; i < members->dim; i++)
    {
        Dsymbol *member = (*members)[i];
        //printf("toObjFile %s %s\n", member->kind(), member->toChars());
        member->toObjFile(multiobj);
    }

    if (global.params.cov)
    {
        /* Generate
         *      bit[numlines] __bcoverage;
         */
        Symbol *bcov = symbol_calloc("__bcoverage");
        bcov->Stype = type_fake(TYuint);
        bcov->Stype->Tcount++;
        bcov->Sclass = SCstatic;
        bcov->Sfl = FLdata;
        dtnbytes(&bcov->Sdt, (numlines + 32) / 32 * sizeof(*covb), (char *)covb);
        outdata(bcov);

        free(covb);
        covb = NULL;

        /* Generate:
         *  _d_cover_register(uint[] __coverage, BitArray __bcoverage, string filename);
         * and prepend it to the static constructor.
         */

        /* t will be the type of the functions generated:
         *      extern (C) void func();
         */
        type *t = type_function(TYnfunc, NULL, 0, false, tsvoid);
        t->Tmangle = mTYman_c;

        sictor = toSymbolX("__modictor", SCglobal, t, "FZv");
        cstate.CSpsymtab = &sictor->Sfunc->Flocsym;
        localgot = ictorlocalgot;

        elem *ecov  = el_pair(TYdarray, el_long(TYsize_t, numlines), el_ptr(cov));
        elem *ebcov = el_pair(TYdarray, el_long(TYsize_t, numlines), el_ptr(bcov));

        if (config.exe == EX_WIN64)
        {
            ecov  = addressElem(ecov,  Type::tvoid->arrayOf(), false);
            ebcov = addressElem(ebcov, Type::tvoid->arrayOf(), false);
        }

        elem *e = el_params(
                      el_long(TYuchar, global.params.covPercent),
                      ecov,
                      ebcov,
                      toEfilename(),
                      NULL);
        e = el_bin(OPcall, TYvoid, el_var(rtlsym[RTLSYM_DCOVER2]), e);
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
            b->BC = BCret;
            b->Belem = eictor;
            sictor->Sfunc->Fstartline.Sfilename = arg;
            sictor->Sfunc->Fstartblock = b;
            writefunc(sictor);
        }

        sctor = callFuncsAndGates(this, &sctors, &ectorgates, "__modctor");
        sdtor = callFuncsAndGates(this, &sdtors, NULL, "__moddtor");

#if DMDV2
        ssharedctor = callFuncsAndGates(this, &ssharedctors, (StaticDtorDeclarations *)&esharedctorgates, "__modsharedctor");
        sshareddtor = callFuncsAndGates(this, &sshareddtors, NULL, "__modshareddtor");
#endif
        stest = callFuncsAndGates(this, &stests, NULL, "__modtest");

        if (doppelganger)
            genmoduleinfo();
    }

    if (doppelganger)
    {
        objmod->termfile();
        return;
    }

    if (global.params.multiobj)
    {   /* This is necessary because the main .obj for this module is written
         * first, but determining whether marray or massert or munittest are needed is done
         * possibly later in the doppelganger modules.
         * Another way to fix it is do the main one last.
         */
        toModuleAssert();
        toModuleUnittest();
        toModuleArray();
    }

    /* Always generate module info, because of templates and -cov.
     * But module info needs the runtime library, so disable it for betterC.
     */
    if (!global.params.betterC /*|| needModuleInfo()*/)
        genmoduleinfo();

    // If module assert
    for (int i = 0; i < 3; i++)
    {
        Symbol *ma;
        unsigned rt;
        unsigned bc;
        switch (i)
        {
            case 0:     ma = marray;    rt = RTLSYM_DARRAY;     bc = BCexit; break;
            case 1:     ma = massert;   rt = RTLSYM_DASSERTM;   bc = BCexit; break;
            case 2:     ma = munittest; rt = RTLSYM_DUNITTESTM; bc = BCret;  break;
            default:    assert(0);
        }

        if (ma)
        {
            elem *elinnum;

            localgot = NULL;

            // Call dassert(filename, line)
            // Get sole parameter, linnum
            {
                Symbol *sp = symbol_calloc("linnum");
                sp->Stype = type_fake(TYint);
                sp->Stype->Tcount++;
                sp->Sclass = (config.exe == EX_WIN64) ? SCshadowreg : SCfastpar;

                FuncParamRegs fpr(TYjfunc);
                fpr.alloc(sp->Stype, sp->Stype->Tty, &sp->Spreg, &sp->Spreg2);

                sp->Sflags &= ~SFLspill;
                sp->Sfl = (sp->Sclass == SCshadowreg) ? FLpara : FLfast;
                cstate.CSpsymtab = &ma->Sfunc->Flocsym;
                symbol_add(sp);

                elinnum = el_var(sp);
            }

            elem *efilename = el_ptr(toSymbol());

            elem *e = el_var(rtlsym[rt]);
            e = el_bin(OPcall, TYvoid, e, el_param(elinnum, efilename));

            block *b = block_calloc();
            b->BC = bc;
            b->Belem = e;
            ma->Sfunc->Fstartline.Sfilename = arg;
            ma->Sfunc->Fstartblock = b;
            ma->Sclass = SCglobal;
            ma->Sfl = 0;
            ma->Sflags |= rtlsym[rt]->Sflags & SFLexit;
            writefunc(ma);
        }
    }

    objmod->termfile();
}


/* ================================================================== */

void FuncDeclaration::toObjFile(int multiobj)
{
    FuncDeclaration *func = this;
    ClassDeclaration *cd = func->parent->isClassDeclaration();
    int reverse;
    int has_arguments;

    //printf("FuncDeclaration::toObjFile(%p, %s.%s)\n", func, parent->toChars(), func->toChars());

    //if (type) printf("type = %s\n", func->type->toChars());
#if 0
    //printf("line = %d\n",func->getWhere() / LINEINC);
    EEcontext *ee = env->getEEcontext();
    if (ee->EEcompile == 2)
    {
        if (ee->EElinnum < (func->getWhere() / LINEINC) ||
            ee->EElinnum > (func->endwhere / LINEINC)
           )
            return;             // don't compile this function
        ee->EEfunc = func->toSymbol();
    }
#endif

    if (semanticRun >= PASSobj) // if toObjFile() already run
        return;

    // If errors occurred compiling it, such as bugzilla 6118
    if (type && type->ty == Tfunction && ((TypeFunction *)type)->next->ty == Terror)
        return;

    if (global.errors)
        return;

    if (!func->fbody)
    {
        return;
    }
    if (func->isUnitTestDeclaration() && !global.params.useUnitTests)
        return;

    if (multiobj && !isStaticDtorDeclaration() && !isStaticCtorDeclaration())
    {   obj_append(this);
        return;
    }

    if (semanticRun == PASSsemanticdone)
    {
        /* What happened is this function failed semantic3() with errors,
         * but the errors were gagged.
         * Try to reproduce those errors, and then fail.
         */
        error("errors compiling the function");
        return;
    }
    assert(semanticRun == PASSsemantic3done);
    assert(ident != Id::empty);

    /* Skip generating code if this part of a TemplateInstance that is instantiated
     * only by non-root modules (i.e. modules not listed on the command line).
     */
    TemplateInstance *ti = inTemplateInstance();
    if (!global.params.useUnitTests &&
        !global.params.allInst &&
        /* The issue is that if the importee is compiled with a different -debug
         * setting than the importer, the importer may believe it exists
         * in the compiled importee when it does not, when the instantiation
         * is behind a conditional debug declaration.
         */
        !global.params.debuglevel &&     // workaround for Bugzilla 11239
        ti && ti->instantiatingModule && !ti->instantiatingModule->isRoot())
    {
        Module *mi = ti->instantiatingModule;

        // If mi imports any root modules, we still need to generate the code.
        for (size_t i = 0; i < Module::amodules.dim; ++i)
        {
            Module *m = Module::amodules[i];
            m->insearch = 0;
        }
        bool importsRoot = false;
        for (size_t i = 0; i < Module::amodules.dim; ++i)
        {
            Module *m = Module::amodules[i];
            if (m->isRoot() && mi->imports(m))
            {
                importsRoot = true;
                break;
            }
        }
        for (size_t i = 0; i < Module::amodules.dim; ++i)
        {
            Module *m = Module::amodules[i];
            m->insearch = 0;
        }
        if (!importsRoot)
        {
            //printf("instantiated by %s   %s\n", ti->instantiatingModule->toChars(), ti->toChars());
            return;
        }
    }

    // start code generation
    semanticRun = PASSobj;

    if (global.params.verbose)
        fprintf(global.stdmsg, "function  %s\n",func->toPrettyChars());

    Symbol *s = func->toSymbol();
    func_t *f = s->Sfunc;

    // tunnel type of "this" to debug info generation
    if (AggregateDeclaration* ad = func->parent->isAggregateDeclaration())
    {
        ::type* t = ad->getType()->toCtype();
        if(cd)
            t = t->Tnext; // skip reference
        f->Fclass = (Classsym *)t;
    }

#if TARGET_WINDOS
    /* This is done so that the 'this' pointer on the stack is the same
     * distance away from the function parameters, so that an overriding
     * function can call the nested fdensure or fdrequire of its overridden function
     * and the stack offsets are the same.
     */
    if (isVirtual() && (fensure || frequire))
        f->Fflags3 |= Ffakeeh;
#endif

#if TARGET_OSX
    s->Sclass = SCcomdat;
#else
    s->Sclass = SCglobal;
#endif
    for (Dsymbol *p = parent; p; p = p->parent)
    {
        if (p->isTemplateInstance())
        {
            s->Sclass = SCcomdat;
            break;
        }
    }

    /* Vector operations should be comdat's
     */
    if (isArrayOp)
        s->Sclass = SCcomdat;

    if (isNested())
    {
//      if (!(config.flags3 & CFG3pic))
//          s->Sclass = SCstatic;
        f->Fflags3 |= Fnested;

        /* The enclosing function must have its code generated first,
         * so we know things like where its local symbols are stored.
         */
        FuncDeclaration *fdp = toAliasFunc()->toParent2()->isFuncDeclaration();
        // Bug 8016 - only include the function if it is a template instance
        Dsymbol * owner = NULL;
        if (fdp)
        {   owner =  fdp->toParent();
            while (owner && !owner->isTemplateInstance())
                owner = owner->toParent();
        }

        if (owner && fdp && fdp->semanticRun == PASSsemantic3done &&
            !fdp->isUnitTestDeclaration())
        {
            /* Can't do unittest's out of order, they are order dependent in that their
             * execution is done in lexical order, and some modules (std.datetime *cough*
             * *cough*) rely on this.
             */
            fdp->toObjFile(multiobj);
        }
    }
    else
    {
        const char *libname = (global.params.symdebug)
                                ? global.params.debuglibname
                                : global.params.defaultlibname;

        // Pull in RTL startup code (but only once)
        if (func->isMain() && onlyOneMain(loc))
        {
#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_SOLARIS
            objmod->external_def("_main");
            objmod->ehsections();   // initialize exception handling sections
#endif
#if TARGET_WINDOS
            if (I64)
            {
                objmod->external_def("main");
                objmod->ehsections();   // initialize exception handling sections
            }
            else
            {
                objmod->external_def("_main");
                objmod->external_def("__acrtused_con");
            }
#endif
            objmod->includelib(libname);
            s->Sclass = SCglobal;
        }
        else if (strcmp(s->Sident, "main") == 0 && linkage == LINKc)
        {
#if TARGET_WINDOS
            if (I64)
            {
                objmod->includelib("LIBCMT");
                objmod->includelib("OLDNAMES");
            }
            else
            {
                objmod->external_def("__acrtused_con");        // bring in C startup code
                objmod->includelib("snn.lib");          // bring in C runtime library
            }
#endif
            s->Sclass = SCglobal;
        }
#if TARGET_WINDOS
        else if (func->isWinMain() && onlyOneMain(loc))
        {
            if (I64)
            {
                objmod->includelib("uuid");
                objmod->includelib("LIBCMT");
                objmod->includelib("OLDNAMES");
                objmod->ehsections();   // initialize exception handling sections
            }
            else
            {
                objmod->external_def("__acrtused");
            }
            objmod->includelib(libname);
            s->Sclass = SCglobal;
        }

        // Pull in RTL startup code
        else if (func->isDllMain() && onlyOneMain(loc))
        {
            if (I64)
            {
                objmod->includelib("uuid");
                objmod->includelib("LIBCMT");
                objmod->includelib("OLDNAMES");
                objmod->ehsections();   // initialize exception handling sections
            }
            else
            {
                objmod->external_def("__acrtused_dll");
            }
            objmod->includelib(libname);
            s->Sclass = SCglobal;
        }
#endif
    }

    cstate.CSpsymtab = &f->Flocsym;

    // Find module m for this function
    Module *m = NULL;
    for (Dsymbol *p = parent; p; p = p->parent)
    {
        m = p->isModule();
        if (m)
            break;
    }

    IRState irs(m, func);
    Dsymbols deferToObj;                   // write these to OBJ file later
    irs.deferToObj = &deferToObj;

    TypeFunction *tf;
    RET retmethod;
    symbol *shidden = NULL;
    Symbol *sthis = NULL;
    tym_t tyf;

    tyf = tybasic(s->Stype->Tty);
    //printf("linkage = %d, tyf = x%x\n", linkage, tyf);
    reverse = tyrevfunc(s->Stype->Tty);

    assert(func->type->ty == Tfunction);
    tf = (TypeFunction *)(func->type);
    has_arguments = (tf->linkage == LINKd) && (tf->varargs == 1);
    retmethod = tf->retStyle();
    if (retmethod == RETstack)
    {
        // If function returns a struct, put a pointer to that
        // as the first argument
        ::type *thidden = tf->next->pointerTo()->toCtype();
        char hiddenparam[5+4+1];
        static int hiddenparami;    // how many we've generated so far

        sprintf(hiddenparam,"__HID%d",++hiddenparami);
        shidden = symbol_name(hiddenparam,SCparameter,thidden);
        shidden->Sflags |= SFLtrue | SFLfree;
#if DMDV1
        if (func->nrvo_can && func->nrvo_var && func->nrvo_var->nestedref)
#else
        if (func->nrvo_can && func->nrvo_var && func->nrvo_var->nestedrefs.dim)
#endif
            type_setcv(&shidden->Stype, shidden->Stype->Tty | mTYvolatile);
        irs.shidden = shidden;
        this->shidden = shidden;
    }
    else
    {   // Register return style cannot make nrvo.
        // Auto functions keep the nrvo_can flag up to here,
        // so we should eliminate it before entering backend.
        nrvo_can = 0;
    }

    if (vthis)
    {
        assert(!vthis->csym);
        sthis = vthis->toSymbol();
        irs.sthis = sthis;
        if (!(f->Fflags3 & Fnested))
            f->Fflags3 |= Fmember;
    }

    // Estimate number of parameters, pi
    size_t pi = (v_arguments != NULL);
    if (parameters)
        pi += parameters->dim;

    // Create a temporary buffer, params[], to hold function parameters
    Symbol *paramsbuf[10];
    Symbol **params = paramsbuf;    // allocate on stack if possible
    if (pi + 2 > 10)                // allow extra 2 for sthis and shidden
    {   params = (Symbol **)malloc((pi + 2) * sizeof(Symbol *));
        assert(params);
    }

    // Get the actual number of parameters, pi, and fill in the params[]
    pi = 0;
    if (v_arguments)
    {
        params[pi] = v_arguments->toSymbol();
        pi += 1;
    }
    if (parameters)
    {
        for (size_t i = 0; i < parameters->dim; i++)
        {
            VarDeclaration *v = (*parameters)[i];
            assert(!v->csym);
            params[pi + i] = v->toSymbol();
        }
        pi += parameters->dim;
    }

    if (reverse)
    {   // Reverse params[] entries
        for (size_t i = 0; i < pi/2; i++)
        {
            Symbol *sptmp = params[i];
            params[i] = params[pi - 1 - i];
            params[pi - 1 - i] = sptmp;
        }
    }

    if (shidden)
    {
#if 0
        // shidden becomes last parameter
        params[pi] = shidden;
#else
        // shidden becomes first parameter
        memmove(params + 1, params, pi * sizeof(params[0]));
        params[0] = shidden;
#endif
        pi++;
    }


    if (sthis)
    {
#if 0
        // sthis becomes last parameter
        params[pi] = sthis;
#else
        // sthis becomes first parameter
        memmove(params + 1, params, pi * sizeof(params[0]));
        params[0] = sthis;
#endif
        pi++;
    }

    if ((global.params.isLinux || global.params.isOSX || global.params.isFreeBSD || global.params.isSolaris) &&
         linkage != LINKd && shidden && sthis)
    {
        /* swap shidden and sthis
         */
        Symbol *sp = params[0];
        params[0] = params[1];
        params[1] = sp;
    }

    for (size_t i = 0; i < pi; i++)
    {   Symbol *sp = params[i];
        sp->Sclass = SCparameter;
        sp->Sflags &= ~SFLspill;
        sp->Sfl = FLpara;
        symbol_add(sp);
    }

    // Determine register assignments
    if (pi)
    {
        FuncParamRegs fpr(tyf);

        for (size_t i = 0; i < pi; i++)
        {   Symbol *sp = params[i];
            if (fpr.alloc(sp->Stype, sp->Stype->Tty, &sp->Spreg, &sp->Spreg2))
            {
                sp->Sclass = (config.exe == EX_WIN64) ? SCshadowreg : SCfastpar;
                sp->Sfl = (sp->Sclass == SCshadowreg) ? FLpara : FLfast;
            }
        }
    }

    // Done with params
    if (params != paramsbuf)
        free(params);
    params = NULL;

    if (func->fbody)
    {
        localgot = NULL;

        Statement *sbody = func->fbody;

        Blockx bx;
        memset(&bx,0,sizeof(bx));
        bx.startblock = block_calloc();
        bx.curblock = bx.startblock;
        bx.funcsym = s;
        bx.scope_index = -1;
        bx.classdec = cd;
        bx.member = func;
        bx.module = getModule();
        irs.blx = &bx;

        /* Doing this in semantic3() caused all kinds of problems:
         * 1. couldn't reliably get the final mangling of the function name due to fwd refs
         * 2. impact on function inlining
         * 3. what to do when writing out .di files, or other pretty printing
         */
        if (global.params.trace)
        {   /* Wrap the entire function body in:
             *   trace_pro("funcname");
             *   try
             *     body;
             *   finally
             *     _c_trace_epi();
             */
            StringExp *se = new StringExp(Loc(), s->Sident);
            se->type = new TypeDArray(Type::tchar->immutableOf());
            se->type = se->type->semantic(Loc(), NULL);
            Expressions *exps = new Expressions();
            exps->push(se);
            FuncDeclaration *fdpro = FuncDeclaration::genCfunc(NULL, Type::tvoid, "trace_pro");
            Expression *ec = new VarExp(Loc(), fdpro);
            Expression *e = new CallExp(Loc(), ec, exps);
            e->type = Type::tvoid;
            Statement *sp = new ExpStatement(loc, e);

            FuncDeclaration *fdepi = FuncDeclaration::genCfunc(NULL, Type::tvoid, "_c_trace_epi");
            ec = new VarExp(Loc(), fdepi);
            e = new CallExp(Loc(), ec);
            e->type = Type::tvoid;
            Statement *sf = new ExpStatement(loc, e);

            Statement *stf;
            if (sbody->blockExit(tf->isnothrow) == BEfallthru)
                stf = new CompoundStatement(Loc(), sbody, sf);
            else
                stf = new TryFinallyStatement(Loc(), sbody, sf);
            sbody = new CompoundStatement(Loc(), sp, stf);
        }

#if DMDV2
        buildClosure(&irs);
#endif

#if TARGET_WINDOS
        if (func->isSynchronized() && cd && config.flags2 & CFG2seh &&
            !func->isStatic() && !sbody->usesEH() && !global.params.trace)
        {
            /* The "jmonitor" hack uses an optimized exception handling frame
             * which is a little shorter than the more general EH frame.
             */
            s->Sfunc->Fflags3 |= Fjmonitor;
        }
#endif

        sbody->toIR(&irs);
        bx.curblock->BC = BCret;

        f->Fstartblock = bx.startblock;
//      einit = el_combine(einit,bx.init);

        if (isCtorDeclaration())
        {
            assert(sthis);
            for (block *b = f->Fstartblock; b; b = b->Bnext)
            {
                if (b->BC == BCret)
                {
                    b->BC = BCretexp;
                    b->Belem = el_combine(b->Belem, el_var(sthis));
                }
            }
        }
    }

    // If static constructor
#if DMDV2
    if (isSharedStaticCtorDeclaration())        // must come first because it derives from StaticCtorDeclaration
    {
        ssharedctors.push(s);
    }
    else
#endif
    if (isStaticCtorDeclaration())
    {
        sctors.push(s);
    }

    // If static destructor
#if DMDV2
    if (isSharedStaticDtorDeclaration())        // must come first because it derives from StaticDtorDeclaration
    {
        SharedStaticDtorDeclaration *f = isSharedStaticDtorDeclaration();
        assert(f);
        if (f->vgate)
        {   /* Increment destructor's vgate at construction time
             */
            esharedctorgates.push(f);
        }

        sshareddtors.shift(s);
    }
    else
#endif
    if (isStaticDtorDeclaration())
    {
        StaticDtorDeclaration *f = isStaticDtorDeclaration();
        assert(f);
        if (f->vgate)
        {   /* Increment destructor's vgate at construction time
             */
            ectorgates.push(f);
        }

        sdtors.shift(s);
    }

    // If unit test
    if (isUnitTestDeclaration())
    {
        stests.push(s);
    }

    if (global.errors)
        return;

    writefunc(s);
    if (isExport())
        objmod->export_symbol(s, Para.offset);

    for (size_t i = 0; i < irs.deferToObj->dim; i++)
    {
        Dsymbol *s = (*irs.deferToObj)[i];

        FuncDeclaration *fd = s->isFuncDeclaration();
        if (fd)
        {   FuncDeclaration *fdp = fd->toParent2()->isFuncDeclaration();
            if (fdp && fdp->semanticRun < PASSobj)
            {   /* Bugzilla 7595
                 * FuncDeclaration::buildClosure() relies on nested functions
                 * being toObjFile'd after the outer function. Otherwise, the
                 * v->offset's for the closure variables are wrong.
                 * So, defer fd until after fdp is done.
                 */
                fdp->deferred.push(fd);
                continue;
            }
        }

        s->toObjFile(0);
    }

    for (size_t i = 0; i < deferred.dim; i++)
    {
        FuncDeclaration *fd = deferred[i];
        fd->toObjFile(0);
    }

#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_SOLARIS
    // A hack to get a pointer to this function put in the .dtors segment
    if (ident && memcmp(ident->toChars(), "_STD", 4) == 0)
        objmod->staticdtor(s);
#endif
#if DMDV2
    if (irs.startaddress)
    {
        //printf("Setting start address\n");
        objmod->startaddress(irs.startaddress);
    }
#endif
}

bool onlyOneMain(Loc loc)
{
    static Loc lastLoc;
    static bool hasMain = false;
    if (hasMain)
    {
        const char *msg = NULL;
        if (global.params.addMain)
            msg = ", -main switch added another main()";
#if TARGET_WINDOS
        error(lastLoc, "only one main/WinMain/DllMain allowed%s", msg ? msg : "");
#else
        error(lastLoc, "only one main allowed%s", msg ? msg : "");
#endif
        return false;
    }
    lastLoc = loc;
    hasMain = true;
    return true;
}

/* ================================================================== */

/*****************************
 * Return back end type corresponding to D front end type.
 */

unsigned Type::totym()
{   unsigned t;

    switch (ty)
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
        case Tbool:     t = TYbool;     break;
        case Tchar:     t = TYchar;     break;
        case Twchar:    t = TYwchar_t;  break;
#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_SOLARIS
        case Tdchar:    t = TYdchar;    break;
#else
        case Tdchar:
                t = (global.params.symdebug == 1) ? TYdchar : TYulong;
                break;
#endif

        case Taarray:   t = TYaarray;   break;
        case Tclass:
        case Treference:
        case Tpointer:  t = TYnptr;     break;
        case Tdelegate: t = TYdelegate; break;
        case Tarray:    t = TYdarray;   break;
        case Tsarray:   t = TYstruct;   break;
        case Tstruct:   t = TYstruct;   break;

        case Tenum:
        case Ttypedef:
             t = toBasetype()->totym();
             break;

        case Tident:
        case Ttypeof:
#ifdef DEBUG
            printf("ty = %d, '%s'\n", ty, toChars());
#endif
            error(Loc(), "forward reference of %s", toChars());
            t = TYint;
            break;

        case Tnull:
            t = TYnptr;
            break;

        case Tvector:
        {   TypeVector *tv = (TypeVector *)this;
            TypeBasic *tb = tv->elementType();
            switch (tb->ty)
            {   case Tvoid:
                case Tint8:     t = TYschar16;  break;
                case Tuns8:     t = TYuchar16;  break;
                case Tint16:    t = TYshort8;   break;
                case Tuns16:    t = TYushort8;  break;
                case Tint32:    t = TYlong4;    break;
                case Tuns32:    t = TYulong4;   break;
                case Tint64:    t = TYllong2;   break;
                case Tuns64:    t = TYullong2;  break;
                case Tfloat32:  t = TYfloat4;   break;
                case Tfloat64:  t = TYdouble2;  break;
                default:
                    assert(0);
                    break;
            }
            static bool once = false;
            if (!once)
            {
                if (global.params.is64bit || global.params.isOSX)
                    ;
                else
                {   error(Loc(), "SIMD vector types not supported on this platform");
                    once = true;
                }
                if (tv->size(Loc()) == 32)
                {   error(Loc(), "AVX vector types not supported");
                    once = true;
                }
            }
            break;
        }

        default:
#ifdef DEBUG
            printf("ty = %d, '%s'\n", ty, toChars());
            halt();
#endif
            assert(0);
    }

#if DMDV2
    // Add modifiers
    switch (mod)
    {
        case 0:
            break;
        case MODconst:
        case MODwild:
            t |= mTYconst;
            break;
        case MODimmutable:
            t |= mTYimmutable;
            break;
        case MODshared:
            t |= mTYshared;
            break;
        case MODshared | MODwild:
        case MODshared | MODconst:
            t |= mTYshared | mTYconst;
            break;
        default:
            assert(0);
    }
#endif

    return t;
}

unsigned TypeFunction::totym()
{
    tym_t tyf;

    //printf("TypeFunction::totym(), linkage = %d\n", linkage);
    switch (linkage)
    {
        case LINKwindows:
            tyf = (varargs == 1) ? TYnfunc : TYnsfunc;
            break;

        case LINKpascal:
            tyf = (varargs == 1) ? TYnfunc : TYnpfunc;
            break;

        case LINKc:
        case LINKcpp:
            tyf = TYnfunc;
#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_SOLARIS
            if (I32 && retStyle() == RETstack)
                tyf = TYhfunc;
#endif
            break;

        case LINKd:
            tyf = (varargs == 1) ? TYnfunc : TYjfunc;
            break;

        default:
            printf("linkage = %d\n", linkage);
            assert(0);
    }
#if DMDV2
    if (isnothrow)
        tyf |= mTYnothrow;
#endif
    return tyf;
}

/**************************************
 */

Symbol *Type::toSymbol()
{
    assert(0);
    return NULL;
}

Symbol *TypeClass::toSymbol()
{
    return sym->toSymbol();
}

/**************************************
 * Generate elem that is a pointer to the module file name.
 */

elem *Module::toEfilename()
{   elem *efilename;

    if (!sfilename)
    {
        dt_t *dt = NULL;
        char *id = srcfile->toChars();
        size_t len = strlen(id);
        dtsize_t(&dt, len);
        dtabytes(&dt,TYnptr, 0, len + 1, id);

        sfilename = symbol_generate(SCstatic,type_fake(TYdarray));
        sfilename->Sdt = dt;
        sfilename->Sfl = FLdata;
        out_readonly(sfilename);
        outdata(sfilename);
    }

    efilename = (config.exe == EX_WIN64) ? el_ptr(sfilename) : el_var(sfilename);
    return efilename;
}


