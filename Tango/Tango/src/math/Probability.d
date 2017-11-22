/**
 * Cumulative Probability Distribution Functions
 *
 * Copyright: Based on the CEPHES math library, which is
 *            Copyright (C) 1994 Stephen L. Moshier (moshier@world.std.com).
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Stephen L. Moshier (original C код), Don Clugston
 */

/**
 * Macros:
 *  NAN = $(RED NAN)
 *  SUP = <вринтервал стиль="vertical-align:super;font-размер:smaller">$0</вринтервал>
 *  GAMMA =  &#915;
 *  INTEGRAL = &#8747;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  BIGSUM = $(BIG &Sigma; <sup>$2</sup><подст>$(SMALL $1)</подст>)
 *  CHOOSE = $(BIG &#40;) <sup>$(SMALL $1)</sup><подст>$(SMALL $2)</подст> $(BIG &#41;)
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 */

module math.Probability;
static import math.ErrorFunction;
private import math.GammaFunction;
private import math.Math;
private import math.IEEE;


/***
Cumulative ни в каком дистрибутиве function for the Нормальный ни в каком дистрибутиве, и its complement.

The нормаль (or Gaussian, or bell-shaped) ни в каком дистрибутиве is
defined as:

normalDist(x) = 1/$(SQRT) &pi; $(INTEGRAL -$(INFINITY), x) эксп( - $(POWER t, 2)/2) dt
    = 0.5 + 0.5 * матош(x/квкор(2))
    = 0.5 * матошфунк(- x/квкор(2))

Note that
normalDistribution(x) = 1 - normalDistribution(-x).

Accuracy:
Within a few биты of machine resolution over the entire
range.

References:
$(LINK http://www.netlib.org/cephes/ldoubdoc.html),
G. Marsaglia, "Evaluating the Нормальный Distribution",
Journal of Statistical Software <b>11</b>, (July 2004).
*/
реал normalDistribution(реал a)
{
    return math.ErrorFunction.normalDistributionImpl(a);
}

/** ditto */
реал normalDistributionCompl(реал a)
{
    return -math.ErrorFunction.normalDistributionImpl(-a);
}

/******************************
 * Inverse of Нормальный ни в каком дистрибутиве function
 *
 * Returns the аргумент, x, for which the area under the
 * Нормальный probability density function (integrated из_
 * minus infinity в_ x) is equal в_ p.
 *
 * For small аргументы 0 < p < эксп(-2), the program computes
 * z = квкор( -2 лог(p) );  then the approximation is
 * x = z - лог(z)/z  - (1/z) P(1/z) / Q(1/z) .
 * For larger аргументы,  x/квкор(2 pi) = w + w^3 R(w^2)/S(w^2)) ,
 * where w = p - 0.5 .
 */
реал normalDistributionInv(реал p)
{
    return math.ErrorFunction.normalDistributionInvImpl(p);
}

/** ditto */
реал normalDistributionComplInv(реал p)
{
    return -math.ErrorFunction.normalDistributionInvImpl(-p);
}

debug(UnitTest) {
unittest {
    assert(отнравх(normalDistributionInv(normalDistribution(0.1)),0.1L)>=реал.mant_dig-4);
    assert(отнравх(normalDistributionComplInv(normalDistributionCompl(0.1)),0.1L)>=реал.mant_dig-4);
}
}

/** Student's t cumulative ни в каком дистрибутиве function
 *
 * Computes the integral из_ minus infinity в_ t of the Student
 * t ни в каком дистрибутиве with целое nu > 0 degrees of freedom:
 *
 *   $(GAMMA)( (nu+1)/2) / ( квкор(nu &pi;) $(GAMMA)(nu/2) ) *
 * $(INTEGRATE -&infin;, t) $(POWER (1+$(POWER x, 2)/nu), -(nu+1)/2) dx
 *
 * Can be использован в_ тест whether the means of two normally distributed populations
 * are equal.
 *
 * It is related в_ the incomplete бета integral:
 *        1 - studentsDistribution(nu,t) = 0.5 * betaDistribution( nu/2, 1/2, z )
 * where
 *        z = nu/(nu + t<sup>2</sup>).
 *
 * For t < -1.6, this is the метод of computation.  For higher t,
 * a direct метод is производный из_ integration by части.
 * Since the function is symmetric about t=0, the area under the
 * right хвост of the density is найдено by calling the function
 * with -t instead of t.
 */
