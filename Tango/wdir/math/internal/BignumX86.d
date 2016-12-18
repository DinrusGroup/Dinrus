/** Optimised asm arbitrary точность arithmetic ('bignum') 
 * routines for X86 processors.
 *
 * All functions operate on массивы of uints, stored LSB first.
 * If there is a destination array, it will be the first parameter.
 * Currently, all of these functions are субъект to change, and are
 * intended for internal use only. 
 * The symbol [#] indicates an array of machine words which is to be
 * interpreted as a multi-byte число.
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Don Clugston
 */
/**
 * In simple terms, there are 3 modern x86 microarchitectures:
 * (a) the P6 семейство (Pentium Pro, PII, PIII, PM, Core), produced by Intel;
 * (b) the K6, Athlon, and AMD64 families, produced by AMD; and
 * (c) the Pentium 4, produced by Marketing.
 *
 * This код есть been optimised for the Intel P6 семейство.
 * Generally the код remains near-optimal for Intel Core2, after translating
 * EAX-> RAX, etc, since all these CPUs use essentially the same pИПeline, and
 * are typically limited by memory access.
 * The код uses techniques described in Agner Fog's superb Pentium manuals
 * available at www.agner.org.
 * Not optimised for AMD, which can do two memory loads per cycle (Intel
 * CPUs can only do one). Despite this, performance is superior on AMD.
 * Performance is dreadful on P4. 
 *
 *  Timing results (cycles per цел)
 *              --Intel Pentium--  --AMD--
 *              PM     P4   Core2   K7 
 *  +,-         2.25  15.6   2.25   1.5
 *  <<,>>       2.0    6.6   2.0    5.0
 *    (<< MMX)  1.7    5.3   1.5    1.2
 *  *           5.0   15.0   4.0    4.3
 *  mulAdd      5.7   19.0   4.9    4.0
 *  div        30.0   32.0  32.0   22.4
 *  mulAcc(32)  6.5   20.0   5.4    4.9
 *
 * mulAcc(32) is multИПlyAccumulate() for a 32*32 multИПly. Thus it includes
 * function call overhead.
 * The timing for Div is quite unpredictable, but it's probably too slow
 * to be useful. On 64-bit processors, these times should
 * halve if run in 64-bit режим, except for the MMX functions.
 */

module math.internal.BignumX86;

/*  
  Naked asm is used throughout, because:
  (a) it frees up the EBP register
  (b) compiler bugs prevent the use of .ptr when a frame pointer is used.
*/

