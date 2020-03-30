/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/intrange.d, _intrange.d)
 * Documentation:  https://dlang.org/phobos/dmd_intrange.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/intrange.d
 */

module dmd.intrange;

import cidrus;

import dmd.mtype;
import drc.ast.Expression;
import dmd.globals;

private uinteger_t copySign(uinteger_t x, бул sign)
{
    // return sign ? -x : x;
    return (x - cast(uinteger_t)sign) ^ -cast(uinteger_t)sign;
}

struct SignExtendedNumber
{
    uinteger_t значение;
    бул negative;

    static SignExtendedNumber fromInteger(uinteger_t value_)
    {
        return SignExtendedNumber(value_, value_ >> 63);
    }

    static SignExtendedNumber extreme(бул minimum)
    {
        return SignExtendedNumber(minimum - 1, minimum);
    }

    static SignExtendedNumber max()
    {
        return SignExtendedNumber(бдол.max, нет);
    }

    static SignExtendedNumber min()
    {
        return SignExtendedNumber(0, да);
    }

    бул isMinimum()
    {
        return negative && значение == 0;
    }

    бул opEquals(ref SignExtendedNumber a)
    {
        return значение == a.значение && negative == a.negative;
    }

    цел opCmp(ref SignExtendedNumber a)
    {
        if (negative != a.negative)
        {
            if (negative)
                return -1;
            else
                return 1;
        }
        if (значение < a.значение)
            return -1;
        else if (значение > a.значение)
            return 1;
        else
            return 0;
    }

    SignExtendedNumber opUnary(ткст op : "++")()
    {
        if (значение != бдол.max)
            ++значение;
        else if (negative)
        {
            значение = 0;
            negative = нет;
        }
        return this;
    }

    SignExtendedNumber opUnary(ткст op : "~")()
    {
        if (~значение == 0)
            return SignExtendedNumber(~значение);
        else
            return SignExtendedNumber(~значение, !negative);
    }

    SignExtendedNumber opUnary(ткст op : "-")()
    {
        if (значение == 0)
            return SignExtendedNumber(-cast(бдол)negative);
        else
            return SignExtendedNumber(-значение, !negative);
    }

    SignExtendedNumber opBinary(ткст op : "&")(SignExtendedNumber rhs)
    {
        return SignExtendedNumber(значение & rhs.значение);
    }

    SignExtendedNumber opBinary(ткст op : "|")(SignExtendedNumber rhs)
    {
        return SignExtendedNumber(значение | rhs.значение);
    }

    SignExtendedNumber opBinary(ткст op : "^")(SignExtendedNumber rhs)
    {
        return SignExtendedNumber(значение ^ rhs.значение);
    }

    SignExtendedNumber opBinary(ткст op : "+")(SignExtendedNumber rhs)
    {
        uinteger_t sum = значение + rhs.значение;
        бул carry = sum < значение && sum < rhs.значение;
        if (negative != rhs.negative)
            return SignExtendedNumber(sum, !carry);
        else if (negative)
            return SignExtendedNumber(carry ? sum : 0, да);
        else
            return SignExtendedNumber(carry ? бдол.max : sum, нет);
    }


    SignExtendedNumber opBinary(ткст op : "-")(SignExtendedNumber rhs)
    {
        if (rhs.isMinimum())
            return negative ? SignExtendedNumber(значение, нет) : max();
        else
            return this + (-rhs);
    }

    SignExtendedNumber opBinary(ткст op : "*")(SignExtendedNumber rhs)
    {
        // perform *saturated* multiplication, otherwise we may get bogus ranges
        //  like 0x10 * 0x10 == 0x100 == 0.

        /* Special handling for zeros:
            INT65_MIN * 0 = 0
            INT65_MIN * + = INT65_MIN
            INT65_MIN * - = INT65_MAX
            0 * anything = 0
        */
        if (значение == 0)
        {
            if (!negative)
                return this;
            else if (rhs.negative)
                return max();
            else
                return rhs.значение == 0 ? rhs : this;
        }
        else if (rhs.значение == 0)
            return rhs * this; // don't duplicate the symmetric case.

        SignExtendedNumber rv;
        // these are != 0 now surely.
        uinteger_t tAbs = copySign(значение, negative);
        uinteger_t aAbs = copySign(rhs.значение, rhs.negative);
        rv.negative = negative != rhs.negative;
        if (бдол.max / tAbs < aAbs)
            rv.значение = rv.negative - 1;
        else
            rv.значение = copySign(tAbs * aAbs, rv.negative);
        return rv;
    }