реал studentsTDistribution(цел nu, реал t)
in{
   assert(nu>0);
}
body{
  /* Based on код из_ Cephes Math Library Release 2.3:  January, 1995
     Copyright 1984, 1995 by Stephen L. Moshier
 */

    if ( nu <= 0 ) return НЧ(ДИНРУС_НЧ.STUDENTSDDISTRIBUTION_DOMAIN); // домен ошибка -- or should it return 0?
    if ( t == 0.0 )  return 0.5;

    реал rk, z, p;

    if ( t < -1.6 ) {
        rk = nu;
        z = rk / (rk + t * t);
        return 0.5L * бетаНеполная( 0.5L*rk, 0.5L, z );
    }

    /*  compute integral из_ -t в_ + t */

    rk = nu;    /* degrees of freedom */

    реал x;
    if (t < 0) x = -t; else x = t;
    z = 1.0L + ( x * x )/rk;

    реал f, tz;
    цел j;

    if ( nu & 1)    {
        /*  computation for odd nu  */
        реал xsqk = x/квкор(rk);
        p = атан( xsqk );
        if ( nu > 1 )   {
            f = 1.0L;
            tz = 1.0L;
            j = 3;
            while(  (j<=(nu-2)) && ( (tz/f) > реал.epsilon )  ) {
                tz *= (j-1)/( z * j );
                f += tz;
                j += 2;
            }
            p += f * xsqk/z;
            }
        p *= 2.0L/ПИ;
    } else {
        /*  computation for even nu */
        f = 1.0L;
        tz = 1.0L;
        j = 2;

        while ( ( j <= (nu-2) ) && ( (tz/f) > реал.epsilon )  ) {
            tz *= (j - 1)/( z * j );
            f += tz;
            j += 2;
        }
        p = f * x/квкор(z*rk);
    }
    if ( t < 0.0L )
        p = -p; /* note destruction of relative accuracy */

    p = 0.5L + 0.5L * p;
    return p;
}

/** Inverse of Student's t ни в каком дистрибутиве
 *
 * Given probability p и degrees of freedom nu,
 * finds the аргумент t such that the one-sопрed
 * studentsDistribution(nu,t) is equal в_ p.
 *
 * Параметры:
 * nu = degrees of freedom. Must be >1
 * p  = probability. 0 < p < 1
 */
реал studentsTDistributionInv(цел nu, реал p )
in {
   assert(nu>0);
   assert(p>=0.0L && p<=1.0L);
}
body
{
    if (p==0) return -реал.infinity;
    if (p==1) return реал.infinity;

    реал rk, z;
    rk =  nu;

    if ( p > 0.25L && p < 0.75L ) {
        if ( p == 0.5L ) return 0;
        z = 1.0L - 2.0L * p;
        z = бетаНеполнаяИнв( 0.5L, 0.5L*rk, фабс(z) );
        реал t = квкор( rk*z/(1.0L-z) );
        if( p < 0.5L )
            t = -t;
        return t;
    }
    цел rflg = -1; // знак of the результат
    if (p >= 0.5L) {
        p = 1.0L - p;
        rflg = 1;
    }
    z = бетаНеполнаяИнв( 0.5L*rk, 0.5L, 2.0L*p );

    if (z<0) return rflg * реал.infinity;
    return rflg * квкор( rk/z - rk );
}

