/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/constfold.d, _constfold.d)
 * Documentation:  https://dlang.org/phobos/dmd_constfold.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/constfold.d
 */

module dmd.constfold;

import cidrus;
import dmd.arraytypes;
import dmd.complex;
import dmd.ctfeexpr;
import dmd.declaration;
import dmd.dstruct;
import dmd.errors;
import drc.ast.Expression;
import dmd.globals;
import dmd.mtype;
import util.ctfloat;
import util.port;
import util.rmem;
import dmd.sideeffect;
import dmd.target;
import drc.lexer.Tokens;
import util.utf;

private const LOG = нет;

private Выражение expType(Тип тип, Выражение e)
{
    if (тип != e.тип)
    {
        e = e.копируй();
        e.тип = тип;
    }
    return e;
}

/************************************
 * Возвращает:
 *    да if e is a constant
 */
цел isConst(Выражение e)
{
    //printf("Выражение::isConst(): %s\n", e.вТкст0());
    switch (e.op)
    {
    case ТОК2.int64:
    case ТОК2.float64:
    case ТОК2.complex80:
        return 1;
    case ТОК2.null_:
        return 0;
    case ТОК2.symbolOffset:
        return 2;
    default:
        return 0;
    }
    assert(0);
}

/**********************************
 * Initialize a ТОК2.cantВыражение Выражение.
 * Параметры:
 *      ue = where to пиши it
 */
проц cantExp(out UnionExp ue)
{
    emplaceExp!(CTFEExp)(&ue, ТОК2.cantВыражение);
}

/* =============================== constFold() ============================== */
/* The constFold() functions were redundant with the optimize() ones,
 * and so have been folded in with them.
 */
/* ========================================================================== */
UnionExp Neg(Тип тип, Выражение e1)
{
    UnionExp ue = проц;
    Место место = e1.место;
    if (e1.тип.isreal())
    {
        emplaceExp!(RealExp)(&ue, место, -e1.toReal(), тип);
    }
    else if (e1.тип.isimaginary())
    {
        emplaceExp!(RealExp)(&ue, место, -e1.toImaginary(), тип);
    }
    else if (e1.тип.iscomplex())
    {
        emplaceExp!(ComplexExp)(&ue, место, -e1.toComplex(), тип);
    }
    else
    {
        emplaceExp!(IntegerExp)(&ue, место, -e1.toInteger(), тип);
    }
    return ue;
}

UnionExp Com(Тип тип, Выражение e1)
{
    UnionExp ue = проц;
    Место место = e1.место;
    emplaceExp!(IntegerExp)(&ue, место, ~e1.toInteger(), тип);
    return ue;
}

UnionExp Not(Тип тип, Выражение e1)
{
    UnionExp ue = проц;
    Место место = e1.место;
    emplaceExp!(IntegerExp)(&ue, место, e1.isBool(нет) ? 1 : 0, тип);
    return ue;
}

private UnionExp Bool(Тип тип, Выражение e1)
{
    UnionExp ue = проц;
    Место место = e1.место;
    emplaceExp!(IntegerExp)(&ue, место, e1.isBool(да) ? 1 : 0, тип);
    return ue;
}

UnionExp Add(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    static if (LOG)
    {
        printf("Add(e1 = %s, e2 = %s)\n", e1.вТкст0(), e2.вТкст0());
    }
    if (тип.isreal())
    {
        emplaceExp!(RealExp)(&ue, место, e1.toReal() + e2.toReal(), тип);
    }
    else if (тип.isimaginary())
    {
        emplaceExp!(RealExp)(&ue, место, e1.toImaginary() + e2.toImaginary(), тип);
    }
    else if (тип.iscomplex())
    {
        // This rigamarole is necessary so that -0.0 doesn't get
        // converted to +0.0 by doing an extraneous add with +0.0
        auto c1 = complex_t(CTFloat.нуль);
        real_t r1 = CTFloat.нуль;
        real_t i1 = CTFloat.нуль;
        auto c2 = complex_t(CTFloat.нуль);
        real_t r2 = CTFloat.нуль;
        real_t i2 = CTFloat.нуль;
        auto v = complex_t(CTFloat.нуль);
        цел x;
        if (e1.тип.isreal())
        {
            r1 = e1.toReal();
            x = 0;
        }
        else if (e1.тип.isimaginary())
        {
            i1 = e1.toImaginary();
            x = 3;
        }
        else
        {
            c1 = e1.toComplex();
            x = 6;
        }
        if (e2.тип.isreal())
        {
            r2 = e2.toReal();
        }
        else if (e2.тип.isimaginary())
        {
            i2 = e2.toImaginary();
            x += 1;
        }
        else
        {
            c2 = e2.toComplex();
            x += 2;
        }
        switch (x)
        {
        case 0 + 0:
            v = complex_t(r1 + r2);
            break;
        case 0 + 1:
            v = complex_t(r1, i2);
            break;
        case 0 + 2:
            v = complex_t(r1 + creall(c2), cimagl(c2));
            break;
        case 3 + 0:
            v = complex_t(r2, i1);
            break;
        case 3 + 1:
            v = complex_t(CTFloat.нуль, i1 + i2);
            break;
        case 3 + 2:
            v = complex_t(creall(c2), i1 + cimagl(c2));
            break;
        case 6 + 0:
            v = complex_t(creall(c1) + r2, cimagl(c2));
            break;
        case 6 + 1:
            v = complex_t(creall(c1), cimagl(c1) + i2);
            break;
        case 6 + 2:
            v = c1 + c2;
            break;
        default:
            assert(0);
        }
        emplaceExp!(ComplexExp)(&ue, место, v, тип);
    }
    else if (e1.op == ТОК2.symbolOffset)
    {
        SymOffExp soe = cast(SymOffExp)e1;
        emplaceExp!(SymOffExp)(&ue, место, soe.var, soe.смещение + e2.toInteger());
        ue.exp().тип = тип;
    }
    else if (e2.op == ТОК2.symbolOffset)
    {
        SymOffExp soe = cast(SymOffExp)e2;
        emplaceExp!(SymOffExp)(&ue, место, soe.var, soe.смещение + e1.toInteger());
        ue.exp().тип = тип;
    }
    else
        emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() + e2.toInteger(), тип);
    return ue;
}

