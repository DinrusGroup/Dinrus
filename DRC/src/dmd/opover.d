/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/opover.d, _opover.d)
 * Documentation:  https://dlang.org/phobos/dmd_opover.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/opover.d
 */

module dmd.opover;

import cidrus;
import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import dmd.dclass;
import dmd.declaration;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.инструкция;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;

/***********************************
 * Determine if operands of binary op can be reversed
 * to fit operator overload.
 */
бул isCommutative(ТОК2 op)
{
    switch (op)
    {
    case ТОК2.add:
    case ТОК2.mul:
    case ТОК2.and:
    case ТОК2.or:
    case ТОК2.xor:
    // EqualExp
    case ТОК2.equal:
    case ТОК2.notEqual:
    // CmpExp
    case ТОК2.lessThan:
    case ТОК2.lessOrEqual:
    case ТОК2.greaterThan:
    case ТОК2.greaterOrEqual:
        return да;
    default:
        break;
    }
    return нет;
}

/***********************************
 * Get Идентификатор2 for operator overload.
 */
private Идентификатор2 opId(Выражение e)
{
    switch (e.op)
    {
    case ТОК2.uadd:                      return Id.uadd;
    case ТОК2.negate:                    return Id.neg;
    case ТОК2.tilde:                     return Id.com;
    case ТОК2.cast_:                     return Id._cast;
    case ТОК2.in_:                       return Id.opIn;
    case ТОК2.plusPlus:                  return Id.postinc;
    case ТОК2.minusMinus:                return Id.postdec;
    case ТОК2.add:                       return Id.add;
    case ТОК2.min:                       return Id.sub;
    case ТОК2.mul:                       return Id.mul;
    case ТОК2.div:                       return Id.div;
    case ТОК2.mod:                       return Id.mod;
    case ТОК2.pow:                       return Id.pow;
    case ТОК2.leftShift:                 return Id.shl;
    case ТОК2.rightShift:                return Id.shr;
    case ТОК2.unsignedRightShift:        return Id.ushr;
    case ТОК2.and:                       return Id.iand;
    case ТОК2.or:                        return Id.ior;
    case ТОК2.xor:                       return Id.ixor;
    case ТОК2.concatenate:               return Id.cat;
    case ТОК2.assign:                    return Id.assign;
    case ТОК2.addAssign:                 return Id.addass;
    case ТОК2.minAssign:                 return Id.subass;
    case ТОК2.mulAssign:                 return Id.mulass;
    case ТОК2.divAssign:                 return Id.divass;
    case ТОК2.modAssign:                 return Id.modass;
    case ТОК2.powAssign:                 return Id.powass;
    case ТОК2.leftShiftAssign:           return Id.shlass;
    case ТОК2.rightShiftAssign:          return Id.shrass;
    case ТОК2.unsignedRightShiftAssign:  return Id.ushrass;
    case ТОК2.andAssign:                 return Id.andass;
    case ТОК2.orAssign:                  return Id.orass;
    case ТОК2.xorAssign:                 return Id.xorass;
    case ТОК2.concatenateAssign:         return Id.catass;
    case ТОК2.equal:                     return Id.eq;
    case ТОК2.lessThan:
    case ТОК2.lessOrEqual:
    case ТОК2.greaterThan:
    case ТОК2.greaterOrEqual:            return Id.cmp;
    case ТОК2.массив:                     return Id.index;
    case ТОК2.star:                      return Id.opStar;
    default:                            assert(0);
    }
}

/***********************************
 * Get Идентификатор2 for reverse operator overload,
 * `null` if not supported for this operator.
 */
private Идентификатор2 opId_r(Выражение e)
{
    switch (e.op)
    {
    case ТОК2.in_:               return Id.opIn_r;
    case ТОК2.add:               return Id.add_r;
    case ТОК2.min:               return Id.sub_r;
    case ТОК2.mul:               return Id.mul_r;
    case ТОК2.div:               return Id.div_r;
    case ТОК2.mod:               return Id.mod_r;
    case ТОК2.pow:               return Id.pow_r;
    case ТОК2.leftShift:         return Id.shl_r;
    case ТОК2.rightShift:        return Id.shr_r;
    case ТОК2.unsignedRightShift:return Id.ushr_r;
    case ТОК2.and:               return Id.iand_r;
    case ТОК2.or:                return Id.ior_r;
    case ТОК2.xor:               return Id.ixor_r;
    case ТОК2.concatenate:       return Id.cat_r;
    default:                    return null;
    }
}

/*******************************************
 * Helper function to turn operator into template argument list
 */
Объекты* opToArg(Scope* sc, ТОК2 op)
{
    /* Remove the = from op=
     */
    switch (op)
    {
    case ТОК2.addAssign:
        op = ТОК2.add;
        break;
    case ТОК2.minAssign:
        op = ТОК2.min;
        break;
    case ТОК2.mulAssign:
        op = ТОК2.mul;
        break;
    case ТОК2.divAssign:
        op = ТОК2.div;
        break;
    case ТОК2.modAssign:
        op = ТОК2.mod;
        break;
    case ТОК2.andAssign:
        op = ТОК2.and;
        break;
    case ТОК2.orAssign:
        op = ТОК2.or;
        break;
    case ТОК2.xorAssign:
        op = ТОК2.xor;
        break;
    case ТОК2.leftShiftAssign:
        op = ТОК2.leftShift;
        break;
    case ТОК2.rightShiftAssign:
        op = ТОК2.rightShift;
        break;
    case ТОК2.unsignedRightShiftAssign:
        op = ТОК2.unsignedRightShift;
        break;
    case ТОК2.concatenateAssign:
        op = ТОК2.concatenate;
        break;
    case ТОК2.powAssign:
        op = ТОК2.pow;
        break;
    default:
        break;
    }
    Выражение e = new StringExp(Место.initial, Сема2.вТкст(op));
    e = e.ВыражениеSemantic(sc);
    auto tiargs = new Объекты();
    tiargs.сунь(e);
    return tiargs;
}

// Try alias this on first operand
private Выражение checkAliasThisForLhs(AggregateDeclaration ad, Scope* sc, BinExp e)
{
    if (!ad || !ad.aliasthis)
        return null;

    /* Rewrite (e1 op e2) as:
     *      (e1.aliasthis op e2)
     */
    if (e.att1 && e.e1.тип == e.att1)
        return null;
    //printf("att %s e1 = %s\n", Сема2::вТкст0(e.op), e.e1.тип.вТкст0());
    Выражение e1 = new DotIdExp(e.место, e.e1, ad.aliasthis.идент);
    BinExp be = cast(BinExp)e.копируй();
    if (!be.att1 && e.e1.тип.checkAliasThisRec())
        be.att1 = e.e1.тип;
    be.e1 = e1;

    Выражение результат;
    if (be.op == ТОК2.concatenateAssign)
        результат = be.op_overload(sc);
    else
        результат = be.trySemantic(sc);

    return результат;
}

// Try alias this on second operand
private Выражение checkAliasThisForRhs(AggregateDeclaration ad, Scope* sc, BinExp e)
{
    if (!ad || !ad.aliasthis)
        return null;
    /* Rewrite (e1 op e2) as:
     *      (e1 op e2.aliasthis)
     */
    if (e.att2 && e.e2.тип == e.att2)
        return null;
    //printf("att %s e2 = %s\n", Сема2::вТкст0(e.op), e.e2.тип.вТкст0());
    Выражение e2 = new DotIdExp(e.место, e.e2, ad.aliasthis.идент);
    BinExp be = cast(BinExp)e.копируй();
    if (!be.att2 && e.e2.тип.checkAliasThisRec())
        be.att2 = e.e2.тип;
    be.e2 = e2;

    Выражение результат;
    if (be.op == ТОК2.concatenateAssign)
        результат = be.op_overload(sc);
    else
        результат = be.trySemantic(sc);

    return результат;
}

/************************************
 * Operator overload.
 * Check for operator overload, if so, replace
 * with function call.
 * Параметры:
 *      e = Выражение with operator
 *      sc = context
 *      вынь = if not null, is set to the operator that was actually overloaded,
 *            which may not be `e.op`. Happens when operands are reversed to
 *            to match an overload
 * Возвращает:
 *      `null` if not an operator overload,
 *      otherwise the lowered Выражение
 */
