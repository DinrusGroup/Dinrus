/**
 * Low-уровень Mathematical Functions which take advantage of the IEEE754 ABI.
 *
 * Copyright: Portions Copyright (C) 2001-2005 Digital Mars.
 * License:   BSD стиль: $(LICENSE), Digital Mars.
 * Authors:   Don Clugston, Walter Bright, Sean Kelly
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
 *
 *  TABLE_SV = <table border=1 cellpдобавьing=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</table>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  SVH3 = $(TR $(TH $1) $(TH $2) $(TH $3))
 *  SV3  = $(TR $(TD $1) $(TD $2) $(TD $3))
 *  NAN = $(RED NAN)
 *  PLUSMN = &plusmn;
 *  INFIN = &infin;
 *  PLUSMNINF = &plusmn;&infin;
 *  PI = &pi;
 *  LT = &lt;
 *  GT = &gt;
 *  SQRT = &radix;
 *  HALF = &frac12;
 */
module math.IEEE;

version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(TangoNoAsm) {

} else version(D_InlineAsm_X86) {
    version = Naked_D_InlineAsm_X86;
}

version (X86){
    version = X86_Any;
}

version (X86_64){
    version = X86_Any;
}

version (Naked_D_InlineAsm_X86) {
    // Don't include this extra dependency unless we need в_.
    debug(UnitTest) {
        static import rt.core.stdc.math;
    }
} else {
    // Needed for кос(), син(), тан() on GNU.
    static import rt.core.stdc.math;
}


version(Windows) { 
    version(DigitalMars) { 
 	    version = DMDWindows; 
    } 
}
 	
// Standard Dinrus НЧ payloads.
// NOTE: These values may change in future Dinrus releases
// The lowest three биты indicate the cause of the НЧ:
// 0 = ошибка другой than those listed below:
// 1 = домен ошибка
// 2 = singularity
// 3 = range
// 4-7 = reserved.
enum TANGO_NAN {
    // General ошибки
    DOMAIN_ERROR = 0x0101,
    SINGULARITY  = 0x0102,
    RANGE_ERROR  = 0x0103,
    // NaNs создан by functions in the basic library
    TAN_DOMAIN   = 0x1001,
    POW_DOMAIN   = 0x1021,
    GAMMA_DOMAIN = 0x1101,
    GAMMA_POLE   = 0x1102,
    SGNGAMMA     = 0x1112,
    BETA_DOMAIN  = 0x1131,
    // NaNs из_ statistical functions
    NORMALDISTRIBUTION_INV_DOMAIN = 0x2001,
    STUDENTSDDISTRIBUTION_DOMAIN  = 0x2011
}

private:
/* Most of the functions depend on the форматируй of the largest IEEE floating-point тип.
 * These код will differ depending on whether 'реал' is 64, 80, or 128 биты,
 * and whether it is a big-эндиан or little-эндиан architecture.
 * Only five 'реал' ABIs are currently supported:
 * 64 bit Биг-эндиан  'дво' (eg PowerPC)
 * 128 bit Биг-эндиан 'quadruple' (eg SPARC)
 * 64 bit Литл-эндиан 'дво' (eg x86-SSE2)
 * 80 bit Литл-эндиан, with implied bit 'real80' (eg x87, Itanium).
 * 128 bit Литл-эндиан 'quadruple' (не реализован on any known процессор!)
 *
 * There is also an unsupported ABI which does not follow IEEE; several of its functions
 *  will generate run-время ошибки if used.
 * 128 bit Биг-эндиан 'doubledouble' (used by GDC <= 0.23 for PowerPC)
 */

version(LittleEndian) {
    static assert(реал.mant_dig == 53 || реал.mant_dig==64 || реал.mant_dig == 113,
        "Only 64-bit, 80-bit, and 128-bit reals are supported for LittleEndian CPUs");
} else {
    static assert(реал.mant_dig == 53 || реал.mant_dig==106 || реал.mant_dig == 113,
     "Only 64-bit and 128-bit reals are supported for БигЭндиан CPUs. дво-дво reals have partial support");
}

// Constants used for extracting the components of the representation.
// They supplement the built-in floating point свойства.
template floatTraits(T) {
 // EXPMASK is a бкрат маска в_ выбери the exponent portion (without sign)
 // SIGNMASK is a бкрат маска в_ выбери the sign bit.
 // EXPPOS_SHORT is the индекс of the exponent when represented as a бкрат Массив.
 // SIGNPOS_BYTE is the индекс of the sign when represented as a ббайт Массив.
 // RECИП_EPSILON is the значение such that (smallest_denormal) * RECИП_EPSILON == T.min
 const T RECИП_EPSILON = (1/T.epsilon);

 static if (T.mant_dig == 24) { // плав
    enum : бкрат {
        EXPMASK = 0x7F80,
        SIGNMASK = 0x8000,
        EXPBIAS = 0x3F00
    }
    const бцел EXPMASK_INT = 0x7F80_0000;
    const бцел MANTISSAMASK_INT = 0x007F_FFFF;
    version(LittleEndian) {        
      const EXPPOS_SHORT = 1;
    } else {
      const EXPPOS_SHORT = 0;
    }
 } else static if (T.mant_dig==53) { // дво, or реал==дво
     enum : бкрат {
         EXPMASK = 0x7FF0,
         SIGNMASK = 0x8000,
         EXPBIAS = 0x3FE0
    }
    const бцел EXPMASK_INT = 0x7FF0_0000;
    const бцел MANTISSAMASK_INT = 0x000F_FFFF; // for the MSB only
    version(LittleEndian) {
      const EXPPOS_SHORT = 3;
      const SIGNPOS_BYTE = 7;
    } else {
      const EXPPOS_SHORT = 0;
      const SIGNPOS_BYTE = 0;
    }
 } else static if (T.mant_dig==64) { // real80
     enum : бкрат {
         EXPMASK = 0x7FFF,
         SIGNMASK = 0x8000,
         EXPBIAS = 0x3FFE
     }
//    const бдол QUIETNANMASK = 0xC000_0000_0000_0000; // Converts a signaling НЧ в_ a quiet НЧ.
    version(LittleEndian) {
      const EXPPOS_SHORT = 4;
      const SIGNPOS_BYTE = 9;
    } else {
      const EXPPOS_SHORT = 0;
      const SIGNPOS_BYTE = 0;
    }
 } else static if (реал.mant_dig==113){ // quadruple
     enum : бкрат {
         EXPMASK = 0x7FFF,
         SIGNMASK = 0x8000,
         EXPBIAS = 0x3FFE
     }
    version(LittleEndian) {
      const EXPPOS_SHORT = 7;
      const SIGNPOS_BYTE = 15;
    } else {
      const EXPPOS_SHORT = 0;
      const SIGNPOS_BYTE = 0;
    }
 } else static if (реал.mant_dig==106) { // doubledouble
     enum : бкрат {
         EXPMASK = 0x7FF0,
         SIGNMASK = 0x8000
//         EXPBIAS = 0x3FE0
     }
    // the exponent байт is not unique
    version(LittleEndian) {
      const EXPPOS_SHORT = 7; // 3 is also an эксп крат
      const SIGNPOS_BYTE = 15;
    } else {
      const EXPPOS_SHORT = 0; // 4 is also an эксп крат
      const SIGNPOS_BYTE = 0;
    }
 }
}

// These apply в_ все floating-point типы
version(LittleEndian) {
    const MANTISSA_LSB = 0;
    const MANTISSA_MSB = 1;    
} else {
    const MANTISSA_LSB = 1;
    const MANTISSA_MSB = 0;
}

public:

/** IEEE исключение статус флаги

 These флаги indicate that an exceptional floating-point condition есть occured.
 They indicate that a НЧ or an infinity есть been generated, that a результат
 is неточно, or that a signalling НЧ есть been encountered.
 The return values of the свойства should be treated as booleans, although
 each is returned as an цел, for скорость.

 Example:
 ----
    реал a=3.5;
    // Набор все the флаги в_ zero
    переустановИ3еФлагов();
    assert(!и3еФлаги.делНаНоль);
    // Perform a division by zero.
    a/=0.0L;
    assert(a==реал.infinity);
    assert(и3еФлаги.делНаНоль);
    // Create a НЧ
    a*=0.0L;
    assert(и3еФлаги.не_годится);
    assert(нч_ли(a));

    // Check that calling func() есть no effect on the
    // статус флаги.
    И3еФлаги f = и3еФлаги;
    func();
    assert(и3еФлаги == f);

 ----
 */
