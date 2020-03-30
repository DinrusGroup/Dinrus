/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Target Instruction Enum Values and Descriptors                             *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

#ifdef GET_INSTRINFO_ENUM
#undef GET_INSTRINFO_ENUM
namespace llvm {

namespace MSP430 {
  enum {
    PHI	= 0,
    INLINEASM	= 1,
    INLINEASM_BR	= 2,
    CFI_INSTRUCTION	= 3,
    EH_LABEL	= 4,
    GC_LABEL	= 5,
    ANNOTATION_LABEL	= 6,
    KILL	= 7,
    EXTRACT_SUBREG	= 8,
    INSERT_SUBREG	= 9,
    IMPLICIT_DEF	= 10,
    SUBREG_TO_REG	= 11,
    COPY_TO_REGCLASS	= 12,
    DBG_VALUE	= 13,
    DBG_LABEL	= 14,
    REG_SEQUENCE	= 15,
    COPY	= 16,
    BUNDLE	= 17,
    LIFETIME_START	= 18,
    LIFETIME_END	= 19,
    STACKMAP	= 20,
    FENTRY_CALL	= 21,
    PATCHPOINT	= 22,
    LOAD_STACK_GUARD	= 23,
    STATEPOINT	= 24,
    LOCAL_ESCAPE	= 25,
    FAULTING_OP	= 26,
    PATCHABLE_OP	= 27,
    PATCHABLE_FUNCTION_ENTER	= 28,
    PATCHABLE_RET	= 29,
    PATCHABLE_FUNCTION_EXIT	= 30,
    PATCHABLE_TAIL_CALL	= 31,
    PATCHABLE_EVENT_CALL	= 32,
    PATCHABLE_TYPED_EVENT_CALL	= 33,
    ICALL_BRANCH_FUNNEL	= 34,
    G_ADD	= 35,
    G_SUB	= 36,
    G_MUL	= 37,
    G_SDIV	= 38,
    G_UDIV	= 39,
    G_SREM	= 40,
    G_UREM	= 41,
    G_AND	= 42,
    G_OR	= 43,
    G_XOR	= 44,
    G_IMPLICIT_DEF	= 45,
    G_PHI	= 46,
    G_FRAME_INDEX	= 47,
    G_GLOBAL_VALUE	= 48,
    G_EXTRACT	= 49,
    G_UNMERGE_VALUES	= 50,
    G_INSERT	= 51,
    G_MERGE_VALUES	= 52,
    G_BUILD_VECTOR	= 53,
    G_BUILD_VECTOR_TRUNC	= 54,
    G_CONCAT_VECTORS	= 55,
    G_PTRTOINT	= 56,
    G_INTTOPTR	= 57,
    G_BITCAST	= 58,
    G_INTRINSIC_TRUNC	= 59,
    G_INTRINSIC_ROUND	= 60,
    G_LOAD	= 61,
    G_SEXTLOAD	= 62,
    G_ZEXTLOAD	= 63,
    G_STORE	= 64,
    G_ATOMIC_CMPXCHG_WITH_SUCCESS	= 65,
    G_ATOMIC_CMPXCHG	= 66,
    G_ATOMICRMW_XCHG	= 67,
    G_ATOMICRMW_ADD	= 68,
    G_ATOMICRMW_SUB	= 69,
    G_ATOMICRMW_AND	= 70,
    G_ATOMICRMW_NAND	= 71,
    G_ATOMICRMW_OR	= 72,
    G_ATOMICRMW_XOR	= 73,
    G_ATOMICRMW_MAX	= 74,
    G_ATOMICRMW_MIN	= 75,
    G_ATOMICRMW_UMAX	= 76,
    G_ATOMICRMW_UMIN	= 77,
    G_FENCE	= 78,
    G_BRCOND	= 79,
    G_BRINDIRECT	= 80,
    G_INTRINSIC	= 81,
    G_INTRINSIC_W_SIDE_EFFECTS	= 82,
    G_ANYEXT	= 83,
    G_TRUNC	= 84,
    G_CONSTANT	= 85,
    G_FCONSTANT	= 86,
    G_VASTART	= 87,
    G_VAARG	= 88,
    G_SEXT	= 89,
    G_ZEXT	= 90,
    G_SHL	= 91,
    G_LSHR	= 92,
    G_ASHR	= 93,
    G_ICMP	= 94,
    G_FCMP	= 95,
    G_SELECT	= 96,
    G_UADDO	= 97,
    G_UADDE	= 98,
    G_USUBO	= 99,
    G_USUBE	= 100,
    G_SADDO	= 101,
    G_SADDE	= 102,
    G_SSUBO	= 103,
    G_SSUBE	= 104,
    G_UMULO	= 105,
    G_SMULO	= 106,
    G_UMULH	= 107,
    G_SMULH	= 108,
    G_FADD	= 109,
    G_FSUB	= 110,
    G_FMUL	= 111,
    G_FMA	= 112,
    G_FDIV	= 113,
    G_FREM	= 114,
    G_FPOW	= 115,
    G_FEXP	= 116,
    G_FEXP2	= 117,
    G_FLOG	= 118,
    G_FLOG2	= 119,
    G_FLOG10	= 120,
    G_FNEG	= 121,
    G_FPEXT	= 122,
    G_FPTRUNC	= 123,
    G_FPTOSI	= 124,
    G_FPTOUI	= 125,
    G_SITOFP	= 126,
    G_UITOFP	= 127,
    G_FABS	= 128,
    G_FCOPYSIGN	= 129,
    G_FCANONICALIZE	= 130,
    G_FMINNUM	= 131,
    G_FMAXNUM	= 132,
    G_FMINNUM_IEEE	= 133,
    G_FMAXNUM_IEEE	= 134,
    G_FMINIMUM	= 135,
    G_FMAXIMUM	= 136,
    G_GEP	= 137,
    G_PTR_MASK	= 138,
    G_SMIN	= 139,
    G_SMAX	= 140,
    G_UMIN	= 141,
    G_UMAX	= 142,
    G_BR	= 143,
    G_BRJT	= 144,
    G_INSERT_VECTOR_ELT	= 145,
    G_EXTRACT_VECTOR_ELT	= 146,
    G_SHUFFLE_VECTOR	= 147,
    G_CTTZ	= 148,
    G_CTTZ_ZERO_UNDEF	= 149,
    G_CTLZ	= 150,
    G_CTLZ_ZERO_UNDEF	= 151,
    G_CTPOP	= 152,
    G_BSWAP	= 153,
    G_FCEIL	= 154,
    G_FCOS	= 155,
    G_FSIN	= 156,
    G_FSQRT	= 157,
    G_FFLOOR	= 158,
    G_FRINT	= 159,
    G_FNEARBYINT	= 160,
    G_ADDRSPACE_CAST	= 161,
    G_BLOCK_ADDR	= 162,
    G_JUMP_TABLE	= 163,
    ADD16mc	= 164,
    ADD16mi	= 165,
    ADD16mm	= 166,
    ADD16mn	= 167,
    ADD16mp	= 168,
    ADD16mr	= 169,
    ADD16rc	= 170,
    ADD16ri	= 171,
    ADD16rm	= 172,
    ADD16rn	= 173,
    ADD16rp	= 174,
    ADD16rr	= 175,
    ADD8mc	= 176,
    ADD8mi	= 177,
    ADD8mm	= 178,
    ADD8mn	= 179,
    ADD8mp	= 180,
    ADD8mr	= 181,
    ADD8rc	= 182,
    ADD8ri	= 183,
    ADD8rm	= 184,
    ADD8rn	= 185,
    ADD8rp	= 186,
    ADD8rr	= 187,
    ADDC16mc	= 188,
    ADDC16mi	= 189,
    ADDC16mm	= 190,
    ADDC16mn	= 191,
    ADDC16mp	= 192,
    ADDC16mr	= 193,
    ADDC16rc	= 194,
    ADDC16ri	= 195,
    ADDC16rm	= 196,
    ADDC16rn	= 197,
    ADDC16rp	= 198,
    ADDC16rr	= 199,
    ADDC8mc	= 200,
    ADDC8mi	= 201,
    ADDC8mm	= 202,
    ADDC8mn	= 203,
    ADDC8mp	= 204,
    ADDC8mr	= 205,
    ADDC8rc	= 206,
    ADDC8ri	= 207,
    ADDC8rm	= 208,
    ADDC8rn	= 209,
    ADDC8rp	= 210,
    ADDC8rr	= 211,
    ADDframe	= 212,
    ADJCALLSTACKDOWN	= 213,
    ADJCALLSTACKUP	= 214,
    AND16mc	= 215,
    AND16mi	= 216,
    AND16mm	= 217,
    AND16mn	= 218,
    AND16mp	= 219,
    AND16mr	= 220,
    AND16rc	= 221,
    AND16ri	= 222,
    AND16rm	= 223,
    AND16rn	= 224,
    AND16rp	= 225,
    AND16rr	= 226,
    AND8mc	= 227,
    AND8mi	= 228,
    AND8mm	= 229,
    AND8mn	= 230,
    AND8mp	= 231,
    AND8mr	= 232,
    AND8rc	= 233,
    AND8ri	= 234,
    AND8rm	= 235,
    AND8rn	= 236,
    AND8rp	= 237,
    AND8rr	= 238,
    BIC16mc	= 239,
    BIC16mi	= 240,
    BIC16mm	= 241,
    BIC16mn	= 242,
    BIC16mp	= 243,
    BIC16mr	= 244,
    BIC16rc	= 245,
    BIC16ri	= 246,
    BIC16rm	= 247,
    BIC16rn	= 248,
    BIC16rp	= 249,
    BIC16rr	= 250,
    BIC8mc	= 251,
    BIC8mi	= 252,
    BIC8mm	= 253,
    BIC8mn	= 254,
    BIC8mp	= 255,
    BIC8mr	= 256,
    BIC8rc	= 257,
    BIC8ri	= 258,
    BIC8rm	= 259,
    BIC8rn	= 260,
    BIC8rp	= 261,
    BIC8rr	= 262,
    BIS16mc	= 263,
    BIS16mi	= 264,
    BIS16mm	= 265,
    BIS16mn	= 266,
    BIS16mp	= 267,
    BIS16mr	= 268,
    BIS16rc	= 269,
    BIS16ri	= 270,
    BIS16rm	= 271,
    BIS16rn	= 272,
    BIS16rp	= 273,
    BIS16rr	= 274,
    BIS8mc	= 275,
    BIS8mi	= 276,
    BIS8mm	= 277,
    BIS8mn	= 278,
    BIS8mp	= 279,
    BIS8mr	= 280,
    BIS8rc	= 281,
    BIS8ri	= 282,
    BIS8rm	= 283,
    BIS8rn	= 284,
    BIS8rp	= 285,
    BIS8rr	= 286,
    BIT16mc	= 287,
    BIT16mi	= 288,
    BIT16mm	= 289,
    BIT16mn	= 290,
    BIT16mp	= 291,
    BIT16mr	= 292,
    BIT16rc	= 293,
    BIT16ri	= 294,
    BIT16rm	= 295,
    BIT16rn	= 296,
    BIT16rp	= 297,
    BIT16rr	= 298,
    BIT8mc	= 299,
    BIT8mi	= 300,
    BIT8mm	= 301,
    BIT8mn	= 302,
    BIT8mp	= 303,
    BIT8mr	= 304,
    BIT8rc	= 305,
    BIT8ri	= 306,
    BIT8rm	= 307,
    BIT8rn	= 308,
    BIT8rp	= 309,
    BIT8rr	= 310,
    Bi	= 311,
    Bm	= 312,
    Br	= 313,
    CALLi	= 314,
    CALLm	= 315,
    CALLn	= 316,
    CALLp	= 317,
    CALLr	= 318,
    CMP16mc	= 319,
    CMP16mi	= 320,
    CMP16mm	= 321,
    CMP16mn	= 322,
    CMP16mp	= 323,
    CMP16mr	= 324,
    CMP16rc	= 325,
    CMP16ri	= 326,
    CMP16rm	= 327,
    CMP16rn	= 328,
    CMP16rp	= 329,
    CMP16rr	= 330,
    CMP8mc	= 331,
    CMP8mi	= 332,
    CMP8mm	= 333,
    CMP8mn	= 334,
    CMP8mp	= 335,
    CMP8mr	= 336,
    CMP8rc	= 337,
    CMP8ri	= 338,
    CMP8rm	= 339,
    CMP8rn	= 340,
    CMP8rp	= 341,
    CMP8rr	= 342,
    DADD16mc	= 343,
    DADD16mi	= 344,
    DADD16mm	= 345,
    DADD16mn	= 346,
    DADD16mp	= 347,
    DADD16mr	= 348,
    DADD16rc	= 349,
    DADD16ri	= 350,
    DADD16rm	= 351,
    DADD16rn	= 352,
    DADD16rp	= 353,
    DADD16rr	= 354,
    DADD8mc	= 355,
    DADD8mi	= 356,
    DADD8mm	= 357,
    DADD8mn	= 358,
    DADD8mp	= 359,
    DADD8mr	= 360,
    DADD8rc	= 361,
    DADD8ri	= 362,
    DADD8rm	= 363,
    DADD8rn	= 364,
    DADD8rp	= 365,
    DADD8rr	= 366,
    JCC	= 367,
    JMP	= 368,
    MOV16mc	= 369,
    MOV16mi	= 370,
    MOV16mm	= 371,
    MOV16mn	= 372,
    MOV16mr	= 373,
    MOV16rc	= 374,
    MOV16ri	= 375,
    MOV16rm	= 376,
    MOV16rn	= 377,
    MOV16rp	= 378,
    MOV16rr	= 379,
    MOV8mc	= 380,
    MOV8mi	= 381,
    MOV8mm	= 382,
    MOV8mn	= 383,
    MOV8mr	= 384,
    MOV8rc	= 385,
    MOV8ri	= 386,
    MOV8rm	= 387,
    MOV8rn	= 388,
    MOV8rp	= 389,
    MOV8rr	= 390,
    MOVZX16rm8	= 391,
    MOVZX16rr8	= 392,
    POP16r	= 393,
    PUSH16c	= 394,
    PUSH16i	= 395,
    PUSH16r	= 396,
    PUSH8r	= 397,
    RET	= 398,
    RETI	= 399,
    RRA16m	= 400,
    RRA16n	= 401,
    RRA16p	= 402,
    RRA16r	= 403,
    RRA8m	= 404,
    RRA8n	= 405,
    RRA8p	= 406,
    RRA8r	= 407,
    RRC16m	= 408,
    RRC16n	= 409,
    RRC16p	= 410,
    RRC16r	= 411,
    RRC8m	= 412,
    RRC8n	= 413,
    RRC8p	= 414,
    RRC8r	= 415,
    Rrcl16	= 416,
    Rrcl8	= 417,
    SEXT16m	= 418,
    SEXT16n	= 419,
    SEXT16p	= 420,
    SEXT16r	= 421,
    SUB16mc	= 422,
    SUB16mi	= 423,
    SUB16mm	= 424,
    SUB16mn	= 425,
    SUB16mp	= 426,
    SUB16mr	= 427,
    SUB16rc	= 428,
    SUB16ri	= 429,
    SUB16rm	= 430,
    SUB16rn	= 431,
    SUB16rp	= 432,
    SUB16rr	= 433,
    SUB8mc	= 434,
    SUB8mi	= 435,
    SUB8mm	= 436,
    SUB8mn	= 437,
    SUB8mp	= 438,
    SUB8mr	= 439,
    SUB8rc	= 440,
    SUB8ri	= 441,
    SUB8rm	= 442,
    SUB8rn	= 443,
    SUB8rp	= 444,
    SUB8rr	= 445,
    SUBC16mc	= 446,
    SUBC16mi	= 447,
    SUBC16mm	= 448,
    SUBC16mn	= 449,
    SUBC16mp	= 450,
    SUBC16mr	= 451,
    SUBC16rc	= 452,
    SUBC16ri	= 453,
    SUBC16rm	= 454,
    SUBC16rn	= 455,
    SUBC16rp	= 456,
    SUBC16rr	= 457,
    SUBC8mc	= 458,
    SUBC8mi	= 459,
    SUBC8mm	= 460,
    SUBC8mn	= 461,
    SUBC8mp	= 462,
    SUBC8mr	= 463,
    SUBC8rc	= 464,
    SUBC8ri	= 465,
    SUBC8rm	= 466,
    SUBC8rn	= 467,
    SUBC8rp	= 468,
    SUBC8rr	= 469,
    SWPB16m	= 470,
    SWPB16n	= 471,
    SWPB16p	= 472,
    SWPB16r	= 473,
    Select16	= 474,
    Select8	= 475,
    Shl16	= 476,
    Shl8	= 477,
    Sra16	= 478,
    Sra8	= 479,
    Srl16	= 480,
    Srl8	= 481,
    XOR16mc	= 482,
    XOR16mi	= 483,
    XOR16mm	= 484,
    XOR16mn	= 485,
    XOR16mp	= 486,
    XOR16mr	= 487,
    XOR16rc	= 488,
    XOR16ri	= 489,
    XOR16rm	= 490,
    XOR16rn	= 491,
    XOR16rp	= 492,
    XOR16rr	= 493,
    XOR8mc	= 494,
    XOR8mi	= 495,
    XOR8mm	= 496,
    XOR8mn	= 497,
    XOR8mp	= 498,
    XOR8mr	= 499,
    XOR8rc	= 500,
    XOR8ri	= 501,
    XOR8rm	= 502,
    XOR8rn	= 503,
    XOR8rp	= 504,
    XOR8rr	= 505,
    ZEXT16r	= 506,
    INSTRUCTION_LIST_END = 507
  };

} // end MSP430 namespace
} // end llvm namespace
#endif // GET_INSTRINFO_ENUM