debug(UnitTest) {
unittest {

// There are simple forms for nu = 1 и nu = 2.

// if (nu == 1), tDistribution(x) = 0.5 + атан(x)/ПИ
//              so tDistributionInv(p) = тан( ПИ * (p-0.5) );
// nu==2: tDistribution(x) = 0.5 * (1 + x/ квкор(2+x*x) )

assert(studentsTDistribution(1, -0.4)== 0.5 + атан(-0.4)/ПИ);
assert(studentsTDistribution(2, 0.9) == 0.5L * (1 + 0.9L/квкор(2.0L + 0.9*0.9)) );
assert(studentsTDistribution(2, -5.4) == 0.5L * (1 - 5.4L/квкор(2.0L + 5.4*5.4)) );

// return да if a==b в_ given число of places.
бул isfeqabs(реал a, реал b, реал diff)
{
  return фабс(a-b) < diff;
}

// Check a few spot значения with statsoft.com (Mathworld значения are wrong!!)
// According в_ statsoft.com, studentsDistributionInv(10, 0.995)= 3.16927.

// The остаток значения listed here are из_ Excel, и are unlikely в_ be accurate
// in the последний decimal places. However, they are helpful as a sanity проверь.

//  Microsoft Excel 2003 gives TINV(2*(1-0.995), 10) == 3.16927267160917
assert(isfeqabs(studentsTDistributionInv(10, 0.995), 3.169_272_67L, 0.000_000_005L));


assert(isfeqabs(studentsTDistributionInv(8, 0.6), 0.261_921_096_769_043L,0.000_000_000_05L));
// -TINV(2*0.4, 18) ==  -0.257123042655869

assert(isfeqabs(studentsTDistributionInv(18, 0.4), -0.257_123_042_655_869L, 0.000_000_000_05L));
assert( отнравх(studentsTDistribution(18, studentsTDistributionInv(18, 0.4L)),0.4L)
 > реал.mant_dig-5 );
assert( отнравх(studentsTDistribution(11, studentsTDistributionInv(11, 0.9L)),0.9L)
  > реал.mant_dig-2);
}
}

/** The F ни в каком дистрибутиве, its complement, и inverse.
 *
 * The F density function (also known as Snedcor's density or the
 * variance ratio density) is the density
 * of x = (u1/df1)/(u2/df2), where u1 и u2 are random
 * variables having $(POWER &chi;,2) distributions with df1
 * и df2 degrees of freedom, respectively.
 *
 * fDistribution returns the area из_ zero в_ x under the F density
 * function.   The complementary function,
 * fDistributionCompl, returns the area из_ x в_ &infin; under the F density function.
 *
 * The inverse of the complemented F ни в каком дистрибутиве,
 * fDistributionComplInv, finds the аргумент x such that the integral
 * из_ x в_ infinity of the F density is equal в_ the given probability y.
 *
 * Can be использован в_ тест whether the means of multИПle normally distributed
 * populations, все with the same стандарт deviation, are equal;
 * or в_ тест that the стандарт deviations of two normally distributed
 * populations are equal.
 *
 * Параметры:
 *  df1 = Degrees of freedom of the первый переменная. Must be >= 1
 *  df2 = Degrees of freedom of the секунда переменная. Must be >= 1
 *  x  = Must be >= 0
 */
реал fDistribution(цел df1, цел df2, реал x)
in {
 assert(df1>=1 && df2>=1);
 assert(x>=0);
}
body{
    реал a = cast(реал)(df1);
    реал b = cast(реал)(df2);
    реал w = a * x;
    w = w/(b + w);
    return бетаНеполная(0.5L*a, 0.5L*b, w);
}

/** ditto */
реал fDistributionCompl(цел df1, цел df2, реал x)
in {
 assert(df1>=1 && df2>=1);
 assert(x>=0);
}
body{
    реал a = cast(реал)(df1);
    реал b = cast(реал)(df2);
    реал w = b / (b + a * x);
    return бетаНеполная( 0.5L*b, 0.5L*a, w );
}

/*
 * Inverse of complemented F ни в каком дистрибутиве
 *
 * Finds the F density аргумент x such that the integral
 * из_ x в_ infinity of the F density is equal в_ the
 * given probability p.
 *
 * This is accomplished using the inverse бета integral
 * function и the relations
 *
 *      z = бетаНеполнаяИнв( df2/2, df1/2, p ),
 *      x = df2 (1-z) / (df1 z).
 *
 * Note that the following relations hold for the inverse of
 * the uncomplemented F ни в каком дистрибутиве:
 *
 *      z = бетаНеполнаяИнв( df1/2, df2/2, p ),
 *      x = df2 z / (df1 (1-z)).
*/

