/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/code_x86.d, backend/code_x86.d)
 */

module drc.backend.code_x86;

// Online documentation: https://dlang.org/phobos/dmd_backend_code_x86.html

import drc.backend.cdef;
import drc.backend.cc : config;
import drc.backend.code;
import drc.backend.codebuilder : CodeBuilder;
import drc.backend.el : elem;
import drc.backend.ty : I64;



alias бцел opcode_t;          // CPU opcode
const opcode_t NoOpcode = 0xFFFF;              // not a valid opcode_t

/* Register definitions */

enum
{
    AX      = 0,
    CX      = 1,
    DX      = 2,
    BX      = 3,
    SP      = 4,
    BP      = 5,
    SI      = 6,
    DI      = 7,

    // #defining R12-R15 interfere with setjmps' _JUMP_BUFFER члены

    R8       = 8,
    R9       = 9,
    R10      = 10,
    R11      = 11,
    R12      = 12,
    R13      = 13,
    R14      = 14,
    R15      = 15,

    XMM0    = 16,
    XMM1    = 17,
    XMM2    = 18,
    XMM3    = 19,
    XMM4    = 20,
    XMM5    = 21,
    XMM6    = 22,
    XMM7    = 23,
/* There are also XMM8..XMM14 */
    XMM15   = 31,
}

бул isXMMreg(reg_t reg)  { return reg >= XMM0 && reg <= XMM15; }

const PICREG = BX;

const ES     = 24;

const NUMGENREGS = 16;

// fishy naming as it covers XMM7 but not XMM15
// currently only используется as a replacement for mES in cgcod.c
const NUMREGS = 25;

const PSW     = 25;
const STACK   = 26;      // top of stack
const ST0     = 27;      // 8087 top of stack register
const ST01    = 28;      // top two 8087 registers; for complex types

const reg_t NOREG   = 29;     // no register

enum
{
    AL      = 0,
    CL      = 1,
    DL      = 2,
    BL      = 3,
    AH      = 4,
    CH      = 5,
    DH      = 6,
    BH      = 7,
}

enum
{
    mAX     = 1,
    mCX     = 2,
    mDX     = 4,
    mBX     = 8,
    mSP     = 0x10,
    mBP     = 0x20,
    mSI     = 0x40,
    mDI     = 0x80,

    mR8     = (1 << R8),
    mR9     = (1 << R9),
    mR10    = (1 << R10),
    mR11    = (1 << R11),
    mR12    = (1 << R12),
    mR13    = (1 << R13),
    mR14    = (1 << R14),
    mR15    = (1 << R15),

    mXMM0   = (1 << XMM0),
    mXMM1   = (1 << XMM1),
    mXMM2   = (1 << XMM2),
    mXMM3   = (1 << XMM3),
    mXMM4   = (1 << XMM4),
    mXMM5   = (1 << XMM5),
    mXMM6   = (1 << XMM6),
    mXMM7   = (1 << XMM7),
    XMMREGS = (mXMM0 |mXMM1 |mXMM2 |mXMM3 |mXMM4 |mXMM5 |mXMM6 |mXMM7),

    mES     = (1 << ES),      // 0x1000000
    mPSW    = (1 << PSW),     // 0x2000000

    mSTACK  = (1 << STACK),   // 0x4000000

    mST0    = (1 << ST0),     // 0x20000000
    mST01   = (1 << ST01),    // 0x40000000
}

// Flags for getlvalue (must fit in regm_t)
const RMload  = (1 << 30);
const RMstore = (1 << 31);

 extern  regm_t ALLREGS;
 extern  regm_t BYTEREGS;

static if (TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS)
{
    // To support positional independent code,
    // must be able to удали BX from доступно registers
    const ALLREGS_INIT          = (mAX|mBX|mCX|mDX|mSI|mDI);
    const ALLREGS_INIT_PIC      = (mAX|mCX|mDX|mSI|mDI);
    const BYTEREGS_INIT         = (mAX|mBX|mCX|mDX);
    const BYTEREGS_INIT_PIC     = (mAX|mCX|mDX);
}
else
{
    const ALLREGS_INIT          = (mAX|mBX|mCX|mDX|mSI|mDI);
    const BYTEREGS_INIT         = (mAX|mBX|mCX|mDX);
}


/* We use the same IDXREGS for the 386 as the 8088, because if
   we используется ALLREGS, it would interfere with mMSW
 */
const IDXREGS         = (mBX|mSI|mDI);

const FLOATREGS_64    = mAX;
const FLOATREGS2_64   = mDX;
const DOUBLEREGS_64   = mAX;
const DOUBLEREGS2_64  = mDX;

const FLOATREGS_32    = mAX;
const FLOATREGS2_32   = mDX;
const DOUBLEREGS_32   = (mAX|mDX);
const DOUBLEREGS2_32  = (mCX|mBX);

