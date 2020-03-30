/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/todt.d, _todt.d)
 * Documentation:  https://dlang.org/phobos/dmd_todt.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/todt.d
 */

module dmd.todt;

import cidrus;

import util.array;
import util.rmem;

import dmd.aggregate;
import dmd.arraytypes;
import drc.backend.тип;
import dmd.complex;
import dmd.ctfeexpr;
import dmd.declaration;
import dmd.dclass;
import dmd.denum;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.init;
import dmd.mtype;
import dmd.target;
import drc.lexer.Tokens;
import dmd.tocsym;
import dmd.toobj;
import dmd.typesem;
import dmd.typinf;
import drc.ast.Visitor;

import drc.backend.cc;
import drc.backend.dt;
import dmd.e2ir : вТкстSymbol;
import dmd.glue : totym;


alias dmd.tocsym.toSymbol toSymbol;
alias dmd.glue.toSymbol toSymbol;

/* A dt_t is a simple structure representing данные to be added
 * to the данные segment of the output объект файл. As such,
 * it is a list of initialized bytes, 0 данные, and offsets from
 * other symbols.
 * Each D symbol and тип can be converted into a dt_t so it can
 * be written to the данные segment.
 */

alias МассивДРК!(dt_t*) Dts;

/* ================================================================ */

 проц Initializer_toDt(Инициализатор init, ref DtBuilder dtb)
{
    проц visitError(ErrorInitializer)
    {
        assert(0);
    }

    проц visitVoid(VoidInitializer vi)
    {
        /* Void initializers are set to 0, just because we need something
         * to set them to in the static данные segment.
         */
        dtb.nzeros(cast(бцел)vi.тип.size());
    }

    проц visitStruct(StructInitializer si)
    {
        //printf("StructInitializer.toDt('%s')\n", si.вТкст0());
        assert(0);
    }

    проц visitArray(ArrayInitializer ai)
    {
        //printf("ArrayInitializer.toDt('%s')\n", ai.вТкст0());
        Тип tb = ai.тип.toBasetype();
        if (tb.ty == Tvector)
            tb = (cast(TypeVector)tb).basetype;

        Тип tn = tb.nextOf().toBasetype();

        //printf("\tdim = %d\n", ai.dim);
        Dts dts;
        dts.устДим(ai.dim);
        dts.нуль();

        бцел size = cast(бцел)tn.size();

        бцел length = 0;
        foreach (i, idx; ai.index)
        {
            if (idx)
                length = cast(бцел)idx.toInteger();
            //printf("\tindex[%d] = %p, length = %u, dim = %u\n", i, idx, length, ai.dim);

            assert(length < ai.dim);
            auto dtb = DtBuilder(0);
            Initializer_toDt(ai.значение[i], dtb);
            if (dts[length])
                выведиОшибку(ai.место, "duplicate initializations for index `%d`", length);
            dts[length] = dtb.finish();
            length++;
        }

        Выражение edefault = tb.nextOf().defaultInit(Место.initial);

        const n = tn.numberOfElems(ai.место);

        dt_t* dtdefault = null;

        auto dtbarray = DtBuilder(0);
        foreach (dt; dts)
        {
            if (dt)
                dtbarray.cat(dt);
            else
            {
                if (!dtdefault)
                {
                    auto dtb = DtBuilder(0);
                    Выражение_toDt(edefault, dtb);
                    dtdefault = dtb.finish();
                }
                dtbarray.repeat(dtdefault, n);
            }
        }
        switch (tb.ty)
        {
            case Tsarray:
            {
                TypeSArray ta = cast(TypeSArray)tb;
                т_мера tadim = cast(т_мера)ta.dim.toInteger();
                if (ai.dim < tadim)
                {
                    if (edefault.isBool(нет))
                    {
                        // pad out end of массив
                        dtbarray.nzeros(cast(бцел)(size * (tadim - ai.dim)));
                    }
                    else
                    {
                        if (!dtdefault)
                        {
                            auto dtb = DtBuilder(0);
                            Выражение_toDt(edefault, dtb);
                            dtdefault = dtb.finish();
                        }

                        const m = n * (tadim - ai.dim);
                        assert(m <= бцел.max);
                        dtbarray.repeat(dtdefault, cast(бцел)m);
                    }
                }
                else if (ai.dim > tadim)
                {
                    выведиОшибку(ai.место, "too many initializers, %d, for массив[%d]", ai.dim, tadim);
                }
                dtb.cat(dtbarray);
                break;
            }

            case Tpointer:
            case Tarray:
            {
                if (tb.ty == Tarray)
                    dtb.size(ai.dim);
                Symbol* s = dtb.dtoff(dtbarray.finish(), 0);
                if (tn.isMutable())
                    foreach (i; new бцел[0 .. ai.dim])
                        write_pointers(tn, s, size * cast(цел)i);
                break;
            }

            default:
                assert(0);
        }
        dt_free(dtdefault);
    }

    проц visitExp(ExpInitializer ei)
    {
        //printf("ExpInitializer.toDt() %s\n", ei.exp.вТкст0());
        ei.exp = ei.exp.optimize(WANTvalue);
        Выражение_toDt(ei.exp, dtb);
    }

    switch (init.вид)
    {
        case InitKind.void_:   return visitVoid  (cast(  VoidInitializer)init);
        case InitKind.error:   return visitError (cast( ErrorInitializer)init);
        case InitKind.struct_: return visitStruct(cast(StructInitializer)init);
        case InitKind.массив:   return visitArray (cast( ArrayInitializer)init);
        case InitKind.exp:     return visitExp   (cast(   ExpInitializer)init);
    }
}

