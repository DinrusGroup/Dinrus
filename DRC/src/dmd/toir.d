/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/_tocsym.d, _toir.d)
 * Documentation:  https://dlang.org/phobos/dmd_toir.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/toir.d
 */

module dmd.toir;

import cidrus;

import util.array;
import util.outbuffer;
import util.rmem;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.dt;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.oper;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.dclass;
import dmd.declaration;
import dmd.dmangle;
import dmd.dmodule;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.toctype;
import dmd.e2ir;
import dmd.func;
import dmd.globals;
import dmd.glue;
import drc.lexer.Identifier;
import drc.lexer.Id;
import dmd.irstate;
import dmd.mtype;
import dmd.target;
import dmd.tocvdebug;
import dmd.tocsym;

alias  dmd.tocsym.toSymbol toSymbol;
alias  dmd.glue.toSymbol toSymbol;


/*extern (C++):*/

/*********************************************
 * Produce elem which increments the использование count for a particular line.
 * Sets corresponding bit in bitmap `m.covb[номстр]`.
 * Used to implement -cov switch (coverage analysis).
 * Параметры:
 *      irs = context
 *      место = line and файл of what line to show использование for
 * Возвращает:
 *      elem that increments the line count
 * References:
 * https://dlang.org/dmd-windows.html#switch-cov
 */
extern (D) elem *incUsageElem(IRState *irs, ref Место место)
{
    бцел номстр = место.номстр;

    Module m = cast(Module)irs.blx._module;
    if (!m.cov || !номстр ||
        место.имяф != m.srcfile.вТкст0())
        return null;

    //printf("cov = %p, covb = %p, номстр = %u\n", m.cov, m.covb, p, номстр);

    номстр--;           // from 1-based to 0-based

    /* Set bit in covb[] indicating this is a valid code line number
     */
    бцел *p = m.covb;
    if (p)      // covb can be null if it has already been written out to its .obj файл
    {
        assert(номстр < m.numlines);
        p += номстр / ((*p).sizeof * 8);
        *p |= 1 << (номстр & ((*p).sizeof * 8 - 1));
    }

    /* Generate: *(m.cov + номстр * 4) += 1
     */
    elem *e;
    e = el_ptr(m.cov);
    e = el_bin(OPadd, TYnptr, e, el_long(TYuint, номстр * 4));
    e = el_una(OPind, TYuint, e);
    e = el_bin(OPaddass, TYuint, e, el_long(TYuint, 1));
    return e;
}

/******************************************
 * Return elem that evaluates to the static frame pointer for function fd.
 * If fd is a member function, the returned Выражение will compute the значение
 * of fd's 'this' variable.
 * 'fdp' is the родитель of 'fd' if the frame pointer is being используется to call 'fd'.
 * 'origSc' is the original scope we inlined from.
 * This routine is critical for implementing nested functions.
 */
