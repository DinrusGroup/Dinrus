/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/builtin.d, _builtin.d)
 * Documentation:  https://dlang.org/phobos/dmd_builtin.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/builtin.d
 */

module dmd.builtin;

import cidrus;
import dmd.arraytypes;
import dmd.dmangle;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.mtype;
import util.ctfloat;
import util.stringtable;
import drc.lexer.Tokens;
//static import core.bitop;

private:

/**
 * Handler for evaluating builtins during CTFE.
 *
 * Параметры:
 *  место = The call location, for error reporting.
 *  fd = The callee declaration, e.g. to disambiguate between different overloads
 *       in a single handler (LDC).
 *  arguments = The function call arguments.
 * Возвращает:
 *  An Выражение containing the return значение of the call.
 */
alias Выражение function(Место место, FuncDeclaration fd, Выражения* arguments) builtin_fp;

 ТаблицаСтрок!(builtin_fp) builtins;

проц add_builtin(ткст mangle, builtin_fp fp)
{
    builtins.вставь(mangle, fp);
}

builtin_fp builtin_lookup(ткст0 mangle)
{
    if (auto sv = builtins.lookup(mangle, strlen(mangle)))
        return sv.значение;
    return null;
}

Выражение eval_unimp(Место место, FuncDeclaration fd, Выражения* arguments)
{
    return null;
}

Выражение eval_sin(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.sin(arg0.toReal()), arg0.тип);
}

Выражение eval_cos(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.cos(arg0.toReal()), arg0.тип);
}

Выражение eval_tan(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.tan(arg0.toReal()), arg0.тип);
}

Выражение eval_sqrt(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.sqrt(arg0.toReal()), arg0.тип);
}

Выражение eval_fabs(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.fabs(arg0.toReal()), arg0.тип);
}

Выражение eval_ldexp(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.int64);
    return new RealExp(место, CTFloat.ldexp(arg0.toReal(), cast(цел) arg1.toInteger()), arg0.тип);
}

Выражение eval_log(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.log(arg0.toReal()), arg0.тип);
}

Выражение eval_log2(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.log2(arg0.toReal()), arg0.тип);
}

Выражение eval_log10(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.log10(arg0.toReal()), arg0.тип);
}

Выражение eval_exp(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.exp(arg0.toReal()), arg0.тип);
}

Выражение eval_expm1(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.expm1(arg0.toReal()), arg0.тип);
}

Выражение eval_exp2(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.exp2(arg0.toReal()), arg0.тип);
}

Выражение eval_round(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.round(arg0.toReal()), arg0.тип);
}

Выражение eval_floor(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.floor(arg0.toReal()), arg0.тип);
}

Выражение eval_ceil(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.ceil(arg0.toReal()), arg0.тип);
}

Выражение eval_trunc(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return new RealExp(место, CTFloat.trunc(arg0.toReal()), arg0.тип);
}

Выражение eval_copysign(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    return new RealExp(место, CTFloat.copysign(arg0.toReal(), arg1.toReal()), arg0.тип);
}

Выражение eval_pow(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    return new RealExp(место, CTFloat.pow(arg0.toReal(), arg1.toReal()), arg0.тип);
}

Выражение eval_fmin(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    return new RealExp(место, CTFloat.fmin(arg0.toReal(), arg1.toReal()), arg0.тип);
}

Выражение eval_fmax(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    return new RealExp(место, CTFloat.fmax(arg0.toReal(), arg1.toReal()), arg0.тип);
}

Выражение eval_fma(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    Выражение arg2 = (*arguments)[2];
    assert(arg2.op == ТОК2.float64);
    return new RealExp(место, CTFloat.fma(arg0.toReal(), arg1.toReal(), arg2.toReal()), arg0.тип);
}

Выражение eval_isnan(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return IntegerExp.createBool(CTFloat.isNaN(arg0.toReal()));
}

Выражение eval_isinfinity(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    return IntegerExp.createBool(CTFloat.isInfinity(arg0.toReal()));
}

Выражение eval_isfinite(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    const значение = !CTFloat.isNaN(arg0.toReal()) && !CTFloat.isInfinity(arg0.toReal());
    return IntegerExp.createBool(значение);
}

Выражение eval_bsf(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.int64);
    uinteger_t n = arg0.toInteger();
    if (n == 0)
        выведиОшибку(место, "`bsf(0)` is undefined");
    return new IntegerExp(место, core.bitop.bsf(n), Тип.tint32);
}

