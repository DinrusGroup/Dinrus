/** Fundamental operations for arbitrary-точность arithmetic
 *
 * These functions are for internal use only.
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Don Clugston
 */
/* References:
  - R.P. Brent and P. Zimmermann, "Modern Computer Arithmetic", 
    Версия 0.2, p. 26, (June 2009).
  - C. Burkinel and J. Ziegler, "Быстрый Recursive Division", MPI-I-98-1-022, 
    Max-Planck Institute fuer Informatik, (Oct 1998).
  - G. Hanrot, M. Quercia, and P. Zimmermann, "The Mопрdle Product Algorithm, I.",
    INRIA 4664, (Dec 2002).
  - M. Bodrato and A. Zanoni, "What about Toom-Cook Matrices Optimality?",
    http://bodrato.it/papers (2006).
  - A. Fog, "Optimizing subroutines in assembly language", 
    www.agner.org/оптимизируй (2008).
  - A. Fog, "The microarchitecture of Intel and AMD CPU's",
    www.agner.org/оптимизируй (2008).
  - A. Fog, "Instruction tables: Lists of instruction latencies, throughputs
    and micro-operation breakdowns for Intel and AMD CPU's.", www.agner.org/оптимизируй (2008).
*/ 
module math.internal.BigбцелCore;

//version=TangoBignumNoAsm;       /// temporal: see ticket #1878

version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(TangoBignumNoAsm) {

} else version(D_InlineAsm_X86) {
    version = Naked_D_InlineAsm_X86;
} else version(LLVM_InlineAsm_X86) { 
    version = Naked_D_InlineAsm_X86; 
}

version(Naked_D_InlineAsm_X86) { 
private import math.internal.BignumX86;
} else {
private import math.internal.BignumNoAsm;
}
version(build){// bud/build won't link properly without this.
    static import math.internal.BignumX86;
}

alias multibyteдобавьSub!('+') multibyteдобавь;
alias multibyteдобавьSub!('-') multibyteSub;

// private import core.Cpuid;
static this()
{
    CACHELIMIT = 8000; // core.Cpuid.datacache[0].размер/2;
    FASTDIVLIMIT = 100;
}

private:
// Limits for when в_ switch between algorithms.
const цел CACHELIMIT;   // Half the размер of the данные cache.
const цел FASTDIVLIMIT; // crossover в_ recursive division


// These constants are used by shift operations
static if (BigDigit.sizeof == цел.sizeof) {
    enum { LG2BIGDIGITBITS = 5, BIGDIGITSHIFTMASK = 31 };
    alias бкрат BIGHALFDIGIT;
} else static if (BigDigit.sizeof == дол.sizeof) {
    alias бцел BIGHALFDIGIT;
    enum { LG2BIGDIGITBITS = 6, BIGDIGITSHIFTMASK = 63 };
} else static assert(0, "Unsupported BigDigit размер");

const BigDigit [] ZERO = [0];
const BigDigit [] ONE = [1];
const BigDigit [] TWO = [2];
const BigDigit [] TEN = [10];

public:       

/// BigUint performs память management and wraps the low-уровень calls.
struct BigUint {
private:
    invariant() {
        assert( данные.length == 1 || данные[$-1] != 0 );
    }
    BigDigit [] данные = ZERO; 
    static BigUint opCall(BigDigit [] x) {
       BigUint a;
       a.данные = x;
       return a;
    }
public: // for development only, will be removed eventually
    // Equivalent в_ BigUint[numbytes-$..$]
    BigUint sliceHighestBytes(бцел numbytes) {
        BigUint x;
        x.данные = данные[$ - (numbytes>>2) .. $];
        return x;
    }
    // Length in бцелs
    цел бцелLength() {
        static if (BigDigit.sizeof == бцел.sizeof) {
            return данные.length;
        } else static if (BigDigit.sizeof == бдол.sizeof) {
            return данные.length * 2 - 
            ((данные[$-1] & 0xFFFF_FFFF_0000_0000L) ? 1 : 0);
        }
    }
    цел ulongLength() {
        static if (BigDigit.sizeof == бцел.sizeof) {
            return (данные.length + 1) >> 1;
        } else static if (BigDigit.sizeof == бдол.sizeof) {
            return данные.length;
        }
    }