/* ================================================================ */

 проц Выражение_toDt(Выражение e, ref DtBuilder dtb)
{
    проц nonConstExpError(Выражение e)
    {
        version (none)
        {
            printf("Выражение.toDt() %d\n", e.op);
        }
        e.выведиОшибку("non-constant Выражение `%s`", e.вТкст0());
        dtb.nzeros(1);
    }

    проц visitCast(CastExp e)
    {
        version (none)
        {
            printf("CastExp.toDt() %d from %s to %s\n", e.op, e.e1.тип.вТкст0(), e.тип.вТкст0());
        }
        if (e.e1.тип.ty == Tclass)
        {
            if (auto toc = e.тип.isTypeClass())
            {
                if (auto toi = toc.sym.isInterfaceDeclaration()) // casting from class to interface
                {
                    auto cre1 = e.e1.isClassReferenceExp();
                    ClassDeclaration from = cre1.originalClass();
                    цел off = 0;
                    const isbase = toi.isBaseOf(from, &off);
                    assert(isbase);
                    ClassReferenceExp_toDt(cre1, dtb, off);
                }
                else //casting from class to class
                {
                    Выражение_toDt(e.e1, dtb);
                }
                return;
            }
        }
        nonConstExpError(e);
    }

    проц visitAddr(AddrExp e)
    {
        version (none)
        {
            printf("AddrExp.toDt() %d\n", e.op);
        }
        if (auto sl = e.e1.isStructLiteralExp())
        {
            Symbol* s = toSymbol(sl);
            dtb.xoff(s, 0);
            if (sl.тип.isMutable())
                write_pointers(sl.тип, s, 0);
            return;
        }
        nonConstExpError(e);
    }

    проц visitInteger(IntegerExp e)
    {
        //printf("IntegerExp.toDt() %d\n", e.op);
        const sz = cast(бцел)e.тип.size();
        if (auto значение = e.getInteger())
            dtb.члобайт(sz, cast(сим*)&значение);
        else
            dtb.nzeros(sz);
    }

    проц visitReal(RealExp e)
    {
        //printf("RealExp.toDt(%Lg)\n", e.значение);
        switch (e.тип.toBasetype().ty)
        {
            case Tfloat32:
            case Timaginary32:
            {
                auto fvalue = cast(float)e.значение;
                dtb.члобайт(4, cast(сим*)&fvalue);
                break;
            }

            case Tfloat64:
            case Timaginary64:
            {
                auto dvalue = cast(double)e.значение;
                dtb.члобайт(8, cast(сим*)&dvalue);
                break;
            }

            case Tfloat80:
            case Timaginary80:
            {
                auto evalue = e.значение;
                dtb.члобайт(target.realsize - target.realpad, cast(сим*)&evalue);
                dtb.nzeros(target.realpad);
                break;
            }

            default:
                printf("%s, e.тип=%s\n", e.вТкст0(), e.тип.вТкст0());
                assert(0);
        }
    }

    проц visitComplex(ComplexExp e)
    {
        //printf("ComplexExp.toDt() '%s'\n", e.вТкст0());
        switch (e.тип.toBasetype().ty)
        {
            case Tcomplex32:
            {
                auto fvalue = cast(float)creall(e.значение);
                dtb.члобайт(4, cast(сим*)&fvalue);
                fvalue = cast(float)cimagl(e.значение);
                dtb.члобайт(4, cast(сим*)&fvalue);
                break;
            }

            case Tcomplex64:
            {
                auto dvalue = cast(double)creall(e.значение);
                dtb.члобайт(8, cast(сим*)&dvalue);
                dvalue = cast(double)cimagl(e.значение);
                dtb.члобайт(8, cast(сим*)&dvalue);
                break;
            }

            case Tcomplex80:
            {
                auto evalue = creall(e.значение);
                dtb.члобайт(target.realsize - target.realpad, cast(сим*)&evalue);
                dtb.nzeros(target.realpad);
                evalue = cimagl(e.значение);
                dtb.члобайт(target.realsize - target.realpad, cast(сим*)&evalue);
                dtb.nzeros(target.realpad);
                break;
            }

            default:
                assert(0);
        }
    }

    проц visitNull(NullExp e)
    {
        assert(e.тип);
        dtb.nzeros(cast(бцел)e.тип.size());
    }

    проц visitString(StringExp e)
    {
        //printf("StringExp.toDt() '%s', тип = %s\n", e.вТкст0(), e.тип.вТкст0());
        Тип t = e.тип.toBasetype();

        // BUG: should implement some form of static ткст pooling
        const n = cast(цел)e.numberOfCodeUnits();
        ткст0 p;
        ткст0 q;
        if (e.sz == 1)
            p = e.peekString().ptr;
        else
        {
            q = cast(сим*)mem.xmalloc(n * e.sz);
            e.writeTo(q, нет);
            p = q;
        }

        switch (t.ty)
        {
            case Tarray:
                dtb.size(n);
                goto case Tpointer;

            case Tpointer:
                if (e.sz == 1)
                {
                    Symbol* s = вТкстSymbol(p, n, e.sz);
                    dtb.xoff(s, 0);
                }
                else
                    dtb.abytes(0, n * e.sz, p, cast(бцел)e.sz);
                break;

            case Tsarray:
            {
                auto tsa = t.isTypeSArray();

                dtb.члобайт(n * e.sz, p);
                if (tsa.dim)
                {
                    dinteger_t dim = tsa.dim.toInteger();
                    if (n < dim)
                    {
                        // Pad remainder with 0
                        dtb.nzeros(cast(бцел)((dim - n) * tsa.следщ.size()));
                    }
                }
                break;
            }

            default:
                printf("StringExp.toDt(тип = %s)\n", e.тип.вТкст0());
                assert(0);
        }
        mem.xfree(q);
    }

    проц visitArrayLiteral(ArrayLiteralExp e)
    {
        //printf("ArrayLiteralExp.toDt() '%s', тип = %s\n", e.вТкст0(), e.тип.вТкст0());

        auto dtbarray = DtBuilder(0);
        foreach (i; new бцел[0 .. e.elements.dim])
        {
            Выражение_toDt(e[i], dtbarray);
        }

        Тип t = e.тип.toBasetype();
        switch (t.ty)
        {
            case Tsarray:
                dtb.cat(dtbarray);
                break;

            case Tarray:
                dtb.size(e.elements.dim);
                goto case Tpointer;

            case Tpointer:
            {
                if (auto d = dtbarray.finish())
                    dtb.dtoff(d, 0);
                else
                    dtb.size(0);

                break;
            }

            default:
                assert(0);
        }
    }

    проц visitStructLiteral(StructLiteralExp sle)
    {
        //printf("StructLiteralExp.toDt() %s, ctfe = %d\n", sle.вТкст0(), sle.ownedByCtfe);
        assert(sle.sd.nonHiddenFields() <= sle.elements.dim);
        membersToDt(sle.sd, dtb, sle.elements, 0, null);
    }

    проц visitSymOff(SymOffExp e)
    {
        //printf("SymOffExp.toDt('%s')\n", e.var.вТкст0());
        assert(e.var);
        if (!(e.var.isDataseg() || e.var.isCodeseg()) ||
            e.var.needThis() ||
            e.var.isThreadlocal())
        {
            return nonConstExpError(e);
        }
        dtb.xoff(toSymbol(e.var), cast(бцел)e.смещение);
    }

    проц visitVar(VarExp e)
    {
        //printf("VarExp.toDt() %d\n", e.op);

        if (auto v = e.var.isVarDeclaration())
        {
            if ((v.isConst() || v.isImmutable()) &&
                e.тип.toBasetype().ty != Tsarray && v._иниц)
            {
                e.выведиОшибку("recursive reference `%s`", e.вТкст0());
                return;
            }
            v.inuse++;
            Initializer_toDt(v._иниц, dtb);
            v.inuse--;
            return;
        }

        if (auto sd = e.var.isSymbolDeclaration())
            if (sd.dsym)
            {
                StructDeclaration_toDt(sd.dsym, dtb);
                return;
            }

        return nonConstExpError(e);
    }

    проц visitFunc(FuncExp e)
    {
        //printf("FuncExp.toDt() %d\n", e.op);
        if (e.fd.tok == ТОК2.reserved && e.тип.ty == Tpointer)
        {
            // change to non-nested
            e.fd.tok = ТОК2.function_;
            e.fd.vthis = null;
        }
        Symbol *s = toSymbol(e.fd);
        toObjFile(e.fd, нет);
        if (e.fd.tok == ТОК2.delegate_)
            dtb.size(0);
        dtb.xoff(s, 0);
    }

    проц visitVector(VectorExp e)
    {
        //printf("VectorExp.toDt() %s\n", e.вТкст0());
        foreach (i; new бцел[0 .. e.dim])
        {
            Выражение elem;
            if (auto ale = e.e1.isArrayLiteralExp())
                elem = ale[i];
            else
                elem = e.e1;
            Выражение_toDt(elem, dtb);
        }
    }

    проц visitClassReference(ClassReferenceExp e)
    {
        InterfaceDeclaration to = (cast(TypeClass)e.тип).sym.isInterfaceDeclaration();

        if (to) //Static typeof this literal is an interface. We must add смещение to symbol
        {
            ClassDeclaration from = e.originalClass();
            цел off = 0;
            const isbase = to.isBaseOf(from, &off);
            assert(isbase);
            ClassReferenceExp_toDt(e, dtb, off);
        }
        else
            ClassReferenceExp_toDt(e, dtb, 0);
    }

    проц visitTypeid(TypeidExp e)
    {
        if (Тип t = тип_ли(e.obj))
        {
            genTypeInfo(e.место, t, null);
            Symbol *s = toSymbol(t.vtinfo);
            dtb.xoff(s, 0);
            return;
        }
        assert(0);
    }

    switch (e.op)
    {
        default:                 return nonConstExpError(e);
        case ТОК2.cast_:          return visitCast          (e.isCastExp());
        case ТОК2.address:        return visitAddr          (e.isAddrExp());
        case ТОК2.int64:          return visitInteger       (e.isIntegerExp());
        case ТОК2.float64:        return visitReal          (e.isRealExp());
        case ТОК2.complex80:      return visitComplex       (e.isComplexExp());
        case ТОК2.null_:          return visitNull          (e.isNullExp());
        case ТОК2.string_:        return visitString        (e.isStringExp());
        case ТОК2.arrayLiteral:   return visitArrayLiteral  (e.isArrayLiteralExp());
        case ТОК2.structLiteral:  return visitStructLiteral (e.isStructLiteralExp());
        case ТОК2.symbolOffset:   return visitSymOff        (e.isSymOffExp());
        case ТОК2.variable:       return visitVar           (e.isVarExp());
        case ТОК2.function_:      return visitFunc          (e.isFuncExp());
        case ТОК2.vector:         return visitVector        (e.isVectorExp());
        case ТОК2.classReference: return visitClassReference(e.isClassReferenceExp());
        case ТОК2.typeid_:        return visitTypeid        (e.isTypeidExp());
    }
}

