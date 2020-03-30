/**
 * Inline assembler implementation for DMD.
 *
 * Part of the compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (c) 1992-1999 by Symantec
 *              Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     Mike Cote, John Micco and $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/iasmdmd.d, _iasmdmd.d)
 * Documentation:  https://dlang.org/phobos/dmd_iasmdmd.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/iasmdmd.d
 */

module dmd.iasmdmd;

import cidrus;

import dmd.declaration;
import dmd.denum;
import dmd.dscope;
import dmd.дсимвол;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.инструкция;
import dmd.target;
import drc.lexer.Tokens;

import util.ctfloat;
import util.rmem;
import drc.ast.Node;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.codebuilder : CodeBuilder;
import drc.backend.глоб2;
import drc.backend.iasm;
import drc.backend.xmm;

//debug = EXTRA_DEBUG;
//debug = debuga;

/*******************************
 * Clean up iasm things before exiting the compiler.
 * Currently not called.
 */

version (none)
public проц iasm_term()
{
    if (asmstate.bInit)
    {
        asmstate.psDollar = null;
        asmstate.psLocalsize = null;
        asmstate.bInit = нет;
    }
}

/************************
 * Perform semantic analysis on InlineAsmStatement.
 * Параметры:
 *      s = inline asm инструкция
 *      sc = context
 */
public Инструкция2 inlineAsmSemantic(InlineAsmStatement s, Scope *sc)
{
    //printf("InlineAsmStatement.semantic()\n");

    OP *o;
    OPND opnd1, opnd2, opnd3, opnd4;
    OPND* o1, o2, o3, o4;
    PTRNTAB ptb;
    цел usNumops;

    asmstate.ucItype = 0;
    asmstate.bReturnax = нет;
    asmstate.lbracketNestCount = 0;

    asmstate.инструкция = s;
    asmstate.sc = sc;

version (none) // don't use bReturnax anymore, and will fail anyway if we use return тип inference
{
    // Scalar return values will always be in AX.  So if it is a scalar
    // then asm block sets return значение if it modifies AX, if it is non-scalar
    // then always assume that the ASM block sets up an appropriate return
    // значение.

    asmstate.bReturnax = да;
    if (sc.func.тип.nextOf().isscalar())
        asmstate.bReturnax = нет;
}

    if (!asmstate.bInit)
    {
        asmstate.bInit = да;
        init_optab();
        asmstate.psDollar = LabelDsymbol.создай(Id._dollar);
        asmstate.psLocalsize = ДСимвол.создай(Id.__LOCAL_SIZE);
    }

    asmstate.место = s.место;

    asmstate.tok = s.tokens;
    asm_token_trans(asmstate.tok);

    switch (asmstate.tokValue)
    {
        case cast(ТОК2)ASMTKnaked:
            s.naked = да;
            sc.func.naked = да;
            asm_token();
            break;

        case cast(ТОК2)ASMTKeven:
            asm_token();
            s.asmalign = 2;
            break;

        case ТОК2.align_:
        {
            asm_token();
            бцел _align = asm_getnum();
            if (ispow2(_align) == -1)
                asmerr("`align %d` must be a power of 2", _align);
            else
                s.asmalign = _align;
            break;
        }

        // The following three convert the keywords 'цел', 'in', 'out'
        // to identifiers, since they are x86 instructions.
        case ТОК2.int32:
            o = asm_op_lookup(Id.__int.вТкст0());
            goto Lopcode;

        case ТОК2.in_:
            o = asm_op_lookup(Id.___in.вТкст0());
            goto Lopcode;

        case ТОК2.out_:
            o = asm_op_lookup(Id.___out.вТкст0());
            goto Lopcode;

        case ТОК2.идентификатор:
            o = asm_op_lookup(asmstate.tok.идент.вТкст0());
            if (!o)
                goto OPCODE_EXPECTED;

        Lopcode:
            asmstate.ucItype = o.usNumops & ITMASK;
            asm_token();
            if (o.usNumops > 4)
            {
                switch (asmstate.ucItype)
                {
                    case ITdata:
                        s.asmcode = asm_db_parse(o);
                        goto AFTER_EMIT;

                    case ITaddr:
                        s.asmcode = asm_da_parse(o);
                        goto AFTER_EMIT;

                    default:
                        break;
                }
            }
            // get the first part of an expr
            if (asmstate.tokValue != ТОК2.endOfFile)
            {
                asm_cond_exp(opnd1);
                o1 = &opnd1;
                if (asmstate.tokValue == ТОК2.comma)
                {
                    asm_token();
                    asm_cond_exp(opnd2);
                    o2 = &opnd2;
                    if (asmstate.tokValue == ТОК2.comma)
                    {
                        asm_token();
                        asm_cond_exp(opnd3);
                        o3 = &opnd3;
                        if (asmstate.tokValue == ТОК2.comma)
                        {
                            asm_token();
                            asm_cond_exp(opnd4);
                            o4 = &opnd4;
                        }
                    }
                }
            }

            // match opcode and operands in ptrntab to verify legal inst and
            // generate

            ptb = asm_classify(o, o1, o2, o3, o4, cast(бцел*)&usNumops);
            assert(ptb.pptb0);

            //
            // The Multiply instruction takes 3 operands, but if only 2 are seen
            // then the third should be the second and the second should
            // be a duplicate of the first.
            //

            if (asmstate.ucItype == ITopt &&
                    (usNumops == 2) &&
                    (ASM_GET_aopty(o2.usFlags) == _imm) &&
                    ((o.usNumops & ITSIZE) == 3) &&
                    o2 && !o3)
            {
                o3 = o2;
                o2 = &opnd3;
                *o2 = *o1;

                // Re-classify the opcode because the first classification
                // assumed 2 operands.

                ptb = asm_classify(o, o1, o2, o3, o4, cast(бцел*)&usNumops);
            }
            else
            {
version (none)
{
                if (asmstate.ucItype == ITshift && (ptb.pptb2.usOp2 == 0 ||
                        (ptb.pptb2.usOp2 & _cl)))
                {
                    o2 = null;
                    usNumops = 1;
                }
}
            }
            s.asmcode = asm_emit(s.место, usNumops, ptb, o, o1, o2, o3, o4);
            break;

        default:
        OPCODE_EXPECTED:
            asmerr("opcode expected, not `%s`", asmstate.tok.вТкст0());
            break;
    }

AFTER_EMIT:

    if (asmstate.tokValue != ТОК2.endOfFile)
    {
        asmerr("end of instruction expected, not `%s`", asmstate.tok.вТкст0());  // end of line expected
    }
    //return asmstate.bReturnax;
    return s;
}

/**********************************
 * Called from back end.
 * Параметры: bp = asm block
 * Возвращает: mask of registers используется by block bp.
 */
 public regm_t iasm_regs(block *bp)
{
    debug (debuga)
        printf("Block iasm regs = 0x%X\n", bp.usIasmregs);

    refparam |= bp.bIasmrefparam;
    return bp.usIasmregs;
}



private:

const ADDFWAIT = нет;


// Additional tokens for the inline assembler
alias цел ASMTK;
enum
{
    ASMTKlocalsize = ТОК2.max_ + 1,
    ASMTKdword,
    ASMTKeven,
    ASMTKfar,
    ASMTKnaked,
    ASMTKnear,
    ASMTKptr,
    ASMTKqword,
    ASMTKseg,
    ASMTKword,
    ASMTKmax = ASMTKword-(ТОК2.max_+1)+1
}

const сим*[ASMTKmax] apszAsmtk =
[
    "__LOCAL_SIZE",
    "dword",
    "even",
    "far",
    "naked",
    "near",
    "ptr",
    "qword",
    "seg",
    "word",
];

alias ббайт ucItype_t;
enum
{
    ITprefix        = 0x10,    /// special префикс
    ITjump          = 0x20,    /// jump instructions CALL, Jxx and LOOPxx
    ITimmed         = 0x30,    /// значение of an immediate operand controls
                               /// code generation
    ITopt           = 0x40,    /// not all operands are required
    ITshift         = 0x50,    /// rotate and shift instructions
    ITfloat         = 0x60,    /// floating point coprocessor instructions
    ITdata          = 0x70,    /// DB, DW, DD, DQ, DT pseudo-ops
    ITaddr          = 0x80,    /// DA (define addresss) pseudo-op
    ITMASK          = 0xF0,
    ITSIZE          = 0x0F,    /// mask for size
}

struct ASM_STATE
{
    ucItype_t ucItype;  /// Instruction тип
    Место место;
    бул bInit;
    LabelDsymbol psDollar;
    ДСимвол psLocalsize;
    бул bReturnax;
    InlineAsmStatement инструкция;
    Scope* sc;
    Сема2* tok;
    ТОК2 tokValue;
    цел lbracketNestCount;
}

 ASM_STATE asmstate;

// From ptrntab.c

public{
    ткст0 asm_opstr(OP *вынь);
    OP *asm_op_lookup(ткст0 s);
    проц init_optab();
}

/**
 * Describes a register
 *
 * This struct is only используется for manifest constant
 */
struct REG
{
const:
    ткст regstr;
    ббайт val;
    opflag_t ty;

    бул isSIL_DIL_BPL_SPL()
    {
        // Be careful as these have the same val's as AH CH DH BH
        return ty == _r8 &&
            ((val == _SIL && regstr == "SIL") ||
             (val == _DIL && regstr == "DIL") ||
             (val == _BPL && regstr == "BPL") ||
             (val == _SPL && regstr == "SPL"));
    }
}

const REG regFp =      { "ST", 0, _st };

const REG[8] aregFp =
[
    { "ST(0)", 0, _sti },
    { "ST(1)", 1, _sti },
    { "ST(2)", 2, _sti },
    { "ST(3)", 3, _sti },
    { "ST(4)", 4, _sti },
    { "ST(5)", 5, _sti },
    { "ST(6)", 6, _sti },
    { "ST(7)", 7, _sti }
];


enum // the x86 CPU numbers for these registers
{
    _AL           = 0,
    _AH           = 4,
    _AX           = 0,
    _EAX          = 0,
    _BL           = 3,
    _BH           = 7,
    _BX           = 3,
    _EBX          = 3,
    _CL           = 1,
    _CH           = 5,
    _CX           = 1,
    _ECX          = 1,
    _DL           = 2,
    _DH           = 6,
    _DX           = 2,
    _EDX          = 2,
    _BP           = 5,
    _EBP          = 5,
    _SP           = 4,
    _ESP          = 4,
    _DI           = 7,
    _EDI          = 7,
    _SI           = 6,
    _ESI          = 6,
    _ES           = 0,
    _CS           = 1,
    _SS           = 2,
    _DS           = 3,
    _GS           = 5,
    _FS           = 4,
}

const REG[63] regtab =
[
    {"AL",   _AL,    _r8 | _al},
    {"AH",   _AH,    _r8},
    {"AX",   _AX,    _r16 | _ax},
    {"EAX",  _EAX,   _r32 | _eax},
    {"BL",   _BL,    _r8},
    {"BH",   _BH,    _r8},
    {"BX",   _BX,    _r16},
    {"EBX",  _EBX,   _r32},
    {"CL",   _CL,    _r8 | _cl},
    {"CH",   _CH,    _r8},
    {"CX",   _CX,    _r16},
    {"ECX",  _ECX,   _r32},
    {"DL",   _DL,    _r8},
    {"DH",   _DH,    _r8},
    {"DX",   _DX,    _r16 | _dx},
    {"EDX",  _EDX,   _r32},
    {"BP",   _BP,    _r16},
    {"EBP",  _EBP,   _r32},
    {"SP",   _SP,    _r16},
    {"ESP",  _ESP,   _r32},
    {"DI",   _DI,    _r16},
    {"EDI",  _EDI,   _r32},
    {"SI",   _SI,    _r16},
    {"ESI",  _ESI,   _r32},
    {"ES",   _ES,    _seg | _es},
    {"CS",   _CS,    _seg | _cs},
    {"SS",   _SS,    _seg | _ss },
    {"DS",   _DS,    _seg | _ds},
    {"GS",   _GS,    _seg | _gs},
    {"FS",   _FS,    _seg | _fs},
    {"CR0",  0,      _special | _crn},
    {"CR2",  2,      _special | _crn},
    {"CR3",  3,      _special | _crn},
    {"CR4",  4,      _special | _crn},
    {"DR0",  0,      _special | _drn},
    {"DR1",  1,      _special | _drn},
    {"DR2",  2,      _special | _drn},
    {"DR3",  3,      _special | _drn},
    {"DR4",  4,      _special | _drn},
    {"DR5",  5,      _special | _drn},
    {"DR6",  6,      _special | _drn},
    {"DR7",  7,      _special | _drn},
    {"TR3",  3,      _special | _trn},
    {"TR4",  4,      _special | _trn},
    {"TR5",  5,      _special | _trn},
    {"TR6",  6,      _special | _trn},
    {"TR7",  7,      _special | _trn},
    {"MM0",  0,      _mm},
    {"MM1",  1,      _mm},
    {"MM2",  2,      _mm},
    {"MM3",  3,      _mm},
    {"MM4",  4,      _mm},
    {"MM5",  5,      _mm},
    {"MM6",  6,      _mm},
    {"MM7",  7,      _mm},
    {"XMM0", 0,      _xmm | _xmm0},
    {"XMM1", 1,      _xmm},
    {"XMM2", 2,      _xmm},
    {"XMM3", 3,      _xmm},
    {"XMM4", 4,      _xmm},
    {"XMM5", 5,      _xmm},
    {"XMM6", 6,      _xmm},
    {"XMM7", 7,      _xmm},
];


enum // 64 bit only registers
{
    _RAX  = 0,
    _RBX  = 3,
    _RCX  = 1,
    _RDX  = 2,
    _RSI  = 6,
    _RDI  = 7,
    _RBP  = 5,
    _RSP  = 4,
    _R8   = 8,
    _R9   = 9,
    _R10  = 10,
    _R11  = 11,
    _R12  = 12,
    _R13  = 13,
    _R14  = 14,
    _R15  = 15,

    _R8D  = 8,
    _R9D  = 9,
    _R10D = 10,
    _R11D = 11,
    _R12D = 12,
    _R13D = 13,
    _R14D = 14,
    _R15D = 15,

    _R8W  = 8,
    _R9W  = 9,
    _R10W = 10,
    _R11W = 11,
    _R12W = 12,
    _R13W = 13,
    _R14W = 13,
    _R15W = 15,

    _SIL  = 6,
    _DIL  = 7,
    _BPL  = 5,
    _SPL  = 4,
    _R8B  = 8,
    _R9B  = 9,
    _R10B = 10,
    _R11B = 11,
    _R12B = 12,
    _R13B = 13,
    _R14B = 14,
    _R15B = 15,
}

const REG[73] regtab64 =
[
    {"RAX",  _RAX,   _r64 | _rax},
    {"RBX",  _RBX,   _r64},
    {"RCX",  _RCX,   _r64},
    {"RDX",  _RDX,   _r64},
    {"RSI",  _RSI,   _r64},
    {"RDI",  _RDI,   _r64},
    {"RBP",  _RBP,   _r64},
    {"RSP",  _RSP,   _r64},
    {"R8",   _R8,    _r64},
    {"R9",   _R9,    _r64},
    {"R10",  _R10,   _r64},
    {"R11",  _R11,   _r64},
    {"R12",  _R12,   _r64},
    {"R13",  _R13,   _r64},
    {"R14",  _R14,   _r64},
    {"R15",  _R15,   _r64},

    {"R8D",  _R8D,   _r32},
    {"R9D",  _R9D,   _r32},
    {"R10D", _R10D,  _r32},
    {"R11D", _R11D,  _r32},
    {"R12D", _R12D,  _r32},
    {"R13D", _R13D,  _r32},
    {"R14D", _R14D,  _r32},
    {"R15D", _R15D,  _r32},

    {"R8W",  _R8W,   _r16},
    {"R9W",  _R9W,   _r16},
    {"R10W", _R10W,  _r16},
    {"R11W", _R11W,  _r16},
    {"R12W", _R12W,  _r16},
    {"R13W", _R13W,  _r16},
    {"R14W", _R14W,  _r16},
    {"R15W", _R15W,  _r16},

    {"SIL",  _SIL,   _r8},
    {"DIL",  _DIL,   _r8},
    {"BPL",  _BPL,   _r8},
    {"SPL",  _SPL,   _r8},
    {"R8B",  _R8B,   _r8},
    {"R9B",  _R9B,   _r8},
    {"R10B", _R10B,  _r8},
    {"R11B", _R11B,  _r8},
    {"R12B", _R12B,  _r8},
    {"R13B", _R13B,  _r8},
    {"R14B", _R14B,  _r8},
    {"R15B", _R15B,  _r8},

    {"XMM8",   8,    _xmm},
    {"XMM9",   9,    _xmm},
    {"XMM10", 10,    _xmm},
    {"XMM11", 11,    _xmm},
    {"XMM12", 12,    _xmm},
    {"XMM13", 13,    _xmm},
    {"XMM14", 14,    _xmm},
    {"XMM15", 15,    _xmm},

    {"YMM0",   0,    _ymm},
    {"YMM1",   1,    _ymm},
    {"YMM2",   2,    _ymm},
    {"YMM3",   3,    _ymm},
    {"YMM4",   4,    _ymm},
    {"YMM5",   5,    _ymm},
    {"YMM6",   6,    _ymm},
    {"YMM7",   7,    _ymm},
    {"YMM8",   8,    _ymm},
    {"YMM9",   9,    _ymm},
    {"YMM10", 10,    _ymm},
    {"YMM11", 11,    _ymm},
    {"YMM12", 12,    _ymm},
    {"YMM13", 13,    _ymm},
    {"YMM14", 14,    _ymm},
    {"YMM15", 15,    _ymm},
    {"CR8",   8,     _r64 | _special | _crn},
];


