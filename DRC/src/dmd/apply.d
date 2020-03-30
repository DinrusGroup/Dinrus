/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/apply.d, _apply.d)
 * Documentation:  https://dlang.org/phobos/dmd_apply.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/apply.d
 */

module dmd.apply;

import dmd.arraytypes;
import dmd.dtemplate;
import drc.ast.Expression;
import drc.ast.Visitor;

/**************************************
 * An Выражение tree walker that will посети each Выражение e in the tree,
 * in depth-first evaluation order, and call fp(e,param) on it.
 * fp() signals whether the walking continues with its return значение:
 * Возвращает:
 *      0       continue
 *      1       done
 * It's a bit slower than using virtual functions, but more encapsulated and less brittle.
 * Creating an iterator for this would be much more complex.
 */
private  final class PostorderВыражениеВизитор2 : StoppableVisitor
{
    alias typeof(super).посети посети;
public:
    StoppableVisitor v;

    this(StoppableVisitor v)
    {
        this.v = v;
    }

    бул doCond(Выражение e)
    {
        if (!stop && e)
            e.прими(this);
        return stop;
    }

    бул doCond(Выражения* e)
    {
        if (!e)
            return нет;
        for (т_мера i = 0; i < e.dim && !stop; i++)
            doCond((*e)[i]);
        return stop;
    }

    бул applyTo(Выражение e)
    {
        e.прими(v);
        stop = v.stop;
        return да;
    }

    override проц посети(Выражение e)
    {
        applyTo(e);
    }

    override проц посети(NewExp e)
    {
        //printf("NewExp::apply(): %s\n", вТкст0());
        doCond(e.thisexp) || doCond(e.newargs) || doCond(e.arguments) || applyTo(e);
    }

    override проц посети(NewAnonClassExp e)
    {
        //printf("NewAnonClassExp::apply(): %s\n", вТкст0());
        doCond(e.thisexp) || doCond(e.newargs) || doCond(e.arguments) || applyTo(e);
    }

    override проц посети(TypeidExp e)
    {
        doCond(выражение_ли(e.obj)) || applyTo(e);
    }

    override проц посети(UnaExp e)
    {
        doCond(e.e1) || applyTo(e);
    }

    override проц посети(BinExp e)
    {
        doCond(e.e1) || doCond(e.e2) || applyTo(e);
    }

    override проц посети(AssertExp e)
    {
        //printf("CallExp::apply(apply_fp_t fp, проц *param): %s\n", вТкст0());
        doCond(e.e1) || doCond(e.msg) || applyTo(e);
    }

    override проц посети(CallExp e)
    {
        //printf("CallExp::apply(apply_fp_t fp, проц *param): %s\n", вТкст0());
        doCond(e.e1) || doCond(e.arguments) || applyTo(e);
    }

    override проц посети(ArrayExp e)
    {
        //printf("ArrayExp::apply(apply_fp_t fp, проц *param): %s\n", вТкст0());
        doCond(e.e1) || doCond(e.arguments) || applyTo(e);
    }

    override проц посети(SliceExp e)
    {
        doCond(e.e1) || doCond(e.lwr) || doCond(e.upr) || applyTo(e);
    }

    override проц посети(ArrayLiteralExp e)
    {
        doCond(e.basis) || doCond(e.elements) || applyTo(e);
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        doCond(e.keys) || doCond(e.values) || applyTo(e);
    }

    override проц посети(StructLiteralExp e)
    {
        if (e.stageflags & stageApply)
            return;
        цел old = e.stageflags;
        e.stageflags |= stageApply;
        doCond(e.elements) || applyTo(e);
        e.stageflags = old;
    }

    override проц посети(TupleExp e)
    {
        doCond(e.e0) || doCond(e.exps) || applyTo(e);
    }

    override проц посети(CondExp e)
    {
        doCond(e.econd) || doCond(e.e1) || doCond(e.e2) || applyTo(e);
    }
}

бул walkPostorder(Выражение e, StoppableVisitor v)
{
    scope PostorderВыражениеВизитор2 pv = new PostorderВыражениеВизитор2(v);
    e.прими(pv);
    return v.stop;
}