/* ================================================================= */

// Generate the данные for the static инициализатор.

 проц ClassDeclaration_toDt(ClassDeclaration cd, ref DtBuilder dtb)
{
    //printf("ClassDeclaration.toDt(this = '%s')\n", cd.вТкст0());

    membersToDt(cd, dtb, null, 0, cd);

    //printf("-ClassDeclaration.toDt(this = '%s')\n", cd.вТкст0());
}

 проц StructDeclaration_toDt(StructDeclaration sd, ref DtBuilder dtb)
{
    //printf("+StructDeclaration.toDt(), this='%s'\n", sd.вТкст0());
    membersToDt(sd, dtb, null, 0, null);

    //printf("-StructDeclaration.toDt(), this='%s'\n", sd.вТкст0());
}

/******************************
 * Generate данные for instance of __cpp_type_info_ptr that refers
 * to the C++ RTTI symbol for cd.
 * Параметры:
 *      cd = C++ class
 *      dtb = данные table builder
 */
 проц cpp_type_info_ptr_toDt(ClassDeclaration cd, ref DtBuilder dtb)
{
    //printf("cpp_type_info_ptr_toDt(this = '%s')\n", cd.вТкст0());
    assert(cd.isCPPclass());

    // Put in first two члены, the vtbl[] and the monitor
    dtb.xoff(toVtblSymbol(ClassDeclaration.cpp_type_info_ptr), 0);
    if (ClassDeclaration.cpp_type_info_ptr.hasMonitor())
        dtb.size(0);             // monitor

    // Create symbol for C++ тип info
    Symbol *s = toSymbolCppTypeInfo(cd);

    // Put in address of cd's C++ тип info
    dtb.xoff(s, 0);

    //printf("-cpp_type_info_ptr_toDt(this = '%s')\n", cd.вТкст0());
}