Выражение eval_bsr(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.int64);
    uinteger_t n = arg0.toInteger();
    if (n == 0)
        выведиОшибку(место, "`bsr(0)` is undefined");
    return new IntegerExp(место, core.bitop.bsr(n), Тип.tint32);
}

Выражение eval_bswap(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.int64);
    uinteger_t n = arg0.toInteger();
    TY ty = arg0.тип.toBasetype().ty;
    if (ty == Tint64 || ty == Tuns64)
        return new IntegerExp(место, core.bitop.bswap(cast(бдол) n), arg0.тип);
    else
        return new IntegerExp(место, core.bitop.bswap(cast(бцел) n), arg0.тип);
}

Выражение eval_popcnt(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.int64);
    uinteger_t n = arg0.toInteger();
    return new IntegerExp(место, core.bitop.popcnt(n), Тип.tint32);
}

Выражение eval_yl2x(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    const x = arg0.toReal();
    const y = arg1.toReal();
    real_t результат = CTFloat.нуль;
    CTFloat.yl2x(&x, &y, &результат);
    return new RealExp(место, результат, arg0.тип);
}

Выражение eval_yl2xp1(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    assert(arg0.op == ТОК2.float64);
    Выражение arg1 = (*arguments)[1];
    assert(arg1.op == ТОК2.float64);
    const x = arg0.toReal();
    const y = arg1.toReal();
    real_t результат = CTFloat.нуль;
    CTFloat.yl2xp1(&x, &y, &результат);
    return new RealExp(место, результат, arg0.тип);
}

Выражение eval_toPrecFloat(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    float f = cast(real)arg0.toReal();
    return new RealExp(место, real_t(f), Тип.tfloat32);
}

Выражение eval_toPrecDouble(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    double d = cast(real)arg0.toReal();
    return new RealExp(место, real_t(d), Тип.tfloat64);
}

Выражение eval_toPrecReal(Место место, FuncDeclaration fd, Выражения* arguments)
{
    Выражение arg0 = (*arguments)[0];
    return new RealExp(место, arg0.toReal(), Тип.tfloat80);
}

