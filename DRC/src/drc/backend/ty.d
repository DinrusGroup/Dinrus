/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1983-1998 by Symantec
 *              Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/ty.d, backend/_ty.d)
 */

module drc.backend.ty;

// Online documentation: https://dlang.org/phobos/dmd_backend_ty.html

/*extern (C++):*/
/*:*/


alias  бцел tym_t;

/*****************************************
 * Data types.
 * (consists of basic тип + modifier bits)
 */

// Basic types.
// casttab[][] in exp2.c depends on the order of this
// typromo[] in cpp.c depends on the order too

enum
{
    TYбул              = 0,
    TYchar              = 1,
    TYschar             = 2,    // signed сим
    TYuchar             = 3,    // unsigned сим
    TYchar8             = 4,
    TYchar16            = 5,
    TYshort             = 6,
    TYwchar_t           = 7,
    TYushort            = 8,    // unsigned short
    TYenum              = 9,    // enumeration значение
    TYint               = 0xA,
    TYuint              = 0xB,  // unsigned
    TYlong              = 0xC,
    TYulong             = 0xD,  // unsigned long
    TYdchar             = 0xE,  // 32 bit Unicode сим
    TYllong             = 0xF,  // 64 bit long
    TYullong            = 0x10, // 64 bit unsigned long
    TYfloat             = 0x11, // 32 bit real
    TYdouble            = 0x12, // 64 bit real

    // long double is mapped to either of the following at runtime:
    TYdouble_alias      = 0x13, // 64 bit real (but distinct for overload purposes)
    TYldouble           = 0x14, // 80 bit real

    // Add imaginary and complex types for D and C99
    TYifloat            = 0x15,
    TYidouble           = 0x16,
    TYildouble          = 0x17,
    TYcfloat            = 0x18,
    TYcdouble           = 0x19,
    TYcldouble          = 0x1A,

    TYnullptr           = 0x1C,
    TYnptr              = 0x1D, // данные segment relative pointer
    TYref               = 0x24, // reference to another тип
    TYvoid              = 0x25,
    TYstruct            = 0x26, // watch tyaggregate()
    TYarray             = 0x27, // watch tyaggregate()
    TYnfunc             = 0x28, // near C func
    TYnpfunc            = 0x2A, // near Cpp func
    TYnsfunc            = 0x2C, // near stdcall func
    TYifunc             = 0x2E, // interrupt func
    TYptr               = 0x33, // generic pointer тип
    TYmfunc             = 0x37, // NT C++ member func
    TYjfunc             = 0x38, // LINK.d D function
    TYhfunc             = 0x39, // C function with hidden параметр
    TYnref              = 0x3A, // near reference

    TYcent              = 0x3C, // 128 bit signed integer
    TYucent             = 0x3D, // 128 bit unsigned integer

    // Used for segmented architectures
    TYsptr              = 0x1E, // stack segment relative pointer
    TYcptr              = 0x1F, // code segment relative pointer
    TYf16ptr            = 0x20, // special OS/2 far16 pointer
    TYfptr              = 0x21, // far pointer (has segment and смещение)
    TYhptr              = 0x22, // huge pointer (has segment and смещение)
    TYvptr              = 0x23, // __handle pointer (has segment and смещение)
    TYffunc             = 0x29, // far  C func
    TYfpfunc            = 0x2B, // far  Cpp func
    TYfsfunc            = 0x2D, // far stdcall func
    TYf16func           = 0x34, // _far16 _pascal function
    TYnsysfunc          = 0x35, // near __syscall func
    TYfsysfunc          = 0x36, // far __syscall func
    TYfref              = 0x3B, // far reference

    // Used for C++ compiler
    TYmemptr            = 0x2F, // pointer to member
    TYident             = 0x30, // тип-argument
    TYtemplate          = 0x31, // unexpanded class template
    TYvtshape           = 0x32, // virtual function table

    // SIMD 16 byte vector types        // D тип
    TYfloat4            = 0x3E, // float[4]
    TYdouble2           = 0x3F, // double[2]
    TYschar16           = 0x40, // byte[16]
    TYuchar16           = 0x41, // ббайт[16]
    TYshort8            = 0x42, // short[8]
    TYushort8           = 0x43, // ushort[8]
    TYlong4             = 0x44, // цел[4]
    TYulong4            = 0x45, // бцел[4]
    TYllong2            = 0x46, // long[2]
    TYullong2           = 0x47, // бдол[2]

    // SIMD 32 byte vector types        // D тип
    TYfloat8            = 0x48, // float[8]
    TYdouble4           = 0x49, // double[4]
    TYschar32           = 0x4A, // byte[32]
    TYuchar32           = 0x4B, // ббайт[32]
    TYshort16           = 0x4C, // short[16]
    TYushort16          = 0x4D, // ushort[16]
    TYlong8             = 0x4E, // цел[8]
    TYulong8            = 0x4F, // бцел[8]
    TYllong4            = 0x50, // long[4]
    TYullong4           = 0x51, // бдол[4]

