/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/tocsym.d, _tocsym.d)
 * Documentation:  https://dlang.org/phobos/dmd_tocsym.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/tocsym.d
 */

module dmd.tocsym;

import cidrus;

import util.array;
import util.rmem;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.complex;
import dmd.ctfeexpr;
import dmd.declaration;
import dmd.dclass;
import dmd.denum;
import dmd.dmodule;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.e2ir;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.glue;
import drc.lexer.Identifier;
import drc.lexer.Id;
import dmd.init;
import dmd.mtype;
import dmd.target;
import dmd.toctype;
import dmd.todt;
import drc.lexer.Tokens;
import dmd.typinf;
import drc.ast.Visitor;
import dmd.irstate;
import dmd.dmangle;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.dt;
import drc.backend.тип;
import drc.backend.глоб2;
import drc.backend.oper;
import drc.backend.cgcv;
import drc.backend.ty;

import cidrus : malloc, free;
import util.outbuffer : БуфВыв;
import cidrus : strlen;
import util.outbuffer : БуфВыв;
import cidrus : alloca;
/*extern (C++):*/


/*************************************
 * Helper
 */

Symbol *toSymbolX(ДСимвол ds, ткст0 префикс, цел sclass, тип *t, ткст0 suffix)
{
    //printf("ДСимвол::toSymbolX('%s')\n", префикс);

    БуфВыв буф;
    mangleToBuffer(ds, &буф);
    т_мера nlen = буф.length;
    ткст0 n = буф.peekChars();
    assert(n);

    т_мера prefixlen = strlen(префикс);
    т_мера suffixlen = strlen(suffix);
    т_мера idlen = 2 + nlen + т_мера.sizeof * 3 + prefixlen + suffixlen + 1;

    сим[64] idbuf = void;
    сим *ид = &idbuf[0];
    if (idlen > idbuf.sizeof)
    {
        ид = cast(сим *)Пам.check(malloc(idlen));
    }

    цел nwritten = sprintf(ид,"_D%.*s%d%.*s%.*s",
        cast(цел)nlen, n,
        cast(цел)prefixlen, cast(цел)prefixlen, префикс,
        cast(цел)suffixlen, suffix);
    assert(cast(бцел)nwritten < idlen);         // nwritten does not include the terminating 0 сим

    Symbol *s = symbol_name(ид, nwritten, sclass, t);

    if (ид != &idbuf[0])
        free(ид);

    //printf("-ДСимвол::toSymbolX() %s\n", ид);
    return s;
}

private  Symbol *scc;

/*************************************
 */