UnionExp Min(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    if (тип.isreal())
    {
        emplaceExp!(RealExp)(&ue, место, e1.toReal() - e2.toReal(), тип);
    }
    else if (тип.isimaginary())
    {
        emplaceExp!(RealExp)(&ue, место, e1.toImaginary() - e2.toImaginary(), тип);
    }
    else if (тип.iscomplex())
    {
        // This rigamarole is necessary so that -0.0 doesn't get
        // converted to +0.0 by doing an extraneous add with +0.0
        auto c1 = complex_t(CTFloat.нуль);
        real_t r1 = CTFloat.нуль;
        real_t i1 = CTFloat.нуль;
        auto c2 = complex_t(CTFloat.нуль);
        real_t r2 = CTFloat.нуль;
        real_t i2 = CTFloat.нуль;
        auto v = complex_t(CTFloat.нуль);
        цел x;
        if (e1.тип.isreal())
        {
            r1 = e1.toReal();
            x = 0;
        }
        else if (e1.тип.isimaginary())
        {
            i1 = e1.toImaginary();
            x = 3;
        }
        else
        {
            c1 = e1.toComplex();
            x = 6;
        }
        if (e2.тип.isreal())
        {
            r2 = e2.toReal();
        }
        else if (e2.тип.isimaginary())
        {
            i2 = e2.toImaginary();
            x += 1;
        }
        else
        {
            c2 = e2.toComplex();
            x += 2;
        }
        switch (x)
        {
        case 0 + 0:
            v = complex_t(r1 - r2);
            break;
        case 0 + 1:
            v = complex_t(r1, -i2);
            break;
        case 0 + 2:
            v = complex_t(r1 - creall(c2), -cimagl(c2));
            break;
        case 3 + 0:
            v = complex_t(-r2, i1);
            break;
        case 3 + 1:
            v = complex_t(CTFloat.нуль, i1 - i2);
            break;
        case 3 + 2:
            v = complex_t(-creall(c2), i1 - cimagl(c2));
            break;
        case 6 + 0:
            v = complex_t(creall(c1) - r2, cimagl(c1));
            break;
        case 6 + 1:
            v = complex_t(creall(c1), cimagl(c1) - i2);
            break;
        case 6 + 2:
            v = c1 - c2;
            break;
        default:
            assert(0);
        }
        emplaceExp!(ComplexExp)(&ue, место, v, тип);
    }
    else if (e1.op == ТОК2.symbolOffset)
    {
        SymOffExp soe = cast(SymOffExp)e1;
        emplaceExp!(SymOffExp)(&ue, место, soe.var, soe.смещение - e2.toInteger());
        ue.exp().тип = тип;
    }
    else
    {
        emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() - e2.toInteger(), тип);
    }
    return ue;
}

UnionExp Mul(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    if (тип.isfloating())
    {
        auto c = complex_t(CTFloat.нуль);
        real_t r = CTFloat.нуль;
        if (e1.тип.isreal())
        {
            r = e1.toReal();
            c = e2.toComplex();
            c = complex_t(r * creall(c), r * cimagl(c));
        }
        else if (e1.тип.isimaginary())
        {
            r = e1.toImaginary();
            c = e2.toComplex();
            c = complex_t(-r * cimagl(c), r * creall(c));
        }
        else if (e2.тип.isreal())
        {
            r = e2.toReal();
            c = e1.toComplex();
            c = complex_t(r * creall(c), r * cimagl(c));
        }
        else if (e2.тип.isimaginary())
        {
            r = e2.toImaginary();
            c = e1.toComplex();
            c = complex_t(-r * cimagl(c), r * creall(c));
        }
        else
            c = e1.toComplex() * e2.toComplex();
        if (тип.isreal())
            emplaceExp!(RealExp)(&ue, место, creall(c), тип);
        else if (тип.isimaginary())
            emplaceExp!(RealExp)(&ue, место, cimagl(c), тип);
        else if (тип.iscomplex())
            emplaceExp!(ComplexExp)(&ue, место, c, тип);
        else
            assert(0);
    }
    else
    {
        emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() * e2.toInteger(), тип);
    }
    return ue;
}

UnionExp Div(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    if (тип.isfloating())
    {
        auto c = complex_t(CTFloat.нуль);
        if (e2.тип.isreal())
        {
            if (e1.тип.isreal())
            {
                emplaceExp!(RealExp)(&ue, место, e1.toReal() / e2.toReal(), тип);
                return ue;
            }
            const r = e2.toReal();
            c = e1.toComplex();
            c = complex_t(creall(c) / r, cimagl(c) / r);
        }
        else if (e2.тип.isimaginary())
        {
            const r = e2.toImaginary();
            c = e1.toComplex();
            c = complex_t(cimagl(c) / r, -creall(c) / r);
        }
        else
        {
            c = e1.toComplex() / e2.toComplex();
        }

        if (тип.isreal())
            emplaceExp!(RealExp)(&ue, место, creall(c), тип);
        else if (тип.isimaginary())
            emplaceExp!(RealExp)(&ue, место, cimagl(c), тип);
        else if (тип.iscomplex())
            emplaceExp!(ComplexExp)(&ue, место, c, тип);
        else
            assert(0);
    }
    else
    {
        sinteger_t n1;
        sinteger_t n2;
        sinteger_t n;
        n1 = e1.toInteger();
        n2 = e2.toInteger();
        if (n2 == 0)
        {
            e2.выведиОшибку("divide by 0");
            emplaceExp!(ErrorExp)(&ue);
            return ue;
        }
        if (n2 == -1 && !тип.isunsigned())
        {
            // Check for цел.min / -1
            if (n1 == 0xFFFFFFFF80000000UL && тип.toBasetype().ty != Tint64)
            {
                e2.выведиОшибку("integer overflow: `цел.min / -1`");
                emplaceExp!(ErrorExp)(&ue);
                return ue;
            }
            else if (n1 == 0x8000000000000000L) // long.min / -1
            {
                e2.выведиОшибку("integer overflow: `long.min / -1L`");
                emplaceExp!(ErrorExp)(&ue);
                return ue;
            }
        }
        if (e1.тип.isunsigned() || e2.тип.isunsigned())
            n = (cast(dinteger_t)n1) / (cast(dinteger_t)n2);
        else
            n = n1 / n2;
        emplaceExp!(IntegerExp)(&ue, место, n, тип);
    }
    return ue;
}

UnionExp Mod(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    if (тип.isfloating())
    {
        auto c = complex_t(CTFloat.нуль);
        if (e2.тип.isreal())
        {
            const r2 = e2.toReal();
            c = complex_t(e1.toReal() % r2, e1.toImaginary() % r2);
        }
        else if (e2.тип.isimaginary())
        {
            const i2 = e2.toImaginary();
            c = complex_t(e1.toReal() % i2, e1.toImaginary() % i2);
        }
        else
            assert(0);
        if (тип.isreal())
            emplaceExp!(RealExp)(&ue, место, creall(c), тип);
        else if (тип.isimaginary())
            emplaceExp!(RealExp)(&ue, место, cimagl(c), тип);
        else if (тип.iscomplex())
            emplaceExp!(ComplexExp)(&ue, место, c, тип);
        else
            assert(0);
    }
    else
    {
        sinteger_t n1;
        sinteger_t n2;
        sinteger_t n;
        n1 = e1.toInteger();
        n2 = e2.toInteger();
        if (n2 == 0)
        {
            e2.выведиОшибку("divide by 0");
            emplaceExp!(ErrorExp)(&ue);
            return ue;
        }
        if (n2 == -1 && !тип.isunsigned())
        {
            // Check for цел.min % -1
            if (n1 == 0xFFFFFFFF80000000UL && тип.toBasetype().ty != Tint64)
            {
                e2.выведиОшибку("integer overflow: `цел.min %% -1`");
                emplaceExp!(ErrorExp)(&ue);
                return ue;
            }
            else if (n1 == 0x8000000000000000L) // long.min % -1
            {
                e2.выведиОшибку("integer overflow: `long.min %% -1L`");
                emplaceExp!(ErrorExp)(&ue);
                return ue;
            }
        }
        if (e1.тип.isunsigned() || e2.тип.isunsigned())
            n = (cast(dinteger_t)n1) % (cast(dinteger_t)n2);
        else
            n = n1 % n2;
        emplaceExp!(IntegerExp)(&ue, место, n, тип);
    }
    return ue;
}