    // SIMD 64 byte vector types        // D тип
    TYfloat16           = 0x52, // float[16]
    TYdouble8           = 0x53, // double[8]
    TYschar64           = 0x54, // byte[64]
    TYuchar64           = 0x55, // ббайт[64]
    TYshort32           = 0x56, // short[32]
    TYushort32          = 0x57, // ushort[32]
    TYlong16            = 0x58, // цел[16]
    TYulong16           = 0x59, // бцел[16]
    TYllong8            = 0x5A, // long[8]
    TYullong8           = 0x5B, // бдол[8]

    TYsharePtr          = 0x5C, // pointer to shared данные
    TYimmutPtr          = 0x5D, // pointer to const данные
    TYfgPtr             = 0x5E, // GS: pointer (I32) FS: pointer (I64)

    TYMAX               = 0x5F,
}

alias TYint TYerror;

extern  цел TYaarray;                            // D тип

// These change depending on memory model
extern  цел TYdelegate, TYdarray;                // D types
extern  цел TYptrdiff, TYsize, TYт_мера;

enum
{
    mTYbasic        = 0xFF,          // bit mask for basic types

   // Linkage тип
    mTYnear         = 0x0800,
    mTYfar          = 0x1000,        // seg:смещение style pointer
    mTYcs           = 0x2000,        // in code segment
    mTYthread       = 0x4000,

    // Used for symbols going in the __thread_data section for TLS variables for Mach-O 64bit
    mTYthreadData   = 0x5000,
    mTYLINK         = 0x7800,        // all компонаж bits

    mTYloadds       = 0x08000,       // 16 bit Windows LOADDS attribute
    mTYexport       = 0x10000,
    mTYweak         = 0x00000,
    mTYimport       = 0x20000,
    mTYnaked        = 0x40000,
    mTYMOD          = 0x78000,       // all modifier bits

    // Modifiers to basic types

    mTYarrayhandle  = 0x0,
    mTYconst        = 0x100,
    mTYvolatile     = 0x200,
    mTYrestrict     = 0,             // BUG: add for C99
    mTYmutable      = 0,             // need to add support
    mTYunaligned    = 0,             // non-нуль for PowerPC

    mTYimmutable    = 0x00080000,    // const данные
    mTYshared       = 0x00100000,    // shared данные
    mTYnothrow      = 0x00200000,    //  function

    // Used only by C/C++ compiler
//#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS
    mTYnoret        = 0x01000000,    // function has no return
    mTYtransu       = 0x01000000,    // transparent union
//#else
    mTYfar16        = 0x01000000,
//#endif
    mTYstdcall      = 0x02000000,
    mTYfastcall     = 0x04000000,
    mTYinterrupt    = 0x08000000,
    mTYcdecl        = 0x10000000,
    mTYpascal       = 0x20000000,
    mTYsyscall      = 0x40000000,
    mTYjava         = 0x80000000,

//#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS
//    mTYTFF          = 0xFE000000,
//#else
    mTYTFF          = 0xFF000000,
//#endif
}


tym_t tybasic(tym_t ty) { return ty & mTYbasic; }

/* Flags in tytab[] массив       */
extern  бцел[256] tytab;
enum
{
    TYFLptr         = 1,
    TYFLreal        = 2,
    TYFLintegral    = 4,
    TYFLcomplex     = 8,
    TYFLimaginary   = 0x10,
    TYFLuns         = 0x20,
    TYFLmptr        = 0x40,
    TYFLfv          = 0x80,       // TYfptr || TYvptr

    TYFLpascal      = 0x200,      // callee cleans up stack
    TYFLrevparam    = 0x400,      // function parameters are reversed
    TYFLnullptr     = 0x800,
    TYFLshort       = 0x1000,
    TYFLaggregate   = 0x2000,
    TYFLfunc        = 0x4000,
    TYFLref         = 0x8000,
    TYFLsimd        = 0x20000,    // SIMD vector тип
    TYFLfarfunc     = 0x100,      // __far functions (for segmented architectures)
    TYFLxmmreg      = 0x10000,    // can be put in XMM register
}

/* МассивДРК to give the size in bytes of a тип, -1 means error    */
extern  byte[256] _tysize;
extern  byte[256] _tyalignsize;

// Give size of тип
byte tysize(tym_t ty)      { return _tysize[ty & 0xFF]; }
byte tyalignsize(tym_t ty) { return _tyalignsize[ty & 0xFF]; }


/* Groupings of types   */

бцел tyintegral(tym_t ty) { return tytab[ty & 0xFF] & TYFLintegral; }

