/**
 * Elementary Mathematical Functions
 *
 * Copyright: Portions Copyright (C) 2001-2005 Digital Mars.
 * License:   BSD стиль: $(LICENSE), Digital Mars.
 * Authors:   Walter Bright, Don Clugston, Sean Kelly
 */
/* Portions of this код were taken из_ Phobos std.math, which есть the following
 * copyright notice:
 *
 * Author:
 *  Walter Bright
 * Copyright:
 *  Copyright (c) 2001-2005 by Digital Mars,
 *  все Rights Reserved,
 *  www.digitalmars.com
 * License:
 *  This software is provопрed 'as-is', without any express or implied
 *  warranty. In no событие will the authors be held liable for any damages
 *  arising из_ the use of this software.
 *
 *  Permission is granted в_ anyone в_ use this software for any purpose,
 *  включая commercial applications, and в_ alter it and redistribute it
 *  freely, субъект в_ the following restrictions:
 *
 *  <ul>
 *  <li> The origin of this software must not be misrepresented; you must not
 *       claim that you wrote the original software. If you use this software
 *       in a product, an acknowledgment in the product documentation would be
 *       appreciated but is not required.
 *  </li>
 *  <li> Altered источник versions must be plainly marked as such, and must not
 *       be misrepresented as being the original software.
 *  </li>
 *  <li> This notice may not be removed or altered из_ any источник
 *       distribution.
 *  </li>
 *  </ul>
 */

/**
 * Macros:
 *  NAN = $(RED NAN)
 *  TEXTNAN = $(RED NAN:$1 )
 *  SUP = <вринтервал стиль="vertical-align:super;font-размер:smaller">$0</вринтервал>
 *  GAMMA =  &#915;
 *  INTEGRAL = &#8747;
 *  INTEGRATE = $(BIG &#8747;<sub>$(SMALL $1)</sub><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  BIGSUM = $(BIG &Sigma; <sup>$2</sup><sub>$(SMALL $1)</sub>)
 *  CHOOSE = $(BIG &#40;) <sup>$(SMALL $1)</sup><sub>$(SMALL $2)</sub> $(BIG &#41;)
 *  PLUSMN = &plusmn;
 *  INFIN = &infin;
 *  PLUSMNINF = &plusmn;&infin;
 *  PI = &pi;
 *  LT = &lt;
 *  GT = &gt;
 *  SQRT = &radix;
 *  HALF = &frac12;
 *  TABLE_SV = <table border=1 cellpдобавьing=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</table>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  TABLE_DOMRG = <table border=1 cellpдобавьing=4 cellspacing=0>$0</table>
 *  DOMAIN = $(TR $(TD Domain) $(TD $0))
 *  RANGE  = $(TR $(TD Диапазон) $(TD $0))
 */

module math.Math;

static import rt.core.stdc.math;
private import math.IEEE;


version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(TangoNoAsm) {

} else version(D_InlineAsm_X86) {
    version = Naked_D_InlineAsm_X86;
}
version(LDC)
{
    import ldc.intrinsics;
}

/*
 * Constants
 */

const реал E =          2.7182818284590452354L;  /** e */ // 3.32193 fldl2t 0x1.5BF0A8B1_45769535_5FF5p+1L
const реал LOG2T =      0x1.a934f0979a3715fcp+1; /** $(SUB лог, 2)10 */ // 1.4427 fldl2e
const реал LOG2E =      0x1.71547652b82fe178p+0; /** $(SUB лог, 2)e */ // 0.30103 fldlg2
const реал LOG2 =       0x1.34413509f79fef32p-2; /** $(SUB лог, 10)2 */
const реал LOG10E =     0.43429448190325182765;  /** $(SUB лог, 10)e */
const реал LN2 =        0x1.62e42fefa39ef358p-1; /** ln 2 */  // 0.693147 fldln2
const реал LN10 =       2.30258509299404568402;  /** ln 10 */
const реал PI =         0x1.921fb54442d1846ap+1; /** $(_PI) */ // 3.14159 fldpi
const реал PI_2 =       1.57079632679489661923;  /** $(PI) / 2 */
const реал PI_4 =       0.78539816339744830962;  /** $(PI) / 4 */
const реал M_1_PI =     0.31830988618379067154;  /** 1 / $(PI) */
const реал M_2_PI =     0.63661977236758134308;  /** 2 / $(PI) */
const реал M_2_SQRTPI = 1.12837916709551257390;  /** 2 / $(SQRT)$(PI) */
const реал SQRT2 =      1.41421356237309504880;  /** $(SQRT)2 */
const реал SQRT1_2 =    0.70710678118654752440;  /** $(SQRT)$(HALF) */

//const реал SQRTPI  = 1.77245385090551602729816748334114518279754945612238L; /** &radic;&pi; */
//const реал SQRT2PI = 2.50662827463100050242E0L; /** &radic;(2 &pi;) */
//const реал SQRTE   = 1.64872127070012814684865078781416357L; /** &radic;(e) */

const реал MAXLOG = 0x1.62e42fefa39ef358p+13L;  /** лог(реал.max) */
const реал MINLOG = -0x1.6436716d5406e6d8p+13L; /** лог(реал.min*реал.epsilon) */
const реал EULERGAMMA = 0.57721_56649_01532_86060_65120_90082_40243_10421_59335_93992L; /** Euler-Mascheroni constant 0.57721566.. */

/*
 * Primitives
 */

/**
 * Calculates the абсолютный значение
 *
 * For комплексное numbers, абс(z) = квкор( $(POWER z.re, 2) + $(POWER z.im, 2) )
 * = гипот(z.re, z.im).
 */
реал абс(реал x)
{
    return math.IEEE.fabs(x);
}

/** ditto */
дол абс(дол x)
{
    return x>=0 ? x : -x;
}

/** ditto */
цел абс(цел x)
{
    return x>=0 ? x : -x;
}

/** ditto */
реал абс(креал z)
{
    return гипот(z.re, z.im);
}

/** ditto */
реал абс(вреал y)
{
    return math.IEEE.fabs(y.im);
}

debug(UnitTest) {
unittest
{
    assert(идентичен_ли(0.0L,абс(-0.0L)));
    assert(нч_ли(абс(реал.nan)));
    assert(абс(-реал.infinity) == реал.infinity);
    assert(абс(-3.2Li) == 3.2L);
    assert(абс(71.6Li) == 71.6L);
    assert(абс(-56) == 56);
    assert(абс(2321312L)  == 2321312L);
    assert(абс(-1.0L+1.0Li) == квкор(2.0L));
}
}

/**
 * Complex conjugate
 *
 *  конъюнк(x + iy) = x - iy
 *
 * Note that z * конъюнк(z) = $(POWER z.re, 2) + $(POWER z.im, 2)
 * is always a реал число
 */
креал конъюнк(креал z)
{
    return z.re - z.im*1i;
}

/** ditto */
вреал конъюнк(вреал y)
{
    return -y;
}

debug(UnitTest) {
unittest
{
    assert(конъюнк(7 + 3i) == 7-3i);
    вреал z = -3.2Li;
    assert(конъюнк(z) == -z);
}
}

private {
    // Return the тип which would be returned by a max or min operation
template минмакстип(T...){
    static if(T.length == 1) alias T[0] минмакстип;
    else static if(T.length > 2)
        alias минмакстип!(минмакстип!(T[0..2]), T[2..$]) минмакстип;
    else alias typeof (T[1] > T[0] ? T[1] : T[0]) минмакстип;
}
}

/** Return the minimum of the supplied аргументы.
 *
 * Note: If the аргументы are floating-point numbers, and at least one is a НЧ,
 * the результат is undefined.
 */