UnionExp Pow(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    //printf("Pow()\n");
    UnionExp ue;
    // Handle integer power operations.
    if (e2.тип.isintegral())
    {
        dinteger_t n = e2.toInteger();
        бул neg;
        if (!e2.тип.isunsigned() && cast(sinteger_t)n < 0)
        {
            if (e1.тип.isintegral())
            {
                cantExp(ue);
                return ue;
            }
            // Don't worry about overflow, from now on n is unsigned.
            neg = да;
            n = -n;
        }
        else
            neg = нет;
        UnionExp ur, uv;
        if (e1.тип.iscomplex())
        {
            emplaceExp!(ComplexExp)(&ur, место, e1.toComplex(), e1.тип);
            emplaceExp!(ComplexExp)(&uv, место, complex_t(CTFloat.one), e1.тип);
        }
        else if (e1.тип.isfloating())
        {
            emplaceExp!(RealExp)(&ur, место, e1.toReal(), e1.тип);
            emplaceExp!(RealExp)(&uv, место, CTFloat.one, e1.тип);
        }
        else
        {
            emplaceExp!(IntegerExp)(&ur, место, e1.toInteger(), e1.тип);
            emplaceExp!(IntegerExp)(&uv, место, 1, e1.тип);
        }
        Выражение r = ur.exp();
        Выражение v = uv.exp();
        while (n != 0)
        {
            if (n & 1)
            {
                // v = v * r;
                uv = Mul(место, v.тип, v, r);
            }
            n >>= 1;
            // r = r * r
            ur = Mul(место, r.тип, r, r);
        }
        if (neg)
        {
            // ue = 1.0 / v
            UnionExp one;
            emplaceExp!(RealExp)(&one, место, CTFloat.one, v.тип);
            uv = Div(место, v.тип, one.exp(), v);
        }
        if (тип.iscomplex())
            emplaceExp!(ComplexExp)(&ue, место, v.toComplex(), тип);
        else if (тип.isintegral())
            emplaceExp!(IntegerExp)(&ue, место, v.toInteger(), тип);
        else
            emplaceExp!(RealExp)(&ue, место, v.toReal(), тип);
    }
    else if (e2.тип.isfloating())
    {
        // x ^^ y for x < 0 and y not an integer is not defined; so set результат as NaN
        if (e1.toReal() < CTFloat.нуль)
        {
            emplaceExp!(RealExp)(&ue, место, target.RealProperties.nan, тип);
        }
        else
            cantExp(ue);
    }
    else
        cantExp(ue);
    return ue;
}

UnionExp Shl(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() << e2.toInteger(), тип);
    return ue;
}

UnionExp Shr(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    dinteger_t значение = e1.toInteger();
    dinteger_t dcount = e2.toInteger();
    assert(dcount <= 0xFFFFFFFF);
    бцел count = cast(бцел)dcount;
    switch (e1.тип.toBasetype().ty)
    {
    case Tint8:
        значение = cast(d_int8)значение >> count;
        break;
    case Tuns8:
    case Tchar:
        значение = cast(d_uns8)значение >> count;
        break;
    case Tint16:
        значение = cast(d_int16)значение >> count;
        break;
    case Tuns16:
    case Twchar:
        значение = cast(d_uns16)значение >> count;
        break;
    case Tint32:
        значение = cast(d_int32)значение >> count;
        break;
    case Tuns32:
    case Tdchar:
        значение = cast(d_uns32)значение >> count;
        break;
    case Tint64:
        значение = cast(d_int64)значение >> count;
        break;
    case Tuns64:
        значение = cast(d_uns64)значение >> count;
        break;
    case Terror:
        emplaceExp!(ErrorExp)(&ue);
        return ue;
    default:
        assert(0);
    }
    emplaceExp!(IntegerExp)(&ue, место, значение, тип);
    return ue;
}

UnionExp Ushr(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    dinteger_t значение = e1.toInteger();
    dinteger_t dcount = e2.toInteger();
    assert(dcount <= 0xFFFFFFFF);
    бцел count = cast(бцел)dcount;
    switch (e1.тип.toBasetype().ty)
    {
    case Tint8:
    case Tuns8:
    case Tchar:
        // Possible only with >>>=. >>> always gets promoted to цел.
        значение = (значение & 0xFF) >> count;
        break;
    case Tint16:
    case Tuns16:
    case Twchar:
        // Possible only with >>>=. >>> always gets promoted to цел.
        значение = (значение & 0xFFFF) >> count;
        break;
    case Tint32:
    case Tuns32:
    case Tdchar:
        значение = (значение & 0xFFFFFFFF) >> count;
        break;
    case Tint64:
    case Tuns64:
        значение = cast(d_uns64)значение >> count;
        break;
    case Terror:
        emplaceExp!(ErrorExp)(&ue);
        return ue;
    default:
        assert(0);
    }
    emplaceExp!(IntegerExp)(&ue, место, значение, тип);
    return ue;
}

UnionExp And(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() & e2.toInteger(), тип);
    return ue;
}

UnionExp Or(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() | e2.toInteger(), тип);
    return ue;
}

UnionExp Xor(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    //printf("Xor(номстр = %d, e1 = %s, e2 = %s)\n", место.номстр, e1.вТкст0(), e2.вТкст0());
    UnionExp ue = проц;
    emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() ^ e2.toInteger(), тип);
    return ue;
}

/* Also returns ТОК2.cantВыражение if cannot be computed.
 */