alias цел ASM_JUMPTYPE;
enum
{
    ASM_JUMPTYPE_UNSPECIFIED,
    ASM_JUMPTYPE_SHORT,
    ASM_JUMPTYPE_NEAR,
    ASM_JUMPTYPE_FAR
}

struct OPND
{
    const REG *base;        // if plain register
    const REG *pregDisp1;   // if [register1]
    const REG *pregDisp2;
    const REG *segreg;      // if segment override
    бул bOffset;            // if 'смещение' keyword
    бул bSeg;               // if 'segment' keyword
    бул bPtr;               // if 'ptr' keyword
    бцел uchMultiplier;      // register multiplier; valid values are 0,1,2,4,8
    opflag_t usFlags;
    ДСимвол s;
    targ_llong disp;
    real_t vreal = 0.0;
    Тип ptype;
    ASM_JUMPTYPE ajt;
}


/*******************************
 */

проц asm_chktok(ТОК2 toknum, ткст0 msg)
{
    if (asmstate.tokValue == toknum)
        asm_token();                    // scan past token
    else
    {
        /* When we run out of tokens, asmstate.tok is null.
         * But when this happens when a ';' was hit.
         */
        asmerr(msg, asmstate.tok ? asmstate.tok.вТкст0() : ";");
    }
}


/*******************************
 */

PTRNTAB asm_classify(OP *вынь, OPND *popnd1, OPND *popnd2,
        OPND *popnd3, OPND *popnd4, бцел *pusNumops)
{
    бцел usNumops;
    бцел usActual;
    PTRNTAB ptbRet = { null };
    opflag_t opflags1 = 0 ;
    opflag_t opflags2 = 0;
    opflag_t opflags3 = 0;
    opflag_t opflags4 = 0;
    бул    bInvalid64bit = нет;

    бул   bMatch1, bMatch2, bMatch3, bMatch4, bRetry = нет;

    // How many arguments are there?  the parser is strictly left to right
    // so this should work.

    if (!popnd1)
    {
        usNumops = 0;
    }
    else
    {
        popnd1.usFlags = opflags1 = asm_determine_operand_flags(popnd1);
        if (!popnd2)
        {
            usNumops = 1;
        }
        else
        {
            popnd2.usFlags = opflags2 = asm_determine_operand_flags(popnd2);
            if (!popnd3)
            {
                usNumops = 2;
            }
            else
            {
                popnd3.usFlags = opflags3 = asm_determine_operand_flags(popnd3);
                if (!popnd4)
                {
                    usNumops = 3;
                }
                else
                {
                    popnd4.usFlags = opflags4 = asm_determine_operand_flags(popnd4);
                    usNumops = 4;
                }
            }
        }
    }

    // Now check to insure that the number of operands is correct
    usActual = (вынь.usNumops & ITSIZE);
    if (usActual != usNumops && asmstate.ucItype != ITopt &&
        asmstate.ucItype != ITfloat)
    {
PARAM_ERROR:
        asmerr("%u operands found for `%s` instead of the expected %u", usNumops, asm_opstr(вынь), usActual);
    }
    if (usActual < usNumops)
        *pusNumops = usActual;
    else
        *pusNumops = usNumops;

    проц TYPE_SIZE_ERROR()
    {
        if (popnd1 && ASM_GET_aopty(popnd1.usFlags) != _reg)
        {
            opflags1 = popnd1.usFlags |= _anysize;
            if (asmstate.ucItype == ITjump)
            {
                if (bRetry && popnd1.s && !popnd1.s.isLabel())
                {
                    asmerr("label expected", popnd1.s.вТкст0());
                }

                popnd1.usFlags |= CONSTRUCT_FLAGS(0, 0, 0,
                        _fanysize);
            }
        }
        if (popnd2 && ASM_GET_aopty(popnd2.usFlags) != _reg)
        {
            opflags2 = popnd2.usFlags |= (_anysize);
            if (asmstate.ucItype == ITjump)
                popnd2.usFlags |= CONSTRUCT_FLAGS(0, 0, 0,
                        _fanysize);
        }
        if (popnd3 && ASM_GET_aopty(popnd3.usFlags) != _reg)
        {
            opflags3 = popnd3.usFlags |= (_anysize);
            if (asmstate.ucItype == ITjump)
                popnd3.usFlags |= CONSTRUCT_FLAGS(0, 0, 0,
                        _fanysize);
        }
        if (bRetry)
        {
            if(bInvalid64bit)
                asmerr("operand for `%s` invalid in 64bit mode", asm_opstr(вынь));
            else
                asmerr("bad тип/size of operands `%s`", asm_opstr(вынь));
        }
        bRetry = да;
    }

//
//  The number of arguments matches, now check to найди the opcode
//  in the associated opcode table
//
RETRY:
    //printf("usActual = %d\n", usActual);
    switch (usActual)
    {
        case 0:
            if (глоб2.парамы.is64bit && (вынь.ptb.pptb0.usFlags & _i64_bit))
                asmerr("opcode `%s` is unavailable in 64bit mode", asm_opstr(вынь));  // illegal opcode in 64bit mode

            if ((asmstate.ucItype == ITopt ||
                 asmstate.ucItype == ITfloat) &&
                usNumops != 0)
                goto PARAM_ERROR;

            ptbRet = вынь.ptb;

            goto RETURN_IT;

        case 1:
        {
            //printf("opflags1 = "); asm_output_flags(opflags1); printf("\n");
            PTRNTAB1 *table1;
            for (table1 = вынь.ptb.pptb1; table1.opcode != ASM_END;
                    table1++)
            {
                //printf("table    = "); asm_output_flags(table1.usOp1); printf("\n");
                bMatch1 = asm_match_flags(opflags1, table1.usOp1);
                //printf("bMatch1 = x%x\n", bMatch1);
                if (bMatch1)
                {
                    if (table1.opcode == 0x68 &&
                        table1.usOp1 == _imm16
                      )
                        // Don't match PUSH imm16 in 32 bit code
                        continue;

                    // Check if match is invalid in 64bit mode
                    if (глоб2.парамы.is64bit && (table1.usFlags & _i64_bit))
                    {
                        bInvalid64bit = да;
                        continue;
                    }

                    break;
                }
                if ((asmstate.ucItype == ITimmed) &&
                    asm_match_flags(opflags1,
                        CONSTRUCT_FLAGS(_8 | _16 | _32, _imm, _normal,
                                         0)) &&
                        popnd1.disp == table1.usFlags)
                    break;
                if (asmstate.ucItype == ITopt ||
                    asmstate.ucItype == ITfloat)
                {
                    switch (usNumops)
                    {
                        case 0:
                            if (!table1.usOp1)
                                goto Lfound1;
                            break;
                        case 1:
                            break;
                        default:
                            goto PARAM_ERROR;
                    }
                }
            }
        Lfound1:
            if (table1.opcode == ASM_END)
            {
                debug (debuga)
                {
                    printf("\t%s\t", asm_opstr(вынь));
                    if (popnd1)
                            asm_output_popnd(popnd1);
                    if (popnd2)
                    {
                            printf(",");
                            asm_output_popnd(popnd2);
                    }
                    if (popnd3)
                    {
                            printf(",");
                            asm_output_popnd(popnd3);
                    }
                    printf("\n");

                    printf("OPCODE mism = ");
                    if (popnd1)
                        asm_output_flags(popnd1.usFlags);
                    else
                        printf("NONE");
                    printf("\n");
                }
                TYPE_SIZE_ERROR();
                goto RETRY;
            }
            ptbRet.pptb1 = table1;
            goto RETURN_IT;
        }
        case 2:
        {
            //printf("opflags1 = "); asm_output_flags(opflags1); printf(" ");
            //printf("opflags2 = "); asm_output_flags(opflags2); printf("\n");
            PTRNTAB2 *table2;
            for (table2 = вынь.ptb.pptb2;
                 table2.opcode != ASM_END;
                 table2++)
            {
                //printf("table1   = "); asm_output_flags(table2.usOp1); printf(" ");
                //printf("table2   = "); asm_output_flags(table2.usOp2); printf("\n");
                if (глоб2.парамы.is64bit && (table2.usFlags & _i64_bit))
                    asmerr("opcode `%s` is unavailable in 64bit mode", asm_opstr(вынь));

                bMatch1 = asm_match_flags(opflags1, table2.usOp1);
                bMatch2 = asm_match_flags(opflags2, table2.usOp2);
                //printf("match1 = %d, match2 = %d\n",bMatch1,bMatch2);
                if (bMatch1 && bMatch2)
                {
                    //printf("match\n");

                    /* Don't match if implicit sign-extension will
                     * change the значение of the immediate operand
                     */
                    if (!bRetry && ASM_GET_aopty(table2.usOp2) == _imm)
                    {
                        цел op1size = ASM_GET_uSizemask(table2.usOp1);
                        if (!op1size) // implicit register operand
                        {
                            switch (ASM_GET_uRegmask(table2.usOp1))
                            {
                                case ASM_GET_uRegmask(_al):
                                case ASM_GET_uRegmask(_cl): op1size = _8; break;
                                case ASM_GET_uRegmask(_ax):
                                case ASM_GET_uRegmask(_dx): op1size = _16; break;
                                case ASM_GET_uRegmask(_eax): op1size = _32; break;
                                case ASM_GET_uRegmask(_rax): op1size = _64; break;
                                default:
                                    assert(0);
                            }
                        }
                        if (op1size > ASM_GET_uSizemask(table2.usOp2))
                        {
                            switch(ASM_GET_uSizemask(table2.usOp2))
                            {
                                case _8:
                                    if (popnd2.disp > byte.max)
                                        continue;
                                    break;
                                case _16:
                                    if (popnd2.disp > short.max)
                                        continue;
                                    break;
                                case _32:
                                    if (popnd2.disp > цел.max)
                                        continue;
                                    break;
                                default:
                                    assert(0);
                            }
                        }
                    }
                    break;
                }
                if (asmstate.ucItype == ITopt ||
                    asmstate.ucItype == ITfloat)
                {
                    switch (usNumops)
                    {
                        case 0:
                            if (!table2.usOp1)
                                goto Lfound2;
                            break;
                        case 1:
                            if (bMatch1 && !table2.usOp2)
                                goto Lfound2;
                            break;
                        case 2:
                            break;
                        default:
                            goto PARAM_ERROR;
                    }
                }
version (none)
{
                if (asmstate.ucItype == ITshift &&
                    !table2.usOp2 &&
                    bMatch1 && popnd2.disp == 1 &&
                    asm_match_flags(opflags2,
                        CONSTRUCT_FLAGS(_8|_16|_32, _imm,_normal,0))
                  )
                    break;
}
            }
        Lfound2:
            if (table2.opcode == ASM_END)
            {
                debug (debuga)
                {
                    printf("\t%s\t", asm_opstr(вынь));
                    if (popnd1)
                        asm_output_popnd(popnd1);
                    if (popnd2)
                    {
                        printf(",");
                        asm_output_popnd(popnd2);
                    }
                    if (popnd3)
                    {
                        printf(",");
                        asm_output_popnd(popnd3);
                    }
                    printf("\n");

                    printf("OPCODE mismatch = ");
                    if (popnd1)
                        asm_output_flags(popnd1.usFlags);
                    else
                        printf("NONE");
                    printf( " Op2 = ");
                    if (popnd2)
                        asm_output_flags(popnd2.usFlags);
                    else
                        printf("NONE");
                    printf("\n");
                }
                TYPE_SIZE_ERROR();
                goto RETRY;
            }
            ptbRet.pptb2 = table2;
            goto RETURN_IT;
        }
        case 3:
        {
            PTRNTAB3 *table3;
            for (table3 = вынь.ptb.pptb3;
                 table3.opcode != ASM_END;
                 table3++)
            {
                bMatch1 = asm_match_flags(opflags1, table3.usOp1);
                bMatch2 = asm_match_flags(opflags2, table3.usOp2);
                bMatch3 = asm_match_flags(opflags3, table3.usOp3);
                if (bMatch1 && bMatch2 && bMatch3)
                    goto Lfound3;
                if (asmstate.ucItype == ITopt)
                {
                    switch (usNumops)
                    {
                        case 0:
                            if (!table3.usOp1)
                                goto Lfound3;
                            break;
                        case 1:
                            if (bMatch1 && !table3.usOp2)
                                goto Lfound3;
                            break;
                        case 2:
                            if (bMatch1 && bMatch2 && !table3.usOp3)
                                goto Lfound3;
                            break;
                        case 3:
                            break;
                        default:
                            goto PARAM_ERROR;
                    }
                }
            }
        Lfound3:
            if (table3.opcode == ASM_END)
            {
                debug (debuga)
                {
                    printf("\t%s\t", asm_opstr(вынь));
                    if (popnd1)
                        asm_output_popnd(popnd1);
                    if (popnd2)
                    {
                        printf(",");
                        asm_output_popnd(popnd2);
                    }
                    if (popnd3)
                    {
                        printf(",");
                        asm_output_popnd(popnd3);
                    }
                    printf("\n");

                    printf("OPCODE mismatch = ");
                    if (popnd1)
                        asm_output_flags(popnd1.usFlags);
                    else
                        printf("NONE");
                    printf( " Op2 = ");
                    if (popnd2)
                        asm_output_flags(popnd2.usFlags);
                    else
                        printf("NONE");
                    if (popnd3)
                        asm_output_flags(popnd3.usFlags);
                    printf("\n");
                }
                TYPE_SIZE_ERROR();
                goto RETRY;
            }
            ptbRet.pptb3 = table3;
            goto RETURN_IT;
        }
        case 4:
        {
            PTRNTAB4 *table4;
            for (table4 = вынь.ptb.pptb4;
                 table4.opcode != ASM_END;
                 table4++)
            {
                bMatch1 = asm_match_flags(opflags1, table4.usOp1);
                bMatch2 = asm_match_flags(opflags2, table4.usOp2);
                bMatch3 = asm_match_flags(opflags3, table4.usOp3);
                bMatch4 = asm_match_flags(opflags4, table4.usOp4);
                if (bMatch1 && bMatch2 && bMatch3 && bMatch4)
                    goto Lfound4;
                if (asmstate.ucItype == ITopt)
                {
                    switch (usNumops)
                    {
                        case 0:
                            if (!table4.usOp1)
                                goto Lfound4;
                            break;
                        case 1:
                            if (bMatch1 && !table4.usOp2)
                                goto Lfound4;
                            break;
                        case 2:
                            if (bMatch1 && bMatch2 && !table4.usOp3)
                                goto Lfound4;
                            break;
                        case 3:
                            if (bMatch1 && bMatch2 && bMatch3 && !table4.usOp4)
                                goto Lfound4;
                            break;
                        case 4:
                            break;
                        default:
                            goto PARAM_ERROR;
                    }
                }
            }
        Lfound4:
            if (table4.opcode == ASM_END)
            {
                debug (debuga)
                {
                    printf("\t%s\t", asm_opstr(вынь));
                    if (popnd1)
                        asm_output_popnd(popnd1);
                    if (popnd2)
                    {
                        printf(",");
                        asm_output_popnd(popnd2);
                    }
                    if (popnd3)
                    {
                        printf(",");
                        asm_output_popnd(popnd3);
                    }
                    if (popnd4)
                    {
                        printf(",");
                        asm_output_popnd(popnd4);
                    }
                    printf("\n");

                    printf("OPCODE mismatch = ");
                    if (popnd1)
                        asm_output_flags(popnd1.usFlags);
                    else
                        printf("NONE");
                    printf( " Op2 = ");
                    if (popnd2)
                        asm_output_flags(popnd2.usFlags);
                    else
                        printf("NONE");
                    printf( " Op3 = ");
                    if (popnd3)
                        asm_output_flags(popnd3.usFlags);
                    else
                        printf("NONE");
                    printf( " Op4 = ");
                    if (popnd4)
                        asm_output_flags(popnd4.usFlags);
                    else
                        printf("NONE");
                    printf("\n");
                }
                TYPE_SIZE_ERROR();
                goto RETRY;
            }
            ptbRet.pptb4 = table4;
            goto RETURN_IT;
        }
        default:
            break;
    }
RETURN_IT:
    if (bRetry)
    {
        asmerr("bad тип/size of operands `%s`", asm_opstr(вынь));
    }
    return ptbRet;
}

