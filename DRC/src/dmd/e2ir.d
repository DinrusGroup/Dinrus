/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/e2ir.d, _e2ir.d)
 * Documentation: https://dlang.org/phobos/dmd_e2ir.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/e2ir.d
 */

module dmd.e2ir;

import cidrus;

import util.array;
import util.ctfloat;
import util.rmem;
import drc.ast.Node;
import util.stringtable;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import dmd.canthrow;
import dmd.ctfeexpr;
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
import drc.lexer.Id;
import dmd.init;
import dmd.irstate;
import dmd.mtype;
import dmd.objc_glue;
import dmd.s2ir;
import dmd.sideeffect;
import dmd.инструкция;
import dmd.target;
import dmd.tocsym;
import dmd.toctype;
import dmd.toir;
import drc.lexer.Tokens;
import dmd.toobj;
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
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

import util.outbuffer : БуфВыв;
import dmd.dmangle;
import drc.backend.md5;
/*extern (C++):*/

alias  МассивДРК!(elem *) Elems;

alias  dmd.tocsym.toSymbol toSymbol;
alias  dmd.glue.toSymbol toSymbol;

ук mem_malloc2(бцел);


 цел REGSIZE() { return _tysize[TYnptr]; }

/* If variable var is a reference
 */
бул ISREF(Declaration var)
{
    if (var.isOut() || var.isRef())
    {
        return да;
    }

    return ISX64REF(var);
}

/* If variable var of тип typ is a reference due to x64 calling conventions
 */
бул ISX64REF(Declaration var)
{
    if (var.isOut() || var.isRef())
    {
        return нет;
    }

    if (var.isParameter())
    {
        if (config.exe == EX_WIN64)
        {
            return var.тип.size(Место.initial) > REGSIZE
                || (var.класс_хранения & STC.lazy_)
                || (var.тип.isTypeStruct() && !var.тип.isTypeStruct().sym.isPOD());
        }
        else if (!глоб2.парамы.isWindows)
        {
            return !(var.класс_хранения & STC.lazy_) && var.тип.isTypeStruct() && !var.тип.isTypeStruct().sym.isPOD();
        }
    }

    return нет;
}

/* If variable exp of тип typ is a reference due to x64 calling conventions
 */
бул ISX64REF(IRState* irs, Выражение exp)
{
    if (config.exe == EX_WIN64)
    {
        return exp.тип.size(Место.initial) > REGSIZE
            || (exp.тип.isTypeStruct() && !exp.тип.isTypeStruct().sym.isPOD());
    }
    else if (!irs.парамы.isWindows)
    {
        return exp.тип.isTypeStruct() && !exp.тип.isTypeStruct().sym.isPOD();
    }

    return нет;
}

/******************************************
 * If argument to a function should use OPstrpar,
 * fix it so it does and return it.
 */
private elem *useOPstrpar(elem *e)
{
    tym_t ty = tybasic(e.Ety);
    if (ty == TYstruct || ty == TYarray)
    {
        e = el_una(OPstrpar, TYstruct, e);
        e.ET = e.EV.E1.ET;
        assert(e.ET);
    }
    return e;
}

/************************************
 * Call a function.
 */

private elem *callfunc(ref Место место,
        IRState *irs,
        цел directcall,         // 1: don't do virtual call
        Тип tret,              // return тип
        elem *ec,               // evaluates to function address
        Тип ectype,            // original тип of ec
        FuncDeclaration fd,     // if !=NULL, this is the function being called
        Тип t,                 // TypeDelegate or TypeFunction for this function
        elem *ehidden,          // if !=null, this is the 'hidden' argument
        Выражения *arguments,
        elem *esel = null,      // selector for Objective-C methods (when not provided by fd)
        elem *ethis2 = null)    // multi-context массив
{
    elem *ethis = null;
    elem *eside = null;
    elem *eрезультат = ehidden;

    version (none)
    {
        printf("callfunc(directcall = %d, tret = '%s', ec = %p, fd = %p)\n",
            directcall, tret.вТкст0(), ec, fd);
        printf("ec: "); elem_print(ec);
        if (fd)
            printf("fd = '%s', vtblIndex = %d, isVirtual() = %d\n", fd.вТкст0(), fd.vtblIndex, fd.isVirtual());
        if (ehidden)
        {   printf("ehidden: "); elem_print(ehidden); }
    }

    t = t.toBasetype();
    TypeFunction tf = t.isTypeFunction();
    if (!tf)
    {
        assert(t.ty == Tdelegate);
        // A delegate consists of:
        //      { Object *this; Function *funcptr; }
        assert(!fd);
        tf = t.nextOf().isTypeFunction();
        assert(tf);
        ethis = ec;
        ec = el_same(&ethis);
        ethis = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYnptr, ethis); // get this
        ec = array_toPtr(t, ec);                // get funcptr
        ec = el_una(OPind, totym(tf), ec);
    }

    const ty = fd ? toSymbol(fd).Stype.Tty : ec.Ety;
    const left_to_right = tyrevfunc(ty);   // left-to-right параметр evaluation
                                           // (TYnpfunc, TYjfunc, TYfpfunc, TYf16func)
    elem* ep = null;
    const op = fd ? intrinsic_op(fd) : NotIntrinsic;
    if (arguments && arguments.dim)
    {
        if (op == OPvector)
        {
            Выражение arg = (*arguments)[0];
            if (arg.op != ТОК2.int64)
                arg.выведиОшибку("simd operator must be an integer constant, not `%s`", arg.вТкст0());
        }

        /* Convert arguments[] to elems[] in left-to-right order
         */
        const n = arguments.dim;
        debug
            elem*[2] elems_array = проц;
        else
            elem*[10] elems_array = проц;
        
        auto pe = (n <= elems_array.length)
                  ? elems_array.ptr
                  : cast(elem**)Пам.check(malloc(arguments.dim * (elem*).sizeof));
        elem*[] elems = pe[0 .. n];

        /* Fill elems[] with arguments converted to elems
         */

        // j=1 if _arguments[] is first argument
        const цел j = tf.isDstyleVariadic();

        foreach (i, arg; *arguments)
        {
            elem *ea = toElem(arg, irs);

            //printf("\targ[%d]: %s\n", i, arg.вТкст0());

            if (i - j < tf.parameterList.length &&
                i >= j &&
                tf.parameterList[i - j].классХранения & (STC.out_ | STC.ref_))
            {
                /* `ref` and `out` parameters mean convert
                 * corresponding argument to a pointer
                 */
                elems[i] = addressElem(ea, arg.тип.pointerTo());
                continue;
            }

            if (ISX64REF(irs, arg) && op == NotIntrinsic)
            {
                /* Copy to a temporary, and make the argument a pointer
                 * to that temporary.
                 */
                elems[i] = addressElem(ea, arg.тип, да);
                continue;
            }

            if (config.exe == EX_WIN64 && tybasic(ea.Ety) == TYcfloat)
            {
                /* Treat a cfloat like it was a struct { float re,im; }
                 */
                ea.Ety = TYllong;
            }
            elems[i] = ea;
        }
        if (!left_to_right)
        {
            /* Avoid 'fixing' side effects of _array... functions as
             * they were already working right from the olden days before this fix
             */
            if (!(ec.Eoper == OPvar && fd.isArrayOp))
                eside = fixArgumentEvaluationOrder(elems);
        }

        foreach (ref e; elems)
        {
            e = useOPstrpar(e);
        }

        if (!left_to_right)   // swap order if right-to-left
            reverse(elems);

        ep = el_params(cast(ук*)elems.ptr, cast(цел)n);

        if (elems.ptr != elems_array.ptr)
            free(elems.ptr);
    }

    objc.setupMethodSelector(fd, &esel);
    objc.setupEp(esel, &ep, left_to_right);

    const retmethod = retStyle(tf, fd && fd.needThis());
    if (retmethod == RET.stack)
    {
        if (!ehidden)
        {
            // Don't have one, so создай one
            тип *tc;

            Тип tret2 = tf.следщ;
            if (tret2.toBasetype().ty == Tstruct ||
                tret2.toBasetype().ty == Tsarray)
                tc = Type_toCtype(tret2);
            else
                tc = type_fake(totym(tret2));
            Symbol *stmp = symbol_genauto(tc);
            ehidden = el_ptr(stmp);
            eрезультат = ehidden;
        }
        if (target.isPOSIX && tf.компонаж != LINK.d)
        {
                // ehidden goes last on Linux/OSX C++
        }
        else
        {
            if (ep)
            {
                /* // BUG: implement
                if (left_to_right && type_mangle(tfunc) == mTYman_cpp)
                    ep = el_param(ehidden,ep);
                else
                */
                    ep = el_param(ep,ehidden);
            }
            else
                ep = ehidden;
            ehidden = null;
        }
    }

    if (fd && fd.isMemberLocal())
    {
        assert(op == NotIntrinsic);       // члены should not be intrinsics

        AggregateDeclaration ad = fd.isThis();
        if (ad)
        {
            ethis = ec;
            if (ad.isStructDeclaration() && tybasic(ec.Ety) != TYnptr)
            {
                ethis = addressElem(ec, ectype);
            }
            if (ethis2)
            {
                ethis2 = setEthis2(место, irs, fd, ethis2, &ethis, &eside);
            }
            if (el_sideeffect(ethis))
            {
                elem *ex = ethis;
                ethis = el_copytotmp(&ex);
                eside = el_combine(ex, eside);
            }
        }
        else
        {
            // Evaluate ec for side effects
            eside = el_combine(ec, eside);
        }
        Symbol *sfunc = toSymbol(fd);

        if (esel)
        {
            auto результат = objc.setupMethodCall(fd, tf, directcall != 0, ec, ehidden, ethis);
            ec = результат.ec;
            ethis = результат.ethis;
        }
        else if (!fd.isVirtual() ||
            directcall ||               // BUG: fix
            fd.isFinalFunc()
           /* Future optimization: || (whole program analysis && not overridden)
            */
           )
        {
            // make static call
            ec = el_var(sfunc);
        }
        else
        {
            // make virtual call
            assert(ethis);
            elem *ev = el_same(&ethis);
            ev = el_una(OPind, TYnptr, ev);
            бцел vindex = fd.vtblIndex;
            assert(cast(цел)vindex >= 0);

            // Build *(ev + vindex * 4)
if (!irs.парамы.is64bit) assert(tysize(TYnptr) == 4);
            ec = el_bin(OPadd,TYnptr,ev,el_long(TYт_мера, vindex * tysize(TYnptr)));
            ec = el_una(OPind,TYnptr,ec);
            ec = el_una(OPind,tybasic(sfunc.Stype.Tty),ec);
        }
    }
    else if (fd && fd.isNested())
    {
        assert(!ethis);
        ethis = getEthis(место, irs, fd, fd.toParentLocal());
        if (ethis2)
            ethis2 = setEthis2(место, irs, fd, ethis2, &ethis, &eside);
    }

    ep = el_param(ep, ethis2 ? ethis2 : ethis);
    if (ehidden)
        ep = el_param(ep, ehidden);     // if ehidden goes last

    const tyret = totym(tret);

    // Look for intrinsic functions and construct результат into e
    elem *e;
    if (ec.Eoper == OPvar && op != NotIntrinsic)
    {
        el_free(ec);
        if (op != OPtoPrec && OTbinary(op))
        {
            ep.Eoper = cast(ббайт)op;
            ep.Ety = tyret;
            e = ep;
            if (op == OPeq)
            {   /* This was a volatileStore(ptr, значение) operation, rewrite as:
                 *   *ptr = значение
                 */
                e.EV.E1 = el_una(OPind, e.EV.E2.Ety | mTYvolatile, e.EV.E1);
            }
            if (op == OPscale)
            {
                elem *et = e.EV.E1;
                e.EV.E1 = el_una(OPs32_d, TYdouble, e.EV.E2);
                e.EV.E1 = el_una(OPd_ld, TYldouble, e.EV.E1);
                e.EV.E2 = et;
            }
            else if (op == OPyl2x || op == OPyl2xp1)
            {
                elem *et = e.EV.E1;
                e.EV.E1 = e.EV.E2;
                e.EV.E2 = et;
            }
        }
        else if (op == OPvector)
        {
            e = ep;
            /* Recognize store operations as:
             *  (op OPparam (op1 OPparam op2))
             * Rewrite as:
             *  (op1 OPvecsto (op OPparam op2))
             * A separate operation is используется for stores because it
             * has a side effect, and so takes a different path through
             * the optimizer.
             */
            if (e.Eoper == OPparam &&
                e.EV.E1.Eoper == OPconst &&
                isXMMstore(cast(бцел)el_tolong(e.EV.E1)))
            {
                //printf("OPvecsto\n");
                elem *tmp = e.EV.E1;
                e.EV.E1 = e.EV.E2.EV.E1;
                e.EV.E2.EV.E1 = tmp;
                e.Eoper = OPvecsto;
                e.Ety = tyret;
            }
            else
                e = el_una(op,tyret,ep);
        }
        else if (op == OPind)
            e = el_una(op,mTYvolatile | tyret,ep);
        else if (op == OPva_start && irs.парамы.is64bit)
        {
            // (OPparam &va &arg)
            // call as (OPva_start &va)
            ep.Eoper = cast(ббайт)op;
            ep.Ety = tyret;
            e = ep;

            elem *earg = e.EV.E2;
            e.EV.E2 = null;
            e = el_combine(earg, e);
        }
        else if (op == OPtoPrec)
        {
            static цел X(цел fty, цел tty) { return fty * TMAX + tty; }

            switch (X(tybasic(ep.Ety), tyret))
            {
            case X(TYfloat, TYfloat):     // float -> float
            case X(TYdouble, TYdouble):   // double -> double
            case X(TYldouble, TYldouble): // real -> real
                e = ep;
                break;

            case X(TYfloat, TYdouble):    // float -> double
                e = el_una(OPf_d, tyret, ep);
                break;

            case X(TYfloat, TYldouble):   // float -> real
                e = el_una(OPf_d, TYdouble, ep);
                e = el_una(OPd_ld, tyret, e);
                break;

            case X(TYdouble, TYfloat):    // double -> float
                e = el_una(OPd_f, tyret, ep);
                break;

            case X(TYdouble, TYldouble):  // double -> real
                e = el_una(OPd_ld, tyret, ep);
                break;

            case X(TYldouble, TYfloat):   // real -> float
                e = el_una(OPld_d, TYdouble, ep);
                e = el_una(OPd_f, tyret, e);
                break;

            case X(TYldouble, TYdouble):  // real -> double
                e = el_una(OPld_d, tyret, ep);
                break;
            }
        }
        else
            e = el_una(op,tyret,ep);
    }
    else
    {
        /* Do not do "no side effect" calls if a hidden параметр is passed,
         * as the return значение is stored through the hidden параметр, which
         * is a side effect.
         */
        //printf("1: fd = %p prity = %d,  = %d, retmethod = %d, use-assert = %d\n",
        //       fd, (fd ? fd.isPure() : tf.purity), tf.isnothrow, retmethod, irs.парамы.useAssert);
        //printf("\tfd = %s, tf = %s\n", fd.вТкст0(), tf.вТкст0());
        /* assert() has 'implicit side effect' so disable this optimization.
         */
        цел ns = ((fd ? callSideEffectLevel(fd)
                      : callSideEffectLevel(t)) == 2 &&
                  retmethod != RET.stack &&
                  irs.парамы.useAssert == CHECKENABLE.off && irs.парамы.optimize);
        if (ep)
            e = el_bin(ns ? OPcallns : OPcall, tyret, ec, ep);
        else
            e = el_una(ns ? OPucallns : OPucall, tyret, ec);

        if (tf.parameterList.varargs != ВарАрг.none)
            e.Eflags |= EFLAGS_variadic;
    }

    const isCPPCtor = fd && fd.компонаж == LINK.cpp && fd.isCtorDeclaration();
    if (isCPPCtor && target.isPOSIX)
    {
        // CPP constructor returns проц on Posix
        // https://itanium-cxx-abi.github.io/cxx-abi/abi.html#return-значение-ctor
        e.Ety = TYvoid;
        e = el_combine(e, el_same(&ethis));
    }
    else if (retmethod == RET.stack)
    {
        if (irs.парамы.isOSX && eрезультат)
            /* ABI quirk: hidden pointer is not returned in registers
             */
            e = el_combine(e, el_copytree(eрезультат));
        e.Ety = TYnptr;
        e = el_una(OPind, tyret, e);
    }

    if (tf.isref)
    {
        e.Ety = TYnptr;
        e = el_una(OPind, tyret, e);
    }

    if (tybasic(tyret) == TYstruct)
    {
        e.ET = Type_toCtype(tret);
    }
    e = el_combine(eside, e);
    return e;
}

/**********************************
 * D presumes left-to-right argument evaluation, but we're evaluating things
 * right-to-left here.
 * 1. determine if this matters
 * 2. fix it if it does
 * Параметры:
 *      arguments = function arguments, these will get rewritten in place
 * Возвращает:
 *      elem that evaluates the side effects
 */
private extern (D) elem *fixArgumentEvaluationOrder(elem*[] elems)
{
    /* It matters if all are да:
     * 1. at least one argument has side effects
     * 2. at least one other argument may depend on side effects
     */
    if (elems.length <= 1)
        return null;

    т_мера ifirstside = 0;      // index-1 of first side effect
    т_мера ifirstdep = 0;       // index-1 of first dependency on side effect
    foreach (i, e; elems)
    {
        switch (e.Eoper)
        {
            case OPconst:
            case OPrelconst:
            case OPstring:
                continue;

            default:
                break;
        }

        if (el_sideeffect(e))
        {
            if (!ifirstside)
                ifirstside = i + 1;
            else if (!ifirstdep)
                ifirstdep = i + 1;
        }
        else
        {
            if (!ifirstdep)
                ifirstdep = i + 1;
        }
        if (ifirstside && ifirstdep)
            break;
    }

    if (!ifirstdep || !ifirstside)
        return null;

    /* Now fix by appending side effects and dependencies to eside and replacing
     * argument with a temporary.
     * Rely on the optimizer removing some unneeded ones using flow analysis.
     */
    elem* eside = null;
    foreach (i, e; elems)
    {
        while (e.Eoper == OPcomma)
        {
            eside = el_combine(eside, e.EV.E1);
            e = e.EV.E2;
            elems[i] = e;
        }

        switch (e.Eoper)
        {
            case OPconst:
            case OPrelconst:
            case OPstring:
                continue;

            default:
                break;
        }

        elem *es = e;
        elems[i] = el_copytotmp(&es);
        eside = el_combine(eside, es);
    }

    return eside;
}

/*******************************************
 * Take address of an elem.
 */

elem *addressElem(elem *e, Тип t, бул alwaysCopy = нет)
{
    //printf("addressElem()\n");

    elem **pe;
    for (pe = &e; (*pe).Eoper == OPcomma; pe = &(*pe).EV.E2)
    {
    }

    // For conditional operator, both branches need conversion.
    if ((*pe).Eoper == OPcond)
    {
        elem *ec = (*pe).EV.E2;

        ec.EV.E1 = addressElem(ec.EV.E1, t, alwaysCopy);
        ec.EV.E2 = addressElem(ec.EV.E2, t, alwaysCopy);

        (*pe).Ejty = (*pe).Ety = cast(ббайт)ec.EV.E1.Ety;
        (*pe).ET = ec.EV.E1.ET;

        e.Ety = TYnptr;
        return e;
    }

    if (alwaysCopy || ((*pe).Eoper != OPvar && (*pe).Eoper != OPind))
    {
        elem *e2 = *pe;
        тип *tx;

        // Convert to ((tmp=e2),tmp)
        TY ty;
        if (t && ((ty = t.toBasetype().ty) == Tstruct || ty == Tsarray))
            tx = Type_toCtype(t);
        else if (tybasic(e2.Ety) == TYstruct)
        {
            assert(t);                  // don't know of a case where this can be null
            tx = Type_toCtype(t);
        }
        else
            tx = type_fake(e2.Ety);
        Symbol *stmp = symbol_genauto(tx);

        elem *eeq = elAssign(el_var(stmp), e2, t, tx);
        *pe = el_bin(OPcomma,e2.Ety,eeq,el_var(stmp));
    }
    tym_t typ = TYnptr;
    if (e.Eoper == OPind && tybasic(e.EV.E1.Ety) == TYimmutPtr)
        typ = TYimmutPtr;
    e = el_una(OPaddr,typ,e);
    return e;
}

/***************************************
 * Return `да` if elem is a an lvalue.
 * Lvalue elems are OPvar and OPind.
 */

бул elemIsLvalue(elem* e)
{
    while (e.Eoper == OPcomma || e.Eoper == OPinfo)
        e = e.EV.E2;

    // For conditional operator, both branches need to be lvalues.
    if (e.Eoper == OPcond)
    {
        elem* ec = e.EV.E2;
        return elemIsLvalue(ec.EV.E1) && elemIsLvalue(ec.EV.E2);
    }

    return e.Eoper == OPvar || e.Eoper == OPind;
}

/*****************************************
 * Convert массив to a pointer to the данные.
 * Параметры:
 *      t = массив тип
 *      e = массив to convert, it is "consumed" by the function
 * Возвращает:
 *      e rebuilt into a pointer to the данные
 */

elem *array_toPtr(Тип t, elem *e)
{
    //printf("array_toPtr()\n");
    //elem_print(e);
    t = t.toBasetype();
    switch (t.ty)
    {
        case Tpointer:
            break;

        case Tarray:
        case Tdelegate:
            if (e.Eoper == OPcomma)
            {
                e.Ety = TYnptr;
                e.EV.E2 = array_toPtr(t, e.EV.E2);
            }
            else if (e.Eoper == OPpair)
            {
                if (el_sideeffect(e.EV.E1))
                {
                    e.Eoper = OPcomma;
                    e.Ety = TYnptr;
                }
                else
                {
                    auto r = e;
                    e = e.EV.E2;
                    e.Ety = TYnptr;
                    r.EV.E2 = null;
                    el_free(r);
                }
            }
            else
            {
version (all)
                e = el_una(OPmsw, TYnptr, e);
else
{
                e = el_una(OPaddr, TYnptr, e);
                e = el_bin(OPadd, TYnptr, e, el_long(TYт_мера, 4));
                e = el_una(OPind, TYnptr, e);
}
            }
            break;

        case Tsarray:
            //e = el_una(OPaddr, TYnptr, e);
            e = addressElem(e, t);
            break;

        default:
            printf("%s\n", t.вТкст0());
            assert(0);
    }
    return e;
}

/*****************************************
 * Convert массив to a dynamic массив.
 */

elem *array_toDarray(Тип t, elem *e)
{
    бцел dim;
    elem *ef = null;
    elem *ex;

    //printf("array_toDarray(t = %s)\n", t.вТкст0());
    //elem_print(e);
    t = t.toBasetype();
    switch (t.ty)
    {
        case Tarray:
            break;

        case Tsarray:
            e = addressElem(e, t);
            dim = cast(бцел)(cast(TypeSArray)t).dim.toInteger();
            e = el_pair(TYdarray, el_long(TYт_мера, dim), e);
            break;

        default:
        L1:
            switch (e.Eoper)
            {
                case OPconst:
                {
                    т_мера len = tysize(e.Ety);
                    elem *es = el_calloc();
                    es.Eoper = OPstring;

                    // freed in el_free
                    es.EV.Vstring = cast(сим*)mem_malloc2(cast(бцел)len);
                    memcpy(es.EV.Vstring, &e.EV, len);

                    es.EV.Vstrlen = len;
                    es.Ety = TYnptr;
                    e = es;
                    break;
                }

                case OPvar:
                    e = el_una(OPaddr, TYnptr, e);
                    break;

                case OPcomma:
                    ef = el_combine(ef, e.EV.E1);
                    ex = e;
                    e = e.EV.E2;
                    ex.EV.E1 = null;
                    ex.EV.E2 = null;
                    el_free(ex);
                    goto L1;

                case OPind:
                    ex = e;
                    e = e.EV.E1;
                    ex.EV.E1 = null;
                    ex.EV.E2 = null;
                    el_free(ex);
                    break;

                default:
                {
                    // Copy Выражение to a variable and take the
                    // address of that variable.
                    e = addressElem(e, t);
                    break;
                }
            }
            dim = 1;
            e = el_pair(TYdarray, el_long(TYт_мера, dim), e);
            break;
    }
    return el_combine(ef, e);
}

/************************************
 */

elem *sarray_toDarray(ref Место место, Тип tfrom, Тип tto, elem *e)
{
    //printf("sarray_toDarray()\n");
    //elem_print(e);

    dinteger_t dim = (cast(TypeSArray)tfrom).dim.toInteger();

    if (tto)
    {
        бцел fsize = cast(бцел)tfrom.nextOf().size();
        бцел tsize = cast(бцел)tto.nextOf().size();

        if ((dim * fsize) % tsize != 0)
        {
            // have to change to Internal Compiler Error?
            выведиОшибку(место, "cannot cast %s to %s since sizes don't line up", tfrom.вТкст0(), tto.вТкст0());
        }
        dim = (dim * fsize) / tsize;
    }
    elem *elen = el_long(TYт_мера, dim);
    e = addressElem(e, tfrom);
    e = el_pair(TYdarray, elen, e);
    return e;
}

/************************************
 */

elem *getTypeInfo(Место место, Тип t, IRState *irs)
{
    assert(t.ty != Terror);
    genTypeInfo(место, t, null);
    elem *e = el_ptr(toSymbol(t.vtinfo));
    return e;
}

/********************************************
 * Determine if t is a struct that has postblit.
 */
StructDeclaration needsPostblit(Тип t)
{
    if (auto ts = t.baseElemOf().isTypeStruct())
    {
        StructDeclaration sd = ts.sym;
        if (sd.postblit)
            return sd;
    }
    return null;
}

/********************************************
 * Determine if t is a struct that has destructor.
 */
StructDeclaration needsDtor(Тип t)
{
    if (auto ts = t.baseElemOf().isTypeStruct())
    {
        StructDeclaration sd = ts.sym;
        if (sd.dtor)
            return sd;
    }
    return null;
}

/*******************************************
 * Set an массив pointed to by eptr to evalue:
 *      eptr[0..edim] = evalue;
 * Параметры:
 *      exp    = the Выражение for which this operation is performed
 *      eptr   = where to пиши the данные to
 *      edim   = number of times to пиши evalue to eptr[]
 *      tb     = тип of evalue
 *      evalue = значение to пиши
 *      irs    = context
 *      op     = ТОК2.blit, ТОК2.assign, or ТОК2.construct
 * Возвращает:
 *      created IR code
 */