Symbol *toSymbol(ДСимвол s)
{
     static final class ToSymbol : Визитор2
    {
        alias Визитор2.посети посети;

        Symbol *результат;

        this()
        {
            результат = null;
        }

        override проц посети(ДСимвол s)
        {
            printf("ДСимвол.toSymbol() '%s', вид = '%s'\n", s.вТкст0(), s.вид());
            assert(0);          // BUG: implement
        }

        override проц посети(SymbolDeclaration sd)
        {
            результат = toInitializer(sd.dsym);
        }

        override проц посети(VarDeclaration vd)
        {
            //printf("VarDeclaration.toSymbol(%s)\n", vd.вТкст0());
            assert(!vd.needThis());

            ткст ид;
            БуфВыв буф;
            бул isNRVO = нет;
            if (vd.isDataseg())
            {
                mangleToBuffer(vd, &буф);
                ид = буф.peekChars()[0..буф.length]; // symbol_calloc needs нуль termination
            }
            else
            {
                ид = vd.идент.вТкст();
                if (FuncDeclaration fd = vd.toParent2().isFuncDeclaration())
                {
                    if (fd.nrvo_can && fd.nrvo_var == vd)
                    {
                        буф.пишиСтр("__nrvo_");
                        буф.пишиСтр(ид);
                        ид = буф.peekChars()[0..буф.length]; // symbol_calloc needs нуль termination
                        isNRVO = да;
                    }
                }
            }
            Symbol *s = symbol_calloc(ид.ptr, cast(бцел)ид.length);
            s.Salignment = vd.alignment;
            if (vd.класс_хранения & STC.temp)
                s.Sflags |= SFLartifical;
            if (isNRVO)
                s.Sflags |= SFLnodebug;

            TYPE *t;
            if (vd.класс_хранения & (STC.out_ | STC.ref_))
            {
                t = type_allocn(TYnref, Type_toCtype(vd.тип));
                t.Tcount++;
            }
            else if (vd.класс_хранения & STC.lazy_)
            {
                if (config.exe == EX_WIN64 && vd.isParameter())
                    t = type_fake(TYnptr);
                else
                    t = type_fake(TYdelegate);          // Tdelegate as C тип
                t.Tcount++;
            }
            else if (vd.isParameter())
            {
                if (ISX64REF(vd))
                {
                    t = type_allocn(TYnref, Type_toCtype(vd.тип));
                    t.Tcount++;
                }
                else
                {
                    t = Type_toCtype(vd.тип);
                    t.Tcount++;
                }
            }
            else
            {
                t = Type_toCtype(vd.тип);
                t.Tcount++;
            }

            /* Even if a symbol is const, if it has a constructor then
             * the constructor mutates it. Remember that constructors can
             * be inlined into other code.
             * Just can't rely on it being const.
             */
            if (t.Tty & (mTYimmutable | mTYconst))
            {
                if (vd.ctorinit)
                {
                    /* It was initialized in a constructor, so not really const
                     * as far as the optimizer is concerned, as in this case:
                     *   const цел x;
                     *   shared static this() { x += 3; }
                     */
                    t = type_setty(&t, t.Tty & ~(mTYimmutable | mTYconst));
                }
                else if (auto ts = vd.тип.isTypeStruct())
                {
                    if (!ts.isMutable() && ts.sym.ctor)
                    {
                        t = type_setty(&t, t.Tty & ~(mTYimmutable | mTYconst));
                    }
                }
                else if (auto tc = vd.тип.isTypeClass())
                {
                    if (!tc.isMutable() && tc.sym.ctor)
                    {
                        t = type_setty(&t, t.Tty & ~(mTYimmutable | mTYconst));
                    }
                }
            }

            if (vd.isDataseg())
            {
                if (vd.isThreadlocal() && !(vd.класс_хранения & STC.temp))
                {
                    /* Thread local storage
                     */
                    auto ts = t;
                    ts.Tcount++;   // make sure a different t is allocated
                    type_setty(&t, t.Tty | mTYthread);
                    ts.Tcount--;

                    if (config.objfmt == OBJ_MACH && _tysize[TYnptr] == 8)
                        s.Salignment = 2;

                    if (глоб2.парамы.vtls)
                    {
                        message(vd.место, "`%s` is thread local", vd.вТкст0());
                    }
                }
                s.Sclass = SCextern;
                s.Sfl = FLextern;
                /* if it's глоб2 or static, then it needs to have a qualified but unmangled имя.
                 * This gives some explanation of the separation in treating имя mangling.
                 * It applies to PDB format, but should apply to CV as PDB derives from CV.
                 *    http://msdn.microsoft.com/en-us/library/ff553493(VS.85).aspx
                 */
                s.prettyIdent = vd.toPrettyChars(да);
            }
            else
            {
                s.Sclass = SCauto;
                s.Sfl = FLauto;

                if (vd.nestedrefs.dim)
                {
                    /* Symbol is accessed by a nested function. Make sure
                     * it is not put in a register, and that the optimizer
                     * assumes it is modified across function calls and pointer
                     * dereferences.
                     */
                    //printf("\tnested ref, not register\n");
                    type_setcv(&t, t.Tty | mTYvolatile);
                }
            }

            if (vd.класс_хранения & STC.volatile_)
            {
                type_setcv(&t, t.Tty | mTYvolatile);
            }

            mangle_t m = 0;
            switch (vd.компонаж)
            {
                case LINK.windows:
                    m = глоб2.парамы.is64bit ? mTYman_c : mTYman_std;
                    break;

                case LINK.pascal:
                    m = mTYman_pas;
                    break;

                case LINK.objc:
                case LINK.c:
                    m = mTYman_c;
                    break;

                case LINK.d:
                    m = mTYman_d;
                    break;

                case LINK.cpp:
                    s.Sflags |= SFLpublic;
                    m = mTYman_cpp;
                    break;

                case LINK.default_:
                case LINK.system:
                    printf("компонаж = %d, vd = %s %s @ [%s]\n",
                        vd.компонаж, vd.вид(), vd.вТкст0(), vd.место.вТкст0());
                    assert(0);
            }

            type_setmangle(&t, m);
            s.Stype = t;

            s.lnoscopestart = vd.место.номстр;
            s.lnoscopeend = vd.endlinnum;
            результат = s;
        }

        override проц посети(TypeInfoDeclaration tid)
        {
            //printf("TypeInfoDeclaration.toSymbol(%s), компонаж = %d\n", tid.вТкст0(), tid.компонаж);
            assert(tid.tinfo.ty != Terror);
            посети(tid.isVarDeclaration());
        }

        override проц посети(TypeInfoClassDeclaration ticd)
        {
            //printf("TypeInfoClassDeclaration.toSymbol(%s), компонаж = %d\n", ticd.вТкст0(), ticd.компонаж);
            ticd.tinfo.isTypeClass().sym.прими(this);
        }

        override проц посети(FuncAliasDeclaration fad)
        {
            fad.funcalias.прими(this);
        }

        override проц посети(FuncDeclaration fd)
        {
            ткст0 ид = mangleExact(fd);

            //printf("FuncDeclaration.toSymbol(%s %s)\n", fd.вид(), fd.вТкст0());
            //printf("\tid = '%s'\n", ид);
            //printf("\ttype = %s\n", fd.тип.вТкст0());
            auto s = symbol_calloc(ид, cast(бцел)strlen(ид));

            s.prettyIdent = fd.toPrettyChars(да);
            s.Sclass = SCglobal;
            symbol_func(s);
            func_t *f = s.Sfunc;
            if (fd.isVirtual() && fd.vtblIndex != -1)
                f.Fflags |= Fvirtual;
            else if (fd.isMember2() && fd.isStatic())
                f.Fflags |= Fstatic;

            f.Fstartline.set(fd.место.имяф, fd.место.номстр, fd.место.имяс);
            if (fd.endloc.номстр)
            {
                f.Fendline.set(fd.endloc.имяф, fd.endloc.номстр, fd.endloc.имяс);
            }
            else
            {
                f.Fendline = f.Fstartline;
            }

            auto t = Type_toCtype(fd.тип);
            const msave = t.Tmangle;
            if (fd.isMain())
            {
                t.Tty = TYnfunc;
                t.Tmangle = mTYman_c;
            }
            else
            {
                switch (fd.компонаж)
                {
                    case LINK.windows:
                        t.Tmangle = глоб2.парамы.is64bit ? mTYman_c : mTYman_std;
                        break;

                    case LINK.pascal:
                        t.Tty = TYnpfunc;
                        t.Tmangle = mTYman_pas;
                        break;

                    case LINK.c:
                    case LINK.objc:
                        t.Tmangle = mTYman_c;
                        break;

                    case LINK.d:
                        t.Tmangle = mTYman_d;
                        break;
                    case LINK.cpp:
                        s.Sflags |= SFLpublic;
                        if (fd.isThis() && !глоб2.парамы.is64bit && глоб2.парамы.isWindows)
                        {
                            if ((cast(TypeFunction)fd.тип).parameterList.varargs == ВарАрг.variadic)
                            {
                                t.Tty = TYnfunc;
                            }
                            else
                            {
                                t.Tty = TYmfunc;
                            }
                        }
                        t.Tmangle = mTYman_cpp;
                        break;
                    case LINK.default_:
                    case LINK.system:
                        printf("компонаж = %d\n", fd.компонаж);
                        assert(0);
                }
            }

            if (msave)
                assert(msave == t.Tmangle);
            //printf("Tty = %x, mangle = x%x\n", t.Tty, t.Tmangle);
            t.Tcount++;
            s.Stype = t;
            //s.Sfielddef = this;

            результат = s;
        }

        static тип* getClassInfoCType()
        {
            if (!scc)
                scc = fake_classsym(Id.ClassInfo);
            return scc.Stype;
        }

        /*************************************
         * Create the "ClassInfo" symbol
         */

        override проц посети(ClassDeclaration cd)
        {
            auto s = toSymbolX(cd, "__Class", SCextern, getClassInfoCType(), "Z");
            s.Sfl = FLextern;
            s.Sflags |= SFLnodebug;
            результат = s;
        }

        /*************************************
         * Create the "InterfaceInfo" symbol
         */

        override проц посети(InterfaceDeclaration ид)
        {
            auto s = toSymbolX(ид, "__Interface", SCextern, getClassInfoCType(), "Z");
            s.Sfl = FLextern;
            s.Sflags |= SFLnodebug;
            результат = s;
        }

        /*************************************
         * Create the "ModuleInfo" symbol
         */

        override проц посети(Module m)
        {
            auto s = toSymbolX(m, "__ModuleInfo", SCextern, getClassInfoCType(), "Z");
            s.Sfl = FLextern;
            s.Sflags |= SFLnodebug;
            результат = s;
        }
    }

    if (s.csym)
        return s.csym;

    scope ToSymbol v = new ToSymbol();
    s.прими(v);
    s.csym = v.результат;
    return v.результат;
}