/*******************************
 */

opflag_t asm_determine_float_flags(OPND *popnd)
{
    //printf("asm_determine_float_flags()\n");

    opflag_t us, usFloat;

    // Insure that if it is a register, that it is not a normal processor
    // register.

    if (popnd.base &&
        !popnd.s && !popnd.disp && !popnd.vreal
        && !(popnd.base.ty & (_r8 | _r16 | _r32)))
    {
        return popnd.base.ty;
    }
    if (popnd.pregDisp1 && !popnd.base)
    {
        us = asm_float_type_size(popnd.ptype, &usFloat);
        //printf("us = x%x, usFloat = x%x\n", us, usFloat);
        if (popnd.pregDisp1.ty & (_r32 | _r64))
            return(CONSTRUCT_FLAGS(us, _m, _addr32, usFloat));
        else if (popnd.pregDisp1.ty & _r16)
            return(CONSTRUCT_FLAGS(us, _m, _addr16, usFloat));
    }
    else if (popnd.s !is null)
    {
        us = asm_float_type_size(popnd.ptype, &usFloat);
        return CONSTRUCT_FLAGS(us, _m, _normal, usFloat);
    }

    if (popnd.segreg)
    {
        us = asm_float_type_size(popnd.ptype, &usFloat);
        return(CONSTRUCT_FLAGS(us, _m, _addr32, usFloat));
    }

version (none)
{
    if (popnd.vreal)
    {
        switch (popnd.ptype.ty)
        {
            case Tfloat32:
                popnd.s = fconst(popnd.vreal);
                return(CONSTRUCT_FLAGS(_32, _m, _normal, 0));

            case Tfloat64:
                popnd.s = dconst(popnd.vreal);
                return(CONSTRUCT_FLAGS(0, _m, _normal, _f64));

            case Tfloat80:
                popnd.s = ldconst(popnd.vreal);
                return(CONSTRUCT_FLAGS(0, _m, _normal, _f80));
        }
    }
}

    asmerr("unknown operand for floating point instruction");
    return 0;
}

/*******************************
 */

opflag_t asm_determine_operand_flags(OPND *popnd)
{
    ДСимвол ps;
    цел ty;
    opflag_t us;
    opflag_t sz;
    ASM_OPERAND_TYPE opty;
    ASM_MODIFIERS amod;

    // If specified 'смещение' or 'segment' but no symbol
    if ((popnd.bOffset || popnd.bSeg) && !popnd.s)
        выведиОшибку(asmstate.место, "specified 'смещение' or 'segment' but no symbol");

    if (asmstate.ucItype == ITfloat)
        return asm_determine_float_flags(popnd);

    // If just a register
    if (popnd.base && !popnd.s && !popnd.disp && !popnd.vreal)
            return popnd.base.ty;
    debug (debuga)
        printf("popnd.base = %s\n, popnd.pregDisp1 = %p\n", popnd.base ? popnd.base.regstr : "NONE", popnd.pregDisp1);

    ps = popnd.s;
    Declaration ds = ps ? ps.isDeclaration() : null;
    if (ds && ds.класс_хранения & STC.lazy_)
        sz = _anysize;
    else
        sz = asm_type_size((ds && ds.класс_хранения & (STC.out_ | STC.ref_)) ? popnd.ptype.pointerTo() : popnd.ptype);
    if (popnd.pregDisp1 && !popnd.base)
    {
        if (ps && ps.isLabel() && sz == _anysize)
            sz = _32;
        return (popnd.pregDisp1.ty & (_r32 | _r64))
            ? CONSTRUCT_FLAGS(sz, _m, _addr32, 0)
            : CONSTRUCT_FLAGS(sz, _m, _addr16, 0);
    }
    else if (ps)
    {
        if (popnd.bOffset || popnd.bSeg || ps == asmstate.psLocalsize)
            return CONSTRUCT_FLAGS(_32, _imm, _normal, 0);

        if (ps.isLabel())
        {
            switch (popnd.ajt)
            {
                case ASM_JUMPTYPE_UNSPECIFIED:
                    if (ps == asmstate.psDollar)
                    {
                        if (popnd.disp >= byte.min &&
                            popnd.disp <= byte.max)
                            us = CONSTRUCT_FLAGS(_8, _rel, _flbl,0);
                        else if (popnd.disp >= short.min &&
                            popnd.disp <= short.max && !глоб2.парамы.is64bit)
                            us = CONSTRUCT_FLAGS(_16, _rel, _flbl,0);
                        else
                            us = CONSTRUCT_FLAGS(_32, _rel, _flbl,0);
                    }
                    else if (asmstate.ucItype != ITjump)
                    {
                        if (sz == _8)
                        {
                            us = CONSTRUCT_FLAGS(_8,_rel,_flbl,0);
                            break;
                        }
                        goto case_near;
                    }
                    else
                        us = CONSTRUCT_FLAGS(_8|_32, _rel, _flbl,0);
                    break;

                case ASM_JUMPTYPE_NEAR:
                case_near:
                    us = CONSTRUCT_FLAGS(_32, _rel, _flbl, 0);
                    break;
                case ASM_JUMPTYPE_SHORT:
                    us = CONSTRUCT_FLAGS(_8, _rel, _flbl, 0);
                    break;
                case ASM_JUMPTYPE_FAR:
                    us = CONSTRUCT_FLAGS(_48, _rel, _flbl, 0);
                    break;
                default:
                    assert(0);
            }
            return us;
        }
        if (!popnd.ptype)
            return CONSTRUCT_FLAGS(sz, _m, _normal, 0);
        ty = popnd.ptype.ty;
        if (ty == Tpointer && popnd.ptype.nextOf().ty == Tfunction &&
            !ps.isVarDeclaration())
        {
            return CONSTRUCT_FLAGS(_32, _m, _fn16, 0);
        }
        else if (ty == Tfunction)
        {
            return CONSTRUCT_FLAGS(_32, _rel, _fn16, 0);
        }
        else if (asmstate.ucItype == ITjump)
        {
            amod = _normal;
            goto L1;
        }
        else
            return CONSTRUCT_FLAGS(sz, _m, _normal, 0);
    }
    if (popnd.segreg /*|| popnd.bPtr*/)
    {
        amod = _addr32;
        if (asmstate.ucItype == ITjump)
        {
        L1:
            opty = _m;
            if (sz == _48)
                opty = _mnoi;
            us = CONSTRUCT_FLAGS(sz,opty,amod,0);
        }
        else
            us = CONSTRUCT_FLAGS(sz,
//                               _rel, amod, 0);
                                 _m, amod, 0);
    }

    else if (popnd.ptype)
        us = CONSTRUCT_FLAGS(sz, _imm, _normal, 0);
    else if (popnd.disp >= byte.min && popnd.disp <= ббайт.max)
        us = CONSTRUCT_FLAGS(  _8 | _16 | _32 | _64, _imm, _normal, 0);
    else if (popnd.disp >= short.min && popnd.disp <= ushort.max)
        us = CONSTRUCT_FLAGS( _16 | _32 | _64, _imm, _normal, 0);
    else if (popnd.disp >= цел.min && popnd.disp <= бцел.max)
        us = CONSTRUCT_FLAGS( _32 | _64, _imm, _normal, 0);
    else
        us = CONSTRUCT_FLAGS( _64, _imm, _normal, 0);
    return us;
}

/******************************
 * Convert assembly instruction into a code, and приставь
 * it to the code generated for this block.
 */

code *asm_emit(Место место,
    бцел usNumops, PTRNTAB ptb,
    OP *вынь,
    OPND *popnd1, OPND *popnd2, OPND *popnd3, OPND *popnd4)
{
    ббайт[16] auchOpcode;
    бцел usIdx = 0;
    debug
    {
        проц emit(бцел op) { auchOpcode[usIdx++] = cast(ббайт)op; }
    }
    else
    {
        проц emit(бцел op) { }
    }
//  бцел us;
    ббайт *puc;
    бцел usDefaultseg;
    code *pc = null;
    OPND *popndTmp = null;
    ASM_OPERAND_TYPE    aoptyTmp;
    бцел  uSizemaskTmp;
    const REG *pregSegment;
    //ASM_OPERAND_TYPE    aopty1 = _reg , aopty2 = 0, aopty3 = 0;
    ASM_MODIFIERS       amod1 = _normal, amod2 = _normal;
    бцел            uSizemaskTable1 =0, uSizemaskTable2 =0,
                        uSizemaskTable3 =0;
    ASM_OPERAND_TYPE    aoptyTable1 = _reg, aoptyTable2 = _reg, aoptyTable3 = _reg;
    ASM_MODIFIERS       amodTable1 = _normal,
                        amodTable2 = _normal;
    бцел            uRegmaskTable1 = 0, uRegmaskTable2 =0;

    pc = code_calloc();
    pc.Iflags |= CFpsw;            // assume we want to keep the flags
    if (popnd1)
    {
        //aopty1 = ASM_GET_aopty(popnd1.usFlags);
        amod1 = ASM_GET_amod(popnd1.usFlags);

        uSizemaskTable1 = ASM_GET_uSizemask(ptb.pptb1.usOp1);
        aoptyTable1 = ASM_GET_aopty(ptb.pptb1.usOp1);
        amodTable1 = ASM_GET_amod(ptb.pptb1.usOp1);
        uRegmaskTable1 = ASM_GET_uRegmask(ptb.pptb1.usOp1);

    }
    if (popnd2)
    {
        version (none)
        {
            printf("\nasm_emit:\nop: ");
            asm_output_flags(popnd2.usFlags);
            printf("\ntb: ");
            asm_output_flags(ptb.pptb2.usOp2);
            printf("\n");
        }

        //aopty2 = ASM_GET_aopty(popnd2.usFlags);
        amod2 = ASM_GET_amod(popnd2.usFlags);

        uSizemaskTable2 = ASM_GET_uSizemask(ptb.pptb2.usOp2);
        aoptyTable2 = ASM_GET_aopty(ptb.pptb2.usOp2);
        amodTable2 = ASM_GET_amod(ptb.pptb2.usOp2);
        uRegmaskTable2 = ASM_GET_uRegmask(ptb.pptb2.usOp2);
    }
    if (popnd3)
    {
        //aopty3 = ASM_GET_aopty(popnd3.usFlags);

        uSizemaskTable3 = ASM_GET_uSizemask(ptb.pptb3.usOp3);
        aoptyTable3 = ASM_GET_aopty(ptb.pptb3.usOp3);
    }

    asmstate.инструкция.regs |= asm_modify_regs(ptb, popnd1, popnd2);

    if (ptb.pptb0.usFlags & _64_bit && !глоб2.парамы.is64bit)
        выведиОшибку(asmstate.место, "use -m64 to compile 64 bit instructions");

    if (глоб2.парамы.is64bit && (ptb.pptb0.usFlags & _64_bit))
    {
        emit(REX | REX_W);
        pc.Irex |= REX_W;
    }

    switch (usNumops)
    {
        case 0:
            if (ptb.pptb0.usFlags & _16_bit)
            {
                emit(0x66);
                pc.Iflags |= CFopsize;
            }
            break;

        // vex adds 4 operand instructions, but already provides
        // encoded operation size
        case 4:
            break;

        // 3 and 2 are the same because the third operand is always
        // an immediate and does not affect operation size
        case 3:
        case 2:
            if ((!глоб2.парамы.is64bit &&
                  (amod2 == _addr16 ||
                   (uSizemaskTable2 & _16 && aoptyTable2 == _rel) ||
                   (uSizemaskTable2 & _32 && aoptyTable2 == _mnoi) ||
                   (ptb.pptb2.usFlags & _16_bit_addr)
                 )
                )
              )
            {
                emit(0x67);
                pc.Iflags |= CFaddrsize;
                if (!глоб2.парамы.is64bit)
                    amod2 = _addr16;
                else
                    amod2 = _addr32;
                popnd2.usFlags &= ~CONSTRUCT_FLAGS(0,0,7,0);
                popnd2.usFlags |= CONSTRUCT_FLAGS(0,0,amod2,0);
            }


        /* Fall through, operand 1 controls the opsize, but the
            address size can be in either operand 1 or operand 2,
            hence the extra checking the flags tested for SHOULD
            be mutex on operand 1 and operand 2 because there is
            only one MOD R/M byte
         */
            goto case;

        case 1:
            if ((!глоб2.парамы.is64bit &&
                  (amod1 == _addr16 ||
                   (uSizemaskTable1 & _16 && aoptyTable1 == _rel) ||
                    (uSizemaskTable1 & _32 && aoptyTable1 == _mnoi) ||
                    (ptb.pptb1.usFlags & _16_bit_addr))))
            {
                emit(0x67);     // address size префикс
                pc.Iflags |= CFaddrsize;
                if (!глоб2.парамы.is64bit)
                    amod1 = _addr16;
                else
                    amod1 = _addr32;
                popnd1.usFlags &= ~CONSTRUCT_FLAGS(0,0,7,0);
                popnd1.usFlags |= CONSTRUCT_FLAGS(0,0,amod1,0);
            }

            // If the size of the operand is unknown, assume that it is
            // the default size
            if (ptb.pptb0.usFlags & _16_bit)
            {
                //if (asmstate.ucItype != ITjump)
                {
                    emit(0x66);
                    pc.Iflags |= CFopsize;
                }
            }
            if (((pregSegment = (popndTmp = popnd1).segreg) != null) ||
                    ((popndTmp = popnd2) != null &&
                    (pregSegment = popndTmp.segreg) != null)
              )
            {
                if ((popndTmp.pregDisp1 &&
                        popndTmp.pregDisp1.val == _BP) ||
                        popndTmp.pregDisp2 &&
                        popndTmp.pregDisp2.val == _BP)
                        usDefaultseg = _SS;
                else if (asmstate.ucItype == ITjump)
                        usDefaultseg = _CS;
                else
                        usDefaultseg = _DS;
                if (pregSegment.val != usDefaultseg)
                {
                    if (asmstate.ucItype == ITjump)
                        выведиОшибку(asmstate.место, "Cannot generate a segment префикс for a branching instruction");
                    else
                        switch (pregSegment.val)
                        {
                        case _CS:
                            emit(0x2e);
                            pc.Iflags |= CFcs;
                            break;
                        case _SS:
                            emit(0x36);
                            pc.Iflags |= CFss;
                            break;
                        case _DS:
                            emit(0x3e);
                            pc.Iflags |= CFds;
                            break;
                        case _ES:
                            emit(0x26);
                            pc.Iflags |= CFes;
                            break;
                        case _FS:
                            emit(0x64);
                            pc.Iflags |= CFfs;
                            break;
                        case _GS:
                            emit(0x65);
                            pc.Iflags |= CFgs;
                            break;
                        default:
                            assert(0);
                        }
                }
            }
            break;
    }
    бцел opcode = ptb.pptb0.opcode;

    pc.Iop = opcode;
    if (pc.Ivex.pfx == 0xC4)
    {
        debug бцел oIdx = usIdx;

        // vvvv
        switch (pc.Ivex.vvvv)
        {
        case VEX_NOO:
            pc.Ivex.vvvv = 0xF; // not используется

            if ((aoptyTable1 == _m || aoptyTable1 == _rm) &&
                aoptyTable2 == _reg)
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd1, popnd2);
            else if (usNumops == 2 || usNumops == 3 && aoptyTable3 == _imm)
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd2, popnd1);
            else
                assert(!usNumops); // no operands

            if (usNumops == 3)
            {
                popndTmp = popnd3;
                aoptyTmp = ASM_GET_aopty(ptb.pptb3.usOp3);
                uSizemaskTmp = ASM_GET_uSizemask(ptb.pptb3.usOp3);
                assert(aoptyTmp == _imm);
            }
            break;

        case VEX_NDD:
            pc.Ivex.vvvv = cast(ббайт) ~cast(цел)(popnd1.base.val);

            asm_make_modrm_byte(
                auchOpcode.ptr, &usIdx,
                pc,
                ptb.pptb1.usFlags,
                popnd2, null);

            if (usNumops == 3)
            {
                popndTmp = popnd3;
                aoptyTmp = ASM_GET_aopty(ptb.pptb3.usOp3);
                uSizemaskTmp = ASM_GET_uSizemask(ptb.pptb3.usOp3);
                assert(aoptyTmp == _imm);
            }
            break;

        case VEX_DDS:
            assert(usNumops == 3);
            pc.Ivex.vvvv = cast(ббайт) ~cast(цел)(popnd2.base.val);

            asm_make_modrm_byte(
                auchOpcode.ptr, &usIdx,
                pc,
                ptb.pptb1.usFlags,
                popnd3, popnd1);
            break;

        case VEX_NDS:
            pc.Ivex.vvvv = cast(ббайт) ~cast(цел)(popnd2.base.val);

            if (aoptyTable1 == _m || aoptyTable1 == _rm)
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd1, popnd3);
            else
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd3, popnd1);

            if (usNumops == 4)
            {
                popndTmp = popnd4;
                aoptyTmp = ASM_GET_aopty(ptb.pptb4.usOp4);
                uSizemaskTmp = ASM_GET_uSizemask(ptb.pptb4.usOp4);
                assert(aoptyTmp == _imm);
            }
            break;

        default:
            assert(0);
        }

        // REX
        // REX_W is solely taken from WO/W1/WIG
        // pc.Ivex.w = !!(pc.Irex & REX_W);
        pc.Ivex.b =  !(pc.Irex & REX_B);
        pc.Ivex.x =  !(pc.Irex & REX_X);
        pc.Ivex.r =  !(pc.Irex & REX_R);

        /* Check if a 3-byte vex is needed.
         */
        checkSetVex3(pc);
        if (pc.Iflags & CFvex3)
        {
            debug
            {
                memmove(&auchOpcode.ptr[oIdx+3], &auchOpcode[oIdx], usIdx-oIdx);
                usIdx = oIdx;
            }
            emit(0xC4);
            emit(VEX3_B1(pc.Ivex));
            emit(VEX3_B2(pc.Ivex));
            pc.Iflags |= CFvex3;
        }
        else
        {
            debug
            {
                memmove(&auchOpcode[oIdx+2], &auchOpcode[oIdx], usIdx-oIdx);
                usIdx = oIdx;
            }
            emit(0xC5);
            emit(VEX2_B1(pc.Ivex));
        }
        pc.Iflags |= CFvex;
        emit(pc.Ivex.op);
        if (popndTmp)
            goto L1;
        goto L2;
    }
    else if ((opcode & 0xFFFD00) == 0x0F3800)    // SSSE3, SSE4
    {
        emit(0xFF);
        emit(0xFD);
        emit(0x00);
        goto L3;
    }

    switch (opcode & 0xFF0000)
    {
        case 0:
            break;

        case 0x660000:
            opcode &= 0xFFFF;
            goto L3;

        case 0xF20000:                      // REPNE
        case 0xF30000:                      // REP/REPE
            // BUG: What if there's an address size префикс or segment
            // override префикс? Must the REP be adjacent to the rest
            // of the opcode?
            opcode &= 0xFFFF;
            goto L3;

        case 0x0F0000:                      // an AMD instruction
            puc = (cast(ббайт *) &opcode);
            if (puc[1] != 0x0F)             // if not AMD instruction 0x0F0F
                goto L4;
            emit(puc[2]);
            emit(puc[1]);
            emit(puc[0]);
            pc.Iop >>= 8;
            pc.IEV2.Vint = puc[0];
            pc.IFL2 = FLconst;
            goto L3;

        default:
            puc = (cast(ббайт *) &opcode);
        L4:
            emit(puc[2]);
            emit(puc[1]);
            emit(puc[0]);
            pc.Iop >>= 8;
            pc.Irm = puc[0];
            goto L3;
    }
    if (opcode & 0xff00)
    {
        puc = (cast(ббайт *) &(opcode));
        emit(puc[1]);
        emit(puc[0]);
        pc.Iop = puc[1];
        if (pc.Iop == 0x0f)
        {
            pc.Iop = 0x0F00 | puc[0];
        }
        else
        {
            if (opcode == 0xDFE0) // FSTSW AX
            {
                pc.Irm = puc[0];
                goto L2;
            }
            if (asmstate.ucItype == ITfloat)
            {
                pc.Irm = puc[0];
            }
            else
            {
                pc.IEV2.Vint = puc[0];
                pc.IFL2 = FLconst;
            }
        }
    }
    else
    {
        emit(opcode);
    }