/** ditto */
реал fDistributionComplInv(цел df1, цел df2, реал p )
in {
 assert(df1>=1 && df2>=1);
 assert(p>=0 && p<=1.0);
}
body{
    реал a = df1;
    реал b = df2;
    /* Compute probability for x = 0.5.  */
    реал w = бетаНеполная( 0.5L*b, 0.5L*a, 0.5L );
    /* If that is greater than p, then the solution w < .5.
       Otherwise, solve at 1-p в_ удали cancellation in (b - b*w).  */
    if ( w > p || p < 0.001L) {
        w = бетаНеполнаяИнв( 0.5L*b, 0.5L*a, p );
        return (b - b*w)/(a*w);
    } else {
        w = бетаНеполнаяИнв( 0.5L*a, 0.5L*b, 1.0L - p );
        return b*w/(a*(1.0L-w));
    }
}

debug(UnitTest) {
unittest {
// fDistCompl(df1, df2, x) = Excel's FDIST(x, df1, df2)
  assert(фабс(fDistributionCompl(6, 4, 16.5) - 0.00858719177897249L)< 0.0000000000005L);
  assert(фабс((1-fDistribution(12, 23, 0.1)) - 0.99990562845505L)< 0.0000000000005L);
  assert(фабс(fDistributionComplInv(8, 34, 0.2) - 1.48267037661408L)< 0.0000000005L);
  assert(фабс(fDistributionComplInv(4, 16, 0.008) - 5.043_537_593_48596L)< 0.0000000005L);
  // Regression тест: This one использован в_ краш because of a bug in the definition of МИНЛОГ.
  assert(отнравх(fDistributionCompl(4, 16, fDistributionComplInv(4,16, 0.008)), 0.008L)>=реал.mant_dig-3);
}
}

/** $(POWER &chi;,2) cumulative ни в каком дистрибутиве function и its complement.
 *
 * Returns the area under the left hand хвост (из_ 0 в_ x)
 * of the Chi square probability density function with
 * v degrees of freedom. The complement returns the area under
 * the right hand хвост (из_ x в_ &infin;).
 *
 *  chiSqrDistribution(x | v) = ($(INTEGRATE 0, x)
 *          $(POWER t, v/2-1) $(POWER e, -t/2) dt )
 *             / $(POWER 2, v/2) $(GAMMA)(v/2)
 *
 *  chiSqrDistributionCompl(x | v) = ($(INTEGRATE x, &infin;)
 *          $(POWER t, v/2-1) $(POWER e, -t/2) dt )
 *             / $(POWER 2, v/2) $(GAMMA)(v/2)
 *
 * Параметры:
 *  v  = degrees of freedom. Must be positive.
 *  x  = the $(POWER &chi;,2) переменная. Must be positive.
 *
 */
реал chiSqrDistribution(реал v, реал x)
in {
 assert(x>=0);
 assert(v>=1.0);
}
body{
   return гаммаНеполная( 0.5*v, 0.5*x);
}

/** ditto */
реал chiSqrDistributionCompl(реал v, реал x)
in {
 assert(x>=0);
 assert(v>=1.0);
}
body{
    return gammaIncompleteCompl( 0.5L*v, 0.5L*x );
}

/**
 *  Inverse of complemented $(POWER &chi;, 2) ни в каком дистрибутиве
 *
 * Finds the $(POWER &chi;, 2) аргумент x such that the integral
 * из_ x в_ &infin; of the $(POWER &chi;, 2) density is equal
 * в_ the given cumulative probability p.
 *
 * Параметры:
 * p = Cumulative probability. 0<= p <=1.
 * v = Degrees of freedom. Must be positive.
 *
 */
реал chiSqrDistributionComplInv(реал v, реал p)
in {
  assert(p>=0 && p<=1.0L);
  assert(v>=1.0L);
}
body
{
   return  2.0 * gammaIncompleteComplInv( 0.5*v, p);
}

