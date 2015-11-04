/** Arbitrary-точность ('bignum') arithmetic
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Don Clugston
 */

module math.BigInt;

private import math.internal.BigбцелCore;

/** A struct representing an arbitrary точность целое
 *
 * все arithmetic operations are supported, except
 * unsigned shift right (>>>).
 * Реверсни operations are supported only for цел, дол,
 * and бдол, due в_ language limitations.
 * It реализует значение semantics using копируй-on-пиши. This means that
 * assignment is cheap, but operations such as x++ will cause куча
 * allocation. (But note that for most bigint operations, куча allocation is
 * inevitable anyway).
 *
 * Performance is excellent for numbers below ~1000 decimal digits.
 * For X86 machines, highly optimised assembly routines are used.
 */
struct BigInt
{
private:
	BigUint данные;     // BigInt добавьs signed arithmetic в_ BigUint.
	бул sign = нет;
public:
    /// Construct a BigInt из_ a decimal or hexadecimal ткст.
    /// The число must be in the form of a D decimal or hex literal:
    /// It may have a leading + or - sign; followed by "0x" if hexadecimal.
    /// Underscores are permitted.
    /// BUG: Should throw a ИсклНелегальногоАргумента/ConvError if не_годится character найдено
    static BigInt opCall(T : ткст)(T z) {
        сим [] s = z;
        BigInt r;
        бул neg = нет;
        if (s[0] == '-') {
            neg = да;
            s = s[1..$];
        } else if (s[0]=='+') {
            s = s[1..$];
        }
        auto q = 0X3;
        бул ok;
        if (s.length>2 && (s[0..2]=="0x" || s[0..2]=="0X")) {
            ok = r.данные.fromHexString(s[2..$]);
        } else {
            ok = r.данные.fromDecimalString(s);
        }
        assert(ok);
        if (r.isZero()) neg = нет;
        r.sign = neg;
        return r;
    }
    static BigInt opCall(T: цел)(T x) {
        BigInt r;
        r.данные = cast(бдол)((x < 0) ? -x : x);
        r.sign = (x < 0);
        return r;
    }
    ///
    проц opAssign(T:цел)(T x) {
        данные = cast(бдол)((x < 0) ? -x : x);
        sign = (x < 0);
    }
    ///
    BigInt opAdd(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSubInt(данные, u, sign!=(y<0), &r.sign);
        return r;
    }    
    ///
    BigInt opAddAssign(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        данные = BigUint.добавьOrSubInt(данные, u, sign!=(y<0), &sign);
        return *this;
    }    
    ///
    BigInt opAdd(T: BigInt)(T y) {
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSub(данные, y.данные, sign != y.sign, &r.sign);
        return r;
    }
    ///
    BigInt opAddAssign(T:BigInt)(T y) {
        данные = BigUint.добавьOrSub(данные, y.данные, sign != y.sign, &sign);
        return *this;
    }    
    ///
    BigInt opSub(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSubInt(данные, u, sign == (y<0), &r.sign);
        return r;
    }        
    ///
    BigInt opSubAssign(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        данные = BigUint.добавьOrSubInt(данные, u, sign == (y<0), &sign);
        return *this;
    }
    ///
    BigInt opSub(T: BigInt)(T y) {
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSub(данные, y.данные, sign == y.sign, &r.sign);
        return r;
    }        
    ///
    BigInt opSub_r(цел y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSubInt(данные, u, sign == (y<0), &r.sign);
        r.negate();
        return r;
    }
    ///
    BigInt opSub_r(дол y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSubInt(данные, u, sign == (y<0), &r.sign);
        r.negate();
        return r;
    }
    ///
    BigInt opSub_r(бдол y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        BigInt r;
        r.sign = sign;
        r.данные = BigUint.добавьOrSubInt(данные, u, sign == (y<0), &r.sign);
        r.negate();
        return r;
    }    
    ///
    BigInt opSubAssign(T:BigInt)(T y) {
        данные = BigUint.добавьOrSub(данные, y.данные, sign == y.sign, &sign);
        return *this;
    }    
    ///
    BigInt opMul(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        return mulInternal(*this, u, sign != (y<0));
    }
    ///    
    BigInt opMulAssign(T: цел)(T y) {
        бдол u = cast(бдол)(y < 0 ? -y : y);
        *this = mulInternal(*this, u, sign != (y<0));
        return *this;
    }
    ///    
    BigInt opMul(T:BigInt)(T y) {
        return mulInternal(*this, y);
    }
    ///
    BigInt opMulAssign(T: BigInt)(T y) {
        *this = mulInternal(*this, y);
        return *this;        
    }
    ///
    BigInt opDiv(T:цел)(T y) {
        assert(y!=0, "Деление на ноль");
        BigInt r;
        бцел u = y < 0 ? -y : y;
        r.данные = BigUint.divInt(данные, u);
        r.sign = r.isZero()? нет : sign != (y<0);
        return r;
    }
    ///
    BigInt opDivAssign(T: цел)(T y) {
        assert(y!=0, "Деление на ноль");
        бцел u = y < 0 ? -y : y;
        данные = BigUint.divInt(данные, u);
        sign = данные.isZero()? нет : sign ^ (y<0);
        return *this;
    }
    ///
    BigInt opDivAssign(T: BigInt)(T y) {
        *this = divInternal(*this, y);
        return *this;
    }    
    ///
    BigInt opDiv(T: BigInt)(T y) {
        return divInternal(*this, y);
    }    
    ///
    цел opMod(T:цел)(T y) {
        assert(y!=0);
        бцел u = y < 0 ? -y : y;
        цел rem = BigUint.modInt(данные, u);
        // x%y always есть the same sign as x.
        // This is not the same as mathematical mod.
        return sign? -rem : rem; 
    }
    ///
    BigInt opModAssign(T:цел)(T y) {
        assert(y!=0);
        бцел u = y < 0 ? -y : y;
        данные = BigUint.modInt(данные, u);
        // x%y always есть the same sign as x.
        // This is not the same as mathematical mod.
        return *this;
    }
    ///
    BigInt opMod(T: BigInt)(T y) {
        return modInternal(*this, y);
    }    
    ///
    BigInt opModAssign(T: BigInt)(T y) {
        *this = modInternal(*this, y);
        return *this;
    }    
    ///
    BigInt opNeg() {
        BigInt r = *this;
        r.negate();
        return r;
    }
    ///
    BigInt opPos() { return *this; }    
    ///
    BigInt opPostInc() {
        BigInt old = *this;
        данные = BigUint.добавьOrSubInt(данные, 1, нет, &sign);
        return old;
    }
    ///
    BigInt opPostDec() {
        BigInt old = *this;
        данные = BigUint.добавьOrSubInt(данные, 1, да, &sign);
        return old;
    }
    ///
    BigInt opShr(T:цел)(T y) {
        BigInt r;
        r.данные = данные.opShr(y);
        r.sign = r.данные.isZero()? нет : sign;
        return r;
    }
    ///
    BigInt opShrAssign(T:цел)(T y) {
        данные = данные.opShr(y);
        if (данные.isZero()) sign = нет;
        return *this;
    }
    ///
    BigInt opShl(T:цел)(T y) {
        BigInt r;
        r.данные = данные.opShl(y);
        r.sign = sign;
        return r;
    }
    ///
    BigInt opShlAssign(T:цел)(T y) {
        данные = данные.opShl(y);
        return *this;
    }
    ///
    цел opEquals(T: BigInt)(T y) {
       return sign == y.sign && y.данные == данные;
    }
    ///
    цел opEquals(T: цел)(T y) {
        if (sign!=(y<0)) return 0;
        return данные.opEquals(cast(бдол)(y>=0?y:-y));
    }
    ///
    цел opCmp(T:цел)(T y) {
     //   if (y==0) return sign? -1: 1;
        if (sign!=(y<0)) return sign ? -1 : 1;
        цел cmp = данные.opCmp(cast(бдол)(y>=0? y: -y));        
        return sign? -cmp: cmp;
    }
    ///
    цел opCmp(T:BigInt)(T y) {
        if (sign!=y.sign) return sign ? -1 : 1;
        цел cmp = данные.opCmp(y.данные);
        return sign? -cmp: cmp;
    }
    /// Returns the значение of this BigInt as a дол,
    /// or +- дол.max if outsопрe the representable range.
    дол toLong() {
        return (sign ? -1 : 1)* 
          (данные.ulongLength() == 1  && (данные.ПросмотрUlong(0) <= cast(бдол)(дол.max)) ? cast(дол)(данные.ПросмотрUlong(0)): дол.max);
    }
    /// Returns the значение of this BigInt as an цел,
    /// or +- дол.max if outsопрe the representable range.
    дол вЦел() {
        return (sign ? -1 : 1)* 
          (данные.бцелLength() == 1  && (данные.ПросмотрUint(0) <= cast(бцел)(цел.max)) ? cast(цел)(данные.ПросмотрUint(0)): цел.max);
    }
    /// Число of significant бцелs which are used in storing this число.
    /// The абсолютный значение of this BigInt is always < 2^(32*бцелLength)
    цел бцелLength() { return данные.бцелLength(); }
    /// Число of significant ulongs which are used in storing this число.
    /// The абсолютный значение of this BigInt is always < 2^(64*ulongLength)
    цел ulongLength() { return данные.ulongLength(); } 
    