#ifdef GET_INSTRINFO_SCHED_ENUM
#undef GET_INSTRINFO_SCHED_ENUM
namespace llvm {

namespace MSP430 {
namespace Sched {
  enum {
    NoInstrModel	= 0,
    SCHED_LIST_END = 1
  };
} // end Sched namespace
} // end MSP430 namespace
} // end llvm namespace
#endif // GET_INSTRINFO_SCHED_ENUM

#ifdef GET_INSTRINFO_MC_DESC
#undef GET_INSTRINFO_MC_DESC
namespace llvm {

static const MCPhysReg ImplicitList1[] = { MSP430::SR, 0 };
static const MCPhysReg ImplicitList2[] = { MSP430::SP, 0 };
static const MCPhysReg ImplicitList3[] = { MSP430::SP, MSP430::SR, 0 };
static const MCPhysReg ImplicitList4[] = { MSP430::R11, MSP430::R12, MSP430::R13, MSP430::R14, MSP430::R15, MSP430::SR, 0 };

static const MCOperandInfo OperandInfo2[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo3[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo4[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo5[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo6[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo7[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo8[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo9[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo10[] = { { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo11[] = { { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo12[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo13[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo14[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo15[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo16[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo17[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, };
static const MCOperandInfo OperandInfo18[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo19[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo20[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_2, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo21[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo22[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo23[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, };
static const MCOperandInfo OperandInfo24[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, };
static const MCOperandInfo OperandInfo25[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, };
static const MCOperandInfo OperandInfo26[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, };
static const MCOperandInfo OperandInfo27[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo28[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, };
static const MCOperandInfo OperandInfo29[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_2, 0 }, };
static const MCOperandInfo OperandInfo30[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_2, 0 }, };
static const MCOperandInfo OperandInfo31[] = { { -1, 0, MCOI::OPERAND_GENERIC_0, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_1, 0 }, { -1, 0, MCOI::OPERAND_GENERIC_2, 0 }, };
static const MCOperandInfo OperandInfo32[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo33[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo34[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo35[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo36[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo37[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo38[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo39[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo40[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo41[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo42[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo43[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo44[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo45[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo46[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo47[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo48[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo49[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo50[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo51[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo52[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo53[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo54[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo55[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo56[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo57[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo58[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo59[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo60[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo61[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo62[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo63[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo64[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo65[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo66[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo67[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo68[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo69[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo70[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo71[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo72[] = { { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo73[] = { { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { MSP430::GR8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };

extern const MCInstrDesc MSP430Insts[] = {
  { 0,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #0 = PHI
  { 1,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1 = INLINEASM
  { 2,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2 = INLINEASM_BR
  { 3,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #3 = CFI_INSTRUCTION
  { 4,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #4 = EH_LABEL
  { 5,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #5 = GC_LABEL
  { 6,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #6 = ANNOTATION_LABEL
  { 7,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #7 = KILL
  { 8,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo4, -1 ,nullptr },  // Inst #8 = EXTRACT_SUBREG
  { 9,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo5, -1 ,nullptr },  // Inst #9 = INSERT_SUBREG
  { 10,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #10 = IMPLICIT_DEF
  { 11,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo6, -1 ,nullptr },  // Inst #11 = SUBREG_TO_REG
  { 12,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo4, -1 ,nullptr },  // Inst #12 = COPY_TO_REGCLASS
  { 13,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #13 = DBG_VALUE
  { 14,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #14 = DBG_LABEL
  { 15,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #15 = REG_SEQUENCE
  { 16,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #16 = COPY
  { 17,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #17 = BUNDLE
  { 18,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #18 = LIFETIME_START
  { 19,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #19 = LIFETIME_END
  { 20,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo8, -1 ,nullptr },  // Inst #20 = STACKMAP
  { 21,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #21 = FENTRY_CALL
  { 22,	6,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo9, -1 ,nullptr },  // Inst #22 = PATCHPOINT
  { 23,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo10, -1 ,nullptr },  // Inst #23 = LOAD_STACK_GUARD
  { 24,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #24 = STATEPOINT
  { 25,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo11, -1 ,nullptr },  // Inst #25 = LOCAL_ESCAPE
  { 26,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #26 = FAULTING_OP
  { 27,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #27 = PATCHABLE_OP
  { 28,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #28 = PATCHABLE_FUNCTION_ENTER
  { 29,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #29 = PATCHABLE_RET
  { 30,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #30 = PATCHABLE_FUNCTION_EXIT
  { 31,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #31 = PATCHABLE_TAIL_CALL
  { 32,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo11, -1 ,nullptr },  // Inst #32 = PATCHABLE_EVENT_CALL
  { 33,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo12, -1 ,nullptr },  // Inst #33 = PATCHABLE_TYPED_EVENT_CALL
  { 34,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #34 = ICALL_BRANCH_FUNNEL
  { 35,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #35 = G_ADD
  { 36,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #36 = G_SUB
  { 37,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #37 = G_MUL
  { 38,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #38 = G_SDIV
  { 39,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #39 = G_UDIV
  { 40,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #40 = G_SREM
  { 41,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #41 = G_UREM
  { 42,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #42 = G_AND
  { 43,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #43 = G_OR
  { 44,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #44 = G_XOR
  { 45,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #45 = G_IMPLICIT_DEF
  { 46,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #46 = G_PHI
  { 47,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #47 = G_FRAME_INDEX
  { 48,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #48 = G_GLOBAL_VALUE
  { 49,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo16, -1 ,nullptr },  // Inst #49 = G_EXTRACT
  { 50,	2,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #50 = G_UNMERGE_VALUES
  { 51,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo18, -1 ,nullptr },  // Inst #51 = G_INSERT
  { 52,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #52 = G_MERGE_VALUES
  { 53,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #53 = G_BUILD_VECTOR
  { 54,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #54 = G_BUILD_VECTOR_TRUNC
  { 55,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #55 = G_CONCAT_VECTORS
  { 56,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #56 = G_PTRTOINT
  { 57,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #57 = G_INTTOPTR
  { 58,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #58 = G_BITCAST
  { 59,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #59 = G_INTRINSIC_TRUNC
  { 60,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #60 = G_INTRINSIC_ROUND
  { 61,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #61 = G_LOAD
  { 62,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #62 = G_SEXTLOAD
  { 63,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #63 = G_ZEXTLOAD
  { 64,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #64 = G_STORE
  { 65,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo20, -1 ,nullptr },  // Inst #65 = G_ATOMIC_CMPXCHG_WITH_SUCCESS
  { 66,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #66 = G_ATOMIC_CMPXCHG
  { 67,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #67 = G_ATOMICRMW_XCHG
  { 68,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #68 = G_ATOMICRMW_ADD
  { 69,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #69 = G_ATOMICRMW_SUB
  { 70,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #70 = G_ATOMICRMW_AND
  { 71,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #71 = G_ATOMICRMW_NAND
  { 72,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #72 = G_ATOMICRMW_OR
  { 73,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #73 = G_ATOMICRMW_XOR
  { 74,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #74 = G_ATOMICRMW_MAX
  { 75,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #75 = G_ATOMICRMW_MIN
  { 76,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #76 = G_ATOMICRMW_UMAX
  { 77,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #77 = G_ATOMICRMW_UMIN
  { 78,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo8, -1 ,nullptr },  // Inst #78 = G_FENCE
  { 79,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #79 = G_BRCOND
  { 80,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #80 = G_BRINDIRECT
  { 81,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #81 = G_INTRINSIC
  { 82,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #82 = G_INTRINSIC_W_SIDE_EFFECTS
  { 83,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #83 = G_ANYEXT
  { 84,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #84 = G_TRUNC
  { 85,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #85 = G_CONSTANT
  { 86,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #86 = G_FCONSTANT
  { 87,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #87 = G_VASTART
  { 88,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo16, -1 ,nullptr },  // Inst #88 = G_VAARG
  { 89,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #89 = G_SEXT
  { 90,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #90 = G_ZEXT
  { 91,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #91 = G_SHL
  { 92,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #92 = G_LSHR
  { 93,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #93 = G_ASHR
  { 94,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo24, -1 ,nullptr },  // Inst #94 = G_ICMP
  { 95,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo24, -1 ,nullptr },  // Inst #95 = G_FCMP
  { 96,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #96 = G_SELECT
  { 97,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #97 = G_UADDO
  { 98,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #98 = G_UADDE
  { 99,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #99 = G_USUBO
  { 100,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #100 = G_USUBE
  { 101,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #101 = G_SADDO
  { 102,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #102 = G_SADDE
  { 103,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #103 = G_SSUBO
  { 104,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #104 = G_SSUBE
  { 105,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #105 = G_UMULO
  { 106,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #106 = G_SMULO
  { 107,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #107 = G_UMULH
  { 108,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #108 = G_SMULH
  { 109,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #109 = G_FADD
  { 110,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #110 = G_FSUB
  { 111,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #111 = G_FMUL
  { 112,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo26, -1 ,nullptr },  // Inst #112 = G_FMA
  { 113,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #113 = G_FDIV
  { 114,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #114 = G_FREM
  { 115,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #115 = G_FPOW
  { 116,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #116 = G_FEXP
  { 117,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #117 = G_FEXP2
  { 118,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #118 = G_FLOG
  { 119,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #119 = G_FLOG2
  { 120,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #120 = G_FLOG10
  { 121,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #121 = G_FNEG
  { 122,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #122 = G_FPEXT
  { 123,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #123 = G_FPTRUNC
  { 124,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #124 = G_FPTOSI
  { 125,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #125 = G_FPTOUI
  { 126,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #126 = G_SITOFP
  { 127,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #127 = G_UITOFP
  { 128,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #128 = G_FABS
  { 129,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #129 = G_FCOPYSIGN
  { 130,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #130 = G_FCANONICALIZE
  { 131,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #131 = G_FMINNUM
  { 132,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #132 = G_FMAXNUM
  { 133,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #133 = G_FMINNUM_IEEE
  { 134,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #134 = G_FMAXNUM_IEEE
  { 135,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #135 = G_FMINIMUM
  { 136,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #136 = G_FMAXIMUM
  { 137,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #137 = G_GEP
  { 138,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo27, -1 ,nullptr },  // Inst #138 = G_PTR_MASK
  { 139,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #139 = G_SMIN
  { 140,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #140 = G_SMAX
  { 141,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #141 = G_UMIN
  { 142,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #142 = G_UMAX
  { 143,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #143 = G_BR
  { 144,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo28, -1 ,nullptr },  // Inst #144 = G_BRJT
  { 145,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo29, -1 ,nullptr },  // Inst #145 = G_INSERT_VECTOR_ELT
  { 146,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo30, -1 ,nullptr },  // Inst #146 = G_EXTRACT_VECTOR_ELT
  { 147,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo31, -1 ,nullptr },  // Inst #147 = G_SHUFFLE_VECTOR
  { 148,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #148 = G_CTTZ
  { 149,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #149 = G_CTTZ_ZERO_UNDEF
  { 150,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #150 = G_CTLZ
  { 151,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #151 = G_CTLZ_ZERO_UNDEF
  { 152,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #152 = G_CTPOP
  { 153,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #153 = G_BSWAP
  { 154,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #154 = G_FCEIL
  { 155,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #155 = G_FCOS
  { 156,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #156 = G_FSIN
  { 157,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #157 = G_FSQRT
  { 158,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #158 = G_FFLOOR
  { 159,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #159 = G_FRINT
  { 160,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #160 = G_FNEARBYINT
  { 161,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #161 = G_ADDRSPACE_CAST
  { 162,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #162 = G_BLOCK_ADDR
  { 163,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #163 = G_JUMP_TABLE
  { 164,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #164 = ADD16mc
  { 165,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #165 = ADD16mi
  { 166,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #166 = ADD16mm
  { 167,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #167 = ADD16mn
  { 168,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #168 = ADD16mp
  { 169,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #169 = ADD16mr
  { 170,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #170 = ADD16rc
  { 171,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #171 = ADD16ri
  { 172,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #172 = ADD16rm
  { 173,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #173 = ADD16rn
  { 174,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #174 = ADD16rp
  { 175,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #175 = ADD16rr
  { 176,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #176 = ADD8mc
  { 177,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #177 = ADD8mi
  { 178,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #178 = ADD8mm
  { 179,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #179 = ADD8mn
  { 180,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #180 = ADD8mp
  { 181,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #181 = ADD8mr
  { 182,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #182 = ADD8rc
  { 183,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #183 = ADD8ri
  { 184,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #184 = ADD8rm
  { 185,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #185 = ADD8rn
  { 186,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #186 = ADD8rp
  { 187,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #187 = ADD8rr
  { 188,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #188 = ADDC16mc
  { 189,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #189 = ADDC16mi
  { 190,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #190 = ADDC16mm
  { 191,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #191 = ADDC16mn
  { 192,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #192 = ADDC16mp
  { 193,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #193 = ADDC16mr
  { 194,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #194 = ADDC16rc
  { 195,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #195 = ADDC16ri
  { 196,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #196 = ADDC16rm
  { 197,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #197 = ADDC16rn
  { 198,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #198 = ADDC16rp
  { 199,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #199 = ADDC16rr
  { 200,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #200 = ADDC8mc
  { 201,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #201 = ADDC8mi
  { 202,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #202 = ADDC8mm
  { 203,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #203 = ADDC8mn
  { 204,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #204 = ADDC8mp
  { 205,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #205 = ADDC8mr
  { 206,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #206 = ADDC8rc
  { 207,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #207 = ADDC8ri
  { 208,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #208 = ADDC8rm
  { 209,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #209 = ADDC8rn
  { 210,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #210 = ADDC8rp
  { 211,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #211 = ADDC8rr
  { 212,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #212 = ADDframe
  { 213,	2,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList3, OperandInfo8, -1 ,nullptr },  // Inst #213 = ADJCALLSTACKDOWN
  { 214,	2,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList3, OperandInfo8, -1 ,nullptr },  // Inst #214 = ADJCALLSTACKUP
  { 215,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #215 = AND16mc
  { 216,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #216 = AND16mi
  { 217,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #217 = AND16mm
  { 218,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #218 = AND16mn
  { 219,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #219 = AND16mp
  { 220,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #220 = AND16mr
  { 221,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #221 = AND16rc
  { 222,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #222 = AND16ri
  { 223,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #223 = AND16rm
  { 224,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #224 = AND16rn
  { 225,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #225 = AND16rp
  { 226,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #226 = AND16rr
  { 227,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #227 = AND8mc
  { 228,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #228 = AND8mi
  { 229,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #229 = AND8mm
  { 230,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #230 = AND8mn
  { 231,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #231 = AND8mp
  { 232,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #232 = AND8mr
  { 233,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #233 = AND8rc
  { 234,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #234 = AND8ri
  { 235,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #235 = AND8rm
  { 236,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #236 = AND8rn
  { 237,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #237 = AND8rp
  { 238,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #238 = AND8rr
  { 239,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #239 = BIC16mc
  { 240,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #240 = BIC16mi
  { 241,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #241 = BIC16mm
  { 242,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #242 = BIC16mn
  { 243,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #243 = BIC16mp
  { 244,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #244 = BIC16mr
  { 245,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #245 = BIC16rc
  { 246,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #246 = BIC16ri
  { 247,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #247 = BIC16rm
  { 248,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #248 = BIC16rn
  { 249,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #249 = BIC16rp
  { 250,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #250 = BIC16rr
  { 251,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #251 = BIC8mc
  { 252,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #252 = BIC8mi
  { 253,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #253 = BIC8mm
  { 254,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #254 = BIC8mn
  { 255,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #255 = BIC8mp
  { 256,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #256 = BIC8mr
  { 257,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #257 = BIC8rc
  { 258,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #258 = BIC8ri
  { 259,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #259 = BIC8rm
  { 260,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #260 = BIC8rn
  { 261,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #261 = BIC8rp
  { 262,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #262 = BIC8rr
  { 263,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #263 = BIS16mc
  { 264,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #264 = BIS16mi
  { 265,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #265 = BIS16mm
  { 266,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #266 = BIS16mn
  { 267,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #267 = BIS16mp
  { 268,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #268 = BIS16mr
  { 269,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #269 = BIS16rc
  { 270,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #270 = BIS16ri
  { 271,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #271 = BIS16rm
  { 272,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #272 = BIS16rn
  { 273,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #273 = BIS16rp
  { 274,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #274 = BIS16rr
  { 275,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #275 = BIS8mc
  { 276,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #276 = BIS8mi
  { 277,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #277 = BIS8mm
  { 278,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #278 = BIS8mn
  { 279,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #279 = BIS8mp
  { 280,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #280 = BIS8mr
  { 281,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #281 = BIS8rc
  { 282,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #282 = BIS8ri
  { 283,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #283 = BIS8rm
  { 284,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #284 = BIS8rn
  { 285,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #285 = BIS8rp
  { 286,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #286 = BIS8rr
  { 287,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #287 = BIT16mc
  { 288,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #288 = BIT16mi
  { 289,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #289 = BIT16mm
  { 290,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #290 = BIT16mn
  { 291,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #291 = BIT16mp
  { 292,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #292 = BIT16mr
  { 293,	2,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #293 = BIT16rc
  { 294,	2,	0,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #294 = BIT16ri
  { 295,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo53, -1 ,nullptr },  // Inst #295 = BIT16rm
  { 296,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #296 = BIT16rn
  { 297,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #297 = BIT16rp
  { 298,	2,	0,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #298 = BIT16rr
  { 299,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #299 = BIT8mc
  { 300,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #300 = BIT8mi
  { 301,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #301 = BIT8mm
  { 302,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #302 = BIT8mn
  { 303,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #303 = BIT8mp
  { 304,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #304 = BIT8mr
  { 305,	2,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #305 = BIT8rc
  { 306,	2,	0,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo57, -1 ,nullptr },  // Inst #306 = BIT8ri
  { 307,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo58, -1 ,nullptr },  // Inst #307 = BIT8rm
  { 308,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #308 = BIT8rn
  { 309,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #309 = BIT8rp
  { 310,	2,	0,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo60, -1 ,nullptr },  // Inst #310 = BIT8rr
  { 311,	1,	0,	4,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #311 = Bi
  { 312,	2,	0,	4,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo61, -1 ,nullptr },  // Inst #312 = Bm
  { 313,	1,	0,	2,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo62, -1 ,nullptr },  // Inst #313 = Br
  { 314,	1,	0,	4,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList4, OperandInfo3, -1 ,nullptr },  // Inst #314 = CALLi
  { 315,	2,	0,	4,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList4, OperandInfo61, -1 ,nullptr },  // Inst #315 = CALLm
  { 316,	1,	0,	2,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList4, OperandInfo63, -1 ,nullptr },  // Inst #316 = CALLn
  { 317,	1,	0,	2,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList4, OperandInfo63, -1 ,nullptr },  // Inst #317 = CALLp
  { 318,	1,	0,	2,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList4, OperandInfo62, -1 ,nullptr },  // Inst #318 = CALLr
  { 319,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #319 = CMP16mc
  { 320,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #320 = CMP16mi
  { 321,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #321 = CMP16mm
  { 322,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #322 = CMP16mn
  { 323,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #323 = CMP16mp
  { 324,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #324 = CMP16mr
  { 325,	2,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #325 = CMP16rc
  { 326,	2,	0,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #326 = CMP16ri
  { 327,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo53, -1 ,nullptr },  // Inst #327 = CMP16rm
  { 328,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #328 = CMP16rn
  { 329,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #329 = CMP16rp
  { 330,	2,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #330 = CMP16rr
  { 331,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #331 = CMP8mc
  { 332,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #332 = CMP8mi
  { 333,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #333 = CMP8mm
  { 334,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #334 = CMP8mn
  { 335,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #335 = CMP8mp
  { 336,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #336 = CMP8mr
  { 337,	2,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #337 = CMP8rc
  { 338,	2,	0,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo57, -1 ,nullptr },  // Inst #338 = CMP8ri
  { 339,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo58, -1 ,nullptr },  // Inst #339 = CMP8rm
  { 340,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #340 = CMP8rn
  { 341,	2,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #341 = CMP8rp
  { 342,	2,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo60, -1 ,nullptr },  // Inst #342 = CMP8rr
  { 343,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #343 = DADD16mc
  { 344,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #344 = DADD16mi
  { 345,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #345 = DADD16mm
  { 346,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #346 = DADD16mn
  { 347,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #347 = DADD16mp
  { 348,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #348 = DADD16mr
  { 349,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #349 = DADD16rc
  { 350,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #350 = DADD16ri
  { 351,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #351 = DADD16rm
  { 352,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #352 = DADD16rn
  { 353,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #353 = DADD16rp
  { 354,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #354 = DADD16rr
  { 355,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #355 = DADD8mc
  { 356,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #356 = DADD8mi
  { 357,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #357 = DADD8mm
  { 358,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #358 = DADD8mn
  { 359,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #359 = DADD8mp
  { 360,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #360 = DADD8mr
  { 361,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #361 = DADD8rc
  { 362,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #362 = DADD8ri
  { 363,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #363 = DADD8rm
  { 364,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #364 = DADD8rn
  { 365,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #365 = DADD8rp
  { 366,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #366 = DADD8rr
  { 367,	2,	0,	2,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #367 = JCC
  { 368,	1,	0,	2,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #368 = JMP
  { 369,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #369 = MOV16mc
  { 370,	3,	0,	6,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #370 = MOV16mi
  { 371,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #371 = MOV16mm
  { 372,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #372 = MOV16mn
  { 373,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #373 = MOV16mr
  { 374,	2,	1,	2,	0,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #374 = MOV16rc
  { 375,	2,	1,	4,	0,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #375 = MOV16ri
  { 376,	3,	1,	4,	0,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo53, -1 ,nullptr },  // Inst #376 = MOV16rm
  { 377,	2,	1,	2,	0,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo54, -1 ,nullptr },  // Inst #377 = MOV16rn
  { 378,	3,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #378 = MOV16rp
  { 379,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #379 = MOV16rr
  { 380,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #380 = MOV8mc
  { 381,	3,	0,	6,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #381 = MOV8mi
  { 382,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #382 = MOV8mm
  { 383,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #383 = MOV8mn
  { 384,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #384 = MOV8mr
  { 385,	2,	1,	2,	0,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo56, -1 ,nullptr },  // Inst #385 = MOV8rc
  { 386,	2,	1,	4,	0,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #386 = MOV8ri
  { 387,	3,	1,	4,	0,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #387 = MOV8rm
  { 388,	2,	1,	2,	0,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #388 = MOV8rn
  { 389,	3,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo65, -1 ,nullptr },  // Inst #389 = MOV8rp
  { 390,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #390 = MOV8rr
  { 391,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo53, -1 ,nullptr },  // Inst #391 = MOVZX16rm8
  { 392,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #392 = MOVZX16rr8
  { 393,	1,	1,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo62, -1 ,nullptr },  // Inst #393 = POP16r
  { 394,	1,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #394 = PUSH16c
  { 395,	1,	0,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo3, -1 ,nullptr },  // Inst #395 = PUSH16i
  { 396,	1,	0,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo62, -1 ,nullptr },  // Inst #396 = PUSH16r
  { 397,	1,	0,	2,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo67, -1 ,nullptr },  // Inst #397 = PUSH8r
  { 398,	0,	0,	2,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #398 = RET
  { 399,	0,	0,	2,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #399 = RETI
  { 400,	2,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #400 = RRA16m
  { 401,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #401 = RRA16n
  { 402,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #402 = RRA16p
  { 403,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #403 = RRA16r
  { 404,	2,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #404 = RRA8m
  { 405,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #405 = RRA8n
  { 406,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #406 = RRA8p
  { 407,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo69, -1 ,nullptr },  // Inst #407 = RRA8r
  { 408,	2,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #408 = RRC16m
  { 409,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #409 = RRC16n
  { 410,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #410 = RRC16p
  { 411,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #411 = RRC16r
  { 412,	2,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #412 = RRC8m
  { 413,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #413 = RRC8n
  { 414,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #414 = RRC8p
  { 415,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo69, -1 ,nullptr },  // Inst #415 = RRC8r
  { 416,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #416 = Rrcl16
  { 417,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo60, -1 ,nullptr },  // Inst #417 = Rrcl8
  { 418,	2,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #418 = SEXT16m
  { 419,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #419 = SEXT16n
  { 420,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #420 = SEXT16p
  { 421,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #421 = SEXT16r
  { 422,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #422 = SUB16mc
  { 423,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #423 = SUB16mi
  { 424,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #424 = SUB16mm
  { 425,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #425 = SUB16mn
  { 426,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #426 = SUB16mp
  { 427,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #427 = SUB16mr
  { 428,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #428 = SUB16rc
  { 429,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #429 = SUB16ri
  { 430,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #430 = SUB16rm
  { 431,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #431 = SUB16rn
  { 432,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #432 = SUB16rp
  { 433,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #433 = SUB16rr
  { 434,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #434 = SUB8mc
  { 435,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #435 = SUB8mi
  { 436,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #436 = SUB8mm
  { 437,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #437 = SUB8mn
  { 438,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #438 = SUB8mp
  { 439,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #439 = SUB8mr
  { 440,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #440 = SUB8rc
  { 441,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #441 = SUB8ri
  { 442,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #442 = SUB8rm
  { 443,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #443 = SUB8rn
  { 444,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #444 = SUB8rp
  { 445,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #445 = SUB8rr
  { 446,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #446 = SUBC16mc
  { 447,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #447 = SUBC16mi
  { 448,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #448 = SUBC16mm
  { 449,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #449 = SUBC16mn
  { 450,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #450 = SUBC16mp
  { 451,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #451 = SUBC16mr
  { 452,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #452 = SUBC16rc
  { 453,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #453 = SUBC16ri
  { 454,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #454 = SUBC16rm
  { 455,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #455 = SUBC16rn
  { 456,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #456 = SUBC16rp
  { 457,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #457 = SUBC16rr
  { 458,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #458 = SUBC8mc
  { 459,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #459 = SUBC8mi
  { 460,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #460 = SUBC8mm
  { 461,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #461 = SUBC8mn
  { 462,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #462 = SUBC8mp
  { 463,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #463 = SUBC8mr
  { 464,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #464 = SUBC8rc
  { 465,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #465 = SUBC8ri
  { 466,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #466 = SUBC8rm
  { 467,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #467 = SUBC8rn
  { 468,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #468 = SUBC8rp
  { 469,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #469 = SUBC8rr
  { 470,	2,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo61, -1 ,nullptr },  // Inst #470 = SWPB16m
  { 471,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #471 = SWPB16n
  { 472,	1,	0,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #472 = SWPB16p
  { 473,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #473 = SWPB16r
  { 474,	4,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo70, -1 ,nullptr },  // Inst #474 = Select16
  { 475,	4,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo71, -1 ,nullptr },  // Inst #475 = Select8
  { 476,	3,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo72, -1 ,nullptr },  // Inst #476 = Shl16
  { 477,	3,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo73, -1 ,nullptr },  // Inst #477 = Shl8
  { 478,	3,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo72, -1 ,nullptr },  // Inst #478 = Sra16
  { 479,	3,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo73, -1 ,nullptr },  // Inst #479 = Sra8
  { 480,	3,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo72, -1 ,nullptr },  // Inst #480 = Srl16
  { 481,	3,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo73, -1 ,nullptr },  // Inst #481 = Srl8
  { 482,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #482 = XOR16mc
  { 483,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #483 = XOR16mi
  { 484,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #484 = XOR16mm
  { 485,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #485 = XOR16mn
  { 486,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #486 = XOR16mp
  { 487,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #487 = XOR16mr
  { 488,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #488 = XOR16rc
  { 489,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #489 = XOR16ri
  { 490,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #490 = XOR16rm
  { 491,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #491 = XOR16rn
  { 492,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #492 = XOR16rp
  { 493,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo42, -1 ,nullptr },  // Inst #493 = XOR16rr
  { 494,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #494 = XOR8mc
  { 495,	3,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #495 = XOR8mi
  { 496,	4,	0,	6,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #496 = XOR8mm
  { 497,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #497 = XOR8mn
  { 498,	3,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #498 = XOR8mp
  { 499,	3,	0,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo43, -1 ,nullptr },  // Inst #499 = XOR8mr
  { 500,	3,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo44, -1 ,nullptr },  // Inst #500 = XOR8rc
  { 501,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #501 = XOR8ri
  { 502,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo46, -1 ,nullptr },  // Inst #502 = XOR8rm
  { 503,	3,	1,	2,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo47, -1 ,nullptr },  // Inst #503 = XOR8rn
  { 504,	4,	2,	2,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #504 = XOR8rp
  { 505,	3,	1,	2,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #505 = XOR8rr
  { 506,	2,	1,	2,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #506 = ZEXT16r
};

extern const char MSP430InstrNameData[] = {
  /* 0 */ 'G', '_', 'F', 'L', 'O', 'G', '1', '0', 0,
  /* 9 */ 'G', '_', 'F', 'L', 'O', 'G', '2', 0,
  /* 17 */ 'G', '_', 'F', 'E', 'X', 'P', '2', 0,
  /* 25 */ 'S', 'r', 'a', '1', '6', 0,
  /* 31 */ 'R', 'r', 'c', 'l', '1', '6', 0,
  /* 38 */ 'S', 'h', 'l', '1', '6', 0,
  /* 44 */ 'S', 'r', 'l', '1', '6', 0,
  /* 50 */ 'S', 'e', 'l', 'e', 'c', 't', '1', '6', 0,
  /* 59 */ 'S', 'r', 'a', '8', 0,
  /* 64 */ 'R', 'r', 'c', 'l', '8', 0,
  /* 70 */ 'S', 'h', 'l', '8', 0,
  /* 75 */ 'S', 'r', 'l', '8', 0,
  /* 80 */ 'M', 'O', 'V', 'Z', 'X', '1', '6', 'r', 'm', '8', 0,
  /* 91 */ 'M', 'O', 'V', 'Z', 'X', '1', '6', 'r', 'r', '8', 0,
  /* 102 */ 'S', 'e', 'l', 'e', 'c', 't', '8', 0,
  /* 110 */ 'G', '_', 'F', 'M', 'A', 0,
  /* 116 */ 'G', '_', 'F', 'S', 'U', 'B', 0,
  /* 123 */ 'G', '_', 'S', 'U', 'B', 0,
  /* 129 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'S', 'U', 'B', 0,
  /* 145 */ 'J', 'C', 'C', 0,
  /* 149 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', 0,
  /* 161 */ 'G', '_', 'F', 'P', 'T', 'R', 'U', 'N', 'C', 0,
  /* 171 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 189 */ 'G', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 197 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 218 */ 'G', '_', 'S', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 229 */ 'G', '_', 'Z', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 240 */ 'G', '_', 'L', 'O', 'A', 'D', 0,
  /* 247 */ 'G', '_', 'F', 'A', 'D', 'D', 0,
  /* 254 */ 'G', '_', 'A', 'D', 'D', 0,
  /* 260 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'D', 'D', 0,
  /* 276 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'N', 'A', 'N', 'D', 0,
  /* 293 */ 'G', '_', 'A', 'N', 'D', 0,
  /* 299 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'N', 'D', 0,
  /* 315 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'E', 'N', 'D', 0,
  /* 328 */ 'G', '_', 'B', 'R', 'C', 'O', 'N', 'D', 0,
  /* 337 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'R', 'O', 'U', 'N', 'D', 0,
  /* 355 */ 'L', 'O', 'A', 'D', '_', 'S', 'T', 'A', 'C', 'K', '_', 'G', 'U', 'A', 'R', 'D', 0,
  /* 372 */ 'G', '_', 'S', 'S', 'U', 'B', 'E', 0,
  /* 380 */ 'G', '_', 'U', 'S', 'U', 'B', 'E', 0,
  /* 388 */ 'G', '_', 'F', 'E', 'N', 'C', 'E', 0,
  /* 396 */ 'R', 'E', 'G', '_', 'S', 'E', 'Q', 'U', 'E', 'N', 'C', 'E', 0,
  /* 409 */ 'G', '_', 'S', 'A', 'D', 'D', 'E', 0,
  /* 417 */ 'G', '_', 'U', 'A', 'D', 'D', 'E', 0,
  /* 425 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 440 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 455 */ 'G', '_', 'J', 'U', 'M', 'P', '_', 'T', 'A', 'B', 'L', 'E', 0,
  /* 468 */ 'B', 'U', 'N', 'D', 'L', 'E', 0,
  /* 475 */ 'L', 'O', 'C', 'A', 'L', '_', 'E', 'S', 'C', 'A', 'P', 'E', 0,
  /* 488 */ 'G', '_', 'S', 'T', 'O', 'R', 'E', 0,
  /* 496 */ 'D', 'B', 'G', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 506 */ 'G', '_', 'G', 'L', 'O', 'B', 'A', 'L', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 521 */ 'G', '_', 'F', 'C', 'A', 'N', 'O', 'N', 'I', 'C', 'A', 'L', 'I', 'Z', 'E', 0,
  /* 537 */ 'G', '_', 'C', 'T', 'L', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 555 */ 'G', '_', 'C', 'T', 'T', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 573 */ 'G', '_', 'I', 'M', 'P', 'L', 'I', 'C', 'I', 'T', '_', 'D', 'E', 'F', 0,
  /* 588 */ 'G', '_', 'F', 'N', 'E', 'G', 0,
  /* 595 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 610 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 624 */ 'S', 'U', 'B', 'R', 'E', 'G', '_', 'T', 'O', '_', 'R', 'E', 'G', 0,
  /* 638 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', 0,
  /* 655 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', 0,
  /* 672 */ 'G', '_', 'F', 'L', 'O', 'G', 0,
  /* 679 */ 'G', '_', 'V', 'A', 'A', 'R', 'G', 0,
  /* 687 */ 'G', '_', 'S', 'M', 'U', 'L', 'H', 0,
  /* 695 */ 'G', '_', 'U', 'M', 'U', 'L', 'H', 0,
  /* 703 */ 'G', '_', 'P', 'H', 'I', 0,
  /* 709 */ 'G', '_', 'F', 'P', 'T', 'O', 'S', 'I', 0,
  /* 718 */ 'R', 'E', 'T', 'I', 0,
  /* 723 */ 'G', '_', 'F', 'P', 'T', 'O', 'U', 'I', 0,
  /* 732 */ 'G', '_', 'P', 'T', 'R', '_', 'M', 'A', 'S', 'K', 0,
  /* 743 */ 'G', 'C', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 752 */ 'D', 'B', 'G', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 762 */ 'E', 'H', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 771 */ 'A', 'N', 'N', 'O', 'T', 'A', 'T', 'I', 'O', 'N', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 788 */ 'I', 'C', 'A', 'L', 'L', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'F', 'U', 'N', 'N', 'E', 'L', 0,
  /* 808 */ 'G', '_', 'S', 'H', 'L', 0,
  /* 814 */ 'G', '_', 'F', 'C', 'E', 'I', 'L', 0,
  /* 822 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'A', 'I', 'L', '_', 'C', 'A', 'L', 'L', 0,
  /* 842 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'Y', 'P', 'E', 'D', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 869 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 890 */ 'F', 'E', 'N', 'T', 'R', 'Y', '_', 'C', 'A', 'L', 'L', 0,
  /* 902 */ 'K', 'I', 'L', 'L', 0,
  /* 907 */ 'G', '_', 'F', 'M', 'U', 'L', 0,
  /* 914 */ 'G', '_', 'M', 'U', 'L', 0,
  /* 920 */ 'G', '_', 'F', 'R', 'E', 'M', 0,
  /* 927 */ 'G', '_', 'S', 'R', 'E', 'M', 0,
  /* 934 */ 'G', '_', 'U', 'R', 'E', 'M', 0,
  /* 941 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', 0,
  /* 951 */ 'G', '_', 'F', 'M', 'I', 'N', 'I', 'M', 'U', 'M', 0,
  /* 962 */ 'G', '_', 'F', 'M', 'A', 'X', 'I', 'M', 'U', 'M', 0,
  /* 973 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', 0,
  /* 983 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', 0,
  /* 993 */ 'G', '_', 'F', 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', 0,
  /* 1005 */ 'G', '_', 'S', 'M', 'I', 'N', 0,
  /* 1012 */ 'G', '_', 'U', 'M', 'I', 'N', 0,
  /* 1019 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'I', 'N', 0,
  /* 1036 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'I', 'N', 0,
  /* 1052 */ 'G', '_', 'F', 'S', 'I', 'N', 0,
  /* 1059 */ 'C', 'F', 'I', '_', 'I', 'N', 'S', 'T', 'R', 'U', 'C', 'T', 'I', 'O', 'N', 0,
  /* 1075 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'D', 'O', 'W', 'N', 0,
  /* 1092 */ 'G', '_', 'S', 'S', 'U', 'B', 'O', 0,
  /* 1100 */ 'G', '_', 'U', 'S', 'U', 'B', 'O', 0,
  /* 1108 */ 'G', '_', 'S', 'A', 'D', 'D', 'O', 0,
  /* 1116 */ 'G', '_', 'U', 'A', 'D', 'D', 'O', 0,
  /* 1124 */ 'G', '_', 'S', 'M', 'U', 'L', 'O', 0,
  /* 1132 */ 'G', '_', 'U', 'M', 'U', 'L', 'O', 0,
  /* 1140 */ 'S', 'T', 'A', 'C', 'K', 'M', 'A', 'P', 0,
  /* 1149 */ 'G', '_', 'B', 'S', 'W', 'A', 'P', 0,
  /* 1157 */ 'G', '_', 'G', 'E', 'P', 0,
  /* 1163 */ 'G', '_', 'S', 'I', 'T', 'O', 'F', 'P', 0,
  /* 1172 */ 'G', '_', 'U', 'I', 'T', 'O', 'F', 'P', 0,
  /* 1181 */ 'G', '_', 'F', 'C', 'M', 'P', 0,
  /* 1188 */ 'G', '_', 'I', 'C', 'M', 'P', 0,
  /* 1195 */ 'J', 'M', 'P', 0,
  /* 1199 */ 'G', '_', 'C', 'T', 'P', 'O', 'P', 0,
  /* 1207 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'O', 'P', 0,
  /* 1220 */ 'F', 'A', 'U', 'L', 'T', 'I', 'N', 'G', '_', 'O', 'P', 0,
  /* 1232 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'U', 'P', 0,
  /* 1247 */ 'G', '_', 'F', 'E', 'X', 'P', 0,
  /* 1254 */ 'G', '_', 'B', 'R', 0,
  /* 1259 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', '_', 'B', 'R', 0,
  /* 1272 */ 'G', '_', 'B', 'L', 'O', 'C', 'K', '_', 'A', 'D', 'D', 'R', 0,
  /* 1285 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'N', 'T', 'E', 'R', 0,
  /* 1310 */ 'G', '_', 'A', 'S', 'H', 'R', 0,
  /* 1317 */ 'G', '_', 'L', 'S', 'H', 'R', 0,
  /* 1324 */ 'G', '_', 'F', 'F', 'L', 'O', 'O', 'R', 0,
  /* 1333 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 1348 */ 'G', '_', 'S', 'H', 'U', 'F', 'F', 'L', 'E', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 1365 */ 'G', '_', 'X', 'O', 'R', 0,
  /* 1371 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'O', 'R', 0,
  /* 1387 */ 'G', '_', 'O', 'R', 0,
  /* 1392 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'O', 'R', 0,
  /* 1407 */ 'G', '_', 'I', 'N', 'T', 'T', 'O', 'P', 'T', 'R', 0,
  /* 1418 */ 'G', '_', 'F', 'A', 'B', 'S', 0,
  /* 1425 */ 'G', '_', 'U', 'N', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 1442 */ 'G', '_', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 1457 */ 'G', '_', 'F', 'C', 'O', 'S', 0,
  /* 1464 */ 'G', '_', 'C', 'O', 'N', 'C', 'A', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', 'S', 0,
  /* 1481 */ 'C', 'O', 'P', 'Y', '_', 'T', 'O', '_', 'R', 'E', 'G', 'C', 'L', 'A', 'S', 'S', 0,
  /* 1498 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'W', 'I', 'T', 'H', '_', 'S', 'U', 'C', 'C', 'E', 'S', 'S', 0,
  /* 1528 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'W', '_', 'S', 'I', 'D', 'E', '_', 'E', 'F', 'F', 'E', 'C', 'T', 'S', 0,
  /* 1555 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 0,
  /* 1565 */ 'G', '_', 'S', 'E', 'L', 'E', 'C', 'T', 0,
  /* 1574 */ 'G', '_', 'B', 'R', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', 0,
  /* 1587 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'R', 'E', 'T', 0,
  /* 1601 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'X', 'I', 'T', 0,
  /* 1625 */ 'G', '_', 'B', 'R', 'J', 'T', 0,
  /* 1632 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 1653 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 1673 */ 'G', '_', 'F', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 1685 */ 'G', '_', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 1696 */ 'S', 'T', 'A', 'T', 'E', 'P', 'O', 'I', 'N', 'T', 0,
  /* 1707 */ 'P', 'A', 'T', 'C', 'H', 'P', 'O', 'I', 'N', 'T', 0,
  /* 1718 */ 'G', '_', 'P', 'T', 'R', 'T', 'O', 'I', 'N', 'T', 0,
  /* 1729 */ 'G', '_', 'F', 'R', 'I', 'N', 'T', 0,
  /* 1737 */ 'G', '_', 'F', 'N', 'E', 'A', 'R', 'B', 'Y', 'I', 'N', 'T', 0,
  /* 1750 */ 'G', '_', 'V', 'A', 'S', 'T', 'A', 'R', 'T', 0,
  /* 1760 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'S', 'T', 'A', 'R', 'T', 0,
  /* 1775 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', 0,
  /* 1784 */ 'G', '_', 'F', 'S', 'Q', 'R', 'T', 0,
  /* 1792 */ 'G', '_', 'B', 'I', 'T', 'C', 'A', 'S', 'T', 0,
  /* 1802 */ 'G', '_', 'A', 'D', 'D', 'R', 'S', 'P', 'A', 'C', 'E', '_', 'C', 'A', 'S', 'T', 0,
  /* 1819 */ 'G', '_', 'F', 'P', 'E', 'X', 'T', 0,
  /* 1827 */ 'G', '_', 'S', 'E', 'X', 'T', 0,
  /* 1834 */ 'G', '_', 'A', 'N', 'Y', 'E', 'X', 'T', 0,
  /* 1843 */ 'G', '_', 'Z', 'E', 'X', 'T', 0,
  /* 1850 */ 'G', '_', 'F', 'D', 'I', 'V', 0,
  /* 1857 */ 'G', '_', 'S', 'D', 'I', 'V', 0,
  /* 1864 */ 'G', '_', 'U', 'D', 'I', 'V', 0,
  /* 1871 */ 'G', '_', 'F', 'P', 'O', 'W', 0,
  /* 1878 */ 'G', '_', 'S', 'M', 'A', 'X', 0,
  /* 1885 */ 'G', '_', 'U', 'M', 'A', 'X', 0,
  /* 1892 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'A', 'X', 0,
  /* 1909 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'A', 'X', 0,
  /* 1925 */ 'G', '_', 'F', 'R', 'A', 'M', 'E', '_', 'I', 'N', 'D', 'E', 'X', 0,
  /* 1939 */ 'C', 'O', 'P', 'Y', 0,
  /* 1944 */ 'G', '_', 'C', 'T', 'L', 'Z', 0,
  /* 1951 */ 'G', '_', 'C', 'T', 'T', 'Z', 0,
  /* 1958 */ 'P', 'U', 'S', 'H', '1', '6', 'c', 0,
  /* 1966 */ 'S', 'U', 'B', '1', '6', 'm', 'c', 0,
  /* 1974 */ 'S', 'U', 'B', 'C', '1', '6', 'm', 'c', 0,
  /* 1983 */ 'A', 'D', 'D', 'C', '1', '6', 'm', 'c', 0,
  /* 1992 */ 'B', 'I', 'C', '1', '6', 'm', 'c', 0,
  /* 2000 */ 'D', 'A', 'D', 'D', '1', '6', 'm', 'c', 0,
  /* 2009 */ 'A', 'N', 'D', '1', '6', 'm', 'c', 0,
  /* 2017 */ 'C', 'M', 'P', '1', '6', 'm', 'c', 0,
  /* 2025 */ 'X', 'O', 'R', '1', '6', 'm', 'c', 0,
  /* 2033 */ 'B', 'I', 'S', '1', '6', 'm', 'c', 0,
  /* 2041 */ 'B', 'I', 'T', '1', '6', 'm', 'c', 0,
  /* 2049 */ 'M', 'O', 'V', '1', '6', 'm', 'c', 0,
  /* 2057 */ 'S', 'U', 'B', '8', 'm', 'c', 0,
  /* 2064 */ 'S', 'U', 'B', 'C', '8', 'm', 'c', 0,
  /* 2072 */ 'A', 'D', 'D', 'C', '8', 'm', 'c', 0,
  /* 2080 */ 'B', 'I', 'C', '8', 'm', 'c', 0,
  /* 2087 */ 'D', 'A', 'D', 'D', '8', 'm', 'c', 0,
  /* 2095 */ 'A', 'N', 'D', '8', 'm', 'c', 0,
  /* 2102 */ 'C', 'M', 'P', '8', 'm', 'c', 0,
  /* 2109 */ 'X', 'O', 'R', '8', 'm', 'c', 0,
  /* 2116 */ 'B', 'I', 'S', '8', 'm', 'c', 0,
  /* 2123 */ 'B', 'I', 'T', '8', 'm', 'c', 0,
  /* 2130 */ 'M', 'O', 'V', '8', 'm', 'c', 0,
  /* 2137 */ 'S', 'U', 'B', '1', '6', 'r', 'c', 0,
  /* 2145 */ 'S', 'U', 'B', 'C', '1', '6', 'r', 'c', 0,
  /* 2154 */ 'A', 'D', 'D', 'C', '1', '6', 'r', 'c', 0,
  /* 2163 */ 'B', 'I', 'C', '1', '6', 'r', 'c', 0,
  /* 2171 */ 'D', 'A', 'D', 'D', '1', '6', 'r', 'c', 0,
  /* 2180 */ 'A', 'N', 'D', '1', '6', 'r', 'c', 0,
  /* 2188 */ 'C', 'M', 'P', '1', '6', 'r', 'c', 0,
  /* 2196 */ 'X', 'O', 'R', '1', '6', 'r', 'c', 0,
  /* 2204 */ 'B', 'I', 'S', '1', '6', 'r', 'c', 0,
  /* 2212 */ 'B', 'I', 'T', '1', '6', 'r', 'c', 0,
  /* 2220 */ 'M', 'O', 'V', '1', '6', 'r', 'c', 0,
  /* 2228 */ 'S', 'U', 'B', '8', 'r', 'c', 0,
  /* 2235 */ 'S', 'U', 'B', 'C', '8', 'r', 'c', 0,
  /* 2243 */ 'A', 'D', 'D', 'C', '8', 'r', 'c', 0,
  /* 2251 */ 'B', 'I', 'C', '8', 'r', 'c', 0,
  /* 2258 */ 'D', 'A', 'D', 'D', '8', 'r', 'c', 0,
  /* 2266 */ 'A', 'N', 'D', '8', 'r', 'c', 0,
  /* 2273 */ 'C', 'M', 'P', '8', 'r', 'c', 0,
  /* 2280 */ 'X', 'O', 'R', '8', 'r', 'c', 0,
  /* 2287 */ 'B', 'I', 'S', '8', 'r', 'c', 0,
  /* 2294 */ 'B', 'I', 'T', '8', 'r', 'c', 0,
  /* 2301 */ 'M', 'O', 'V', '8', 'r', 'c', 0,
  /* 2308 */ 'A', 'D', 'D', 'f', 'r', 'a', 'm', 'e', 0,
  /* 2317 */ 'P', 'U', 'S', 'H', '1', '6', 'i', 0,
  /* 2325 */ 'B', 'i', 0,
  /* 2328 */ 'C', 'A', 'L', 'L', 'i', 0,
  /* 2334 */ 'S', 'U', 'B', '1', '6', 'm', 'i', 0,
  /* 2342 */ 'S', 'U', 'B', 'C', '1', '6', 'm', 'i', 0,
  /* 2351 */ 'A', 'D', 'D', 'C', '1', '6', 'm', 'i', 0,
  /* 2360 */ 'B', 'I', 'C', '1', '6', 'm', 'i', 0,
  /* 2368 */ 'D', 'A', 'D', 'D', '1', '6', 'm', 'i', 0,
  /* 2377 */ 'A', 'N', 'D', '1', '6', 'm', 'i', 0,
  /* 2385 */ 'C', 'M', 'P', '1', '6', 'm', 'i', 0,
  /* 2393 */ 'X', 'O', 'R', '1', '6', 'm', 'i', 0,
  /* 2401 */ 'B', 'I', 'S', '1', '6', 'm', 'i', 0,
  /* 2409 */ 'B', 'I', 'T', '1', '6', 'm', 'i', 0,
  /* 2417 */ 'M', 'O', 'V', '1', '6', 'm', 'i', 0,
  /* 2425 */ 'S', 'U', 'B', '8', 'm', 'i', 0,
  /* 2432 */ 'S', 'U', 'B', 'C', '8', 'm', 'i', 0,
  /* 2440 */ 'A', 'D', 'D', 'C', '8', 'm', 'i', 0,
  /* 2448 */ 'B', 'I', 'C', '8', 'm', 'i', 0,
  /* 2455 */ 'D', 'A', 'D', 'D', '8', 'm', 'i', 0,
  /* 2463 */ 'A', 'N', 'D', '8', 'm', 'i', 0,
  /* 2470 */ 'C', 'M', 'P', '8', 'm', 'i', 0,
  /* 2477 */ 'X', 'O', 'R', '8', 'm', 'i', 0,
  /* 2484 */ 'B', 'I', 'S', '8', 'm', 'i', 0,
  /* 2491 */ 'B', 'I', 'T', '8', 'm', 'i', 0,
  /* 2498 */ 'M', 'O', 'V', '8', 'm', 'i', 0,
  /* 2505 */ 'S', 'U', 'B', '1', '6', 'r', 'i', 0,
  /* 2513 */ 'S', 'U', 'B', 'C', '1', '6', 'r', 'i', 0,
  /* 2522 */ 'A', 'D', 'D', 'C', '1', '6', 'r', 'i', 0,
  /* 2531 */ 'B', 'I', 'C', '1', '6', 'r', 'i', 0,
  /* 2539 */ 'D', 'A', 'D', 'D', '1', '6', 'r', 'i', 0,
  /* 2548 */ 'A', 'N', 'D', '1', '6', 'r', 'i', 0,
  /* 2556 */ 'C', 'M', 'P', '1', '6', 'r', 'i', 0,
  /* 2564 */ 'X', 'O', 'R', '1', '6', 'r', 'i', 0,
  /* 2572 */ 'B', 'I', 'S', '1', '6', 'r', 'i', 0,
  /* 2580 */ 'B', 'I', 'T', '1', '6', 'r', 'i', 0,
  /* 2588 */ 'M', 'O', 'V', '1', '6', 'r', 'i', 0,
  /* 2596 */ 'S', 'U', 'B', '8', 'r', 'i', 0,
  /* 2603 */ 'S', 'U', 'B', 'C', '8', 'r', 'i', 0,
  /* 2611 */ 'A', 'D', 'D', 'C', '8', 'r', 'i', 0,
  /* 2619 */ 'B', 'I', 'C', '8', 'r', 'i', 0,
  /* 2626 */ 'D', 'A', 'D', 'D', '8', 'r', 'i', 0,
  /* 2634 */ 'A', 'N', 'D', '8', 'r', 'i', 0,
  /* 2641 */ 'C', 'M', 'P', '8', 'r', 'i', 0,
  /* 2648 */ 'X', 'O', 'R', '8', 'r', 'i', 0,
  /* 2655 */ 'B', 'I', 'S', '8', 'r', 'i', 0,
  /* 2662 */ 'B', 'I', 'T', '8', 'r', 'i', 0,
  /* 2669 */ 'M', 'O', 'V', '8', 'r', 'i', 0,
  /* 2676 */ 'R', 'R', 'A', '1', '6', 'm', 0,
  /* 2683 */ 'S', 'W', 'P', 'B', '1', '6', 'm', 0,
  /* 2691 */ 'R', 'R', 'C', '1', '6', 'm', 0,
  /* 2698 */ 'S', 'E', 'X', 'T', '1', '6', 'm', 0,
  /* 2706 */ 'R', 'R', 'A', '8', 'm', 0,
  /* 2712 */ 'R', 'R', 'C', '8', 'm', 0,
  /* 2718 */ 'B', 'm', 0,
  /* 2721 */ 'C', 'A', 'L', 'L', 'm', 0,
  /* 2727 */ 'S', 'U', 'B', '1', '6', 'm', 'm', 0,
  /* 2735 */ 'S', 'U', 'B', 'C', '1', '6', 'm', 'm', 0,
  /* 2744 */ 'A', 'D', 'D', 'C', '1', '6', 'm', 'm', 0,
  /* 2753 */ 'B', 'I', 'C', '1', '6', 'm', 'm', 0,
  /* 2761 */ 'D', 'A', 'D', 'D', '1', '6', 'm', 'm', 0,
  /* 2770 */ 'A', 'N', 'D', '1', '6', 'm', 'm', 0,
  /* 2778 */ 'C', 'M', 'P', '1', '6', 'm', 'm', 0,
  /* 2786 */ 'X', 'O', 'R', '1', '6', 'm', 'm', 0,
  /* 2794 */ 'B', 'I', 'S', '1', '6', 'm', 'm', 0,
  /* 2802 */ 'B', 'I', 'T', '1', '6', 'm', 'm', 0,
  /* 2810 */ 'M', 'O', 'V', '1', '6', 'm', 'm', 0,
  /* 2818 */ 'S', 'U', 'B', '8', 'm', 'm', 0,
  /* 2825 */ 'S', 'U', 'B', 'C', '8', 'm', 'm', 0,
  /* 2833 */ 'A', 'D', 'D', 'C', '8', 'm', 'm', 0,
  /* 2841 */ 'B', 'I', 'C', '8', 'm', 'm', 0,
  /* 2848 */ 'D', 'A', 'D', 'D', '8', 'm', 'm', 0,
  /* 2856 */ 'A', 'N', 'D', '8', 'm', 'm', 0,
  /* 2863 */ 'C', 'M', 'P', '8', 'm', 'm', 0,
  /* 2870 */ 'X', 'O', 'R', '8', 'm', 'm', 0,
  /* 2877 */ 'B', 'I', 'S', '8', 'm', 'm', 0,
  /* 2884 */ 'B', 'I', 'T', '8', 'm', 'm', 0,
  /* 2891 */ 'M', 'O', 'V', '8', 'm', 'm', 0,
  /* 2898 */ 'S', 'U', 'B', '1', '6', 'r', 'm', 0,
  /* 2906 */ 'S', 'U', 'B', 'C', '1', '6', 'r', 'm', 0,
  /* 2915 */ 'A', 'D', 'D', 'C', '1', '6', 'r', 'm', 0,
  /* 2924 */ 'B', 'I', 'C', '1', '6', 'r', 'm', 0,
  /* 2932 */ 'D', 'A', 'D', 'D', '1', '6', 'r', 'm', 0,
  /* 2941 */ 'A', 'N', 'D', '1', '6', 'r', 'm', 0,
  /* 2949 */ 'C', 'M', 'P', '1', '6', 'r', 'm', 0,
  /* 2957 */ 'X', 'O', 'R', '1', '6', 'r', 'm', 0,
  /* 2965 */ 'B', 'I', 'S', '1', '6', 'r', 'm', 0,
  /* 2973 */ 'B', 'I', 'T', '1', '6', 'r', 'm', 0,
  /* 2981 */ 'M', 'O', 'V', '1', '6', 'r', 'm', 0,
  /* 2989 */ 'S', 'U', 'B', '8', 'r', 'm', 0,
  /* 2996 */ 'S', 'U', 'B', 'C', '8', 'r', 'm', 0,
  /* 3004 */ 'A', 'D', 'D', 'C', '8', 'r', 'm', 0,
  /* 3012 */ 'B', 'I', 'C', '8', 'r', 'm', 0,
  /* 3019 */ 'D', 'A', 'D', 'D', '8', 'r', 'm', 0,
  /* 3027 */ 'A', 'N', 'D', '8', 'r', 'm', 0,
  /* 3034 */ 'C', 'M', 'P', '8', 'r', 'm', 0,
  /* 3041 */ 'X', 'O', 'R', '8', 'r', 'm', 0,
  /* 3048 */ 'B', 'I', 'S', '8', 'r', 'm', 0,
  /* 3055 */ 'B', 'I', 'T', '8', 'r', 'm', 0,
  /* 3062 */ 'M', 'O', 'V', '8', 'r', 'm', 0,
  /* 3069 */ 'R', 'R', 'A', '1', '6', 'n', 0,
  /* 3076 */ 'S', 'W', 'P', 'B', '1', '6', 'n', 0,
  /* 3084 */ 'R', 'R', 'C', '1', '6', 'n', 0,
  /* 3091 */ 'S', 'E', 'X', 'T', '1', '6', 'n', 0,
  /* 3099 */ 'R', 'R', 'A', '8', 'n', 0,
  /* 3105 */ 'R', 'R', 'C', '8', 'n', 0,
  /* 3111 */ 'C', 'A', 'L', 'L', 'n', 0,
  /* 3117 */ 'S', 'U', 'B', '1', '6', 'm', 'n', 0,
  /* 3125 */ 'S', 'U', 'B', 'C', '1', '6', 'm', 'n', 0,
  /* 3134 */ 'A', 'D', 'D', 'C', '1', '6', 'm', 'n', 0,
  /* 3143 */ 'B', 'I', 'C', '1', '6', 'm', 'n', 0,
  /* 3151 */ 'D', 'A', 'D', 'D', '1', '6', 'm', 'n', 0,
  /* 3160 */ 'A', 'N', 'D', '1', '6', 'm', 'n', 0,
  /* 3168 */ 'C', 'M', 'P', '1', '6', 'm', 'n', 0,
  /* 3176 */ 'X', 'O', 'R', '1', '6', 'm', 'n', 0,
  /* 3184 */ 'B', 'I', 'S', '1', '6', 'm', 'n', 0,
  /* 3192 */ 'B', 'I', 'T', '1', '6', 'm', 'n', 0,
  /* 3200 */ 'M', 'O', 'V', '1', '6', 'm', 'n', 0,
  /* 3208 */ 'S', 'U', 'B', '8', 'm', 'n', 0,
  /* 3215 */ 'S', 'U', 'B', 'C', '8', 'm', 'n', 0,
  /* 3223 */ 'A', 'D', 'D', 'C', '8', 'm', 'n', 0,
  /* 3231 */ 'B', 'I', 'C', '8', 'm', 'n', 0,
  /* 3238 */ 'D', 'A', 'D', 'D', '8', 'm', 'n', 0,
  /* 3246 */ 'A', 'N', 'D', '8', 'm', 'n', 0,
  /* 3253 */ 'C', 'M', 'P', '8', 'm', 'n', 0,
  /* 3260 */ 'X', 'O', 'R', '8', 'm', 'n', 0,
  /* 3267 */ 'B', 'I', 'S', '8', 'm', 'n', 0,
  /* 3274 */ 'B', 'I', 'T', '8', 'm', 'n', 0,
  /* 3281 */ 'M', 'O', 'V', '8', 'm', 'n', 0,
  /* 3288 */ 'S', 'U', 'B', '1', '6', 'r', 'n', 0,
  /* 3296 */ 'S', 'U', 'B', 'C', '1', '6', 'r', 'n', 0,
  /* 3305 */ 'A', 'D', 'D', 'C', '1', '6', 'r', 'n', 0,
  /* 3314 */ 'B', 'I', 'C', '1', '6', 'r', 'n', 0,
  /* 3322 */ 'D', 'A', 'D', 'D', '1', '6', 'r', 'n', 0,
  /* 3331 */ 'A', 'N', 'D', '1', '6', 'r', 'n', 0,
  /* 3339 */ 'C', 'M', 'P', '1', '6', 'r', 'n', 0,
  /* 3347 */ 'X', 'O', 'R', '1', '6', 'r', 'n', 0,
  /* 3355 */ 'B', 'I', 'S', '1', '6', 'r', 'n', 0,
  /* 3363 */ 'B', 'I', 'T', '1', '6', 'r', 'n', 0,
  /* 3371 */ 'M', 'O', 'V', '1', '6', 'r', 'n', 0,
  /* 3379 */ 'S', 'U', 'B', '8', 'r', 'n', 0,
  /* 3386 */ 'S', 'U', 'B', 'C', '8', 'r', 'n', 0,
  /* 3394 */ 'A', 'D', 'D', 'C', '8', 'r', 'n', 0,
  /* 3402 */ 'B', 'I', 'C', '8', 'r', 'n', 0,
  /* 3409 */ 'D', 'A', 'D', 'D', '8', 'r', 'n', 0,
  /* 3417 */ 'A', 'N', 'D', '8', 'r', 'n', 0,
  /* 3424 */ 'C', 'M', 'P', '8', 'r', 'n', 0,
  /* 3431 */ 'X', 'O', 'R', '8', 'r', 'n', 0,
  /* 3438 */ 'B', 'I', 'S', '8', 'r', 'n', 0,
  /* 3445 */ 'B', 'I', 'T', '8', 'r', 'n', 0,
  /* 3452 */ 'M', 'O', 'V', '8', 'r', 'n', 0,
  /* 3459 */ 'R', 'R', 'A', '1', '6', 'p', 0,
  /* 3466 */ 'S', 'W', 'P', 'B', '1', '6', 'p', 0,
  /* 3474 */ 'R', 'R', 'C', '1', '6', 'p', 0,
  /* 3481 */ 'S', 'E', 'X', 'T', '1', '6', 'p', 0,
  /* 3489 */ 'R', 'R', 'A', '8', 'p', 0,
  /* 3495 */ 'R', 'R', 'C', '8', 'p', 0,
  /* 3501 */ 'C', 'A', 'L', 'L', 'p', 0,
  /* 3507 */ 'S', 'U', 'B', '1', '6', 'm', 'p', 0,
  /* 3515 */ 'S', 'U', 'B', 'C', '1', '6', 'm', 'p', 0,
  /* 3524 */ 'A', 'D', 'D', 'C', '1', '6', 'm', 'p', 0,
  /* 3533 */ 'B', 'I', 'C', '1', '6', 'm', 'p', 0,
  /* 3541 */ 'D', 'A', 'D', 'D', '1', '6', 'm', 'p', 0,
  /* 3550 */ 'A', 'N', 'D', '1', '6', 'm', 'p', 0,
  /* 3558 */ 'C', 'M', 'P', '1', '6', 'm', 'p', 0,
  /* 3566 */ 'X', 'O', 'R', '1', '6', 'm', 'p', 0,
  /* 3574 */ 'B', 'I', 'S', '1', '6', 'm', 'p', 0,
  /* 3582 */ 'B', 'I', 'T', '1', '6', 'm', 'p', 0,
  /* 3590 */ 'S', 'U', 'B', '8', 'm', 'p', 0,
  /* 3597 */ 'S', 'U', 'B', 'C', '8', 'm', 'p', 0,
  /* 3605 */ 'A', 'D', 'D', 'C', '8', 'm', 'p', 0,
  /* 3613 */ 'B', 'I', 'C', '8', 'm', 'p', 0,
  /* 3620 */ 'D', 'A', 'D', 'D', '8', 'm', 'p', 0,
  /* 3628 */ 'A', 'N', 'D', '8', 'm', 'p', 0,
  /* 3635 */ 'C', 'M', 'P', '8', 'm', 'p', 0,
  /* 3642 */ 'X', 'O', 'R', '8', 'm', 'p', 0,
  /* 3649 */ 'B', 'I', 'S', '8', 'm', 'p', 0,
  /* 3656 */ 'B', 'I', 'T', '8', 'm', 'p', 0,
  /* 3663 */ 'S', 'U', 'B', '1', '6', 'r', 'p', 0,
  /* 3671 */ 'S', 'U', 'B', 'C', '1', '6', 'r', 'p', 0,
  /* 3680 */ 'A', 'D', 'D', 'C', '1', '6', 'r', 'p', 0,
  /* 3689 */ 'B', 'I', 'C', '1', '6', 'r', 'p', 0,
  /* 3697 */ 'D', 'A', 'D', 'D', '1', '6', 'r', 'p', 0,
  /* 3706 */ 'A', 'N', 'D', '1', '6', 'r', 'p', 0,
  /* 3714 */ 'C', 'M', 'P', '1', '6', 'r', 'p', 0,
  /* 3722 */ 'X', 'O', 'R', '1', '6', 'r', 'p', 0,
  /* 3730 */ 'B', 'I', 'S', '1', '6', 'r', 'p', 0,
  /* 3738 */ 'B', 'I', 'T', '1', '6', 'r', 'p', 0,
  /* 3746 */ 'M', 'O', 'V', '1', '6', 'r', 'p', 0,
  /* 3754 */ 'S', 'U', 'B', '8', 'r', 'p', 0,
  /* 3761 */ 'S', 'U', 'B', 'C', '8', 'r', 'p', 0,
  /* 3769 */ 'A', 'D', 'D', 'C', '8', 'r', 'p', 0,
  /* 3777 */ 'B', 'I', 'C', '8', 'r', 'p', 0,
  /* 3784 */ 'D', 'A', 'D', 'D', '8', 'r', 'p', 0,
  /* 3792 */ 'A', 'N', 'D', '8', 'r', 'p', 0,
  /* 3799 */ 'C', 'M', 'P', '8', 'r', 'p', 0,
  /* 3806 */ 'X', 'O', 'R', '8', 'r', 'p', 0,
  /* 3813 */ 'B', 'I', 'S', '8', 'r', 'p', 0,
  /* 3820 */ 'B', 'I', 'T', '8', 'r', 'p', 0,
  /* 3827 */ 'M', 'O', 'V', '8', 'r', 'p', 0,
  /* 3834 */ 'R', 'R', 'A', '1', '6', 'r', 0,
  /* 3841 */ 'S', 'W', 'P', 'B', '1', '6', 'r', 0,
  /* 3849 */ 'R', 'R', 'C', '1', '6', 'r', 0,
  /* 3856 */ 'P', 'U', 'S', 'H', '1', '6', 'r', 0,
  /* 3864 */ 'P', 'O', 'P', '1', '6', 'r', 0,
  /* 3871 */ 'S', 'E', 'X', 'T', '1', '6', 'r', 0,
  /* 3879 */ 'Z', 'E', 'X', 'T', '1', '6', 'r', 0,
  /* 3887 */ 'R', 'R', 'A', '8', 'r', 0,
  /* 3893 */ 'R', 'R', 'C', '8', 'r', 0,
  /* 3899 */ 'P', 'U', 'S', 'H', '8', 'r', 0,
  /* 3906 */ 'B', 'r', 0,
  /* 3909 */ 'C', 'A', 'L', 'L', 'r', 0,
  /* 3915 */ 'S', 'U', 'B', '1', '6', 'm', 'r', 0,
  /* 3923 */ 'S', 'U', 'B', 'C', '1', '6', 'm', 'r', 0,
  /* 3932 */ 'A', 'D', 'D', 'C', '1', '6', 'm', 'r', 0,
  /* 3941 */ 'B', 'I', 'C', '1', '6', 'm', 'r', 0,
  /* 3949 */ 'D', 'A', 'D', 'D', '1', '6', 'm', 'r', 0,
  /* 3958 */ 'A', 'N', 'D', '1', '6', 'm', 'r', 0,
  /* 3966 */ 'C', 'M', 'P', '1', '6', 'm', 'r', 0,
  /* 3974 */ 'X', 'O', 'R', '1', '6', 'm', 'r', 0,
  /* 3982 */ 'B', 'I', 'S', '1', '6', 'm', 'r', 0,
  /* 3990 */ 'B', 'I', 'T', '1', '6', 'm', 'r', 0,
  /* 3998 */ 'M', 'O', 'V', '1', '6', 'm', 'r', 0,
  /* 4006 */ 'S', 'U', 'B', '8', 'm', 'r', 0,
  /* 4013 */ 'S', 'U', 'B', 'C', '8', 'm', 'r', 0,
  /* 4021 */ 'A', 'D', 'D', 'C', '8', 'm', 'r', 0,
  /* 4029 */ 'B', 'I', 'C', '8', 'm', 'r', 0,
  /* 4036 */ 'D', 'A', 'D', 'D', '8', 'm', 'r', 0,
  /* 4044 */ 'A', 'N', 'D', '8', 'm', 'r', 0,
  /* 4051 */ 'C', 'M', 'P', '8', 'm', 'r', 0,
  /* 4058 */ 'X', 'O', 'R', '8', 'm', 'r', 0,
  /* 4065 */ 'B', 'I', 'S', '8', 'm', 'r', 0,
  /* 4072 */ 'B', 'I', 'T', '8', 'm', 'r', 0,
  /* 4079 */ 'M', 'O', 'V', '8', 'm', 'r', 0,
  /* 4086 */ 'S', 'U', 'B', '1', '6', 'r', 'r', 0,
  /* 4094 */ 'S', 'U', 'B', 'C', '1', '6', 'r', 'r', 0,
  /* 4103 */ 'A', 'D', 'D', 'C', '1', '6', 'r', 'r', 0,
  /* 4112 */ 'B', 'I', 'C', '1', '6', 'r', 'r', 0,
  /* 4120 */ 'D', 'A', 'D', 'D', '1', '6', 'r', 'r', 0,
  /* 4129 */ 'A', 'N', 'D', '1', '6', 'r', 'r', 0,
  /* 4137 */ 'C', 'M', 'P', '1', '6', 'r', 'r', 0,
  /* 4145 */ 'X', 'O', 'R', '1', '6', 'r', 'r', 0,
  /* 4153 */ 'B', 'I', 'S', '1', '6', 'r', 'r', 0,
  /* 4161 */ 'B', 'I', 'T', '1', '6', 'r', 'r', 0,
  /* 4169 */ 'M', 'O', 'V', '1', '6', 'r', 'r', 0,
  /* 4177 */ 'S', 'U', 'B', '8', 'r', 'r', 0,
  /* 4184 */ 'S', 'U', 'B', 'C', '8', 'r', 'r', 0,
  /* 4192 */ 'A', 'D', 'D', 'C', '8', 'r', 'r', 0,
  /* 4200 */ 'B', 'I', 'C', '8', 'r', 'r', 0,
  /* 4207 */ 'D', 'A', 'D', 'D', '8', 'r', 'r', 0,
  /* 4215 */ 'A', 'N', 'D', '8', 'r', 'r', 0,
  /* 4222 */ 'C', 'M', 'P', '8', 'r', 'r', 0,
  /* 4229 */ 'X', 'O', 'R', '8', 'r', 'r', 0,
  /* 4236 */ 'B', 'I', 'S', '8', 'r', 'r', 0,
  /* 4243 */ 'B', 'I', 'T', '8', 'r', 'r', 0,
  /* 4250 */ 'M', 'O', 'V', '8', 'r', 'r', 0,
};

extern const unsigned MSP430InstrNameIndices[] = {
    705U, 941U, 1259U, 1059U, 762U, 743U, 771U, 902U, 
    595U, 610U, 575U, 624U, 1481U, 496U, 752U, 396U, 
    1939U, 468U, 1760U, 315U, 1140U, 890U, 1707U, 355U, 
    1696U, 475U, 1220U, 1207U, 1285U, 1587U, 1601U, 822U, 
    869U, 842U, 788U, 254U, 123U, 914U, 1857U, 1864U, 
    927U, 934U, 293U, 1387U, 1365U, 573U, 703U, 1925U, 
    506U, 1555U, 1425U, 1775U, 1442U, 1333U, 197U, 1464U, 
    1718U, 1407U, 1792U, 171U, 337U, 240U, 218U, 229U, 
    488U, 1498U, 638U, 655U, 260U, 129U, 299U, 276U, 
    1392U, 1371U, 1909U, 1036U, 1892U, 1019U, 388U, 328U, 
    1574U, 149U, 1528U, 1834U, 189U, 1685U, 1673U, 1750U, 
    679U, 1827U, 1843U, 808U, 1317U, 1310U, 1188U, 1181U, 
    1565U, 1116U, 417U, 1100U, 380U, 1108U, 409U, 1092U, 
    372U, 1132U, 1124U, 695U, 687U, 247U, 116U, 907U, 
    110U, 1850U, 920U, 1871U, 1247U, 17U, 672U, 9U, 
    0U, 588U, 1819U, 161U, 709U, 723U, 1163U, 1172U, 
    1418U, 993U, 521U, 973U, 983U, 425U, 440U, 951U, 
    962U, 1157U, 732U, 1005U, 1878U, 1012U, 1885U, 1254U, 
    1625U, 1653U, 1632U, 1348U, 1951U, 555U, 1944U, 537U, 
    1199U, 1149U, 814U, 1457U, 1052U, 1784U, 1324U, 1729U, 
    1737U, 1802U, 1272U, 455U, 2001U, 2369U, 2762U, 3152U, 
    3542U, 3950U, 2172U, 2540U, 2933U, 3323U, 3698U, 4121U, 
    2088U, 2456U, 2849U, 3239U, 3621U, 4037U, 2259U, 2627U, 
    3020U, 3410U, 3785U, 4208U, 1983U, 2351U, 2744U, 3134U, 
    3524U, 3932U, 2154U, 2522U, 2915U, 3305U, 3680U, 4103U, 
    2072U, 2440U, 2833U, 3223U, 3605U, 4021U, 2243U, 2611U, 
    3004U, 3394U, 3769U, 4192U, 2308U, 1075U, 1232U, 2009U, 
    2377U, 2770U, 3160U, 3550U, 3958U, 2180U, 2548U, 2941U, 
    3331U, 3706U, 4129U, 2095U, 2463U, 2856U, 3246U, 3628U, 
    4044U, 2266U, 2634U, 3027U, 3417U, 3792U, 4215U, 1992U, 
    2360U, 2753U, 3143U, 3533U, 3941U, 2163U, 2531U, 2924U, 
    3314U, 3689U, 4112U, 2080U, 2448U, 2841U, 3231U, 3613U, 
    4029U, 2251U, 2619U, 3012U, 3402U, 3777U, 4200U, 2033U, 
    2401U, 2794U, 3184U, 3574U, 3982U, 2204U, 2572U, 2965U, 
    3355U, 3730U, 4153U, 2116U, 2484U, 2877U, 3267U, 3649U, 
    4065U, 2287U, 2655U, 3048U, 3438U, 3813U, 4236U, 2041U, 
    2409U, 2802U, 3192U, 3582U, 3990U, 2212U, 2580U, 2973U, 
    3363U, 3738U, 4161U, 2123U, 2491U, 2884U, 3274U, 3656U, 
    4072U, 2294U, 2662U, 3055U, 3445U, 3820U, 4243U, 2325U, 
    2718U, 3906U, 2328U, 2721U, 3111U, 3501U, 3909U, 2017U, 
    2385U, 2778U, 3168U, 3558U, 3966U, 2188U, 2556U, 2949U, 
    3339U, 3714U, 4137U, 2102U, 2470U, 2863U, 3253U, 3635U, 
    4051U, 2273U, 2641U, 3034U, 3424U, 3799U, 4222U, 2000U, 
    2368U, 2761U, 3151U, 3541U, 3949U, 2171U, 2539U, 2932U, 
    3322U, 3697U, 4120U, 2087U, 2455U, 2848U, 3238U, 3620U, 
    4036U, 2258U, 2626U, 3019U, 3409U, 3784U, 4207U, 145U, 
    1195U, 2049U, 2417U, 2810U, 3200U, 3998U, 2220U, 2588U, 
    2981U, 3371U, 3746U, 4169U, 2130U, 2498U, 2891U, 3281U, 
    4079U, 2301U, 2669U, 3062U, 3452U, 3827U, 4250U, 80U, 
    91U, 3864U, 1958U, 2317U, 3856U, 3899U, 1597U, 718U, 
    2676U, 3069U, 3459U, 3834U, 2706U, 3099U, 3489U, 3887U, 
    2691U, 3084U, 3474U, 3849U, 2712U, 3105U, 3495U, 3893U, 
    31U, 64U, 2698U, 3091U, 3481U, 3871U, 1966U, 2334U, 
    2727U, 3117U, 3507U, 3915U, 2137U, 2505U, 2898U, 3288U, 
    3663U, 4086U, 2057U, 2425U, 2818U, 3208U, 3590U, 4006U, 
    2228U, 2596U, 2989U, 3379U, 3754U, 4177U, 1974U, 2342U, 
    2735U, 3125U, 3515U, 3923U, 2145U, 2513U, 2906U, 3296U, 
    3671U, 4094U, 2064U, 2432U, 2825U, 3215U, 3597U, 4013U, 
    2235U, 2603U, 2996U, 3386U, 3761U, 4184U, 2683U, 3076U, 
    3466U, 3841U, 50U, 102U, 38U, 70U, 25U, 59U, 
    44U, 75U, 2025U, 2393U, 2786U, 3176U, 3566U, 3974U, 
    2196U, 2564U, 2957U, 3347U, 3722U, 4145U, 2109U, 2477U, 
    2870U, 3260U, 3642U, 4058U, 2280U, 2648U, 3041U, 3431U, 
    3806U, 4229U, 3879U, 
};

static inline void InitMSP430MCInstrInfo(MCInstrInfo *II) {
  II->InitMCInstrInfo(MSP430Insts, MSP430InstrNameIndices, MSP430InstrNameData, 507);
}

} // end llvm namespace
#endif // GET_INSTRINFO_MC_DESC

#ifdef GET_INSTRINFO_HEADER
#undef GET_INSTRINFO_HEADER
namespace llvm {
struct MSP430GenInstrInfo : public TargetInstrInfo {
  explicit MSP430GenInstrInfo(int CFSetupOpcode = -1, int CFDestroyOpcode = -1, int CatchRetOpcode = -1, int ReturnOpcode = -1);
  ~MSP430GenInstrInfo() override = default;

};
} // end llvm namespace
#endif // GET_INSTRINFO_HEADER

#ifdef GET_INSTRINFO_HELPER_DECLS
#undef GET_INSTRINFO_HELPER_DECLS


#endif // GET_INSTRINFO_HELPER_DECLS

#ifdef GET_INSTRINFO_HELPERS
#undef GET_INSTRINFO_HELPERS

#endif // GET_INSTRINFO_HELPERS

#ifdef GET_INSTRINFO_CTOR_DTOR
#undef GET_INSTRINFO_CTOR_DTOR
namespace llvm {
extern const MCInstrDesc MSP430Insts[];
extern const unsigned MSP430InstrNameIndices[];
extern const char MSP430InstrNameData[];
MSP430GenInstrInfo::MSP430GenInstrInfo(int CFSetupOpcode, int CFDestroyOpcode, int CatchRetOpcode, int ReturnOpcode)
  : TargetInstrInfo(CFSetupOpcode, CFDestroyOpcode, CatchRetOpcode, ReturnOpcode) {
  InitMCInstrInfo(MSP430Insts, MSP430InstrNameIndices, MSP430InstrNameData, 507);
}
} // end llvm namespace
#endif // GET_INSTRINFO_CTOR_DTOR

#ifdef GET_INSTRINFO_OPERAND_ENUM
#undef GET_INSTRINFO_OPERAND_ENUM
namespace llvm {
namespace MSP430 {
namespace OpName {
enum {
OPERAND_LAST
};
} // end namespace OpName
} // end namespace MSP430
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_ENUM

#ifdef GET_INSTRINFO_NAMED_OPS
#undef GET_INSTRINFO_NAMED_OPS
namespace llvm {
namespace MSP430 {
LLVM_READONLY
int16_t getNamedOperandIdx(uint16_t Opcode, uint16_t NamedIdx) {
  return -1;
}
} // end namespace MSP430
} // end namespace llvm
#endif //GET_INSTRINFO_NAMED_OPS

#ifdef GET_INSTRINFO_OPERAND_TYPES_ENUM
#undef GET_INSTRINFO_OPERAND_TYPES_ENUM
namespace llvm {
namespace MSP430 {
namespace OpTypes {
enum OperandType {
  cc = 0,
  cg16imm = 1,
  cg8imm = 2,
  f32imm = 3,
  f64imm = 4,
  i16imm = 5,
  i1imm = 6,
  i32imm = 7,
  i64imm = 8,
  i8imm = 9,
  indreg = 10,
  jmptarget = 11,
  memdst = 12,
  memsrc = 13,
  postreg = 14,
  ptype0 = 15,
  ptype1 = 16,
  ptype2 = 17,
  ptype3 = 18,
  ptype4 = 19,
  ptype5 = 20,
  type0 = 21,
  type1 = 22,
  type2 = 23,
  type3 = 24,
  type4 = 25,
  type5 = 26,
  OPERAND_TYPE_LIST_END
};
} // end namespace OpTypes
} // end namespace MSP430
} // end namespace llvm
#endif // GET_INSTRINFO_OPERAND_TYPES_ENUM

#ifdef GET_INSTRINFO_OPERAND_TYPE
#undef GET_INSTRINFO_OPERAND_TYPE
namespace llvm {
namespace MSP430 {
LLVM_READONLY
int getOperandType(uint16_t Opcode, uint16_t OpIdx) {
  const int Offsets[] = {
    0,
    1,
    1,
    1,
    2,
    3,
    4,
    5,
    5,
    8,
    12,
    13,
    17,
    20,
    20,
    21,
    23,
    25,
    25,
    26,
    27,
    29,
    29,
    35,
    36,
    36,
    38,
    39,
    39,
    39,
    39,
    39,
    39,
    41,
    44,
    44,
    47,
    50,
    53,
    56,
    59,
    62,
    65,
    68,
    71,
    74,
    75,
    76,
    78,
    80,
    83,
    85,
    89,
    91,
    93,
    95,
    97,
    99,
    101,
    103,
    105,
    107,
    109,
    111,
    113,
    115,
    120,
    124,
    127,
    130,
    133,
    136,
    139,
    142,
    145,
    148,
    151,
    154,
    157,
    159,
    161,
    162,
    163,
    164,
    166,
    168,
    170,
    172,
    173,
    176,
    178,
    180,
    183,
    186,
    189,
    193,
    197,
    201,
    205,
    210,
    214,
    219,
    223,
    228,
    232,
    237,
    241,
    245,
    248,
    251,
    254,
    257,
    260,
    264,
    267,
    270,
    273,
    275,
    277,
    279,
    281,
    283,
    285,
    287,
    289,
    291,
    293,
    295,
    297,
    299,
    302,
    304,
    307,
    310,
    313,
    316,
    319,
    322,
    325,
    328,
    331,
    334,
    337,
    340,
    341,
    344,
    348,
    351,
    355,
    357,
    359,
    361,
    363,
    365,
    367,
    369,
    371,
    373,
    375,
    377,
    379,
    381,
    383,
    385,
    387,
    390,
    393,
    397,
    400,
    403,
    406,
    409,
    412,
    416,
    419,
    423,
    426,
    429,
    432,
    436,
    439,
    442,
    445,
    448,
    451,
    455,
    458,
    462,
    465,
    468,
    471,
    475,
    478,
    481,
    484,
    487,
    490,
    494,
    497,
    501,
    504,
    507,
    510,
    514,
    517,
    520,
    523,
    526,
    529,
    533,
    536,
    540,
    543,
    546,
    548,
    550,
    553,
    556,
    560,
    563,
    566,
    569,
    572,
    575,
    579,
    582,
    586,
    589,
    592,
    595,
    599,
    602,
    605,
    608,
    611,
    614,
    618,
    621,
    625,
    628,
    631,
    634,
    638,
    641,
    644,
    647,
    650,
    653,
    657,
    660,
    664,
    667,
    670,
    673,
    677,
    680,
    683,
    686,
    689,
    692,
    696,
    699,
    703,
    706,
    709,
    712,
    716,
    719,
    722,
    725,
    728,
    731,
    735,
    738,
    742,
    745,
    748,
    751,
    755,
    758,
    761,
    764,
    767,
    770,
    774,
    777,
    781,
    784,
    787,
    790,
    794,
    797,
    800,
    803,
    805,
    807,
    810,
    812,
    814,
    816,
    819,
    822,
    826,
    829,
    832,
    835,
    837,
    839,
    842,
    844,
    846,
    848,
    849,
    851,
    852,
    853,
    855,
    856,
    857,
    858,
    861,
    864,
    868,
    871,
    874,
    877,
    879,
    881,
    884,
    886,
    888,
    890,
    893,
    896,
    900,
    903,
    906,
    909,
    911,
    913,
    916,
    918,
    920,
    922,
    925,
    928,
    932,
    935,
    938,
    941,
    944,
    947,
    951,
    954,
    958,
    961,
    964,
    967,
    971,
    974,
    977,
    980,
    983,
    986,
    990,
    993,
    997,
    1000,
    1002,
    1003,
    1006,
    1009,
    1013,
    1016,
    1019,
    1021,
    1023,
    1026,
    1028,
    1031,
    1033,
    1036,
    1039,
    1043,
    1046,
    1049,
    1051,
    1053,
    1056,
    1058,
    1061,
    1063,
    1066,
    1068,
    1069,
    1070,
    1071,
    1072,
    1073,
    1073,
    1073,
    1075,
    1076,
    1077,
    1079,
    1081,
    1082,
    1083,
    1085,
    1087,
    1088,
    1089,
    1091,
    1093,
    1094,
    1095,
    1097,
    1099,
    1101,
    1103,
    1104,
    1105,
    1107,
    1110,
    1113,
    1117,
    1120,
    1123,
    1126,
    1129,
    1132,
    1136,
    1139,
    1143,
    1146,
    1149,
    1152,
    1156,
    1159,
    1162,
    1165,
    1168,
    1171,
    1175,
    1178,
    1182,
    1185,
    1188,
    1191,
    1195,
    1198,
    1201,
    1204,
    1207,
    1210,
    1214,
    1217,
    1221,
    1224,
    1227,
    1230,
    1234,
    1237,
    1240,
    1243,
    1246,
    1249,
    1253,
    1256,
    1260,
    1263,
    1265,
    1266,
    1267,
    1269,
    1273,
    1277,
    1280,
    1283,
    1286,
    1289,
    1292,
    1295,
    1298,
    1301,
    1305,
    1308,
    1311,
    1314,
    1317,
    1320,
    1324,
    1327,
    1331,
    1334,
    1337,
    1340,
    1344,
    1347,
    1350,
    1353,
    1356,
    1359,
    1363,
    1366,
    1370,
    1373,
  };
  const int OpcodeOperandTypes[] = {
    -1, 
    /**/
    /**/
    OpTypes::i32imm, 
    OpTypes::i32imm, 
    OpTypes::i32imm, 
    OpTypes::i32imm, 
    /**/
    -1, -1, OpTypes::i32imm, 
    -1, -1, -1, OpTypes::i32imm, 
    -1, 
    -1, -1, -1, OpTypes::i32imm, 
    -1, -1, OpTypes::i32imm, 
    /**/
    -1, 
    -1, -1, 
    -1, -1, 
    /**/
    OpTypes::i32imm, 
    OpTypes::i32imm, 
    OpTypes::i64imm, OpTypes::i32imm, 
    /**/
    -1, OpTypes::i64imm, OpTypes::i32imm, -1, OpTypes::i32imm, OpTypes::i32imm, 
    -1, 
    /**/
    -1, OpTypes::i32imm, 
    -1, 
    /**/
    /**/
    /**/
    /**/
    /**/
    -1, OpTypes::i8imm, 
    OpTypes::i16imm, -1, OpTypes::i32imm, 
    /**/
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, 
    OpTypes::type0, 
    OpTypes::type0, -1, 
    OpTypes::type0, -1, 
    OpTypes::type0, OpTypes::type1, -1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, -1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, 
    OpTypes::type0, OpTypes::ptype1, 
    OpTypes::type0, OpTypes::ptype1, 
    OpTypes::type0, OpTypes::ptype1, 
    OpTypes::type0, OpTypes::type1, OpTypes::type2, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::type0, OpTypes::ptype1, OpTypes::type0, 
    OpTypes::i32imm, OpTypes::i32imm, 
    OpTypes::type0, -1, 
    OpTypes::type0, 
    -1, 
    -1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, -1, 
    OpTypes::type0, -1, 
    OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, -1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, -1, OpTypes::type1, OpTypes::type1, 
    OpTypes::type0, -1, OpTypes::type1, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, -1, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, OpTypes::type0, 
    -1, 
    OpTypes::ptype0, -1, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, OpTypes::type1, OpTypes::type2, 
    OpTypes::type0, OpTypes::type1, OpTypes::type2, 
    OpTypes::type0, OpTypes::type1, OpTypes::type1, OpTypes::type2, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type0, 
    OpTypes::type0, OpTypes::type1, 
    OpTypes::type0, -1, 
    OpTypes::type0, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    OpTypes::i16imm, OpTypes::i16imm, 
    OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::cg8imm, 
    -1, OpTypes::i8imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    OpTypes::i16imm, 
    -1, OpTypes::i16imm, 
    -1, 
    OpTypes::i16imm, 
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::cg8imm, 
    -1, OpTypes::i8imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    OpTypes::jmptarget, OpTypes::cc, 
    OpTypes::jmptarget, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::cg8imm, 
    -1, OpTypes::i8imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, 
    -1, 
    OpTypes::cg16imm, 
    OpTypes::i16imm, 
    -1, 
    -1, 
    /**/
    /**/
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, -1, 
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, -1, 
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, -1, 
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i8imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg16imm, 
    -1, OpTypes::i16imm, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg16imm, 
    -1, -1, OpTypes::i16imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::i16imm, OpTypes::cg8imm, 
    -1, OpTypes::i16imm, OpTypes::i8imm, 
    -1, OpTypes::i16imm, -1, OpTypes::i16imm, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, OpTypes::i16imm, -1, 
    -1, -1, OpTypes::cg8imm, 
    -1, -1, OpTypes::i8imm, 
    -1, -1, -1, OpTypes::i16imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
  };
  return OpcodeOperandTypes[Offsets[Opcode] + OpIdx];
}
} // end namespace MSP430
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_TYPE