private elem *setArray(Выражение exp, elem *eptr, elem *edim, Тип tb, elem *evalue, IRState *irs, цел op)
{
    assert(op == ТОК2.blit || op == ТОК2.assign || op == ТОК2.construct);
    const sz = cast(бцел)tb.size();

Lagain:
    цел r;
    switch (tb.ty)
    {
        case Tfloat80:
        case Timaginary80:
            r = RTLSYM_MEMSET80;
            break;
        case Tcomplex80:
            r = RTLSYM_MEMSET160;
            break;
        case Tcomplex64:
            r = RTLSYM_MEMSET128;
            break;
        case Tfloat32:
        case Timaginary32:
            if (!irs.парамы.is64bit)
                goto default;          // legacy binary compatibility
            r = RTLSYM_MEMSETFLOAT;
            break;
        case Tfloat64:
        case Timaginary64:
            if (!irs.парамы.is64bit)
                goto default;          // legacy binary compatibility
            r = RTLSYM_MEMSETDOUBLE;
            break;

        case Tstruct:
        {
            if (!irs.парамы.is64bit)
                goto default;

            TypeStruct tc = cast(TypeStruct)tb;
            StructDeclaration sd = tc.sym;
            if (sd.arg1type && !sd.arg2type)
            {
                tb = sd.arg1type;
                goto Lagain;
            }
            goto default;
        }

        case Tvector:
            r = RTLSYM_MEMSETSIMD;
            break;

        default:
            switch (sz)
            {
                case 1:      r = RTLSYM_MEMSET8;    break;
                case 2:      r = RTLSYM_MEMSET16;   break;
                case 4:      r = RTLSYM_MEMSET32;   break;
                case 8:      r = RTLSYM_MEMSET64;   break;
                case 16:     r = irs.парамы.is64bit ? RTLSYM_MEMSET128ii : RTLSYM_MEMSET128; break;
                default:     r = RTLSYM_MEMSETN;    break;
            }

            /* Determine if we need to do postblit
             */
            if (op != ТОК2.blit)
            {
                if (needsPostblit(tb) || needsDtor(tb))
                {
                    /* Need to do postblit/destructor.
                     *   проц *_d_arraysetassign(проц *p, проц *значение, цел dim, TypeInfo ti);
                     */
                    r = (op == ТОК2.construct) ? RTLSYM_ARRAYSETCTOR : RTLSYM_ARRAYSETASSIGN;
                    evalue = el_una(OPaddr, TYnptr, evalue);
                    // This is a hack so we can call postblits on const/const objects.
                    elem *eti = getTypeInfo(exp.место, tb.unSharedOf().mutableOf(), irs);
                    elem *e = el_params(eti, edim, evalue, eptr, null);
                    e = el_bin(OPcall,TYnptr,el_var(getRtlsym(r)),e);
                    return e;
                }
            }

            if (irs.парамы.is64bit && tybasic(evalue.Ety) == TYstruct && r != RTLSYM_MEMSETN)
            {
                /* If this struct is in-memory only, i.e. cannot necessarily be passed as
                 * a gp register параметр.
                 * The trouble is that memset() is expecting the argument to be in a gp
                 * register, but the argument pusher may have other ideas on I64.
                 * MEMSETN is inefficient, though.
                 */
                if (tybasic(evalue.ET.Tty) == TYstruct)
                {
                    тип *t1 = evalue.ET.Ttag.Sstruct.Sarg1type;
                    тип *t2 = evalue.ET.Ttag.Sstruct.Sarg2type;
                    if (!t1 && !t2)
                    {
                        if (config.exe != EX_WIN64 || sz > 8)
                            r = RTLSYM_MEMSETN;
                    }
                    else if (config.exe != EX_WIN64 &&
                             r == RTLSYM_MEMSET128ii &&
                             tyfloating(t1.Tty) &&
                             tyfloating(t2.Tty))
                        r = RTLSYM_MEMSET128;
                }
            }

            if (r == RTLSYM_MEMSETN)
            {
                // проц *_memsetn(проц *p, проц *значение, цел dim, цел sizelem)
                evalue = addressElem(evalue, tb);
                elem *esz = el_long(TYт_мера, sz);
                elem *e = el_params(esz, edim, evalue, eptr, null);
                e = el_bin(OPcall,TYnptr,el_var(getRtlsym(r)),e);
                return e;
            }
            break;
    }
    if (sz > 1 && sz <= 8 &&
        evalue.Eoper == OPconst && el_allbits(evalue, 0))
    {
        r = RTLSYM_MEMSET8;
        edim = el_bin(OPmul, TYт_мера, edim, el_long(TYт_мера, sz));
    }

    if (config.exe == EX_WIN64 && sz > REGSIZE)
    {
        evalue = addressElem(evalue, tb);
    }
    // cast to the proper параметр тип
    else if (r != RTLSYM_MEMSETN)
    {
        tym_t tym;
        switch (r)
        {
            case RTLSYM_MEMSET8:      tym = TYchar;     break;
            case RTLSYM_MEMSET16:     tym = TYshort;    break;
            case RTLSYM_MEMSET32:     tym = TYlong;     break;
            case RTLSYM_MEMSET64:     tym = TYllong;    break;
            case RTLSYM_MEMSET80:     tym = TYldouble;  break;
            case RTLSYM_MEMSET160:    tym = TYcldouble; break;
            case RTLSYM_MEMSET128:    tym = TYcdouble;  break;
            case RTLSYM_MEMSET128ii:  tym = TYucent;    break;
            case RTLSYM_MEMSETFLOAT:  tym = TYfloat;    break;
            case RTLSYM_MEMSETDOUBLE: tym = TYdouble;   break;
            case RTLSYM_MEMSETSIMD:   tym = TYfloat4;   break;
            default:
                assert(0);
        }
        tym = tym | (evalue.Ety & ~mTYbasic);
        evalue = addressElem(evalue, tb);
        evalue = el_una(OPind, tym, evalue);
    }

    evalue = useOPstrpar(evalue);

    // Be careful about параметр side effect ordering
    if (r == RTLSYM_MEMSET8)
    {
        elem *e = el_param(edim, evalue);
        return el_bin(OPmemset,TYnptr,eptr,e);
    }
    else
    {
        elem *e = el_params(edim, evalue, eptr, null);
        return el_bin(OPcall,TYnptr,el_var(getRtlsym(r)),e);
    }
}


 ТаблицаСтрок!(Symbol*) *stringTab;

/********************************
 * Reset stringTab[] between объект files being emitted, because the symbols are local.
 */
проц clearStringTab()
{
    //printf("clearStringTab()\n");
    if (stringTab)
        stringTab.сбрось(1000);             // 1000 is arbitrary guess
    else
    {
        stringTab = new ТаблицаСтрок!(Symbol*)();
        stringTab._иниц(1000);
    }
}


