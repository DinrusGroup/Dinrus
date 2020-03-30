/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/sideeffect.d, _sideeffect.d)
 * Documentation:  https://dlang.org/phobos/dmd_sideeffect.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/sideeffect.d
 */

module dmd.sideeffect;

import dmd.apply;
import dmd.declaration;
import dmd.dscope;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import drc.lexer.Tokens;
import drc.ast.Visitor;

/**************************************************
 * Front-end Выражение rewriting should создай temporary variables for
 * non trivial sub-Выражения in order to:
 *  1. save evaluation order
 *  2. prevent sharing of sub-Выражение in AST
 */
 бул isTrivialExp(Выражение e)
{
     final class IsTrivialExp : StoppableVisitor
    {
        alias  typeof(super).посети посети ;
    public:
        this()
        {
        }

        override проц посети(Выражение e)
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=11201
             * CallExp is always non trivial Выражение,
             * especially for inlining.
             */
            if (e.op == ТОК2.call)
            {
                stop = да;
                return;
            }
            // stop walking if we determine this Выражение has side effects
            stop = lambdaHasSideEffect(e);
        }
    }

    scope IsTrivialExp v = new IsTrivialExp();
    return walkPostorder(e, v) == нет;
}

/********************************************
 * Determine if Выражение has any side effects.
 */
 бул hasSideEffect(Выражение e)
{
     final class LambdaHasSideEffect : StoppableVisitor
    {
        alias  typeof(super).посети посети ;
    public:
        this()
        {
        }

        override проц посети(Выражение e)
        {
            // stop walking if we determine this Выражение has side effects
            stop = lambdaHasSideEffect(e);
        }
    }

    scope LambdaHasSideEffect v = new LambdaHasSideEffect();
    return walkPostorder(e, v);
}

/********************************************
 * Determine if the call of f, or function тип or delegate тип t1, has any side effects.
 * Возвращает:
 *      0   has any side effects
 *      1    + constant purity
 *      2    + strong purity
 */
цел callSideEffectLevel(FuncDeclaration f)
{
    /* https://issues.dlang.org/show_bug.cgi?ид=12760
     * ctor call always has side effects.
     */
    if (f.isCtorDeclaration())
        return 0;
    assert(f.тип.ty == Tfunction);
    TypeFunction tf = cast(TypeFunction)f.тип;
    if (tf.isnothrow)
    {
        PURE purity = f.isPure();
        if (purity == PURE.strong)
            return 2;
        if (purity == PURE.const_)
            return 1;
    }
    return 0;
}

цел callSideEffectLevel(Тип t)
{
    t = t.toBasetype();
    TypeFunction tf;
    if (t.ty == Tdelegate)
        tf = cast(TypeFunction)(cast(TypeDelegate)t).следщ;
    else
    {
        assert(t.ty == Tfunction);
        tf = cast(TypeFunction)t;
    }
    if (!tf.isnothrow)  // function can throw
        return 0;

    tf.purityLevel();
    PURE purity = tf.purity;
    if (t.ty == Tdelegate && purity > PURE.weak)
    {
        if (tf.isMutable())
            purity = PURE.weak;
        else if (!tf.isImmutable())
            purity = PURE.const_;
    }

    if (purity == PURE.strong)
        return 2;
    if (purity == PURE.const_)
        return 1;
    return 0;
}

