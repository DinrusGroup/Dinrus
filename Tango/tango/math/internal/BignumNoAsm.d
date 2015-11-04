/** Arbitrary точность arithmetic ('bignum') for processors with no asm support
 *
 * все functions operate on массивы of бцелs, stored LSB first.
 * If there is a destination Массив, it will be the first parameter.
 * Currently, все of these functions are субъект в_ change, and are
 * intended for internal use only.
 * This module is intended only в_ assist development of high-скорость routines
 * on currently unsupported processors.
 * The X86 asm version is about 30 times faster than the D version(DMD).
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Don Clugston
 */

module math.internal.BignumNoAsm;

public:
alias бцел BigDigit; // A Bignum is an Массив of BigDigits. 
    
    // Limits for when в_ switch between multИПlication algorithms.
enum : цел { KARATSUBALIMIT = 10 }; // Minimum значение for which Karatsuba is worthwhile.
enum : цел { KARATSUBASQUARELIMIT=12 }; // Minimum значение for which square Karatsuba is worthwhile


/** Multi-байт добавьition or subtraction
 *    приёмник[] = src1[] + src2[] + carry (0 or 1).
 * or приёмник[] = src1[] - src2[] - carry (0 or 1).
 * Returns carry or borrow (0 or 1).
 * Набор op == '+' for добавьition, '-' for subtraction.
 */