/*************************************
 */

Symbol *toImport(Symbol *sym)
{
    //printf("ДСимвол.toImport('%s')\n", sym.Sident);
    сим *n = sym.Sident.ptr;   
    сим *ид = cast(сим *) alloca(6 + strlen(n) + 1 + type_paramsize(sym.Stype).sizeof*3 + 1);
    цел idlen;
    if (config.exe != EX_WIN32 && config.exe != EX_WIN64)
    {
        ид = n;
        idlen = cast(цел)strlen(n);
    }
    else if (sym.Stype.Tmangle == mTYman_std && tyfunc(sym.Stype.Tty))
    {
        if (config.exe == EX_WIN64)
            idlen = sprintf(ид,"__imp_%s",n);
        else
            idlen = sprintf(ид,"_imp__%s@%u",n,cast(бцел)type_paramsize(sym.Stype));
    }
    else
    {
        idlen = sprintf(ид,(config.exe == EX_WIN64) ? "__imp_%s" : "_imp__%s",n);
    }
    auto t = type_alloc(TYnptr | mTYconst);
    t.Tnext = sym.Stype;
    t.Tnext.Tcount++;
    t.Tmangle = mTYman_c;
    t.Tcount++;
    auto s = symbol_calloc(ид, idlen);
    s.Stype = t;
    s.Sclass = SCextern;
    s.Sfl = FLextern;
    return s;
}