/****************************************************
 * Put out initializers of ad.fields[].
 * Although this is consistent with the elements[] version, we
 * have to use this optimized version to reduce memory footprint.
 * Параметры:
 *      ad = aggregate with члены
 *      pdt = tail of инициализатор list to start appending initialized данные to
 *      elements = values to use as initializers, null means use default initializers
 *      firstFieldIndex = starting place is elements[firstFieldIndex]
 *      concreteType = structs: null, classes: most derived class
 *      ppb = pointer that moves through КлассОснова2[] from most derived class
 * Возвращает:
 *      updated tail of dt_t list
 */

private проц membersToDt(AggregateDeclaration ad, ref DtBuilder dtb,
        Выражения* elements, т_мера firstFieldIndex,
        ClassDeclaration concreteType,
        КлассОснова2*** ppb = null)
{
    //printf("membersToDt(ad = '%s', concrete = '%s', ppb = %p)\n", ad.вТкст0(), concreteType ? concreteType.вТкст0() : "null", ppb);
    ClassDeclaration cd = ad.isClassDeclaration();
    version (none)
    {
        printf(" interfaces.length = %d\n", cast(цел)cd.interfaces.length);
        foreach (i, b; cd.vtblInterfaces[])
        {
            printf("  vbtblInterfaces[%d] b = %p, b.sym = %s\n", cast(цел)i, b, b.sym.вТкст0());
        }
    }

    /* Order:
     *  { base class } or { __vptr, __monitor }
     *  interfaces
     *  fields
     */

    бцел смещение;
    if (cd)
    {
        if (ClassDeclaration cdb = cd.baseClass)
        {
            т_мера index = 0;
            for (ClassDeclaration c = cdb.baseClass; c; c = c.baseClass)
                index += c.fields.dim;
            membersToDt(cdb, dtb, elements, index, concreteType);
            смещение = cdb.structsize;
        }
        else if (InterfaceDeclaration ид = cd.isInterfaceDeclaration())
        {
            смещение = (**ppb).смещение;
            if (ид.vtblInterfaces.dim == 0)
            {
                КлассОснова2* b = **ppb;
                //printf("  Interface %s, b = %p\n", ид.вТкст0(), b);
                ++(*ppb);
                for (ClassDeclaration cd2 = concreteType; 1; cd2 = cd2.baseClass)
                {
                    assert(cd2);
                    бцел csymoffset = baseVtblOffset(cd2, b);
                    //printf("    cd2 %s csymoffset = x%x\n", cd2 ? cd2.вТкст0() : "null", csymoffset);
                    if (csymoffset != ~0)
                    {
                        dtb.xoff(toSymbol(cd2), csymoffset);
                        смещение += target.ptrsize;
                        break;
                    }
                }
            }
        }
        else
        {
            dtb.xoff(toVtblSymbol(concreteType), 0);  // __vptr
            смещение = target.ptrsize;
            if (cd.hasMonitor())
            {
                dtb.size(0);              // __monitor
                смещение += target.ptrsize;
            }
        }

        // Interface vptr initializations
        toSymbol(cd);                                         // define csym

        КлассОснова2** pb;
        if (!ppb)
        {
            pb = (*cd.vtblInterfaces)[].ptr;
            ppb = &pb;
        }

        foreach (si; cd.interfaces[])
        {
            КлассОснова2* b = **ppb;
            if (смещение < b.смещение)
                dtb.nzeros(b.смещение - смещение);
            membersToDt(si.sym, dtb, elements, firstFieldIndex, concreteType, ppb);
            //printf("b.смещение = %d, b.sym.structsize = %d\n", (цел)b.смещение, (цел)b.sym.structsize);
            смещение = b.смещение + b.sym.structsize;
        }
    }
    else
        смещение = 0;

    assert(!elements ||
           firstFieldIndex <= elements.dim &&
           firstFieldIndex + ad.fields.dim <= elements.dim);

    foreach (i, field; ad.fields)
    {
        if (elements && !(*elements)[firstFieldIndex + i])
            continue;

        if (!elements || !(*elements)[firstFieldIndex + i])
        {
            if (field._иниц && field._иниц.isVoidInitializer())
                continue;
        }

        VarDeclaration vd;
        т_мера k;
        foreach (j; new бцел[i .. ad.fields.length])
        {
            VarDeclaration v2 = ad.fields[j];
            if (v2.смещение < смещение)
                continue;

            if (elements && !(*elements)[firstFieldIndex + j])
                continue;

            if (!elements || !(*elements)[firstFieldIndex + j])
            {
                if (v2._иниц && v2._иниц.isVoidInitializer())
                    continue;
            }

            // найди the nearest field
            if (!vd || v2.смещение < vd.смещение)
            {
                vd = v2;
                k = j;
                assert(vd == v2 || !vd.isOverlappedWith(v2));
            }
        }
        if (!vd)
            continue;

        assert(смещение <= vd.смещение);
        if (смещение < vd.смещение)
            dtb.nzeros(vd.смещение - смещение);

        auto dtbx = DtBuilder(0);
        if (elements)
        {
            Выражение e = (*elements)[firstFieldIndex + k];
            if (auto tsa = vd.тип.toBasetype().isTypeSArray())
                toDtElem(tsa, dtbx, e);
            else
                Выражение_toDt(e, dtbx);    // convert e to an инициализатор dt
        }
        else
        {
            if (Инициализатор init = vd._иниц)
            {
                //printf("\t\t%s has инициализатор %s\n", vd.вТкст0(), init.вТкст0());
                if (init.isVoidInitializer())
                    continue;

                assert(vd.semanticRun >= PASS.semantic2done);

                auto ei = init.isExpInitializer();
                auto tsa = vd.тип.toBasetype().isTypeSArray();
                if (ei && tsa)
                    toDtElem(tsa, dtbx, ei.exp);
                else
                    Initializer_toDt(init, dtbx);
            }
            else if (смещение <= vd.смещение)
            {
                //printf("\t\tdefault инициализатор\n");
                Type_toDt(vd.тип, dtbx);
            }
            if (dtbx.isZeroLength())
                continue;
        }

        dtb.cat(dtbx);
        смещение = cast(бцел)(vd.смещение + vd.тип.size());
    }

    if (смещение < ad.structsize)
        dtb.nzeros(ad.structsize - смещение);
}


