/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/tocsym.d, _toobj.d)
 * Documentation:  https://dlang.org/phobos/dmd_toobj.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/toobj.d
 */

module dmd.toobj;

import cidrus;

import util.array;
import util.outbuffer;
import util.rmem;
import drc.ast.Node;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.glue;
import dmd.hdrgen;
import drc.lexer.Id;
import dmd.init;
import dmd.irstate;
import dmd.mtype;
import dmd.nspace;
import dmd.objc_glue;
import dmd.инструкция;
import dmd.staticassert;
import dmd.target;
import dmd.tocsym;
import dmd.toctype;
import dmd.tocvdebug;
import dmd.todt;
import drc.lexer.Tokens;
import dmd.traits;
import dmd.typinf;
import drc.ast.Visitor;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.cgcv;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.cv4;
import drc.backend.dt;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/

alias dmd.tocsym.toSymbol toSymbol;
alias dmd.glue.toSymbol toSymbol;


/* ================================================================== */

// Put out instance of ModuleInfo for this Module

проц genModuleInfo(Module m)
{
    //printf("Module.genmoduleinfo() %s\n", m.вТкст0());

    if (!Module.moduleinfo)
    {
        ObjectNotFound(Id.ModuleInfo);
    }

    Symbol *msym = toSymbol(m);

    //////////////////////////////////////////////

    m.csym.Sclass = SCglobal;
    m.csym.Sfl = FLdata;

    auto dtb = DtBuilder(0);
    ClassDeclarations aclasses;

    //printf("члены.dim = %d\n", члены.dim);
    foreach (i; new бцел[0 .. m.члены.dim])
    {
        ДСимвол member = (*m.члены)[i];

        //printf("\tmember '%s'\n", member.вТкст0());
        member.addLocalClass(&aclasses);
    }

    // importedModules[]
    т_мера aimports_dim = m.aimports.dim;
    for (т_мера i = 0; i < m.aimports.dim; i++)
    {
        Module mod = m.aimports[i];
        if (!mod.needmoduleinfo)
            aimports_dim--;
    }

    FuncDeclaration sgetmembers = m.findGetMembers();

    // These must match the values in druntime/src/object_.d
    enum
    {
        MIstandalone      = 0x4,
        MItlsctor         = 0x8,
        MItlsdtor         = 0x10,
        MIctor            = 0x20,
        MIdtor            = 0x40,
        MIxgetMembers     = 0x80,
        MIictor           = 0x100,
        MIunitTest        = 0x200,
        MIimportedModules = 0x400,
        MIlocalClasses    = 0x800,
        MIname            = 0x1000,
    }

    бцел flags = 0;
    if (!m.needmoduleinfo)
        flags |= MIstandalone;
    if (m.sctor)
        flags |= MItlsctor;
    if (m.sdtor)
        flags |= MItlsdtor;
    if (m.ssharedctor)
        flags |= MIctor;
    if (m.sshareddtor)
        flags |= MIdtor;
    if (sgetmembers)
        flags |= MIxgetMembers;
    if (m.sictor)
        flags |= MIictor;
    if (m.stest)
        flags |= MIunitTest;
    if (aimports_dim)
        flags |= MIimportedModules;
    if (aclasses.dim)
        flags |= MIlocalClasses;
    flags |= MIname;

    dtb.dword(flags);        // _flags
    dtb.dword(0);            // _index

    if (flags & MItlsctor)
        dtb.xoff(m.sctor, 0, TYnptr);
    if (flags & MItlsdtor)
        dtb.xoff(m.sdtor, 0, TYnptr);
    if (flags & MIctor)
        dtb.xoff(m.ssharedctor, 0, TYnptr);
    if (flags & MIdtor)
        dtb.xoff(m.sshareddtor, 0, TYnptr);
    if (flags & MIxgetMembers)
        dtb.xoff(toSymbol(sgetmembers), 0, TYnptr);
    if (flags & MIictor)
        dtb.xoff(m.sictor, 0, TYnptr);
    if (flags & MIunitTest)
        dtb.xoff(m.stest, 0, TYnptr);
    if (flags & MIimportedModules)
    {
        dtb.size(aimports_dim);
        foreach (i; new бцел[0 .. m.aimports.dim])
        {
            Module mod = m.aimports[i];

            if (!mod.needmoduleinfo)
                continue;

            Symbol *s = toSymbol(mod);

            /* Weak references don't pull objects in from the library,
             * they resolve to 0 if not pulled in by something else.
             * Don't pull in a module just because it was imported.
             */
            s.Sflags |= SFLweak;
            dtb.xoff(s, 0, TYnptr);
        }
    }
    if (flags & MIlocalClasses)
    {
        dtb.size(aclasses.dim);
        foreach (i; new бцел[0 .. aclasses.dim])
        {
            ClassDeclaration cd = aclasses[i];
            dtb.xoff(toSymbol(cd), 0, TYnptr);
        }
    }
    if (flags & MIname)
    {
        // Put out module имя as a 0-terminated ткст, to save bytes
        m.nameoffset = dtb.length();
        сим *имя = m.toPrettyChars();
        m.namelen = strlen(имя);
        dtb.члобайт(cast(бцел)m.namelen + 1, имя);
        //printf("nameoffset = x%x\n", nameoffset);
    }

    objc.generateModuleInfo(m);
    m.csym.Sdt = dtb.finish();
    out_readonly(m.csym);
    outdata(m.csym);

    //////////////////////////////////////////////

    objmod.moduleinfo(msym);
}

/*****************************************
 * пиши pointer references for typed данные to the объект файл
 * a class тип is considered to mean a reference to a class instance
 * Параметры:
 *      тип   = тип of the данные to check for pointers
 *      s      = symbol that содержит the данные
 *      смещение = смещение of the данные inside the Symbol's memory
 */
проц write_pointers(Тип тип, Symbol *s, бцел смещение)
{
    бцел ty = тип.toBasetype().ty;
    if (ty == Tclass)
        return objmod.write_pointerRef(s, смещение);

    write_instance_pointers(тип, s, смещение);
}

