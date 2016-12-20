/**
 * Реализует функции гамма и бета, их интегралы.
 *
 * License:   BSD стиль: $(LICENSE)
 * Copyright: Based on the CEPHES math library, which is
 *            Copyright (C) 1994 Stephen L. Moshier (moshier@world.std.com).
 * Authors:   Stephen L. Moshier (original C код). Conversion в_ D by Don Clugston
 *
 *
Macros:
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  GAMMA =  &#915;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  NAN = $(RED NAN)
 */
module math.GammaFunction;
private import math.Math;
private import math.IEEE;
private import math.ErrorFunction;

version(Windows) { // Some tests only пароль on DMD Windows
    version(DigitalMars) {
    version = FailsOnLinux;
}
}

//------------------------------------------------------------------

/// Максимальное значение x , для которого гамма(x) < реал.infinity.
const реал МАКСГАММА = 1755.5483429L;

private {

const реал КВКОР2ПИ = 2.50662827463100050242E0L; // квкор(2pi)

// Polynomial approximations for гамма и loggamma.

const реал КоэффЧислителяГаммы[] = [ 1.0,
    0x1.acf42d903366539ep-1, 0x1.73a991c8475f1aeap-2, 0x1.c7e918751d6b2a92p-4, 
    0x1.86d162cca32cfe86p-6, 0x1.0c378e2e6eaf7cd8p-8, 0x1.dc5c66b7d05feb54p-12,
    0x1.616457b47e448694p-15
];

const реал КоэффЗнаменателяГаммы[] = [ 1.0,
  0x1.a8f9faae5d8fc8bp-2,  -0x1.cb7895a6756eebdep-3,  -0x1.7b9bab006d30652ap-5,
  0x1.c671af78f312082ep-6, -0x1.a11ebbfaf96252dcp-11, -0x1.447b4d2230a77ddap-10,
  0x1.ec1d45bb85e06696p-13,-0x1.d4ce24d05bd0a8e6p-17
];

const реал КоэффМалойГаммы[] = [ 1.0,
    0x1.2788cfc6fb618f52p-1, -0x1.4fcf4026afa2f7ecp-1, -0x1.5815e8fa24d7e306p-5,
    0x1.5512320aea2ad71ap-3, -0x1.59af0fb9d82e216p-5,  -0x1.3b4b61d3bfdf244ap-7,
    0x1.d9358e9d9d69fd34p-8, -0x1.38fc4bcbada775d6p-10
];

const реал КоэффМалойОтрицГаммы[] = [ -1.0,
    0x1.2788cfc6fb618f54p-1, 0x1.4fcf4026afa2bc4cp-1, -0x1.5815e8fa2468fec8p-5,
    -0x1.5512320baedaf4b6p-3, -0x1.59af0fa283baf07ep-5, 0x1.3b4a70de31e05942p-7,
    0x1.d9398be3bad13136p-8, 0x1.291b73ee05bcbba2p-10
];

const реал логКоэффГаммыСтирлинга[] = [
    0x1.5555555555553f98p-4, -0x1.6c16c16c07509b1p-9, 0x1.a01a012461cbf1e4p-11,
    -0x1.3813089d3f9d164p-11, 0x1.b911a92555a277b8p-11, -0x1.ed0a7b4206087b22p-10,
    0x1.402523859811b308p-8
];

const реал логЧислительГаммы[] = [
    -0x1.0edd25913aaa40a2p+23, -0x1.31c6ce2e58842d1ep+24, -0x1.f015814039477c3p+23,
    -0x1.74ffe40c4b184b34p+22, -0x1.0d9c6d08f9eab55p+20,  -0x1.54c6b71935f1fc88p+16,
    -0x1.0e761b42932b2aaep+11
];

const реал логЗнаменательГаммы[] = [
    -0x1.4055572d75d08c56p+24, -0x1.deeb6013998e4d76p+24, -0x1.106f7cded5dcc79ep+24,
    -0x1.25e17184848c66d2p+22, -0x1.301303b99a614a0ap+19, -0x1.09e76ab41ae965p+15,
    -0x1.00f95ced9e5f54eep+9, 1.0
];

/*
 * Вспомогательная функция: Функция гаммы по формуле Стирлинга.
 *
 * Формула Стирлинга для гаммы следующая:
 *
 * $(GAMMA)(x) = квкор(2 &pi;) x<sup>x-0.5</sup> эксп(-x) (1 + 1/x P(1/x))
 *
 */
реал гаммаСтирлинга(реал x)
{
    // CEPHES код Copyright 1994 by Stephen L. Moshier

    const реал SmallStirlingCoeffs[] = [
        0x1.55555555555543aap-4, 0x1.c71c71c720dd8792p-9, -0x1.5f7268f0b5907438p-9,
        -0x1.e13cd410e0477de6p-13, 0x1.9b0f31643442616ep-11, 0x1.2527623a3472ae08p-14,
        -0x1.37f6bc8ef8b374dep-11,-0x1.8c968886052b872ap-16, 0x1.76baa9c6d3eeddbcp-11
    ];

    const реал LargeStirlingCoeffs[] = [ 1.0L,
        8.33333333333333333333E-2L, 3.47222222222222222222E-3L,
        -2.68132716049382716049E-3L, -2.29472093621399176955E-4L,
        7.84039221720066627474E-4L, 6.97281375836585777429E-5L
    ];

    реал w = 1.0L/x;
    реал y = эксп(x);
    if ( x > 1024.0L ) {
        // For large x, use rational coefficients из_ the analytical expansion.
        w = поли(w, LargeStirlingCoeffs);
        // Avoопр перебор in степень()
        реал v = степень( x, 0.5L * x - 0.25L );
        y = v * (v / y);
    }
    else {
        w = 1.0L + w * поли( w, SmallStirlingCoeffs);
        y = степень( x, x - 0.5L ) / y;
    }
    y = КВКОР2ПИ * y * w;
    return  y;
}

} // private

/****************
 * The знак of $(GAMMA)(x).
 *
 * Returns -1 if $(GAMMA)(x) < 0,  +1 if $(GAMMA)(x) > 0,
 * $(NAN) if знак is indeterminate.
 */
реал знакГаммы(реал x)
{
    /* Author: Don Clugston. */
    if (нч_ли(x)) return x;
    if (x > 0) return 1.0;
    if (x < -1/реал.epsilon) {
        // Large negatives lose все точность
        return НЧ(ДИНРУС_НЧ.ЗНГАММА);
    }
//  if (remquo(x, -1.0, n) == 0) {
    дол n = окрвдол(x);
    if (x == n) {
        return x == 0 ?  копируйзнак(1, x) : НЧ(ДИНРУС_НЧ.ЗНГАММА);
    }
    return n & 1 ? 1.0 : -1.0;
}