минмакстип!(T) min(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] < арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return min(арг[1] < арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/** Return the maximum of the supplied аргументы.
 *
 * Note: If the аргументы are floating-point numbers, and at least one is a НЧ,
 * the результат is undefined.
 */
минмакстип!(T) max(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] > арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return max(арг[1] > арг[0] ? арг[1] : арг[0], арг[2..$]);
}
debug(UnitTest) {
unittest
{
    assert(max('e', 'f')=='f');
    assert(min(3.5, 3.8)==3.5);
    // check implicit conversion в_ целое.
    assert(min(3.5, 18)==3.5);

}
}

/** Returns the minimum число of x and y, favouring numbers over NaNs.
 *
 * If Всё x and y are numbers, the minimum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ and the другой is a число, the число is
 * returned (this behaviour is mandated by IEEE 754R, and is useful
 * for determining the range of a function).
 */
реал минЧло(реал x, реал y) {
    if (x<=y || нч_ли(y)) return x; else return y;
}

/** Returns the maximum число of x and y, favouring numbers over NaNs.
 *
 * If Всё x and y are numbers, the maximum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ and the другой is a число, the число is
 * returned (this behaviour is mandated by IEEE 754-2008, and is useful
 * for determining the range of a function).
 */
реал максЧло(реал x, реал y) {
    if (x>=y || нч_ли(y)) return x; else return y;
}

/** Returns the minimum of x and y, favouring NaNs over numbers
 *
 * If Всё x and y are numbers, the minimum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ and the другой is a число, the НЧ is returned.
 */
реал минНч(реал x, реал y) {
    return (x<=y || нч_ли(x))? x : y;
}

/** Returns the maximum of x and y, favouring NaNs over numbers
 *
 * If Всё x and y are numbers, the maximum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ and the другой is a число, the НЧ is returned.
 */
реал максНч(реал x, реал y) {
    return (x>=y || нч_ли(x))? x : y;
}

debug(UnitTest) {
unittest
{
    assert(максЧло(НЧ(0xABC), 56.1L)== 56.1L);
    assert(идентичен_ли(максНч(НЧ(1389), 56.1L), НЧ(1389)));
    assert(максЧло(28.0, НЧ(0xABC))== 28.0);
    assert(минЧло(1e12, НЧ(0xABC))== 1e12);
    assert(идентичен_ли(минНч(1e12, НЧ(23454)), НЧ(23454)));
    assert(идентичен_ли(минЧло(НЧ(489), НЧ(23)), НЧ(489)));
}
}

/*
 * Trig Functions
 */

/***********************************
 * Returns cosine of x. x is in radians.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH кос(x)) $(TH не_годится?))
 *      $(TR $(TD $(NAN))            $(TD $(NAN)) $(TD да)     )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(NAN)) $(TD да)     )
 *      )
 * Bugs:
 *      Results are undefined if |x| >= $(POWER 2,64).
 */

реал кос(реал x) /* intrinsic */
{
    version(LDC)
    {
        return llvm_cos(x);
    }
    else version(D_InlineAsm_X86)
    {
        asm
        {
            fld x;
            fcos;
        }
    }
    else
    {
        return rt.core.stdc.math.cosl(x);
    }
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(кос(НЧ(314)), НЧ(314)));
}
}

/***********************************
 * Returns sine of x. x is in radians.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)               $(TH син(x))      $(TH не_годится?))
 *      $(TR $(TD $(NAN))          $(TD $(NAN))      $(TD да))
 *      $(TR $(TD $(PLUSMN)0.0)    $(TD $(PLUSMN)0.0) $(TD no))
 *      $(TR $(TD $(PLUSMNINF))    $(TD $(NAN))      $(TD да))
 *      )
 * Bugs:
 *      Results are undefined if |x| >= $(POWER 2,64).
 */
реал син(реал x) /* intrinsic */
{
    version(LDC)
    {
        return llvm_sin(x);
    }
    else version(D_InlineAsm_X86)
    {
        asm
        {
            fld x;
            fsin;
        }
    }
    else
    {
        return rt.core.stdc.math.sinl(x);
    }
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(син(НЧ(314)), НЧ(314)));
}
}

version (GNU) {
    extern (C) реал tanl(реал);
}

/**
 * Returns tangent of x. x is in radians.
 *
 *	$(TABLE_SV
 *	$(TR $(TH x)               $(TH тан(x))       $(TH не_годится?))
 *	$(TR $(TD $(NAN))          $(TD $(NAN))       $(TD да))
 *	$(TR $(TD $(PLUSMN)0.0)    $(TD $(PLUSMN)0.0) $(TD no))
 *	$(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(NAN))     $(TD да))
 *	)
 */
реал тан(реал x)
{
    version (GNU) {
        return tanl(x);
    }
    else version(LDC) {
        return rt.core.stdc.math.tanl(x);
    }
    else {
    asm
    {
        fld x[EBP]      ; // загрузи тэта
        fxam            ; // тест for oddball values
        fstsw   AX      ;
        sahf            ;
        jc  trigerr     ; // x is NAN, infinity, or пустой
                              // 387's can укз denormals
SC18:   fptan           ;
        fstp    ST(0)   ; // dump X, which is always 1
        fstsw   AX      ;
        sahf            ;
        jnp Lret        ; // C2 = 1 (x is out of range)

        // Do аргумент reduction в_ bring x преобр_в range
        fldpi           ;
        fxch            ;
SC17:   fprem1          ;
        fstsw   AX      ;
        sahf            ;
        jp  SC17        ;
        fstp    ST(1)   ; // удали pi из_ stack
        jmp SC18        ;

trigerr:
        jnp Lret        ; // if x is НЧ, return x.
        fstp    ST(0)   ; // dump x, which will be infinity
    }
    return НЧ(TANGO_NAN.TAN_DOMAIN);
Lret:
    ;
    }
}

debug(UnitTest) {
    unittest
    {
        static реал vals[][2] =     // angle,тан
        [
                [   0,   0],
                [   .5,  .5463024898],
                [   1,   1.557407725],
                [   1.5, 14.10141995],
                [   2,  -2.185039863],
                [   2.5,-.7470222972],
                [   3,  -.1425465431],
                [   3.5, .3745856402],
                [   4,   1.157821282],
                [   4.5, 4.637332055],
                [   5,  -3.380515006],
                [   5.5,-.9955840522],
                [   6,  -.2910061914],
                [   6.5, .2202772003],
                [   10,  .6483608275],

                // special angles
                [   PI_4,   1],
                //[   PI_2,   реал.infinity], // PI_2 is not _exactly_ pi/2.
                [   3*PI_4, -1],
                [   PI,     0],
                [   5*PI_4, 1],
                //[   3*PI_2, -реал.infinity],
                [   7*PI_4, -1],
                [   2*PI,   0],
        ];
        цел i;

        for (i = 0; i < vals.length; i++)
        {
            реал x = vals[i][0];
            реал r = vals[i][1];
            реал t = тан(x);

            //printf("тан(%Lg) = %Lg, should be %Lg\n", x, t, r);
            if (!идентичен_ли(r, t)) assert(fabs(r-t) <= .0000001);

            x = -x;
            r = -r;
            t = тан(x);
            //printf("тан(%Lg) = %Lg, should be %Lg\n", x, t, r);
            if (!идентичен_ли(r, t) && !(r!<>=0 && t!<>=0)) assert(fabs(r-t) <= .0000001);
        }
        // перебор
        assert(нч_ли(тан(реал.infinity)));
        assert(нч_ли(тан(-реал.infinity)));
        // НЧ propagation
        assert(идентичен_ли( тан(НЧ(0x0123L)), НЧ(0x0123L) ));
    }
}

/*****************************************
 * Sine, cosine, and arctangent of multИПle of &pi;
 *
 * Accuracy is preserved for large values of x.
 */
реал косПи(реал x)
{
    return кос((x%2.0)*PI);
}

/** ditto */
реал синПи(реал x)
{
    return син((x%2.0)*PI);
}

/** ditto */
реал атанПи(реал x)
{
    return PI * атан(x); // BUG: Fix this.
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(синПи(0.0), 0.0));
    assert(идентичен_ли(синПи(-0.0), -0.0));
    assert(идентичен_ли(атанПи(0.0), 0.0));
    assert(идентичен_ли(атанПи(-0.0), -0.0));
}
}