/*****************************************
* пиши pointer references for typed данные to the объект файл
* a class тип is considered to mean the instance, not a reference
* Параметры:
*      тип   = тип of the данные to check for pointers
*      s      = symbol that содержит the данные
*      смещение = смещение of the данные inside the Symbol's memory
*/
проц write_instance_pointers(Тип тип, Symbol *s, бцел смещение)
{
    if (!тип.hasPointers())
        return;

    МассивДРК!(d_uns64) данные;
    d_uns64 sz = getTypePointerBitmap(Место.initial, тип, &данные);
    if (sz == d_uns64.max)
        return;

    const bytes_т_мера = cast(т_мера)Тип.tт_мера.size(Место.initial);
    const bits_т_мера = bytes_т_мера * 8;
    auto words = cast(т_мера)(sz / bytes_т_мера);
    for (т_мера i = 0; i < данные.dim; i++)
    {
        т_мера bits = words < bits_т_мера ? words : bits_т_мера;
        for (т_мера b = 0; b < bits; b++)
            if (данные[i] & (1L << b))
            {
                auto off = cast(бцел) ((i * bits_т_мера + b) * bytes_т_мера);
                objmod.write_pointerRef(s, off + смещение);
            }
        words -= bits;
    }
}

/* ================================================================== */

проц toObjFile(ДСимвол ds, бул multiobj)
{
    //printf("toObjFile(%s)\n", ds.вТкст0());
     final class ToObjFile : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        бул multiobj;

        this(бул multiobj)
        {
            this.multiobj = multiobj;
        }

        проц visitNoMultiObj(ДСимвол ds)
        {
            бул multiobjsave = multiobj;
            multiobj = нет;
            ds.прими(this);
            multiobj = multiobjsave;
        }

        override проц посети(ДСимвол ds)
        {
            //printf("ДСимвол.toObjFile('%s')\n", ds.вТкст0());
            // ignore
        }

        override проц посети(FuncDeclaration fd)
        {
            // in glue.c
            FuncDeclaration_toObjFile(fd, multiobj);
        }

        override проц посети(ClassDeclaration cd)
        {
            //printf("ClassDeclaration.toObjFile('%s')\n", cd.вТкст0());

            if (cd.тип.ty == Terror)
            {
                cd.выведиОшибку("had semantic errors when compiling");
                return;
            }

            if (!cd.члены)
                return;

            if (multiobj && !cd.hasStaticCtorOrDtor())
            {
                obj_append(cd);
                return;
            }

            if (глоб2.парамы.symdebugref)
                Type_toCtype(cd.тип); // calls toDebug() only once
            else if (глоб2.парамы.symdebug)
                toDebug(cd);

            assert(cd.semanticRun >= PASS.semantic3done);     // semantic() should have been run to completion

            enum_SC scclass = SCcomdat;

            // Put out the члены
            /* There might be static ctors in the члены, and they cannot
             * be put in separate obj files.
             */
            cd.члены.foreachDsymbol( (s) { s.прими(this); } );

            if (cd.classKind == ClassKind.objc)
            {
                objc.toObjFile(cd);
                return;
            }

            // If something goes wrong during this pass don't bother with the
            // rest as we may have incomplete info
            // https://issues.dlang.org/show_bug.cgi?ид=17918
            if (!finishVtbl(cd))
            {
                return;
            }

            const бул gentypeinfo = глоб2.парамы.useTypeInfo && Тип.dtypeinfo;
            const бул genclassinfo = gentypeinfo || !(cd.isCPPclass || cd.isCOMclass);

            // Generate C symbols
            if (genclassinfo)
                toSymbol(cd);                           // __ClassZ symbol
            toVtblSymbol(cd);                           // __vtblZ symbol
            Symbol *sinit = toInitializer(cd);          // __initZ symbol

            //////////////////////////////////////////////

            // Generate static инициализатор
            {
                sinit.Sclass = scclass;
                sinit.Sfl = FLdata;
                auto dtb = DtBuilder(0);
                ClassDeclaration_toDt(cd, dtb);
                sinit.Sdt = dtb.finish();
                out_readonly(sinit);
                outdata(sinit);
            }

            //////////////////////////////////////////////

            // Put out the TypeInfo
            if (gentypeinfo)
                genTypeInfo(cd.место, cd.тип, null);
            //toObjFile(cd.тип.vtinfo, multiobj);

            if (genclassinfo)
            {
                genClassInfoForClass(cd, sinit);
            }

            //////////////////////////////////////////////

            // Put out the vtbl[]
            //printf("putting out %s.vtbl[]\n", вТкст0());
            auto dtbv = DtBuilder(0);
            if (cd.vtblOffset())
                dtbv.xoff(cd.csym, 0, TYnptr);           // first entry is ClassInfo reference
            foreach (i; new бцел[cd.vtblOffset() .. cd.vtbl.dim])
            {
                FuncDeclaration fd = cd.vtbl[i].isFuncDeclaration();

                //printf("\tvtbl[%d] = %p\n", i, fd);
                if (fd && (fd.fbody || !cd.isAbstract()))
                {
                    dtbv.xoff(toSymbol(fd), 0, TYnptr);
                }
                else
                    dtbv.size(0);
            }
            if (dtbv.isZeroLength())
            {
                /* Someone made an ' class C { }' with no virtual functions.
                 * But making an empty vtbl[] causes linking problems, so make a dummy
                 * entry.
                 */
                dtbv.size(0);
            }
            cd.vtblsym.csym.Sdt = dtbv.finish();
            cd.vtblsym.csym.Sclass = scclass;
            cd.vtblsym.csym.Sfl = FLdata;
            out_readonly(cd.vtblsym.csym);
            outdata(cd.vtblsym.csym);
            if (cd.isExport())
                objmod.export_symbol(cd.vtblsym.csym,0);
        }

        override проц посети(InterfaceDeclaration ид)
        {
            //printf("InterfaceDeclaration.toObjFile('%s')\n", ид.вТкст0());

            if (ид.тип.ty == Terror)
            {
                ид.выведиОшибку("had semantic errors when compiling");
                return;
            }

            if (!ид.члены)
                return;

            if (глоб2.парамы.symdebugref)
                Type_toCtype(ид.тип); // calls toDebug() only once
            else if (глоб2.парамы.symdebug)
                toDebug(ид);

            // Put out the члены
            ид.члены.foreachDsymbol( (s) { visitNoMultiObj(s); } );

            // Generate C symbols
            toSymbol(ид);

            //////////////////////////////////////////////

            // Put out the TypeInfo
            if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
            {
                genTypeInfo(ид.место, ид.тип, null);
                ид.тип.vtinfo.прими(this);
            }

            //////////////////////////////////////////////

            genClassInfoForInterface(ид);
        }

        override проц посети(StructDeclaration sd)
        {
            //printf("StructDeclaration.toObjFile('%s')\n", sd.вТкст0());

            if (sd.тип.ty == Terror)
            {
                sd.выведиОшибку("had semantic errors when compiling");
                return;
            }

            if (multiobj && !sd.hasStaticCtorOrDtor())
            {
                obj_append(sd);
                return;
            }

            // Anonymous structs/unions only exist as part of others,
            // do not output forward referenced structs's
            if (!sd.isAnonymous() && sd.члены)
            {
                if (глоб2.парамы.symdebugref)
                    Type_toCtype(sd.тип); // calls toDebug() only once
                else if (глоб2.парамы.symdebug)
                    toDebug(sd);

                if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
                    genTypeInfo(sd.место, sd.тип, null);

                // Generate static инициализатор
                auto sinit = toInitializer(sd);
                if (sinit.Sclass == SCextern)
                {
                    if (sinit == bzeroSymbol) assert(0);
                    sinit.Sclass = sd.isInstantiated() ? SCcomdat : SCglobal;
                    sinit.Sfl = FLdata;
                    auto dtb = DtBuilder(0);
                    StructDeclaration_toDt(sd, dtb);
                    sinit.Sdt = dtb.finish();

                    /* fails to link on OBJ_MACH 64 with:
                     *  ld: in generated/osx/release/64/libphobos2.a(dwarfeh_8dc_56a.o),
                     *  in section __TEXT,__textcoal_nt reloc 6:
                     *  symbol index out of range for architecture x86_64
                     */
                    if (config.objfmt != OBJ_MACH &&
                        dtallzeros(sinit.Sdt))
                    {
                        sinit.Sclass = SCglobal;
                        dt2common(&sinit.Sdt);
                    }
                    else
                        out_readonly(sinit);    // put in читай-only segment
                    outdata(sinit);
                }

                // Put out the члены
                /* There might be static ctors in the члены, and they cannot
                 * be put in separate obj files.
                 */
                sd.члены.foreachDsymbol( (s) { s.прими(this); } );

                if (sd.xeq && sd.xeq != StructDeclaration.xerreq)
                    sd.xeq.прими(this);
                if (sd.xcmp && sd.xcmp != StructDeclaration.xerrcmp)
                    sd.xcmp.прими(this);
                if (sd.xhash)
                    sd.xhash.прими(this);
            }
        }

        override проц посети(VarDeclaration vd)
        {

            //printf("VarDeclaration.toObjFile(%p '%s' тип=%s) защита %d\n", vd, vd.вТкст0(), vd.тип.вТкст0(), vd.защита);
            //printf("\talign = %d\n", vd.alignment);

            if (vd.тип.ty == Terror)
            {
                vd.выведиОшибку("had semantic errors when compiling");
                return;
            }

            if (vd.aliassym)
            {
                visitNoMultiObj(vd.toAlias());
                return;
            }

            // Do not store variables we cannot take the address of
            if (!vd.canTakeAddressOf())
            {
                return;
            }

            if (!vd.isDataseg() || vd.класс_хранения & STC.extern_)
                return;

            Symbol *s = toSymbol(vd);
            d_uns64 sz64 = vd.тип.size(vd.место);
            if (sz64 == SIZE_INVALID)
            {
                vd.выведиОшибку("size overflow");
                return;
            }
            if (sz64 >= target.maxStaticDataSize)
            {
                vd.выведиОшибку("size of 0x%llx exceeds max allowed size 0x%llx", sz64, target.maxStaticDataSize);
            }
            бцел sz = cast(бцел)sz64;

            ДСимвол родитель = vd.toParent();
            s.Sclass = SCglobal;

            do
            {
                /* Global template данные члены need to be in comdat's
                 * in case multiple .obj files instantiate the same
                 * template with the same types.
                 */
                if (родитель.isTemplateInstance() && !родитель.isTemplateMixin())
                {
                    s.Sclass = SCcomdat;
                    break;
                }
                родитель = родитель.родитель;
            } while (родитель);
            s.Sfl = FLdata;

            if (!sz && vd.тип.toBasetype().ty != Tsarray)
                assert(0); // this shouldn't be possible

            auto dtb = DtBuilder(0);
            if (config.objfmt == OBJ_MACH && глоб2.парамы.is64bit && (s.Stype.Tty & mTYLINK) == mTYthread)
            {
                tlsToDt(vd, s, sz, dtb);
            }
            else if (!sz)
            {
                /* Give it a byte of данные
                 * so we can take the 'address' of this symbol
                 * and avoid problematic behavior of объект файл format
                 */
                dtb.nzeros(1);
            }
            else if (vd._иниц)
            {
                initializerToDt(vd, dtb);
            }
            else
            {
                Type_toDt(vd.тип, dtb);
            }
            s.Sdt = dtb.finish();

            // See if we can convert a comdat to a comdef,
            // which saves on exe файл space.
            if (s.Sclass == SCcomdat &&
                s.Sdt &&
                dtallzeros(s.Sdt) &&
                !vd.isThreadlocal())
            {
                s.Sclass = SCglobal;
                dt2common(&s.Sdt);
            }

            outdata(s);
            if (vd.тип.isMutable() || !vd._иниц)
                write_pointers(vd.тип, s, 0);
            if (vd.isExport())
                objmod.export_symbol(s, 0);
        }

        override проц посети(EnumDeclaration ed)
        {
            if (ed.semanticRun >= PASS.obj)  // already written
                return;
            //printf("EnumDeclaration.toObjFile('%s')\n", ed.вТкст0());

            if (ed.errors || ed.тип.ty == Terror)
            {
                ed.выведиОшибку("had semantic errors when compiling");
                return;
            }

            if (ed.isAnonymous())
                return;

            if (глоб2.парамы.symdebugref)
                Type_toCtype(ed.тип); // calls toDebug() only once
            else if (глоб2.парамы.symdebug)
                toDebug(ed);

            if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
                genTypeInfo(ed.место, ed.тип, null);

            TypeEnum tc = cast(TypeEnum)ed.тип;
            if (!tc.sym.члены || ed.тип.isZeroInit(Место.initial))
            {
            }
            else
            {
                enum_SC scclass = SCglobal;
                if (ed.isInstantiated())
                    scclass = SCcomdat;

                // Generate static инициализатор
                toInitializer(ed);
                ed.sinit.Sclass = scclass;
                ed.sinit.Sfl = FLdata;
                auto dtb = DtBuilder(0);
                Выражение_toDt(tc.sym.defaultval, dtb);
                ed.sinit.Sdt = dtb.finish();
                outdata(ed.sinit);
            }
            ed.semanticRun = PASS.obj;
        }

        override проц посети(TypeInfoDeclaration tid)
        {
            if (isSpeculativeType(tid.tinfo))
            {
                //printf("-speculative '%s'\n", tid.toPrettyChars());
                return;
            }
            //printf("TypeInfoDeclaration.toObjFile(%p '%s') защита %d\n", tid, tid.вТкст0(), tid.защита);

            if (multiobj)
            {
                obj_append(tid);
                return;
            }

            Symbol *s = toSymbol(tid);
            s.Sclass = SCcomdat;
            s.Sfl = FLdata;

            auto dtb = DtBuilder(0);
            TypeInfo_toDt(dtb, tid);
            s.Sdt = dtb.finish();

            // See if we can convert a comdat to a comdef,
            // which saves on exe файл space.
            if (s.Sclass == SCcomdat &&
                dtallzeros(s.Sdt))
            {
                s.Sclass = SCglobal;
                dt2common(&s.Sdt);
            }

            outdata(s);
            if (tid.isExport())
                objmod.export_symbol(s, 0);
        }

        override проц посети(AttribDeclaration ad)
        {
            Дсимволы *d = ad.include(null);

            if (d)
            {
                for (т_мера i = 0; i < d.dim; i++)
                {
                    ДСимвол s = (*d)[i];
                    s.прими(this);
                }
            }
        }

        override проц посети(PragmaDeclaration pd)
        {
            if (pd.идент == Id.lib)
            {
                assert(pd.args && pd.args.dim == 1);

                Выражение e = (*pd.args)[0];

                assert(e.op == ТОК2.string_);

                StringExp se = cast(StringExp)e;
                сим *имя = cast(сим *)mem.xmalloc(se.numberOfCodeUnits() + 1);
                se.writeTo(имя, да);

                /* Embed the library имена into the объект файл.
                 * The linker will then automatically
                 * search that library, too.
                 */
                if (!obj_includelib(имя))
                {
                    /* The format does not allow embedded library имена,
                     * so instead приставь the library имя to the list to be passed
                     * to the linker.
                     */
                    глоб2.парамы.libfiles.сунь(имя);
                }
            }
            else if (pd.идент == Id.startaddress)
            {
                assert(pd.args && pd.args.dim == 1);
                Выражение e = (*pd.args)[0];
                ДСимвол sa = getDsymbol(e);
                FuncDeclaration f = sa.isFuncDeclaration();
                assert(f);
                Symbol *s = toSymbol(f);
                obj_startaddress(s);
            }
            else if (pd.идент == Id.linkerDirective)
            {
                assert(pd.args && pd.args.dim == 1);

                Выражение e = (*pd.args)[0];

                assert(e.op == ТОК2.string_);

                StringExp se = cast(StringExp)e;
                сим *directive = cast(сим *)mem.xmalloc(se.numberOfCodeUnits() + 1);
                se.writeTo(directive, да);

                obj_linkerdirective(directive);
            }
            else if (pd.идент == Id.crt_constructor || pd.идент == Id.crt_destructor)
            {
                const isCtor = pd.идент == Id.crt_constructor;

                static бцел recurse(ДСимвол s, бул isCtor)
                {
                    if (auto ad = s.isAttribDeclaration())
                    {
                        бцел nestedCount;
                        auto decls = ad.include(null);
                        if (decls)
                        {
                            for (т_мера i = 0; i < decls.dim; ++i)
                                nestedCount += recurse((*decls)[i], isCtor);
                        }
                        return nestedCount;
                    }
                    else if (auto f = s.isFuncDeclaration())
                    {
                        f.isCrtCtorDtor |= isCtor ? 1 : 2;
                        if (f.компонаж != LINK.c)
                            f.выведиОшибку("must be `extern(C)` for `pragma(%s)`", isCtor ? "crt_constructor".ptr : "crt_destructor".ptr);
                        return 1;
                    }
                    else
                        return 0;
                    assert(0);
                }

                if (recurse(pd, isCtor) > 1)
                    pd.выведиОшибку("can only apply to a single declaration");
            }

            посети(cast(AttribDeclaration)pd);
        }

        override проц посети(TemplateInstance ti)
        {
            //printf("TemplateInstance.toObjFile(%p, '%s')\n", ti, ti.вТкст0());
            if (!isError(ti) && ti.члены)
            {
                if (!ti.needsCodegen())
                {
                    //printf("-speculative (%p, %s)\n", ti, ti.toPrettyChars());
                    return;
                }
                //printf("TemplateInstance.toObjFile(%p, '%s')\n", ti, ti.toPrettyChars());

                if (multiobj)
                {
                    // Append to list of объект files to be written later
                    obj_append(ti);
                }
                else
                {
                    ti.члены.foreachDsymbol( (s) { s.прими(this); } );
                }
            }
        }

        override проц посети(TemplateMixin tm)
        {
            //printf("TemplateMixin.toObjFile('%s')\n", tm.вТкст0());
            if (!isError(tm))
            {
                tm.члены.foreachDsymbol( (s) { s.прими(this); } );
            }
        }

        override проц посети(StaticAssert sa)
        {
        }

        override проц посети(Nspace ns)
        {
            //printf("Nspace.toObjFile('%s', this = %p)\n", ns.вТкст0(), ns);
            if (!isError(ns) && ns.члены)
            {
                if (multiobj)
                {
                    // Append to list of объект files to be written later
                    obj_append(ns);
                }
                else
                {
                    ns.члены.foreachDsymbol( (s) { s.прими(this); } );
                }
            }
        }

    private:
        static проц initializerToDt(VarDeclaration vd, ref DtBuilder dtb)
        {
            Initializer_toDt(vd._иниц, dtb);

            // Look for static массив that is block initialized
            ExpInitializer ie = vd._иниц.isExpInitializer();

            Тип tb = vd.тип.toBasetype();
            if (tb.ty == Tsarray && ie &&
                !tb.nextOf().равен(ie.exp.тип.toBasetype().nextOf()) &&
                ie.exp.implicitConvTo(tb.nextOf())
                )
            {
                auto dim = (cast(TypeSArray)tb).dim.toInteger();

                // Duplicate Sdt 'dim-1' times, as we already have the first one
                while (--dim > 0)
                {
                    Выражение_toDt(ie.exp, dtb);
                }
            }
        }

        /**
         * Output a TLS symbol for Mach-O.
         *
         * A TLS variable in the Mach-O format consists of two symbols.
         * One symbol for the данные, which содержит the инициализатор, if any.
         * The имя of this symbol is the same as the variable, but with the
         * "$tlv$init" suffix. If the variable has an инициализатор it's placed in
         * the __thread_data section. Otherwise it's placed in the __thread_bss
         * section.
         *
         * The other symbol is for the TLV descriptor. The symbol has the same
         * имя as the variable and is placed in the __thread_vars section.
         * A TLV descriptor has the following structure, where T is the тип of
         * the variable:
         *
         * struct TLVDescriptor(T)
         * {
         *     extern(C) T* function(TLVDescriptor*) thunk;
         *     т_мера ключ;
         *     т_мера смещение;
         * }
         *
         * Параметры:
         *      vd = the variable declaration for the symbol
         *      s = the backend Symbol corresponsing to vd
         *      sz = данные size of s
         *      dtb = where to put the данные
         */
        static проц tlsToDt(VarDeclaration vd, Symbol *s, бцел sz, ref DtBuilder dtb)
        {
            assert(config.objfmt == OBJ_MACH && глоб2.парамы.is64bit && (s.Stype.Tty & mTYLINK) == mTYthread);

            Symbol *tlvInit = createTLVDataSymbol(vd, s);
            auto tlvInitDtb = DtBuilder(0);

            if (sz == 0)
                tlvInitDtb.nzeros(1);
            else if (vd._иниц)
                initializerToDt(vd, tlvInitDtb);
            else
                Type_toDt(vd.тип, tlvInitDtb);

            tlvInit.Sdt = tlvInitDtb.finish();
            outdata(tlvInit);

            if (глоб2.парамы.is64bit)
                tlvInit.Sclass = SCextern;

            Symbol* tlvBootstrap = objmod.tlv_bootstrap();
            dtb.xoff(tlvBootstrap, 0, TYnptr);
            dtb.size(0);
            dtb.xoff(tlvInit, 0, TYnptr);
        }

        /**
         * Creates the данные symbol используется to initialize a TLS variable for Mach-O.
         *
         * Параметры:
         *      vd = the variable declaration for the symbol
         *      s = the back end symbol corresponding to vd
         *
         * Возвращает: the newly created symbol
         */
        static Symbol *createTLVDataSymbol(VarDeclaration vd, Symbol *s)
        {
            assert(config.objfmt == OBJ_MACH && глоб2.парамы.is64bit && (s.Stype.Tty & mTYLINK) == mTYthread);

            // Compute идентификатор for tlv symbol
            БуфВыв буфер;
            буфер.пишиСтр(s.Sident);
            буфер.пишиСтр("$tlv$init");
            сим *tlvInitName = буфер.peekChars();

            // Compute тип for tlv symbol
            тип *t = type_fake(vd.тип.ty);
            type_setty(&t, t.Tty | mTYthreadData);
            type_setmangle(&t, mangle(vd));

            Symbol *tlvInit = symbol_name(tlvInitName, SCstatic, t);
            tlvInit.Sdt = null;
            tlvInit.Salignment = type_alignsize(s.Stype);
            if (vd.компонаж == LINK.cpp)
                tlvInit.Sflags |= SFLpublic;

            return tlvInit;
        }

        /**
         * Возвращает the target mangling mangle_t for the given variable.
         *
         * Параметры:
         *      vd = the variable declaration
         *
         * Возвращает:
         *      the mangling that should be используется for variable
         */
        static mangle_t mangle(VarDeclaration vd)
        {
            switch (vd.компонаж)
            {
                case LINK.windows:
                    return глоб2.парамы.is64bit ? mTYman_c : mTYman_std;

                case LINK.pascal:
                    return mTYman_pas;

                case LINK.objc:
                case LINK.c:
                    return mTYman_c;

                case LINK.d:
                    return mTYman_d;

                case LINK.cpp:
                    return mTYman_cpp;

                case LINK.default_:
                case LINK.system:
                    printf("компонаж = %d\n", vd.компонаж);
                    assert(0);
            }
        }
    }

    scope v = new ToObjFile(multiobj);
    ds.прими(v);
}