debug(UnitTest) {
unittest {
    assert(знакГаммы(5.0) == 1.0);
    assert(нч_ли(знакГаммы(-3.0)));
    assert(знакГаммы(-0.1) == -1.0);
    assert(знакГаммы(-55.1) == 1.0);
    assert(нч_ли(знакГаммы(-реал.infinity)));
    assert(идентичен_ли(знакГаммы(НЧ(0xABC)), НЧ(0xABC)));
}
}

/*****************************************************
 *  The Gamma function, $(GAMMA)(x)
 *
 *  $(GAMMA)(x) is a generalisation of the factorial function
 *  в_ реал и комплексное numbers.
 *  Like x!, $(GAMMA)(x+1) = x*$(GAMMA)(x).
 *
 *  Mathematically, if z.re > 0 then
 *   $(GAMMA)(z) = $(INTEGRATE 0, &infin;) $(POWER t, z-1)$(POWER e, -t) dt
 *
 *  $(TABLE_SV
 *    $(SVH  x,          $(GAMMA)(x) )
 *    $(SV  $(NAN),      $(NAN)      )
 *    $(SV  &plusmn;0.0, &plusmn;&infin;)
 *    $(SV целое > 0,  (x-1)!      )
 *    $(SV целое < 0,  $(NAN)      )
 *    $(SV +&infin;,     +&infin;    )
 *    $(SV -&infin;,     $(NAN)      )
 *  )
 */
реал гамма(реал x)
{
/* Based on код из_ the CEPHES library.
 * CEPHES код Copyright 1994 by Stephen L. Moshier
 *
 * Аргументы |x| <= 13 are reduced by recurrence и the function
 * approximated by a rational function of degree 7/8 in the
 * интервал (2,3).  Large аргументы are handled by Stirling's
 * formula. Large негатив аргументы are made positive using
 * a reflection formula.
 */

    реал q, z;
    if (нч_ли(x)) return x;
    if (x == -x.infinity) return НЧ(ДИНРУС_НЧ.ГАММА_ДОМЕН);
    if ( фабс(x) > МАКСГАММА ) return реал.infinity;
    if (x==0) return 1.0/x; // +- infinity depending on знак of x, создай an исключение.

    q = фабс(x);

    if ( q > 13.0L )    {
        // Large аргументы are handled by Stirling's
        // formula. Large негатив аргументы are made positive using
        // the reflection formula.

        if ( x < 0.0L ) {
            цел sgngam = 1; // знак of гамма.
            реал p  = пол(q);
            if (p == q)
                  return НЧ(ДИНРУС_НЧ.ГАММА_ДОМЕН); // poles for все целыйs <0.
            цел intpart = cast(цел)(p);
            if ( (intpart & 1) == 0 )
                sgngam = -1;
            z = q - p;
            if ( z > 0.5L ) {
                p += 1.0L;
                z = q - p;
            }
            z = q * син( ПИ * z );
            z = фабс(z) * гаммаСтирлинга(q);
            if ( z <= ПИ/реал.max ) return sgngam * реал.infinity;
            return sgngam * ПИ/z;
        } else {
            return гаммаСтирлинга(x);
        }
    }

    // Аргументы |x| <= 13 are reduced by recurrence и the function
    // approximated by a rational function of degree 7/8 in the
    // интервал (2,3).

    z = 1.0L;
    while ( x >= 3.0L ) {
        x -= 1.0L;
        z *= x;
    }

    while ( x < -0.03125L ) {
        z /= x;
        x += 1.0L;
    }

    if ( x <= 0.03125L ) {
        if ( x == 0.0L )
            return НЧ(ДИНРУС_НЧ.ГАММА_ПОЛЮС);
        else {
            if ( x < 0.0L ) {
                x = -x;
                return z / (x * поли( x, КоэффМалойОтрицГаммы ));
            } else {
                return z / (x * поли( x, КоэффМалойГаммы ));
            }
        }
    }

    while ( x < 2.0L ) {
        z /= x;
        x += 1.0L;
    }
    if ( x == 2.0L ) return z;

    x -= 2.0L;
    return z * поли( x, КоэффЧислителяГаммы ) / поли( x, КоэффЗнаменателяГаммы );
}

debug(UnitTest) {
unittest {
    // гамма(n) = factorial(n-1) if n is an целое.
    реал fact = 1.0L;
    for (цел i=1; fact<реал.max; ++i) {
        // Require exact equality for small factorials
        if (i<14) assert(гамма(i*1.0L) == fact);
        version(FailsOnLinux) assert(отнравх(гамма(i*1.0L), fact) > реал.mant_dig-15);
        fact *= (i*1.0L);
    }
    assert(гамма(0.0) == реал.infinity);
    assert(гамма(-0.0) == -реал.infinity);
    assert(нч_ли(гамма(-1.0)));
    assert(нч_ли(гамма(-15.0)));
    assert(идентичен_ли(гамма(НЧ(0xABC)), НЧ(0xABC)));
    assert(гамма(реал.infinity) == реал.infinity);
    assert(гамма(реал.max) == реал.infinity);
    assert(нч_ли(гамма(-реал.infinity)));
    assert(гамма(реал.min*реал.epsilon) == реал.infinity);
    assert(гамма(МАКСГАММА)< реал.infinity);
    assert(гамма(МАКСГАММА*2) == реал.infinity);

    // Test some high-точность значения (50 decimal цифры)
    const реал SQRT_PI = 1.77245385090551602729816748334114518279754945612238L;

    version(FailsOnLinux) assert(отнравх(гамма(0.5L), SQRT_PI) == реал.mant_dig);

    assert(отнравх(гамма(1.0/3.L),  2.67893853470774763365569294097467764412868937795730L) >= реал.mant_dig-2);
    assert(отнравх(гамма(0.25L),
        3.62560990822190831193068515586767200299516768288006L) >= реал.mant_dig-1);
    assert(отнравх(гамма(1.0/5.0L),
        4.59084371199880305320475827592915200343410999829340L) >= реал.mant_dig-1);
}
}

/*****************************************************
 * Natural logarithm of гамма function.
 *
 * Returns the основа e (2.718...) logarithm of the абсолютный
 * значение of the гамма function of the аргумент.
 *
 * For reals, логГаммы is equivalent в_ лог(фабс(гамма(x))).
 *
 *  $(TABLE_SV
 *    $(SVH  x,             логГаммы(x)   )
 *    $(SV  $(NAN),         $(NAN)      )
 *    $(SV целое <= 0,    +&infin;    )
 *    $(SV &plusmn;&infin;, +&infin;    )
 *  )
 */
