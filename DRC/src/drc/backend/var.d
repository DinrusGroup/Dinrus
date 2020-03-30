/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/var.d, backend/var.d)
 */

module drc.backend.var;

/* Global variables for PARSER  */

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.dlist;
import drc.backend.goh;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.ty;
import drc.backend.тип;

version (SPP)
{
    import parser;
    import phstring;
}
version (SCPP)
{
    import parser;
    import phstring;
}
version (HTOD)
{
    import parser;
    import phstring;
}

/*extern (C++):*/



/* Global flags:
 */

сим PARSER = 0;                    // indicate we're in the parser
сим OPTIMIZER = 0;                 // indicate we're in the optimizer
цел structalign;                /* alignment for члены of structures  */
сим dbcs = 0;                      // current double byte character set

цел TYptrdiff = TYint;
цел TYsize = TYuint;
цел TYт_мера = TYuint;
цел TYaarray = TYnptr;
цел TYdelegate = TYllong;
цел TYdarray = TYullong;

сим debuga=0,debugb=0,debugc=0,debugd=0,debuge=0,debugf=0,debugr=0,debugs=0,debugt=0,debugu=0,debugw=0,debugx=0,debugy=0;

version (Dinrus) { } else
{
linkage_t компонаж;
цел linkage_spec = 0;           /* using the default                    */

/* Function types       */
/* LINK_MAXDIM = C,C++,Pascal,FORTRAN,syscall,stdcall,Mars */
static if (MEMMODELS == 1)
{
tym_t[LINK_MAXDIM] functypetab =
[
    TYnfunc,
    TYnpfunc,
    TYnpfunc,
    TYnfunc,
];
}
else
{
tym_t[MEMMODELS][LINK_MAXDIM] functypetab =
[
    [ TYnfunc,  TYffunc,  TYnfunc,  TYffunc,  TYffunc  ],
    [ TYnfunc,  TYffunc,  TYnfunc,  TYffunc,  TYffunc  ],
    [ TYnpfunc, TYfpfunc, TYnpfunc, TYfpfunc, TYfpfunc ],
    [ TYnpfunc, TYfpfunc, TYnpfunc, TYfpfunc, TYfpfunc ],
    [ TYnfunc,  TYffunc,  TYnfunc,  TYffunc,  TYffunc  ],
    [ TYnsfunc, TYfsfunc, TYnsfunc, TYfsfunc, TYfsfunc ],
    [ TYjfunc,  TYfpfunc, TYnpfunc, TYfpfunc, TYfpfunc ],
];
}

/* Function mangling    */
/* LINK_MAXDIM = C,C++,Pascal,FORTRAN,syscall,stdcall */
mangle_t[LINK_MAXDIM] funcmangletab =
[
    mTYman_c,
    mTYman_cpp,
    mTYman_pas,
    mTYman_for,
    mTYman_sys,
    mTYman_std,
    mTYman_d,
];

/* Name mangling for глоб2 variables   */
mangle_t[LINK_MAXDIM] varmangletab =
[
    mTYman_c,
    mTYman_cpp,
    mTYman_pas,mTYman_for,mTYman_sys,mTYman_std,mTYman_d
];
}

/* Файл variables: */

сим *argv0;                    // argv[0] (program имя)
extern (C)
{
FILE *fdep = null;              // dependency файл stream pointer
FILE *flst = null;              // list файл stream pointer
FILE *fin = null;               // input файл
version (SPP)
{
FILE *fout;
}
}

// htod
сим *fdmodulename = null;
extern (C) FILE *fdmodule = null;

ткст0   foutdir = null,       // directory to place output files in
        finname = null,
        foutname = null,
        fsymname = null,
        fphreadname = null,
        ftdbname = null,
        fdepname = null,
        flstname = null;       /* the имяф strings                 */

version (SPP)
{
    phstring_t fdeplist;
    phstring_t pathlist;            // include paths
}
version (SCPP)
{
    phstring_t fdeplist;
    phstring_t pathlist;            // include paths
}
version (HTOD)
{
    phstring_t fdeplist;
    phstring_t pathlist;            // include paths
}

цел pathsysi;                   // -isystem= index
list_t headers;                 /* pre-include files                    */

/* Data from lexical analyzer: */

бцел idhash = 0;    // хэш значение of идентификатор
цел xc = ' ';           // character last читай

/* Data for pragma processor:
 */

цел colnumber = 0;              /* current column number                */

/* Other variables: */

цел уровень = 0;                  /* declaration уровень                    */
                                /* 0: top уровень                         */
                                /* 1: function параметр declarations   */
                                /* 2: function local declarations       */
                                /* 3+: compound инструкция decls         */