    SignExtendedNumber opBinary(ткст op : "/")(SignExtendedNumber rhs)
    {
        /* special handling for zeros:
            INT65_MIN / INT65_MIN = 1
            anything / INT65_MIN = 0
            + / 0 = INT65_MAX  (eh?)
            - / 0 = INT65_MIN  (eh?)
        */
        if (rhs.значение == 0)
        {
            if (rhs.negative)
                return SignExtendedNumber(значение == 0 && negative);
            else
                return extreme(negative);
        }

        uinteger_t aAbs = copySign(rhs.значение, rhs.negative);
        uinteger_t rvVal;

        if (!isMinimum())
            rvVal = copySign(значение, negative) / aAbs;
        // Special handling for INT65_MIN
        //  if the denominator is not a power of 2, it is same as бдол.max / x.
        else if (aAbs & (aAbs - 1))
            rvVal = бдол.max / aAbs;
        // otherwise, it's the same as reversing the bits of x.
        else
        {
            if (aAbs == 1)
                return extreme(!rhs.negative);
            rvVal = 1UL << 63;
            aAbs >>= 1;
            if (aAbs & 0xAAAAAAAAAAAAAAAAUL) rvVal >>= 1;
            if (aAbs & 0xCCCCCCCCCCCCCCCCUL) rvVal >>= 2;
            if (aAbs & 0xF0F0F0F0F0F0F0F0UL) rvVal >>= 4;
            if (aAbs & 0xFF00FF00FF00FF00UL) rvVal >>= 8;
            if (aAbs & 0xFFFF0000FFFF0000UL) rvVal >>= 16;
            if (aAbs & 0xFFFFFFFF00000000UL) rvVal >>= 32;
        }
        бул rvNeg = negative != rhs.negative;
        rvVal = copySign(rvVal, rvNeg);

        return SignExtendedNumber(rvVal, rvVal != 0 && rvNeg);
    }

    SignExtendedNumber opBinary(ткст op : "%")(SignExtendedNumber rhs)
    {
        if (rhs.значение == 0)
            return !rhs.negative ? rhs : isMinimum() ? SignExtendedNumber(0) : this;

        uinteger_t aAbs = copySign(rhs.значение, rhs.negative);
        uinteger_t rvVal;

        // a % b == sgn(a) * abs(a) % abs(b).
        if (!isMinimum())
            rvVal = copySign(значение, negative) % aAbs;
        // Special handling for INT65_MIN
        //  if the denominator is not a power of 2, it is same as бдол.max % x + 1.
        else if (aAbs & (aAbs - 1))
            rvVal = бдол.max % aAbs + 1;
        //  otherwise, the modulus is trivially нуль.
        else
            rvVal = 0;

        rvVal = copySign(rvVal, negative);
        return SignExtendedNumber(rvVal, rvVal != 0 && negative);
    }

    SignExtendedNumber opBinary(ткст op : "<<")(SignExtendedNumber rhs)
    {
        // assume left-shift the shift-amount is always unsigned. Thus negative
        //  shifts will give huge результат.
        if (значение == 0)
            return this;
        else if (rhs.negative)
            return extreme(negative);

        uinteger_t v = copySign(значение, negative);

        // compute base-2 log of 'v' to determine the maximum allowed bits to shift.
        // Ref: http://graphics.stanford.edu/~seander/bithacks.html#IntegerLog

        // Why is this a т_мера? Looks like a bug.
        т_мера r, s;

        r = (v > 0xFFFFFFFFUL) << 5; v >>= r;
        s = (v > 0xFFFFUL    ) << 4; v >>= s; r |= s;
        s = (v > 0xFFUL      ) << 3; v >>= s; r |= s;
        s = (v > 0xFUL       ) << 2; v >>= s; r |= s;
        s = (v > 0x3UL       ) << 1; v >>= s; r |= s;
                                               r |= (v >> 1);

        uinteger_t allowableShift = 63 - r;
        if (rhs.значение > allowableShift)
            return extreme(negative);
        else
            return SignExtendedNumber(значение << rhs.значение, negative);
    }

