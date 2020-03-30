/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/complex.d, _complex.d)
 * Documentation:  https://dlang.org/phobos/dmd_complex.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/complex.d
 */

module dmd.complex;

import util.ctfloat;

 class complex_t
{
    real_t re;
    real_t im;

   // this() @disable;

    this(real_t re)
    {
        this(re, CTFloat.нуль);
    }

    this(real_t re, real_t im)
    {
        this.re = re;
        this.im = im;
    }

    complex_t opBinary(ткст op)(complex_t y){
        if (op == "+")
        {
            return complex_t(re + y.re, im + y.im);
        }}

    complex_t opBinary(ткст op)(complex_t y){
        if (op == "-")
    {
        return complex_t(re - y.re, im - y.im);
    }}

    complex_t opUnary(ткст op)(){
        if (op == "-")
    {
        return complex_t(-re, -im);
    }}

    complex_t opBinary(ткст op)(complex_t y){
        if (op == "*")
    {
        return complex_t(re * y.re - im * y.im, im * y.re + re * y.im);
    }}

    complex_t opBinaryRight(ткст op)(real_t x){
        if (op == "*")
    {
        return complex_t(x) * this;
    }}

    complex_t opBinary(ткст op)(real_t y){
        if (op == "*")
    {
        return this * complex_t(y);
    }}

    complex_t opBinary(ткст op)(real_t y){
        if (op == "/")
    {
        return this / complex_t(y);
    }}

    complex_t opBinary(ткст op)(complex_t y){
        if (op == "/")
    {
        if (CTFloat.fabs(y.re) < CTFloat.fabs(y.im))
        {
            const r = y.re / y.im;
            const den = y.im + r * y.re;
            return complex_t((re * r + im) / den, (im * r - re) / den);
        }
        else
        {
            const r = y.im / y.re;
            const den = y.re + r * y.im;
            return complex_t((re + r * im) / den, (im - r * re) / den);
        }
    }}

    бул opCast(T : бул)()
    {
        return re || im;
    }

    цел opEquals(complex_t y)
    {
        return re == y.re && im == y.im;
    }
}

 real_t creall(complex_t x)
{
    return x.re;
}

 real_t cimagl(complex_t x)
{
    return x.im;
}