elem *getEthis(ref Место место, IRState *irs, ДСимвол fd, ДСимвол fdp = null, ДСимвол origSc = null)
{
    elem *ethis;
    FuncDeclaration thisfd = irs.getFunc();
    ДСимвол ctxt0 = fdp ? fdp : fd;                     // follow either of these two
    ДСимвол ctxt1 = origSc ? origSc.toParent2() : null; // contexts from template arguments
    if (!fdp) fdp = fd.toParent2();
    ДСимвол fdparent = fdp;

    /* These two are compiler generated functions for the in and out contracts,
     * and are called from an overriding function, not just the one they're
     * nested inside, so this hack sets fdparent so it'll pass
     */
    if (fdparent != thisfd && (fd.идент == Id.require || fd.идент == Id.ensure))
    {
        FuncDeclaration fdthis = thisfd;
        for (т_мера i = 0; ; )
        {
            if (i == fdthis.foverrides.dim)
            {
                if (i == 0)
                    break;
                fdthis = fdthis.foverrides[0];
                i = 0;
                continue;
            }
            if (fdthis.foverrides[i] == fdp)
            {
                fdparent = thisfd;
                break;
            }
            i++;
        }
    }

    //printf("[%s] getEthis(thisfd = '%s', fd = '%s', fdparent = '%s')\n", место.вТкст0(), thisfd.toPrettyChars(), fd.toPrettyChars(), fdparent.toPrettyChars());
    if (fdparent == thisfd)
    {
        /* Going down one nesting уровень, i.e. we're calling
         * a nested function from its enclosing function.
         */
        if (irs.sclosure && !(fd.идент == Id.require || fd.идент == Id.ensure))
        {
            ethis = el_var(irs.sclosure);
        }
        else if (irs.sthis)
        {
            // We have a 'this' pointer for the current function

            if (fdp != thisfd)
            {
                /* fdparent (== thisfd) is a derived member function,
                 * fdp is the overridden member function in base class, and
                 * fd is the nested function '__require' or '__ensure'.
                 * Even if there's a closure environment, we should give
                 * original stack данные as the nested function frame.
                 * See also: SymbolExp.toElem() in e2ir.c (https://issues.dlang.org/show_bug.cgi?ид=9383 fix)
                 */
                /* Address of 'sthis' gives the 'this' for the nested
                 * function.
                 */
                //printf("L%d fd = %s, fdparent = %s, fd.toParent2() = %s\n",
                //    __LINE__, fd.toPrettyChars(), fdparent.toPrettyChars(), fdp.toPrettyChars());
                assert(fd.идент == Id.require || fd.идент == Id.ensure);
                assert(thisfd.hasNestedFrameRefs());

                ClassDeclaration cdp = fdp.isThis().isClassDeclaration();
                ClassDeclaration cd = thisfd.isThis().isClassDeclaration();
                assert(cdp && cd);

                цел смещение;
                cdp.isBaseOf(cd, &смещение);
                assert(смещение != ClassDeclaration.OFFSET_RUNTIME);
                //printf("%s to %s, смещение = %d\n", cd.вТкст0(), cdp.вТкст0(), смещение);
                if (смещение)
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=7517: If fdp is declared in interface, смещение the
                     * 'this' pointer to get correct interface тип reference.
                     */
                    Symbol *stmp = symbol_genauto(TYnptr);
                    ethis = el_bin(OPadd, TYnptr, el_var(irs.sthis), el_long(TYт_мера, смещение));
                    ethis = el_bin(OPeq, TYnptr, el_var(stmp), ethis);
                    ethis = el_combine(ethis, el_ptr(stmp));
                    //elem_print(ethis);
                }
                else
                    ethis = el_ptr(irs.sthis);
            }
            else if (thisfd.hasNestedFrameRefs())
            {
                /* Local variables are referenced, can't skip.
                 * Address of 'sthis' gives the 'this' for the nested
                 * function.
                 */
                ethis = el_ptr(irs.sthis);
            }
            else
            {
                /* If no variables in the current function's frame are
                 * referenced by nested functions, then we can 'skip'
                 * adding this frame into the linked list of stack
                 * frames.
                 */
                ethis = el_var(irs.sthis);
            }
        }
        else
        {
            /* No 'this' pointer for current function,
             */
            if (thisfd.hasNestedFrameRefs())
            {
                /* OPframeptr is an operator that gets the frame pointer
                 * for the current function, i.e. for the x86 it gets
                 * the значение of EBP
                 */
                ethis = el_long(TYnptr, 0);
                ethis.Eoper = OPframeptr;
            }
            else
            {
                /* Use null if no references to the current function's frame
                 */
                ethis = el_long(TYnptr, 0);
            }
        }
    }
    else
    {
        if (!irs.sthis)                // if no frame pointer for this function
        {
            fd.выведиОшибку(место, "is a nested function and cannot be accessed from `%s`", irs.getFunc().toPrettyChars());
            return el_long(TYnptr, 0); // error recovery
        }

        /* Go up a nesting уровень, i.e. we need to найди the 'this'
         * of an enclosing function.
         * Our 'enclosing function' may also be an inner class.
         */
        ethis = el_var(irs.sthis);
        ДСимвол s = thisfd;
        while (fd != s)
        {
            //printf("\ts = '%s'\n", s.вТкст0());
            thisfd = s.isFuncDeclaration();

            if (thisfd)
            {
                /* Enclosing function is a function.
                 */
                // Error should have been caught by front end
                assert(thisfd.isNested() || thisfd.vthis);

                // pick one context
                ethis = fixEthis2(ethis, thisfd, thisfd.followInstantiationContext(ctxt0, ctxt1));
            }
            else
            {
                /* Enclosed by an aggregate. That means the current
                 * function must be a member function of that aggregate.
                 */
                AggregateDeclaration ad = s.isAggregateDeclaration();
                if (!ad)
                {
                  Lnoframe:
                    irs.getFunc().выведиОшибку(место, "cannot get frame pointer to `%s`", fd.toPrettyChars());
                    return el_long(TYnptr, 0);      // error recovery
                }
                ClassDeclaration cd = ad.isClassDeclaration();
                ClassDeclaration cdx = fd.isClassDeclaration();
                if (cd && cdx && cdx.isBaseOf(cd, null))
                    break;
                StructDeclaration sd = ad.isStructDeclaration();
                if (fd == sd)
                    break;
                if (!ad.isNested() || !(ad.vthis || ad.vthis2))
                    goto Lnoframe;

                бул i = ad.followInstantiationContext(ctxt0, ctxt1);
                const voffset = i ? ad.vthis2.смещение : ad.vthis.смещение;
                ethis = el_bin(OPadd, TYnptr, ethis, el_long(TYт_мера, voffset));
                ethis = el_una(OPind, TYnptr, ethis);
            }
            if (fdparent == s.toParentP(ctxt0, ctxt1))
                break;

            /* Remember that frames for functions that have no
             * nested references are skipped in the linked list
             * of frames.
             */
            FuncDeclaration fdp2 = s.toParentP(ctxt0, ctxt1).isFuncDeclaration();
            if (fdp2 && fdp2.hasNestedFrameRefs())
                ethis = el_una(OPind, TYnptr, ethis);

            s = s.toParentP(ctxt0, ctxt1);
            assert(s);
        }
    }
    version (none)
    {
        printf("ethis:\n");
        elem_print(ethis);
        printf("\n");
    }
    return ethis;
}