UnionExp Equal(ТОК2 op, ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    цел cmp = 0;
    real_t r1 = CTFloat.нуль;
    real_t r2 = CTFloat.нуль;
    //printf("Equal(e1 = %s, e2 = %s)\n", e1.вТкст0(), e2.вТкст0());
    assert(op == ТОК2.equal || op == ТОК2.notEqual);
    if (e1.op == ТОК2.null_)
    {
        if (e2.op == ТОК2.null_)
            cmp = 1;
        else if (e2.op == ТОК2.string_)
        {
            StringExp es2 = cast(StringExp)e2;
            cmp = (0 == es2.len);
        }
        else if (e2.op == ТОК2.arrayLiteral)
        {
            ArrayLiteralExp es2 = cast(ArrayLiteralExp)e2;
            cmp = !es2.elements || (0 == es2.elements.dim);
        }
        else
        {
            cantExp(ue);
            return ue;
        }
    }
    else if (e2.op == ТОК2.null_)
    {
        if (e1.op == ТОК2.string_)
        {
            StringExp es1 = cast(StringExp)e1;
            cmp = (0 == es1.len);
        }
        else if (e1.op == ТОК2.arrayLiteral)
        {
            ArrayLiteralExp es1 = cast(ArrayLiteralExp)e1;
            cmp = !es1.elements || (0 == es1.elements.dim);
        }
        else
        {
            cantExp(ue);
            return ue;
        }
    }
    else if (e1.op == ТОК2.string_ && e2.op == ТОК2.string_)
    {
        StringExp es1 = cast(StringExp)e1;
        StringExp es2 = cast(StringExp)e2;
        if (es1.sz != es2.sz)
        {
            assert(глоб2.errors);
            cantExp(ue);
            return ue;
        }
        const data1 = es1.peekData();
        const data2 = es2.peekData();
        if (es1.len == es2.len && memcmp(data1.ptr, data2.ptr, es1.sz * es1.len) == 0)
            cmp = 1;
        else
            cmp = 0;
    }
    else if (e1.op == ТОК2.arrayLiteral && e2.op == ТОК2.arrayLiteral)
    {
        ArrayLiteralExp es1 = cast(ArrayLiteralExp)e1;
        ArrayLiteralExp es2 = cast(ArrayLiteralExp)e2;
        if ((!es1.elements || !es1.elements.dim) && (!es2.elements || !es2.elements.dim))
            cmp = 1; // both arrays are empty
        else if (!es1.elements || !es2.elements)
            cmp = 0;
        else if (es1.elements.dim != es2.elements.dim)
            cmp = 0;
        else
        {
            for (т_мера i = 0; i < es1.elements.dim; i++)
            {
                auto ee1 = es1[i];
                auto ee2 = es2[i];
                ue = Equal(ТОК2.equal, место, Тип.tint32, ee1, ee2);
                if (CTFEExp.isCantExp(ue.exp()))
                    return ue;
                cmp = cast(цел)ue.exp().toInteger();
                if (cmp == 0)
                    break;
            }
        }
    }
    else if (e1.op == ТОК2.arrayLiteral && e2.op == ТОК2.string_)
    {
        // Swap operands and use common code
        Выражение etmp = e1;
        e1 = e2;
        e2 = etmp;
        goto Lsa;
    }
    else if (e1.op == ТОК2.string_ && e2.op == ТОК2.arrayLiteral)
    {
    Lsa:
        StringExp es1 = cast(StringExp)e1;
        ArrayLiteralExp es2 = cast(ArrayLiteralExp)e2;
        т_мера dim1 = es1.len;
        т_мера dim2 = es2.elements ? es2.elements.dim : 0;
        if (dim1 != dim2)
            cmp = 0;
        else
        {
            cmp = 1; // if dim1 winds up being 0
            for (т_мера i = 0; i < dim1; i++)
            {
                uinteger_t c = es1.charAt(i);
                auto ee2 = es2[i];
                if (ee2.isConst() != 1)
                {
                    cantExp(ue);
                    return ue;
                }
                cmp = (c == ee2.toInteger());
                if (cmp == 0)
                    break;
            }
        }
    }
    else if (e1.op == ТОК2.structLiteral && e2.op == ТОК2.structLiteral)
    {
        StructLiteralExp es1 = cast(StructLiteralExp)e1;
        StructLiteralExp es2 = cast(StructLiteralExp)e2;
        if (es1.sd != es2.sd)
            cmp = 0;
        else if ((!es1.elements || !es1.elements.dim) && (!es2.elements || !es2.elements.dim))
            cmp = 1; // both arrays are empty
        else if (!es1.elements || !es2.elements)
            cmp = 0;
        else if (es1.elements.dim != es2.elements.dim)
            cmp = 0;
        else
        {
            cmp = 1;
            for (т_мера i = 0; i < es1.elements.dim; i++)
            {
                Выражение ee1 = (*es1.elements)[i];
                Выражение ee2 = (*es2.elements)[i];
                if (ee1 == ee2)
                    continue;
                if (!ee1 || !ee2)
                {
                    cmp = 0;
                    break;
                }
                ue = Equal(ТОК2.equal, место, Тип.tint32, ee1, ee2);
                if (ue.exp().op == ТОК2.cantВыражение)
                    return ue;
                cmp = cast(цел)ue.exp().toInteger();
                if (cmp == 0)
                    break;
            }
        }
    }
    else if (e1.isConst() != 1 || e2.isConst() != 1)
    {
        cantExp(ue);
        return ue;
    }
    else if (e1.тип.isreal())
    {
        r1 = e1.toReal();
        r2 = e2.toReal();
        goto L1;
    }
    else if (e1.тип.isimaginary())
    {
        r1 = e1.toImaginary();
        r2 = e2.toImaginary();
    L1:
        if (CTFloat.isNaN(r1) || CTFloat.isNaN(r2)) // if unordered
        {
            cmp = 0;
        }
        else
        {
            cmp = (r1 == r2);
        }
    }
    else if (e1.тип.iscomplex())
    {
        cmp = e1.toComplex() == e2.toComplex();
    }
    else if (e1.тип.isintegral() || e1.тип.toBasetype().ty == Tpointer)
    {
        cmp = (e1.toInteger() == e2.toInteger());
    }
    else
    {
        cantExp(ue);
        return ue;
    }
    if (op == ТОК2.notEqual)
        cmp ^= 1;
    emplaceExp!(IntegerExp)(&ue, место, cmp, тип);
    return ue;
}

UnionExp Identity(ТОК2 op, ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    цел cmp;
    if (e1.op == ТОК2.null_)
    {
        cmp = (e2.op == ТОК2.null_);
    }
    else if (e2.op == ТОК2.null_)
    {
        cmp = 0;
    }
    else if (e1.op == ТОК2.symbolOffset && e2.op == ТОК2.symbolOffset)
    {
        SymOffExp es1 = cast(SymOffExp)e1;
        SymOffExp es2 = cast(SymOffExp)e2;
        cmp = (es1.var == es2.var && es1.смещение == es2.смещение);
    }
    else
    {
        if (e1.тип.isreal())
        {
            cmp = RealIdentical(e1.toReal(), e2.toReal());
        }
        else if (e1.тип.isimaginary())
        {
            cmp = RealIdentical(e1.toImaginary(), e2.toImaginary());
        }
        else if (e1.тип.iscomplex())
        {
            complex_t v1 = e1.toComplex();
            complex_t v2 = e2.toComplex();
            cmp = RealIdentical(creall(v1), creall(v2)) && RealIdentical(cimagl(v1), cimagl(v1));
        }
        else
        {
            ue = Equal((op == ТОК2.identity) ? ТОК2.equal : ТОК2.notEqual, место, тип, e1, e2);
            return ue;
        }
    }
    if (op == ТОК2.notIdentity)
        cmp ^= 1;
    emplaceExp!(IntegerExp)(&ue, место, cmp, тип);
    return ue;
}