Выражение op_overload(Выражение e, Scope* sc, ТОК2* вынь = null)
{
     final class OpOverload : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        Scope* sc;
        ТОК2* вынь;
        Выражение результат;

        this(Scope* sc, ТОК2* вынь)
        {
            this.sc = sc;
            this.вынь = вынь;
        }

        override проц посети(Выражение e)
        {
            assert(0);
        }

        override проц посети(UnaExp e)
        {
            //printf("UnaExp::op_overload() (%s)\n", e.вТкст0());
            if (e.e1.op == ТОК2.массив)
            {
                ArrayExp ae = cast(ArrayExp)e.e1;
                ae.e1 = ae.e1.ВыражениеSemantic(sc);
                ae.e1 = resolveProperties(sc, ae.e1);
                Выражение ae1old = ae.e1;
                const бул maybeSlice = (ae.arguments.dim == 0 || ae.arguments.dim == 1 && (*ae.arguments)[0].op == ТОК2.interval);
                IntervalExp ie = null;
                if (maybeSlice && ae.arguments.dim)
                {
                    assert((*ae.arguments)[0].op == ТОК2.interval);
                    ie = cast(IntervalExp)(*ae.arguments)[0];
                }
                while (да)
                {
                    if (ae.e1.op == ТОК2.error)
                    {
                        результат = ae.e1;
                        return;
                    }
                    Выражение e0 = null;
                    Выражение ae1save = ae.e1;
                    ae.lengthVar = null;
                    Тип t1b = ae.e1.тип.toBasetype();
                    AggregateDeclaration ad = isAggregate(t1b);
                    if (!ad)
                        break;
                    if (search_function(ad, Id.opIndexUnary))
                    {
                        // Deal with $
                        результат = resolveOpDollar(sc, ae, &e0);
                        if (!результат) // op(a[i..j]) might be: a.opSliceUnary!(op)(i, j)
                            goto Lfallback;
                        if (результат.op == ТОК2.error)
                            return;
                        /* Rewrite op(a[arguments]) as:
                         *      a.opIndexUnary!(op)(arguments)
                         */
                        Выражения* a = ae.arguments.копируй();
                        Объекты* tiargs = opToArg(sc, e.op);
                        результат = new DotTemplateInstanceExp(e.место, ae.e1, Id.opIndexUnary, tiargs);
                        результат = new CallExp(e.место, результат, a);
                        if (maybeSlice) // op(a[]) might be: a.opSliceUnary!(op)()
                            результат = результат.trySemantic(sc);
                        else
                            результат = результат.ВыражениеSemantic(sc);
                        if (результат)
                        {
                            результат = Выражение.combine(e0, результат);
                            return;
                        }
                    }
                Lfallback:
                    if (maybeSlice && search_function(ad, Id.opSliceUnary))
                    {
                        // Deal with $
                        результат = resolveOpDollar(sc, ae, ie, &e0);
                        if (результат.op == ТОК2.error)
                            return;
                        /* Rewrite op(a[i..j]) as:
                         *      a.opSliceUnary!(op)(i, j)
                         */
                        auto a = new Выражения();
                        if (ie)
                        {
                            a.сунь(ie.lwr);
                            a.сунь(ie.upr);
                        }
                        Объекты* tiargs = opToArg(sc, e.op);
                        результат = new DotTemplateInstanceExp(e.место, ae.e1, Id.opSliceUnary, tiargs);
                        результат = new CallExp(e.место, результат, a);
                        результат = результат.ВыражениеSemantic(sc);
                        результат = Выражение.combine(e0, результат);
                        return;
                    }
                    // Didn't найди it. Forward to aliasthis
                    if (ad.aliasthis && t1b != ae.att1)
                    {
                        if (!ae.att1 && t1b.checkAliasThisRec())
                            ae.att1 = t1b;
                        /* Rewrite op(a[arguments]) as:
                         *      op(a.aliasthis[arguments])
                         */
                        ae.e1 = resolveAliasThis(sc, ae1save, да);
                        if (ae.e1)
                            continue;
                    }
                    break;
                }
                ae.e1 = ae1old; // recovery
                ae.lengthVar = null;
            }
            e.e1 = e.e1.ВыражениеSemantic(sc);
            e.e1 = resolveProperties(sc, e.e1);
            if (e.e1.op == ТОК2.error)
            {
                результат = e.e1;
                return;
            }
            AggregateDeclaration ad = isAggregate(e.e1.тип);
            if (ad)
            {
                ДСимвол fd = null;
                /* Rewrite as:
                 *      e1.opUnary!(op)()
                 */
                fd = search_function(ad, Id.opUnary);
                if (fd)
                {
                    Объекты* tiargs = opToArg(sc, e.op);
                    результат = new DotTemplateInstanceExp(e.место, e.e1, fd.идент, tiargs);
                    результат = new CallExp(e.место, результат);
                    результат = результат.ВыражениеSemantic(sc);
                    return;
                }
                // D1-style operator overloads, deprecated
                if (e.op != ТОК2.prePlusPlus && e.op != ТОК2.preMinusMinus)
                {
                    auto ид = opId(e);
                    fd = search_function(ad, ид);
                    if (fd)
                    {
                        // @@@DEPRECATED_2.094@@@.
                        // Deprecated in 2.088
                        // Make an error in 2.094
                        e.deprecation("`%s` is deprecated.  Use `opUnary(ткст op)() if (op == \"%s\")` instead.", ид.вТкст0(), Сема2.вТкст0(e.op));
                        // Rewrite +e1 as e1.add()
                        результат = build_overload(e.место, sc, e.e1, null, fd);
                        return;
                    }
                }
                // Didn't найди it. Forward to aliasthis
                if (ad.aliasthis && e.e1.тип != e.att1)
                {
                    /* Rewrite op(e1) as:
                     *      op(e1.aliasthis)
                     */
                    //printf("att una %s e1 = %s\n", Сема2::вТкст0(op), this.e1.тип.вТкст0());
                    Выражение e1 = new DotIdExp(e.место, e.e1, ad.aliasthis.идент);
                    UnaExp ue = cast(UnaExp)e.копируй();
                    if (!ue.att1 && e.e1.тип.checkAliasThisRec())
                        ue.att1 = e.e1.тип;
                    ue.e1 = e1;
                    результат = ue.trySemantic(sc);
                    return;
                }
            }
        }

        override проц посети(ArrayExp ae)
        {
            //printf("ArrayExp::op_overload() (%s)\n", ae.вТкст0());
            ae.e1 = ae.e1.ВыражениеSemantic(sc);
            ae.e1 = resolveProperties(sc, ae.e1);
            Выражение ae1old = ae.e1;
            const бул maybeSlice = (ae.arguments.dim == 0 || ae.arguments.dim == 1 && (*ae.arguments)[0].op == ТОК2.interval);
            IntervalExp ie = null;
            if (maybeSlice && ae.arguments.dim)
            {
                assert((*ae.arguments)[0].op == ТОК2.interval);
                ie = cast(IntervalExp)(*ae.arguments)[0];
            }
            while (да)
            {
                if (ae.e1.op == ТОК2.error)
                {
                    результат = ae.e1;
                    return;
                }
                Выражение e0 = null;
                Выражение ae1save = ae.e1;
                ae.lengthVar = null;
                Тип t1b = ae.e1.тип.toBasetype();
                AggregateDeclaration ad = isAggregate(t1b);
                if (!ad)
                {
                    // If the non-aggregate Выражение ae.e1 is indexable or sliceable,
                    // convert it to the corresponding concrete Выражение.
                    if (isIndexableNonAggregate(t1b) || ae.e1.op == ТОК2.тип)
                    {
                        // Convert to SliceExp
                        if (maybeSlice)
                        {
                            результат = new SliceExp(ae.место, ae.e1, ie);
                            результат = результат.ВыражениеSemantic(sc);
                            return;
                        }
                        // Convert to IndexExp
                        if (ae.arguments.dim == 1)
                        {
                            результат = new IndexExp(ae.место, ae.e1, (*ae.arguments)[0]);
                            результат = результат.ВыражениеSemantic(sc);
                            return;
                        }
                    }
                    break;
                }
                if (search_function(ad, Id.index))
                {
                    // Deal with $
                    результат = resolveOpDollar(sc, ae, &e0);
                    if (!результат) // a[i..j] might be: a.opSlice(i, j)
                        goto Lfallback;
                    if (результат.op == ТОК2.error)
                        return;
                    /* Rewrite e1[arguments] as:
                     *      e1.opIndex(arguments)
                     */
                    Выражения* a = ae.arguments.копируй();
                    результат = new DotIdExp(ae.место, ae.e1, Id.index);
                    результат = new CallExp(ae.место, результат, a);
                    if (maybeSlice) // a[] might be: a.opSlice()
                        результат = результат.trySemantic(sc);
                    else
                        результат = результат.ВыражениеSemantic(sc);
                    if (результат)
                    {
                        результат = Выражение.combine(e0, результат);
                        return;
                    }
                }
            Lfallback:
                if (maybeSlice && ae.e1.op == ТОК2.тип)
                {
                    результат = new SliceExp(ae.место, ae.e1, ie);
                    результат = результат.ВыражениеSemantic(sc);
                    результат = Выражение.combine(e0, результат);
                    return;
                }
                if (maybeSlice && search_function(ad, Id.slice))
                {
                    // Deal with $
                    результат = resolveOpDollar(sc, ae, ie, &e0);
                    if (результат.op == ТОК2.error)
                        return;
                    /* Rewrite a[i..j] as:
                     *      a.opSlice(i, j)
                     */
                    auto a = new Выражения();
                    if (ie)
                    {
                        a.сунь(ie.lwr);
                        a.сунь(ie.upr);
                    }
                    результат = new DotIdExp(ae.место, ae.e1, Id.slice);
                    результат = new CallExp(ae.место, результат, a);
                    результат = результат.ВыражениеSemantic(sc);
                    результат = Выражение.combine(e0, результат);
                    return;
                }
                // Didn't найди it. Forward to aliasthis
                if (ad.aliasthis && t1b != ae.att1)
                {
                    if (!ae.att1 && t1b.checkAliasThisRec())
                        ae.att1 = t1b;
                    //printf("att arr e1 = %s\n", this.e1.тип.вТкст0());
                    /* Rewrite op(a[arguments]) as:
                     *      op(a.aliasthis[arguments])
                     */
                    ae.e1 = resolveAliasThis(sc, ae1save, да);
                    if (ae.e1)
                        continue;
                }
                break;
            }
            ae.e1 = ae1old; // recovery
            ae.lengthVar = null;
        }

        /***********************************************
         * This is mostly the same as UnaryExp::op_overload(), but has
         * a different rewrite.
         */
        override проц посети(CastExp e)
        {
            //printf("CastExp::op_overload() (%s)\n", e.вТкст0());
            AggregateDeclaration ad = isAggregate(e.e1.тип);
            if (ad)
            {
                ДСимвол fd = null;
                /* Rewrite as:
                 *      e1.opCast!(T)()
                 */
                fd = search_function(ad, Id._cast);
                if (fd)
                {
                    version (all)
                    {
                        // Backwards compatibility with D1 if opCast is a function, not a template
                        if (fd.isFuncDeclaration())
                        {
                            // Rewrite as:  e1.opCast()
                            результат = build_overload(e.место, sc, e.e1, null, fd);
                            return;
                        }
                    }
                    auto tiargs = new Объекты();
                    tiargs.сунь(e.to);
                    результат = new DotTemplateInstanceExp(e.место, e.e1, fd.идент, tiargs);
                    результат = new CallExp(e.место, результат);
                    результат = результат.ВыражениеSemantic(sc);
                    return;
                }
                // Didn't найди it. Forward to aliasthis
                if (ad.aliasthis)
                {
                    /* Rewrite op(e1) as:
                     *      op(e1.aliasthis)
                     */
                    Выражение e1 = resolveAliasThis(sc, e.e1);
                    результат = e.копируй();
                    (cast(UnaExp)результат).e1 = e1;
                    результат = результат.op_overload(sc);
                    return;
                }
            }
        }

        override проц посети(BinExp e)
        {
            //printf("BinExp::op_overload() (%s)\n", e.вТкст0());
            Идентификатор2 ид = opId(e);
            Идентификатор2 id_r = opId_r(e);
            Выражения args1;
            Выражения args2;
            цел argsset = 0;
            AggregateDeclaration ad1 = isAggregate(e.e1.тип);
            AggregateDeclaration ad2 = isAggregate(e.e2.тип);
            if (e.op == ТОК2.assign && ad1 == ad2)
            {
                StructDeclaration sd = ad1.isStructDeclaration();
                if (sd && !sd.hasIdentityAssign)
                {
                    /* This is bitwise struct assignment. */
                    return;
                }
            }
            ДСимвол s = null;
            ДСимвол s_r = null;
            Объекты* tiargs = null;
            if (e.op == ТОК2.plusPlus || e.op == ТОК2.minusMinus)
            {
                // Bug4099 fix
                if (ad1 && search_function(ad1, Id.opUnary))
                    return;
            }
            if (e.op != ТОК2.equal && e.op != ТОК2.notEqual && e.op != ТОК2.assign && e.op != ТОК2.plusPlus && e.op != ТОК2.minusMinus)
            {
                /* Try opBinary and opBinaryRight
                 */
                if (ad1)
                {
                    s = search_function(ad1, Id.opBinary);
                    if (s && !s.isTemplateDeclaration())
                    {
                        e.e1.выведиОшибку("`%s.opBinary` isn't a template", e.e1.вТкст0());
                        результат = new ErrorExp();
                        return;
                    }
                }
                if (ad2)
                {
                    s_r = search_function(ad2, Id.opBinaryRight);
                    if (s_r && !s_r.isTemplateDeclaration())
                    {
                        e.e2.выведиОшибку("`%s.opBinaryRight` isn't a template", e.e2.вТкст0());
                        результат = new ErrorExp();
                        return;
                    }
                    if (s_r && s_r == s) // https://issues.dlang.org/show_bug.cgi?ид=12778
                        s_r = null;
                }
                // Set tiargs, the template argument list, which will be the operator ткст
                if (s || s_r)
                {
                    ид = Id.opBinary;
                    id_r = Id.opBinaryRight;
                    tiargs = opToArg(sc, e.op);
                }
            }
            if (!s && !s_r)
            {
                // Try the D1-style operators, deprecated
                if (ad1 && ид)
                {
                    s = search_function(ad1, ид);
                    if (s && ид != Id.assign)
                    {
                        // @@@DEPRECATED_2.094@@@.
                        // Deprecated in 2.088
                        // Make an error in 2.094
                        if (ид == Id.postinc || ид == Id.postdec)
                            e.deprecation("`%s` is deprecated.  Use `opUnary(ткст op)() if (op == \"%s\")` instead.", ид.вТкст0(), Сема2.вТкст0(e.op));
                        else
                            e.deprecation("`%s` is deprecated.  Use `opBinary(ткст op)(...) if (op == \"%s\")` instead.", ид.вТкст0(), Сема2.вТкст0(e.op));
                    }
                }
                if (ad2 && id_r)
                {
                    s_r = search_function(ad2, id_r);
                    // https://issues.dlang.org/show_bug.cgi?ид=12778
                    // If both x.opBinary(y) and y.opBinaryRight(x) found,
                    // and they are exactly same symbol, x.opBinary(y) should be preferred.
                    if (s_r && s_r == s)
                        s_r = null;
                    if (s_r)
                    {
                        // @@@DEPRECATED_2.094@@@.
                        // Deprecated in 2.088
                        // Make an error in 2.094
                        e.deprecation("`%s` is deprecated.  Use `opBinaryRight(ткст op)(...) if (op == \"%s\")` instead.", id_r.вТкст0(), Сема2.вТкст0(e.op));
                    }
                }
            }
            if (s || s_r)
            {
                /* Try:
                 *      a.opfunc(b)
                 *      b.opfunc_r(a)
                 * and see which is better.
                 */
                args1.устДим(1);
                args1[0] = e.e1;
                expandTuples(&args1);
                args2.устДим(1);
                args2[0] = e.e2;
                expandTuples(&args2);
                argsset = 1;
                MatchAccumulator m;
                if (s)
                {
                    functionResolve(m, s, e.место, sc, tiargs, e.e1.тип, &args2);
                    if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                    {
                        результат = new ErrorExp();
                        return;
                    }
                }
                FuncDeclaration lastf = m.lastf;
                if (s_r)
                {
                    functionResolve(m, s_r, e.место, sc, tiargs, e.e2.тип, &args1);
                    if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                    {
                        результат = new ErrorExp();
                        return;
                    }
                }
                if (m.count > 1)
                {
                    // Error, ambiguous
                    e.выведиОшибку("overloads `%s` and `%s` both match argument list for `%s`", m.lastf.тип.вТкст0(), m.nextf.тип.вТкст0(), m.lastf.вТкст0());
                }
                else if (m.last <= MATCH.nomatch)
                {
                    if (tiargs)
                        goto L1;
                    m.lastf = null;
                }
                if (e.op == ТОК2.plusPlus || e.op == ТОК2.minusMinus)
                {
                    // Kludge because operator overloading regards e++ and e--
                    // as unary, but it's implemented as a binary.
                    // Rewrite (e1 ++ e2) as e1.postinc()
                    // Rewrite (e1 -- e2) as e1.postdec()
                    результат = build_overload(e.место, sc, e.e1, null, m.lastf ? m.lastf : s);
                }
                else if (lastf && m.lastf == lastf || !s_r && m.last <= MATCH.nomatch)
                {
                    // Rewrite (e1 op e2) as e1.opfunc(e2)
                    результат = build_overload(e.место, sc, e.e1, e.e2, m.lastf ? m.lastf : s);
                }
                else
                {
                    // Rewrite (e1 op e2) as e2.opfunc_r(e1)
                    результат = build_overload(e.место, sc, e.e2, e.e1, m.lastf ? m.lastf : s_r);
                }
                return;
            }
        L1:
            version (all)
            {
                // Retained for D1 compatibility
                if (isCommutative(e.op) && !tiargs)
                {
                    s = null;
                    s_r = null;
                    if (ad1 && id_r)
                    {
                        s_r = search_function(ad1, id_r);
                    }
                    if (ad2 && ид)
                    {
                        s = search_function(ad2, ид);
                        if (s && s == s_r) // https://issues.dlang.org/show_bug.cgi?ид=12778
                            s = null;
                    }
                    if (s || s_r)
                    {
                        /* Try:
                         *  a.opfunc_r(b)
                         *  b.opfunc(a)
                         * and see which is better.
                         */
                        if (!argsset)
                        {
                            args1.устДим(1);
                            args1[0] = e.e1;
                            expandTuples(&args1);
                            args2.устДим(1);
                            args2[0] = e.e2;
                            expandTuples(&args2);
                        }
                        MatchAccumulator m;
                        if (s_r)
                        {
                            functionResolve(m, s_r, e.место, sc, tiargs, e.e1.тип, &args2);
                            if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                            {
                                результат = new ErrorExp();
                                return;
                            }
                        }
                        FuncDeclaration lastf = m.lastf;
                        if (s)
                        {
                            functionResolve(m, s, e.место, sc, tiargs, e.e2.тип, &args1);
                            if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                            {
                                результат = new ErrorExp();
                                return;
                            }
                        }
                        if (m.count > 1)
                        {
                            // Error, ambiguous
                            e.выведиОшибку("overloads `%s` and `%s` both match argument list for `%s`", m.lastf.тип.вТкст0(), m.nextf.тип.вТкст0(), m.lastf.вТкст0());
                        }
                        else if (m.last <= MATCH.nomatch)
                        {
                            m.lastf = null;
                        }

                        if (lastf && m.lastf == lastf || !s && m.last <= MATCH.nomatch)
                        {
                            // Rewrite (e1 op e2) as e1.opfunc_r(e2)
                            результат = build_overload(e.место, sc, e.e1, e.e2, m.lastf ? m.lastf : s_r);
                        }
                        else
                        {
                            // Rewrite (e1 op e2) as e2.opfunc(e1)
                            результат = build_overload(e.место, sc, e.e2, e.e1, m.lastf ? m.lastf : s);
                        }
                        // When reversing operands of comparison operators,
                        // need to reverse the sense of the op
                        if (вынь)
                            *вынь = reverseRelation(e.op);
                        return;
                    }
                }
            }

            Выражение tempрезультат;
            if (!(e.op == ТОК2.assign && ad2 && ad1 == ad2)) // https://issues.dlang.org/show_bug.cgi?ид=2943
            {
                результат = checkAliasThisForLhs(ad1, sc, e);
                if (результат)
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=19441
                     *
                     * alias this may not be используется for partial assignment.
                     * If a struct has a single member which is aliased this
                     * directly or aliased to a ref getter function that returns
                     * the mentioned member, then alias this may be
                     * используется since the объект will be fully initialised.
                     * If the struct is nested, the context pointer is considered
                     * one of the члены, hence the `ad1.fields.dim == 2 && ad1.vthis`
                     * условие.
                     */
                    if (e.op != ТОК2.assign || e.e1.op == ТОК2.тип)
                        return;

                    if (ad1.fields.dim == 1 || (ad1.fields.dim == 2 && ad1.vthis))
                    {
                        auto var = ad1.aliasthis.sym.isVarDeclaration();
                        if (var && var.тип == ad1.fields[0].тип)
                            return;

                        auto func = ad1.aliasthis.sym.isFuncDeclaration();
                        auto tf = cast(TypeFunction)(func.тип);
                        if (tf.isref && ad1.fields[0].тип == tf.следщ)
                            return;
                    }
                    tempрезультат = результат;
                }
            }
            if (!(e.op == ТОК2.assign && ad1 && ad1 == ad2)) // https://issues.dlang.org/show_bug.cgi?ид=2943
            {
                результат = checkAliasThisForRhs(ad2, sc, e);
                if (результат)
                    return;
            }

            // @@@DEPRECATED_2019-02@@@
            // 1. Deprecation for 1 year
            // 2. Turn to error after
            if (tempрезультат)
            {
                // move this line where tempрезультат is assigned to результат and turn to error when derecation period is over
                e.deprecation("Cannot use `alias this` to partially initialize variable `%s` of тип `%s`. Use `%s`", e.e1.вТкст0(), ad1.вТкст0(), (cast(BinExp)tempрезультат).e1.вТкст0());
                // delete this line when deprecation period is over
                результат = tempрезультат;
            }
        }

        override проц посети(EqualExp e)
        {
            //printf("EqualExp::op_overload() (%s)\n", e.вТкст0());
            Тип t1 = e.e1.тип.toBasetype();
            Тип t2 = e.e2.тип.toBasetype();

            /* Check for массив equality.
             */
            if ((t1.ty == Tarray || t1.ty == Tsarray) &&
                (t2.ty == Tarray || t2.ty == Tsarray))
            {
                бул needsDirectEq()
                {
                    Тип t1n = t1.nextOf().toBasetype();
                    Тип t2n = t2.nextOf().toBasetype();
                    if (((t1n.ty == Tchar || t1n.ty == Twchar || t1n.ty == Tdchar) &&
                         (t2n.ty == Tchar || t2n.ty == Twchar || t2n.ty == Tdchar)) ||
                        (t1n.ty == Tvoid || t2n.ty == Tvoid))
                    {
                        return нет;
                    }
                    if (t1n.constOf() != t2n.constOf())
                        return да;

                    Тип t = t1n;
                    while (t.toBasetype().nextOf())
                        t = t.nextOf().toBasetype();
                    if (t.ty != Tstruct)
                        return нет;

                    if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
                        semanticTypeInfo(sc, t);

                    return (cast(TypeStruct)t).sym.hasIdentityEquals;
                }

                if (needsDirectEq() && !(t1.ty == Tarray && t2.ty == Tarray))
                {
                    /* Rewrite as:
                     *      __МассивEq(e1, e2)
                     */
                    Выражение eeq = new IdentifierExp(e.место, Id.__МассивEq);
                    результат = new CallExp(e.место, eeq, e.e1, e.e2);
                    if (e.op == ТОК2.notEqual)
                        результат = new NotExp(e.место, результат);
                    результат = результат.trySemantic(sc); // for better error message
                    if (!результат)
                    {
                        e.выведиОшибку("cannot compare `%s` and `%s`", t1.вТкст0(), t2.вТкст0());
                        результат = new ErrorExp();
                    }
                    return;
                }
            }

            /* Check for class equality with null literal or typeof(null).
             */
            if (t1.ty == Tclass && e.e2.op == ТОК2.null_ ||
                t2.ty == Tclass && e.e1.op == ТОК2.null_)
            {
                e.выведиОшибку("use `%s` instead of `%s` when comparing with `null`",
                    Сема2.вТкст0(e.op == ТОК2.equal ? ТОК2.identity : ТОК2.notIdentity),
                    Сема2.вТкст0(e.op));
                результат = new ErrorExp();
                return;
            }
            if (t1.ty == Tclass && t2.ty == Tnull ||
                t1.ty == Tnull && t2.ty == Tclass)
            {
                // Comparing a class with typeof(null) should not call opEquals
                return;
            }

            /* Check for class equality.
             */
            if (t1.ty == Tclass && t2.ty == Tclass)
            {
                ClassDeclaration cd1 = t1.isClassHandle();
                ClassDeclaration cd2 = t2.isClassHandle();
                if (!(cd1.classKind == ClassKind.cpp || cd2.classKind == ClassKind.cpp))
                {
                    /* Rewrite as:
                     *      .объект.opEquals(e1, e2)
                     */
                    Выражение e1x = e.e1;
                    Выражение e2x = e.e2;

                    /* The explicit cast is necessary for interfaces
                     * https://issues.dlang.org/show_bug.cgi?ид=4088
                     */
                    Тип to = ClassDeclaration.объект.getType();
                    if (cd1.isInterfaceDeclaration())
                        e1x = new CastExp(e.место, e.e1, t1.isMutable() ? to : to.constOf());
                    if (cd2.isInterfaceDeclaration())
                        e2x = new CastExp(e.место, e.e2, t2.isMutable() ? to : to.constOf());

                    результат = new IdentifierExp(e.место, Id.empty);
                    результат = new DotIdExp(e.место, результат, Id.объект);
                    результат = new DotIdExp(e.место, результат, Id.eq);
                    результат = new CallExp(e.место, результат, e1x, e2x);
                    if (e.op == ТОК2.notEqual)
                        результат = new NotExp(e.место, результат);
                    результат = результат.ВыражениеSemantic(sc);
                    return;
                }
            }

            результат = compare_overload(e, sc, Id.eq, null);
            if (результат)
            {
                if (результат.op == ТОК2.call && e.op == ТОК2.notEqual)
                {
                    результат = new NotExp(результат.место, результат);
                    результат = результат.ВыражениеSemantic(sc);
                }
                return;
            }

            if (t1.ty == Tarray && t2.ty == Tarray)
                return;

            /* Check for pointer equality.
             */
            if (t1.ty == Tpointer || t2.ty == Tpointer)
            {
                /* Rewrite:
                 *      ptr1 == ptr2
                 * as:
                 *      ptr1 is ptr2
                 *
                 * This is just a rewriting for deterministic AST representation
                 * as the backend input.
                 */
                auto op2 = e.op == ТОК2.equal ? ТОК2.identity : ТОК2.notIdentity;
                результат = new IdentityExp(op2, e.место, e.e1, e.e2);
                результат = результат.ВыражениеSemantic(sc);
                return;
            }

            /* Check for struct equality without opEquals.
             */
            if (t1.ty == Tstruct && t2.ty == Tstruct)
            {
                auto sd = (cast(TypeStruct)t1).sym;
                if (sd != (cast(TypeStruct)t2).sym)
                    return;

//                import dmd.clone : needOpEquals;
                if (!глоб2.парамы.fieldwise && !needOpEquals(sd))
                {
                    // Use bitwise equality.
                    auto op2 = e.op == ТОК2.equal ? ТОК2.identity : ТОК2.notIdentity;
                    результат = new IdentityExp(op2, e.место, e.e1, e.e2);
                    результат = результат.ВыражениеSemantic(sc);
                    return;
                }

                /* Do memberwise equality.
                 * https://dlang.org/spec/Выражение.html#equality_Выражениеs
                 * Rewrite:
                 *      e1 == e2
                 * as:
                 *      e1.tupleof == e2.tupleof
                 *
                 * If sd is a nested struct, and if it's nested in a class, it will
                 * also compare the родитель class's equality. Otherwise, compares
                 * the identity of родитель context through ук.
                 */
                if (e.att1 && t1 == e.att1) return;
                if (e.att2 && t2 == e.att2) return;

                e = cast(EqualExp)e.копируй();
                if (!e.att1) e.att1 = t1;
                if (!e.att2) e.att2 = t2;
                e.e1 = new DotIdExp(e.место, e.e1, Id._tupleof);
                e.e2 = new DotIdExp(e.место, e.e2, Id._tupleof);

                auto sc2 = sc.сунь();
                sc2.flags = (sc2.flags & ~SCOPE.onlysafeaccess) | SCOPE.noaccesscheck;
                результат = e.ВыражениеSemantic(sc2);
                sc2.вынь();

                /* https://issues.dlang.org/show_bug.cgi?ид=15292
                 * if the rewrite результат is same with the original,
                 * the equality is unresolvable because it has recursive definition.
                 */
                if (результат.op == e.op &&
                    (cast(EqualExp)результат).e1.тип.toBasetype() == t1)
                {
                    e.выведиОшибку("cannot compare `%s` because its auto generated member-wise equality has recursive definition",
                        t1.вТкст0());
                    результат = new ErrorExp();
                }
                return;
            }

            /* Check for кортеж equality.
             */
            if (e.e1.op == ТОК2.кортеж && e.e2.op == ТОК2.кортеж)
            {
                auto tup1 = cast(TupleExp)e.e1;
                auto tup2 = cast(TupleExp)e.e2;
                т_мера dim = tup1.exps.dim;
                if (dim != tup2.exps.dim)
                {
                    e.выведиОшибку("mismatched кортеж lengths, `%d` and `%d`",
                        cast(цел)dim, cast(цел)tup2.exps.dim);
                    результат = new ErrorExp();
                    return;
                }

                if (dim == 0)
                {
                    // нуль-length кортеж comparison should always return да or нет.
                    результат = IntegerExp.createBool(e.op == ТОК2.equal);
                }
                else
                {
                    for (т_мера i = 0; i < dim; i++)
                    {
                        auto ex1 = (*tup1.exps)[i];
                        auto ex2 = (*tup2.exps)[i];
                        auto eeq = new EqualExp(e.op, e.место, ex1, ex2);
                        eeq.att1 = e.att1;
                        eeq.att2 = e.att2;

                        if (!результат)
                            результат = eeq;
                        else if (e.op == ТОК2.equal)
                            результат = new LogicalExp(e.место, ТОК2.andAnd, результат, eeq);
                        else
                            результат = new LogicalExp(e.место, ТОК2.orOr, результат, eeq);
                    }
                    assert(результат);
                }
                результат = Выражение.combine(tup1.e0, tup2.e0, результат);
                результат = результат.ВыражениеSemantic(sc);

                return;
            }
        }

        override проц посети(CmpExp e)
        {
            //printf("CmpExp:: () (%s)\n", e.вТкст0());
            результат = compare_overload(e, sc, Id.cmp, вынь);
        }

        /*********************************
         * Operator overloading for op=
         */
        override проц посети(BinAssignExp e)
        {
            //printf("BinAssignExp::op_overload() (%s)\n", e.вТкст0());
            if (e.e1.op == ТОК2.массив)
            {
                ArrayExp ae = cast(ArrayExp)e.e1;
                ae.e1 = ae.e1.ВыражениеSemantic(sc);
                ae.e1 = resolveProperties(sc, ae.e1);
                Выражение ae1old = ae.e1;
                const бул maybeSlice = (ae.arguments.dim == 0 || ae.arguments.dim == 1 && (*ae.arguments)[0].op == ТОК2.interval);
                IntervalExp ie = null;
                if (maybeSlice && ae.arguments.dim)
                {
                    assert((*ae.arguments)[0].op == ТОК2.interval);
                    ie = cast(IntervalExp)(*ae.arguments)[0];
                }
                while (да)
                {
                    if (ae.e1.op == ТОК2.error)
                    {
                        результат = ae.e1;
                        return;
                    }
                    Выражение e0 = null;
                    Выражение ae1save = ae.e1;
                    ae.lengthVar = null;
                    Тип t1b = ae.e1.тип.toBasetype();
                    AggregateDeclaration ad = isAggregate(t1b);
                    if (!ad)
                        break;
                    if (search_function(ad, Id.opIndexOpAssign))
                    {
                        // Deal with $
                        результат = resolveOpDollar(sc, ae, &e0);
                        if (!результат) // (a[i..j] op= e2) might be: a.opSliceOpAssign!(op)(e2, i, j)
                            goto Lfallback;
                        if (результат.op == ТОК2.error)
                            return;
                        результат = e.e2.ВыражениеSemantic(sc);
                        if (результат.op == ТОК2.error)
                            return;
                        e.e2 = результат;
                        /* Rewrite a[arguments] op= e2 as:
                         *      a.opIndexOpAssign!(op)(e2, arguments)
                         */
                        Выражения* a = ae.arguments.копируй();
                        a.вставь(0, e.e2);
                        Объекты* tiargs = opToArg(sc, e.op);
                        результат = new DotTemplateInstanceExp(e.место, ae.e1, Id.opIndexOpAssign, tiargs);
                        результат = new CallExp(e.место, результат, a);
                        if (maybeSlice) // (a[] op= e2) might be: a.opSliceOpAssign!(op)(e2)
                            результат = результат.trySemantic(sc);
                        else
                            результат = результат.ВыражениеSemantic(sc);
                        if (результат)
                        {
                            результат = Выражение.combine(e0, результат);
                            return;
                        }
                    }
                Lfallback:
                    if (maybeSlice && search_function(ad, Id.opSliceOpAssign))
                    {
                        // Deal with $
                        результат = resolveOpDollar(sc, ae, ie, &e0);
                        if (результат.op == ТОК2.error)
                            return;
                        результат = e.e2.ВыражениеSemantic(sc);
                        if (результат.op == ТОК2.error)
                            return;
                        e.e2 = результат;
                        /* Rewrite (a[i..j] op= e2) as:
                         *      a.opSliceOpAssign!(op)(e2, i, j)
                         */
                        auto a = new Выражения();
                        a.сунь(e.e2);
                        if (ie)
                        {
                            a.сунь(ie.lwr);
                            a.сунь(ie.upr);
                        }
                        Объекты* tiargs = opToArg(sc, e.op);
                        результат = new DotTemplateInstanceExp(e.место, ae.e1, Id.opSliceOpAssign, tiargs);
                        результат = new CallExp(e.место, результат, a);
                        результат = результат.ВыражениеSemantic(sc);
                        результат = Выражение.combine(e0, результат);
                        return;
                    }
                    // Didn't найди it. Forward to aliasthis
                    if (ad.aliasthis && t1b != ae.att1)
                    {
                        if (!ae.att1 && t1b.checkAliasThisRec())
                            ae.att1 = t1b;
                        /* Rewrite (a[arguments] op= e2) as:
                         *      a.aliasthis[arguments] op= e2
                         */
                        ae.e1 = resolveAliasThis(sc, ae1save, да);
                        if (ae.e1)
                            continue;
                    }
                    break;
                }
                ae.e1 = ae1old; // recovery
                ae.lengthVar = null;
            }
            результат = e.binSemanticProp(sc);
            if (результат)
                return;
            // Don't attempt 'alias this' if an error occurred
            if (e.e1.тип.ty == Terror || e.e2.тип.ty == Terror)
            {
                результат = new ErrorExp();
                return;
            }
            Идентификатор2 ид = opId(e);
            Выражения args2;
            AggregateDeclaration ad1 = isAggregate(e.e1.тип);
            ДСимвол s = null;
            Объекты* tiargs = null;
            /* Try opOpAssign
             */
            if (ad1)
            {
                s = search_function(ad1, Id.opOpAssign);
                if (s && !s.isTemplateDeclaration())
                {
                    e.выведиОшибку("`%s.opOpAssign` isn't a template", e.e1.вТкст0());
                    результат = new ErrorExp();
                    return;
                }
            }
            // Set tiargs, the template argument list, which will be the operator ткст
            if (s)
            {
                ид = Id.opOpAssign;
                tiargs = opToArg(sc, e.op);
            }

            // Try D1-style operator overload, deprecated
            if (!s && ad1 && ид)
            {
                s = search_function(ad1, ид);
                if (s)
                {
                    // @@@DEPRECATED_2.094@@@.
                    // Deprecated in 2.088
                    // Make an error in 2.094
                    scope ткст op = Сема2.вТкст(e.op).dup;
                    op[$-1] = '\0'; // удали trailing `=`
                    e.deprecation("`%s` is deprecated.  Use `opOpAssign(ткст op)(...) if (op == \"%s\")` instead.", ид.вТкст0(), op.ptr);
                }
            }

            if (s)
            {
                /* Try:
                 *      a.opOpAssign(b)
                 */
                args2.устДим(1);
                args2[0] = e.e2;
                expandTuples(&args2);
                MatchAccumulator m;
                if (s)
                {
                    functionResolve(m, s, e.место, sc, tiargs, e.e1.тип, &args2);
                    if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                    {
                        результат = new ErrorExp();
                        return;
                    }
                }
                if (m.count > 1)
                {
                    // Error, ambiguous
                    e.выведиОшибку("overloads `%s` and `%s` both match argument list for `%s`", m.lastf.тип.вТкст0(), m.nextf.тип.вТкст0(), m.lastf.вТкст0());
                }
                else if (m.last <= MATCH.nomatch)
                {
                    if (tiargs)
                        goto L1;
                    m.lastf = null;
                }
                // Rewrite (e1 op e2) as e1.opOpAssign(e2)
                результат = build_overload(e.место, sc, e.e1, e.e2, m.lastf ? m.lastf : s);
                return;
            }
        L1:
            результат = checkAliasThisForLhs(ad1, sc, e);
            if (результат || !s) // no point in trying Rhs alias-this if there's no overload of any вид in lhs
                return;

            результат = checkAliasThisForRhs(isAggregate(e.e2.тип), sc, e);
        }
    }

    if (вынь)
        *вынь = e.op;
    scope OpOverload v = new OpOverload(sc, вынь);
    e.прими(v);
    return v.результат;
}