/***********************************
 *  sine, комплексное and мнимое
 *
 *  син(z) = син(z.re)*гкос(z.im) + кос(z.re)*гсин(z.im)i
 *
 * If Всё син(&тэта;) and кос(&тэта;) are required,
 * it is most efficient в_ use expi(&тэта).
 */
креал син(креал z)
{
  креал cs = expi(z.re);
  return cs.im * гкос(z.im) + cs.re * гсин(z.im) * 1i;
}

/** ditto */
вреал син(вреал y)
{
  return гкос(y.im)*1i;
}

debug(UnitTest) {
unittest {
  assert(син(0.0+0.0i) == 0.0);
  assert(син(2.0+0.0i) == син(2.0L) );
}
}

/***********************************
 *  cosine, комплексное and мнимое
 *
 *  кос(z) = кос(z.re)*гкос(z.im) + син(z.re)*гсин(z.im)i
 */
креал кос(креал z)
{
  креал cs = expi(z.re);
  return cs.re * гкос(z.im) - cs.im * гсин(z.im) * 1i;
}

/** ditto */
реал кос(вреал y)
{
  return гкос(y.im);
}

debug(UnitTest) {
unittest{
  assert(кос(0.0+0.0i)==1.0);
  assert(кос(1.3L+0.0i)==кос(1.3L));
  assert(кос(5.2Li)== гкос(5.2L));
}
}

/***************
 * Calculates the arc cosine of x,
 * returning a значение ranging из_ 0 в_ $(PI).
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)         $(TH акос(x)) $(TH не_годится?))
 *      $(TR $(TD $(GT)1.0)  $(TD $(NAN))  $(TD да))
 *      $(TR $(TD $(LT)-1.0) $(TD $(NAN))  $(TD да))
 *      $(TR $(TD $(NAN))    $(TD $(NAN))  $(TD да))
 *      )
 */
реал акос(реал x)
{
    return rt.core.stdc.math.acosl(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    version(darwin){}
    else {
        assert(идентичен_ли(акос(НЧ(254)), НЧ(254)));
    }
}
}

/***************
 * Calculates the arc sine of x,
 * returning a значение ranging из_ -$(PI)/2 в_ $(PI)/2.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)            $(TH асин(x))      $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)0.0) $(TD $(PLUSMN)0.0) $(TD no))
 *      $(TR $(TD $(GT)1.0)     $(TD $(NAN))       $(TD да))
 *      $(TR $(TD $(LT)-1.0)    $(TD $(NAN))       $(TD да))
 *      )
 */
реал асин(реал x)
{
    return rt.core.stdc.math.asinl(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    version(darwin){}
    else{
        assert(идентичен_ли(асин(НЧ(7249)), НЧ(7249)));
    }
}
}

/***************
 * Calculates the arc tangent of x,
 * returning a значение ranging из_ -$(PI)/2 в_ $(PI)/2.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH атан(x))      $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0) $(TD no))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(NAN))       $(TD да))
 *      )
 */
реал атан(реал x)
{
    return rt.core.stdc.math.atanl(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(атан(НЧ(9876)), НЧ(9876)));
}
}

/***************
 * Calculates the arc tangent of y / x,
 * returning a значение ranging из_ -$(PI) в_ $(PI).
 *
 *      $(TABLE_SV
 *      $(TR $(TH y)                 $(TH x)            $(TH атан(y, x)))
 *      $(TR $(TD $(NAN))            $(TD anything)     $(TD $(NAN)) )
 *      $(TR $(TD anything)          $(TD $(NAN))       $(TD $(NAN)) )
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(GT)0.0)     $(TD $(PLUSMN)0.0) )
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD +0.0)         $(TD $(PLUSMN)0.0) )
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(LT)0.0)     $(TD $(PLUSMN)$(PI)))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD -0.0)         $(TD $(PLUSMN)$(PI)))
 *      $(TR $(TD $(GT)0.0)          $(TD $(PLUSMN)0.0) $(TD $(PI)/2) )
 *      $(TR $(TD $(LT)0.0)          $(TD $(PLUSMN)0.0) $(TD -$(PI)/2) )
 *      $(TR $(TD $(GT)0.0)          $(TD $(INFIN))     $(TD $(PLUSMN)0.0) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD anything)     $(TD $(PLUSMN)$(PI)/2))
 *      $(TR $(TD $(GT)0.0)          $(TD -$(INFIN))    $(TD $(PLUSMN)$(PI)) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(INFIN))     $(TD $(PLUSMN)$(PI)/4))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD -$(INFIN))    $(TD $(PLUSMN)3$(PI)/4))
 *      )
 */
реал атан2(реал y, реал x)
{
    return rt.core.stdc.math.atan2l(y,x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(атан2(5.3, НЧ(9876)), НЧ(9876)));
    assert(идентичен_ли(атан2(НЧ(9876), 2.18), НЧ(9876)));
}
}

/***********************************
 * Complex inverse sine
 *
 * асин(z) = -i лог( квкор(1-$(POWER z, 2)) + iz)
 * where Всё лог and квкор are комплексное.
 */
креал асин(креал z)
{
    return -лог(квкор(1-z*z) + z*1i)*1i;
}

debug(UnitTest) {
unittest {
   assert(асин(син(0+0i)) == 0 + 0i);
}
}

/***********************************
 * Complex inverse cosine
 *
 * акос(z) = $(PI)/2 - асин(z)
 */
креал акос(креал z)
{
    return PI_2 - асин(z);
}


/***********************************
 * Calculates the hyperbolic cosine of x.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH гкос(x))      $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(PLUSMN)0.0) $(TD no) )
 *      )
 */
реал гкос(реал x)
{
    //  гкос = (эксп(x)+эксп(-x))/2.
    // The naive implementation works correctly. 
    реал y = эксп(x);
    return (y + 1.0/y) * 0.5;
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(гкос(НЧ(432)), НЧ(432)));
}
}

/***********************************
 * Calculates the hyperbolic sine of x.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH гсин(x))           $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0)      $(TD no))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(PLUSMN)$(INFIN)) $(TD no))
 *      )
 */
реал гсин(реал x)
{
    //  гсин(x) =  (эксп(x)-эксп(-x))/2;    
    // Very large аргументы could cause an перебор, but
    // the maximum значение of x for which эксп(x) + эксп(-x)) != эксп(x)
    // is x = 0.5 * (реал.mant_dig) * LN2. // = 22.1807 for real80.
    if (fabs(x) > реал.mant_dig * LN2) {
        return copysign(0.5*эксп(fabs(x)), x);
    }    
    реал y = экспм1(x);
    return 0.5 * y / (y+1) * (y+2);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(гсин(НЧ(0xABC)), НЧ(0xABC)));
}
}

/***********************************
 * Calculates the hyperbolic tangent of x.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH гтан(x))      $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0) $(TD no) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(PLUSMN)1.0) $(TD no))
 *      )
 */
реал гтан(реал x)
{
    //  гтан(x) = (эксп(x) - эксп(-x))/(эксп(x)+эксп(-x))
    if (fabs(x)> реал.mant_dig * LN2){
        return copysign(1, x);        
    }
    реал y = экспм1(2*x);
    return y/(y + 2);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(гтан(НЧ(0xABC)), НЧ(0xABC)));
}
}

/***********************************
 *  hyperbolic sine, комплексное and мнимое
 *
 *  гсин(z) = кос(z.im)*гсин(z.re) + син(z.im)*гкос(z.re)i
 */
креал гсин(креал z)
{
  креал cs = expi(z.im);
  return cs.re * гсин(z.re) + cs.im * гкос(z.re) * 1i;
}

/** ditto */
вреал гсин(вреал y)
{
  return син(y.im)*1i;
}