elem *toElem(Выражение e, IRState *irs)
{
     class ToElemVisitor : Визитор2
    {
        IRState *irs;
        elem *результат;

        this(IRState *irs)
        {
            this.irs = irs;
            результат = null;
        }

        alias Визитор2.посети посети;

        /***************************************
         */

        override проц посети(Выражение e)
        {
            printf("[%s] %s: %s\n", e.место.вТкст0(), Сема2.вТкст0(e.op), e.вТкст0());
            assert(0);
        }

        /************************************
         */
        override проц посети(SymbolExp se)
        {
            elem *e;
            Тип tb = (se.op == ТОК2.symbolOffset) ? se.var.тип.toBasetype() : se.тип.toBasetype();
            цел смещение = (se.op == ТОК2.symbolOffset) ? cast(цел)(cast(SymOffExp)se).смещение : 0;
            VarDeclaration v = se.var.isVarDeclaration();

            //printf("[%s] SymbolExp.toElem('%s') %p, %s\n", se.место.вТкст0(), se.вТкст0(), se, se.тип.вТкст0());
            //printf("\tparent = '%s'\n", se.var.родитель ? se.var.родитель.вТкст0() : "null");
            if (se.op == ТОК2.variable && se.var.needThis())
            {
                se.выведиОшибку("need `this` to access member `%s`", se.вТкст0());
                результат = el_long(TYт_мера, 0);
                return;
            }

            /* The magic variable __ctfe is always нет at runtime
             */
            if (se.op == ТОК2.variable && v && v.идент == Id.ctfe)
            {
                результат = el_long(totym(se.тип), 0);
                return;
            }

            if (FuncLiteralDeclaration fld = se.var.isFuncLiteralDeclaration())
            {
                if (fld.tok == ТОК2.reserved)
                {
                    // change to non-nested
                    fld.tok = ТОК2.function_;
                    fld.vthis = null;
                }
                if (!fld.deferToObj)
                {
                    fld.deferToObj = да;
                    irs.deferToObj.сунь(fld);
                }
            }

            Symbol *s = toSymbol(se.var);
            FuncDeclaration fd = null;
            if (se.var.toParent2())
                fd = se.var.toParent2().isFuncDeclaration();

            цел nrvo = 0;
            if (fd && fd.nrvo_can && fd.nrvo_var == se.var)
            {
                s = fd.shidden;
                nrvo = 1;
            }

            if (s.Sclass == SCauto || s.Sclass == SCparameter || s.Sclass == SCshadowreg)
            {
                if (fd && fd != irs.getFunc())
                {
                    // 'var' is a variable in an enclosing function.
                    elem *ethis = getEthis(se.место, irs, fd, null, se.originalScope);
                    ethis = el_una(OPaddr, TYnptr, ethis);

                    /* https://issues.dlang.org/show_bug.cgi?ид=9383
                     * If 's' is a virtual function параметр
                     * placed in closure, and actually accessed from in/out
                     * contract, instead look at the original stack данные.
                     */
                    бул forceStackAccess = нет;
                    if (fd.isVirtual() && (fd.fdrequire || fd.fdensure))
                    {
                        ДСимвол sx = irs.getFunc();
                        while (sx != fd)
                        {
                            if (sx.идент == Id.require || sx.идент == Id.ensure)
                            {
                                forceStackAccess = да;
                                break;
                            }
                            sx = sx.toParent2();
                        }
                    }

                    цел soffset;
                    if (v && v.смещение && !forceStackAccess)
                        soffset = v.смещение;
                    else
                    {
                        soffset = cast(цел)s.Soffset;
                        /* If fd is a non-static member function of a class or struct,
                         * then ethis isn't the frame pointer.
                         * ethis is the 'this' pointer to the class/struct instance.
                         * We must смещение it.
                         */
                        if (fd.vthis)
                        {
                            Symbol *vs = toSymbol(fd.vthis);
                            //printf("vs = %s, смещение = %x, %p\n", vs.Sident, (цел)vs.Soffset, vs);
                            soffset -= vs.Soffset;
                        }
                        //printf("\tSoffset = x%x, sthis.Soffset = x%x\n", s.Soffset, irs.sthis.Soffset);
                    }

                    if (!nrvo)
                        soffset += смещение;

                    e = el_bin(OPadd, TYnptr, ethis, el_long(TYnptr, soffset));
                    if (se.op == ТОК2.variable)
                        e = el_una(OPind, TYnptr, e);
                    if (ISREF(se.var) && !(ISX64REF(se.var) && v && v.смещение && !forceStackAccess))
                        e = el_una(OPind, s.Stype.Tty, e);
                    else if (se.op == ТОК2.symbolOffset && nrvo)
                    {
                        e = el_una(OPind, TYnptr, e);
                        e = el_bin(OPadd, e.Ety, e, el_long(TYт_мера, смещение));
                    }
                    goto L1;
                }
            }

            /* If var is a member of a closure
             */
            if (v && v.смещение)
            {
                assert(irs.sclosure);
                e = el_var(irs.sclosure);
                e = el_bin(OPadd, TYnptr, e, el_long(TYт_мера, v.смещение));
                if (se.op == ТОК2.variable)
                {
                    e = el_una(OPind, totym(se.тип), e);
                    if (tybasic(e.Ety) == TYstruct)
                        e.ET = Type_toCtype(se.тип);
                    elem_setLoc(e, se.место);
                }
                if (ISREF(se.var) && !ISX64REF(se.var))
                {
                    e.Ety = TYnptr;
                    e = el_una(OPind, s.Stype.Tty, e);
                }
                else if (se.op == ТОК2.symbolOffset && nrvo)
                {
                    e = el_una(OPind, TYnptr, e);
                    e = el_bin(OPadd, e.Ety, e, el_long(TYт_мера, смещение));
                }
                else if (se.op == ТОК2.symbolOffset)
                {
                    e = el_bin(OPadd, e.Ety, e, el_long(TYт_мера, смещение));
                }
                goto L1;
            }

            if (s.Sclass == SCauto && s.Ssymnum == -1)
            {
                //printf("\tadding symbol %s\n", s.Sident);
                symbol_add(s);
            }

            if (se.var.isImportedSymbol())
            {
                assert(se.op == ТОК2.variable);
                e = el_var(toImport(se.var));
                e = el_una(OPind,s.Stype.Tty,e);
            }
            else if (ISREF(se.var))
            {
                // Out parameters are really references
                e = el_var(s);
                e.Ety = TYnptr;
                if (se.op == ТОК2.variable)
                    e = el_una(OPind, s.Stype.Tty, e);
                else if (смещение)
                    e = el_bin(OPadd, TYnptr, e, el_long(TYт_мера, смещение));
            }
            else if (se.op == ТОК2.variable)
                e = el_var(s);
            else
            {
                e = nrvo ? el_var(s) : el_ptr(s);
                e = el_bin(OPadd, e.Ety, e, el_long(TYт_мера, смещение));
            }
        L1:
            if (se.op == ТОК2.variable)
            {
                if (nrvo)
                {
                    e.Ety = TYnptr;
                    e = el_una(OPind, 0, e);
                }

                tym_t tym;
                if (se.var.класс_хранения & STC.lazy_)
                    tym = TYdelegate;       // Tdelegate as C тип
                else if (tb.ty == Tfunction)
                    tym = s.Stype.Tty;
                else
                    tym = totym(se.тип);

                e.Ejty = cast(ббайт)(e.Ety = tym);

                if (tybasic(tym) == TYstruct)
                {
                    e.ET = Type_toCtype(se.тип);
                }
                else if (tybasic(tym) == TYarray)
                {
                    e.Ejty = e.Ety = TYstruct;
                    e.ET = Type_toCtype(se.тип);
                }
                else if (tysimd(tym))
                {
                    e.ET = Type_toCtype(se.тип);
                }
            }
            elem_setLoc(e,se.место);
            результат = e;
        }

        /**************************************
         */

        override проц посети(FuncExp fe)
        {
            //printf("FuncExp.toElem() %s\n", fe.вТкст0());
            FuncLiteralDeclaration fld = fe.fd;

            if (fld.tok == ТОК2.reserved && fe.тип.ty == Tpointer)
            {
                // change to non-nested
                fld.tok = ТОК2.function_;
                fld.vthis = null;
            }
            if (!fld.deferToObj)
            {
                fld.deferToObj = да;
                irs.deferToObj.сунь(fld);
            }

            Symbol *s = toSymbol(fld);
            elem *e = el_ptr(s);
            if (fld.isNested())
            {
                elem *ethis;
                // Delegate literals report isNested() even if they are in глоб2 scope,
                // so we need to check that the родитель is a function.
                if (!fld.toParent2().isFuncDeclaration())
                    ethis = el_long(TYnptr, 0);
                else
                    ethis = getEthis(fe.место, irs, fld);
                e = el_pair(TYdelegate, ethis, e);
            }
            elem_setLoc(e, fe.место);
            результат = e;
        }

        override проц посети(DeclarationExp de)
        {
            //printf("DeclarationExp.toElem() %s\n", de.вТкст0());
            результат = Dsymbol_toElem(de.declaration);
        }

        /***************************************
         */

        override проц посети(TypeidExp e)
        {
            //printf("TypeidExp.toElem() %s\n", e.вТкст0());
            if (Тип t = тип_ли(e.obj))
            {
                результат = getTypeInfo(e.место, t, irs);
                результат = el_bin(OPadd, результат.Ety, результат, el_long(TYт_мера, t.vtinfo.смещение));
                return;
            }
            if (Выражение ex = выражение_ли(e.obj))
            {
                auto tc = ex.тип.toBasetype().isTypeClass();
                assert(tc);
                // generate **classptr to get the classinfo
                результат = toElem(ex, irs);
                результат = el_una(OPind,TYnptr,результат);
                результат = el_una(OPind,TYnptr,результат);
                // Add extra indirection for interfaces
                if (tc.sym.isInterfaceDeclaration())
                    результат = el_una(OPind,TYnptr,результат);
                return;
            }
            assert(0);
        }

        /***************************************
         */

        override проц посети(ThisExp te)
        {
            //printf("ThisExp.toElem()\n");
            assert(irs.sthis);

            elem *ethis;
            if (te.var)
            {
                assert(te.var.родитель);
                FuncDeclaration fd = te.var.toParent2().isFuncDeclaration();
                assert(fd);
                ethis = getEthis(te.место, irs, fd);
                ethis = fixEthis2(ethis, fd);
            }
            else
            {
                ethis = el_var(irs.sthis);
                ethis = fixEthis2(ethis, irs.getFunc());
            }

            if (te.тип.ty == Tstruct)
            {
                ethis = el_una(OPind, TYstruct, ethis);
                ethis.ET = Type_toCtype(te.тип);
            }
            elem_setLoc(ethis,te.место);
            результат = ethis;
        }

        /***************************************
         */

        override проц посети(IntegerExp ie)
        {
            elem *e = el_long(totym(ie.тип), ie.getInteger());
            elem_setLoc(e,ie.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(RealExp re)
        {
            //printf("RealExp.toElem(%p) %s\n", re, re.вТкст0());
            elem *e = el_long(TYint, 0);
            tym_t ty = totym(re.тип.toBasetype());
            switch (tybasic(ty))
            {
                case TYfloat:
                case TYifloat:
                    e.EV.Vfloat = cast(float) re.значение;
                    break;

                case TYdouble:
                case TYidouble:
                    e.EV.Vdouble = cast(double) re.значение;
                    break;

                case TYldouble:
                case TYildouble:
                    e.EV.Vldouble = re.значение;
                    break;

                default:
                    printf("ty = %d, tym = %x, re=%s, re.тип=%s, re.тип.toBasetype=%s\n",
                           re.тип.ty, ty, re.вТкст0(), re.тип.вТкст0(), re.тип.toBasetype().вТкст0());
                    assert(0);
            }
            e.Ety = ty;
            результат = e;
        }

        /***************************************
         */

        override проц посети(ComplexExp ce)
        {

            //printf("ComplexExp.toElem(%p) %s\n", ce, ce.вТкст0());

            elem *e = el_long(TYint, 0);
            real_t re = ce.значение.re;
            real_t im = ce.значение.im;

            tym_t ty = totym(ce.тип);
            switch (tybasic(ty))
            {
                case TYcfloat:
                    union UF { float f; бцел i; }
                    e.EV.Vcfloat.re = cast(float) re;
                    if (CTFloat.isSNaN(re))
                    {
                        UF u;
                        u.f = e.EV.Vcfloat.re;
                        u.i &= 0xFFBFFFFFL;
                        e.EV.Vcfloat.re = u.f;
                    }
                    e.EV.Vcfloat.im = cast(float) im;
                    if (CTFloat.isSNaN(im))
                    {
                        UF u;
                        u.f = e.EV.Vcfloat.im;
                        u.i &= 0xFFBFFFFFL;
                        e.EV.Vcfloat.im = u.f;
                    }
                    break;

                case TYcdouble:
                    union UD { double d; бдол i; }
                    e.EV.Vcdouble.re = cast(double) re;
                    if (CTFloat.isSNaN(re))
                    {
                        UD u;
                        u.d = e.EV.Vcdouble.re;
                        u.i &= 0xFFF7FFFFFFFFFFFFUL;
                        e.EV.Vcdouble.re = u.d;
                    }
                    e.EV.Vcdouble.im = cast(double) im;
                    if (CTFloat.isSNaN(re))
                    {
                        UD u;
                        u.d = e.EV.Vcdouble.im;
                        u.i &= 0xFFF7FFFFFFFFFFFFUL;
                        e.EV.Vcdouble.im = u.d;
                    }
                    break;

                case TYcldouble:
                    e.EV.Vcldouble.re = re;
                    e.EV.Vcldouble.im = im;
                    break;

                default:
                    assert(0);
            }
            e.Ety = ty;
            результат = e;
        }

        /***************************************
         */

        override проц посети(NullExp ne)
        {
            результат = el_long(totym(ne.тип), 0);
        }

        /***************************************
         */

        override проц посети(StringExp se)
        {
            //printf("StringExp.toElem() %s, тип = %s\n", se.вТкст0(), se.тип.вТкст0());

            elem *e;
            Тип tb = se.тип.toBasetype();
            if (tb.ty == Tarray)
            {
                Symbol *si = вТкстSymbol(se);
                e = el_pair(TYdarray, el_long(TYт_мера, se.numberOfCodeUnits()), el_ptr(si));
            }
            else if (tb.ty == Tsarray)
            {
                Symbol *si = вТкстSymbol(se);
                e = el_var(si);
                e.Ejty = e.Ety = TYstruct;
                e.ET = si.Stype;
                e.ET.Tcount++;
            }
            else if (tb.ty == Tpointer)
            {
                e = el_calloc();
                e.Eoper = OPstring;
                // freed in el_free
                бцел len = cast(бцел)((se.numberOfCodeUnits() + 1) * se.sz);
                e.EV.Vstring = cast(сим *)mem_malloc2(cast(бцел)len);
                se.writeTo(e.EV.Vstring, да);
                e.EV.Vstrlen = len;
                e.Ety = TYnptr;
            }
            else
            {
                printf("тип is %s\n", se.тип.вТкст0());
                assert(0);
            }
            elem_setLoc(e,se.место);
            результат = e;
        }

        override проц посети(NewExp ne)
        {
            //printf("NewExp.toElem() %s\n", ne.вТкст0());
            Тип t = ne.тип.toBasetype();
            //printf("\ttype = %s\n", t.вТкст0());
            //if (ne.member)
                //printf("\tmember = %s\n", ne.member.вТкст0());
            elem *e;
            Тип ectype;
            if (t.ty == Tclass)
            {
                auto tclass = ne.newtype.toBasetype().isTypeClass();
                assert(tclass);
                ClassDeclaration cd = tclass.sym;

                /* Things to do:
                 * 1) ex: call allocator
                 * 2) ey: set vthis for nested classes
                 * 2) ew: set vthis2 for nested classes
                 * 3) ez: call constructor
                 */

                elem *ex = null;
                elem *ey = null;
                elem *ew = null;
                elem *ezprefix = null;
                elem *ez = null;

                if (ne.allocator || ne.onstack)
                {
                    if (ne.onstack)
                    {
                        /* Create an instance of the class on the stack,
                         * and call it stmp.
                         * Set ex to be the &stmp.
                         */
                        .тип *tc = type_struct_class(tclass.sym.вТкст0(),
                                tclass.sym.alignsize, tclass.sym.structsize,
                                null, null,
                                нет, нет, да, нет);
                        tc.Tcount--;
                        Symbol *stmp = symbol_genauto(tc);
                        ex = el_ptr(stmp);
                    }
                    else
                    {
                        ex = el_var(toSymbol(ne.allocator));
                        ex = callfunc(ne.место, irs, 1, ne.тип, ex, ne.allocator.тип,
                                ne.allocator, ne.allocator.тип, null, ne.newargs);
                    }

                    Symbol *si = toInitializer(tclass.sym);
                    elem *ei = el_var(si);

                    if (cd.isNested())
                    {
                        ey = el_same(&ex);
                        ez = el_copytree(ey);
                        if (cd.vthis2)
                            ew = el_copytree(ey);
                    }
                    else if (ne.member)
                        ez = el_same(&ex);

                    ex = el_una(OPind, TYstruct, ex);
                    ex = elAssign(ex, ei, null, Type_toCtype(tclass).Tnext);
                    ex = el_una(OPaddr, TYnptr, ex);
                    ectype = tclass;
                }
                else
                {
                    Symbol *csym = toSymbol(cd);
                    const rtl = глоб2.парамы.ehnogc && ne.thrownew ? RTLSYM_NEWTHROW : RTLSYM_NEWCLASS;
                    ex = el_bin(OPcall,TYnptr,el_var(getRtlsym(rtl)),el_ptr(csym));
                    toTraceGC(irs, ex, ne.место);
                    ectype = null;

                    if (cd.isNested())
                    {
                        ey = el_same(&ex);
                        ez = el_copytree(ey);
                        if (cd.vthis2)
                            ew = el_copytree(ey);
                    }
                    else if (ne.member)
                        ez = el_same(&ex);
                    //elem_print(ex);
                    //elem_print(ey);
                    //elem_print(ez);
                }

                if (ne.thisexp)
                {
                    ClassDeclaration cdthis = ne.thisexp.тип.isClassHandle();
                    assert(cdthis);
                    //printf("cd = %s\n", cd.вТкст0());
                    //printf("cdthis = %s\n", cdthis.вТкст0());
                    assert(cd.isNested());
                    цел смещение = 0;
                    ДСимвол cdp = cd.toParentLocal();     // class we're nested in

                    //printf("member = %p\n", member);
                    //printf("cdp = %s\n", cdp.вТкст0());
                    //printf("cdthis = %s\n", cdthis.вТкст0());
                    if (cdp != cdthis)
                    {
                        цел i = cdp.isClassDeclaration().isBaseOf(cdthis, &смещение);
                        assert(i);
                    }
                    elem *ethis = toElem(ne.thisexp, irs);
                    if (смещение)
                        ethis = el_bin(OPadd, TYnptr, ethis, el_long(TYт_мера, смещение));

                    if (!cd.vthis)
                    {
                        ne.выведиОшибку("forward reference to `%s`", cd.вТкст0());
                    }
                    else
                    {
                        ey = el_bin(OPadd, TYnptr, ey, el_long(TYт_мера, cd.vthis.смещение));
                        ey = el_una(OPind, TYnptr, ey);
                        ey = el_bin(OPeq, TYnptr, ey, ethis);
                    }
                    //printf("ex: "); elem_print(ex);
                    //printf("ey: "); elem_print(ey);
                    //printf("ez: "); elem_print(ez);
                }
                else if (cd.isNested())
                {
                    /* Initialize cd.vthis:
                     *  *(ey + cd.vthis.смещение) = this;
                     */
                    ey = setEthis(ne.место, irs, ey, cd);
                }

                if (cd.vthis2)
                {
                    /* Initialize cd.vthis2:
                     *  *(ew + cd.vthis2.смещение) = this;
                     */
                    assert(ew);
                    ew = setEthis(ne.место, irs, ew, cd, да);
                }

                if (ne.member)
                {
                    if (ne.argprefix)
                        ezprefix = toElem(ne.argprefix, irs);
                    // Call constructor
                    ez = callfunc(ne.место, irs, 1, ne.тип, ez, ectype, ne.member, ne.member.тип, null, ne.arguments);
                }

                e = el_combine(ex, ey);
                e = el_combine(e, ew);
                e = el_combine(e, ezprefix);
                e = el_combine(e, ez);
            }
            else if (t.ty == Tpointer && t.nextOf().toBasetype().ty == Tstruct)
            {
                t = ne.newtype.toBasetype();
                TypeStruct tclass = t.isTypeStruct();
                StructDeclaration sd = tclass.sym;

                /* Things to do:
                 * 1) ex: call allocator
                 * 2) ey: set vthis for nested structs
                 * 2) ew: set vthis2 for nested structs
                 * 3) ez: call constructor
                 */

                elem *ex = null;
                elem *ey = null;
                elem *ew = null;
                elem *ezprefix = null;
                elem *ez = null;

                if (ne.allocator)
                {

                    ex = el_var(toSymbol(ne.allocator));
                    ex = callfunc(ne.место, irs, 1, ne.тип, ex, ne.allocator.тип,
                                ne.allocator, ne.allocator.тип, null, ne.newargs);

                    ectype = tclass;
                }
                else
                {
                    // call _d_newitemT(ti)
                    e = getTypeInfo(ne.место, ne.newtype, irs);

                    цел rtl = t.isZeroInit(Место.initial) ? RTLSYM_NEWITEMT : RTLSYM_NEWITEMIT;
                    ex = el_bin(OPcall,TYnptr,el_var(getRtlsym(rtl)),e);
                    toTraceGC(irs, ex, ne.место);

                    ectype = null;
                }

                elem *ev = el_same(&ex);

                if (ne.argprefix)
                        ezprefix = toElem(ne.argprefix, irs);
                if (ne.member)
                {
                    if (sd.isNested())
                    {
                        ey = el_copytree(ev);

                        /* Initialize sd.vthis:
                         *  *(ey + sd.vthis.смещение) = this;
                         */
                        ey = setEthis(ne.место, irs, ey, sd);
                        if (sd.vthis2)
                        {
                            /* Initialize sd.vthis2:
                             *  *(ew + sd.vthis2.смещение) = this1;
                             */
                            ew = el_copytree(ev);
                            ew = setEthis(ne.место, irs, ew, sd, да);
                        }
                    }

                    // Call constructor
                    ez = callfunc(ne.место, irs, 1, ne.тип, ev, ectype, ne.member, ne.member.тип, null, ne.arguments);
                    /* Structs return a ref, which gets automatically dereferenced.
                     * But we want a pointer to the instance.
                     */
                    ez = el_una(OPaddr, TYnptr, ez);
                }
                else
                {
                    StructLiteralExp sle = StructLiteralExp.создай(ne.место, sd, ne.arguments, t);
                    ez = toElemStructLit(sle, irs, ТОК2.construct, ev.EV.Vsym, нет);
                }
                //elem_print(ex);
                //elem_print(ey);
                //elem_print(ez);

                e = el_combine(ex, ey);
                e = el_combine(e, ew);
                e = el_combine(e, ezprefix);
                e = el_combine(e, ez);
            }
            else if (auto tda = t.isTypeDArray())
            {
                elem *ezprefix = ne.argprefix ? toElem(ne.argprefix, irs) : null;

                assert(ne.arguments && ne.arguments.dim >= 1);
                if (ne.arguments.dim == 1)
                {
                    // Single dimension массив allocations
                    Выражение arg = (*ne.arguments)[0]; // gives массив length
                    e = toElem(arg, irs);

                    // call _d_newT(ti, arg)
                    e = el_param(e, getTypeInfo(ne.место, ne.тип, irs));
                    цел rtl = tda.следщ.isZeroInit(Место.initial) ? RTLSYM_NEWARRAYT : RTLSYM_NEWARRAYIT;
                    e = el_bin(OPcall,TYdarray,el_var(getRtlsym(rtl)),e);
                    toTraceGC(irs, e, ne.место);
                }
                else
                {
                    // Multidimensional массив allocations
                    foreach (i; new бцел[0 .. ne.arguments.dim])
                    {
                        assert(t.ty == Tarray);
                        t = t.nextOf();
                        assert(t);
                    }

                    // Allocate массив of dimensions on the stack
                    Symbol *sdata = null;
                    elem *earray = ВыражениеsToStaticArray(ne.место, ne.arguments, &sdata);

                    e = el_pair(TYdarray, el_long(TYт_мера, ne.arguments.dim), el_ptr(sdata));
                    if (config.exe == EX_WIN64)
                        e = addressElem(e, Тип.tт_мера.arrayOf());
                    e = el_param(e, getTypeInfo(ne.место, ne.тип, irs));
                    цел rtl = t.isZeroInit(Место.initial) ? RTLSYM_NEWARRAYMTX : RTLSYM_NEWARRAYMITX;
                    e = el_bin(OPcall,TYdarray,el_var(getRtlsym(rtl)),e);
                    toTraceGC(irs, e, ne.место);

                    e = el_combine(earray, e);
                }
                e = el_combine(ezprefix, e);
            }
            else if (auto tp = t.isTypePointer())
            {
                elem *ezprefix = ne.argprefix ? toElem(ne.argprefix, irs) : null;

                // call _d_newitemT(ti)
                e = getTypeInfo(ne.место, ne.newtype, irs);

                цел rtl = tp.следщ.isZeroInit(Место.initial) ? RTLSYM_NEWITEMT : RTLSYM_NEWITEMIT;
                e = el_bin(OPcall,TYnptr,el_var(getRtlsym(rtl)),e);
                toTraceGC(irs, e, ne.место);

                if (ne.arguments && ne.arguments.dim == 1)
                {
                    /* ezprefix, ts=_d_newitemT(ti), *ts=arguments[0], ts
                     */
                    elem *e2 = toElem((*ne.arguments)[0], irs);

                    Symbol *ts = symbol_genauto(Type_toCtype(tp));
                    elem *eeq1 = el_bin(OPeq, TYnptr, el_var(ts), e);

                    elem *ederef = el_una(OPind, e2.Ety, el_var(ts));
                    elem *eeq2 = el_bin(OPeq, e2.Ety, ederef, e2);

                    e = el_combine(eeq1, eeq2);
                    e = el_combine(e, el_var(ts));
                    //elem_print(e);
                }
                e = el_combine(ezprefix, e);
            }
            else
            {
                ne.выведиОшибку("Internal Compiler Error: cannot new тип `%s`\n", t.вТкст0());
                assert(0);
            }

            elem_setLoc(e,ne.место);
            результат = e;
        }

        //////////////////////////// Unary ///////////////////////////////

        /***************************************
         */

        override проц посети(NegExp ne)
        {
            elem *e = toElem(ne.e1, irs);
            Тип tb1 = ne.e1.тип.toBasetype();

            assert(tb1.ty != Tarray && tb1.ty != Tsarray);

            switch (tb1.ty)
            {
                case Tvector:
                {
                    // rewrite (-e) as (0-e)
                    elem *ez = el_calloc();
                    ez.Eoper = OPconst;
                    ez.Ety = e.Ety;
                    ez.EV.Vcent.lsw = 0;
                    ez.EV.Vcent.msw = 0;
                    e = el_bin(OPmin, totym(ne.тип), ez, e);
                    break;
                }

                default:
                    e = el_una(OPneg, totym(ne.тип), e);
                    break;
            }

            elem_setLoc(e,ne.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(ComExp ce)
        {
            elem *e1 = toElem(ce.e1, irs);
            Тип tb1 = ce.e1.тип.toBasetype();
            tym_t ty = totym(ce.тип);

            assert(tb1.ty != Tarray && tb1.ty != Tsarray);

            elem *e;
            switch (tb1.ty)
            {
                case Tbool:
                    e = el_bin(OPxor, ty, e1, el_long(ty, 1));
                    break;

                case Tvector:
                {
                    // rewrite (~e) as (e^~0)
                    elem *ec = el_calloc();
                    ec.Eoper = OPconst;
                    ec.Ety = e1.Ety;
                    ec.EV.Vcent.lsw = ~0L;
                    ec.EV.Vcent.msw = ~0L;
                    e = el_bin(OPxor, ty, e1, ec);
                    break;
                }

                default:
                    e = el_una(OPcom,ty,e1);
                    break;
            }

            elem_setLoc(e,ce.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(NotExp ne)
        {
            elem *e = el_una(OPnot, totym(ne.тип), toElem(ne.e1, irs));
            elem_setLoc(e,ne.место);
            результат = e;
        }


        /***************************************
         */

        override проц посети(HaltExp he)
        {
            результат = genHalt(he.место);
        }

        /********************************************
         */

        override проц посети(AssertExp ae)
        {
            // https://dlang.org/spec/Выражение.html#assert_Выражениеs
            //printf("AssertExp.toElem() %s\n", вТкст0());
            elem *e;
            if (irs.парамы.useAssert == CHECKENABLE.on)
            {
                if (irs.парамы.checkAction == CHECKACTION.C)
                {
                    auto econd = toElem(ae.e1, irs);
                    auto ea = callCAssert(irs, ae.e1.место, ae.e1, ae.msg, null);
                    auto eo = el_bin(OPoror, TYvoid, econd, ea);
                    elem_setLoc(eo, ae.место);
                    результат = eo;
                    return;
                }

                if (irs.парамы.checkAction == CHECKACTION.halt)
                {
                    /* Generate:
                     *  ae.e1 || halt
                     */
                    auto econd = toElem(ae.e1, irs);
                    auto ea = genHalt(ae.место);
                    auto eo = el_bin(OPoror, TYvoid, econd, ea);
                    elem_setLoc(eo, ae.место);
                    результат = eo;
                    return;
                }

                e = toElem(ae.e1, irs);
                Symbol *ts = null;
                elem *einv = null;
                Тип t1 = ae.e1.тип.toBasetype();

                FuncDeclaration inv;

                // If e1 is a class объект, call the class invariant on it
                if (irs.парамы.useInvariants == CHECKENABLE.on && t1.ty == Tclass &&
                    !(cast(TypeClass)t1).sym.isInterfaceDeclaration() &&
                    !(cast(TypeClass)t1).sym.isCPPclass())
                {
                    ts = symbol_genauto(Type_toCtype(t1));
                    einv = el_bin(OPcall, TYvoid, el_var(getRtlsym(RTLSYM_DINVARIANT)), el_var(ts));
                }
                else if (irs.парамы.useInvariants == CHECKENABLE.on &&
                    t1.ty == Tpointer &&
                    t1.nextOf().ty == Tstruct &&
                    (inv = (cast(TypeStruct)t1.nextOf()).sym.inv) !is null)
                {
                    // If e1 is a struct объект, call the struct invariant on it
                    ts = symbol_genauto(Type_toCtype(t1));
                    einv = callfunc(ae.место, irs, 1, inv.тип.nextOf(), el_var(ts), ae.e1.тип, inv, inv.тип, null, null);
                }

                // Construct: (e1 || ModuleAssert(line))
                Module m = cast(Module)irs.blx._module;
                сим *mname = cast(сим*)m.srcfile.вТкст0();

                //printf("имяф = '%s'\n", ae.место.имяф);
                //printf("module = '%s'\n", m.srcfile.вТкст0());

                /* Determine if we are in a unittest
                 */
                FuncDeclaration fd = irs.getFunc();
                UnitTestDeclaration ud = fd ? fd.isUnitTestDeclaration() : null;

                /* If the source файл имя has changed, probably due
                 * to a #line directive.
                 */
                elem *ea;
                if (ae.место.имяф && (ae.msg || strcmp(ae.место.имяф, mname) != 0))
                {
                    ткст0 ид = ae.место.имяф;
                    т_мера len = strlen(ид);
                    Symbol *si = вТкстSymbol(ид, len, 1);
                    elem *efilename = el_pair(TYdarray, el_long(TYт_мера, len), el_ptr(si));
                    if (config.exe == EX_WIN64)
                        efilename = addressElem(efilename, Тип.tstring, да);

                    if (ae.msg)
                    {
                        /* https://issues.dlang.org/show_bug.cgi?ид=8360
                         * If the условие is evalated to да,
                         * msg is not evaluated at all. so should use
                         * toElemDtor(msg, irs) instead of toElem(msg, irs).
                         */
                        elem *emsg = toElemDtor(ae.msg, irs);
                        emsg = array_toDarray(ae.msg.тип, emsg);
                        if (config.exe == EX_WIN64)
                            emsg = addressElem(emsg, Тип.tvoid.arrayOf(), нет);

                        ea = el_var(getRtlsym(ud ? RTLSYM_DUNITTEST_MSG : RTLSYM_DASSERT_MSG));
                        ea = el_bin(OPcall, TYvoid, ea, el_params(el_long(TYint, ae.место.номстр), efilename, emsg, null));
                    }
                    else
                    {
                        ea = el_var(getRtlsym(ud ? RTLSYM_DUNITTEST : RTLSYM_DASSERT));
                        ea = el_bin(OPcall, TYvoid, ea, el_param(el_long(TYint, ae.место.номстр), efilename));
                    }
                }
                else
                {
                    auto eassert = el_var(getRtlsym(ud ? RTLSYM_DUNITTESTP : RTLSYM_DASSERTP));
                    auto efile = toEfilenamePtr(m);
                    auto eline = el_long(TYint, ae.место.номстр);
                    ea = el_bin(OPcall, TYvoid, eassert, el_param(eline, efile));
                }
                if (einv)
                {
                    // tmp = e, e || assert, e.inv
                    elem *eassign = el_bin(OPeq, e.Ety, el_var(ts), e);
                    e = el_combine(eassign, el_bin(OPoror, TYvoid, el_var(ts), ea));
                    e = el_combine(e, einv);
                }
                else
                    e = el_bin(OPoror,TYvoid,e,ea);
            }
            else
            {
                // BUG: should replace assert(0); with a HLT instruction
                e = el_long(TYint, 0);
            }
            elem_setLoc(e,ae.место);
            результат = e;
        }

        override проц посети(PostExp pe)
        {
            //printf("PostExp.toElem() '%s'\n", pe.вТкст0());
            elem *e = toElem(pe.e1, irs);
            elem *einc = toElem(pe.e2, irs);
            e = el_bin((pe.op == ТОК2.plusPlus) ? OPpostinc : OPpostdec,
                        e.Ety,e,einc);
            elem_setLoc(e,pe.место);
            результат = e;
        }

        //////////////////////////// Binary ///////////////////////////////

        /********************************************
         */
        elem *toElemBin(BinExp be, цел op)
        {
            //printf("toElemBin() '%s'\n", be.вТкст0());

            Тип tb1 = be.e1.тип.toBasetype();
            Тип tb2 = be.e2.тип.toBasetype();

            assert(!((tb1.ty == Tarray || tb1.ty == Tsarray ||
                      tb2.ty == Tarray || tb2.ty == Tsarray) &&
                     tb2.ty != Tvoid &&
                     op != OPeq && op != OPandand && op != OPoror));

            tym_t tym = totym(be.тип);

            elem *el = toElem(be.e1, irs);
            elem *er = toElem(be.e2, irs);
            elem *e = el_bin(op,tym,el,er);

            elem_setLoc(e,be.место);
            return e;
        }

        elem *toElemBinAssign(BinAssignExp be, цел op)
        {
            //printf("toElemBinAssign() '%s'\n", be.вТкст0());

            Тип tb1 = be.e1.тип.toBasetype();
            Тип tb2 = be.e2.тип.toBasetype();

            assert(!((tb1.ty == Tarray || tb1.ty == Tsarray ||
                      tb2.ty == Tarray || tb2.ty == Tsarray) &&
                     tb2.ty != Tvoid &&
                     op != OPeq && op != OPandand && op != OPoror));

            tym_t tym = totym(be.тип);

            elem *el;
            elem *ev;
            if (be.e1.op == ТОК2.cast_)
            {
                цел depth = 0;
                Выражение e1 = be.e1;
                while (e1.op == ТОК2.cast_)
                {
                    ++depth;
                    e1 = (cast(CastExp)e1).e1;
                }
                assert(depth > 0);

                el = toElem(e1, irs);
                el = addressElem(el, e1.тип.pointerTo());
                ev = el_same(&el);

                el = el_una(OPind, totym(e1.тип), el);

                ev = el_una(OPind, tym, ev);

                foreach (d; new бцел[0 .. depth])
                {
                    e1 = be.e1;
                    foreach (i; new бцел[1 .. depth - d])
                        e1 = (cast(CastExp)e1).e1;

                    el = toElemCast(cast(CastExp)e1, el, да);
                }
            }
            else
            {
                el = toElem(be.e1, irs);
                el = addressElem(el, be.e1.тип.pointerTo());
                ev = el_same(&el);

                el = el_una(OPind, tym, el);
                ev = el_una(OPind, tym, ev);
            }
            elem *er = toElem(be.e2, irs);
            elem *e = el_bin(op, tym, el, er);
            e = el_combine(e, ev);

            elem_setLoc(e,be.место);
            return e;
        }

        /***************************************
         */

        override проц посети(AddExp e)
        {
            результат = toElemBin(e, OPadd);
        }

        /***************************************
         */

        override проц посети(MinExp e)
        {
            результат = toElemBin(e, OPmin);
        }

        /*****************************************
         * Evaluate elem and convert to dynamic массив suitable for a function argument.
         */
        elem *eval_Darray(Выражение e)
        {
            elem *ex = toElem(e, irs);
            ex = array_toDarray(e.тип, ex);
            if (config.exe == EX_WIN64)
            {
                ex = addressElem(ex, Тип.tvoid.arrayOf(), нет);
            }
            return ex;
        }

        /***************************************
         * http://dlang.org/spec/Выражение.html#cat_Выражениеs
         */

        override проц посети(CatExp ce)
        {
            /* Do this check during code gen rather than semantic() because concatenation is
             * allowed in CTFE, and cannot distinguish that in semantic().
             */
            if (irs.парамы.betterC)
            {
                выведиОшибку(ce.место, "массив concatenation of Выражение `%s` requires the СМ which is not доступно with -betterC", ce.вТкст0());
                результат = el_long(TYint, 0);
                return;
            }

            Тип tb1 = ce.e1.тип.toBasetype();
            Тип tb2 = ce.e2.тип.toBasetype();

            Тип ta = (tb1.ty == Tarray || tb1.ty == Tsarray) ? tb1 : tb2;

            elem *e;
            if (ce.e1.op == ТОК2.concatenate)
            {
                CatExp ex = ce;

                // Flatten ((a ~ b) ~ c) to [a, b, c]
                Elems elems;
                elems.shift(array_toDarray(ex.e2.тип, toElem(ex.e2, irs)));
                do
                {
                    ex = cast(CatExp)ex.e1;
                    elems.shift(array_toDarray(ex.e2.тип, toElem(ex.e2, irs)));
                } while (ex.e1.op == ТОК2.concatenate);
                elems.shift(array_toDarray(ex.e1.тип, toElem(ex.e1, irs)));

                // We can't use ВыражениеsToStaticArray because each exp needs
                // to have array_toDarray called on it first, as some might be
                // single elements instead of arrays.
                Symbol *sdata;
                elem *earr = ElemsToStaticArray(ce.место, ce.тип, &elems, &sdata);

                elem *ep = el_pair(TYdarray, el_long(TYт_мера, elems.dim), el_ptr(sdata));
                if (config.exe == EX_WIN64)
                    ep = addressElem(ep, Тип.tvoid.arrayOf());
                ep = el_param(ep, getTypeInfo(ce.место, ta, irs));
                e = el_bin(OPcall, TYdarray, el_var(getRtlsym(RTLSYM_ARRAYCATNTX)), ep);
                toTraceGC(irs, e, ce.место);
                e = el_combine(earr, e);
            }
            else
            {
                elem *e1 = eval_Darray(ce.e1);
                elem *e2 = eval_Darray(ce.e2);
                elem *ep = el_params(e2, e1, getTypeInfo(ce.место, ta, irs), null);
                e = el_bin(OPcall, TYdarray, el_var(getRtlsym(RTLSYM_ARRAYCATT)), ep);
                toTraceGC(irs, e, ce.место);
            }
            elem_setLoc(e,ce.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(MulExp e)
        {
            результат = toElemBin(e, OPmul);
        }

        /************************************
         */

        override проц посети(DivExp e)
        {
            результат = toElemBin(e, OPdiv);
        }

        /***************************************
         */

        override проц посети(ModExp e)
        {
            результат = toElemBin(e, OPmod);
        }

        /***************************************
         */

        override проц посети(CmpExp ce)
        {
            //printf("CmpExp.toElem() %s\n", ce.вТкст0());

            OPER eop;
            Тип t1 = ce.e1.тип.toBasetype();
            Тип t2 = ce.e2.тип.toBasetype();

            switch (ce.op)
            {
                case ТОК2.lessThan:     eop = OPlt;     break;
                case ТОК2.greaterThan:     eop = OPgt;     break;
                case ТОК2.lessOrEqual:     eop = OPle;     break;
                case ТОК2.greaterOrEqual:     eop = OPge;     break;
                case ТОК2.equal:  eop = OPeqeq;   break;
                case ТОК2.notEqual: eop = OPne;   break;

                default:
                    printf("%s\n", ce.вТкст0());
                    assert(0);
            }
            if (!t1.isfloating())
            {
                // Convert from floating point compare to equivalent
                // integral compare
                eop = cast(OPER)rel_integral(eop);
            }
            elem *e;
            if (cast(цел)eop > 1 && t1.ty == Tclass && t2.ty == Tclass)
            {
                // Should have already been lowered
                assert(0);
            }
            else if (cast(цел)eop > 1 &&
                (t1.ty == Tarray || t1.ty == Tsarray) &&
                (t2.ty == Tarray || t2.ty == Tsarray))
            {
                // This codepath was replaced by lowering during semantic
                // to объект.__cmp in druntime.
                assert(0);
            }
            else
            {
                if (cast(цел)eop <= 1)
                {
                    /* The результат is determinate, создай:
                     *   (e1 , e2) , eop
                     */
                    e = toElemBin(ce,OPcomma);
                    e = el_bin(OPcomma,e.Ety,e,el_long(e.Ety,cast(цел)eop));
                }
                else
                    e = toElemBin(ce,eop);
            }
            результат = e;
        }

        override проц посети(EqualExp ee)
        {
            //printf("EqualExp.toElem() %s\n", ee.вТкст0());

            Тип t1 = ee.e1.тип.toBasetype();
            Тип t2 = ee.e2.тип.toBasetype();

            OPER eop;
            switch (ee.op)
            {
                case ТОК2.equal:          eop = OPeqeq;   break;
                case ТОК2.notEqual:       eop = OPne;     break;
                default:
                    printf("%s\n", ee.вТкст0());
                    assert(0);
            }

            //printf("EqualExp.toElem()\n");
            elem *e;
            if (t1.ty == Tstruct)
            {
                // Rewritten to IdentityExp or memberwise-compare
                assert(0);
            }
            else if ((t1.ty == Tarray || t1.ty == Tsarray) &&
                     (t2.ty == Tarray || t2.ty == Tsarray))
            {
                Тип telement  = t1.nextOf().toBasetype();
                Тип telement2 = t2.nextOf().toBasetype();

                if ((telement.isintegral() || telement.ty == Tvoid) && telement.ty == telement2.ty)
                {
                    // Optimize comparisons of arrays of basic types
                    // For arrays of integers/characters, and проц[],
                    // replace druntime call with:
                    // For a==b: a.length==b.length && (a.length == 0 || memcmp(a.ptr, b.ptr, size)==0)
                    // For a!=b: a.length!=b.length || (a.length != 0 || memcmp(a.ptr, b.ptr, size)!=0)
                    // size is a.length*sizeof(a[0]) for dynamic arrays, or sizeof(a) for static arrays.

                    elem* earr1 = toElem(ee.e1, irs);
                    elem* earr2 = toElem(ee.e2, irs);
                    elem* eptr1, eptr2; // Pointer to данные, to pass to memcmp
                    elem* elen1, elen2; // Length, for comparison
                    elem* esiz1, esiz2; // Data size, to pass to memcmp
                    d_uns64 sz = telement.size(); // Size of one element

                    if (t1.ty == Tarray)
                    {
                        elen1 = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, el_same(&earr1));
                        esiz1 = el_bin(OPmul, TYт_мера, el_same(&elen1), el_long(TYт_мера, sz));
                        eptr1 = array_toPtr(t1, el_same(&earr1));
                    }
                    else
                    {
                        elen1 = el_long(TYт_мера, (cast(TypeSArray)t1).dim.toInteger());
                        esiz1 = el_long(TYт_мера, t1.size());
                        earr1 = addressElem(earr1, t1);
                        eptr1 = el_same(&earr1);
                    }

                    if (t2.ty == Tarray)
                    {
                        elen2 = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, el_same(&earr2));
                        esiz2 = el_bin(OPmul, TYт_мера, el_same(&elen2), el_long(TYт_мера, sz));
                        eptr2 = array_toPtr(t2, el_same(&earr2));
                    }
                    else
                    {
                        elen2 = el_long(TYт_мера, (cast(TypeSArray)t2).dim.toInteger());
                        esiz2 = el_long(TYт_мера, t2.size());
                        earr2 = addressElem(earr2, t2);
                        eptr2 = el_same(&earr2);
                    }

                    elem *esize = t2.ty == Tsarray ? esiz2 : esiz1;

                    e = el_param(eptr1, eptr2);
                    e = el_bin(OPmemcmp, TYint, e, esize);
                    e = el_bin(eop, TYint, e, el_long(TYint, 0));

                    elem *elen = t2.ty == Tsarray ? elen2 : elen1;
                    elem *esizecheck = el_bin(eop, TYint, el_same(&elen), el_long(TYт_мера, 0));
                    e = el_bin(ee.op == ТОК2.equal ? OPoror : OPandand, TYint, esizecheck, e);

                    if (t1.ty == Tsarray && t2.ty == Tsarray)
                        assert(t1.size() == t2.size());
                    else
                    {
                        elem *elencmp = el_bin(eop, TYint, elen1, elen2);
                        e = el_bin(ee.op == ТОК2.equal ? OPandand : OPoror, TYint, elencmp, e);
                    }

                    // Гарант left-to-right order of evaluation
                    e = el_combine(earr2, e);
                    e = el_combine(earr1, e);
                    elem_setLoc(e, ee.место);
                    результат = e;
                    return;
                }

                elem *ea1 = eval_Darray(ee.e1);
                elem *ea2 = eval_Darray(ee.e2);

                elem *ep = el_params(getTypeInfo(ee.место, telement.arrayOf(), irs),
                        ea2, ea1, null);
                цел rtlfunc = RTLSYM_ARRAYEQ2;
                e = el_bin(OPcall, TYint, el_var(getRtlsym(rtlfunc)), ep);
                if (ee.op == ТОК2.notEqual)
                    e = el_bin(OPxor, TYint, e, el_long(TYint, 1));
                elem_setLoc(e,ee.место);
            }
            else if (t1.ty == Taarray && t2.ty == Taarray)
            {
                TypeAArray taa = cast(TypeAArray)t1;
                Symbol *s = aaGetSymbol(taa, "Equal", 0);
                elem *ti = getTypeInfo(ee.место, taa, irs);
                elem *ea1 = toElem(ee.e1, irs);
                elem *ea2 = toElem(ee.e2, irs);
                // aaEqual(ti, e1, e2)
                elem *ep = el_params(ea2, ea1, ti, null);
                e = el_bin(OPcall, TYnptr, el_var(s), ep);
                if (ee.op == ТОК2.notEqual)
                    e = el_bin(OPxor, TYint, e, el_long(TYint, 1));
                elem_setLoc(e, ee.место);
                результат = e;
                return;
            }
            else
                e = toElemBin(ee, eop);
            результат = e;
        }

        override проц посети(IdentityExp ie)
        {
            Тип t1 = ie.e1.тип.toBasetype();
            Тип t2 = ie.e2.тип.toBasetype();

            OPER eop;
            switch (ie.op)
            {
                case ТОК2.identity:       eop = OPeqeq;   break;
                case ТОК2.notIdentity:    eop = OPne;     break;
                default:
                    printf("%s\n", ie.вТкст0());
                    assert(0);
            }

            //printf("IdentityExp.toElem() %s\n", ie.вТкст0());

            /* Fix Issue 18746 : https://issues.dlang.org/show_bug.cgi?ид=18746
             * Before skipping the comparison for empty structs
             * it is necessary to check whether the Выражения involved
             * have any sideeffects
             */

            const canSkipCompare = isTrivialExp(ie.e1) && isTrivialExp(ie.e2);
            elem *e;
            if (t1.ty == Tstruct && (cast(TypeStruct)t1).sym.fields.dim == 0 && canSkipCompare)
            {
                // we can skip the compare if the structs are empty
                e = el_long(TYбул, ie.op == ТОК2.identity);
            }
            else if (t1.ty == Tstruct || t1.isfloating())
            {
                // Do bit compare of struct's
                elem *es1 = toElem(ie.e1, irs);
                es1 = addressElem(es1, ie.e1.тип);
                elem *es2 = toElem(ie.e2, irs);
                es2 = addressElem(es2, ie.e2.тип);
                e = el_param(es1, es2);
                elem *ecount = el_long(TYт_мера, t1.size());
                e = el_bin(OPmemcmp, TYint, e, ecount);
                e = el_bin(eop, TYint, e, el_long(TYint, 0));
                elem_setLoc(e, ie.место);
            }
            else if ((t1.ty == Tarray || t1.ty == Tsarray) &&
                     (t2.ty == Tarray || t2.ty == Tsarray))
            {

                elem *ea1 = toElem(ie.e1, irs);
                ea1 = array_toDarray(t1, ea1);
                elem *ea2 = toElem(ie.e2, irs);
                ea2 = array_toDarray(t2, ea2);

                e = el_bin(eop, totym(ie.тип), ea1, ea2);
                elem_setLoc(e, ie.место);
            }
            else
                e = toElemBin(ie, eop);

            результат = e;
        }

        /***************************************
         */

        override проц посети(InExp ie)
        {
            elem *ключ = toElem(ie.e1, irs);
            elem *aa = toElem(ie.e2, irs);
            TypeAArray taa = cast(TypeAArray)ie.e2.тип.toBasetype();

            // aaInX(aa, keyti, ключ);
            ключ = addressElem(ключ, ie.e1.тип);
            Symbol *s = aaGetSymbol(taa, "InX", 0);
            elem *keyti = getTypeInfo(ie.место, taa.index, irs);
            elem *ep = el_params(ключ, keyti, aa, null);
            elem *e = el_bin(OPcall, totym(ie.тип), el_var(s), ep);

            elem_setLoc(e, ie.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(RemoveExp re)
        {
            auto taa = re.e1.тип.toBasetype().isTypeAArray();
            assert(taa);
            elem *ea = toElem(re.e1, irs);
            elem *ekey = toElem(re.e2, irs);

            ekey = addressElem(ekey, re.e2.тип);
            Symbol *s = aaGetSymbol(taa, "DelX", 0);
            elem *keyti = getTypeInfo(re.место, taa.index, irs);
            elem *ep = el_params(ekey, keyti, ea, null);
            elem *e = el_bin(OPcall, TYnptr, el_var(s), ep);

            elem_setLoc(e, re.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(AssignExp ae)
        {
            version (none)
            {
                if (ae.op == ТОК2.blit)      printf("BlitExp.toElem('%s')\n", ae.вТкст0());
                if (ae.op == ТОК2.assign)    printf("AssignExp.toElem('%s')\n", ae.вТкст0());
                if (ae.op == ТОК2.construct) printf("ConstructExp.toElem('%s')\n", ae.вТкст0());
            }

            проц setрезультат(elem* e)
            {
                elem_setLoc(e, ae.место);
                результат = e;
            }

            Тип t1b = ae.e1.тип.toBasetype();

            // Look for массив.length = n
            if (auto ale = ae.e1.isArrayLengthExp())
            {
                assert(0, "This case should have been rewritten to `_d_arraysetlengthT` in the semantic phase");
            }

            // Look for массив[]=n
            if (auto are = ae.e1.isSliceExp())
            {
                Тип t1 = t1b;
                Тип ta = are.e1.тип.toBasetype();

                // which we do if the 'следщ' types match
                if (ae.memset & MemorySet.blockAssign)
                {
                    // Do a memset for массив[]=v
                    //printf("Lpair %s\n", ae.вТкст0());
                    Тип tb = ta.nextOf().toBasetype();
                    бцел sz = cast(бцел)tb.size();

                    elem *n1 = toElem(are.e1, irs);
                    elem *elwr = are.lwr ? toElem(are.lwr, irs) : null;
                    elem *eupr = are.upr ? toElem(are.upr, irs) : null;

                    elem *n1x = n1;

                    elem *enbytes;
                    elem *einit;
                    // Look for массив[]=n
                    if (auto ts = ta.isTypeSArray())
                    {
                        n1 = array_toPtr(ta, n1);
                        enbytes = toElem(ts.dim, irs);
                        n1x = n1;
                        n1 = el_same(&n1x);
                        einit = resolveLengthVar(are.lengthVar, &n1, ta);
                    }
                    else if (ta.ty == Tarray)
                    {
                        n1 = el_same(&n1x);
                        einit = resolveLengthVar(are.lengthVar, &n1, ta);
                        enbytes = el_copytree(n1);
                        n1 = array_toPtr(ta, n1);
                        enbytes = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, enbytes);
                    }
                    else if (ta.ty == Tpointer)
                    {
                        n1 = el_same(&n1x);
                        enbytes = el_long(TYт_мера, -1);   // largest possible index
                        einit = null;
                    }

                    // Enforce order of evaluation of n1[elwr..eupr] as n1,elwr,eupr
                    elem *elwrx = elwr;
                    if (elwr) elwr = el_same(&elwrx);
                    elem *euprx = eupr;
                    if (eupr) eupr = el_same(&euprx);

                    version (none)
                    {
                        printf("sz = %d\n", sz);
                        printf("n1x\n");        elem_print(n1x);
                        printf("einit\n");      elem_print(einit);
                        printf("elwrx\n");      elem_print(elwrx);
                        printf("euprx\n");      elem_print(euprx);
                        printf("n1\n");         elem_print(n1);
                        printf("elwr\n");       elem_print(elwr);
                        printf("eupr\n");       elem_print(eupr);
                        printf("enbytes\n");    elem_print(enbytes);
                    }
                    einit = el_combine(n1x, einit);
                    einit = el_combine(einit, elwrx);
                    einit = el_combine(einit, euprx);

                    elem *evalue = toElem(ae.e2, irs);

                    version (none)
                    {
                        printf("n1\n");         elem_print(n1);
                        printf("enbytes\n");    elem_print(enbytes);
                    }

                    if (irs.arrayBoundsCheck() && eupr && ta.ty != Tpointer)
                    {
                        assert(elwr);
                        elem *enbytesx = enbytes;
                        enbytes = el_same(&enbytesx);
                        elem *c1 = el_bin(OPle, TYint, el_copytree(eupr), enbytesx);
                        elem *c2 = el_bin(OPle, TYint, el_copytree(elwr), el_copytree(eupr));
                        c1 = el_bin(OPandand, TYint, c1, c2);

                        // Construct: (c1 || arrayBoundsError)
                        auto ea = buildArrayBoundsError(irs, ae.место, el_copytree(elwr), el_copytree(eupr), el_copytree(enbytesx));
                        elem *eb = el_bin(OPoror,TYvoid,c1,ea);
                        einit = el_combine(einit, eb);
                    }

                    elem *elength;
                    if (elwr)
                    {
                        el_free(enbytes);
                        elem *elwr2 = el_copytree(elwr);
                        elwr2 = el_bin(OPmul, TYт_мера, elwr2, el_long(TYт_мера, sz));
                        n1 = el_bin(OPadd, TYnptr, n1, elwr2);
                        enbytes = el_bin(OPmin, TYт_мера, eupr, elwr);
                        elength = el_copytree(enbytes);
                    }
                    else
                        elength = el_copytree(enbytes);
                    elem* e = setArray(are.e1, n1, enbytes, tb, evalue, irs, ae.op);
                    e = el_pair(TYdarray, elength, e);
                    e = el_combine(einit, e);
                    //elem_print(e);
                    return setрезультат(e);
                }
                else
                {
                    /* It's array1[]=array2[]
                     * which is a memcpy
                     */
                    elem *eto = toElem(ae.e1, irs);
                    elem *efrom = toElem(ae.e2, irs);

                    бцел size = cast(бцел)t1.nextOf().size();
                    elem *esize = el_long(TYт_мера, size);

                    /* Determine if we need to do postblit
                     */
                    бул postblit = нет;
                    if (needsPostblit(t1.nextOf()) &&
                        (ae.e2.op == ТОК2.slice && (cast(UnaExp)ae.e2).e1.isLvalue() ||
                         ae.e2.op == ТОК2.cast_  && (cast(UnaExp)ae.e2).e1.isLvalue() ||
                         ae.e2.op != ТОК2.slice && ae.e2.isLvalue()))
                    {
                        postblit = да;
                    }
                    бул destructor = needsDtor(t1.nextOf()) !is null;

                    assert(ae.e2.тип.ty != Tpointer);

                    if (!postblit && !destructor)
                    {
                        elem *ex = el_same(&eto);

                        /* Возвращает: length of массив ex
                         */
                        static elem *getDotLength(IRState* irs, elem *eto, elem *ex)
                        {
                            if (eto.Eoper == OPpair &&
                                eto.EV.E1.Eoper == OPconst)
                            {
                                // It's a constant, so just pull it from eto
                                return el_copytree(eto.EV.E1);
                            }
                            else
                            {
                                // It's not a constant, so pull it from the dynamic массив
                                return el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, el_copytree(ex));
                            }
                        }

                        auto elen = getDotLength(irs, eto, ex);
                        auto члобайт = el_bin(OPmul, TYт_мера, elen, esize);  // number of bytes to memcpy
                        auto epto = array_toPtr(ae.e1.тип, ex);

                        elem *epfr;
                        elem *echeck;
                        if (irs.arrayBoundsCheck()) // check массив lengths match and do not overlap
                        {
                            auto ey = el_same(&efrom);
                            auto eleny = getDotLength(irs, efrom, ey);
                            epfr = array_toPtr(ae.e2.тип, ey);

                            // length check: (eleny == elen)
                            auto c = el_bin(OPeqeq, TYint, eleny, el_copytree(elen));

                            /* Don't check overlap if epto and epfr point to different symbols
                             */
                            if (!(epto.Eoper == OPaddr && epto.EV.E1.Eoper == OPvar &&
                                  epfr.Eoper == OPaddr && epfr.EV.E1.Eoper == OPvar &&
                                  epto.EV.E1.EV.Vsym != epfr.EV.E1.EV.Vsym))
                            {
                                // Add overlap check (c && (px + члобайт <= py || py + члобайт <= px))
                                auto c2 = el_bin(OPle, TYint, el_bin(OPadd, TYт_мера, el_copytree(epto), el_copytree(члобайт)), el_copytree(epfr));
                                auto c3 = el_bin(OPle, TYint, el_bin(OPadd, TYт_мера, el_copytree(epfr), el_copytree(члобайт)), el_copytree(epto));
                                c = el_bin(OPandand, TYint, c, el_bin(OPoror, TYint, c2, c3));
                            }

                            // Construct: (c || arrayBoundsError)
                            echeck = el_bin(OPoror, TYvoid, c, buildArrayBoundsError(irs, ae.место, null, el_copytree(eleny), el_copytree(elen)));
                        }
                        else
                        {
                            epfr = array_toPtr(ae.e2.тип, efrom);
                            efrom = null;
                            echeck = null;
                        }

                        /* Construct:
                         *   memcpy(ex.ptr, ey.ptr, члобайт)[0..elen]
                         */
                        elem* e = el_params(члобайт, epfr, epto, null);
                        e = el_bin(OPcall,TYnptr,el_var(getRtlsym(RTLSYM_MEMCPY)),e);
                        e = el_pair(eto.Ety, el_copytree(elen), e);

                        /* Combine: eto, efrom, echeck, e
                         */
                        e = el_combine(el_combine(eto, efrom), el_combine(echeck, e));
                        return setрезультат(e);
                    }
                    else if ((postblit || destructor) && ae.op != ТОК2.blit)
                    {
                        /* Generate:
                         *      _d_arrayassign(ti, efrom, eto)
                         * or:
                         *      _d_arrayctor(ti, efrom, eto)
                         */
                        el_free(esize);
                        elem *eti = getTypeInfo(ae.e1.место, t1.nextOf().toBasetype(), irs);
                        if (config.exe == EX_WIN64)
                        {
                            eto   = addressElem(eto,   Тип.tvoid.arrayOf());
                            efrom = addressElem(efrom, Тип.tvoid.arrayOf());
                        }
                        elem *ep = el_params(eto, efrom, eti, null);
                        цел rtl = (ae.op == ТОК2.construct) ? RTLSYM_ARRAYCTOR : RTLSYM_ARRAYASSIGN;
                        elem* e = el_bin(OPcall, totym(ae.тип), el_var(getRtlsym(rtl)), ep);
                        return setрезультат(e);
                    }
                    else
                    {
                        // Generate:
                        //      _d_arraycopy(eto, efrom, esize)

                        if (config.exe == EX_WIN64)
                        {
                            eto   = addressElem(eto,   Тип.tvoid.arrayOf());
                            efrom = addressElem(efrom, Тип.tvoid.arrayOf());
                        }
                        elem *ep = el_params(eto, efrom, esize, null);
                        elem* e = el_bin(OPcall, totym(ae.тип), el_var(getRtlsym(RTLSYM_ARRAYCOPY)), ep);
                        return setрезультат(e);
                    }
                }
                assert(0);
            }

            /* Look for initialization of an `out` or `ref` variable
             */
            if (ae.memset & MemorySet.referenceInit)
            {
                assert(ae.op == ТОК2.construct || ae.op == ТОК2.blit);
                auto ve = ae.e1.isVarExp();
                assert(ve);
                assert(ve.var.класс_хранения & (STC.out_ | STC.ref_));

                // It'll be initialized to an address
                elem* e = toElem(ae.e2, irs);
                e = addressElem(e, ae.e2.тип);
                elem *es = toElem(ae.e1, irs);
                if (es.Eoper == OPind)
                    es = es.EV.E1;
                else
                    es = el_una(OPaddr, TYnptr, es);
                es.Ety = TYnptr;
                e = el_bin(OPeq, TYnptr, es, e);
                assert(!(t1b.ty == Tstruct && ae.e2.op == ТОК2.int64));

                return setрезультат(e);
            }

            tym_t tym = totym(ae.тип);
            elem *e1 = toElem(ae.e1, irs);

            elem *e1x;

            проц setрезультат2(elem* e)
            {
                return setрезультат(el_combine(e, e1x));
            }

            // Create a reference to e1.
            if (e1.Eoper == OPvar)
                e1x = el_copytree(e1);
            else
            {
                /* Rewrite to:
                 *  e1  = *((tmp = &e1), tmp)
                 *  e1x = *tmp
                 */
                e1 = addressElem(e1, null);
                e1x = el_same(&e1);
                e1 = el_una(OPind, tym, e1);
                if (tybasic(tym) == TYstruct)
                    e1.ET = Type_toCtype(ae.e1.тип);
                e1x = el_una(OPind, tym, e1x);
                if (tybasic(tym) == TYstruct)
                    e1x.ET = Type_toCtype(ae.e1.тип);
                //printf("e1  = \n"); elem_print(e1);
                //printf("e1x = \n"); elem_print(e1x);
            }

            // inlining may generate lazy variable initialization
            if (auto ve = ae.e1.isVarExp())
                if (ve.var.класс_хранения & STC.lazy_)
                {
                    assert(ae.op == ТОК2.construct || ae.op == ТОК2.blit);
                    elem* e = el_bin(OPeq, tym, e1, toElem(ae.e2, irs));
                    return setрезультат2(e);
                }

            /* This will work if we can distinguish an assignment from
             * an initialization of the lvalue. It'll work if the latter.
             * If the former, because of aliasing of the return значение with
             * function arguments, it'll fail.
             */
            if (ae.op == ТОК2.construct && ae.e2.op == ТОК2.call)
            {
                CallExp ce = cast(CallExp)ae.e2;
                TypeFunction tf = cast(TypeFunction)ce.e1.тип.toBasetype();
                if (tf.ty == Tfunction && retStyle(tf, ce.f && ce.f.needThis()) == RET.stack)
                {
                    elem *ehidden = e1;
                    ehidden = el_una(OPaddr, TYnptr, ehidden);
                    assert(!irs.ehidden);
                    irs.ehidden = ehidden;
                    elem* e = toElem(ae.e2, irs);
                    return setрезультат2(e);
                }

                /* Look for:
                 *  v = structliteral.ctor(args)
                 * and have the structliteral пиши into v, rather than создай a temporary
                 * and копируй the temporary into v
                 */
                if (e1.Eoper == OPvar && // no closure variables https://issues.dlang.org/show_bug.cgi?ид=17622
                    ae.e1.op == ТОК2.variable && ce.e1.op == ТОК2.dotVariable)
                {
                    auto dve = cast(DotVarExp)ce.e1;
                    auto fd = dve.var.isFuncDeclaration();
                    if (fd && fd.isCtorDeclaration())
                    {
                        if (auto sle = dve.e1.isStructLiteralExp())
                        {
                            sle.sym = toSymbol((cast(VarExp)ae.e1).var);
                            elem* e = toElem(ae.e2, irs);
                            return setрезультат2(e);
                        }
                    }
                }
            }

            //if (ae.op == ТОК2.construct) printf("construct\n");
            if (auto t1s = t1b.isTypeStruct())
            {
                if (ae.e2.op == ТОК2.int64)
                {
                    assert(ae.op == ТОК2.blit);

                    /* Implement:
                     *  (struct = 0)
                     * with:
                     *  memset(&struct, 0, struct.sizeof)
                     */
                    бцел sz = cast(бцел)ae.e1.тип.size();
                    StructDeclaration sd = t1s.sym;

                    elem *el = e1;
                    elem *enbytes = el_long(TYт_мера, sz);
                    elem *evalue = el_long(TYт_мера, 0);

                    el = el_una(OPaddr, TYnptr, el);
                    elem* e = el_param(enbytes, evalue);
                    e = el_bin(OPmemset,TYnptr,el,e);
                    return setрезультат2(e);
                }

                //printf("toElemBin() '%s'\n", ae.вТкст0());

                if (auto sle = ae.e2.isStructLiteralExp())
                {
                    auto ex = e1.Eoper == OPind ? e1.EV.E1 : e1;
                    if (ex.Eoper == OPvar && ex.EV.Voffset == 0 &&
                        (ae.op == ТОК2.construct || ae.op == ТОК2.blit))
                    {
                        elem* e = toElemStructLit(sle, irs, ae.op, ex.EV.Vsym, да);
                        el_free(e1);
                        return setрезультат2(e);
                    }
                }

                /* Implement:
                 *  (struct = struct)
                 */
                elem *e2 = toElem(ae.e2, irs);

                elem* e = elAssign(e1, e2, ae.e1.тип, null);
                return setрезультат2(e);
            }
            else if (t1b.ty == Tsarray)
            {
                if (ae.op == ТОК2.blit && ae.e2.op == ТОК2.int64)
                {
                    /* Implement:
                     *  (sarray = 0)
                     * with:
                     *  memset(&sarray, 0, struct.sizeof)
                     */
                    elem *ey = null;
                    targ_т_мера sz = ae.e1.тип.size();
                    StructDeclaration sd = (cast(TypeStruct)t1b.baseElemOf()).sym;

                    elem *el = e1;
                    elem *enbytes = el_long(TYт_мера, sz);
                    elem *evalue = el_long(TYт_мера, 0);

                    el = el_una(OPaddr, TYnptr, el);
                    elem* e = el_param(enbytes, evalue);
                    e = el_bin(OPmemset,TYnptr,el,e);
                    e = el_combine(ey, e);
                    return setрезультат2(e);
                }

                /* Implement:
                 *  (sarray = sarray)
                 */
                assert(ae.e2.тип.toBasetype().ty == Tsarray);

                бул postblit = needsPostblit(t1b.nextOf()) !is null;
                бул destructor = needsDtor(t1b.nextOf()) !is null;

                /* Optimize static массив assignment with массив literal.
                 * Rewrite:
                 *      e1 = [a, b, ...];
                 * as:
                 *      e1[0] = a, e1[1] = b, ...;
                 *
                 * If the same values are contiguous, that will be rewritten
                 * to block assignment.
                 * Rewrite:
                 *      e1 = [x, a, a, b, ...];
                 * as:
                 *      e1[0] = x, e1[1..2] = a, e1[3] = b, ...;
                 */
                if (ae.op == ТОК2.construct &&   // https://issues.dlang.org/show_bug.cgi?ид=11238
                                               // avoid aliasing issue
                    ae.e2.op == ТОК2.arrayLiteral)
                {
                    ArrayLiteralExp ale = cast(ArrayLiteralExp)ae.e2;
                    elem* e;
                    if (ale.elements.dim == 0)
                    {
                        e = e1;
                    }
                    else
                    {
                        Symbol *stmp = symbol_genauto(TYnptr);
                        e1 = addressElem(e1, t1b);
                        e1 = el_bin(OPeq, TYnptr, el_var(stmp), e1);

                        // Eliminate _d_arrayliteralTX call in ae.e2.
                        e = ВыражениеsToStaticArray(ale.место, ale.elements, &stmp, 0, ale.basis);
                        e = el_combine(e1, e);
                    }
                    return setрезультат2(e);
                }

                /* https://issues.dlang.org/show_bug.cgi?ид=13661
                 * Even if the elements in rhs are all rvalues and
                 * don't have to call postblits, this assignment should call
                 * destructors on old assigned elements.
                 */
                бул lvalueElem = нет;
                if (ae.e2.op == ТОК2.slice && (cast(UnaExp)ae.e2).e1.isLvalue() ||
                    ae.e2.op == ТОК2.cast_  && (cast(UnaExp)ae.e2).e1.isLvalue() ||
                    ae.e2.op != ТОК2.slice && ae.e2.isLvalue())
                {
                    lvalueElem = да;
                }

                elem *e2 = toElem(ae.e2, irs);

                if (!postblit && !destructor ||
                    ae.op == ТОК2.construct && !lvalueElem && postblit ||
                    ae.op == ТОК2.blit ||
                    type_size(e1.ET) == 0)
                {
                    elem* e = elAssign(e1, e2, ae.e1.тип, null);
                    return setрезультат2(e);
                }
                else if (ae.op == ТОК2.construct)
                {
                    e1 = sarray_toDarray(ae.e1.место, ae.e1.тип, null, e1);
                    e2 = sarray_toDarray(ae.e2.место, ae.e2.тип, null, e2);

                    /* Generate:
                     *      _d_arrayctor(ti, e2, e1)
                     */
                    elem *eti = getTypeInfo(ae.e1.место, t1b.nextOf().toBasetype(), irs);
                    if (config.exe == EX_WIN64)
                    {
                        e1 = addressElem(e1, Тип.tvoid.arrayOf());
                        e2 = addressElem(e2, Тип.tvoid.arrayOf());
                    }
                    elem *ep = el_params(e1, e2, eti, null);
                    elem* e = el_bin(OPcall, TYdarray, el_var(getRtlsym(RTLSYM_ARRAYCTOR)), ep);
                    return setрезультат2(e);
                }
                else
                {
                    e1 = sarray_toDarray(ae.e1.место, ae.e1.тип, null, e1);
                    e2 = sarray_toDarray(ae.e2.место, ae.e2.тип, null, e2);

                    Symbol *stmp = symbol_genauto(Type_toCtype(t1b.nextOf()));
                    elem *etmp = el_una(OPaddr, TYnptr, el_var(stmp));

                    /* Generate:
                     *      _d_arrayassign_l(ti, e2, e1, etmp)
                     * or:
                     *      _d_arrayassign_r(ti, e2, e1, etmp)
                     */
                    elem *eti = getTypeInfo(ae.e1.место, t1b.nextOf().toBasetype(), irs);
                    if (config.exe == EX_WIN64)
                    {
                        e1 = addressElem(e1, Тип.tvoid.arrayOf());
                        e2 = addressElem(e2, Тип.tvoid.arrayOf());
                    }
                    elem *ep = el_params(etmp, e1, e2, eti, null);
                    цел rtl = lvalueElem ? RTLSYM_ARRAYASSIGN_L : RTLSYM_ARRAYASSIGN_R;
                    elem* e = el_bin(OPcall, TYdarray, el_var(getRtlsym(rtl)), ep);
                    return setрезультат2(e);
                }
            }
            else
            {
                elem* e = el_bin(OPeq, tym, e1, toElem(ae.e2, irs));
                return setрезультат2(e);
            }
            assert(0);
        }

        /***************************************
         */

        override проц посети(AddAssignExp e)
        {
            //printf("AddAssignExp.toElem() %s\n", e.вТкст0());
            результат = toElemBinAssign(e, OPaddass);
        }


        /***************************************
         */

        override проц посети(MinAssignExp e)
        {
            результат = toElemBinAssign(e, OPminass);
        }

        /***************************************
         */

        override проц посети(CatAssignExp ce)
        {
            //printf("CatAssignExp.toElem('%s')\n", ce.вТкст0());
            elem *e;
            Тип tb1 = ce.e1.тип.toBasetype();
            Тип tb2 = ce.e2.тип.toBasetype();
            assert(tb1.ty == Tarray);
            Тип tb1n = tb1.nextOf().toBasetype();

            elem *e1 = toElem(ce.e1, irs);
            elem *e2 = toElem(ce.e2, irs);

            switch (ce.op)
            {
                case ТОК2.concatenateDcharAssign:
                {
                    // Append dchar to ткст or wткст
                    assert(tb2.ty == Tdchar &&
                          (tb1n.ty == Tchar || tb1n.ty == Twchar));

                    e1 = el_una(OPaddr, TYnptr, e1);

                    elem *ep = el_params(e2, e1, null);
                    цел rtl = (tb1.nextOf().ty == Tchar)
                            ? RTLSYM_ARRAYAPPENDCD
                            : RTLSYM_ARRAYAPPENDWD;
                    e = el_bin(OPcall, TYdarray, el_var(getRtlsym(rtl)), ep);
                    toTraceGC(irs, e, ce.место);
                    elem_setLoc(e, ce.место);
                    break;
                }

                case ТОК2.concatenateAssign:
                {
                    // Append массив
                    assert(tb2.ty == Tarray || tb2.ty == Tsarray);

                    assert(tb1n.равен(tb2.nextOf().toBasetype()));

                    e1 = el_una(OPaddr, TYnptr, e1);
                    if (config.exe == EX_WIN64)
                        e2 = addressElem(e2, tb2, да);
                    else
                        e2 = useOPstrpar(e2);
                    elem *ep = el_params(e2, e1, getTypeInfo(ce.e1.место, ce.e1.тип, irs), null);
                    e = el_bin(OPcall, TYdarray, el_var(getRtlsym(RTLSYM_ARRAYAPPENDT)), ep);
                    toTraceGC(irs, e, ce.место);
                    break;
                }

                case ТОК2.concatenateElemAssign:
                {
                    // Append element
                    assert(tb1n.равен(tb2));

                    elem *e2x = null;

                    if (e2.Eoper != OPvar && e2.Eoper != OPconst)
                    {
                        // Evaluate e2 and assign результат to temporary s2.
                        // Do this because of:
                        //    a ~= a[$-1]
                        // because $ changes its значение
                        тип* tx = Type_toCtype(tb2);
                        Symbol *s2 = symbol_genauto(tx);
                        e2x = elAssign(el_var(s2), e2, tb1n, tx);

                        e2 = el_var(s2);
                    }

                    // Extend массив with _d_arrayappendcTX(TypeInfo ti, e1, 1)
                    e1 = el_una(OPaddr, TYnptr, e1);
                    elem *ep = el_param(e1, getTypeInfo(ce.e1.место, ce.e1.тип, irs));
                    ep = el_param(el_long(TYт_мера, 1), ep);
                    e = el_bin(OPcall, TYdarray, el_var(getRtlsym(RTLSYM_ARRAYAPPENDCTX)), ep);
                    toTraceGC(irs, e, ce.место);
                    Symbol *stmp = symbol_genauto(Type_toCtype(tb1));
                    e = el_bin(OPeq, TYdarray, el_var(stmp), e);

                    // Assign e2 to last element in stmp[]
                    // *(stmp.ptr + (stmp.length - 1) * szelem) = e2

                    elem *eptr = array_toPtr(tb1, el_var(stmp));
                    elem *elength = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, el_var(stmp));
                    elength = el_bin(OPmin, TYт_мера, elength, el_long(TYт_мера, 1));
                    elength = el_bin(OPmul, TYт_мера, elength, el_long(TYт_мера, ce.e2.тип.size()));
                    eptr = el_bin(OPadd, TYnptr, eptr, elength);
                    elem *ederef = el_una(OPind, e2.Ety, eptr);

                    elem *eeq = elAssign(ederef, e2, tb1n, null);
                    e = el_combine(e2x, e);
                    e = el_combine(e, eeq);
                    e = el_combine(e, el_var(stmp));
                    break;
                }

                default:
                    assert(0);
            }
            elem_setLoc(e, ce.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(DivAssignExp e)
        {
            результат = toElemBinAssign(e, OPdivass);
        }

        /***************************************
         */

        override проц посети(ModAssignExp e)
        {
            результат = toElemBinAssign(e, OPmodass);
        }

        /***************************************
         */

        override проц посети(MulAssignExp e)
        {
            результат = toElemBinAssign(e, OPmulass);
        }

        /***************************************
         */

        override проц посети(ShlAssignExp e)
        {
            результат = toElemBinAssign(e, OPshlass);
        }

        /***************************************
         */

        override проц посети(ShrAssignExp e)
        {
            //printf("ShrAssignExp.toElem() %s, %s\n", e.e1.тип.вТкст0(), e.e1.вТкст0());
            Тип t1 = e.e1.тип;
            if (e.e1.op == ТОК2.cast_)
            {
                /* Use the тип before it was integrally promoted to цел
                 */
                CastExp ce = cast(CastExp)e.e1;
                t1 = ce.e1.тип;
            }
            результат = toElemBinAssign(e, t1.isunsigned() ? OPshrass : OPashrass);
        }

        /***************************************
         */

        override проц посети(UshrAssignExp e)
        {
            результат = toElemBinAssign(e, OPshrass);
        }

        /***************************************
         */

        override проц посети(AndAssignExp e)
        {
            результат = toElemBinAssign(e, OPandass);
        }

        /***************************************
         */

        override проц посети(OrAssignExp e)
        {
            результат = toElemBinAssign(e, OPorass);
        }

        /***************************************
         */

        override проц посети(XorAssignExp e)
        {
            результат = toElemBinAssign(e, OPxorass);
        }

        /***************************************
         */

        override проц посети(LogicalExp aae)
        {
            tym_t tym = totym(aae.тип);

            elem *el = toElem(aae.e1, irs);
            elem *er = toElemDtor(aae.e2, irs);
            elem *e = el_bin(aae.op == ТОК2.andAnd ? OPandand : OPoror,tym,el,er);

            elem_setLoc(e, aae.место);

            if (irs.парамы.cov && aae.e2.место.номстр)
                e.EV.E2 = el_combine(incUsageElem(irs, aae.e2.место), e.EV.E2);
            результат = e;
        }

        /***************************************
         */

        override проц посети(XorExp e)
        {
            результат = toElemBin(e, OPxor);
        }

        /***************************************
         */

        override проц посети(AndExp e)
        {
            результат = toElemBin(e, OPand);
        }

        /***************************************
         */

        override проц посети(OrExp e)
        {
            результат = toElemBin(e, OPor);
        }

        /***************************************
         */

        override проц посети(ShlExp e)
        {
            результат = toElemBin(e, OPshl);
        }

        /***************************************
         */

        override проц посети(ShrExp e)
        {
            результат = toElemBin(e, e.e1.тип.isunsigned() ? OPshr : OPashr);
        }

        /***************************************
         */

        override проц посети(UshrExp se)
        {
            elem *eleft  = toElem(se.e1, irs);
            eleft.Ety = touns(eleft.Ety);
            elem *eright = toElem(se.e2, irs);
            elem *e = el_bin(OPshr, totym(se.тип), eleft, eright);
            elem_setLoc(e, se.место);
            результат = e;
        }

        /****************************************
         */

        override проц посети(CommaExp ce)
        {
            assert(ce.e1 && ce.e2);
            elem *eleft  = toElem(ce.e1, irs);
            elem *eright = toElem(ce.e2, irs);
            elem *e = el_combine(eleft, eright);
            if (e)
                elem_setLoc(e, ce.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(CondExp ce)
        {
            elem *ec = toElem(ce.econd, irs);

            elem *eleft = toElem(ce.e1, irs);
            if (irs.парамы.cov && ce.e1.место.номстр)
                eleft = el_combine(incUsageElem(irs, ce.e1.место), eleft);

            elem *eright = toElem(ce.e2, irs);
            if (irs.парамы.cov && ce.e2.место.номстр)
                eright = el_combine(incUsageElem(irs, ce.e2.место), eright);

            tym_t ty = eleft.Ety;
            if (ce.e1.тип.toBasetype().ty == Tvoid ||
                ce.e2.тип.toBasetype().ty == Tvoid)
                ty = TYvoid;

            elem *e = el_bin(OPcond, ty, ec, el_bin(OPcolon, ty, eleft, eright));
            if (tybasic(ty) == TYstruct)
                e.ET = Type_toCtype(ce.e1.тип);
            elem_setLoc(e, ce.место);
            результат = e;
        }

        /***************************************
         */

        override проц посети(TypeExp e)
        {
            //printf("TypeExp.toElem()\n");
            e.выведиОшибку("тип `%s` is not an Выражение", e.вТкст0());
            результат = el_long(TYint, 0);
        }

        override проц посети(ScopeExp e)
        {
            e.выведиОшибку("`%s` is not an Выражение", e.sds.вТкст0());
            результат = el_long(TYint, 0);
        }

        override проц посети(DotVarExp dve)
        {
            // *(&e + смещение)

            //printf("[%s] DotVarExp.toElem('%s')\n", dve.место.вТкст0(), dve.вТкст0());

            VarDeclaration v = dve.var.isVarDeclaration();
            if (!v)
            {
                dve.выведиОшибку("`%s` is not a field, but a %s", dve.var.вТкст0(), dve.var.вид());
                результат = el_long(TYint, 0);
                return;
            }

            // https://issues.dlang.org/show_bug.cgi?ид=12900
            Тип txb = dve.тип.toBasetype();
            Тип tyb = v.тип.toBasetype();
            if (auto tv = txb.isTypeVector()) txb = tv.basetype;
            if (auto tv = tyb.isTypeVector()) tyb = tv.basetype;

            debug if (txb.ty != tyb.ty)
                printf("[%s] dve = %s, dve.тип = %s, v.тип = %s\n", dve.место.вТкст0(), dve.вТкст0(), dve.тип.вТкст0(), v.тип.вТкст0());

            assert(txb.ty == tyb.ty);

            // https://issues.dlang.org/show_bug.cgi?ид=14730
            if (irs.парамы.useInline && v.смещение == 0)
            {
                FuncDeclaration fd = v.родитель.isFuncDeclaration();
                if (fd && fd.semanticRun < PASS.obj)
                    setClosureVarOffset(fd);
            }

            elem *e = toElem(dve.e1, irs);
            Тип tb1 = dve.e1.тип.toBasetype();
            tym_t typ = TYnptr;
            if (tb1.ty != Tclass && tb1.ty != Tpointer)
            {
                e = addressElem(e, tb1);
                typ = tybasic(e.Ety);
            }
            auto смещение = el_long(TYт_мера, v.смещение);
            смещение = objc.getOffset(v, tb1, смещение);
            e = el_bin(OPadd, typ, e, смещение);
            if (v.класс_хранения & (STC.out_ | STC.ref_))
                e = el_una(OPind, TYnptr, e);
            e = el_una(OPind, totym(dve.тип), e);
            if (tybasic(e.Ety) == TYstruct)
            {
                e.ET = Type_toCtype(dve.тип);
            }
            elem_setLoc(e,dve.место);
            результат = e;
        }

        override проц посети(DelegateExp de)
        {
            цел directcall = 0;
            //printf("DelegateExp.toElem() '%s'\n", de.вТкст0());

            if (de.func.semanticRun == PASS.semantic3done)
            {
                // Bug 7745 - only include the function if it belongs to this module
                // ie, it is a member of this module, or is a template instance
                // (the template declaration could come from any module).
                ДСимвол owner = de.func.toParent();
                while (!owner.isTemplateInstance() && owner.toParent())
                    owner = owner.toParent();
                if (owner.isTemplateInstance() || owner == irs.m )
                {
                    irs.deferToObj.сунь(de.func);
                }
            }

            elem *eeq = null;
            elem *ethis;
            Symbol *sfunc = toSymbol(de.func);
            elem *ep;

            elem *ethis2 = null;
            if (de.vthis2)
            {
                // avoid using toSymbol directly because vthis2 may be a closure var
                Выражение ve = new VarExp(de.место, de.vthis2);
                ve.тип = de.vthis2.тип;
                ve = new AddrExp(de.место, ve);
                ve.тип = de.vthis2.тип.pointerTo();
                ethis2 = toElem(ve, irs);
            }

            if (de.func.isNested() && !de.func.isThis())
            {
                ep = el_ptr(sfunc);
                if (de.e1.op == ТОК2.null_)
                    ethis = toElem(de.e1, irs);
                else
                    ethis = getEthis(de.место, irs, de.func, de.func.toParentLocal());

                if (ethis2)
                    ethis2 = setEthis2(de.место, irs, de.func, ethis2, &ethis, &eeq);
            }
            else
            {
                ethis = toElem(de.e1, irs);
                if (de.e1.тип.ty != Tclass && de.e1.тип.ty != Tpointer)
                    ethis = addressElem(ethis, de.e1.тип);

                if (ethis2)
                    ethis2 = setEthis2(de.место, irs, de.func, ethis2, &ethis, &eeq);

                if (de.e1.op == ТОК2.super_ || de.e1.op == ТОК2.dotType)
                    directcall = 1;

                if (!de.func.isThis())
                    de.выведиОшибку("delegates are only for non-static functions");

                if (!de.func.isVirtual() ||
                    directcall ||
                    de.func.isFinalFunc())
                {
                    ep = el_ptr(sfunc);
                }
                else
                {
                    // Get pointer to function out of virtual table

                    assert(ethis);
                    ep = el_same(&ethis);
                    ep = el_una(OPind, TYnptr, ep);
                    бцел vindex = de.func.vtblIndex;

                    assert(cast(цел)vindex >= 0);

                    // Build *(ep + vindex * 4)
                    ep = el_bin(OPadd,TYnptr,ep,el_long(TYт_мера, vindex * target.ptrsize));
                    ep = el_una(OPind,TYnptr,ep);
                }

                //if (func.tintro)
                //    func.выведиОшибку(место, "cannot form delegate due to covariant return тип");
            }

            elem *e;
            if (ethis2)
                ethis = ethis2;
            if (ethis.Eoper == OPcomma)
            {
                ethis.EV.E2 = el_pair(TYdelegate, ethis.EV.E2, ep);
                ethis.Ety = TYdelegate;
                e = ethis;
            }
            else
                e = el_pair(TYdelegate, ethis, ep);
            elem_setLoc(e, de.место);
            if (eeq)
                e = el_combine(eeq, e);
            результат = e;
        }

        override проц посети(DotTypeExp dte)
        {
            // Just a pass-thru to e1
            //printf("DotTypeExp.toElem() %s\n", dte.вТкст0());
            elem *e = toElem(dte.e1, irs);
            elem_setLoc(e, dte.место);
            результат = e;
        }

        override проц посети(CallExp ce)
        {
            //printf("[%s] CallExp.toElem('%s') %p, %s\n", ce.место.вТкст0(), ce.вТкст0(), ce, ce.тип.вТкст0());
            assert(ce.e1.тип);
            Тип t1 = ce.e1.тип.toBasetype();
            Тип ectype = t1;
            elem *eeq = null;

            elem *ehidden = irs.ehidden;
            irs.ehidden = null;

            elem *ec;
            FuncDeclaration fd = null;
            бул dctor = нет;
            if (ce.e1.op == ТОК2.dotVariable && t1.ty != Tdelegate)
            {
                DotVarExp dve = cast(DotVarExp)ce.e1;

                fd = dve.var.isFuncDeclaration();

                if (auto sle = dve.e1.isStructLiteralExp())
                {
                    if (fd && fd.isCtorDeclaration() ||
                        fd.тип.isMutable() ||
                        sle.тип.size() <= 8)          // more efficient than fPIC
                        sle.useStaticInit = нет;     // don't modify инициализатор, so make копируй
                }

                ec = toElem(dve.e1, irs);
                ectype = dve.e1.тип.toBasetype();

                /* Recognize:
                 *   [1] ce:  ((S __ctmp = инициализатор),__ctmp).ctor(args)
                 * where the left of the . was turned into [2] or [3] for EH_DWARF:
                 *   [2] ec:  (dctor info ((__ctmp = инициализатор),__ctmp)), __ctmp
                 *   [3] ec:  (dctor info ((_flag=0),((__ctmp = инициализатор),__ctmp))), __ctmp
                 * The trouble
                 * https://issues.dlang.org/show_bug.cgi?ид=13095
                 * is if ctor(args) throws, then __ctmp is destructed even though __ctmp
                 * is not a fully constructed объект yet. The solution is to move the ctor(args) itno the dctor tree.
                 * But first, detect [1], then [2], then split up [2] into:
                 *   eeq: (dctor info ((__ctmp = инициализатор),__ctmp))
                 *   eeq: (dctor info ((_flag=0),((__ctmp = инициализатор),__ctmp)))   for EH_DWARF
                 *   ec:  __ctmp
                 */
                if (fd && fd.isCtorDeclaration())
                {
                    //printf("test30 %s\n", dve.e1.вТкст0());
                    if (dve.e1.op == ТОК2.comma)
                    {
                        //printf("test30a\n");
                        if ((cast(CommaExp)dve.e1).e1.op == ТОК2.declaration && (cast(CommaExp)dve.e1).e2.op == ТОК2.variable)
                        {   // dve.e1: (declaration , var)

                            //printf("test30b\n");
                            if (ec.Eoper == OPcomma &&
                                ec.EV.E1.Eoper == OPinfo &&
                                ec.EV.E1.EV.E1.Eoper == OPdctor &&
                                ec.EV.E1.EV.E2.Eoper == OPcomma)
                            {   // ec: ((dctor info (* , *)) , *)

                                //printf("test30c\n");
                                dctor = да;                   // remember we detected it

                                // Split ec into eeq and ec per коммент above
                                eeq = ec.EV.E1;                   // (dctor info (*, *))
                                ec.EV.E1 = null;
                                ec = el_selecte2(ec);           // *
                            }
                        }
                    }
                }


                if (dctor)
                {
                }
                else if (ce.arguments && ce.arguments.dim && ec.Eoper != OPvar)
                {
                    if (ec.Eoper == OPind && el_sideeffect(ec.EV.E1))
                    {
                        /* Rewrite (*exp)(arguments) as:
                         * tmp = exp, (*tmp)(arguments)
                         */
                        elem *ec1 = ec.EV.E1;
                        Symbol *stmp = symbol_genauto(type_fake(ec1.Ety));
                        eeq = el_bin(OPeq, ec.Ety, el_var(stmp), ec1);
                        ec.EV.E1 = el_var(stmp);
                    }
                    else if (tybasic(ec.Ety) != TYnptr)
                    {
                        /* Rewrite (exp)(arguments) as:
                         * tmp=&exp, (*tmp)(arguments)
                         */
                        ec = addressElem(ec, ectype);

                        Symbol *stmp = symbol_genauto(type_fake(ec.Ety));
                        eeq = el_bin(OPeq, ec.Ety, el_var(stmp), ec);
                        ec = el_una(OPind, totym(ectype), el_var(stmp));
                    }
                }
            }
            else if (ce.e1.op == ТОК2.variable)
            {
                fd = (cast(VarExp)ce.e1).var.isFuncDeclaration();
                version (none)
                {
                    // This optimization is not valid if alloca can be called
                    // multiple times within the same function, eg in a loop
                    // see issue 3822
                    if (fd && fd.идент == Id.__alloca &&
                        !fd.fbody && fd.компонаж == LINK.c &&
                        arguments && arguments.dim == 1)
                    {   Выражение arg = (*arguments)[0];
                        arg = arg.optimize(WANTvalue);
                        if (arg.isConst() && arg.тип.isintegral())
                        {   dinteger_t sz = arg.toInteger();
                            if (sz > 0 && sz < 0x40000)
                            {
                                // It's an alloca(sz) of a fixed amount.
                                // Replace with an массив allocated on the stack
                                // of the same size: сим[sz] tmp;

                                assert(!ehidden);
                                .тип *t = type_static_array(sz, tschar);  // BUG: fix extra Tcount++
                                Symbol *stmp = symbol_genauto(t);
                                ec = el_ptr(stmp);
                                elem_setLoc(ec,место);
                                return ec;
                            }
                        }
                    }
                }

                ec = toElem(ce.e1, irs);
            }
            else
            {
                ec = toElem(ce.e1, irs);
                if (ce.arguments && ce.arguments.dim)
                {
                    /* The idea is to enforce Выражения being evaluated left to right,
                     * even though call trees are evaluated parameters first.
                     * We just do a quick hack to catch the more obvious cases, though
                     * we need to solve this generally.
                     */
                    if (ec.Eoper == OPind && el_sideeffect(ec.EV.E1))
                    {
                        /* Rewrite (*exp)(arguments) as:
                         * tmp=exp, (*tmp)(arguments)
                         */
                        elem *ec1 = ec.EV.E1;
                        Symbol *stmp = symbol_genauto(type_fake(ec1.Ety));
                        eeq = el_bin(OPeq, ec.Ety, el_var(stmp), ec1);
                        ec.EV.E1 = el_var(stmp);
                    }
                    else if (tybasic(ec.Ety) == TYdelegate && el_sideeffect(ec))
                    {
                        /* Rewrite (exp)(arguments) as:
                         * tmp=exp, (tmp)(arguments)
                         */
                        Symbol *stmp = symbol_genauto(type_fake(ec.Ety));
                        eeq = el_bin(OPeq, ec.Ety, el_var(stmp), ec);
                        ec = el_var(stmp);
                    }
                }
            }
            elem *ethis2 = null;
            if (ce.vthis2)
            {
                // avoid using toSymbol directly because vthis2 may be a closure var
                Выражение ve = new VarExp(ce.место, ce.vthis2);
                ve.тип = ce.vthis2.тип;
                ve = new AddrExp(ce.место, ve);
                ve.тип = ce.vthis2.тип.pointerTo();
                ethis2 = toElem(ve, irs);
            }
            elem *ecall = callfunc(ce.место, irs, ce.directcall, ce.тип, ec, ectype, fd, t1, ehidden, ce.arguments, null, ethis2);

            if (dctor && ecall.Eoper == OPind)
            {
                /* Continuation of fix outlined above for moving constructor call into dctor tree.
                 * Given:
                 *   eeq:   (dctor info ((__ctmp = инициализатор),__ctmp))
                 *   eeq:   (dctor info ((_flag=0),((__ctmp = инициализатор),__ctmp)))   for EH_DWARF
                 *   ecall: * call(ce, args)
                 * Rewrite ecall as:
                 *    * (dctor info ((__ctmp = инициализатор),call(ce, args)))
                 *    * (dctor info ((_flag=0),(__ctmp = инициализатор),call(ce, args)))
                 */
                elem *ea = ecall.EV.E1;           // ea: call(ce,args)
                tym_t ty = ea.Ety;
                ecall.EV.E1 = eeq;
                assert(eeq.Eoper == OPinfo);
                elem *eeqcomma = eeq.EV.E2;
                assert(eeqcomma.Eoper == OPcomma);
                while (eeqcomma.EV.E2.Eoper == OPcomma)
                {
                    eeqcomma.Ety = ty;
                    eeqcomma = eeqcomma.EV.E2;
                }
                eeq.Ety = ty;
                el_free(eeqcomma.EV.E2);
                eeqcomma.EV.E2 = ea;               // replace ,__ctmp with ,call(ce,args)
                eeqcomma.Ety = ty;
                eeq = null;
            }

            elem_setLoc(ecall, ce.место);
            if (eeq)
                ecall = el_combine(eeq, ecall);
            результат = ecall;
        }

        override проц посети(AddrExp ae)
        {
            //printf("AddrExp.toElem('%s')\n", ae.вТкст0());
            if (auto sle = ae.e1.isStructLiteralExp())
            {
                //printf("AddrExp.toElem('%s') %d\n", ae.вТкст0(), ae);
                //printf("StructLiteralExp(%p); origin:%p\n", sle, sle.origin);
                //printf("sle.toSymbol() (%p)\n", sle.toSymbol());
                elem *e = el_ptr(toSymbol(sle.origin));
                e.ET = Type_toCtype(ae.тип);
                elem_setLoc(e, ae.место);
                результат = e;
                return;
            }
            else
            {
                elem *e = toElem(ae.e1, irs);
                e = addressElem(e, ae.e1.тип);
                e.Ety = totym(ae.тип);
                elem_setLoc(e, ae.место);
                результат = e;
                return;
            }
        }

        override проц посети(PtrExp pe)
        {
            //printf("PtrExp.toElem() %s\n", pe.вТкст0());
            elem *e = toElem(pe.e1, irs);
            if (tybasic(e.Ety) == TYnptr &&
                pe.e1.тип.nextOf() &&
                pe.e1.тип.nextOf().isImmutable())
            {
                e.Ety = TYimmutPtr;     // pointer to const
            }
            e = el_una(OPind,totym(pe.тип),e);
            if (tybasic(e.Ety) == TYstruct)
            {
                e.ET = Type_toCtype(pe.тип);
            }
            elem_setLoc(e, pe.место);
            результат = e;
        }

        override проц посети(DeleteExp de)
        {
            Тип tb;

            //printf("DeleteExp.toElem()\n");
            if (de.e1.op == ТОК2.index)
            {
                IndexExp ae = cast(IndexExp)de.e1;
                tb = ae.e1.тип.toBasetype();
                assert(tb.ty != Taarray);
            }
            //e1.тип.print();
            elem *e = toElem(de.e1, irs);
            tb = de.e1.тип.toBasetype();
            цел rtl;
            switch (tb.ty)
            {
                case Tarray:
                {
                    e = addressElem(e, de.e1.тип);
                    rtl = RTLSYM_DELARRAYT;

                    /* See if we need to run destructors on the массив contents
                     */
                    elem *et = null;
                    Тип tv = tb.nextOf().baseElemOf();
                    if (auto ts = tv.isTypeStruct())
                    {
                        // FIXME: ts can be non-mutable, but _d_delarray_t requests TypeInfo_Struct.
                        StructDeclaration sd = ts.sym;
                        if (sd.dtor)
                            et = getTypeInfo(de.e1.место, tb.nextOf(), irs);
                    }
                    if (!et)                            // if no destructors needed
                        et = el_long(TYnptr, 0);        // pass null for TypeInfo
                    e = el_params(et, e, null);
                    // call _d_delarray_t(e, et);
                    break;
                }
                case Tclass:
                    if (de.e1.op == ТОК2.variable)
                    {
                        VarExp ve = cast(VarExp)de.e1;
                        if (ve.var.isVarDeclaration() &&
                            ve.var.isVarDeclaration().onstack)
                        {
                            rtl = RTLSYM_CALLFINALIZER;
                            if (tb.isClassHandle().isInterfaceDeclaration())
                                rtl = RTLSYM_CALLINTERFACEFINALIZER;
                            break;
                        }
                    }
                    e = addressElem(e, de.e1.тип);
                    rtl = RTLSYM_DELCLASS;
                    if (tb.isClassHandle().isInterfaceDeclaration())
                        rtl = RTLSYM_DELINTERFACE;
                    break;

                case Tpointer:
                    e = addressElem(e, de.e1.тип);
                    rtl = RTLSYM_DELMEMORY;
                    tb = (cast(TypePointer)tb).следщ.toBasetype();
                    if (auto ts = tb.isTypeStruct())
                    {
                        if (ts.sym.dtor)
                        {
                            rtl = RTLSYM_DELSTRUCT;
                            elem *et = getTypeInfo(de.e1.место, tb, irs);
                            e = el_params(et, e, null);
                        }
                    }
                    break;

                default:
                    assert(0);
            }
            e = el_bin(OPcall, TYvoid, el_var(getRtlsym(rtl)), e);
            toTraceGC(irs, e, de.место);
            elem_setLoc(e, de.место);
            результат = e;
        }

        override проц посети(VectorExp ve)
        {
            version (none)
            {
                printf("VectorExp.toElem()\n");
                ve.print();
                printf("\tfrom: %s\n", ve.e1.тип.вТкст0());
                printf("\tto  : %s\n", ve.to.вТкст0());
            }

            elem* e;
            if (ve.e1.op == ТОК2.arrayLiteral)
            {
                e = el_calloc();
                e.Eoper = OPconst;
                e.Ety = totym(ve.тип);

                foreach (i; new бцел[0 .. ve.dim])
                {
                    Выражение elem = ve.e1.isArrayLiteralExp()[i];
                    const complex = elem.toComplex();
                    const integer = elem.toInteger();
                    switch (elem.тип.toBasetype().ty)
                    {
                        case Tfloat32:
                            // Must not call toReal directly, to avoid dmd bug 14203 from breaking dmd
                            e.EV.Vfloat8[i] = cast(float) complex.re;
                            break;

                        case Tfloat64:
                            // Must not call toReal directly, to avoid dmd bug 14203 from breaking dmd
                            e.EV.Vdouble4[i] = cast(double) complex.re;
                            break;

                        case Tint64:
                        case Tuns64:
                            e.EV.Vullong4[i] = integer;
                            break;

                        case Tint32:
                        case Tuns32:
                            e.EV.Vulong8[i] = cast(бцел)integer;
                            break;

                        case Tint16:
                        case Tuns16:
                            e.EV.Vushort16[i] = cast(ushort)integer;
                            break;

                        case Tint8:
                        case Tuns8:
                            e.EV.Vuchar32[i] = cast(ббайт)integer;
                            break;

                        default:
                            assert(0);
                    }
                }
            }
            else
            {
                // Create vecfill(e1)
                elem* e1 = toElem(ve.e1, irs);
                e = el_una(OPvecfill, totym(ve.тип), e1);
            }
            elem_setLoc(e, ve.место);
            результат = e;
        }

        override проц посети(VectorArrayExp vae)
        {
            // Generate code for `vec.массив`
            if (auto ve = vae.e1.isVectorExp())
            {
                // https://issues.dlang.org/show_bug.cgi?ид=19607
                // When viewing a vector literal as an массив, build the underlying массив directly.
                if (ve.e1.op == ТОК2.arrayLiteral)
                    результат = toElem(ve.e1, irs);
                else
                {
                    // Generate: stmp[0 .. dim] = e1
                    тип* tarray = Type_toCtype(vae.тип);
                    Symbol* stmp = symbol_genauto(tarray);
                    результат = setArray(ve.e1, el_ptr(stmp), el_long(TYт_мера, tarray.Tdim),
                                      ve.e1.тип, toElem(ve.e1, irs), irs, ТОК2.blit);
                    результат = el_combine(результат, el_var(stmp));
                    результат.ET = tarray;
                }
            }
            else
            {
                // For other vector Выражения this just a paint operation.
                elem* e = toElem(vae.e1, irs);
                тип* tarray = Type_toCtype(vae.тип);
                // Take the address then repaint,
                // this makes it swap to the right registers
                e = addressElem(e, vae.e1.тип);
                e = el_una(OPind, tarray.Tty, e);
                e.ET = tarray;
                результат = e;
            }
            результат.Ety = totym(vae.тип);
            elem_setLoc(результат, vae.место);
        }

        override проц посети(CastExp ce)
        {
            version (none)
            {
                printf("CastExp.toElem()\n");
                ce.print();
                printf("\tfrom: %s\n", ce.e1.тип.вТкст0());
                printf("\tto  : %s\n", ce.to.вТкст0());
            }
            elem *e = toElem(ce.e1, irs);

            результат = toElemCast(ce, e, нет);
        }

        elem *toElemCast(CastExp ce, elem *e, бул isLvalue)
        {
            tym_t ftym;
            tym_t ttym;
            OPER eop;

            Тип tfrom = ce.e1.тип.toBasetype();
            Тип t = ce.to.toBasetype();         // skip over typedef's

            TY fty;
            TY tty;
            if (t.равен(tfrom) ||
                t.равен(Тип.tvoid)) // https://issues.dlang.org/show_bug.cgi?ид=18573
                                      // Remember to вынь значение left on FPU stack
                return e;

            fty = tfrom.ty;
            tty = t.ty;
            //printf("fty = %d\n", fty);

            static elem* Lret(CastExp ce, elem* e)
            {
                // Adjust for any тип paints
                Тип t = ce.тип.toBasetype();
                e.Ety = totym(t);
                if (tyaggregate(e.Ety))
                    e.ET = Type_toCtype(t);

                elem_setLoc(e, ce.место);
                return e;
            }

            static elem* Lpaint(CastExp ce, elem* e, tym_t ttym)
            {
                e.Ety = ttym;
                return Lret(ce, e);
            }

            static elem* Lzero(CastExp ce, elem* e, tym_t ttym)
            {
                e = el_bin(OPcomma, ttym, e, el_long(ttym, 0));
                return Lret(ce, e);
            }

            static elem* Leop(CastExp ce, elem* e, OPER eop, tym_t ttym)
            {
                e = el_una(eop, ttym, e);
                return Lret(ce, e);
            }

            if (tty == Tpointer && fty == Tarray)
            {
                if (e.Eoper == OPvar)
                {
                    // e1 . *(&e1 + 4)
                    e = el_una(OPaddr, TYnptr, e);
                    e = el_bin(OPadd, TYnptr, e, el_long(TYт_мера, tysize(TYnptr)));
                    e = el_una(OPind,totym(t),e);
                }
                else
                {
                    // e1 . (бцел)(e1 >> 32)
                    if (irs.парамы.is64bit)
                    {
                        e = el_bin(OPshr, TYucent, e, el_long(TYint, 64));
                        e = el_una(OP128_64, totym(t), e);
                    }
                    else
                    {
                        e = el_bin(OPshr, TYullong, e, el_long(TYint, 32));
                        e = el_una(OP64_32, totym(t), e);
                    }
                }
                return Lret(ce, e);
            }

            if (tty == Tpointer && fty == Tsarray)
            {
                // e1 . &e1
                e = el_una(OPaddr, TYnptr, e);
                return Lret(ce, e);
            }

            // Convert from static массив to dynamic массив
            if (tty == Tarray && fty == Tsarray)
            {
                e = sarray_toDarray(ce.место, tfrom, t, e);
                return Lret(ce, e);
            }

            // Convert from dynamic массив to dynamic массив
            if (tty == Tarray && fty == Tarray)
            {
                бцел fsize = cast(бцел)tfrom.nextOf().size();
                бцел tsize = cast(бцел)t.nextOf().size();

                if (fsize != tsize)
                {   // МассивДРК element sizes do not match, so we must adjust the dimensions
                    if (tsize != 0 && fsize % tsize == 0)
                    {
                        // Set массив dimension to (length * (fsize / tsize))
                        // Generate pair(e.length * (fsize/tsize), es.ptr)

                        elem *es = el_same(&e);

                        elem *eptr = el_una(OPmsw, TYnptr, es);
                        elem *elen = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, e);
                        elem *elen2 = el_bin(OPmul, TYт_мера, elen, el_long(TYт_мера, fsize / tsize));
                        e = el_pair(totym(ce.тип), elen2, eptr);
                    }
                    else
                    {
                        assert(нет, "This case should have been rewritten to `__МассивCast` in the semantic phase");
                    }
                }
                return Lret(ce, e);
            }

            // Casting between class/interface may require a runtime check
            if (fty == Tclass && tty == Tclass)
            {
                ClassDeclaration cdfrom = tfrom.isClassHandle();
                ClassDeclaration cdto   = t.isClassHandle();

                цел смещение;
                if (cdto.isBaseOf(cdfrom, &смещение) && смещение != ClassDeclaration.OFFSET_RUNTIME)
                {
                    /* The смещение from cdfrom => cdto is known at compile time.
                     * Cases:
                     *  - class => base class (upcast)
                     *  - class => base interface (upcast)
                     */

                    //printf("смещение = %d\n", смещение);
                    if (смещение == ClassDeclaration.OFFSET_FWDREF)
                    {
                        assert(0, "unexpected forward reference");
                    }
                    else if (смещение)
                    {
                        /* Rewrite cast as (e ? e + смещение : null)
                         */
                        if (ce.e1.op == ТОК2.this_)
                        {
                            // Assume 'this' is never null, so skip null check
                            e = el_bin(OPadd, TYnptr, e, el_long(TYт_мера, смещение));
                        }
                        else
                        {
                            elem *etmp = el_same(&e);
                            elem *ex = el_bin(OPadd, TYnptr, etmp, el_long(TYт_мера, смещение));
                            ex = el_bin(OPcolon, TYnptr, ex, el_long(TYnptr, 0));
                            e = el_bin(OPcond, TYnptr, e, ex);
                        }
                    }
                    else
                    {
                        // Casting from derived class to base class is a no-op
                    }
                }
                else if (cdfrom.classKind == ClassKind.cpp)
                {
                    if (cdto.classKind == ClassKind.cpp)
                    {
                        /* Casting from a C++ interface to a C++ interface
                         * is always a 'paint' operation
                         */
                        return Lret(ce, e);                  // no-op
                    }

                    /* Casting from a C++ interface to a class
                     * always результатs in null because there is no runtime
                     * information доступно to do it.
                     *
                     * Casting from a C++ interface to a non-C++ interface
                     * always результатs in null because there's no way one
                     * can be derived from the other.
                     */
                    e = el_bin(OPcomma, TYnptr, e, el_long(TYnptr, 0));
                    return Lret(ce, e);
                }
                else
                {
                    /* The смещение from cdfrom => cdto can only be determined at runtime.
                     * Cases:
                     *  - class     => derived class (downcast)
                     *  - interface => derived class (downcast)
                     *  - class     => foreign interface (cross cast)
                     *  - interface => base or foreign interface (cross cast)
                     */
                    цел rtl = cdfrom.isInterfaceDeclaration()
                                ? RTLSYM_INTERFACE_CAST
                                : RTLSYM_DYNAMIC_CAST;
                    elem *ep = el_param(el_ptr(toSymbol(cdto)), e);
                    e = el_bin(OPcall, TYnptr, el_var(getRtlsym(rtl)), ep);
                }
                return Lret(ce, e);
            }

            if (fty == Tvector && tty == Tsarray)
            {
                if (tfrom.size() == t.size())
                {
                    if (e.Eoper != OPvar && e.Eoper != OPind)
                    {
                        // can't perform массив ops on it unless it's in memory
                        e = addressElem(e, tfrom);
                        e = el_una(OPind, TYarray, e);
                        e.ET = Type_toCtype(t);
                    }
                    return Lret(ce, e);
                }
            }

            ftym = tybasic(e.Ety);
            ttym = tybasic(totym(t));
            if (ftym == ttym)
                return Lret(ce, e);

            /* Reduce combinatorial explosion by rewriting the 'to' and 'from' types to a
             * generic equivalent (as far as casting goes)
             */
            switch (tty)
            {
                case Tpointer:
                    if (fty == Tdelegate)
                        return Lpaint(ce, e, ttym);
                    tty = irs.парамы.is64bit ? Tuns64 : Tuns32;
                    break;

                case Tchar:     tty = Tuns8;    break;
                case Twchar:    tty = Tuns16;   break;
                case Tdchar:    tty = Tuns32;   break;
                case Tvoid:     return Lpaint(ce, e, ttym);

                case Tbool:
                {
                    // Construct e?да:нет
                    e = el_una(OPбул, ttym, e);
                    return Lret(ce, e);
                }

                default:
                    break;
            }

            switch (fty)
            {
                case Tnull:
                {
                    // typeof(null) is same with ук in binary уровень.
                    return Lzero(ce, e, ttym);
                }
                case Tpointer:  fty = irs.парамы.is64bit ? Tuns64 : Tuns32;  break;
                case Tchar:     fty = Tuns8;    break;
                case Twchar:    fty = Tuns16;   break;
                case Tdchar:    fty = Tuns32;   break;

                default:
                    break;
            }

            static цел X(цел fty, цел tty) { return fty * TMAX + tty; }

            while (да)
            {
                switch (X(fty,tty))
                {
                    /* ============================= */

                    case X(Tbool,Tint8):
                    case X(Tbool,Tuns8):
                        return Lpaint(ce, e, ttym);
                    case X(Tbool,Tint16):
                    case X(Tbool,Tuns16):
                    case X(Tbool,Tint32):
                    case X(Tbool,Tuns32):
                        if (isLvalue)
                        {
                            eop = OPu8_16;
                            return Leop(ce, e, eop, ttym);
                        }
                        else
                        {
                            e = el_bin(OPand, TYuchar, e, el_long(TYuchar, 1));
                            fty = Tuns8;
                            continue;
                        }

                    case X(Tbool,Tint64):
                    case X(Tbool,Tuns64):
                    case X(Tbool,Tfloat32):
                    case X(Tbool,Tfloat64):
                    case X(Tbool,Tfloat80):
                    case X(Tbool,Tcomplex32):
                    case X(Tbool,Tcomplex64):
                    case X(Tbool,Tcomplex80):
                        e = el_bin(OPand, TYuchar, e, el_long(TYuchar, 1));
                        fty = Tuns8;
                        continue;

                    case X(Tbool,Timaginary32):
                    case X(Tbool,Timaginary64):
                    case X(Tbool,Timaginary80):
                        return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tint8,Tuns8):    return Lpaint(ce, e, ttym);
                    case X(Tint8,Tint16):
                    case X(Tint8,Tuns16):
                    case X(Tint8,Tint32):
                    case X(Tint8,Tuns32):   eop = OPs8_16;  return Leop(ce, e, eop, ttym);
                    case X(Tint8,Tint64):
                    case X(Tint8,Tuns64):
                    case X(Tint8,Tfloat32):
                    case X(Tint8,Tfloat64):
                    case X(Tint8,Tfloat80):
                    case X(Tint8,Tcomplex32):
                    case X(Tint8,Tcomplex64):
                    case X(Tint8,Tcomplex80):
                        e = el_una(OPs8_16, TYint, e);
                        fty = Tint32;
                        continue;
                    case X(Tint8,Timaginary32):
                    case X(Tint8,Timaginary64):
                    case X(Tint8,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tuns8,Tint8):    return Lpaint(ce, e, ttym);
                    case X(Tuns8,Tint16):
                    case X(Tuns8,Tuns16):
                    case X(Tuns8,Tint32):
                    case X(Tuns8,Tuns32):   eop = OPu8_16;  return Leop(ce, e, eop, ttym);
                    case X(Tuns8,Tint64):
                    case X(Tuns8,Tuns64):
                    case X(Tuns8,Tfloat32):
                    case X(Tuns8,Tfloat64):
                    case X(Tuns8,Tfloat80):
                    case X(Tuns8,Tcomplex32):
                    case X(Tuns8,Tcomplex64):
                    case X(Tuns8,Tcomplex80):
                        e = el_una(OPu8_16, TYuint, e);
                        fty = Tuns32;
                        continue;
                    case X(Tuns8,Timaginary32):
                    case X(Tuns8,Timaginary64):
                    case X(Tuns8,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tint16,Tint8):
                    case X(Tint16,Tuns8):   eop = OP16_8;   return Leop(ce, e, eop, ttym);
                    case X(Tint16,Tuns16):  return Lpaint(ce, e, ttym);
                    case X(Tint16,Tint32):
                    case X(Tint16,Tuns32):  eop = OPs16_32; return Leop(ce, e, eop, ttym);
                    case X(Tint16,Tint64):
                    case X(Tint16,Tuns64):  e = el_una(OPs16_32, TYint, e);
                        fty = Tint32;
                        continue;
                    case X(Tint16,Tfloat32):
                    case X(Tint16,Tfloat64):
                    case X(Tint16,Tfloat80):
                    case X(Tint16,Tcomplex32):
                    case X(Tint16,Tcomplex64):
                    case X(Tint16,Tcomplex80):
                        e = el_una(OPs16_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tint16,Timaginary32):
                    case X(Tint16,Timaginary64):
                    case X(Tint16,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tuns16,Tint8):
                    case X(Tuns16,Tuns8):   eop = OP16_8;   return Leop(ce, e, eop, ttym);
                    case X(Tuns16,Tint16):  return Lpaint(ce, e, ttym);
                    case X(Tuns16,Tint32):
                    case X(Tuns16,Tuns32):  eop = OPu16_32; return Leop(ce, e, eop, ttym);
                    case X(Tuns16,Tint64):
                    case X(Tuns16,Tuns64):
                    case X(Tuns16,Tfloat64):
                    case X(Tuns16,Tfloat32):
                    case X(Tuns16,Tfloat80):
                    case X(Tuns16,Tcomplex32):
                    case X(Tuns16,Tcomplex64):
                    case X(Tuns16,Tcomplex80):
                        e = el_una(OPu16_32, TYuint, e);
                        fty = Tuns32;
                        continue;
                    case X(Tuns16,Timaginary32):
                    case X(Tuns16,Timaginary64):
                    case X(Tuns16,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tint32,Tint8):
                    case X(Tint32,Tuns8):   e = el_una(OP32_16, TYshort, e);
                        fty = Tint16;
                        continue;
                    case X(Tint32,Tint16):
                    case X(Tint32,Tuns16):  eop = OP32_16;  return Leop(ce, e, eop, ttym);
                    case X(Tint32,Tuns32):  return Lpaint(ce, e, ttym);
                    case X(Tint32,Tint64):
                    case X(Tint32,Tuns64):  eop = OPs32_64; return Leop(ce, e, eop, ttym);
                    case X(Tint32,Tfloat32):
                    case X(Tint32,Tfloat64):
                    case X(Tint32,Tfloat80):
                    case X(Tint32,Tcomplex32):
                    case X(Tint32,Tcomplex64):
                    case X(Tint32,Tcomplex80):
                        e = el_una(OPs32_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tint32,Timaginary32):
                    case X(Tint32,Timaginary64):
                    case X(Tint32,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tuns32,Tint8):
                    case X(Tuns32,Tuns8):   e = el_una(OP32_16, TYshort, e);
                        fty = Tuns16;
                        continue;
                    case X(Tuns32,Tint16):
                    case X(Tuns32,Tuns16):  eop = OP32_16;  return Leop(ce, e, eop, ttym);
                    case X(Tuns32,Tint32):  return Lpaint(ce, e, ttym);
                    case X(Tuns32,Tint64):
                    case X(Tuns32,Tuns64):  eop = OPu32_64; return Leop(ce, e, eop, ttym);
                    case X(Tuns32,Tfloat32):
                    case X(Tuns32,Tfloat64):
                    case X(Tuns32,Tfloat80):
                    case X(Tuns32,Tcomplex32):
                    case X(Tuns32,Tcomplex64):
                    case X(Tuns32,Tcomplex80):
                        e = el_una(OPu32_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tuns32,Timaginary32):
                    case X(Tuns32,Timaginary64):
                    case X(Tuns32,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tint64,Tint8):
                    case X(Tint64,Tuns8):
                    case X(Tint64,Tint16):
                    case X(Tint64,Tuns16):  e = el_una(OP64_32, TYint, e);
                        fty = Tint32;
                        continue;
                    case X(Tint64,Tint32):
                    case X(Tint64,Tuns32):  eop = OP64_32; return Leop(ce, e, eop, ttym);
                    case X(Tint64,Tuns64):  return Lpaint(ce, e, ttym);
                    case X(Tint64,Tfloat32):
                    case X(Tint64,Tfloat64):
                    case X(Tint64,Tfloat80):
                    case X(Tint64,Tcomplex32):
                    case X(Tint64,Tcomplex64):
                    case X(Tint64,Tcomplex80):
                        e = el_una(OPs64_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tint64,Timaginary32):
                    case X(Tint64,Timaginary64):
                    case X(Tint64,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tuns64,Tint8):
                    case X(Tuns64,Tuns8):
                    case X(Tuns64,Tint16):
                    case X(Tuns64,Tuns16):  e = el_una(OP64_32, TYint, e);
                        fty = Tint32;
                        continue;
                    case X(Tuns64,Tint32):
                    case X(Tuns64,Tuns32):  eop = OP64_32;  return Leop(ce, e, eop, ttym);
                    case X(Tuns64,Tint64):  return Lpaint(ce, e, ttym);
                    case X(Tuns64,Tfloat32):
                    case X(Tuns64,Tfloat64):
                    case X(Tuns64,Tfloat80):
                    case X(Tuns64,Tcomplex32):
                    case X(Tuns64,Tcomplex64):
                    case X(Tuns64,Tcomplex80):
                        e = el_una(OPu64_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tuns64,Timaginary32):
                    case X(Tuns64,Timaginary64):
                    case X(Tuns64,Timaginary80): return Lzero(ce, e, ttym);

                        /* ============================= */

                    case X(Tfloat32,Tint8):
                    case X(Tfloat32,Tuns8):
                    case X(Tfloat32,Tint16):
                    case X(Tfloat32,Tuns16):
                    case X(Tfloat32,Tint32):
                    case X(Tfloat32,Tuns32):
                    case X(Tfloat32,Tint64):
                    case X(Tfloat32,Tuns64):
                    case X(Tfloat32,Tfloat80): e = el_una(OPf_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tfloat32,Tfloat64): eop = OPf_d; return Leop(ce, e, eop, ttym);
                    case X(Tfloat32,Timaginary32):
                    case X(Tfloat32,Timaginary64):
                    case X(Tfloat32,Timaginary80): return Lzero(ce, e, ttym);
                    case X(Tfloat32,Tcomplex32):
                    case X(Tfloat32,Tcomplex64):
                    case X(Tfloat32,Tcomplex80):
                        e = el_bin(OPadd,TYcfloat,el_long(TYifloat,0),e);
                        fty = Tcomplex32;
                        continue;

                        /* ============================= */

                    case X(Tfloat64,Tint8):
                    case X(Tfloat64,Tuns8):    e = el_una(OPd_s16, TYshort, e);
                        fty = Tint16;
                        continue;
                    case X(Tfloat64,Tint16):   eop = OPd_s16; return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tuns16):   eop = OPd_u16; return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tint32):   eop = OPd_s32; return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tuns32):   eop = OPd_u32; return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tint64):   eop = OPd_s64; return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tuns64):   eop = OPd_u64; return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tfloat32): eop = OPd_f;   return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Tfloat80): eop = OPd_ld;  return Leop(ce, e, eop, ttym);
                    case X(Tfloat64,Timaginary32):
                    case X(Tfloat64,Timaginary64):
                    case X(Tfloat64,Timaginary80):  return Lzero(ce, e, ttym);
                    case X(Tfloat64,Tcomplex32):
                    case X(Tfloat64,Tcomplex64):
                    case X(Tfloat64,Tcomplex80):
                        e = el_bin(OPadd,TYcdouble,el_long(TYidouble,0),e);
                        fty = Tcomplex64;
                        continue;

                        /* ============================= */

                    case X(Tfloat80,Tint8):
                    case X(Tfloat80,Tuns8):
                    case X(Tfloat80,Tint16):
                    case X(Tfloat80,Tuns16):
                    case X(Tfloat80,Tint32):
                    case X(Tfloat80,Tuns32):
                    case X(Tfloat80,Tint64):
                    case X(Tfloat80,Tfloat32): e = el_una(OPld_d, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tfloat80,Tuns64):
                        eop = OPld_u64; return Leop(ce, e, eop, ttym);
                    case X(Tfloat80,Tfloat64): eop = OPld_d; return Leop(ce, e, eop, ttym);
                    case X(Tfloat80,Timaginary32):
                    case X(Tfloat80,Timaginary64):
                    case X(Tfloat80,Timaginary80): return Lzero(ce, e, ttym);
                    case X(Tfloat80,Tcomplex32):
                    case X(Tfloat80,Tcomplex64):
                    case X(Tfloat80,Tcomplex80):
                        e = el_bin(OPadd,TYcldouble,e,el_long(TYildouble,0));
                        fty = Tcomplex80;
                        continue;

                        /* ============================= */

                    case X(Timaginary32,Tint8):
                    case X(Timaginary32,Tuns8):
                    case X(Timaginary32,Tint16):
                    case X(Timaginary32,Tuns16):
                    case X(Timaginary32,Tint32):
                    case X(Timaginary32,Tuns32):
                    case X(Timaginary32,Tint64):
                    case X(Timaginary32,Tuns64):
                    case X(Timaginary32,Tfloat32):
                    case X(Timaginary32,Tfloat64):
                    case X(Timaginary32,Tfloat80):  return Lzero(ce, e, ttym);
                    case X(Timaginary32,Timaginary64): eop = OPf_d; return Leop(ce, e, eop, ttym);
                    case X(Timaginary32,Timaginary80):
                        e = el_una(OPf_d, TYidouble, e);
                        fty = Timaginary64;
                        continue;
                    case X(Timaginary32,Tcomplex32):
                    case X(Timaginary32,Tcomplex64):
                    case X(Timaginary32,Tcomplex80):
                        e = el_bin(OPadd,TYcfloat,el_long(TYfloat,0),e);
                        fty = Tcomplex32;
                        continue;

                        /* ============================= */

                    case X(Timaginary64,Tint8):
                    case X(Timaginary64,Tuns8):
                    case X(Timaginary64,Tint16):
                    case X(Timaginary64,Tuns16):
                    case X(Timaginary64,Tint32):
                    case X(Timaginary64,Tuns32):
                    case X(Timaginary64,Tint64):
                    case X(Timaginary64,Tuns64):
                    case X(Timaginary64,Tfloat32):
                    case X(Timaginary64,Tfloat64):
                    case X(Timaginary64,Tfloat80):  return Lzero(ce, e, ttym);
                    case X(Timaginary64,Timaginary32): eop = OPd_f;   return Leop(ce, e, eop, ttym);
                    case X(Timaginary64,Timaginary80): eop = OPd_ld;  return Leop(ce, e, eop, ttym);
                    case X(Timaginary64,Tcomplex32):
                    case X(Timaginary64,Tcomplex64):
                    case X(Timaginary64,Tcomplex80):
                        e = el_bin(OPadd,TYcdouble,el_long(TYdouble,0),e);
                        fty = Tcomplex64;
                        continue;

                        /* ============================= */

                    case X(Timaginary80,Tint8):
                    case X(Timaginary80,Tuns8):
                    case X(Timaginary80,Tint16):
                    case X(Timaginary80,Tuns16):
                    case X(Timaginary80,Tint32):
                    case X(Timaginary80,Tuns32):
                    case X(Timaginary80,Tint64):
                    case X(Timaginary80,Tuns64):
                    case X(Timaginary80,Tfloat32):
                    case X(Timaginary80,Tfloat64):
                    case X(Timaginary80,Tfloat80):  return Lzero(ce, e, ttym);
                    case X(Timaginary80,Timaginary32): e = el_una(OPld_d, TYidouble, e);
                        fty = Timaginary64;
                        continue;
                    case X(Timaginary80,Timaginary64): eop = OPld_d; return Leop(ce, e, eop, ttym);
                    case X(Timaginary80,Tcomplex32):
                    case X(Timaginary80,Tcomplex64):
                    case X(Timaginary80,Tcomplex80):
                        e = el_bin(OPadd,TYcldouble,el_long(TYldouble,0),e);
                        fty = Tcomplex80;
                        continue;

                        /* ============================= */

                    case X(Tcomplex32,Tint8):
                    case X(Tcomplex32,Tuns8):
                    case X(Tcomplex32,Tint16):
                    case X(Tcomplex32,Tuns16):
                    case X(Tcomplex32,Tint32):
                    case X(Tcomplex32,Tuns32):
                    case X(Tcomplex32,Tint64):
                    case X(Tcomplex32,Tuns64):
                    case X(Tcomplex32,Tfloat32):
                    case X(Tcomplex32,Tfloat64):
                    case X(Tcomplex32,Tfloat80):
                        e = el_una(OPc_r, TYfloat, e);
                        fty = Tfloat32;
                        continue;
                    case X(Tcomplex32,Timaginary32):
                    case X(Tcomplex32,Timaginary64):
                    case X(Tcomplex32,Timaginary80):
                        e = el_una(OPc_i, TYifloat, e);
                        fty = Timaginary32;
                        continue;
                    case X(Tcomplex32,Tcomplex64):
                    case X(Tcomplex32,Tcomplex80):
                        e = el_una(OPf_d, TYcdouble, e);
                        fty = Tcomplex64;
                        continue;

                        /* ============================= */

                    case X(Tcomplex64,Tint8):
                    case X(Tcomplex64,Tuns8):
                    case X(Tcomplex64,Tint16):
                    case X(Tcomplex64,Tuns16):
                    case X(Tcomplex64,Tint32):
                    case X(Tcomplex64,Tuns32):
                    case X(Tcomplex64,Tint64):
                    case X(Tcomplex64,Tuns64):
                    case X(Tcomplex64,Tfloat32):
                    case X(Tcomplex64,Tfloat64):
                    case X(Tcomplex64,Tfloat80):
                        e = el_una(OPc_r, TYdouble, e);
                        fty = Tfloat64;
                        continue;
                    case X(Tcomplex64,Timaginary32):
                    case X(Tcomplex64,Timaginary64):
                    case X(Tcomplex64,Timaginary80):
                        e = el_una(OPc_i, TYidouble, e);
                        fty = Timaginary64;
                        continue;
                    case X(Tcomplex64,Tcomplex32):   eop = OPd_f;   return Leop(ce, e, eop, ttym);
                    case X(Tcomplex64,Tcomplex80):   eop = OPd_ld;  return Leop(ce, e, eop, ttym);

                        /* ============================= */

                    case X(Tcomplex80,Tint8):
                    case X(Tcomplex80,Tuns8):
                    case X(Tcomplex80,Tint16):
                    case X(Tcomplex80,Tuns16):
                    case X(Tcomplex80,Tint32):
                    case X(Tcomplex80,Tuns32):
                    case X(Tcomplex80,Tint64):
                    case X(Tcomplex80,Tuns64):
                    case X(Tcomplex80,Tfloat32):
                    case X(Tcomplex80,Tfloat64):
                    case X(Tcomplex80,Tfloat80):
                        e = el_una(OPc_r, TYldouble, e);
                        fty = Tfloat80;
                        continue;
                    case X(Tcomplex80,Timaginary32):
                    case X(Tcomplex80,Timaginary64):
                    case X(Tcomplex80,Timaginary80):
                        e = el_una(OPc_i, TYildouble, e);
                        fty = Timaginary80;
                        continue;
                    case X(Tcomplex80,Tcomplex32):
                    case X(Tcomplex80,Tcomplex64):
                        e = el_una(OPld_d, TYcdouble, e);
                        fty = Tcomplex64;
                        continue;

                        /* ============================= */

                    default:
                        if (fty == tty)
                            return Lpaint(ce, e, ttym);
                        //dump(0);
                        //printf("fty = %d, tty = %d, %d\n", fty, tty, t.ty);
                        // This error should really be pushed to the front end
                        ce.выведиОшибку("e2ir: cannot cast `%s` of тип `%s` to тип `%s`", ce.e1.вТкст0(), ce.e1.тип.вТкст0(), t.вТкст0());
                        e = el_long(TYint, 0);
                        return e;

                }
            }
        }

        override проц посети(ArrayLengthExp ale)
        {
            elem *e = toElem(ale.e1, irs);
            e = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, totym(ale.тип), e);
            elem_setLoc(e, ale.место);
            результат = e;
        }

        override проц посети(DelegatePtrExp dpe)
        {
            // *cast(ук*)(&dg)
            elem *e = toElem(dpe.e1, irs);
            Тип tb1 = dpe.e1.тип.toBasetype();
            e = addressElem(e, tb1);
            e = el_una(OPind, totym(dpe.тип), e);
            elem_setLoc(e, dpe.место);
            результат = e;
        }

        override проц посети(DelegateFuncptrExp dfpe)
        {
            // *cast(ук*)(&dg + т_мера.sizeof)
            elem *e = toElem(dfpe.e1, irs);
            Тип tb1 = dfpe.e1.тип.toBasetype();
            e = addressElem(e, tb1);
            e = el_bin(OPadd, TYnptr, e, el_long(TYт_мера, irs.парамы.is64bit ? 8 : 4));
            e = el_una(OPind, totym(dfpe.тип), e);
            elem_setLoc(e, dfpe.место);
            результат = e;
        }

        override проц посети(SliceExp se)
        {
            //printf("SliceExp.toElem() se = %s %s\n", se.тип.вТкст0(), se.вТкст0());
            Тип tb = se.тип.toBasetype();
            assert(tb.ty == Tarray || tb.ty == Tsarray);
            Тип t1 = se.e1.тип.toBasetype();
            elem *e = toElem(se.e1, irs);
            if (se.lwr)
            {
                бцел sz = cast(бцел)t1.nextOf().size();

                elem *einit = resolveLengthVar(se.lengthVar, &e, t1);
                if (t1.ty == Tsarray)
                    e = array_toPtr(se.e1.тип, e);
                if (!einit)
                {
                    einit = e;
                    e = el_same(&einit);
                }
                // e is a temporary, typed:
                //  TYdarray if t.ty == Tarray
                //  TYptr if t.ty == Tsarray or Tpointer

                elem *elwr = toElem(se.lwr, irs);
                elem *eupr = toElem(se.upr, irs);
                elem *elwr2 = el_sideeffect(eupr) ? el_copytotmp(&elwr) : el_same(&elwr);
                elem *eupr2 = eupr;

                //printf("upperIsInBounds = %d lowerIsLessThanUpper = %d\n", se.upperIsInBounds, se.lowerIsLessThanUpper);
                if (irs.arrayBoundsCheck())
                {
                    // Checks (unsigned compares):
                    //  upr <= массив.length
                    //  lwr <= upr

                    elem *c1 = null;
                    elem *elen;
                    if (!se.upperIsInBounds)
                    {
                        eupr2 = el_same(&eupr);
                        eupr2.Ety = TYт_мера;  // make sure unsigned comparison

                        if (auto tsa = t1.isTypeSArray())
                        {
                            elen = el_long(TYт_мера, tsa.dim.toInteger());
                        }
                        else if (t1.ty == Tarray)
                        {
                            if (se.lengthVar && !(se.lengthVar.класс_хранения & STC.const_))
                                elen = el_var(toSymbol(se.lengthVar));
                            else
                            {
                                elen = e;
                                e = el_same(&elen);
                                elen = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, elen);
                            }
                        }

                        c1 = el_bin(OPle, TYint, eupr, elen);

                        if (!se.lowerIsLessThanUpper)
                        {
                            c1 = el_bin(OPandand, TYint,
                                c1, el_bin(OPle, TYint, elwr2, eupr2));
                            elwr2 = el_copytree(elwr2);
                            eupr2 = el_copytree(eupr2);
                        }
                    }
                    else if (!se.lowerIsLessThanUpper)
                    {
                        eupr2 = el_same(&eupr);
                        eupr2.Ety = TYт_мера;  // make sure unsigned comparison

                        c1 = el_bin(OPle, TYint, elwr2, eupr);
                        elwr2 = el_copytree(elwr2);
                    }

                    if (c1)
                    {
                        // Construct: (c1 || arrayBoundsError)
                        auto ea = buildArrayBoundsError(irs, se.место, el_copytree(elwr2), el_copytree(eupr2), el_copytree(elen));
                        elem *eb = el_bin(OPoror, TYvoid, c1, ea);

                        elwr = el_combine(elwr, eb);
                    }
                }
                if (t1.ty != Tsarray)
                    e = array_toPtr(se.e1.тип, e);

                // Create an массив reference where:
                // length is (upr - lwr)
                // pointer is (ptr + lwr*sz)
                // Combine as (length pair ptr)

                elem *eofs = el_bin(OPmul, TYт_мера, elwr2, el_long(TYт_мера, sz));
                elem *eptr = el_bin(OPadd, TYnptr, e, eofs);

                if (tb.ty == Tarray)
                {
                    elem *elen = el_bin(OPmin, TYт_мера, eupr2, el_copytree(elwr2));
                    e = el_pair(TYdarray, elen, eptr);
                }
                else
                {
                    assert(tb.ty == Tsarray);
                    e = el_una(OPind, totym(se.тип), eptr);
                    if (tybasic(e.Ety) == TYstruct)
                        e.ET = Type_toCtype(se.тип);
                }
                e = el_combine(elwr, e);
                e = el_combine(einit, e);
                //elem_print(e);
            }
            else if (t1.ty == Tsarray && tb.ty == Tarray)
            {
                e = sarray_toDarray(se.место, t1, null, e);
            }
            else
            {
                assert(t1.ty == tb.ty);   // Tarray or Tsarray

                // https://issues.dlang.org/show_bug.cgi?ид=14672
                // If se is in left side operand of element-wise
                // assignment, the element тип can be painted to the base class.
                цел смещение;
                assert(t1.nextOf().equivalent(tb.nextOf()) ||
                       tb.nextOf().isBaseOf(t1.nextOf(), &смещение) && смещение == 0);
            }
            elem_setLoc(e, se.место);
            результат = e;
        }

        override проц посети(IndexExp ie)
        {
            elem *e;
            elem *n1 = toElem(ie.e1, irs);
            elem *eb = null;

            //printf("IndexExp.toElem() %s\n", ie.вТкст0());
            Тип t1 = ie.e1.тип.toBasetype();
            if (auto taa = t1.isTypeAArray())
            {
                // set to:
                //      *aaGetY(aa, aati, valuesize, &ключ);
                // or
                //      *aaGetRvalueX(aa, keyti, valuesize, &ключ);

                бцел vsize = cast(бцел)taa.следщ.size();

                // n2 becomes the index, also known as the ключ
                elem *n2 = toElem(ie.e2, irs);

                /* Turn n2 into a pointer to the index.  If it's an lvalue,
                 * take the address of it. If not, копируй it to a temp and
                 * take the address of that.
                 */
                n2 = addressElem(n2, taa.index);

                elem *valuesize = el_long(TYт_мера, vsize);
                //printf("valuesize: "); elem_print(valuesize);
                Symbol *s;
                elem *ti;
                if (ie.modifiable)
                {
                    n1 = el_una(OPaddr, TYnptr, n1);
                    s = aaGetSymbol(taa, "GetY", 1);
                    ti = getTypeInfo(ie.e1.место, taa.unSharedOf().mutableOf(), irs);
                }
                else
                {
                    s = aaGetSymbol(taa, "GetRvalueX", 1);
                    ti = getTypeInfo(ie.e1.место, taa.index, irs);
                }
                //printf("taa.index = %s\n", taa.index.вТкст0());
                //printf("ti:\n"); elem_print(ti);
                elem *ep = el_params(n2, valuesize, ti, n1, null);
                e = el_bin(OPcall, TYnptr, el_var(s), ep);
                if (irs.arrayBoundsCheck())
                {
                    elem *n = el_same(&e);

                    // Construct: ((e || arrayBoundsError), n)
                    auto ea = buildArrayBoundsError(irs, ie.место, null, null, null); // FIXME
                    e = el_bin(OPoror,TYvoid,e,ea);
                    e = el_bin(OPcomma, TYnptr, e, n);
                }
                e = el_una(OPind, totym(ie.тип), e);
                if (tybasic(e.Ety) == TYstruct)
                    e.ET = Type_toCtype(ie.тип);
            }
            else
            {
                elem *einit = resolveLengthVar(ie.lengthVar, &n1, t1);
                elem *n2 = toElem(ie.e2, irs);

                if (irs.arrayBoundsCheck() && !ie.indexIsInBounds)
                {
                    elem *elength;

                    if (auto tsa = t1.isTypeSArray())
                    {
                        const length = tsa.dim.toInteger();

                        elength = el_long(TYт_мера, length);
                        goto L1;
                    }
                    else if (t1.ty == Tarray)
                    {
                        elength = n1;
                        n1 = el_same(&elength);
                        elength = el_una(irs.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, elength);
                    L1:
                        elem *n2x = n2;
                        n2 = el_same(&n2x);
                        n2x = el_bin(OPlt, TYint, n2x, elength);

                        // Construct: (n2x || arrayBoundsError)
                        auto ea = buildArrayBoundsError(irs, ie.место, null, el_copytree(n2), el_copytree(elength));
                        eb = el_bin(OPoror,TYvoid,n2x,ea);
                    }
                }

                n1 = array_toPtr(t1, n1);

                {
                    elem *escale = el_long(TYт_мера, t1.nextOf().size());
                    n2 = el_bin(OPmul, TYт_мера, n2, escale);
                    e = el_bin(OPadd, TYnptr, n1, n2);
                    e = el_una(OPind, totym(ie.тип), e);
                    if (tybasic(e.Ety) == TYstruct || tybasic(e.Ety) == TYarray)
                    {
                        e.Ety = TYstruct;
                        e.ET = Type_toCtype(ie.тип);
                    }
                }

                eb = el_combine(einit, eb);
                e = el_combine(eb, e);
            }
            elem_setLoc(e, ie.место);
            результат = e;
        }


        override проц посети(TupleExp te)
        {
            //printf("TupleExp.toElem() %s\n", te.вТкст0());
            elem *e = null;
            if (te.e0)
                e = toElem(te.e0, irs);
            foreach (el; *te.exps)
            {
                elem *ep = toElem(el, irs);
                e = el_combine(e, ep);
            }
            результат = e;
        }

        static elem *tree_insert(Elems *args, т_мера low, т_мера high)
        {
            assert(low < high);
            if (low + 1 == high)
                return (*args)[low];
            цел mid = cast(цел)((low + high) >> 1);
            return el_param(tree_insert(args, low, mid),
                            tree_insert(args, mid, high));
        }

        override проц посети(ArrayLiteralExp ale)
        {
            т_мера dim = ale.elements ? ale.elements.dim : 0;

            //printf("ArrayLiteralExp.toElem() %s, тип = %s\n", ale.вТкст0(), ale.тип.вТкст0());
            Тип tb = ale.тип.toBasetype();
            if (tb.ty == Tsarray && tb.nextOf().toBasetype().ty == Tvoid)
            {
                // Convert проц[n] to ббайт[n]
                tb = Тип.tuns8.sarrayOf((cast(TypeSArray)tb).dim.toUInteger());
            }

            elem *e;
            if (tb.ty == Tsarray && dim)
            {
                Symbol *stmp = null;
                e = ВыражениеsToStaticArray(ale.место, ale.elements, &stmp, 0, ale.basis);
                e = el_combine(e, el_ptr(stmp));
            }
            else if (ale.elements)
            {
                /* Instead of passing the initializers on the stack, размести the
                 * массив and assign the члены inline.
                 * Avoids the whole variadic arg mess.
                 */

                // call _d_arrayliteralTX(ti, dim)
                e = el_bin(OPcall, TYnptr,
                    el_var(getRtlsym(RTLSYM_ARRAYLITERALTX)),
                    el_param(el_long(TYт_мера, dim), getTypeInfo(ale.место, ale.тип, irs)));
                toTraceGC(irs, e, ale.место);

                Symbol *stmp = symbol_genauto(Type_toCtype(Тип.tvoid.pointerTo()));
                e = el_bin(OPeq, TYnptr, el_var(stmp), e);

                /* Note: Even if dm == 0, the druntime function will be called so
                 * СМ heap may be allocated. However, currently it's implemented
                 * to return null for 0 length.
                 */
                if (dim)
                    e = el_combine(e, ВыражениеsToStaticArray(ale.место, ale.elements, &stmp, 0, ale.basis));

                e = el_combine(e, el_var(stmp));
            }
            else
            {
                e = el_long(TYт_мера, 0);
            }

            if (tb.ty == Tarray)
            {
                e = el_pair(TYdarray, el_long(TYт_мера, dim), e);
            }
            else if (tb.ty == Tpointer)
            {
            }
            else
            {
                e = el_una(OPind, TYstruct, e);
                e.ET = Type_toCtype(ale.тип);
            }

            elem_setLoc(e, ale.место);
            результат = e;
        }

        /**************************************
         * Mirrors logic in Dsymbol_canThrow().
         */
        elem *Dsymbol_toElem(ДСимвол s)
        {
            elem *e = null;

            проц symbolDg(ДСимвол s)
            {
                e = el_combine(e, Dsymbol_toElem(s));
            }

            //printf("Dsymbol_toElem() %s\n", s.вТкст0());
            if (auto vd = s.isVarDeclaration())
            {
                s = s.toAlias();
                if (s != vd)
                    return Dsymbol_toElem(s);
                if (vd.класс_хранения & STC.manifest)
                    return null;
                else if (vd.isStatic() || vd.класс_хранения & (STC.extern_ | STC.tls | STC.gshared))
                    toObjFile(vd, нет);
                else
                {
                    Symbol *sp = toSymbol(s);
                    symbol_add(sp);
                    //printf("\tadding symbol '%s'\n", sp.Sident);
                    if (vd._иниц)
                    {
                        if (auto ie = vd._иниц.isExpInitializer())
                            e = toElem(ie.exp, irs);
                    }

                    /* Mark the point of construction of a variable that needs to be destructed.
                     */
                    if (vd.needsScopeDtor())
                    {
                        elem *edtor = toElem(vd.edtor, irs);
                        elem *ed = null;
                        if (irs.isNothrow())
                        {
                            ed = edtor;
                        }
                        else
                        {
                            // Construct special elems to deal with exceptions
                            e = el_ctor_dtor(e, edtor, &ed);
                        }

                        // ed needs to be inserted into the code later
                        irs.varsInScope.сунь(ed);
                    }
                }
            }
            else if (auto cd = s.isClassDeclaration())
            {
                irs.deferToObj.сунь(s);
            }
            else if (auto sd = s.isStructDeclaration())
            {
                irs.deferToObj.сунь(sd);
            }
            else if (auto fd = s.isFuncDeclaration())
            {
                //printf("function %s\n", fd.вТкст0());
                irs.deferToObj.сунь(fd);
            }
            else if (auto ad = s.isAttribDeclaration())
            {
                ad.include(null).foreachDsymbol(&symbolDg);
            }
            else if (auto tm = s.isTemplateMixin())
            {
                //printf("%s\n", tm.вТкст0());
                tm.члены.foreachDsymbol(&symbolDg);
            }
            else if (auto td = s.isTupleDeclaration())
            {
                foreach (o; *td.objects)
                {
                    if (o.динкаст() == ДИНКАСТ.Выражение)
                    {   Выражение eo = cast(Выражение)o;
                        if (eo.op == ТОК2.dSymbol)
                        {   DsymbolExp se = cast(DsymbolExp)eo;
                            e = el_combine(e, Dsymbol_toElem(se.s));
                        }
                    }
                }
            }
            else if (auto ed = s.isEnumDeclaration())
            {
                irs.deferToObj.сунь(ed);
            }
            else if (auto ti = s.isTemplateInstance())
            {
                irs.deferToObj.сунь(ti);
            }
            return e;
        }

        /*************************************************
         * Allocate a static массив, and initialize its члены with elems[].
         * Return the initialization Выражение, and the symbol for the static массив in *psym.
         */
        elem *ElemsToStaticArray(ref Место место, Тип telem, Elems *elems, Symbol **psym)
        {
            // Create a static массив of тип telem[dim]
            const dim = elems.dim;
            assert(dim);

            Тип tsarray = telem.sarrayOf(dim);
            const szelem = telem.size();
            .тип *te = Type_toCtype(telem);   // stmp[] element тип

            Symbol *stmp = symbol_genauto(Type_toCtype(tsarray));
            *psym = stmp;

            elem *e = null;
            foreach (i, ep; *elems)
            {
                /* Generate: *(&stmp + i * szelem) = element[i]
                 */
                elem *ev = el_ptr(stmp);
                ev = el_bin(OPadd, TYnptr, ev, el_long(TYт_мера, i * szelem));
                ev = el_una(OPind, te.Tty, ev);
                elem *eeq = elAssign(ev, ep, null, te);
                e = el_combine(e, eeq);
            }
            return e;
        }

        /*************************************************
         * Allocate a static массив, and initialize its члены with
         * exps[].
         * Return the initialization Выражение, and the symbol for the static массив in *psym.
         */
        elem *ВыражениеsToStaticArray(ref Место место, Выражения *exps, Symbol **psym, т_мера смещение = 0, Выражение basis = null)
        {
            // Create a static массив of тип telem[dim]
            const dim = exps.dim;
            assert(dim);

            Тип telem = ((*exps)[0] ? (*exps)[0] : basis).тип;
            const szelem = telem.size();
            .тип *te = Type_toCtype(telem);   // stmp[] element тип

            if (!*psym)
            {
                Тип tsarray2 = telem.sarrayOf(dim);
                *psym = symbol_genauto(Type_toCtype(tsarray2));
                смещение = 0;
            }
            Symbol *stmp = *psym;

            elem *e = null;
            for (т_мера i = 0; i < dim; )
            {
                Выражение el = (*exps)[i];
                if (!el)
                    el = basis;
                if (el.op == ТОК2.arrayLiteral &&
                    el.тип.toBasetype().ty == Tsarray)
                {
                    ArrayLiteralExp ale = cast(ArrayLiteralExp)el;
                    if (ale.elements && ale.elements.dim)
                    {
                        elem *ex = ВыражениеsToStaticArray(
                            ale.место, ale.elements, &stmp, cast(бцел)(смещение + i * szelem), ale.basis);
                        e = el_combine(e, ex);
                    }
                    i++;
                    continue;
                }

                т_мера j = i + 1;
                if (el.isConst() || el.op == ТОК2.null_)
                {
                    // If the trivial elements are same values, do memcpy.
                    while (j < dim)
                    {
                        Выражение en = (*exps)[j];
                        if (!en)
                            en = basis;
                        if (!el.равен(en))
                            break;
                        j++;
                    }
                }

                /* Generate: *(&stmp + i * szelem) = element[i]
                 */
                elem *ep = toElem(el, irs);
                elem *ev = tybasic(stmp.Stype.Tty) == TYnptr ? el_var(stmp) : el_ptr(stmp);
                ev = el_bin(OPadd, TYnptr, ev, el_long(TYт_мера, смещение + i * szelem));

                elem *eeq;
                if (j == i + 1)
                {
                    ev = el_una(OPind, te.Tty, ev);
                    eeq = elAssign(ev, ep, null, te);
                }
                else
                {
                    elem *edim = el_long(TYт_мера, j - i);
                    eeq = setArray(el, ev, edim, telem, ep, irs, ТОК2.blit);
                }
                e = el_combine(e, eeq);
                i = j;
            }
            return e;
        }

        override проц посети(AssocArrayLiteralExp aale)
        {
            //printf("AssocArrayLiteralExp.toElem() %s\n", aale.вТкст0());

            Тип t = aale.тип.toBasetype().mutableOf();

            т_мера dim = aale.keys.dim;
            if (dim)
            {
                // call _d_assocarrayliteralTX(TypeInfo_AssociativeArray ti, проц[] keys, проц[] values)
                // Prefer this to avoid the varargs fiasco in 64 bit code

                assert(t.ty == Taarray);
                Тип ta = t;

                Symbol *skeys = null;
                elem *ekeys = ВыражениеsToStaticArray(aale.место, aale.keys, &skeys);

                Symbol *svalues = null;
                elem *evalues = ВыражениеsToStaticArray(aale.место, aale.values, &svalues);

                elem *ev = el_pair(TYdarray, el_long(TYт_мера, dim), el_ptr(svalues));
                elem *ek = el_pair(TYdarray, el_long(TYт_мера, dim), el_ptr(skeys  ));
                if (config.exe == EX_WIN64)
                {
                    ev = addressElem(ev, Тип.tvoid.arrayOf());
                    ek = addressElem(ek, Тип.tvoid.arrayOf());
                }
                elem *e = el_params(ev, ek,
                                    getTypeInfo(aale.место, ta, irs),
                                    null);

                // call _d_assocarrayliteralTX(ti, keys, values)
                e = el_bin(OPcall,TYnptr,el_var(getRtlsym(RTLSYM_ASSOCARRAYLITERALTX)),e);
                toTraceGC(irs, e, aale.место);
                if (t != ta)
                    e = addressElem(e, ta);
                elem_setLoc(e, aale.место);

                e = el_combine(evalues, e);
                e = el_combine(ekeys, e);
                результат = e;
                return;
            }
            else
            {
                elem *e = el_long(TYnptr, 0);      // empty associative массив is the null pointer
                if (t.ty != Taarray)
                    e = addressElem(e, Тип.tvoidptr);
                результат = e;
                return;
            }
        }

        override проц посети(StructLiteralExp sle)
        {
            //printf("[%s] StructLiteralExp.toElem() %s\n", sle.место.вТкст0(), sle.вТкст0());
            результат = toElemStructLit(sle, irs, ТОК2.construct, sle.sym, да);
        }

        override проц посети(ObjcClassReferenceExp e)
        {
            результат = objc.toElem(e);
        }

        /*****************************************************/
        /*                   CTFE stuff                      */
        /*****************************************************/

        override проц посети(ClassReferenceExp e)
        {
            //printf("ClassReferenceExp.toElem() %p, значение=%p, %s\n", e, e.значение, e.вТкст0());
            результат = el_ptr(toSymbol(e));
        }
    }

    scope v = new ToElemVisitor(irs);
    e.прими(v);
    return v.результат;
}