/* ================================================================= */

 проц Type_toDt(Тип t, ref DtBuilder dtb)
{
    switch (t.ty)
    {
        case Tvector:
            toDtElem(t.isTypeVector().basetype.isTypeSArray(), dtb, null);
            break;

        case Tsarray:
            toDtElem(t.isTypeSArray(), dtb, null);
            break;

        case Tstruct:
            StructDeclaration_toDt(t.isTypeStruct().sym, dtb);
            break;

        default:
            Выражение_toDt(t.defaultInit(Место.initial), dtb);
            break;
    }
}

private проц toDtElem(TypeSArray tsa, ref DtBuilder dtb, Выражение e)
{
    //printf("TypeSArray.toDtElem() tsa = %s\n", tsa.вТкст0());
    if (tsa.size(Место.initial) == 0)
    {
        dtb.nzeros(0);
    }
    else
    {
        т_мера len = cast(т_мера)tsa.dim.toInteger();
        assert(len);
        Тип tnext = tsa.следщ;
        Тип tbn = tnext.toBasetype();
        Тип ten = e ? e.тип : null;
        if (ten && (ten.ty == Tsarray || ten.ty == Tarray))
            ten = ten.nextOf();
        while (tbn.ty == Tsarray && (!e || !tbn.equivalent(ten)))
        {
            len *= tbn.isTypeSArray().dim.toInteger();
            tnext = tbn.nextOf();
            tbn = tnext.toBasetype();
        }
        if (!e)                             // if not already supplied
            e = tsa.defaultInit(Место.initial);    // use default инициализатор

        if (!e.тип.implicitConvTo(tnext))    // https://issues.dlang.org/show_bug.cgi?ид=14996
        {
            // https://issues.dlang.org/show_bug.cgi?ид=1914
            // https://issues.dlang.org/show_bug.cgi?ид=3198
            if (auto se = e.isStringExp())
                len /= se.numberOfCodeUnits();
            else if (auto ae = e.isArrayLiteralExp())
                len /= ae.elements.dim;
        }

        auto dtb2 = DtBuilder(0);
        Выражение_toDt(e, dtb2);
        dt_t* dt2 = dtb2.finish();
        assert(len <= бцел.max);
        dtb.repeat(dt2, cast(бцел)len);
    }
}

/*****************************************************/
/*                   CTFE stuff                      */
/*****************************************************/

private проц ClassReferenceExp_toDt(ClassReferenceExp e, ref DtBuilder dtb, цел off)
{
    //printf("ClassReferenceExp.toDt() %d\n", e.op);
    Symbol* s = toSymbol(e);
    dtb.xoff(s, off);
    if (e.тип.isMutable())
        write_instance_pointers(e.тип, s, 0);
}

 проц ClassReferenceExp_toInstanceDt(ClassReferenceExp ce, ref DtBuilder dtb)
{
    //printf("ClassReferenceExp.toInstanceDt() %d\n", ce.op);
    ClassDeclaration cd = ce.originalClass();

    // Put in the rest
    т_мера firstFieldIndex = 0;
    for (ClassDeclaration c = cd.baseClass; c; c = c.baseClass)
        firstFieldIndex += c.fields.dim;
    membersToDt(cd, dtb, ce.значение.elements, firstFieldIndex, cd);
}

/****************************************************
 */
private  class TypeInfoDtVisitor : Визитор2
{
    DtBuilder* dtb;