struct И3еФлаги
{
private:
    // The x87 FPU статус регистрируй is 16 биты.
    // The Pentium SSE2 статус регистрируй is 32 биты.
    цел m_flags;
    version (X86_Any) {
        // Applies в_ Всё x87 статус word (16 биты) and SSE2 статус word(32 биты).
        enum : цел {
            INEXACT_MASK   = 0x20,
            UNDERFLOW_MASK = 0x10,
            OVERFLOW_MASK  = 0x08,
            DIVBYZERO_MASK = 0x04,
            INVALID_MASK   = 0x01
        }
        // Don't Всёer about denormals, they are not supported on most CPUs.
        //  DENORMAL_MASK = 0x02;
    } else version (PPC) {
        // PowerPC FPSCR is a 32-bit регистрируй.
        enum : цел {
            INEXACT_MASK   = 0x600,
            UNDERFLOW_MASK = 0x010,
            OVERFLOW_MASK  = 0x008,
            DIVBYZERO_MASK = 0x020,
            INVALID_MASK   = 0xF80
        }
    } else { // SPARC FSR is a 32bit регистрируй
             //(64 биты for Sparc 7 & 8, but high 32 биты are uninteresting).
        enum : цел {
            INEXACT_MASK   = 0x020,
            UNDERFLOW_MASK = 0x080,
            OVERFLOW_MASK  = 0x100,
            DIVBYZERO_MASK = 0x040,
            INVALID_MASK   = 0x200
        }
    }
private:
    static И3еФлаги getIeeeFlags()
    {
        // This is a highly время-critical operation, and
        // should really be an intrinsic.
        version(D_InlineAsm_X86) {
            version(DMDWindows) {
             // In this case, we
             // take advantage of the fact that for DMD-Windows
             // a struct containing only a цел is returned in EAX.
             asm {
                 fstsw AX;
                 // NOTE: If compiler supports SSE2, need в_ OR the результат with
                 // the SSE2 статус регистрируй.
                 // Clear все irrelevant биты
                 and EAX, 0x03D;
             }
           }
           else {
             И3еФлаги tmp1;
             asm {
                 fstsw AX;
                 // NOTE: If compiler supports SSE2, need в_ OR the результат with
                 // the SSE2 статус регистрируй.
                 // Clear все irrelevant биты
                 and EAX, 0x03D;
                 mov tmp1, EAX;
             }
             return tmp1;
           }
       } else version (PPC) {
           assert(0, "Not yet supported");
       } else {
           /*   SPARC:
               цел retval;
               asm { st %fsr, retval; }
               return retval;
            */
           assert(0, "Not yet supported");
       }
    }
    static проц переустановИ3еФлагов()
    {
       version(D_InlineAsm_X86) {
            asm {
                fnclex;
            }
        } else {
            /* SPARC:
              цел tmpval;
              asm { st %fsr, tmpval; }
              tmpval &=0xFFFF_FC00;
              asm { ld tmpval, %fsr; }
            */
           assert(0, "Not yet supported");
        }
    }
public:
    /// The результат cannot be represented exactly, so rounding occured.
    /// (example: x = син(0.1); }
    цел неточно() { return m_flags & INEXACT_MASK; }
    /// A zero was generated by недобор (example: x = реал.min*реал.epsilon/2;)
    цел недобор() { return m_flags & UNDERFLOW_MASK; }
    /// An infinity was generated by перебор (example: x = реал.max*2;)
    цел перебор() { return m_flags & OVERFLOW_MASK; }
    /// An infinity was generated by division by zero (example: x = 3/0.0; )
    цел делНаНоль() { return m_flags & DIVBYZERO_MASK; }
    /// A machine НЧ was generated. (example: x = реал.infinity * 0.0; )
    цел не_годится() { return m_flags & INVALID_MASK; }
}

/// Return a снимок of the current состояние of the floating-point статус флаги.
И3еФлаги и3еФлаги() { return И3еФлаги.getIeeeFlags(); }

/// Набор все of the floating-point статус флаги в_ нет.
проц переустановИ3еФлагов() { И3еФлаги.переустановИ3еФлагов; }

/** IEEE rounding modes.
 * The default режим is НАИБЛИЖАЙШИЙ.
 */
enum РежимОкругления : крат {
    НАИБЛИЖАЙШИЙ = 0x0000,
    ВВЕРХ      = 0x0400,
    ВНИЗ        = 0x0800,
    К_НУЛЮ    = 0x0C00
};

/** Change the rounding режим used for все floating-point operations.
 *
 * Returns the old rounding режим.
 *
 * When changing the rounding режим, it is almost always necessary в_ restore it
 * at the конец of the function. Typical usage:
---
    auto oldrounding = установиИ3еОкругление(РежимОкругления.ВВЕРХ);
    scope (exit) установиИ3еОкругление(oldrounding);
---
 */
РежимОкругления установиИ3еОкругление(РежимОкругления roundingmode) {
   version(D_InlineAsm_X86) {
        // TODO: For SSE/SSE2, do we also need в_ установи the SSE rounding режим?
        крат cont;
        asm {
            fstcw cont;
            mov CX, cont;
            mov AX, cont;
            and EAX, 0x0C00; // Form the return значение
            and CX, 0xF3FF;
            or CX, roundingmode;
            mov cont, CX;
            fldcw cont;
        }
    } else {
           assert(0, "Not yet supported");
    }
}

/** Get the IEEE rounding режим which is in use.
 *
 */
РежимОкругления дайИ3еОкругление() {
   version(D_InlineAsm_X86) {
        // TODO: For SSE/SSE2, do we also need в_ check the SSE rounding режим?
        крат cont;
        asm {
            mov EAX, 0x0C00;
            fstcw cont;
            and AX, cont;
        }
    } else {
           assert(0, "Not yet supported");
    }
}

debug(UnitTest) {
   version(D_InlineAsm_X86) { // Won't work for anything else yet
unittest {
    реал a = 3.5;
    переустановИ3еФлагов();
    assert(!и3еФлаги.делНаНоль);
    a /= 0.0L;
    assert(и3еФлаги.делНаНоль);
    assert(a == реал.infinity);
    a *= 0.0L;
    assert(и3еФлаги.не_годится);
    assert(нч_ли(a));
    a = реал.max;
    a *= 2;
    assert(и3еФлаги.перебор);
    a = реал.min * реал.epsilon;
    a /= 99;
    assert(и3еФлаги.недобор);
    assert(и3еФлаги.неточно);

    цел r = дайИ3еОкругление;
    assert(r == РежимОкругления.НАИБЛИЖАЙШИЙ);
}
}
}

// Note: Itanium supports ещё точность options than this. SSE/SSE2 does not support any.
enum КонтрольТочности : крат {
    ТОЧНОСТЬ80 = 0x300,
    ТОЧНОСТЬ64 = 0x200,
    ТОЧНОСТЬ32 = 0x000
};

/** Набор the число of биты of точность used by 'реал'.
 *
 * Возвращает: the old точность.
 * This is not supported on все platforms.
 */
КонтрольТочности передайТочностьРеала(КонтрольТочности prec) {
   version(D_InlineAsm_X86) {
        крат cont;
        asm {
            fstcw cont;
            mov CX, cont;
            mov AX, cont;
            and EAX, 0x0300; // Form the return значение
            and CX,  0xFCFF;
            or  CX,  prec;
            mov cont, CX;
            fldcw cont;
        }
    } else {
           assert(0, "Not yet supported");
    }
}

/*********************************************************************
 * Separate floating point значение преобр_в significand and exponent.
 *
 * Возвращает:
 *      Calculate and return $(I x) and $(I эксп) such that
 *      значение =$(I x)*2$(SUP эксп) and
 *      .5 $(LT)= |$(I x)| $(LT) 1.0
 *      
 *      $(I x) есть same sign as значение.
 *
 *      $(TABLE_SV
 *      $(TR $(TH значение)           $(TH returns)         $(TH эксп))
 *      $(TR $(TD $(PLUSMN)0.0)    $(TD $(PLUSMN)0.0)    $(TD 0))
 *      $(TR $(TD +$(INFIN))       $(TD +$(INFIN))       $(TD цел.max))
 *      $(TR $(TD -$(INFIN))       $(TD -$(INFIN))       $(TD цел.min))
 *      $(TR $(TD $(PLUSMN)$(NAN)) $(TD $(PLUSMN)$(NAN)) $(TD цел.min))
 *      )
 */