/******************************************
 * Common code for overloading of EqualExp and CmpExp
 */
private Выражение compare_overload(BinExp e, Scope* sc, Идентификатор2 ид, ТОК2* вынь)
{
    //printf("BinExp::compare_overload(ид = %s) %s\n", ид.вТкст0(), e.вТкст0());
    AggregateDeclaration ad1 = isAggregate(e.e1.тип);
    AggregateDeclaration ad2 = isAggregate(e.e2.тип);
    ДСимвол s = null;
    ДСимвол s_r = null;
    if (ad1)
    {
        s = search_function(ad1, ид);
    }
    if (ad2)
    {
        s_r = search_function(ad2, ид);
        if (s == s_r)
            s_r = null;
    }
    Объекты* tiargs = null;
    if (s || s_r)
    {
        /* Try:
         *      a.opEquals(b)
         *      b.opEquals(a)
         * and see which is better.
         */
        Выражения args1 = Выражения(1);
        args1[0] = e.e1;
        expandTuples(&args1);
        Выражения args2 = Выражения(1);
        args2[0] = e.e2;
        expandTuples(&args2);
        MatchAccumulator m;
        if (0 && s && s_r)
        {
            printf("s  : %s\n", s.toPrettyChars());
            printf("s_r: %s\n", s_r.toPrettyChars());
        }
        if (s)
        {
            functionResolve(m, s, e.место, sc, tiargs, e.e1.тип, &args2);
            if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                return new ErrorExp();
        }
        FuncDeclaration lastf = m.lastf;
        цел count = m.count;
        if (s_r)
        {
            functionResolve(m, s_r, e.место, sc, tiargs, e.e2.тип, &args1);
            if (m.lastf && (m.lastf.errors || m.lastf.semantic3Errors))
                return new ErrorExp();
        }
        if (m.count > 1)
        {
            /* The following if says "not ambiguous" if there's one match
             * from s and one from s_r, in which case we pick s.
             * This doesn't follow the spec, but is a workaround for the case
             * where opEquals was generated from templates and we cannot figure
             * out if both s and s_r came from the same declaration or not.
             * The test case is:
             *   import std.typecons;
             *   проц main() {
             *    assert(кортеж("has a", 2u) == кортеж("has a", 1));
             *   }
             */
            if (!(m.lastf == lastf && m.count == 2 && count == 1))
            {
                // Error, ambiguous
                e.выведиОшибку("overloads `%s` and `%s` both match argument list for `%s`", m.lastf.тип.вТкст0(), m.nextf.тип.вТкст0(), m.lastf.вТкст0());
            }
        }
        else if (m.last <= MATCH.nomatch)
        {
            m.lastf = null;
        }
        Выражение результат;
        if (lastf && m.lastf == lastf || !s_r && m.last <= MATCH.nomatch)
        {
            // Rewrite (e1 op e2) as e1.opfunc(e2)
            результат = build_overload(e.место, sc, e.e1, e.e2, m.lastf ? m.lastf : s);
        }
        else
        {
            // Rewrite (e1 op e2) as e2.opfunc_r(e1)
            результат = build_overload(e.место, sc, e.e2, e.e1, m.lastf ? m.lastf : s_r);
            // When reversing operands of comparison operators,
            // need to reverse the sense of the op
            if (вынь)
                *вынь = reverseRelation(e.op);
        }
        return результат;
    }
    /*
     * https://issues.dlang.org/show_bug.cgi?ид=16657
     * at this point, no matching opEquals was found for structs,
     * so we should not follow the alias this comparison code.
     */
    if ((e.op == ТОК2.equal || e.op == ТОК2.notEqual) && ad1 == ad2)
        return null;
    Выражение результат = checkAliasThisForLhs(ad1, sc, e);
    return результат ? результат : checkAliasThisForRhs(isAggregate(e.e2.тип), sc, e);
}

