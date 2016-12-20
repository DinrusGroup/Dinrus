/**
 * Элементарные Математические Функции
 */
module math.Math;

public import stdrus: абс, конъюнк, кос, син, тан, акос, асин, атан, атан2, гкос, гсин, гтан, гакос, гасин, гатан, округливдол, округливближдол, квкор, эксп, экспм1, эксп2, экспи, прэксп, илогб, лдэксп, лог, лог10, лог1п, лог2, логб, модф, скалбн, кубкор, гипот, фцош, лгамма, тгамма, потолок, пол, ближцел, окрвцел, окрвдол, округли, докругли, упрости, остаток, конечен_ли, нч, следщБольш, следщМеньш, следщза, пдельта, пбольш_из, пменьш_из, степень, правны, квадрат, дво, знак, цикл8градус,цикл8радиан, цикл8градиент, градус8цикл, градус8радиан, градус8градиент, радиан8градус, радиан8цикл, радиан8градиент, градиент8градус, градиент8цикл, градиент8радиан, сариф, сумма, меньш_из, больш_из, акот, асек, акосек, кот, сек, косек, гкот, гсек, гкосек, гакот, гасек, гакосек, ткст8реал;

private import math.IEEE;

private {
template минмакстип(T...){
    static if(T.length == 1) alias T[0] минмакстип;
    else static if(T.length > 2)
        alias минмакстип!(минмакстип!(T[0..2]), T[2..$]) минмакстип;
    else alias typeof (T[1] > T[0] ? T[1] : T[0]) минмакстип;
}
}

/** Возвращает минимальный из предложенных аргументов.
 *
 * Note: If the аргументы are floating-точка numbers, и at least one is a НЧ,
 * the результат is undefined.
 */
минмакстип!(T) мин(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] < арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return мин(арг[1] < арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/** Return the maximum of the supplied аргументы.
 *
 * Note: If the аргументы are floating-точка numbers, и at least one is a НЧ,
 * the результат is undefined.
 */
минмакстип!(T) макс(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] > арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return макс(арг[1] > арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/** Returns the minimum число of x и y, favouring numbers over NaNs.
 *
 * If Всё x и y are numbers, the minimum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the число is
 * returned (this behaviour is mandated by IEEE 754R, и is useful
 * for determining the range of a function).
 */
реал минЧло(реал x, реал y) {
    if (x<=y || нч_ли(y)) return x; else return y;
}

/** Returns the maximum число of x и y, favouring numbers over NaNs.
 *
 * If Всё x и y are numbers, the maximum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the число is
 * returned (this behaviour is mandated by IEEE 754-2008, и is useful
 * for determining the range of a function).
 */
реал максЧло(реал x, реал y) {
    if (x>=y || нч_ли(y)) return x; else return y;
}

/** Returns the minimum of x и y, favouring NaNs over numbers
 *
 * If Всё x и y are numbers, the minimum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the НЧ is returned.
 */
реал минНч(реал x, реал y) {
    return (x<=y || нч_ли(x))? x : y;
}

/** Returns the maximum of x и y, favouring NaNs over numbers
 *
 * If Всё x и y are numbers, the maximum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the НЧ is returned.
 */
реал максНч(реал x, реал y) {
    return (x>=y || нч_ли(x))? x : y;
}

/*****************************************
 * Sine, cosine, и arctangent of multИПle of &pi;
 *
 * Accuracy is preserved for large значения of x.
 */
реал косПи(реал x)
{
    return кос((x%2.0)*ПИ);
}

/** ditto */
реал синПи(реал x)
{
    return син((x%2.0)*ПИ);
}

/** ditto */
реал атанПи(реал x)
{
    return ПИ * атан(x); // BUG: Fix this.
}

/***********************************
 * Коммплексный инверсный синус
 *
 * асин(z) = -i лог( квкор(1-$(POWER z, 2)) + iz)
 * где и лог, и квкор комплексные.
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
 * Комплексный инверсный косинус
 *
 * акос(z) = $(ПИ)/2 - асин(z)
 */
креал акос(креал z)
{
    return ПИ_2 - асин(z);
}


/***********************************
 *  Гиперболический синус, комплексное и мнимое
 *
 *  гсин(z) = кос(z.im)*гсин(z.re) + син(z.im)*гкос(z.re)i
 */
креал гсин(креал z)
{
  креал cs = экспи(z.im);
  return cs.re * гсин(z.re) + cs.im * гкос(z.re) * 1i;
}

/** ditto */
вреал гсин(вреал y)
{
  return син(y.im)*1i;
}

/***********************************
 *  hyperbolic cosine, комплексное и мнимое
 *
 *  гкос(z) = кос(z.im)*гкос(z.re) + син(z.im)*гсин(z.re)i
 */
креал гкос(креал z)
{
  креал cs = экспи(z.im);
  return cs.re * гкос(z.re) + cs.im * гсин(z.re) * 1i;
}

/** ditto */
реал гкос(вреал y)
{
  return кос(y.im);
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
/+
креал квкор(креал z)
{

    if (z == 0.0) return z;
    реал x,y,w,r;
    креал c;

    x = math.IEEE.фабс(z.re);
    y = math.IEEE.фабс(z.im);
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
+/

/***********************************
 * Exponential, комплексное и мнимое
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
   return экспи(y.im);
}

/** ditto */
креал эксп(креал z)
{
  return экспи(z.im) * эксп(z.re);
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
 * The arctangent ranges из_ -ПИ в_ +ПИ.
 * There are branch cuts along Всё the негатив реал и негатив
 * мнимое axes. For pure мнимое аргументы, use one of the
 * following forms, depending on which branch is требуется.
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
цел худшотнравенство(креал a, креал b)
{
    цел intmin(цел a, цел b) { return a<b? a: b; }
    return intmin(отнравх(a.re, b.re), отнравх(a.im, b.im));
}
}
unittest {

  assert(лог(3.0L +0i) == лог(3.0L)+0i);
  assert(худшотнравенство(лог(0.0L-2i),( лог(2.0L)-ПИ_2*1i)) >= реал.mant_dig-10);
  assert(худшотнравенство(лог(0.0L+2i),( лог(2.0L)+ПИ_2*1i)) >= реал.mant_dig-10);
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
        add     EDX,ECX             ;
        add     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x[EBP]              ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2:  fmul    ST,ST(1)           ; // r *= x
        fld     real ptr -10[EDX]   ;
        sub     EDX,10              ; // deg--
        faddp   ST(1),ST            ;
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
        add     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x                   ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2: fmul    ST,ST(1)            ; // r *= x
        fld     real ptr -12[EDX]   ;
        sub     EDX,12              ; // deg--
        faddp   ST(1),ST            ;
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

package {
T рационалПоли(T)(T x, T [] numerator, T [] denominator)
{
    return поли(x, numerator)/поли(x, denominator);
}
}
/+
deprecated {
private enum : цел { MANTDIG_2 = реал.mant_dig/2 } // Compiler workaround

/** Floating точка "approximate equality".
 *
 * Return да if x is equal в_ y, в_ внутри the specified точность
 * If roundoffbits is not specified, a reasonable default is использован.
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
+/