const FLOATREGS_16    = (mDX|mAX);
const FLOATREGS2_16   = (mCX|mBX);
const DOUBLEREGS_16   = (mAX|mBX|mCX|mDX);

/*#define _8087REGS (mST0|mST1|mST2|mST3|mST4|mST5|mST6|mST7)*/

/* Segment registers    */
enum
{
    SEG_ES  = 0,
    SEG_CS  = 1,
    SEG_SS  = 2,
    SEG_DS  = 3,
}

/*********************
 * Masks for register pairs.
 * Note that index registers are always LSWs. This is for the convenience
 * of implementing far pointers.
 */

static if (0)
{
// Give us an extra one so we can enregister a long
const mMSW = mCX|mDX|mDI|mES;       // most significant regs
const mLSW = mAX|mBX|mSI;           // least significant regs
}
else
{
const mMSW = mCX|mDX|mES;           // most significant regs
const mLSW = mAX|mBX|mSI|mDI;       // least significant regs
}

/* Return !=0 if there is a SIB byte   */
бцел issib(бцел rm) { return (rm & 7) == 4 && (rm & 0xC0) != 0xC0; }

static if (0)
{
// relocation field size is always 32bits
//enum is32bitaddr(x,Iflags) (1)
}
else
{
//
// is32bitaddr works correctly only when x is 0 or 1.  This is
// да today for the current definition of I32, but if the definition
// of I32 changes, this macro will need to change as well
//
// Note: even for linux targets, CFaddrsize can be set by the inline
// assembler.
бул is32bitaddr(бул x,code_flags_t Iflags) { return I64 || (x ^ ((Iflags & CFaddrsize) !=0)); }
}


/**********************
 * C library routines.
 * See callclib().
 */

enum CLIB
{
    lcmp,
    lmul,
    ldiv,
    lmod,
    uldiv,
    ulmod,

    dmul,ddiv,dtst0,dtst0exc,dcmp,dcmpexc,dneg,dadd,dsub,
    fmul,fdiv,ftst0,ftst0exc,fcmp,fcmpexc,fneg,fadd,fsub,

    dbllng,lngdbl,dblint,intdbl,
    dbluns,unsdbl,
    dblulng,
    ulngdbl,
    dblflt,fltdbl,
    dblllng,
    llngdbl,
    dblullng,
    ullngdbl,
    dtst,
    vptrfptr,cvptrfptr,

    _87topsw,fltto87,dblto87,dblint87,dbllng87,
    ftst,
    fcompp,
    ftest,
    ftest0,
    fdiv87,

    // Complex numbers
    cmul,
    cdiv,
    ccmp,

    u64_ldbl,
    ld_u64,
    MAX
}

alias бцел code_flags_t;
enum
{
    CFes        =        1,     // generate an ES: segment override for this instr
    CFjmp16     =        2,     // need 16 bit jump смещение (long branch)
    CFtarg      =        4,     // this code is the target of a jump
    CFseg       =        8,     // get segment of immediate значение
    CFoff       =     0x10,     // get смещение of immediate значение
    CFss        =     0x20,     // generate an SS: segment override (not with
                                // CFes at the same time, though!)
    CFpsw       =     0x40,     // we need the flags результат after this instruction
    CFopsize    =     0x80,     // префикс with operand size
    CFaddrsize  =    0x100,     // префикс with address size
    CFds        =    0x200,     // need DS override (not with ES, SS, or CS )
    CFcs        =    0x400,     // need CS override
    CFfs        =    0x800,     // need FS override
    CFgs        =   CFcs | CFfs,   // need GS override
    CFwait      =   0x1000,     // If I32 it indicates when to output a WAIT
    CFselfrel   =   0x2000,     // if self-relative
    CFunambig   =   0x4000,     // indicates cannot be accessed by other addressing
                                // modes
    CFtarg2     =   0x8000,     // like CFtarg, but we can't optimize this away
    CFvolatile  =  0x10000,     // volatile reference, do not schedule
    CFclassinit =  0x20000,     // class init code
    CFoffset64  =  0x40000,     // смещение is 64 bits
    CFpc32      =  0x80000,     // I64: PC relative 32 bit fixup

    CFvex       =  0x100000,    // vex префикс
    CFvex3      =  0x200000,    // 3 byte vex префикс

    CFjmp5      =  0x400000,    // always a 5 byte jmp
    CFswitch    =  0x800000,    // kludge for switch table fixups

    CFindirect  = 0x1000000,    // OSX32: indirect fixups

    /* These are for CFpc32 fixups, they're the negative of the смещение of the fixup
     * from the program counter
     */
    CFREL       = 0x7000000,