private бул lambdaHasSideEffect(Выражение e)
{
    switch (e.op)
    {
    // Sort the cases by most frequently используется first
    case ТОК2.assign:
    case ТОК2.plusPlus:
    case ТОК2.minusMinus:
    case ТОК2.declaration:
    case ТОК2.construct:
    case ТОК2.blit:
    case ТОК2.addAssign:
    case ТОК2.minAssign:
    case ТОК2.concatenateAssign:
    case ТОК2.concatenateElemAssign:
    case ТОК2.concatenateDcharAssign:
    case ТОК2.mulAssign:
    case ТОК2.divAssign:
    case ТОК2.modAssign:
    case ТОК2.leftShiftAssign:
    case ТОК2.rightShiftAssign:
    case ТОК2.unsignedRightShiftAssign:
    case ТОК2.andAssign:
    case ТОК2.orAssign:
    case ТОК2.xorAssign:
    case ТОК2.powAssign:
    case ТОК2.in_:
    case ТОК2.удали:
    case ТОК2.assert_:
    case ТОК2.halt:
    case ТОК2.delete_:
    case ТОК2.new_:
    case ТОК2.newAnonymousClass:
        return да;
    case ТОК2.call:
        {
            CallExp ce = cast(CallExp)e;
            /* Calling a function or delegate that is  
             * has no side effects.
             */
            if (ce.e1.тип)
            {
                Тип t = ce.e1.тип.toBasetype();
                if (t.ty == Tdelegate)
                    t = (cast(TypeDelegate)t).следщ;
                if (t.ty == Tfunction && (ce.f ? callSideEffectLevel(ce.f) : callSideEffectLevel(ce.e1.тип)) > 0)
                {
                }
                else
                    return да;
            }
            break;
        }
    case ТОК2.cast_:
        {
            CastExp ce = cast(CastExp)e;
            /* if:
             *  cast(classtype)func()  // because it may throw
             */
            if (ce.to.ty == Tclass && ce.e1.op == ТОК2.call && ce.e1.тип.ty == Tclass)
                return да;
            break;
        }
    default:
        break;
    }
    return нет;
}

/***********************************
 * The результат of this Выражение will be discarded.
 * Print error messages if the operation has no side effects (and hence is meaningless).
 * Возвращает:
 *      да if Выражение has no side effects
 */
бул discardValue(Выражение e)
{
    if (lambdaHasSideEffect(e)) // check side-effect shallowly
        return нет;
    switch (e.op)
    {
    case ТОК2.cast_:
        {
            CastExp ce = cast(CastExp)e;
            if (ce.to.равен(Тип.tvoid))
            {
                /*
                 * Don't complain about an Выражение with no effect if it was cast to проц
                 */
                return нет;
            }
            break; // complain
        }
    case ТОК2.error:
        return нет;
    case ТОК2.variable:
        {
            VarDeclaration v = (cast(VarExp)e).var.isVarDeclaration();
            if (v && (v.класс_хранения & STC.temp))
            {
                // https://issues.dlang.org/show_bug.cgi?ид=5810
                // Don't complain about an internal generated variable.
                return нет;
            }
            break;
        }
    case ТОК2.call:
        /* Issue 3882: */
        if (глоб2.парамы.warnings != DiagnosticReporting.off && !глоб2.gag)
        {
            CallExp ce = cast(CallExp)e;
            if (e.тип.ty == Tvoid)
            {
                /* Don't complain about calling проц-returning functions with no side-effect,
                 * because purity and  are inferred, and because some of the
                 * runtime library depends on it. Needs more investigation.
                 *
                 * One possible solution is to restrict this message to only be called in hierarchies that
                 * never call assert (and or not called from inside unittest blocks)
                 */
            }
            else if (ce.e1.тип)
            {
                Тип t = ce.e1.тип.toBasetype();
                if (t.ty == Tdelegate)
                    t = (cast(TypeDelegate)t).следщ;
                if (t.ty == Tfunction && (ce.f ? callSideEffectLevel(ce.f) : callSideEffectLevel(ce.e1.тип)) > 0)
                {
                    ткст0 s;
                    if (ce.f)
                        s = ce.f.toPrettyChars();
                    else if (ce.e1.op == ТОК2.star)
                    {
                        // print 'fp' if ce.e1 is (*fp)
                        s = (cast(PtrExp)ce.e1).e1.вТкст0();
                    }
                    else
                        s = ce.e1.вТкст0();
                    e.warning("calling %s without side effects discards return значение of тип %s, prepend a cast(проц) if intentional", s, e.тип.вТкст0());
                }
            }
        }
        return нет;
    case ТОК2.andAnd:
    case ТОК2.orOr:
        {
            LogicalExp aae = cast(LogicalExp)e;
            return discardValue(aae.e2);
        }
    case ТОК2.question:
        {
            CondExp ce = cast(CondExp)e;
            /* https://issues.dlang.org/show_bug.cgi?ид=6178
             * https://issues.dlang.org/show_bug.cgi?ид=14089
             * Either CondExp::e1 or e2 may have
             * redundant Выражение to make those types common. For example:
             *
             *  struct S { this(цел n); цел v; alias v this; }
             *  S[цел] aa;
             *  aa[1] = 0;
             *
             * The last assignment инструкция will be rewitten to:
             *
             *  1 in aa ? aa[1].значение = 0 : (aa[1] = 0, aa[1].this(0)).значение;
             *
             * The last DotVarExp is necessary to take assigned значение.
             *
             *  цел значение = (aa[1] = 0);    // значение = aa[1].значение
             *
             * To avoid нет error, discardValue() should be called only when
             * the both tops of e1 and e2 have actually no side effects.
             */
            if (!lambdaHasSideEffect(ce.e1) && !lambdaHasSideEffect(ce.e2))
            {
                return discardValue(ce.e1) |
                       discardValue(ce.e2);
            }
            return нет;
        }
    case ТОК2.comma:
        {
            CommaExp ce = cast(CommaExp)e;
            /* Check for compiler-generated code of the form  auto __tmp, e, __tmp;
             * In such cases, only check e for side effect (it's OK for __tmp to have
             * no side effect).
             * See https://issues.dlang.org/show_bug.cgi?ид=4231 for discussion
             */
            auto fc = firstComma(ce);
            if (fc.op == ТОК2.declaration && ce.e2.op == ТОК2.variable && (cast(DeclarationExp)fc).declaration == (cast(VarExp)ce.e2).var)
            {
                return нет;
            }
            // Don't check e1 until we cast(проц) the a,b code generation
            //discardValue(ce.e1);
            return discardValue(ce.e2);
        }
    case ТОК2.кортеж:
        /* Pass without complaint if any of the кортеж elements have side effects.
         * Ideally any кортеж elements with no side effects should raise an error,
         * this needs more investigation as to what is the right thing to do.
         */
        if (!hasSideEffect(e))
            break;
        return нет;
    default:
        break;
    }
    e.выведиОшибку("`%s` has no effect", e.вТкст0());
    return да;
}