бцел tyarithmetic(tym_t ty) { return tytab[ty & 0xFF] & (TYFLintegral | TYFLreal | TYFLimaginary | TYFLcomplex); }

бцел tyaggregate(tym_t ty) { return tytab[ty & 0xFF] & TYFLaggregate; }

бцел tyscalar(tym_t ty) { return tytab[ty & 0xFF] & (TYFLintegral | TYFLreal | TYFLimaginary | TYFLcomplex | TYFLptr | TYFLmptr | TYFLnullptr | TYFLref); }

бцел tyfloating(tym_t ty) { return tytab[ty & 0xFF] & (TYFLreal | TYFLimaginary | TYFLcomplex); }

бцел tyimaginary(tym_t ty) { return tytab[ty & 0xFF] & TYFLimaginary; }

бцел tycomplex(tym_t ty) { return tytab[ty & 0xFF] & TYFLcomplex; }

бцел tyreal(tym_t ty) { return tytab[ty & 0xFF] & TYFLreal; }

// Fits into 64 bit register
бул ty64reg(tym_t ty) { return tytab[ty & 0xFF] & (TYFLintegral | TYFLptr | TYFLref) && tysize(ty) <= _tysize[TYnptr]; }

// Can go in XMM floating point register
бцел tyxmmreg(tym_t ty) { return tytab[ty & 0xFF] & TYFLxmmreg; }

// Is a vector тип
бул tyvector(tym_t ty) { return tybasic(ty) >= TYfloat4 && tybasic(ty) <= TYullong4; }

/* Types that are chars or shorts       */
бцел tyshort(tym_t ty) { return tytab[ty & 0xFF] & TYFLshort; }

/* Detect TYlong or TYulong     */
бул tylong(tym_t ty) { return tybasic(ty) == TYlong || tybasic(ty) == TYulong; }

/* Use to detect a pointer тип */
бцел typtr(tym_t ty) { return tytab[ty & 0xFF] & TYFLptr; }

/* Use to detect a reference тип */
бцел tyref(tym_t ty) { return tytab[ty & 0xFF] & TYFLref; }

/* Use to detect a pointer тип or a member pointer     */
бцел tymptr(tym_t ty) { return tytab[ty & 0xFF] & (TYFLptr | TYFLmptr); }

// Use to detect a nullptr тип or a member pointer
бцел tynullptr(tym_t ty) { return tytab[ty & 0xFF] & TYFLnullptr; }

/* Detect TYfptr or TYvptr      */
бцел tyfv(tym_t ty) { return tytab[ty & 0xFF] & TYFLfv; }

/* All данные types that fit in exactly 8 bits    */
бул tybyte(tym_t ty) { return tysize(ty) == 1; }

/* Types that fit into a single machine register        */
бул tyreg(tym_t ty) { return tysize(ty) <= _tysize[TYnptr]; }

/* Detect function тип */
бцел tyfunc(tym_t ty) { return tytab[ty & 0xFF] & TYFLfunc; }

/* Detect function тип where parameters are pushed left to right    */
бцел tyrevfunc(tym_t ty) { return tytab[ty & 0xFF] & TYFLrevparam; }

/* Detect бцел types */
бцел tyuns(tym_t ty) { return tytab[ty & 0xFF] & (TYFLuns | TYFLptr); }

/* Target dependent info        */
alias TYuint TYoffset;         // смещение to an address

/* Detect cpp function тип (callee cleans up stack)    */
бцел typfunc(tym_t ty) { return tytab[ty & 0xFF] & TYFLpascal; }

/* МассивДРК to convert a тип to its unsigned equivalent   */
extern  tym_t[256] tytouns;
tym_t touns(tym_t ty) { return tytouns[ty & 0xFF]; }

/* Determine if TYffunc or TYfpfunc (a far function) */
бцел tyfarfunc(tym_t ty) { return tytab[ty & 0xFF] & TYFLfarfunc; }

// Determine if параметр is a SIMD vector тип
бцел tysimd(tym_t ty) { return tytab[ty & 0xFF] & TYFLsimd; }

/* Determine relaxed тип       */
extern  ббайт[TYMAX] _tyrelax;
бцел tyrelax(tym_t ty) { return _tyrelax[tybasic(ty)]; }


/* Determine functionally equivalent тип       */
extern  ббайт[TYMAX] tyequiv;

/* Give an ascii ткст for a тип      */
extern (C) { extern  сим*[TYMAX] tystring; }

/* Debugger значение for тип      */
extern  ббайт[TYMAX] dttab;
extern  ushort[TYMAX] dttab4;


бул I16() { return _tysize[TYnptr] == 2; }
бул I32() { return _tysize[TYnptr] == 4; }
бул I64() { return _tysize[TYnptr] == 8; }