debug(UnitTest) {
unittest {
  assert(гсин(4.2L + 0i)==гсин(4.2L));
}
}

/***********************************
 *  hyperbolic cosine, комплексное and мнимое
 *
 *  гкос(z) = кос(z.im)*гкос(z.re) + син(z.im)*гсин(z.re)i
 */
креал гкос(креал z)
{
  креал cs = expi(z.im);
  return cs.re * гкос(z.re) + cs.im * гсин(z.re) * 1i;
}

/** ditto */
реал гкос(вреал y)
{
  return кос(y.im);
}

debug(UnitTest) {
unittest {
  assert(гкос(8.3L + 0i)==гкос(8.3L));
}
}


/***********************************
 * Calculates the inverse hyperbolic cosine of x.
 *
 *  Mathematically, гакос(x) = лог(x + квкор( x*x - 1))
 *
 *    $(TABLE_SV
 *    $(SVH  x,     гакос(x) )
 *    $(SV  $(NAN), $(NAN) )
 *    $(SV  $(LT)1,     $(NAN) )
 *    $(SV  1,      0       )
 *    $(SV  +$(INFIN),+$(INFIN))
 *  )
 */
реал гакос(реал x)
{
    if (x > 1/реал.epsilon)
    return LN2 + лог(x);
    else
    return лог(x + квкор(x*x - 1));
}

debug(UnitTest) {
unittest
{
    assert(нч_ли(гакос(0.9)));
    assert(нч_ли(гакос(реал.nan)));
    assert(гакос(1)==0.0);
    assert(гакос(реал.infinity) == реал.infinity);
    // НЧ payloads
    assert(идентичен_ли(гакос(НЧ(0xABC)), НЧ(0xABC)));
}
}

/***********************************
 * Calculates the inverse hyperbolic sine of x.
 *
 *  Mathematically,
 *  ---------------
 *  гасин(x) =  лог( x + квкор( x*x + 1 )) // if x >= +0
 *  гасин(x) = -лог(-x + квкор( x*x + 1 )) // if x <= -0
 *  -------------
 *
 *    $(TABLE_SV
 *    $(SVH x,                гасин(x)       )
 *    $(SV  $(NAN),           $(NAN)         )
 *    $(SV  $(PLUSMN)0,       $(PLUSMN)0      )
 *    $(SV  $(PLUSMN)$(INFIN),$(PLUSMN)$(INFIN))
 *    )
 */
реал гасин(реал x)
{
    if (math.IEEE.fabs(x) > 1 / реал.epsilon) // beyond this point, x*x + 1 == x*x
    return math.IEEE.copysign(LN2 + лог(math.IEEE.fabs(x)), x);
    else
    {
    // квкор(x*x + 1) ==  1 + x * x / ( 1 + квкор(x*x + 1) )
    return math.IEEE.copysign(лог1п(math.IEEE.fabs(x) + x*x / (1 + квкор(x*x + 1)) ), x);
    }
}

debug(UnitTest) {
unittest
{
    assert(идентичен_ли(0.0L,гасин(0.0)));
    assert(идентичен_ли(-0.0L,гасин(-0.0)));
    assert(гасин(реал.infinity) == реал.infinity);
    assert(гасин(-реал.infinity) == -реал.infinity);
    assert(нч_ли(гасин(реал.nan)));
    // НЧ payloads
    assert(идентичен_ли(гасин(НЧ(0xABC)), НЧ(0xABC)));
}
}

/***********************************
 * Calculates the inverse hyperbolic tangent of x,
 * returning a значение из_ ranging из_ -1 в_ 1.
 *
 * Mathematically, гатан(x) = лог( (1+x)/(1-x) ) / 2
 *
 *
 *    $(TABLE_SV
 *    $(SVH  x,     гакос(x) )
 *    $(SV  $(NAN), $(NAN) )
 *    $(SV  $(PLUSMN)0, $(PLUSMN)0)
 *    $(SV  -$(INFIN), -0)
 *    )
 */
реал гатан(реал x)
{
    // лог( (1+x)/(1-x) ) == лог ( 1 + (2*x)/(1-x) )
    return  0.5 * лог1п( 2 * x / (1 - x) );
}

debug(UnitTest) {
unittest
{
    assert(идентичен_ли(0.0L, гатан(0.0)));
    assert(идентичен_ли(-0.0L,гатан(-0.0)));
    assert(идентичен_ли(гатан(-1),-реал.infinity));
    assert(идентичен_ли(гатан(1),реал.infinity));
    assert(нч_ли(гатан(-реал.infinity)));
    // НЧ payloads
    assert(идентичен_ли(гатан(НЧ(0xABC)), НЧ(0xABC)));
}
}

/** ditto */
креал гатан(вреал y)
{
    // Not optimised for accuracy or скорость
    return 0.5*(лог(1+y) - лог(1-y));
}

/** ditto */
креал гатан(креал z)
{
    // Not optimised for accuracy or скорость
    return 0.5 * (лог(1 + z) - лог(1-z));
}

/*
 * Powers and Roots
 */

/***************************************
 * Compute square корень of x.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)         $(TH квкор(x))   $(TH не_годится?))
 *      $(TR $(TD -0.0)      $(TD -0.0)      $(TD no))
 *      $(TR $(TD $(LT)0.0)  $(TD $(NAN))    $(TD да))
 *      $(TR $(TD +$(INFIN)) $(TD +$(INFIN)) $(TD no))
 *      )
 */
плав квкор(плав x) /* intrinsic */
{
    version(LDC)
    {
        return llvm_sqrt(x);
    }
    else version(D_InlineAsm_X86)
    {
        asm
        {
            fld x;
            fsqrt;
        }
    }
    else
    {
        return rt.core.stdc.math.sqrtf(x);
    }
}

дво квкор(дво x) /* intrinsic */ /// ditto
{
    version(LDC)
    {
        return llvm_sqrt(x);
    }
    else version(D_InlineAsm_X86)
    {
        asm
        {
            fld x;
            fsqrt;
        }
    }
    else
    {
        return rt.core.stdc.math.квкор(x);
    }
}

реал квкор(реал x) /* intrinsic */ /// ditto
{
    version(LDC)
    {
        return llvm_sqrt(x);
    }
    else version(D_InlineAsm_X86)
    {
        asm
        {
            fld x;
            fsqrt;
        }
    }
    else
    {
        return rt.core.stdc.math.sqrtl(x);
    }
}

/** ditto */
креал квкор(креал z)
{

    if (z == 0.0) return z;
    реал x,y,w,r;
    креал c;

    x = math.IEEE.fabs(z.re);
    y = math.IEEE.fabs(z.im);
    if (x >= y) {
        r = y / x;
        w = квкор(x) * квкор(0.5 * (1 + квкор(1 + r * r)));
    } else  {
        r = x / y;
        w = квкор(y) * квкор(0.5 * (r + квкор(1 + r * r)));
    }

    if (z.re >= 0) {
        c = w + (z.im / (w + w)) * 1.0i;
    } else {
        if (z.im < 0)  w = -w;
        c = z.im / (w + w) + w * 1.0i;
    }
    return c;
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(квкор(НЧ(0xABC)), НЧ(0xABC)));
    assert(квкор(-1+0i) == 1i);
    assert(идентичен_ли(квкор(0-0i), 0-0i));
    assert(отнравкх(квкор(4+16i)*квкор(4+16i), 4+16i)>=реал.mant_dig-2);
}
}

/***************
 * Calculates the cube корень of x.
 *
 *      $(TABLE_SV
 *      $(TR $(TH $(I x))            $(TH кубкор(x))           $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0)      $(TD no) )
 *      $(TR $(TD $(NAN))            $(TD $(NAN))            $(TD да) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD $(PLUSMN)$(INFIN)) $(TD no) )
 *      )
 */
реал кубкор(реал x)
{
    return rt.core.stdc.math.cbrtl(x);
}


debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(кубкор(НЧ(0xABC)), НЧ(0xABC)));
}
}