UnionExp Cmp(ТОК2 op, ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    dinteger_t n;
    real_t r1 = CTFloat.нуль;
    real_t r2 = CTFloat.нуль;
    //printf("Cmp(e1 = %s, e2 = %s)\n", e1.вТкст0(), e2.вТкст0());
    if (e1.op == ТОК2.string_ && e2.op == ТОК2.string_)
    {
        StringExp es1 = cast(StringExp)e1;
        StringExp es2 = cast(StringExp)e2;
        т_мера sz = es1.sz;
        assert(sz == es2.sz);
        т_мера len = es1.len;
        if (es2.len < len)
            len = es2.len;
        const data1 = es1.peekData();
        const data2 = es1.peekData();
        цел rawCmp = memcmp(data1.ptr, data2.ptr, sz * len);
        if (rawCmp == 0)
            rawCmp = cast(цел)(es1.len - es2.len);
        n = specificCmp(op, rawCmp);
    }
    else if (e1.isConst() != 1 || e2.isConst() != 1)
    {
        cantExp(ue);
        return ue;
    }
    else if (e1.тип.isreal())
    {
        r1 = e1.toReal();
        r2 = e2.toReal();
        goto L1;
    }
    else if (e1.тип.isimaginary())
    {
        r1 = e1.toImaginary();
        r2 = e2.toImaginary();
    L1:
        n = realCmp(op, r1, r2);
    }
    else if (e1.тип.iscomplex())
    {
        assert(0);
    }
    else
    {
        sinteger_t n1;
        sinteger_t n2;
        n1 = e1.toInteger();
        n2 = e2.toInteger();
        if (e1.тип.isunsigned() || e2.тип.isunsigned())
            n = intUnsignedCmp(op, n1, n2);
        else
            n = intSignedCmp(op, n1, n2);
    }
    emplaceExp!(IntegerExp)(&ue, место, n, тип);
    return ue;
}

/* Also returns ТОК2.cantВыражение if cannot be computed.
 *  to: тип to cast to
 *  тип: тип to paint the результат
 */
UnionExp Cast(ref Место место, Тип тип, Тип to, Выражение e1)
{
    UnionExp ue = проц;
    Тип tb = to.toBasetype();
    Тип typeb = тип.toBasetype();
    //printf("Cast(тип = %s, to = %s, e1 = %s)\n", тип.вТкст0(), to.вТкст0(), e1.вТкст0());
    //printf("\te1.тип = %s\n", e1.тип.вТкст0());
    if (e1.тип.равен(тип) && тип.равен(to))
    {
        emplaceExp!(UnionExp)(&ue, e1);
        return ue;
    }
    if (e1.op == ТОК2.vector && (cast(TypeVector)e1.тип).basetype.равен(тип) && тип.равен(to))
    {
        Выражение ex = (cast(VectorExp)e1).e1;
        emplaceExp!(UnionExp)(&ue, ex);
        return ue;
    }
    if (e1.тип.implicitConvTo(to) >= MATCH.constant || to.implicitConvTo(e1.тип) >= MATCH.constant)
    {
        goto L1;
    }
    // Allow covariant converions of delegates
    // (Perhaps implicit conversion from  to impure should be a MATCH.constant,
    // then we wouldn't need this extra check.)
    if (e1.тип.toBasetype().ty == Tdelegate && e1.тип.implicitConvTo(to) == MATCH.convert)
    {
        goto L1;
    }
    /* Allow casting from one ткст тип to another
     */
    if (e1.op == ТОК2.string_)
    {
        if (tb.ty == Tarray && typeb.ty == Tarray && tb.nextOf().size() == typeb.nextOf().size())
        {
            goto L1;
        }
    }
    if (e1.op == ТОК2.arrayLiteral && typeb == tb)
    {
    L1:
        Выражение ex = expType(to, e1);
        emplaceExp!(UnionExp)(&ue, ex);
        return ue;
    }
    if (e1.isConst() != 1)
    {
        cantExp(ue);
    }
    else if (tb.ty == Tbool)
    {
        emplaceExp!(IntegerExp)(&ue, место, e1.toInteger() != 0, тип);
    }
    else if (тип.isintegral())
    {
        if (e1.тип.isfloating())
        {
            dinteger_t результат;
            real_t r = e1.toReal();
            switch (typeb.ty)
            {
            case Tint8:
                результат = cast(d_int8)cast(sinteger_t)r;
                break;
            case Tchar:
            case Tuns8:
                результат = cast(d_uns8)cast(dinteger_t)r;
                break;
            case Tint16:
                результат = cast(d_int16)cast(sinteger_t)r;
                break;
            case Twchar:
            case Tuns16:
                результат = cast(d_uns16)cast(dinteger_t)r;
                break;
            case Tint32:
                результат = cast(d_int32)r;
                break;
            case Tdchar:
            case Tuns32:
                результат = cast(d_uns32)r;
                break;
            case Tint64:
                результат = cast(d_int64)r;
                break;
            case Tuns64:
                результат = cast(d_uns64)r;
                break;
            default:
                assert(0);
            }
            emplaceExp!(IntegerExp)(&ue, место, результат, тип);
        }
        else if (тип.isunsigned())
            emplaceExp!(IntegerExp)(&ue, место, e1.toUInteger(), тип);
        else
            emplaceExp!(IntegerExp)(&ue, место, e1.toInteger(), тип);
    }
    else if (tb.isreal())
    {
        real_t значение = e1.toReal();
        emplaceExp!(RealExp)(&ue, место, значение, тип);
    }
    else if (tb.isimaginary())
    {
        real_t значение = e1.toImaginary();
        emplaceExp!(RealExp)(&ue, место, значение, тип);
    }
    else if (tb.iscomplex())
    {
        complex_t значение = e1.toComplex();
        emplaceExp!(ComplexExp)(&ue, место, значение, тип);
    }
    else if (tb.isscalar())
    {
        emplaceExp!(IntegerExp)(&ue, место, e1.toInteger(), тип);
    }
    else if (tb.ty == Tvoid)
    {
        cantExp(ue);
    }
    else if (tb.ty == Tstruct && e1.op == ТОК2.int64)
    {
        // Struct = 0;
        StructDeclaration sd = tb.toDsymbol(null).isStructDeclaration();
        assert(sd);
        auto elements = new Выражения();
        for (т_мера i = 0; i < sd.fields.dim; i++)
        {
            VarDeclaration v = sd.fields[i];
            UnionExp нуль;
            emplaceExp!(IntegerExp)(&нуль, 0);
            ue = Cast(место, v.тип, v.тип, нуль.exp());
            if (ue.exp().op == ТОК2.cantВыражение)
                return ue;
            elements.сунь(ue.exp().копируй());
        }
        emplaceExp!(StructLiteralExp)(&ue, место, sd, elements);
        ue.exp().тип = тип;
    }
    else
    {
        if (тип != Тип.terror)
        {
            // have to change to Internal Compiler Error
            // all invalid casts should be handled already in Выражение::castTo().
            выведиОшибку(место, "cannot cast `%s` to `%s`", e1.тип.вТкст0(), тип.вТкст0());
        }
        emplaceExp!(ErrorExp)(&ue);
    }
    return ue;
}

UnionExp ArrayLength(Тип тип, Выражение e1)
{
    UnionExp ue = проц;
    Место место = e1.место;
    if (e1.op == ТОК2.string_)
    {
        StringExp es1 = cast(StringExp)e1;
        emplaceExp!(IntegerExp)(&ue, место, es1.len, тип);
    }
    else if (e1.op == ТОК2.arrayLiteral)
    {
        ArrayLiteralExp ale = cast(ArrayLiteralExp)e1;
        т_мера dim = ale.elements ? ale.elements.dim : 0;
        emplaceExp!(IntegerExp)(&ue, место, dim, тип);
    }
    else if (e1.op == ТОК2.assocArrayLiteral)
    {
        AssocArrayLiteralExp ale = cast(AssocArrayLiteralExp)e1;
        т_мера dim = ale.keys.dim;
        emplaceExp!(IntegerExp)(&ue, место, dim, тип);
    }
    else if (e1.тип.toBasetype().ty == Tsarray)
    {
        Выражение e = (cast(TypeSArray)e1.тип.toBasetype()).dim;
        emplaceExp!(UnionExp)(&ue, e);
    }
    else
        cantExp(ue);
    return ue;
}