    /// Return x raised в_ the power of y
    /// This interface is tentative and may change.
    static BigInt степ(BigInt x, бдол y) {
       BigInt r;
       r.sign = (y&1)? x.sign : нет;
       r.данные = BigUint.степ(x.данные, y);
       return r;
    }
public:
    /// Deprecated. Use бцелLength() or ulongLength() instead.
    цел numBytes() {
        return данные.numBytes();
    }
    /// BUG: For testing only, this will be removed eventually 
    /// (needs formatting options)
    сим [] toDecimalString(){
        сим [] buff = данные.toDecimalString(1);
        if (isNegative()) buff[0] = '-';
        else buff = buff[1..$];
        return buff;
    }
    /// Convert в_ a hexadecimal ткст, with an underscore every
    /// 8 characters.
    сим [] toHex() {
        сим [] buff = данные.toHexString(1, '_');
        if (isNegative()) buff[0] = '-';
        else buff = buff[1..$];
        return buff;
    }
public:
    проц negate() { if (!данные.isZero()) sign = !sign; }
    бул isZero() { return данные.isZero(); }
    бул isNegative() { return sign; }
package:
    /// BUG: For testing only, this will be removed eventually
    BigInt sliceHighestBytes(бцел numbytes) {
        assert(numbytes<=numBytes());
        BigInt x;
        x.sign = sign;
        x.данные = данные.sliceHighestBytes(numbytes);
        return x;
    }

private:    
    static BigInt добавьsubInternal(BigInt x, BigInt y, бул wantSub) {
        BigInt r;
        r.sign = x.sign;
        r.данные = BigUint.добавьOrSub(x.данные, y.данные, wantSub, &r.sign);
        return r;
    }
    static BigInt mulInternal(BigInt x, BigInt y) {
        BigInt r;        
        r.данные = BigUint.mul(x.данные, y.данные);
        r.sign = r.isZero() ? нет : x.sign ^ y.sign;
        return r;
    }
    