public  проц builtin_init()
{
    builtins._иниц(113);
    //     real function(real)
    add_builtin("_D4core4math3sinFNaNbNiNfeZe", &eval_sin);
    add_builtin("_D4core4math3cosFNaNbNiNfeZe", &eval_cos);
    add_builtin("_D4core4math3tanFNaNbNiNfeZe", &eval_tan);
    add_builtin("_D4core4math4sqrtFNaNbNiNfeZe", &eval_sqrt);
    add_builtin("_D4core4math4fabsFNaNbNiNfeZe", &eval_fabs);
    add_builtin("_D4core4math5expm1FNaNbNiNfeZe", &eval_unimp);
    add_builtin("_D4core4math4exp2FNaNbNiNfeZe", &eval_unimp);
    //    real function(real)
    add_builtin("_D4core4math3sinFNaNbNiNeeZe", &eval_sin);
    add_builtin("_D4core4math3cosFNaNbNiNeeZe", &eval_cos);
    add_builtin("_D4core4math3tanFNaNbNiNeeZe", &eval_tan);
    add_builtin("_D4core4math4sqrtFNaNbNiNeeZe", &eval_sqrt);
    add_builtin("_D4core4math4fabsFNaNbNiNeeZe", &eval_fabs);
    add_builtin("_D4core4math5expm1FNaNbNiNeeZe", &eval_unimp);
    //     double function(double)
    add_builtin("_D4core4math4sqrtFNaNbNiNfdZd", &eval_sqrt);
    //     float function(float)
    add_builtin("_D4core4math4sqrtFNaNbNiNffZf", &eval_sqrt);
    //     real function(real, real)
    add_builtin("_D4core4math5atan2FNaNbNiNfeeZe", &eval_unimp);
    if (CTFloat.yl2x_supported)
    {
        add_builtin("_D4core4math4yl2xFNaNbNiNfeeZe", &eval_yl2x);
    }
    else
    {
        add_builtin("_D4core4math4yl2xFNaNbNiNfeeZe", &eval_unimp);
    }
    if (CTFloat.yl2xp1_supported)
    {
        add_builtin("_D4core4math6yl2xp1FNaNbNiNfeeZe", &eval_yl2xp1);
    }
    else
    {
        add_builtin("_D4core4math6yl2xp1FNaNbNiNfeeZe", &eval_unimp);
    }
    //     long function(real)
    add_builtin("_D4core4math6rndtolFNaNbNiNfeZl", &eval_unimp);
    //     real function(real)
    add_builtin("_D3std4math3tanFNaNbNiNfeZe", &eval_tan);
    add_builtin("_D3std4math4trig3tanFNaNbNiNfeZe", &eval_tan);
    add_builtin("_D3std4math5expm1FNaNbNiNfeZe", &eval_unimp);
    //    real function(real)
    add_builtin("_D3std4math3tanFNaNbNiNeeZe", &eval_tan);
    add_builtin("_D3std4math4trig3tanFNaNbNiNeeZe", &eval_tan);
    add_builtin("_D3std4math3expFNaNbNiNeeZe", &eval_exp);
    add_builtin("_D3std4math5expm1FNaNbNiNeeZe", &eval_expm1);
    add_builtin("_D3std4math4exp2FNaNbNiNeeZe", &eval_exp2);
    //     real function(real, real)
    add_builtin("_D3std4math5atan2FNaNbNiNfeeZe", &eval_unimp);
    add_builtin("_D3std4math4trig5atan2FNaNbNiNfeeZe", &eval_unimp);
    //     T function(T, цел)
    add_builtin("_D4core4math5ldexpFNaNbNiNfeiZe", &eval_ldexp);

    add_builtin("_D3std4math3logFNaNbNiNfeZe", &eval_log);

    add_builtin("_D3std4math4log2FNaNbNiNfeZe", &eval_log2);

    add_builtin("_D3std4math5log10FNaNbNiNfeZe", &eval_log10);

    add_builtin("_D3std4math5roundFNbNiNeeZe", &eval_round);
    add_builtin("_D3std4math5roundFNaNbNiNeeZe", &eval_round);

    add_builtin("_D3std4math5floorFNaNbNiNefZf", &eval_floor);
    add_builtin("_D3std4math5floorFNaNbNiNedZd", &eval_floor);
    add_builtin("_D3std4math5floorFNaNbNiNeeZe", &eval_floor);

    add_builtin("_D3std4math4ceilFNaNbNiNefZf", &eval_ceil);
    add_builtin("_D3std4math4ceilFNaNbNiNedZd", &eval_ceil);
    add_builtin("_D3std4math4ceilFNaNbNiNeeZe", &eval_ceil);

    add_builtin("_D3std4math5truncFNaNbNiNeeZe", &eval_trunc);

    add_builtin("_D3std4math4fminFNaNbNiNfeeZe", &eval_fmin);

    add_builtin("_D3std4math4fmaxFNaNbNiNfeeZe", &eval_fmax);

    add_builtin("_D3std4math__T8copysignTfTfZQoFNaNbNiNeffZf", &eval_copysign);
    add_builtin("_D3std4math__T8copysignTdTdZQoFNaNbNiNeddZd", &eval_copysign);
    add_builtin("_D3std4math__T8copysignTeTeZQoFNaNbNiNeeeZe", &eval_copysign);

    add_builtin("_D3std4math__T3powTfTfZQjFNaNbNiNeffZf", &eval_pow);
    add_builtin("_D3std4math__T3powTdTdZQjFNaNbNiNeddZd", &eval_pow);
    add_builtin("_D3std4math__T3powTeTeZQjFNaNbNiNeeeZe", &eval_pow);

    add_builtin("_D3std4math3fmaFNaNbNiNfeeeZe", &eval_fma);

    //    бул function(T)
    add_builtin("_D3std4math__T5isNaNTeZQjFNaNbNiNeeZb", &eval_isnan);
    add_builtin("_D3std4math__T5isNaNTdZQjFNaNbNiNedZb", &eval_isnan);
    add_builtin("_D3std4math__T5isNaNTfZQjFNaNbNiNefZb", &eval_isnan);
    add_builtin("_D3std4math__T10isInfinityTeZQpFNaNbNiNeeZb", &eval_isinfinity);
    add_builtin("_D3std4math__T10isInfinityTdZQpFNaNbNiNedZb", &eval_isinfinity);
    add_builtin("_D3std4math__T10isInfinityTfZQpFNaNbNiNefZb", &eval_isinfinity);
    add_builtin("_D3std4math__T8isFiniteTeZQmFNaNbNiNeeZb", &eval_isfinite);
    add_builtin("_D3std4math__T8isFiniteTdZQmFNaNbNiNedZb", &eval_isfinite);
    add_builtin("_D3std4math__T8isFiniteTfZQmFNaNbNiNefZb", &eval_isfinite);

    //     цел function(бцел)
    add_builtin("_D4core5bitop3bsfFNaNbNiNfkZi", &eval_bsf);
    add_builtin("_D4core5bitop3bsrFNaNbNiNfkZi", &eval_bsr);
    //     цел function(бдол)
    add_builtin("_D4core5bitop3bsfFNaNbNiNfmZi", &eval_bsf);
    add_builtin("_D4core5bitop3bsrFNaNbNiNfmZi", &eval_bsr);
    //     бцел function(бцел)
    add_builtin("_D4core5bitop5bswapFNaNbNiNfkZk", &eval_bswap);
    //     цел function(бцел)
    add_builtin("_D4core5bitop7_popcntFNaNbNiNfkZi", &eval_popcnt);
    //     ushort function(ushort)
    add_builtin("_D4core5bitop7_popcntFNaNbNiNftZt", &eval_popcnt);
    //     цел function(бдол)
    if (глоб2.парамы.is64bit)
        add_builtin("_D4core5bitop7_popcntFNaNbNiNfmZi", &eval_popcnt);

    //     float core.math.toPrec!(float).toPrec(float)
    add_builtin("_D4core4math__T6toPrecHTfZQlFNaNbNiNffZf", &eval_toPrecFloat);
    //     float core.math.toPrec!(float).toPrec(double)
    add_builtin("_D4core4math__T6toPrecHTfZQlFNaNbNiNfdZf", &eval_toPrecFloat);
    //     float core.math.toPrec!(float).toPrec(real)
    add_builtin("_D4core4math__T6toPrecHTfZQlFNaNbNiNfeZf", &eval_toPrecFloat);
    //     double core.math.toPrec!(double).toPrec(float)
    add_builtin("_D4core4math__T6toPrecHTdZQlFNaNbNiNffZd", &eval_toPrecDouble);
    //     double core.math.toPrec!(double).toPrec(double)
    add_builtin("_D4core4math__T6toPrecHTdZQlFNaNbNiNfdZd", &eval_toPrecDouble);
    //     double core.math.toPrec!(double).toPrec(real)
    add_builtin("_D4core4math__T6toPrecHTdZQlFNaNbNiNfeZd", &eval_toPrecDouble);
    //     double core.math.toPrec!(real).toPrec(float)
    add_builtin("_D4core4math__T6toPrecHTeZQlFNaNbNiNffZe", &eval_toPrecReal);
    //     double core.math.toPrec!(real).toPrec(double)
    add_builtin("_D4core4math__T6toPrecHTeZQlFNaNbNiNfdZe", &eval_toPrecReal);
    //     double core.math.toPrec!(real).toPrec(real)
    add_builtin("_D4core4math__T6toPrecHTeZQlFNaNbNiNfeZe", &eval_toPrecReal);
}

/**
 * Deinitializes the глоб2 state of the compiler.
 *
 * This can be используется to restore the state set by `builtin_init` to its original
 * state.
 */
public проц builtinDeinitialize()
{
    builtins = builtins.init;
}

/**********************************
 * Determine if function is a builtin one that we can
 * evaluate at compile time.
 */
public  BUILTIN isBuiltin(FuncDeclaration fd)
{
    if (fd.builtin == BUILTIN.unknown)
    {
        builtin_fp fp = builtin_lookup(mangleExact(fd));
        fd.builtin = fp ? BUILTIN.yes : BUILTIN.no;
    }
    return fd.builtin;
}

/**************************************
 * Evaluate builtin function.
 * Return результат; NULL if cannot evaluate it.
 */
public  Выражение eval_builtin(Место место, FuncDeclaration fd, Выражения* arguments)
{
    if (fd.builtin == BUILTIN.yes)
    {
        builtin_fp fp = builtin_lookup(mangleExact(fd));
        assert(fp);
        return fp(место, fd, arguments);
    }
    return null;
}