    SignExtendedNumber opBinary(ткст op : ">>")(SignExtendedNumber rhs)
    {
        if (rhs.negative || rhs.значение > 63)
            return negative ? SignExtendedNumber(-1, да) : SignExtendedNumber(0);
        else if (isMinimum())
            return rhs.значение == 0 ? this : SignExtendedNumber(-1UL << (64 - rhs.значение), да);

        uinteger_t x = значение ^ -cast(цел)negative;
        x >>= rhs.значение;
        return SignExtendedNumber(x ^ -cast(цел)negative, negative);
    }

    SignExtendedNumber opBinary(ткст op : "^^")(SignExtendedNumber rhs)
    {
        // Not yet implemented
        assert(0);
    }
}

struct IntRange
{
    SignExtendedNumber imin, imax;

    this(IntRange another)
    {
        imin = another.imin;
        imax = another.imax;
    }

    this(SignExtendedNumber a)
    {
        imin = a;
        imax = a;
    }

    this(SignExtendedNumber lower, SignExtendedNumber upper)
    {
        imin = lower;
        imax = upper;
    }

    static IntRange fromType(Тип тип)
    {
        return fromType(тип, тип.isunsigned());
    }

    static IntRange fromType(Тип тип, бул isUnsigned)
    {
        if (!тип.isintegral() || тип.toBasetype().ty == Tvector)
            return widest();

        uinteger_t mask = тип.sizemask();
        auto lower = SignExtendedNumber(0);
        auto upper = SignExtendedNumber(mask);
        if (тип.toBasetype().ty == Tdchar)
            upper.значение = 0x10FFFFUL;
        else if (!isUnsigned)
        {
            lower.значение = ~(mask >> 1);
            lower.negative = да;
            upper.значение = (mask >> 1);
        }
        return IntRange(lower, upper);
    }

    static IntRange fromNumbers2(SignExtendedNumber* numbers)
    {
        if (numbers[0] < numbers[1])
            return IntRange(numbers[0], numbers[1]);
        else
            return IntRange(numbers[1], numbers[0]);
    }

    static IntRange fromNumbers4(SignExtendedNumber* numbers)
    {
        IntRange ab = fromNumbers2(numbers);
        IntRange cd = fromNumbers2(numbers + 2);
        if (cd.imin < ab.imin)
            ab.imin = cd.imin;
        if (cd.imax > ab.imax)
            ab.imax = cd.imax;
        return ab;
    }

    static IntRange widest()
    {
        return IntRange(SignExtendedNumber.min(), SignExtendedNumber.max());
    }

    IntRange castSigned(uinteger_t mask)
    {
        // .... 0x1e7f ] [0x1e80 .. 0x1f7f] [0x1f80 .. 0x7f] [0x80 .. 0x17f] [0x180 ....
        //
        // regular signed тип. We use a technique similar to the unsigned version,
        //  but the chunk has to be смещение by 1/2 of the range.
        uinteger_t halfChunkMask = mask >> 1;
        uinteger_t minHalfChunk = imin.значение & ~halfChunkMask;
        uinteger_t maxHalfChunk = imax.значение & ~halfChunkMask;
        цел minHalfChunkNegativity = imin.negative; // 1 = neg, 0 = nonneg, -1 = chunk containing ::max
        цел maxHalfChunkNegativity = imax.negative;
        if (minHalfChunk & mask)
        {
            minHalfChunk += halfChunkMask + 1;
            if (minHalfChunk == 0)
                --minHalfChunkNegativity;
        }
        if (maxHalfChunk & mask)
        {
            maxHalfChunk += halfChunkMask + 1;
            if (maxHalfChunk == 0)
                --maxHalfChunkNegativity;
        }
        if (minHalfChunk == maxHalfChunk && minHalfChunkNegativity == maxHalfChunkNegativity)
        {
            imin.значение &= mask;
            imax.значение &= mask;
            // sign extend if necessary.
            imin.negative = (imin.значение & ~halfChunkMask) != 0;
            imax.negative = (imax.значение & ~halfChunkMask) != 0;
            halfChunkMask += 1;
            imin.значение = (imin.значение ^ halfChunkMask) - halfChunkMask;
            imax.значение = (imax.значение ^ halfChunkMask) - halfChunkMask;
        }
        else
        {
            imin = SignExtendedNumber(~halfChunkMask, да);
            imax = SignExtendedNumber(halfChunkMask, нет);
        }
        return this;
    }