реал frexp(реал значение, out цел эксп)
{
    бкрат* vu = cast(бкрат*)&значение;
    дол* vl = cast(дол*)&значение;
    бцел ex;
    alias floatTraits!(реал) F;

    ex = vu[F.EXPPOS_SHORT] & F.EXPMASK;
  static if (реал.mant_dig == 64) { // real80
    if (ex) { // If exponent is non-zero
        if (ex == F.EXPMASK) {   // infinity or НЧ
            if (*vl &  0x7FFF_FFFF_FFFF_FFFF) {  // НЧ
                *vl |= 0xC000_0000_0000_0000;  // преобразуй $(NAN)S в_ $(NAN)Q
                эксп = цел.min;
            } else if (vu[F.EXPPOS_SHORT] & 0x8000) {   // negative infinity
                эксп = цел.min;
            } else {   // positive infinity
                эксп = цел.max;
            }
        } else {
            эксп = ex - F.EXPBIAS;
            vu[F.EXPPOS_SHORT] = cast(бкрат)((0x8000 & vu[F.EXPPOS_SHORT]) | 0x3FFE);
        }
    } else if (!*vl) {
        // значение is +-0.0
        эксп = 0;
    } else {
        // denormal
        значение *= F.RECИП_EPSILON;
        ex = vu[F.EXPPOS_SHORT] & F.EXPMASK;
        эксп = ex - F.EXPBIAS - 63;
        vu[F.EXPPOS_SHORT] = cast(бкрат)((0x8000 & vu[F.EXPPOS_SHORT]) | 0x3FFE);
    }
    return значение;
  } else static if (реал.mant_dig == 113) { // quadruple      
        if (ex) { // If exponent is non-zero
            if (ex == F.EXPMASK) {   // infinity or НЧ
                if (vl[MANTISSA_LSB] |( vl[MANTISSA_MSB]&0x0000_FFFF_FFFF_FFFF)) {  // НЧ
                    vl[MANTISSA_MSB] |= 0x0000_8000_0000_0000;  // преобразуй $(NAN)S в_ $(NAN)Q
                    эксп = цел.min;
                } else if (vu[F.EXPPOS_SHORT] & 0x8000) {   // negative infinity
                    эксп = цел.min;
                } else {   // positive infinity
                    эксп = цел.max;
                }
            } else {
                эксп = ex - F.EXPBIAS;
                vu[F.EXPPOS_SHORT] = cast(бкрат)((0x8000 & vu[F.EXPPOS_SHORT]) | 0x3FFE);
            }
        } else if ((vl[MANTISSA_LSB] |(vl[MANTISSA_MSB]&0x0000_FFFF_FFFF_FFFF))==0) {
            // значение is +-0.0
            эксп = 0;
    } else {
        // denormal
        значение *= F.RECИП_EPSILON;
        ex = vu[F.EXPPOS_SHORT] & F.EXPMASK;
        эксп = ex - F.EXPBIAS - 113;
        vu[F.EXPPOS_SHORT] = cast(бкрат)((0x8000 & vu[F.EXPPOS_SHORT]) | 0x3FFE);
    }
    return значение;
  } else static if (реал.mant_dig==53) { // реал is дво
    if (ex) { // If exponent is non-zero
        if (ex == F.EXPMASK) {   // infinity or НЧ
            if (*vl==0x7FF0_0000_0000_0000) {  // positive infinity
                эксп = цел.max;
            } else if (*vl==0xFFF0_0000_0000_0000) { // negative infinity
                эксп = цел.min;
            } else { // НЧ
                *vl |= 0x0008_0000_0000_0000;  // преобразуй $(NAN)S в_ $(NAN)Q
                эксп = цел.min;
            }
        } else {
            эксп = (ex - F.EXPBIAS) >>> 4;
            vu[F.EXPPOS_SHORT] = (0x8000 & vu[F.EXPPOS_SHORT]) | 0x3FE0;
        }
    } else if (!(*vl & 0x7FFF_FFFF_FFFF_FFFF)) {
        // значение is +-0.0
        эксп = 0;
    } else {
        // denormal
        бкрат sgn;
        sgn = (0x8000 & vu[F.EXPPOS_SHORT])| 0x3FE0;
        *vl &= 0x7FFF_FFFF_FFFF_FFFF;

        цел i = -0x3FD+11;
        do {
            i--;
            *vl <<= 1;
        } while (*vl > 0);
        эксп = i;
        vu[F.EXPPOS_SHORT] = sgn;
    }
    return значение;
  }else { //static if(реал.mant_dig==106) // doubledouble
        assert(0, "Unsupported");
  }
}

debug(UnitTest) {

unittest
{
    static реал vals[][3] = // x,frexp,эксп
    [
        [0.0,   0.0,    0],
        [-0.0,  -0.0,   0],
        [1.0,   .5, 1],
        [-1.0,  -.5,    1],
        [2.0,   .5, 2],
        [дво.min/2.0, .5, -1022],
        [реал.infinity,реал.infinity,цел.max],
        [-реал.infinity,-реал.infinity,цел.min],
    ];   
    
    цел i;
    цел eptr;
    реал v = frexp(НЧ(0xABC), eptr);
    assert(идентичен_ли(НЧ(0xABC), v));
    assert(eptr ==цел.min);
    v = frexp(-НЧ(0xABC), eptr);
    assert(идентичен_ли(-НЧ(0xABC), v));
    assert(eptr ==цел.min);

    for (i = 0; i < vals.length; i++) {
        реал x = vals[i][0];
        реал e = vals[i][1];
        цел эксп = cast(цел)vals[i][2];
        v = frexp(x, eptr);
//        printf("frexp(%La) = %La, should be %La, eptr = %d, should be %d\n", x, v, e, eptr, эксп);
        assert(идентичен_ли(e, v));
        assert(эксп == eptr);

    }
   static if (реал.mant_dig == 64) {
     static реал extendedvals[][3] = [ // x,frexp,эксп
        [0x1.a5f1c2eb3fe4efp+73L, 0x1.A5F1C2EB3FE4EFp-1L,   74],    // нормаль
        [0x1.fa01712e8f0471ap-1064L,  0x1.fa01712e8f0471ap-1L,     -1063],
        [реал.min,  .5,     -16381],
        [реал.min/2.0L, .5,     -16382]    // denormal
     ];

    for (i = 0; i < extendedvals.length; i++) {
        реал x = extendedvals[i][0];
        реал e = extendedvals[i][1];
        цел эксп = cast(цел)extendedvals[i][2];
        v = frexp(x, eptr);
        assert(идентичен_ли(e, v));
        assert(эксп == eptr);

    }
  }
}
}

/**
 * Compute n * 2$(SUP эксп)
 * References: frexp
 */
реал ldexp(реал n, цел эксп) /* intrinsic */
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {
            fild эксп;
            fld n;
            fscale;
            fstp ST(1), ST(0);
        }
    }
    else
    {
        return rt.core.stdc.math.ldexpl(n, эксп);
    }
}

/******************************************
 * Extracts the exponent of x as a signed integral значение.
 *
 * If x is not a special значение, the результат is the same as
 * $(D cast(цел)logb(x)).
 * 
 * Remarks: This function is consistent with IEEE754R, but it
 * differs из_ the C function of the same имя
 * in the return значение of infinity. (in C, ilogb(реал.infinity)== цел.max).
 * Note that the special return values may все be equal.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                $(TH ilogb(x))     $(TH Invalid?))
 *      $(TR $(TD 0)                 $(TD FP_ILOGB0)   $(TD да))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD FP_ILOGBINFINITY) $(TD да))
 *      $(TR $(TD $(NAN))            $(TD FP_ILOGBNAN) $(TD да))
 *      )
 */
цел ilogb(реал x)
{
        version(Naked_D_InlineAsm_X86)
        {
            цел y;
            asm {
                fld x;
                fxtract;
                fstp ST(0); // drop significand
                fistp y; // and return the exponent
            }
            return y;
        } else static if (реал.mant_dig==64) { // 80-bit reals
            alias floatTraits!(реал) F;
            крат e = cast(крат)((cast(крат *)&x)[F.EXPPOS_SHORT] & F.EXPMASK);
            if (e == F.EXPMASK) {
                // BUG: should also установи the не_годится исключение
                бдол s = *cast(бдол *)&x;
                if (s == 0x8000_0000_0000_0000) {
                    return FP_ILOGBINFINITY;
                }
                else return FP_ILOGBNAN;
            }
            if (e==0) {
                бдол s = *cast(бдол *)&x;
                if (s == 0x0000_0000_0000_0000) {
                    // BUG: should also установи the не_годится исключение
                    return FP_ILOGB0;
                }
                // Denormals
                x *= F.RECИП_EPSILON;
                крат f = (cast(крат *)&x)[F.EXPPOS_SHORT];
                return -0x3FFF - (63-f);
            }
            return e - 0x3FFF;
        } else {
        return rt.core.stdc.math.ilogbl(x);
    }
}

version (X86)
{
    const цел FP_ILOGB0        = -цел.max-1;
    const цел FP_ILOGBNAN      = -цел.max-1;
    const цел FP_ILOGBINFINITY = -цел.max-1;
} else {
    alias rt.core.stdc.math.FP_ILOGB0   FP_ILOGB0;
    alias rt.core.stdc.math.FP_ILOGBNAN FP_ILOGBNAN;
    const цел FP_ILOGBINFINITY = цел.max;
}

debug(UnitTest) {
unittest {
    assert(ilogb(1.0) == 0);
    assert(ilogb(65536) == 16);
    assert(ilogb(-65536) == 16);
    assert(ilogb(1.0 / 65536) == -16);
    assert(ilogb(реал.nan) == FP_ILOGBNAN);
    assert(ilogb(0.0) == FP_ILOGB0);
    assert(ilogb(-0.0) == FP_ILOGB0);
    // denormal
    assert(ilogb(0.125 * реал.min) == реал.min_exp - 4);
    assert(ilogb(реал.infinity) == FP_ILOGBINFINITY);
}
}