/************************
 * Select one context pointer from a dual-context массив
 * Возвращает:
 *      *(ethis + смещение);
 */
elem *fixEthis2(elem *ethis, FuncDeclaration fd, бул ctxt2 = нет)
{
    if (fd && fd.isThis2)
    {
        if (ctxt2)
            ethis = el_bin(OPadd, TYnptr, ethis, el_long(TYт_мера, tysize(TYnptr)));
        ethis = el_una(OPind, TYnptr, ethis);
    }
    return ethis;
}

/*************************
 * Initialize the hidden aggregate member, vthis, with
 * the context pointer.
 * Возвращает:
 *      *(ey + (ethis2 ? ad.vthis2 : ad.vthis).смещение) = this;
 */
elem *setEthis(ref Место место, IRState *irs, elem *ey, AggregateDeclaration ad, бул setthis2 = нет)
{
    elem *ethis;
    FuncDeclaration thisfd = irs.getFunc();
    цел смещение = 0;
    ДСимвол adp = setthis2 ? ad.toParent2(): ad.toParentLocal();     // class/func we're nested in

    //printf("[%s] setEthis(ad = %s, adp = %s, thisfd = %s)\n", место.вТкст0(), ad.вТкст0(), adp.вТкст0(), thisfd.вТкст0());

    if (adp == thisfd)
    {
        ethis = getEthis(место, irs, ad);
    }
    else if (thisfd.vthis && !thisfd.isThis2 &&
          (adp == thisfd.toParent2() ||
           (adp.isClassDeclaration() &&
            adp.isClassDeclaration().isBaseOf(thisfd.toParent2().isClassDeclaration(), &смещение)
           )
          )
        )
    {
        /* Class we're new'ing is at the same уровень as thisfd
         */
        assert(смещение == 0);    // BUG: should handle this case
        ethis = el_var(irs.sthis);
    }
    else
    {
        ethis = getEthis(место, irs, adp);
        FuncDeclaration fdp = adp.isFuncDeclaration();
        if (fdp && fdp.hasNestedFrameRefs())
            ethis = el_una(OPaddr, TYnptr, ethis);
    }

    assert(!setthis2 || ad.vthis2);
    const voffset = setthis2 ? ad.vthis2.смещение : ad.vthis.смещение;
    ey = el_bin(OPadd, TYnptr, ey, el_long(TYт_мера, voffset));
    ey = el_una(OPind, TYnptr, ey);
    ey = el_bin(OPeq, TYnptr, ey, ethis);
    return ey;
}