/* Also return ТОК2.cantВыражение if this fails
 */
UnionExp Index(Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    Место место = e1.место;
    //printf("Index(e1 = %s, e2 = %s)\n", e1.вТкст0(), e2.вТкст0());
    assert(e1.тип);
    if (e1.op == ТОК2.string_ && e2.op == ТОК2.int64)
    {
        StringExp es1 = cast(StringExp)e1;
        uinteger_t i = e2.toInteger();
        if (i >= es1.len)
        {
            e1.выведиОшибку("ткст index %llu is out of bounds `[0 .. %llu]`", i, cast(бдол)es1.len);
            emplaceExp!(ErrorExp)(&ue);
        }
        else
        {
            emplaceExp!(IntegerExp)(&ue, место, es1.charAt(i), тип);
        }
    }
    else if (e1.тип.toBasetype().ty == Tsarray && e2.op == ТОК2.int64)
    {
        TypeSArray tsa = cast(TypeSArray)e1.тип.toBasetype();
        uinteger_t length = tsa.dim.toInteger();
        uinteger_t i = e2.toInteger();
        if (i >= length)
        {
            e1.выведиОшибку("массив index %llu is out of bounds `%s[0 .. %llu]`", i, e1.вТкст0(), length);
            emplaceExp!(ErrorExp)(&ue);
        }
        else if (e1.op == ТОК2.arrayLiteral)
        {
            ArrayLiteralExp ale = cast(ArrayLiteralExp)e1;
            auto e = ale[cast(т_мера)i];
            e.тип = тип;
            e.место = место;
            if (hasSideEffect(e))
                cantExp(ue);
            else
                emplaceExp!(UnionExp)(&ue, e);
        }
        else
            cantExp(ue);
    }
    else if (e1.тип.toBasetype().ty == Tarray && e2.op == ТОК2.int64)
    {
        uinteger_t i = e2.toInteger();
        if (e1.op == ТОК2.arrayLiteral)
        {
            ArrayLiteralExp ale = cast(ArrayLiteralExp)e1;
            if (i >= ale.elements.dim)
            {
                e1.выведиОшибку("массив index %llu is out of bounds `%s[0 .. %u]`", i, e1.вТкст0(), ale.elements.dim);
                emplaceExp!(ErrorExp)(&ue);
            }
            else
            {
                auto e = ale[cast(т_мера)i];
                e.тип = тип;
                e.место = место;
                if (hasSideEffect(e))
                    cantExp(ue);
                else
                    emplaceExp!(UnionExp)(&ue, e);
            }
        }
        else
            cantExp(ue);
    }
    else if (e1.op == ТОК2.assocArrayLiteral)
    {
        AssocArrayLiteralExp ae = cast(AssocArrayLiteralExp)e1;
        /* Search the keys backwards, in case there are duplicate keys
         */
        for (т_мера i = ae.keys.dim; i;)
        {
            i--;
            Выражение ekey = (*ae.keys)[i];
            ue = Equal(ТОК2.equal, место, Тип.tбул, ekey, e2);
            if (CTFEExp.isCantExp(ue.exp()))
                return ue;
            if (ue.exp().isBool(да))
            {
                Выражение e = (*ae.values)[i];
                e.тип = тип;
                e.место = место;
                if (hasSideEffect(e))
                    cantExp(ue);
                else
                    emplaceExp!(UnionExp)(&ue, e);
                return ue;
            }
        }
        cantExp(ue);
    }
    else
        cantExp(ue);
    return ue;
}

/* Also return ТОК2.cantВыражение if this fails
 */
UnionExp Slice(Тип тип, Выражение e1, Выражение lwr, Выражение upr)
{
    UnionExp ue = проц;
    Место место = e1.место;
    static if (LOG)
    {
        printf("Slice()\n");
        if (lwr)
        {
            printf("\te1 = %s\n", e1.вТкст0());
            printf("\tlwr = %s\n", lwr.вТкст0());
            printf("\tupr = %s\n", upr.вТкст0());
        }
    }

    static бул sliceBoundsCheck(uinteger_t lwr, uinteger_t upr, uinteger_t newlwr, uinteger_t newupr) 
    {
        assert(lwr <= upr);
        return !(newlwr <= newupr &&
                 lwr <= newlwr &&
                 newupr <= upr);
    }

    if (e1.op == ТОК2.string_ && lwr.op == ТОК2.int64 && upr.op == ТОК2.int64)
    {
        StringExp es1 = cast(StringExp)e1;
        const uinteger_t ilwr = lwr.toInteger();
        const uinteger_t iupr = upr.toInteger();
        if (sliceBoundsCheck(0, es1.len, ilwr, iupr))
            cantExp(ue);   // https://issues.dlang.org/show_bug.cgi?ид=18115
        else
        {
            const len = cast(т_мера)(iupr - ilwr);
            const sz = es1.sz;
            ук s = mem.xmalloc(len * sz);
            const data1 = es1.peekData();
            memcpy(s, data1.ptr + ilwr * sz, len * sz);
            emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz, es1.postfix);
            StringExp es = cast(StringExp)ue.exp();
            es.committed = es1.committed;
            es.тип = тип;
        }
    }
    else if (e1.op == ТОК2.arrayLiteral && lwr.op == ТОК2.int64 && upr.op == ТОК2.int64 && !hasSideEffect(e1))
    {
        ArrayLiteralExp es1 = cast(ArrayLiteralExp)e1;
        const uinteger_t ilwr = lwr.toInteger();
        const uinteger_t iupr = upr.toInteger();
        if (sliceBoundsCheck(0, es1.elements.dim, ilwr, iupr))
            cantExp(ue);
        else
        {
            auto elements = new Выражения(cast(т_мера)(iupr - ilwr));
            memcpy(elements.tdata(), es1.elements.tdata() + ilwr, cast(т_мера)(iupr - ilwr) * ((*es1.elements)[0]).sizeof);
            emplaceExp!(ArrayLiteralExp)(&ue, e1.место, тип, elements);
        }
    }
    else
        cantExp(ue);
    return ue;
}

/* Set a slice of сим/integer массив literal 'existingAE' from a ткст 'newval'.
 * existingAE[firstIndex..firstIndex+newval.length] = newval.
 */
проц sliceAssignArrayLiteralFromString(ArrayLiteralExp existingAE, StringExp newval, т_мера firstIndex)
{
    const len = newval.len;
    Тип elemType = existingAE.тип.nextOf();
    foreach (j; new бцел[0 .. len])
    {
        const val = newval.getCodeUnit(j);
        (*existingAE.elements)[j + firstIndex] = new IntegerExp(newval.место, val, elemType);
    }
}

/* Set a slice of ткст 'existingSE' from a сим массив literal 'newae'.
 *   existingSE[firstIndex..firstIndex+newae.length] = newae.
 */
