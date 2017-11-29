/** Arbitrary точность arithmetic ('bignum') for processors with no asm support
 *
 * All functions operate on массивы of uints, stored LSB first.
 * If there is a destination array, it will be the first parameter.
 * Currently, all of these functions are субъект to change, and are
 * intended for internal use only.
 * This module is intended only to assist development of high-скорость routines
 * on currently unsupported processors.
 * The X86 asm version is about 30 times faster than the D version(DMD).
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Don Clugston
 */

module math.internal.BignumNoAsm;

public:
alias бцел БольшЦифра; // A Bignum is an array of BigDigits. 
    
    // Limits for when to switch between multИПlication algorithms.
enum : цел { KARATSUBALIMIT = 10 }; // Minimum value for which Karatsuba is worthwhile.
enum : цел { KARATSUBASQUARELIMIT=12 }; // Minimum value for which square Karatsuba is worthwhile


/** Multi-byte addition or subtraction
 *    приёмник[] = src1[] + src2[] + carry (0 or 1).
 * or приёмник[] = src1[] - src2[] - carry (0 or 1).
 * Returns carry or borrow (0 or 1).
 * Набор op == '+' for addition, '-' for subtraction.
 */
бцел многобайтПрибавОтним(сим op)(бцел[] приёмник, бцел [] src1, бцел [] src2, бцел carry)
{
    ulong c = carry;
    for (бцел i = 0; i < src2.length; ++i) {
        static if (op=='+') c = c  + src1[i] + src2[i];
             else           c = cast(ulong)src1[i] - src2[i] - c;
        приёмник[i] = cast(бцел)c;
        c = (c>0xFFFF_FFFF);
    }
    return cast(бцел)c;
}

debug (UnitTest)
{
unittest
{
    бцел [] a = new бцел[40];
    бцел [] b = new бцел[40];
    бцел [] c = new бцел[40];
    for (цел i=0; i<a.length; ++i)
    {
        if (i&1) a[i]=0x8000_0000 + i;
        else a[i]=i;
        b[i]= 0x8000_0003;
    }
    c[19]=0x3333_3333;
    бцел carry = многобайтПрибавОтним!('+')(c[0..18], b[0..18], a[0..18], 0);
    assert(c[0]==0x8000_0003);
    assert(c[1]==4);
    assert(c[19]==0x3333_3333); // check for overrun
    assert(carry==1);
    for (цел i=0; i<a.length; ++i)
    {
        a[i]=b[i]=c[i]=0;
    }
    a[8]=0x048D159E;
    b[8]=0x048D159E;
    a[10]=0x1D950C84;
    b[10]=0x1D950C84;
    a[5] =0x44444444;
    carry = многобайтПрибавОтним!('-')(a[0..12], a[0..12], b[0..12], 0);
    assert(a[11]==0);
    for (цел i=0; i<10; ++i) if (i!=5) assert(a[i]==0); 
    
    for (цел q=3; q<36;++q) {
        for (цел i=0; i<a.length; ++i)
        {
            a[i]=b[i]=c[i]=0;
        }    
        a[q-2]=0x040000;
        b[q-2]=0x040000;
       carry = многобайтПрибавОтним!('-')(a[0..q], a[0..q], b[0..q], 0);
       assert(a[q-2]==0);
    }
}
}



/** приёмник[] += carry, or приёмник[] -= carry.
 *  op must be '+' or '-'
 *  Returns final carry or borrow (0 or 1)
 */
бцел многобайтИнкрПрисвой(сим op)(бцел[] приёмник, бцел carry)
{
    static if (op=='+') {
        ulong c = carry;
        c += приёмник[0];
        приёмник[0] = cast(бцел)c;
        if (c<=0xFFFF_FFFF) return 0; 
        
        for (бцел i = 1; i < приёмник.length; ++i) {
            ++приёмник[i];
            if (приёмник[i]!=0) return 0;
        }
        return 1;
   } else {
       ulong c = carry;
       c = приёмник[0] - c;
       приёмник[0] = cast(бцел)c;
       if (c<=0xFFFF_FFFF) return 0;
        for (бцел i = 1; i < приёмник.length; ++i) {
            --приёмник[i];
            if (приёмник[i]!=0xFFFF_FFFF) return 0;
        }
        return 1;
    }
}

/** приёмник[] = src[] << numbits
 *  numbits must be in the range 1..31
 */