/**************************************************
 * Build a temporary variable to копируй the значение of e into.
 * Параметры:
 *  stc = storage classes will be added to the made temporary variable
 *  имя = имя for temporary variable
 *  e = original Выражение
 * Возвращает:
 *  Newly created temporary variable.
 */
VarDeclaration copyToTemp(КлассХранения stc, ткст имя, Выражение e)
{
    assert(имя[0] == '_' && имя[1] == '_');
    auto vd = new VarDeclaration(e.место, e.тип,
        Идентификатор2.генерируйИд(имя),
        new ExpInitializer(e.место, e));
    vd.класс_хранения = stc | STC.temp | STC.ctfe; // temporary is always CTFEable
    return vd;
}

/**************************************************
 * Build a temporary variable to extract e's evaluation, if e is not trivial.
 * Параметры:
 *  sc = scope
 *  имя = имя for temporary variable
 *  e0 = a new side effect part will be appended to it.
 *  e = original Выражение
 *  alwaysCopy = if да, build new temporary variable even if e is trivial.
 * Возвращает:
 *  When e is trivial and alwaysCopy == нет, e itself is returned.
 *  Otherwise, a new VarExp is returned.
 * Note:
 *  e's lvalue-ness will be handled well by STC.ref_ or STC.rvalue.
 */
Выражение extractSideEffect(Scope* sc, ткст имя,
    ref Выражение e0, Выражение e, бул alwaysCopy = нет)
{
    //printf("extractSideEffect(e: %s)\n", e.вТкст0());

    /* The trouble here is that if CTFE is running, extracting the side effect
     * результатs in an assignment, and then the interpreter says it cannot evaluate the
     * side effect assignment variable. But we don't have to worry about side
     * effects in function calls anyway, because then they won't CTFE.
     * https://issues.dlang.org/show_bug.cgi?ид=17145
     */
    if (!alwaysCopy &&
        ((sc.flags & SCOPE.ctfe) ? !hasSideEffect(e) : isTrivialExp(e)))
        return e;

    auto vd = copyToTemp(0, имя, e);
    vd.класс_хранения |= e.isLvalue() ? STC.ref_ : STC.rvalue;

       auto rez = new DeclarationExp(vd.место, vd);
       e0 = Выражение.combine(e0, rez.ВыражениеSemantic(sc));

    auto rez = new VarExp(vd.место, vd);
    return rez.ВыражениеSemantic(sc);
}