public:

/**
 * Calculates e$(SUP x).
 *
 *  $(TABLE_SV
 *    $(TR $(TH x)             $(TH e$(SUP x)) )
 *    $(TD +$(INFIN))          $(TD +$(INFIN)) )
 *    $(TD -$(INFIN))          $(TD +0.0)      )
 *    $(TR $(TD $(NAN))        $(TD $(NAN))    )
 *  )
 */
реал эксп(реал x) {
    version(Naked_D_InlineAsm_X86) {
   //  e^x = 2^(LOG2E*x)
   // (This is valid because the перебор & недобор limits for эксп
   // and эксп2 are so similar).
    return эксп2(LOG2E*x);
    } else {
        return rt.core.stdc.math.expl(x);        
    }    
}

/**
 * Calculates the значение of the натурал logarithm основа (e)
 * raised в_ the power of x, minus 1.
 *
 * For very small x, экспм1(x) is ещё accurate
 * than эксп(x)-1.
 *
 *  $(TABLE_SV
 *    $(TR $(TH x)             $(TH e$(SUP x)-1)  )
 *    $(TR $(TD $(PLUSMN)0.0)  $(TD $(PLUSMN)0.0) )
 *    $(TD +$(INFIN))          $(TD +$(INFIN))    )
 *    $(TD -$(INFIN))          $(TD -1.0)         )
 *    $(TR $(TD $(NAN))        $(TD $(NAN))       )
 *  )
 */
реал экспм1(реал x) 
{
    version(Naked_D_InlineAsm_X86) {
      enum { PARAMSIZE = (реал.sizeof+3)&(0xFFFF_FFFC) } // always a multИПle of 4
      asm {
        /*  экспм1() for x87 80-bit reals, IEEE754-2008 conformant.
         * Author: Don Clugston.
         * 
         *    экспм1(x) = 2^(окрвцел(y))* 2^(y-окрвцел(y)) - 1 where y = LN2*x.
         *    = 2rndy * 2ym1 + 2rndy - 1, where 2rndy = 2^(окрвцел(y))
         *     and 2ym1 = (2^(y-окрвцел(y))-1).
         *    If 2rndy  < 0.5*реал.epsilon, результат is -1.
         *    Implementation is otherwise the same as for эксп2()
         */
        naked;        
        fld real ptr [ESP+4] ; // x
        mov AX, [ESP+4+8]; // AX = exponent and sign
        sub ESP, 12+8; // Create черновик пространство on the stack 
        // [ESP,ESP+2] = scratchint
        // [ESP+4..+6, +8..+10, +10] = scratchreal
        // установи scratchreal mantissa = 1.0
        mov dword ptr [ESP+8], 0;
        mov dword ptr [ESP+8+4], 0x80000000;
        and AX, 0x7FFF; // drop sign bit
        cmp AX, 0x401D; // avoопр InvalidException in fist
        jae L_extreme;
        fldl2e;
        fmul ; // y = x*лог2(e)       
        fist dword ptr [ESP]; // scratchint = окрвцел(y)
        fisub dword ptr [ESP]; // y - окрвцел(y)
        // and сейчас установи scratchreal exponent
        mov EAX, [ESP];
        добавь EAX, 0x3fff;
        jle крат L_largenegative;
        cmp EAX,0x8000;
        jge крат L_largepositive;
        mov [ESP+8+8],AX;        
        f2xm1; // 2^(y-окрвцел(y)) -1 
        fld real ptr [ESP+8] ; // 2^окрвцел(y)
        fmul ST(1), ST;
        fld1;
        fsubp ST(1), ST;
        fдобавь;        
        добавь ESP,12+8;        
        ret PARAMSIZE;
        
L_extreme: // Extreme exponent. X is very large positive, very
        // large negative, infinity, or НЧ.
        fxam;
        fstsw AX;
        test AX, 0x0400; // NaN_or_zero, but we already know x!=0 
        jz L_was_nan;  // if x is НЧ, returns x
        test AX, 0x0200;
        jnz L_largenegative;
L_largepositive:        
        // Набор scratchreal = реал.max. 
        // squaring it will создай infinity, and установи перебор flag.
        mov word  ptr [ESP+8+8], 0x7FFE;
        fstp ST(0), ST;
        fld real ptr [ESP+8];  // загрузи scratchreal
        fmul ST(0), ST;        // square it, в_ создай havoc!
L_was_nan:
        добавь ESP,12+8;
        ret PARAMSIZE;
L_largenegative:        
        fstp ST(0), ST;
        fld1;
        fchs; // return -1. Underflow flag is not установи.
        добавь ESP,12+8;
        ret PARAMSIZE;
      }
    } else {
        return rt.core.stdc.math.expm1l(x);                
    }
}

/**
 * Calculates 2$(SUP x).
 *
 *  $(TABLE_SV
 *    $(TR $(TH x)             $(TH эксп2(x)    )
 *    $(TD +$(INFIN))          $(TD +$(INFIN)) )
 *    $(TD -$(INFIN))          $(TD +0.0)      )
 *    $(TR $(TD $(NAN))        $(TD $(NAN))    )
 *  )
 */
реал эксп2(реал x) 
{
    version(Naked_D_InlineAsm_X86) {
      enum { PARAMSIZE = (реал.sizeof+3)&(0xFFFF_FFFC) } // always a multИПle of 4
      asm {
        /*  эксп2() for x87 80-bit reals, IEEE754-2008 conformant.
         * Author: Don Clugston.
         * 
         * эксп2(x) = 2^(окрвцел(x))* 2^(y-окрвцел(x))
         * The trick for high performance is в_ avoопр the fscale(28cycles on core2),
         * frndint(19 cycles), leaving f2xm1(19 cycles) as the only slow instruction.
         * 
         * We can do frndint by using fist. BUT we can't use it for huge numbers,
         * because it will установи the Invalid Operation flag is перебор or НЧ occurs.
         * Fortunately, whenever this happens the результат would be zero or infinity.
         * 
         * We can perform fscale by directly poking преобр_в the exponent. BUT this doesn't
         * work for the (very rare) cases where the результат is subnormal. So we fall back
         * в_ the slow метод in that case.
         */
        naked;        
        fld real ptr [ESP+4] ; // x
        mov AX, [ESP+4+8]; // AX = exponent and sign
        sub ESP, 12+8; // Create черновик пространство on the stack 
        // [ESP,ESP+2] = scratchint
        // [ESP+4..+6, +8..+10, +10] = scratchreal
        // установи scratchreal mantissa = 1.0
        mov dword ptr [ESP+8], 0;
        mov dword ptr [ESP+8+4], 0x80000000;
        and AX, 0x7FFF; // drop sign bit
        cmp AX, 0x401D; // avoопр InvalidException in fist
        jae L_extreme;
        fist dword ptr [ESP]; // scratchint = окрвцел(x)
        fisub dword ptr [ESP]; // x - окрвцел(x)
        // and сейчас установи scratchreal exponent
        mov EAX, [ESP];
        добавь EAX, 0x3fff;
        jle крат L_subnormal;
        cmp EAX,0x8000;
        jge крат L_overflow;
        mov [ESP+8+8],AX;        
L_normal:
        f2xm1;
        fld1;
        fдобавь; // 2^(x-окрвцел(x))
        fld real ptr [ESP+8] ; // 2^окрвцел(x)
        добавь ESP,12+8;        
        fmulp ST(1), ST;
        ret PARAMSIZE;

L_subnormal:
        // Результат will be subnormal.
        // In this rare case, the simple poking метод doesn't work. 
        // The скорость doesn't matter, so use the slow fscale метод.
        fild dword ptr [ESP];  // scratchint
        fld1;
        fscale;
        fstp real ptr [ESP+8]; // scratchreal = 2^scratchint
        fstp ST(0),ST;         // drop scratchint        
        jmp L_normal;
        
L_extreme: // Extreme exponent. X is very large positive, very
        // large negative, infinity, or НЧ.
        fxam;
        fstsw AX;
        test AX, 0x0400; // NaN_or_zero, but we already know x!=0 
        jz L_was_nan;  // if x is НЧ, returns x
        // установи scratchreal = реал.min
        // squaring it will return 0, настройка недобор flag
        mov word  ptr [ESP+8+8], 1;
        test AX, 0x0200;
        jnz L_waslargenegative;
L_overflow:        
        // Набор scratchreal = реал.max.
        // squaring it will создай infinity, and установи перебор flag.
        mov word  ptr [ESP+8+8], 0x7FFE;
L_waslargenegative:        
        fstp ST(0), ST;
        fld real ptr [ESP+8];  // загрузи scratchreal
        fmul ST(0), ST;        // square it, в_ создай havoc!
L_was_nan:
        добавь ESP,12+8;
        ret PARAMSIZE;
      }
    } else {
        return rt.core.stdc.math.exp2l(x);
    }    
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(эксп(НЧ(0xABC)), НЧ(0xABC)));
}
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(экспм1(НЧ(0xABC)), НЧ(0xABC)));
}
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(эксп2(НЧ(0xABC)), НЧ(0xABC)));
}
}