const NotIntrinsic = -1;
const OPtoPrec = OPMAX + 1; // front end only

/*******************************************
 * Convert intrinsic function to operator.
 * Возвращает:
 *      the operator as backend OPER,
 *      NotIntrinsic if not an intrinsic function,
 *      OPtoPrec if frontend-only intrinsic
 */
цел intrinsic_op(FuncDeclaration fd)
{
    цел op = NotIntrinsic;
    fd = fd.toAliasFunc();
    if (fd.isDeprecated())
        return op;
    //printf("intrinsic_op(%s)\n", имя);

    // Look for [core|std].module.function as id3.id2.id1 ...
    const Идентификатор2 id3 = fd.идент;
    auto m = fd.getModule();
    if (!m || !m.md)
        return op;

    const md = m.md;
    const Идентификатор2 id2 = md.ид;

    if (!md.пакеты)
        return op;

    // get тип of first argument
    auto tf = fd.тип ? fd.тип.isTypeFunction() : null;
    auto param1 = tf && tf.parameterList.length > 0 ? tf.parameterList[0] : null;
    auto argtype1 = param1 ? param1.тип : null;

    const Идентификатор2 id1 = (*md.пакеты)[0];
    // ... except std.math package and core.stdc.stdarg.va_start.
    if (md.пакеты.dim == 2)
    {
        if (id2 == Id.trig &&
            (*md.пакеты)[1] == Id.math &&
            id1 == Id.std)
        {
            goto Lstdmath;
        }
        goto Lva_start;
    }

    if (id1 == Id.std && id2 == Id.math)
    {
    Lstdmath:
        if (argtype1 is Тип.tfloat80 || id3 == Id._sqrt)
            goto Lmath;
    }
    else if (id1 == Id.core)
    {
        if (id2 == Id.math)
        {
        Lmath:
            if (argtype1 is Тип.tfloat80 || argtype1 is Тип.tfloat32 || argtype1 is Тип.tfloat64)
            {
                     if (id3 == Id.cos)    op = OPcos;
                else if (id3 == Id.sin)    op = OPsin;
                else if (id3 == Id.fabs)   op = OPabs;
                else if (id3 == Id.rint)   op = OPrint;
                else if (id3 == Id._sqrt)  op = OPsqrt;
                else if (id3 == Id.yl2x)   op = OPyl2x;
                else if (id3 == Id.ldexp)  op = OPscale;
                else if (id3 == Id.rndtol) op = OPrndtol;
                else if (id3 == Id.yl2xp1) op = OPyl2xp1;
                else if (id3 == Id.toPrec) op = OPtoPrec;
            }
        }
        else if (id2 == Id.simd)
        {
                 if (id3 == Id.__prefetch) op = OPprefetch;
            else if (id3 == Id.__simd_sto) op = OPvector;
            else if (id3 == Id.__simd)     op = OPvector;
            else if (id3 == Id.__simd_ib)  op = OPvector;
        }
        else if (id2 == Id.bitop)
        {
                 if (id3 == Id.volatileLoad)  op = OPind;
            else if (id3 == Id.volatileStore) op = OPeq;

            else if (id3 == Id.bsf) op = OPbsf;
            else if (id3 == Id.bsr) op = OPbsr;
            else if (id3 == Id.btc) op = OPbtc;
            else if (id3 == Id.btr) op = OPbtr;
            else if (id3 == Id.bts) op = OPbts;

            else if (id3 == Id.inp)  op = OPinp;
            else if (id3 == Id.inpl) op = OPinp;
            else if (id3 == Id.inpw) op = OPinp;

            else if (id3 == Id.outp)  op = OPoutp;
            else if (id3 == Id.outpl) op = OPoutp;
            else if (id3 == Id.outpw) op = OPoutp;

            else if (id3 == Id.bswap)   op = OPbswap;
            else if (id3 == Id._popcnt) op = OPpopcnt;
        }
        /+
        else if (id2 == Id.volatile)
        {
                 if (id3 == Id.volatileLoad)  op = OPind;
            else if (id3 == Id.volatileStore) op = OPeq;
        }
        +/
    }

    if (!глоб2.парамы.is64bit)
    // No 64-bit bsf bsr in 32bit mode
    {
        if ((op == OPbsf || op == OPbsr) && argtype1 is Тип.tuns64)
            return NotIntrinsic;
    }
    // No 64-bit bswap
    if (op == OPbswap && argtype1 is Тип.tuns64)
        return NotIntrinsic;
    return op;

Lva_start:
    if (глоб2.парамы.is64bit &&
        fd.toParent().isTemplateInstance() &&
        id3 == Id.va_start &&
        id2 == Id.stdarg &&
        (*md.пакеты)[1] == Id.stdc &&
        id1 == Id.core)
    {
        return OPva_start;
    }
    return op;
}

