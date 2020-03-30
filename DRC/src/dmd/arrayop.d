/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/arrayop.d, _arrayop.d)
 * Documentation:  https://dlang.org/phobos/dmd_arrayop.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/arrayop.d
 */

module dmd.arrayop;

import cidrus;
import dmd.arraytypes;
import dmd.declaration;
import dmd.dscope;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import util.outbuffer;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.dtemplate : TemplateDeclaration;
/**********************************************
 * Check that there are no uses of arrays without [].
 */
бул isArrayOpValid(Выражение e)
{
    //printf("isArrayOpValid() %s\n", e.вТкст0());
    if (e.op == ТОК2.slice)
        return да;
    if (e.op == ТОК2.arrayLiteral)
    {
        Тип t = e.тип.toBasetype();
        while (t.ty == Tarray || t.ty == Tsarray)
            t = t.nextOf().toBasetype();
        return (t.ty != Tvoid);
    }
    Тип tb = e.тип.toBasetype();
    if (tb.ty == Tarray || tb.ty == Tsarray)
    {
        if (isUnaArrayOp(e.op))
        {
            return isArrayOpValid((cast(UnaExp)e).e1);
        }
        if (isBinArrayOp(e.op) || isBinAssignArrayOp(e.op) || e.op == ТОК2.assign)
        {
            BinExp be = cast(BinExp)e;
            return isArrayOpValid(be.e1) && isArrayOpValid(be.e2);
        }
        if (e.op == ТОК2.construct)
        {
            BinExp be = cast(BinExp)e;
            return be.e1.op == ТОК2.slice && isArrayOpValid(be.e2);
        }
        // if (e.op == ТОК2.call)
        // {
        // TODO: Decide if [] is required after arrayop calls.
        // }
        return нет;
    }
    return да;
}

бул isNonAssignmentArrayOp(Выражение e)
{
    if (e.op == ТОК2.slice)
        return isNonAssignmentArrayOp((cast(SliceExp)e).e1);

    Тип tb = e.тип.toBasetype();
    if (tb.ty == Tarray || tb.ty == Tsarray)
    {
        return (isUnaArrayOp(e.op) || isBinArrayOp(e.op));
    }
    return нет;
}

бул checkNonAssignmentArrayOp(Выражение e, бул suggestion = нет)
{
    if (isNonAssignmentArrayOp(e))
    {
        ткст0 s = "";
        if (suggestion)
            s = " (possible missing [])";
        e.выведиОшибку("массив operation `%s` without destination memory not allowed%s", e.вТкст0(), s);
        return да;
    }
    return нет;
}

/***********************************
 * Construct the массив operation Выражение, call объект._arrayOp!(tiargs)(args).
 *
 * Encode operand types and operations into tiargs using reverse polish notation (RPN) to preserve precedence.
 * Unary operations are prefixed with "u" (e.g. "u~").
 * Pass operand values (slices or scalars) as args.
 *
 * Scalar Выражение sub-trees of `e` are evaluated before calling
 * into druntime to hoist them out of the loop. This is a valid
 * evaluation order as the actual массив operations have no
 * side-effect.
 * References:
 * https://github.com/dlang/druntime/blob/master/src/объект.d#L3944
 * https://github.com/dlang/druntime/blob/master/src/core/internal/массив/operations.d
 */