/*****************************************
 * Extracts the exponent of x as a signed integral значение.
 *
 * If x is subnormal, it is treated as if it were normalized.
 * For a positive, finite x:
 *
 * 1 $(LT)= $(I x) * FLT_RADIX$(SUP -logb(x)) $(LT) FLT_RADIX
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH logb(x))   $(TH divопрe by 0?) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD +$(INFIN)) $(TD no))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD -$(INFIN)) $(TD да) )
 *      )
 */
реал logb(реал x)
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {
            fld x;
            fxtract;
            fstp ST(0), ST; // drop significand
        }
    } else {
        return rt.core.stdc.math.logbl(x);
    }
}

debug(UnitTest) {
unittest {
    assert(logb(реал.infinity)== реал.infinity);
    assert(идентичен_ли(logb(НЧ(0xFCD)), НЧ(0xFCD)));
    assert(logb(1.0)== 0.0);
    assert(logb(-65536) == 16);
    assert(logb(0.0)== -реал.infinity);
    assert(ilogb(0.125*реал.min) == реал.min_exp-4);
}
}

/*************************************
 * Efficiently calculates x * 2$(SUP n).
 *
 * scalbn handles недобор and перебор in
 * the same fashion as the basic arithmetic operators.
 *
 *  $(TABLE_SV
 *      $(TR $(TH x)                 $(TH scalb(x)))
 *      $(TR $(TD $(PLUSMNINF))      $(TD $(PLUSMNINF)) )
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0) )
 *  )
 */
реал scalbn(реал x, цел n)
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {
            fild n;
            fld x;
            fscale;
            fstp ST(1), ST;
        }
    } else {
        // NOTE: Not implemented in DMD
        return rt.core.stdc.math.scalbnl(x, n);
    }
}

debug(UnitTest) {
unittest {
    assert(scalbn(-реал.infinity, 5) == -реал.infinity);
    assert(идентичен_ли(scalbn(НЧ(0xABC),7), НЧ(0xABC)));
}
}

/**
 * Returns the positive difference between x and y.
 *
 * If either of x or y is $(NAN), it will be returned.
 * Возвращает:
 * $(TABLE_SV
 *  $(SVH Аргументы, fdim(x, y))
 *  $(SV x $(GT) y, x - y)
 *  $(SV x $(LT)= y, +0.0)
 * )
 */
реал fdim(реал x, реал y)
{
    return (x !<= y) ? x - y : +0.0;
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(fdim(НЧ(0xABC), 58.2), НЧ(0xABC)));
}
}

/*******************************
 * Returns |x|
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH fabs(x)))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD +0.0) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD +$(INFIN)) )
 *      )
 */
реал fabs(реал x) /* intrinsic */
{
    version(D_InlineAsm_X86)
    {
        asm {
            fld x;
            fabs;
        }
    }
    else
    {
        return rt.core.stdc.math.fabsl(x);
    }
}

unittest {
    assert(идентичен_ли(fabs(НЧ(0xABC)), НЧ(0xABC)));
}

/**
 * Returns (x * y) + z, rounding only once according в_ the
 * current rounding режим.
 *
 * BUGS: Not currently implemented - rounds twice.
 */
реал fma(плав x, плав y, плав z)
{
    return (x * y) + z;
}

/**
 * Calculate кос(y) + i син(y).
 *
 * On x86 CPUs, this is a very efficient operation;
 * almost twice as fast as calculating син(y) and кос(y)
 * seperately, and is the preferred метод when Всё are required.
 */
креал expi(реал y)
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {            
            fld y;
            fsincos;
            fxch ST(1), ST(0);
        }
    }
    else
    {
        return rt.core.stdc.math.cosl(y) + rt.core.stdc.math.sinl(y)*1i;
    }
}

debug(UnitTest) {
unittest
{
    assert(expi(1.3e5L) == rt.core.stdc.math.cosl(1.3e5L) + rt.core.stdc.math.sinl(1.3e5L) * 1i);
    assert(expi(0.0L) == 1L + 0.0Li);
}
}

/*********************************
 * Returns !=0 if e is a НЧ.
 */

цел нч_ли(реал x)
{
  alias floatTraits!(реал) F;
  static if (реал.mant_dig==53) { // дво
        бдол*  p = cast(бдол *)&x;
        return (*p & 0x7FF0_0000_0000_0000 == 0x7FF0_0000_0000_0000) && *p & 0x000F_FFFF_FFFF_FFFF;
  } else static if (реал.mant_dig==64) {     // real80
        бкрат e = F.EXPMASK & (cast(бкрат *)&x)[F.EXPPOS_SHORT];
        бдол*  ps = cast(бдол *)&x;
        return e == F.EXPMASK &&
            *ps & 0x7FFF_FFFF_FFFF_FFFF; // not infinity
  } else static if (реал.mant_dig==113) {  // quadruple
        бкрат e = F.EXPMASK & (cast(бкрат *)&x)[F.EXPPOS_SHORT];
        бдол*  ps = cast(бдол *)&x;
        return e == F.EXPMASK &&
           (ps[MANTISSA_LSB] | (ps[MANTISSA_MSB]& 0x0000_FFFF_FFFF_FFFF))!=0;
  } else {
      return x!=x;
  }
}


debug(UnitTest) {
unittest
{
    assert(нч_ли(плав.nan));
    assert(нч_ли(-дво.nan));
    assert(нч_ли(реал.nan));

    assert(!нч_ли(53.6));
    assert(!нч_ли(плав.infinity));
}
}

/**
 * Returns !=0 if x is normalized.
 *
 * (Need one for each форматируй because subnormal
 *  floats might be преобразованый в_ нормаль reals)
 */
цел isNormal(X)(X x)
{
    alias floatTraits!(X) F;
    
    static if(реал.mant_dig==106) { // doubledouble
    // doubledouble is нормаль if the least significant часть is нормаль.
        return isNormal((cast(дво*)&x)[MANTISSA_LSB]);
    } else {
        бкрат e = F.EXPMASK & (cast(бкрат *)&x)[F.EXPPOS_SHORT];
        return (e != F.EXPMASK && e!=0);
    }
}

debug(UnitTest) {
unittest
{
    плав f = 3;
    дво d = 500;
    реал e = 10e+48;

    assert(isNormal(f));
    assert(isNormal(d));
    assert(isNormal(e));
    f=d=e=0;
    assert(!isNormal(f));
    assert(!isNormal(d));
    assert(!isNormal(e));
    assert(!isNormal(реал.infinity));
    assert(isNormal(-реал.max));
    assert(!isNormal(реал.min/4));
    
}
}

/*********************************
 * Is the binary representation of x опрentical в_ y?
 *
 * Same as ==, except that positive and negative zero are not опрentical,
 * and two $(NAN)s are опрentical if they have the same 'payload'.
 */

бул идентичен_ли(реал x, реал y)
{
    // We're doing a bitwise comparison so the endianness is irrelevant.
    дол*   pxs = cast(дол *)&x;
    дол*   pys = cast(дол *)&y;
  static if (реал.mant_dig == 53){ //дво
    return pxs[0] == pys[0];
  } else static if (реал.mant_dig == 113 || реал.mant_dig==106) {
      // quadruple or doubledouble
    return pxs[0] == pys[0] && pxs[1] == pys[1];
  } else { // real80
    бкрат* pxe = cast(бкрат *)&x;
    бкрат* pye = cast(бкрат *)&y;
    return pxe[4] == pye[4] && pxs[0] == pys[0];
  }
}

/** ditto */
бул идентичен_ли(вреал x, вреал y) {
    return идентичен_ли(x.im, y.im);
}

/** ditto */
бул идентичен_ли(креал x, креал y) {
    return идентичен_ли(x.re, y.re) && идентичен_ли(x.im, y.im);
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(0.0, 0.0));
    assert(!идентичен_ли(0.0, -0.0));
    assert(идентичен_ли(НЧ(0xABC), НЧ(0xABC)));
    assert(!идентичен_ли(НЧ(0xABC), НЧ(218)));
    assert(идентичен_ли(1.234e56, 1.234e56));
    assert(нч_ли(НЧ(0x12345)));
    assert(идентичен_ли(3.1 + НЧ(0xDEF) * 1i, 3.1 + НЧ(0xDEF)*1i));
    assert(!идентичен_ли(3.1+0.0i, 3.1-0i));
    assert(!идентичен_ли(0.0i, 2.5e58i));
}
}

/*********************************
 * Is число subnormal? (Also called "denormal".)
 * Subnormals have a 0 exponent and a 0 most significant significand bit,
 * but are non-zero.
 */

/* Need one for each форматируй because subnormal floats might
 * be преобразованый в_ нормаль reals.
 */