бцел multibyteдобавьSub(сим op)(бцел[] приёмник, бцел [] src1, бцел [] src2, бцел carry)
{
    бдол c = carry;
    for (бцел i = 0; i < src2.length; ++i) {
        static if (op=='+') c = c  + src1[i] + src2[i];
             else           c = cast(бдол)src1[i] - src2[i] - c;
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
    бцел carry = multibyteдобавьSub!('+')(c[0..18], b[0..18], a[0..18], 0);
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
    carry = multibyteдобавьSub!('-')(a[0..12], a[0..12], b[0..12], 0);
    assert(a[11]==0);
    for (цел i=0; i<10; ++i) if (i!=5) assert(a[i]==0); 
    
    for (цел q=3; q<36;++q) {
        for (цел i=0; i<a.length; ++i)
        {
            a[i]=b[i]=c[i]=0;
        }    
        a[q-2]=0x040000;
        b[q-2]=0x040000;
       carry = multibyteдобавьSub!('-')(a[0..q], a[0..q], b[0..q], 0);
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
        бдол c = carry;
        c += приёмник[0];
        приёмник[0] = cast(бцел)c;
        if (c<=0xFFFF_FFFF) return 0; 
        
        for (бцел i = 1; i < приёмник.length; ++i) {
            ++приёмник[i];
            if (приёмник[i]!=0) return 0;
        }
        return 1;
   } else {
       бдол c = carry;
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

/** приёмник[] = ист[] << numbits
 *  numbits must be in the range 1..31
 */
бцел многобайтСдвигЛ(бцел [] приёмник, бцел [] ист, бцел numbits)
{
    бдол c = 0;
    for(цел i=0; i<приёмник.length; ++i){
        c += (cast(бдол)(ист[i]) << numbits);
        приёмник[i] = cast(бцел)c;
        c >>>= 32;
   }
   return cast(бцел)c;
}


/** приёмник[] = ист[] >> numbits
 *  numbits must be in the range 1..31
 */
проц многобайтСдвигП(бцел [] приёмник, бцел [] ист, бцел numbits)
{
    бдол c = 0;
    for(цел i=приёмник.length-1; i>=0; --i){
        c += (ист[i] >>numbits) + (cast(бдол)(ист[i]) << (64 - numbits));
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

/** приёмник[] = ист[] * множитель + carry.
 * Returns carry.
 */
бцел многобайтУмнож(бцел[] приёмник, бцел[] ист, бцел множитель, бцел carry)
{
    assert(приёмник.length==ист.length);
    бдол c = carry;
    for(цел i=0; i<ист.length; ++i){
        c += cast(бдол)(ист[i]) * множитель;
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
 * приёмник[] += ист[] * множитель + carry(0..FFFF_FFFF).
 * Returns carry out of MSB (0..FFFF_FFFF).
 */
бцел multibyteMulдобавь(сим op)(бцел [] приёмник, бцел[] ист, бцел множитель, бцел carry)
{
    assert(приёмник.length == ист.length);
    бдол c = carry;
    for(цел i = 0; i < ист.length; ++i){
        static if(op=='+') {
            c += cast(бдол)(множитель) * ист[i]  + приёмник[i];
            приёмник[i] = cast(бцел)c;
            c >>= 32;
        } else {
            c += cast(бдол)множитель * ист[i];
            бдол t = cast(бдол)приёмник[i] - cast(бцел)c;
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
    multibyteMulдобавь!('+')(bb[1..$-1], aa[1..$-2], 16, 5);
	assert(bb[0] == 0x1234_1234 && bb[4] == 0xC0C0_C0C0);
    assert(bb[1] == 0x2222_2230 + 0xF0F0_F0F0+5 && bb[2] == 0x5555_5561+0x00C0_C0C0+1
	    && bb[3] == 0x9999_99A4+0xF0F0_F0F0 );
}
}


/** 
   Sets результат = результат[0..left.length] + left * right
   
   It is defined in this way в_ allow cache-efficient multИПlication.
   This function is equivalent в_:
    ----
    for (цел i = 0; i< right.length; ++i) {
        приёмник[left.length + i] = multibyteMulдобавь(приёмник[i..left.length+i],
                left, right[i], 0);
    }
    ----
 */
проц многобайтУмножАккум(бцел [] приёмник, бцел[] left, бцел [] right)
{
    for (цел i = 0; i< right.length; ++i) {
        приёмник[left.length + i] = multibyteMulдобавь!('+')(приёмник[i..left.length+i],
                left, right[i], 0);
    }
}

/**  приёмник[] /= divisor.
 * перебор is the начальное remainder, and must be in the range 0..divisor-1.
 */
бцел многобайтПрисвойДеление(бцел [] приёмник, бцел divisor, бцел перебор)
{
    бдол c = cast(бдол)перебор;
    for(цел i = приёмник.length-1; i>=0; --i){
        c = (c<<32) + cast(бдол)(приёмник[i]);
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
    бцел перебор = многобайтУмнож(aa, aa, 0x8EFD_FCFB, 0x33FF_7461);
    бцел r = многобайтПрисвойДеление(aa, 0x8EFD_FCFB, перебор);
    for (цел i=aa.length-1; i>=0; --i) { assert(aa[i] == 0x8765_4321 * (i+3)); }
    assert(r==0x33FF_7461);

}
}

// Набор приёмник[2*i..2*i+1]+=ист[i]*ист[i]
проц multibyteдобавьDiagonalSquares(бцел[] приёмник, бцел[] ист)
{
    бдол c = 0;
    for(цел i = 0; i < ист.length; ++i){
		 // At this point, c is 0 or 1, since FFFF*FFFF+FFFF_FFFF = 1_0000_0000.
         c += cast(бдол)(ист[i]) * ист[i] + приёмник[2*i];
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
            бдол c = cast(бдол)(x[$-1]) * x[$-2]  + приёмник[2*x.length-3];
	        приёмник[2*x.length-3] = cast(бцел)c;
	        c >>= 32;
	        приёмник[2*x.length-2] = cast(бцел)c;
        }
	    return;
	}
    for (цел i = 2; i < x.length-2; ++i) {
        приёмник[i-1+ x.length] = multibyteMulдобавь!('+')(
             приёмник[i+i-1 .. i+x.length-1], x[i..$], x[i-1], 0);
    }
	// Unroll the последний two записи, в_ reduce loop overhead:
    бдол  c = cast(бдол)(x[$-3]) * x[$-2] + приёмник[2*x.length-5];
    приёмник[2*x.length-5] = cast(бцел)c;
    c >>= 32;
    c += cast(бдол)(x[$-3]) * x[$-1] + приёмник[2*x.length-4];
    приёмник[2*x.length-4] = cast(бцел)c;
    c >>= 32;
    c += cast(бдол)(x[$-1]) * x[$-2];
	приёмник[2*x.length-3] = cast(бцел)c;
	c >>= 32;
	приёмник[2*x.length-2] = cast(бцел)c;
}

проц многобайтПлощадь(BigDigit[] результат, BigDigit [] x)
{
    многобайтПрямоугАккум(результат, x);
    результат[$-1] = многобайтСдвигЛ(результат[1..$-1], результат[1..$-1], 1); // mul by 2
    результат[0] = 0;
    multibyteдобавьDiagonalSquares(результат, x);
}