/*
 * Powers and Roots
 */

/**************************************
 * Calculate the натурал logarithm of x.
 *
 *    $(TABLE_SV
 *    $(TR $(TH x)            $(TH лог(x))    $(TH divопрe by 0?) $(TH не_годится?))
 *    $(TR $(TD $(PLUSMN)0.0) $(TD -$(INFIN)) $(TD да)          $(TD no))
 *    $(TR $(TD $(LT)0.0)     $(TD $(NAN))    $(TD no)           $(TD да))
 *    $(TR $(TD +$(INFIN))    $(TD +$(INFIN)) $(TD no)           $(TD no))
 *    )
 */
реал лог(реал x)
{
    return rt.core.stdc.math.logl(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(лог(НЧ(0xABC)), НЧ(0xABC)));
}
}

/******************************************
 *      Calculates the натурал logarithm of 1 + x.
 *
 *      For very small x, лог1п(x) will be ещё accurate than
 *      лог(1 + x).
 *
 *  $(TABLE_SV
 *  $(TR $(TH x)            $(TH лог1п(x))     $(TH divопрe by 0?) $(TH не_годится?))
 *  $(TR $(TD $(PLUSMN)0.0) $(TD $(PLUSMN)0.0) $(TD no)           $(TD no))
 *  $(TR $(TD -1.0)         $(TD -$(INFIN))    $(TD да)          $(TD no))
 *  $(TR $(TD $(LT)-1.0)    $(TD $(NAN))       $(TD no)           $(TD да))
 *  $(TR $(TD +$(INFIN))    $(TD -$(INFIN))    $(TD no)           $(TD no))
 *  )
 */
реал лог1п(реал x)
{
    return rt.core.stdc.math.log1pl(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(лог1п(НЧ(0xABC)), НЧ(0xABC)));
}
}

/***************************************
 * Calculates the основа-2 logarithm of x:
 * $(SUB лог, 2)x
 *
 *  $(TABLE_SV
 *  $(TR $(TH x)            $(TH лог2(x))   $(TH divопрe by 0?) $(TH не_годится?))
 *  $(TR $(TD $(PLUSMN)0.0) $(TD -$(INFIN)) $(TD да)          $(TD no) )
 *  $(TR $(TD $(LT)0.0)     $(TD $(NAN))    $(TD no)           $(TD да) )
 *  $(TR $(TD +$(INFIN))    $(TD +$(INFIN)) $(TD no)           $(TD no) )
 *  )
 */
реал лог2(реал x)
{
    return rt.core.stdc.math.log2l(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(лог2(НЧ(0xABC)), НЧ(0xABC)));
}
}

/**************************************
 * Calculate the основа-10 logarithm of x.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)            $(TH лог10(x))  $(TH divопрe by 0?) $(TH не_годится?))
 *      $(TR $(TD $(PLUSMN)0.0) $(TD -$(INFIN)) $(TD да)          $(TD no))
 *      $(TR $(TD $(LT)0.0)     $(TD $(NAN))    $(TD no)           $(TD да))
 *      $(TR $(TD +$(INFIN))    $(TD +$(INFIN)) $(TD no)           $(TD no))
 *      )
 */
реал лог10(реал x)
{
    return rt.core.stdc.math.log10l(x);
}

debug(UnitTest) {
unittest {
    // НЧ payloads
    assert(идентичен_ли(лог10(НЧ(0xABC)), НЧ(0xABC)));
}
}

/***********************************
 * Exponential, комплексное and мнимое
 *
 * For комплексное numbers, the exponential function is defined as
 *
 *  эксп(z) = эксп(z.re)кос(z.im) + эксп(z.re)син(z.im)i.
 *
 *  For a pure мнимое аргумент,
 *  эксп(&тэта;i)  = кос(&тэта;) + син(&тэта;)i.
 *
 */
креал эксп(вреал y)
{
   return expi(y.im);
}

/** ditto */
креал эксп(креал z)
{
  return expi(z.im) * эксп(z.re);
}

debug(UnitTest) {
unittest {
    assert(эксп(1.3e5Li)==кос(1.3e5L)+син(1.3e5L)*1i);
    assert(эксп(0.0Li)==1L+0.0Li);
    assert(эксп(7.2 + 0.0i) == эксп(7.2L));
    креал c = эксп(вреал.nan);
    assert(нч_ли(c.re) && нч_ли(c.im));
    c = эксп(вреал.infinity);
    assert(нч_ли(c.re) && нч_ли(c.im));
}
}

/***********************************
 *  Natural logarithm, комплексное
 *
 * Returns комплексное logarithm в_ the основа e (2.718...) of
 * the комплексное аргумент x.
 *
 * If z = x + iy, then
 *       лог(z) = лог(абс(z)) + i arctan(y/x).
 *
 * The arctangent ranges из_ -PI в_ +PI.
 * There are branch cuts along Всё the negative реал and negative
 * мнимое axes. For pure мнимое аргументы, use one of the
 * following forms, depending on which branch is required.
 * ------------
 *    лог( 0.0 + yi) = лог(-y) + PI_2i  // y<=-0.0
 *    лог(-0.0 + yi) = лог(-y) - PI_2i  // y<=-0.0
 * ------------
 */
креал лог(креал z)
{
  return лог(абс(z)) + атан2(z.im, z.re)*1i;
}

debug(UnitTest) {
private {    
/*
 * отнравх for комплексное numbers. Returns the worst relative
 * equality of the two components.
 */
цел отнравкх(креал a, креал b)
{
    цел intmin(цел a, цел b) { return a<b? a: b; }
    return intmin(отнравх(a.re, b.re), отнравх(a.im, b.im));
}
}
unittest {

  assert(лог(3.0L +0i) == лог(3.0L)+0i);
  assert(отнравкх(лог(0.0L-2i),( лог(2.0L)-PI_2*1i)) >= реал.mant_dig-10);
  assert(отнравкх(лог(0.0L+2i),( лог(2.0L)+PI_2*1i)) >= реал.mant_dig-10);
}
}

/**
 * Быстрый integral powers.
 */
реал степ(реал x, бцел n)
{
    реал p;

    switch (n)
    {
    case 0:
        p = 1.0;
        break;

    case 1:
        p = x;
        break;

    case 2:
        p = x * x;
        break;

    default:
        p = 1.0;
        while (1){
            if (n & 1)
                p *= x;
            n >>= 1;
            if (!n)
                break;
            x *= x;
        }
        break;
    }
    return p;
}

/** ditto */
реал степ(реал x, цел n)
{
    if (n < 0) return степ(x, cast(реал)n);
    else return степ(x, cast(бцел)n);
}