/*********************************
 * Generate import symbol from symbol.
 */

Symbol *toImport(ДСимвол ds)
{
    if (!ds.isym)
    {
        if (!ds.csym)
            ds.csym = toSymbol(ds);
        ds.isym = toImport(ds.csym);
    }
    return ds.isym;
}

/*************************************
 * Thunks adjust the incoming 'this' pointer by 'смещение'.
 */

Symbol *toThunkSymbol(FuncDeclaration fd, цел смещение)
{
    Symbol *s = toSymbol(fd);
    if (!смещение)
        return s;

     цел tmpnum;
    сим[6 + tmpnum.sizeof * 3 + 1] имя = проц;

    sprintf(имя.ptr,"_THUNK%d",tmpnum++);
    auto sthunk = symbol_name(имя.ptr,SCstatic,fd.csym.Stype);
    sthunk.Sflags |= SFLnodebug | SFLartifical;
    sthunk.Sflags |= SFLimplem;
    outthunk(sthunk, fd.csym, 0, TYnptr, -смещение, -1, 0);
    return sthunk;
}


/**************************************
 * Fake a struct symbol.
 */

Classsym *fake_classsym(Идентификатор2 ид)
{
    auto t = type_struct_class(ид.вТкст0(),8,0,
        null,null,
        нет, нет, да, нет);

    t.Ttag.Sstruct.Sflags = STRglobal;
    t.Tflags |= TFsizeunknown | TFforward;
    assert(t.Tmangle == 0);
    t.Tmangle = mTYman_d;
    return t.Ttag;
}