    // The значение at (cast(бдол[])данные)[n]
    бдол ПросмотрUlong(цел n) {
        static if (BigDigit.sizeof == цел.sizeof) {
            if (данные.length == n*2 + 1) return данные[n*2];
            version(LittleEndian) {
                return данные[n*2] + ((cast(бдол)данные[n*2 + 1]) << 32 );
            } else {
                return данные[n*2 + 1] + ((cast(бдол)данные[n*2]) << 32 );
            }
        } else static if (BigDigit.sizeof == дол.sizeof) {
            return данные[n];
        }
    }
    бцел ПросмотрUint(цел n) {
        static if (BigDigit.sizeof == цел.sizeof) {
            return данные[n];
        } else {
            бдол x = данные[n >> 1];
            return (n & 1) ? cast(бцел)(x >> 32) : cast(бцел)x;
        }
    }
public:
    ///
    проц opAssign(бдол u) {
        if (u == 0) данные = ZERO;
        else if (u == 1) данные = ONE;
        else if (u == 2) данные = TWO;
        else if (u == 10) данные = TEN;
        else {
            бцел ulo = cast(бцел)(u & 0xFFFF_FFFF);
            бцел uhi = cast(бцел)(u >> 32);
            if (uhi==0) {
              данные = new BigDigit[1];
              данные[0] = ulo;
            } else {
              данные = new BigDigit[2];
              данные[0] = ulo;
              данные[1] = uhi;
            }
        }
    }
    
///
цел opCmp(BigUint y)
{
    if (данные.length != y.данные.length) {
        return (данные.length > y.данные.length) ?  1 : -1;
    }
    бцел k = highestDifferentDigit(данные, y.данные);
    if (данные[k] == y.данные[k]) return 0;
    return данные[k] > y.данные[k] ? 1 : -1;
}

///
цел opCmp(бдол y)
{
    if (данные.length>2) return 1;
    бцел ylo = cast(бцел)(y & 0xFFFF_FFFF);
    бцел yhi = cast(бцел)(y >> 32);
    if (данные.length == 2 && данные[1] != yhi) {
        return данные[1] > yhi ? 1: -1;
    }
    if (данные[0] == ylo) return 0;
    return данные[0] > ylo ? 1: -1;
}

цел opEquals(BigUint y) {
       return y.данные[] == данные[];
}

цел opEquals(бдол y) {
    if (данные.length>2) return 0;
    бцел ylo = cast(бцел)(y & 0xFFFF_FFFF);
    бцел yhi = cast(бцел)(y >> 32);
    if (данные.length==2 && данные[1]!=yhi) return 0;
    if (данные.length==1 && yhi!=0) return 0;
    return (данные[0] == ylo);
}


бул isZero() { return данные.length == 1 && данные[0] == 0; }

цел numBytes() {
    return данные.length * BigDigit.sizeof;
}

// the extra байты are добавьed в_ the старт of the ткст
сим [] toDecimalString(цел frontExtraBytes)
{
    бцел predictlength = 20+20*(данные.length/2); // just over 19
    сим [] buff = new сим[frontExtraBytes + predictlength];
    цел sofar = bigбцелToDecimal(buff, данные.dup);       
    return buff[sofar-frontExtraBytes..$];
}

/** Convert в_ a hex ткст, printing a minimum число of digits 'minPдобавьing',
 *  allocating an добавьitional 'frontExtraBytes' at the старт of the ткст.
 *  Pдобавьing is готово with padChar, which may be '0' or ' '.
 *  'разделитель' is a цифра separation character. If non-zero, it is inserted
 *  between every 8 digits.
 *  Separator characters do not contribute в_ the minPдобавьing.
 */
сим [] toHexString(цел frontExtraBytes, сим разделитель = 0, цел minPдобавьing=0, сим padChar = '0')
{
    // Calculate число of extra паддинг байты
    т_мера extraPad = (minPдобавьing > данные.length * 2 * BigDigit.sizeof) 
        ? minPдобавьing - данные.length * 2 * BigDigit.sizeof : 0;

    // Length not включая разделитель байты                
    т_мера lenBytes = данные.length * 2 * BigDigit.sizeof;

    // Calculate число of разделитель байты
    т_мера mainSeparatorBytes = разделитель ? (lenBytes  / 8) - 1 : 0;
    т_мера totalSeparatorBytes = разделитель ? ((extraPad + lenBytes + 7) / 8) - 1: 0;

    сим [] buff = new сим[lenBytes + extraPad + totalSeparatorBytes + frontExtraBytes];
    bigбцелToHex(buff[$ - lenBytes - mainSeparatorBytes .. $], данные, разделитель);
    if (extraPad > 0) {
        if (разделитель) {
            т_мера старт = frontExtraBytes; // first индекс в_ pad
            if (extraPad &7) {
                // Do 1 в_ 7 extra zeros.
                buff[frontExtraBytes .. frontExtraBytes + (extraPad & 7)] = padChar;
                buff[frontExtraBytes + (extraPad & 7)] = (padChar == ' ' ? ' ' : разделитель);
                старт += (extraPad & 7) + 1;
            }
            for (цел i=0; i< (extraPad >> 3); ++i) {
                buff[старт .. старт + 8] = padChar;
                buff[старт + 8] = (padChar == ' ' ? ' ' : разделитель);
                старт += 9;
            }
        } else {
            buff[frontExtraBytes .. frontExtraBytes + extraPad]=padChar;
        }
    }
    цел z = frontExtraBytes;
    if (lenBytes > minPдобавьing) {
        // StrИП leading zeros.
        цел maxStrИП = lenBytes - minPдобавьing;
        while (z< buff.length-1 && (buff[z]=='0' || buff[z]==padChar) && maxStrИП>0) {
            ++z; --maxStrИП;
        }
    }
    if (padChar!='0') {
        // Convert leading zeros преобр_в padChars.
        for (т_мера k= z; k< buff.length-1 && (buff[k]=='0' || buff[k]==padChar); ++k) {
            if (buff[k]=='0') buff[k]=padChar;
        }
    }
    return buff[z-frontExtraBytes..$];
}

// return нет if не_годится character найдено
бул fromHexString(сим [] s)
{
    //StrИП leading zeros
    цел firstNonZero = 0;    
    while ((firstNonZero < s.length - 1) && 
        (s[firstNonZero]=='0' || s[firstNonZero]=='_')) {
            ++firstNonZero;
    }    
    цел длин = (s.length - firstNonZero + 15)/4;
    данные = new BigDigit[длин+1];
    бцел часть = 0;
    бцел sofar = 0;
    бцел partcount = 0;
    assert(s.length>0);
    for (цел i = s.length - 1; i>=firstNonZero; --i) {
        assert(i>=0);
        сим c = s[i];
        if (s[i]=='_') continue;
        бцел x = (c>='0' && c<='9') ? c - '0' 
               : (c>='A' && c<='F') ? c - 'A' + 10 
               : (c>='a' && c<='f') ? c - 'a' + 10
               : 100;
        if (x==100) return нет;
        часть >>= 4;
        часть |= (x<<(32-4));
        ++partcount;
        if (partcount==8) {
            данные[sofar] = часть;
            ++sofar;
            partcount = 0;
            часть = 0;
        }
    }
    if (часть) {
        for ( ; partcount != 8; ++partcount) часть >>= 4;
        данные[sofar] = часть;
        ++sofar;
    }
    if (sofar == 0) данные = ZERO;
    else данные = данные[0..sofar];
    return да;
}

// return да if ОК; нет if erroneous characters найдено
бул fromDecimalString(сим [] s)
{
    //StrИП leading zeros
    цел firstNonZero = 0;    
    while ((firstNonZero < s.length - 1) && 
        (s[firstNonZero]=='0' || s[firstNonZero]=='_')) {
            ++firstNonZero;
    }
    if (firstNonZero == s.length - 1 && s.length > 1) {
        данные = ZERO;
        return да;
    }
    бцел predictlength = (18*2 + 2*(s.length-firstNonZero)) / 19;
    данные = new BigDigit[predictlength];
    бцел hi = bigбцелFromDecimal(данные, s[firstNonZero..$]);
    данные.length = hi;
    return да;
}

////////////////////////
//
// все of these member functions создай a new BigUint.

// return x >> y
BigUint opShr(бдол y)
{
    assert(y>0);
    бцел биты = cast(бцел)y & BIGDIGITSHIFTMASK;
    if ((y>>LG2BIGDIGITBITS) >= данные.length) return BigUint(ZERO);
    бцел words = cast(бцел)(y >> LG2BIGDIGITBITS);
    if (биты==0) {
        return BigUint(данные[words..$]);
    } else {
        бцел [] результат = new BigDigit[данные.length - words];
        многобайтСдвигП(результат, данные[words..$], биты);
        if (результат.length>1 && результат[$-1]==0) return BigUint(результат[0..$-1]);
        else return BigUint(результат);
    }
}

// return x << y
BigUint opShl(бдол y)
{
    assert(y>0);
    if (isZero()) return *this;
    бцел биты = cast(бцел)y & BIGDIGITSHIFTMASK;
    assert ((y>>LG2BIGDIGITBITS) < cast(бдол)(бцел.max));
    бцел words = cast(бцел)(y >> LG2BIGDIGITBITS);
    BigDigit [] результат = new BigDigit[данные.length + words+1];
    результат[0..words] = 0;
    if (биты==0) {
        результат[words..words+данные.length] = данные[];
        return BigUint(результат[0..words+данные.length]);
    } else {
        бцел c = многобайтСдвигЛ(результат[words..words+данные.length], данные, биты);
        if (c==0) return BigUint(результат[0..words+данные.length]);
        результат[$-1] = c;
        return BigUint(результат);
    }
}

// If wantSub is нет, return x+y, leaving sign unchanged
// If wantSub is да, return абс(x-y), negating sign if x<y
static BigUint добавьOrSubInt(BigUint x, бдол y, бул wantSub, бул *sign) {
    BigUint r;
    if (wantSub) { // perform a subtraction
        if (x.данные.length > 2) {
            r.данные = subInt(x.данные, y);                
        } else { // could change sign!
            бдол xx = x.данные[0];
            if (x.данные.length > 1) xx+= (cast(бдол)x.данные[1]) << 32;
            бдол d;
            if (xx <= y) {
                d = y - xx;
                *sign = !*sign;
            } else {
                d = xx - y;
            }
            if (d==0) {
                r = 0;
                return r;
            }
            r.данные = new BigDigit[ d > бцел.max ? 2: 1];
            r.данные[0] = cast(бцел)(d & 0xFFFF_FFFF);
            if (d > бцел.max) r.данные[1] = cast(бцел)(d>>32);
        }
    } else {
        r.данные = добавьInt(x.данные, y);
    }
    return r;
}

// If wantSub is нет, return x + y, leaving sign unchanged.
// If wantSub is да, return абс(x - y), negating sign if x<y
static BigUint добавьOrSub(BigUint x, BigUint y, бул wantSub, бул *sign) {
    BigUint r;
    if (wantSub) { // perform a subtraction
        r.данные = sub(x.данные, y.данные, sign);
        if (r.isZero()) {
            *sign = нет;
        }
    } else {
        r.данные = добавь(x.данные, y.данные);
    }
    return r;
}


//  return x*y.
//  y must not be zero.
static BigUint mulInt(BigUint x, бдол y)
{
    if (y==0 || x == 0) return BigUint(ZERO);
    бцел hi = cast(бцел)(y >>> 32);
    бцел lo = cast(бцел)(y & 0xFFFF_FFFF);
    бцел [] результат = new BigDigit[x.данные.length+1+(hi!=0)];
    результат[x.данные.length] = многобайтУмнож(результат[0..x.данные.length], x.данные, lo, 0);
    if (hi!=0) {
        результат[x.данные.length+1] = multibyteMulдобавь!('+')(результат[1..x.данные.length+1],
            x.данные, hi, 0);
    }
    return BigUint(removeLeadingZeros(результат));
}

/*  return x*y.
 */
static BigUint mul(BigUint x, BigUint y)
{
    if (y==0 || x == 0) return BigUint(ZERO);

    бцел длин = x.данные.length + y.данные.length;
    BigDigit [] результат = new BigDigit[длин];
    if (y.данные.length > x.данные.length) {
        mulInternal(результат, y.данные, x.данные);
    } else {
        if (x.данные[]==y.данные[]) squareInternal(результат, x.данные);
        else mulInternal(результат, x.данные, y.данные);
    }
    // the highest element could be zero, 
    // in which case we need в_ reduce the length
    return BigUint(removeLeadingZeros(результат));
}

// return x/y
static BigUint divInt(BigUint x, бцел y) {
    бцел [] результат = new BigDigit[x.данные.length];
    if ((y&(-y))==y) {
        assert(y!=0, "BigUint division by zero");
        // perfect power of 2
        бцел b = 0;
        for (;y!=1; y>>=1) {
            ++b;
        }
        многобайтСдвигП(результат, x.данные, b);
    } else {
        результат[] = x.данные[];
        бцел rem = многобайтПрисвойДеление(результат, y, 0);
    }
    return BigUint(removeLeadingZeros(результат));
}

// return x%y
static бцел modInt(BigUint x, бцел y) {
    assert(y!=0);
    if (y&(-y)==y) { // perfect power of 2        
        return x.данные[0]&(y-1);   
    } else {
        // horribly inefficient - malloc, копируй, & сохрани are unnecessary.
        бцел [] wasteful = new BigDigit[x.данные.length];
        wasteful[] = x.данные[];
        бцел rem = многобайтПрисвойДеление(wasteful, y, 0);
        delete wasteful;
        return rem;
    }   
}

// return x/y
static BigUint div(BigUint x, BigUint y)
{
    if (y.данные.length > x.данные.length) return BigUint(ZERO);
    if (y.данные.length == 1) return divInt(x, y.данные[0]);
    BigDigit [] результат = new BigDigit[x.данные.length - y.данные.length + 1];
    divModInternal(результат, пусто, x.данные, y.данные);
    return BigUint(removeLeadingZeros(результат));
}

// return x%y
static BigUint mod(BigUint x, BigUint y)
{
    if (y.данные.length > x.данные.length) return x;
    if (y.данные.length == 1) {
        BigDigit [] результат = new BigDigit[1];
        результат[0] = modInt(x, y.данные[0]);
        return BigUint(результат);
    }
    BigDigit [] результат = new BigDigit[x.данные.length - y.данные.length + 1];
    BigDigit [] rem = new BigDigit[y.данные.length];
    divModInternal(результат, rem, x.данные, y.данные);
    return BigUint(removeLeadingZeros(rem));
}

/**
 * Return a BigUint which is x raised в_ the power of y.
 * Метод: Powers of 2 are removed из_ x, then left-в_-right binary
 * exponentiation is used.
 * Memory allocation is minimized: at most one temporary BigUint is used.
 */
static BigUint степ(BigUint x, бдол y)
{
    // Deal with the degenerate cases first.
    if (y==0) return BigUint(ONE);
    if (y==1) return x;
    if (x==0 || x==1) return x;
   
    BigUint результат;
     
    // Simplify, step 1: Удали все powers of 2.
    бцел firstnonzero = firstNonZeroDigit(x.данные);
    
    // See if x can сейчас fit преобр_в a single цифра.            
    бул singledigit = ((x.данные.length - firstnonzero) == 1);
    // If да, then x0 is that цифра, and we must calculate x0 ^^ y0.
    BigDigit x0 = x.данные[firstnonzero];
    assert(x0 !=0);
    т_мера xlength = x.данные.length;
    бдол y0;
    бцел evenbits = 0; // число of even биты in the bottom of x
    while (!(x0 & 1)) { x0 >>= 1; ++evenbits; }
    
    if ((x.данные.length- firstnonzero == 2)) {
        // Check for a single цифра strдобавьling a цифра boundary
        BigDigit x1 = x.данные[firstnonzero+1];
        if ((x1 >> evenbits) == 0) {
            x0 |= (x1 << (BigDigit.sizeof * 8 - evenbits));
            singledigit = да;
        }
    }
    бцел evenshiftbits = 0; // Total powers of 2 в_ shift by, at the конец
    
    // Simplify, step 2: For singledigits, see if we can trivially reduce y
    
    BigDigit finalMultИПlier = 1;
   
    if (singledigit) {
        // x fits преобр_в a single цифра. Raise it в_ the highest power we can
        // that still fits преобр_в a single цифра, then reduce the exponent accordingly.
        // We're quite likely в_ have a resопрual multИПly at the конец.
        // For example, 10^^100 = (((5^^13)^^7) * 5^^9) * 2^^100.
        // and 5^^13 still fits преобр_в a бцел.
        evenshiftbits  = cast(бцел)( (evenbits * y) & BIGDIGITSHIFTMASK);
        if (x0 == 1) { // Perfect power of 2
             результат = 1;
             return результат<< (evenbits + firstnonzero*BigDigit.sizeof)*y;
        } else {
            цел p = highestPowerBelowUintMax(x0);
            if (y <= p) { // Just do it with степ               
                результат = intpow(x0, y);
                if (evenshiftbits+firstnonzero == 0) return результат;
                return результат<< (evenbits + firstnonzero*BigDigit.sizeof)*y;
            }
            y0 = y/p;
            finalMultИПlier = intpow(x0, y - y0*p);
            x0 = intpow(x0, p);
        }
        xlength = 1;
    }

    // Check for перебор and размести результат буфер
    // Single цифра case: +1 is for final множитель, + 1 is for spare evenbits.
    бдол estimatelength = singledigit ? firstnonzero*y + y0*1 + 2 + ((evenbits*y) >> LG2BIGDIGITBITS) 
        : x.данные.length * y; // estimated length in BigDigits
    // (Estimated length can overestimate by a factor of 2, if x.данные.length ~ 2).
    if (estimatelength > бцел.max/(4*BigDigit.sizeof)) assert(0, "Overflow in BigInt.степ");
    
    // The результат буфер включает пространство for все the trailing zeros
    BigDigit [] resultBuffer = new BigDigit[cast(т_мера)estimatelength];
    
    // Do все the powers of 2!
    т_мера result_start = cast(т_мера)(firstnonzero*y + singledigit? ((evenbits*y) >> LG2BIGDIGITBITS) : 0);
    resultBuffer[0..result_start] = 0;
    BigDigit [] t1 = resultBuffer[result_start..$];
    BigDigit [] r1;
    
    if (singledigit) {
        r1 = t1[0..1];
        r1[0] = x0;
        y = y0;        
    } else {
        // It's not worth right shifting by evenbits unless we also shrink the length after each 
        // multИПly or squaring operation. That might still be worthwhile for large y.
        r1 = t1[0..x.данные.length - firstnonzero];
        r1[0..$] = x.данные[firstnonzero..$];
    }    

    if (y>1) {    // Набор r1 = r1 ^^ y.
         
        // The secondary буфер only needs пространство for the multИПlication results    
        BigDigit [] secondaryBuffer = new BigDigit[resultBuffer.length - result_start];
        BigDigit [] t2 = secondaryBuffer;
        BigDigit [] r2;
    
        цел shifts = 63; // num биты in a дол
        while(!(y & 0x8000_0000_0000_0000L)) {
            y <<= 1;
            --shifts;
        }
        y <<=1;
   
        while(y!=0) {
            r2 = t2[0 .. r1.length*2];
            squareInternal(r2, r1);
            if (y & 0x8000_0000_0000_0000L) {           
                r1 = t1[0 .. r2.length + xlength];
                if (xlength == 1) {
                    r1[$-1] = многобайтУмнож(r1[0 .. $-1], r2, x0, 0);
                } else {
                    mulInternal(r1, r2, x.данные);
                }
            } else {
                r1 = t1[0 .. r2.length];
                r1[] = r2[];
            }
            y <<=1;
            shifts--;
        }
        while (shifts>0) {
            r2 = t2[0 .. r1.length * 2];
            squareInternal(r2, r1);
            r1 = t1[0 .. r2.length];
            r1[] = r2[];
            --shifts;
        }
    }   

    if (finalMultИПlier!=1) {
        BigDigit carry = многобайтУмнож(r1, r1, finalMultИПlier, 0);
        if (carry) {
            r1 = t1[0 .. r1.length + 1];
            r1[$-1] = carry;
        }
    }
    if (evenshiftbits) {
        BigDigit carry = многобайтСдвигЛ(r1, r1, evenshiftbits);
        if (carry!=0) {
            r1 = t1[0 .. r1.length + 1];
            r1[$ - 1] = carry;
        }
    }    
    while(r1[$ - 1]==0) {
        r1=r1[0 .. $ - 1];
    }
    результат.данные = resultBuffer[0 .. result_start + r1.length];
    return результат;
}

} // конец BigUint


