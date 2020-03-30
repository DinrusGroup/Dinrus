/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/optimize.d, _optimize.d)
 * Documentation:  https://dlang.org/phobos/dmd_optimize.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/optimize.d
 */

module dmd.optimize;

import cidrus;

import dmd.constfold;
import dmd.ctfeexpr;
import dmd.dclass;
import dmd.declaration;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import dmd.init;
import dmd.mtype;
import util.ctfloat;
import dmd.sideeffect;
import drc.lexer.Tokens;
import drc.ast.Visitor;
//import core.checkedint : mulu;
import dmd.aggregate : Sizeok;
/*************************************
 * Если у переменной есть инициализатор const ,
 * вернуть этот инициализатор.
 * Возвращает:
 *      инициализатор, если он имеется,
 *      null, если его нет,
 *      ErrorExp, если ошибка
 */
Выражение expandVar(цел результат, VarDeclaration v)
{
    //printf("expandVar(результат = %d, v = %p, %s)\n", результат, v, v ? v.вТкст0() : "null");

    /********
     * Параметры:
     *  e = инициализатор Выражение
     */
    Выражение initializerReturn(Выражение e)
    {
        if (e.тип != v.тип)
        {
            e = e.castTo(null, v.тип);
        }
        v.inuse++;
        e = e.optimize(результат);
        v.inuse--;
        //if (e) printf("\te = %p, %s, e.тип = %d, %s\n", e, e.вТкст0(), e.тип.ty, e.тип.вТкст0());
        return e;
    }

    static Выражение nullReturn()
    {
        return null;
    }

    static Выражение errorReturn()
    {
        return new ErrorExp();
    }

    if (!v)
        return nullReturn();
    if (!v.originalType && v.semanticRun < PASS.semanticdone) // semantic() not yet run
        v.dsymbolSemantic(null);
    if (v.тип &&
        (v.isConst() || v.isImmutable() || v.класс_хранения & STC.manifest))
    {
        Тип tb = v.тип.toBasetype();
        if (v.класс_хранения & STC.manifest ||
            tb.isscalar() ||
            ((результат & WANTexpand) && (tb.ty != Tsarray && tb.ty != Tstruct)))
        {
            if (v._иниц)
            {
                if (v.inuse)
                {
                    if (v.класс_хранения & STC.manifest)
                    {
                        v.выведиОшибку("рекурсивная инициализация константы");
                        return errorReturn();
                    }
                    return nullReturn();
                }
                Выражение ei = v.getConstInitializer();
                if (!ei)
                {
                    if (v.класс_хранения & STC.manifest)
                    {
                        v.выведиОшибку("перечень не может инициализовываться с `%s`", v._иниц.вТкст0());
                        return errorReturn();
                    }
                    return nullReturn();
                }
                if (ei.op == ТОК2.construct || ei.op == ТОК2.blit)
                {
                    AssignExp ae = cast(AssignExp)ei;
                    ei = ae.e2;
                    if (ei.isConst() == 1)
                    {
                    }
                    else if (ei.op == ТОК2.string_)
                    {
                        // https://issues.dlang.org/show_bug.cgi?ид=14459
                        // Do not constfold the ткст literal
                        // if it's typed as a C ткст, because the значение expansion
                        // will drop the pointer identity.
                        if (!(результат & WANTexpand) && ei.тип.toBasetype().ty == Tpointer)
                            return nullReturn();
                    }
                    else
                        return nullReturn();
                    if (ei.тип == v.тип)
                    {
                        // const variable initialized with const Выражение
                    }
                    else if (ei.implicitConvTo(v.тип) >= MATCH.constant)
                    {
                        // const var initialized with non-const Выражение
                        ei = ei.implicitCastTo(null, v.тип);
                        ei = ei.ВыражениеSemantic(null);
                    }
                    else
                        return nullReturn();
                }
                else if (!(v.класс_хранения & STC.manifest) &&
                         ei.isConst() != 1 &&
                         ei.op != ТОК2.string_ &&
                         ei.op != ТОК2.address)
                {
                    return nullReturn();
                }

                if (!ei.тип)
                {
                    return nullReturn();
                }
                else
                {
                    // Should удали the копируй() operation by
                    // making all mods to Выражения копируй-on-пиши
                    return initializerReturn(ei.копируй());
                }
            }
            else
            {
                // v does not have an инициализатор
                version (all)
                {
                    return nullReturn();
                }
                else
                {
                    // BUG: what if const is initialized in constructor?
                    auto e = v.тип.defaultInit();
                    e.место = e1.место;
                    return initializerReturn(e);
                }
            }
            assert(0);
        }
    }
    return nullReturn();
}

