/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/safe.d, _safe.d)
 * Documentation:  https://dlang.org/phobos/dmd_safe.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/safe.d
 */

module dmd.safe;

import cidrus;

import dmd.aggregate;
import dmd.dclass;
import dmd.declaration;
import dmd.dscope;
import drc.ast.Expression;
import dmd.mtype;
import dmd.target;
import drc.lexer.Tokens;


/*************************************************************
 * Check for unsafe access in  code:
 * 1. читай overlapped pointers
 * 2. пиши misaligned pointers
 * 3. пиши overlapped storage classes
 * Print error if unsafe.
 * Параметры:
 *      sc = scope
 *      e = Выражение to check
 *      readonly = if access is читай-only
 *      printmsg = print error message if да
 * Возвращает:
 *      да if error
 */

бул checkUnsafeAccess(Scope* sc, Выражение e, бул readonly, бул printmsg)
{
    //printf("checkUnsafeAccess(e: '%s', readonly: %d, printmsg: %d)\n", e.вТкст0(), readonly, printmsg);
    if (e.op != ТОК2.dotVariable)
        return нет;
    DotVarExp dve = cast(DotVarExp)e;
    if (VarDeclaration v = dve.var.isVarDeclaration())
    {
        if (sc.intypeof || !sc.func || !sc.func.isSafeBypassingInference())
            return нет;

        auto ad = v.toParent2().isAggregateDeclaration();
        if (!ad)
            return нет;

        const hasPointers = v.тип.hasPointers();
        if (hasPointers)
        {
            if (ad.sizeok != Sizeok.done)
                ad.determineSize(ad.место);       // needed to set v.overlapped

            if (v.overlapped && sc.func.setUnsafe())
            {
                if (printmsg)
                    e.выведиОшибку("field `%s.%s` cannot access pointers in `` code that overlap other fields",
                        ad.вТкст0(), v.вТкст0());
                return да;
            }
        }

        if (readonly || !e.тип.isMutable())
            return нет;

        if (hasPointers && v.тип.toBasetype().ty != Tstruct)
        {
            if ((ad.тип.alignment() < target.ptrsize ||
                 (v.смещение & (target.ptrsize - 1))) &&
                sc.func.setUnsafe())
            {
                if (printmsg)
                    e.выведиОшибку("field `%s.%s` cannot modify misaligned pointers in `` code",
                        ad.вТкст0(), v.вТкст0());
                return да;
            }
        }

        if (v.overlapUnsafe && sc.func.setUnsafe())
        {
             if (printmsg)
                 e.выведиОшибку("field `%s.%s` cannot modify fields in `` code that overlap fields with other storage classes",
                    ad.вТкст0(), v.вТкст0());
             return да;
        }
    }
    return нет;
}


/**********************************************
 * Determine if it is  to cast e from tfrom to tto.
 * Параметры:
 *      e = Выражение to be cast
 *      tfrom = тип of e
 *      tto = тип to cast e to
 * Возвращает:
 *      да if 
 */
бул isSafeCast(Выражение e, Тип tfrom, Тип tto)
{
    // Implicit conversions are always safe
    if (tfrom.implicitConvTo(tto))
        return да;

    if (!tto.hasPointers())
        return да;

    auto tfromb = tfrom.toBasetype();
    auto ttob = tto.toBasetype();

    if (ttob.ty == Tclass && tfromb.ty == Tclass)
    {
        ClassDeclaration cdfrom = tfromb.isClassHandle();
        ClassDeclaration cdto = ttob.isClassHandle();

        цел смещение;
        if (!cdfrom.isBaseOf(cdto, &смещение) &&
            !((cdfrom.isInterfaceDeclaration() || cdto.isInterfaceDeclaration())
                && cdfrom.classKind == ClassKind.d && cdto.classKind == ClassKind.d))
            return нет;

        if (cdfrom.isCPPinterface() || cdto.isCPPinterface())
            return нет;

        if (!MODimplicitConv(tfromb.mod, ttob.mod))
            return нет;
        return да;
    }

    if (ttob.ty == Tarray && tfromb.ty == Tsarray) // https://issues.dlang.org/show_bug.cgi?ид=12502
        tfromb = tfromb.nextOf().arrayOf();

    if (ttob.ty == Tarray   && tfromb.ty == Tarray ||
        ttob.ty == Tpointer && tfromb.ty == Tpointer)
    {
        Тип ttobn = ttob.nextOf().toBasetype();
        Тип tfromn = tfromb.nextOf().toBasetype();

        /* From проц[] to anything mutable is unsafe because:
         *  цел*[] api;
         *  проц[] av = api;
         *  цел[] ai = cast(цел[]) av;
         *  ai[0] = 7;
         *  *api[0] crash!
         */
        if (tfromn.ty == Tvoid && ttobn.isMutable())
        {
            if (ttob.ty == Tarray && e.op == ТОК2.arrayLiteral)
                return да;
            return нет;
        }

        // If the struct is opaque we don't know about the struct члены then the cast becomes unsafe
        if (ttobn.ty == Tstruct && !(cast(TypeStruct)ttobn).sym.члены ||
            tfromn.ty == Tstruct && !(cast(TypeStruct)tfromn).sym.члены)
            return нет;

        const frompointers = tfromn.hasPointers();
        const topointers = ttobn.hasPointers();

        if (frompointers && !topointers && ttobn.isMutable())
            return нет;

        if (!frompointers && topointers)
            return нет;

        if (!topointers &&
            ttobn.ty != Tfunction && tfromn.ty != Tfunction &&
            (ttob.ty == Tarray || ttobn.size() <= tfromn.size()) &&
            MODimplicitConv(tfromn.mod, ttobn.mod))
        {
            return да;
        }
    }
    return нет;
}