реал логГаммы(реал x)
{
    /* Based on код из_ the CEPHES library.
     * CEPHES код Copyright 1994 by Stephen L. Moshier
     *
     * For аргументы greater than 33, the logarithm of the гамма
     * function is approximated by the logarithmic version of
     * Stirling's formula using a polynomial approximation of
     * degree 4. Аргументы between -33 и +33 are reduced by
     * recurrence в_ the интервал [2,3] of a rational approximation.
     * The cosecant reflection formula is employed for аргументы
     * less than -33.
     */
    реал q, w, z, f, nx;

    if (нч_ли(x)) return x;
    if (фабс(x) == x.infinity) return x.infinity;

    if( x < -34.0L ) {
        q = -x;
        w = логГаммы(q);
        реал p = пол(q);
        if ( p == q ) return реал.infinity;
        цел intpart = cast(цел)(p);
        реал sgngam = 1;
        if ( (intpart & 1) == 0 )
            sgngam = -1;
        z = q - p;
        if ( z > 0.5L ) {
            p += 1.0L;
            z = p - q;
        }
        z = q * син( ПИ * z );
        if ( z == 0.0L ) return sgngam * реал.infinity;
    /*  z = LOGPI - logl( z ) - w; */
        z = лог( ПИ/z ) - w;
        return z;
    }

    if( x < 13.0L ) {
        z = 1.0L;
        nx = пол( x +  0.5L );
        f = x - nx;
        while ( x >= 3.0L ) {
            nx -= 1.0L;
            x = nx + f;
            z *= x;
        }
        while ( x < 2.0L ) {
            if( фабс(x) <= 0.03125 ) {
                    if ( x == 0.0L ) return реал.infinity;
                    if ( x < 0.0L ) {
                        x = -x;
                        q = z / (x * поли( x, КоэффМалойОтрицГаммы));
                    } else
                        q = z / (x * поли( x, КоэффМалойГаммы));
                    return лог( фабс(q) );
            }
            z /= nx +  f;
            nx += 1.0L;
            x = nx + f;
        }
        z = фабс(z);
        if ( x == 2.0L )
            return лог(z);
        x = (nx - 2.0L) + f;
        реал p = x * рационалПоли( x, логЧислительГаммы, логЗнаменательГаммы);
        return лог(z) + p;
    }

    // const реал MAXLGM = 1.04848146839019521116e+4928L;
    //  if( x > MAXLGM ) return sgngaml * реал.infinity;

    const реал LOGSQRT2PI  =  0.91893853320467274178L; // лог( квкор( 2*pi ) )

    q = ( x - 0.5L ) * лог(x) - x + LOGSQRT2PI;
    if (x > 1.0e10L) return q;
    реал p = 1.0L / (x*x);
    q += поли( p, логКоэффГаммыСтирлинга ) / x;
    return q ;
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(логГаммы(НЧ(0xDEF)), НЧ(0xDEF)));
    assert(логГаммы(реал.infinity) == реал.infinity);
    assert(логГаммы(-1.0) == реал.infinity);
    assert(логГаммы(0.0) == реал.infinity);
    assert(логГаммы(-50.0) == реал.infinity);
    assert(идентичен_ли(0.0L, логГаммы(1.0L)));
    assert(идентичен_ли(0.0L, логГаммы(2.0L)));
    assert(логГаммы(реал.min*реал.epsilon) == реал.infinity);
    assert(логГаммы(-реал.min*реал.epsilon) == реал.infinity);

    // x, correct loggamma(x), correct d/dx loggamma(x).
    static реал[] testpoints = [
    8.0L,                    8.525146484375L      + 1.48766904143001655310E-5,   2.01564147795560999654E0L,
    8.99993896484375e-1L,    6.6375732421875e-2L  + 5.11505711292524166220E-6L, -7.54938684259372234258E-1,
    7.31597900390625e-1L,    2.2369384765625e-1   + 5.21506341809849792422E-6L, -1.13355566660398608343E0L,
    2.31639862060546875e-1L, 1.3686676025390625L  + 1.12609441752996145670E-5L, -4.56670961813812679012E0,
    1.73162841796875L,      -8.88214111328125e-2L + 3.36207740803753034508E-6L, 2.33339034686200586920E-1L,
    1.23162841796875L,      -9.3902587890625e-2L  + 1.28765089229009648104E-5L, -2.49677345775751390414E-1L,
    7.3786976294838206464e19L,   3.301798506038663053312e21L - 1.656137564136932662487046269677E5L,
                          4.57477139169563904215E1L,
    1.08420217248550443401E-19L, 4.36682586669921875e1L + 1.37082843669932230418E-5L,
                         -9.22337203685477580858E18L,
    1.0L, 0.0L, -5.77215664901532860607E-1L,
    2.0L, 0.0L, 4.22784335098467139393E-1L,
    -0.5L,  1.2655029296875L    + 9.19379714539648894580E-6L, 3.64899739785765205590E-2L,
    -1.5L,  8.6004638671875e-1L + 6.28657731014510932682E-7L, 7.03156640645243187226E-1L,
    -2.5L, -5.6243896484375E-2L + 1.79986700949327405470E-7,  1.10315664064524318723E0L,
    -3.5L,  -1.30902099609375L  + 1.43111007079536392848E-5L, 1.38887092635952890151E0L
    ];
   // TODO: тест derivatives as well.
    for (цел i=0; i<testpoints.length; i+=3) {
        assert( отнравх(логГаммы(testpoints[i]), testpoints[i+1]) > реал.mant_dig-5);
        if (testpoints[i]<МАКСГАММА) {
            assert( отнравх(лог(фабс(гамма(testpoints[i]))), testpoints[i+1]) > реал.mant_dig-5);
        }
    }
    assert(логГаммы(-50.2) == лог(фабс(гамма(-50.2))));
    assert(логГаммы(-0.008) == лог(фабс(гамма(-0.008))));
    assert(отнравх(логГаммы(-38.8),лог(фабс(гамма(-38.8)))) > реал.mant_dig-4);
    assert(отнравх(логГаммы(1500.0L),лог(гамма(1500.0L))) > реал.mant_dig-2);
}
}

private {
const реал МАКСЛОГ = 0x1.62e42fefa39ef358p+13L;  // лог(реал.max)
const реал МИНЛОГ = -0x1.6436716d5406e6d8p+13L; // лог(реал.min*реал.epsilon) = лог(smallest denormal)
const реал BETA_BIG = 9.223372036854775808e18L;
const реал BETA_BIGINV = 1.084202172485504434007e-19L;
}

/** Beta function
 *
 * The бета function is defined as
 *
 * бета(x, y) = (&Gamma;(x) &Gamma;(y))/&Gamma;(x + y)
 */