private Выражение fromConstInitializer(цел результат, Выражение e1)
{
    //printf("fromConstInitializer(результат = %x, %s)\n", результат, e1.вТкст0());
    //static цел xx; if (xx++ == 10) assert(0);
    Выражение e = e1;
    if (e1.op == ТОК2.variable)
    {
        VarExp ve = cast(VarExp)e1;
        VarDeclaration v = ve.var.isVarDeclaration();
        e = expandVar(результат, v);
        if (e)
        {
            // If it is a comma Выражение involving a declaration, we mustn't
            // perform a копируй -- we'd get two declarations of the same variable.
            // See bugzilla 4465.
            if (e.op == ТОК2.comma && (cast(CommaExp)e).e1.op == ТОК2.declaration)
                e = e1;
            else if (e.тип != e1.тип && e1.тип && e1.тип.ty != Tident)
            {
                // Тип 'paint' operation
                e = e.копируй();
                e.тип = e1.тип;
            }
            e.место = e1.место;
        }
        else
        {
            e = e1;
        }
    }
    return e;
}

/* It is possible for constant folding to change an массив Выражение of
 * unknown length, into one where the length is known.
 * If the Выражение 'arr' is a literal, set lengthVar to be its length.
 */
package проц setLengthVarIfKnown(VarDeclaration lengthVar, Выражение arr)
{
    if (!lengthVar)
        return;
    if (lengthVar._иниц && !lengthVar._иниц.isVoidInitializer())
        return; // we have previously calculated the length
    т_мера len;
    if (arr.op == ТОК2.string_)
        len = (cast(StringExp)arr).len;
    else if (arr.op == ТОК2.arrayLiteral)
        len = (cast(ArrayLiteralExp)arr).elements.dim;
    else
    {
        Тип t = arr.тип.toBasetype();
        if (t.ty == Tsarray)
            len = cast(т_мера)(cast(TypeSArray)t).dim.toInteger();
        else
            return; // we don't know the length yet
    }
    Выражение dollar = new IntegerExp(Место.initial, len, Тип.tт_мера);
    lengthVar._иниц = new ExpInitializer(Место.initial, dollar);
    lengthVar.класс_хранения |= STC.static_ | STC.const_;
}

/* Same as above, but determines the length from 'тип'. */
package проц setLengthVarIfKnown(VarDeclaration lengthVar, Тип тип)
{
    if (!lengthVar)
        return;
    if (lengthVar._иниц && !lengthVar._иниц.isVoidInitializer())
        return; // we have previously calculated the length
    т_мера len;
    Тип t = тип.toBasetype();
    if (t.ty == Tsarray)
        len = cast(т_мера)(cast(TypeSArray)t).dim.toInteger();
    else
        return; // we don't know the length yet
    Выражение dollar = new IntegerExp(Место.initial, len, Тип.tт_мера);
    lengthVar._иниц = new ExpInitializer(Место.initial, dollar);
    lengthVar.класс_хранения |= STC.static_ | STC.const_;
}

/*********************************
 * Constant fold an Выражение.
 * Параметры:
 *      e = Выражение to const fold; this may get modified in-place
 *      результат = WANTvalue, WANTexpand, or both
 *      keepLvalue = `e` is an lvalue, and keep it as an lvalue since it is
 *                   an argument to a `ref` or `out` параметр, or the operand of `&` operator
 * Возвращает:
 *      Constant folded version of `e`
 */