Выражение arrayOp(BinExp e, Scope* sc)
{
    //printf("BinExp.arrayOp() %s\n", e.вТкст0());
    Тип tb = e.тип.toBasetype();
    assert(tb.ty == Tarray || tb.ty == Tsarray);
    Тип tbn = tb.nextOf().toBasetype();
    if (tbn.ty == Tvoid)
    {
        e.выведиОшибку("cannot perform массив operations on `проц[]` arrays");
        return new ErrorExp();
    }
    if (!isArrayOpValid(e))
        return arrayOpInvalidError(e);

    auto tiargs = new Объекты();
    auto args = new Выражения();
    buildArrayOp(sc, e, tiargs, args);


     TemplateDeclaration arrayOp;
    if (arrayOp is null)
    {
        // Create .объект._arrayOp
        Идентификатор2 idArrayOp = Идентификатор2.idPool("_arrayOp");
        Выражение ид = new IdentifierExp(e.место, Id.empty);
        ид = new DotIdExp(e.место, ид, Id.объект);
        ид = new DotIdExp(e.место, ид, idArrayOp);

        ид = ид.ВыражениеSemantic(sc);
        if (auto te = ид.isTemplateExp())
            arrayOp = te.td;
        else
            ObjectNotFound(idArrayOp);   // fatal error
    }

    auto fd = resolveFuncCall(e.место, sc, arrayOp, tiargs, null, args, FuncResolveFlag.standard);
    if (!fd || fd.errors)
        return new ErrorExp();
    auto rez = new CallExp(e.место, new VarExp(e.место, fd, нет), args);
    return rez.ВыражениеSemantic(sc);
}

/// ditto
Выражение arrayOp(BinAssignExp e, Scope* sc)
{
    //printf("BinAssignExp.arrayOp() %s\n", вТкст0());

    /* Check that the elements of e1 can be assigned to
     */
    Тип tn = e.e1.тип.toBasetype().nextOf();

    if (tn && (!tn.isMutable() || !tn.isAssignable()))
    {
        e.выведиОшибку("slice `%s` is not mutable", e.e1.вТкст0());
        if (e.op == ТОК2.addAssign)
            checkPossibleAddCatError!(AddAssignExp, CatAssignExp)(e.isAddAssignExp);
        return new ErrorExp();
    }
    if (e.e1.op == ТОК2.arrayLiteral)
    {
        return e.e1.modifiableLvalue(sc, e.e1);
    }

    return arrayOp(cast(BinExp)e, sc);
}

/******************************************
 * Convert the Выражение tree e to template and function arguments,
 * using reverse polish notation (RPN) to encode order of operations.
 * Encode operations as ткст arguments, using a "u" префикс for unary operations.
 */
private проц buildArrayOp(Scope* sc, Выражение e, Объекты* tiargs, Выражения* args)
{
     final class BuildArrayOpVisitor : Визитор2
    {
        alias Визитор2.посети посети;
        Scope* sc;
        Объекты* tiargs;
        Выражения* args;

    public:
        this(Scope* sc, Объекты* tiargs, Выражения* args)
        {
            this.sc = sc;
            this.tiargs = tiargs;
            this.args = args;
        }

        override проц посети(Выражение e)
        {
            tiargs.сунь(e.тип);
            args.сунь(e);
        }

        override проц посети(SliceExp e)
        {
            посети(cast(Выражение) e);
        }

        override проц посети(CastExp e)
        {
            посети(cast(Выражение) e);
        }

        override проц посети(UnaExp e)
        {
            Тип tb = e.тип.toBasetype();
            if (tb.ty != Tarray && tb.ty != Tsarray) // hoist scalar Выражения
            {
                посети(cast(Выражение) e);
            }
            else
            {
                // RPN, префикс unary ops with u
                БуфВыв буф;
                буф.пишиСтр("u");
                буф.пишиСтр(Сема2.вТкст(e.op));
                e.e1.прими(this);
                auto rez = new StringExp(Место.initial, буф.извлекиСрез());
                tiargs.сунь(rez.ВыражениеSemantic(sc));
            }
        }

        override проц посети(BinExp e)
        {
            Тип tb = e.тип.toBasetype();
            if (tb.ty != Tarray && tb.ty != Tsarray) // hoist scalar Выражения
            {
                посети(cast(Выражение) e);
            }
            else
            {
                // RPN
                e.e1.прими(this);
                e.e2.прими(this);
                auto rez = new StringExp(Место.initial, Сема2.вТкст(e.op));
                tiargs.сунь(rez.ВыражениеSemantic(sc));
            }
        }
    }

    scope v = new BuildArrayOpVisitor(sc, tiargs, args);
    e.прими(v);
}