    CFSEG       = CFes | CFss | CFds | CFcs | CFfs | CFgs,
    CFPREFIX    = CFSEG | CFopsize | CFaddrsize,
}

struct code
{
    code *следщ;
    code_flags_t Iflags;

    union
    {
        opcode_t Iop;
        struct Svex
        {
          
          align(1):
            ббайт  op;

            // [R X B m-mmmm]  [W vvvv L pp]
            ushort _pp;

             ushort pp(){ return _pp & 3; }
             проц pp(ushort v) { _pp = (_pp & ~3) | (v & 3); }

             ushort l(){ return (_pp >> 2) & 1; }
             проц l(ushort v) { _pp = cast(ushort)((_pp & ~4) | ((v & 1) << 2)); }

             ushort vvvv(){ return (_pp >> 3) & 0x0F; }
             проц vvvv(ushort v) { _pp = cast(ushort)((_pp & ~0x78) | ((v & 0x0F) << 3)); }

             ushort w(){ return (_pp >> 7) & 1; }
             проц w(ushort v) { _pp = cast(ushort)((_pp & ~0x80) | ((v & 1) << 7)); }

             ushort mmmm(){ return (_pp >> 8) & 0x1F; }
             проц mmmm(ushort v) { _pp = cast(ushort)((_pp & ~0x1F00) | ((v & 0x1F) << 8)); }

             ushort b(){ return (_pp >> 13) & 1; }
             проц b(ushort v) { _pp = cast(ushort)((_pp & ~0x2000) | ((v & 1) << 13)); }

             ushort x(){ return (_pp >> 14) & 1; }
             проц x(ushort v) { _pp = cast(ushort)((_pp & ~0x4000) | ((v & 1) << 14)); }

             ushort r(){ return (_pp >> 15) & 1; }
             проц r(ushort v) { _pp = cast(ushort)((_pp & ~0x8000) | (v << 15)); }

            ббайт pfx; // always 0xC4
        }
        Svex Ivex;
    }

    /* The _EA is the "effective address" for the instruction, and consists of the modregrm byte,
     * the sib byte, and the REX префикс byte. The 16 bit code generator just используется the modregrm,
     * the 32 bit x86 added the sib, and the 64 bit one added the rex.
     */
    union
    {
        бцел Iea;
        struct
        {
            ббайт Irm;          // reg/mode
            ббайт Isib;         // SIB byte
            ббайт Irex;         // REX префикс
        }
    }

    /* IFL1 and IEV1 are the first operand, which usually winds up being the смещение to the Effective
     * Address. IFL1 is the tag saying which variant тип is in IEV1. IFL2 and IEV2 is the second
     * operand, usually for immediate instructions.
     */

    ббайт IFL1,IFL2;    // FLavors of 1st, 2nd operands
    evc IEV1;             // 1st operand, if any
    evc IEV2;             // 2nd operand, if any

  
    проц orReg(бцел reg)
    {   if (reg & 8)
            Irex |= REX_R;
        Irm |= modregrm(0, reg & 7, 0);
    }

    проц setReg(бцел reg)
    {
        Irex &= ~REX_R;
        Irm &= cast(ббайт)~cast(бцел)modregrm(0, 7, 0);
        orReg(reg);
    }

    бул isJumpOP() { return Iop == JMP || Iop == JMPS; }

     проц print()               // pretty-printer
    {
        code_print(&this);
    }
}

extern (C) проц code_print(code*);

/*******************
 * Some instructions.
 */

enum
{
    SEGES   = 0x26,
    SEGCS   = 0x2E,
    SEGSS   = 0x36,
    SEGDS   = 0x3E,
    SEGFS   = 0x64,
    SEGGS   = 0x65,

    CMP     = 0x3B,
    CALL    = 0xE8,
    JMP     = 0xE9,    // Intra-Segment Direct
    JMPS    = 0xEB,    // JMP SHORT
    JCXZ    = 0xE3,
    LOOP    = 0xE2,
    LES     = 0xC4,
    LEA     = 0x8D,
    LOCK    = 0xF0,
    INT3    = 0xCC,
    HLT     = 0xF4,

    STO     = 0x89,
    LOD     = 0x8B,

    JO      = 0x70,
    JNO     = 0x71,
    JC      = 0x72,
    JB      = 0x72,
    JNC     = 0x73,
    JAE     = 0x73,
    JE      = 0x74,
    JNE     = 0x75,
    JBE     = 0x76,
    JA      = 0x77,
    JS      = 0x78,
    JNS     = 0x79,
    JP      = 0x7A,
    JNP     = 0x7B,
    JL      = 0x7C,
    JGE     = 0x7D,
    JLE     = 0x7E,
    JG      = 0x7F,

    UD2     = 0x0F0B,