реал бета(реал x, реал y)
{
    if ((x+y)> МАКСГАММА) {
        return эксп(логГаммы(x) + логГаммы(y) - логГаммы(x+y));
    } else return гамма(x)*гамма(y)/гамма(x+y);
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(бета(НЧ(0xABC), 4), НЧ(0xABC)));
    assert(идентичен_ли(бета(2, НЧ(0xABC)), НЧ(0xABC)));
}
}

/** Incomplete бета integral
 *
 * Returns incomplete бета integral of the аргументы, evaluated
 * из_ zero в_ x. The regularized incomplete бета function is defined as
 *
 * бетаНеполная(a, b, x) = &Gamma;(a+b)/(&Gamma;(a) &Gamma;(b)) *
 * $(INTEGRATE 0, x) $(POWER t, a-1)$(POWER (1-t),b-1) dt
 *
 * и is the same as the the cumulative ни в каком дистрибутиве function.
 *
 * The домен of definition is 0 <= x <= 1.  In this
 * implementation a и b are restricted в_ positive значения.
 * The integral из_ x в_ 1 may be obtained by the symmetry
 * relation
 *
 *    betaIncompleteCompl(a, b, x )  =  бетаНеполная( b, a, 1-x )
 *
 * The integral is evaluated by a continued дво expansion
 * or, when b*x is small, by a power series.
 */
реал бетаНеполная(реал aa, реал bb, реал xx )
{
    if (!(aa>0 && bb>0)) {
         if (нч_ли(aa)) return aa;
         if (нч_ли(bb)) return bb;
         return НЧ(ДИНРУС_НЧ.БЕТА_ДОМЕН); // домен ошибка
    }
    if (!(xx>0 && xx<1.0)) {
        if (нч_ли(xx)) return xx;
        if ( xx == 0.0L ) return 0.0;
        if ( xx == 1.0L )  return 1.0;
        return НЧ(ДИНРУС_НЧ.БЕТА_ДОМЕН); // домен ошибка
    }
    if ( (bb * xx) <= 1.0L && xx <= 0.95L)   {
        return betaDistPowerSeries(aa, bb, xx);
    }
    реал x;
    реал xc; // = 1 - x

    реал a, b;
    цел флаг = 0;

    /* Реверсни a и b if x is greater than the mean. */
    if( xx > (aa/(aa+bb)) ) {
        // here x > aa/(aa+bb) и (bb*x>1 or x>0.95)
        флаг = 1;
        a = bb;
        b = aa;
        xc = xx;
        x = 1.0L - xx;
    } else {
        a = aa;
        b = bb;
        xc = 1.0L - xx;
        x = xx;
    }

    if( флаг == 1 && (b * x) <= 1.0L && x <= 0.95L) {
        // here xx > aa/(aa+bb) и  ((bb*xx>1) or xx>0.95) и (aa*(1-xx)<=1) и xx > 0.05
        return 1.0 - betaDistPowerSeries(a, b, x); // note loss of точность
    }

    реал w;
    // Choose expansion for optimal convergence
    // One is for x * (a+b+2) < (a+1),
    // the другой is for x * (a+b+2) > (a+1).
    реал y = x * (a+b-2.0L) - (a-1.0L);
    if( y < 0.0L ) {
        w = betaDistExpansion1( a, b, x );
    } else {
        w = betaDistExpansion2( a, b, x ) / xc;
    }

    /* MultИПly w by the factor
         a      b
        x  (1-x)   Gamma(a+b) / ( a Gamma(a) Gamma(b) ) .   */

    y = a * лог(x);
    реал t = b * лог(xc);
    if ( (a+b) < МАКСГАММА && фабс(y) < МАКСЛОГ && фабс(t) < МАКСЛОГ ) {
        t = степень(xc,b);
        t *= степень(x,a);
        t /= a;
        t *= w;
        t *= гамма(a+b) / (гамма(a) * гамма(b));
    } else {
        /* Resort в_ logarithms.  */
        y += t + логГаммы(a+b) - логГаммы(a) - логГаммы(b);
        y += лог(w/a);

        t = эксп(y);
/+
        // There seems в_ be a bug in Cephes at this точка.
        // Problems occur for y > МАКСЛОГ, not y < МИНЛОГ.
        if( y < МИНЛОГ ) {
            t = 0.0L;
        } else {
            t = эксп(y);
        }
+/
    }
    if( флаг == 1 ) {
/+   // CEPHES включает this код, but I think it is erroneous.
        if( t <= реал.epsilon ) {
            t = 1.0L - реал.epsilon;
        } else
+/
        t = 1.0L - t;
    }
    return t;
}

/** Inverse of incomplete бета integral
 *
 * Given y, the function finds x such that
 *
 *  бетаНеполная(a, b, x) == y
 *
 *  Newton iterations or интервал halving is использован.
 */