    IntRange castUnsigned(uinteger_t mask)
    {
        // .... 0x1eff ] [0x1f00 .. 0x1fff] [0 .. 0xff] [0x100 .. 0x1ff] [0x200 ....
        //
        // regular unsigned тип. We just need to see if ir steps across the
        //  boundary of validRange. If yes, ir will represent the whole validRange,
        //  otherwise, we just take the modulus.
        // e.g. [0x105, 0x107] & 0xff == [5, 7]
        //      [0x105, 0x207] & 0xff == [0, 0xff]
        uinteger_t minChunk = imin.значение & ~mask;
        uinteger_t maxChunk = imax.значение & ~mask;
        if (minChunk == maxChunk && imin.negative == imax.negative)
        {
            imin.значение &= mask;
            imax.значение &= mask;
        }
        else
        {
            imin.значение = 0;
            imax.значение = mask;
        }
        imin.negative = imax.negative = нет;
        return this;
    }

    IntRange castDchar()
    {
        // special case for dchar. Casting to dchar means "I'll ignore all
        //  invalid characters."
        castUnsigned(0xFFFFFFFFUL);
        if (imin.значение > 0x10FFFFUL) // ??
            imin.значение = 0x10FFFFUL; // ??
        if (imax.значение > 0x10FFFFUL)
            imax.значение = 0x10FFFFUL;
        return this;
    }

    IntRange _cast(Тип тип)
    {
        if (!тип.isintegral() || тип.toBasetype().ty == Tvector)
            return this;
        else if (!тип.isunsigned())
            return castSigned(тип.sizemask());
        else if (тип.toBasetype().ty == Tdchar)
            return castDchar();
        else
            return castUnsigned(тип.sizemask());
    }

    IntRange castUnsigned(Тип тип)
    {
        if (!тип.isintegral() || тип.toBasetype().ty == Tvector)
            return castUnsigned(бдол.max);
        else if (тип.toBasetype().ty == Tdchar)
            return castDchar();
        else
            return castUnsigned(тип.sizemask());
    }

    бул содержит(IntRange a)
    {
        return imin <= a.imin && imax >= a.imax;
    }

    бул containsZero()
    {
        return (imin.negative && !imax.negative)
            || (!imin.negative && imin.значение == 0);
    }

    IntRange absNeg()
    {
        if (imax.negative)
            return this;
        else if (!imin.negative)
            return IntRange(-imax, -imin);
        else
        {
            SignExtendedNumber imaxAbsNeg = -imax;
            return IntRange(imaxAbsNeg < imin ? imaxAbsNeg : imin,
                            SignExtendedNumber(0));
        }
    }

    IntRange unionWith(ref IntRange other)
    {
        return IntRange(imin < other.imin ? imin : other.imin,
                        imax > other.imax ? imax : other.imax);
    }

    проц unionOrAssign(IntRange other, ref бул union_)
    {
        if (!union_ || imin > other.imin)
            imin = other.imin;
        if (!union_ || imax < other.imax)
            imax = other.imax;
        union_ = да;
    }

    IntRange dump(ткст0 funcName, Выражение e)
    {
        printf("[(%c)%#018llx, (%c)%#018llx] @ %s ::: %s\n",
               imin.negative?'-':'+', cast(бдол)imin.значение,
               imax.negative?'-':'+', cast(бдол)imax.значение,
               funcName, e.вТкст0());
        return this;
    }

    проц splitBySign(ref IntRange negRange, ref бул hasNegRange, ref IntRange nonNegRange, ref бул hasNonNegRange)
    {
        hasNegRange = imin.negative;
        if (hasNegRange)
        {
            negRange.imin = imin;
            negRange.imax = imax.negative ? imax : SignExtendedNumber(-1, да);
        }
        hasNonNegRange = !imax.negative;
        if (hasNonNegRange)
        {
            nonNegRange.imin = imin.negative ? SignExtendedNumber(0) : imin;
            nonNegRange.imax = imax;
        }
    }