проц sliceAssignStringFromArrayLiteral(StringExp existingSE, ArrayLiteralExp newae, т_мера firstIndex)
{
    assert(existingSE.ownedByCtfe != OwnedBy.code);
    foreach (j; new бцел[0 .. newae.elements.dim])
    {
        existingSE.setCodeUnit(firstIndex + j, cast(dchar)newae[j].toInteger());
    }
}

/* Set a slice of ткст 'existingSE' from a ткст 'newstr'.
 *   existingSE[firstIndex..firstIndex+newstr.length] = newstr.
 */
проц sliceAssignStringFromString(StringExp existingSE, StringExp newstr, т_мера firstIndex)
{
    assert(existingSE.ownedByCtfe != OwnedBy.code);
    т_мера sz = existingSE.sz;
    assert(sz == newstr.sz);
    auto data1 = existingSE.borrowData();
    const data2 = newstr.peekData();
    memcpy(data1.ptr + firstIndex * sz, data2.ptr, data2.length);
}

/* Compare a ткст slice with another ткст slice.
 * Conceptually equivalent to memcmp( se1[lo1..lo1+len],  se2[lo2..lo2+len])
 */
цел sliceCmpStringWithString(StringExp se1, StringExp se2, т_мера lo1, т_мера lo2, т_мера len)
{
    т_мера sz = se1.sz;
    assert(sz == se2.sz);
    const data1 = se1.peekData();
    const data2 = se2.peekData();
    return memcmp(data1.ptr + sz * lo1, data2.ptr + sz * lo2, sz * len);
}

/* Compare a ткст slice with an массив literal slice
 * Conceptually equivalent to memcmp( se1[lo1..lo1+len],  ae2[lo2..lo2+len])
 */
цел sliceCmpStringWithArray(StringExp se1, ArrayLiteralExp ae2, т_мера lo1, т_мера lo2, т_мера len)
{
    foreach (j; new бцел[0 .. len])
    {
        const val2 = cast(dchar)ae2[j + lo2].toInteger();
        const val1 = se1.getCodeUnit(j + lo1);
        const цел c = val1 - val2;
        if (c)
            return c;
    }
    return 0;
}

/** Copy element `Выражения` in the parameters when they're `ArrayLiteralExp`s.
 * Параметры:
 *      e1  = If it's ArrayLiteralExp, its `elements` will be copied.
 *            Otherwise, `e1` itself will be pushed into the new `Выражения`.
 *      e2  = If it's not `null`, it will be pushed/appended to the new
 *            `Выражения` by the same way with `e1`.
 * Возвращает:
 *      Newly allocated `Выражения`. Note that it points to the original
 *      `Выражение` values in e1 and e2.
 */
private Выражения* copyElements(Выражение e1, Выражение e2 = null)
{
    auto elems = new Выражения();

    проц приставь(ArrayLiteralExp ale)
    {
        if (!ale.elements)
            return;
        auto d = elems.dim;
        elems.приставь(ale.elements);
        foreach (ref el; (*elems)[d .. elems.dim])
        {
            if (!el)
                el = ale.basis;
        }
    }

    if (e1.op == ТОК2.arrayLiteral)
        приставь(cast(ArrayLiteralExp)e1);
    else
        elems.сунь(e1);

    if (e2)
    {
        if (e2.op == ТОК2.arrayLiteral)
            приставь(cast(ArrayLiteralExp)e2);
        else
            elems.сунь(e2);
    }

    return elems;
}

/* Also return ТОК2.cantВыражение if this fails
 */