// Удали leading zeros из_ x, в_ restore the BigUint invariant
BigDigit[] removeLeadingZeros(BigDigit [] x)
{
    т_мера k = x.length;
    while(k>1 && x[k - 1]==0) --k;
    return x[0 .. k];
}

debug(UnitTest) {
unittest {
// Bug 1650.
   BigUint r = BigUint([5]);
   BigUint t = BigUint([7]);
   BigUint s = BigUint.mod(r, t);
   assert(s==5);
}
}



debug (UnitTest) {
// Pow tests
unittest {
    BigUint r, s;
    r.fromHexString("80000000_00000001");
    s = BigUint.степ(r, 5);
    r.fromHexString("08000000_00000000_50000000_00000001_40000000_00000002_80000000"
      ~ "_00000002_80000000_00000001");
    assert(s == r);
    s = 10;
    s = BigUint.степ(s, 39);
    r.fromDecimalString("1000000000000000000000000000000000000000");
    assert(s == r);
    r.fromHexString("1_E1178E81_00000000");
    s = BigUint.степ(r, 15); // Regression тест: this used в_ перебор Массив bounds

}

// Radix conversion tests
unittest {   
    BigUint r;
    r.fromHexString("1_E1178E81_00000000");
    assert(r.toHexString(0, '_', 0) == "1_E1178E81_00000000");
    assert(r.toHexString(0, '_', 20) == "0001_E1178E81_00000000");
    assert(r.toHexString(0, '_', 16+8) == "00000001_E1178E81_00000000");
    assert(r.toHexString(0, '_', 16+9) == "0_00000001_E1178E81_00000000");
    assert(r.toHexString(0, '_', 16+8+8) ==   "00000000_00000001_E1178E81_00000000");
    assert(r.toHexString(0, '_', 16+8+8+1) ==      "0_00000000_00000001_E1178E81_00000000");
    assert(r.toHexString(0, '_', 16+8+8+1, ' ') == "                  1_E1178E81_00000000");
    assert(r.toHexString(0, 0, 16+8+8+1) == "00000000000000001E1178E8100000000");
    r = 0;
    assert(r.toHexString(0, '_', 0) == "0");
    assert(r.toHexString(0, '_', 7) == "0000000");
    assert(r.toHexString(0, '_', 7, ' ') == "      0");
    assert(r.toHexString(0, '#', 9) == "0#00000000");
    assert(r.toHexString(0, 0, 9) == "000000000");
    
}
}