param_t *paramlst = null;       /* function параметр list              */
tym_t pointertype = TYnptr;     /* default данные pointer тип            */

/************************
 * Bit masks
 */

const бцел[32] mask =
        [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,0x8000,
         0x10000,0x20000,0x40000,0x80000,0x100000,0x200000,0x400000,0x800000,
         0x1000000,0x2000000,0x4000000,0x8000000,
         0x10000000,0x20000000,0x40000000,0x80000000];

static if (0)
{
const бцел[32] maskl =
        [1,2,4,8,0x10,0x20,0x40,0x80,
         0x100,0x200,0x400,0x800,0x1000,0x2000,0x4000,0x8000,
         0x10000,0x20000,0x40000,0x80000,0x100000,0x200000,0x400000,0x800000,
         0x1000000,0x2000000,0x4000000,0x8000000,
         0x10000000,0x20000000,0x40000000,0x80000000];
}


/* From util.c */

/*****************************
 * SCxxxx types.
 */

version (SPP) { } else
{

сим[SCMAX] sytab =
[
    /* unde */     SCEXP|SCKEP|SCSCT,      /* undefined                            */
    /* auto */     SCEXP|SCSS|SCRD  ,      /* automatic (stack)                    */
    /* static */   SCEXP|SCKEP|SCSCT,      /* statically allocated                 */
    /* thread */   SCEXP|SCKEP      ,      /* thread local                         */
    /* extern */   SCEXP|SCKEP|SCSCT,      /* external                             */
    /* register */ SCEXP|SCSS|SCRD  ,      /* registered variable                  */
    /* pseudo */   SCEXP            ,      /* pseudo register variable             */
    /* глоб2 */   SCEXP|SCKEP|SCSCT,      /* top уровень глоб2 definition          */
    /* comdat */   SCEXP|SCKEP|SCSCT,      /* initialized common block             */
    /* параметр */SCEXP|SCSS       ,      /* function параметр                   */
    /* regpar */   SCEXP|SCSS       ,      /* function register параметр          */
    /* fastpar */  SCEXP|SCSS       ,      /* function параметр passed in register */
    /* shadowreg */SCEXP|SCSS       ,      /* function параметр passed in register, shadowed on stack */
    /* typedef */  0                ,      /* тип definition                      */
    /* explicit */ 0                ,      /* explicit                             */
    /* mutable */  0                ,      /* mutable                              */
    /* label */    0                ,      /* goto label                           */
    /* struct */   SCKEP            ,      /* struct/class/union tag имя          */
    /* enum */     0                ,      /* enum tag имя                        */
    /* field */    SCEXP|SCKEP      ,      /* bit field of struct or union         */
    /* const */    SCEXP|SCSCT      ,      /* constant integer                     */
    /* member */   SCEXP|SCKEP|SCSCT,      /* member of struct or union            */
    /* anon */     0                ,      /* member of анонимный union            */
    /* inline */   SCEXP|SCKEP      ,      /* for inline functions                 */
    /* sinline */  SCEXP|SCKEP      ,      /* for static inline functions          */
    /* einline */  SCEXP|SCKEP      ,      /* for extern inline functions          */
    /* overload */ SCEXP            ,      /* for overloaded function имена        */
    /* friend */   0                ,      /* friend of a class                    */
    /* virtual */  0                ,      /* virtual function                     */
    /* locstat */  SCEXP|SCSCT      ,      /* static, but local to a function      */
    /* template */ 0                ,      /* class template                       */
    /* functempl */0                ,      /* function template                    */
    /* ftexpspec */0                ,      /* function template explicit specialization */
    /* компонаж */  0                ,      /* function компонаж symbol              */
    /* public */   SCEXP|SCKEP|SCSCT,      /* generate a pubdef for this           */
    /* comdef */   SCEXP|SCKEP|SCSCT,      /* uninitialized common block           */
    /* bprel */    SCEXP|SCSS       ,      /* variable at fixed смещение from frame pointer */
    /* namespace */0                ,      /* namespace                            */
    /* alias */    0                ,      /* alias to another symbol              */
    /* funcalias */0                ,      /* alias to another function symbol     */
    /* memalias */ 0                ,      /* alias to base class member           */
    /* stack */    SCEXP|SCSS       ,      /* смещение from stack pointer (not frame pointer) */
    /* adl */      0                ,      /* list of ADL symbols for overloading  */
];

}

