/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dcast.d, _dcast.d)
 * Documentation:  https://dlang.org/phobos/dmd_dcast.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dcast.d
 */

module dmd.dcast;

import cidrus;
import dmd.aggregate;
import dmd.aliasthis;
import dmd.arrayop;
import dmd.arraytypes;
import dmd.dclass;
import dmd.declaration;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.errors;
import dmd.escape;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.impcnvtab;
import drc.lexer.Id;
import dmd.init;
import dmd.intrange;
import dmd.mtype;
import dmd.opover;
import util.ctfloat;
import util.outbuffer;
import util.rmem;
import drc.lexer.Tokens;
import dmd.typesem;
import util.utf;
import drc.ast.Visitor;

const LOG = нет;

/**************************************
 * Do an implicit cast.
 * Issue error if it can't be done.
 */
Выражение implicitCastTo(Выражение e, Scope* sc, Тип t)
{
     final class ImplicitCastTo : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        Тип t;
        Scope* sc;
        Выражение результат;

        this(Scope* sc, Тип t)
        {
            this.sc = sc;
            this.t = t;
        }

        override проц посети(Выражение e)
        {
            //printf("Выражение.implicitCastTo(%s of тип %s) => %s\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());

            MATCH match = e.implicitConvTo(t);
            if (match)
            {
                if (match == MATCH.constant && (e.тип.constConv(t) || !e.isLvalue() && e.тип.equivalent(t)))
                {
                    /* Do not emit CastExp for const conversions and
                     * unique conversions on rvalue.
                     */
                    результат = e.копируй();
                    результат.тип = t;
                    return;
                }

                auto ad = isAggregate(e.тип);
                if (ad && ad.aliasthis)
                {
                    MATCH adMatch;
                    if (ad.тип.ty == Tstruct)
                        adMatch = (cast(TypeStruct)(ad.тип)).implicitConvToWithoutAliasThis(t);
                    else
                        adMatch = (cast(TypeClass)(ad.тип)).implicitConvToWithoutAliasThis(t);

                    if (!adMatch)
                    {
                        Тип tob = t.toBasetype();
                        Тип t1b = e.тип.toBasetype();
                        AggregateDeclaration toad = isAggregate(tob);
                        if (ad != toad)
                        {
                            if (t1b.ty == Tclass && tob.ty == Tclass)
                            {
                                ClassDeclaration t1cd = t1b.isClassHandle();
                                ClassDeclaration tocd = tob.isClassHandle();
                                цел смещение;
                                if (tocd.isBaseOf(t1cd, &смещение))
                                {
                                    результат = new CastExp(e.место, e, t);
                                    результат.тип = t;
                                    return;
                                }
                            }

                            /* Forward the cast to our alias this member, rewrite to:
                             *   cast(to)e1.aliasthis
                             */
                            результат = resolveAliasThis(sc, e);
                            результат = результат.castTo(sc, t);
                            return;
                       }
                    }
                }

                результат = e.castTo(sc, t);
                return;
            }

            результат = e.optimize(WANTvalue);
            if (результат != e)
            {
                результат.прими(this);
                return;
            }

            if (t.ty != Terror && e.тип.ty != Terror)
            {
                if (!t.deco)
                {
                    e.выведиОшибку("forward reference to тип `%s`", t.вТкст0());
                }
                else
                {
                    //printf("тип %p ty %d deco %p\n", тип, тип.ty, тип.deco);
                    //тип = тип.typeSemantic(место, sc);
                    //printf("тип %s t %s\n", тип.deco, t.deco);
                    auto ts = toAutoQualChars(e.тип, t);
                    e.выведиОшибку("cannot implicitly convert Выражение `%s` of тип `%s` to `%s`",
                        e.вТкст0(), ts[0], ts[1]);
                }
            }
            результат = new ErrorExp();
        }

        override проц посети(StringExp e)
        {
            //printf("StringExp::implicitCastTo(%s of тип %s) => %s\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            посети(cast(Выражение)e);
            if (результат.op == ТОК2.string_)
            {
                // Retain polysemous nature if it started out that way
                (cast(StringExp)результат).committed = e.committed;
            }
        }

        override проц посети(ErrorExp e)
        {
            результат = e;
        }

        override проц посети(FuncExp e)
        {
            //printf("FuncExp::implicitCastTo тип = %p %s, t = %s\n", e.тип, e.тип ? e.тип.вТкст0() : NULL, t.вТкст0());
            FuncExp fe;
            if (e.matchType(t, sc, &fe) > MATCH.nomatch)
            {
                результат = fe;
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(ArrayLiteralExp e)
        {
            посети(cast(Выражение)e);

            Тип tb = результат.тип.toBasetype();
            if (tb.ty == Tarray && глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
                semanticTypeInfo(sc, (cast(TypeDArray)tb).следщ);
        }

        override проц посети(SliceExp e)
        {
            посети(cast(Выражение)e);
            if (результат.op != ТОК2.slice)
                return;

            e = cast(SliceExp)результат;
            if (e.e1.op == ТОК2.arrayLiteral)
            {
                ArrayLiteralExp ale = cast(ArrayLiteralExp)e.e1;
                Тип tb = t.toBasetype();
                Тип tx;
                if (tb.ty == Tsarray)
                    tx = tb.nextOf().sarrayOf(ale.elements ? ale.elements.dim : 0);
                else
                    tx = tb.nextOf().arrayOf();
                e.e1 = ale.implicitCastTo(sc, tx);
            }
        }
    }

    scope ImplicitCastTo v = new ImplicitCastTo(sc, t);
    e.прими(v);
    return v.результат;
}

/*******************************************
 * Return MATCH уровень of implicitly converting e to тип t.
 * Don't do the actual cast; don't change e.
 */
MATCH implicitConvTo(Выражение e, Тип t)
{
     final class ImplicitConvTo : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        Тип t;
        MATCH результат;

        this(Тип t)
        {
            this.t = t;
            результат = MATCH.nomatch;
        }

        override проц посети(Выражение e)
        {
            version (none)
            {
                printf("Выражение::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            //static цел nest; if (++nest == 10) assert(0);
            if (t == Тип.terror)
                return;
            if (!e.тип)
            {
                e.выведиОшибку("`%s` is not an Выражение", e.вТкст0());
                e.тип = Тип.terror;
            }

            Выражение ex = e.optimize(WANTvalue);
            if (ex.тип.равен(t))
            {
                результат = MATCH.exact;
                return;
            }
            if (ex != e)
            {
                //printf("\toptimized to %s of тип %s\n", e.вТкст0(), e.тип.вТкст0());
                результат = ex.implicitConvTo(t);
                return;
            }

            MATCH match = e.тип.implicitConvTo(t);
            if (match != MATCH.nomatch)
            {
                результат = match;
                return;
            }

            /* See if we can do integral narrowing conversions
             */
            if (e.тип.isintegral() && t.isintegral() && e.тип.isTypeBasic() && t.isTypeBasic())
            {
                IntRange src = getIntRange(e);
                IntRange target = IntRange.fromType(t);
                if (target.содержит(src))
                {
                    результат = MATCH.convert;
                    return;
                }
            }
        }

        /******
         * Given Выражение e of тип t, see if we can implicitly convert e
         * to тип tprime, where tprime is тип t with mod bits added.
         * Возвращает:
         *      match уровень
         */
        static MATCH implicitMod(Выражение e, Тип t, MOD mod)
        {
            Тип tprime;
            if (t.ty == Tpointer)
                tprime = t.nextOf().castMod(mod).pointerTo();
            else if (t.ty == Tarray)
                tprime = t.nextOf().castMod(mod).arrayOf();
            else if (t.ty == Tsarray)
                tprime = t.nextOf().castMod(mod).sarrayOf(t.size() / t.nextOf().size());
            else
                tprime = t.castMod(mod);

            return e.implicitConvTo(tprime);
        }

        static MATCH implicitConvToAddMin(BinExp e, Тип t)
        {
            /* Is this (ptr +- смещение)? If so, then ask ptr
             * if the conversion can be done.
             * This is to support doing things like implicitly converting a mutable unique
             * pointer to an const pointer.
             */

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (typeb.ty != Tpointer || tb.ty != Tpointer)
                return MATCH.nomatch;

            Тип t1b = e.e1.тип.toBasetype();
            Тип t2b = e.e2.тип.toBasetype();
            if (t1b.ty == Tpointer && t2b.isintegral() && t1b.equivalent(tb))
            {
                // ptr + смещение
                // ptr - смещение
                MATCH m = e.e1.implicitConvTo(t);
                return (m > MATCH.constant) ? MATCH.constant : m;
            }
            if (t2b.ty == Tpointer && t1b.isintegral() && t2b.equivalent(tb))
            {
                // смещение + ptr
                MATCH m = e.e2.implicitConvTo(t);
                return (m > MATCH.constant) ? MATCH.constant : m;
            }

            return MATCH.nomatch;
        }

        override проц посети(AddExp e)
        {
            version (none)
            {
                printf("AddExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            посети(cast(Выражение)e);
            if (результат == MATCH.nomatch)
                результат = implicitConvToAddMin(e, t);
        }

        override проц посети(MinExp e)
        {
            version (none)
            {
                printf("MinExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            посети(cast(Выражение)e);
            if (результат == MATCH.nomatch)
                результат = implicitConvToAddMin(e, t);
        }

        override проц посети(IntegerExp e)
        {
            version (none)
            {
                printf("IntegerExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            MATCH m = e.тип.implicitConvTo(t);
            if (m >= MATCH.constant)
            {
                результат = m;
                return;
            }

            TY ty = e.тип.toBasetype().ty;
            TY toty = t.toBasetype().ty;
            TY oldty = ty;

            if (m == MATCH.nomatch && t.ty == Tenum)
                return;

            if (t.ty == Tvector)
            {
                TypeVector tv = cast(TypeVector)t;
                TypeBasic tb = tv.elementType();
                if (tb.ty == Tvoid)
                    return;
                toty = tb.ty;
            }

            switch (ty)
            {
            case Tbool:
            case Tint8:
            case Tchar:
            case Tuns8:
            case Tint16:
            case Tuns16:
            case Twchar:
                ty = Tint32;
                break;

            case Tdchar:
                ty = Tuns32;
                break;

            default:
                break;
            }

            // Only allow conversion if no change in значение
            const dinteger_t значение = e.toInteger();

            бул isLosslesslyConvertibleToFP(T)()
            {
                if (e.тип.isunsigned())
                {
                    const f = cast(T) значение;
                    return cast(dinteger_t) f == значение;
                }

                const f = cast(T) cast(sinteger_t) значение;
                return cast(sinteger_t) f == cast(sinteger_t) значение;
            }

            switch (toty)
            {
            case Tbool:
                if ((значение & 1) != значение)
                    return;
                break;

            case Tint8:
                if (ty == Tuns64 && значение & ~0x7FU)
                    return;
                else if (cast(byte)значение != значение)
                    return;
                break;

            case Tchar:
                if ((oldty == Twchar || oldty == Tdchar) && значение > 0x7F)
                    return;
                goto case Tuns8;
            case Tuns8:
                //printf("значение = %llu %llu\n", (dinteger_t)(unsigned сим)значение, значение);
                if (cast(ббайт)значение != значение)
                    return;
                break;

            case Tint16:
                if (ty == Tuns64 && значение & ~0x7FFFU)
                    return;
                else if (cast(short)значение != значение)
                    return;
                break;

            case Twchar:
                if (oldty == Tdchar && значение > 0xD7FF && значение < 0xE000)
                    return;
                goto case Tuns16;
            case Tuns16:
                if (cast(ushort)значение != значение)
                    return;
                break;

            case Tint32:
                if (ty == Tuns32)
                {
                }
                else if (ty == Tuns64 && значение & ~0x7FFFFFFFU)
                    return;
                else if (cast(цел)значение != значение)
                    return;
                break;

            case Tuns32:
                if (ty == Tint32)
                {
                }
                else if (cast(бцел)значение != значение)
                    return;
                break;

            case Tdchar:
                if (значение > 0x10FFFFU)
                    return;
                break;

            case Tfloat32:
                if (!isLosslesslyConvertibleToFP!(float))
                    return;
                break;

            case Tfloat64:
                if (!isLosslesslyConvertibleToFP!(double))
                    return;
                break;

            case Tfloat80:
                if (!isLosslesslyConvertibleToFP!(real_t))
                    return;
                break;

            case Tpointer:
                //printf("тип = %s\n", тип.toBasetype()->вТкст0());
                //printf("t = %s\n", t.toBasetype()->вТкст0());
                if (ty == Tpointer && e.тип.toBasetype().nextOf().ty == t.toBasetype().nextOf().ty)
                {
                    /* Allow things like:
                     *      const ткст0 P = cast(сим *)3;
                     *      ткст0 q = P;
                     */
                    break;
                }
                goto default;

            default:
                посети(cast(Выражение)e);
                return;
            }

            //printf("MATCH.convert\n");
            результат = MATCH.convert;
        }

        override проц посети(ErrorExp e)
        {
            // no match
        }

        override проц посети(NullExp e)
        {
            version (none)
            {
                printf("NullExp::implicitConvTo(this=%s, тип=%s, t=%s, committed = %d)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0(), e.committed);
            }
            if (e.тип.равен(t))
            {
                результат = MATCH.exact;
                return;
            }

            /* Allow implicit conversions from const to mutable|const,
             * and mutable to const. It works because, after all, a null
             * doesn't actually point to anything.
             */
            if (t.equivalent(e.тип))
            {
                результат = MATCH.constant;
                return;
            }

            посети(cast(Выражение)e);
        }

        override проц посети(StructLiteralExp e)
        {
            version (none)
            {
                printf("StructLiteralExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;
            if (e.тип.ty == t.ty && e.тип.ty == Tstruct && (cast(TypeStruct)e.тип).sym == (cast(TypeStruct)t).sym)
            {
                результат = MATCH.constant;
                for (т_мера i = 0; i < e.elements.dim; i++)
                {
                    Выражение el = (*e.elements)[i];
                    if (!el)
                        continue;
                    Тип te = e.sd.fields[i].тип.addMod(t.mod);
                    MATCH m2 = el.implicitConvTo(te);
                    //printf("\t%s => %s, match = %d\n", el.вТкст0(), te.вТкст0(), m2);
                    if (m2 < результат)
                        результат = m2;
                }
            }
        }

        override проц посети(StringExp e)
        {
            version (none)
            {
                printf("StringExp::implicitConvTo(this=%s, committed=%d, тип=%s, t=%s)\n", e.вТкст0(), e.committed, e.тип.вТкст0(), t.вТкст0());
            }
            if (!e.committed && t.ty == Tpointer && t.nextOf().ty == Tvoid)
                return;

            if (!(e.тип.ty == Tsarray || e.тип.ty == Tarray || e.тип.ty == Tpointer))
                return посети(cast(Выражение)e);

            TY tyn = e.тип.nextOf().ty;

            if (!(tyn == Tchar || tyn == Twchar || tyn == Tdchar))
                return посети(cast(Выражение)e);

            switch (t.ty)
            {
            case Tsarray:
                if (e.тип.ty == Tsarray)
                {
                    TY tynto = t.nextOf().ty;
                    if (tynto == tyn)
                    {
                        if ((cast(TypeSArray)e.тип).dim.toInteger() == (cast(TypeSArray)t).dim.toInteger())
                        {
                            результат = MATCH.exact;
                        }
                        return;
                    }
                    if (tynto == Tchar || tynto == Twchar || tynto == Tdchar)
                    {
                        if (e.committed && tynto != tyn)
                            return;
                        т_мера fromlen = e.numberOfCodeUnits(tynto);
                        т_мера tolen = cast(т_мера)(cast(TypeSArray)t).dim.toInteger();
                        if (tolen < fromlen)
                            return;
                        if (tolen != fromlen)
                        {
                            // implicit length extending
                            результат = MATCH.convert;
                            return;
                        }
                    }
                    if (!e.committed && (tynto == Tchar || tynto == Twchar || tynto == Tdchar))
                    {
                        результат = MATCH.exact;
                        return;
                    }
                }
                else if (e.тип.ty == Tarray)
                {
                    TY tynto = t.nextOf().ty;
                    if (tynto == Tchar || tynto == Twchar || tynto == Tdchar)
                    {
                        if (e.committed && tynto != tyn)
                            return;
                        т_мера fromlen = e.numberOfCodeUnits(tynto);
                        т_мера tolen = cast(т_мера)(cast(TypeSArray)t).dim.toInteger();
                        if (tolen < fromlen)
                            return;
                        if (tolen != fromlen)
                        {
                            // implicit length extending
                            результат = MATCH.convert;
                            return;
                        }
                    }
                    if (tynto == tyn)
                    {
                        результат = MATCH.exact;
                        return;
                    }
                    if (!e.committed && (tynto == Tchar || tynto == Twchar || tynto == Tdchar))
                    {
                        результат = MATCH.exact;
                        return;
                    }
                }
                goto case; /+ fall through +/
            case Tarray:
            case Tpointer:
                Тип tn = t.nextOf();
                MATCH m = MATCH.exact;
                if (e.тип.nextOf().mod != tn.mod)
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=16183
                    if (!tn.isConst() && !tn.isImmutable())
                        return;
                    m = MATCH.constant;
                }
                if (!e.committed)
                {
                    switch (tn.ty)
                    {
                    case Tchar:
                        if (e.postfix == 'w' || e.postfix == 'd')
                            m = MATCH.convert;
                        результат = m;
                        return;
                    case Twchar:
                        if (e.postfix != 'w')
                            m = MATCH.convert;
                        результат = m;
                        return;
                    case Tdchar:
                        if (e.postfix != 'd')
                            m = MATCH.convert;
                        результат = m;
                        return;
                    case Tenum:
                        if ((cast(TypeEnum)tn).sym.isSpecial())
                        {
                            /* Allow ткст literal -> const(wchar_t)[]
                             */
                            if (TypeBasic tob = tn.toBasetype().isTypeBasic())
                            результат = tn.implicitConvTo(tob);
                            return;
                        }
                        break;
                    default:
                        break;
                    }
                }
                break;

            default:
                break;
            }

            посети(cast(Выражение)e);
        }

        override проц посети(ArrayLiteralExp e)
        {
            version (none)
            {
                printf("ArrayLiteralExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if ((tb.ty == Tarray || tb.ty == Tsarray) &&
                (typeb.ty == Tarray || typeb.ty == Tsarray))
            {
                результат = MATCH.exact;
                Тип typen = typeb.nextOf().toBasetype();

                if (tb.ty == Tsarray)
                {
                    TypeSArray tsa = cast(TypeSArray)tb;
                    if (e.elements.dim != tsa.dim.toInteger())
                        результат = MATCH.nomatch;
                }

                Тип telement = tb.nextOf();
                if (!e.elements.dim)
                {
                    if (typen.ty != Tvoid)
                        результат = typen.implicitConvTo(telement);
                }
                else
                {
                    if (e.basis)
                    {
                        MATCH m = e.basis.implicitConvTo(telement);
                        if (m < результат)
                            результат = m;
                    }
                    for (т_мера i = 0; i < e.elements.dim; i++)
                    {
                        Выражение el = (*e.elements)[i];
                        if (результат == MATCH.nomatch)
                            break;
                        if (!el)
                            continue;
                        MATCH m = el.implicitConvTo(telement);
                        if (m < результат)
                            результат = m; // remember worst match
                    }
                }

                if (!результат)
                    результат = e.тип.implicitConvTo(t);

                return;
            }
            else if (tb.ty == Tvector && (typeb.ty == Tarray || typeb.ty == Tsarray))
            {
                результат = MATCH.exact;
                // Convert массив literal to vector тип
                TypeVector tv = cast(TypeVector)tb;
                TypeSArray tbase = cast(TypeSArray)tv.basetype;
                assert(tbase.ty == Tsarray);
                const edim = e.elements.dim;
                const tbasedim = tbase.dim.toInteger();
                if (edim > tbasedim)
                {
                    результат = MATCH.nomatch;
                    return;
                }

                Тип telement = tv.elementType();
                if (edim < tbasedim)
                {
                    Выражение el = typeb.nextOf.defaultInitLiteral(e.место);
                    MATCH m = el.implicitConvTo(telement);
                    if (m < результат)
                        результат = m; // remember worst match
                }
                foreach (i; new бцел[0 .. edim])
                {
                    Выражение el = (*e.elements)[i];
                    MATCH m = el.implicitConvTo(telement);
                    if (m < результат)
                        результат = m; // remember worst match
                    if (результат == MATCH.nomatch)
                        break; // no need to check for worse
                }
                return;
            }

            посети(cast(Выражение)e);
        }

        override проц посети(AssocArrayLiteralExp e)
        {
            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (!(tb.ty == Taarray && typeb.ty == Taarray))
                return посети(cast(Выражение)e);

            результат = MATCH.exact;
            for (т_мера i = 0; i < e.keys.dim; i++)
            {
                Выражение el = (*e.keys)[i];
                MATCH m = el.implicitConvTo((cast(TypeAArray)tb).index);
                if (m < результат)
                    результат = m; // remember worst match
                if (результат == MATCH.nomatch)
                    break; // no need to check for worse
                el = (*e.values)[i];
                m = el.implicitConvTo(tb.nextOf());
                if (m < результат)
                    результат = m; // remember worst match
                if (результат == MATCH.nomatch)
                    break; // no need to check for worse
            }
        }

        override проц посети(CallExp e)
        {
            const LOG = нет;
            static if (LOG)
            {
                printf("CallExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }

            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;

            /* Allow the результат of strongly  functions to
             * convert to const
             */
            if (e.f && e.f.isReturnIsolated() &&
                (!глоб2.парамы.vsafe ||        // lots of legacy code breaks with the following purity check
                 e.f.isPure() >= PURE.strong ||
                 // Special case exemption for Object.dup() which we assume is implemented correctly
                 e.f.идент == Id.dup &&
                 e.f.toParent2() == ClassDeclaration.объект.toParent())
               )
            {
                результат = e.тип.immutableOf().implicitConvTo(t);
                if (результат > MATCH.constant) // Match уровень is MATCH.constant at best.
                    результат = MATCH.constant;
                return;
            }

            /* Conversion is 'const' conversion if:
             * 1. function is  (weakly  is ok)
             * 2. implicit conversion only fails because of mod bits
             * 3. each function параметр can be implicitly converted to the mod bits
             */
            Тип tx = e.f ? e.f.тип : e.e1.тип;
            tx = tx.toBasetype();
            if (tx.ty != Tfunction)
                return;
            TypeFunction tf = cast(TypeFunction)tx;

            if (tf.purity == PURE.impure)
                return;
            if (e.f && e.f.isNested())
                return;

            /* See if fail only because of mod bits.
             *
             * https://issues.dlang.org/show_bug.cgi?ид=14155
             * All  functions can access глоб2 const данные.
             * So the returned pointer may refer an const глоб2 данные,
             * and then the returned pointer that points non-mutable объект
             * cannot be unique pointer.
             *
             * Example:
             *  const g;
             *  static this() { g = 1; }
             *  const(цел*) foo()  { return &g; }
             *  проц test() {
             *    const(цел*) ip = foo(); // OK
             *    цел* mp = foo();            // should be disallowed
             *  }
             */
            if (e.тип.immutableOf().implicitConvTo(t) < MATCH.constant && e.тип.addMod(MODFlags.shared_).implicitConvTo(t) < MATCH.constant && e.тип.implicitConvTo(t.addMod(MODFlags.shared_)) < MATCH.constant)
            {
                return;
            }
            // Allow a conversion to const тип, or
            // conversions of mutable types between thread-local and shared.

            /* Get mod bits of what we're converting to
             */
            Тип tb = t.toBasetype();
            MOD mod = tb.mod;
            if (tf.isref)
            {
            }
            else
            {
                Тип ti = getIndirection(t);
                if (ti)
                    mod = ti.mod;
            }
            static if (LOG)
            {
                printf("mod = x%x\n", mod);
            }
            if (mod & MODFlags.wild)
                return; // not sure what to do with this

            /* Apply mod bits to each function параметр,
             * and see if we can convert the function argument to the modded тип
             */

            т_мера nparams = tf.parameterList.length;
            т_мера j = tf.isDstyleVariadic(); // if TypeInfoArray was prepended
            if (e.e1.op == ТОК2.dotVariable)
            {
                /* Treat 'this' as just another function argument
                 */
                DotVarExp dve = cast(DotVarExp)e.e1;
                Тип targ = dve.e1.тип;
                if (targ.constConv(targ.castMod(mod)) == MATCH.nomatch)
                    return;
            }
            for (т_мера i = j; i < e.arguments.dim; ++i)
            {
                Выражение earg = (*e.arguments)[i];
                Тип targ = earg.тип.toBasetype();
                static if (LOG)
                {
                    printf("[%d] earg: %s, targ: %s\n", cast(цел)i, earg.вТкст0(), targ.вТкст0());
                }
                if (i - j < nparams)
                {
                    Параметр2 fparam = tf.parameterList[i - j];
                    if (fparam.классХранения & STC.lazy_)
                        return; // not sure what to do with this
                    Тип tparam = fparam.тип;
                    if (!tparam)
                        continue;
                    if (fparam.классХранения & (STC.out_ | STC.ref_))
                    {
                        if (targ.constConv(tparam.castMod(mod)) == MATCH.nomatch)
                            return;
                        continue;
                    }
                }
                static if (LOG)
                {
                    printf("[%d] earg: %s, targm: %s\n", cast(цел)i, earg.вТкст0(), targ.addMod(mod).вТкст0());
                }
                if (implicitMod(earg, targ, mod) == MATCH.nomatch)
                    return;
            }

            /* Success
             */
            результат = MATCH.constant;
        }

        override проц посети(AddrExp e)
        {
            version (none)
            {
                printf("AddrExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            результат = e.тип.implicitConvTo(t);
            //printf("\tрезультат = %d\n", результат);

            if (результат != MATCH.nomatch)
                return;

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            // Look for pointers to functions where the functions are overloaded.
            if (e.e1.op == ТОК2.overloadSet &&
                (tb.ty == Tpointer || tb.ty == Tdelegate) && tb.nextOf().ty == Tfunction)
            {
                OverExp eo = cast(OverExp)e.e1;
                FuncDeclaration f = null;
                for (т_мера i = 0; i < eo.vars.a.dim; i++)
                {
                    ДСимвол s = eo.vars.a[i];
                    FuncDeclaration f2 = s.isFuncDeclaration();
                    assert(f2);
                    if (f2.overloadExactMatch(tb.nextOf()))
                    {
                        if (f)
                        {
                            /* Error if match in more than one overload set,
                             * even if one is a 'better' match than the other.
                             */
                            ScopeDsymbol.multiplyDefined(e.место, f, f2);
                        }
                        else
                            f = f2;
                        результат = MATCH.exact;
                    }
                }
            }

            if (e.e1.op == ТОК2.variable &&
                typeb.ty == Tpointer && typeb.nextOf().ty == Tfunction &&
                tb.ty == Tpointer && tb.nextOf().ty == Tfunction)
            {
                /* I don't think this can ever happen -
                 * it should have been
                 * converted to a SymOffExp.
                 */
                assert(0);
            }

            //printf("\tрезультат = %d\n", результат);
        }

        override проц посети(SymOffExp e)
        {
            version (none)
            {
                printf("SymOffExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            результат = e.тип.implicitConvTo(t);
            //printf("\tрезультат = %d\n", результат);
            if (результат != MATCH.nomatch)
                return;

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            // Look for pointers to functions where the functions are overloaded.
            if (typeb.ty == Tpointer && typeb.nextOf().ty == Tfunction &&
                (tb.ty == Tpointer || tb.ty == Tdelegate) && tb.nextOf().ty == Tfunction)
            {
                if (FuncDeclaration f = e.var.isFuncDeclaration())
                {
                    f = f.overloadExactMatch(tb.nextOf());
                    if (f)
                    {
                        if ((tb.ty == Tdelegate && (f.needThis() || f.isNested())) ||
                            (tb.ty == Tpointer && !(f.needThis() || f.isNested())))
                        {
                            результат = MATCH.exact;
                        }
                    }
                }
            }
            //printf("\tрезультат = %d\n", результат);
        }

        override проц посети(DelegateExp e)
        {
            version (none)
            {
                printf("DelegateExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            результат = e.тип.implicitConvTo(t);
            if (результат != MATCH.nomatch)
                return;

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            // Look for pointers to functions where the functions are overloaded.
            if (typeb.ty == Tdelegate && tb.ty == Tdelegate)
            {
                if (e.func && e.func.overloadExactMatch(tb.nextOf()))
                    результат = MATCH.exact;
            }
        }

        override проц посети(FuncExp e)
        {
            //printf("FuncExp::implicitConvTo тип = %p %s, t = %s\n", e.тип, e.тип ? e.тип.вТкст0() : NULL, t.вТкст0());
            MATCH m = e.matchType(t, null, null, 1);
            if (m > MATCH.nomatch)
            {
                результат = m;
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(AndExp e)
        {
            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;

            MATCH m1 = e.e1.implicitConvTo(t);
            MATCH m2 = e.e2.implicitConvTo(t);

            // Pick the worst match
            результат = (m1 < m2) ? m1 : m2;
        }

        override проц посети(OrExp e)
        {
            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;

            MATCH m1 = e.e1.implicitConvTo(t);
            MATCH m2 = e.e2.implicitConvTo(t);

            // Pick the worst match
            результат = (m1 < m2) ? m1 : m2;
        }

        override проц посети(XorExp e)
        {
            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;

            MATCH m1 = e.e1.implicitConvTo(t);
            MATCH m2 = e.e2.implicitConvTo(t);

            // Pick the worst match
            результат = (m1 < m2) ? m1 : m2;
        }

        override проц посети(CondExp e)
        {
            MATCH m1 = e.e1.implicitConvTo(t);
            MATCH m2 = e.e2.implicitConvTo(t);
            //printf("CondExp: m1 %d m2 %d\n", m1, m2);

            // Pick the worst match
            результат = (m1 < m2) ? m1 : m2;
        }

        override проц посети(CommaExp e)
        {
            e.e2.прими(this);
        }

        override проц посети(CastExp e)
        {
            version (none)
            {
                printf("CastExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            результат = e.тип.implicitConvTo(t);
            if (результат != MATCH.nomatch)
                return;

            if (t.isintegral() && e.e1.тип.isintegral() && e.e1.implicitConvTo(t) != MATCH.nomatch)
                результат = MATCH.convert;
            else
                посети(cast(Выражение)e);
        }

        override проц посети(NewExp e)
        {
            version (none)
            {
                printf("NewExp::implicitConvTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;

            /* Calling new() is like calling a  function. We can implicitly convert the
             * return from new() to t using the same algorithm as in CallExp, with the function
             * 'arguments' being:
             *    thisexp
             *    newargs
             *    arguments
             *    .init
             * 'member' and 'allocator' need to be .
             */

            /* See if fail only because of mod bits
             */
            if (e.тип.immutableOf().implicitConvTo(t.immutableOf()) == MATCH.nomatch)
                return;

            /* Get mod bits of what we're converting to
             */
            Тип tb = t.toBasetype();
            MOD mod = tb.mod;
            if (Тип ti = getIndirection(t))
                mod = ti.mod;
            static if (LOG)
            {
                printf("mod = x%x\n", mod);
            }
            if (mod & MODFlags.wild)
                return; // not sure what to do with this

            /* Apply mod bits to each argument,
             * and see if we can convert the argument to the modded тип
             */

            if (e.thisexp)
            {
                /* Treat 'this' as just another function argument
                 */
                Тип targ = e.thisexp.тип;
                if (targ.constConv(targ.castMod(mod)) == MATCH.nomatch)
                    return;
            }

            /* Check call to 'allocator', then 'member'
             */
            FuncDeclaration fd = e.allocator;
            for (цел count = 0; count < 2; ++count, (fd = e.member))
            {
                if (!fd)
                    continue;
                if (fd.errors || fd.тип.ty != Tfunction)
                    return; // error
                TypeFunction tf = cast(TypeFunction)fd.тип;
                if (tf.purity == PURE.impure)
                    return; // impure

                if (fd == e.member)
                {
                    if (e.тип.immutableOf().implicitConvTo(t) < MATCH.constant && e.тип.addMod(MODFlags.shared_).implicitConvTo(t) < MATCH.constant && e.тип.implicitConvTo(t.addMod(MODFlags.shared_)) < MATCH.constant)
                    {
                        return;
                    }
                    // Allow a conversion to const тип, or
                    // conversions of mutable types between thread-local and shared.
                }

                Выражения* args = (fd == e.allocator) ? e.newargs : e.arguments;

                т_мера nparams = tf.parameterList.length;
                // if TypeInfoArray was prepended
                т_мера j = tf.isDstyleVariadic();
                for (т_мера i = j; i < e.arguments.dim; ++i)
                {
                    Выражение earg = (*args)[i];
                    Тип targ = earg.тип.toBasetype();
                    static if (LOG)
                    {
                        printf("[%d] earg: %s, targ: %s\n", cast(цел)i, earg.вТкст0(), targ.вТкст0());
                    }
                    if (i - j < nparams)
                    {
                        Параметр2 fparam = tf.parameterList[i - j];
                        if (fparam.классХранения & STC.lazy_)
                            return; // not sure what to do with this
                        Тип tparam = fparam.тип;
                        if (!tparam)
                            continue;
                        if (fparam.классХранения & (STC.out_ | STC.ref_))
                        {
                            if (targ.constConv(tparam.castMod(mod)) == MATCH.nomatch)
                                return;
                            continue;
                        }
                    }
                    static if (LOG)
                    {
                        printf("[%d] earg: %s, targm: %s\n", cast(цел)i, earg.вТкст0(), targ.addMod(mod).вТкст0());
                    }
                    if (implicitMod(earg, targ, mod) == MATCH.nomatch)
                        return;
                }
            }

            /* If no 'member', then construction is by simple assignment,
             * and just straight check 'arguments'
             */
            if (!e.member && e.arguments)
            {
                for (т_мера i = 0; i < e.arguments.dim; ++i)
                {
                    Выражение earg = (*e.arguments)[i];
                    if (!earg) // https://issues.dlang.org/show_bug.cgi?ид=14853
                               // if it's on overlapped field
                        continue;
                    Тип targ = earg.тип.toBasetype();
                    static if (LOG)
                    {
                        printf("[%d] earg: %s, targ: %s\n", cast(цел)i, earg.вТкст0(), targ.вТкст0());
                        printf("[%d] earg: %s, targm: %s\n", cast(цел)i, earg.вТкст0(), targ.addMod(mod).вТкст0());
                    }
                    if (implicitMod(earg, targ, mod) == MATCH.nomatch)
                        return;
                }
            }

            /* Consider the .init Выражение as an argument
             */
            Тип ntb = e.newtype.toBasetype();
            if (ntb.ty == Tarray)
                ntb = ntb.nextOf().toBasetype();
            if (ntb.ty == Tstruct)
            {
                // Don't allow nested structs - uplevel reference may not be convertible
                StructDeclaration sd = (cast(TypeStruct)ntb).sym;
                sd.size(e.место); // resolve any forward references
                if (sd.isNested())
                    return;
            }
            if (ntb.isZeroInit(e.место))
            {
                /* Zeros are implicitly convertible, except for special cases.
                 */
                if (ntb.ty == Tclass)
                {
                    /* With new() must look at the class instance инициализатор.
                     */
                    ClassDeclaration cd = (cast(TypeClass)ntb).sym;

                    cd.size(e.место); // resolve any forward references

                    if (cd.isNested())
                        return; // uplevel reference may not be convertible

                    assert(!cd.isInterfaceDeclaration());

                    struct ClassCheck
                    {
                         static бул convertible(Место место, ClassDeclaration cd, MOD mod)
                        {
                            for (т_мера i = 0; i < cd.fields.dim; i++)
                            {
                                VarDeclaration v = cd.fields[i];
                                Инициализатор _иниц = v._иниц;
                                if (_иниц)
                                {
                                    if (_иниц.isVoidInitializer())
                                    {
                                    }
                                    else if (ExpInitializer ei = _иниц.isExpInitializer())
                                    {
                                        Тип tb = v.тип.toBasetype();
                                        if (implicitMod(ei.exp, tb, mod) == MATCH.nomatch)
                                            return нет;
                                    }
                                    else
                                    {
                                        /* Enhancement: handle StructInitializer and ArrayInitializer
                                         */
                                        return нет;
                                    }
                                }
                                else if (!v.тип.isZeroInit(место))
                                    return нет;
                            }
                            return cd.baseClass ? convertible(место, cd.baseClass, mod) : да;
                        }
                    }

                    if (!ClassCheck.convertible(e.место, cd, mod))
                        return;
                }
            }
            else
            {
                Выражение earg = e.newtype.defaultInitLiteral(e.место);
                Тип targ = e.newtype.toBasetype();

                if (implicitMod(earg, targ, mod) == MATCH.nomatch)
                    return;
            }

            /* Success
             */
            результат = MATCH.constant;
        }

        override проц посети(SliceExp e)
        {
            //printf("SliceExp::implicitConvTo e = %s, тип = %s\n", e.вТкст0(), e.тип.вТкст0());
            посети(cast(Выражение)e);
            if (результат != MATCH.nomatch)
                return;

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (tb.ty == Tsarray && typeb.ty == Tarray)
            {
                typeb = toStaticArrayType(e);
                if (typeb)
                    результат = typeb.implicitConvTo(t);
                return;
            }

            /* If the only reason it won't convert is because of the mod bits,
             * then test for conversion by seeing if e1 can be converted with those
             * same mod bits.
             */
            Тип t1b = e.e1.тип.toBasetype();
            if (tb.ty == Tarray && typeb.equivalent(tb))
            {
                Тип tbn = tb.nextOf();
                Тип tx = null;

                /* If e.e1 is dynamic массив or pointer, the uniqueness of e.e1
                 * is equivalent with the uniqueness of the referred данные. And in here
                 * we can have arbitrary typed reference for that.
                 */
                if (t1b.ty == Tarray)
                    tx = tbn.arrayOf();
                if (t1b.ty == Tpointer)
                    tx = tbn.pointerTo();

                /* If e.e1 is static массив, at least it should be an rvalue.
                 * If not, e.e1 is a reference, and its uniqueness does not link
                 * to the uniqueness of the referred данные.
                 */
                if (t1b.ty == Tsarray && !e.e1.isLvalue())
                    tx = tbn.sarrayOf(t1b.size() / tbn.size());

                if (tx)
                {
                    результат = e.e1.implicitConvTo(tx);
                    if (результат > MATCH.constant) // Match уровень is MATCH.constant at best.
                        результат = MATCH.constant;
                }
            }

            // Enhancement 10724
            if (tb.ty == Tpointer && e.e1.op == ТОК2.string_)
                e.e1.прими(this);
        }
    }

    scope ImplicitConvTo v = new ImplicitConvTo(t);
    e.прими(v);
    return v.результат;
}

Тип toStaticArrayType(SliceExp e)
{
    if (e.lwr && e.upr)
    {
        // For the following code to work, e should be optimized beforehand.
        // (eg. $ in lwr and upr should be already resolved, if possible)
        Выражение lwr = e.lwr.optimize(WANTvalue);
        Выражение upr = e.upr.optimize(WANTvalue);
        if (lwr.isConst() && upr.isConst())
        {
            т_мера len = cast(т_мера)(upr.toUInteger() - lwr.toUInteger());
            return e.тип.toBasetype().nextOf().sarrayOf(len);
        }
    }
    else
    {
        Тип t1b = e.e1.тип.toBasetype();
        if (t1b.ty == Tsarray)
            return t1b;
    }
    return null;
}

// Try casting the alias this member. Return the Выражение if it succeeds, null otherwise.
private Выражение tryAliasThisCast(Выражение e, Scope* sc, Тип tob, Тип t1b, Тип t)
{
    Выражение результат;
    AggregateDeclaration t1ad = isAggregate(t1b);
    if (!t1ad)
        return null;

    AggregateDeclaration toad = isAggregate(tob);
    if (t1ad == toad || !t1ad.aliasthis)
        return null;

    /* Forward the cast to our alias this member, rewrite to:
     *   cast(to)e1.aliasthis
     */
    результат = resolveAliasThis(sc, e);
    const errors = глоб2.startGagging();
    результат = результат.castTo(sc, t);
    return глоб2.endGagging(errors) ? null : результат;
}

/**************************************
 * Do an explicit cast.
 * Assume that the 'this' Выражение does not have any indirections.
 */
Выражение castTo(Выражение e, Scope* sc, Тип t)
{
     final class CastTo : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        Тип t;
        Scope* sc;
        Выражение результат;

        this(Scope* sc, Тип t)
        {
            this.sc = sc;
            this.t = t;
        }

        override проц посети(Выражение e)
        {
            //printf("Выражение::castTo(this=%s, t=%s)\n", e.вТкст0(), t.вТкст0());
            version (none)
            {
                printf("Выражение::castTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            if (e.тип.равен(t))
            {
                результат = e;
                return;
            }
            if (e.op == ТОК2.variable)
            {
                VarDeclaration v = (cast(VarExp)e).var.isVarDeclaration();
                if (v && v.класс_хранения & STC.manifest)
                {
                    результат = e.ctfeInterpret();
                    /* https://issues.dlang.org/show_bug.cgi?ид=18236
                     *
                     * The Выражение returned by ctfeInterpret points
                     * to the line where the manifest constant was declared
                     * so we need to update the location before trying to cast
                     */
                    результат.место = e.место;
                    результат = результат.castTo(sc, t);
                    return;
                }
            }

            Тип tob = t.toBasetype();
            Тип t1b = e.тип.toBasetype();
            if (tob.равен(t1b))
            {
                результат = e.копируй(); // because of COW for assignment to e.тип
                результат.тип = t;
                return;
            }

            /* Make semantic error against invalid cast between concrete types.
             * Assume that 'e' is never be any placeholder Выражения.
             * The результат of these checks should be consistent with CastExp::toElem().
             */

            // Fat Значение types
            const бул tob_isFV = (tob.ty == Tstruct || tob.ty == Tsarray);
            const бул t1b_isFV = (t1b.ty == Tstruct || t1b.ty == Tsarray);

            // Fat Reference types
            const бул tob_isFR = (tob.ty == Tarray || tob.ty == Tdelegate);
            const бул t1b_isFR = (t1b.ty == Tarray || t1b.ty == Tdelegate);

            // Reference types
            const бул tob_isR = (tob_isFR || tob.ty == Tpointer || tob.ty == Taarray || tob.ty == Tclass);
            const бул t1b_isR = (t1b_isFR || t1b.ty == Tpointer || t1b.ty == Taarray || t1b.ty == Tclass);

            // Arithmetic types (== valueable basic types)
            const бул tob_isA = (tob.isintegral() || tob.isfloating());
            const бул t1b_isA = (t1b.isintegral() || t1b.isfloating());

            бул hasAliasThis;
            if (AggregateDeclaration t1ad = isAggregate(t1b))
            {
                AggregateDeclaration toad = isAggregate(tob);
                if (t1ad != toad && t1ad.aliasthis)
                {
                    if (t1b.ty == Tclass && tob.ty == Tclass)
                    {
                        ClassDeclaration t1cd = t1b.isClassHandle();
                        ClassDeclaration tocd = tob.isClassHandle();
                        цел смещение;
                        if (tocd.isBaseOf(t1cd, &смещение))
                            goto Lok;
                    }
                    hasAliasThis = да;
                }
            }
            else if (tob.ty == Tvector && t1b.ty != Tvector)
            {
                //printf("test1 e = %s, e.тип = %s, tob = %s\n", e.вТкст0(), e.тип.вТкст0(), tob.вТкст0());
                TypeVector tv = cast(TypeVector)tob;
                результат = new CastExp(e.место, e, tv.elementType());
                результат = new VectorExp(e.место, результат, tob);
                результат = результат.ВыражениеSemantic(sc);
                return;
            }
            else if (tob.ty != Tvector && t1b.ty == Tvector)
            {
                // T[n] <-- __vector(U[m])
                if (tob.ty == Tsarray)
                {
                    if (t1b.size(e.место) == tob.size(e.место))
                        goto Lok;
                }
                goto Lfail;
            }
            else if (t1b.implicitConvTo(tob) == MATCH.constant && t.равен(e.тип.constOf()))
            {
                результат = e.копируй();
                результат.тип = t;
                return;
            }

            // arithmetic values vs. other arithmetic values
            // arithmetic values vs. T*
            if (tob_isA && (t1b_isA || t1b.ty == Tpointer) || t1b_isA && (tob_isA || tob.ty == Tpointer))
            {
                goto Lok;
            }

            // arithmetic values vs. references or fat values
            if (tob_isA && (t1b_isR || t1b_isFV) || t1b_isA && (tob_isR || tob_isFV))
            {
                goto Lfail;
            }

            // Bugzlla 3133: A cast between fat values is possible only when the sizes match.
            if (tob_isFV && t1b_isFV)
            {
                if (hasAliasThis)
                {
                    результат = tryAliasThisCast(e, sc, tob, t1b, t);
                    if (результат)
                        return;
                }

                if (t1b.size(e.место) == tob.size(e.место))
                    goto Lok;

                auto ts = toAutoQualChars(e.тип, t);
                e.выведиОшибку("cannot cast Выражение `%s` of тип `%s` to `%s` because of different sizes",
                    e.вТкст0(), ts[0], ts[1]);
                результат = new ErrorExp();
                return;
            }

            // Fat values vs. null or references
            if (tob_isFV && (t1b.ty == Tnull || t1b_isR) || t1b_isFV && (tob.ty == Tnull || tob_isR))
            {
                if (tob.ty == Tpointer && t1b.ty == Tsarray)
                {
                    // T[n] sa;
                    // cast(U*)sa; // ==> cast(U*)sa.ptr;
                    результат = new AddrExp(e.место, e, t);
                    return;
                }
                if (tob.ty == Tarray && t1b.ty == Tsarray)
                {
                    // T[n] sa;
                    // cast(U[])sa; // ==> cast(U[])sa[];
                    d_uns64 fsize = t1b.nextOf().size();
                    d_uns64 tsize = tob.nextOf().size();
                    if (((cast(TypeSArray)t1b).dim.toInteger() * fsize) % tsize != 0)
                    {
                        // copied from sarray_toDarray() in e2ir.c
                        e.выведиОшибку("cannot cast Выражение `%s` of тип `%s` to `%s` since sizes don't line up", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
                        результат = new ErrorExp();
                        return;
                    }
                    goto Lok;
                }
                goto Lfail;
            }

            /* For references, any reinterpret casts are allowed to same 'ty' тип.
             *      T* to U*
             *      R1 function(P1) to R2 function(P2)
             *      R1 delegate(P1) to R2 delegate(P2)
             *      T[] to U[]
             *      V1[K1] to V2[K2]
             *      class/interface A to B  (will be a dynamic cast if possible)
             */
            if (tob.ty == t1b.ty && tob_isR && t1b_isR)
                goto Lok;

            // typeof(null) <-- non-null references or values
            if (tob.ty == Tnull && t1b.ty != Tnull)
                goto Lfail; // https://issues.dlang.org/show_bug.cgi?ид=14629
            // typeof(null) --> non-null references or arithmetic values
            if (t1b.ty == Tnull && tob.ty != Tnull)
                goto Lok;

            // Check size mismatch of references.
            // Tarray and Tdelegate are (ук).sizeof*2, but others have (ук).sizeof.
            if (tob_isFR && t1b_isR || t1b_isFR && tob_isR)
            {
                if (tob.ty == Tpointer && t1b.ty == Tarray)
                {
                    // T[] da;
                    // cast(U*)da; // ==> cast(U*)da.ptr;
                    goto Lok;
                }
                if (tob.ty == Tpointer && t1b.ty == Tdelegate)
                {
                    // проц delegate() dg;
                    // cast(U*)dg; // ==> cast(U*)dg.ptr;
                    // Note that it happens even when U is a Tfunction!
                    e.deprecation("casting from %s to %s is deprecated", e.тип.вТкст0(), t.вТкст0());
                    goto Lok;
                }
                goto Lfail;
            }

            if (t1b.ty == Tvoid && tob.ty != Tvoid)
            {
            Lfail:
                /* if the cast cannot be performed, maybe there is an alias
                 * this that can be используется for casting.
                 */
                if (hasAliasThis)
                {
                    результат = tryAliasThisCast(e, sc, tob, t1b, t);
                    if (результат)
                        return;
                }
                e.выведиОшибку("cannot cast Выражение `%s` of тип `%s` to `%s`", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
                результат = new ErrorExp();
                return;
            }

        Lok:
            результат = new CastExp(e.место, e, t);
            результат.тип = t; // Don't call semantic()
            //printf("Returning: %s\n", результат.вТкст0());
        }

        override проц посети(ErrorExp e)
        {
            результат = e;
        }

        override проц посети(RealExp e)
        {
            if (!e.тип.равен(t))
            {
                if ((e.тип.isreal() && t.isreal()) || (e.тип.isimaginary() && t.isimaginary()))
                {
                    результат = e.копируй();
                    результат.тип = t;
                }
                else
                    посети(cast(Выражение)e);
                return;
            }
            результат = e;
        }

        override проц посети(ComplexExp e)
        {
            if (!e.тип.равен(t))
            {
                if (e.тип.iscomplex() && t.iscomplex())
                {
                    результат = e.копируй();
                    результат.тип = t;
                }
                else
                    посети(cast(Выражение)e);
                return;
            }
            результат = e;
        }

        override проц посети(NullExp e)
        {
            //printf("NullExp::castTo(t = %s) %s\n", t.вТкст0(), вТкст0());
            посети(cast(Выражение)e);
            if (результат.op == ТОК2.null_)
            {
                NullExp ex = cast(NullExp)результат;
                ex.committed = 1;
                return;
            }
        }

        override проц посети(StructLiteralExp e)
        {
            посети(cast(Выражение)e);
            if (результат.op == ТОК2.structLiteral)
                (cast(StructLiteralExp)результат).stype = t; // commit тип
        }

        override проц посети(StringExp e)
        {
            /* This follows копируй-on-пиши; any changes to 'this'
             * will результат in a копируй.
             * The this.ткст member is considered const.
             */
            цел copied = 0;

            //printf("StringExp::castTo(t = %s), '%s' committed = %d\n", t.вТкст0(), e.вТкст0(), e.committed);

            if (!e.committed && t.ty == Tpointer && t.nextOf().ty == Tvoid)
            {
                e.выведиОшибку("cannot convert ткст literal to `ук`");
                результат = new ErrorExp();
                return;
            }

            StringExp se = e;
            if (!e.committed)
            {
                se = cast(StringExp)e.копируй();
                se.committed = 1;
                copied = 1;
            }

            if (e.тип.равен(t))
            {
                результат = se;
                return;
            }

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            //printf("\ttype = %s\n", e.тип.вТкст0());
            if (tb.ty == Tdelegate && typeb.ty != Tdelegate)
            {
                посети(cast(Выражение)e);
                return;
            }

            if (typeb.равен(tb))
            {
                if (!copied)
                {
                    se = cast(StringExp)e.копируй();
                    copied = 1;
                }
                se.тип = t;
                результат = se;
                return;
            }

            /* Handle reinterpret casts:
             *  cast(wchar[3])"abcd"c --> [\u6261, \u6463, \u0000]
             *  cast(wchar[2])"abcd"c --> [\u6261, \u6463]
             *  cast(wchar[1])"abcd"c --> [\u6261]
             *  cast(сим[4])"a" --> ['a', 0, 0, 0]
             */
            if (e.committed && tb.ty == Tsarray && typeb.ty == Tarray)
            {
                se = cast(StringExp)e.копируй();
                d_uns64 szx = tb.nextOf().size();
                assert(szx <= 255);
                se.sz = cast(ббайт)szx;
                se.len = cast(т_мера)(cast(TypeSArray)tb).dim.toInteger();
                se.committed = 1;
                se.тип = t;

                /* If larger than source, pad with zeros.
                 */
                const fullSize = (se.len + 1) * se.sz; // incl. terminating 0
                if (fullSize > (e.len + 1) * e.sz)
                {
                    ук s = mem.xmalloc(fullSize);
                    const srcSize = e.len * e.sz;
                    const данные = se.peekData();
                    memcpy(s, данные.ptr, srcSize);
                    memset(s + srcSize, 0, fullSize - srcSize);
                    se.setData(s, se.len, se.sz);
                }
                результат = se;
                return;
            }

            if (tb.ty != Tsarray && tb.ty != Tarray && tb.ty != Tpointer)
            {
                if (!copied)
                {
                    se = cast(StringExp)e.копируй();
                    copied = 1;
                }
                goto Lcast;
            }
            if (typeb.ty != Tsarray && typeb.ty != Tarray && typeb.ty != Tpointer)
            {
                if (!copied)
                {
                    se = cast(StringExp)e.копируй();
                    copied = 1;
                }
                goto Lcast;
            }

            if (typeb.nextOf().size() == tb.nextOf().size())
            {
                if (!copied)
                {
                    se = cast(StringExp)e.копируй();
                    copied = 1;
                }
                if (tb.ty == Tsarray)
                    goto L2; // handle possible change in static массив dimension
                se.тип = t;
                результат = se;
                return;
            }

            if (e.committed)
                goto Lcast;

            цел X(T, U)(T tf, U tt)
            {
                return (cast(цел)tf * 256 + cast(цел)tt);
            }

            {
                БуфВыв буфер;
                т_мера newlen = 0;
                цел tfty = typeb.nextOf().toBasetype().ty;
                цел ttty = tb.nextOf().toBasetype().ty;
                switch (X(tfty, ttty))
                {
                case X(Tchar, Tchar):
                case X(Twchar, Twchar):
                case X(Tdchar, Tdchar):
                    break;

                case X(Tchar, Twchar):
                    for (т_мера u = 0; u < e.len;)
                    {
                        dchar c;
                        if(auto s = utf_decodeChar(se.peekString(), u, c))
                            e.выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
                        else
                            буфер.пишиЮ16(c);
                    }
                    newlen = буфер.length / 2;
                    буфер.пишиЮ16(0);
                    goto L1;

                case X(Tchar, Tdchar):
                    for (т_мера u = 0; u < e.len;)
                    {
                        dchar c;
                        if(auto s = utf_decodeChar(se.peekString(), u, c))
                            e.выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
                        буфер.пиши4(c);
                        newlen++;
                    }
                    буфер.пиши4(0);
                    goto L1;

                case X(Twchar, Tchar):
                    for (т_мера u = 0; u < e.len;)
                    {
                        dchar c;
                        if(auto s = utf_decodeWchar(se.peekWstring(), u, c))
                            e.выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
                        else
                            буфер.пишиЮ8(c);
                    }
                    newlen = буфер.length;
                    буфер.пишиЮ8(0);
                    goto L1;

                case X(Twchar, Tdchar):
                    for (т_мера u = 0; u < e.len;)
                    {
                        dchar c;
                        if(auto s = utf_decodeWchar(se.peekWstring(), u, c))
                            e.выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
                        буфер.пиши4(c);
                        newlen++;
                    }
                    буфер.пиши4(0);
                    goto L1;

                case X(Tdchar, Tchar):
                    for (т_мера u = 0; u < e.len; u++)
                    {
                        бцел c = se.peekDstring()[u];
                        if (!utf_isValidDchar(c))
                            e.выведиОшибку("invalid UCS-32 сим \\U%08x", c);
                        else
                            буфер.пишиЮ8(c);
                        newlen++;
                    }
                    newlen = буфер.length;
                    буфер.пишиЮ8(0);
                    goto L1;

                case X(Tdchar, Twchar):
                    for (т_мера u = 0; u < e.len; u++)
                    {
                        бцел c = se.peekDstring()[u];
                        if (!utf_isValidDchar(c))
                            e.выведиОшибку("invalid UCS-32 сим \\U%08x", c);
                        else
                            буфер.пишиЮ16(c);
                        newlen++;
                    }
                    newlen = буфер.length / 2;
                    буфер.пишиЮ16(0);
                    goto L1;

                L1:
                    if (!copied)
                    {
                        se = cast(StringExp)e.копируй();
                        copied = 1;
                    }

                    {
                        d_uns64 szx = tb.nextOf().size();
                        assert(szx <= 255);
                        se.setData(буфер.извлекиСрез().ptr, newlen, cast(ббайт)szx);
                    }
                    break;

                default:
                    assert(typeb.nextOf().size() != tb.nextOf().size());
                    goto Lcast;
                }
            }
        L2:
            assert(copied);

            // See if need to truncate or extend the literal
            if (tb.ty == Tsarray)
            {
                т_мера dim2 = cast(т_мера)(cast(TypeSArray)tb).dim.toInteger();
                //printf("dim from = %d, to = %d\n", (цел)se.len, (цел)dim2);

                // Changing dimensions
                if (dim2 != se.len)
                {
                    // Copy when changing the ткст literal
                    const newsz = se.sz;
                    const d = (dim2 < se.len) ? dim2 : se.len;
                    ук s = mem.xmalloc((dim2 + 1) * newsz);
                    memcpy(s, se.peekData().ptr, d * newsz);
                    // Extend with 0, add terminating 0
                    memset(s + d * newsz, 0, (dim2 + 1 - d) * newsz);
                    se.setData(s, dim2, newsz);
                }
            }
            se.тип = t;
            результат = se;
            return;

        Lcast:
            результат = new CastExp(e.место, se, t);
            результат.тип = t; // so semantic() won't be run on e
        }

        override проц посети(AddrExp e)
        {
            version (none)
            {
                printf("AddrExp::castTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            результат = e;

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (tb.равен(typeb))
            {
                результат = e.копируй();
                результат.тип = t;
                return;
            }

            // Look for pointers to functions where the functions are overloaded.
            if (e.e1.op == ТОК2.overloadSet &&
                (tb.ty == Tpointer || tb.ty == Tdelegate) && tb.nextOf().ty == Tfunction)
            {
                OverExp eo = cast(OverExp)e.e1;
                FuncDeclaration f = null;
                for (т_мера i = 0; i < eo.vars.a.dim; i++)
                {
                    auto s = eo.vars.a[i];
                    auto f2 = s.isFuncDeclaration();
                    assert(f2);
                    if (f2.overloadExactMatch(tb.nextOf()))
                    {
                        if (f)
                        {
                            /* Error if match in more than one overload set,
                             * even if one is a 'better' match than the other.
                             */
                            ScopeDsymbol.multiplyDefined(e.место, f, f2);
                        }
                        else
                            f = f2;
                    }
                }
                if (f)
                {
                    f.tookAddressOf++;
                    auto se = new SymOffExp(e.место, f, 0, нет);
                    se.ВыражениеSemantic(sc);
                    // Let SymOffExp::castTo() do the heavy lifting
                    посети(se);
                    return;
                }
            }

            if (e.e1.op == ТОК2.variable &&
                typeb.ty == Tpointer && typeb.nextOf().ty == Tfunction &&
                tb.ty == Tpointer && tb.nextOf().ty == Tfunction)
            {
                auto ve = cast(VarExp)e.e1;
                auto f = ve.var.isFuncDeclaration();
                if (f)
                {
                    assert(f.isImportedSymbol());
                    f = f.overloadExactMatch(tb.nextOf());
                    if (f)
                    {
                        результат = new VarExp(e.место, f, нет);
                        результат.тип = f.тип;
                        результат = new AddrExp(e.место, результат, t);
                        return;
                    }
                }
            }

            if (auto f = isFuncAddress(e))
            {
                if (f.checkForwardRef(e.место))
                {
                    результат = new ErrorExp();
                    return;
                }
            }

            посети(cast(Выражение)e);
        }

        override проц посети(TupleExp e)
        {
            if (e.тип.равен(t))
            {
                результат = e;
                return;
            }

            TupleExp te = cast(TupleExp)e.копируй();
            te.e0 = e.e0 ? e.e0.копируй() : null;
            te.exps = e.exps.копируй();
            for (т_мера i = 0; i < te.exps.dim; i++)
            {
                Выражение ex = (*te.exps)[i];
                ex = ex.castTo(sc, t);
                (*te.exps)[i] = ex;
            }
            результат = te;

            /* Questionable behavior: In here, результат.тип is not set to t.
             * Therefoe:
             *  КортежТипов!(цел, цел) values;
             *  auto values2 = cast(long)values;
             *  // typeof(values2) == КортежТипов!(цел, цел) !!
             *
             * Only when the casted кортеж is immediately expanded, it would work.
             *  auto arr = [cast(long)values];
             *  // typeof(arr) == long[]
             */
        }

        override проц посети(ArrayLiteralExp e)
        {
            version (none)
            {
                printf("ArrayLiteralExp::castTo(this=%s, тип=%s, => %s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }

            ArrayLiteralExp ae = e;

            Тип tb = t.toBasetype();
            if (tb.ty == Tarray && глоб2.парамы.vsafe)
            {
                if (checkArrayLiteralEscape(sc, ae, нет))
                {
                    результат = new ErrorExp();
                    return;
                }
            }

            if (e.тип == t)
            {
                результат = e;
                return;
            }
            Тип typeb = e.тип.toBasetype();

            if ((tb.ty == Tarray || tb.ty == Tsarray) &&
                (typeb.ty == Tarray || typeb.ty == Tsarray))
            {
                if (tb.nextOf().toBasetype().ty == Tvoid && typeb.nextOf().toBasetype().ty != Tvoid)
                {
                    // Don't do anything to cast non-проц[] to проц[]
                }
                else if (typeb.ty == Tsarray && typeb.nextOf().toBasetype().ty == Tvoid)
                {
                    // Don't do anything for casting проц[n] to others
                }
                else
                {
                    if (tb.ty == Tsarray)
                    {
                        TypeSArray tsa = cast(TypeSArray)tb;
                        if (e.elements.dim != tsa.dim.toInteger())
                            goto L1;
                    }

                    ae = cast(ArrayLiteralExp)e.копируй();
                    if (e.basis)
                        ae.basis = e.basis.castTo(sc, tb.nextOf());
                    ae.elements = e.elements.копируй();
                    for (т_мера i = 0; i < e.elements.dim; i++)
                    {
                        Выражение ex = (*e.elements)[i];
                        if (!ex)
                            continue;
                        ex = ex.castTo(sc, tb.nextOf());
                        (*ae.elements)[i] = ex;
                    }
                    ae.тип = t;
                    результат = ae;
                    return;
                }
            }
            else if (tb.ty == Tpointer && typeb.ty == Tsarray)
            {
                Тип tp = typeb.nextOf().pointerTo();
                if (!tp.равен(ae.тип))
                {
                    ae = cast(ArrayLiteralExp)e.копируй();
                    ae.тип = tp;
                }
            }
            else if (tb.ty == Tvector && (typeb.ty == Tarray || typeb.ty == Tsarray))
            {
                // Convert массив literal to vector тип
                TypeVector tv = cast(TypeVector)tb;
                TypeSArray tbase = cast(TypeSArray)tv.basetype;
                assert(tbase.ty == Tsarray);
                const edim = e.elements.dim;
                const tbasedim = tbase.dim.toInteger();
                if (edim > tbasedim)
                    goto L1;

                ae = cast(ArrayLiteralExp)e.копируй();
                ae.тип = tbase; // https://issues.dlang.org/show_bug.cgi?ид=12642
                ae.elements = e.elements.копируй();
                Тип telement = tv.elementType();
                foreach (i; new бцел[0 .. edim])
                {
                    Выражение ex = (*e.elements)[i];
                    ex = ex.castTo(sc, telement);
                    (*ae.elements)[i] = ex;
                }
                // Fill in the rest with the default инициализатор
                ae.elements.устДим(cast(т_мера)tbasedim);
                foreach (i; new бцел[edim .. cast(т_мера)tbasedim])
                {
                    Выражение ex = typeb.nextOf.defaultInitLiteral(e.место);
                    ex = ex.castTo(sc, telement);
                    (*ae.elements)[i] = ex;
                }
                Выражение ev = new VectorExp(e.место, ae, tb);
                ev = ev.ВыражениеSemantic(sc);
                результат = ev;
                return;
            }
        L1:
            посети(cast(Выражение)ae);
        }

        override проц посети(AssocArrayLiteralExp e)
        {
            //printf("AssocArrayLiteralExp::castTo(this=%s, тип=%s, => %s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            if (e.тип == t)
            {
                результат = e;
                return;
            }

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (tb.ty == Taarray && typeb.ty == Taarray &&
                tb.nextOf().toBasetype().ty != Tvoid)
            {
                AssocArrayLiteralExp ae = cast(AssocArrayLiteralExp)e.копируй();
                ae.keys = e.keys.копируй();
                ae.values = e.values.копируй();
                assert(e.keys.dim == e.values.dim);
                for (т_мера i = 0; i < e.keys.dim; i++)
                {
                    Выражение ex = (*e.values)[i];
                    ex = ex.castTo(sc, tb.nextOf());
                    (*ae.values)[i] = ex;

                    ex = (*e.keys)[i];
                    ex = ex.castTo(sc, (cast(TypeAArray)tb).index);
                    (*ae.keys)[i] = ex;
                }
                ae.тип = t;
                результат = ae;
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(SymOffExp e)
        {
            version (none)
            {
                printf("SymOffExp::castTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
            if (e.тип == t && !e.hasOverloads)
            {
                результат = e;
                return;
            }

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (tb.равен(typeb))
            {
                результат = e.копируй();
                результат.тип = t;
                (cast(SymOffExp)результат).hasOverloads = нет;
                return;
            }

            // Look for pointers to functions where the functions are overloaded.
            if (e.hasOverloads &&
                typeb.ty == Tpointer && typeb.nextOf().ty == Tfunction &&
                (tb.ty == Tpointer || tb.ty == Tdelegate) && tb.nextOf().ty == Tfunction)
            {
                FuncDeclaration f = e.var.isFuncDeclaration();
                f = f ? f.overloadExactMatch(tb.nextOf()) : null;
                if (f)
                {
                    if (tb.ty == Tdelegate)
                    {
                        if (f.needThis() && hasThis(sc))
                        {
                            результат = new DelegateExp(e.место, new ThisExp(e.место), f, нет);
                            результат = результат.ВыражениеSemantic(sc);
                        }
                        else if (f.needThis())
                        {
                            e.выведиОшибку("no `this` to создай delegate for `%s`", f.вТкст0());
                            результат = new ErrorExp();
                            return;
                        }
                        else if (f.isNested())
                        {
                            результат = new DelegateExp(e.место, IntegerExp.literal!(0)(), f, нет);
                            результат = результат.ВыражениеSemantic(sc);
                        }
                        else
                        {
                            e.выведиОшибку("cannot cast from function pointer to delegate");
                            результат = new ErrorExp();
                            return;
                        }
                    }
                    else
                    {
                        результат = new SymOffExp(e.место, f, 0, нет);
                        результат.тип = t;
                    }
                    f.tookAddressOf++;
                    return;
                }
            }

            if (auto f = isFuncAddress(e))
            {
                if (f.checkForwardRef(e.место))
                {
                    результат = new ErrorExp();
                    return;
                }
            }

            посети(cast(Выражение)e);
        }

        override проц посети(DelegateExp e)
        {
            version (none)
            {
                printf("DelegateExp::castTo(this=%s, тип=%s, t=%s)\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            }
             ткст0 msg = "cannot form delegate due to covariant return тип";

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (tb.равен(typeb) && !e.hasOverloads)
            {
                цел смещение;
                e.func.tookAddressOf++;
                if (e.func.tintro && e.func.tintro.nextOf().isBaseOf(e.func.тип.nextOf(), &смещение) && смещение)
                    e.выведиОшибку("%s", msg);
                результат = e.копируй();
                результат.тип = t;
                return;
            }

            // Look for delegates to functions where the functions are overloaded.
            if (typeb.ty == Tdelegate && tb.ty == Tdelegate)
            {
                if (e.func)
                {
                    auto f = e.func.overloadExactMatch(tb.nextOf());
                    if (f)
                    {
                        цел смещение;
                        if (f.tintro && f.tintro.nextOf().isBaseOf(f.тип.nextOf(), &смещение) && смещение)
                            e.выведиОшибку("%s", msg);
                        if (f != e.func)    // if address not already marked as taken
                            f.tookAddressOf++;
                        результат = new DelegateExp(e.место, e.e1, f, нет, e.vthis2);
                        результат.тип = t;
                        return;
                    }
                    if (e.func.tintro)
                        e.выведиОшибку("%s", msg);
                }
            }

            if (auto f = isFuncAddress(e))
            {
                if (f.checkForwardRef(e.место))
                {
                    результат = new ErrorExp();
                    return;
                }
            }

            посети(cast(Выражение)e);
        }

        override проц посети(FuncExp e)
        {
            //printf("FuncExp::castTo тип = %s, t = %s\n", e.тип.вТкст0(), t.вТкст0());
            FuncExp fe;
            if (e.matchType(t, sc, &fe, 1) > MATCH.nomatch)
            {
                результат = fe;
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(CondExp e)
        {
            if (!e.тип.равен(t))
            {
                результат = new CondExp(e.место, e.econd, e.e1.castTo(sc, t), e.e2.castTo(sc, t));
                результат.тип = t;
                return;
            }
            результат = e;
        }

        override проц посети(CommaExp e)
        {
            Выражение e2c = e.e2.castTo(sc, t);

            if (e2c != e.e2)
            {
                результат = new CommaExp(e.место, e.e1, e2c);
                результат.тип = e2c.тип;
            }
            else
            {
                результат = e;
                результат.тип = e.e2.тип;
            }
        }

        override проц посети(SliceExp e)
        {
            //printf("SliceExp::castTo e = %s, тип = %s, t = %s\n", e.вТкст0(), e.тип.вТкст0(), t.вТкст0());

            Тип tb = t.toBasetype();
            Тип typeb = e.тип.toBasetype();

            if (e.тип.равен(t) || typeb.ty != Tarray ||
                (tb.ty != Tarray && tb.ty != Tsarray))
            {
                посети(cast(Выражение)e);
                return;
            }

            if (tb.ty == Tarray)
            {
                if (typeb.nextOf().equivalent(tb.nextOf()))
                {
                    // T[] to const(T)[]
                    результат = e.копируй();
                    результат.тип = t;
                }
                else
                {
                    посети(cast(Выражение)e);
                }
                return;
            }

            // Handle the cast from Tarray to Tsarray with CT-known slicing

            TypeSArray tsa = cast(TypeSArray)toStaticArrayType(e);
            if (tsa && tsa.size(e.место) == tb.size(e.место))
            {
                /* Match if the sarray sizes are equal:
                 *  T[a .. b] to const(T)[b-a]
                 *  T[a .. b] to U[dim] if (T.sizeof*(b-a) == U.sizeof*dim)
                 *
                 * If a SliceExp has Tsarray, it will become lvalue.
                 * That's handled in SliceExp::isLvalue and toLvalue
                 */
                результат = e.копируй();
                результат.тип = t;
                return;
            }
            if (tsa && tsa.dim.равен((cast(TypeSArray)tb).dim))
            {
                /* Match if the dimensions are equal
                 * with the implicit conversion of e.e1:
                 *  cast(float[2]) [2.0, 1.0, 0.0][0..2];
                 */
                Тип t1b = e.e1.тип.toBasetype();
                if (t1b.ty == Tsarray)
                    t1b = tb.nextOf().sarrayOf((cast(TypeSArray)t1b).dim.toInteger());
                else if (t1b.ty == Tarray)
                    t1b = tb.nextOf().arrayOf();
                else if (t1b.ty == Tpointer)
                    t1b = tb.nextOf().pointerTo();
                else
                    assert(0);
                if (e.e1.implicitConvTo(t1b) > MATCH.nomatch)
                {
                    Выражение e1x = e.e1.implicitCastTo(sc, t1b);
                    assert(e1x.op != ТОК2.error);
                    e = cast(SliceExp)e.копируй();
                    e.e1 = e1x;
                    e.тип = t;
                    результат = e;
                    return;
                }
            }
            auto ts = toAutoQualChars(tsa ? tsa : e.тип, t);
            e.выведиОшибку("cannot cast Выражение `%s` of тип `%s` to `%s`",
                e.вТкст0(), ts[0], ts[1]);
            результат = new ErrorExp();
        }
    }

    scope CastTo v = new CastTo(sc, t);
    e.прими(v);
    return v.результат;
}

/****************************************
 * Set тип inference target
 *      t       Target тип
 *      флаг    1: don't put an error when inference fails
 */
Выражение inferType(Выражение e, Тип t, цел флаг = 0)
{
    Выражение visitAle(ArrayLiteralExp ale)
    {
        Тип tb = t.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            Тип tn = tb.nextOf();
            if (ale.basis)
                ale.basis = inferType(ale.basis, tn, флаг);
            for (т_мера i = 0; i < ale.elements.dim; i++)
            {
                if (Выражение e = (*ale.elements)[i])
                {
                    e = inferType(e, tn, флаг);
                    (*ale.elements)[i] = e;
                }
            }
        }
        return ale;
    }

    Выражение visitAar(AssocArrayLiteralExp aale)
    {
        Тип tb = t.toBasetype();
        if (tb.ty == Taarray)
        {
            TypeAArray taa = cast(TypeAArray)tb;
            Тип ti = taa.index;
            Тип tv = taa.nextOf();
            for (т_мера i = 0; i < aale.keys.dim; i++)
            {
                if (Выражение e = (*aale.keys)[i])
                {
                    e = inferType(e, ti, флаг);
                    (*aale.keys)[i] = e;
                }
            }
            for (т_мера i = 0; i < aale.values.dim; i++)
            {
                if (Выражение e = (*aale.values)[i])
                {
                    e = inferType(e, tv, флаг);
                    (*aale.values)[i] = e;
                }
            }
        }
        return aale;
    }

    Выражение visitFun(FuncExp fe)
    {
        //printf("FuncExp::inferType('%s'), to=%s\n", fe.тип ? fe.тип.вТкст0() : "null", t.вТкст0());
        if (t.ty == Tdelegate || t.ty == Tpointer && t.nextOf().ty == Tfunction)
        {
            fe.fd.treq = t;
        }
        return fe;
    }

    Выражение visitTer(CondExp ce)
    {
        Тип tb = t.toBasetype();
        ce.e1 = inferType(ce.e1, tb, флаг);
        ce.e2 = inferType(ce.e2, tb, флаг);
        return ce;
    }

    if (t) switch (e.op)
    {
        case ТОК2.arrayLiteral:      return visitAle(cast(ArrayLiteralExp) e);
        case ТОК2.assocArrayLiteral: return visitAar(cast(AssocArrayLiteralExp) e);
        case ТОК2.function_:         return visitFun(cast(FuncExp) e);
        case ТОК2.question:          return visitTer(cast(CondExp) e);
        default:
    }
    return e;
}

/****************************************
 * Scale addition/subtraction to/from pointer.
 */
Выражение scaleFactor(BinExp be, Scope* sc)
{
    Тип t1b = be.e1.тип.toBasetype();
    Тип t2b = be.e2.тип.toBasetype();
    Выражение eoff;

    if (t1b.ty == Tpointer && t2b.isintegral())
    {
        // Need to adjust operator by the stride
        // Replace (ptr + цел) with (ptr + (цел * stride))
        Тип t = Тип.tptrdiff_t;

        d_uns64 stride = t1b.nextOf().size(be.место);
        if (!t.равен(t2b))
            be.e2 = be.e2.castTo(sc, t);
        eoff = be.e2;
        be.e2 = new MulExp(be.место, be.e2, new IntegerExp(Место.initial, stride, t));
        be.e2.тип = t;
        be.тип = be.e1.тип;
    }
    else if (t2b.ty == Tpointer && t1b.isintegral())
    {
        // Need to adjust operator by the stride
        // Replace (цел + ptr) with (ptr + (цел * stride))
        Тип t = Тип.tptrdiff_t;
        Выражение e;

        d_uns64 stride = t2b.nextOf().size(be.место);
        if (!t.равен(t1b))
            e = be.e1.castTo(sc, t);
        else
            e = be.e1;
        eoff = e;
        e = new MulExp(be.место, e, new IntegerExp(Место.initial, stride, t));
        e.тип = t;
        be.тип = be.e2.тип;
        be.e1 = be.e2;
        be.e2 = e;
    }
    else
        assert(0);

    if (sc.func && !sc.intypeof)
    {
        eoff = eoff.optimize(WANTvalue);
        if (eoff.op == ТОК2.int64 && eoff.toInteger() == 0)
        {
        }
        else if (sc.func.setUnsafe())
        {
            be.выведиОшибку("pointer arithmetic not allowed in  functions");
            return new ErrorExp();
        }
    }

    return be;
}

/**************************************
 * Return да if e is an empty массив literal with dimensionality
 * equal to or less than тип of other массив.
 * [], [[]], [[[]]], etc.
 * I.e., make sure that [1,2] is compatible with [],
 * [[1,2]] is compatible with [[]], etc.
 */
private бул isVoidArrayLiteral(Выражение e, Тип other)
{
    while (e.op == ТОК2.arrayLiteral && e.тип.ty == Tarray && ((cast(ArrayLiteralExp)e).elements.dim == 1))
    {
        auto ale = cast(ArrayLiteralExp)e;
        e = ale[0];
        if (other.ty == Tsarray || other.ty == Tarray)
            other = other.nextOf();
        else
            return нет;
    }
    if (other.ty != Tsarray && other.ty != Tarray)
        return нет;
    Тип t = e.тип;
    return (e.op == ТОК2.arrayLiteral && t.ty == Tarray && t.nextOf().ty == Tvoid && (cast(ArrayLiteralExp)e).elements.dim == 0);
}

/**************************************
 * Combine types.
 * Output:
 *      *pt     merged тип, if *pt is not NULL
 *      *pe1    rewritten e1
 *      *pe2    rewritten e2
 * Возвращает:
 *      да    успех
 *      нет   failed
 */
бул typeMerge(Scope* sc, ТОК2 op, Тип* pt, Выражение* pe1, Выражение* pe2)
{
    //printf("typeMerge() %s op %s\n", pe1.вТкст0(), pe2.вТкст0());

    MATCH m;
    Выражение e1 = *pe1;
    Выражение e2 = *pe2;

    Тип t1 = e1.тип;
    Тип t2 = e2.тип;

    Тип t1b = e1.тип.toBasetype();
    Тип t2b = e2.тип.toBasetype();

    Тип t;

    бул Lret()
    {
        if (!*pt)
            *pt = t;
        *pe1 = e1;
        *pe2 = e2;

        version (none)
        {
            printf("-typeMerge() %s op %s\n", e1.вТкст0(), e2.вТкст0());
            if (e1.тип)
                printf("\tt1 = %s\n", e1.тип.вТкст0());
            if (e2.тип)
                printf("\tt2 = %s\n", e2.тип.вТкст0());
            printf("\ttype = %s\n", t.вТкст0());
        }
        return да;
    }

    бул Lt1()
    {
        e2 = e2.castTo(sc, t1);
        t = t1;
        return Lret();
    }

    бул Lt2()
    {
        e1 = e1.castTo(sc, t2);
        t = t2;
        return Lret();
    }

    бул Lincompatible() { return нет; }

    if (op != ТОК2.question || t1b.ty != t2b.ty && (t1b.isTypeBasic() && t2b.isTypeBasic()))
    {
        if (op == ТОК2.question && t1b.ischar() && t2b.ischar())
        {
            e1 = charPromotions(e1, sc);
            e2 = charPromotions(e2, sc);
        }
        else
        {
            e1 = integralPromotions(e1, sc);
            e2 = integralPromotions(e2, sc);
        }
    }

    t1 = e1.тип;
    t2 = e2.тип;
    assert(t1);
    t = t1;

    /* The start тип of alias this тип recursion.
     * In following case, we should save A, and stop recursion
     * if it appears again.
     *      X -> Y -> [A] -> B -> A -> B -> ...
     */
    Тип att1 = null;
    Тип att2 = null;

    //if (t1) printf("\tt1 = %s\n", t1.вТкст0());
    //if (t2) printf("\tt2 = %s\n", t2.вТкст0());
    debug
    {
        if (!t2)
            printf("\te2 = '%s'\n", e2.вТкст0());
    }
    assert(t2);

    if (t1.mod != t2.mod &&
        t1.ty == Tenum && t2.ty == Tenum &&
        (cast(TypeEnum)t1).sym == (cast(TypeEnum)t2).sym)
    {
        ббайт mod = MODmerge(t1.mod, t2.mod);
        t1 = t1.castMod(mod);
        t2 = t2.castMod(mod);
    }

Lagain:
    t1b = t1.toBasetype();
    t2b = t2.toBasetype();

    TY ty = cast(TY)impcnvрезультат[t1b.ty][t2b.ty];
    if (ty != Terror)
    {
        TY ty1 = cast(TY)impcnvType1[t1b.ty][t2b.ty];
        TY ty2 = cast(TY)impcnvType2[t1b.ty][t2b.ty];

        if (t1b.ty == ty1) // if no promotions
        {
            if (t1.равен(t2))
            {
                t = t1;
                return Lret();
            }

            if (t1b.равен(t2b))
            {
                t = t1b;
                return Lret();
            }
        }

        t = Тип.basic[ty];

        t1 = Тип.basic[ty1];
        t2 = Тип.basic[ty2];
        e1 = e1.castTo(sc, t1);
        e2 = e2.castTo(sc, t2);
        return Lret();
    }

    t1 = t1b;
    t2 = t2b;

    if (t1.ty == Ttuple || t2.ty == Ttuple)
        return Lincompatible();

    if (t1.равен(t2))
    {
        // merging can not результат in new enum тип
        if (t.ty == Tenum)
            t = t1b;
    }
    else if ((t1.ty == Tpointer && t2.ty == Tpointer) || (t1.ty == Tdelegate && t2.ty == Tdelegate))
    {
        // Bring pointers to compatible тип
        Тип t1n = t1.nextOf();
        Тип t2n = t2.nextOf();

        if (t1n.равен(t2n))
        {
        }
        else if (t1n.ty == Tvoid) // pointers to проц are always compatible
            t = t2;
        else if (t2n.ty == Tvoid)
        {
        }
        else if (t1.implicitConvTo(t2))
        {
            return Lt2();
        }
        else if (t2.implicitConvTo(t1))
        {
            return Lt1();
        }
        else if (t1n.ty == Tfunction && t2n.ty == Tfunction)
        {
            TypeFunction tf1 = cast(TypeFunction)t1n;
            TypeFunction tf2 = cast(TypeFunction)t2n;
            tf1.purityLevel();
            tf2.purityLevel();

            TypeFunction d = cast(TypeFunction)tf1.syntaxCopy();

            if (tf1.purity != tf2.purity)
                d.purity = PURE.impure;
            assert(d.purity != PURE.fwdref);

            d.isnothrow = (tf1.isnothrow && tf2.isnothrow);
            d.isnogc = (tf1.isnogc && tf2.isnogc);

            if (tf1.trust == tf2.trust)
                d.trust = tf1.trust;
            else if (tf1.trust <= TRUST.system || tf2.trust <= TRUST.system)
                d.trust = TRUST.system;
            else
                d.trust = TRUST.trusted;

            Тип tx = null;
            if (t1.ty == Tdelegate)
            {
                tx = new TypeDelegate(d);
            }
            else
                tx = d.pointerTo();

            tx = tx.typeSemantic(e1.место, sc);

            if (t1.implicitConvTo(tx) && t2.implicitConvTo(tx))
            {
                t = tx;
                e1 = e1.castTo(sc, t);
                e2 = e2.castTo(sc, t);
                return Lret();
            }
            return Lincompatible();
        }
        else if (t1n.mod != t2n.mod)
        {
            if (!t1n.isImmutable() && !t2n.isImmutable() && t1n.isShared() != t2n.isShared())
                return Lincompatible();
            ббайт mod = MODmerge(t1n.mod, t2n.mod);
            t1 = t1n.castMod(mod).pointerTo();
            t2 = t2n.castMod(mod).pointerTo();
            t = t1;
            goto Lagain;
        }
        else if (t1n.ty == Tclass && t2n.ty == Tclass)
        {
            ClassDeclaration cd1 = t1n.isClassHandle();
            ClassDeclaration cd2 = t2n.isClassHandle();
            цел смещение;
            if (cd1.isBaseOf(cd2, &смещение))
            {
                if (смещение)
                    e2 = e2.castTo(sc, t);
            }
            else if (cd2.isBaseOf(cd1, &смещение))
            {
                t = t2;
                if (смещение)
                    e1 = e1.castTo(sc, t);
            }
            else
                return Lincompatible();
        }
        else
        {
            t1 = t1n.constOf().pointerTo();
            t2 = t2n.constOf().pointerTo();
            if (t1.implicitConvTo(t2))
            {
                return Lt2();
            }
            else if (t2.implicitConvTo(t1))
            {
                return Lt1();
            }
            return Lincompatible();
        }
    }
    else if ((t1.ty == Tsarray || t1.ty == Tarray) && (e2.op == ТОК2.null_ && t2.ty == Tpointer && t2.nextOf().ty == Tvoid || e2.op == ТОК2.arrayLiteral && t2.ty == Tsarray && t2.nextOf().ty == Tvoid && (cast(TypeSArray)t2).dim.toInteger() == 0 || isVoidArrayLiteral(e2, t1)))
    {
        /*  (T[n] op ук)   => T[]
         *  (T[]  op ук)   => T[]
         *  (T[n] op проц[0]) => T[]
         *  (T[]  op проц[0]) => T[]
         *  (T[n] op проц[])  => T[]
         *  (T[]  op проц[])  => T[]
         */
        goto Lx1;
    }
    else if ((t2.ty == Tsarray || t2.ty == Tarray) && (e1.op == ТОК2.null_ && t1.ty == Tpointer && t1.nextOf().ty == Tvoid || e1.op == ТОК2.arrayLiteral && t1.ty == Tsarray && t1.nextOf().ty == Tvoid && (cast(TypeSArray)t1).dim.toInteger() == 0 || isVoidArrayLiteral(e1, t2)))
    {
        /*  (ук   op T[n]) => T[]
         *  (ук   op T[])  => T[]
         *  (проц[0] op T[n]) => T[]
         *  (проц[0] op T[])  => T[]
         *  (проц[]  op T[n]) => T[]
         *  (проц[]  op T[])  => T[]
         */
        goto Lx2;
    }
    else if ((t1.ty == Tsarray || t1.ty == Tarray) && (m = t1.implicitConvTo(t2)) != MATCH.nomatch)
    {
        // https://issues.dlang.org/show_bug.cgi?ид=7285
        // Tsarray op [x, y, ...] should to be Tsarray
        // https://issues.dlang.org/show_bug.cgi?ид=14737
        // Tsarray ~ [x, y, ...] should to be Tarray
        if (t1.ty == Tsarray && e2.op == ТОК2.arrayLiteral && op != ТОК2.concatenate)
            return Lt1();
        if (m == MATCH.constant && (op == ТОК2.addAssign || op == ТОК2.minAssign || op == ТОК2.mulAssign || op == ТОК2.divAssign || op == ТОК2.modAssign || op == ТОК2.powAssign || op == ТОК2.andAssign || op == ТОК2.orAssign || op == ТОК2.xorAssign))
        {
            // Don't make the lvalue const
            t = t2;
            return Lret();
        }
        return Lt2();
    }
    else if ((t2.ty == Tsarray || t2.ty == Tarray) && t2.implicitConvTo(t1))
    {
        // https://issues.dlang.org/show_bug.cgi?ид=7285
        // https://issues.dlang.org/show_bug.cgi?ид=14737
        if (t2.ty == Tsarray && e1.op == ТОК2.arrayLiteral && op != ТОК2.concatenate)
            return Lt2();
        return Lt1();
    }
    else if ((t1.ty == Tsarray || t1.ty == Tarray || t1.ty == Tpointer) && (t2.ty == Tsarray || t2.ty == Tarray || t2.ty == Tpointer) && t1.nextOf().mod != t2.nextOf().mod)
    {
        /* If one is mutable and the other invariant, then retry
         * with both of them as const
         */
        Тип t1n = t1.nextOf();
        Тип t2n = t2.nextOf();
        ббайт mod;
        if (e1.op == ТОК2.null_ && e2.op != ТОК2.null_)
            mod = t2n.mod;
        else if (e1.op != ТОК2.null_ && e2.op == ТОК2.null_)
            mod = t1n.mod;
        else if (!t1n.isImmutable() && !t2n.isImmutable() && t1n.isShared() != t2n.isShared())
            return Lincompatible();
        else
            mod = MODmerge(t1n.mod, t2n.mod);

        if (t1.ty == Tpointer)
            t1 = t1n.castMod(mod).pointerTo();
        else
            t1 = t1n.castMod(mod).arrayOf();

        if (t2.ty == Tpointer)
            t2 = t2n.castMod(mod).pointerTo();
        else
            t2 = t2n.castMod(mod).arrayOf();
        t = t1;
        goto Lagain;
    }
    else if (t1.ty == Tclass && t2.ty == Tclass)
    {
        if (t1.mod != t2.mod)
        {
            ббайт mod;
            if (e1.op == ТОК2.null_ && e2.op != ТОК2.null_)
                mod = t2.mod;
            else if (e1.op != ТОК2.null_ && e2.op == ТОК2.null_)
                mod = t1.mod;
            else if (!t1.isImmutable() && !t2.isImmutable() && t1.isShared() != t2.isShared())
                return Lincompatible();
            else
                mod = MODmerge(t1.mod, t2.mod);
            t1 = t1.castMod(mod);
            t2 = t2.castMod(mod);
            t = t1;
            goto Lagain;
        }
        goto Lcc;
    }
    else if (t1.ty == Tclass || t2.ty == Tclass)
    {
    Lcc:
        while (1)
        {
            MATCH i1 = e2.implicitConvTo(t1);
            MATCH i2 = e1.implicitConvTo(t2);

            if (i1 && i2)
            {
                // We have the case of class vs. ук, so pick class
                if (t1.ty == Tpointer)
                    i1 = MATCH.nomatch;
                else if (t2.ty == Tpointer)
                    i2 = MATCH.nomatch;
            }

            if (i2)
            {
                e2 = e2.castTo(sc, t2);
                return Lt2();
            }
            else if (i1)
            {
                e1 = e1.castTo(sc, t1);
                return Lt1();
            }
            else if (t1.ty == Tclass && t2.ty == Tclass)
            {
                TypeClass tc1 = cast(TypeClass)t1;
                TypeClass tc2 = cast(TypeClass)t2;

                /* Pick 'tightest' тип
                 */
                ClassDeclaration cd1 = tc1.sym.baseClass;
                ClassDeclaration cd2 = tc2.sym.baseClass;
                if (cd1 && cd2)
                {
                    t1 = cd1.тип.castMod(t1.mod);
                    t2 = cd2.тип.castMod(t2.mod);
                }
                else if (cd1)
                    t1 = cd1.тип;
                else if (cd2)
                    t2 = cd2.тип;
                else
                    return Lincompatible();
            }
            else if (t1.ty == Tstruct && (cast(TypeStruct)t1).sym.aliasthis)
            {
                if (att1 && e1.тип == att1)
                    return Lincompatible();
                if (!att1 && e1.тип.checkAliasThisRec())
                    att1 = e1.тип;
                //printf("att tmerge(c || c) e1 = %s\n", e1.тип.вТкст0());
                e1 = resolveAliasThis(sc, e1);
                t1 = e1.тип;
                continue;
            }
            else if (t2.ty == Tstruct && (cast(TypeStruct)t2).sym.aliasthis)
            {
                if (att2 && e2.тип == att2)
                    return Lincompatible();
                if (!att2 && e2.тип.checkAliasThisRec())
                    att2 = e2.тип;
                //printf("att tmerge(c || c) e2 = %s\n", e2.тип.вТкст0());
                e2 = resolveAliasThis(sc, e2);
                t2 = e2.тип;
                continue;
            }
            else
                return Lincompatible();
        }
    }
    else if (t1.ty == Tstruct && t2.ty == Tstruct)
    {
        if (t1.mod != t2.mod)
        {
            if (!t1.isImmutable() && !t2.isImmutable() && t1.isShared() != t2.isShared())
                return Lincompatible();
            ббайт mod = MODmerge(t1.mod, t2.mod);
            t1 = t1.castMod(mod);
            t2 = t2.castMod(mod);
            t = t1;
            goto Lagain;
        }

        TypeStruct ts1 = cast(TypeStruct)t1;
        TypeStruct ts2 = cast(TypeStruct)t2;
        if (ts1.sym != ts2.sym)
        {
            if (!ts1.sym.aliasthis && !ts2.sym.aliasthis)
                return Lincompatible();

            MATCH i1 = MATCH.nomatch;
            MATCH i2 = MATCH.nomatch;

            Выражение e1b = null;
            Выражение e2b = null;
            if (ts2.sym.aliasthis)
            {
                if (att2 && e2.тип == att2)
                    return Lincompatible();
                if (!att2 && e2.тип.checkAliasThisRec())
                    att2 = e2.тип;
                //printf("att tmerge(s && s) e2 = %s\n", e2.тип.вТкст0());
                e2b = resolveAliasThis(sc, e2);
                i1 = e2b.implicitConvTo(t1);
            }
            if (ts1.sym.aliasthis)
            {
                if (att1 && e1.тип == att1)
                    return Lincompatible();
                if (!att1 && e1.тип.checkAliasThisRec())
                    att1 = e1.тип;
                //printf("att tmerge(s && s) e1 = %s\n", e1.тип.вТкст0());
                e1b = resolveAliasThis(sc, e1);
                i2 = e1b.implicitConvTo(t2);
            }
            if (i1 && i2)
                return Lincompatible();

            if (i1)
                return Lt1();
            else if (i2)
                return Lt2();

            if (e1b)
            {
                e1 = e1b;
                t1 = e1b.тип.toBasetype();
            }
            if (e2b)
            {
                e2 = e2b;
                t2 = e2b.тип.toBasetype();
            }
            t = t1;
            goto Lagain;
        }
    }
    else if (t1.ty == Tstruct || t2.ty == Tstruct)
    {
        if (t1.ty == Tstruct && (cast(TypeStruct)t1).sym.aliasthis)
        {
            if (att1 && e1.тип == att1)
                return Lincompatible();
            if (!att1 && e1.тип.checkAliasThisRec())
                att1 = e1.тип;
            //printf("att tmerge(s || s) e1 = %s\n", e1.тип.вТкст0());
            e1 = resolveAliasThis(sc, e1);
            t1 = e1.тип;
            t = t1;
            goto Lagain;
        }
        if (t2.ty == Tstruct && (cast(TypeStruct)t2).sym.aliasthis)
        {
            if (att2 && e2.тип == att2)
                return Lincompatible();
            if (!att2 && e2.тип.checkAliasThisRec())
                att2 = e2.тип;
            //printf("att tmerge(s || s) e2 = %s\n", e2.тип.вТкст0());
            e2 = resolveAliasThis(sc, e2);
            t2 = e2.тип;
            t = t2;
            goto Lagain;
        }
        return Lincompatible();
    }
    else if ((e1.op == ТОК2.string_ || e1.op == ТОК2.null_) && e1.implicitConvTo(t2))
    {
        return Lt2();
    }
    else if ((e2.op == ТОК2.string_ || e2.op == ТОК2.null_) && e2.implicitConvTo(t1))
    {
        return Lt1();
    }
    else if (t1.ty == Tsarray && t2.ty == Tsarray && e2.implicitConvTo(t1.nextOf().arrayOf()))
    {
    Lx1:
        t = t1.nextOf().arrayOf(); // T[]
        e1 = e1.castTo(sc, t);
        e2 = e2.castTo(sc, t);
    }
    else if (t1.ty == Tsarray && t2.ty == Tsarray && e1.implicitConvTo(t2.nextOf().arrayOf()))
    {
    Lx2:
        t = t2.nextOf().arrayOf();
        e1 = e1.castTo(sc, t);
        e2 = e2.castTo(sc, t);
    }
    else if (t1.ty == Tvector && t2.ty == Tvector)
    {
        // https://issues.dlang.org/show_bug.cgi?ид=13841
        // all vector types should have no common types between
        // different vectors, even though their sizes are same.
        auto tv1 = cast(TypeVector)t1;
        auto tv2 = cast(TypeVector)t2;
        if (!tv1.basetype.равен(tv2.basetype))
            return Lincompatible();

        goto LmodCompare;
    }
    else if (t1.ty == Tvector && t2.ty != Tvector && e2.implicitConvTo(t1))
    {
        e2 = e2.castTo(sc, t1);
        t2 = t1;
        t = t1;
        goto Lagain;
    }
    else if (t2.ty == Tvector && t1.ty != Tvector && e1.implicitConvTo(t2))
    {
        e1 = e1.castTo(sc, t2);
        t1 = t2;
        t = t1;
        goto Lagain;
    }
    else if (t1.isintegral() && t2.isintegral())
    {
        if (t1.ty != t2.ty)
        {
            if (t1.ty == Tvector || t2.ty == Tvector)
                return Lincompatible();
            e1 = integralPromotions(e1, sc);
            e2 = integralPromotions(e2, sc);
            t1 = e1.тип;
            t2 = e2.тип;
            goto Lagain;
        }
        assert(t1.ty == t2.ty);
LmodCompare:
        if (!t1.isImmutable() && !t2.isImmutable() && t1.isShared() != t2.isShared())
            return Lincompatible();
        ббайт mod = MODmerge(t1.mod, t2.mod);

        t1 = t1.castMod(mod);
        t2 = t2.castMod(mod);
        t = t1;
        e1 = e1.castTo(sc, t);
        e2 = e2.castTo(sc, t);
        goto Lagain;
    }
    else if (t1.ty == Tnull && t2.ty == Tnull)
    {
        ббайт mod = MODmerge(t1.mod, t2.mod);

        t = t1.castMod(mod);
        e1 = e1.castTo(sc, t);
        e2 = e2.castTo(sc, t);
        return Lret();
    }
    else if (t2.ty == Tnull && (t1.ty == Tpointer || t1.ty == Taarray || t1.ty == Tarray))
    {
        return Lt1();
    }
    else if (t1.ty == Tnull && (t2.ty == Tpointer || t2.ty == Taarray || t2.ty == Tarray))
    {
        return Lt2();
    }
    else if (t1.ty == Tarray && isBinArrayOp(op) && isArrayOpOperand(e1))
    {
        if (e2.implicitConvTo(t1.nextOf()))
        {
            // T[] op T
            // T[] op cast(T)U
            e2 = e2.castTo(sc, t1.nextOf());
            t = t1.nextOf().arrayOf();
        }
        else if (t1.nextOf().implicitConvTo(e2.тип))
        {
            // (cast(T)U)[] op T    (https://issues.dlang.org/show_bug.cgi?ид=12780)
            // e1 is left as U[], it will be handled in arrayOp() later.
            t = e2.тип.arrayOf();
        }
        else if (t2.ty == Tarray && isArrayOpOperand(e2))
        {
            if (t1.nextOf().implicitConvTo(t2.nextOf()))
            {
                // (cast(T)U)[] op T[]  (https://issues.dlang.org/show_bug.cgi?ид=12780)
                t = t2.nextOf().arrayOf();
                // if cast won't be handled in arrayOp() later
                if (!isArrayOpImplicitCast(t1.isTypeDArray(), t2.isTypeDArray()))
                    e1 = e1.castTo(sc, t);
            }
            else if (t2.nextOf().implicitConvTo(t1.nextOf()))
            {
                // T[] op (cast(T)U)[]  (https://issues.dlang.org/show_bug.cgi?ид=12780)
                // e2 is left as U[], it will be handled in arrayOp() later.
                t = t1.nextOf().arrayOf();
                // if cast won't be handled in arrayOp() later
                if (!isArrayOpImplicitCast(t2.isTypeDArray(), t1.isTypeDArray()))
                    e2 = e2.castTo(sc, t);
            }
            else
                return Lincompatible();
        }
        else
            return Lincompatible();
    }
    else if (t2.ty == Tarray && isBinArrayOp(op) && isArrayOpOperand(e2))
    {
        if (e1.implicitConvTo(t2.nextOf()))
        {
            // T op T[]
            // cast(T)U op T[]
            e1 = e1.castTo(sc, t2.nextOf());
            t = t2.nextOf().arrayOf();
        }
        else if (t2.nextOf().implicitConvTo(e1.тип))
        {
            // T op (cast(T)U)[]    (https://issues.dlang.org/show_bug.cgi?ид=12780)
            // e2 is left as U[], it will be handled in arrayOp() later.
            t = e1.тип.arrayOf();
        }
        else
            return Lincompatible();

        //printf("test %s\n", Сема2::вТкст0(op));
        e1 = e1.optimize(WANTvalue);
        if (isCommutative(op) && e1.isConst())
        {
            /* Swap operands to minimize number of functions generated
             */
            //printf("swap %s\n", Сема2::вТкст0(op));
            Выражение tmp = e1;
            e1 = e2;
            e2 = tmp;
        }
    }
    else
    {
        return Lincompatible();
    }
    return Lret();
}

/************************************
 * Bring leaves to common тип.
 * Возвращает:
 *    null on успех, ErrorExp if error occurs
 */
Выражение typeCombine(BinExp be, Scope* sc)
{
    Выражение errorReturn()
    {
        Выражение ex = be.incompatibleTypes();
        if (ex.op == ТОК2.error)
            return ex;
        return new ErrorExp();
    }

    Тип t1 = be.e1.тип.toBasetype();
    Тип t2 = be.e2.тип.toBasetype();

    if (be.op == ТОК2.min || be.op == ТОК2.add)
    {
        // struct+struct, and class+class are errors
        if (t1.ty == Tstruct && t2.ty == Tstruct)
            return errorReturn();
        else if (t1.ty == Tclass && t2.ty == Tclass)
            return errorReturn();
        else if (t1.ty == Taarray && t2.ty == Taarray)
            return errorReturn();
    }

    if (!typeMerge(sc, be.op, &be.тип, &be.e1, &be.e2))
        return errorReturn();

    // If the types have no значение, return an error
    if (be.e1.op == ТОК2.error)
        return be.e1;
    if (be.e2.op == ТОК2.error)
        return be.e2;
    return null;
}

/***********************************
 * Do integral promotions (convertchk).
 * Don't convert <массив of> to <pointer to>
 */
Выражение integralPromotions(Выражение e, Scope* sc)
{
    //printf("integralPromotions %s %s\n", e.вТкст0(), e.тип.вТкст0());
    switch (e.тип.toBasetype().ty)
    {
    case Tvoid:
        e.выведиОшибку("проц has no значение");
        return new ErrorExp();

    case Tint8:
    case Tuns8:
    case Tint16:
    case Tuns16:
    case Tbool:
    case Tchar:
    case Twchar:
        e = e.castTo(sc, Тип.tint32);
        break;

    case Tdchar:
        e = e.castTo(sc, Тип.tuns32);
        break;

    default:
        break;
    }
    return e;
}

/***********************************
 * Do сим promotions.
 *   сим  -> dchar
 *   wchar -> dchar
 *   dchar -> dchar
 */
Выражение charPromotions(Выражение e, Scope* sc)
{
    //printf("charPromotions %s %s\n", e.вТкст0(), e.тип.вТкст0());
    switch (e.тип.toBasetype().ty)
    {
    case Tchar:
    case Twchar:
    case Tdchar:
        e = e.castTo(sc, Тип.tdchar);
        break;

    default:
        assert(0);
    }
    return e;
}

/******************************************************
 * This provides a transition from the non-promoting behavior
 * of unary + - ~ to the C-like integral promotion behavior.
 * Параметры:
 *    sc = context
 *    ue = NegExp, UAddExp, or ComExp which is revised per rules
 * References:
 *      https://issues.dlang.org/show_bug.cgi?ид=16997
 */

проц fix16997(Scope* sc, UnaExp ue)
{
    if (глоб2.парамы.fix16997)
        ue.e1 = integralPromotions(ue.e1, sc);          // desired C-like behavor
    else
    {
        switch (ue.e1.тип.toBasetype.ty)
        {
            case Tint8:
            case Tuns8:
            case Tint16:
            case Tuns16:
            //case Tbool:       // these operations aren't allowed on бул anyway
            case Tchar:
            case Twchar:
            case Tdchar:
                ue.deprecation("integral promotion not done for `%s`, use '-preview=intpromote' switch or `%scast(цел)(%s)`",
                    ue.вТкст0(), Сема2.вТкст0(ue.op), ue.e1.вТкст0());
                break;

            default:
                break;
        }
    }
}

/***********************************
 * See if both types are arrays that can be compared
 * for equality. Return да if so.
 * If they are arrays, but incompatible, issue error.
 * This is to enable comparing things like an const
 * массив with a mutable one.
 */
 бул arrayTypeCompatible(Место место, Тип t1, Тип t2)
{
    t1 = t1.toBasetype().merge2();
    t2 = t2.toBasetype().merge2();

    if ((t1.ty == Tarray || t1.ty == Tsarray || t1.ty == Tpointer) && (t2.ty == Tarray || t2.ty == Tsarray || t2.ty == Tpointer))
    {
        if (t1.nextOf().implicitConvTo(t2.nextOf()) < MATCH.constant && t2.nextOf().implicitConvTo(t1.nextOf()) < MATCH.constant && (t1.nextOf().ty != Tvoid && t2.nextOf().ty != Tvoid))
        {
            выведиОшибку(место, "массив equality comparison тип mismatch, `%s` vs `%s`", t1.вТкст0(), t2.вТкст0());
        }
        return да;
    }
    return нет;
}

/***********************************
 * See if both types are arrays that can be compared
 * for equality without any casting. Return да if so.
 * This is to enable comparing things like an const
 * массив with a mutable one.
 */
 бул arrayTypeCompatibleWithoutCasting(Тип t1, Тип t2)
{
    t1 = t1.toBasetype();
    t2 = t2.toBasetype();

    if ((t1.ty == Tarray || t1.ty == Tsarray || t1.ty == Tpointer) && t2.ty == t1.ty)
    {
        if (t1.nextOf().implicitConvTo(t2.nextOf()) >= MATCH.constant || t2.nextOf().implicitConvTo(t1.nextOf()) >= MATCH.constant)
            return да;
    }
    return нет;
}

/******************************************************************/
/* Determine the integral ranges of an Выражение.
 * This is используется to determine if implicit narrowing conversions will
 * be allowed.
 */
IntRange getIntRange(Выражение e)
{
     final class IntRangeVisitor : Визитор2
    {
        alias Визитор2.посети посети;

    public:
        IntRange range;

        override проц посети(Выражение e)
        {
            range = IntRange.fromType(e.тип);
        }

        override проц посети(IntegerExp e)
        {
            range = IntRange(SignExtendedNumber(e.getInteger()))._cast(e.тип);
        }

        override проц посети(CastExp e)
        {
            range = getIntRange(e.e1)._cast(e.тип);
        }

        override проц посети(AddExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);
            range = (ir1 + ir2)._cast(e.тип);
        }

        override проц посети(MinExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);
            range = (ir1 - ir2)._cast(e.тип);
        }

        override проц посети(DivExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);

            range = (ir1 / ir2)._cast(e.тип);
        }

        override проц посети(MulExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);

            range = (ir1 * ir2)._cast(e.тип);
        }

        override проц посети(ModExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);

            // Modding on 0 is invalid anyway.
            if (!ir2.absNeg().imin.negative)
            {
                посети(cast(Выражение)e);
                return;
            }
            range = (ir1 % ir2)._cast(e.тип);
        }

        override проц посети(AndExp e)
        {
            IntRange результат;
            бул hasрезультат = нет;
            результат.unionOrAssign(getIntRange(e.e1) & getIntRange(e.e2), hasрезультат);

            assert(hasрезультат);
            range = результат._cast(e.тип);
        }

        override проц посети(OrExp e)
        {
            IntRange результат;
            бул hasрезультат = нет;
            результат.unionOrAssign(getIntRange(e.e1) | getIntRange(e.e2), hasрезультат);

            assert(hasрезультат);
            range = результат._cast(e.тип);
        }

        override проц посети(XorExp e)
        {
            IntRange результат;
            бул hasрезультат = нет;
            результат.unionOrAssign(getIntRange(e.e1) ^ getIntRange(e.e2), hasрезультат);

            assert(hasрезультат);
            range = результат._cast(e.тип);
        }

        override проц посети(ShlExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);

            range = (ir1 << ir2)._cast(e.тип);
        }

        override проц посети(ShrExp e)
        {
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);

            range = (ir1 >> ir2)._cast(e.тип);
        }

        override проц посети(UshrExp e)
        {
            IntRange ir1 = getIntRange(e.e1).castUnsigned(e.e1.тип);
            IntRange ir2 = getIntRange(e.e2);

            range = (ir1 >>> ir2)._cast(e.тип);
        }

        override проц посети(AssignExp e)
        {
            range = getIntRange(e.e2)._cast(e.тип);
        }

        override проц посети(CondExp e)
        {
            // No need to check e.econd; assume caller has called optimize()
            IntRange ir1 = getIntRange(e.e1);
            IntRange ir2 = getIntRange(e.e2);
            range = ir1.unionWith(ir2)._cast(e.тип);
        }

        override проц посети(VarExp e)
        {
            Выражение ie;
            VarDeclaration vd = e.var.isVarDeclaration();
            if (vd && vd.range)
                range = vd.range._cast(e.тип);
            else if (vd && vd._иниц && !vd.тип.isMutable() && (ie = vd.getConstInitializer()) !is null)
                ie.прими(this);
            else
                посети(cast(Выражение)e);
        }

        override проц посети(CommaExp e)
        {
            e.e2.прими(this);
        }

        override проц посети(ComExp e)
        {
            IntRange ir = getIntRange(e.e1);
            range = IntRange(SignExtendedNumber(~ir.imax.значение, !ir.imax.negative), SignExtendedNumber(~ir.imin.значение, !ir.imin.negative))._cast(e.тип);
        }

        override проц посети(NegExp e)
        {
            IntRange ir = getIntRange(e.e1);
            range = (-ir)._cast(e.тип);
        }
    }

    scope IntRangeVisitor v = new IntRangeVisitor();
    e.прими(v);
    return v.range;
}