private:

// works for any тип
T intpow(T)(T x, бдол n)
{
    T p;

    switch (n)
    {
    case 0:
        p = 1;
        break;

    case 1:
        p = x;
        break;

    case 2:
        p = x * x;
        break;

    default:
        p = 1;
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


//  returns the maximum power of x that will fit in a бцел.
цел highestPowerBelowUintMax(бцел x)
{
     assert(x>1);     
     const ббайт [22] maxpwr = [31, 20, 15, 13, 12, 11, 10, 10, 9, 9,
                                 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7];
     if (x<24) return maxpwr[x-2]; 
     if (x<41) return 6;
     if (x<85) return 5;
     if (x<256) return 4;
     if (x<1626) return 3;
     if (x<65536) return 2;
     return 1;
}

//  returns the maximum power of x that will fit in a бдол.
цел highestPowerBelowUlongMax(бцел x)
{
     assert(x>1);     
     const ббайт [39] maxpwr = [63, 40, 31, 27, 24, 22, 21, 20, 19, 18,
                                 17, 17, 16, 16, 15, 15, 15, 15, 14, 14,
                                 14, 14, 13, 13, 13, 13, 13, 13, 13, 12,
                                 12, 12, 12, 12, 12, 12, 12, 12, 12];
     if (x<41) return maxpwr[x-2]; 
     if (x<57) return 11;
     if (x<85) return 10;
     if (x<139) return 9;
     if (x<256) return 8;
     if (x<566) return 7;
     if (x<1626) return 6;
     if (x<7132) return 5;
     if (x<65536) return 4;
     if (x<2642246) return 3;
     return 2;
} 

version(UnitTest) {
цел slowHighestPowerBelowUintMax(бцел x)
{
     цел pwr = 1;
     for (бдол q = x;x*q < cast(бдол)бцел.max; ) {
         q*=x; ++pwr;
     } 
     return pwr;
}

unittest {
  assert(highestPowerBelowUintMax(10)==9);
  for (цел k=82; k<88; ++k) {assert(highestPowerBelowUintMax(k)== slowHighestPowerBelowUintMax(k)); }
}
}


/*  General unsigned subtraction routine for bigints.
 *  Sets результат = x - y. If the результат is negative, negative will be да.
 */
BigDigit [] sub(BigDigit[] x, BigDigit[] y, бул *negative)
{
    if (x.length == y.length) {
        // There's a possibility of cancellation, if x and y are almost equal.
        цел последний = highestDifferentDigit(x, y);
        BigDigit [] результат = new BigDigit[последний+1];
        if (x[последний] < y[последний]) { // we know результат is negative
            multibyteSub(результат[0..последний+1], y[0..последний+1], x[0..последний+1], 0);
            *negative = да;
        } else { // positive or zero результат
            multibyteSub(результат[0..последний+1], x[0..последний+1], y[0..последний+1], 0);
            *negative = нет;
        }
        while (результат.length > 1 && результат[$-1] == 0) {
            результат = результат[0..$-1];
        }
        return результат;
    }
    // Lengths are different
    BigDigit [] large, small;
    if (x.length < y.length) {
        *negative = да;
        large = y; small = x;
    } else {
        *negative = нет;
        large = x; small = y;
    }
    
    BigDigit [] результат = new BigDigit[large.length];
    BigDigit carry = multibyteSub(результат[0..small.length], large[0..small.length], small, 0);
    результат[small.length..$] = large[small.length..$];
    if (carry) {
        многобайтИнкрПрисвой!('-')(результат[small.length..$], carry);
    }
    while (результат.length > 1 && результат[$-1] == 0) {
        результат = результат[0..$-1];
    }    
    return результат;
}


// return a + b
BigDigit [] добавь(BigDigit[] a, BigDigit [] b) {
    BigDigit [] x, y;
    if (a.length<b.length) { x = b; y = a; } else { x = a; y = b; }
    // сейчас we know x.length > y.length
    // создай результат. добавь 1 in case it overflows
    BigDigit [] результат = new BigDigit[x.length + 1];
    
    BigDigit carry = multibyteдобавь(результат[0..y.length], x[0..y.length], y, 0);
    if (x.length != y.length){
        результат[y.length..$-1]= x[y.length..$];
        carry  = многобайтИнкрПрисвой!('+')(результат[y.length..$-1], carry);
    }
    if (carry) {
        результат[$-1] = carry;
        return результат;
    } else return результат[0..$-1];
}
    
/**  return x + y
 */
BigDigit [] добавьInt(BigDigit[] x, бдол y)
{
    бцел hi = cast(бцел)(y >>> 32);
    бцел lo = cast(бцел)(y& 0xFFFF_FFFF);
    бцел длин = x.length;
    if (x.length < 2 && hi!=0) ++длин;
    BigDigit [] результат = new BigDigit[длин+1];
    результат[0..x.length] = x[]; 
    if (x.length < 2 && hi!=0) { результат[1]=hi; hi=0; }	
    бцел carry = многобайтИнкрПрисвой!('+')(результат[0..$-1], lo);
    if (hi!=0) carry += многобайтИнкрПрисвой!('+')(результат[1..$-1], hi);
    if (carry) {
        результат[$-1] = carry;
        return результат;
    } else return результат[0..$-1];
}

/** Return x - y.
 *  x must be greater than y.
 */  
BigDigit [] subInt(BigDigit[] x, бдол y)
{
    бцел hi = cast(бцел)(y >>> 32);
    бцел lo = cast(бцел)(y & 0xFFFF_FFFF);
    BigDigit [] результат = new BigDigit[x.length];
    результат[] = x[];
    многобайтИнкрПрисвой!('-')(результат[], lo);
    if (hi) многобайтИнкрПрисвой!('-')(результат[1..$], hi);
    if (результат[$-1]==0) return результат[0..$-1];
    else return результат; 
}

/**  General unsigned multИПly routine for bigints.
 *  Sets результат = x * y.
 *
 *  The length of y must not be larger than the length of x.
 *  Different algorithms are used, depending on the lengths of x and y.
 *  TODO: "Modern Computer Arithmetic" suggests the OddEvenKaratsuba algorithm for the
 *  unbalanced case. (But I doubt it would be faster in practice).
 *  
 */
проц mulInternal(BigDigit[] результат, BigDigit[] x, BigDigit[] y)
{
    assert( результат.length == x.length + y.length );
    assert( y.length > 0 );
    assert( x.length >= y.length);
    if (y.length <= KARATSUBALIMIT) {
        // Small множитель, we'll just use the asm classic multИПly.
        if (y.length==1) { // Trivial case, no cache effects в_ worry about
            результат[x.length] = многобайтУмнож(результат[0..x.length], x, y[0], 0);
            return;
        }
        if (x.length + y.length < CACHELIMIT) return mulSimple(результат, x, y);
        
        // If x is so big that it won't fit преобр_в the cache, we divопрe it преобр_в chunks            
        // Every chunk must be greater than y.length.
        // We сделай the first chunk shorter, if necessary, в_ ensure this.
        
        бцел chunksize = CACHELIMIT/y.length;
        бцел resопрual  =  x.length % chunksize;
        if (resопрual < y.length) { chunksize -= y.length; }
        // Use schoolbook multИПly.
        mulSimple(результат[0 .. chunksize + y.length], x[0..chunksize], y);
        бцел готово = chunksize;        
    
        while (готово < x.length) {            
            // результат[готово .. готово+ylength] already есть a значение.
            chunksize = (готово + (CACHELIMIT/y.length) < x.length) ? (CACHELIMIT/y.length) :  x.length - готово;
            BigDigit [KARATSUBALIMIT] partial;
            partial[0..y.length] = результат[готово..готово+y.length];
            mulSimple(результат[готово..готово+chunksize+y.length], x[готово..готово+chunksize], y);
            добавьAssignSimple(результат[готово..готово+chunksize + y.length], partial[0..y.length]);
            готово += chunksize;
        }
        return;
    }
    
    бцел half = (x.length >> 1) + (x.length & 1);
    if (2*y.length*y.length <= x.length*x.length) {
        // UNBALANCED MULTИПLY
        // Use school multИПly в_ cut преобр_в quasi-squares of Karatsuba-размер
        // or larger. The ratio of the two sопрes of the 'square' must be 
        // between 1.414:1 and 1:1. Use Karatsuba on each chunk. 
        //
        // For maximum performance, we want the ratio в_ be as закрой в_ 
        // 1:1 as possible. To achieve this, we can either pad x or y.
        // The best choice depends on the modulus x%y.       
        бцел numchunks = x.length / y.length;
        бцел chunksize = y.length;
        бцел extra =  x.length % y.length;
        бцел maxchunk = chunksize + extra;
        бул pдобавьingY; // да = we're паддинг Y, нет = we're паддинг X.
        if (extra * extra * 2 < y.length*y.length) {
            // The leftover bit is small enough that it should be incorporated
            // in the existing chunks.            
            // Make все the chunks a tiny bit bigger
            // (We're паддинг y with zeros)
            chunksize += extra / cast(дво)numchunks;
            extra = x.length - chunksize*numchunks;
            // there will probably be a few left over.
            // Every chunk will either have размер chunksize, or chunksize+1.
            maxchunk = chunksize + 1;
            pдобавьingY = да;
            assert(chunksize + extra + chunksize *(numchunks-1) == x.length );
        } else  {
            // the extra bit is large enough that it's worth making a new chunk.
            // (This means we're паддинг x with zeros, when doing the first one).
            maxchunk = chunksize;
            ++numchunks;
            pдобавьingY = нет;
            assert(extra + chunksize *(numchunks-1) == x.length );
        }
        // We сделай the буфер a bit bigger so we have пространство for the partial sums.
        BigDigit [] scratchbuff = new BigDigit[karatsubaRequiredBuffSize(maxchunk) + y.length];
        BigDigit [] partial = scratchbuff[$ - y.length .. $];
        бцел готово; // как much of X have we готово so far?
        дво resопрual = 0;
        if (pдобавьingY) {
            // If the first chunk is bigger, do it first. We're паддинг y. 
          mulKaratsuba(результат[0 .. y.length + chunksize + (extra > 0 ? 1 : 0 )], 
                        x[0 .. chunksize + (extra>0?1:0)], y, scratchbuff);
          готово = chunksize + (extra > 0 ? 1 : 0);
          if (extra) --extra;
        } else { // We're паддинг X. Начало with the extra bit.
            mulKaratsuba(результат[0 .. y.length + extra], y, x[0..extra], scratchbuff);
            готово = extra;
            extra = 0;
        }
        auto basechunksize = chunksize;
        while (готово < x.length) {
            chunksize = basechunksize + (extra > 0 ? 1 : 0);
            if (extra) --extra;
            partial[] = результат[готово .. готово+y.length];
            mulKaratsuba(результат[готово .. готово + y.length + chunksize], 
                       x[готово .. готово+chunksize], y, scratchbuff);
            добавьAssignSimple(результат[готово .. готово + y.length + chunksize], partial);
            готово += chunksize;
        }
        delete scratchbuff;
    } else {
        // Balanced. Use Karatsuba directly.
        BigDigit [] scratchbuff = new BigDigit[karatsubaRequiredBuffSize(x.length)];
        mulKaratsuba(результат, x, y, scratchbuff);
        delete scratchbuff;
    }
}

/**  General unsigned squaring routine for BigInts.
 *   Sets результат = x*x.
 *   NOTE: If the highest half-цифра of x is zero, the highest цифра of результат will
 *   also be zero.
 */
проц squareInternal(BigDigit[] результат, BigDigit[] x)
{
  // TODO: Squaring is potentially half a multИПly, plus добавь the squares of 
  // the diagonal elements.
  assert(результат.length == 2*x.length);
  if (x.length <= KARATSUBASQUARELIMIT) {
      if (x.length==1) {
         результат[1] = многобайтУмнож(результат[0..1], x, x[0], 0);
         return;
      }
      return squareSimple(результат, x);
  }
  // The nice thing about squaring is that it always stays balanced
  BigDigit [] scratchbuff = new BigDigit[karatsubaRequiredBuffSize(x.length)];
  squareKaratsuba(результат, x, scratchbuff);
  delete scratchbuff;  
}


import core.BitManip : bsr;

/// if remainder is пусто, only calculate quotient.
проц divModInternal(BigDigit [] quotient, BigDigit[] remainder, BigDigit [] u, BigDigit [] v)
{
    assert(quotient.length == u.length - v.length + 1);
    assert(remainder==пусто || remainder.length == v.length);
    assert(v.length > 1);
    assert(u.length >= v.length);
    
    // Normalize by shifting v left just enough so that
    // its high-order bit is on, and shift u left the
    // same amount. The highest bit of u will never be установи.
   
    BigDigit [] vn = new BigDigit[v.length];
    BigDigit [] un = new BigDigit[u.length + 1];
    // How much в_ left shift v, so that its MSB is установи.
    бцел s = BIGDIGITSHIFTMASK - bsr(v[$-1]);
    if (s!=0) {
        многобайтСдвигЛ(vn, v, s);        
        un[$-1] = многобайтСдвигЛ(un[0..$-1], u, s);
    } else {
        vn[] = v[];
        un[0..$-1] = u[];
        un[$-1] = 0;
    }
    if (quotient.length<FASTDIVLIMIT) {
        schoolbookDivMod(quotient, un, vn);
    } else {
        fastDivMod(quotient, un, vn);        
    }
    
    // Unnormalize remainder, if required.
    if (remainder != пусто) {
        if (s == 0) remainder[] = un[0..vn.length];
        else многобайтСдвигП(remainder, un[0..vn.length+1], s);
    }
    delete un;
    delete vn;
}

debug(UnitTest)
{
unittest {
    бцел [] u = [0, 0xFFFF_FFFE, 0x8000_0000];
    бцел [] v = [0xFFFF_FFFF, 0x8000_0000];
    бцел [] q = new бцел[u.length - v.length + 1];
    бцел [] r = new бцел[2];
    divModInternal(q, r, u, v);
    assert(q[]==[0xFFFF_FFFFu, 0]);
    assert(r[]==[0xFFFF_FFFFu, 0x7FFF_FFFF]);
    u = [0, 0xFFFF_FFFE, 0x8000_0001];
    v = [0xFFFF_FFFF, 0x8000_0000];
    divModInternal(q, r, u, v);
}
}

private:
// Converts a big бцел в_ a hexadecimal ткст.
//
// Optionally, a разделитель character (eg, an underscore) may be добавьed between
// every 8 digits.
// buff.length must be данные.length*8 if разделитель is zero,
// or данные.length*9 if разделитель is non-zero. It will be completely filled.
сим [] bigбцелToHex(сим [] buff, BigDigit [] данные, сим разделитель=0)
{
    цел x=0;
    for (цел i=данные.length - 1; i>=0; --i) {
        toHexZeroPдобавьed(buff[x..x+8], данные[i]);
        x+=8;
        if (разделитель) {
            if (i>0) buff[x] = разделитель;
            ++x;
        }
    }
    return buff;
}

/** Convert a big бцел преобр_в a decimal ткст.
 *
 * Параметры:
 *  данные    The bigбцел в_ be преобразованый. Will be destroyed.
 *  buff    The destination буфер for the decimal ткст. Must be
 *          large enough в_ сохрани the результат, включая leading zeros.
 *          Will be filled backwards, starting из_ buff[$-1].
 *
 * buff.length must be >= (данные.length*32)/лог2(10) = 9.63296 * данные.length.
 * Возвращает:
 *    the lowest индекс of buff which was used.
 */
цел bigбцелToDecimal(сим [] buff, BigDigit [] данные){
    цел sofar = buff.length;
    // Might be better в_ divопрe by (10^38/2^32) since that gives 38 digits for
    // the price of 3 divisions and a shr; this version only gives 27 digits
    // for 3 divisions.
    while(данные.length>1) {
        бцел rem = многобайтПрисвойДеление(данные, 10_0000_0000, 0);
        itoaZeroPдобавьed(buff[sofar-9 .. sofar], rem);
        sofar -= 9;
        if (данные[$-1]==0 && данные.length>1) {
            данные.length = данные.length - 1;
        }
    }
    itoaZeroPдобавьed(buff[sofar-10 .. sofar], данные[0]);
    sofar -= 10;
    // and strip off the leading zeros
    while(sofar!= buff.length-1 && buff[sofar] == '0') sofar++;    
    return sofar;
}

/** Convert a decimal ткст преобр_в a big бцел.
 *
 * Параметры:
 *  данные    The bigбцел в_ be принять the результат. Must be large enough в_ 
 *          сохрани the результат.
 *  s       The decimal ткст. May contain 0..9, or _. Will be preserved.
 *
 * The required length for the destination буфер is slightly less than
 *  1 + s.length/лог2(10) = 1 + s.length/3.3219.
 *
 * Возвращает:
 *    the highest индекс of данные which was used.
 */
цел bigбцелFromDecimal(BigDigit [] данные, сим [] s) {
    // Convert в_ основа 1e19 = 10_000_000_000_000_000_000.
    // (this is the largest power of 10 that will fit преобр_в a дол).
    // The length will be less than 1 + s.length/лог2(10) = 1 + s.length/3.3219.
    // 485 биты will only just fit преобр_в 146 decimal digits.
    бцел lo = 0;
    бцел x = 0;
    бдол y = 0;
    бцел hi = 0;
    данные[0] = 0; // initially число is 0.
    данные[1] = 0;    
   
    for (цел i= (s[0]=='-' || s[0]=='+')? 1 : 0; i<s.length; ++i) {            
        if (s[i] == '_') continue;
        x *= 10;
        x += s[i] - '0';
        ++lo;
        if (lo==9) {
            y = x;
            x = 0;
        }
        if (lo==18) {
            y *= 10_0000_0000;
            y += x;
            x = 0;
        }
        if (lo==19) {
            y *= 10;
            y += x;
            x = 0;
            // MultИПly existing число by 10^19, then добавь y1.
            if (hi>0) {
                данные[hi] = многобайтУмнож(данные[0..hi], данные[0..hi], 1220703125*2, 0); // 5^13*2 = 0x9184_E72A
                ++hi;
                данные[hi] = многобайтУмнож(данные[0..hi], данные[0..hi], 15625*262144, 0); // 5^6*2^18 = 0xF424_0000
                ++hi;
            } else hi = 2;
            бцел c = многобайтИнкрПрисвой!('+')(данные[0..hi], cast(бцел)(y&0xFFFF_FFFF));
            c += многобайтИнкрПрисвой!('+')(данные[1..hi], cast(бцел)(y>>32));
            if (c!=0) {
                данные[hi]=c;
                ++hi;
            }
            y = 0;
            lo = 0;
        }
    }
    // Сейчас установи y = все remaining digits.
    if (lo>=18) {
    } else if (lo>=9) {
        for (цел k=9; k<lo; ++k) y*=10;
        y+=x;
    } else {
        for (цел k=0; k<lo; ++k) y*=10;
        y+=x;
    }
    if (lo!=0) {
        if (hi==0)  {
            *cast(бдол *)(&данные[hi]) = y;
            hi=2;
        } else {
            while (lo>0) {
                бцел c = многобайтУмнож(данные[0..hi], данные[0..hi], 10, 0);
                if (c!=0) { данные[hi]=c; ++hi; }                
                --lo;
            }
            бцел c = многобайтИнкрПрисвой!('+')(данные[0..hi], cast(бцел)(y&0xFFFF_FFFF));
            if (y>0xFFFF_FFFFL) {
                c += многобайтИнкрПрисвой!('+')(данные[1..hi], cast(бцел)(y>>32));
            }
            if (c!=0) { данные[hi]=c; ++hi; }
          //  hi+=2;
        }
    }
    if (hi>1 && данные[hi-1]==0) --hi;
    return hi;
}


private:
// ------------------------
// These in-place functions are only for internal use; they are incompatible
// with COW.

// Classic 'schoolbook' multИПlication.
проц mulSimple(BigDigit[] результат, BigDigit [] left, BigDigit[] right)
in {    
    assert(результат.length == left.length + right.length);
    assert(right.length>1);
}
body {
    результат[left.length] = многобайтУмнож(результат[0..left.length], left, right[0], 0);   
    многобайтУмножАккум(результат[1..$], left, right[1..$]);
}

// Classic 'schoolbook' squaring
проц squareSimple(BigDigit[] результат, BigDigit [] x)
in {    
    assert(результат.length == 2*x.length);
    assert(x.length>1);
}
body {
    многобайтПлощадь(результат, x);
}


// добавь two бцелs of possibly different lengths. Результат must be as дол
// as the larger length.
// Returns carry (0 or 1).
бцел добавьSimple(BigDigit [] результат, BigDigit [] left, BigDigit [] right)
in {
    assert(результат.length == left.length);
    assert(left.length >= right.length);
    assert(right.length>0);
}
body {
    бцел carry = multibyteдобавь(результат[0..right.length],
            left[0..right.length], right, 0);
    if (right.length < left.length) {
        результат[right.length..left.length] = left[right.length .. $];            
        carry = многобайтИнкрПрисвой!('+')(результат[right.length..$], carry);
    }
    return carry;
}

//  результат = left - right
// returns carry (0 or 1)
BigDigit subSimple(BigDigit [] результат, BigDigit [] left, BigDigit [] right)
in {
    assert(результат.length == left.length);
    assert(left.length >= right.length);
    assert(right.length>0);
}
body {
    BigDigit carry = multibyteSub(результат[0..right.length],
            left[0..right.length], right, 0);
    if (right.length < left.length) {
        результат[right.length..left.length] = left[right.length .. $];            
        carry = многобайтИнкрПрисвой!('-')(результат[right.length..$], carry);
    } //else if (результат.length==left.length+1) { результат[$-1] = carry; carry=0; }
    return carry;
}


/* результат = результат - right 
 * Returns carry = 1 if результат was less than right.
*/
BigDigit subAssignSimple(BigDigit [] результат, BigDigit [] right)
{
    assert(результат.length >= right.length);
    бцел c = multibyteSub(результат[0..right.length], результат[0..right.length], right, 0); 
    if (c && результат.length > right.length) c = многобайтИнкрПрисвой!('-')(результат[right.length .. $], c);
    return c;
}

/* результат = результат + right
*/
BigDigit добавьAssignSimple(BigDigit [] результат, BigDigit [] right)
{
    assert(результат.length >= right.length);
    бцел c = multibyteдобавь(результат[0..right.length], результат[0..right.length], right, 0);
    if (c && результат.length > right.length) {
       c = многобайтИнкрПрисвой!('+')(результат[right.length .. $], c);
    }
    return c;
}

/* performs результат += wantSub? - right : right;
*/
BigDigit добавьOrSubAssignSimple(BigDigit [] результат, BigDigit [] right, бул wantSub)
{
  if (wantSub) return subAssignSimple(результат, right);
  else return добавьAssignSimple(результат, right);
}


// return да if x<y, consопрering leading zeros
бул less(BigDigit[] x, BigDigit[] y)
{
    assert(x.length >= y.length);
    бцел k = x.length-1;
    while(x[k]==0 && k>=y.length) --k; 
    if (k>=y.length) return нет;
    while (k>0 && x[k]==y[k]) --k;
    return x[k] < y[k];
}

// Набор результат = абс(x-y), return да if результат is negative(x<y), нет if x<=y.
бул inplaceSub(BigDigit[] результат, BigDigit[] x, BigDigit[] y)
{
    assert(результат.length == (x.length >= y.length) ? x.length : y.length);
    
    т_мера minlen;
    бул negative;
    if (x.length >= y.length) {
        minlen = y.length;
        negative = less(x, y);
    } else {
       minlen = x.length;
       negative = !less(y, x);
    }
    BigDigit[] large, small;
    if (negative) { large = y; small=x; } else { large=x; small=y; }
       
    BigDigit carry = multibyteSub(результат[0..minlen], large[0..minlen], small[0..minlen], 0);
    if (x.length != y.length) {
        результат[minlen..large.length]= large[minlen..$];
        результат[large.length..$] = 0;
        if (carry) многобайтИнкрПрисвой!('-')(результат[minlen..$], carry);
    }
    return negative;
}

/* Determine как much пространство is required for the temporaries
 * when performing a Karatsuba multИПlication. 
 */
бцел karatsubaRequiredBuffSize(бцел xlen)
{
    return xlen <= KARATSUBALIMIT ? 0 : 2*xlen; // - KARATSUBALIMIT+2;
}

/* Sets результат = x*y, using Karatsuba multИПlication.
* x must be longer or equal в_ y.
* Valопр only for balanced multИПlies, where x is not shorter than y.
* It is superior в_ schoolbook multИПlication if and only if 
*    квкор(2)*y.length > x.length > y.length.
* Karatsuba multИПlication is O(n^1.59), whereas schoolbook is O(n^2)
* The maximum allowable length of x and y is бцел.max; but better algorithms
* should be used far before that length is reached.
* Параметры:
* scratchbuff      An Массив дол enough в_ сохрани все the temporaries. Will be destroyed.
*/
проц mulKaratsuba(BigDigit [] результат, BigDigit [] x, BigDigit[] y, BigDigit [] scratchbuff)
{
    assert(x.length >= y.length);
	  assert(результат.length < бцел.max, "Operands too large");
    assert(результат.length == x.length + y.length);
    if (x.length <= KARATSUBALIMIT) {
        return mulSimple(результат, x, y);
    }
    // Must be almost square (otherwise, a schoolbook iteration is better)
    assert(2L * y.length * y.length > (x.length-1) * (x.length-1),
        "Bigint Internal Ошибка: Asymmetric Karatsuba");
        
    // The subtractive version of Karatsuba multИПly uses the following результат:
    // (Nx1 + x0)*(Ny1 + y0) = (N*N)*x1y1 + x0y0 + N * (x0y0 + x1y1 - mопр)
    // where mопр = (x0-x1)*(y0-y1)
    // requiring 3 multИПlies of length N, instead of 4.
    // The advantage of the subtractive over the аддитивный version is that
    // the mопр multИПly cannot exceed length N. But there are subtleties:
    // (x0-x1),(y0-y1) may be negative or zero. To keep it simple, we 
    // retain все of the leading zeros in the subtractions
    
    // half length, округли up.
    бцел half = (x.length >> 1) + (x.length & 1);
    
    BigDigit [] x0 = x[0 .. half];
    BigDigit [] x1 = x[half .. $];    
    BigDigit [] y0 = y[0 .. half];
    BigDigit [] y1 = y[half .. $];
    BigDigit [] mопр = scratchbuff[0 .. half*2];
    BigDigit [] newscratchbuff = scratchbuff[half*2 .. $];
    BigDigit [] resultLow = результат[0 .. 2*half];
    BigDigit [] resultHigh = результат[2*half .. $];
     // initially use результат в_ сохрани temporaries
    BigDigit [] xdiff= результат[0 .. half];
    BigDigit [] ydiff = результат[half .. half*2];
    
    // First, we calculate mопр, and sign of mопр
    бул mопрNegative = inplaceSub(xdiff, x0, x1)
                      ^ inplaceSub(ydiff, y0, y1);
    mulKaratsuba(mопр, xdiff, ydiff, newscratchbuff);
    
    // Low half of результат gets x0 * y0. High half gets x1 * y1
  
    mulKaratsuba(resultLow, x0, y0, newscratchbuff);
    
    if (2L * y1.length * y1.length < x1.length * x1.length) {
        // an asymmetric situation есть been создан.
        // Worst case is if x:y = 1.414 : 1, then x1:y1 = 2.41 : 1.
        // Applying one schoolbook multИПly gives us two pieces each 1.2:1
        if (y1.length <= KARATSUBALIMIT) {
            mulSimple(resultHigh, x1, y1);
        } else {
            // divопрe x1 in two, then use schoolbook multИПly on the two pieces.
            бцел quarter = (x1.length >> 1) + (x1.length & 1);
            бул ysmaller = (quarter >= y1.length);
            mulKaratsuba(resultHigh[0..quarter+y1.length], ysmaller ? x1[0..quarter] : y1, 
                ysmaller ? y1 : x1[0..quarter], newscratchbuff);
            // Save the часть which will be overwritten.
            бул ysmaller2 = ((x1.length - quarter) >= y1.length);
            newscratchbuff[0..y1.length] = resultHigh[quarter..quarter + y1.length];
            mulKaratsuba(resultHigh[quarter..$], ysmaller2 ? x1[quarter..$] : y1, 
                ysmaller2 ? y1 : x1[quarter..$], newscratchbuff[y1.length..$]);

            resultHigh[quarter..$].добавьAssignSimple(newscratchbuff[0..y1.length]);                
        }
    } else mulKaratsuba(resultHigh, x1, y1, newscratchbuff);

    /* We сейчас have результат = x0y0 + (N*N)*x1y1
       Before добавьing or subtracting mопр, we must calculate
       результат += N * (x0y0 + x1y1)    
       We can do this with three half-length добавьitions. With a = x0y0, b = x1y1:
                      aHI aLO
        +       aHI   aLO
        +       bHI   bLO
        +  bHI  bLO
        =  R3   R2    R1   R0        
        R1 = aHI + bLO + aLO
        R2 = aHI + bLO + aHI + carry_from_R1
        R3 = bHi + carry_from_R2
         Can also do use newscratchbuff:

//    It might actually be quicker в_ do it in two full-length добавьitions:        
//    newscratchbuff[2*half] = добавьSimple(newscratchbuff[0..2*half], результат[0..2*half], результат[2*half..$]);
//    добавьAssignSimple(результат[half..$], newscratchbuff[0..2*half+1]);
   */
    BigDigit[] R1 = результат[half..half*2];
    BigDigit[] R2 = результат[half*2..half*3];
    BigDigit[] R3 = результат[half*3..$];
    BigDigit c1 = multibyteдобавь(R2, R2, R1, 0); // c1:R2 = R2 + R1
    BigDigit c2 = multibyteдобавь(R1, R2, результат[0..half], 0); // c2:R1 = R2 + R1 + R0
    BigDigit c3 = добавьAssignSimple(R2, R3); // R2 = R2 + R1 + R3
    if (c1+c2) многобайтИнкрПрисвой!('+')(результат[half*2..$], c1+c2);
    if (c1+c3) многобайтИнкрПрисвой!('+')(R3, c1+c3);
     
    // And finally we вычти mопр
    добавьOrSubAssignSimple(результат[half..$], mопр, !mопрNegative);
}

проц squareKaratsuba(BigDigit [] результат, BigDigit [] x, BigDigit [] scratchbuff)
{
    // See mulKaratsuba for implementation comments.
    // Squaring is simpler, since it never gets asymmetric.
	  assert(результат.length < бцел.max, "Operands too large");
    assert(результат.length == 2*x.length);
    if (x.length <= KARATSUBASQUARELIMIT) {
        return squareSimple(результат, x);
    }
    // half length, округли up.
    бцел half = (x.length >> 1) + (x.length & 1);
    
    BigDigit [] x0 = x[0 .. half];
    BigDigit [] x1 = x[half .. $];    
    BigDigit [] mопр = scratchbuff[0 .. half*2];
    BigDigit [] newscratchbuff = scratchbuff[half*2 .. $];
     // initially use результат в_ сохрани temporaries
    BigDigit [] xdiff= результат[0 .. half];
    BigDigit [] ydiff = результат[half .. half*2];
    
    // First, we calculate mопр. We don't need its sign
    inplaceSub(xdiff, x0, x1);
    squareKaratsuba(mопр, xdiff, newscratchbuff);
  
    // Набор результат = x0x0 + (N*N)*x1x1
    squareKaratsuba(результат[0 .. 2*half], x0, newscratchbuff);
    squareKaratsuba(результат[2*half .. $], x1, newscratchbuff);

    /* результат += N * (x0x0 + x1x1)    
       Do this with three half-length добавьitions. With a = x0x0, b = x1x1:
        R1 = aHI + bLO + aLO
        R2 = aHI + bLO + aHI + carry_from_R1
        R3 = bHi + carry_from_R2
    */
    BigDigit[] R1 = результат[half..half*2];
    BigDigit[] R2 = результат[half*2..half*3];
    BigDigit[] R3 = результат[half*3..$];
    BigDigit c1 = multibyteдобавь(R2, R2, R1, 0); // c1:R2 = R2 + R1
    BigDigit c2 = multibyteдобавь(R1, R2, результат[0..half], 0); // c2:R1 = R2 + R1 + R0
    BigDigit c3 = добавьAssignSimple(R2, R3); // R2 = R2 + R1 + R3
    if (c1+c2) многобайтИнкрПрисвой!('+')(результат[half*2..$], c1+c2);
    if (c1+c3) многобайтИнкрПрисвой!('+')(R3, c1+c3);
     
    // And finally we вычти mопр, which is always positive
    subAssignSimple(результат[half..$], mопр);
}

/* Knuth's Algorithm D, as presented in 
 * H.S. Warren, "Hacker's Delight", добавьison-Wesley Professional (2002).
 * Also described in "Modern Computer Arithmetic" 0.2, Exercise 1.8.18.
 * Given u and v, calculates  quotient  = u/v, u = u%v.
 * v must be normalized (ie, the MSB of v must be 1).
 * The most significant words of quotient and u may be zero.
 * u[0..v.length] holds the remainder.
 */
проц schoolbookDivMod(BigDigit [] quotient, BigDigit [] u, in BigDigit [] v)
{
    assert(quotient.length == u.length - v.length);
    assert(v.length > 1);
    assert(u.length >= v.length);
    assert((v[$-1]&0x8000_0000)!=0);
    assert(u[$-1] < v[$-1]);
    // BUG: This код only works if BigDigit is бцел.
    бцел vhi = v[$-1];
    бцел vlo = v[$-2];
        
    for (цел j = u.length - v.length - 1; j >= 0; j--) {
        // Compute estimate of quotient[j],
        // qhat = (three most significant words of u)/(two most sig words of v).
        бцел qhat;               
        if (u[j + v.length] == vhi) {
            // uu/vhi could exceed бцел.max (it will be 0x8000_0000 or 0x8000_0001)
            qhat = бцел.max;
        } else {
            бцел ulo = u[j + v.length - 2];
version(Naked_D_InlineAsm_X86) {
            // Note: On DMD, this is only ~10% faster than the non-asm код. 
            бцел *p = &u[j + v.length - 1];
            asm {
                mov EAX, p;
                mov EDX, [EAX+4];
                mov EAX, [EAX];
                div dword ptr [vhi];
                mov qhat, EAX;
                mov ECX, EDX;
div3by2correction:                
                mul dword ptr [vlo]; // EDX:EAX = qhat * vlo
                sub EAX, ulo;
                sbb EDX, ECX;
                jbe div3by2done;
                mov EAX, qhat;
                dec EAX;
                mov qhat, EAX;
                добавь ECX, dword ptr [vhi];
                jnc div3by2correction;
div3by2done:    ;
}
            } else { // version(InlineAsm)
                бдол uu = (cast(бдол)(u[j+v.length]) << 32) | u[j+v.length-1];
                бдол bigqhat = uu / vhi;
                бдол rhat =  uu - bigqhat * vhi;
                qhat = cast(бцел)bigqhat;            
       again:
                if (cast(бдол)qhat*vlo > ((rhat<<32) + ulo)) {
                    --qhat;
                    rhat += vhi;
                    if (!(rhat & 0xFFFF_FFFF_0000_0000L)) goto again;
                }
            } // version(InlineAsm)
        } 
        // MultИПly and вычти.
        бцел carry = multibyteMulдобавь!('-')(u[j..j+v.length], v, qhat, 0);

        if (u[j+v.length] < carry) {
            // If we subtracted too much, добавь back
            --qhat;
            carry -= multibyteдобавь(u[j..j+v.length],u[j..j+v.length], v, 0);
        }
        quotient[j] = qhat;
        u[j + v.length] = u[j + v.length] - carry;
    }
}

private:
// TODO: Замени with a library вызов
проц itoaZeroPдобавьed(ткст вывод, бцел значение, цел radix = 10) {
    цел x = вывод.length - 1;
    for( ; x>=0; --x) {
        вывод[x]= cast(сим)(значение % radix + '0');
        значение /= radix;
    }
}

проц toHexZeroPдобавьed(ткст вывод, бцел значение) {
    цел x = вывод.length - 1;
    const сим [] hexDigits = "0123456789ABCDEF";
    for( ; x>=0; --x) {        
        вывод[x] = hexDigits[значение & 0xF];
        значение >>= 4;
    }
}

private:
    
// Returns the highest значение of i for which left[i]!=right[i],
// or 0 if left[]==right[]
цел highestDifferentDigit(BigDigit [] left, BigDigit [] right)
{
    assert(left.length == right.length);
    for (цел i=left.length-1; i>0; --i) {
        if (left[i]!=right[i]) return i;
    }
    return 0;
}

// Returns the lowest значение of i for which x[i]!=0.
цел firstNonZeroDigit(BigDigit[] x)
{
    цел k = 0;
    while (x[k]==0) {
        ++k;
        assert(k<x.length);
    }
    return k;
}

/* Calculate quotient and remainder of u / v using fast recursive division.
  v must be normalised, and must be at least half as дол as u.
  Given u and v, v normalised, calculates  quotient  = u/v, u = u%v.
  Algorithm is described in 
  - C. Burkinel and J. Ziegler, "Быстрый Recursive Division", MPI-I-98-1-022, 
    Max-Planck Institute fuer Informatik, (Oct 1998).
  - R.P. Brent and P. Zimmermann, "Modern Computer Arithmetic", 
    Версия 0.2, p. 26, (June 2008).
Возвращает:    
    u[0..v.length] is the remainder. u[v.length..$] is corrupted.
    черновик is temporary storage пространство, must be at least as дол as quotient.
*/
проц recursiveDivMod(BigDigit[] quotient, BigDigit[] u, in BigDigit[] v,
                     BigDigit[] черновик)
in {
    assert(quotient.length == u.length - v.length);
    assert(u.length <= 2 * v.length, "Asymmetric division"); // use основа-case division в_ получи it в_ this situation
    assert(v.length > 1);
    assert(u.length >= v.length);
    assert((v[$ - 1] & 0x8000_0000) != 0);
    assert(черновик.length >= quotient.length);
    
}
body {
    if(quotient.length < FASTDIVLIMIT) {
        return schoolbookDivMod(quotient, u, v);
    }
    бцел k = quotient.length >> 1;
    бцел h = k + v.length;

    recursiveDivMod(quotient[k .. $], u[2 * k .. $], v[k .. $], черновик);
    adjustRemainder(quotient[k .. $], u[k .. h], v, k,
            черновик[0 .. quotient.length]);
    recursiveDivMod(quotient[0 .. k], u[k .. h], v[k .. $], черновик);
    adjustRemainder(quotient[0 .. k], u[0 .. v.length], v, k,
            черновик[0 .. 2 * k]);
}

// rem -= quot * v[0..k].
// If would сделай rem negative, decrease quot until rem is >=0.
// Needs (quot.length * k) черновик пространство в_ сохрани the результат of the multИПly. 
проц adjustRemainder(BigDigit[] quot, BigDigit[] rem, in BigDigit[] v, цел k,
                     BigDigit[] черновик)
{
    assert(rem.length == v.length);
    mulInternal(черновик, quot, v[0 .. k]);
    бцел carry = subAssignSimple(rem, черновик);
    while(carry) {
        многобайтИнкрПрисвой!('-')(quot, 1); // quot--
        carry -= multibyteдобавь(rem, rem, v, 0);
    }
}

// Cope with unbalanced division by performing block schoolbook division.
проц fastDivMod(BigDigit [] quotient, BigDigit [] u, in BigDigit [] v)
{
    assert(quotient.length == u.length - v.length);
    assert(v.length > 1);
    assert(u.length >= v.length);
    assert((v[$-1] & 0x8000_0000)!=0);
    BigDigit [] черновик = new BigDigit[v.length];

    // Perform block schoolbook division, with 'v.length' blocks.
    бцел m = u.length - v.length;
    while (m > v.length) {
        recursiveDivMod(quotient[m-v.length..m], 
            u[m - v.length..m + v.length], v, черновик);
        m -= v.length;
    }
    recursiveDivMod(quotient[0..m], u[0..m + v.length], v, черновик);
    delete черновик;
}

debug(UnitTest)
{
import rt.core.stdc.stdio;

проц printBigбцел(бцел [] данные)
{
    сим [] buff = new сим[данные.length*9];
    printf("%.*s\n", bigбцелToHex(buff, данные, '_'));
}

проц printDecimalBigUint(BigUint данные)
{
   printf("%.*s\n", данные.toDecimalString(0)); 
}

unittest{
  бцел [] a, b;
  a = new бцел[43];
  b = new бцел[179];
  for (цел i=0; i<a.length; ++i) a[i] = 0x1234_B6E9 + i;
  for (цел i=0; i<b.length; ++i) b[i] = 0x1BCD_8763 - i*546;
  
  a[$-1] |= 0x8000_0000;
  бцел [] r = new бцел[a.length];
  бцел [] q = new бцел[b.length-a.length+1];
 
  divModInternal(q, r, b, a);
  q = q[0..$-1];
  бцел [] r1 = r.dup;
  бцел [] q1 = q.dup;  
  fastDivMod(q, b, a);
  r = b[0..a.length];
  assert(r[]==r1[]);
  assert(q[]==q1[]);
}
}
