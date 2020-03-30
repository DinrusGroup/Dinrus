/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Manage flow analysis for constructors.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/ctorflow.d, _ctorflow.d)
 * Documentation:  https://dlang.org/phobos/dmd_ctorflow.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/ctorflow.d
 */

module dmd.ctorflow;

import cidrus;

import util.rmem;
import dmd.globals : Место;

enum CSX : ushort
{
    none            = 0,
    this_ctor       = 0x01,     /// called this()
    super_ctor      = 0x02,     /// called super()
    label           = 0x04,     /// seen a label
    return_         = 0x08,     /// seen a return инструкция
    any_ctor        = 0x10,     /// either this() or super() was called
    halt            = 0x20,     /// assert(0)
}

/// Individual field in the Ctor with information about its callees and location.
struct FieldInit
{
    CSX csx; /// information about the field's callees
    Место место; /// location of the field initialization
}

/***********
 * Primitive flow analysis for constructors
 */
struct CtorFlow
{
    CSX callSuper;      /// state of calling other constructors

    FieldInit[] fieldinit;    /// state of field initializations

    проц allocFieldinit(т_мера dim)
    {
        fieldinit = (cast(FieldInit*)mem.xcalloc(FieldInit.sizeof, dim))[0 .. dim];
    }

    проц freeFieldinit()
    {
        if (fieldinit.ptr)
            mem.xfree(fieldinit.ptr);

        fieldinit = null;
    }

    /***********************
     * Create a deep копируй of `this`
     * Возвращает:
     *  a копируй
     */
    CtorFlow clone()
    {
        return CtorFlow(callSuper, fieldinit.arraydup);
    }

    /**********************************
     * Set CSX bits in flow analysis state
     * Параметры:
     *  csx = bits to set
     */
    проц orCSX(CSX csx) 
    {
        callSuper |= csx;
        foreach (ref u; fieldinit)
            u.csx |= csx;
    }

    /******************************
     * OR CSX bits to `this`
     * Параметры:
     *  ctorflow = bits to OR in
     */
    проц OR(ref CtorFlow ctorflow)
    {
        callSuper |= ctorflow.callSuper;
        if (fieldinit.length && ctorflow.fieldinit.length)
        {
            assert(fieldinit.length == ctorflow.fieldinit.length);
            foreach (i, u; ctorflow.fieldinit)
            {
                auto fi = &fieldinit[i];
                fi.csx |= u.csx;
                if (fi.место is Место.init)
                    fi.место = u.место;
            }
        }
    }
}


/****************************************
 * Merge `b` flow analysis результатs into `a`.
 * Параметры:
 *      a = the path to merge `b` into
 *      b = the other path
 * Возвращает:
 *      нет means one of the paths skips construction
 */
бул mergeCallSuper(ref CSX a, CSX b)
{
    // This does a primitive flow analysis to support the restrictions
    // regarding when and how constructors can appear.
    // It merges the результатs of two paths.
    // The two paths are `a` and `b`; the результат is merged into `a`.
    if (b == a)
        return да;

    // Have ALL branches called a constructor?
    const aAll = (a & (CSX.this_ctor | CSX.super_ctor)) != 0;
    const bAll = (b & (CSX.this_ctor | CSX.super_ctor)) != 0;
    // Have ANY branches called a constructor?
    const aAny = (a & CSX.any_ctor) != 0;
    const bAny = (b & CSX.any_ctor) != 0;
    // Have any branches returned?
    const aRet = (a & CSX.return_) != 0;
    const bRet = (b & CSX.return_) != 0;
    // Have any branches halted?
    const aHalt = (a & CSX.halt) != 0;
    const bHalt = (b & CSX.halt) != 0;
    if (aHalt && bHalt)
    {
        a = CSX.halt;
    }
    else if ((!bHalt && bRet && !bAny && aAny) || (!aHalt && aRet && !aAny && bAny))
    {
        // If one has returned without a constructor call, there must not
        // be ctor calls in the other.
        return нет;
    }
    else if (bHalt || bRet && bAll)
    {
        // If one branch has called a ctor and then exited, anything the
        // other branch has done is OK (except returning without a
        // ctor call, but we already checked that).
        a |= b & (CSX.any_ctor | CSX.label);
    }
    else if (aHalt || aRet && aAll)
    {
        a = cast(CSX)(b | (a & (CSX.any_ctor | CSX.label)));
    }
    else if (aAll != bAll) // both branches must have called ctors, or both not
        return нет;
    else
    {
        // If one returned without a ctor, remember that
        if (bRet && !bAny)
            a |= CSX.return_;
        a |= b & (CSX.any_ctor | CSX.label);
    }
    return да;
}


/****************************************
 * Merge `b` flow analysis результатs into `a`.
 * Параметры:
 *      a = the path to merge `b` into
 *      b = the other path
 * Возвращает:
 *      нет means either `a` or `b` skips initialization
 */
бул mergeFieldInit(ref CSX a, CSX b)
{
    if (b == a)
        return да;

    // Have any branches returned?
    const aRet = (a & CSX.return_) != 0;
    const bRet = (b & CSX.return_) != 0;
    // Have any branches halted?
    const aHalt = (a & CSX.halt) != 0;
    const bHalt = (b & CSX.halt) != 0;

    if (aHalt && bHalt)
    {
        a = CSX.halt;
        return да;
    }

    бул ok;
    if (!bHalt && bRet)
    {
        ok = (b & CSX.this_ctor);
        a = a;
    }
    else if (!aHalt && aRet)
    {
        ok = (a & CSX.this_ctor);
        a = b;
    }
    else if (bHalt)
    {
        ok = (a & CSX.this_ctor);
        a = a;
    }
    else if (aHalt)
    {
        ok = (b & CSX.this_ctor);
        a = b;
    }
    else
    {
        ok = !((a ^ b) & CSX.this_ctor);
        a |= b;
    }
    return ok;
}