/*********************************
 * Finish semantic analysis of functions in vtbl[].
 * Параметры:
 *    cd = class which has the vtbl[]
 * Возвращает:
 *    да for успех (no errors)
 */
private бул finishVtbl(ClassDeclaration cd)
{
    бул hasError = нет;

    foreach (i; new бцел[cd.vtblOffset() .. cd.vtbl.dim])
    {
        FuncDeclaration fd = cd.vtbl[i].isFuncDeclaration();

        //printf("\tvtbl[%d] = %p\n", i, fd);
        if (!fd || !fd.fbody && cd.isAbstract())
        {
            // Nothing to do
            continue;
        }
        // Гарант function has a return значение
        // https://issues.dlang.org/show_bug.cgi?ид=4869
        if (!fd.functionSemantic())
        {
            hasError = да;
        }

        if (!cd.isFuncHidden(fd) || fd.isFuture())
        {
            // All good, no имя hiding to check for
            continue;
        }

        /* fd is hidden from the view of this class.
         * If fd overlaps with any function in the vtbl[], then
         * issue 'hidden' error.
         */
        foreach (j; new бцел[1 .. cd.vtbl.dim])
        {
            if (j == i)
                continue;
            FuncDeclaration fd2 = cd.vtbl[j].isFuncDeclaration();
            if (!fd2.идент.равен(fd.идент))
                continue;
            if (fd2.isFuture())
                continue;
            if (!fd.leastAsSpecialized(fd2) && !fd2.leastAsSpecialized(fd))
                continue;
            // Hiding detected: same имя, overlapping specializations
            TypeFunction tf = cast(TypeFunction)fd.тип;
            if (tf.ty == Tfunction)
            {
                cd.выведиОшибку("use of `%s%s` is hidden by `%s`; use `alias %s = %s.%s;` to introduce base class overload set",
                    fd.toPrettyChars(),
                    parametersTypeToChars(tf.parameterList),
                    cd.вТкст0(),
                    fd.вТкст0(),
                    fd.родитель.вТкст0(),
                    fd.вТкст0());
            }
            else
            {
                cd.выведиОшибку("use of `%s` is hidden by `%s`", fd.toPrettyChars(), cd.вТкст0());
            }
            hasError = да;
            break;
        }
    }

    return !hasError;
}