L3:

    // If CALL, Jxx or LOOPx to a symbolic location
    if (/*asmstate.ucItype == ITjump &&*/
        popnd1 && popnd1.s && popnd1.s.isLabel())
    {
        ДСимвол s = popnd1.s;
        if (s == asmstate.psDollar)
        {
            pc.IFL2 = FLconst;
            if (uSizemaskTable1 & (_8 | _16))
                pc.IEV2.Vint = cast(цел)popnd1.disp;
            else if (uSizemaskTable1 & _32)
                pc.IEV2.Vpointer = cast(targ_т_мера) popnd1.disp;
        }
        else
        {
            LabelDsymbol label = s.isLabel();
            if (label)
            {
                if ((pc.Iop & ~0x0F) == 0x70)
                    pc.Iflags |= CFjmp16;
                if (usNumops == 1)
                {
                    pc.IFL2 = FLblock;
                    pc.IEV2.Vlsym = cast(_LabelDsymbol*)label;
                }
                else
                {
                    pc.IFL1 = FLblock;
                    pc.IEV1.Vlsym = cast(_LabelDsymbol*)label;
                }
            }
        }
    }

    switch (usNumops)
    {
        case 0:
            break;
        case 1:
            if (((aoptyTable1 == _reg || aoptyTable1 == _float) &&
                 amodTable1 == _normal && (uRegmaskTable1 & _rplus_r)))
            {
                бцел reg = popnd1.base.val;
                if (reg & 8)
                {
                    reg &= 7;
                    pc.Irex |= REX_B;
                    assert(глоб2.парамы.is64bit);
                }
                if (asmstate.ucItype == ITfloat)
                    pc.Irm += reg;
                else
                    pc.Iop += reg;
                debug auchOpcode[usIdx-1] += reg;
            }
            else
            {
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd1, null);
            }
            popndTmp = popnd1;
            aoptyTmp = aoptyTable1;
            uSizemaskTmp = uSizemaskTable1;
L1:
            if (aoptyTmp == _imm)
            {
                Declaration d = popndTmp.s ? popndTmp.s.isDeclaration()
                                             : null;
                if (popndTmp.bSeg)
                {
                    if (!(d && d.isDataseg()))
                        asmerr("bad addr mode");
                }
                switch (uSizemaskTmp)
                {
                    case _8:
                    case _16:
                    case _32:
                    case _64:
                        if (popndTmp.s == asmstate.psLocalsize)
                        {
                            pc.IFL2 = FLlocalsize;
                            pc.IEV2.Vdsym = null;
                            pc.Iflags |= CFoff;
                            pc.IEV2.Voffset = popndTmp.disp;
                        }
                        else if (d)
                        {
                            //if ((pc.IFL2 = d.Sfl) == 0)
                                pc.IFL2 = FLdsymbol;
                            pc.Iflags &= ~(CFseg | CFoff);
                            if (popndTmp.bSeg)
                                pc.Iflags |= CFseg;
                            else
                                pc.Iflags |= CFoff;
                            pc.IEV2.Voffset = popndTmp.disp;
                            pc.IEV2.Vdsym = cast(_Declaration*)d;
                        }
                        else
                        {
                            pc.IEV2.Vllong = popndTmp.disp;
                            pc.IFL2 = FLconst;
                        }
                        break;

                    default:
                        break;
                }
            }

            break;
    case 2:
//
// If there are two immediate operands then
//
        if (aoptyTable1 == _imm &&
            aoptyTable2 == _imm)
        {
                pc.IEV1.Vint = cast(цел)popnd1.disp;
                pc.IFL1 = FLconst;
                pc.IEV2.Vint = cast(цел)popnd2.disp;
                pc.IFL2 = FLconst;
                break;
        }
        if (aoptyTable2 == _m ||
            aoptyTable2 == _rel ||
            // If not MMX register (_mm) or XMM register (_xmm)
            (amodTable1 == _rspecial && !(uRegmaskTable1 & (0x08 | 0x10)) && !uSizemaskTable1) ||
            aoptyTable2 == _rm ||
            (popnd1.usFlags == _r32 && popnd2.usFlags == _xmm) ||
            (popnd1.usFlags == _r32 && popnd2.usFlags == _mm))
        {
            version (none)
            {
                printf("test4 %d,%d,%d,%d\n",
                    (aoptyTable2 == _m),
                    (aoptyTable2 == _rel),
                    (amodTable1 == _rspecial && !(uRegmaskTable1 & (0x08 | 0x10))),
                    (aoptyTable2 == _rm)
                    );
                printf("opcode = %x\n", opcode);
            }
            if (ptb.pptb0.opcode == 0x0F7E ||    // MOVD _rm32,_mm
                ptb.pptb0.opcode == 0x660F7E     // MOVD _rm32,_xmm
               )
            {
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd1, popnd2);
            }
            else
            {
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd2, popnd1);
            }
            popndTmp = popnd1;
            aoptyTmp = aoptyTable1;
            uSizemaskTmp = uSizemaskTable1;
        }
        else
        {
            if (((aoptyTable1 == _reg || aoptyTable1 == _float) &&
                 amodTable1 == _normal &&
                 (uRegmaskTable1 & _rplus_r)))
            {
                бцел reg = popnd1.base.val;
                if (reg & 8)
                {
                    reg &= 7;
                    pc.Irex |= REX_B;
                    assert(глоб2.парамы.is64bit);
                }
                else if (popnd1.base.isSIL_DIL_BPL_SPL())
                {
                    pc.Irex |= REX;
                    assert(глоб2.парамы.is64bit);
                }
                if (asmstate.ucItype == ITfloat)
                    pc.Irm += reg;
                else
                    pc.Iop += reg;
                debug auchOpcode[usIdx-1] += reg;
            }
            else if (((aoptyTable2 == _reg || aoptyTable2 == _float) &&
                 amodTable2 == _normal &&
                 (uRegmaskTable2 & _rplus_r)))
            {
                бцел reg = popnd2.base.val;
                if (reg & 8)
                {
                    reg &= 7;
                    pc.Irex |= REX_B;
                    assert(глоб2.парамы.is64bit);
                }
                else if (popnd1.base.isSIL_DIL_BPL_SPL())
                {
                    pc.Irex |= REX;
                    assert(глоб2.парамы.is64bit);
                }
                if (asmstate.ucItype == ITfloat)
                    pc.Irm += reg;
                else
                    pc.Iop += reg;
                debug auchOpcode[usIdx-1] += reg;
            }
            else if (ptb.pptb0.opcode == 0xF30FD6 ||
                     ptb.pptb0.opcode == 0x0F12 ||
                     ptb.pptb0.opcode == 0x0F16 ||
                     ptb.pptb0.opcode == 0x660F50 ||
                     ptb.pptb0.opcode == 0x0F50 ||
                     ptb.pptb0.opcode == 0x660FD7 ||
                     ptb.pptb0.opcode == MOVDQ2Q ||
                     ptb.pptb0.opcode == 0x0FD7)
            {
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd2, popnd1);
            }
            else
            {
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd1, popnd2);

            }
            if (aoptyTable1 == _imm)
            {
                popndTmp = popnd1;
                aoptyTmp = aoptyTable1;
                uSizemaskTmp = uSizemaskTable1;
            }
            else
            {
                popndTmp = popnd2;
                aoptyTmp = aoptyTable2;
                uSizemaskTmp = uSizemaskTable2;
            }
        }
        goto L1;

    case 3:
        if (aoptyTable2 == _m || aoptyTable2 == _rm ||
            opcode == 0x0FC5     ||    // pextrw  _r32,  _mm,    _imm8
            opcode == 0x660FC5   ||    // pextrw  _r32, _xmm,    _imm8
            opcode == 0x660F3A20 ||    // pinsrb  _xmm, _r32/m8, _imm8
            opcode == 0x660F3A22       // pinsrd  _xmm, _rm32,   _imm8
           )
        {
            asm_make_modrm_byte(
                auchOpcode.ptr, &usIdx,
                pc,
                ptb.pptb1.usFlags,
                popnd2, popnd1);
        popndTmp = popnd3;
        aoptyTmp = aoptyTable3;
        uSizemaskTmp = uSizemaskTable3;
        }
        else
        {

            if (((aoptyTable1 == _reg || aoptyTable1 == _float) &&
                 amodTable1 == _normal &&
                 (uRegmaskTable1 &_rplus_r)))
            {
                бцел reg = popnd1.base.val;
                if (reg & 8)
                {
                    reg &= 7;
                    pc.Irex |= REX_B;
                    assert(глоб2.парамы.is64bit);
                }
                if (asmstate.ucItype == ITfloat)
                    pc.Irm += reg;
                else
                    pc.Iop += reg;
                debug auchOpcode[usIdx-1] += reg;
            }
            else if (((aoptyTable2 == _reg || aoptyTable2 == _float) &&
                 amodTable2 == _normal &&
                 (uRegmaskTable2 &_rplus_r)))
            {
                бцел reg = popnd1.base.val;
                if (reg & 8)
                {
                    reg &= 7;
                    pc.Irex |= REX_B;
                    assert(глоб2.парамы.is64bit);
                }
                if (asmstate.ucItype == ITfloat)
                    pc.Irm += reg;
                else
                    pc.Iop += reg;
                debug auchOpcode[usIdx-1] += reg;
            }
            else
                asm_make_modrm_byte(
                    auchOpcode.ptr, &usIdx,
                    pc,
                    ptb.pptb1.usFlags,
                    popnd1, popnd2);

            popndTmp = popnd3;
            aoptyTmp = aoptyTable3;
            uSizemaskTmp = uSizemaskTable3;

        }
        goto L1;
    }
L2:

    if ((pc.Iop & ~7) == 0xD8 &&
        ADDFWAIT &&
        !(ptb.pptb0.usFlags & _nfwait))
            pc.Iflags |= CFwait;
    else if ((ptb.pptb0.usFlags & _fwait) &&
        config.target_cpu >= TARGET_80386)
            pc.Iflags |= CFwait;

    debug (debuga)
    {
        бцел u;

        for (u = 0; u < usIdx; u++)
            printf("  %02X", auchOpcode[u]);

        printf("\t%s\t", asm_opstr(вынь));
        if (popnd1)
            asm_output_popnd(popnd1);
        if (popnd2)
        {
            printf(",");
            asm_output_popnd(popnd2);
        }
        if (popnd3)
        {
            printf(",");
            asm_output_popnd(popnd3);
        }
        printf("\n");
    }

    CodeBuilder cdb;
    cdb.ctor();

    if (глоб2.парамы.symdebug)
    {
        cdb.genlinnum(Srcpos.создай(место.имяф, место.номстр, место.имяс));
    }

    cdb.приставь(pc);
    return cdb.finish();
}


/*******************************
 */

проц asmerr(ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    verror(asmstate.место, format, ap);
    va_end(ap);

    exit(EXIT_FAILURE);
}

/*******************************
 */

opflag_t asm_float_type_size(Тип ptype, opflag_t *pusFloat)
{
    *pusFloat = 0;

    //printf("asm_float_type_size('%s')\n", ptype.вТкст0());
    if (ptype && ptype.isscalar())
    {
        цел sz = cast(цел)ptype.size();
        if (sz == target.realsize)
        {
            *pusFloat = _f80;
            return 0;
        }
        switch (sz)
        {
            case 2:
                return _16;
            case 4:
                return _32;
            case 8:
                *pusFloat = _f64;
                return 0;
            case 10:
                *pusFloat = _f80;
                return 0;
            default:
                break;
        }
    }
    *pusFloat = _fanysize;
    return _anysize;
}