/**************************************
 * Given an Выражение e that is an массив,
 * determine and set the 'length' variable.
 * Input:
 *      lengthVar       Symbol of 'length' variable
 *      &e      Выражение that is the массив
 *      t1      Тип of the массив
 * Output:
 *      e       is rewritten to avoid side effects
 * Возвращает:
 *      Выражение that initializes 'length'
 */
elem *resolveLengthVar(VarDeclaration lengthVar, elem **pe, Тип t1)
{
    //printf("resolveLengthVar()\n");
    elem *einit = null;

    if (lengthVar && !(lengthVar.класс_хранения & STC.const_))
    {
        elem *elength;
        Symbol *slength;

        if (t1.ty == Tsarray)
        {
            TypeSArray tsa = cast(TypeSArray)t1;
            dinteger_t length = tsa.dim.toInteger();

            elength = el_long(TYт_мера, length);
            goto L3;
        }
        else if (t1.ty == Tarray)
        {
            elength = *pe;
            *pe = el_same(&elength);
            elength = el_una(глоб2.парамы.is64bit ? OP128_64 : OP64_32, TYт_мера, elength);

        L3:
            slength = toSymbol(lengthVar);
            //symbol_add(slength);

            einit = el_bin(OPeq, TYт_мера, el_var(slength), elength);
        }
    }
    return einit;
}

/*************************************
 * for a nested function 'fd' return the тип of the closure
 * of an outer function or aggregate. If the function is a member function
 * the 'this' тип is expected to be stored in 'sthis.Sthis'.
 * It is always returned if it is not a проц pointer.
 * buildClosure() must have been called on the outer function before.
 *
 * Параметры:
 *      sthis = the symbol of the current 'this' derived from fd.vthis
 *      fd = the nested function
 */