    IntRange opUnary(ткст op:"~")()
    {
        return IntRange(~imax, ~imin);
    }

    IntRange opUnary(ткст op : "-")()
    {
        return IntRange(-imax, -imin);
    }

    // Credits to Timon Gehr for the algorithms for &, |
    // https://github.com/tgehr/d-compiler/blob/master/vrange.d
    IntRange opBinary(ткст op : "&")(IntRange rhs)
    {
        // unsigned or identical sign bits
        if ((imin.negative ^ imax.negative) != 1 && (rhs.imin.negative ^ rhs.imax.negative) != 1)
        {
            return IntRange(minAnd(this, rhs), maxAnd(this, rhs));
        }

        IntRange l = IntRange(this);
        IntRange r = IntRange(rhs);

        // both intervals span [-1,0]
        if ((imin.negative ^ imax.negative) == 1 && (rhs.imin.negative ^ rhs.imax.negative) == 1)
        {
            // cannot be larger than either l.max or r.max, set the other one to -1
            SignExtendedNumber max = l.imax.значение > r.imax.значение ? l.imax : r.imax;

            // only negative numbers for minimum
            l.imax.значение = -1;
            l.imax.negative = да;
            r.imax.значение = -1;
            r.imax.negative = да;

            return IntRange(minAnd(l, r), max);
        }
        else
        {
            // only one interval spans [-1,0]
            if ((l.imin.negative ^ l.imax.negative) == 1)
            {
                swap(l, r); // r spans [-1,0]
            }

            auto minAndNeg = minAnd(l, IntRange(r.imin, SignExtendedNumber(-1)));
            auto minAndPos = minAnd(l, IntRange(SignExtendedNumber(0), r.imax));
            auto maxAndNeg = maxAnd(l, IntRange(r.imin, SignExtendedNumber(-1)));
            auto maxAndPos = maxAnd(l, IntRange(SignExtendedNumber(0), r.imax));

            auto min = minAndNeg < minAndPos ? minAndNeg : minAndPos;
            auto max = maxAndNeg > maxAndPos ? maxAndNeg : maxAndPos;

            auto range = IntRange(min, max);
            return range;
        }
    }

    // Credits to Timon Gehr for the algorithms for &, |
    // https://github.com/tgehr/d-compiler/blob/master/vrange.d
    IntRange opBinary(ткст op : "|")(IntRange rhs)
    {
        // unsigned or identical sign bits:
        if ((imin.negative ^ imax.negative) == 0 && (rhs.imin.negative ^ rhs.imax.negative) == 0)
        {
            return IntRange(minOr(this, rhs), maxOr(this, rhs));
        }

        IntRange l = IntRange(this);
        IntRange r = IntRange(rhs);

        // both intervals span [-1,0]
        if ((imin.negative ^ imax.negative) == 1 && (rhs.imin.negative ^ rhs.imax.negative) == 1)
        {
            // cannot be smaller than either l.min or r.min, set the other one to 0
            SignExtendedNumber min = l.imin.значение < r.imin.значение ? l.imin : r.imin;

            // only negative numbers for minimum
            l.imin.значение = 0;
            l.imin.negative = нет;
            r.imin.значение = 0;
            r.imin.negative = нет;

            return IntRange(min, maxOr(l, r));
        }
        else
        {
            // only one interval spans [-1,0]
            if ((imin.negative ^ imax.negative) == 1)
            {
                swap(l, r); // r spans [-1,0]
            }

            auto minOrNeg = minOr(l, IntRange(r.imin, SignExtendedNumber(-1)));
            auto minOrPos = minOr(l, IntRange(SignExtendedNumber(0), r.imax));
            auto maxOrNeg = maxOr(l, IntRange(r.imin, SignExtendedNumber(-1)));
            auto maxOrPos = maxOr(l, IntRange(SignExtendedNumber(0), r.imax));

            auto min = minOrNeg < minOrPos ? minOrNeg : minOrPos;
            auto max = maxOrNeg > maxOrPos ? maxOrNeg : maxOrPos;

            auto range = IntRange(min, max);
            return range;
        }
    }

    IntRange opBinary(ткст op : "^")(IntRange rhs)
    {
        return this & ~rhs | ~this & rhs;
    }