/*******************************************
 * Generate elem to нуль fill contents of Symbol stmp
 * from *poffset..offset2.
 * May store anywhere from 0..maxoff, as this function
 * tries to use aligned цел stores whereever possible.
 * Update *poffset to end of initialized hole; *poffset will be >= offset2.
 */
private elem *fillHole(Symbol *stmp, т_мера *poffset, т_мера offset2, т_мера maxoff)
{
    elem *e = null;
    бул basealign = да;

    while (*poffset < offset2)
    {
        elem *e1;
        if (tybasic(stmp.Stype.Tty) == TYnptr)
            e1 = el_var(stmp);
        else
            e1 = el_ptr(stmp);
        if (basealign)
            *poffset &= ~3;
        basealign = да;
        т_мера sz = maxoff - *poffset;
        tym_t ty;
        switch (sz)
        {
            case 1: ty = TYchar;        break;
            case 2: ty = TYshort;       break;
            case 3:
                ty = TYshort;
                basealign = нет;
                break;
            default:
                ty = TYlong;
                // TODO: OPmemset is better if sz is much bigger than 4?
                break;
        }
        e1 = el_bin(OPadd, TYnptr, e1, el_long(TYт_мера, *poffset));
        e1 = el_una(OPind, ty, e1);
        e1 = el_bin(OPeq, ty, e1, el_long(ty, 0));
        e = el_combine(e, e1);
        *poffset += tysize(ty);
    }
    return e;
}