/***********************************
 * Utility to build a function call out of this reference and argument.
 */
Выражение build_overload(ref Место место, Scope* sc, Выражение ethis, Выражение earg, ДСимвол d)
{
    assert(d);
    Выражение e;
    Declaration decl = d.isDeclaration();
    if (decl)
        e = new DotVarExp(место, ethis, decl, нет);
    else
        e = new DotIdExp(место, ethis, d.идент);
    e = new CallExp(место, e, earg);
    e = e.ВыражениеSemantic(sc);
    return e;
}

/***************************************
 * Search for function funcid in aggregate ad.
 */
ДСимвол search_function(ScopeDsymbol ad, Идентификатор2 funcid)
{
    ДСимвол s = ad.search(Место.initial, funcid);
    if (s)
    {
        //printf("search_function: s = '%s'\n", s.вид());
        ДСимвол s2 = s.toAlias();
        //printf("search_function: s2 = '%s'\n", s2.вид());
        FuncDeclaration fd = s2.isFuncDeclaration();
        if (fd && fd.тип.ty == Tfunction)
            return fd;
        TemplateDeclaration td = s2.isTemplateDeclaration();
        if (td)
            return td;
    }
    return null;
}

/**************************************
 * Figure out what is being foreach'd over by looking at the ForeachAggregate.
 * Параметры:
 *      sc = context
 *      isForeach = да for foreach, нет for foreach_reverse
 *      feaggr = ForeachAggregate
 *      sapply = set to function opApply/opApplyReverse, or delegate, or null.
 *               Overload resolution is not done.
 * Возвращает:
 *      да if successfully figured it out; feaggr updated with semantic analysis.
 *      нет for failed, which is an error.
 */