    IntRange opBinary(ткст op : "+")(IntRange rhs)
    {
        return IntRange(imin + rhs.imin, imax + rhs.imax);
    }

    IntRange opBinary(ткст op : "-")(IntRange rhs)
    {
        return IntRange(imin - rhs.imax, imax - rhs.imin);
    }

    IntRange opBinary(ткст op : "*")(IntRange rhs)
    {
        // [a,b] * [c,d] = [min (ac, ad, bc, bd), max (ac, ad, bc, bd)]
        SignExtendedNumber[4] bdy;
        bdy[0] = imin * rhs.imin;
        bdy[1] = imin * rhs.imax;
        bdy[2] = imax * rhs.imin;
        bdy[3] = imax * rhs.imax;
        return IntRange.fromNumbers4(bdy.ptr);
    }

    IntRange opBinary(ткст op : "/")(IntRange rhs)
    {
        // Handle divide by 0
        if (rhs.imax.значение == 0 && rhs.imin.значение == 0)
            return widest();

        // Don't treat the whole range as divide by 0 if only one end of a range is 0.
        // Issue 15289
        if (rhs.imax.значение == 0)
        {
            rhs.imax.значение--;
        }
        else if(rhs.imin.значение == 0)
        {
            rhs.imin.значение++;
        }

        if (!imin.negative && !imax.negative && !rhs.imin.negative && !rhs.imax.negative)
        {
            return IntRange(imin / rhs.imax, imax / rhs.imin);
        }
        else
        {
            // [a,b] / [c,d] = [min (a/c, a/d, b/c, b/d), max (a/c, a/d, b/c, b/d)]
            SignExtendedNumber[4] bdy;
            bdy[0] = imin / rhs.imin;
            bdy[1] = imin / rhs.imax;
            bdy[2] = imax / rhs.imin;
            bdy[3] = imax / rhs.imax;

            return IntRange.fromNumbers4(bdy.ptr);
        }
    }

    IntRange opBinary(ткст op : "%")(IntRange rhs)
    {
        IntRange irNum = this;
        IntRange irDen = rhs.absNeg();

        /*
         due to the rules of D (C)'s % operator, we need to consider the cases
         separately in different range of signs.

             case 1. [500, 1700] % [7, 23] (numerator is always positive)
                 = [0, 22]
             case 2. [-500, 1700] % [7, 23] (numerator can be negative)
                 = [-22, 22]
             case 3. [-1700, -500] % [7, 23] (numerator is always negative)
                 = [-22, 0]

         the number 22 is the maximum absolute значение in the denomator's range. We
         don't care about divide by нуль.
         */

        irDen.imin = irDen.imin + SignExtendedNumber(1);
        irDen.imax = -irDen.imin;

        if (!irNum.imin.negative)
        {
            irNum.imin.значение = 0;
        }
        else if (irNum.imin < irDen.imin)
        {
            irNum.imin = irDen.imin;
        }

        if (irNum.imax.negative)
        {
            irNum.imax.negative = нет;
            irNum.imax.значение = 0;
        }
        else if (irNum.imax > irDen.imax)
        {
            irNum.imax = irDen.imax;
        }

        return irNum;
    }

    IntRange opBinary(ткст op : "<<")(IntRange rhs)
    {
        if (rhs.imin.negative)
        {
            rhs = IntRange(SignExtendedNumber(0), SignExtendedNumber(64));
        }

        SignExtendedNumber lower = imin << (imin.negative ? rhs.imax : rhs.imin);
        SignExtendedNumber upper = imax << (imax.negative ? rhs.imin : rhs.imax);

        return IntRange(lower, upper);
    }

    IntRange opBinary(ткст op : ">>")(IntRange rhs)
    {
        if (rhs.imin.negative)
        {
            rhs = IntRange(SignExtendedNumber(0), SignExtendedNumber(64));
        }

        SignExtendedNumber lower = imin >> (imin.negative ? rhs.imin : rhs.imax);
        SignExtendedNumber upper = imax >> (imax.negative ? rhs.imax : rhs.imin);

        return IntRange(lower, upper);
    }

    IntRange opBinary(ткст op : ">>>")(IntRange rhs)
    {
        if (rhs.imin.negative)
        {
            rhs = IntRange(SignExtendedNumber(0), SignExtendedNumber(64));
        }

        return IntRange(imin >> rhs.imax, imax >> rhs.imin);
    }