/*************************************************
 * Параметры:
 *      op = ТОК2.assign, ТОК2.construct, ТОК2.blit
 *      fillHoles = Fill in alignment holes with нуль. Set to
 *                  нет if allocated by operator new, as the holes are already zeroed.
 */

private elem *toElemStructLit(StructLiteralExp sle, IRState *irs, ТОК2 op, Symbol *sym, бул fillHoles)
{
    //printf("[%s] StructLiteralExp.toElem() %s\n", sle.место.вТкст0(), sle.вТкст0());
    //printf("\tblit = %s, sym = %p fillHoles = %d\n", op == ТОК2.blit, sym, fillHoles);

    if (sle.useStaticInit)
    {
        /* Use the struct declaration's init symbol
         */
        elem *e = el_var(toInitializer(sle.sd));
        e.ET = Type_toCtype(sle.sd.тип);
        elem_setLoc(e, sle.место);

        if (sym)
        {
            elem *ev = el_var(sym);
            if (tybasic(ev.Ety) == TYnptr)
                ev = el_una(OPind, e.Ety, ev);
            ev.ET = e.ET;
            e = elAssign(ev, e, null, ev.ET);

            //ev = el_var(sym);
            //ev.ET = e.ET;
            //e = el_combine(e, ev);
            elem_setLoc(e, sle.место);
        }
        return e;
    }

    // struct symbol to initialize with the literal
    Symbol *stmp = sym ? sym : symbol_genauto(Type_toCtype(sle.sd.тип));

    elem *e = null;

    /* If a field has explicit инициализатор (*sle.elements)[i] != null),
     * any other overlapped fields won't have инициализатор. It's asserted by
     * StructDeclaration.fill() function.
     *
     *  union U { цел x; long y; }
     *  U u1 = U(1);        // elements = [`1`, null]
     *  U u2 = {y:2};       // elements = [null, `2`];
     *  U u3 = U(1, 2);     // error
     *  U u4 = {x:1, y:2};  // error
     */
    т_мера dim = sle.elements ? sle.elements.dim : 0;
    assert(dim <= sle.sd.fields.dim);

    if (fillHoles)
    {
        /* Initialize all alignment 'holes' to нуль.
         * Do before initializing fields, as the hole filling process
         * can spill over into the fields.
         */
        const т_мера structsize = sle.sd.structsize;
        т_мера смещение = 0;
        //printf("-- %s - fillHoles, structsize = %d\n", sle.вТкст0(), structsize);
        for (т_мера i = 0; i < sle.sd.fields.dim && смещение < structsize; )
        {
            VarDeclaration v = sle.sd.fields[i];

            /* If the field v has explicit инициализатор, [смещение .. v.смещение]
             * is a hole divided by the инициализатор.
             * However if the field size is нуль (e.g. цел[0] v;), we can merge
             * the two holes in the front and the back of the field v.
             */
            if (i < dim && (*sle.elements)[i] && v.тип.size())
            {
                //if (смещение != v.смещение) printf("  1 fillHole, %d .. %d\n", смещение, v.смещение);
                e = el_combine(e, fillHole(stmp, &смещение, v.смещение, structsize));
                смещение = cast(бцел)(v.смещение + v.тип.size());
                i++;
                continue;
            }
            if (!v.overlapped)
            {
                i++;
                continue;
            }

            /* AggregateDeclaration.fields holds the fields by the lexical order.
             * This code will minimize each hole sizes. For example:
             *
             *  struct S {
             *    union { бцел f1; ushort f2; }   // f1: 0..4,  f2: 0..2
             *    union { бцел f3; бдол f4; }    // f3: 8..12, f4: 8..16
             *  }
             *  S s = {f2:x, f3:y};     // filled holes: 2..8 and 12..16
             */
            т_мера vend = sle.sd.fields.dim;
            т_мера holeEnd = structsize;
            т_мера offset2 = structsize;
            foreach (j; new бцел[i + 1 .. vend])
            {
                VarDeclaration vx = sle.sd.fields[j];
                if (!vx.overlapped)
                {
                    vend = j;
                    break;
                }
                if (j < dim && (*sle.elements)[j] && vx.тип.size())
                {
                    // Find the lowest end смещение of the hole.
                    if (смещение <= vx.смещение && vx.смещение < holeEnd)
                    {
                        holeEnd = vx.смещение;
                        offset2 = cast(бцел)(vx.смещение + vx.тип.size());
                    }
                }
            }
            if (holeEnd < structsize)
            {
                //if (смещение != holeEnd) printf("  2 fillHole, %d .. %d\n", смещение, holeEnd);
                e = el_combine(e, fillHole(stmp, &смещение, holeEnd, structsize));
                смещение = offset2;
                continue;
            }
            i = vend;
        }
        //if (смещение != sle.sd.structsize) printf("  3 fillHole, %d .. %d\n", смещение, sle.sd.structsize);
        e = el_combine(e, fillHole(stmp, &смещение, sle.sd.structsize, sle.sd.structsize));
    }

    // CTFE may fill the hidden pointer by NullExp.
    {
        foreach (i, el; *sle.elements)
        {
            if (!el)
                continue;

            VarDeclaration v = sle.sd.fields[i];
            assert(!v.isThisDeclaration() || el.op == ТОК2.null_);

            elem *e1;
            if (tybasic(stmp.Stype.Tty) == TYnptr)
            {
                e1 = el_var(stmp);
            }
            else
            {
                e1 = el_ptr(stmp);
            }
            e1 = el_bin(OPadd, TYnptr, e1, el_long(TYт_мера, v.смещение));

            elem *ep = toElem(el, irs);

            Тип t1b = v.тип.toBasetype();
            Тип t2b = el.тип.toBasetype();
            if (t1b.ty == Tsarray)
            {
                if (t2b.implicitConvTo(t1b))
                {
                    elem *esize = el_long(TYт_мера, t1b.size());
                    ep = array_toPtr(el.тип, ep);
                    e1 = el_bin(OPmemcpy, TYnptr, e1, el_param(ep, esize));
                }
                else
                {
                    elem *edim = el_long(TYт_мера, t1b.size() / t2b.size());
                    e1 = setArray(el, e1, edim, t2b, ep, irs, op == ТОК2.construct ? ТОК2.blit : op);
                }
            }
            else
            {
                tym_t ty = totym(v.тип);
                e1 = el_una(OPind, ty, e1);
                if (tybasic(ty) == TYstruct)
                    e1.ET = Type_toCtype(v.тип);
                e1 = elAssign(e1, ep, v.тип, e1.ET);
            }
            e = el_combine(e, e1);
        }
    }

    if (sle.sd.isNested() && dim != sle.sd.fields.dim)
    {
        // Initialize the hidden 'this' pointer
        assert(sle.sd.fields.dim);

        elem* e1, e2;
        if (tybasic(stmp.Stype.Tty) == TYnptr)
        {
            e1 = el_var(stmp);
        }
        else
        {
            e1 = el_ptr(stmp);
        }
        if (sle.sd.vthis2)
        {
            /* Initialize sd.vthis2:
             *  *(e2 + sd.vthis2.смещение) = this1;
             */
            e2 = el_copytree(e1);
            e2 = setEthis(sle.место, irs, e2, sle.sd, да);
        }
        /* Initialize sd.vthis:
         *  *(e1 + sd.vthis.смещение) = this;
         */
        e1 = setEthis(sle.место, irs, e1, sle.sd);

        e = el_combine(e, e1);
        e = el_combine(e, e2);
    }

    elem *ev = el_var(stmp);
    ev.ET = Type_toCtype(sle.sd.тип);
    e = el_combine(e, ev);
    elem_setLoc(e, sle.место);
    return e;
}