реал бетаНеполнаяИнв(реал aa, реал bb, реал yy0 )
{
    реал a, b, y0, d, y, x, x0, x1, lgm, yp, di, dithresh, yl, yh, xt;
    цел i, rflg, Пап, nflg;

    if (нч_ли(yy0)) return yy0;
    if (нч_ли(aa)) return aa;
    if (нч_ли(bb)) return bb;
    if( yy0 <= 0.0L )
        return 0.0L;
    if( yy0 >= 1.0L )
        return 1.0L;
    x0 = 0.0L;
    yl = 0.0L;
    x1 = 1.0L;
    yh = 1.0L;
    if( aa <= 1.0L || bb <= 1.0L ) {
        dithresh = 1.0e-7L;
        rflg = 0;
        a = aa;
        b = bb;
        y0 = yy0;
        x = a/(a+b);
        y = бетаНеполная( a, b, x );
        nflg = 0;
        goto ihalve;
    } else {
        nflg = 0;
        dithresh = 1.0e-4L;
    }

    /* approximation в_ inverse function */

    yp = -normalDistributionInvImpl( yy0 );

    if( yy0 > 0.5L ) {
        rflg = 1;
        a = bb;
        b = aa;
        y0 = 1.0L - yy0;
        yp = -yp;
    } else {
        rflg = 0;
        a = aa;
        b = bb;
        y0 = yy0;
    }

    lgm = (yp * yp - 3.0L)/6.0L;
    x = 2.0L/( 1.0L/(2.0L * a-1.0L)  +  1.0L/(2.0L * b - 1.0L) );
    d = yp * квкор( x + lgm ) / x
        - ( 1.0L/(2.0L * b - 1.0L) - 1.0L/(2.0L * a - 1.0L) )
        * (lgm + (5.0L/6.0L) - 2.0L/(3.0L * x));
    d = 2.0L * d;
    if( d < МИНЛОГ ) {
        x = 1.0L;
        goto under;
    }
    x = a/( a + b * эксп(d) );
    y = бетаНеполная( a, b, x );
    yp = (y - y0)/y0;
    if( фабс(yp) < 0.2 )
        goto newt;

    /* Resort в_ интервал halving if not закрой enough. */
ihalve:

    Пап = 0;
    di = 0.5L;
    for( i=0; i<400; i++ ) {
        if( i != 0 ) {
            x = x0  +  di * (x1 - x0);
            if( x == 1.0L ) {
                x = 1.0L - реал.epsilon;
            }
            if( x == 0.0L ) {
                di = 0.5;
                x = x0  +  di * (x1 - x0);
                if( x == 0.0 )
                    goto under;
            }
            y = бетаНеполная( a, b, x );
            yp = (x1 - x0)/(x1 + x0);
            if( фабс(yp) < dithresh )
                goto newt;
            yp = (y-y0)/y0;
            if( фабс(yp) < dithresh )
                goto newt;
        }
        if( y < y0 ) {
            x0 = x;
            yl = y;
            if( Пап < 0 ) {
                Пап = 0;
                di = 0.5L;
            } else if( Пап > 3 )
                di = 1.0L - (1.0L - di) * (1.0L - di);
            else if( Пап > 1 )
                di = 0.5L * di + 0.5L;
            else
                di = (y0 - y)/(yh - yl);
            Пап += 1;
            if( x0 > 0.95L ) {
                if( rflg == 1 ) {
                    rflg = 0;
                    a = aa;
                    b = bb;
                    y0 = yy0;
                } else {
                    rflg = 1;
                    a = bb;
                    b = aa;
                    y0 = 1.0 - yy0;
                }
                x = 1.0L - x;
                y = бетаНеполная( a, b, x );
                x0 = 0.0;
                yl = 0.0;
                x1 = 1.0;
                yh = 1.0;
                goto ihalve;
            }
        } else {
            x1 = x;
            if( rflg == 1 && x1 < реал.epsilon ) {
                x = 0.0L;
                goto готово;
            }
            yh = y;
            if( Пап > 0 ) {
                Пап = 0;
                di = 0.5L;
            }
            else if( Пап < -3 )
                di = di * di;
            else if( Пап < -1 )
                di = 0.5L * di;
            else
                di = (y - y0)/(yh - yl);
            Пап -= 1;
            }
        }
    // loss of точность имеется occurred

    //mtherr( "incbil", PLOSS );
    if( x0 >= 1.0L ) {
        x = 1.0L - реал.epsilon;
        goto готово;
    }
    if( x <= 0.0L ) {
under:
        // недобор имеется occurred
        //mtherr( "incbil", UNDERFLOW );
        x = 0.0L;
        goto готово;
    }

newt:

    if ( nflg ) {
        goto готово;
    }
    nflg = 1;
    lgm = логГаммы(a+b) - логГаммы(a) - логГаммы(b);

    for( i=0; i<15; i++ ) {
        /* Compute the function at this точка. */
        if ( i != 0 )
            y = бетаНеполная(a,b,x);
        if ( y < yl ) {
            x = x0;
            y = yl;
        } else if( y > yh ) {
            x = x1;
            y = yh;
        } else if( y < y0 ) {
            x0 = x;
            yl = y;
        } else {
            x1 = x;
            yh = y;
        }
        if( x == 1.0L || x == 0.0L )
            break;
        /* Compute the derivative of the function at this точка. */
        d = (a - 1.0L) * лог(x) + (b - 1.0L) * лог(1.0L - x) + lgm;
        if ( d < МИНЛОГ ) {
            goto готово;
        }
        if ( d > МАКСЛОГ ) {
            break;
        }
        d = эксп(d);
        /* Compute the step в_ the следщ approximation of x. */
        d = (y - y0)/d;
        xt = x - d;
        if ( xt <= x0 ) {
            y = (x - x0) / (x1 - x0);
            xt = x0 + 0.5L * y * (x - x0);
            if( xt <= 0.0L )
                break;
        }
        if ( xt >= x1 ) {
            y = (x1 - x) / (x1 - x0);
            xt = x1 - 0.5L * y * (x1 - x);
            if ( xt >= 1.0L )
                break;
        }
        x = xt;
        if ( фабс(d/x) < (128.0L * реал.epsilon) )
            goto готово;
        }
    /* Dопр not converge.  */
    dithresh = 256.0L * реал.epsilon;
    goto ihalve;

готово:
    if ( rflg ) {
        if( x <= реал.epsilon )
            x = 1.0L - реал.epsilon;
        else
            x = 1.0L - x;
    }
    return x;
}

debug(UnitTest) {
unittest { // also tested by the нормаль ни в каком дистрибутиве
  // проверь НЧ propagation
  assert(идентичен_ли(бетаНеполная(НЧ(0xABC),2,3), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполная(7,НЧ(0xABC),3), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполная(7,15,НЧ(0xABC)), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполнаяИнв(НЧ(0xABC),1,17), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполнаяИнв(2,НЧ(0xABC),8), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполнаяИнв(2,3, НЧ(0xABC)), НЧ(0xABC)));

  assert(нч_ли(бетаНеполная(-1, 2, 3)));

  assert(бетаНеполная(1, 2, 0)==0);
  assert(бетаНеполная(1, 2, 1)==1);
  assert(нч_ли(бетаНеполная(1, 2, 3)));
  assert(бетаНеполнаяИнв(1, 1, 0)==0);
  assert(бетаНеполнаяИнв(1, 1, 1)==1);

  // Test some значения against Microsoft Excel 2003.

  assert(фабс(бетаНеполная(8, 10, 0.2) - 0.010_934_315_236_957_2L) < 0.000_000_000_5);
  assert(фабс(бетаНеполная(2, 2.5, 0.9) - 0.989_722_597_604_107L) < 0.000_000_000_000_5);
  assert(фабс(бетаНеполная(1000, 800, 0.5) - 1.17914088832798E-06L) < 0.000_000_05e-6);

  assert(фабс(бетаНеполная(0.0001, 10000, 0.0001) - 0.999978059369989L) < 0.000_000_000_05);

  assert(фабс(бетаНеполнаяИнв(5, 10, 0.2) - 0.229121208190918L) < 0.000_000_5L);
  assert(фабс(бетаНеполнаяИнв(4, 7, 0.8) - 0.483657360076904L) < 0.000_000_5L);

    // Coverage tests. I don't have correct значения for these tests, but
    // these значения cover most of the код, so they are useful for
    // regression testing.
    // Extensive testing неудачно в_ increase the coverage. It seems likely that about
    // half the код in this function is unnecessary; there is potential for
    // significant improvement over the original CEPHES код.

// Excel 2003 gives clearly erroneous results (betadist>1) when a и x are tiny и b is huge.
// The correct results are for these следщ tests are неизвестное.

//    реал testpoint1 = бетаНеполная(1e-10, 5e20, 8e-21);
//    assert(testpoint1 == 0x1.ffff_ffff_c906_404cp-1L);

    assert(бетаНеполная(0.01, 327726.7, 0.545113) == 1.0);
    assert(бетаНеполнаяИнв(0.01, 8e-48, 5.45464e-20)==1-реал.epsilon);
    assert(бетаНеполнаяИнв(0.01, 8e-48, 9e-26)==1-реал.epsilon);

    assert(бетаНеполная(0.01, 498.437, 0.0121433) == 0x1.ffff_8f72_19197402p-1);
    assert(1- бетаНеполная(0.01, 328222, 4.0375e-5) == 0x1.5f62926b4p-30);
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(0x1.b3d151fbba0eb18p+1, 1.2265e-19, 2.44859e-18)==0x1.c0110c8531d0952cp-1);
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(0x1.ff1275ae5b939bcap-41, 4.6713e18, 0.0813601)==0x1.f97749d90c7adba8p-63);
    реал a1;
    a1 = 3.40483;
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(a1, 4.0640301659679627772e19L, 0.545113)== 0x1.ba8c08108aaf5d14p-109);
    реал b1;
    b1= 2.82847e-25;
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(0.01, b1, 9e-26) == 0x1.549696104490aa9p-830);

    // --- Problematic cases ---
    // This is a situation where the series expansion fails в_ converge
    assert( нч_ли(бетаНеполнаяИнв(0.12167, 4.0640301659679627772e19L, 0.0813601)));
    // This следщ результат is almost certainly erroneous.
    assert(бетаНеполная(1.16251e20, 2.18e39, 5.45e-20)==-реал.infinity);
}
}