/*************************************
 * This is accessible via the ClassData, but since it is frequently
 * needed directly (like for rtti comparisons), make it directly accessible.
 */

Symbol *toVtblSymbol(ClassDeclaration cd)
{
    if (!cd.vtblsym || !cd.vtblsym.csym)
    {
        if (!cd.csym)
            toSymbol(cd);

        auto t = type_allocn(TYnptr | mTYconst, tstypes[TYvoid]);
        t.Tmangle = mTYman_d;
        auto s = toSymbolX(cd, "__vtbl", SCextern, t, "Z");
        s.Sflags |= SFLnodebug;
        s.Sfl = FLextern;

        auto vtbl = cd.vtblSymbol();
        vtbl.csym = s;
    }
    return cd.vtblsym.csym;
}

/**********************************
 * Create the static инициализатор for the struct/class.
 */

Symbol *toInitializer(AggregateDeclaration ad)
{
    //printf("toInitializer() %s\n", ad.вТкст0());
    if (!ad.sinit)
    {
        static structalign_t alignOf(Тип t)
        {
            const explicitAlignment = t.alignment();
            return explicitAlignment == STRUCTALIGN_DEFAULT ? t.alignsize() : explicitAlignment;
        }

        auto sd = ad.isStructDeclaration();
        if (sd &&
            alignOf(sd.тип) <= 16 &&
            sd.тип.size() <= 128 &&
            sd.zeroInit &&
            config.objfmt != OBJ_MACH && // same reason as in toobj.d toObjFile()
            !(config.objfmt == OBJ_MSCOFF && !глоб2.парамы.is64bit)) // -m32mscoff relocations are wrong
        {
            auto bzsave = bzeroSymbol;
            ad.sinit = getBzeroSymbol();

            // Гарант emitted only once per объект файл
            if (bzsave && bzeroSymbol != bzsave)
                assert(0);
        }
        else
        {
            auto stag = fake_classsym(Id.ClassInfo);
            auto s = toSymbolX(ad, "__init", SCextern, stag.Stype, "Z");
            s.Sfl = FLextern;
            s.Sflags |= SFLnodebug;
            if (sd)
                s.Salignment = sd.alignment;
            ad.sinit = s;
        }
    }
    return ad.sinit;
}

Symbol *toInitializer(EnumDeclaration ed)
{
    if (!ed.sinit)
    {
        auto stag = fake_classsym(Id.ClassInfo);
        assert(ed.идент);
        auto s = toSymbolX(ed, "__init", SCextern, stag.Stype, "Z");
        s.Sfl = FLextern;
        s.Sflags |= SFLnodebug;
        ed.sinit = s;
    }
    return ed.sinit;
}


/********************************************
 * Determine the right symbol to look up
 * an associative массив element.
 * Input:
 *      flags   0       don't add значение signature
 *              1       add значение signature
 */