version(GNU) {
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(D_InlineAsm_X86) {
    version = Really_D_InlineAsm_X86;
} else version(LLVM_InlineAsm_X86) { 
        version = Really_D_InlineAsm_X86; 
}

version(Really_D_InlineAsm_X86) {

private:

/* Duplicate ткст s, with n times, substituting index for '@'.
 *
 * Each instance of '@' in s is replaced by 0,1,...n-1. This is a helper
 * function for some of the asm routines.
 */
сим [] откатиИндексированныйЦикл(цел n, сим [] s)
{
    сим [] u;
    for (цел i = 0; i<n; ++i) {
        сим [] nstr= (i>9 ? ""~ cast(сим)('0'+i/10) : "") ~ cast(сим)('0' + i%10);
        
        цел последний = 0;
        for (цел j = 0; j<s.length; ++j) {
            if (s[j]=='@') {
                u ~= s[последний..j] ~ nstr;
                последний = j+1;
            }
        }
        if (последний<s.length) u = u ~ s[последний..$];
        
    }
    return u;    
}

debug (UnitTest)
{unittest
{
assert(откатиИндексированныйЦикл(3, "@*23;")=="0*23;1*23;2*23;");
}
}

public:
    
alias бцел БольшЦифра; // A Bignum is an array of BigDigits. Usually the machine word size.
    
// Limits for when to switch between multИПlication algorithms.
enum : цел { KARATSUBALIMIT = 18 }; // Minimum value for which Karatsuba is worthwhile.
enum : цел { KARATSUBASQUARELIMIT=26 }; // Minimum value for which square Karatsuba is worthwhile
    
/** Multi-byte addition or subtraction
 *    приёмник[#] = src1[#] + src2[#] + carry (0 or 1).
 * or приёмник[#] = src1[#] - src2[#] - carry (0 or 1).
 * Returns carry or borrow (0 or 1).
 * Набор op == '+' for addition, '-' for subtraction.
 */
бцел многобайтПрибавОтним(сим op)(бцел[] приёмник, бцел [] src1, бцел [] src2, бцел carry)
{
    // Timing:
    // Pentium M: 2.25/цел
    // P6 семейство, Core2 have a partial flags stall when reading the carry flag in
    // an ADC, SBB operation after an operation such as INC or DEC which
    // modifies some, but not all, flags. We avoопр this by storing carry преобр_в
    // a resister (AL), and restoring it after the branch.
    
    enum { LASTPARAM = 4*4 } // 3* pushes + return address.
    asm {
        naked;
        push EDI;
        push EBX;
        push ESI;
        mov ECX, [ESP + LASTPARAM + 4*4]; // приёмник.length;
        mov EDX, [ESP + LASTPARAM + 3*4]; // src1.ptr
        mov ESI, [ESP + LASTPARAM + 1*4]; // src2.ptr
        mov EDI, [ESP + LASTPARAM + 5*4]; // приёмник.ptr
             // Carry is in EAX
        // Count UP to zero (from -len) to minimize loop overhead.
        lea EDX, [EDX + 4*ECX]; // EDX = end of src1.
        lea ESI, [ESI + 4*ECX]; // EBP = end of src2.        
        lea EDI, [EDI + 4*ECX]; // EDI = end of приёмник.

        neg ECX;
        add ECX, 8;
        jb L2;  // if length < 8 , bypass the unrolled loop.
L_unrolled:
        shr AL, 1; // get carry from EAX
    }
        mixin(" asm {"
        ~ откатиИндексированныйЦикл( 8, 
        "mov EAX, [@*4-8*4+EDX+ECX*4];"
        ~ ( op == '+' ? "adc" : "sbb" ) ~ " EAX, [@*4-8*4+ESI+ECX*4];"
        "mov [@*4-8*4+EDI+ECX*4], EAX;")
        ~ "}");
asm {        
        setc AL; // save carry
        add ECX, 8;
        ja L_unrolled;
L2:     // Do the resопрual 1..7 ints.
   
        sub ECX, 8; 
        jz done;
L_resопрual: 
        shr AL, 1; // get carry from EAX
    }
        mixin(" asm {"
        ~ откатиИндексированныйЦикл( 1, 
        "mov EAX, [@*4+EDX+ECX*4];"
        ~ ( op == '+' ? "adc" : "sbb" ) ~ " EAX, [@*4+ESI+ECX*4];"
        "mov [@*4+EDI+ECX*4], EAX;") ~ "}");
asm {        
        setc AL; // save carry
        add ECX, 1;
        jnz L_resопрual;
done:
        and EAX, 1; // make it O or 1.
        pop ESI;
        pop EBX;
        pop EDI;
        ret 6*4;
    } 
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
    бцел carry = многобайтПрибавОтним!('+')(c[0..18], a[0..18], b[0..18], 0);
    assert(carry==1);
    assert(c[0]==0x8000_0003);
    assert(c[1]==4);
    assert(c[19]==0x3333_3333); // check for overrun
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

/** приёмник[#] += carry, or приёмник[#] -= carry.
 *  op must be '+' or '-'
 *  Returns final carry or borrow (0 or 1)
 */
бцел многобайтИнкрПрисвой(сим op)(бцел[] приёмник, бцел carry)
{
    enum { LASTPARAM = 1*4 } // 0* pushes + return address.
    asm {
        naked;
        mov ECX, [ESP + LASTPARAM + 0*4]; // приёмник.length;
        mov EDX, [ESP + LASTPARAM + 1*4]; // приёмник.ptr
        // EAX  = carry
L1: ;
    }
    static if (op=='+')
        asm { add [EDX], EAX; }
    else 
        asm { sub [EDX], EAX; }    
    asm {
        mov EAX, 1;
        jnc L2;
        add EDX, 4;        
        dec ECX;
        jnz L1;
        mov EAX, 2;
L2:     dec EAX;
        ret 2*4;
    }
}
    
/** приёмник[#] = src[#] << numbits
 *  numbits must be in the range 1..31
 *  Returns the overflow
 */
бцел многобайтСдвигЛБезММХ(бцел [] приёмник, бцел [] src, бцел numbits)
{
    // Timing: Optimal for P6 семейство.
    // 2.0 cycles/цел on PPro..PM (limited by execution порт p0)
    // 5.0 cycles/цел on Athlon, which есть 7 cycles for SHLD!!
    enum { LASTPARAM = 4*4 } // 3* pushes + return address.
    asm {
        naked;
        push ESI;
        push EDI;
        push EBX;
        mov EDI, [ESP + LASTPARAM + 4*3]; //приёмник.ptr;
        mov EBX, [ESP + LASTPARAM + 4*2]; //приёмник.length;
        mov ESI, [ESP + LASTPARAM + 4*1]; //src.ptr;
        mov ECX, EAX; // numbits;

        mov EAX, [-4+ESI + 4*EBX];
        mov EDX, 0;
        shld EDX, EAX, CL;
        push EDX; // Save return value
        cmp EBX, 1;
        jz L_last;
        mov EDX, [-4+ESI + 4*EBX];
        test EBX, 1;
        jz L_odd;
        sub EBX, 1;        
L_even:
        mov EDX, [-4+ ESI + 4*EBX];
        shld EAX, EDX, CL;
        mov [EDI+4*EBX], EAX;
L_odd:
        mov EAX, [-8+ESI + 4*EBX];
        shld EDX, EAX, CL;
        mov [-4+EDI + 4*EBX], EDX;        
        sub EBX, 2;
        jg L_even;
L_last:
        shl EAX, CL;
        mov [EDI], EAX;
        pop EAX; // pop return value
        pop EBX;
        pop EDI;
        pop ESI;
        ret 4*4;
     }
}

/** приёмник[#] = src[#] >> numbits
 *  numbits must be in the range 1..31
 * This version uses MMX.
 */
бцел многобайтСдвигЛ(бцел [] приёмник, бцел [] src, бцел numbits)
{
    // Timing:
    // K7 1.2/цел. PM 1.7/цел P4 5.3/цел
    enum { LASTPARAM = 4*4 } // 3* pushes + return address.

    asm {
        naked;
        push ESI;
        push EDI;
        push EBX;
        mov EDI, [ESP + LASTPARAM + 4*3]; //приёмник.ptr;
        mov EBX, [ESP + LASTPARAM + 4*2]; //приёмник.length;
        mov ESI, [ESP + LASTPARAM + 4*1]; //src.ptr;

        movd MM3, EAX; // numbits = биты to shift left
        xor EAX, 63;
        align   16;
        inc EAX;        
        movd MM4, EAX ; // 64-numbits = биты to shift right
        
        // Get the return value преобр_в EAX
        and EAX, 31; // EAX = 32-numbits
        movd MM2, EAX; // 32-numbits
        movd MM1, [ESI+4*EBX-4];                
        psrlq MM1, MM2;
        movd EAX, MM1;  // EAX = return value
        test EBX, 1;
        jz L_even;
L_odd:
        cmp EBX, 1;
        jz L_length1;
    
         // deal with odd lengths
        movq MM1, [ESI+4*EBX-8];
        psrlq MM1, MM2;        
        movd    [EDI +4*EBX-4], MM1;
        sub EBX, 1;
L_even: // It's either singly or doubly even
        movq    MM2, [ESI + 4*EBX - 8];
        psllq   MM2, MM3;
        sub EBX, 2;
        jle L_last;
        movq MM1, MM2;
        add EBX, 2;
        test EBX, 2;
        jz L_onceeven;
        sub EBX, 2;
        
        // MAIN LOOP -- 128 bytes per iteration
 L_twiceeven:      // here MM2 is the carry
        movq    MM0, [ESI + 4*EBX-8];
        psrlq   MM0, MM4;
        movq    MM1, [ESI + 4*EBX-8];
        psllq   MM1, MM3;
        por     MM2, MM0;
        movq    [EDI +4*EBX], MM2;
L_onceeven:        // here MM1 is the carry
        movq    MM0, [ESI + 4*EBX-16];
        psrlq   MM0, MM4;
        movq    MM2, [ESI + 4*EBX-16];
        por     MM1, MM0;
        movq    [EDI +4*EBX-8], MM1;        
        psllq   MM2, MM3;
        sub EBX, 4;
        jg L_twiceeven;
L_last:        
        movq    [EDI +4*EBX], MM2;
L_alldone:        
        emms;  // NOTE: costs 6 cycles on Intel CPUs
        pop EBX;
        pop EDI;
        pop ESI;
        ret 4*4;
        
L_length1:
        // length 1 is a special case
        movd MM1, [ESI];
        psllq MM1, MM3;
        movd [EDI], MM1;
        jmp L_alldone;        
   }
}

проц многобайтСдвигП(бцел [] приёмник, бцел [] src, бцел numbits)
{
    enum { LASTPARAM = 4*4 } // 3* pushes + return address.
    asm {
        naked;
        push ESI;
        push EDI;
        push EBX;
        mov EDI, [ESP + LASTPARAM + 4*3]; //приёмник.ptr;
        mov EBX, [ESP + LASTPARAM + 4*2]; //приёмник.length;
align 16;
        mov ESI, [ESP + LASTPARAM + 4*1]; //src.ptr;
        lea EDI, [EDI + 4*EBX]; // EDI = end of приёмник
        lea ESI, [ESI + 4*EBX]; // ESI = end of src
        neg EBX;                // count UP to zero.
        
        movd MM3, EAX; // numbits = биты to shift right
        xor EAX, 63;
        inc EAX;        
        movd MM4, EAX ; // 64-numbits = биты to shift left
        
        test EBX, 1;
        jz L_even;
L_odd:
         // deal with odd lengths
        and EAX, 31; // EAX = 32-numbits
        movd MM2, EAX; // 32-numbits
        cmp EBX, -1;
        jz L_length1;
    
        movq MM0, [ESI+4*EBX];
        psrlq MM0, MM3;        
        movd    [EDI +4*EBX], MM0;
        add EBX, 1;        
L_even: 
        movq    MM2, [ESI + 4*EBX];
        psrlq   MM2, MM3;
        
        movq MM1, MM2;
        add EBX, 4;
        cmp EBX, -2+4;        
        jz L_last;
        // It's either singly or doubly even
        sub EBX, 2;
        test EBX, 2;
        jnz L_onceeven;
        add EBX, 2;
        
        // MAIN LOOP -- 128 bytes per iteration
 L_twiceeven:      // here MM2 is the carry
        movq    MM0, [ESI + 4*EBX-8];
        psllq   MM0, MM4;
        movq    MM1, [ESI + 4*EBX-8];
        psrlq   MM1, MM3;
        por     MM2, MM0;
        movq    [EDI +4*EBX-16], MM2;
L_onceeven:        // here MM1 is the carry
        movq    MM0, [ESI + 4*EBX];
        psllq   MM0, MM4;
        movq    MM2, [ESI + 4*EBX];
        por     MM1, MM0;
        movq    [EDI +4*EBX-8], MM1;        
        psrlq   MM2, MM3;
        add EBX, 4;
        jl L_twiceeven;
L_last:     
        movq    [EDI +4*EBX-16], MM2;
L_alldone:        
        emms;  // NOTE: costs 6 cycles on Intel CPUs
        pop EBX;
        pop EDI;
        pop ESI;
        ret 4*4;
        
L_length1:
        // length 1 is a special case
        movd MM1, [ESI+4*EBX];
        psrlq MM1, MM3;        
        movd    [EDI +4*EBX], MM1;
        jmp L_alldone;        

   }
}

/** приёмник[#] = src[#] >> numbits
 *  numbits must be in the range 1..31
 */
проц многобайтСдвигПБезММХ(бцел [] приёмник, бцел [] src, бцел numbits)
{
    // Timing: Optimal for P6 семейство.
    // 2.0 cycles/цел on PPro..PM (limited by execution порт p0)
    // Terrible performance on AMD64, which есть 7 cycles for SHRD!!
    enum { LASTPARAM = 4*4 } // 3* pushes + return address.
    asm {
        naked;
        push ESI;
        push EDI;
        push EBX;
        mov EDI, [ESP + LASTPARAM + 4*3]; //приёмник.ptr;
        mov EBX, [ESP + LASTPARAM + 4*2]; //приёмник.length;
        mov ESI, [ESP + LASTPARAM + 4*1]; //src.ptr;
        mov ECX, EAX; // numbits;

        lea EDI, [EDI + 4*EBX]; // EDI = end of приёмник
        lea ESI, [ESI + 4*EBX]; // ESI = end of src
        neg EBX;                // count UP to zero.
        mov EAX, [ESI + 4*EBX];
        cmp EBX, -1;
        jz L_last;
        mov EDX, [ESI + 4*EBX];
        test EBX, 1;
        jz L_odd;
        add EBX, 1;        
L_even:
        mov EDX, [ ESI + 4*EBX];
        shrd EAX, EDX, CL;
        mov [-4 + EDI+4*EBX], EAX;
L_odd:
        mov EAX, [4 + ESI + 4*EBX];
        shrd EDX, EAX, CL;
        mov [EDI + 4*EBX], EDX;        
        add EBX, 2;
        jl L_even;
L_last:
        shr EAX, CL;
        mov [-4 + EDI], EAX;
        
        pop EBX;
        pop EDI;
        pop ESI;
        ret 4*4;
     }
}

debug (UnitTest)
{
unittest
{

    бцел [] aa = [0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтСдвигП(aa[0..$-1], aa, 4);
    assert(aa[0] == 0x6122_2222 && aa[1]==0xA455_5555 
        && aa[2]==0xD899_9999 && aa[3]==0x0BCC_CCCC);

    aa = [0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтСдвигП(aa[2..$-1], aa[2..$-1], 4);
    assert(aa[0] == 0x1222_2223 && aa[1]==0x4555_5556
        && aa[2]==0xD899_9999 && aa[3]==0x0BCC_CCCC);

    aa = [0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    многобайтСдвигП(aa[0..$-2], aa, 4);
    assert(aa[1]==0xA455_5555 && aa[2]==0x0899_9999);
    assert(aa[0]==0x6122_2222);
    assert(aa[3]==0xBCCC_CCCD);


    aa = [0xF0FF_FFFF, 0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    бцел r = многобайтСдвигЛ(aa[2..4], aa[2..4], 4);
    assert(aa[0] == 0xF0FF_FFFF && aa[1]==0x1222_2223
        && aa[2]==0x5555_5560 && aa[3]==0x9999_99A4 && aa[4]==0xBCCC_CCCD);
    assert(r==8);
        
    aa = [0xF0FF_FFFF, 0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    r = многобайтСдвигЛ(aa[1..4], aa[1..4], 4);    
    assert(aa[0] == 0xF0FF_FFFF
        && aa[2]==0x5555_5561);    
        assert(aa[3]==0x9999_99A4 && aa[4]==0xBCCC_CCCD);
    assert(r==8);
        assert(aa[1]==0x2222_2230);
        
    aa = [0xF0FF_FFFF, 0x1222_2223, 0x4555_5556, 0x8999_999A, 0xBCCC_CCCD, 0xEEEE_EEEE];
    r = многобайтСдвигЛ(aa[0..4], aa[1..5], 31);    
}
}

/** приёмник[#] = src[#] * множитель + carry.
 * Returns carry.
 */
бцел многобайтУмнож(бцел[] приёмник, бцел[] src, бцел множитель, бцел carry)
{
    // Timing: definitely not optimal.
    // Pentium M: 5.0 cycles/operation, есть 3 resource stalls/iteration
    // Fastest implementation найдено was 4.6 cycles/op, but not worth the complexity.

    enum { LASTPARAM = 4*4 } // 4* pushes + return address.
    // We'll use p2 (load unit) instead of the overworked p0 or p1 (ALU units)
    // when initializing variables to zero.
    version(D_PIC)
    {
        enum { zero = 0 }
    }
    else
    {
        static цел zero = 0;
    }
    asm {
        naked;      
        push ESI;
        push EDI;
        push EBX;
        
        mov EDI, [ESP + LASTPARAM + 4*4]; // приёмник.ptr
        mov EBX, [ESP + LASTPARAM + 4*3]; // приёмник.length
        mov ESI, [ESP + LASTPARAM + 4*2];  // src.ptr
        align 16;
        lea EDI, [EDI + 4*EBX]; // EDI = end of приёмник
        lea ESI, [ESI + 4*EBX]; // ESI = end of src
        mov ECX, EAX; // [carry]; -- последний param is in EAX.
        neg EBX;                // count UP to zero.
        test EBX, 1;
        jnz L_odd;
        add EBX, 1;
 L1:
        mov EAX, [-4 + ESI + 4*EBX];
        mul int ptr [ESP+LASTPARAM]; //[множитель];
        add EAX, ECX;
        mov ECX, zero;
        mov [-4+EDI + 4*EBX], EAX;
        adc ECX, EDX;
L_odd:        
        mov EAX, [ESI + 4*EBX];  // p2
        mul int ptr [ESP+LASTPARAM]; //[множитель]; // p0*3, 
        add EAX, ECX;
        mov ECX, zero;
        adc ECX, EDX;
        mov [EDI + 4*EBX], EAX;
        add EBX, 2;
        jl L1;
        
        mov EAX, ECX; // get final carry

        pop EBX;
        pop EDI;
        pop ESI;
        ret 5*4;
     }
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

// The inner multИПly-and-add loop, together with the Even entry точка.
// MultИПles by M_ADDRESS which should be "ESP+LASTPARAM" or "ESP". OP must be "add" or "sub"
// This is the most time-critical код in the BigInt library.
// It is used by Всё MulAdd, multИПlyAccumulate, and triangleAccumulate
сим [] асмУмножьДоб_внутрцикл(сим [] OP, сим [] M_ADDRESS) {
    // The bottlenecks in this код are extremely complicated. The MUL, ADD, and ADC
    // need 4 cycles on each of the ALUs units p0 and p1. So we use memory load 
    // (unit p2) for initializing registers to zero.
    // There are also dependencies between the instructions, and we run up against the
    // ROB-read limit (can only read 2 registers per cycle).
    // We also need the число of uops in the loop to be a multИПle of 3.
    // The only available execution unit for this is p3 (memory write). Unfortunately we can't do that
	// if Position-Independent Code is required.
	
	// Register usage
    // ESI = end of src
    // EDI = end of приёмник
    // EBX = index. Counts up to zero (in steps of 2).
    // EDX:EAX = черновик, used in multИПly.
    // ECX = carry1.
    // EBP = carry2.
	// ESP = points to the множитель.
	
	// The first member of 'приёмник' which will be modified is [EDI+4*EBX].
	// EAX must already contain the first member of 'src', [ESI+4*EBX].

version(D_PIC) { bool using_PIC = true; } else { bool using_PIC=false; }
return "asm {
        // Entry точка for even length
        add EBX, 1;
        mov EBP, ECX; // carry
        
        mul int ptr [" ~ M_ADDRESS ~ "]; // M
        mov ECX, 0;
 
        add EBP, EAX;
        mov EAX, [ESI+4*EBX];
        adc ECX, EDX;

        mul int ptr [" ~ M_ADDRESS ~ "]; // M
        " ~ OP ~ " [-4+EDI+4*EBX], EBP;
        mov EBP, zero;
    
        adc ECX, EAX;
        mov EAX, [4+ESI+4*EBX];
    
        adc EBP, EDX;    
        add EBX, 2;
        jnl L_done;
L1:
        mul int ptr [" ~ M_ADDRESS ~ "];
        " ~ OP ~ " [-8+EDI+4*EBX], ECX; 
        adc EBP, EAX;
        mov ECX, zero;
        mov EAX, [ESI+4*EBX];        
        adc ECX, EDX;
		" ~
    (using_PIC ? "" : "   mov storagenop, EDX; ") // make #uops in loop a multИПle of 3, can't do this in PIC режим.
	~ "
        mul int ptr [" ~ M_ADDRESS ~ "];
        " ~ OP ~ " [-4+EDI+4*EBX], EBP;
        mov EBP, zero;
    
        adc ECX, EAX;
        mov EAX, [4+ESI+4*EBX];
    
        adc EBP, EDX;    
        add EBX, 2;
        jl L1;
L_done: " ~ OP ~ " [-8+EDI+4*EBX], ECX;
        adc EBP, 0;
		}";
		// final carry is now in EBP
}

сим [] асмУмножьДоб_вх_одд(сим [] OP, сим [] M_ADDRESS) {
return "asm {
        mul int ptr [" ~M_ADDRESS ~"];
        mov EBP, zero;   
        add ECX, EAX;
        mov EAX, [4+ESI+4*EBX];
    
        adc EBP, EDX;    
        add EBX, 2;
        jl L1;
        jmp L_done;
		}";
}
		


/**
 * приёмник[#] += src[#] * множитель OP carry(0..FFFF_FFFF).
 * where op == '+' or '-'
 * Returns carry out of MSB (0..FFFF_FFFF).
 */
бцел многобайтУмножПрибавь(сим op)(бцел [] приёмник, бцел[] src, бцел множитель, бцел carry)
{
    // Timing: This is the most time-critical bignum function.
    // Pentium M: 5.4 cycles/operation, still есть 2 resource stalls + 1load block/iteration
    
    // The main loop is pИПelined and unrolled by 2, 
    //   so entry to the loop is also complicated.
    
    // Register usage
    // EDX:EAX = multИПly
    // EBX = counter
    // ECX = carry1
    // EBP = carry2
    // EDI = приёмник
    // ESI = src
    
    const сим [] OP = (op=='+')? "add" : "sub";
    version(D_PIC) {
        enum { zero = 0 }
    } else {
        // use p2 (load unit) instead of the overworked p0 or p1 (ALU units)
        // when initializing registers to zero.
        static цел zero = 0;
        // use p3/p4 units 
        static цел storagenop; // write-only
    }
    
    enum { LASTPARAM = 5*4 } // 4* pushes + return address.
    asm {
        naked;
        
        push ESI;
        push EDI;
        push EBX;
        push EBP;
        mov EDI, [ESP + LASTPARAM + 4*4]; // приёмник.ptr
        mov EBX, [ESP + LASTPARAM + 4*3]; // приёмник.length
        align 16;
        nop;
        mov ESI, [ESP + LASTPARAM + 4*2];  // src.ptr
        lea EDI, [EDI + 4*EBX]; // EDI = end of приёмник
        lea ESI, [ESI + 4*EBX]; // ESI = end of src
        mov EBP, 0;
        mov ECX, EAX; // ECX = input carry.
        neg EBX;                // count UP to zero.
        mov EAX, [ESI+4*EBX];
        test EBX, 1;
        jnz L_enter_odd;
}
		// Main loop, with entry точка for even length
mixin(асмУмножьДоб_внутрцикл(OP, "ESP+LASTPARAM")); 
asm {
        mov EAX, EBP; // get final carry
        pop EBP;
        pop EBX;
        pop EDI;
        pop ESI;
        ret 5*4;
}        
L_enter_odd:
    mixin(асмУмножьДоб_вх_одд(OP, "ESP+LASTPARAM"));
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
   Sets result[#] = result[0..left.length] + left[#] * right[#]
   
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
    // Register usage
    // EDX:EAX = used in multИПly
    // EBX = index
    // ECX = carry1
    // EBP = carry2
    // EDI = end of приёмник for this пароль through the loop. Index for outer loop.
    // ESI = end of left. never changes
    // [ESP] = M = right[i] = множитель for this пароль through the loop.
    // right.length is changed преобр_в приёмник.ptr+приёмник.length
    version(D_PIC) {
        enum { zero = 0 }
    } else {
        // use p2 (load unit) instead of the overworked p0 or p1 (ALU units)
        // when initializing registers to zero.
        static цел zero = 0;
        // use p3/p4 units 
        static цел storagenop; // write-only
    }
    
    enum { LASTPARAM = 6*4 } // 4* pushes + local + return address.
    asm {
        naked;
          
        push ESI;
        push EDI;
        align 16;
        push EBX;
        push EBP;
        push EAX;    // local переменная M
        mov EDI, [ESP + LASTPARAM + 4*5]; // приёмник.ptr
        mov EBX, [ESP + LASTPARAM + 4*2]; // left.length
        mov ESI, [ESP + LASTPARAM + 4*3];  // left.ptr
        lea EDI, [EDI + 4*EBX]; // EDI = end of приёмник for first пароль
        
        mov EAX, [ESP + LASTPARAM + 4*0]; // right.length
        lea EAX, [EDI + 4*EAX];
        mov [ESP + LASTPARAM + 4*0], EAX; // последний value for EDI       

        lea ESI, [ESI + 4*EBX]; // ESI = end of left
        mov EAX, [ESP + LASTPARAM + 4*1]; // right.ptr
        mov EAX, [EAX];
        mov [ESP], EAX; // M
outer_loop:        
        mov EBP, 0;
        mov ECX, 0; // ECX = input carry.
        neg EBX;                // count UP to zero.
        mov EAX, [ESI+4*EBX];
        test EBX, 1;
        jnz L_enter_odd;
		}
        // -- Inner loop, with even entry точка
        mixin(асмУмножьДоб_внутрцикл("add", "ESP"));
asm {
        mov [-4+EDI+4*EBX], EBP;
        add EDI, 4;
        cmp EDI, [ESP + LASTPARAM + 4*0]; // is EDI = &приёмник[$]?
        jz outer_done;
        mov EAX, [ESP + LASTPARAM + 4*1]; // right.ptr
        mov EAX, [EAX+4];                 // get new M
        mov [ESP], EAX;                   // save new M
        add int ptr [ESP + LASTPARAM + 4*1], 4; // right.ptr
        mov EBX, [ESP + LASTPARAM + 4*2]; // left.length
        jmp outer_loop;
outer_done:        
        pop EAX;
        pop EBP;
        pop EBX;
        pop EDI;
        pop ESI;
        ret 6*4;
}
L_enter_odd:
    mixin(асмУмножьДоб_вх_одд("add", "ESP"));
}

/**  приёмник[#] /= divisor.
 * overflow is the начальное remainder, and must be in the range 0..divisor-1.
 * divisor must not be a power of 2 (use right shift for that case;
 * A division by zero will occur if divisor is a power of 2).
 * Returns the final remainder
 *
 * Based on public домен код by Eric Bainville. 
 * (http://www.bealto.com/) Used with permission.
 */
бцел многобайтПрисвойДеление(бцел [] приёмник, бцел divisor, бцел overflow)
{
    // Timing: limited by a horrible dependency chain.
    // Pentium M: 18 cycles/op, 8 resource stalls/op.
    // EAX, EDX = черновик, used by MUL
    // EDI = приёмник
    // CL = shift
    // ESI = quotient
    // EBX = remainderhi
    // EBP = remainderlo
    // [ESP-4] = mask
    // [ESP] = kinv (2^64 /divisor)
    enum { LASTPARAM = 5*4 } // 4* pushes + return address.
    enum { LOCALS = 2*4} // MASK, KINV
    asm {
        naked;
        
        push ESI;
        push EDI;
        push EBX;
        push EBP;
        
        mov EDI, [ESP + LASTPARAM + 4*2]; // приёмник.ptr
        mov EBX, [ESP + LASTPARAM + 4*1]; // приёмник.length

        // Loop from msb to lsb
        lea     EDI, [EDI + 4*EBX];        
        mov EBP, EAX; // rem is the input remainder, in 0..divisor-1
        // Build the pseudo-inverse of divisor k: 2^64/k
        // First determine the shift in ecx to get the max число of биты in kinv
        xor     ECX, ECX;
        mov     EAX, [ESP + LASTPARAM]; //divisor;
        mov     EDX, 1;
kinv1:
        inc     ECX;
        ror     EDX, 1;
        shl     EAX, 1;
        jnc     kinv1;
        dec     ECX;
        // Here, ecx is a left shift moving the msb of k to bit 32
        
        mov     EAX, 1;
        shl     EAX, CL;
        dec     EAX;
        ror     EAX, CL ; //ecx биты at msb
        push    EAX; // MASK        
        
        // Then divопрe 2^(32+cx) by divisor (edx already ok)
        xor     EAX, EAX;
        div     int ptr [ESP + LASTPARAM +  LOCALS-4*1]; //divisor;
        push    EAX; // kinv        
        align   16;
L2:
        // Get 32 биты of quotient approx, multИПlying
        // most significant word of (rem*2^32+input)
        mov     EAX, [ESP+4]; //MASK;
        and     EAX, [EDI - 4];
        or      EAX, EBP;
        rol     EAX, CL;
        mov     EBX, EBP;
        mov     EBP, [EDI - 4];
        mul     int ptr [ESP]; //KINV;
                
        shl     EAX, 1;
        rcl     EDX, 1;
        
        // MultИПly by k and вычти to get remainder
        // Subtraction must be done on two words
        mov     EAX, EDX;
        mov     ESI, EDX; // quot = high word
        mul     int ptr [ESP + LASTPARAM+LOCALS]; //divisor;
        sub     EBP, EAX;
        sbb     EBX, EDX;   
        jz      Lb;  // high word is 0, goto исправь on single word

        // Adjust quotient and remainder on two words
Ld:     inc     ESI;
        sub     EBP, [ESP + LASTPARAM+LOCALS]; //divisor;
        sbb     EBX, 0;
        jnz     Ld;
        
        // Adjust quotient and remainder on single word
Lb:     cmp     EBP, [ESP + LASTPARAM+LOCALS]; //divisor;
        jc      Lc; // rem in 0..divisor-1, ОК        
        sub     EBP, [ESP + LASTPARAM+LOCALS]; //divisor;
        inc     ESI;
        jmp     Lb;
        
        // Store result
Lc:
        mov     [EDI - 4], ESI;
        lea     EDI, [EDI - 4];
        dec     int ptr [ESP + LASTPARAM + 4*1+LOCALS]; // len
        jnz    L2;
        
        pop EAX; // discard kinv
        pop EAX; // discard mask
        
        mov     EAX, EBP; // return final remainder
        pop     EBP;
        pop     EBX;
        pop     EDI;
        pop     ESI;        
        ret     3*4;
    }
}

debug (UnitTest)
{
unittest {
    бцел [] aa = new бцел[101];
    for (цел i=0; i<aa.length; ++i) aa[i] = 0x8765_4321 * (i+3);
    бцел overflow = многобайтУмнож(aa, aa, 0x8EFD_FCFB, 0x33FF_7461);
    бцел r = многобайтПрисвойДеление(aa, 0x8EFD_FCFB, overflow);
    for (цел i=0; i<aa.length-1; ++i) assert(aa[i] == 0x8765_4321 * (i+3));
    assert(r==0x33FF_7461);
}
}

// Набор приёмник[2*i..2*i+1]+=src[i]*src[i]
проц многобайтПрибавьДиагПлощ(бцел [] приёмник, бцел [] src)
{
    /* Unlike mulAdd, the carry is only 1 bit, 
	   since FFFF*FFFF+FFFF_FFFF = 1_0000_0000.
	   Note also that on the последний iteration, no carry can occur.
	   As for multibyteAdd, we save & restore carry flag through the loop.
	   
	   The timing is entirely dictated by the dependency chain. We could
	   improve it by moving the mov EAX after the adc [EDI], EAX. Probably not worthwhile.
    */
    enum { LASTPARAM = 4*5 } // 4* pushes + return address.
 asm {
    naked;
    push ESI;
    push EDI;
    push EBX;
	push ECX;
    mov EDI, [ESP + LASTPARAM + 4*3]; //приёмник.ptr;
    mov EBX, [ESP + LASTPARAM + 4*0]; //src.length;
    mov ESI, [ESP + LASTPARAM + 4*1]; //src.ptr;
    lea EDI, [EDI + 8*EBX];      // EDI = end of приёмник
    lea ESI, [ESI + 4*EBX];      // ESI = end of src
    neg EBX;                     // count UP to zero.
    xor ECX, ECX;             // начальное carry = 0.
L1:
    mov EAX, [ESI + 4*EBX];
    mul EAX, EAX;
    shr CL, 1;                 // get carry
    adc [EDI + 8*EBX], EAX;
    adc [EDI + 8*EBX + 4], EDX;
    setc CL;                   // save carry
    inc EBX;
    jnz L1;
	
	pop ECX;
	pop EBX;
	pop EDI;
	pop ESI;
	ret 4*4;
 }
}
debug (UnitTest)
{
unittest {
    бцел [] aa = new бцел[13];
	бцел [] bb = new бцел[6];
    for (цел i=0; i<aa.length; ++i) aa[i] = 0x8000_0000;
    for (цел i=0; i<bb.length; ++i) bb[i] = i;
	aa[$-1]= 7;
    многобайтПрибавьДиагПлощ(aa[0..$-1], bb);
	assert(aa[$-1]==7);
	for (цел i=0; i<bb.length; ++i) { assert(aa[2*i]==0x8000_0000+i*i); assert(aa[2*i+1]==0x8000_0000); }
}
}

проц многобайтПрямоугАккумД(бцел[] приёмник, бцел[] x)
{
    for (цел i = 0; i < x.length-3; ++i) {
        приёмник[i+x.length] = многобайтУмножПрибавь!('+')(
             приёмник[i+i+1 .. i+x.length], x[i+1..$], x[i], 0);
    }
    ulong c = cast(ulong)(x[$-3]) * x[$-2] + приёмник[$-5];
    приёмник[$-5] = cast(бцел)c;
    c >>= 32;
    c += cast(ulong)(x[$-3]) * x[$-1] + приёмник[$-4];
    приёмник[$-4] = cast(бцел)c;
    c >>= 32;
length2:	
    c += cast(ulong)(x[$-2]) * x[$-1];
	приёмник[$-3] = cast(бцел)c;
	c >>= 32;
	приёмник[$-2] = cast(бцел)c;
}

//приёмник += src[0]*src[1...$] + src[1]*src[2..$] + ... + src[$-3]*src[$-2..$]+ src[$-2]*src[$-1]
// assert(приёмник.length = src.length*2);
// assert(src.length >= 3);
проц многобайтПрямоугАккумАсм(бцел[] приёмник, бцел[] src)
{
    // Register usage
    // EDX:EAX = used in multИПly
    // EBX = index
    // ECX = carry1
    // EBP = carry2
    // EDI = end of приёмник for this пароль through the loop. Index for outer loop.
    // ESI = end of src. never changes
    // [ESP] = M = src[i] = множитель for this пароль through the loop.
    // приёмник.length is changed преобр_в приёмник.ptr+приёмник.length
    version(D_PIC) {
        enum { zero = 0 }
    } else {
        // use p2 (load unit) instead of the overworked p0 or p1 (ALU units)
        // when initializing registers to zero.
        static цел zero = 0;
        // use p3/p4 units 
        static цел storagenop; // write-only
    }

    enum { LASTPARAM = 6*4 } // 4* pushes + local + return address.
    asm {
        naked;

        push ESI;
        push EDI;
        align 16;
        push EBX;
        push EBP;
        push EAX;    // local переменная M= src[i]
        mov EDI, [ESP + LASTPARAM + 4*3]; // приёмник.ptr
        mov EBX, [ESP + LASTPARAM + 4*0]; // src.length
        mov ESI, [ESP + LASTPARAM + 4*1];  // src.ptr

        lea ESI, [ESI + 4*EBX]; // ESI = end of left
        add int ptr [ESP + LASTPARAM + 4*1], 4; // src.ptr, used for getting M

        // local переменная [ESP + LASTPARAM + 4*2] = последний value for EDI
        lea EDI, [EDI + 4*EBX]; // EDI = end of приёмник for first пароль

        lea EAX, [EDI + 4*EBX-3*4]; // up to src.length - 3
        mov [ESP + LASTPARAM + 4*2], EAX; // последний value for EDI  = &приёмник[src.length*2 -3]     		

        cmp EBX, 3;
        jz length_is_3;
        
        // We start at src[1], not src[0].		    
        dec EBX;
        mov [ESP + LASTPARAM + 4*0], EBX;

outer_loop:        
        mov EBX, [ESP + LASTPARAM + 4*0]; // src.length
        mov EBP, 0;
        mov ECX, 0; // ECX = input carry.
        dec [ESP + LASTPARAM + 4*0]; // Next time, the length will be shorter by 1.
        neg EBX;                // count UP to zero.

        mov EAX, [ESI + 4*EBX - 4*1]; // get new M
        mov [ESP], EAX;                   // save new M

        mov EAX, [ESI+4*EBX];
        test EBX, 1;
        jnz L_enter_odd;
    }
    // -- Inner loop, with even entry точка
    mixin(асмУмножьДоб_внутрцикл("add", "ESP"));
    asm {
        mov [-4+EDI+4*EBX], EBP;
        add EDI, 4;
        cmp EDI, [ESP + LASTPARAM + 4*2]; // is EDI = &приёмник[$-3]?
        jnz outer_loop;        
length_is_3:
        mov EAX, [ESI - 4*3];
        mul EAX, [ESI - 4*2];
        mov ECX, 0;
        add [EDI-2*4], EAX;  // ECX:приёмник[$-5] += x[$-3] * x[$-2]        
        adc ECX, EDX;

        mov EAX, [ESI - 4*3];
        mul EAX, [ESI - 4*1]; // x[$-3] * x[$-1]
        add EAX, ECX;
        mov ECX, 0;
        adc EDX, 0;
        // now EDX: EAX = c + x[$-3] * x[$-1]
        add [EDI-1*4], EAX; // ECX:приёмник[$-4] += (EDX:EAX)
        adc ECX, EDX;  //  ECX holds приёмник[$-3], it acts as carry for the последний row
// do length==2 
        mov EAX, [ESI - 4*2];
        mul EAX, [ESI - 4*1];
        add ECX, EAX;
        adc EDX, 0;        
        mov [EDI - 0*4], ECX; // приёмник[$-2:$-3] = c + x[$-2] * x[$-1];
        mov [EDI + 1*4], EDX;

        pop EAX;
        pop EBP;
        pop EBX;
        pop EDI;
        pop ESI;
        ret 4*4;
    }
    L_enter_odd:
        mixin(асмУмножьДоб_вх_одд("add", "ESP"));
}

debug (UnitTest)
{
unittest {
бцел [] aa = new бцел[200];
   бцел [] a  = aa[0..100];
   бцел [] b  = new бцел [100];
   aa[] = 761;
   a[] = 0;
   b[] = 0;
   a[3] = 6;
   b[0]=1;
   b[1] = 17;
   b[50..100]=78;
   многобайтПрямоугАккумАсм(a, b[0..50]);
   бцел [] c = new бцел[100];
   c[] = 0;
   c[1] = 17;
   c[3] = 6;
   assert(a[]==c[]);
   assert(a[0]==0);
   aa[] = 0xFFFF_FFFF;   
   a[] = 0;
   b[] = 0;
   b[0]= 0xbf6a1f01;
   b[1]=  0x6e38ed64;
   b[2]=  0xdaa797ed;
   b[3] = 0;
   
   многобайтПрямоугАккумАсм(a[0..8], b[0..4]);
   assert(a[1]==0x3a600964);
   assert(a[2]==0x339974f6);
   assert(a[3]==0x46736fce);
   assert(a[4]==0x5e24a2b4);
   
   b[3] = 0xe93ff9f4;
   b[4] = 0x184f03;
   a[]=0;
   многобайтПрямоугАккумАсм(a[0..14], b[0..7]);
   assert(a[3]==0x79fff5c2);
   assert(a[4]==0xcf384241);
   assert(a[5]== 0x4a17fc8);
   assert(a[6]==0x4d549025);
}
}


проц многобайтПлощадь(БольшЦифра[] result, БольшЦифра [] x)
{
    if (x.length < 4) {
        // Special cases, not worth doing triangular.
        result[x.length] = многобайтУмнож(result[0..x.length], x, x[0], 0);   
        многобайтУмножАккум(result[1..$], x, x[1..$]);
        return;
    }
    //  Do half a square multИПly.
    //  приёмник += src[0]*src[1...$] + src[1]*src[2..$] + ... + src[$-3]*src[$-2..$]+ src[$-2]*src[$-1]
    result[x.length] = многобайтУмнож!('+')(result[1 .. x.length], x[1..$], x[0], 0);
    многобайтПрямоугАккумАсм(result[2..$], x[1..$]);
    // MultИПly by 2 
    result[$-1] = многобайтСдвигЛБезММХ(result[1..$-1], result[1..$-1], 1);
    // And add the diagonal elements
    result[0] = 0;
    многобайтПрибавьДиагПлощ(result, x);
}

version(TangoPerformanceTest) {
import rt.core.stdc.stdio;
цел clock() { asm { push EBX; xor EAX, EAX; cpuid; pop EBX; rdtsc; } }

бцел [2200] X1;
бцел [2200] Y1;
бцел [4000] Z1;

проц testPerformance()
{
    // The performance results at the top of this file were obtained using
    // a Windows device driver to access the CPU performance counters.
    // The код below is less accurate but ещё wопрely usable.
    // The value for division is quite inconsistent.
    for (цел i=0; i<X1.length; ++i) { X1[i]=i; Y1[i]=i; Z1[i]=i; }
    цел t, t0;    
    многобайтСдвигЛ(Z1[0..2000], X1[0..2000], 7);
    t0 = clock();
    многобайтСдвигЛ(Z1[0..1000], X1[0..1000], 7);
    t = clock();
    многобайтСдвигЛ(Z1[0..2000], X1[0..2000], 7);
    auto shltime = (clock() - t) - (t - t0);
    t0 = clock();
    многобайтСдвигП(Z1[2..1002], X1[4..1004], 13);
    t = clock();
    многобайтСдвигП(Z1[2..2002], X1[4..2004], 13);
    auto shrtime = (clock() - t) - (t - t0);
    t0 = clock();
    многобайтПрибавОтним!('+')(Z1[0..1000], X1[0..1000], Y1[0..1000], 0);
    t = clock();
    многобайтПрибавОтним!('+')(Z1[0..2000], X1[0..2000], Y1[0..2000], 0);
    auto addtime = (clock() - t) - (t-t0);
    t0 = clock();
    многобайтУмнож(Z1[0..1000], X1[0..1000], 7, 0);
    t = clock();
    многобайтУмнож(Z1[0..2000], X1[0..2000], 7, 0);
    auto multime = (clock() - t) - (t - t0);
    многобайтУмножПрибавь!('+')(Z1[0..2000], X1[0..2000], 217, 0);
    t0 = clock();
    многобайтУмножПрибавь!('+')(Z1[0..1000], X1[0..1000], 217, 0);
    t = clock();
    многобайтУмножПрибавь!('+')(Z1[0..2000], X1[0..2000], 217, 0);
    auto muladdtime = (clock() - t) - (t - t0);        
    многобайтУмножАккум(Z1[0..64], X1[0..32], Y1[0..32]);
    t = clock();
    многобайтУмножАккум(Z1[0..64], X1[0..32], Y1[0..32]);
    auto accumtime = clock() - t;
    t0 = clock();
    многобайтПрисвойДеление(Z1[0..2000], 217, 0);
    t = clock();
    многобайтПрисвойДеление(Z1[0..1000], 37, 0);
    auto divtime = (t - t0) - (clock() - t);
	t= clock();
    многобайтПлощадь(Z1[0..64], X1[0..32]);
    auto squaretime = clock() - t;
    
    printf("-- BigInt asm performance (cycles/цел) --\n");    
    printf("Add:        %.2f\n", addtime/1000.0);
    printf("Shl:        %.2f\n", shltime/1000.0);
    printf("Shr:        %.2f\n", shrtime/1000.0);
    printf("Mul:        %.2f\n", multime/1000.0);
    printf("MulAdd:     %.2f\n", muladdtime/1000.0);
    printf("Div:        %.2f\n", divtime/1000.0);
    printf("MulAccum32: %.2f*n*n (total %d)\n", accumtime/(32.0*32.0), accumtime);
    printf("Square32: %.2f*n*n (total %d)\n\n", squaretime/(32.0*32.0), squaretime);
}

static this()
{
    testPerformance();
}
}

} // version(D_InlineAsm_X86)