бцел многобайтСдвигЛ(бцел [] приёмник, бцел [] src, бцел numbits)
{
    ulong c = 0;
    for(цел i=0; i<приёмник.length; ++i){
        c += (cast(ulong)(src[i]) << numbits);
        приёмник[i] = cast(бцел)c;
        c >>>= 32;
   }
   return cast(бцел)c;
}


/** приёмник[] = src[] >> numbits
 *  numbits must be in the range 1..31
 */
проц многобайтСдвигП(бцел [] приёмник, бцел [] src, бцел numbits)
{
    ulong c = 0;
    for(цел i=приёмник.length-1; i>=0; --i){
        c += (src[i] >>numbits) + (cast(ulong)(src[i]) << (64 - numbits));
        приёмник[i]= cast(бцел)c;
        c >>>= 32;
   }
}

debug (UnitTest)
{
unittest
{
    
    бцел [] aa = [0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтСдвигП(aa[0..$-2], aa, 4);
	assert(aa[0]==0x6122_2222 && aa[1]==0xA455_5555 && aa[2]==0x0899_9999);
	assert(aa[3]==0xBCCC_CCCD);

    aa = [0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтСдвигП(aa[0..$-1], aa, 4);
	assert(aa[0] == 0x6122_2222 && aa[1]==0xA455_5555 
	    && aa[2]==0xD899_9999 && aa[3]==0x0BCC_CCCC);

    aa = [0xF0FF_FFFF, 0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтСдвигЛ(aa[1..4], aa[1..$], 4);
	assert(aa[0] == 0xF0FF_FFFF && aa[1] == 0x2222_2230 
	    && aa[2]==0x5555_5561 && aa[3]==0x9999_99A4 && aa[4]==0x0BCCC_CCCD);
}
}

/** приёмник[] = src[] * множитель + carry.
 * Returns carry.
 */
бцел многобайтУмнож(бцел[] приёмник, бцел[] src, бцел множитель, бцел carry)
{
    assert(приёмник.length==src.length);
    ulong c = carry;
    for(цел i=0; i<src.length; ++i){
        c += cast(ulong)(src[i]) * множитель;
        приёмник[i] = cast(бцел)c;
        c>>=32;
    }
    return cast(бцел)c;
}

debug (UnitTest)
{
unittest
{
    бцел [] aa = [0xF0FF_FFFF, 0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтУмнож(aa[1..4], aa[1..4], 16, 0);
	assert(aa[0] == 0xF0FF_FFFF && aa[1] == 0x2222_2230 && aa[2]==0x5555_5561 && aa[3]==0x9999_99A4 && aa[4]==0x0BCCC_CCCD);
}
}

/**
 * приёмник[] += src[] * множитель + carry(0..FFFF_FFFF).
 * Returns carry out of MSB (0..FFFF_FFFF).
 */
бцел многобайтУмножПрибавь(сим op)(бцел [] приёмник, бцел[] src, бцел множитель, бцел carry)
{
    assert(приёмник.length == src.length);
    ulong c = carry;
    for(цел i = 0; i < src.length; ++i){
        static if(op=='+') {
            c += cast(ulong)(множитель) * src[i]  + приёмник[i];
            приёмник[i] = cast(бцел)c;
            c >>= 32;
        } else {
            c += cast(ulong)множитель * src[i];
            ulong t = cast(ulong)приёмник[i] - cast(бцел)c;
            приёмник[i] = cast(бцел)t;
            c = cast(бцел)((c>>32) - (t>>32));                
        }
    }
    return cast(бцел)c;    
}

debug (UnitTest)
{
unittest {
    
    бцел [] aa = [0xF0FF_FFFF, 0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    бцел [] bb = [0x1234_1234, 0xF0F0_F0F0, 0x00C0_C0C0, 0xF0F0_F0F0, 0xC0C0_C0C0];
    многобайтУмножПрибавь!('+')(bb[1..$-1], aa[1..$-2], 16, 5);
	assert(bb[0] == 0x1234_1234 && bb[4] == 0xC0C0_C0C0);
    assert(bb[1] == 0x2222_2230 + 0xF0F0_F0F0+5 && bb[2] == 0x5555_5561+0x00C0_C0C0+1
	    && bb[3] == 0x9999_99A4+0xF0F0_F0F0 );
}
}


/** 
   Sets result = result[0..left.length] + left * right
   
   It is defined in this way to allow cache-efficient multИПlication.
   This function is equivalent to:
    ----
    for (цел i = 0; i< right.length; ++i) {
        приёмник[left.length + i] = многобайтУмножПрибавь(приёмник[i..left.length+i],
                left, right[i], 0);
    }
    ----
 */
проц многобайтУмножАккум(бцел [] приёмник, бцел[] left, бцел [] right)
{
    for (цел i = 0; i< right.length; ++i) {
        приёмник[left.length + i] = многобайтУмножПрибавь!('+')(приёмник[i..left.length+i],
                left, right[i], 0);
    }
}

/**  приёмник[] /= divisor.
 * overflow is the начальное remainder, and must be in the range 0..divisor-1.
 */
бцел многобайтПрисвойДеление(бцел [] приёмник, бцел divisor, бцел overflow)
{
    ulong c = cast(ulong)overflow;
    for(цел i = приёмник.length-1; i>=0; --i){
        c = (c<<32) + cast(ulong)(приёмник[i]);
        бцел q = cast(бцел)(c/divisor);
        c -= divisor * q;
        приёмник[i] = q;
    }
    return cast(бцел)c;
}

debug (UnitTest)
{
unittest {
    бцел [] aa = new бцел[101];
    for (цел i=0; i<aa.length; ++i) aa[i] = 0x8765_4321 * (i+3);
    бцел overflow = многобайтУмнож(aa, aa, 0x8EFD_FCFB, 0x33FF_7461);
    бцел r = многобайтПрисвойДеление(aa, 0x8EFD_FCFB, overflow);
    for (цел i=aa.length-1; i>=0; --i) { assert(aa[i] == 0x8765_4321 * (i+3)); }
    assert(r==0x33FF_7461);

}
}

// Набор приёмник[2*i..2*i+1]+=src[i]*src[i]
проц многобайтПрибавьДиагПлощ(бцел[] приёмник, бцел[] src)
{
    ulong c = 0;
    for(цел i = 0; i < src.length; ++i){
		 // At this точка, c is 0 or 1, since FFFF*FFFF+FFFF_FFFF = 1_0000_0000.
         c += cast(ulong)(src[i]) * src[i] + приёмник[2*i];
         приёмник[2*i] = cast(бцел)c;
         c = (c>>=32) + приёмник[2*i+1];
         приёмник[2*i+1] = cast(бцел)c;
         c >>= 32;
    }
}

// Does half a square multИПly. (square = diagonal + 2*triangle)
проц многобайтПрямоугАккум(бцел[] приёмник, бцел[] x)
{
    // x[0]*x[1...$] + x[1]*x[2..$] + ... + x[$-2]x[$-1..$]
    приёмник[x.length] = многобайтУмнож(приёмник[1 .. x.length], x[1..$], x[0], 0);
	if (x.length <4) {
	    if (x.length ==3) {
            ulong c = cast(ulong)(x[$-1]) * x[$-2]  + приёмник[2*x.length-3];
	        приёмник[2*x.length-3] = cast(бцел)c;
	        c >>= 32;
	        приёмник[2*x.length-2] = cast(бцел)c;
        }
	    return;
	}
    for (цел i = 2; i < x.length-2; ++i) {
        приёмник[i-1+ x.length] = многобайтУмножПрибавь!('+')(
             приёмник[i+i-1 .. i+x.length-1], x[i..$], x[i-1], 0);
    }
	// Unroll the последний two entries, to reduce loop overhead:
    ulong  c = cast(ulong)(x[$-3]) * x[$-2] + приёмник[2*x.length-5];
    приёмник[2*x.length-5] = cast(бцел)c;
    c >>= 32;
    c += cast(ulong)(x[$-3]) * x[$-1] + приёмник[2*x.length-4];
    приёмник[2*x.length-4] = cast(бцел)c;
    c >>= 32;
    c += cast(ulong)(x[$-1]) * x[$-2];
	приёмник[2*x.length-3] = cast(бцел)c;
	c >>= 32;
	приёмник[2*x.length-2] = cast(бцел)c;
}

проц многобайтПлощадь(БольшЦифра[] result, БольшЦифра [] x)
{
    многобайтПрямоугАккум(result, x);
    result[$-1] = многобайтСдвигЛ(result[1..$-1], result[1..$-1], 1); // mul by 2
    result[0] = 0;
    многобайтПрибавьДиагПлощ(result, x);
}