extern (C) цел controlc_saw = 0;              /* a control C was seen         */
symtab_t globsym;               /* глоб2 symbol table                  */
Pstate pstate;                  // parser state
Cstate cstate;                  // compiler state

бцел
         maxblks = 0,   /* массив max for all block stuff                */
                        /* dfoblks <= numblks <= maxblks                */
         numcse;        /* number of common subВыражения              */

GlobalOptimizer go;

/* From debug.c */
сим*[32] regstring = ["AX","CX","DX","BX","SP","BP","SI","DI",
                             "R8","R9","R10","R11","R12","R13","R14","R15",
                             "XMM0","XMM1","XMM2","XMM3","XMM4","XMM5","XMM6","XMM7",
                             "ES","PSW","STACK","ST0","ST01","NOREG","RMload","RMstore"];

/* From nwc.c */

тип *chartype;                 /* default 'сим' тип                  */

Obj objmod = null;

 бцел[256] tytab =
() {
    бцел[256] tab;
    foreach (i; TXptr)        { tab[i] |= TYFLptr; }
    foreach (i; TXptr_nflat)  { tab[i] |= TYFLptr; }
    foreach (i; TXreal)       { tab[i] |= TYFLreal; }
    foreach (i; TXintegral)   { tab[i] |= TYFLintegral; }
    foreach (i; TXimaginary)  { tab[i] |= TYFLimaginary; }
    foreach (i; TXcomplex)    { tab[i] |= TYFLcomplex; }
    foreach (i; TXuns)        { tab[i] |= TYFLuns; }
    foreach (i; TXmptr)       { tab[i] |= TYFLmptr; }
    foreach (i; TXfv)         { tab[i] |= TYFLfv; }
    foreach (i; TXfarfunc)    { tab[i] |= TYFLfarfunc; }
    foreach (i; TXpasfunc)    { tab[i] |= TYFLpascal; }
    foreach (i; TXrevfunc)    { tab[i] |= TYFLrevparam; }
    foreach (i; TXshort)      { tab[i] |= TYFLshort; }
    foreach (i; TXaggregate)  { tab[i] |= TYFLaggregate; }
    foreach (i; TXref)        { tab[i] |= TYFLref; }
    foreach (i; TXfunc)       { tab[i] |= TYFLfunc; }
    foreach (i; TXnullptr)    { tab[i] |= TYFLnullptr; }
    foreach (i; TXpasfunc_nf) { tab[i] |= TYFLpascal; }
    foreach (i; TXrevfunc_nf) { tab[i] |= TYFLrevparam; }
    foreach (i; TXref_nflat)  { tab[i] |= TYFLref; }
    foreach (i; TXfunc_nflat) { tab[i] |= TYFLfunc; }
    foreach (i; TXxmmreg)     { tab[i] |= TYFLxmmreg; }
    foreach (i; TXsimd)       { tab[i] |= TYFLsimd; }
    return tab;
} ();