Выражение Выражение_optimize(Выражение e, цел результат, бул keepLvalue)
{
     final class OptimizeVisitor : Визитор2
    {
        alias Визитор2.посети посети;

        Выражение ret;
        private const цел результат;
        private const бул keepLvalue;

        this(Выражение e, цел результат, бул keepLvalue)
        {
            this.ret = e;               // default результат is original Выражение
            this.результат = результат;
            this.keepLvalue = keepLvalue;
        }

        проц выведиОшибку()
        {
            ret = new ErrorExp();
        }

        бул expOptimize(ref Выражение e, цел flags, бул keepLvalue = нет)
        {
            if (!e)
                return нет;
            Выражение ex = Выражение_optimize(e, flags, keepLvalue);
            if (ex.op == ТОК2.error)
            {
                ret = ex; // store error результат
                return да;
            }
            else
            {
                e = ex; // modify original
                return нет;
            }
        }

        бул unaOptimize(UnaExp e, цел flags)
        {
            return expOptimize(e.e1, flags);
        }

        бул binOptimize(BinExp e, цел flags)
        {
            expOptimize(e.e1, flags);
            expOptimize(e.e2, flags);
            return ret.op == ТОК2.error;
        }

        override проц посети(Выражение e)
        {
            //printf("Выражение::optimize(результат = x%x) %s\n", результат, e.вТкст0());
        }

        override проц посети(VarExp e)
        {
            if (keepLvalue)
            {
                VarDeclaration v = e.var.isVarDeclaration();
                if (v && !(v.класс_хранения & STC.manifest))
                    return;
            }
            ret = fromConstInitializer(результат, e);
        }

        override проц посети(TupleExp e)
        {
            expOptimize(e.e0, WANTvalue);
            for (т_мера i = 0; i < e.exps.dim; i++)
            {
                expOptimize((*e.exps)[i], WANTvalue);
            }
        }

        override проц посети(ArrayLiteralExp e)
        {
            if (e.elements)
            {
                expOptimize(e.basis, результат & WANTexpand);
                for (т_мера i = 0; i < e.elements.dim; i++)
                {
                    expOptimize((*e.elements)[i], результат & WANTexpand);
                }
            }
        }

        override проц посети(AssocArrayLiteralExp e)
        {
            assert(e.keys.dim == e.values.dim);
            for (т_мера i = 0; i < e.keys.dim; i++)
            {
                expOptimize((*e.keys)[i], результат & WANTexpand);
                expOptimize((*e.values)[i], результат & WANTexpand);
            }
        }

        override проц посети(StructLiteralExp e)
        {
            if (e.stageflags & stageOptimize)
                return;
            цел old = e.stageflags;
            e.stageflags |= stageOptimize;
            if (e.elements)
            {
                for (т_мера i = 0; i < e.elements.dim; i++)
                {
                    expOptimize((*e.elements)[i], результат & WANTexpand);
                }
            }
            e.stageflags = old;
        }

        override проц посети(UnaExp e)
        {
            //printf("UnaExp::optimize() %s\n", e.вТкст0());
            if (unaOptimize(e, результат))
                return;
        }

        override проц посети(NegExp e)
        {
            if (unaOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1)
            {
                ret = Neg(e.тип, e.e1).копируй();
            }
        }

        override проц посети(ComExp e)
        {
            if (unaOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1)
            {
                ret = Com(e.тип, e.e1).копируй();
            }
        }

        override проц посети(NotExp e)
        {
            if (unaOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1)
            {
                ret = Not(e.тип, e.e1).копируй();
            }
        }

        override проц посети(SymOffExp e)
        {
            assert(e.var);
        }

        override проц посети(AddrExp e)
        {
            //printf("AddrExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            /* Rewrite &(a,b) as (a,&b)
             */
            if (e.e1.op == ТОК2.comma)
            {
                CommaExp ce = cast(CommaExp)e.e1;
                auto ae = new AddrExp(e.место, ce.e2, e.тип);
                ret = new CommaExp(ce.место, ce.e1, ae);
                ret.тип = e.тип;
                return;
            }
            // Keep lvalue-ness
            if (expOptimize(e.e1, результат, да))
                return;
            // Convert &*ex to ex
            if (e.e1.op == ТОК2.star)
            {
                Выражение ex = (cast(PtrExp)e.e1).e1;
                if (e.тип.равен(ex.тип))
                    ret = ex;
                else if (e.тип.toBasetype().equivalent(ex.тип.toBasetype()))
                {
                    ret = ex.копируй();
                    ret.тип = e.тип;
                }
                return;
            }
            if (e.e1.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)e.e1;
                if (!ve.var.isOut() && !ve.var.isRef() && !ve.var.isImportedSymbol())
                {
                    ret = new SymOffExp(e.место, ve.var, 0, ve.hasOverloads);
                    ret.тип = e.тип;
                    return;
                }
            }
            if (e.e1.op == ТОК2.index)
            {
                // Convert &массив[n] to &массив+n
                IndexExp ae = cast(IndexExp)e.e1;
                if (ae.e2.op == ТОК2.int64 && ae.e1.op == ТОК2.variable)
                {
                    sinteger_t index = ae.e2.toInteger();
                    VarExp ve = cast(VarExp)ae.e1;
                    if (ve.тип.ty == Tsarray && !ve.var.isImportedSymbol())
                    {
                        TypeSArray ts = cast(TypeSArray)ve.тип;
                        sinteger_t dim = ts.dim.toInteger();
                        if (index < 0 || index >= dim)
                        {
                            e.выведиОшибку("массив index %lld is out of bounds `[0..%lld]`", index, dim);
                            return выведиОшибку();
                        }

                        бул overflow;
                        const смещение = mulu(index, ts.nextOf().size(e.место), overflow);
                        if (overflow)
                        {
                            e.выведиОшибку("массив смещение overflow");
                            return выведиОшибку();
                        }

                        ret = new SymOffExp(e.место, ve.var, смещение);
                        ret.тип = e.тип;
                        return;
                    }
                }
            }
        }

        override проц посети(PtrExp e)
        {
            //printf("PtrExp::optimize(результат = x%x) %s\n", результат, e.вТкст0());
            if (expOptimize(e.e1, результат))
                return;
            // Convert *&ex to ex
            // But only if there is no тип punning involved
            if (e.e1.op == ТОК2.address)
            {
                Выражение ex = (cast(AddrExp)e.e1).e1;
                if (e.тип.равен(ex.тип))
                    ret = ex;
                else if (e.тип.toBasetype().equivalent(ex.тип.toBasetype()))
                {
                    ret = ex.копируй();
                    ret.тип = e.тип;
                }
            }
            if (keepLvalue)
                return;
            // Constant fold *(&structliteral + смещение)
            if (e.e1.op == ТОК2.add)
            {
                Выражение ex = Ptr(e.тип, e.e1).копируй();
                if (!CTFEExp.isCantExp(ex))
                {
                    ret = ex;
                    return;
                }
            }
            if (e.e1.op == ТОК2.symbolOffset)
            {
                SymOffExp se = cast(SymOffExp)e.e1;
                VarDeclaration v = se.var.isVarDeclaration();
                Выражение ex = expandVar(результат, v);
                if (ex && ex.op == ТОК2.structLiteral)
                {
                    StructLiteralExp sle = cast(StructLiteralExp)ex;
                    ex = sle.getField(e.тип, cast(бцел)se.смещение);
                    if (ex && !CTFEExp.isCantExp(ex))
                    {
                        ret = ex;
                        return;
                    }
                }
            }
        }

        override проц посети(DotVarExp e)
        {
            //printf("DotVarExp::optimize(результат = x%x) %s\n", результат, e.вТкст0());
            if (expOptimize(e.e1, результат))
                return;
            if (keepLvalue)
                return;
            Выражение ex = e.e1;
            if (ex.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)ex;
                VarDeclaration v = ve.var.isVarDeclaration();
                ex = expandVar(результат, v);
            }
            if (ex && ex.op == ТОК2.structLiteral)
            {
                StructLiteralExp sle = cast(StructLiteralExp)ex;
                VarDeclaration vf = e.var.isVarDeclaration();
                if (vf && !vf.overlapped)
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=13021
                     * Prevent optimization if vf has overlapped fields.
                     */
                    ex = sle.getField(e.тип, vf.смещение);
                    if (ex && !CTFEExp.isCantExp(ex))
                    {
                        ret = ex;
                        return;
                    }
                }
            }
        }

        override проц посети(NewExp e)
        {
            expOptimize(e.thisexp, WANTvalue);
            // Optimize parameters
            if (e.newargs)
            {
                for (т_мера i = 0; i < e.newargs.dim; i++)
                {
                    expOptimize((*e.newargs)[i], WANTvalue);
                }
            }
            if (e.arguments)
            {
                for (т_мера i = 0; i < e.arguments.dim; i++)
                {
                    expOptimize((*e.arguments)[i], WANTvalue);
                }
            }
        }

        override проц посети(CallExp e)
        {
            //printf("CallExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            // Optimize parameters with keeping lvalue-ness
            if (expOptimize(e.e1, результат))
                return;
            if (e.arguments)
            {
                Тип t1 = e.e1.тип.toBasetype();
                if (t1.ty == Tdelegate)
                    t1 = t1.nextOf();
                assert(t1.ty == Tfunction);
                TypeFunction tf = cast(TypeFunction)t1;
                for (т_мера i = 0; i < e.arguments.dim; i++)
                {
                    Параметр2 p = tf.parameterList[i];
                    бул keep = p && (p.классХранения & (STC.ref_ | STC.out_)) != 0;
                    expOptimize((*e.arguments)[i], WANTvalue, keep);
                }
            }
        }

        override проц посети(CastExp e)
        {
            //printf("CastExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            //printf("from %s to %s\n", e.тип.вТкст0(), e.to.вТкст0());
            //printf("from %s\n", e.тип.вТкст0());
            //printf("e1.тип %s\n", e.e1.тип.вТкст0());
            //printf("тип = %p\n", e.тип);
            assert(e.тип);
            ТОК2 op1 = e.e1.op;
            Выражение e1old = e.e1;
            if (expOptimize(e.e1, результат))
                return;
            e.e1 = fromConstInitializer(результат, e.e1);
            if (e.e1 == e1old && e.e1.op == ТОК2.arrayLiteral && e.тип.toBasetype().ty == Tpointer && e.e1.тип.toBasetype().ty != Tsarray)
            {
                // Casting this will результат in the same Выражение, and
                // infinite loop because of Выражение::implicitCastTo()
                return; // no change
            }
            if ((e.e1.op == ТОК2.string_ || e.e1.op == ТОК2.arrayLiteral) &&
                (e.тип.ty == Tpointer || e.тип.ty == Tarray))
            {
                const esz  = e.тип.nextOf().size(e.место);
                const e1sz = e.e1.тип.toBasetype().nextOf().size(e.e1.место);
                if (esz == SIZE_INVALID || e1sz == SIZE_INVALID)
                    return выведиОшибку();

                if (e1sz == esz)
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=12937
                    // If target тип is проц массив, trying to paint
                    // e.e1 with that тип will cause infinite recursive optimization.
                    if (e.тип.nextOf().ty == Tvoid)
                        return;
                    ret = e.e1.castTo(null, e.тип);
                    //printf(" returning1 %s\n", ret.вТкст0());
                    return;
                }
            }

            if (e.e1.op == ТОК2.structLiteral && e.e1.тип.implicitConvTo(e.тип) >= MATCH.constant)
            {
                //printf(" returning2 %s\n", e.e1.вТкст0());
            L1:
                // Returning e1 with changing its тип
                ret = (e1old == e.e1 ? e.e1.копируй() : e.e1);
                ret.тип = e.тип;
                return;
            }
            /* The first test here is to prevent infinite loops
             */
            if (op1 != ТОК2.arrayLiteral && e.e1.op == ТОК2.arrayLiteral)
            {
                ret = e.e1.castTo(null, e.to);
                return;
            }
            if (e.e1.op == ТОК2.null_ && (e.тип.ty == Tpointer || e.тип.ty == Tclass || e.тип.ty == Tarray))
            {
                //printf(" returning3 %s\n", e.e1.вТкст0());
                goto L1;
            }
            if (e.тип.ty == Tclass && e.e1.тип.ty == Tclass)
            {               

                // See if we can удали an unnecessary cast
                ClassDeclaration cdfrom = e.e1.тип.isClassHandle();
                ClassDeclaration cdto = e.тип.isClassHandle();
                if (cdto == ClassDeclaration.объект && !cdfrom.isInterfaceDeclaration())
                    goto L1;    // can always convert a class to Object
                // Need to determine correct смещение before optimizing away the cast.
                // https://issues.dlang.org/show_bug.cgi?ид=16980
                cdfrom.size(e.место);
                assert(cdfrom.sizeok == Sizeok.done);
                assert(cdto.sizeok == Sizeok.done || !cdto.isBaseOf(cdfrom, null));
                цел смещение;
                if (cdto.isBaseOf(cdfrom, &смещение) && смещение == 0)
                {
                    //printf(" returning4 %s\n", e.e1.вТкст0());
                    goto L1;
                }
            }
            // We can convert 'head const' to mutable
            if (e.to.mutableOf().constOf().равен(e.e1.тип.mutableOf().constOf()))
            {
                //printf(" returning5 %s\n", e.e1.вТкст0());
                goto L1;
            }
            if (e.e1.isConst())
            {
                if (e.e1.op == ТОК2.symbolOffset)
                {
                    if (e.тип.toBasetype().ty != Tsarray)
                    {
                        const esz = e.тип.size(e.место);
                        const e1sz = e.e1.тип.size(e.e1.место);
                        if (esz == SIZE_INVALID ||
                            e1sz == SIZE_INVALID)
                            return выведиОшибку();

                        if (esz == e1sz)
                            goto L1;
                    }
                    return;
                }
                if (e.to.toBasetype().ty != Tvoid)
                {
                    if (e.e1.тип.равен(e.тип) && e.тип.равен(e.to))
                        ret = e.e1;
                    else
                        ret = Cast(e.место, e.тип, e.to, e.e1).копируй();
                }
            }
            //printf(" returning6 %s\n", ret.вТкст0());
        }

        override проц посети(BinExp e)
        {
            //printf("BinExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            // don't replace const variable with its инициализатор in e1
            бул e2only = (e.op == ТОК2.construct || e.op == ТОК2.blit);
            if (e2only ? expOptimize(e.e2, результат) : binOptimize(e, результат))
                return;
            if (e.op == ТОК2.leftShiftAssign || e.op == ТОК2.rightShiftAssign || e.op == ТОК2.unsignedRightShiftAssign)
            {
                if (e.e2.isConst() == 1)
                {
                    sinteger_t i2 = e.e2.toInteger();
                    d_uns64 sz = e.e1.тип.size(e.e1.место);
                    assert(sz != SIZE_INVALID);
                    sz *= 8;
                    if (i2 < 0 || i2 >= sz)
                    {
                        e.выведиОшибку("shift assign by %lld is outside the range `0..%llu`", i2, cast(бдол)sz - 1);
                        return выведиОшибку();
                    }
                }
            }
        }

        override проц посети(AddExp e)
        {
            //printf("AddExp::optimize(%s)\n", e.вТкст0());
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() && e.e2.isConst())
            {
                if (e.e1.op == ТОК2.symbolOffset && e.e2.op == ТОК2.symbolOffset)
                    return;
                ret = Add(e.место, e.тип, e.e1, e.e2).копируй();
            }
        }

        override проц посети(MinExp e)
        {
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() && e.e2.isConst())
            {
                if (e.e2.op == ТОК2.symbolOffset)
                    return;
                ret = Min(e.место, e.тип, e.e1, e.e2).копируй();
            }
        }

        override проц посети(MulExp e)
        {
            //printf("MulExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
            {
                ret = Mul(e.место, e.тип, e.e1, e.e2).копируй();
            }
        }

        override проц посети(DivExp e)
        {
            //printf("DivExp::optimize(%s)\n", e.вТкст0());
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
            {
                ret = Div(e.место, e.тип, e.e1, e.e2).копируй();
            }
        }

        override проц посети(ModExp e)
        {
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
            {
                ret = Mod(e.место, e.тип, e.e1, e.e2).копируй();
            }
        }

        extern (D) проц shift_optimize(BinExp e, UnionExp function(ref Место, Тип, Выражение, Выражение) shift)
        {
            if (binOptimize(e, результат))
                return;
            if (e.e2.isConst() == 1)
            {
                sinteger_t i2 = e.e2.toInteger();
                d_uns64 sz = e.e1.тип.size(e.e1.место);
                assert(sz != SIZE_INVALID);
                sz *= 8;
                if (i2 < 0 || i2 >= sz)
                {
                    e.выведиОшибку("shift by %lld is outside the range `0..%llu`", i2, cast(бдол)sz - 1);
                    return выведиОшибку();
                }
                if (e.e1.isConst() == 1)
                    ret = (*shift)(e.место, e.тип, e.e1, e.e2).копируй();
            }
        }

        override проц посети(ShlExp e)
        {
            //printf("ShlExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            shift_optimize(e, &Shl);
        }

        override проц посети(ShrExp e)
        {
            //printf("ShrExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            shift_optimize(e, &Shr);
        }

        override проц посети(UshrExp e)
        {
            //printf("UshrExp::optimize(результат = %d) %s\n", результат, вТкст0());
            shift_optimize(e, &Ushr);
        }

        override проц посети(AndExp e)
        {
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
                ret = And(e.место, e.тип, e.e1, e.e2).копируй();
        }

        override проц посети(OrExp e)
        {
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
                ret = Or(e.место, e.тип, e.e1, e.e2).копируй();
        }

        override проц посети(XorExp e)
        {
            if (binOptimize(e, результат))
                return;
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
                ret = Xor(e.место, e.тип, e.e1, e.e2).копируй();
        }

        override проц посети(PowExp e)
        {
            if (binOptimize(e, результат))
                return;
            // All negative integral powers are illegal.
            if (e.e1.тип.isintegral() && (e.e2.op == ТОК2.int64) && cast(sinteger_t)e.e2.toInteger() < 0)
            {
                e.выведиОшибку("cannot raise `%s` to a negative integer power. Did you mean `(cast(real)%s)^^%s` ?", e.e1.тип.toBasetype().вТкст0(), e.e1.вТкст0(), e.e2.вТкст0());
                return выведиОшибку();
            }
            // If e2 *could* have been an integer, make it one.
            if (e.e2.op == ТОК2.float64 && e.e2.toReal() == real_t(cast(sinteger_t)e.e2.toReal()))
            {
                // This only applies to floating point, or positive integral powers.
                if (e.e1.тип.isfloating() || cast(sinteger_t)e.e2.toInteger() >= 0)
                    e.e2 = new IntegerExp(e.место, e.e2.toInteger(), Тип.tint64);
            }
            if (e.e1.isConst() == 1 && e.e2.isConst() == 1)
            {
                Выражение ex = Pow(e.место, e.тип, e.e1, e.e2).копируй();
                if (!CTFEExp.isCantExp(ex))
                {
                    ret = ex;
                    return;
                }
            }
        }

        override проц посети(CommaExp e)
        {
            //printf("CommaExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            // Comma needs special treatment, because it may
            // contain compiler-generated declarations. We can interpret them, but
            // otherwise we must NOT attempt to constant-fold them.
            // In particular, if the comma returns a temporary variable, it needs
            // to be an lvalue (this is particularly important for struct constructors)
            expOptimize(e.e1, WANTvalue);
            expOptimize(e.e2, результат, keepLvalue);
            if (ret.op == ТОК2.error)
                return;
            if (!e.e1 || e.e1.op == ТОК2.int64 || e.e1.op == ТОК2.float64 || !hasSideEffect(e.e1))
            {
                ret = e.e2;
                if (ret)
                    ret.тип = e.тип;
            }
            //printf("-CommaExp::optimize(результат = %d) %s\n", результат, e.e.вТкст0());
        }

        override проц посети(ArrayLengthExp e)
        {
            //printf("ArrayLengthExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            if (unaOptimize(e, WANTexpand))
                return;
            // CTFE interpret static const arrays (to get better diagnostics)
            if (e.e1.op == ТОК2.variable)
            {
                VarDeclaration v = (cast(VarExp)e.e1).var.isVarDeclaration();
                if (v && (v.класс_хранения & STC.static_) && (v.класс_хранения & STC.immutable_) && v._иниц)
                {
                    if (Выражение ci = v.getConstInitializer())
                        e.e1 = ci;
                }
            }
            if (e.e1.op == ТОК2.string_ || e.e1.op == ТОК2.arrayLiteral || e.e1.op == ТОК2.assocArrayLiteral || e.e1.тип.toBasetype().ty == Tsarray)
            {
                ret = ArrayLength(e.тип, e.e1).копируй();
            }
        }

        override проц посети(EqualExp e)
        {
            //printf("EqualExp::optimize(результат = %x) %s\n", результат, e.вТкст0());
            if (binOptimize(e, WANTvalue))
                return;
            Выражение e1 = fromConstInitializer(результат, e.e1);
            Выражение e2 = fromConstInitializer(результат, e.e2);
            if (e1.op == ТОК2.error)
            {
                ret = e1;
                return;
            }
            if (e2.op == ТОК2.error)
            {
                ret = e2;
                return;
            }
            ret = Equal(e.op, e.место, e.тип, e1, e2).копируй();
            if (CTFEExp.isCantExp(ret))
                ret = e;
        }

        override проц посети(IdentityExp e)
        {
            //printf("IdentityExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            if (binOptimize(e, WANTvalue))
                return;
            if ((e.e1.isConst() && e.e2.isConst()) || (e.e1.op == ТОК2.null_ && e.e2.op == ТОК2.null_))
            {
                ret = Identity(e.op, e.место, e.тип, e.e1, e.e2).копируй();
                if (CTFEExp.isCantExp(ret))
                    ret = e;
            }
        }

        override проц посети(IndexExp e)
        {
            //printf("IndexExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            if (expOptimize(e.e1, результат & WANTexpand))
                return;
            Выражение ex = fromConstInitializer(результат, e.e1);
            // We might know $ now
            setLengthVarIfKnown(e.lengthVar, ex);
            if (expOptimize(e.e2, WANTvalue))
                return;
            if (keepLvalue)
                return;
            ret = Index(e.тип, ex, e.e2).копируй();
            if (CTFEExp.isCantExp(ret))
                ret = e;
        }

        override проц посети(SliceExp e)
        {
            //printf("SliceExp::optimize(результат = %d) %s\n", результат, e.вТкст0());
            if (expOptimize(e.e1, результат & WANTexpand))
                return;
            if (!e.lwr)
            {
                if (e.e1.op == ТОК2.string_)
                {
                    // Convert slice of ткст literal into dynamic массив
                    Тип t = e.e1.тип.toBasetype();
                    if (Тип tn = t.nextOf())
                        ret = e.e1.castTo(null, tn.arrayOf());
                }
            }
            else
            {
                e.e1 = fromConstInitializer(результат, e.e1);
                // We might know $ now
                setLengthVarIfKnown(e.lengthVar, e.e1);
                expOptimize(e.lwr, WANTvalue);
                expOptimize(e.upr, WANTvalue);
                if (ret.op == ТОК2.error)
                    return;
                ret = Slice(e.тип, e.e1, e.lwr, e.upr).копируй();
                if (CTFEExp.isCantExp(ret))
                    ret = e;
            }
            // https://issues.dlang.org/show_bug.cgi?ид=14649
            // Leave the slice form so it might be
            // a part of массив operation.
            // Assume that the backend codegen will handle the form `e[]`
            // as an equal to `e` itself.
            if (ret.op == ТОК2.string_)
            {
                e.e1 = ret;
                e.lwr = null;
                e.upr = null;
                ret = e;
            }
            //printf("-SliceExp::optimize() %s\n", ret.вТкст0());
        }

        override проц посети(LogicalExp e)
        {
            //printf("LogicalExp::optimize(%d) %s\n", результат, e.вТкст0());
            if (expOptimize(e.e1, WANTvalue))
                return;
            const oror = e.op == ТОК2.orOr;
            if (e.e1.isBool(oror))
            {
                // Replace with (e1, oror)
                ret = IntegerExp.createBool(oror);
                ret = Выражение.combine(e.e1, ret);
                if (e.тип.toBasetype().ty == Tvoid)
                {
                    ret = new CastExp(e.место, ret, Тип.tvoid);
                    ret.тип = e.тип;
                }
                ret = Выражение_optimize(ret, результат, нет);
                return;
            }
            if (expOptimize(e.e2, WANTvalue))
                return;
            if (e.e1.isConst())
            {
                if (e.e2.isConst())
                {
                    бул n1 = e.e1.isBool(да);
                    бул n2 = e.e2.isBool(да);
                    ret = new IntegerExp(e.место, oror ? (n1 || n2) : (n1 && n2), e.тип);
                }
                else if (e.e1.isBool(!oror))
                {
                    if (e.тип.toBasetype().ty == Tvoid)
                        ret = e.e2;
                    else
                    {
                        ret = new CastExp(e.место, e.e2, e.тип);
                        ret.тип = e.тип;
                    }
                }
            }
        }

        override проц посети(CmpExp e)
        {
            //printf("CmpExp::optimize() %s\n", e.вТкст0());
            if (binOptimize(e, WANTvalue))
                return;
            Выражение e1 = fromConstInitializer(результат, e.e1);
            Выражение e2 = fromConstInitializer(результат, e.e2);
            ret = Cmp(e.op, e.место, e.тип, e1, e2).копируй();
            if (CTFEExp.isCantExp(ret))
                ret = e;
        }

        override проц посети(CatExp e)
        {
            //printf("CatExp::optimize(%d) %s\n", результат, e.вТкст0());
            if (binOptimize(e, результат))
                return;
            if (e.e1.op == ТОК2.concatenate)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=12798
                // optimize ((expr ~ str1) ~ str2)
                CatExp ce1 = cast(CatExp)e.e1;
                scope CatExp cex = new CatExp(e.место, ce1.e2, e.e2);
                cex.тип = e.тип;
                Выражение ex = Выражение_optimize(cex, результат, нет);
                if (ex != cex)
                {
                    e.e1 = ce1.e1;
                    e.e2 = ex;
                }
            }
            // optimize "str"[] -> "str"
            if (e.e1.op == ТОК2.slice)
            {
                SliceExp se1 = cast(SliceExp)e.e1;
                if (se1.e1.op == ТОК2.string_ && !se1.lwr)
                    e.e1 = se1.e1;
            }
            if (e.e2.op == ТОК2.slice)
            {
                SliceExp se2 = cast(SliceExp)e.e2;
                if (se2.e1.op == ТОК2.string_ && !se2.lwr)
                    e.e2 = se2.e1;
            }
            ret = Cat(e.тип, e.e1, e.e2).копируй();
            if (CTFEExp.isCantExp(ret))
                ret = e;
        }

        override проц посети(CondExp e)
        {
            if (expOptimize(e.econd, WANTvalue))
                return;
            if (e.econd.isBool(да))
                ret = Выражение_optimize(e.e1, результат, keepLvalue);
            else if (e.econd.isBool(нет))
                ret = Выражение_optimize(e.e2, результат, keepLvalue);
            else
            {
                expOptimize(e.e1, результат, keepLvalue);
                expOptimize(e.e2, результат, keepLvalue);
            }
        }
    }

    scope OptimizeVisitor v = new OptimizeVisitor(e, результат, keepLvalue);

    // Optimize the Выражение until it can no longer be simplified.
    т_мера b;
    while (1)
    {
        if (b++ == глоб2.recursionLimit)
        {
            e.выведиОшибку("infinite loop while optimizing Выражение");
            fatal();
        }
        auto ex = v.ret;
        ex.прими(v);
        if (ex == v.ret)
            break;
    }
    return v.ret;
}