UnionExp Cat(Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    Выражение e = CTFEExp.cantexp;
    Место место = e1.место;
    Тип t;
    Тип t1 = e1.тип.toBasetype();
    Тип t2 = e2.тип.toBasetype();
    //printf("Cat(e1 = %s, e2 = %s)\n", e1.вТкст0(), e2.вТкст0());
    //printf("\tt1 = %s, t2 = %s, тип = %s\n", t1.вТкст0(), t2.вТкст0(), тип.вТкст0());
    if (e1.op == ТОК2.null_ && (e2.op == ТОК2.int64 || e2.op == ТОК2.structLiteral))
    {
        e = e2;
        t = t1;
        goto L2;
    }
    else if ((e1.op == ТОК2.int64 || e1.op == ТОК2.structLiteral) && e2.op == ТОК2.null_)
    {
        e = e1;
        t = t2;
    L2:
        Тип tn = e.тип.toBasetype();
        if (tn.ty == Tchar || tn.ty == Twchar || tn.ty == Tdchar)
        {
            // Create a StringExp
            if (t.nextOf())
                t = t.nextOf().toBasetype();
            const sz = cast(ббайт)t.size();
            dinteger_t v = e.toInteger();
            const len = (t.ty == tn.ty) ? 1 : utf_codeLength(sz, cast(dchar)v);
            ук s = mem.xmalloc(len * sz);
            if (t.ty == tn.ty)
                Port.valcpy(s, v, sz);
            else
                utf_encode(sz, s, cast(dchar)v);
            emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz);
            StringExp es = cast(StringExp)ue.exp();
            es.тип = тип;
            es.committed = 1;
        }
        else
        {
            // Create an ArrayLiteralExp
            auto elements = new Выражения();
            elements.сунь(e);
            emplaceExp!(ArrayLiteralExp)(&ue, e.место, тип, elements);
        }
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.null_ && e2.op == ТОК2.null_)
    {
        if (тип == e1.тип)
        {
            // Handle null ~= null
            if (t1.ty == Tarray && t2 == t1.nextOf())
            {
                emplaceExp!(ArrayLiteralExp)(&ue, e1.место, тип, e2);
                assert(ue.exp().тип);
                return ue;
            }
            else
            {
                emplaceExp!(UnionExp)(&ue, e1);
                assert(ue.exp().тип);
                return ue;
            }
        }
        if (тип == e2.тип)
        {
            emplaceExp!(UnionExp)(&ue, e2);
            assert(ue.exp().тип);
            return ue;
        }
        emplaceExp!(NullExp)(&ue, e1.место, тип);
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.string_ && e2.op == ТОК2.string_)
    {
        // Concatenate the strings
        StringExp es1 = cast(StringExp)e1;
        StringExp es2 = cast(StringExp)e2;
        т_мера len = es1.len + es2.len;
        ббайт sz = es1.sz;
        if (sz != es2.sz)
        {
            /* Can happen with:
             *   auto s = "foo"d ~ "bar"c;
             */
            assert(глоб2.errors);
            cantExp(ue);
            assert(ue.exp().тип);
            return ue;
        }
        ук s = mem.xmalloc(len * sz);
        const data1 = es1.peekData();
        const data2 = es2.peekData();
        memcpy(cast(сим*)s, data1.ptr, es1.len * sz);
        memcpy(cast(сим*)s + es1.len * sz, data2.ptr, es2.len * sz);
        emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz);
        StringExp es = cast(StringExp)ue.exp();
        es.committed = es1.committed | es2.committed;
        es.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if (e2.op == ТОК2.string_ && e1.op == ТОК2.arrayLiteral && t1.nextOf().isintegral())
    {
        // [chars] ~ ткст --> [chars]
        StringExp es = cast(StringExp)e2;
        ArrayLiteralExp ea = cast(ArrayLiteralExp)e1;
        т_мера len = es.len + ea.elements.dim;
        auto elems = new Выражения(len);
        for (т_мера i = 0; i < ea.elements.dim; ++i)
        {
            (*elems)[i] = ea[i];
        }
        emplaceExp!(ArrayLiteralExp)(&ue, e1.место, тип, elems);
        ArrayLiteralExp dest = cast(ArrayLiteralExp)ue.exp();
        sliceAssignArrayLiteralFromString(dest, es, ea.elements.dim);
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.string_ && e2.op == ТОК2.arrayLiteral && t2.nextOf().isintegral())
    {
        // ткст ~ [chars] --> [chars]
        StringExp es = cast(StringExp)e1;
        ArrayLiteralExp ea = cast(ArrayLiteralExp)e2;
        т_мера len = es.len + ea.elements.dim;
        auto elems = new Выражения(len);
        for (т_мера i = 0; i < ea.elements.dim; ++i)
        {
            (*elems)[es.len + i] = ea[i];
        }
        emplaceExp!(ArrayLiteralExp)(&ue, e1.место, тип, elems);
        ArrayLiteralExp dest = cast(ArrayLiteralExp)ue.exp();
        sliceAssignArrayLiteralFromString(dest, es, 0);
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.string_ && e2.op == ТОК2.int64)
    {
        // ткст ~ сим --> ткст
        StringExp es1 = cast(StringExp)e1;
        StringExp es;
        const sz = es1.sz;
        dinteger_t v = e2.toInteger();
        // Is it a concatenation of homogenous types?
        // (ткст ~ сим, wткст~wchar, or dткст~dchar)
        бул homoConcat = (sz == t2.size());
        const len = es1.len + (homoConcat ? 1 : utf_codeLength(sz, cast(dchar)v));
        ук s = mem.xmalloc(len * sz);
        const data1 = es1.peekData();
        memcpy(s, data1.ptr, data1.length);
        if (homoConcat)
            Port.valcpy(cast(сим*)s + (sz * es1.len), v, sz);
        else
            utf_encode(sz, cast(сим*)s + (sz * es1.len), cast(dchar)v);
        emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz);
        es = cast(StringExp)ue.exp();
        es.committed = es1.committed;
        es.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.int64 && e2.op == ТОК2.string_)
    {
        // [w|d]?сим ~ ткст --> ткст
        // We assume that we only ever prepend one сим of the same тип
        // (wchar,dchar) as the ткст's characters.
        StringExp es2 = cast(StringExp)e2;
        const len = 1 + es2.len;
        const sz = es2.sz;
        dinteger_t v = e1.toInteger();
        ук s = mem.xmalloc(len * sz);
        Port.valcpy(cast(сим*)s, v, sz);
        const data2 = es2.peekData();
        memcpy(cast(сим*)s + sz, data2.ptr, data2.length);
        emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz);
        StringExp es = cast(StringExp)ue.exp();
        es.sz = sz;
        es.committed = es2.committed;
        es.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.arrayLiteral && e2.op == ТОК2.arrayLiteral && t1.nextOf().равен(t2.nextOf()))
    {
        // Concatenate the arrays
        auto elems = copyElements(e1, e2);

        emplaceExp!(ArrayLiteralExp)(&ue, e1.место, cast(Тип)null, elems);

        e = ue.exp();
        if (тип.toBasetype().ty == Tsarray)
        {
            e.тип = t1.nextOf().sarrayOf(elems.dim);
        }
        else
            e.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.arrayLiteral && e2.op == ТОК2.null_ && t1.nextOf().равен(t2.nextOf()))
    {
        e = e1;
        goto L3;
    }
    else if (e1.op == ТОК2.null_ && e2.op == ТОК2.arrayLiteral && t1.nextOf().равен(t2.nextOf()))
    {
        e = e2;
    L3:
        // Concatenate the массив with null
        auto elems = copyElements(e);

        emplaceExp!(ArrayLiteralExp)(&ue, e.место, cast(Тип)null, elems);

        e = ue.exp();
        if (тип.toBasetype().ty == Tsarray)
        {
            e.тип = t1.nextOf().sarrayOf(elems.dim);
        }
        else
            e.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if ((e1.op == ТОК2.arrayLiteral || e1.op == ТОК2.null_) && e1.тип.toBasetype().nextOf() && e1.тип.toBasetype().nextOf().равен(e2.тип))
    {
        auto elems = (e1.op == ТОК2.arrayLiteral)
                ? copyElements(e1) : new Выражения();
        elems.сунь(e2);

        emplaceExp!(ArrayLiteralExp)(&ue, e1.место, cast(Тип)null, elems);

        e = ue.exp();
        if (тип.toBasetype().ty == Tsarray)
        {
            e.тип = e2.тип.sarrayOf(elems.dim);
        }
        else
            e.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if (e2.op == ТОК2.arrayLiteral && e2.тип.toBasetype().nextOf().равен(e1.тип))
    {
        auto elems = copyElements(e1, e2);

        emplaceExp!(ArrayLiteralExp)(&ue, e2.место, cast(Тип)null, elems);

        e = ue.exp();
        if (тип.toBasetype().ty == Tsarray)
        {
            e.тип = e1.тип.sarrayOf(elems.dim);
        }
        else
            e.тип = тип;
        assert(ue.exp().тип);
        return ue;
    }
    else if (e1.op == ТОК2.null_ && e2.op == ТОК2.string_)
    {
        t = e1.тип;
        e = e2;
        goto L1;
    }
    else if (e1.op == ТОК2.string_ && e2.op == ТОК2.null_)
    {
        e = e1;
        t = e2.тип;
    L1:
        Тип tb = t.toBasetype();
        if (tb.ty == Tarray && tb.nextOf().equivalent(e.тип))
        {
            auto Выражения = new Выражения();
            Выражения.сунь(e);
            emplaceExp!(ArrayLiteralExp)(&ue, место, t, Выражения);
            e = ue.exp();
        }
        else
        {
            emplaceExp!(UnionExp)(&ue, e);
            e = ue.exp();
        }
        if (!e.тип.равен(тип))
        {
            StringExp se = cast(StringExp)e.копируй();
            e = se.castTo(null, тип);
            emplaceExp!(UnionExp)(&ue, e);
            e = ue.exp();
        }
    }
    else
        cantExp(ue);
    assert(ue.exp().тип);
    return ue;
}

UnionExp Ptr(Тип тип, Выражение e1)
{
    //printf("Ptr(e1 = %s)\n", e1.вТкст0());
    UnionExp ue = проц;
    if (e1.op == ТОК2.add)
    {
        AddExp ae = cast(AddExp)e1;
        if (ae.e1.op == ТОК2.address && ae.e2.op == ТОК2.int64)
        {
            AddrExp ade = cast(AddrExp)ae.e1;
            if (ade.e1.op == ТОК2.structLiteral)
            {
                StructLiteralExp se = cast(StructLiteralExp)ade.e1;
                бцел смещение = cast(бцел)ae.e2.toInteger();
                Выражение e = se.getField(тип, смещение);
                if (e)
                {
                    emplaceExp!(UnionExp)(&ue, e);
                    return ue;
                }
            }
        }
    }
    cantExp(ue);
    return ue;
}