/*******************************
 */

private   бул asm_isint(ref OPND o)
{
    if (o.base || o.s)
        return нет;
    return да;
}

private   бул asm_isNonZeroInt(ref OPND o)
{
    if (o.base || o.s)
        return нет;
    return o.disp != 0;
}

/*******************************
 */

private   бул asm_is_fpreg(ткст szReg)
{
    return szReg == "ST";
}

/*******************************
 * Merge operands o1 and o2 into a single operand, o1.
 */

private проц asm_merge_opnds(ref OPND o1, ref OPND o2)
{
    //printf("asm_merge_opnds()\n");
    debug ткст0 psz;
    debug (EXTRA_DEBUG) debug (debuga)
    {
        printf("asm_merge_opnds(o1 = ");
        asm_output_popnd(o1);
        printf(", o2 = ");
        asm_output_popnd(o2);
        printf(")\n");
    }
    debug (EXTRA_DEBUG)
        printf("Combining Operands: mult1 = %d, mult2 = %d",
                o1.uchMultiplier, o2.uchMultiplier);
    /*      combine the OPND's disp field */
    if (o2.segreg)
    {
        if (o1.segreg)
        {
            debug psz = "o1.segment && o2.segreg";
            goto ILLEGAL_ADDRESS_ERROR;
        }
        else
            o1.segreg = o2.segreg;
    }

    // combine the OPND's symbol field
    if (o1.s && o2.s)
    {
        debug psz = "o1.s && ос.s";
ILLEGAL_ADDRESS_ERROR:
        debug printf("Invalid addr because /%s/\n", psz);

        выведиОшибку(asmstate.место, "cannot have two symbols in addressing mode");
    }
    else if (o2.s)
    {
        o1.s = o2.s;
    }
    else if (o1.s && o1.s.isTupleDeclaration())
    {
        TupleDeclaration tup = o1.s.isTupleDeclaration();
        т_мера index = cast(цел)o2.disp;
        if (index >= tup.objects.dim)
        {
            выведиОшибку(asmstate.место, "кортеж index %u exceeds length %u", index, tup.objects.dim);
        }
        else
        {
            КорневойОбъект o = (*tup.objects)[index];
            if (o.динкаст() == ДИНКАСТ.дсимвол)
            {
                o1.s = cast(ДСимвол)o;
                return;
            }
            else if (o.динкаст() == ДИНКАСТ.Выражение)
            {
                Выражение e = cast(Выражение)o;
                if (e.op == ТОК2.variable)
                {
                    o1.s = (cast(VarExp)e).var;
                    return;
                }
                else if (e.op == ТОК2.function_)
                {
                    o1.s = (cast(FuncExp)e).fd;
                    return;
                }
            }
            выведиОшибку(asmstate.место, "invalid asm operand `%s`", o1.s.вТкст0());
        }
    }

    if (o1.disp && o2.disp)
        o1.disp += o2.disp;
    else if (o2.disp)
        o1.disp = o2.disp;

    /* combine the OPND's base field */
    if (o1.base != null && o2.base != null)
    {
            debug psz = "o1.base != null && o2.base != null";
            goto ILLEGAL_ADDRESS_ERROR;
    }
    else if (o2.base)
            o1.base = o2.base;

    /* Combine the displacement register fields */
    if (o2.pregDisp1)
    {
        if (o1.pregDisp2)
        {
            debug psz = "o2.pregDisp1 && o1.pregDisp2";
            goto ILLEGAL_ADDRESS_ERROR;
        }
        else if (o1.pregDisp1)
        {
            if (o1.uchMultiplier ||
                    (o2.pregDisp1.val == _ESP &&
                    (o2.pregDisp1.ty & _r32) &&
                    !o2.uchMultiplier))
            {
                o1.pregDisp2 = o1.pregDisp1;
                o1.pregDisp1 = o2.pregDisp1;
            }
            else
                o1.pregDisp2 = o2.pregDisp1;
        }
        else
            o1.pregDisp1 = o2.pregDisp1;
    }
    if (o2.pregDisp2)
    {
        if (o1.pregDisp2)
        {
            debug psz = "o1.pregDisp2 && o2.pregDisp2";
            goto ILLEGAL_ADDRESS_ERROR;
        }
        else
            o1.pregDisp2 = o2.pregDisp2;
    }
    if (o2.uchMultiplier)
    {
        if (o1.uchMultiplier)
        {
            debug psz = "o1.uchMultiplier && o2.uchMultiplier";
            goto ILLEGAL_ADDRESS_ERROR;
        }
        else
            o1.uchMultiplier = o2.uchMultiplier;
    }
    if (o2.ptype && !o1.ptype)
        o1.ptype = o2.ptype;
    if (o2.bOffset)
        o1.bOffset = o2.bOffset;
    if (o2.bSeg)
        o1.bSeg = o2.bSeg;

    if (o2.ajt && !o1.ajt)
        o1.ajt = o2.ajt;

    debug (EXTRA_DEBUG)
        printf("результат = %d\n", o1.uchMultiplier);
    debug (debuga)
    {
        printf("Merged результат = /");
        asm_output_popnd(o1);
        printf("/\n");
    }
}

/***************************************
 */

проц asm_merge_symbol(ref OPND o1, ДСимвол s)
{
    VarDeclaration v;
    EnumMember em;

    //printf("asm_merge_symbol(s = %s %s)\n", s.вид(), s.вТкст0());
    s = s.toAlias();
    //printf("s = %s %s\n", s.вид(), s.вТкст0());
    if (s.isLabel())
    {
        o1.s = s;
        return;
    }

    v = s.isVarDeclaration();
    if (v)
    {
        if (v.isParameter())
            asmstate.инструкция.refparam = да;

        v.checkNestedReference(asmstate.sc, asmstate.место);
        if (0 && !v.isDataseg() && v.родитель != asmstate.sc.родитель && v.родитель)
        {
            asmerr("uplevel nested reference to variable `%s`", v.вТкст0());
        }
        if (v.isField())
        {
            o1.disp += v.смещение;
            goto L2;
        }
        if ((v.isConst() || v.isImmutable() || v.класс_хранения & STC.manifest) &&
            !v.тип.isfloating() && v.тип.ty != Tvector && v._иниц)
        {
            ExpInitializer ei = v._иниц.isExpInitializer();
            if (ei)
            {
                o1.disp = ei.exp.toInteger();
                return;
            }
        }
        if (v.isThreadlocal())
            выведиОшибку(asmstate.место, "cannot directly load TLS variable `%s`", v.вТкст0());
        else if (v.isDataseg() && глоб2.парамы.pic != PIC.fixed)
            выведиОшибку(asmstate.место, "cannot directly load глоб2 variable `%s` with PIC or PIE code", v.вТкст0());
    }
    em = s.isEnumMember();
    if (em)
    {
        o1.disp = em.значение().toInteger();
        return;
    }
    o1.s = s;  // a C идентификатор
L2:
    Declaration d = s.isDeclaration();
    if (!d)
    {
        asmerr("%s `%s` is not a declaration", s.вид(), s.вТкст0());
    }
    else if (d.getType())
        asmerr("cannot use тип `%s` as an operand", d.getType().вТкст0());
    else if (d.isTupleDeclaration())
    {
    }
    else
        o1.ptype = d.тип.toBasetype();
}

/****************************
 * Fill in the modregrm and sib bytes of code.
 */

проц asm_make_modrm_byte(
        ббайт *puchOpcode, бцел *pusIdx,
        code *pc,
        бцел usFlags,
        OPND *popnd, OPND *popnd2)
{
    struct MODRM_BYTE
    {
        бцел rm;
        бцел reg;
        бцел mod;
        бцел uchOpcode()
        {
            assert(rm < 8);
            assert(reg < 8);
            assert(mod < 4);
            return (mod << 6) | (reg << 3) | rm;
        }
    }

    struct SIB_BYTE
    {
        бцел base;
        бцел index;
        бцел ss;
        бцел uchOpcode()
        {
            assert(base < 8);
            assert(index < 8);
            assert(ss < 4);
            return (ss << 6) | (index << 3) | base;
        }
    }

    MODRM_BYTE  mrmb = { 0, 0, 0 };
    SIB_BYTE    sib = { 0, 0, 0 };
    бул                bSib = нет;
    бул                bDisp = нет;
    debug ббайт        *puc;
    бул                bModset = нет;
    ДСимвол             s;

    бцел                uSizemask =0;
    ASM_OPERAND_TYPE    aopty;
    ASM_MODIFIERS       amod;
    бул                bOffsetsym = нет;

    version (none)
    {
        printf("asm_make_modrm_byte(usFlags = x%x)\n", usFlags);
        printf("op1: ");
        asm_output_flags(popnd.usFlags);
        if (popnd2)
        {
            printf(" op2: ");
            asm_output_flags(popnd2.usFlags);
        }
        printf("\n");
    }

    uSizemask = ASM_GET_uSizemask(popnd.usFlags);
    aopty = ASM_GET_aopty(popnd.usFlags);
    amod = ASM_GET_amod(popnd.usFlags);
    s = popnd.s;
    if (s)
    {
        Declaration d = s.isDeclaration();

        if (amod == _fn16 && aopty == _rel && popnd2)
        {
            aopty = _m;
            goto L1;
        }

        if (amod == _fn16 || amod == _fn32)
        {
            pc.Iflags |= CFoff;
            debug
            {
                puchOpcode[(*pusIdx)++] = 0;
                puchOpcode[(*pusIdx)++] = 0;
            }
            if (aopty == _m || aopty == _mnoi)
            {
                pc.IFL1 = FLdata;
                pc.IEV1.Vdsym = cast(_Declaration*)d;
                pc.IEV1.Voffset = 0;
            }
            else
            {
                if (aopty == _p)
                    pc.Iflags |= CFseg;

                debug
                {
                    if (aopty == _p || aopty == _rel)
                    {
                        puchOpcode[(*pusIdx)++] = 0;
                        puchOpcode[(*pusIdx)++] = 0;
                    }
                }

                pc.IFL2 = FLfunc;
                pc.IEV2.Vdsym = cast(_Declaration*)d;
                pc.IEV2.Voffset = 0;
                //return;
            }
        }
        else
        {
          L1:
            LabelDsymbol label = s.isLabel();
            if (label)
            {
                if (s == asmstate.psDollar)
                {
                    pc.IFL1 = FLconst;
                    if (uSizemask & (_8 | _16))
                        pc.IEV1.Vint = cast(цел)popnd.disp;
                    else if (uSizemask & _32)
                        pc.IEV1.Vpointer = cast(targ_т_мера) popnd.disp;
                }
                else
                {
                    pc.IFL1 = FLblockoff;
                    pc.IEV1.Vlsym = cast(_LabelDsymbol*)label;
                }
            }
            else if (s == asmstate.psLocalsize)
            {
                pc.IFL1 = FLlocalsize;
                pc.IEV1.Vdsym = null;
                pc.Iflags |= CFoff;
                pc.IEV1.Voffset = popnd.disp;
            }
            else if (s.isFuncDeclaration())
            {
                pc.IFL1 = FLfunc;
                pc.IEV1.Vdsym = cast(_Declaration*)d;
                pc.Iflags |= CFoff;
                pc.IEV1.Voffset = popnd.disp;
            }
            else
            {
                debug (debuga)
                    printf("Setting up symbol %s\n", d.идент.вТкст0());
                pc.IFL1 = FLdsymbol;
                pc.IEV1.Vdsym = cast(_Declaration*)d;
                pc.Iflags |= CFoff;
                pc.IEV1.Voffset = popnd.disp;
            }
        }
    }
    mrmb.reg = usFlags & NUM_MASK;

    if (s && (aopty == _m || aopty == _mnoi) && !s.isLabel())
    {
        if (s == asmstate.psLocalsize)
        {
    DATA_REF:
            mrmb.rm = BPRM;
            if (amod == _addr16 || amod == _addr32)
                mrmb.mod = 0x2;
            else
                mrmb.mod = 0x0;
        }
        else
        {
            Declaration d = s.isDeclaration();
            assert(d);
            if (d.isDataseg() || d.isCodeseg())
            {
                if (!глоб2.парамы.is64bit && amod == _addr16)
                    выведиОшибку(asmstate.место, "cannot have 16 bit addressing mode in 32 bit code");
                goto DATA_REF;
            }
            mrmb.rm = BPRM;
            mrmb.mod = 0x2;
        }
    }

    if (aopty == _reg || amod == _rspecial)
    {
        mrmb.mod = 0x3;
        mrmb.rm |= popnd.base.val & NUM_MASK;
        if (popnd.base.val & NUM_MASKR)
            pc.Irex |= REX_B;
        else if (popnd.base.isSIL_DIL_BPL_SPL())
            pc.Irex |= REX;
    }
    else if (amod == _addr16)
    {
        бцел rm;

        debug (debuga)
            printf("This is an ADDR16\n");
        if (!popnd.pregDisp1)
        {
            rm = 0x6;
            if (!s)
                bDisp = да;
        }
        else
        {
            бцел r1r2;
            static бцел X(бцел r1, бцел r2) { return (r1 * 16) + r2; }
            static бцел Y(бцел r1) { return X(r1,9); }


            if (popnd.pregDisp2)
                r1r2 = X(popnd.pregDisp1.val,popnd.pregDisp2.val);
            else
                r1r2 = Y(popnd.pregDisp1.val);
            switch (r1r2)
            {
                case X(_BX,_SI):        rm = 0; break;
                case X(_BX,_DI):        rm = 1; break;
                case Y(_BX):    rm = 7; break;

                case X(_BP,_SI):        rm = 2; break;
                case X(_BP,_DI):        rm = 3; break;
                case Y(_BP):    rm = 6; bDisp = да;   break;

                case X(_SI,_BX):        rm = 0; break;
                case X(_SI,_BP):        rm = 2; break;
                case Y(_SI):    rm = 4; break;

                case X(_DI,_BX):        rm = 1; break;
                case X(_DI,_BP):        rm = 3; break;
                case Y(_DI):    rm = 5; break;

                default:
                    asmerr("bad 16 bit index address mode");
            }
        }
        mrmb.rm = rm;

        debug (debuga)
            printf("This is an mod = %d, popnd.s =%p, popnd.disp = %lld\n",
               mrmb.mod, s, cast(long)popnd.disp);
        if (!s || (!mrmb.mod && popnd.disp))
        {
            if ((!popnd.disp && !bDisp) ||
                !popnd.pregDisp1)
                mrmb.mod = 0x0;
            else if (popnd.disp >= byte.min &&
                popnd.disp <= byte.max)
                mrmb.mod = 0x1;
            else
                mrmb.mod = 0X2;
        }
        else
            bOffsetsym = да;

    }
    else if (amod == _addr32 || (amod == _flbl && !глоб2.парамы.is64bit))
    {
        debug (debuga)
            printf("This is an ADDR32\n");
        if (!popnd.pregDisp1)
            mrmb.rm = 0x5;
        else if (popnd.pregDisp2 ||
                 popnd.uchMultiplier ||
                 (popnd.pregDisp1.val & NUM_MASK) == _ESP)
        {
            if (popnd.pregDisp2)
            {
                if (popnd.pregDisp2.val == _ESP)
                    выведиОшибку(asmstate.место, "`ESP` cannot be scaled index register");
            }
            else
            {
                if (popnd.uchMultiplier &&
                    popnd.pregDisp1.val ==_ESP)
                    выведиОшибку(asmstate.место, "`ESP` cannot be scaled index register");
                bDisp = да;
            }

            mrmb.rm = 0x4;
            bSib = да;
            if (bDisp)
            {
                if (!popnd.uchMultiplier &&
                    (popnd.pregDisp1.val & NUM_MASK) == _ESP)
                {
                    sib.base = 4;           // _ESP or _R12
                    sib.index = 0x4;
                    if (popnd.pregDisp1.val & NUM_MASKR)
                        pc.Irex |= REX_B;
                }
                else
                {
                    debug (debuga)
                        printf("Resetting the mod to 0\n");
                    if (popnd.pregDisp2)
                    {
                        if (popnd.pregDisp2.val != _EBP)
                            выведиОшибку(asmstate.место, "`EBP` cannot be base register");
                    }
                    else
                    {
                        mrmb.mod = 0x0;
                        bModset = да;
                    }

                    sib.base = 0x5;
                    sib.index = popnd.pregDisp1.val;
                }
            }
            else
            {
                sib.base = popnd.pregDisp1.val & NUM_MASK;
                if (popnd.pregDisp1.val & NUM_MASKR)
                    pc.Irex |= REX_B;
                //
                // This is to handle the special case
                // of using the EBP (or R13) register and no
                // displacement.  You must put in an
                // 8 byte displacement in order to
                // get the correct opcodes.
                //
                if ((popnd.pregDisp1.val == _EBP ||
                     popnd.pregDisp1.val == _R13) &&
                    (!popnd.disp && !s))
                {
                    debug (debuga)
                        printf("Setting the mod to 1 in the _EBP case\n");
                    mrmb.mod = 0x1;
                    bDisp = да;   // Need a
                                    // displacement
                    bModset = да;
                }

                sib.index = popnd.pregDisp2.val & NUM_MASK;
                if (popnd.pregDisp2.val & NUM_MASKR)
                    pc.Irex |= REX_X;

            }
            switch (popnd.uchMultiplier)
            {
                case 0: sib.ss = 0; break;
                case 1: sib.ss = 0; break;
                case 2: sib.ss = 1; break;
                case 4: sib.ss = 2; break;
                case 8: sib.ss = 3; break;

                default:
                    выведиОшибку(asmstate.место, "scale factor must be one of 0,1,2,4,8");
                    break;
            }
        }
        else
        {
            бцел rm;

            if (popnd.uchMultiplier)
                выведиОшибку(asmstate.место, "scale factor not allowed");
            switch (popnd.pregDisp1.val & (NUM_MASKR | NUM_MASK))
            {
                case _EBP:
                    if (!popnd.disp && !s)
                    {
                        mrmb.mod = 0x1;
                        bDisp = да;   // Need a displacement
                        bModset = да;
                    }
                    rm = 5;
                    break;

                case _ESP:
                    выведиОшибку(asmstate.место, "`[ESP]` addressing mode not allowed");
                    rm = 0;                     // no uninitialized данные
                    break;

                default:
                    rm = popnd.pregDisp1.val & NUM_MASK;
                    break;
            }
            if (popnd.pregDisp1.val & NUM_MASKR)
                pc.Irex |= REX_B;
            mrmb.rm = rm;
        }

        if (!bModset && (!s ||
                (!mrmb.mod && popnd.disp)))
        {
            if ((!popnd.disp && !mrmb.mod) ||
                (!popnd.pregDisp1 && !popnd.pregDisp2))
            {
                mrmb.mod = 0x0;
                bDisp = да;
            }
            else if (popnd.disp >= byte.min &&
                     popnd.disp <= byte.max)
                mrmb.mod = 0x1;
            else
                mrmb.mod = 0x2;
        }
        else
            bOffsetsym = да;
    }
    if (popnd2 && !mrmb.reg &&
        asmstate.ucItype != ITshift &&
        (ASM_GET_aopty(popnd2.usFlags) == _reg  ||
         ASM_GET_amod(popnd2.usFlags) == _rseg ||
         ASM_GET_amod(popnd2.usFlags) == _rspecial))
    {
        if (popnd2.base.isSIL_DIL_BPL_SPL())
            pc.Irex |= REX;
        mrmb.reg =  popnd2.base.val & NUM_MASK;
        if (popnd2.base.val & NUM_MASKR)
            pc.Irex |= REX_R;
    }
    debug puchOpcode[ (*pusIdx)++ ] = cast(ббайт)mrmb.uchOpcode();
    pc.Irm = cast(ббайт)mrmb.uchOpcode();
    //printf("Irm = %02x\n", pc.Irm);
    if (bSib)
    {
        debug puchOpcode[ (*pusIdx)++ ] = cast(ббайт)sib.uchOpcode();
        pc.Isib= cast(ббайт)sib.uchOpcode();
    }
    if ((!s || (popnd.pregDisp1 && !bOffsetsym)) &&
        aopty != _imm &&
        (popnd.disp || bDisp))
    {
        if (popnd.usFlags & _a16)
        {
            debug
            {
                puc = (cast(ббайт *) &(popnd.disp));
                puchOpcode[(*pusIdx)++] = puc[1];
                puchOpcode[(*pusIdx)++] = puc[0];
            }
            if (usFlags & (_modrm | NUM_MASK))
            {
                debug (debuga)
                    printf("Setting up значение %lld\n", cast(long)popnd.disp);
                pc.IEV1.Vint = cast(цел)popnd.disp;
                pc.IFL1 = FLconst;
            }
            else
            {
                pc.IEV2.Vint = cast(цел)popnd.disp;
                pc.IFL2 = FLconst;
            }
        }
        else
        {
            debug
            {
                puc = (cast(ббайт *) &(popnd.disp));
                puchOpcode[(*pusIdx)++] = puc[3];
                puchOpcode[(*pusIdx)++] = puc[2];
                puchOpcode[(*pusIdx)++] = puc[1];
                puchOpcode[(*pusIdx)++] = puc[0];
            }
            if (usFlags & (_modrm | NUM_MASK))
            {
                debug (debuga)
                    printf("Setting up значение %lld\n", cast(long)popnd.disp);
                pc.IEV1.Vpointer = cast(targ_т_мера) popnd.disp;
                pc.IFL1 = FLconst;
            }
            else
            {
                pc.IEV2.Vpointer = cast(targ_т_мера) popnd.disp;
                pc.IFL2 = FLconst;
            }

        }
    }
}