/********************************************
 * Append destructors for varsInScope[starti..endi] to er.
 * Параметры:
 *      irs = context
 *      er = elem to приставь destructors to
 *      starti = starting index in varsInScope[]
 *      endi = ending index in varsInScope[]
 * Возвращает:
 *      er with destructors appended
 */

private elem *appendDtors(IRState *irs, elem *er, т_мера starti, т_мера endi)
{
    //printf("appendDtors(%d .. %d)\n", starti, endi);

    /* Code gen can be improved by determining if no exceptions can be thrown
     * between the OPdctor and OPddtor, and eliminating the OPdctor and OPddtor.
     */

    /* Build edtors, an Выражение that calls destructors on all the variables
     * going out of the scope starti..endi
     */
    elem *edtors = null;
    foreach (i; new бцел[starti .. endi])
    {
        elem *ed = (*irs.varsInScope)[i];
        if (ed)                                 // if not skipped
        {
            //printf("appending dtor\n");
            (*irs.varsInScope)[i] = null;       // so these are skipped by outer scopes
            edtors = el_combine(ed, edtors);    // execute in reverse order
        }
    }

    if (edtors)
    {
        if (irs.парамы.isWindows && !irs.парамы.is64bit) // Win32
        {
            Blockx *blx = irs.blx;
            nteh_declarvars(blx);
        }

        /* Append edtors to er, while preserving the значение of er
         */
        if (tybasic(er.Ety) == TYvoid)
        {
            /* No значение to preserve, so simply приставь
             */
            er = el_combine(er, edtors);
        }
        else
        {
            elem **pe;
            for (pe = &er; (*pe).Eoper == OPcomma; pe = &(*pe).EV.E2)
            {
            }
            elem *erx = *pe;

            if (erx.Eoper == OPconst || erx.Eoper == OPrelconst)
            {
                *pe = el_combine(edtors, erx);
            }
            else if (elemIsLvalue(erx))
            {
                /* Lvalue, take a pointer to it
                 */
                elem *ep = el_una(OPaddr, TYnptr, erx);
                elem *e = el_same(&ep);
                ep = el_combine(ep, edtors);
                ep = el_combine(ep, e);
                e = el_una(OPind, erx.Ety, ep);
                e.ET = erx.ET;
                *pe = e;
            }
            else
            {
                elem *e = el_same(&erx);
                erx = el_combine(erx, edtors);
                *pe = el_combine(erx, e);
            }
        }
    }
    return er;
}