/******************************************
 * Get смещение of base class's vtbl[] инициализатор from start of csym.
 * Возвращает ~0 if not this csym.
 */

бцел baseVtblOffset(ClassDeclaration cd, КлассОснова2 *bc)
{
    //printf("ClassDeclaration.baseVtblOffset('%s', bc = %p)\n", cd.вТкст0(), bc);
    бцел csymoffset = target.classinfosize;    // must be ClassInfo.size
    csymoffset += cd.vtblInterfaces.dim * (4 * target.ptrsize);

    for (т_мера i = 0; i < cd.vtblInterfaces.dim; i++)
    {
        КлассОснова2 *b = (*cd.vtblInterfaces)[i];

        if (b == bc)
            return csymoffset;
        csymoffset += b.sym.vtbl.dim * target.ptrsize;
    }

    // Put out the overriding interface vtbl[]s.
    // This must be mirrored with ClassDeclaration.baseVtblOffset()
    //printf("putting out overriding interface vtbl[]s for '%s' at смещение x%x\n", вТкст0(), смещение);
    ClassDeclaration cd2;

    for (cd2 = cd.baseClass; cd2; cd2 = cd2.baseClass)
    {
        foreach (k; new бцел[0 .. cd2.vtblInterfaces.dim])
        {
            КлассОснова2 *bs = (*cd2.vtblInterfaces)[k];
            if (bs.fillVtbl(cd, null, 0))
            {
                if (bc == bs)
                {
                    //printf("\tcsymoffset = x%x\n", csymoffset);
                    return csymoffset;
                }
                csymoffset += bs.sym.vtbl.dim * target.ptrsize;
            }
        }
    }

    return ~0;
}