бул inferForeachAggregate(Scope* sc, бул isForeach, ref Выражение feaggr, out ДСимвол sapply)
{
    //printf("inferForeachAggregate(%s)\n", feaggr.вТкст0());
    бул sliced;
    Тип att = null;
    auto aggr = feaggr;
    while (1)
    {
        aggr = aggr.ВыражениеSemantic(sc);
        aggr = resolveProperties(sc, aggr);
        aggr = aggr.optimize(WANTvalue);
        if (!aggr.тип || aggr.op == ТОК2.error)
            return нет;
        Тип tab = aggr.тип.toBasetype();
        switch (tab.ty)
        {
        case Tarray:            // https://dlang.org/spec/инструкция.html#foreach_over_arrays
        case Tsarray:           // https://dlang.org/spec/инструкция.html#foreach_over_arrays
        case Ttuple:            // https://dlang.org/spec/инструкция.html#foreach_over_tuples
        case Taarray:           // https://dlang.org/spec/инструкция.html#foreach_over_associative_arrays
            break;

        case Tclass:
        case Tstruct:
        {
            AggregateDeclaration ad = (tab.ty == Tclass) ? (cast(TypeClass)tab).sym
                                                         : (cast(TypeStruct)tab).sym;
            if (!sliced)
            {
                sapply = search_function(ad, isForeach ? Id.apply : Id.applyReverse);
                if (sapply)
                {
                    // https://dlang.org/spec/инструкция.html#foreach_over_struct_and_classes
                    // opApply aggregate
                    break;
                }
                if (feaggr.op != ТОК2.тип)
                {
                    /* See if rewriting `aggr` to `aggr[]` will work
                     */
                    Выражение rinit = new ArrayExp(aggr.место, feaggr);
                    rinit = rinit.trySemantic(sc);
                    if (rinit) // if it worked
                    {
                        aggr = rinit;
                        sliced = да;  // only try it once
                        continue;
                    }
                }
            }
            if (ad.search(Место.initial, isForeach ? Id.Ffront : Id.Fback))
            {
                // https://dlang.org/spec/инструкция.html#foreach-with-ranges
                // range aggregate
                break;
            }
            if (ad.aliasthis)
            {
                if (att == tab)         // error, circular alias this
                    return нет;
                if (!att && tab.checkAliasThisRec())
                    att = tab;
                aggr = resolveAliasThis(sc, aggr);
                continue;
            }
            return нет;
        }

        case Tdelegate:        // https://dlang.org/spec/инструкция.html#foreach_over_delegates
            if (aggr.op == ТОК2.delegate_)
            {
                sapply = (cast(DelegateExp)aggr).func;
            }
            break;

        case Terror:
            break;

        default:
            return нет;
        }
        feaggr = aggr;
        return да;
    }
    assert(0);
}