debug(UnitTest) {
unittest {
  assert(отнравх(chiSqrDistributionCompl(3.5L, chiSqrDistributionComplInv(3.5L, 0.1L)), 0.1L)>=реал.mant_dig-5);
  assert(chiSqrDistribution(19.02L, 0.4L) + chiSqrDistributionCompl(19.02L, 0.4L) ==1.0L);
}
}

/**
 * The &Gamma; ни в каком дистрибутиве и its complement
 *
 * The &Gamma; ни в каком дистрибутиве is defined as the integral из_ 0 в_ x of the
 * гамма probability density function. The complementary function returns the
 * integral из_ x в_ &infin;
 *
 * gammaDistribution = ($(INTEGRATE 0, x) $(POWER t, b-1)$(POWER e, -at) dt) $(POWER a, b)/&Gamma;(b)
 *
 * x must be greater than 0.
 */
реал gammaDistribution(реал a, реал b, реал x)
in {
   assert(x>=0);
}
body {
   return гаммаНеполная(b, a*x);
}

/** ditto */
реал gammaDistributionCompl(реал a, реал b, реал x )
in {
   assert(x>=0);
}
body {
   return gammaIncompleteCompl( b, a * x );
}

debug(UnitTest) {
unittest {
    assert(gammaDistribution(7,3,0.18)+gammaDistributionCompl(7,3,0.18)==1);
}
}

/**********************
 *  Beta ни в каком дистрибутиве и its inverse
 *
 * Returns the incomplete бета integral of the аргументы, evaluated
 * из_ zero в_ x.  The function is defined as
 *
 * betaDistribution = &Gamma;(a+b)/(&Gamma;(a) &Gamma;(b)) *
 * $(INTEGRATE 0, x) $(POWER t, a-1)$(POWER (1-t),b-1) dt
 *
 * The домен of definition is 0 <= x <= 1.  In this
 * implementation a и b are restricted в_ positive значения.
 * The integral из_ x в_ 1 may be obtained by the symmetry
 * relation
 *
 *    betaDistributionCompl(a, b, x )  =  betaDistribution( b, a, 1-x )
 *
 * The integral is evaluated by a continued дво expansion
 * or, when b*x is small, by a power series.
 *
 * The inverse finds the значение of x for which betaDistribution(a,b,x) - y = 0
 */
реал betaDistribution(реал a, реал b, реал x )
{
   return бетаНеполная(a, b, x );
}

/** ditto */
реал betaDistributionCompl(реал a, реал b, реал x)
{
    return бетаНеполная(b, a, 1-x);
}

/** ditto */
реал betaDistributionInv(реал a, реал b, реал y)
{
    return бетаНеполнаяИнв(a, b, y);
}

/** ditto */
реал betaDistributionComplInv(реал a, реал b, реал y)
{
    return 1-бетаНеполнаяИнв(b, a, y);
}

debug(UnitTest) {
unittest {
    assert(отнравх(betaDistributionInv(2, 6, betaDistribution(2,6, 0.7L)),0.7L)>=реал.mant_dig-3);
    assert(отнравх(betaDistributionComplInv(1.3, 8, betaDistributionCompl(1.3,8, 0.01L)),0.01L)>=реал.mant_dig-4);
}
}

/**
 * The Poisson ни в каком дистрибутиве, its complement, и inverse
 *
 * k is the число of события. m is the mean.
 * The Poisson ни в каком дистрибутиве is defined as the sum of the первый k terms of
 * the Poisson density function.
 * The complement returns the sum of the terms k+1 в_ &infin;.
 *
 * poissonDistribution = $(BIGSUM j=0, k) $(POWER e, -m) $(POWER m, j)/j!
 *
 * poissonDistributionCompl = $(BIGSUM j=k+1, &infin;) $(POWER e, -m) $(POWER m, j)/j!
 *
 * The terms are not summed directly; instead the incomplete
 * гамма integral is employed, according в_ the relation
 *
 * y = poissonDistribution( k, m ) = gammaIncompleteCompl( k+1, m ).
 *
 * The аргументы must Всё be positive.
 */