    IntRange opBinary(ткст op : "^^")(IntRange rhs)
    {
        // Not yet implemented
        assert(0);
    }

private:
    // Credits to Timon Gehr maxOr, minOr, maxAnd, minAnd
    // https://github.com/tgehr/d-compiler/blob/master/vrange.d
    static SignExtendedNumber maxOr( IntRange lhs,  IntRange rhs)
    {
        uinteger_t x = 0;
        auto sign = нет;
        auto xor = lhs.imax.значение ^ rhs.imax.значение;
        auto and = lhs.imax.значение & rhs.imax.значение;
        auto lhsc = IntRange(lhs);
        auto rhsc = IntRange(rhs);

        // Sign bit not part of the .значение so we need an extra iteration
        if (lhsc.imax.negative ^ rhsc.imax.negative)
        {
            sign = да;
            if (lhsc.imax.negative)
            {
                if (!lhsc.imin.negative)
                {
                    lhsc.imin.значение = 0;
                }
                if (!rhsc.imin.negative)
                {
                    rhsc.imin.значение = 0;
                }
            }
        }
        else if (lhsc.imin.negative & rhsc.imin.negative)
        {
            sign = да;
        }
        else if (lhsc.imax.negative & rhsc.imax.negative)
        {
            return SignExtendedNumber(-1, нет);
        }

        for (uinteger_t d = 1LU << (8 * uinteger_t.sizeof - 1); d; d >>= 1)
        {
            if (xor & d)
            {
                x |= d;
                if (lhsc.imax.значение & d)
                {
                    if (~lhsc.imin.значение & d)
                    {
                        lhsc.imin.значение = 0;
                    }
                }
                else
                {
                    if (~rhsc.imin.значение & d)
                    {
                        rhsc.imin.значение = 0;
                    }
                }
            }
            else if (lhsc.imin.значение & rhsc.imin.значение & d)
            {
                x |= d;
            }
            else if (and & d)
            {
                x |= (d << 1) - 1;
                break;
            }
        }

        auto range = SignExtendedNumber(x, sign);
        return range;
    }

    // Credits to Timon Gehr maxOr, minOr, maxAnd, minAnd
    // https://github.com/tgehr/d-compiler/blob/master/vrange.d
    static SignExtendedNumber minOr( IntRange lhs,  IntRange rhs)
    {
        return ~maxAnd(~lhs, ~rhs);
    }

    // Credits to Timon Gehr maxOr, minOr, maxAnd, minAnd
    // https://github.com/tgehr/d-compiler/blob/master/vrange.d
    static SignExtendedNumber maxAnd( IntRange lhs,  IntRange rhs)
    {
        uinteger_t x = 0;
        бул sign = нет;
        auto lhsc = IntRange(lhs);
        auto rhsc = IntRange(rhs);

        if (lhsc.imax.negative & rhsc.imax.negative)
        {
            sign = да;
        }

        for (uinteger_t d = 1LU << (8 * uinteger_t.sizeof - 1); d; d >>= 1)
        {
            if (lhsc.imax.значение & rhsc.imax.значение & d)
            {
                x |= d;
                if (~lhsc.imin.значение & d)
                {
                    lhsc.imin.значение = 0;
                }
                if (~rhsc.imin.значение & d)
                {
                    rhsc.imin.значение = 0;
                }
            }
            else if (~lhsc.imin.значение & d && lhsc.imax.значение & d)
            {
                lhsc.imax.значение |= d - 1;
            }
            else if (~rhsc.imin.значение & d && rhsc.imax.значение & d)
            {
                rhsc.imax.значение |= d - 1;
            }
        }

        auto range = SignExtendedNumber(x, sign);
        return range;
    }

    // Credits to Timon Gehr maxOr, minOr, maxAnd, minAnd
    // https://github.com/tgehr/d-compiler/blob/master/vrange.d
    static SignExtendedNumber minAnd( IntRange lhs,  IntRange rhs)
    {
        return ~maxOr(~lhs, ~rhs);
    }

    static проц swap (ref IntRange a, ref IntRange b)
    {
        auto aux = a;
        a = b;
        b = aux;
    }
}