/*****************************************
 * Given массив of foreach parameters and an aggregate тип,
 * найди best opApply overload,
 * if any of the параметр types are missing, attempt to infer
 * them from the aggregate тип.
 * Параметры:
 *      fes = the foreach инструкция
 *      sc = context
 *      sapply = null or opApply or delegate
 * Возвращает:
 *      нет for errors
 */
бул inferApplyArgTypes(ForeachStatement fes, Scope* sc, ref ДСимвол sapply)
{
    if (!fes.parameters || !fes.parameters.dim)
        return нет;
    if (sapply) // prefer opApply
    {
        foreach (Параметр2 p; *fes.parameters)
        {
            if (p.тип)
            {
                p.тип = p.тип.typeSemantic(fes.место, sc);
                p.тип = p.тип.addStorageClass(p.классХранения);
            }
        }

        // Determine ethis for sapply
        Выражение ethis;
        Тип tab = fes.aggr.тип.toBasetype();
        if (tab.ty == Tclass || tab.ty == Tstruct)
            ethis = fes.aggr;
        else
        {
            assert(tab.ty == Tdelegate && fes.aggr.op == ТОК2.delegate_);
            ethis = (cast(DelegateExp)fes.aggr).e1;
        }

        /* Look for like an
         *  цел opApply(цел delegate(ref Тип [, ...]) dg);
         * overload
         */
        if (FuncDeclaration fd = sapply.isFuncDeclaration())
        {
            auto fdapply = findBestOpApplyMatch(ethis, fd, fes.parameters);
            if (fdapply)
            {
                // Fill in any missing types on foreach parameters[]
                matchParamsToOpApply(cast(TypeFunction)fdapply.тип, fes.parameters, да);
                sapply = fdapply;
                return да;
            }
            return нет;
        }
        return sapply !is null;
    }

    Параметр2 p = (*fes.parameters)[0];
    Тип taggr = fes.aggr.тип;
    assert(taggr);
    Тип tab = taggr.toBasetype();
    switch (tab.ty)
    {
    case Tarray:
    case Tsarray:
    case Ttuple:
        if (fes.parameters.dim == 2)
        {
            if (!p.тип)
            {
                p.тип = Тип.tт_мера; // ключ тип
                p.тип = p.тип.addStorageClass(p.классХранения);
            }
            p = (*fes.parameters)[1];
        }
        if (!p.тип && tab.ty != Ttuple)
        {
            p.тип = tab.nextOf(); // значение тип
            p.тип = p.тип.addStorageClass(p.классХранения);
        }
        break;

    case Taarray:
        {
            TypeAArray taa = cast(TypeAArray)tab;
            if (fes.parameters.dim == 2)
            {
                if (!p.тип)
                {
                    p.тип = taa.index; // ключ тип
                    p.тип = p.тип.addStorageClass(p.классХранения);
                    if (p.классХранения & STC.ref_) // ключ must not be mutated via ref
                        p.тип = p.тип.addMod(MODFlags.const_);
                }
                p = (*fes.parameters)[1];
            }
            if (!p.тип)
            {
                p.тип = taa.следщ; // значение тип
                p.тип = p.тип.addStorageClass(p.классХранения);
            }
            break;
        }

    case Tclass:
    case Tstruct:
    {
        AggregateDeclaration ad = (tab.ty == Tclass) ? (cast(TypeClass)tab).sym
                                                     : (cast(TypeStruct)tab).sym;
        if (fes.parameters.dim == 1)
        {
            if (!p.тип)
            {
                /* Look for a front() or back() overload
                 */
                Идентификатор2 ид = (fes.op == ТОК2.foreach_) ? Id.Ffront : Id.Fback;
                ДСимвол s = ad.search(Место.initial, ид);
                FuncDeclaration fd = s ? s.isFuncDeclaration() : null;
                if (fd)
                {
                    // Resolve inout qualifier of front тип
                    p.тип = fd.тип.nextOf();
                    if (p.тип)
                    {
                        p.тип = p.тип.substWildTo(tab.mod);
                        p.тип = p.тип.addStorageClass(p.классХранения);
                    }
                }
                else if (s && s.isTemplateDeclaration())
                {
                }
                else if (s && s.isDeclaration())
                    p.тип = (cast(Declaration)s).тип;
                else
                    break;
            }
            break;
        }
        break;
    }

    case Tdelegate:
        if (!matchParamsToOpApply(cast(TypeFunction)tab.nextOf(), fes.parameters, да))
            return нет;
        break;

    default:
        break; // ignore error, caught later
    }
    return да;
}