реал poissonDistribution(цел k, реал m )
in {
  assert(k>=0);
  assert(m>0);
}
body {
    return gammaIncompleteCompl( k+1.0, m );
}

/** ditto */
реал poissonDistributionCompl(цел k, реал m )
in {
  assert(k>=0);
  assert(m>0);
}
body {
  return гаммаНеполная( k+1.0, m );
}

/** ditto */
реал poissonDistributionInv( цел k, реал p )
in {
  assert(k>=0);
  assert(p>=0.0 && p<=1.0);
}
body {
    return gammaIncompleteComplInv(k+1, p);
}

debug(UnitTest) {
unittest {
// = Excel's POISSON(k, m, TRUE)
    assert( фабс(poissonDistribution(5, 6.3)
                - 0.398771730072867L) < 0.000000000000005L);
    assert( отнравх(poissonDistributionInv(8, poissonDistribution(8, 2.7e3L)), 2.7e3L)>=реал.mant_dig-2);
    assert( poissonDistribution(2, 8.4e-5) + poissonDistributionCompl(2, 8.4e-5) == 1.0L);
}
}

/***********************************
 *  Binomial ни в каком дистрибутиве и complemented binomial ни в каком дистрибутиве
 *
 * The binomial ни в каком дистрибутиве is defined as the sum of the terms 0 through k
 * of the Binomial probability density.
 * The complement returns the sum of the terms k+1 through n.
 *
 binomialDistribution = $(BIGSUM j=0, k) $(CHOOSE n, j) $(POWER p, j) $(POWER (1-p), n-j)

 binomialDistributionCompl = $(BIGSUM j=k+1, n) $(CHOOSE n, j) $(POWER p, j) $(POWER (1-p), n-j)
 *
 * The terms are not summed directly; instead the incomplete
 * бета integral is employed, according в_ the formula
 *
 * y = binomialDistribution( k, n, p ) = betaDistribution( n-k, k+1, 1-p ).
 *
 * The аргументы must be positive, with p ranging из_ 0 в_ 1, и k<=n.
 */
реал binomialDistribution(цел k, цел n, реал p )
in {
   assert(p>=0 && p<=1.0); // домен ошибка
   assert(k>=0 && k<=n);
}
body{
    реал dk, dn, q;
    if( k == n )
        return 1.0L;

    q = 1.0L - p;
    dn = n - k;
    if ( k == 0 ) {
        return степень( q, dn );
    } else {
        return бетаНеполная( dn, k + 1, q );
    }
}

debug(UnitTest) {
unittest {
    // = Excel's BINOMDIST(k, n, p, TRUE)
    assert( фабс(binomialDistribution(8, 12, 0.5)
                - 0.927001953125L) < 0.0000000000005L);
    assert( фабс(binomialDistribution(0, 3, 0.008L)
                - 0.976191488L) < 0.00000000005L);
    assert(binomialDistribution(7,7, 0.3)==1.0);
}
}

 /** ditto */
реал binomialDistributionCompl(цел k, цел n, реал p )
in {
   assert(p>=0 && p<=1.0); // домен ошибка
   assert(k>=0 && k<=n);
}
body{
    if ( k == n ) {
        return 0;
    }
    реал dn = n - k;
    if ( k == 0 ) {
        if ( p < .01L )
            return -экспм1( dn * лог1п(-p) );
        else
            return 1.0L - степень( 1.0L-p, dn );
    } else {
        return бетаНеполная( k+1, dn, p );
    }
}

debug(UnitTest){
unittest {
    // = Excel's (1 - BINOMDIST(k, n, p, TRUE))
    assert( фабс(1.0L-binomialDistributionCompl(0, 15, 0.003)
                - 0.955932824838906L) < 0.0000000000000005L);
    assert( фабс(1.0L-binomialDistributionCompl(0, 25, 0.2)
                - 0.00377789318629572L) < 0.000000000000000005L);
    assert( фабс(1.0L-binomialDistributionCompl(8, 12, 0.5)
                - 0.927001953125L) < 0.00000000000005L);
    assert(binomialDistributionCompl(7,7, 0.3)==0.0);
}
}