цел isSubnormal(плав f)
{
    бцел *p = cast(бцел *)&f;
    return (*p & 0x7F80_0000) == 0 && *p & 0x007F_FFFF;
}

debug(UnitTest) {
unittest
{
    плав f = -плав.min;
    assert(!isSubnormal(f));
    f/=4;
    assert(isSubnormal(f));
}
}

/// ditto

цел isSubnormal(дво d)
{
    бцел *p = cast(бцел *)&d;
    return (p[MANTISSA_MSB] & 0x7FF0_0000) == 0 && (p[MANTISSA_LSB] || p[MANTISSA_MSB] & 0x000F_FFFF);
}

debug(UnitTest) {
unittest
{
    дво f;

    for (f = 1; !isSubnormal(f); f /= 2)
    assert(f != 0);
}
}

/// ditto

цел isSubnormal(реал x)
{
    alias floatTraits!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return isSubnormal(cast(дво)x);
    } else static if (реал.mant_dig == 113) { // quadruple        
        бкрат e = F.EXPMASK & (cast(бкрат *)&x)[F.EXPPOS_SHORT];
        дол*   ps = cast(дол *)&x;
        return (e == 0 && (((ps[MANTISSA_LSB]|(ps[MANTISSA_MSB]& 0x0000_FFFF_FFFF_FFFF))) !=0));
    } else static if (реал.mant_dig==64) { // real80
        бкрат* pe = cast(бкрат *)&x;
        дол*   ps = cast(дол *)&x;

        return (pe[F.EXPPOS_SHORT] & F.EXPMASK) == 0 && *ps > 0;
    } else { // дво дво
        return isSubnormal((cast(дво*)&x)[MANTISSA_MSB]);
    }
}

debug(UnitTest) {
unittest
{
    реал f;

    for (f = 1; !isSubnormal(f); f /= 2)
    assert(f != 0);
}
}

/*********************************
 * Return !=0 if x is $(PLUSMN)0.
 *
 * Does not affect any floating-point флаги
 */
цел isZero(реал x)
{
    alias floatTraits!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return ((*cast(бдол *)&x) & 0x7FFF_FFFF_FFFF_FFFF) == 0;
    } else static if (реал.mant_dig == 113) { // quadruple   
        дол*   ps = cast(дол *)&x;
        return (ps[MANTISSA_LSB] | (ps[MANTISSA_MSB]& 0x7FFF_FFFF_FFFF_FFFF)) == 0;
    } else { // real80
        бкрат* pe = cast(бкрат *)&x;
        бдол*  ps = cast(бдол  *)&x;
        return (pe[F.EXPPOS_SHORT] & F.EXPMASK) == 0 && *ps == 0;
    }
}

debug(UnitTest) {
unittest
{
    assert(isZero(0.0));
    assert(isZero(-0.0));
    assert(!isZero(2.5));
    assert(!isZero(реал.min / 1000));
}
}

/*********************************
 * Return !=0 if e is $(PLUSMNINF);.
 */