/*********************************************
 * Calculates x$(SUP y).
 *
 * $(TABLE_SV
 * $(TR $(TH x) $(TH y) $(TH степ(x, y))
 *      $(TH div 0) $(TH не_годится?))
 * $(TR $(TD anything)      $(TD $(PLUSMN)0.0)                $(TD 1.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD |x| $(GT) 1)    $(TD +$(INFIN))                  $(TD +$(INFIN))
 *      $(TD no)        $(TD no) )
 * $(TR $(TD |x| $(LT) 1)    $(TD +$(INFIN))                  $(TD +0.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD |x| $(GT) 1)    $(TD -$(INFIN))                  $(TD +0.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD |x| $(LT) 1)    $(TD -$(INFIN))                  $(TD +$(INFIN))
 *      $(TD no)        $(TD no) )
 * $(TR $(TD +$(INFIN))      $(TD $(GT) 0.0)                  $(TD +$(INFIN))
 *      $(TD no)        $(TD no) )
 * $(TR $(TD +$(INFIN))      $(TD $(LT) 0.0)                  $(TD +0.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD -$(INFIN))      $(TD odd целое $(GT) 0.0)      $(TD -$(INFIN))
 *      $(TD no)        $(TD no) )
 * $(TR $(TD -$(INFIN))      $(TD $(GT) 0.0, not odd целое) $(TD +$(INFIN))
 *      $(TD no)        $(TD no))
 * $(TR $(TD -$(INFIN))      $(TD odd целое $(LT) 0.0)      $(TD -0.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD -$(INFIN))      $(TD $(LT) 0.0, not odd целое) $(TD +0.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD $(PLUSMN)1.0)   $(TD $(PLUSMN)$(INFIN))          $(TD $(NAN))
 *      $(TD no)        $(TD да) )
 * $(TR $(TD $(LT) 0.0)      $(TD finite, nonintegral)        $(TD $(NAN))
 *      $(TD no)        $(TD да))
 * $(TR $(TD $(PLUSMN)0.0)   $(TD odd целое $(LT) 0.0)      $(TD $(PLUSMNINF))
 *      $(TD да)       $(TD no) )
 * $(TR $(TD $(PLUSMN)0.0)   $(TD $(LT) 0.0, not odd целое) $(TD +$(INFIN))
 *      $(TD да)       $(TD no))
 * $(TR $(TD $(PLUSMN)0.0)   $(TD odd целое $(GT) 0.0)      $(TD $(PLUSMN)0.0)
 *      $(TD no)        $(TD no) )
 * $(TR $(TD $(PLUSMN)0.0)   $(TD $(GT) 0.0, not odd целое) $(TD +0.0)
 *      $(TD no)        $(TD no) )
 * )
 */
реал степ(реал x, реал y)
{
    version (linux) // C степ() often does not укз special values correctly
    {
    if (нч_ли(y))
        return y;

    if (y == 0)
        return 1;       // even if x is $(NAN)
    if (нч_ли(x) && y != 0)
        return x;
    if (isInfinity(y))
    {
        if (math.IEEE.fabs(x) > 1)
        {
            if (signbit(y))
                return +0.0;
            else
                return реал.infinity;
        }
        else if (math.IEEE.fabs(x) == 1)
        {
            return НЧ(TANGO_NAN.POW_DOMAIN);
        }
        else // < 1
        {
            if (signbit(y))
                return реал.infinity;
            else
                return +0.0;
        }
    }
    if (isInfinity(x))
    {
        if (signbit(x))
        {
            дол i;
            i = cast(дол)y;
            if (y > 0)
            {
                if (i == y && i & 1)
                return -реал.infinity;
                else
                return реал.infinity;
            }
            else if (y < 0)
            {
                if (i == y && i & 1)
                return -0.0;
                else
                return +0.0;
            }
        }
        else
        {
            if (y > 0)
                return реал.infinity;
            else if (y < 0)
                return +0.0;
        }
    }

    if (x == 0.0)
    {
        if (signbit(x))
        {
            дол i;

            i = cast(дол)y;
            if (y > 0)
            {
                if (i == y && i & 1)
                return -0.0;
                else
                return +0.0;
            }
            else if (y < 0)
            {
                if (i == y && i & 1)
                return -реал.infinity;
                else
                return реал.infinity;
            }
        }
        else
        {
            if (y > 0)
                return +0.0;
            else if (y < 0)
                return реал.infinity;
        }
    }
    }
    version(LDC)
    {
        return llvm_pow(x, y);
    }
    else
    {
        return rt.core.stdc.math.powl(x, y);
    }
}

debug(UnitTest) {
unittest
{
    реал x = 46;

    assert(степ(x,0) == 1.0);
    assert(степ(x,1) == x);
    assert(степ(x,2) == x * x);
    assert(степ(x,3) == x * x * x);
    assert(степ(x,8) == (x * x) * (x * x) * (x * x) * (x * x));
    // НЧ payloads
    assert(идентичен_ли(степ(НЧ(0xABC), 19), НЧ(0xABC)));
}
}

/***********************************************************************
 * Calculates the length of the
 * hypotenuse of a right-angled triangle with sопрes of length x and y.
 * The hypotenuse is the значение of the square корень of
 * the sums of the squares of x and y:
 *
 *      квкор($(POW x, 2) + $(POW y, 2))
 *
 * Note that гипот(x, y), гипот(y, x) and
 * гипот(x, -y) are equivalent.
 *
 *  $(TABLE_SV
 *  $(TR $(TH x)            $(TH y)            $(TH гипот(x, y)) $(TH не_годится?))
 *  $(TR $(TD x)            $(TD $(PLUSMN)0.0) $(TD |x|)         $(TD no))
 *  $(TR $(TD $(PLUSMNINF)) $(TD y)            $(TD +$(INFIN))   $(TD no))
 *  $(TR $(TD $(PLUSMNINF)) $(TD $(NAN))       $(TD +$(INFIN))   $(TD no))
 *  )
 */
реал гипот(реал x, реал y)
{
    /*
     * This is based on код из_:
     * Cephes Math Library Release 2.1:  January, 1989
     * Copyright 1984, 1987, 1989 by Stephen L. Moshier
     * Direct inquiries в_ 30 Frost Street, Cambrопрge, MA 02140
     */

    const цел PRECL = реал.mant_dig/2; // = 32

    реал xx, yy, b, re, im;
    цел ex, ey, e;

    // Note, гипот(INFINITY, NAN) = INFINITY.
    if (math.IEEE.isInfinity(x) || math.IEEE.isInfinity(y))
        return реал.infinity;

    if (math.IEEE.нч_ли(x))
        return x;
    if (math.IEEE.нч_ли(y))
        return y;

    re = math.IEEE.fabs(x);
    im = math.IEEE.fabs(y);

    if (re == 0.0)
        return im;
    if (im == 0.0)
        return re;

    // Get the exponents of the numbers
    xx = math.IEEE.frexp(re, ex);
    yy = math.IEEE.frexp(im, ey);

    // Check if one число is tiny compared в_ the другой
    e = ex - ey;
    if (e > PRECL)
        return re;
    if (e < -PRECL)
        return im;

    // Find approximate exponent e of the geometric mean.
    e = (ex + ey) >> 1;

    // Rescale so mean is about 1
    xx = math.IEEE.ldexp(re, -e);
    yy = math.IEEE.ldexp(im, -e);

    // Hypotenuse of the right triangle
    b = квкор(xx * xx  +  yy * yy);

    // Compute the exponent of the answer.
    yy = math.IEEE.frexp(b, ey);
    ey = e + ey;

    // Check it for перебор and недобор.
    if (ey > реал.max_exp + 2) {
        return реал.infinity;
    }
    if (ey < реал.min_exp - 2)
        return 0.0;

    // Undo the scaling
    b = math.IEEE.ldexp(b, e);
    return b;
}