TYPE* getParentClosureType(Symbol* sthis, FuncDeclaration fd)
{
    if (sthis)
    {
        // only replace ук
        if (sthis.Stype.Tty != TYnptr || sthis.Stype.Tnext.Tty != TYvoid)
            return sthis.Stype;
    }
    for (ДСимвол sym = fd.toParent2(); sym; sym = sym.toParent2())
    {
        if (auto fn = sym.isFuncDeclaration())
            if (fn.csym && fn.csym.Sscope)
                return fn.csym.Sscope.Stype;
        if (sym.isAggregateDeclaration())
            break;
    }
    return sthis ? sthis.Stype : Type_toCtype(Тип.tvoidptr);
}

/**************************************
 * Go through the variables in function fd that are
 * to be allocated in a closure, and set the .смещение fields
 * for those variables to their positions relative to the start
 * of the closure instance.
 * Also turns off nrvo for closure variables.
 * Параметры:
 *      fd = function
 */
проц setClosureVarOffset(FuncDeclaration fd)
{
    if (fd.needsClosure())
    {
        бцел смещение = target.ptrsize;      // leave room for previous sthis

        foreach (v; fd.closureVars)
        {
            /* Align and размести space for v in the closure
             * just like AggregateDeclaration.addField() does.
             */
            бцел memsize;
            бцел memalignsize;
            structalign_t xalign;
            if (v.класс_хранения & STC.lazy_)
            {
                /* Lazy variables are really delegates,
                 * so give same answers that TypeDelegate would
                 */
                memsize = target.ptrsize * 2;
                memalignsize = memsize;
                xalign = STRUCTALIGN_DEFAULT;
            }
            else if (v.класс_хранения & (STC.out_ | STC.ref_))
            {
                // reference parameters are just pointers
                memsize = target.ptrsize;
                memalignsize = memsize;
                xalign = STRUCTALIGN_DEFAULT;
            }
            else
            {
                memsize = cast(бцел)v.тип.size();
                memalignsize = v.тип.alignsize();
                xalign = v.alignment;
            }
            AggregateDeclaration.alignmember(xalign, memalignsize, &смещение);
            v.смещение = смещение;
            //printf("closure var %s, смещение = %d\n", v.вТкст0(), v.смещение);

            смещение += memsize;

            /* Can't do nrvo if the variable is put in a closure, since
             * what the shidden points to may no longer exist.
             */
            if (fd.nrvo_can && fd.nrvo_var == v)
            {
                fd.nrvo_can = нет;
            }
        }
    }
}

/*************************************
 * Closures are implemented by taking the local variables that
 * need to survive the scope of the function, and copying them
 * into a gc allocated chuck of memory. That chunk, called the
 * closure here, is inserted into the linked list of stack
 * frames instead of the usual stack frame.
 *
 * buildClosure() inserts code just after the function prolog
 * is complete. It allocates memory for the closure, allocates
 * a local variable (sclosure) to point to it, inserts into it
 * the link to the enclosing frame, and copies into it the parameters
 * that are referred to in nested functions.
 * In VarExp::toElem and SymOffExp::toElem, when referring to a
 * variable that is in a closure, takes the смещение from sclosure rather
 * than from the frame pointer.
 *
 * getEthis() and NewExp::toElem need to use sclosure, if set, rather
 * than the current frame pointer.
 */