extern (C)  сим*[TYMAX] tystring =
[
    TYбул    : "бул",
    TYchar    : "сим",
    TYschar   : "signed сим",
    TYuchar   : "unsigned сим",
    TYchar8   : "char8_t",
    TYchar16  : "char16_t",
    TYshort   : "short",
    TYwchar_t : "wchar_t",
    TYushort  : "unsigned short",

    TYenum    : "enum",
    TYint     : "цел",
    TYuint    : "unsigned",

    TYlong    : "long",
    TYulong   : "unsigned long",
    TYdchar   : "dchar",
    TYllong   : "long long",
    TYullong  : "uns long long",
    TYcent    : "cent",
    TYucent   : "ucent",
    TYfloat   : "float",
    TYdouble  : "double",
    TYdouble_alias : "double alias",
    TYldouble : "long double",

    TYifloat   : "imaginary float",
    TYidouble  : "imaginary double",
    TYildouble : "imaginary long double",

    TYcfloat   : "complex float",
    TYcdouble  : "complex double",
    TYcldouble : "complex long double",

    TYfloat4  : "float[4]",
    TYdouble2 : "double[2]",
    TYschar16 : "signed сим[16]",
    TYuchar16 : "unsigned сим[16]",
    TYshort8  : "short[8]",
    TYushort8 : "unsigned short[8]",
    TYlong4   : "long[4]",
    TYulong4  : "unsigned long[4]",
    TYllong2  : "long long[2]",
    TYullong2 : "unsigned long long[2]",

    TYfloat8  : "float[8]",
    TYdouble4 : "double[4]",
    TYschar32 : "signed сим[32]",
    TYuchar32 : "unsigned сим[32]",
    TYshort16 : "short[16]",
    TYushort16 : "unsigned short[16]",
    TYlong8   : "long[8]",
    TYulong8  : "unsigned long[8]",
    TYllong4  : "long long[4]",
    TYullong4 : "unsigned long long[4]",

    TYfloat16 : "float[16]",
    TYdouble8 : "double[8]",
    TYschar64 : "signed сим[64]",
    TYuchar64 : "unsigned сим[64]",
    TYshort32 : "short[32]",
    TYushort32 : "unsigned short[32]",
    TYlong16  : "long[16]",
    TYulong16 : "unsigned long[16]",
    TYllong8  : "long long[8]",
    TYullong8 : "unsigned long long[8]",

    TYnullptr : "nullptr_t",
    TYnptr    : "*",
    TYref     : "&",
    TYvoid    : "проц",
    TYstruct  : "struct",
    TYarray   : "массив",
    TYnfunc   : "C func",
    TYnpfunc  : "Pascal func",
    TYnsfunc  : "std func",
    TYptr     : "*",
    TYmfunc   : "member func",
    TYjfunc   : "D func",
    TYhfunc   : "C func",
    TYnref    : "__near &",

    TYsptr     : "__ss *",
    TYcptr     : "__cs *",
    TYf16ptr   : "__far16 *",
    TYfptr     : "__far *",
    TYhptr     : "__huge *",
    TYvptr     : "__handle *",
    TYimmutPtr : "__immutable *",
    TYsharePtr : "__shared *",
    TYfgPtr    : "__fg *",
    TYffunc    : "far C func",
    TYfpfunc   : "far Pascal func",
    TYfsfunc   : "far std func",
    TYf16func  : "_far16 Pascal func",
    TYnsysfunc : "sys func",
    TYfsysfunc : "far sys func",
    TYfref     : "__far &",

    TYifunc    : "interrupt func",
    TYmemptr   : "memptr",
    TYident    : "идент",
    TYtemplate : "template",
    TYvtshape  : "vtshape",
];

/// Map to unsigned version of тип
 tym_t[256] tytouns =
() {
    tym_t[256] tab;
    foreach (ty; new бцел[0 .. TYMAX])
    {
        tym_t tym;
        switch (ty)
        {
            case TYchar:      tym = TYuchar;    break;
            case TYschar:     tym = TYuchar;    break;
            case TYshort:     tym = TYushort;   break;
            case TYushort:    tym = TYushort;   break;

            case TYenum:      tym = TYuint;     break;
            case TYint:       tym = TYuint;     break;

            case TYlong:      tym = TYulong;    break;
            case TYllong:     tym = TYullong;   break;
            case TYcent:      tym = TYucent;    break;

            case TYschar16:   tym = TYuchar16;  break;
            case TYshort8:    tym = TYushort8;  break;
            case TYlong4:     tym = TYulong4;   break;
            case TYllong2:    tym = TYullong2;  break;

            case TYschar32:   tym = TYuchar32;  break;
            case TYshort16:   tym = TYushort16; break;
            case TYlong8:     tym = TYulong8;   break;
            case TYllong4:    tym = TYullong4;  break;

            case TYschar64:   tym = TYuchar64;  break;
            case TYshort32:   tym = TYushort32; break;
            case TYlong16:    tym = TYulong16;  break;
            case TYllong8:    tym = TYullong8;  break;

            default:          tym = ty;         break;
        }
        tab[ty] = tym;
    }
    return tab;
} ();

/// Map to relaxed version of тип
 ббайт[TYMAX] _tyrelax =
() {
    ббайт[TYMAX] tab;
    foreach (ty; new бцел[0 .. TYMAX])
    {
        tym_t tym;
        switch (ty)
        {
            case TYбул:      tym = TYchar;  break;
            case TYschar:     tym = TYchar;  break;
            case TYuchar:     tym = TYchar;  break;
            case TYchar8:     tym = TYchar;  break;
            case TYchar16:    tym = TYint;   break;

            case TYshort:     tym = TYint;   break;
            case TYushort:    tym = TYint;   break;
            case TYwchar_t:   tym = TYint;   break;

            case TYenum:      tym = TYint;   break;
            case TYuint:      tym = TYint;   break;

            case TYulong:     tym = TYlong;  break;
            case TYdchar:     tym = TYlong;  break;
            case TYullong:    tym = TYllong; break;
            case TYucent:     tym = TYcent;  break;

            case TYnullptr:   tym = TYptr;   break;

            default:          tym = ty;      break;
        }
        tab[ty] = cast(ббайт)tym;
    }
    return tab;
} ();