debug(UnitTest) {
unittest
{
    static реал vals[][3] = // x,y,гипот
    [
        [   0,  0,  0],
        [   0,  -0, 0],
        [   3,  4,  5],
        [   -300,   -400,   500],
        [   реал.min, реал.min,  0x1.6a09e667f3bcc908p-16382L],
        [   реал.max/2, реал.max/2, 0x1.6a09e667f3bcc908p+16383L /*8.41267e+4931L*/],
        [   реал.max, 1, реал.max],
        [   реал.infinity, реал.nan, реал.infinity],
        [   реал.nan, реал.nan, реал.nan],
    ];

    for (цел i = 0; i < vals.length; i++)
    {
        реал x = vals[i][0];
        реал y = vals[i][1];
        реал z = vals[i][2];
        реал h = гипот(x, y);

        assert(идентичен_ли(z, h));
    }
    // НЧ payloads
    assert(идентичен_ли(гипот(НЧ(0xABC), 3.14), НЧ(0xABC)));
    assert(идентичен_ли(гипот(7.6e39, НЧ(0xABC)), НЧ(0xABC)));
}
}

/***********************************
 * Evaluate polynomial A(x) = $(SUB a, 0) + $(SUB a, 1)x + $(SUB a, 2)$(POWER x,2)
 *                          + $(SUB a,3)$(POWER x,3); ...
 *
 * Uses Horner's правило A(x) = $(SUB a, 0) + x($(SUB a, 1) + x($(SUB a, 2) 
 *                         + x($(SUB a, 3) + ...)))
 * Параметры:
 *      A =     Массив of coefficients $(SUB a, 0), $(SUB a, 1), etc.
 */
T поли(T)(T x, T[] A)
in
{
    assert(A.length > 0);
}
body
{
  version (Naked_D_InlineAsm_X86) {
      const бул Use_D_InlineAsm_X86 = да;
  } else const бул Use_D_InlineAsm_X86 = нет;
  
  // BUG (Inherited из_ Phobos): This код assumes a frame pointer in EBP.
  // This is not in the spec.
  static if (Use_D_InlineAsm_X86 && is(T==реал) && T.sizeof == 10) {
    asm // assembler by W. Bright
    {
        // EDX = (A.length - 1) * реал.sizeof
        mov     ECX,A[EBP]          ; // ECX = A.length
        dec     ECX                 ;
        lea     EDX,[ECX][ECX*8]    ;
        добавь     EDX,ECX             ;
        добавь     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x[EBP]              ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2:  fmul    ST,ST(1)           ; // r *= x
        fld     real ptr -10[EDX]   ;
        sub     EDX,10              ; // deg--
        fдобавьp   ST(1),ST            ;
        dec     ECX                 ;
        jne     L2                  ;
        fxch    ST(1)               ; // ST1 = r, ST0 = x
        fstp    ST(0)               ; // dump x
        align   4                   ;
    return_ST:                      ;
        ;
    }
  } else static if ( Use_D_InlineAsm_X86 && is(T==реал) && T.sizeof==12){
    asm // assembler by W. Bright
    {
        // EDX = (A.length - 1) * реал.sizeof
        mov     ECX,A[EBP]          ; // ECX = A.length
        dec     ECX                 ;
        lea     EDX,[ECX*8]         ;
        lea     EDX,[EDX][ECX*4]    ;
        добавь     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x                   ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2: fmul    ST,ST(1)            ; // r *= x
        fld     real ptr -12[EDX]   ;
        sub     EDX,12              ; // deg--
        fдобавьp   ST(1),ST            ;
        dec     ECX                 ;
        jne     L2                  ;
        fxch    ST(1)               ; // ST1 = r, ST0 = x
        fstp    ST(0)               ; // dump x
        align   4                   ;
    return_ST:                      ;
        ;
        }
  } else {
        т_дельтаук i = A.length - 1;
        реал r = A[i];
        while (--i >= 0)
        {
            r *= x;
            r += A[i];
        }
        return r;
  }
}

debug(UnitTest) {
unittest
{
    реал x = 3.1;
    const реал pp[] = [56.1L, 32.7L, 6L];

    assert( поли(x, pp) == (56.1L + (32.7L + 6L * x) * x) );

    assert(идентичен_ли(поли(НЧ(0xABC), pp), НЧ(0xABC)));
}
}

package {
T рационалПоли(T)(T x, T [] numerator, T [] denominator)
{
    return поли(x, numerator)/поли(x, denominator);
}
}

deprecated {
private enum : цел { MANTDIG_2 = реал.mant_dig/2 } // Compiler workaround

/** Floating point "approximate equality".
 *
 * Return да if x is equal в_ y, в_ within the specified точность
 * If roundoffbits is not specified, a reasonable default is used.
 */
бул равп(цел точность = MANTDIG_2, XReal=реал, YReal=реал)(XReal x, YReal y)
{
    static assert(is( XReal: реал) && is(YReal : реал));
    return math.IEEE.отнравх(x, y) >= точность;
}

unittest{
    assert(!равп(1.0,2.0));
    реал y = 58.0000000001;
    assert(равп!(20)(58, y));
}
}

/*
 * Rounding (returning реал)
 */

/**
 * Returns the значение of x rounded downward в_ the следщ целое
 * (toward negative infinity).
 */
реал пол(реал x)
{
    return rt.core.stdc.math.floorl(x);
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(пол(НЧ(0xABC)), НЧ(0xABC)));
}
}

/**
 * Returns the значение of x rounded upward в_ the следщ целое
 * (toward positive infinity).
 */
реал потолок(реал x)
{
    return rt.core.stdc.math.ceill(x);
}

unittest {
    assert(идентичен_ли(потолок(НЧ(0xABC)), НЧ(0xABC)));
}

/**
 * Return the значение of x rounded в_ the nearest целое.
 * If the fractional часть of x is exactly 0.5, the return значение is rounded в_
 * the even целое.
 */
реал округли(реал x)
{
    return rt.core.stdc.math.roundl(x);
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(округли(НЧ(0xABC)), НЧ(0xABC)));
}
}

/**
 * Returns the целое portion of x, dropping the fractional portion.
 *
 * This is also known as "chop" rounding.
 */
реал обрежь(реал x)
{
    return rt.core.stdc.math.truncl(x);
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(обрежь(НЧ(0xABC)), НЧ(0xABC)));
}
}

/**
* Rounds x в_ the nearest цел or дол.
*
* This is generally the fastest метод в_ преобразуй a floating-point число
* в_ an целое. Note that the results из_ this function
* depend on the rounding режим, if the fractional часть of x is exactly 0.5.
* If using the default rounding режим (ties округли в_ even целыйs)
* окрвцел(4.5) == 4, окрвцел(5.5)==6.
*/
цел окрвцел(реал x)
{
    version(Naked_D_InlineAsm_X86)
    {
        цел n;
        asm
        {
            fld x;
            fistp n;
        }
        return n;
    }
    else
    {
        return rt.core.stdc.math.lrintl(x);
    }
}

/** ditto */
дол окрвдол(реал x)
{
    version(Naked_D_InlineAsm_X86)
    {
        дол n;
        asm
        {
            fld x;
            fistp n;
        }
        return n;
    }
    else
    {
        return rt.core.stdc.math.llrintl(x);
    }
}

debug(UnitTest) {
version(D_InlineAsm_X86) { // Won't work for anything else yet

unittest {

    цел r = дайИ3еОкругление;
    assert(r==РежимОкругления.НАИБЛИЖАЙШИЙ);
    реал b = 5.5;
    цел cnear = math.Math.окрвцел(b);
    assert(cnear == 6);
    auto oldrounding = установиИ3еОкругление(РежимОкругления.ВВЕРХ);
    scope (exit) установиИ3еОкругление(oldrounding);

    assert(дайИ3еОкругление==РежимОкругления.ВВЕРХ);

    цел cdown = math.Math.окрвцел(b);
    assert(cdown==5);
}

unittest {
    // Check that the previous тест correctly restored the rounding режим
    assert(дайИ3еОкругление==РежимОкругления.НАИБЛИЖАЙШИЙ);
}
}
}