проц buildClosure(FuncDeclaration fd, IRState *irs)
{
    //printf("buildClosure(fd = %s)\n", fd.вТкст0());
    if (fd.needsClosure())
    {
        setClosureVarOffset(fd);

        // Generate closure on the heap
        // BUG: doesn't capture variadic arguments passed to this function

        /* BUG: doesn't handle destructors for the local variables.
         * The way to do it is to make the closure variables the fields
         * of a class объект:
         *    class Closure {
         *        vtbl[]
         *        monitor
         *        ptr to destructor
         *        sthis
         *        ... closure variables ...
         *        ~this() { call destructor }
         *    }
         */
        //printf("FuncDeclaration.buildClosure() %s\n", fd.вТкст0());

        /* Generate тип имя for closure struct */
        const сим *name1 = "CLOSURE.";
        const сим *name2 = fd.toPrettyChars();
        т_мера namesize = strlen(name1)+strlen(name2)+1;
        сим *closname = cast(сим *)Пам.check(calloc(namesize, сим.sizeof));
        strcat(strcat(closname, name1), name2);

        /* Build тип for closure */
        тип *Closstru = type_struct_class(closname, target.ptrsize, 0, null, null, нет, нет, да, нет);
        free(closname);
        auto chaintype = getParentClosureType(irs.sthis, fd);
        symbol_struct_addField(Closstru.Ttag, "__chain", chaintype, 0);

        Symbol *sclosure;
        sclosure = symbol_name("__closptr", SCauto, type_pointer(Closstru));
        sclosure.Sflags |= SFLtrue | SFLfree;
        symbol_add(sclosure);
        irs.sclosure = sclosure;

        assert(fd.closureVars.dim);
        assert(fd.closureVars[0].смещение >= target.ptrsize);
        foreach (v; fd.closureVars)
        {
            //printf("closure var %s\n", v.вТкст0());

            // Hack for the case fail_compilation/fail10666.d,
            // until proper issue 5730 fix will come.
            бул isScopeDtorParam = v.edtor && (v.класс_хранения & STC.параметр);
            if (v.needsScopeDtor() || isScopeDtorParam)
            {
                /* Because the значение needs to survive the end of the scope!
                 */
                v.выведиОшибку("has scoped destruction, cannot build closure");
            }
            if (v.isargptr)
            {
                /* See https://issues.dlang.org/show_bug.cgi?ид=2479
                 * This is actually a bug, but better to produce a nice
                 * message at compile time rather than memory corruption at runtime
                 */
                v.выведиОшибку("cannot reference variadic arguments from closure");
            }

            /* Set Sscope to closure */
            Symbol *vsym = toSymbol(v);
            assert(vsym.Sscope == null);
            vsym.Sscope = sclosure;

            /* Add variable as closure тип member */
            symbol_struct_addField(Closstru.Ttag, &vsym.Sident[0], vsym.Stype, v.смещение);
            //printf("closure field %s: memalignsize: %i, смещение: %i\n", &vsym.Sident[0], memalignsize, v.смещение);
        }

        // Calculate the size of the closure
        VarDeclaration  vlast = fd.closureVars[fd.closureVars.dim - 1];
        typeof(Тип.size()) lastsize;
        if (vlast.класс_хранения & STC.lazy_)
            lastsize = target.ptrsize * 2;
        else if (vlast.isRef() || vlast.isOut())
            lastsize = target.ptrsize;
        else
            lastsize = vlast.тип.size();
        бул overflow;
        const structsize = addu(vlast.смещение, lastsize, overflow);
        assert(!overflow && structsize <= бцел.max);
        //printf("structsize = %d\n", cast(бцел)structsize);

        Closstru.Ttag.Sstruct.Sstructsize = cast(бцел)structsize;
        fd.csym.Sscope = sclosure;

        if (глоб2.парамы.symdebug)
            toDebugClosure(Closstru.Ttag);

        // Allocate memory for the closure
        elem *e = el_long(TYт_мера, structsize);
        e = el_bin(OPcall, TYnptr, el_var(getRtlsym(RTLSYM_ALLOCMEMORY)), e);
        toTraceGC(irs, e, fd.место);

        // Assign block of memory to sclosure
        //    sclosure = allocmemory(sz);
        e = el_bin(OPeq, TYvoid, el_var(sclosure), e);

        // Set the first element to sthis
        //    *(sclosure + 0) = sthis;
        elem *ethis;
        if (irs.sthis)
            ethis = el_var(irs.sthis);
        else
            ethis = el_long(TYnptr, 0);
        elem *ex = el_una(OPind, TYnptr, el_var(sclosure));
        ex = el_bin(OPeq, TYnptr, ex, ethis);
        e = el_combine(e, ex);

        // Copy function parameters into closure
        foreach (v; fd.closureVars)
        {
            if (!v.isParameter())
                continue;
            tym_t tym = totym(v.тип);
            const x64ref = ISX64REF(v);
            if (x64ref && config.exe == EX_WIN64)
            {
                if (v.класс_хранения & STC.lazy_)
                    tym = TYdelegate;
            }
            else if (ISREF(v) && !x64ref)
                tym = TYnptr;   // reference parameters are just pointers
            else if (v.класс_хранения & STC.lazy_)
                tym = TYdelegate;
            ex = el_bin(OPadd, TYnptr, el_var(sclosure), el_long(TYт_мера, v.смещение));
            ex = el_una(OPind, tym, ex);
            elem *ev = el_var(toSymbol(v));
            if (x64ref)
            {
                ev.Ety = TYnref;
                ev = el_una(OPind, tym, ev);
                if (tybasic(ev.Ety) == TYstruct || tybasic(ev.Ety) == TYarray)
                    ev.ET = Type_toCtype(v.тип);
            }
            if (tybasic(ex.Ety) == TYstruct || tybasic(ex.Ety) == TYarray)
            {
                .тип *t = Type_toCtype(v.тип);
                ex.ET = t;
                ex = el_bin(OPstreq, tym, ex, ev);
                ex.ET = t;
            }
            else
                ex = el_bin(OPeq, tym, ex, ev);

            e = el_combine(e, ex);
        }

        block_appendexp(irs.blx.curblock, e);
    }
}