/*********************************************
 * Find best overload match on fstart given ethis and parameters[].
 * Параметры:
 *      ethis = Выражение to use for `this`
 *      fstart = opApply or foreach delegate
 *      parameters = ForeachTypeList (i.e. foreach parameters)
 * Возвращает:
 *      best match if there is one, null if error
 */
private FuncDeclaration findBestOpApplyMatch(Выражение ethis, FuncDeclaration fstart, Параметры* parameters)
{
    MOD mod = ethis.тип.mod;
    MATCH match = MATCH.nomatch;
    FuncDeclaration fd_best;
    FuncDeclaration fd_ambig;

    overloadApply(fstart, (ДСимвол s)
    {
        auto f = s.isFuncDeclaration();
        if (!f)
            return 0;           // continue
        auto tf = cast(TypeFunction)f.тип;
        MATCH m = MATCH.exact;
        if (f.isThis())
        {
            if (!MODimplicitConv(mod, tf.mod))
                m = MATCH.nomatch;
            else if (mod != tf.mod)
                m = MATCH.constant;
        }
        if (!matchParamsToOpApply(tf, parameters, нет))
            m = MATCH.nomatch;
        if (m > match)
        {
            fd_best = f;
            fd_ambig = null;
            match = m;
        }
        else if (m == match && m > MATCH.nomatch)
        {
            assert(fd_best);
            /* Ignore covariant matches, as later on it can be redone
             * after the opApply delegate has its attributes inferred.
             */
            if (tf.covariant(fd_best.тип) != 1 &&
                fd_best.тип.covariant(tf) != 1)
                fd_ambig = f;                           // not covariant, so ambiguous
        }
        return 0;               // continue
    });

    if (fd_ambig)
    {
        .выведиОшибку(ethis.место, "`%s.%s` matches more than one declaration:\n`%s`:     `%s`\nand:\n`%s`:     `%s`",
            ethis.вТкст0(), fstart.идент.вТкст0(),
            fd_best.место.вТкст0(), fd_best.тип.вТкст0(),
            fd_ambig.место.вТкст0(), fd_ambig.тип.вТкст0());
        return null;
    }

    return fd_best;
}