    static BigInt modInternal(BigInt x, BigInt y) {
        if (x.isZero()) return x;
        BigInt r;
        r.sign = x.sign;
        r.данные = BigUint.mod(x.данные, y.данные);
        return r;
    }
    static BigInt divInternal(BigInt x, BigInt y) {
        if (x.isZero()) return x;
        BigInt r;
        r.sign = x.sign ^ y.sign;
        r.данные = BigUint.div(x.данные, y.данные);
        return r;
    }
    static BigInt mulInternal(BigInt x, бдол y, бул negResult)
    {
        BigInt r;
        if (y==0) {
            r.sign = нет;
            r.данные = 0;
            return r;
        }
        r.sign = negResult;
        r.данные = BigUint.mulInt(x.данные, y);
        return r;
    }
}

debug(UnitTest)
{
unittest {
    // Radix conversion
    assert( BigInt("-1_234_567_890_123_456_789").toDecimalString 
        == "-1234567890123456789");
    assert( BigInt("0x1234567890123456789").toHex == "123_45678901_23456789");
    assert( BigInt("0x00000000000000000000000000000000000A234567890123456789").toHex
        == "A23_45678901_23456789");
    assert( BigInt("0x000_00_000000_000_000_000000000000_000000_").toHex == "0");
    
    assert(BigInt(-0x12345678).вЦел() == -0x12345678);
    assert(BigInt(-0x12345678).toLong() == -0x12345678);
    assert(BigInt(0x1234_5678_9ABC_5A5AL).toLong() == 0x1234_5678_9ABC_5A5AL);
    assert(BigInt(0xF234_5678_9ABC_5A5AL).toLong() == дол.max);
    assert(BigInt(-0x123456789ABCL).вЦел() == -цел.max);

}
}