/*************************************
 * build a debug info struct for variables captured by nested functions,
 * but not in a closure.
 * must be called after generating the function to fill stack offsets
 * Параметры:
 *      fd = function
 */
проц buildCapture(FuncDeclaration fd)
{
    if (!глоб2.парамы.symdebug)
        return;
    if (!глоб2.парамы.mscoff)  // toDebugClosure only implemented for CodeView,
        return;                 //  but optlink crashes for negative field offsets

    if (fd.closureVars.dim && !fd.needsClosure)
    {
        /* Generate тип имя for struct with captured variables */
        const сим *name1 = "CAPTURE.";
        const сим *name2 = fd.toPrettyChars();
        т_мера namesize = strlen(name1)+strlen(name2)+1;
        сим *capturename = cast(сим *)Пам.check(calloc(namesize, сим.sizeof));
        strcat(strcat(capturename, name1), name2);

        /* Build тип for struct */
        тип *capturestru = type_struct_class(capturename, target.ptrsize, 0, null, null, нет, нет, да, нет);
        free(capturename);

        foreach (v; fd.closureVars)
        {
            Symbol *vsym = toSymbol(v);

            /* Add variable as capture тип member */
            auto soffset = vsym.Soffset;
            if (fd.vthis)
                soffset -= toSymbol(fd.vthis).Soffset; // see toElem.ToElemVisitor.посети(SymbolExp)
            symbol_struct_addField(capturestru.Ttag, &vsym.Sident[0], vsym.Stype, cast(бцел)soffset);
            //printf("capture field %s: смещение: %i\n", &vsym.Sident[0], v.смещение);
        }

        // generate pseudo symbol to put into functions' Sscope
        Symbol *scapture = symbol_name("__captureptr", SCalias, type_pointer(capturestru));
        scapture.Sflags |= SFLtrue | SFLfree;
        //symbol_add(scapture);
        fd.csym.Sscope = scapture;

        toDebugClosure(capturestru.Ttag);
    }
}


/***************************
 * Determine return style of function - whether in registers or
 * through a hidden pointer to the caller's stack.
 * Параметры:
 *   tf = function тип to check
 *   needsThis = да if the function тип is for a non-static member function
 * Возвращает:
 *   RET.stack if return значение from function is on the stack, RET.regs otherwise
 */
RET retStyle(TypeFunction tf, бул needsThis)
{
    //printf("TypeFunction.retStyle() %s\n", вТкст0());
    return target.isReturnOnStack(tf, needsThis) ? RET.stack : RET.regs;
}