private {
// Implementation functions

// Continued дво expansion #1 for incomplete бета integral
// Use when x < (a+1)/(a+b+2)
реал betaDistExpansion1(реал a, реал b, реал x )
{
    реал xk, pk, pkm1, pkm2, qk, qkm1, qkm2;
    реал k1, k2, k3, k4, k5, k6, k7, k8;
    реал r, t, ans;
    цел n;

    k1 = a;
    k2 = a + b;
    k3 = a;
    k4 = a + 1.0L;
    k5 = 1.0L;
    k6 = b - 1.0L;
    k7 = k4;
    k8 = a + 2.0L;

    pkm2 = 0.0L;
    qkm2 = 1.0L;
    pkm1 = 1.0L;
    qkm1 = 1.0L;
    ans = 1.0L;
    r = 1.0L;
    n = 0;
    const реал thresh = 3.0L * реал.epsilon;
    do  {
        xk = -( x * k1 * k2 )/( k3 * k4 );
        pk = pkm1 +  pkm2 * xk;
        qk = qkm1 +  qkm2 * xk;
        pkm2 = pkm1;
        pkm1 = pk;
        qkm2 = qkm1;
        qkm1 = qk;

        xk = ( x * k5 * k6 )/( k7 * k8 );
        pk = pkm1 +  pkm2 * xk;
        qk = qkm1 +  qkm2 * xk;
        pkm2 = pkm1;
        pkm1 = pk;
        qkm2 = qkm1;
        qkm1 = qk;

        if( qk != 0.0L )
            r = pk/qk;
        if( r != 0.0L ) {
            t = фабс( (ans - r)/r );
            ans = r;
        } else {
           t = 1.0L;
        }

        if( t < thresh )
            return ans;

        k1 += 1.0L;
        k2 += 1.0L;
        k3 += 2.0L;
        k4 += 2.0L;
        k5 += 1.0L;
        k6 -= 1.0L;
        k7 += 2.0L;
        k8 += 2.0L;

        if( (фабс(qk) + фабс(pk)) > BETA_BIG ) {
            pkm2 *= BETA_BIGINV;
            pkm1 *= BETA_BIGINV;
            qkm2 *= BETA_BIGINV;
            qkm1 *= BETA_BIGINV;
            }
        if( (фабс(qk) < BETA_BIGINV) || (фабс(pk) < BETA_BIGINV) ) {
            pkm2 *= BETA_BIG;
            pkm1 *= BETA_BIG;
            qkm2 *= BETA_BIG;
            qkm1 *= BETA_BIG;
            }
        }
    while( ++n < 400 );
// loss of точность имеется occurred
// mtherr( "incbetl", PLOSS );
    return ans;
}

// Continued дво expansion #2 for incomplete бета integral
// Use when x > (a+1)/(a+b+2)
реал betaDistExpansion2(реал a, реал b, реал x )
{
    реал  xk, pk, pkm1, pkm2, qk, qkm1, qkm2;
    реал k1, k2, k3, k4, k5, k6, k7, k8;
    реал r, t, ans, z;

    k1 = a;
    k2 = b - 1.0L;
    k3 = a;
    k4 = a + 1.0L;
    k5 = 1.0L;
    k6 = a + b;
    k7 = a + 1.0L;
    k8 = a + 2.0L;

    pkm2 = 0.0L;
    qkm2 = 1.0L;
    pkm1 = 1.0L;
    qkm1 = 1.0L;
    z = x / (1.0L-x);
    ans = 1.0L;
    r = 1.0L;
    цел n = 0;
    const реал thresh = 3.0L * реал.epsilon;
    do {

        xk = -( z * k1 * k2 )/( k3 * k4 );
        pk = pkm1 +  pkm2 * xk;
        qk = qkm1 +  qkm2 * xk;
        pkm2 = pkm1;
        pkm1 = pk;
        qkm2 = qkm1;
        qkm1 = qk;

        xk = ( z * k5 * k6 )/( k7 * k8 );
        pk = pkm1 +  pkm2 * xk;
        qk = qkm1 +  qkm2 * xk;
        pkm2 = pkm1;
        pkm1 = pk;
        qkm2 = qkm1;
        qkm1 = qk;

        if( qk != 0.0L )
            r = pk/qk;
        if( r != 0.0L ) {
            t = фабс( (ans - r)/r );
            ans = r;
        } else
            t = 1.0L;

        if( t < thresh )
            return ans;
        k1 += 1.0L;
        k2 -= 1.0L;
        k3 += 2.0L;
        k4 += 2.0L;
        k5 += 1.0L;
        k6 += 1.0L;
        k7 += 2.0L;
        k8 += 2.0L;

        if( (фабс(qk) + фабс(pk)) > BETA_BIG ) {
            pkm2 *= BETA_BIGINV;
            pkm1 *= BETA_BIGINV;
            qkm2 *= BETA_BIGINV;
            qkm1 *= BETA_BIGINV;
        }
        if( (фабс(qk) < BETA_BIGINV) || (фабс(pk) < BETA_BIGINV) ) {
            pkm2 *= BETA_BIG;
            pkm1 *= BETA_BIG;
            qkm2 *= BETA_BIG;
            qkm1 *= BETA_BIG;
        }
    } while( ++n < 400 );
// loss of точность имеется occurred
//mtherr( "incbetl", PLOSS );
    return ans;
}

/* Power series for incomplete гамма integral.
   Use when b*x is small.  */
реал betaDistPowerSeries(реал a, реал b, реал x )
{
    реал ai = 1.0L / a;
    реал u = (1.0L - b) * x;
    реал v = u / (a + 1.0L);
    реал t1 = v;
    реал t = u;
    реал n = 2.0L;
    реал s = 0.0L;
    реал z = реал.epsilon * ai;
    while( фабс(v) > z ) {
        u = (n - b) * x / n;
        t *= u;
        v = t / (a + n);
        s += v;
        n += 1.0L;
    }
    s += t1;
    s += ai;

    u = a * лог(x);
    if ( (a+b) < МАКСГАММА && фабс(u) < МАКСЛОГ ) {
        t = гамма(a+b)/(гамма(a)*гамма(b));
        s = s * t * степень(x,a);
    } else {
        t = логГаммы(a+b) - логГаммы(a) - логГаммы(b) + u + лог(s);

        if( t < МИНЛОГ ) {
            s = 0.0L;
        } else
            s = эксп(t);
    }
    return s;
}

}