/*******************
 * Emit the vtbl[] to static данные
 * Параметры:
 *    dtb = static данные builder
 *    b = base class
 *    bvtbl = массив of functions to put in this vtbl[]
 *    pc = classid for this vtbl[]
 *    k = смещение from pc to classinfo
 * Возвращает:
 *    number of bytes emitted
 */
private т_мера emitVtbl(ref DtBuilder dtb, КлассОснова2 *b, ref FuncDeclarations bvtbl, ClassDeclaration pc, т_мера k)
{
    //printf("\toverriding vtbl[] for %s\n", b.sym.вТкст0());
    ClassDeclaration ид = b.sym;

    const id_vtbl_dim = ид.vtbl.dim;
    assert(id_vtbl_dim <= bvtbl.dim);

    т_мера jstart = 0;
    if (ид.vtblOffset())
    {
        // First entry is struct Interface reference
        dtb.xoff(toSymbol(pc), cast(бцел)(target.classinfosize + k * (4 * target.ptrsize)), TYnptr);
        jstart = 1;
    }

    foreach (j; new бцел[jstart .. id_vtbl_dim])
    {
        FuncDeclaration fd = bvtbl[j];
        if (fd)
        {
            auto offset2 = b.смещение;
            if (fd.interfaceVirtual)
            {
                offset2 -= fd.interfaceVirtual.смещение;
            }
            dtb.xoff(toThunkSymbol(fd, offset2), 0, TYnptr);
        }
        else
            dtb.size(0);
    }
    return id_vtbl_dim * target.ptrsize;
}