цел isInfinity(реал x)
{
    alias floatTraits!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return ((*cast(бдол *)&x) & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FF8_0000_0000_0000;
    } else static if(реал.mant_dig == 106) { //doubledouble
        return (((cast(бдол *)&x)[MANTISSA_MSB]) & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FF8_0000_0000_0000;   
    } else static if (реал.mant_dig == 113) { // quadruple   
        дол*   ps = cast(дол *)&x;
        return (ps[MANTISSA_LSB] == 0) 
         && (ps[MANTISSA_MSB] & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FFF_0000_0000_0000;
    } else { // real80
        бкрат e = cast(бкрат)(F.EXPMASK & (cast(бкрат *)&x)[F.EXPPOS_SHORT]);
        бдол*  ps = cast(бдол *)&x;

        return e == F.EXPMASK && *ps == 0x8000_0000_0000_0000;
   }
}

debug(UnitTest) {
unittest
{
    assert(isInfinity(плав.infinity));
    assert(!isInfinity(плав.nan));
    assert(isInfinity(дво.infinity));
    assert(isInfinity(-реал.infinity));

    assert(isInfinity(-1.0 / 0.0));
}
}

/**
 * Calculate the следщ largest floating point значение after x.
 *
 * Return the least число greater than x that is representable as a реал;
 * thus, it gives the следщ point on the IEEE число строка.
 *
 *  $(TABLE_SV
 *    $(SVH x,            следщБольш(x)   )
 *    $(SV  -$(INFIN),    -реал.max   )
 *    $(SV  $(PLUSMN)0.0, реал.min*реал.epsilon )
 *    $(SV  реал.max,     $(INFIN) )
 *    $(SV  $(INFIN),     $(INFIN) )
 *    $(SV  $(NAN),       $(NAN)   )
 * )
 *
 * Remarks:
 * This function is included in the IEEE 754-2008 стандарт.
 * 
 * nextDoubleUp and nextFloatUp are the corresponding functions for
 * the IEEE дво and IEEE плав число lines.
 */
реал следщБольш(реал x)
{
    alias floatTraits!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return nextDoubleUp(x);
    } else static if(реал.mant_dig==113) {  // quadruple
        бкрат e = F.EXPMASK & (cast(бкрат *)&x)[F.EXPPOS_SHORT];
        if (e == F.EXPMASK) { // НЧ or Infinity
             if (x == -реал.infinity) return -реал.max;
             return x; // +Inf and НЧ are unchanged.
        }     
        бдол*   ps = cast(бдол *)&e;
        if (ps[MANTISSA_LSB] & 0x8000_0000_0000_0000)  { // Negative число
            if (ps[MANTISSA_LSB]==0 && ps[MANTISSA_MSB] == 0x8000_0000_0000_0000) { // it was negative zero
                ps[MANTISSA_LSB] = 0x0000_0000_0000_0001; // change в_ smallest subnormal
                ps[MANTISSA_MSB] = 0;
                return x;
            }
            --*ps;
            if (ps[MANTISSA_LSB]==0) --ps[MANTISSA_MSB];
        } else { // Positive число
            ++ps[MANTISSA_LSB];
            if (ps[MANTISSA_LSB]==0) ++ps[MANTISSA_MSB];
        }
        return x;
          
    } else static if(реал.mant_dig==64){ // real80
        // For 80-bit reals, the "implied bit" is a nuisance...
        бкрат *pe = cast(бкрат *)&x;
        бдол  *ps = cast(бдол  *)&x;

        if ((pe[F.EXPPOS_SHORT] & F.EXPMASK) == F.EXPMASK) {
            // First, deal with NANs and infinity
            if (x == -реал.infinity) return -реал.max;
            return x; // +Inf and НЧ are unchanged.
        }
        if (pe[F.EXPPOS_SHORT] & 0x8000)  { // Negative число -- need в_ decrease the significand
            --*ps;
            // Need в_ маска with 0x7FFF... so subnormals are treated correctly.
            if ((*ps & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FFF_FFFF_FFFF_FFFF) {
                if (pe[F.EXPPOS_SHORT] == 0x8000) { // it was negative zero
                    *ps = 1;
                    pe[F.EXPPOS_SHORT] = 0; // smallest subnormal.
                    return x;
                }
                --pe[F.EXPPOS_SHORT];
                if (pe[F.EXPPOS_SHORT] == 0x8000) {
                    return x; // it's become a subnormal, implied bit stays low.
                }
                *ps = 0xFFFF_FFFF_FFFF_FFFF; // установи the implied bit
                return x;
            }
            return x;
        } else {
            // Positive число -- need в_ increase the significand.
            // Works automatically for positive zero.
            ++*ps;
            if ((*ps & 0x7FFF_FFFF_FFFF_FFFF) == 0) {
                // change in exponent
                ++pe[F.EXPPOS_SHORT];
                *ps = 0x8000_0000_0000_0000; // установи the high bit
            }
        }
        return x;
    } else { // doubledouble
        assert(0, "Not implemented");
    }
}

/** ditto */
дво nextDoubleUp(дво x)
{
    бдол *ps = cast(бдол *)&x;

    if ((*ps & 0x7FF0_0000_0000_0000) == 0x7FF0_0000_0000_0000) {
        // First, deal with NANs and infinity
        if (x == -x.infinity) return -x.max;
        return x; // +INF and NAN are unchanged.
    }
    if (*ps & 0x8000_0000_0000_0000)  { // Negative число
        if (*ps == 0x8000_0000_0000_0000) { // it was negative zero
            *ps = 0x0000_0000_0000_0001; // change в_ smallest subnormal
            return x;
        }
        --*ps;
    } else { // Positive число
        ++*ps;
    }
    return x;
}

/** ditto */
плав nextFloatUp(плав x)
{
    бцел *ps = cast(бцел *)&x;

    if ((*ps & 0x7F80_0000) == 0x7F80_0000) {
        // First, deal with NANs and infinity
        if (x == -x.infinity) return -x.max;
        return x; // +INF and NAN are unchanged.
    }
    if (*ps & 0x8000_0000)  { // Negative число
        if (*ps == 0x8000_0000) { // it was negative zero
            *ps = 0x0000_0001; // change в_ smallest subnormal
            return x;
        }
        --*ps;
    } else { // Positive число
        ++*ps;
    }
    return x;
}

debug(UnitTest) {
unittest {
 static if (реал.mant_dig == 64) {

  // Tests for 80-bit reals

    assert(идентичен_ли(следщБольш(НЧ(0xABC)), НЧ(0xABC)));
    // negative numbers
    assert( следщБольш(-реал.infinity) == -реал.max );
    assert( следщБольш(-1-реал.epsilon) == -1.0 );
    assert( следщБольш(-2) == -2.0 + реал.epsilon);
    // denormals and zero
    assert( следщБольш(-реал.min) == -реал.min*(1-реал.epsilon) );
    assert( следщБольш(-реал.min*(1-реал.epsilon) == -реал.min*(1-2*реал.epsilon)) );
    assert( идентичен_ли(-0.0L, следщБольш(-реал.min*реал.epsilon)) );
    assert( следщБольш(-0.0) == реал.min*реал.epsilon );
    assert( следщБольш(0.0) == реал.min*реал.epsilon );
    assert( следщБольш(реал.min*(1-реал.epsilon)) == реал.min );
    assert( следщБольш(реал.min) == реал.min*(1+реал.epsilon) );
    // positive numbers
    assert( следщБольш(1) == 1.0 + реал.epsilon );
    assert( следщБольш(2.0-реал.epsilon) == 2.0 );
    assert( следщБольш(реал.max) == реал.infinity );
    assert( следщБольш(реал.infinity)==реал.infinity );
 }

    assert(идентичен_ли(nextDoubleUp(НЧ(0xABC)), НЧ(0xABC)));
    // negative numbers
    assert( nextDoubleUp(-дво.infinity) == -дво.max );
    assert( nextDoubleUp(-1-дво.epsilon) == -1.0 );
    assert( nextDoubleUp(-2) == -2.0 + дво.epsilon);
    // denormals and zero

    assert( nextDoubleUp(-дво.min) == -дво.min*(1-дво.epsilon) );
    assert( nextDoubleUp(-дво.min*(1-дво.epsilon) == -дво.min*(1-2*дво.epsilon)) );
    assert( идентичен_ли(-0.0, nextDoubleUp(-дво.min*дво.epsilon)) );
    assert( nextDoubleUp(0.0) == дво.min*дво.epsilon );
    assert( nextDoubleUp(-0.0) == дво.min*дво.epsilon );
    assert( nextDoubleUp(дво.min*(1-дво.epsilon)) == дво.min );
    assert( nextDoubleUp(дво.min) == дво.min*(1+дво.epsilon) );
    // positive numbers
    assert( nextDoubleUp(1) == 1.0 + дво.epsilon );
    assert( nextDoubleUp(2.0-дво.epsilon) == 2.0 );
    assert( nextDoubleUp(дво.max) == дво.infinity );

    assert(идентичен_ли(nextFloatUp(НЧ(0xABC)), НЧ(0xABC)));
    assert( nextFloatUp(-плав.min) == -плав.min*(1-плав.epsilon) );
    assert( nextFloatUp(1.0) == 1.0+плав.epsilon );
    assert( nextFloatUp(-0.0) == плав.min*плав.epsilon);
    assert( nextFloatUp(плав.infinity)==плав.infinity );

    assert(следщМеньш(1.0+реал.epsilon)==1.0);
    assert(nextDoubleDown(1.0+дво.epsilon)==1.0);
    assert(nextFloatDown(1.0+плав.epsilon)==1.0);
    assert(nextafter(1.0+реал.epsilon, -реал.infinity)==1.0);
}
}

package {
/** Reduces the magnitude of x, so the биты in the lower half of its significand
 * are все zero. Returns the amount which needs в_ be добавьed в_ x в_ restore its
 * начальное значение; this amount will also have zeros in все биты in the lower half
 * of its significand.
 */
X splitSignificand(X)(ref X x)
{
    if (fabs(x) !< X.infinity) return 0; // don't change НЧ or infinity
    X y = x; // копируй the original значение
    static if (X.mant_dig == плав.mant_dig) {
        бцел *ps = cast(бцел *)&x;
        (*ps) &= 0xFFFF_FC00;
    } else static if (X.mant_dig == 53) {
        бдол *ps = cast(бдол *)&x;
        (*ps) &= 0xFFFF_FFFF_FC00_0000L;
    } else static if (X.mant_dig == 64){ // 80-bit реал
        // An x87 real80 есть 63 биты, because the 'implied' bit is stored explicitly.
        // This is annoying, because it means the significand cannot be
        // precisely halved. Instead, we разбей it преобр_в 31+32 биты.
        бдол *ps = cast(бдол *)&x;
        (*ps) &= 0xFFFF_FFFF_0000_0000L;
    } else static if (X.mant_dig==113) { // quadruple
        бдол *ps = cast(бдол *)&x;
        ps[MANTISSA_LSB] &= 0xFF00_0000_0000_0000L;
    }
    //else static assert(0, "Unsupported размер");

    return y - x;
}

unittest {
    дво x = -0x1.234_567A_AAAA_AAp+250;
    дво y = splitSignificand(x);
    assert(x == -0x1.234_5678p+250);
    assert(y == -0x0.000_000A_AAAA_A8p+248);
    assert(x + y == -0x1.234_567A_AAAA_AAp+250);
}
}

/**
 * Calculate the следщ smallest floating point значение before x.
 *
 * Return the greatest число less than x that is representable as a реал;
 * thus, it gives the previous point on the IEEE число строка.
 *
 *  $(TABLE_SV
 *    $(SVH x,            следщМеньш(x)   )
 *    $(SV  $(INFIN),     реал.max  )
 *    $(SV  $(PLUSMN)0.0, -реал.min*реал.epsilon )
 *    $(SV  -реал.max,    -$(INFIN) )
 *    $(SV  -$(INFIN),    -$(INFIN) )
 *    $(SV  $(NAN),       $(NAN)    )
 * )
 *
 * Remarks:
 * This function is included in the IEEE 754-2008 стандарт.
 * 
 * nextDoubleDown and nextFloatDown are the corresponding functions for
 * the IEEE дво and IEEE плав число lines.
 */
реал следщМеньш(реал x)
{
    return -следщБольш(-x);
}

/** ditto */
дво nextDoubleDown(дво x)
{
    return -nextDoubleUp(-x);
}

/** ditto */
плав nextFloatDown(плав x)
{
    return -nextFloatUp(-x);
}

debug(UnitTest) {
unittest {
    assert( следщМеньш(1.0 + реал.epsilon) == 1.0);
}
}

/**
 * Calculates the следщ representable значение after x in the direction of y.
 *
 * If y > x, the результат will be the следщ largest floating-point значение;
 * if y < x, the результат will be the следщ smallest значение.
 * If x == y, the результат is y.
 *
 * Remarks:
 * This function is not generally very useful; it's almost always better в_ use
 * the faster functions следщБольш() or следщМеньш() instead.
 *
 * IEEE 754 requirements не реализован:
 * The FE_INEXACT and FE_OVERFLOW exceptions will be raised if x is finite and
 * the function результат is infinite. The FE_INEXACT and FE_UNDERFLOW
 * exceptions will be raised if the function значение is subnormal, and x is
 * not equal в_ y.
 */
реал nextafter(реал x, реал y)
{
    if (x==y) return y;
    return (y>x) ? следщБольш(x) : следщМеньш(x);
}

/**************************************
 * To what точность is x equal в_ y?
 *
 * Возвращает: the число of significand биты which are equal in x and y.
 * eg, 0x1.F8p+60 and 0x1.F1p+60 are equal в_ 5 биты of точность.
 *
 *  $(TABLE_SV
 *    $(SVH3 x,      y,         отнравх(x, y)  )
 *    $(SV3  x,      x,         typeof(x).mant_dig )
 *    $(SV3  x,      $(GT)= 2*x, 0 )
 *    $(SV3  x,      $(LE)= x/2, 0 )
 *    $(SV3  $(NAN), any,       0 )
 *    $(SV3  any,    $(NAN),    0 )
 *  )
 *
 * Remarks:
 * This is a very fast operation, suitable for use in скорость-critical код.
 */
цел отнравх(X)(X x, X y)
{
    /* Public Domain. Author: Don Clugston, 18 Aug 2005.
     */
  static assert(is(X==реал) || is(X==дво) || is(X==плав), "Only плав, дво, and реал are supported by отнравх");
  
  static if (X.mant_dig == 106) { // doubledouble.
     цел a = отнравх(cast(дво*)(&x)[MANTISSA_MSB], cast(дво*)(&y)[MANTISSA_MSB]);
     if (a != дво.mant_dig) return a;
     return дво.mant_dig + отнравх(cast(дво*)(&x)[MANTISSA_LSB], cast(дво*)(&y)[MANTISSA_LSB]);     
  } else static if (X.mant_dig==64 || X.mant_dig==113 
                 || X.mant_dig==53 || X.mant_dig == 24) {
    if (x == y) return X.mant_dig; // ensure diff!=0, cope with INF.

    X diff = fabs(x - y);

    бкрат *pa = cast(бкрат *)(&x);
    бкрат *pb = cast(бкрат *)(&y);
    бкрат *pd = cast(бкрат *)(&diff);

    alias floatTraits!(X) F;

    // The difference in абс(exponent) between x or y and абс(x-y)
    // is equal в_ the число of significand биты of x which are
    // equal в_ y. If negative, x and y have different exponents.
    // If positive, x and y are equal в_ 'bitsdiff' биты.
    // AND with 0x7FFF в_ form the абсолютный значение.
    // To avoопр out-by-1 ошибки, we вычти 1 so it rounds down
    // if the exponents were different. This means 'bitsdiff' is
    // always 1 lower than we want, except that if bitsdiff==0,
    // they could have 0 or 1 биты in common.

 static if (X.mant_dig==64 || X.mant_dig==113) { // real80 or quadruple
    цел bitsdiff = ( ((pa[F.EXPPOS_SHORT] & F.EXPMASK) 
                     + (pb[F.EXPPOS_SHORT]& F.EXPMASK)
                     - (0x8000-F.EXPMASK))>>1) 
                - pd[F.EXPPOS_SHORT];
 } else static if (X.mant_dig==53) { // дво
    цел bitsdiff = (( ((pa[F.EXPPOS_SHORT] & F.EXPMASK)
                     + (pb[F.EXPPOS_SHORT] & F.EXPMASK)
                     - (0x8000-F.EXPMASK))>>1) 
                 - (pd[F.EXPPOS_SHORT] & F.EXPMASK))>>4;
 } else static if (X.mant_dig == 24) { // плав
     цел bitsdiff = (( ((pa[F.EXPPOS_SHORT] & F.EXPMASK)
                      + (pb[F.EXPPOS_SHORT] & F.EXPMASK)
                      - (0x8000-F.EXPMASK))>>1) 
             - (pd[F.EXPPOS_SHORT] & F.EXPMASK))>>7;     
 }
    if (pd[F.EXPPOS_SHORT] == 0)
    {   // Difference is denormal
        // For denormals, we need в_ добавь the число of zeros that
        // lie at the старт of diff's significand.
        // We do this by multИПlying by 2^реал.mant_dig
        diff *= F.RECИП_EPSILON;
        return bitsdiff + X.mant_dig - pd[F.EXPPOS_SHORT];
    }

    if (bitsdiff > 0)
        return bitsdiff + 1; // добавь the 1 we subtracted before
        
    // Avoопр out-by-1 ошибки when factor is almost 2.    
     static if (X.mant_dig==64 || X.mant_dig==113) { // real80 or quadruple    
        return (bitsdiff == 0) ? (pa[F.EXPPOS_SHORT] == pb[F.EXPPOS_SHORT]) : 0;
     } else static if (X.mant_dig == 53 || X.mant_dig == 24) { // дво or плав
        return (bitsdiff == 0 && !((pa[F.EXPPOS_SHORT] ^ pb[F.EXPPOS_SHORT])& F.EXPMASK)) ? 1 : 0;
     }
 } else {
    assert(0, "Unsupported");
 }
}

debug(UnitTest) {
unittest
{
   // Exact equality
   assert(отнравх(реал.max,реал.max)==реал.mant_dig);
   assert(отнравх(0.0L,0.0L)==реал.mant_dig);
   assert(отнравх(7.1824L,7.1824L)==реал.mant_dig);
   assert(отнравх(реал.infinity,реал.infinity)==реал.mant_dig);

   // a few биты away из_ exact equality
   реал w=1;
   for (цел i=1; i<реал.mant_dig-1; ++i) {
      assert(отнравх(1+w*реал.epsilon,1.0L)==реал.mant_dig-i);
      assert(отнравх(1-w*реал.epsilon,1.0L)==реал.mant_dig-i);
      assert(отнравх(1.0L,1+(w-1)*реал.epsilon)==реал.mant_dig-i+1);
      w*=2;
   }
   assert(отнравх(1.5+реал.epsilon,1.5L)==реал.mant_dig-1);
   assert(отнравх(1.5-реал.epsilon,1.5L)==реал.mant_dig-1);
   assert(отнравх(1.5-реал.epsilon,1.5+реал.epsilon)==реал.mant_dig-2);
   
   assert(отнравх(реал.min/8,реал.min/17)==3);;
   
   // Numbers that are закрой
   assert(отнравх(0x1.Bp+84, 0x1.B8p+84)==5);
   assert(отнравх(0x1.8p+10, 0x1.Cp+10)==2);
   assert(отнравх(1.5*(1-реал.epsilon), 1.0L)==2);
   assert(отнравх(1.5, 1.0)==1);
   assert(отнравх(2*(1-реал.epsilon), 1.0L)==1);

   // Factors of 2
   assert(отнравх(реал.max,реал.infinity)==0);
   assert(отнравх(2*(1-реал.epsilon), 1.0L)==1);
   assert(отнравх(1.0, 2.0)==0);
   assert(отнравх(4.0, 1.0)==0);

   // Extreme inequality
   assert(отнравх(реал.nan,реал.nan)==0);
   assert(отнравх(0.0L,-реал.nan)==0);
   assert(отнравх(реал.nan,реал.infinity)==0);
   assert(отнравх(реал.infinity,-реал.infinity)==0);
   assert(отнравх(-реал.max,реал.infinity)==0);
   assert(отнравх(реал.max,-реал.max)==0);
   
   // floats
   assert(отнравх(2.1f, 2.1f)==плав.mant_dig);
   assert(отнравх(1.5f, 1.0f)==1);
}
}

/*********************************
 * Return 1 if sign bit of e is установи, 0 if not.
 */

цел signbit(реал x)
{
    return ((cast(ббайт *)&x)[floatTraits!(реал).SIGNPOS_BYTE] & 0x80) != 0;
}

debug(UnitTest) {
unittest
{
    assert(!signbit(плав.nan));
    assert(signbit(-плав.nan));
    assert(!signbit(168.1234));
    assert(signbit(-168.1234));
    assert(!signbit(0.0));
    assert(signbit(-0.0));
}
}


/*********************************
 * Return a значение composed of в_ with из_'s sign bit.
 */

реал copysign(реал в_, реал из_)
{
    ббайт* pto   = cast(ббайт *)&в_;
    ббайт* pfrom = cast(ббайт *)&из_;
    
    alias floatTraits!(реал) F;
    pto[F.SIGNPOS_BYTE] &= 0x7F;
    pto[F.SIGNPOS_BYTE] |= pfrom[F.SIGNPOS_BYTE] & 0x80;
    return в_;
}

debug(UnitTest) {
unittest
{
    реал e;

    e = copysign(21, 23.8);
    assert(e == 21);

    e = copysign(-21, 23.8);
    assert(e == 21);

    e = copysign(21, -23.8);
    assert(e == -21);

    e = copysign(-21, -23.8);
    assert(e == -21);

    e = copysign(реал.nan, -23.8);
    assert(нч_ли(e) && signbit(e));
}
}

/** Return the значение that lies halfway between x and y on the IEEE число строка.
 *
 * Formally, the результат is the arithmetic mean of the binary significands of x
 * and y, multИПlied by the geometric mean of the binary exponents of x and y.
 * x and y must have the same sign, and must not be НЧ.
 * Note: this function is useful for ensuring O(лог n) behaviour in algorithms
 * involving a 'binary chop'.
 *
 * Special cases:
 * If x and y are within a factor of 2, (ie, отнравх(x, y) > 0), the return значение
 * is the arithmetic mean (x + y) / 2.
 * If x and y are even powers of 2, the return значение is the geometric mean,
 *   ieeeMean(x, y) = квкор(x * y).
 *
 */
T ieeeMean(T)(T x, T y)
in {
    // Всё x and y must have the same sign, and must not be НЧ.
    assert(signbit(x) == signbit(y)); 
    assert(x<>=0 && y<>=0);
}
body {
    // Runtime behaviour for contract violation:
    // If signs are opposite, or one is a НЧ, return 0.
    if (!((x>=0 && y>=0) || (x<=0 && y<=0))) return 0.0;

    // The implementation is simple: cast x and y в_ целыйs,
    // average them (avoопрing перебор), and cast the результат back в_ a floating-point число.

    alias floatTraits!(реал) F;
    T u;
    static if (T.mant_dig==64) { // real80
        // There's slight добавьitional complexity because they are actually
        // 79-bit reals...
        бкрат *ue = cast(бкрат *)&u;
        бдол *ul = cast(бдол *)&u;
        бкрат *xe = cast(бкрат *)&x;
        бдол *xl = cast(бдол *)&x;
        бкрат *ye = cast(бкрат *)&y;
        бдол *yl = cast(бдол *)&y;
        // Ignore the useless implicit bit. (Bonus: this prevents overflows)
        бдол m = ((*xl) & 0x7FFF_FFFF_FFFF_FFFFL) + ((*yl) & 0x7FFF_FFFF_FFFF_FFFFL);

        бкрат e = cast(бкрат)((xe[F.EXPPOS_SHORT] & 0x7FFF) + (ye[F.EXPPOS_SHORT] & 0x7FFF));
        if (m & 0x8000_0000_0000_0000L) {
            ++e;
            m &= 0x7FFF_FFFF_FFFF_FFFFL;
        }
        // Сейчас do a multi-байт right shift
        бцел c = e & 1; // carry
        e >>= 1;
        m >>>= 1;
        if (c) m |= 0x4000_0000_0000_0000L; // shift carry преобр_в significand
        if (e) *ul = m | 0x8000_0000_0000_0000L; // установи implicit bit...
        else *ul = m; // ... unless exponent is 0 (denormal or zero).
        ue[4]=  e | (xe[F.EXPPOS_SHORT]& F.SIGNMASK); // restore sign bit
    } else static if(T.mant_dig == 113) { //quadruple
        // This would be trivial if 'ucent' were implemented...
        бдол *ul = cast(бдол *)&u;
        бдол *xl = cast(бдол *)&x;
        бдол *yl = cast(бдол *)&y;
        // Multi-байт добавь, then multi-байт right shift.        
        бдол mh = ((xl[MANTISSA_MSB] & 0x7FFF_FFFF_FFFF_FFFFL) 
                  + (yl[MANTISSA_MSB] & 0x7FFF_FFFF_FFFF_FFFFL));
        // Discard the lowest bit (в_ avoопр перебор)
        бдол ml = (xl[MANTISSA_LSB]>>>1) + (yl[MANTISSA_LSB]>>>1);
        // добавь the lowest bit back in, if necessary.
        if (xl[MANTISSA_LSB] & yl[MANTISSA_LSB] & 1) {
            ++ml;
            if (ml==0) ++mh;
        }
        mh >>>=1;
        ul[MANTISSA_MSB] = mh | (xl[MANTISSA_MSB] & 0x8000_0000_0000_0000);
        ul[MANTISSA_LSB] = ml;
    } else static if (T.mant_dig == дво.mant_dig) {
        бдол *ul = cast(бдол *)&u;
        бдол *xl = cast(бдол *)&x;
        бдол *yl = cast(бдол *)&y;
        бдол m = (((*xl) & 0x7FFF_FFFF_FFFF_FFFFL) + ((*yl) & 0x7FFF_FFFF_FFFF_FFFFL)) >>> 1;
        m |= ((*xl) & 0x8000_0000_0000_0000L);
        *ul = m;
    } else static if (T.mant_dig == плав.mant_dig) {
        бцел *ul = cast(бцел *)&u;
        бцел *xl = cast(бцел *)&x;
        бцел *yl = cast(бцел *)&y;
        бцел m = (((*xl) & 0x7FFF_FFFF) + ((*yl) & 0x7FFF_FFFF)) >>> 1;
        m |= ((*xl) & 0x8000_0000);
        *ul = m;
    } else {
        assert(0, "Not implemented");
    }
    return u;
}

debug(UnitTest) {
unittest {
    assert(ieeeMean(-0.0,-1e-20)<0);
    assert(ieeeMean(0.0,1e-20)>0);

    assert(ieeeMean(1.0L,4.0L)==2L);
    assert(ieeeMean(2.0*1.013,8.0*1.013)==4*1.013);
    assert(ieeeMean(-1.0L,-4.0L)==-2L);
    assert(ieeeMean(-1.0,-4.0)==-2);
    assert(ieeeMean(-1.0f,-4.0f)==-2f);
    assert(ieeeMean(-1.0,-2.0)==-1.5);
    assert(ieeeMean(-1*(1+8*реал.epsilon),-2*(1+8*реал.epsilon))==-1.5*(1+5*реал.epsilon));
    assert(ieeeMean(0x1p60,0x1p-10)==0x1p25);
    static if (реал.mant_dig==64) { // x87, 80-bit reals
      assert(ieeeMean(1.0L,реал.infinity)==0x1p8192L);
      assert(ieeeMean(0.0L,реал.infinity)==1.5);
    }
    assert(ieeeMean(0.5*реал.min*(1-4*реал.epsilon),0.5*реал.min)==0.5*реал.min*(1-2*реал.epsilon));
}
}

// Functions for НЧ payloads
/*
 * A 'payload' can be stored in the significand of a $(NAN). One bit is required
 * в_ distinguish between a quiet and a signalling $(NAN). This leaves 22 биты
 * of payload for a плав; 51 биты for a дво; 62 биты for an 80-bit реал;
 * and 111 биты for a 128-bit quad.
*/
/**
 * Create a $(NAN), storing an целое insопрe the payload.
 *
 * For 80-bit or 128-bit reals, the largest possible payload is 0x3FFF_FFFF_FFFF_FFFF.
 * For doubles, it is 0x3_FFFF_FFFF_FFFF.
 * For floats, it is 0x3F_FFFF.
 */
реал НЧ(бдол payload)
{
    static if (реал.mant_dig == 64) { //real80
      бдол v = 3; // implied bit = 1, quiet bit = 1
    } else {
      бдол v = 2; // no implied bit. quiet bit = 1
    }

    бдол a = payload;

    // 22 Float биты
    бдол w = a & 0x3F_FFFF;
    a -= w;

    v <<=22;
    v |= w;
    a >>=22;

    // 29 Double биты
    v <<=29;
    w = a & 0xFFF_FFFF;
    v |= w;
    a -= w;
    a >>=29;

    static if (реал.mant_dig == 53) { // дво
        v |=0x7FF0_0000_0000_0000;
        реал x;
        * cast(бдол *)(&x) = v;
        return x;
    } else {
        v <<=11;
        a &= 0x7FF;
        v |= a;
        реал x = реал.nan;
        // Extended реал биты
        static if (реал.mant_dig==113) { //quadruple
          v<<=1; // there's no implicit bit
          version(LittleEndian) {
            *cast(бдол*)(6+cast(ббайт*)(&x)) = v;
          } else {
            *cast(бдол*)(2+cast(ббайт*)(&x)) = v;
          }        
        } else { // real80
            * cast(бдол *)(&x) = v;
        }
        return x;
    }
}

/**
 * Extract an integral payload из_ a $(NAN).
 *
 * Возвращает:
 * the целое payload as a бдол.
 *
 * For 80-bit or 128-bit reals, the largest possible payload is 0x3FFF_FFFF_FFFF_FFFF.
 * For doubles, it is 0x3_FFFF_FFFF_FFFF.
 * For floats, it is 0x3F_FFFF.
 */
бдол getNaNPayload(реал x)
{
    assert(нч_ли(x));
    static if (реал.mant_dig == 53) {
        бдол m = *cast(бдол *)(&x);
        // Make it look like an 80-bit significand.
        // SkИП exponent, and quiet bit
        m &= 0x0007_FFFF_FFFF_FFFF;
        m <<= 10;
    } else static if (реал.mant_dig==113) { // quadruple
        version(LittleEndian) {
            бдол m = *cast(бдол*)(6+cast(ббайт*)(&x));
        } else {
            бдол m = *cast(бдол*)(2+cast(ббайт*)(&x));
        }
        m>>=1; // there's no implicit bit
    } else {
        бдол m = *cast(бдол *)(&x);
    }
    // ignore implicit bit and quiet bit
    бдол f = m & 0x3FFF_FF00_0000_0000L;
    бдол w = f >>> 40;
    w |= (m & 0x00FF_FFFF_F800L) << (22 - 11);
    w |= (m & 0x7FF) << 51;
    return w;
}

debug(UnitTest) {
unittest {
  реал nan4 = НЧ(0x789_ABCD_EF12_3456);
  static if (реал.mant_dig == 64 || реал.mant_dig==113) {
      assert (getNaNPayload(nan4) == 0x789_ABCD_EF12_3456);
  } else {
      assert (getNaNPayload(nan4) == 0x1_ABCD_EF12_3456);
  }
  дво nan5 = nan4;
  assert (getNaNPayload(nan5) == 0x1_ABCD_EF12_3456);
  плав nan6 = nan4;
  assert (getNaNPayload(nan6) == 0x12_3456);
  nan4 = НЧ(0xFABCD);
  assert (getNaNPayload(nan4) == 0xFABCD);
  nan6 = nan4;
  assert (getNaNPayload(nan6) == 0xFABCD);
  nan5 = НЧ(0x100_0000_0000_3456);
  assert(getNaNPayload(nan5) == 0x0000_0000_3456);
}
}