/** Inverse binomial ни в каком дистрибутиве
 *
 * Finds the событие probability p such that the sum of the
 * terms 0 through k of the Binomial probability density
 * is equal в_ the given cumulative probability y.
 *
 * This is accomplished using the inverse бета integral
 * function и the relation
 *
 * 1 - p = betaDistributionInv( n-k, k+1, y ).
 *
 * The аргументы must be positive, with 0 <= y <= 1, и k <= n.
 */
реал binomialDistributionInv( цел k, цел n, реал y )
in {
   assert(y>=0 && y<=1.0); // домен ошибка
   assert(k>=0 && k<=n);
}
body{
    реал dk, p;
    реал dn = n - k;
    if ( k == 0 ) {
        if( y > 0.8L )
            p = -экспм1( лог1п(y-1.0L) / dn );
        else
            p = 1.0L - степень( y, 1.0L/dn );
    } else {
        dk = k + 1;
        p = бетаНеполная( dn, dk, y );
        if( p > 0.5 )
            p = бетаНеполнаяИнв( dk, dn, 1.0L-y );
        else
            p = 1.0 - бетаНеполнаяИнв( dn, dk, y );
    }
    return p;
}

debug(UnitTest){
unittest {
    реал w = binomialDistribution(9, 15, 0.318L);
    assert(отнравх(binomialDistributionInv(9, 15, w), 0.318L)>=реал.mant_dig-3);
    w = binomialDistribution(5, 35, 0.718L);
    assert(отнравх(binomialDistributionInv(5, 35, w), 0.718L)>=реал.mant_dig-3);
    w = binomialDistribution(0, 24, 0.637L);
    assert(отнравх(binomialDistributionInv(0, 24, w), 0.637L)>=реал.mant_dig-3);
    w = binomialDistributionInv(0, 59, 0.962L);
    assert(отнравх(binomialDistribution(0, 59, w), 0.962L)>=реал.mant_dig-5);
}
}

/** Negative binomial ни в каком дистрибутиве и its inverse
 *
 * Returns the sum of the terms 0 through k of the негатив
 * binomial ни в каком дистрибутиве:
 *
 * $(BIGSUM j=0, k) $(CHOOSE n+j-1, j-1) $(POWER p, n) $(POWER (1-p), j)
 *
 * In a sequence of Bernoulli trials, this is the probability
 * that k or fewer failures precede the n-th success.
 *
 * The аргументы must be positive, with 0 < p < 1 и r>0.
 *
 * The inverse finds the аргумент y such
 * that negativeBinomialDistribution(k,n,y) is equal в_ p.
 *
 * The Geometric Distribution is a special case of the негатив binomial
 * ни в каком дистрибутиве.
 * -----------------------
 * geometricDistribution(k, p) = negativeBinomialDistribution(k, 1, p);
 * -----------------------
 * References:
 * $(LINK http://mathworld.wolfram.com/NegativeBinomialDistribution.html)
 */

реал negativeBinomialDistribution(цел k, цел n, реал p )
in {
   assert(p>=0 && p<=1.0); // домен ошибка
   assert(k>=0);
}
body{
    if ( k == 0 ) return степень( p, n );
    return бетаНеполная( n, k + 1, p );
}

/** ditto */
реал negativeBinomialDistributionInv(цел k, цел n, реал p )
in {
   assert(p>=0 && p<=1.0); // домен ошибка
   assert(k>=0);
}
body{
    return бетаНеполнаяИнв(n, k + 1, p);
}

debug(UnitTest) {
unittest {
  // Значение obtained by sum of terms of MS Excel 2003's NEGBINOMDIST.
  assert( фабс(negativeBinomialDistribution(10, 20, 0.2) - 3.830_52E-08)< 0.000_005e-08);
  assert(отнравх(negativeBinomialDistributionInv(14, 208, negativeBinomialDistribution(14, 208, 1e-4L)), 1e-4L)>=реал.mant_dig-3);
}
}