/******************************************************
 * Generate the ClassInfo for a Class (__classZ) symbol.
 * Write it to the объект файл.
 * Similar to genClassInfoForInterface().
 * Параметры:
 *      cd = the class
 *      sinit = the Инициализатор (__initZ) symbol for the class
 */
private проц genClassInfoForClass(ClassDeclaration cd, Symbol* sinit)
{
    // Put out the ClassInfo, which will be the __ClassZ symbol in the объект файл
    enum_SC scclass = SCcomdat;
    cd.csym.Sclass = scclass;
    cd.csym.Sfl = FLdata;

    /* The layout is:
       {
            проц **vptr;
            monitor_t monitor;
            byte[] m_init;              // static initialization данные
            ткст имя;                // class имя
            ук[] vtbl;
            Interface[] interfaces;
            ClassInfo base;             // base class
            ук destructor;
            проц function(Object) classInvariant;   // class invariant
            ClassFlags m_flags;
            ук deallocator;
            OffsetTypeInfo[] offTi;
            проц function(Object) defaultConstructor;
            //const(MemberInfo[]) function(ткст) xgetMembers;   // module getMembers() function
            const(проц)* m_RTInfo;
            //TypeInfo typeinfo;
       }
     */
    бцел смещение = target.classinfosize;    // must be ClassInfo.size
    if (Тип.typeinfoclass)
    {
        if (Тип.typeinfoclass.structsize != target.classinfosize)
        {
            debug printf("target.classinfosize = x%x, Тип.typeinfoclass.structsize = x%x\n", смещение, Тип.typeinfoclass.structsize);
            cd.выведиОшибку("mismatch between dmd and объект.d or объект.di found. Check installation and import paths with -v compiler switch.");
            fatal();
        }
    }

    auto dtb = DtBuilder(0);

    if (auto tic = Тип.typeinfoclass)
    {
        dtb.xoff(toVtblSymbol(tic), 0, TYnptr); // vtbl for TypeInfo_Class : ClassInfo
        if (tic.hasMonitor())
            dtb.size(0);                        // monitor
    }
    else
    {
        dtb.size(0);                    // BUG: should be an assert()
        dtb.size(0);                    // call hasMonitor()?
    }

    // m_init[]
    assert(cd.structsize >= 8 || (cd.classKind == ClassKind.cpp && cd.structsize >= 4));
    dtb.size(cd.structsize);           // size
    dtb.xoff(sinit, 0, TYnptr);         // инициализатор

    // имя[]
    сим *имя = cd.идент.вТкст0();
    т_мера namelen = strlen(имя);
    if (!(namelen > 9 && memcmp(имя, "TypeInfo_".ptr, 9) == 0))
    {
        имя = cd.toPrettyChars();
        namelen = strlen(имя);
    }
    dtb.size(namelen);
    dt_t *pdtname = dtb.xoffpatch(cd.csym, 0, TYnptr);

    // vtbl[]
    dtb.size(cd.vtbl.dim);
    if (cd.vtbl.dim)
        dtb.xoff(cd.vtblsym.csym, 0, TYnptr);
    else
        dtb.size(0);

    // interfaces[]
    dtb.size(cd.vtblInterfaces.dim);
    if (cd.vtblInterfaces.dim)
        dtb.xoff(cd.csym, смещение, TYnptr);      // (*)
    else
        dtb.size(0);

    // base
    if (cd.baseClass)
        dtb.xoff(toSymbol(cd.baseClass), 0, TYnptr);
    else
        dtb.size(0);

    // destructor
    if (cd.tidtor)
        dtb.xoff(toSymbol(cd.tidtor), 0, TYnptr);
    else
        dtb.size(0);

    // classInvariant
    if (cd.inv)
        dtb.xoff(toSymbol(cd.inv), 0, TYnptr);
    else
        dtb.size(0);

    // flags
    ClassFlags flags = ClassFlags.hasOffTi;
    if (cd.isCOMclass()) flags |= ClassFlags.isCOMclass;
    if (cd.isCPPclass()) flags |= ClassFlags.isCPPclass;
    flags |= ClassFlags.hasGetMembers;
    flags |= ClassFlags.hasTypeInfo;
    if (cd.ctor)
        flags |= ClassFlags.hasCtor;
    for (ClassDeclaration pc = cd; pc; pc = pc.baseClass)
    {
        if (pc.dtor)
        {
            flags |= ClassFlags.hasDtor;
            break;
        }
    }
    if (cd.isAbstract())
        flags |= ClassFlags.isAbstract;

    flags |= ClassFlags.noPointers;     // initially assume no pointers
Louter:
    for (ClassDeclaration pc = cd; pc; pc = pc.baseClass)
    {
        if (pc.члены)
        {
            for (т_мера i = 0; i < pc.члены.dim; i++)
            {
                ДСимвол sm = (*pc.члены)[i];
                //printf("sm = %s %s\n", sm.вид(), sm.вТкст0());
                if (sm.hasPointers())
                {
                    flags &= ~ClassFlags.noPointers;  // not no-how, not no-way
                    break Louter;
                }
            }
        }
    }
    dtb.size(flags);

    // deallocator
    dtb.size(0);

    // offTi[]
    dtb.size(0);
    dtb.size(0);            // null for now, fix later

    // defaultConstructor
    if (cd.defaultCtor && !(cd.defaultCtor.класс_хранения & STC.disable))
        dtb.xoff(toSymbol(cd.defaultCtor), 0, TYnptr);
    else
        dtb.size(0);

    // m_RTInfo
    if (cd.getRTInfo)
        Выражение_toDt(cd.getRTInfo, dtb);
    else if (flags & ClassFlags.noPointers)
        dtb.size(0);
    else
        dtb.size(1);

    //dtb.xoff(toSymbol(cd.тип.vtinfo), 0, TYnptr); // typeinfo

    //////////////////////////////////////////////

    // Put out (*vtblInterfaces)[]. Must immediately follow csym, because
    // of the fixup (*)

    смещение += cd.vtblInterfaces.dim * (4 * target.ptrsize);
    for (т_мера i = 0; i < cd.vtblInterfaces.dim; i++)
    {
        КлассОснова2 *b = (*cd.vtblInterfaces)[i];
        ClassDeclaration ид = b.sym;

        /* The layout is:
         *  struct Interface
         *  {
         *      ClassInfo classinfo;
         *      ук[] vtbl;
         *      т_мера смещение;
         *  }
         */

        // Fill in vtbl[]
        b.fillVtbl(cd, &b.vtbl, 1);

        // classinfo
        dtb.xoff(toSymbol(ид), 0, TYnptr);

        // vtbl[]
        dtb.size(ид.vtbl.dim);
        dtb.xoff(cd.csym, смещение, TYnptr);

        // смещение
        dtb.size(b.смещение);
    }

    // Put out the (*vtblInterfaces)[].vtbl[]
    // This must be mirrored with ClassDeclaration.baseVtblOffset()
    //printf("putting out %d interface vtbl[]s for '%s'\n", vtblInterfaces.dim, вТкст0());
    foreach (i; new бцел[0 .. cd.vtblInterfaces.dim])
    {
        КлассОснова2 *b = (*cd.vtblInterfaces)[i];
        смещение += emitVtbl(dtb, b, b.vtbl, cd, i);
    }

    // Put out the overriding interface vtbl[]s.
    // This must be mirrored with ClassDeclaration.baseVtblOffset()
    //printf("putting out overriding interface vtbl[]s for '%s' at смещение x%x\n", вТкст0(), смещение);
    for (ClassDeclaration pc = cd.baseClass; pc; pc = pc.baseClass)
    {
        foreach (i; new бцел[0 .. pc.vtblInterfaces.dim])
        {
            КлассОснова2 *b = (*pc.vtblInterfaces)[i];
            FuncDeclarations bvtbl;
            if (b.fillVtbl(cd, &bvtbl, 0))
            {
                смещение += emitVtbl(dtb, b, bvtbl, pc, i);
            }
        }
    }

    //////////////////////////////////////////////

    dtpatchoffset(pdtname, смещение);

    dtb.члобайт(cast(бцел)(namelen + 1), имя);
    const т_мера namepad = -(namelen + 1) & (target.ptrsize - 1); // align
    dtb.nzeros(cast(бцел)namepad);

    cd.csym.Sdt = dtb.finish();
    // ClassInfo cannot be const данные, because we use the monitor on it
    outdata(cd.csym);
    if (cd.isExport())
        objmod.export_symbol(cd.csym, 0);
}