/***********************************************
 * Some implicit casting can be performed by the _arrayOp template.
 * Параметры:
 *      tfrom = тип converting from
 *      tto   = тип converting to
 * Возвращает:
 *      да if can be performed by _arrayOp
 */
бул isArrayOpImplicitCast(TypeDArray tfrom, TypeDArray tto)
{
    const tyf = tfrom.nextOf().toBasetype().ty;
    const tyt = tto  .nextOf().toBasetype().ty;
    return tyf == tyt ||
           tyf == Tint32 && tyt == Tfloat64;
}

/***********************************************
 * Test if Выражение is a unary массив op.
 */
бул isUnaArrayOp(ТОК2 op)
{
    switch (op)
    {
    case ТОК2.negate:
    case ТОК2.tilde:
        return да;
    default:
        break;
    }
    return нет;
}

/***********************************************
 * Test if Выражение is a binary массив op.
 */
бул isBinArrayOp(ТОК2 op)
{
    switch (op)
    {
    case ТОК2.add:
    case ТОК2.min:
    case ТОК2.mul:
    case ТОК2.div:
    case ТОК2.mod:
    case ТОК2.xor:
    case ТОК2.and:
    case ТОК2.or:
    case ТОК2.pow:
        return да;
    default:
        break;
    }
    return нет;
}

/***********************************************
 * Test if Выражение is a binary assignment массив op.
 */
бул isBinAssignArrayOp(ТОК2 op)
{
    switch (op)
    {
    case ТОК2.addAssign:
    case ТОК2.minAssign:
    case ТОК2.mulAssign:
    case ТОК2.divAssign:
    case ТОК2.modAssign:
    case ТОК2.xorAssign:
    case ТОК2.andAssign:
    case ТОК2.orAssign:
    case ТОК2.powAssign:
        return да;
    default:
        break;
    }
    return нет;
}

/***********************************************
 * Test if operand is a valid массив op operand.
 */
бул isArrayOpOperand(Выражение e)
{
    //printf("Выражение.isArrayOpOperand() %s\n", e.вТкст0());
    if (e.op == ТОК2.slice)
        return да;
    if (e.op == ТОК2.arrayLiteral)
    {
        Тип t = e.тип.toBasetype();
        while (t.ty == Tarray || t.ty == Tsarray)
            t = t.nextOf().toBasetype();
        return (t.ty != Tvoid);
    }
    Тип tb = e.тип.toBasetype();
    if (tb.ty == Tarray)
    {
        return (isUnaArrayOp(e.op) ||
                isBinArrayOp(e.op) ||
                isBinAssignArrayOp(e.op) ||
                e.op == ТОК2.assign);
    }
    return нет;
}


/***************************************************
 * Print error message about invalid массив operation.
 * Параметры:
 *      e = Выражение with the invalid массив operation
 * Возвращает:
 *      instance of ErrorExp
 */

ErrorExp arrayOpInvalidError(Выражение e)
{
    e.выведиОшибку("invalid массив operation `%s` (possible missing [])", e.вТкст0());
    if (e.op == ТОК2.add)
        checkPossibleAddCatError!(AddExp, CatExp)(e.isAddExp());
    else if (e.op == ТОК2.addAssign)
        checkPossibleAddCatError!(AddAssignExp, CatAssignExp)(e.isAddAssignExp());
    return new ErrorExp();
}

private проц checkPossibleAddCatError(AddT, CatT)(AddT ae)
{
    if (!ae.e2.тип || ae.e2.тип.ty != Tarray || !ae.e2.тип.implicitConvTo(ae.e1.тип))
        return;
    CatT ce = new CatT(ae.место, ae.e1, ae.e2);
    ae.errorSupplemental("did you mean to concatenate (`%s`) instead ?", ce.вТкст0());
}