/*******************************************
 * Convert Выражение to elem, then приставь destructors for any
 * temporaries created in elem.
 * Параметры:
 *      e = Выражение to convert
 *      irs = context
 * Возвращает:
 *      generated elem tree
 */

elem *toElemDtor(Выражение e, IRState *irs)
{
    //printf("Выражение.toElemDtor() %s\n", e.вТкст0());

    /* "may" throw may actually be нет if we look at a subset of
     * the function. Here, the subset is `e`. If that subset is ,
     * we can generate much better code for the destructors for that subset,
     * even if the rest of the function throws.
     * If mayThrow is нет, it cannot be да for some subset of the function,
     * so no need to check.
     * If calling canThrow() here turns out to be too expensive,
     * it can be enabled only for optimized builds.
     */
    const mayThrowSave = irs.mayThrow;
    if (irs.mayThrow && !canThrow(e, irs.getFunc(), нет))
        irs.mayThrow = нет;

    const starti = irs.varsInScope.dim;
    elem* er = toElem(e, irs);
    const endi = irs.varsInScope.dim;

    irs.mayThrow = mayThrowSave;

    // Add destructors
    elem* ex = appendDtors(irs, er, starti, endi);
    return ex;
}


/*******************************************************
 * Write читай-only ткст to объект файл, создай a local symbol for it.
 * Makes a копируй of str's contents, does not keep a reference to it.
 * Параметры:
 *      str = ткст
 *      len = number of code units in ткст
 *      sz = number of bytes per code unit
 * Возвращает:
 *      Symbol
 */