/******************************************************
 * Generate the ClassInfo for an Interface (classZ symbol).
 * Write it to the объект файл.
 * Параметры:
 *      ид = the interface
 */
private проц genClassInfoForInterface(InterfaceDeclaration ид)
{
    enum_SC scclass = SCcomdat;

    // Put out the ClassInfo
    ид.csym.Sclass = scclass;
    ид.csym.Sfl = FLdata;

    /* The layout is:
       {
            проц **vptr;
            monitor_t monitor;
            byte[] m_init;              // static initialization данные
            ткст имя;                // class имя
            ук[] vtbl;
            Interface[] interfaces;
            ClassInfo base;             // base class
            ук destructor;
            проц function(Object) classInvariant;   // class invariant
            ClassFlags m_flags;
            ук deallocator;
            OffsetTypeInfo[] offTi;
            проц function(Object) defaultConstructor;
            //const(MemberInfo[]) function(ткст) xgetMembers;   // module getMembers() function
            const(проц)* m_RTInfo;
            //TypeInfo typeinfo;
       }
     */
    auto dtb = DtBuilder(0);

    if (auto tic = Тип.typeinfoclass)
    {
        dtb.xoff(toVtblSymbol(tic), 0, TYnptr); // vtbl for ClassInfo
        if (tic.hasMonitor())
            dtb.size(0);                        // monitor
    }
    else
    {
        dtb.size(0);                    // BUG: should be an assert()
        dtb.size(0);                    // call hasMonitor()?
    }

    // m_init[]
    dtb.size(0);                        // size
    dtb.size(0);                        // инициализатор

    // имя[]
    сим *имя = ид.toPrettyChars();
    т_мера namelen = strlen(имя);
    dtb.size(namelen);
    dt_t *pdtname = dtb.xoffpatch(ид.csym, 0, TYnptr);

    // vtbl[]
    dtb.size(0);
    dtb.size(0);

    // interfaces[]
    бцел смещение = target.classinfosize;
    dtb.size(ид.vtblInterfaces.dim);
    if (ид.vtblInterfaces.dim)
    {
        if (Тип.typeinfoclass)
        {
            if (Тип.typeinfoclass.structsize != смещение)
            {
                ид.выведиОшибку("mismatch between dmd and объект.d or объект.di found. Check installation and import paths with -v compiler switch.");
                fatal();
            }
        }
        dtb.xoff(ид.csym, смещение, TYnptr);      // (*)
    }
    else
    {
        dtb.size(0);
    }

    // base
    assert(!ид.baseClass);
    dtb.size(0);

    // destructor
    dtb.size(0);

    // classInvariant
    dtb.size(0);

    // flags
    ClassFlags flags = ClassFlags.hasOffTi | ClassFlags.hasTypeInfo;
    if (ид.isCOMinterface()) flags |= ClassFlags.isCOMclass;
    dtb.size(flags);

    // deallocator
    dtb.size(0);

    // offTi[]
    dtb.size(0);
    dtb.size(0);            // null for now, fix later

    // defaultConstructor
    dtb.size(0);

    // xgetMembers
    //dtb.size(0);

    // m_RTInfo
    if (ид.getRTInfo)
        Выражение_toDt(ид.getRTInfo, dtb);
    else
        dtb.size(0);       // no pointers

    //dtb.xoff(toSymbol(ид.тип.vtinfo), 0, TYnptr); // typeinfo

    //////////////////////////////////////////////

    // Put out (*vtblInterfaces)[]. Must immediately follow csym, because
    // of the fixup (*)

    смещение += ид.vtblInterfaces.dim * (4 * target.ptrsize);
    for (т_мера i = 0; i < ид.vtblInterfaces.dim; i++)
    {
        КлассОснова2 *b = (*ид.vtblInterfaces)[i];
        ClassDeclaration base = b.sym;

        // classinfo
        dtb.xoff(toSymbol(base), 0, TYnptr);

        // vtbl[]
        dtb.size(0);
        dtb.size(0);

        // смещение
        dtb.size(b.смещение);
    }

    //////////////////////////////////////////////

    dtpatchoffset(pdtname, смещение);

    dtb.члобайт(cast(бцел)(namelen + 1), имя);
    const т_мера namepad =  -(namelen + 1) & (target.ptrsize - 1); // align
    dtb.nzeros(cast(бцел)namepad);

    ид.csym.Sdt = dtb.finish();
    out_readonly(ид.csym);
    outdata(ид.csym);
    if (ид.isExport())
        objmod.export_symbol(ид.csym, 0);
}