Symbol *aaGetSymbol(TypeAArray taa, ткст0 func, цел flags)
{
    assert((flags & ~1) == 0);

    // Dumb linear symbol table - should use associative массив!
     Symbol*[] sarray;

    //printf("aaGetSymbol(func = '%s', flags = %d, ключ = %p)\n", func, flags, ключ);    
    auto ид = cast(сим *)alloca(3 + strlen(func) + 1);
    const idlen = sprintf(ид, "_aa%s", func);

    // See if symbol is already in sarray
    foreach (s; sarray)
    {
        if (strcmp(ид, s.Sident.ptr) == 0)
        {
            return s;                       // use existing Symbol
        }
    }

    // Create new Symbol

    auto s = symbol_calloc(ид, idlen);
    s.Sclass = SCextern;
    s.Ssymnum = -1;
    symbol_func(s);

    auto t = type_function(TYnfunc, null, нет, Type_toCtype(taa.следщ));
    t.Tmangle = mTYman_c;
    s.Stype = t;

    sarray ~= s;                         // remember it
    return s;
}

/*****************************************************/
/*                   CTFE stuff                      */
/*****************************************************/

Symbol* toSymbol(StructLiteralExp sle)
{
    //printf("toSymbol() %p.sym: %p\n", sle, sle.sym);
    if (sle.sym)
        return sle.sym;
    auto t = type_alloc(TYint);
    t.Tcount++;
    auto s = symbol_calloc("internal", 8);
    s.Sclass = SCstatic;
    s.Sfl = FLextern;
    s.Sflags |= SFLnodebug;
    s.Stype = t;
    sle.sym = s;
    auto dtb = DtBuilder(0);
    Выражение_toDt(sle, dtb);
    s.Sdt = dtb.finish();
    outdata(s);
    return sle.sym;
}

Symbol* toSymbol(ClassReferenceExp cre)
{
    //printf("toSymbol() %p.значение.sym: %p\n", cre, cre.значение.sym);
    if (cre.значение.origin.sym)
        return cre.значение.origin.sym;
    auto t = type_alloc(TYint);
    t.Tcount++;
    auto s = symbol_calloc("internal", 8);
    s.Sclass = SCstatic;
    s.Sfl = FLextern;
    s.Sflags |= SFLnodebug;
    s.Stype = t;
    cre.значение.sym = s;
    cre.значение.origin.sym = s;
    auto dtb = DtBuilder(0);
    ClassReferenceExp_toInstanceDt(cre, dtb);
    s.Sdt = dtb.finish();
    outdata(s);
    return cre.значение.sym;
}

/**************************************
 * For C++ class cd, generate an instance of __cpp_type_info_ptr
 * and populate it with a pointer to the C++ тип info.
 * Параметры:
 *      cd = C++ class
 * Возвращает:
 *      symbol of instance of __cpp_type_info_ptr
 */
Symbol* toSymbolCpp(ClassDeclaration cd)
{
    assert(cd.isCPPclass());

    /* For the symbol std::exception, the тип info is _ZTISt9exception
     */
    if (!cd.cpp_type_info_ptr_sym)
    {
         Symbol *scpp;
        if (!scpp)
            scpp = fake_classsym(Id.cpp_type_info_ptr);
        Symbol *s = toSymbolX(cd, "_cpp_type_info_ptr", SCcomdat, scpp.Stype, "");
        s.Sfl = FLdata;
        s.Sflags |= SFLnodebug;
        auto dtb = DtBuilder(0);
        cpp_type_info_ptr_toDt(cd, dtb);
        s.Sdt = dtb.finish();
        outdata(s);
        cd.cpp_type_info_ptr_sym = s;
    }
    return cd.cpp_type_info_ptr_sym;
}

/**********************************
 * Generate Symbol of C++ тип info for C++ class cd.
 * Параметры:
 *      cd = C++ class
 * Возвращает:
 *      Symbol of cd's rtti тип info
 */
Symbol *toSymbolCppTypeInfo(ClassDeclaration cd)
{
    const ид = target.cpp.typeInfoMangle(cd);
    auto s = symbol_calloc(ид, cast(бцел)strlen(ид));
    s.Sclass = SCextern;
    s.Sfl = FLextern;          // C++ code will provide the definition
    s.Sflags |= SFLnodebug;
    auto t = type_fake(TYnptr);
    t.Tcount++;
    s.Stype = t;
    return s;
}