/// Map to equivalent version of тип
 ббайт[TYMAX] tyequiv =
() {
    ббайт[TYMAX] tab;
    foreach (ty; new бцел[0 .. TYMAX])
    {
        tym_t tym;
        switch (ty)
        {
            case TYchar:      tym = TYschar;  break;    // chars are signed by default
            case TYint:       tym = TYshort;  break;    // adjusted in util_set32()
            case TYuint:      tym = TYushort; break;    // adjusted in util_set32()

            default:          tym = ty;       break;
        }
        tab[ty] = cast(ббайт)tym;
    }
    return tab;
} ();

/// Map to Codeview 1 тип in debugger record
 ббайт[TYMAX] dttab =
[
    TYбул    : 0x80,
    TYchar    : 0x80,
    TYschar   : 0x80,
    TYuchar   : 0x84,
    TYchar8   : 0x84,
    TYchar16  : 0x85,
    TYshort   : 0x81,
    TYwchar_t : 0x85,
    TYushort  : 0x85,

    TYenum    : 0x81,
    TYint     : 0x85,
    TYuint    : 0x85,

    TYlong    : 0x82,
    TYulong   : 0x86,
    TYdchar   : 0x86,
    TYllong   : 0x82,
    TYullong  : 0x86,
    TYcent    : 0x82,
    TYucent   : 0x86,
    TYfloat   : 0x88,
    TYdouble  : 0x89,
    TYdouble_alias : 0x89,
    TYldouble : 0x89,

    TYifloat   : 0x88,
    TYidouble  : 0x89,
    TYildouble : 0x89,

    TYcfloat   : 0x88,
    TYcdouble  : 0x89,
    TYcldouble : 0x89,

    TYfloat4  : 0x00,
    TYdouble2 : 0x00,
    TYschar16 : 0x00,
    TYuchar16 : 0x00,
    TYshort8  : 0x00,
    TYushort8 : 0x00,
    TYlong4   : 0x00,
    TYulong4  : 0x00,
    TYllong2  : 0x00,
    TYullong2 : 0x00,

    TYfloat8  : 0x00,
    TYdouble4 : 0x00,
    TYschar32 : 0x00,
    TYuchar32 : 0x00,
    TYshort16 : 0x00,
    TYushort16 : 0x00,
    TYlong8   : 0x00,
    TYulong8  : 0x00,
    TYllong4  : 0x00,
    TYullong4 : 0x00,

    TYfloat16 : 0x00,
    TYdouble8 : 0x00,
    TYschar64 : 0x00,
    TYuchar64 : 0x00,
    TYshort32 : 0x00,
    TYushort32 : 0x00,
    TYlong16  : 0x00,
    TYulong16 : 0x00,
    TYllong8  : 0x00,
    TYullong8 : 0x00,

    TYnullptr : 0x20,
    TYnptr    : 0x20,
    TYref     : 0x00,
    TYvoid    : 0x85,
    TYstruct  : 0x00,
    TYarray   : 0x78,
    TYnfunc   : 0x63,
    TYnpfunc  : 0x74,
    TYnsfunc  : 0x63,
    TYptr     : 0x20,
    TYmfunc   : 0x64,
    TYjfunc   : 0x74,
    TYhfunc   : 0x00,
    TYnref    : 0x00,

    TYsptr     : 0x20,
    TYcptr     : 0x20,
    TYf16ptr   : 0x40,
    TYfptr     : 0x40,
    TYhptr     : 0x40,
    TYvptr     : 0x40,
    TYimmutPtr : 0x20,
    TYsharePtr : 0x20,
    TYfgPtr    : 0x20,
    TYffunc    : 0x64,
    TYfpfunc   : 0x73,
    TYfsfunc   : 0x64,
    TYf16func  : 0x63,
    TYnsysfunc : 0x63,
    TYfsysfunc : 0x64,
    TYfref     : 0x00,

    TYifunc    : 0x64,
    TYmemptr   : 0x00,
    TYident    : 0x00,
    TYtemplate : 0x00,
    TYvtshape  : 0x00,
];

/// Map to Codeview 4 тип in debugger record
 ushort[TYMAX] dttab4 =