Symbol *вТкстSymbol(ткст0 str, т_мера len, т_мера sz)
{
    //printf("вТкстSymbol() %p\n", stringTab);
    auto sv = stringTab.update(str, len * sz);
    if (!sv.значение)
    {
        Symbol* si;

        if (глоб2.парамы.isWindows)
        {
            /* This should be in the back end, but mangleToBuffer() is
             * in the front end.
             */
            /* The stringTab pools common strings within an объект файл.
             * Win32 and Win64 use COMDATs to pool common strings across объект files.
             */

            scope StringExp se = new StringExp(Место.initial, str[0 .. len], len, cast(ббайт)sz, 'c');

            /* VC++ uses a имя mangling scheme, for example, "hello" is mangled to:
             * ??_C@_05CJBACGMB@hello?$AA@
             *        ^ length
             *         ^^^^^^^^ 8 byte checksum
             * But the checksum algorithm is unknown. Just invent our own.
             */
            БуфВыв буф;
            буф.пишиСтр("__");
            mangleToBuffer(se, &буф);   // recycle how strings are mangled for templates

            if (буф.length >= 32 + 2)
            {   // Replace long ткст with хэш of that ткст
                MD5_CTX mdContext = проц;
                MD5Init(&mdContext);
                MD5Update(&mdContext, cast(ббайт*)буф.peekChars(), cast(бцел)буф.length);
                MD5Final(&mdContext);
                буф.устРазм(2);
                foreach (u; mdContext.digest)
                {
                    ббайт u1 = u >> 4;
                    буф.пишиБайт((u1 < 10) ? u1 + '0' : u1 + 'A' - 10);
                    u1 = u & 0xF;
                    буф.пишиБайт((u1 < 10) ? u1 + '0' : u1 + 'A' - 10);
                }
            }

            si = symbol_calloc(буф.peekChars(), cast(бцел)буф.length);
            si.Sclass = SCcomdat;
            si.Stype = type_static_array(cast(бцел)(len * sz), tstypes[TYchar]);
            si.Stype.Tcount++;
            type_setmangle(&si.Stype, mTYman_c);
            si.Sflags |= SFLnodebug | SFLartifical;
            si.Sfl = FLdata;
            si.Salignment = cast(ббайт)sz;
            out_readonly_comdat(si, str, cast(бцел)(len * sz), cast(бцел)sz);
        }
        else
        {
            si = out_string_literal(str, cast(бцел)len, cast(бцел)sz);
        }

        sv.значение = si;
    }
    return sv.значение;
}

/*******************************************************
 * Turn StringExp into Symbol.
 */

Symbol *вТкстSymbol(StringExp se)
{
    Symbol *si;
    const n = cast(цел)se.numberOfCodeUnits();
    if (se.sz == 1)
    {
        const slice = se.peekString();
        si = вТкстSymbol(slice.ptr, slice.length, 1);
    }
    else
    {
        auto p = cast(сим *)mem.xmalloc(n * se.sz);
        se.writeTo(p, нет);
        si = вТкстSymbol(p, n, se.sz);
        mem.xfree(p);
    }
    return si;
}

/******************************************************
 * Return an elem that is the файл, line, and function suitable
 * for insertion into the параметр list.
 */

private elem *filelinefunction(IRState *irs, ref Место место)
{
    ткст0 ид = место.имяф;
    т_мера len = strlen(ид);
    Symbol *si = вТкстSymbol(ид, len, 1);
    elem *efilename = el_pair(TYdarray, el_long(TYт_мера, len), el_ptr(si));
    if (config.exe == EX_WIN64)
        efilename = addressElem(efilename, Тип.tstring, да);

    elem *elinnum = el_long(TYint, место.номстр);

    ткст0 s = "";
    FuncDeclaration fd = irs.getFunc();
    if (fd)
    {
        s = fd.toPrettyChars();
    }

    len = strlen(s);
    si = вТкстSymbol(s, len, 1);
    elem *efunction = el_pair(TYdarray, el_long(TYт_мера, len), el_ptr(si));
    if (config.exe == EX_WIN64)
        efunction = addressElem(efunction, Тип.tstring, да);

    return el_params(efunction, elinnum, efilename, null);
}

/******************************************************
 * Construct elem to run when an массив bounds check fails.
 * Параметры:
 *      irs = to get function from
 *      место = to get файл/line from
 *      lwr = lower bound passed, if slice (массив[lwr .. upr]). null otherwise.
 *      upr = upper bound passed if slice (массив[lwr .. upr]), index if not a slice (массив[upr])
 *      elength = length of массив
 * Возвращает:
 *      elem generated
 */
elem *buildArrayBoundsError(IRState *irs, ref Место место, elem* lwr, elem* upr, elem* elength)
{
    if (irs.парамы.checkAction == CHECKACTION.C)
    {
        return callCAssert(irs, место, null, null, "массив overflow");
    }
    if (irs.парамы.checkAction == CHECKACTION.halt)
    {
        return genHalt(место);
    }
    auto eassert = el_var(getRtlsym(RTLSYM_DARRAYP));
    auto efile = toEfilenamePtr(cast(Module)irs.blx._module);
    auto eline = el_long(TYint, место.номстр);
    if(upr is null)
    {
        upr = el_long(TYт_мера, 0);
    }
    if(lwr is null)
    {
        lwr = el_long(TYт_мера, 0);
    }
    if(elength is null)
    {
        elength = el_long(TYт_мера, 0);
    }
    return el_bin(OPcall, TYvoid, eassert, el_params(elength, upr, lwr, eline, efile, null));
}

/******************************************************
 * Replace call to СМ allocator with call to tracing СМ allocator.
 * Параметры:
 *      irs = to get function from
 *      e = elem to modify in place
 *      место = to get файл/line from
 */

проц toTraceGC(IRState *irs, elem *e, ref Место место)
{
    static const цел[2][25] map =
    [
        [ RTLSYM_NEWCLASS, RTLSYM_TRACENEWCLASS ],
        [ RTLSYM_NEWITEMT, RTLSYM_TRACENEWITEMT ],
        [ RTLSYM_NEWITEMIT, RTLSYM_TRACENEWITEMIT ],
        [ RTLSYM_NEWARRAYT, RTLSYM_TRACENEWARRAYT ],
        [ RTLSYM_NEWARRAYIT, RTLSYM_TRACENEWARRAYIT ],
        [ RTLSYM_NEWARRAYMTX, RTLSYM_TRACENEWARRAYMTX ],
        [ RTLSYM_NEWARRAYMITX, RTLSYM_TRACENEWARRAYMITX ],

        [ RTLSYM_DELCLASS, RTLSYM_TRACEDELCLASS ],
        [ RTLSYM_CALLFINALIZER, RTLSYM_TRACECALLFINALIZER ],
        [ RTLSYM_CALLINTERFACEFINALIZER, RTLSYM_TRACECALLINTERFACEFINALIZER ],
        [ RTLSYM_DELINTERFACE, RTLSYM_TRACEDELINTERFACE ],
        [ RTLSYM_DELARRAYT, RTLSYM_TRACEDELARRAYT ],
        [ RTLSYM_DELMEMORY, RTLSYM_TRACEDELMEMORY ],
        [ RTLSYM_DELSTRUCT, RTLSYM_TRACEDELSTRUCT ],

        [ RTLSYM_ARRAYLITERALTX, RTLSYM_TRACEARRAYLITERALTX ],
        [ RTLSYM_ASSOCARRAYLITERALTX, RTLSYM_TRACEASSOCARRAYLITERALTX ],

        [ RTLSYM_ARRAYCATT, RTLSYM_TRACEARRAYCATT ],
        [ RTLSYM_ARRAYCATNTX, RTLSYM_TRACEARRAYCATNTX ],

        [ RTLSYM_ARRAYAPPENDCD, RTLSYM_TRACEARRAYAPPENDCD ],
        [ RTLSYM_ARRAYAPPENDWD, RTLSYM_TRACEARRAYAPPENDWD ],
        [ RTLSYM_ARRAYAPPENDT, RTLSYM_TRACEARRAYAPPENDT ],
        [ RTLSYM_ARRAYAPPENDCTX, RTLSYM_TRACEARRAYAPPENDCTX ],

        [ RTLSYM_ARRAYSETLENGTHT, RTLSYM_TRACEARRAYSETLENGTHT ],
        [ RTLSYM_ARRAYSETLENGTHIT, RTLSYM_TRACEARRAYSETLENGTHIT ],

        [ RTLSYM_ALLOCMEMORY, RTLSYM_TRACEALLOCMEMORY ],
    ];

    if (irs.парамы.tracegc && место.имяф)
    {
        assert(e.Eoper == OPcall);
        elem *e1 = e.EV.E1;
        assert(e1.Eoper == OPvar);

        auto s = e1.EV.Vsym;
        /* In -dip1008 code the allocation of exceptions is no longer done by the
         * gc, but by a manual reference counting mechanism implementend in druntime.
         * If that is the case, then there is nothing to trace.
         */
        if (s == getRtlsym(RTLSYM_NEWTHROW))
            return;
        foreach (ref m; map)
        {
            if (s == getRtlsym(m[0]))
            {
                e1.EV.Vsym = getRtlsym(m[1]);
                e.EV.E2 = el_param(e.EV.E2, filelinefunction(irs, место));
                return;
            }
        }
        assert(0);
    }
}


/****************************************
 * Generate call to C's assert failure function.
 * One of exp, emsg, or str must not be null.
 * Параметры:
 *      irs = context
 *      место = location to use for assert message
 *      exp = if not null Выражение to test (not evaluated, but converted to a ткст)
 *      emsg = if not null then informative message to be computed at run time
 *      str = if not null then informative message ткст
 * Возвращает:
 *      generated call
 */
elem *callCAssert(IRState *irs, ref Место место, Выражение exp, Выражение emsg, ткст0 str)
{
    //printf("callCAssert.toElem() %s\n", e.вТкст0());
    Module m = cast(Module)irs.blx._module;
    ткст0 mname = m.srcfile.вТкст0();

    elem* getFuncName()
    {
        ткст0 ид = "";
        FuncDeclaration fd = irs.getFunc();
        if (fd)
            ид = fd.toPrettyChars();
        const len = strlen(ид);
        Symbol *si = вТкстSymbol(ид, len, 1);
        return el_ptr(si);
    }

    //printf("имяф = '%s'\n", место.имяф);
    //printf("module = '%s'\n", mname);

    /* If the source файл имя has changed, probably due
     * to a #line directive.
     */
    elem *efilename;
    if (место.имяф && strcmp(место.имяф, mname) != 0)
    {
        ткст0 ид = место.имяф;
        т_мера len = strlen(ид);
        Symbol *si = вТкстSymbol(ид, len, 1);
        efilename = el_ptr(si);
    }
    else
    {
        efilename = toEfilenamePtr(m);
    }

    elem *elmsg;
    if (emsg)
    {
        // Assuming here that emsg generates a 0 terminated ткст
        auto e = toElemDtor(emsg, irs);
        elmsg = array_toPtr(Тип.tvoid.arrayOf(), e);
    }
    else if (exp)
    {
        // Generate a message out of the assert Выражение
        ткст0 ид = exp.вТкст0();
        const len = strlen(ид);
        Symbol *si = вТкстSymbol(ид, len, 1);
        elmsg = el_ptr(si);
    }
    else
    {
        assert(str);
        const len = strlen(str);
        Symbol *si = вТкстSymbol(str, len, 1);
        elmsg = el_ptr(si);
    }

    auto eline = el_long(TYint, место.номстр);

    elem *ea;
    if (irs.парамы.isOSX)
    {
        // __assert_rtn(func, файл, line, msg);
        elem* efunc = getFuncName();
        auto eassert = el_var(getRtlsym(RTLSYM_C__ASSERT_RTN));
        ea = el_bin(OPcall, TYvoid, eassert, el_params(elmsg, eline, efilename, efunc, null));
    }
    else
    {
        version (CRuntime_Musl)
        {
            // __assert_fail(exp, файл, line, func);
            elem* efunc = getFuncName();
            auto eassert = el_var(getRtlsym(RTLSYM_C__ASSERT_FAIL));
            ea = el_bin(OPcall, TYvoid, eassert, el_params(elmsg, efilename, eline, efunc, null));
        }
        else
        {
            // [_]_assert(msg, файл, line);
            const rtlsym = (irs.парамы.isWindows) ? RTLSYM_C_ASSERT : RTLSYM_C__ASSERT;
            auto eassert = el_var(getRtlsym(rtlsym));
            ea = el_bin(OPcall, TYvoid, eassert, el_params(eline, efilename, elmsg, null));
        }
    }
    return ea;
}

/********************************************
 * Generate HALT instruction.
 * Параметры:
 *      место = location to use for debug info
 * Возвращает:
 *      generated instruction
 */
elem *genHalt(ref Место место)
{
    elem *e = el_calloc();
    e.Ety = TYvoid;
    e.Eoper = OPhalt;
    elem_setLoc(e, место);
    return e;
}

/*************************************************
 * Determine if нуль bits need to be copied for this backend тип
 * Параметры:
 *      t = backend тип
 * Возвращает:
 *      да if 0 bits
 */
бул type_zeroCopy(тип* t)
{
    return type_size(t) == 0 ||
        (tybasic(t.Tty) == TYstruct &&
         (t.Ttag.Stype.Ttag.Sstruct.Sflags & STR0size));
}

/**************************************************
 * Generate a копируй from e2 to e1.
 * Параметры:
 *      e1 = lvalue
 *      e2 = rvalue
 *      t = значение тип
 *      tx = if !null, then t converted to C тип
 * Возвращает:
 *      generated elem
 */
elem* elAssign(elem* e1, elem* e2, Тип t, тип* tx)
{
    elem *e = el_bin(OPeq, e2.Ety, e1, e2);
    switch (tybasic(e2.Ety))
    {
        case TYarray:
            e.Ejty = e.Ety = TYstruct;
            goto case TYstruct;

        case TYstruct:
            e.Eoper = OPstreq;
            if (!tx)
                tx = Type_toCtype(t);
            e.ET = tx;
//            if (type_zeroCopy(tx))
//                e.Eoper = OPcomma;
            break;

        default:
            break;
    }
    return e;
}

/**************************************************
 * Initialize the dual-context массив with the context pointers.
 * Параметры:
 *      место = line and файл of what line to show использование for
 *      irs = current context to get the second context from
 *      fd = the target function
 *      ethis2 = dual-context массив
 *      ethis = the first context
 *      eside = where to store the assignment Выражения
 * Возвращает:
 *      `ethis2` if successful, null otherwise
 */
elem* setEthis2(ref Место место, IRState* irs, FuncDeclaration fd, elem* ethis2, elem** ethis, elem** eside)
{
    if (!fd.isThis2)
        return null;

    assert(ethis2 && ethis && *ethis);

    elem* ectx0 = el_una(OPind, (*ethis).Ety, el_copytree(ethis2));
    elem* eeq0 = el_bin(OPeq, (*ethis).Ety, ectx0, *ethis);
    *ethis = el_copytree(ectx0);
    *eside = el_combine(eeq0, *eside);

    elem* ethis1 = getEthis(место, irs, fd, fd.toParent2());
    elem* ectx1 = el_bin(OPadd, TYnptr, el_copytree(ethis2), el_long(TYт_мера, tysize(TYnptr)));
    ectx1 = el_una(OPind, TYnptr, ectx1);
    elem* eeq1 = el_bin(OPeq, ethis1.Ety, ectx1, ethis1);
    *eside = el_combine(eeq1, *eside);

    return ethis2;
}