/******************************
 * Determine if foreach parameters match opApply parameters.
 * Infer missing foreach параметр types from тип of opApply delegate.
 * Параметры:
 *      tf = тип of opApply or delegate
 *      parameters = foreach parameters
 *      infer = infer missing параметр types
 * Возвращает:
 *      да for match for this function
 *      нет for no match for this function
 */
private бул matchParamsToOpApply(TypeFunction tf, Параметры* parameters, бул infer)
{
    const nomatch = нет;

    /* opApply/delegate has exactly one параметр, and that параметр
     * is a delegate that looks like:
     *     цел opApply(цел delegate(ref Тип [, ...]) dg);
     */
    if (tf.parameterList.length != 1)
        return nomatch;

    /* Get the тип of opApply's dg параметр
     */
    Параметр2 p0 = tf.parameterList[0];
    if (p0.тип.ty != Tdelegate)
        return nomatch;
    TypeFunction tdg = cast(TypeFunction)p0.тип.nextOf();
    assert(tdg.ty == Tfunction);

    /* We now have tdg, the тип of the delegate.
     * tdg's parameters must match that of the foreach arglist (i.e. parameters).
     * Fill in missing types in parameters.
     */
    const nparams = tdg.parameterList.length;
    if (nparams == 0 || nparams != parameters.dim || tdg.parameterList.varargs != ВарАрг.none)
        return nomatch; // параметр mismatch

    foreach (u, p; *parameters)
    {
        Параметр2 param = tdg.parameterList[u];
        if (p.тип)
        {
            if (!p.тип.равен(param.тип))
                return nomatch;
        }
        else if (infer)
        {
            p.тип = param.тип;
            p.тип = p.тип.addStorageClass(p.классХранения);
        }
    }
    return да;
}

/**
 * Reverse relational operator, eg >= becomes <=
 * Note this is not negation.
 * Параметры:
 *      op = comparison operator to reverse
 * Возвращает:
 *      reverse of op
 */
private ТОК2 reverseRelation(ТОК2 op) 
{
    switch (op)
    {
        case ТОК2.greaterOrEqual:  op = ТОК2.lessOrEqual;    break;
        case ТОК2.greaterThan:     op = ТОК2.lessThan;       break;
        case ТОК2.lessOrEqual:     op = ТОК2.greaterOrEqual; break;
        case ТОК2.lessThan:        op = ТОК2.greaterThan;    break;
        default:                  break;
    }
    return op;
}