/***************************************
 *  Incomplete гамма integral и its complement
 *
 * These functions are defined by
 *
 *   гаммаНеполная = ( $(INTEGRATE 0, x) $(POWER e, -t) $(POWER t, a-1) dt )/ $(GAMMA)(a)
 *
 *  gammaIncompleteCompl(a,x)   =   1 - гаммаНеполная(a,x)
 * = ($(INTEGRATE x, &infin;) $(POWER e, -t) $(POWER t, a-1) dt )/ $(GAMMA)(a)
 *
 * In this implementation Всё аргументы must be positive.
 * The integral is evaluated by either a power series or
 * continued дво expansion, depending on the relative
 * значения of a и x.
 */
реал гаммаНеполная(реал a, реал x )
in {
   assert(x >= 0);
   assert(a > 0);
}
body {
    /* left хвост of incomplete гамма function:
     *
     *          inf.      k
     *   a  -x   -       x
     *  x  e     >   ----------
     *           -     -
     *          k=0   | (a+k+1)
     *
     */
    if (x==0)
       return 0.0L;

    if ( (x > 1.0L) && (x > a ) )
        return 1.0L - gammaIncompleteCompl(a,x);

    реал ax = a * лог(x) - x - логГаммы(a);
/+
    if( ax < MINLOGL ) return 0; // недобор
    //  { mtherr( "igaml", UNDERFLOW ); return( 0.0L ); }
+/
    ax = эксп(ax);

    /* power series */
    реал r = a;
    реал c = 1.0L;
    реал ans = 1.0L;

    do  {
        r += 1.0L;
        c *= x/r;
        ans += c;
    } while( c/ans > реал.epsilon );

    return ans * ax/a;
}

/** ditto */
реал gammaIncompleteCompl(реал a, реал x )
in {
   assert(x >= 0);
   assert(a > 0);
}
body {
    if (x==0)
       return 1.0L;
    if ( (x < 1.0L) || (x < a) )
        return 1.0L - гаммаНеполная(a,x);

   // DAC (Cephes bug fix): This is necessary в_ avoопр
   // spurious nans, eg
   // лог(x)-x = НЧ when x = реал.infinity
    const реал MAXLOGL =  1.1356523406294143949492E4L;
   if (x > MAXLOGL) return 0; // недобор

    реал ax = a * лог(x) - x - логГаммы(a);
//const реал MINLOGL = -1.1355137111933024058873E4L;
//  if ( ax < MINLOGL ) return 0; // недобор;
    ax = эксп(ax);


    /* continued дво */
    реал y = 1.0L - a;
    реал z = x + y + 1.0L;
    реал c = 0.0L;

    реал pk, qk, t;

    реал pkm2 = 1.0L;
    реал qkm2 = x;
    реал pkm1 = x + 1.0L;
    реал qkm1 = z * x;
    реал ans = pkm1/qkm1;

    do  {
        c += 1.0L;
        y += 1.0L;
        z += 2.0L;
        реал yc = y * c;
        pk = pkm1 * z  -  pkm2 * yc;
        qk = qkm1 * z  -  qkm2 * yc;
        if( qk != 0.0L ) {
            реал r = pk/qk;
            t = фабс( (ans - r)/r );
            ans = r;
        } else {
            t = 1.0L;
        }
    pkm2 = pkm1;
        pkm1 = pk;
        qkm2 = qkm1;
        qkm1 = qk;

        const реал BIG = 9.223372036854775808e18L;

        if ( фабс(pk) > BIG ) {
            pkm2 /= BIG;
            pkm1 /= BIG;
            qkm2 /= BIG;
            qkm1 /= BIG;
        }
    } while ( t > реал.epsilon );

    return ans * ax;
}

/** Inverse of complemented incomplete гамма integral
 *
 * Given a и y, the function finds x such that
 *
 *  gammaIncompleteCompl( a, x ) = p.
 *
 * Starting with the approximate значение x = a $(POWER t, 3), where
 * t = 1 - d - normalDistributionInv(p) квкор(d),
 * и d = 1/9a,
 * the routine performs up в_ 10 Newton iterations в_ найди the
 * корень of incompleteGammaCompl(a,x) - p = 0.
 */