[
    TYбул    : 0x30,
    TYchar    : 0x70,
    TYschar   : 0x10,
    TYuchar   : 0x20,
    TYchar8   : 0x20,
    TYchar16  : 0x21,
    TYshort   : 0x11,
    TYwchar_t : 0x71,
    TYushort  : 0x21,

    TYenum    : 0x72,
    TYint     : 0x72,
    TYuint    : 0x73,

    TYlong    : 0x12,
    TYulong   : 0x22,
    TYdchar   : 0x7b, // UTF32
    TYllong   : 0x13,
    TYullong  : 0x23,
    TYcent    : 0x603,
    TYucent   : 0x603,
    TYfloat   : 0x40,
    TYdouble  : 0x41,
    TYdouble_alias : 0x41,
    TYldouble : 0x42,

    TYifloat   : 0x40,
    TYidouble  : 0x41,
    TYildouble : 0x42,

    TYcfloat   : 0x50,
    TYcdouble  : 0x51,
    TYcldouble : 0x52,

    TYfloat4  : 0x00,
    TYdouble2 : 0x00,
    TYschar16 : 0x00,
    TYuchar16 : 0x00,
    TYshort8  : 0x00,
    TYushort8 : 0x00,
    TYlong4   : 0x00,
    TYulong4  : 0x00,
    TYllong2  : 0x00,
    TYullong2 : 0x00,

    TYfloat8  : 0x00,
    TYdouble4 : 0x00,
    TYschar32 : 0x00,
    TYuchar32 : 0x00,
    TYshort16 : 0x00,
    TYushort16 : 0x00,
    TYlong8   : 0x00,
    TYulong8  : 0x00,
    TYllong4  : 0x00,
    TYullong4 : 0x00,

    TYfloat16 : 0x00,
    TYdouble8 : 0x00,
    TYschar64 : 0x00,
    TYuchar64 : 0x00,
    TYshort32 : 0x00,
    TYushort32 : 0x00,
    TYlong16  : 0x00,
    TYulong16 : 0x00,
    TYllong8  : 0x00,
    TYullong8 : 0x00,

    TYnullptr : 0x100,
    TYnptr    : 0x100,
    TYref     : 0x00,
    TYvoid    : 0x03,
    TYstruct  : 0x00,
    TYarray   : 0x00,
    TYnfunc   : 0x00,
    TYnpfunc  : 0x00,
    TYnsfunc  : 0x00,
    TYptr     : 0x100,
    TYmfunc   : 0x00,
    TYjfunc   : 0x00,
    TYhfunc   : 0x00,
    TYnref    : 0x00,

    TYsptr     : 0x100,
    TYcptr     : 0x100,
    TYf16ptr   : 0x200,
    TYfptr     : 0x200,
    TYhptr     : 0x300,
    TYvptr     : 0x200,
    TYimmutPtr : 0x100,
    TYsharePtr : 0x100,
    TYfgPtr    : 0x100,
    TYffunc    : 0x00,
    TYfpfunc   : 0x00,
    TYfsfunc   : 0x00,
    TYf16func  : 0x00,
    TYnsysfunc : 0x00,
    TYfsysfunc : 0x00,
    TYfref     : 0x00,

    TYifunc    : 0x00,
    TYmemptr   : 0x00,
    TYident    : 0x00,
    TYtemplate : 0x00,
    TYvtshape  : 0x00,
];

/// Size of a тип
 byte[256] _tysize =
[
    TYбул    : 1,
    TYchar    : 1,
    TYschar   : 1,
    TYuchar   : 1,
    TYchar8   : 1,
    TYchar16  : 2,
    TYshort   : SHORTSIZE,
    TYwchar_t : 2,
    TYushort  : SHORTSIZE,

    TYenum    : -1,
    TYint     : 2,
    TYuint    : 2,

    TYlong    : LONGSIZE,
    TYulong   : LONGSIZE,
    TYdchar   : 4,
    TYllong   : LLONGSIZE,
    TYullong  : LLONGSIZE,
    TYcent    : 16,
    TYucent   : 16,
    TYfloat   : FLOATSIZE,
    TYdouble  : DOUBLESIZE,
    TYdouble_alias : 8,
    TYldouble : -1,

    TYifloat   : FLOATSIZE,
    TYidouble  : DOUBLESIZE,
    TYildouble : -1,

    TYcfloat   : 2*FLOATSIZE,
    TYcdouble  : 2*DOUBLESIZE,
    TYcldouble : -1,

    TYfloat4  : 16,
    TYdouble2 : 16,
    TYschar16 : 16,
    TYuchar16 : 16,
    TYshort8  : 16,
    TYushort8 : 16,
    TYlong4   : 16,
    TYulong4  : 16,
    TYllong2  : 16,
    TYullong2 : 16,

    TYfloat8  : 32,
    TYdouble4 : 32,
    TYschar32 : 32,
    TYuchar32 : 32,
    TYshort16 : 32,
    TYushort16 : 32,
    TYlong8   : 32,
    TYulong8  : 32,
    TYllong4  : 32,
    TYullong4 : 32,

    TYfloat16 : 64,
    TYdouble8 : 64,
    TYschar64 : 64,
    TYuchar64 : 64,
    TYshort32 : 64,
    TYushort32 : 64,
    TYlong16  : 64,
    TYulong16 : 64,
    TYllong8  : 64,
    TYullong8 : 64,

    TYnullptr : 2,
    TYnptr    : 2,
    TYref     : -1,
    TYvoid    : -1,
    TYstruct  : -1,
    TYarray   : -1,
    TYnfunc   : -1,
    TYnpfunc  : -1,
    TYnsfunc  : -1,
    TYptr     : 2,
    TYmfunc   : -1,
    TYjfunc   : -1,
    TYhfunc   : -1,
    TYnref    : 2,

    TYsptr     : 2,
    TYcptr     : 2,
    TYf16ptr   : 4,
    TYfptr     : 4,
    TYhptr     : 4,
    TYvptr     : 4,
    TYimmutPtr : 2,
    TYsharePtr : 2,
    TYfgPtr    : 2,
    TYffunc    : -1,
    TYfpfunc   : -1,
    TYfsfunc   : -1,
    TYf16func  : -1,
    TYnsysfunc : -1,
    TYfsysfunc : -1,
    TYfref     : 4,

    TYifunc    : -1,
    TYmemptr   : -1,
    TYident    : -1,
    TYtemplate : -1,
    TYvtshape  : -1,
];