/*******************************
 */

regm_t asm_modify_regs(PTRNTAB ptb, OPND *popnd1, OPND *popnd2)
{
    regm_t usRet = 0;

    switch (ptb.pptb0.usFlags & MOD_MASK)
    {
    case _modsi:
        usRet |= mSI;
        break;
    case _moddx:
        usRet |= mDX;
        break;
    case _mod2:
        if (popnd2)
            usRet |= asm_modify_regs(ptb, popnd2, null);
        break;
    case _modax:
        usRet |= mAX;
        break;
    case _modnot1:
        popnd1 = null;
        break;
    case _modaxdx:
        usRet |= (mAX | mDX);
        break;
    case _moddi:
        usRet |= mDI;
        break;
    case _modsidi:
        usRet |= (mSI | mDI);
        break;
    case _modcx:
        usRet |= mCX;
        break;
    case _modes:
        /*usRet |= mES;*/
        break;
    case _modall:
        asmstate.bReturnax = да;
        return /*mES |*/ ALLREGS;
    case _modsiax:
        usRet |= (mSI | mAX);
        break;
    case _modsinot1:
        usRet |= mSI;
        popnd1 = null;
        break;
    case _modcxr11:
        usRet |= (mCX | mR11);
        break;
    case _modxmm0:
        usRet |= mXMM0;
        break;
    default:
        break;
    }
    if (popnd1 && ASM_GET_aopty(popnd1.usFlags) == _reg)
    {
        switch (ASM_GET_amod(popnd1.usFlags))
        {
        default:
            usRet |= 1 << popnd1.base.val;
            usRet &= ~(mBP | mSP);              // ignore changing these
            break;

        case _rseg:
            //if (popnd1.base.val == _ES)
                //usRet |= mES;
            break;

        case _rspecial:
            break;
        }
    }
    if (usRet & mAX)
        asmstate.bReturnax = да;

    return usRet;
}

/*******************************
 * Match flags in operand against flags in opcode table.
 * Возвращает:
 *      да if match
 */

бул asm_match_flags(opflag_t usOp, opflag_t usTable)
{
    ASM_OPERAND_TYPE    aoptyTable;
    ASM_OPERAND_TYPE    aoptyOp;
    ASM_MODIFIERS       amodTable;
    ASM_MODIFIERS       amodOp;
    бцел                uRegmaskTable;
    бцел                uRegmaskOp;
    ббайт               bRegmatch;
    бул                bRetval = нет;
    бцел                uSizemaskOp;
    бцел                uSizemaskTable;
    бцел                bSizematch;

    //printf("asm_match_flags(usOp = x%x, usTable = x%x)\n", usOp, usTable);
    if (asmstate.ucItype == ITfloat)
    {
        bRetval = asm_match_float_flags(usOp, usTable);
        goto EXIT;
    }

    uSizemaskOp = ASM_GET_uSizemask(usOp);
    uSizemaskTable = ASM_GET_uSizemask(usTable);

    // Check #1, if the sizes do not match, NO match
    bSizematch =  (uSizemaskOp & uSizemaskTable);

    amodOp = ASM_GET_amod(usOp);

    aoptyTable = ASM_GET_aopty(usTable);
    aoptyOp = ASM_GET_aopty(usOp);

    // _mmm64 matches with a 64 bit mem or an MMX register
    if (usTable == _mmm64)
    {
        if (usOp == _mm)
            goto Lmatch;
        if (aoptyOp == _m && (bSizematch || uSizemaskOp == _anysize))
            goto Lmatch;
        goto EXIT;
    }

    // _xmm_m32, _xmm_m64, _xmm_m128 match with XMM register or memory
    if (usTable == _xmm_m16 ||
        usTable == _xmm_m32 ||
        usTable == _xmm_m64 ||
        usTable == _xmm_m128)
    {
        if (usOp == _xmm || usOp == (_xmm|_xmm0))
            goto Lmatch;
        if (aoptyOp == _m && (bSizematch || uSizemaskOp == _anysize))
            goto Lmatch;
    }

    if (usTable == _ymm_m256)
    {
        if (usOp == _ymm)
            goto Lmatch;
        if (aoptyOp == _m && (bSizematch || uSizemaskOp == _anysize))
            goto Lmatch;
    }

    if (!bSizematch && uSizemaskTable)
    {
        //printf("no size match\n");
        goto EXIT;
    }


//
// The operand types must match, otherwise return нет.
// There is one exception for the _rm which is a table entry which matches
// _reg or _m
//
    if (aoptyTable != aoptyOp)
    {
        if (aoptyTable == _rm && (aoptyOp == _reg ||
                                  aoptyOp == _m ||
                                  aoptyOp == _rel))
            goto Lok;
        if (aoptyTable == _mnoi && aoptyOp == _m &&
            (uSizemaskOp == _32 && amodOp == _addr16 ||
             uSizemaskOp == _48 && amodOp == _addr32 ||
             uSizemaskOp == _48 && amodOp == _normal)
          )
            goto Lok;
        goto EXIT;
    }
Lok:

//
// Looks like a match so far, check to see if anything special is going on
//
    amodTable = ASM_GET_amod(usTable);
    uRegmaskOp = ASM_GET_uRegmask(usOp);
    uRegmaskTable = ASM_GET_uRegmask(usTable);
    bRegmatch = ((!uRegmaskTable && !uRegmaskOp) ||
                 (uRegmaskTable & uRegmaskOp));

    switch (amodTable)
    {
    case _normal:               // Normal's match with normals
        switch(amodOp)
        {
            case _normal:
            case _addr16:
            case _addr32:
            case _fn16:
            case _fn32:
            case _flbl:
                bRetval = (bSizematch || bRegmatch);
                goto EXIT;
            default:
                goto EXIT;
        }
    case _rseg:
    case _rspecial:
        bRetval = (amodOp == amodTable && bRegmatch);
        goto EXIT;
    default:
        assert(0);
    }
EXIT:
    version(none)
    {
        printf("OP : ");
        asm_output_flags(usOp);
        printf("\nTBL: ");
        asm_output_flags(usTable);
        printf(": %s\n", bRetval ? "MATCH" : "NOMATCH");
    }
    return bRetval;

Lmatch:
    //printf("match\n");
    return да;
}

/*******************************
 */

бул asm_match_float_flags(opflag_t usOp, opflag_t usTable)
{
    ASM_OPERAND_TYPE    aoptyTable;
    ASM_OPERAND_TYPE    aoptyOp;
    ASM_MODIFIERS       amodTable;
    ASM_MODIFIERS       amodOp;
    бцел                uRegmaskTable;
    бцел                uRegmaskOp;
    бцел                bRegmatch;


//
// Check #1, if the sizes do not match, NO match
//
    uRegmaskOp = ASM_GET_uRegmask(usOp);
    uRegmaskTable = ASM_GET_uRegmask(usTable);
    bRegmatch = (uRegmaskTable & uRegmaskOp);

    if (!(ASM_GET_uSizemask(usTable) & ASM_GET_uSizemask(usOp) ||
          bRegmatch))
        return нет;

    aoptyTable = ASM_GET_aopty(usTable);
    aoptyOp = ASM_GET_aopty(usOp);
//
// The operand types must match, otherwise return нет.
// There is one exception for the _rm which is a table entry which matches
// _reg or _m
//
    if (aoptyTable != aoptyOp)
    {
        if (aoptyOp != _float)
            return нет;
    }

//
// Looks like a match so far, check to see if anything special is going on
//
    amodOp = ASM_GET_amod(usOp);
    amodTable = ASM_GET_amod(usTable);
    switch (amodTable)
    {
        // Normal's match with normals
        case _normal:
            switch(amodOp)
            {
                case _normal:
                case _addr16:
                case _addr32:
                case _fn16:
                case _fn32:
                case _flbl:
                    return да;
                default:
                    return нет;
            }
        case _rseg:
        case _rspecial:
            return нет;
        default:
            assert(0);
    }
}


/*******************************
 */

//debug
 проц asm_output_flags(opflag_t opflags)
{
    ASM_OPERAND_TYPE    aopty = ASM_GET_aopty(opflags);
    ASM_MODIFIERS       amod = ASM_GET_amod(opflags);
    бцел                uRegmask = ASM_GET_uRegmask(opflags);
    бцел                uSizemask = ASM_GET_uSizemask(opflags);

    if (uSizemask == _anysize)
        printf("_anysize ");
    else if (uSizemask == 0)
        printf("0        ");
    else
    {
        if (uSizemask & _8)
            printf("_8  ");
        if (uSizemask & _16)
            printf("_16 ");
        if (uSizemask & _32)
            printf("_32 ");
        if (uSizemask & _48)
            printf("_48 ");
        if (uSizemask & _64)
            printf("_64 ");
    }

    printf("_");
    switch (aopty)
    {
        case _reg:
            printf("reg   ");
            break;
        case _m:
            printf("m     ");
            break;
        case _imm:
            printf("imm   ");
            break;
        case _rel:
            printf("rel   ");
            break;
        case _mnoi:
            printf("mnoi  ");
            break;
        case _p:
            printf("p     ");
            break;
        case _rm:
            printf("rm    ");
            break;
        case _float:
            printf("float ");
            break;
        default:
            printf(" UNKNOWN ");
    }

    printf("_");
    switch (amod)
    {
        case _normal:
            printf("normal   ");
            if (uRegmask & 1) printf("_al ");
            if (uRegmask & 2) printf("_ax ");
            if (uRegmask & 4) printf("_eax ");
            if (uRegmask & 8) printf("_dx ");
            if (uRegmask & 0x10) printf("_cl ");
            if (uRegmask & 0x40) printf("_rax ");
            if (uRegmask & 0x20) printf("_rplus_r ");
            return;
        case _rseg:
            printf("rseg     ");
            break;
        case _rspecial:
            printf("rspecial ");
            break;
        case _addr16:
            printf("addr16   ");
            break;
        case _addr32:
            printf("addr32   ");
            break;
        case _fn16:
            printf("fn16     ");
            break;
        case _fn32:
            printf("fn32     ");
            break;
        case _flbl:
            printf("flbl     ");
            break;
        default:
            printf("UNKNOWN  ");
            break;
    }
    printf("uRegmask=x%02x", uRegmask);

}

/*******************************
 */