    /*
     * Used in TypeInfo*.toDt to verify the runtime TypeInfo sizes
     */
    static проц verifyStructSize(ClassDeclaration typeclass, т_мера expected)
    {
        if (typeclass.structsize != expected)
        {
            debug
            {
                printf("expected = x%x, %s.structsize = x%x\n", cast(бцел)expected,
                    typeclass.вТкст0(), cast(бцел)typeclass.structsize);
            }
            выведиОшибку(typeclass.место, "`%s`: mismatch between compiler (%d bytes) and объект.d or объект.di (%d bytes) found. Check installation and import paths with -v compiler switch.",
                typeclass.вТкст0(), cast(бцел)expected, cast(бцел)typeclass.structsize);
            fatal();
        }
    }

    this(ref DtBuilder dtb)
    {
        this.dtb = &dtb;
    }

    alias Визитор2.посети посети;

    override проц посети(TypeInfoDeclaration d)
    {
        //printf("TypeInfoDeclaration.toDt() %s\n", вТкст0());
        verifyStructSize(Тип.dtypeinfo, 2 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.dtypeinfo), 0);        // vtbl for TypeInfo
        if (Тип.dtypeinfo.hasMonitor())
            dtb.size(0);                                  // monitor
    }

    override проц посети(TypeInfoConstDeclaration d)
    {
        //printf("TypeInfoConstDeclaration.toDt() %s\n", вТкст0());
        verifyStructSize(Тип.typeinfoconst, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfoconst), 0);    // vtbl for TypeInfo_Const
        if (Тип.typeinfoconst.hasMonitor())
            dtb.size(0);                                  // monitor
        Тип tm = d.tinfo.mutableOf();
        tm = tm.merge();
        genTypeInfo(d.место, tm, null);
        dtb.xoff(toSymbol(tm.vtinfo), 0);
    }

    override проц посети(TypeInfoInvariantDeclaration d)
    {
        //printf("TypeInfoInvariantDeclaration.toDt() %s\n", вТкст0());
        verifyStructSize(Тип.typeinfoinvariant, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfoinvariant), 0);    // vtbl for TypeInfo_Invariant
        if (Тип.typeinfoinvariant.hasMonitor())
            dtb.size(0);                                      // monitor
        Тип tm = d.tinfo.mutableOf();
        tm = tm.merge();
        genTypeInfo(d.место, tm, null);
        dtb.xoff(toSymbol(tm.vtinfo), 0);
    }

    override проц посети(TypeInfoSharedDeclaration d)
    {
        //printf("TypeInfoSharedDeclaration.toDt() %s\n", вТкст0());
        verifyStructSize(Тип.typeinfoshared, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfoshared), 0);   // vtbl for TypeInfo_Shared
        if (Тип.typeinfoshared.hasMonitor())
            dtb.size(0);                                 // monitor
        Тип tm = d.tinfo.unSharedOf();
        tm = tm.merge();
        genTypeInfo(d.место, tm, null);
        dtb.xoff(toSymbol(tm.vtinfo), 0);
    }

    override проц посети(TypeInfoWildDeclaration d)
    {
        //printf("TypeInfoWildDeclaration.toDt() %s\n", вТкст0());
        verifyStructSize(Тип.typeinfowild, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfowild), 0); // vtbl for TypeInfo_Wild
        if (Тип.typeinfowild.hasMonitor())
            dtb.size(0);                              // monitor
        Тип tm = d.tinfo.mutableOf();
        tm = tm.merge();
        genTypeInfo(d.место, tm, null);
        dtb.xoff(toSymbol(tm.vtinfo), 0);
    }

    override проц посети(TypeInfoEnumDeclaration d)
    {
        //printf("TypeInfoEnumDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfoenum, 7 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfoenum), 0); // vtbl for TypeInfo_Enum
        if (Тип.typeinfoenum.hasMonitor())
            dtb.size(0);                              // monitor

        assert(d.tinfo.ty == Tenum);

        TypeEnum tc = cast(TypeEnum)d.tinfo;
        EnumDeclaration sd = tc.sym;

        /* Put out:
         *  TypeInfo base;
         *  ткст имя;
         *  проц[] m_init;
         */

        // TypeInfo for enum члены
        if (sd.memtype)
        {
            genTypeInfo(d.место, sd.memtype, null);
            dtb.xoff(toSymbol(sd.memtype.vtinfo), 0);
        }
        else
            dtb.size(0);

        // ткст имя;
        ткст0 имя = sd.toPrettyChars();
        т_мера namelen = strlen(имя);
        dtb.size(namelen);
        dtb.xoff(d.csym, Тип.typeinfoenum.structsize);

        // проц[] init;
        if (!sd.члены || d.tinfo.isZeroInit(Место.initial))
        {
            // 0 инициализатор, or the same as the base тип
            dtb.size(0);                     // init.length
            dtb.size(0);                     // init.ptr
        }
        else
        {
            dtb.size(sd.тип.size());      // init.length
            dtb.xoff(toInitializer(sd), 0);    // init.ptr
        }

        // Put out имя[] immediately following TypeInfo_Enum
        dtb.члобайт(cast(бцел)(namelen + 1), имя);
    }

    override проц посети(TypeInfoPointerDeclaration d)
    {
        //printf("TypeInfoPointerDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfopointer, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfopointer), 0);  // vtbl for TypeInfo_Pointer
        if (Тип.typeinfopointer.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tc = d.tinfo.isTypePointer();

        genTypeInfo(d.место, tc.следщ, null);
        dtb.xoff(toSymbol(tc.следщ.vtinfo), 0); // TypeInfo for тип being pointed to
    }

    override проц посети(TypeInfoArrayDeclaration d)
    {
        //printf("TypeInfoArrayDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfoarray, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfoarray), 0);    // vtbl for TypeInfo_Массив
        if (Тип.typeinfoarray.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tc = d.tinfo.isTypeDArray();

        genTypeInfo(d.место, tc.следщ, null);
        dtb.xoff(toSymbol(tc.следщ.vtinfo), 0); // TypeInfo for массив of тип
    }

    override проц посети(TypeInfoStaticArrayDeclaration d)
    {
        //printf("TypeInfoStaticArrayDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfostaticarray, 4 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfostaticarray), 0);  // vtbl for TypeInfo_StaticArray
        if (Тип.typeinfostaticarray.hasMonitor())
            dtb.size(0);                                      // monitor

        auto tc = d.tinfo.isTypeSArray();

        genTypeInfo(d.место, tc.следщ, null);
        dtb.xoff(toSymbol(tc.следщ.vtinfo), 0);   // TypeInfo for массив of тип

        dtb.size(tc.dim.toInteger());          // length
    }

    override проц посети(TypeInfoVectorDeclaration d)
    {
        //printf("TypeInfoVectorDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfovector, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfovector), 0);   // vtbl for TypeInfo_Vector
        if (Тип.typeinfovector.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tc = d.tinfo.isTypeVector();

        genTypeInfo(d.место, tc.basetype, null);
        dtb.xoff(toSymbol(tc.basetype.vtinfo), 0); // TypeInfo for equivalent static массив
    }

    override проц посети(TypeInfoAssociativeArrayDeclaration d)
    {
        //printf("TypeInfoAssociativeArrayDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfoassociativearray, 4 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfoassociativearray), 0); // vtbl for TypeInfo_AssociativeArray
        if (Тип.typeinfoassociativearray.hasMonitor())
            dtb.size(0);                    // monitor

        auto tc = d.tinfo.isTypeAArray();

        genTypeInfo(d.место, tc.следщ, null);
        dtb.xoff(toSymbol(tc.следщ.vtinfo), 0);   // TypeInfo for массив of тип

        genTypeInfo(d.место, tc.index, null);
        dtb.xoff(toSymbol(tc.index.vtinfo), 0);  // TypeInfo for массив of тип
    }

    override проц посети(TypeInfoFunctionDeclaration d)
    {
        //printf("TypeInfoFunctionDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfofunction, 5 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfofunction), 0); // vtbl for TypeInfo_Function
        if (Тип.typeinfofunction.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tc = d.tinfo.isTypeFunction();

        genTypeInfo(d.место, tc.следщ, null);
        dtb.xoff(toSymbol(tc.следщ.vtinfo), 0); // TypeInfo for function return значение

        const имя = d.tinfo.deco;
        assert(имя);
        const namelen = strlen(имя);
        dtb.size(namelen);
        dtb.xoff(d.csym, Тип.typeinfofunction.structsize);

        // Put out имя[] immediately following TypeInfo_Function
        dtb.члобайт(cast(бцел)(namelen + 1), имя);
    }

    override проц посети(TypeInfoDelegateDeclaration d)
    {
        //printf("TypeInfoDelegateDeclaration.toDt()\n");
        verifyStructSize(Тип.typeinfodelegate, 5 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfodelegate), 0); // vtbl for TypeInfo_Delegate
        if (Тип.typeinfodelegate.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tc = d.tinfo.isTypeDelegate();

        genTypeInfo(d.место, tc.следщ.nextOf(), null);
        dtb.xoff(toSymbol(tc.следщ.nextOf().vtinfo), 0); // TypeInfo for delegate return значение

        const имя = d.tinfo.deco;
        assert(имя);
        const namelen = strlen(имя);
        dtb.size(namelen);
        dtb.xoff(d.csym, Тип.typeinfodelegate.structsize);

        // Put out имя[] immediately following TypeInfo_Delegate
        dtb.члобайт(cast(бцел)(namelen + 1), имя);
    }

    override проц посети(TypeInfoStructDeclaration d)
    {
        //printf("TypeInfoStructDeclaration.toDt() '%s'\n", d.вТкст0());
        if (глоб2.парамы.is64bit)
            verifyStructSize(Тип.typeinfostruct, 17 * target.ptrsize);
        else
            verifyStructSize(Тип.typeinfostruct, 15 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfostruct), 0); // vtbl for TypeInfo_Struct
        if (Тип.typeinfostruct.hasMonitor())
            dtb.size(0);                                // monitor

        auto tc = d.tinfo.isTypeStruct();
        StructDeclaration sd = tc.sym;

        if (!sd.члены)
            return;

        if (TemplateInstance ti = sd.isInstantiated())
        {
            if (!ti.needsCodegen())
            {
                assert(ti.minst || sd.requestTypeInfo);

                /* ti.toObjFile() won't get called. So, store these
                 * member functions into объект файл in here.
                 */
                if (sd.xeq && sd.xeq != StructDeclaration.xerreq)
                    toObjFile(sd.xeq, глоб2.парамы.multiobj);
                if (sd.xcmp && sd.xcmp != StructDeclaration.xerrcmp)
                    toObjFile(sd.xcmp, глоб2.парамы.multiobj);
                if (FuncDeclaration ftostr = search_вТкст(sd))
                    toObjFile(ftostr, глоб2.парамы.multiobj);
                if (sd.xhash)
                    toObjFile(sd.xhash, глоб2.парамы.multiobj);
                if (sd.postblit)
                    toObjFile(sd.postblit, глоб2.парамы.multiobj);
                if (sd.dtor)
                    toObjFile(sd.dtor, глоб2.парамы.multiobj);
            }
        }

        /* Put out:
         *  ткст имя;
         *  проц[] init;
         *  hash_t function(in ук) xtoHash;
         *  бул function(in ук, in ук) xopEquals;
         *  цел function(in ук, in ук) xopCmp;
         *  ткст function(const(проц)*) xвТкст;
         *  StructFlags m_flags;
         *  //xgetMembers;
         *  xdtor;
         *  xpostblit;
         *  бцел m_align;
         *  version (X86_64)
         *      TypeInfo m_arg1;
         *      TypeInfo m_arg2;
         *  xgetRTInfo
         */

        const имя = sd.toPrettyChars();
        const namelen = strlen(имя);
        dtb.size(namelen);
        dtb.xoff(d.csym, Тип.typeinfostruct.structsize);

        // проц[] init;
        dtb.size(sd.structsize);            // init.length
        if (sd.zeroInit)
            dtb.size(0);                     // null for 0 initialization
        else
            dtb.xoff(toInitializer(sd), 0);    // init.ptr

        if (FuncDeclaration fd = sd.xhash)
        {
            dtb.xoff(toSymbol(fd), 0);
            TypeFunction tf = cast(TypeFunction)fd.тип;
            assert(tf.ty == Tfunction);
            /* I'm a little unsure this is the right way to do it. Perhaps a better
             * way would to automatically add these attributes to any struct member
             * function with the имя "toHash".
             * So I'm leaving this here as an experiment for the moment.
             */
            if (!tf.isnothrow || tf.trust == TRUST.system /*|| tf.purity == PURE.impure*/)
                warning(fd.место, "toHash() must be declared as extern (D) т_мера toHash() const  , not %s", tf.вТкст0());
        }
        else
            dtb.size(0);

        if (sd.xeq)
            dtb.xoff(toSymbol(sd.xeq), 0);
        else
            dtb.size(0);

        if (sd.xcmp)
            dtb.xoff(toSymbol(sd.xcmp), 0);
        else
            dtb.size(0);

        if (FuncDeclaration fd = search_вТкст(sd))
        {
            dtb.xoff(toSymbol(fd), 0);
        }
        else
            dtb.size(0);

        // StructFlags m_flags;
        StructFlags m_flags = StructFlags.none;
        if (tc.hasPointers()) m_flags |= StructFlags.hasPointers;
        dtb.size(m_flags);

        version (none)
        {
            // xgetMembers
            if (auto sgetmembers = sd.findGetMembers())
                dtb.xoff(toSymbol(sgetmembers), 0);
            else
                dtb.size(0);                     // xgetMembers
        }

        // xdtor
        if (auto sdtor = sd.tidtor)
            dtb.xoff(toSymbol(sdtor), 0);
        else
            dtb.size(0);                     // xdtor

        // xpostblit
        FuncDeclaration spostblit = sd.postblit;
        if (spostblit && !(spostblit.класс_хранения & STC.disable))
            dtb.xoff(toSymbol(spostblit), 0);
        else
            dtb.size(0);                     // xpostblit

        // бцел m_align;
        dtb.size(tc.alignsize());

        if (глоб2.парамы.is64bit)
        {
            Тип t = sd.arg1type;
            foreach (i; new бцел[0 .. 2])
            {
                // m_argi
                if (t)
                {
                    genTypeInfo(d.место, t, null);
                    dtb.xoff(toSymbol(t.vtinfo), 0);
                }
                else
                    dtb.size(0);

                t = sd.arg2type;
            }
        }

        // xgetRTInfo
        if (sd.getRTInfo)
        {
            Выражение_toDt(sd.getRTInfo, *dtb);
        }
        else if (m_flags & StructFlags.hasPointers)
            dtb.size(1);
        else
            dtb.size(0);

        // Put out имя[] immediately following TypeInfo_Struct
        dtb.члобайт(cast(бцел)(namelen + 1), имя);
    }

    override проц посети(TypeInfoClassDeclaration d)
    {
        //printf("TypeInfoClassDeclaration.toDt() %s\n", tinfo.вТкст0());
        assert(0);
    }

    override проц посети(TypeInfoInterfaceDeclaration d)
    {
        //printf("TypeInfoInterfaceDeclaration.toDt() %s\n", tinfo.вТкст0());
        verifyStructSize(Тип.typeinfointerface, 3 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfointerface), 0);    // vtbl for TypeInfoInterface
        if (Тип.typeinfointerface.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tc = d.tinfo.isTypeClass();

        if (!tc.sym.vclassinfo)
            tc.sym.vclassinfo = TypeInfoClassDeclaration.создай(tc);
        auto s = toSymbol(tc.sym.vclassinfo);
        dtb.xoff(s, 0);    // ClassInfo for tinfo
    }

    override проц посети(TypeInfoTupleDeclaration d)
    {
        //printf("TypeInfoTupleDeclaration.toDt() %s\n", tinfo.вТкст0());
        verifyStructSize(Тип.typeinfotypelist, 4 * target.ptrsize);

        dtb.xoff(toVtblSymbol(Тип.typeinfotypelist), 0); // vtbl for TypeInfoInterface
        if (Тип.typeinfotypelist.hasMonitor())
            dtb.size(0);                                  // monitor

        auto tu = d.tinfo.isTypeTuple();

        const dim = tu.arguments.dim;
        dtb.size(dim);                       // elements.length

        auto dtbargs = DtBuilder(0);
        foreach (arg; *tu.arguments)
        {
            genTypeInfo(d.место, arg.тип, null);
            Symbol* s = toSymbol(arg.тип.vtinfo);
            dtbargs.xoff(s, 0);
        }

        dtb.dtoff(dtbargs.finish(), 0);                  // elements.ptr
    }
}

 проц TypeInfo_toDt(ref DtBuilder dtb, TypeInfoDeclaration d)
{
    scope v = new TypeInfoDtVisitor(dtb);
    d.прими(v);
}