// Alignment of long doubles varies by target
static if (TARGET_OSX)
    const LDOUBLE_ALIGN = 16;
else static if (TARGET_LINUX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS)
    const LDOUBLE_ALIGN = 4;
else static if (TARGET_WINDOS)
    const LDOUBLE_ALIGN = 2;
else
    static assert(0, "fix this");


/// Size of a тип to use for alignment
 byte[256] _tyalignsize =
[
    TYбул    : 1,
    TYchar    : 1,
    TYschar   : 1,
    TYuchar   : 1,
    TYchar8   : 1,
    TYchar16  : 2,
    TYshort   : SHORTSIZE,
    TYwchar_t : 2,
    TYushort  : SHORTSIZE,

    TYenum    : -1,
    TYint     : 2,
    TYuint    : 2,

    TYlong    : LONGSIZE,
    TYulong   : LONGSIZE,
    TYdchar   : 4,
    TYllong   : LLONGSIZE,
    TYullong  : LLONGSIZE,
    TYcent    : 8,
    TYucent   : 8,
    TYfloat   : FLOATSIZE,
    TYdouble  : DOUBLESIZE,
    TYdouble_alias : 8,
    TYldouble : LDOUBLE_ALIGN,

    TYifloat   : FLOATSIZE,
    TYidouble  : DOUBLESIZE,
    TYildouble : LDOUBLE_ALIGN,

    TYcfloat   : 2*FLOATSIZE,
    TYcdouble  : 2*DOUBLESIZE,
    TYcldouble : LDOUBLE_ALIGN,

    TYfloat4  : 16,
    TYdouble2 : 16,
    TYschar16 : 16,
    TYuchar16 : 16,
    TYshort8  : 16,
    TYushort8 : 16,
    TYlong4   : 16,
    TYulong4  : 16,
    TYllong2  : 16,
    TYullong2 : 16,

    TYfloat8  : 32,
    TYdouble4 : 32,
    TYschar32 : 32,
    TYuchar32 : 32,
    TYshort16 : 32,
    TYushort16 : 32,
    TYlong8   : 32,
    TYulong8  : 32,
    TYllong4  : 32,
    TYullong4 : 32,

    TYfloat16 : 64,
    TYdouble8 : 64,
    TYschar64 : 64,
    TYuchar64 : 64,
    TYshort32 : 64,
    TYushort32 : 64,
    TYlong16  : 64,
    TYulong16 : 64,
    TYllong8  : 64,
    TYullong8 : 64,

    TYnullptr : 2,
    TYnptr    : 2,
    TYref     : -1,
    TYvoid    : -1,
    TYstruct  : -1,
    TYarray   : -1,
    TYnfunc   : -1,
    TYnpfunc  : -1,
    TYnsfunc  : -1,
    TYptr     : 2,
    TYmfunc   : -1,
    TYjfunc   : -1,
    TYhfunc   : -1,
    TYnref    : 2,

    TYsptr     : 2,
    TYcptr     : 2,
    TYf16ptr   : 4,
    TYfptr     : 4,
    TYhptr     : 4,
    TYvptr     : 4,
    TYimmutPtr : 2,
    TYsharePtr : 2,
    TYfgPtr    : 2,
    TYffunc    : -1,
    TYfpfunc   : -1,
    TYfsfunc   : -1,
    TYf16func  : -1,
    TYnsysfunc : -1,
    TYfsysfunc : -1,
    TYfref     : 4,

    TYifunc    : -1,
    TYmemptr   : -1,
    TYident    : -1,
    TYtemplate : -1,
    TYvtshape  : -1,
];