//debug
 проц asm_output_popnd(OPND *popnd)
{
    if (popnd.segreg)
            printf("%s:", popnd.segreg.regstr.ptr);

    if (popnd.s)
            printf("%s", popnd.s.идент.вТкст0());

    if (popnd.base)
            printf("%s", popnd.base.regstr.ptr);
    if (popnd.pregDisp1)
    {
        if (popnd.pregDisp2)
        {
            if (popnd.usFlags & _a32)
            {
                if (popnd.uchMultiplier)
                    printf("[%s][%s*%d]",
                            popnd.pregDisp1.regstr.ptr,
                            popnd.pregDisp2.regstr.ptr,
                            popnd.uchMultiplier);
                else
                    printf("[%s][%s]",
                            popnd.pregDisp1.regstr.ptr,
                            popnd.pregDisp2.regstr.ptr);
            }
            else
                printf("[%s+%s]",
                        popnd.pregDisp1.regstr.ptr,
                        popnd.pregDisp2.regstr.ptr);
        }
        else
        {
            if (popnd.uchMultiplier)
                printf("[%s*%d]",
                        popnd.pregDisp1.regstr.ptr,
                        popnd.uchMultiplier);
            else
                printf("[%s]",
                        popnd.pregDisp1.regstr.ptr);
        }
    }
    if (ASM_GET_aopty(popnd.usFlags) == _imm)
            printf("%llxh", cast(long)popnd.disp);
    else if (popnd.disp)
            printf("+%llxh", cast(long)popnd.disp);
}


/*******************************
 */

REG* asm_reg_lookup(ткст s)
{
    //dbg_printf("asm_reg_lookup('%s')\n",s);

    for (цел i = 0; i < regtab.length; i++)
    {
        if (s == regtab[i].regstr)
        {
            return &regtab[i];
        }
    }
    if (глоб2.парамы.is64bit)
    {
        for (цел i = 0; i < regtab64.length; i++)
        {
            if (s == regtab64[i].regstr)
            {
                return &regtab64[i];
            }
        }
    }
    return null;
}


/*******************************
 */

проц asm_token()
{
    if (asmstate.tok)
        asmstate.tok = asmstate.tok.следщ;
    asm_token_trans(asmstate.tok);
}

/*******************************
 */

проц asm_token_trans(Сема2 *tok)
{
    asmstate.tokValue = ТОК2.endOfFile;
    if (tok)
    {
        asmstate.tokValue = tok.значение;
        if (asmstate.tokValue == ТОК2.идентификатор)
        {
            const ид = tok.идент.вТкст();
            if (ид.length < 20)
            {
                ASMTK asmtk = cast(ASMTK) binary(ид.ptr, cast(сим**)apszAsmtk.ptr, ASMTKmax);
                if (cast(цел)asmtk >= 0)
                    asmstate.tokValue = cast(ТОК2) (asmtk + ТОК2.max_ + 1);
            }
        }
    }
}

/*******************************
 */

бцел asm_type_size(Тип ptype)
{
    бцел u;

    //if (ptype) printf("asm_type_size('%s') = %d\n", ptype.вТкст0(), (цел)ptype.size());
    u = _anysize;
    if (ptype && ptype.ty != Tfunction /*&& ptype.isscalar()*/)
    {
        switch (cast(цел)ptype.size())
        {
            case 0:     asmerr("bad тип/size of operands `%s`", "0 size".ptr);    break;
            case 1:     u = _8;         break;
            case 2:     u = _16;        break;
            case 4:     u = _32;        break;
            case 6:     u = _48;        break;
            case 8:     if (глоб2.парамы.is64bit) u = _64;        break;
            default:    break;
        }
    }
    return u;
}

/*******************************
 *      start of inline assemblers Выражение parser
 *      NOTE: functions in call order instead of alphabetical
 */

/*******************************************
 * Parse DA Выражение
 *
 * Very limited define address to place a code
 * address in the assembly
 * Problems:
 *      o       Should use dw смещение and dd смещение instead,
 *              for near/far support.
 *      o       Should be able to add an смещение to the label address.
 *      o       Blocks addressed by DA should get their Bpred set correctly
 *              for optimizer.
 */

code *asm_da_parse(OP *вынь)
{
    CodeBuilder cdb;
    cdb.ctor();
    while (1)
    {
        if (asmstate.tokValue == ТОК2.идентификатор)
        {
            LabelDsymbol label = asmstate.sc.func.searchLabel(asmstate.tok.идент);
            if (!label)
                выведиОшибку(asmstate.место, "label `%s` not found", asmstate.tok.идент.вТкст0());
            else
                label.iasm = да;

            if (глоб2.парамы.symdebug)
                cdb.genlinnum(Srcpos.создай(asmstate.место.имяф, asmstate.место.номстр, asmstate.место.имяс));
            cdb.genasm(cast(_LabelDsymbol*)label);
        }
        else
            выведиОшибку(asmstate.место, "label expected as argument to DA pseudo-op"); // illegal addressing mode
        asm_token();
        if (asmstate.tokValue != ТОК2.comma)
            break;
        asm_token();
    }

    asmstate.инструкция.regs |= mES|ALLREGS;
    asmstate.bReturnax = да;

    return cdb.finish();
}

/*******************************************
 * Parse DB, DW, DD, DQ and DT Выражения.
 */

code *asm_db_parse(OP *вынь)
{
    union DT
    {
        targ_ullong ul;
        targ_float f;
        targ_double d;
        targ_ldouble ld;
        byte[10] значение;
    }
    DT dt;

    static const ббайт[7] opsize = [ 1,2,4,8,4,8,10 ];

    бцел op = вынь.usNumops & ITSIZE;
    т_мера usSize = opsize[op];

    т_мера usBytes = 0;
    т_мера usMaxbytes = 0;
    byte *bytes = null;

    while (1)
    {
        т_мера len;
        ббайт *q;
        ббайт *qstart = null;

        if (usBytes+usSize > usMaxbytes)
        {
            usMaxbytes = usBytes + usSize + 10;
            bytes = cast(byte *)mem.xrealloc(bytes, usMaxbytes);
        }
        switch (asmstate.tokValue)
        {
            case ТОК2.int32Literal:
                dt.ul = cast(d_int32)asmstate.tok.intvalue;
                goto L1;
            case ТОК2.uns32Literal:
                dt.ul = cast(d_uns32)asmstate.tok.unsvalue;
                goto L1;
            case ТОК2.int64Literal:
                dt.ul = asmstate.tok.intvalue;
                goto L1;
            case ТОК2.uns64Literal:
                dt.ul = asmstate.tok.unsvalue;
                goto L1;
            L1:
                switch (op)
                {
                    case OPdb:
                    case OPds:
                    case OPdi:
                    case OPdl:
                        break;
                    default:
                        asmerr("floating point expected");
                }
                goto L2;

            case ТОК2.float32Literal:
            case ТОК2.float64Literal:
            case ТОК2.float80Literal:
                switch (op)
                {
                    case OPdf:
                        dt.f = cast(float) asmstate.tok.floatvalue;
                        break;
                    case OPdd:
                        dt.d = cast(double) asmstate.tok.floatvalue;
                        break;
                    case OPde:
                        dt.ld = asmstate.tok.floatvalue;
                        break;
                    default:
                        asmerr("integer expected");
                }
                goto L2;

            L2:
                memcpy(bytes + usBytes, &dt, usSize);
                usBytes += usSize;
                break;

            case ТОК2.string_:
                len = asmstate.tok.len;
                q = cast(ббайт*)asmstate.tok.ustring;
            L3:
                if (len)
                {
                    usMaxbytes += len * usSize;
                    bytes = cast(byte *)mem.xrealloc(bytes, usMaxbytes);
                    memcpy(bytes + usBytes, asmstate.tok.ustring, len);

                    auto p = bytes + usBytes;
                    for (т_мера i = 0; i < len; i++)
                    {
                        // Be careful that this works
                        memset(p, 0, usSize);
                        switch (op)
                        {
                            case OPdb:
                                *p = cast(ббайт)*q;
                                if (*p != *q)
                                    asmerr("character is truncated");
                                break;

                            case OPds:
                                *cast(short *)p = *cast(ббайт *)q;
                                if (*cast(short *)p != *q)
                                    asmerr("character is truncated");
                                break;

                            case OPdi:
                            case OPdl:
                                *cast(цел *)p = *q;
                                break;

                            default:
                                asmerr("floating point expected");
                        }
                        q++;
                        p += usSize;
                    }

                    usBytes += len * usSize;
                }
                if (qstart)
                {
                    mem.xfree(qstart);
                    qstart = null;
                }
                break;

            case ТОК2.идентификатор:
            {
                Выражение e = IdentifierExp.создай(asmstate.место, asmstate.tok.идент);
                Scope *sc = asmstate.sc.startCTFE();
                e = e.ВыражениеSemantic(sc);
                sc.endCTFE();
                e = e.ctfeInterpret();
                if (e.op == ТОК2.int64)
                {
                    dt.ul = e.toInteger();
                    goto L2;
                }
                else if (e.op == ТОК2.float64)
                {
                    switch (op)
                    {
                        case OPdf:
                            dt.f = cast(float) e.toReal();
                            break;
                        case OPdd:
                            dt.d = cast(double) e.toReal();
                            break;
                        case OPde:
                            dt.ld = e.toReal();
                            break;
                        default:
                            asmerr("integer expected");
                    }
                    goto L2;
                }
                else if (auto se = e.isStringExp())
                {
                    len = se.numberOfCodeUnits();
                    q = cast(ббайт *)se.peekString().ptr;
                    if (!q)
                    {
                        qstart = cast(ббайт *)mem.xmalloc(len * se.sz);
                        se.writeTo(qstart, нет);
                        q = qstart;
                    }
                    goto L3;
                }
                goto default;
            }

            default:
                asmerr("constant инициализатор expected");          // constant инициализатор
                break;
        }

        asm_token();
        if (asmstate.tokValue != ТОК2.comma)
            break;
        asm_token();
    }

    CodeBuilder cdb;
    cdb.ctor();
    if (глоб2.парамы.symdebug)
        cdb.genlinnum(Srcpos.создай(asmstate.место.имяф, asmstate.место.номстр, asmstate.место.имяс));
    cdb.genasm(cast(сим*)bytes, cast(бцел)usBytes);
    code *c = cdb.finish();
    mem.xfree(bytes);

    asmstate.инструкция.regs |= /* mES| */ ALLREGS;
    asmstate.bReturnax = да;

    return c;
}

/**********************************
 * Parse and get integer Выражение.
 */

цел asm_getnum()
{
    цел v;
    dinteger_t i;

    switch (asmstate.tokValue)
    {
        case ТОК2.int32Literal:
            v = cast(d_int32)asmstate.tok.intvalue;
            break;

        case ТОК2.uns32Literal:
            v = cast(d_uns32)asmstate.tok.unsvalue;
            break;

        case ТОК2.идентификатор:
        {
            Выражение e = IdentifierExp.создай(asmstate.место, asmstate.tok.идент);
            Scope *sc = asmstate.sc.startCTFE();
            e = e.ВыражениеSemantic(sc);
            sc.endCTFE();
            e = e.ctfeInterpret();
            i = e.toInteger();
            v = cast(цел) i;
            if (v != i)
                asmerr("integer expected");
            break;
        }
        default:
            asmerr("integer expected");
            v = 0;              // no uninitialized values
            break;
    }
    asm_token();
    return v;
}

/*******************************
 */

проц asm_cond_exp(out OPND o1)
{
    //printf("asm_cond_exp()\n");
    asm_log_or_exp(o1);
    if (asmstate.tokValue == ТОК2.question)
    {
        asm_token();
        OPND o2;
        asm_cond_exp(o2);
        asm_chktok(ТОК2.colon,"colon");
        OPND o3;
        asm_cond_exp(o3);
        if (o1.disp)
            o1 = o2;
        else
            o1 = o3;
    }
}

/*******************************
 */

проц asm_log_or_exp(out OPND o1)
{
    asm_log_and_exp(o1);
    while (asmstate.tokValue == ТОК2.orOr)
    {
        asm_token();
        OPND o2;
        asm_log_and_exp(o2);
        if (asm_isint(o1) && asm_isint(o2))
            o1.disp = o1.disp || o2.disp;
        else
            asmerr("bad integral operand");
        o1.disp = 0;
        asm_merge_opnds(o1, o2);
    }
}

/*******************************
 */

проц asm_log_and_exp(out OPND o1)
{
    asm_inc_or_exp(o1);
    while (asmstate.tokValue == ТОК2.andAnd)
    {
        asm_token();
        OPND o2;
        asm_inc_or_exp(o2);
        if (asm_isint(o1) && asm_isint(o2))
            o1.disp = o1.disp && o2.disp;
        else
            asmerr("bad integral operand");
        o2.disp = 0;
        asm_merge_opnds(o1, o2);
    }
}

/*******************************
 */

проц asm_inc_or_exp(out OPND o1)
{
    asm_xor_exp(o1);
    while (asmstate.tokValue == ТОК2.or)
    {
        asm_token();
        OPND o2;
        asm_xor_exp(o2);
        if (asm_isint(o1) && asm_isint(o2))
            o1.disp |= o2.disp;
        else
            asmerr("bad integral operand");
        o2.disp = 0;
        asm_merge_opnds(o1, o2);
    }
}

/*******************************
 */

проц asm_xor_exp(out OPND o1)
{
    asm_and_exp(o1);
    while (asmstate.tokValue == ТОК2.xor)
    {
        asm_token();
        OPND o2;
        asm_and_exp(o2);
        if (asm_isint(o1) && asm_isint(o2))
            o1.disp ^= o2.disp;
        else
            asmerr("bad integral operand");
        o2.disp = 0;
        asm_merge_opnds(o1, o2);
    }
}

/*******************************
 */

проц asm_and_exp(out OPND o1)
{
    asm_equal_exp(o1);
    while (asmstate.tokValue == ТОК2.and)
    {
        asm_token();
        OPND o2;
        asm_equal_exp(o2);
        if (asm_isint(o1) && asm_isint(o2))
            o1.disp &= o2.disp;
        else
            asmerr("bad integral operand");
        o2.disp = 0;
        asm_merge_opnds(o1, o2);
    }
}

/*******************************
 */

проц asm_equal_exp(out OPND o1)
{
    asm_rel_exp(o1);
    while (1)
    {
        switch (asmstate.tokValue)
        {
            case ТОК2.equal:
            {
                asm_token();
                OPND o2;
                asm_rel_exp(o2);
                if (asm_isint(o1) && asm_isint(o2))
                    o1.disp = o1.disp == o2.disp;
                else
                    asmerr("bad integral operand");
                o2.disp = 0;
                asm_merge_opnds(o1, o2);
                break;
            }

            case ТОК2.notEqual:
            {
                asm_token();
                OPND o2;
                asm_rel_exp(o2);
                if (asm_isint(o1) && asm_isint(o2))
                    o1.disp = o1.disp != o2.disp;
                else
                    asmerr("bad integral operand");
                o2.disp = 0;
                asm_merge_opnds(o1, o2);
                break;
            }

            default:
                return;
        }
    }
}

/*******************************
 */

проц asm_rel_exp(out OPND o1)
{
    asm_shift_exp(o1);
    while (1)
    {
        switch (asmstate.tokValue)
        {
            case ТОК2.greaterThan:
            case ТОК2.greaterOrEqual:
            case ТОК2.lessThan:
            case ТОК2.lessOrEqual:
                auto tok_save = asmstate.tokValue;
                asm_token();
                OPND o2;
                asm_shift_exp(o2);
                if (asm_isint(o1) && asm_isint(o2))
                {
                    switch (tok_save)
                    {
                        case ТОК2.greaterThan:
                            o1.disp = o1.disp > o2.disp;
                            break;
                        case ТОК2.greaterOrEqual:
                            o1.disp = o1.disp >= o2.disp;
                            break;
                        case ТОК2.lessThan:
                            o1.disp = o1.disp < o2.disp;
                            break;
                        case ТОК2.lessOrEqual:
                            o1.disp = o1.disp <= o2.disp;
                            break;
                        default:
                            assert(0);
                    }
                }
                else
                    asmerr("bad integral operand");
                o2.disp = 0;
                asm_merge_opnds(o1, o2);
                break;

            default:
                return;
        }
    }
}

/*******************************
 */

проц asm_shift_exp(out OPND o1)
{
    asm_add_exp(o1);
    while (asmstate.tokValue == ТОК2.leftShift || asmstate.tokValue == ТОК2.rightShift || asmstate.tokValue == ТОК2.unsignedRightShift)
    {
        auto tk = asmstate.tokValue;
        asm_token();
        OPND o2;
        asm_add_exp(o2);
        if (asm_isint(o1) && asm_isint(o2))
        {
            if (tk == ТОК2.leftShift)
                o1.disp <<= o2.disp;
            else if (tk == ТОК2.unsignedRightShift)
                o1.disp = cast(бцел)o1.disp >> o2.disp;
            else
                o1.disp >>= o2.disp;
        }
        else
            asmerr("bad integral operand");
        o2.disp = 0;
        asm_merge_opnds(o1, o2);
    }
}