    // NOP is используется as a placeholder in the linked list of instructions, no
    // actual code will be generated for it.
    NOP     = SEGCS,   // don't use 0x90 because the
                       // Windows stuff wants to output 0x90's

    ASM     = SEGSS,   // ткст of asm bytes

    ESCAPE  = SEGDS,   // marker that special information is here
                       // (Iop2 is the тип of special information)
}


const ESCAPEmask = 0xFF; // code.Iop & ESCAPEmask ==> actual Iop

enum
{
    ESClinnum   = (1 << 8),      // line number information
    ESCctor     = (2 << 8),      // объект is constructed
    ESCdtor     = (3 << 8),      // объект is destructed
    ESCmark     = (4 << 8),      // mark eh stack
    ESCrelease  = (5 << 8),      // release eh stack
    ESCoffset   = (6 << 8),      // set code смещение for eh
    ESCadjesp   = (7 << 8),      // adjust ESP by IEV2.Vint
    ESCmark2    = (8 << 8),      // mark eh stack
    ESCrelease2 = (9 << 8),      // release eh stack
    ESCframeptr = (10 << 8),     // replace with load of frame pointer
    ESCdctor    = (11 << 8),     // D объект is constructed
    ESCddtor    = (12 << 8),     // D объект is destructed
    ESCadjfpu   = (13 << 8),     // adjust fpustackused by IEV2.Vint
    ESCfixesp   = (14 << 8),     // сбрось ESP to end of local frame
}

/*********************************
 * Macros to ease generating code
 * modregrm:    generate mod reg r/m field
 * modregxrm:   reg could be R8..R15
 * modregrmx:   rm could be R8..R15
 * modregxrmx:  reg or rm could be R8..R15
 * NEWREG:      change reg field of x to r
 * genorreg:    OR  t,f
 */

ббайт modregrm (бцел m, бцел r, бцел rm) { return cast(ббайт)((m << 6) | (r << 3) | rm); }
бцел modregxrm (бцел m, бцел r, бцел rm) { return ((r&8)<<15)|modregrm(m,r&7,rm); }
бцел modregrmx (бцел m, бцел r, бцел rm) { return ((rm&8)<<13)|modregrm(m,r,rm&7); }
бцел modregxrmx(бцел m, бцел r, бцел rm) { return ((r&8)<<15)|((rm&8)<<13)|modregrm(m,r&7,rm&7); }

проц NEWREXR(ref ббайт x, бцел r)  { x = (x&~REX_R)|((r&8)>>1); }
проц NEWREG (ref ббайт x, бцел r)  { x = cast(ббайт)((x & ~(7 << 3)) | (r << 3)); }
проц code_newreg(code* c, бцел r)  { NEWREG(c.Irm,r&7); NEWREXR(c.Irex,r); }

//#define genorreg(c,t,f)         genregs((c),0x09,(f),(t))

enum
{
    REX     = 0x40,        // REX префикс byte, OR'd with the following bits:
    REX_W   = 8,           // 0 = default operand size, 1 = 64 bit operand size
    REX_R   = 4,           // high bit of reg field of modregrm
    REX_X   = 2,           // high bit of sib index reg
    REX_B   = 1,           // high bit of rm field, sib base reg, or opcode reg
}

бцел VEX2_B1(code.Svex ivex)
{
    return ivex.r    << 7 |
        ivex.vvvv << 3 |
        ivex.l    << 2 |
        ivex.pp;
}

бцел VEX3_B1(code.Svex ivex)
{
    return  ivex.r    << 7 |
        ivex.x    << 6 |
        ivex.b    << 5 |
        ivex.mmmm;
}

бцел VEX3_B2(code.Svex ivex)
{
    return  ivex.w    << 7 |
        ivex.vvvv << 3 |
        ivex.l    << 2 |
        ivex.pp;
}

бул ADDFWAIT() { return config.target_cpu <= TARGET_80286; }

/************************************
 */

/*extern (C++):*/

struct NDP
{
    elem *e;                    // which elem is stored here (NULL if none)
    бцел смещение;            // смещение from e (используется for complex numbers)
}

struct Globals87
{
    NDP[8] stack;              // 8087 stack
    цел stackused = 0;         // number of items on the 8087 stack

    NDP *save;
    цел savemax;         // # of entries in save[]
    цел savetop;         // # of entries используется in save[]
}

 extern  Globals87 global87;

проц getlvalue_msw(code *);
проц getlvalue_lsw(code *);
проц getlvalue(ref CodeBuilder cdb, code *pcs, elem *e, regm_t keepmsk);
проц loadea(ref CodeBuilder cdb, elem *e, code *cs, бцел op, бцел reg, targ_т_мера смещение, regm_t keepmsk, regm_t desmsk);