private:

const TXptr       = [ TYnptr ];
const TXptr_nflat = [ TYsptr,TYcptr,TYf16ptr,TYfptr,TYhptr,TYvptr,TYimmutPtr,TYsharePtr,TYfgPtr ];
const TXreal      = [ TYfloat,TYdouble,TYdouble_alias,TYldouble,
                     TYfloat4,TYdouble2,
                     TYfloat8,TYdouble4,
                     TYfloat16,TYdouble8,
                   ];
const TXimaginary = [ TYifloat,TYidouble,TYildouble, ];
const TXcomplex   = [ TYcfloat,TYcdouble,TYcldouble, ];
const TXintegral  = [ TYбул,TYchar,TYschar,TYuchar,TYshort,
                     TYwchar_t,TYushort,TYenum,TYint,TYuint,
                     TYlong,TYulong,TYllong,TYullong,TYdchar,
                     TYschar16,TYuchar16,TYshort8,TYushort8,
                     TYlong4,TYulong4,TYllong2,TYullong2,
                     TYschar32,TYuchar32,TYshort16,TYushort16,
                     TYlong8,TYulong8,TYllong4,TYullong4,
                     TYschar64,TYuchar64,TYshort32,TYushort32,
                     TYlong16,TYulong16,TYllong8,TYullong8,
                     TYchar16,TYcent,TYucent,
                   ];
const TXref       = [ TYnref,TYref ];
const TXfunc      = [ TYnfunc,TYnpfunc,TYnsfunc,TYifunc,TYmfunc,TYjfunc,TYhfunc ];
const TXref_nflat = [ TYfref ];
const TXfunc_nflat= [ TYffunc,TYfpfunc,TYf16func,TYfsfunc,TYnsysfunc,TYfsysfunc, ];
const TXuns       = [ TYuchar,TYushort,TYuint,TYulong,
                     TYwchar_t,
                     TYuchar16,TYushort8,TYulong4,TYullong2,
                     TYdchar,TYullong,TYucent,TYchar16 ];
const TXmptr      = [ TYmemptr ];
const TXnullptr   = [ TYnullptr ];
const TXfv        = [ TYfptr, TYvptr ];
const TXfarfunc   = [ TYffunc,TYfpfunc,TYfsfunc,TYfsysfunc ];
const TXpasfunc   = [ TYnpfunc,TYnsfunc,TYmfunc,TYjfunc ];
const TXpasfunc_nf = [ TYfpfunc,TYf16func,TYfsfunc, ];
const TXrevfunc    = [ TYnpfunc,TYjfunc ];
const TXrevfunc_nf = [ TYfpfunc,TYf16func, ];
const TXshort      = [ TYбул,TYchar,TYschar,TYuchar,TYshort,
                      TYwchar_t,TYushort,TYchar16 ];
const TXaggregate  = [ TYstruct,TYarray ];
const TXxmmreg     = [
                     TYfloat,TYdouble,TYifloat,TYidouble,
                     TYfloat4,TYdouble2,
                     TYschar16,TYuchar16,TYshort8,TYushort8,
                     TYlong4,TYulong4,TYllong2,TYullong2,
                     TYfloat8,TYdouble4,
                     TYschar32,TYuchar32,TYshort16,TYushort16,
                     TYlong8,TYulong8,TYllong4,TYullong4,
                     TYschar64,TYuchar64,TYshort32,TYushort32,
                     TYlong16,TYulong16,TYllong8,TYullong8,
                     TYfloat16,TYdouble8,
                    ];
const TXsimd       = [
                     TYfloat4,TYdouble2,
                     TYschar16,TYuchar16,TYshort8,TYushort8,
                     TYlong4,TYulong4,TYllong2,TYullong2,
                     TYfloat8,TYdouble4,
                     TYschar32,TYuchar32,TYshort16,TYushort16,
                     TYlong8,TYulong8,TYllong4,TYullong4,
                     TYschar64,TYuchar64,TYshort32,TYushort32,
                     TYlong16,TYulong16,TYllong8,TYullong8,
                     TYfloat16,TYdouble8,
                    ];