/*******************************
 */

проц asm_add_exp(out OPND o1)
{
    asm_mul_exp(o1);
    while (1)
    {
        switch (asmstate.tokValue)
        {
            case ТОК2.add:
            {
                asm_token();
                OPND o2;
                asm_mul_exp(o2);
                asm_merge_opnds(o1, o2);
                break;
            }

            case ТОК2.min:
            {
                asm_token();
                OPND o2;
                asm_mul_exp(o2);
                if (asm_isint(o1) && asm_isint(o2))
                {
                    o1.disp -= o2.disp;
                    o2.disp = 0;
                }
                else
                    o2.disp = - o2.disp;
                asm_merge_opnds(o1, o2);
                break;
            }

            default:
                return;
        }
    }
}

/*******************************
 */

проц asm_mul_exp(out OPND o1)
{
    //printf("+asm_mul_exp()\n");
    asm_br_exp(o1);
    while (1)
    {
        switch (asmstate.tokValue)
        {
            case ТОК2.mul:
            {
                asm_token();
                OPND o2;
                asm_br_exp(o2);
                debug (EXTRA_DEBUG) printf("Star  o1.isint=%d, o2.isint=%d, lbra_seen=%d\n",
                    asm_isint(o1), asm_isint(o2), asmstate.lbracketNestCount );
                if (asm_isNonZeroInt(o1) && asm_isNonZeroInt(o2))
                    o1.disp *= o2.disp;
                else if (asmstate.lbracketNestCount && o1.pregDisp1 && asm_isNonZeroInt(o2))
                {
                    o1.uchMultiplier = cast(бцел)o2.disp;
                    debug (EXTRA_DEBUG) printf("Multiplier: %d\n", o1.uchMultiplier);
                }
                else if (asmstate.lbracketNestCount && o2.pregDisp1 && asm_isNonZeroInt(o1))
                {
                    OPND popndTmp = o2;
                    o2 = o1;
                    o1 = popndTmp;
                    o1.uchMultiplier = cast(бцел)o2.disp;
                    debug (EXTRA_DEBUG) printf("Multiplier: %d\n",
                        o1.uchMultiplier);
                }
                else if (asm_isint(o1) && asm_isint(o2))
                    o1.disp *= o2.disp;
                else
                    asmerr("bad operand");
                o2.disp = 0;
                asm_merge_opnds(o1, o2);
                break;
            }

            case ТОК2.div:
            {
                asm_token();
                OPND o2;
                asm_br_exp(o2);
                if (asm_isint(o1) && asm_isint(o2))
                    o1.disp /= o2.disp;
                else
                    asmerr("bad integral operand");
                o2.disp = 0;
                asm_merge_opnds(o1, o2);
                break;
            }

            case ТОК2.mod:
            {
                asm_token();
                OPND o2;
                asm_br_exp(o2);
                if (asm_isint(o1) && asm_isint(o2))
                    o1.disp %= o2.disp;
                else
                    asmerr("bad integral operand");
                o2.disp = 0;
                asm_merge_opnds(o1, o2);
                break;
            }

            default:
                return;
        }
    }
}

/*******************************
 */

проц asm_br_exp(out OPND o1)
{
    //printf("asm_br_exp()\n");
    if (asmstate.tokValue != ТОК2.leftBracket)
        asm_una_exp(o1);
    while (1)
    {
        switch (asmstate.tokValue)
        {
            case ТОК2.leftBracket:
            {
                debug (EXTRA_DEBUG) printf("Saw a left bracket\n");
                asm_token();
                asmstate.lbracketNestCount++;
                OPND o2;
                asm_cond_exp(o2);
                asmstate.lbracketNestCount--;
                asm_chktok(ТОК2.rightBracket,"`]` expected instead of `%s`");
                debug (EXTRA_DEBUG) printf("Saw a right bracket\n");
                asm_merge_opnds(o1, o2);
                if (asmstate.tokValue == ТОК2.идентификатор)
                {
                    asm_una_exp(o2);
                    asm_merge_opnds(o1, o2);
                }
                break;
            }
            default:
                return;
        }
    }
}

/*******************************
 */

проц asm_una_exp(ref OPND o1)
{
    Тип ptype;
    ASM_JUMPTYPE ajt = ASM_JUMPTYPE_UNSPECIFIED;
    бул bPtr = нет;

    switch (cast(цел)asmstate.tokValue)
    {
        case ТОК2.add:
            asm_token();
            asm_una_exp(o1);
            break;

        case ТОК2.min:
            asm_token();
            asm_una_exp(o1);
            if (asm_isint(o1))
                o1.disp = -o1.disp;
            break;

        case ТОК2.not:
            asm_token();
            asm_una_exp(o1);
            if (asm_isint(o1))
                o1.disp = !o1.disp;
            break;

        case ТОК2.tilde:
            asm_token();
            asm_una_exp(o1);
            if (asm_isint(o1))
                o1.disp = ~o1.disp;
            break;

version (none)
{
        case ТОК2.leftParentheses:
            // stoken() is called directly here because we really
            // want the INT token to be an INT.
            stoken();
            if (type_specifier(&ptypeSpec)) /* if type_name     */
            {

                ptype = declar_abstract(ptypeSpec);
                            /* читай abstract_declarator  */
                fixdeclar(ptype);/* fix declarator               */
                type_free(ptypeSpec);/* the declar() function
                                    allocates the typespec again */
                chktok(ТОК2.rightParentheses,"`)` expected instead of `%s`");
                ptype.Tcount--;
                goto CAST_REF;
            }
            else
            {
                type_free(ptypeSpec);
                asm_cond_exp(o1);
                chktok(ТОК2.rightParentheses, "`)` expected instead of `%s`");
            }
            break;
}

        case ТОК2.идентификатор:
            // Check for смещение keyword
            if (asmstate.tok.идент == Id.смещение)
            {
                выведиОшибку(asmstate.место, "use offsetof instead of смещение");
                goto Loffset;
            }
            if (asmstate.tok.идент == Id.offsetof)
            {
            Loffset:
                asm_token();
                asm_cond_exp(o1);
                o1.bOffset = да;
            }
            else
                asm_primary_exp(o1);
            break;

        case ASMTKseg:
            asm_token();
            asm_cond_exp(o1);
            o1.bSeg = да;
            break;

        case ТОК2.int16:
            if (asmstate.ucItype != ITjump)
            {
                ptype = Тип.tint16;
                goto TYPE_REF;
            }
            ajt = ASM_JUMPTYPE_SHORT;
            asm_token();
            goto JUMP_REF2;

        case ASMTKnear:
            ajt = ASM_JUMPTYPE_NEAR;
            goto JUMP_REF;

        case ASMTKfar:
            ajt = ASM_JUMPTYPE_FAR;
JUMP_REF:
            asm_token();
            asm_chktok(cast(ТОК2) ASMTKptr, "ptr expected".ptr);
JUMP_REF2:
            asm_cond_exp(o1);
            o1.ajt = ajt;
            break;

        case ТОК2.void_:
            ptype = Тип.tvoid;
            goto TYPE_REF;

        case ТОК2.бул_:
            ptype = Тип.tбул;
            goto TYPE_REF;

        case ТОК2.char_:
            ptype = Тип.tchar;
            goto TYPE_REF;
        case ТОК2.wchar_:
            ptype = Тип.twchar;
            goto TYPE_REF;
        case ТОК2.dchar_:
            ptype = Тип.tdchar;
            goto TYPE_REF;

        case ТОК2.uns8:
            ptype = Тип.tuns8;
            goto TYPE_REF;
        case ТОК2.uns16:
            ptype = Тип.tuns16;
            goto TYPE_REF;
        case ТОК2.uns32:
            ptype = Тип.tuns32;
            goto TYPE_REF;
        case ТОК2.uns64 :
            ptype = Тип.tuns64;
            goto TYPE_REF;

        case ТОК2.int8:
            ptype = Тип.tint8;
            goto TYPE_REF;
        case ASMTKword:
            ptype = Тип.tint16;
            goto TYPE_REF;
        case ТОК2.int32:
        case ASMTKdword:
            ptype = Тип.tint32;
            goto TYPE_REF;
        case ТОК2.int64:
        case ASMTKqword:
            ptype = Тип.tint64;
            goto TYPE_REF;

        case ТОК2.float32:
            ptype = Тип.tfloat32;
            goto TYPE_REF;
        case ТОК2.float64:
            ptype = Тип.tfloat64;
            goto TYPE_REF;
        case ТОК2.float80:
            ptype = Тип.tfloat80;
            goto TYPE_REF;
TYPE_REF:
            bPtr = да;
            asm_token();
            // try: <BasicType>.<min/max etc>
            if (asmstate.tokValue == ТОК2.dot)
            {
                asm_token();
                if (asmstate.tokValue == ТОК2.идентификатор)
                {
                    TypeExp te = new TypeExp(asmstate.место, ptype);
                    DotIdExp did = new DotIdExp(asmstate.место, te, asmstate.tok.идент);
                    ДСимвол s;
                    tryВыражениеToOperand(did, o1, s);
                }
                else
                {
                    asmerr("property of basic тип `%s` expected", ptype.вТкст0());
                }
                asm_token();
                break;
            }
            // else: ptr <BasicType>
            asm_chktok(cast(ТОК2) ASMTKptr, "ptr expected");
            asm_cond_exp(o1);
            o1.ptype = ptype;
            o1.bPtr = bPtr;
            break;

        default:
            asm_primary_exp(o1);
            break;
    }
}

/*******************************
 */

проц asm_primary_exp(out OPND o1)
{
    ДСимвол s;
    ДСимвол scopesym;

    const REG* regp;

    switch (asmstate.tokValue)
    {
        case ТОК2.dollar:
            o1.s = asmstate.psDollar;
            asm_token();
            break;

        case ТОК2.this_:
        case ТОК2.идентификатор:
            regp = asm_reg_lookup(asmstate.tok.идент.вТкст());
            if (regp != null)
            {
                asm_token();
                // see if it is segment override (like SS:)
                if (!asmstate.lbracketNestCount &&
                        (regp.ty & _seg) &&
                        asmstate.tokValue == ТОК2.colon)
                {
                    o1.segreg = regp;
                    asm_token();
                    OPND o2;
                    asm_cond_exp(o2);
                    if (o2.s && o2.s.isLabel())
                        o2.segreg = null; // The segment register was specified explicitly.
                    asm_merge_opnds(o1, o2);
                }
                else if (asmstate.lbracketNestCount)
                {
                    // should be a register
                    if (o1.pregDisp1)
                        asmerr("bad operand");
                    else
                        o1.pregDisp1 = regp;
                }
                else
                {
                    if (o1.base == null)
                        o1.base = regp;
                    else
                        asmerr("bad operand");
                }
                break;
            }
            // If floating point instruction and ид is a floating register
            else if (asmstate.ucItype == ITfloat &&
                     asm_is_fpreg(asmstate.tok.идент.вТкст()))
            {
                asm_token();
                if (asmstate.tokValue == ТОК2.leftParentheses)
                {
                    asm_token();
                    if (asmstate.tokValue == ТОК2.int32Literal)
                    {
                        бцел n = cast(бцел)asmstate.tok.unsvalue;
                        if (n > 7)
                            asmerr("bad operand");
                        else
                            o1.base = &(aregFp[n]);
                    }
                    asm_chktok(ТОК2.int32Literal, "integer expected");
                    asm_chktok(ТОК2.rightParentheses, "`)` expected instead of `%s`");
                }
                else
                    o1.base = &regFp;
            }
            else
            {
                s = null;
                if (asmstate.sc.func.labtab)
                    s = asmstate.sc.func.labtab.lookup(asmstate.tok.идент);
                if (!s)
                    s = asmstate.sc.search(Место.initial, asmstate.tok.идент, &scopesym);
                if (!s)
                {
                    // Assume it is a label, and define that label
                    s = asmstate.sc.func.searchLabel(asmstate.tok.идент);
                }
                if (auto label = s.isLabel())
                {
                    o1.segreg = &regtab[25]; // Make it use CS as a base for a label
                    label.iasm = да;
                }
                Идентификатор2 ид = asmstate.tok.идент;
                asm_token();
                if (asmstate.tokValue == ТОК2.dot)
                {
                    Выражение e = IdentifierExp.создай(asmstate.место, ид);
                    while (1)
                    {
                        asm_token();
                        if (asmstate.tokValue == ТОК2.идентификатор)
                        {
                            e = DotIdExp.создай(asmstate.место, e, asmstate.tok.идент);
                            asm_token();
                            if (asmstate.tokValue != ТОК2.dot)
                                break;
                        }
                        else
                        {
                            asmerr("идентификатор expected");
                            break;
                        }
                    }
                    ТОК2 e2o = tryВыражениеToOperand(e, o1, s);
                    if (e2o == ТОК2.const_)
                        goto Lpost;
                }

                asm_merge_symbol(o1,s);

                /* This attempts to answer the question: is
                 *  сим[8] foo;
                 * of size 1 or size 8? Presume it is 8 if foo
                 * is the last token of the operand.
                 */
                if (o1.ptype && asmstate.tokValue != ТОК2.comma && asmstate.tokValue != ТОК2.endOfFile)
                {
                    for (;
                         o1.ptype.ty == Tsarray;
                         o1.ptype = o1.ptype.nextOf())
                    {
                    }
                }

            Lpost:
                // for []
                //if (asmstate.tokValue == ТОК2.leftBracket)
                        //o1 = asm_prim_post(o1);
                return;
            }
            break;

        case ТОК2.int32Literal:
            o1.disp = cast(d_int32)asmstate.tok.intvalue;
            asm_token();
            break;

        case ТОК2.uns32Literal:
            o1.disp = cast(d_uns32)asmstate.tok.unsvalue;
            asm_token();
            break;

        case ТОК2.int64Literal:
        case ТОК2.uns64Literal:
            o1.disp = asmstate.tok.intvalue;
            asm_token();
            break;

        case ТОК2.float32Literal:
            o1.vreal = asmstate.tok.floatvalue;
            o1.ptype = Тип.tfloat32;
            asm_token();
            break;

        case ТОК2.float64Literal:
            o1.vreal = asmstate.tok.floatvalue;
            o1.ptype = Тип.tfloat64;
            asm_token();
            break;

        case ТОК2.float80Literal:
            o1.vreal = asmstate.tok.floatvalue;
            o1.ptype = Тип.tfloat80;
            asm_token();
            break;

        case cast(ТОК2)ASMTKlocalsize:
            o1.s = asmstate.psLocalsize;
            o1.ptype = Тип.tint32;
            asm_token();
            break;

         default:
            asmerr("Выражение expected not `%s`", asmstate.tok ? asmstate.tok.вТкст0() : ";");
            break;
    }
}

/**
 * Using an Выражение, try to set an ASM operand as a constant or as an access
 * to a higher уровень variable.
 *
 * Параметры:
 *      e =     Input. The Выражение to evaluate. This can be an arbitrarily complex Выражение
 *              but it must either represent a constant after CTFE or give a higher уровень variable.
 *      o1 =    Output. The ASM operand to define from `e`.
 *      s =     Output. The symbol when `e` represents a variable.
 *
 * Возвращает:
 *      `ТОК2.variable` if `s` was set to a variable,
 *      `ТОК2.const_` if `e` was evaluated to a valid constant,
 *      `ТОК2.error` otherwise.
 */
ТОК2 tryВыражениеToOperand(Выражение e, ref OPND o1, ref ДСимвол s)
{
    Scope *sc = asmstate.sc.startCTFE();
    e = e.ВыражениеSemantic(sc);
    sc.endCTFE();
    e = e.ctfeInterpret();
    if (e.op == ТОК2.variable)
    {
        VarExp v = cast(VarExp) e;
        s = v.var;
        return ТОК2.variable;
    }
    if (e.isConst())
    {
        if (e.тип.isintegral())
        {
            o1.disp = e.toInteger();
            return ТОК2.const_;
        }
        if (e.тип.isreal())
        {
            o1.vreal = e.toReal();
            o1.ptype = e.тип;
            return ТОК2.const_;
        }
    }
    asmerr("bad тип/size of operands `%s`", e.вТкст0());
    return ТОК2.error;
}

/**********************
 * If c is a power of 2, return that power else -1.
 */

private цел ispow2(бцел c)
{
    цел i;

    if (c == 0 || (c & (c - 1)))
        i = -1;
    else
        for (i = 0; c >>= 1; ++i)
        { }
    return i;
}