реал gammaIncompleteComplInv(реал a, реал p)
in {
  assert(p>=0 && p<= 1);
  assert(a>0);
}
body {
    if (p==0) return реал.infinity;

    реал y0 = p;
    const реал MAXLOGL =  1.1356523406294143949492E4L;
    реал x0, x1, x, yl, yh, y, d, lgm, dithresh;
    цел i, Пап;

    /* bound the solution */
    x0 = реал.max;
    yl = 0.0L;
    x1 = 0.0L;
    yh = 1.0L;
    dithresh = 4.0 * реал.epsilon;

    /* approximation в_ inverse function */
    d = 1.0L/(9.0L*a);
    y = 1.0L - d - normalDistributionInvImpl(y0) * квкор(d);
    x = a * y * y * y;

    lgm = логГаммы(a);

    for( i=0; i<10; i++ ) {
        if( x > x0 || x < x1 )
            goto ihalve;
        y = gammaIncompleteCompl(a,x);
        if ( y < yl || y > yh )
            goto ihalve;
        if ( y < y0 ) {
            x0 = x;
            yl = y;
        } else {
            x1 = x;
            yh = y;
        }
    /* compute the derivative of the function at this точка */
        d = (a - 1.0L) * лог(x0) - x0 - lgm;
        if ( d < -MAXLOGL )
            goto ihalve;
        d = -эксп(d);
    /* compute the step в_ the следщ approximation of x */
        d = (y - y0)/d;
        x = x - d;
        if ( i < 3 ) continue;
        if ( фабс(d/x) < dithresh ) return x;
    }

    /* Resort в_ интервал halving if Newton iteration dопр not converge. */
ihalve:
    d = 0.0625L;
    if ( x0 == реал.max ) {
        if( x <= 0.0L )
            x = 1.0L;
        while( x0 == реал.max ) {
            x = (1.0L + d) * x;
            y = gammaIncompleteCompl( a, x );
            if ( y < y0 ) {
                x0 = x;
                yl = y;
                break;
            }
            d = d + d;
        }
    }
    d = 0.5L;
    Пап = 0;

    for( i=0; i<400; i++ ) {
        x = x1  +  d * (x0 - x1);
        y = gammaIncompleteCompl( a, x );
        lgm = (x0 - x1)/(x1 + x0);
        if ( фабс(lgm) < dithresh )
            break;
        lgm = (y - y0)/y0;
        if ( фабс(lgm) < dithresh )
            break;
        if ( x <= 0.0L )
            break;
        if ( y > y0 ) {
            x1 = x;
            yh = y;
            if ( Пап < 0 ) {
                Пап = 0;
                d = 0.5L;
            } else if ( Пап > 1 )
                d = 0.5L * d + 0.5L;
            else
                d = (y0 - yl)/(yh - yl);
            Пап += 1;
        } else {
            x0 = x;
            yl = y;
            if ( Пап > 0 ) {
                Пап = 0;
                d = 0.5L;
            } else if ( Пап < -1 )
                d = 0.5L * d;
            else
                d = (y0 - yl)/(yh - yl);
            Пап -= 1;
        }
    }
    /+
    if( x == 0.0L )
        mtherr( "igamil", UNDERFLOW );
    +/
    return x;
}

debug(UnitTest) {
unittest {
//Values из_ Excel's GammaInv(1-p, x, 1)
assert(фабс(gammaIncompleteComplInv(1, 0.5) - 0.693147188044814) < 0.00000005);
assert(фабс(gammaIncompleteComplInv(12, 0.99) - 5.42818075054289) < 0.00000005);
assert(фабс(gammaIncompleteComplInv(100, 0.8) - 91.5013985848288L) < 0.000005);

assert(гаммаНеполная(1, 0)==0);
assert(gammaIncompleteCompl(1, 0)==1);
assert(гаммаНеполная(4545, реал.infinity)==1);

// Values из_ Excel's (1-GammaDist(x, альфа, 1, TRUE))

assert(фабс(1.0L-gammaIncompleteCompl(0.5, 2) - 0.954499729507309L) < 0.00000005);
assert(фабс(гаммаНеполная(0.5, 2) - 0.954499729507309L) < 0.00000005);
// Fixed Cephes bug:
assert(gammaIncompleteCompl(384, реал.infinity)==0);
assert(gammaIncompleteComplInv(3, 0)==реал.infinity);
}
}

/** Digamma function
*
*   дигамма function is the logarithmic derivative of the гамма function.
*
*  дигамма(x) = d/dx логГаммы(x)
*
*/
реал дигамма(реал x)
{
   // Based on CEPHES, Stephen L. Moshier.
 
    // DAC: These значения are Bn / n for n=2,4,6,8,10,12,14.
    const реал [] Bn_n  = [
        1.0L/(6*2), -1.0L/(30*4), 1.0L/(42*6), -1.0L/(30*8),
        5.0L/(66*10), -691.0L/(2730*12), 7.0L/(6*14) ];

    реал p, q, nz, s, w, y, z;
    цел i, n, негатив;

    негатив = 0;
    nz = 0.0;

    if ( x <= 0.0 ) {
        негатив = 1;
        q = x;
        p = пол(q);
        if( p == q ) {
            return НЧ(ДИНРУС_НЧ.ГАММА_ПОЛЮС); // singularity.
        }
    /* Удали the zeros of тан(ПИ x)
     * by subtracting the nearest целое из_ x
     */
        nz = q - p;
        if ( nz != 0.5 ) {
            if ( nz > 0.5 ) {
                p += 1.0;
                nz = q - p;
            }
            nz = ПИ/тан(ПИ*nz);
        } else {
            nz = 0.0;
        }
        x = 1.0 - x;
    }

    // проверь for small positive целое
    if ((x <= 13.0) && (x == пол(x)) ) {
        y = 0.0;
        n = окрвцел(x);
        // DAC: CEPHES bugfix. Cephes dопр this in реверс order, which
        // создан a larger roundoff ошибка.
        for (i=n-1; i>0; --i) {
            y+=1.0L/i;
        }
        y -= ОЙЛЕРГАММА;
        goto готово;
    }

    s = x;
    w = 0.0;
    while ( s < 10.0 ) {
        w += 1.0/s;
        s += 1.0;
    }

    if ( s < 1.0e17 ) {
        z = 1.0/(s * s);
        y = z * поли(z, Bn_n);
    } else
        y = 0.0;

    y = лог(s)  -  0.5L/s  -  y  -  w;

готово:
    if ( негатив ) {
        y -= nz;
    }
    return y;
}
/+
import cidrus;
debug(UnitTest) {
unittest {
    // Exact значения
    assert(дигамма(1)== -ОЙЛЕРГАММА);
    assert(отнравх(дигамма(0.25), -ПИ/2 - 3* ЛН2 - ОЙЛЕРГАММА)>=реал.mant_dig-7);
    assert(отнравх(дигамма(1.0L/6), -ПИ/2 *квкор(3.0L) - 2* ЛН2 -1.5*лог(3.0L) - ОЙЛЕРГАММА)>=реал.mant_dig-7);
    assert(дигамма(-5)!<>0);    
    assert(отнравх(дигамма(2.5), -ОЙЛЕРГАММА - 2*ЛН2 + 2.0 + 2.0L/3)>=реал.mant_dig-9);
    assert(идентичен_ли(дигамма(НЧ(0xABC)), НЧ(0xABC)));
    
    for (цел k=1; k<40; ++k) {
        реал y=0;
        for (цел u=k; u>=1; --u) {
            y+= 1.0L/u;
        }
        assert(отнравх(дигамма(k+1),-ОЙЛЕРГАММА + y) >=реал.mant_dig-2);
    }
   
//    printf("%d %La %La %d %d\n", k+1, дигамма(k+1), -ОЙЛЕРГАММА + x, отнравх(дигамма(k+1),-ОЙЛЕРГАММА + y), отнравх(дигамма(k+1), -ОЙЛЕРГАММА + x));
}
}

+/