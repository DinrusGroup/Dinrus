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

namespace Mips {
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
    ABSMacro	= 164,
    ADJCALLSTACKDOWN	= 165,
    ADJCALLSTACKUP	= 166,
    AND_V_D_PSEUDO	= 167,
    AND_V_H_PSEUDO	= 168,
    AND_V_W_PSEUDO	= 169,
    ATOMIC_CMP_SWAP_I16	= 170,
    ATOMIC_CMP_SWAP_I16_POSTRA	= 171,
    ATOMIC_CMP_SWAP_I32	= 172,
    ATOMIC_CMP_SWAP_I32_POSTRA	= 173,
    ATOMIC_CMP_SWAP_I64	= 174,
    ATOMIC_CMP_SWAP_I64_POSTRA	= 175,
    ATOMIC_CMP_SWAP_I8	= 176,
    ATOMIC_CMP_SWAP_I8_POSTRA	= 177,
    ATOMIC_LOAD_ADD_I16	= 178,
    ATOMIC_LOAD_ADD_I16_POSTRA	= 179,
    ATOMIC_LOAD_ADD_I32	= 180,
    ATOMIC_LOAD_ADD_I32_POSTRA	= 181,
    ATOMIC_LOAD_ADD_I64	= 182,
    ATOMIC_LOAD_ADD_I64_POSTRA	= 183,
    ATOMIC_LOAD_ADD_I8	= 184,
    ATOMIC_LOAD_ADD_I8_POSTRA	= 185,
    ATOMIC_LOAD_AND_I16	= 186,
    ATOMIC_LOAD_AND_I16_POSTRA	= 187,
    ATOMIC_LOAD_AND_I32	= 188,
    ATOMIC_LOAD_AND_I32_POSTRA	= 189,
    ATOMIC_LOAD_AND_I64	= 190,
    ATOMIC_LOAD_AND_I64_POSTRA	= 191,
    ATOMIC_LOAD_AND_I8	= 192,
    ATOMIC_LOAD_AND_I8_POSTRA	= 193,
    ATOMIC_LOAD_NAND_I16	= 194,
    ATOMIC_LOAD_NAND_I16_POSTRA	= 195,
    ATOMIC_LOAD_NAND_I32	= 196,
    ATOMIC_LOAD_NAND_I32_POSTRA	= 197,
    ATOMIC_LOAD_NAND_I64	= 198,
    ATOMIC_LOAD_NAND_I64_POSTRA	= 199,
    ATOMIC_LOAD_NAND_I8	= 200,
    ATOMIC_LOAD_NAND_I8_POSTRA	= 201,
    ATOMIC_LOAD_OR_I16	= 202,
    ATOMIC_LOAD_OR_I16_POSTRA	= 203,
    ATOMIC_LOAD_OR_I32	= 204,
    ATOMIC_LOAD_OR_I32_POSTRA	= 205,
    ATOMIC_LOAD_OR_I64	= 206,
    ATOMIC_LOAD_OR_I64_POSTRA	= 207,
    ATOMIC_LOAD_OR_I8	= 208,
    ATOMIC_LOAD_OR_I8_POSTRA	= 209,
    ATOMIC_LOAD_SUB_I16	= 210,
    ATOMIC_LOAD_SUB_I16_POSTRA	= 211,
    ATOMIC_LOAD_SUB_I32	= 212,
    ATOMIC_LOAD_SUB_I32_POSTRA	= 213,
    ATOMIC_LOAD_SUB_I64	= 214,
    ATOMIC_LOAD_SUB_I64_POSTRA	= 215,
    ATOMIC_LOAD_SUB_I8	= 216,
    ATOMIC_LOAD_SUB_I8_POSTRA	= 217,
    ATOMIC_LOAD_XOR_I16	= 218,
    ATOMIC_LOAD_XOR_I16_POSTRA	= 219,
    ATOMIC_LOAD_XOR_I32	= 220,
    ATOMIC_LOAD_XOR_I32_POSTRA	= 221,
    ATOMIC_LOAD_XOR_I64	= 222,
    ATOMIC_LOAD_XOR_I64_POSTRA	= 223,
    ATOMIC_LOAD_XOR_I8	= 224,
    ATOMIC_LOAD_XOR_I8_POSTRA	= 225,
    ATOMIC_SWAP_I16	= 226,
    ATOMIC_SWAP_I16_POSTRA	= 227,
    ATOMIC_SWAP_I32	= 228,
    ATOMIC_SWAP_I32_POSTRA	= 229,
    ATOMIC_SWAP_I64	= 230,
    ATOMIC_SWAP_I64_POSTRA	= 231,
    ATOMIC_SWAP_I8	= 232,
    ATOMIC_SWAP_I8_POSTRA	= 233,
    B	= 234,
    BAL_BR	= 235,
    BAL_BR_MM	= 236,
    BEQLImmMacro	= 237,
    BGE	= 238,
    BGEImmMacro	= 239,
    BGEL	= 240,
    BGELImmMacro	= 241,
    BGEU	= 242,
    BGEUImmMacro	= 243,
    BGEUL	= 244,
    BGEULImmMacro	= 245,
    BGT	= 246,
    BGTImmMacro	= 247,
    BGTL	= 248,
    BGTLImmMacro	= 249,
    BGTU	= 250,
    BGTUImmMacro	= 251,
    BGTUL	= 252,
    BGTULImmMacro	= 253,
    BLE	= 254,
    BLEImmMacro	= 255,
    BLEL	= 256,
    BLELImmMacro	= 257,
    BLEU	= 258,
    BLEUImmMacro	= 259,
    BLEUL	= 260,
    BLEULImmMacro	= 261,
    BLT	= 262,
    BLTImmMacro	= 263,
    BLTL	= 264,
    BLTLImmMacro	= 265,
    BLTU	= 266,
    BLTUImmMacro	= 267,
    BLTUL	= 268,
    BLTULImmMacro	= 269,
    BNELImmMacro	= 270,
    BPOSGE32_PSEUDO	= 271,
    BSEL_D_PSEUDO	= 272,
    BSEL_FD_PSEUDO	= 273,
    BSEL_FW_PSEUDO	= 274,
    BSEL_H_PSEUDO	= 275,
    BSEL_W_PSEUDO	= 276,
    B_MM	= 277,
    B_MMR6_Pseudo	= 278,
    B_MM_Pseudo	= 279,
    BeqImm	= 280,
    BneImm	= 281,
    BteqzT8CmpX16	= 282,
    BteqzT8CmpiX16	= 283,
    BteqzT8SltX16	= 284,
    BteqzT8SltiX16	= 285,
    BteqzT8SltiuX16	= 286,
    BteqzT8SltuX16	= 287,
    BtnezT8CmpX16	= 288,
    BtnezT8CmpiX16	= 289,
    BtnezT8SltX16	= 290,
    BtnezT8SltiX16	= 291,
    BtnezT8SltiuX16	= 292,
    BtnezT8SltuX16	= 293,
    BuildPairF64	= 294,
    BuildPairF64_64	= 295,
    CFTC1	= 296,
    CONSTPOOL_ENTRY	= 297,
    COPY_FD_PSEUDO	= 298,
    COPY_FW_PSEUDO	= 299,
    CTTC1	= 300,
    Constant32	= 301,
    DMULImmMacro	= 302,
    DMULMacro	= 303,
    DMULOMacro	= 304,
    DMULOUMacro	= 305,
    DROL	= 306,
    DROLImm	= 307,
    DROR	= 308,
    DRORImm	= 309,
    DSDivIMacro	= 310,
    DSDivMacro	= 311,
    DSRemIMacro	= 312,
    DSRemMacro	= 313,
    DUDivIMacro	= 314,
    DUDivMacro	= 315,
    DURemIMacro	= 316,
    DURemMacro	= 317,
    ERet	= 318,
    ExtractElementF64	= 319,
    ExtractElementF64_64	= 320,
    FABS_D	= 321,
    FABS_W	= 322,
    FEXP2_D_1_PSEUDO	= 323,
    FEXP2_W_1_PSEUDO	= 324,
    FILL_FD_PSEUDO	= 325,
    FILL_FW_PSEUDO	= 326,
    GotPrologue16	= 327,
    INSERT_B_VIDX64_PSEUDO	= 328,
    INSERT_B_VIDX_PSEUDO	= 329,
    INSERT_D_VIDX64_PSEUDO	= 330,
    INSERT_D_VIDX_PSEUDO	= 331,
    INSERT_FD_PSEUDO	= 332,
    INSERT_FD_VIDX64_PSEUDO	= 333,
    INSERT_FD_VIDX_PSEUDO	= 334,
    INSERT_FW_PSEUDO	= 335,
    INSERT_FW_VIDX64_PSEUDO	= 336,
    INSERT_FW_VIDX_PSEUDO	= 337,
    INSERT_H_VIDX64_PSEUDO	= 338,
    INSERT_H_VIDX_PSEUDO	= 339,
    INSERT_W_VIDX64_PSEUDO	= 340,
    INSERT_W_VIDX_PSEUDO	= 341,
    JALR64Pseudo	= 342,
    JALRHB64Pseudo	= 343,
    JALRHBPseudo	= 344,
    JALRPseudo	= 345,
    JAL_MMR6	= 346,
    JalOneReg	= 347,
    JalTwoReg	= 348,
    LDMacro	= 349,
    LD_F16	= 350,
    LOAD_ACC128	= 351,
    LOAD_ACC64	= 352,
    LOAD_ACC64DSP	= 353,
    LOAD_CCOND_DSP	= 354,
    LONG_BRANCH_ADDiu	= 355,
    LONG_BRANCH_ADDiu2Op	= 356,
    LONG_BRANCH_DADDiu	= 357,
    LONG_BRANCH_DADDiu2Op	= 358,
    LONG_BRANCH_LUi	= 359,
    LONG_BRANCH_LUi2Op	= 360,
    LONG_BRANCH_LUi2Op_64	= 361,
    LWM_MM	= 362,
    LoadAddrImm32	= 363,
    LoadAddrImm64	= 364,
    LoadAddrReg32	= 365,
    LoadAddrReg64	= 366,
    LoadImm32	= 367,
    LoadImm64	= 368,
    LoadImmDoubleFGR	= 369,
    LoadImmDoubleFGR_32	= 370,
    LoadImmDoubleGPR	= 371,
    LoadImmSingleFGR	= 372,
    LoadImmSingleGPR	= 373,
    LwConstant32	= 374,
    MFTACX	= 375,
    MFTC0	= 376,
    MFTC1	= 377,
    MFTDSP	= 378,
    MFTGPR	= 379,
    MFTHC1	= 380,
    MFTHI	= 381,
    MFTLO	= 382,
    MIPSeh_return32	= 383,
    MIPSeh_return64	= 384,
    MSA_FP_EXTEND_D_PSEUDO	= 385,
    MSA_FP_EXTEND_W_PSEUDO	= 386,
    MSA_FP_ROUND_D_PSEUDO	= 387,
    MSA_FP_ROUND_W_PSEUDO	= 388,
    MTTACX	= 389,
    MTTC0	= 390,
    MTTC1	= 391,
    MTTDSP	= 392,
    MTTGPR	= 393,
    MTTHC1	= 394,
    MTTHI	= 395,
    MTTLO	= 396,
    MULImmMacro	= 397,
    MULOMacro	= 398,
    MULOUMacro	= 399,
    MultRxRy16	= 400,
    MultRxRyRz16	= 401,
    MultuRxRy16	= 402,
    MultuRxRyRz16	= 403,
    NOP	= 404,
    NORImm	= 405,
    NORImm64	= 406,
    NOR_V_D_PSEUDO	= 407,
    NOR_V_H_PSEUDO	= 408,
    NOR_V_W_PSEUDO	= 409,
    OR_V_D_PSEUDO	= 410,
    OR_V_H_PSEUDO	= 411,
    OR_V_W_PSEUDO	= 412,
    PseudoCMPU_EQ_QB	= 413,
    PseudoCMPU_LE_QB	= 414,
    PseudoCMPU_LT_QB	= 415,
    PseudoCMP_EQ_PH	= 416,
    PseudoCMP_LE_PH	= 417,
    PseudoCMP_LT_PH	= 418,
    PseudoCVT_D32_W	= 419,
    PseudoCVT_D64_L	= 420,
    PseudoCVT_D64_W	= 421,
    PseudoCVT_S_L	= 422,
    PseudoCVT_S_W	= 423,
    PseudoDMULT	= 424,
    PseudoDMULTu	= 425,
    PseudoDSDIV	= 426,
    PseudoDUDIV	= 427,
    PseudoD_SELECT_I	= 428,
    PseudoD_SELECT_I64	= 429,
    PseudoIndirectBranch	= 430,
    PseudoIndirectBranch64	= 431,
    PseudoIndirectBranch64R6	= 432,
    PseudoIndirectBranchR6	= 433,
    PseudoIndirectBranch_MM	= 434,
    PseudoIndirectBranch_MMR6	= 435,
    PseudoIndirectHazardBranch	= 436,
    PseudoIndirectHazardBranch64	= 437,
    PseudoIndrectHazardBranch64R6	= 438,
    PseudoIndrectHazardBranchR6	= 439,
    PseudoMADD	= 440,
    PseudoMADDU	= 441,
    PseudoMADDU_MM	= 442,
    PseudoMADD_MM	= 443,
    PseudoMFHI	= 444,
    PseudoMFHI64	= 445,
    PseudoMFHI_MM	= 446,
    PseudoMFLO	= 447,
    PseudoMFLO64	= 448,
    PseudoMFLO_MM	= 449,
    PseudoMSUB	= 450,
    PseudoMSUBU	= 451,
    PseudoMSUBU_MM	= 452,
    PseudoMSUB_MM	= 453,
    PseudoMTLOHI	= 454,
    PseudoMTLOHI64	= 455,
    PseudoMTLOHI_DSP	= 456,
    PseudoMTLOHI_MM	= 457,
    PseudoMULT	= 458,
    PseudoMULT_MM	= 459,
    PseudoMULTu	= 460,
    PseudoMULTu_MM	= 461,
    PseudoPICK_PH	= 462,
    PseudoPICK_QB	= 463,
    PseudoReturn	= 464,
    PseudoReturn64	= 465,
    PseudoSDIV	= 466,
    PseudoSELECTFP_F_D32	= 467,
    PseudoSELECTFP_F_D64	= 468,
    PseudoSELECTFP_F_I	= 469,
    PseudoSELECTFP_F_I64	= 470,
    PseudoSELECTFP_F_S	= 471,
    PseudoSELECTFP_T_D32	= 472,
    PseudoSELECTFP_T_D64	= 473,
    PseudoSELECTFP_T_I	= 474,
    PseudoSELECTFP_T_I64	= 475,
    PseudoSELECTFP_T_S	= 476,
    PseudoSELECT_D32	= 477,
    PseudoSELECT_D64	= 478,
    PseudoSELECT_I	= 479,
    PseudoSELECT_I64	= 480,
    PseudoSELECT_S	= 481,
    PseudoTRUNC_W_D	= 482,
    PseudoTRUNC_W_D32	= 483,
    PseudoTRUNC_W_S	= 484,
    PseudoUDIV	= 485,
    ROL	= 486,
    ROLImm	= 487,
    ROR	= 488,
    RORImm	= 489,
    RetRA	= 490,
    RetRA16	= 491,
    SDC1_M1	= 492,
    SDIV_MM_Pseudo	= 493,
    SDMacro	= 494,
    SDivIMacro	= 495,
    SDivMacro	= 496,
    SEQIMacro	= 497,
    SEQMacro	= 498,
    SGE	= 499,
    SGEImm	= 500,
    SGEImm64	= 501,
    SGEU	= 502,
    SGEUImm	= 503,
    SGEUImm64	= 504,
    SGTImm	= 505,
    SGTImm64	= 506,
    SGTUImm	= 507,
    SGTUImm64	= 508,
    SLTImm64	= 509,
    SLTUImm64	= 510,
    SNZ_B_PSEUDO	= 511,
    SNZ_D_PSEUDO	= 512,
    SNZ_H_PSEUDO	= 513,
    SNZ_V_PSEUDO	= 514,
    SNZ_W_PSEUDO	= 515,
    SRemIMacro	= 516,
    SRemMacro	= 517,
    STORE_ACC128	= 518,
    STORE_ACC64	= 519,
    STORE_ACC64DSP	= 520,
    STORE_CCOND_DSP	= 521,
    ST_F16	= 522,
    SWM_MM	= 523,
    SZ_B_PSEUDO	= 524,
    SZ_D_PSEUDO	= 525,
    SZ_H_PSEUDO	= 526,
    SZ_V_PSEUDO	= 527,
    SZ_W_PSEUDO	= 528,
    SelBeqZ	= 529,
    SelBneZ	= 530,
    SelTBteqZCmp	= 531,
    SelTBteqZCmpi	= 532,
    SelTBteqZSlt	= 533,
    SelTBteqZSlti	= 534,
    SelTBteqZSltiu	= 535,
    SelTBteqZSltu	= 536,
    SelTBtneZCmp	= 537,
    SelTBtneZCmpi	= 538,
    SelTBtneZSlt	= 539,
    SelTBtneZSlti	= 540,
    SelTBtneZSltiu	= 541,
    SelTBtneZSltu	= 542,
    SltCCRxRy16	= 543,
    SltiCCRxImmX16	= 544,
    SltiuCCRxImmX16	= 545,
    SltuCCRxRy16	= 546,
    SltuRxRyRz16	= 547,
    TAILCALL	= 548,
    TAILCALL64R6REG	= 549,
    TAILCALLHB64R6REG	= 550,
    TAILCALLHBR6REG	= 551,
    TAILCALLR6REG	= 552,
    TAILCALLREG	= 553,
    TAILCALLREG64	= 554,
    TAILCALLREGHB	= 555,
    TAILCALLREGHB64	= 556,
    TAILCALLREG_MM	= 557,
    TAILCALLREG_MMR6	= 558,
    TAILCALL_MM	= 559,
    TAILCALL_MMR6	= 560,
    TRAP	= 561,
    TRAP_MM	= 562,
    UDIV_MM_Pseudo	= 563,
    UDivIMacro	= 564,
    UDivMacro	= 565,
    URemIMacro	= 566,
    URemMacro	= 567,
    Ulh	= 568,
    Ulhu	= 569,
    Ulw	= 570,
    Ush	= 571,
    Usw	= 572,
    XOR_V_D_PSEUDO	= 573,
    XOR_V_H_PSEUDO	= 574,
    XOR_V_W_PSEUDO	= 575,
    ABSQ_S_PH	= 576,
    ABSQ_S_PH_MM	= 577,
    ABSQ_S_QB	= 578,
    ABSQ_S_QB_MMR2	= 579,
    ABSQ_S_W	= 580,
    ABSQ_S_W_MM	= 581,
    ADD	= 582,
    ADDIUPC	= 583,
    ADDIUPC_MM	= 584,
    ADDIUPC_MMR6	= 585,
    ADDIUR1SP_MM	= 586,
    ADDIUR2_MM	= 587,
    ADDIUS5_MM	= 588,
    ADDIUSP_MM	= 589,
    ADDIU_MMR6	= 590,
    ADDQH_PH	= 591,
    ADDQH_PH_MMR2	= 592,
    ADDQH_R_PH	= 593,
    ADDQH_R_PH_MMR2	= 594,
    ADDQH_R_W	= 595,
    ADDQH_R_W_MMR2	= 596,
    ADDQH_W	= 597,
    ADDQH_W_MMR2	= 598,
    ADDQ_PH	= 599,
    ADDQ_PH_MM	= 600,
    ADDQ_S_PH	= 601,
    ADDQ_S_PH_MM	= 602,
    ADDQ_S_W	= 603,
    ADDQ_S_W_MM	= 604,
    ADDSC	= 605,
    ADDSC_MM	= 606,
    ADDS_A_B	= 607,
    ADDS_A_D	= 608,
    ADDS_A_H	= 609,
    ADDS_A_W	= 610,
    ADDS_S_B	= 611,
    ADDS_S_D	= 612,
    ADDS_S_H	= 613,
    ADDS_S_W	= 614,
    ADDS_U_B	= 615,
    ADDS_U_D	= 616,
    ADDS_U_H	= 617,
    ADDS_U_W	= 618,
    ADDU16_MM	= 619,
    ADDU16_MMR6	= 620,
    ADDUH_QB	= 621,
    ADDUH_QB_MMR2	= 622,
    ADDUH_R_QB	= 623,
    ADDUH_R_QB_MMR2	= 624,
    ADDU_MMR6	= 625,
    ADDU_PH	= 626,
    ADDU_PH_MMR2	= 627,
    ADDU_QB	= 628,
    ADDU_QB_MM	= 629,
    ADDU_S_PH	= 630,
    ADDU_S_PH_MMR2	= 631,
    ADDU_S_QB	= 632,
    ADDU_S_QB_MM	= 633,
    ADDVI_B	= 634,
    ADDVI_D	= 635,
    ADDVI_H	= 636,
    ADDVI_W	= 637,
    ADDV_B	= 638,
    ADDV_D	= 639,
    ADDV_H	= 640,
    ADDV_W	= 641,
    ADDWC	= 642,
    ADDWC_MM	= 643,
    ADD_A_B	= 644,
    ADD_A_D	= 645,
    ADD_A_H	= 646,
    ADD_A_W	= 647,
    ADD_MM	= 648,
    ADD_MMR6	= 649,
    ADDi	= 650,
    ADDi_MM	= 651,
    ADDiu	= 652,
    ADDiu_MM	= 653,
    ADDu	= 654,
    ADDu_MM	= 655,
    ALIGN	= 656,
    ALIGN_MMR6	= 657,
    ALUIPC	= 658,
    ALUIPC_MMR6	= 659,
    AND	= 660,
    AND16_MM	= 661,
    AND16_MMR6	= 662,
    AND64	= 663,
    ANDI16_MM	= 664,
    ANDI16_MMR6	= 665,
    ANDI_B	= 666,
    ANDI_MMR6	= 667,
    AND_MM	= 668,
    AND_MMR6	= 669,
    AND_V	= 670,
    ANDi	= 671,
    ANDi64	= 672,
    ANDi_MM	= 673,
    APPEND	= 674,
    APPEND_MMR2	= 675,
    ASUB_S_B	= 676,
    ASUB_S_D	= 677,
    ASUB_S_H	= 678,
    ASUB_S_W	= 679,
    ASUB_U_B	= 680,
    ASUB_U_D	= 681,
    ASUB_U_H	= 682,
    ASUB_U_W	= 683,
    AUI	= 684,
    AUIPC	= 685,
    AUIPC_MMR6	= 686,
    AUI_MMR6	= 687,
    AVER_S_B	= 688,
    AVER_S_D	= 689,
    AVER_S_H	= 690,
    AVER_S_W	= 691,
    AVER_U_B	= 692,
    AVER_U_D	= 693,
    AVER_U_H	= 694,
    AVER_U_W	= 695,
    AVE_S_B	= 696,
    AVE_S_D	= 697,
    AVE_S_H	= 698,
    AVE_S_W	= 699,
    AVE_U_B	= 700,
    AVE_U_D	= 701,
    AVE_U_H	= 702,
    AVE_U_W	= 703,
    AddiuRxImmX16	= 704,
    AddiuRxPcImmX16	= 705,
    AddiuRxRxImm16	= 706,
    AddiuRxRxImmX16	= 707,
    AddiuRxRyOffMemX16	= 708,
    AddiuSpImm16	= 709,
    AddiuSpImmX16	= 710,
    AdduRxRyRz16	= 711,
    AndRxRxRy16	= 712,
    B16_MM	= 713,
    BADDu	= 714,
    BAL	= 715,
    BALC	= 716,
    BALC_MMR6	= 717,
    BALIGN	= 718,
    BALIGN_MMR2	= 719,
    BBIT0	= 720,
    BBIT032	= 721,
    BBIT1	= 722,
    BBIT132	= 723,
    BC	= 724,
    BC16_MMR6	= 725,
    BC1EQZ	= 726,
    BC1EQZC_MMR6	= 727,
    BC1F	= 728,
    BC1FL	= 729,
    BC1F_MM	= 730,
    BC1NEZ	= 731,
    BC1NEZC_MMR6	= 732,
    BC1T	= 733,
    BC1TL	= 734,
    BC1T_MM	= 735,
    BC2EQZ	= 736,
    BC2EQZC_MMR6	= 737,
    BC2NEZ	= 738,
    BC2NEZC_MMR6	= 739,
    BCLRI_B	= 740,
    BCLRI_D	= 741,
    BCLRI_H	= 742,
    BCLRI_W	= 743,
    BCLR_B	= 744,
    BCLR_D	= 745,
    BCLR_H	= 746,
    BCLR_W	= 747,
    BC_MMR6	= 748,
    BEQ	= 749,
    BEQ64	= 750,
    BEQC	= 751,
    BEQC64	= 752,
    BEQC_MMR6	= 753,
    BEQL	= 754,
    BEQZ16_MM	= 755,
    BEQZALC	= 756,
    BEQZALC_MMR6	= 757,
    BEQZC	= 758,
    BEQZC16_MMR6	= 759,
    BEQZC64	= 760,
    BEQZC_MM	= 761,
    BEQZC_MMR6	= 762,
    BEQ_MM	= 763,
    BGEC	= 764,
    BGEC64	= 765,
    BGEC_MMR6	= 766,
    BGEUC	= 767,
    BGEUC64	= 768,
    BGEUC_MMR6	= 769,
    BGEZ	= 770,
    BGEZ64	= 771,
    BGEZAL	= 772,
    BGEZALC	= 773,
    BGEZALC_MMR6	= 774,
    BGEZALL	= 775,
    BGEZALS_MM	= 776,
    BGEZAL_MM	= 777,
    BGEZC	= 778,
    BGEZC64	= 779,
    BGEZC_MMR6	= 780,
    BGEZL	= 781,
    BGEZ_MM	= 782,
    BGTZ	= 783,
    BGTZ64	= 784,
    BGTZALC	= 785,
    BGTZALC_MMR6	= 786,
    BGTZC	= 787,
    BGTZC64	= 788,
    BGTZC_MMR6	= 789,
    BGTZL	= 790,
    BGTZ_MM	= 791,
    BINSLI_B	= 792,
    BINSLI_D	= 793,
    BINSLI_H	= 794,
    BINSLI_W	= 795,
    BINSL_B	= 796,
    BINSL_D	= 797,
    BINSL_H	= 798,
    BINSL_W	= 799,
    BINSRI_B	= 800,
    BINSRI_D	= 801,
    BINSRI_H	= 802,
    BINSRI_W	= 803,
    BINSR_B	= 804,
    BINSR_D	= 805,
    BINSR_H	= 806,
    BINSR_W	= 807,
    BITREV	= 808,
    BITREV_MM	= 809,
    BITSWAP	= 810,
    BITSWAP_MMR6	= 811,
    BLEZ	= 812,
    BLEZ64	= 813,
    BLEZALC	= 814,
    BLEZALC_MMR6	= 815,
    BLEZC	= 816,
    BLEZC64	= 817,
    BLEZC_MMR6	= 818,
    BLEZL	= 819,
    BLEZ_MM	= 820,
    BLTC	= 821,
    BLTC64	= 822,
    BLTC_MMR6	= 823,
    BLTUC	= 824,
    BLTUC64	= 825,
    BLTUC_MMR6	= 826,
    BLTZ	= 827,
    BLTZ64	= 828,
    BLTZAL	= 829,
    BLTZALC	= 830,
    BLTZALC_MMR6	= 831,
    BLTZALL	= 832,
    BLTZALS_MM	= 833,
    BLTZAL_MM	= 834,
    BLTZC	= 835,
    BLTZC64	= 836,
    BLTZC_MMR6	= 837,
    BLTZL	= 838,
    BLTZ_MM	= 839,
    BMNZI_B	= 840,
    BMNZ_V	= 841,
    BMZI_B	= 842,
    BMZ_V	= 843,
    BNE	= 844,
    BNE64	= 845,
    BNEC	= 846,
    BNEC64	= 847,
    BNEC_MMR6	= 848,
    BNEGI_B	= 849,
    BNEGI_D	= 850,
    BNEGI_H	= 851,
    BNEGI_W	= 852,
    BNEG_B	= 853,
    BNEG_D	= 854,
    BNEG_H	= 855,
    BNEG_W	= 856,
    BNEL	= 857,
    BNEZ16_MM	= 858,
    BNEZALC	= 859,
    BNEZALC_MMR6	= 860,
    BNEZC	= 861,
    BNEZC16_MMR6	= 862,
    BNEZC64	= 863,
    BNEZC_MM	= 864,
    BNEZC_MMR6	= 865,
    BNE_MM	= 866,
    BNVC	= 867,
    BNVC_MMR6	= 868,
    BNZ_B	= 869,
    BNZ_D	= 870,
    BNZ_H	= 871,
    BNZ_V	= 872,
    BNZ_W	= 873,
    BOVC	= 874,
    BOVC_MMR6	= 875,
    BPOSGE32	= 876,
    BPOSGE32C_MMR3	= 877,
    BPOSGE32_MM	= 878,
    BREAK	= 879,
    BREAK16_MM	= 880,
    BREAK16_MMR6	= 881,
    BREAK_MM	= 882,
    BREAK_MMR6	= 883,
    BSELI_B	= 884,
    BSEL_V	= 885,
    BSETI_B	= 886,
    BSETI_D	= 887,
    BSETI_H	= 888,
    BSETI_W	= 889,
    BSET_B	= 890,
    BSET_D	= 891,
    BSET_H	= 892,
    BSET_W	= 893,
    BZ_B	= 894,
    BZ_D	= 895,
    BZ_H	= 896,
    BZ_V	= 897,
    BZ_W	= 898,
    BeqzRxImm16	= 899,
    BeqzRxImmX16	= 900,
    Bimm16	= 901,
    BimmX16	= 902,
    BnezRxImm16	= 903,
    BnezRxImmX16	= 904,
    Break16	= 905,
    Bteqz16	= 906,
    BteqzX16	= 907,
    Btnez16	= 908,
    BtnezX16	= 909,
    CACHE	= 910,
    CACHEE	= 911,
    CACHEE_MM	= 912,
    CACHE_MM	= 913,
    CACHE_MMR6	= 914,
    CACHE_R6	= 915,
    CEIL_L_D64	= 916,
    CEIL_L_D_MMR6	= 917,
    CEIL_L_S	= 918,
    CEIL_L_S_MMR6	= 919,
    CEIL_W_D32	= 920,
    CEIL_W_D64	= 921,
    CEIL_W_D_MMR6	= 922,
    CEIL_W_MM	= 923,
    CEIL_W_S	= 924,
    CEIL_W_S_MM	= 925,
    CEIL_W_S_MMR6	= 926,
    CEQI_B	= 927,
    CEQI_D	= 928,
    CEQI_H	= 929,
    CEQI_W	= 930,
    CEQ_B	= 931,
    CEQ_D	= 932,
    CEQ_H	= 933,
    CEQ_W	= 934,
    CFC1	= 935,
    CFC1_MM	= 936,
    CFC2_MM	= 937,
    CFCMSA	= 938,
    CINS	= 939,
    CINS32	= 940,
    CINS64_32	= 941,
    CINS_i32	= 942,
    CLASS_D	= 943,
    CLASS_D_MMR6	= 944,
    CLASS_S	= 945,
    CLASS_S_MMR6	= 946,
    CLEI_S_B	= 947,
    CLEI_S_D	= 948,
    CLEI_S_H	= 949,
    CLEI_S_W	= 950,
    CLEI_U_B	= 951,
    CLEI_U_D	= 952,
    CLEI_U_H	= 953,
    CLEI_U_W	= 954,
    CLE_S_B	= 955,
    CLE_S_D	= 956,
    CLE_S_H	= 957,
    CLE_S_W	= 958,
    CLE_U_B	= 959,
    CLE_U_D	= 960,
    CLE_U_H	= 961,
    CLE_U_W	= 962,
    CLO	= 963,
    CLO_MM	= 964,
    CLO_MMR6	= 965,
    CLO_R6	= 966,
    CLTI_S_B	= 967,
    CLTI_S_D	= 968,
    CLTI_S_H	= 969,
    CLTI_S_W	= 970,
    CLTI_U_B	= 971,
    CLTI_U_D	= 972,
    CLTI_U_H	= 973,
    CLTI_U_W	= 974,
    CLT_S_B	= 975,
    CLT_S_D	= 976,
    CLT_S_H	= 977,
    CLT_S_W	= 978,
    CLT_U_B	= 979,
    CLT_U_D	= 980,
    CLT_U_H	= 981,
    CLT_U_W	= 982,
    CLZ	= 983,
    CLZ_MM	= 984,
    CLZ_MMR6	= 985,
    CLZ_R6	= 986,
    CMPGDU_EQ_QB	= 987,
    CMPGDU_EQ_QB_MMR2	= 988,
    CMPGDU_LE_QB	= 989,
    CMPGDU_LE_QB_MMR2	= 990,
    CMPGDU_LT_QB	= 991,
    CMPGDU_LT_QB_MMR2	= 992,
    CMPGU_EQ_QB	= 993,
    CMPGU_EQ_QB_MM	= 994,
    CMPGU_LE_QB	= 995,
    CMPGU_LE_QB_MM	= 996,
    CMPGU_LT_QB	= 997,
    CMPGU_LT_QB_MM	= 998,
    CMPU_EQ_QB	= 999,
    CMPU_EQ_QB_MM	= 1000,
    CMPU_LE_QB	= 1001,
    CMPU_LE_QB_MM	= 1002,
    CMPU_LT_QB	= 1003,
    CMPU_LT_QB_MM	= 1004,
    CMP_AF_D_MMR6	= 1005,
    CMP_AF_S_MMR6	= 1006,
    CMP_EQ_D	= 1007,
    CMP_EQ_D_MMR6	= 1008,
    CMP_EQ_PH	= 1009,
    CMP_EQ_PH_MM	= 1010,
    CMP_EQ_S	= 1011,
    CMP_EQ_S_MMR6	= 1012,
    CMP_F_D	= 1013,
    CMP_F_S	= 1014,
    CMP_LE_D	= 1015,
    CMP_LE_D_MMR6	= 1016,
    CMP_LE_PH	= 1017,
    CMP_LE_PH_MM	= 1018,
    CMP_LE_S	= 1019,
    CMP_LE_S_MMR6	= 1020,
    CMP_LT_D	= 1021,
    CMP_LT_D_MMR6	= 1022,
    CMP_LT_PH	= 1023,
    CMP_LT_PH_MM	= 1024,
    CMP_LT_S	= 1025,
    CMP_LT_S_MMR6	= 1026,
    CMP_SAF_D	= 1027,
    CMP_SAF_D_MMR6	= 1028,
    CMP_SAF_S	= 1029,
    CMP_SAF_S_MMR6	= 1030,
    CMP_SEQ_D	= 1031,
    CMP_SEQ_D_MMR6	= 1032,
    CMP_SEQ_S	= 1033,
    CMP_SEQ_S_MMR6	= 1034,
    CMP_SLE_D	= 1035,
    CMP_SLE_D_MMR6	= 1036,
    CMP_SLE_S	= 1037,
    CMP_SLE_S_MMR6	= 1038,
    CMP_SLT_D	= 1039,
    CMP_SLT_D_MMR6	= 1040,
    CMP_SLT_S	= 1041,
    CMP_SLT_S_MMR6	= 1042,
    CMP_SUEQ_D	= 1043,
    CMP_SUEQ_D_MMR6	= 1044,
    CMP_SUEQ_S	= 1045,
    CMP_SUEQ_S_MMR6	= 1046,
    CMP_SULE_D	= 1047,
    CMP_SULE_D_MMR6	= 1048,
    CMP_SULE_S	= 1049,
    CMP_SULE_S_MMR6	= 1050,
    CMP_SULT_D	= 1051,
    CMP_SULT_D_MMR6	= 1052,
    CMP_SULT_S	= 1053,
    CMP_SULT_S_MMR6	= 1054,
    CMP_SUN_D	= 1055,
    CMP_SUN_D_MMR6	= 1056,
    CMP_SUN_S	= 1057,
    CMP_SUN_S_MMR6	= 1058,
    CMP_UEQ_D	= 1059,
    CMP_UEQ_D_MMR6	= 1060,
    CMP_UEQ_S	= 1061,
    CMP_UEQ_S_MMR6	= 1062,
    CMP_ULE_D	= 1063,
    CMP_ULE_D_MMR6	= 1064,
    CMP_ULE_S	= 1065,
    CMP_ULE_S_MMR6	= 1066,
    CMP_ULT_D	= 1067,
    CMP_ULT_D_MMR6	= 1068,
    CMP_ULT_S	= 1069,
    CMP_ULT_S_MMR6	= 1070,
    CMP_UN_D	= 1071,
    CMP_UN_D_MMR6	= 1072,
    CMP_UN_S	= 1073,
    CMP_UN_S_MMR6	= 1074,
    COPY_S_B	= 1075,
    COPY_S_D	= 1076,
    COPY_S_H	= 1077,
    COPY_S_W	= 1078,
    COPY_U_B	= 1079,
    COPY_U_H	= 1080,
    COPY_U_W	= 1081,
    CRC32B	= 1082,
    CRC32CB	= 1083,
    CRC32CD	= 1084,
    CRC32CH	= 1085,
    CRC32CW	= 1086,
    CRC32D	= 1087,
    CRC32H	= 1088,
    CRC32W	= 1089,
    CTC1	= 1090,
    CTC1_MM	= 1091,
    CTC2_MM	= 1092,
    CTCMSA	= 1093,
    CVT_D32_S	= 1094,
    CVT_D32_S_MM	= 1095,
    CVT_D32_W	= 1096,
    CVT_D32_W_MM	= 1097,
    CVT_D64_L	= 1098,
    CVT_D64_S	= 1099,
    CVT_D64_S_MM	= 1100,
    CVT_D64_W	= 1101,
    CVT_D64_W_MM	= 1102,
    CVT_D_L_MMR6	= 1103,
    CVT_L_D64	= 1104,
    CVT_L_D64_MM	= 1105,
    CVT_L_D_MMR6	= 1106,
    CVT_L_S	= 1107,
    CVT_L_S_MM	= 1108,
    CVT_L_S_MMR6	= 1109,
    CVT_PS_S64	= 1110,
    CVT_S_D32	= 1111,
    CVT_S_D32_MM	= 1112,
    CVT_S_D64	= 1113,
    CVT_S_D64_MM	= 1114,
    CVT_S_L	= 1115,
    CVT_S_L_MMR6	= 1116,
    CVT_S_PL64	= 1117,
    CVT_S_PU64	= 1118,
    CVT_S_W	= 1119,
    CVT_S_W_MM	= 1120,
    CVT_S_W_MMR6	= 1121,
    CVT_W_D32	= 1122,
    CVT_W_D32_MM	= 1123,
    CVT_W_D64	= 1124,
    CVT_W_D64_MM	= 1125,
    CVT_W_S	= 1126,
    CVT_W_S_MM	= 1127,
    CVT_W_S_MMR6	= 1128,
    C_EQ_D32	= 1129,
    C_EQ_D32_MM	= 1130,
    C_EQ_D64	= 1131,
    C_EQ_D64_MM	= 1132,
    C_EQ_S	= 1133,
    C_EQ_S_MM	= 1134,
    C_F_D32	= 1135,
    C_F_D32_MM	= 1136,
    C_F_D64	= 1137,
    C_F_D64_MM	= 1138,
    C_F_S	= 1139,
    C_F_S_MM	= 1140,
    C_LE_D32	= 1141,
    C_LE_D32_MM	= 1142,
    C_LE_D64	= 1143,
    C_LE_D64_MM	= 1144,
    C_LE_S	= 1145,
    C_LE_S_MM	= 1146,
    C_LT_D32	= 1147,
    C_LT_D32_MM	= 1148,
    C_LT_D64	= 1149,
    C_LT_D64_MM	= 1150,
    C_LT_S	= 1151,
    C_LT_S_MM	= 1152,
    C_NGE_D32	= 1153,
    C_NGE_D32_MM	= 1154,
    C_NGE_D64	= 1155,
    C_NGE_D64_MM	= 1156,
    C_NGE_S	= 1157,
    C_NGE_S_MM	= 1158,
    C_NGLE_D32	= 1159,
    C_NGLE_D32_MM	= 1160,
    C_NGLE_D64	= 1161,
    C_NGLE_D64_MM	= 1162,
    C_NGLE_S	= 1163,
    C_NGLE_S_MM	= 1164,
    C_NGL_D32	= 1165,
    C_NGL_D32_MM	= 1166,
    C_NGL_D64	= 1167,
    C_NGL_D64_MM	= 1168,
    C_NGL_S	= 1169,
    C_NGL_S_MM	= 1170,
    C_NGT_D32	= 1171,
    C_NGT_D32_MM	= 1172,
    C_NGT_D64	= 1173,
    C_NGT_D64_MM	= 1174,
    C_NGT_S	= 1175,
    C_NGT_S_MM	= 1176,
    C_OLE_D32	= 1177,
    C_OLE_D32_MM	= 1178,
    C_OLE_D64	= 1179,
    C_OLE_D64_MM	= 1180,
    C_OLE_S	= 1181,
    C_OLE_S_MM	= 1182,
    C_OLT_D32	= 1183,
    C_OLT_D32_MM	= 1184,
    C_OLT_D64	= 1185,
    C_OLT_D64_MM	= 1186,
    C_OLT_S	= 1187,
    C_OLT_S_MM	= 1188,
    C_SEQ_D32	= 1189,
    C_SEQ_D32_MM	= 1190,
    C_SEQ_D64	= 1191,
    C_SEQ_D64_MM	= 1192,
    C_SEQ_S	= 1193,
    C_SEQ_S_MM	= 1194,
    C_SF_D32	= 1195,
    C_SF_D32_MM	= 1196,
    C_SF_D64	= 1197,
    C_SF_D64_MM	= 1198,
    C_SF_S	= 1199,
    C_SF_S_MM	= 1200,
    C_UEQ_D32	= 1201,
    C_UEQ_D32_MM	= 1202,
    C_UEQ_D64	= 1203,
    C_UEQ_D64_MM	= 1204,
    C_UEQ_S	= 1205,
    C_UEQ_S_MM	= 1206,
    C_ULE_D32	= 1207,
    C_ULE_D32_MM	= 1208,
    C_ULE_D64	= 1209,
    C_ULE_D64_MM	= 1210,
    C_ULE_S	= 1211,
    C_ULE_S_MM	= 1212,
    C_ULT_D32	= 1213,
    C_ULT_D32_MM	= 1214,
    C_ULT_D64	= 1215,
    C_ULT_D64_MM	= 1216,
    C_ULT_S	= 1217,
    C_ULT_S_MM	= 1218,
    C_UN_D32	= 1219,
    C_UN_D32_MM	= 1220,
    C_UN_D64	= 1221,
    C_UN_D64_MM	= 1222,
    C_UN_S	= 1223,
    C_UN_S_MM	= 1224,
    CmpRxRy16	= 1225,
    CmpiRxImm16	= 1226,
    CmpiRxImmX16	= 1227,
    DADD	= 1228,
    DADDi	= 1229,
    DADDiu	= 1230,
    DADDu	= 1231,
    DAHI	= 1232,
    DALIGN	= 1233,
    DATI	= 1234,
    DAUI	= 1235,
    DBITSWAP	= 1236,
    DCLO	= 1237,
    DCLO_R6	= 1238,
    DCLZ	= 1239,
    DCLZ_R6	= 1240,
    DDIV	= 1241,
    DDIVU	= 1242,
    DERET	= 1243,
    DERET_MM	= 1244,
    DERET_MMR6	= 1245,
    DEXT	= 1246,
    DEXT64_32	= 1247,
    DEXTM	= 1248,
    DEXTU	= 1249,
    DI	= 1250,
    DINS	= 1251,
    DINSM	= 1252,
    DINSU	= 1253,
    DIV	= 1254,
    DIVU	= 1255,
    DIVU_MMR6	= 1256,
    DIV_MMR6	= 1257,
    DIV_S_B	= 1258,
    DIV_S_D	= 1259,
    DIV_S_H	= 1260,
    DIV_S_W	= 1261,
    DIV_U_B	= 1262,
    DIV_U_D	= 1263,
    DIV_U_H	= 1264,
    DIV_U_W	= 1265,
    DI_MM	= 1266,
    DI_MMR6	= 1267,
    DLSA	= 1268,
    DLSA_R6	= 1269,
    DMFC0	= 1270,
    DMFC1	= 1271,
    DMFC2	= 1272,
    DMFC2_OCTEON	= 1273,
    DMFGC0	= 1274,
    DMOD	= 1275,
    DMODU	= 1276,
    DMT	= 1277,
    DMTC0	= 1278,
    DMTC1	= 1279,
    DMTC2	= 1280,
    DMTC2_OCTEON	= 1281,
    DMTGC0	= 1282,
    DMUH	= 1283,
    DMUHU	= 1284,
    DMUL	= 1285,
    DMULT	= 1286,
    DMULTu	= 1287,
    DMULU	= 1288,
    DMUL_R6	= 1289,
    DOTP_S_D	= 1290,
    DOTP_S_H	= 1291,
    DOTP_S_W	= 1292,
    DOTP_U_D	= 1293,
    DOTP_U_H	= 1294,
    DOTP_U_W	= 1295,
    DPADD_S_D	= 1296,
    DPADD_S_H	= 1297,
    DPADD_S_W	= 1298,
    DPADD_U_D	= 1299,
    DPADD_U_H	= 1300,
    DPADD_U_W	= 1301,
    DPAQX_SA_W_PH	= 1302,
    DPAQX_SA_W_PH_MMR2	= 1303,
    DPAQX_S_W_PH	= 1304,
    DPAQX_S_W_PH_MMR2	= 1305,
    DPAQ_SA_L_W	= 1306,
    DPAQ_SA_L_W_MM	= 1307,
    DPAQ_S_W_PH	= 1308,
    DPAQ_S_W_PH_MM	= 1309,
    DPAU_H_QBL	= 1310,
    DPAU_H_QBL_MM	= 1311,
    DPAU_H_QBR	= 1312,
    DPAU_H_QBR_MM	= 1313,
    DPAX_W_PH	= 1314,
    DPAX_W_PH_MMR2	= 1315,
    DPA_W_PH	= 1316,
    DPA_W_PH_MMR2	= 1317,
    DPOP	= 1318,
    DPSQX_SA_W_PH	= 1319,
    DPSQX_SA_W_PH_MMR2	= 1320,
    DPSQX_S_W_PH	= 1321,
    DPSQX_S_W_PH_MMR2	= 1322,
    DPSQ_SA_L_W	= 1323,
    DPSQ_SA_L_W_MM	= 1324,
    DPSQ_S_W_PH	= 1325,
    DPSQ_S_W_PH_MM	= 1326,
    DPSUB_S_D	= 1327,
    DPSUB_S_H	= 1328,
    DPSUB_S_W	= 1329,
    DPSUB_U_D	= 1330,
    DPSUB_U_H	= 1331,
    DPSUB_U_W	= 1332,
    DPSU_H_QBL	= 1333,
    DPSU_H_QBL_MM	= 1334,
    DPSU_H_QBR	= 1335,
    DPSU_H_QBR_MM	= 1336,
    DPSX_W_PH	= 1337,
    DPSX_W_PH_MMR2	= 1338,
    DPS_W_PH	= 1339,
    DPS_W_PH_MMR2	= 1340,
    DROTR	= 1341,
    DROTR32	= 1342,
    DROTRV	= 1343,
    DSBH	= 1344,
    DSDIV	= 1345,
    DSHD	= 1346,
    DSLL	= 1347,
    DSLL32	= 1348,
    DSLL64_32	= 1349,
    DSLLV	= 1350,
    DSRA	= 1351,
    DSRA32	= 1352,
    DSRAV	= 1353,
    DSRL	= 1354,
    DSRL32	= 1355,
    DSRLV	= 1356,
    DSUB	= 1357,
    DSUBu	= 1358,
    DUDIV	= 1359,
    DVP	= 1360,
    DVPE	= 1361,
    DVP_MMR6	= 1362,
    DivRxRy16	= 1363,
    DivuRxRy16	= 1364,
    EHB	= 1365,
    EHB_MM	= 1366,
    EHB_MMR6	= 1367,
    EI	= 1368,
    EI_MM	= 1369,
    EI_MMR6	= 1370,
    EMT	= 1371,
    ERET	= 1372,
    ERETNC	= 1373,
    ERETNC_MMR6	= 1374,
    ERET_MM	= 1375,
    ERET_MMR6	= 1376,
    EVP	= 1377,
    EVPE	= 1378,
    EVP_MMR6	= 1379,
    EXT	= 1380,
    EXTP	= 1381,
    EXTPDP	= 1382,
    EXTPDPV	= 1383,
    EXTPDPV_MM	= 1384,
    EXTPDP_MM	= 1385,
    EXTPV	= 1386,
    EXTPV_MM	= 1387,
    EXTP_MM	= 1388,
    EXTRV_RS_W	= 1389,
    EXTRV_RS_W_MM	= 1390,
    EXTRV_R_W	= 1391,
    EXTRV_R_W_MM	= 1392,
    EXTRV_S_H	= 1393,
    EXTRV_S_H_MM	= 1394,
    EXTRV_W	= 1395,
    EXTRV_W_MM	= 1396,
    EXTR_RS_W	= 1397,
    EXTR_RS_W_MM	= 1398,
    EXTR_R_W	= 1399,
    EXTR_R_W_MM	= 1400,
    EXTR_S_H	= 1401,
    EXTR_S_H_MM	= 1402,
    EXTR_W	= 1403,
    EXTR_W_MM	= 1404,
    EXTS	= 1405,
    EXTS32	= 1406,
    EXT_MM	= 1407,
    EXT_MMR6	= 1408,
    FABS_D32	= 1409,
    FABS_D32_MM	= 1410,
    FABS_D64	= 1411,
    FABS_D64_MM	= 1412,
    FABS_S	= 1413,
    FABS_S_MM	= 1414,
    FADD_D	= 1415,
    FADD_D32	= 1416,
    FADD_D32_MM	= 1417,
    FADD_D64	= 1418,
    FADD_D64_MM	= 1419,
    FADD_S	= 1420,
    FADD_S_MM	= 1421,
    FADD_S_MMR6	= 1422,
    FADD_W	= 1423,
    FCAF_D	= 1424,
    FCAF_W	= 1425,
    FCEQ_D	= 1426,
    FCEQ_W	= 1427,
    FCLASS_D	= 1428,
    FCLASS_W	= 1429,
    FCLE_D	= 1430,
    FCLE_W	= 1431,
    FCLT_D	= 1432,
    FCLT_W	= 1433,
    FCMP_D32	= 1434,
    FCMP_D32_MM	= 1435,
    FCMP_D64	= 1436,
    FCMP_S32	= 1437,
    FCMP_S32_MM	= 1438,
    FCNE_D	= 1439,
    FCNE_W	= 1440,
    FCOR_D	= 1441,
    FCOR_W	= 1442,
    FCUEQ_D	= 1443,
    FCUEQ_W	= 1444,
    FCULE_D	= 1445,
    FCULE_W	= 1446,
    FCULT_D	= 1447,
    FCULT_W	= 1448,
    FCUNE_D	= 1449,
    FCUNE_W	= 1450,
    FCUN_D	= 1451,
    FCUN_W	= 1452,
    FDIV_D	= 1453,
    FDIV_D32	= 1454,
    FDIV_D32_MM	= 1455,
    FDIV_D64	= 1456,
    FDIV_D64_MM	= 1457,
    FDIV_S	= 1458,
    FDIV_S_MM	= 1459,
    FDIV_S_MMR6	= 1460,
    FDIV_W	= 1461,
    FEXDO_H	= 1462,
    FEXDO_W	= 1463,
    FEXP2_D	= 1464,
    FEXP2_W	= 1465,
    FEXUPL_D	= 1466,
    FEXUPL_W	= 1467,
    FEXUPR_D	= 1468,
    FEXUPR_W	= 1469,
    FFINT_S_D	= 1470,
    FFINT_S_W	= 1471,
    FFINT_U_D	= 1472,
    FFINT_U_W	= 1473,
    FFQL_D	= 1474,
    FFQL_W	= 1475,
    FFQR_D	= 1476,
    FFQR_W	= 1477,
    FILL_B	= 1478,
    FILL_D	= 1479,
    FILL_H	= 1480,
    FILL_W	= 1481,
    FLOG2_D	= 1482,
    FLOG2_W	= 1483,
    FLOOR_L_D64	= 1484,
    FLOOR_L_D_MMR6	= 1485,
    FLOOR_L_S	= 1486,
    FLOOR_L_S_MMR6	= 1487,
    FLOOR_W_D32	= 1488,
    FLOOR_W_D64	= 1489,
    FLOOR_W_D_MMR6	= 1490,
    FLOOR_W_MM	= 1491,
    FLOOR_W_S	= 1492,
    FLOOR_W_S_MM	= 1493,
    FLOOR_W_S_MMR6	= 1494,
    FMADD_D	= 1495,
    FMADD_W	= 1496,
    FMAX_A_D	= 1497,
    FMAX_A_W	= 1498,
    FMAX_D	= 1499,
    FMAX_W	= 1500,
    FMIN_A_D	= 1501,
    FMIN_A_W	= 1502,
    FMIN_D	= 1503,
    FMIN_W	= 1504,
    FMOV_D32	= 1505,
    FMOV_D32_MM	= 1506,
    FMOV_D64	= 1507,
    FMOV_D64_MM	= 1508,
    FMOV_D_MMR6	= 1509,
    FMOV_S	= 1510,
    FMOV_S_MM	= 1511,
    FMOV_S_MMR6	= 1512,
    FMSUB_D	= 1513,
    FMSUB_W	= 1514,
    FMUL_D	= 1515,
    FMUL_D32	= 1516,
    FMUL_D32_MM	= 1517,
    FMUL_D64	= 1518,
    FMUL_D64_MM	= 1519,
    FMUL_S	= 1520,
    FMUL_S_MM	= 1521,
    FMUL_S_MMR6	= 1522,
    FMUL_W	= 1523,
    FNEG_D32	= 1524,
    FNEG_D32_MM	= 1525,
    FNEG_D64	= 1526,
    FNEG_D64_MM	= 1527,
    FNEG_S	= 1528,
    FNEG_S_MM	= 1529,
    FNEG_S_MMR6	= 1530,
    FORK	= 1531,
    FRCP_D	= 1532,
    FRCP_W	= 1533,
    FRINT_D	= 1534,
    FRINT_W	= 1535,
    FRSQRT_D	= 1536,
    FRSQRT_W	= 1537,
    FSAF_D	= 1538,
    FSAF_W	= 1539,
    FSEQ_D	= 1540,
    FSEQ_W	= 1541,
    FSLE_D	= 1542,
    FSLE_W	= 1543,
    FSLT_D	= 1544,
    FSLT_W	= 1545,
    FSNE_D	= 1546,
    FSNE_W	= 1547,
    FSOR_D	= 1548,
    FSOR_W	= 1549,
    FSQRT_D	= 1550,
    FSQRT_D32	= 1551,
    FSQRT_D32_MM	= 1552,
    FSQRT_D64	= 1553,
    FSQRT_D64_MM	= 1554,
    FSQRT_S	= 1555,
    FSQRT_S_MM	= 1556,
    FSQRT_W	= 1557,
    FSUB_D	= 1558,
    FSUB_D32	= 1559,
    FSUB_D32_MM	= 1560,
    FSUB_D64	= 1561,
    FSUB_D64_MM	= 1562,
    FSUB_S	= 1563,
    FSUB_S_MM	= 1564,
    FSUB_S_MMR6	= 1565,
    FSUB_W	= 1566,
    FSUEQ_D	= 1567,
    FSUEQ_W	= 1568,
    FSULE_D	= 1569,
    FSULE_W	= 1570,
    FSULT_D	= 1571,
    FSULT_W	= 1572,
    FSUNE_D	= 1573,
    FSUNE_W	= 1574,
    FSUN_D	= 1575,
    FSUN_W	= 1576,
    FTINT_S_D	= 1577,
    FTINT_S_W	= 1578,
    FTINT_U_D	= 1579,
    FTINT_U_W	= 1580,
    FTQ_H	= 1581,
    FTQ_W	= 1582,
    FTRUNC_S_D	= 1583,
    FTRUNC_S_W	= 1584,
    FTRUNC_U_D	= 1585,
    FTRUNC_U_W	= 1586,
    GINVI	= 1587,
    GINVI_MMR6	= 1588,
    GINVT	= 1589,
    GINVT_MMR6	= 1590,
    HADD_S_D	= 1591,
    HADD_S_H	= 1592,
    HADD_S_W	= 1593,
    HADD_U_D	= 1594,
    HADD_U_H	= 1595,
    HADD_U_W	= 1596,
    HSUB_S_D	= 1597,
    HSUB_S_H	= 1598,
    HSUB_S_W	= 1599,
    HSUB_U_D	= 1600,
    HSUB_U_H	= 1601,
    HSUB_U_W	= 1602,
    HYPCALL	= 1603,
    HYPCALL_MM	= 1604,
    ILVEV_B	= 1605,
    ILVEV_D	= 1606,
    ILVEV_H	= 1607,
    ILVEV_W	= 1608,
    ILVL_B	= 1609,
    ILVL_D	= 1610,
    ILVL_H	= 1611,
    ILVL_W	= 1612,
    ILVOD_B	= 1613,
    ILVOD_D	= 1614,
    ILVOD_H	= 1615,
    ILVOD_W	= 1616,
    ILVR_B	= 1617,
    ILVR_D	= 1618,
    ILVR_H	= 1619,
    ILVR_W	= 1620,
    INS	= 1621,
    INSERT_B	= 1622,
    INSERT_D	= 1623,
    INSERT_H	= 1624,
    INSERT_W	= 1625,
    INSV	= 1626,
    INSVE_B	= 1627,
    INSVE_D	= 1628,
    INSVE_H	= 1629,
    INSVE_W	= 1630,
    INSV_MM	= 1631,
    INS_MM	= 1632,
    INS_MMR6	= 1633,
    J	= 1634,
    JAL	= 1635,
    JALR	= 1636,
    JALR16_MM	= 1637,
    JALR64	= 1638,
    JALRC16_MMR6	= 1639,
    JALRC_HB_MMR6	= 1640,
    JALRC_MMR6	= 1641,
    JALRS16_MM	= 1642,
    JALRS_MM	= 1643,
    JALR_HB	= 1644,
    JALR_HB64	= 1645,
    JALR_MM	= 1646,
    JALS_MM	= 1647,
    JALX	= 1648,
    JALX_MM	= 1649,
    JAL_MM	= 1650,
    JIALC	= 1651,
    JIALC64	= 1652,
    JIALC_MMR6	= 1653,
    JIC	= 1654,
    JIC64	= 1655,
    JIC_MMR6	= 1656,
    JR	= 1657,
    JR16_MM	= 1658,
    JR64	= 1659,
    JRADDIUSP	= 1660,
    JRC16_MM	= 1661,
    JRC16_MMR6	= 1662,
    JRCADDIUSP_MMR6	= 1663,
    JR_HB	= 1664,
    JR_HB64	= 1665,
    JR_HB64_R6	= 1666,
    JR_HB_R6	= 1667,
    JR_MM	= 1668,
    J_MM	= 1669,
    Jal16	= 1670,
    JalB16	= 1671,
    JrRa16	= 1672,
    JrcRa16	= 1673,
    JrcRx16	= 1674,
    JumpLinkReg16	= 1675,
    LB	= 1676,
    LB64	= 1677,
    LBE	= 1678,
    LBE_MM	= 1679,
    LBU16_MM	= 1680,
    LBUX	= 1681,
    LBUX_MM	= 1682,
    LBU_MMR6	= 1683,
    LB_MM	= 1684,
    LB_MMR6	= 1685,
    LBu	= 1686,
    LBu64	= 1687,
    LBuE	= 1688,
    LBuE_MM	= 1689,
    LBu_MM	= 1690,
    LD	= 1691,
    LDC1	= 1692,
    LDC164	= 1693,
    LDC1_D64_MMR6	= 1694,
    LDC1_MM	= 1695,
    LDC2	= 1696,
    LDC2_MMR6	= 1697,
    LDC2_R6	= 1698,
    LDC3	= 1699,
    LDI_B	= 1700,
    LDI_D	= 1701,
    LDI_H	= 1702,
    LDI_W	= 1703,
    LDL	= 1704,
    LDPC	= 1705,
    LDR	= 1706,
    LDXC1	= 1707,
    LDXC164	= 1708,
    LD_B	= 1709,
    LD_D	= 1710,
    LD_H	= 1711,
    LD_W	= 1712,
    LEA_ADDiu	= 1713,
    LEA_ADDiu64	= 1714,
    LEA_ADDiu_MM	= 1715,
    LH	= 1716,
    LH64	= 1717,
    LHE	= 1718,
    LHE_MM	= 1719,
    LHU16_MM	= 1720,
    LHX	= 1721,
    LHX_MM	= 1722,
    LH_MM	= 1723,
    LHu	= 1724,
    LHu64	= 1725,
    LHuE	= 1726,
    LHuE_MM	= 1727,
    LHu_MM	= 1728,
    LI16_MM	= 1729,
    LI16_MMR6	= 1730,
    LL	= 1731,
    LL64	= 1732,
    LL64_R6	= 1733,
    LLD	= 1734,
    LLD_R6	= 1735,
    LLE	= 1736,
    LLE_MM	= 1737,
    LL_MM	= 1738,
    LL_MMR6	= 1739,
    LL_R6	= 1740,
    LSA	= 1741,
    LSA_MMR6	= 1742,
    LSA_R6	= 1743,
    LUI_MMR6	= 1744,
    LUXC1	= 1745,
    LUXC164	= 1746,
    LUXC1_MM	= 1747,
    LUi	= 1748,
    LUi64	= 1749,
    LUi_MM	= 1750,
    LW	= 1751,
    LW16_MM	= 1752,
    LW64	= 1753,
    LWC1	= 1754,
    LWC1_MM	= 1755,
    LWC2	= 1756,
    LWC2_MMR6	= 1757,
    LWC2_R6	= 1758,
    LWC3	= 1759,
    LWDSP	= 1760,
    LWDSP_MM	= 1761,
    LWE	= 1762,
    LWE_MM	= 1763,
    LWGP_MM	= 1764,
    LWL	= 1765,
    LWL64	= 1766,
    LWLE	= 1767,
    LWLE_MM	= 1768,
    LWL_MM	= 1769,
    LWM16_MM	= 1770,
    LWM16_MMR6	= 1771,
    LWM32_MM	= 1772,
    LWPC	= 1773,
    LWPC_MMR6	= 1774,
    LWP_MM	= 1775,
    LWR	= 1776,
    LWR64	= 1777,
    LWRE	= 1778,
    LWRE_MM	= 1779,
    LWR_MM	= 1780,
    LWSP_MM	= 1781,
    LWUPC	= 1782,
    LWU_MM	= 1783,
    LWX	= 1784,
    LWXC1	= 1785,
    LWXC1_MM	= 1786,
    LWXS_MM	= 1787,
    LWX_MM	= 1788,
    LW_MM	= 1789,
    LW_MMR6	= 1790,
    LWu	= 1791,
    LbRxRyOffMemX16	= 1792,
    LbuRxRyOffMemX16	= 1793,
    LhRxRyOffMemX16	= 1794,
    LhuRxRyOffMemX16	= 1795,
    LiRxImm16	= 1796,
    LiRxImmAlignX16	= 1797,
    LiRxImmX16	= 1798,
    LwRxPcTcp16	= 1799,
    LwRxPcTcpX16	= 1800,
    LwRxRyOffMemX16	= 1801,
    LwRxSpImmX16	= 1802,
    MADD	= 1803,
    MADDF_D	= 1804,
    MADDF_D_MMR6	= 1805,
    MADDF_S	= 1806,
    MADDF_S_MMR6	= 1807,
    MADDR_Q_H	= 1808,
    MADDR_Q_W	= 1809,
    MADDU	= 1810,
    MADDU_DSP	= 1811,
    MADDU_DSP_MM	= 1812,
    MADDU_MM	= 1813,
    MADDV_B	= 1814,
    MADDV_D	= 1815,
    MADDV_H	= 1816,
    MADDV_W	= 1817,
    MADD_D32	= 1818,
    MADD_D32_MM	= 1819,
    MADD_D64	= 1820,
    MADD_DSP	= 1821,
    MADD_DSP_MM	= 1822,
    MADD_MM	= 1823,
    MADD_Q_H	= 1824,
    MADD_Q_W	= 1825,
    MADD_S	= 1826,
    MADD_S_MM	= 1827,
    MAQ_SA_W_PHL	= 1828,
    MAQ_SA_W_PHL_MM	= 1829,
    MAQ_SA_W_PHR	= 1830,
    MAQ_SA_W_PHR_MM	= 1831,
    MAQ_S_W_PHL	= 1832,
    MAQ_S_W_PHL_MM	= 1833,
    MAQ_S_W_PHR	= 1834,
    MAQ_S_W_PHR_MM	= 1835,
    MAXA_D	= 1836,
    MAXA_D_MMR6	= 1837,
    MAXA_S	= 1838,
    MAXA_S_MMR6	= 1839,
    MAXI_S_B	= 1840,
    MAXI_S_D	= 1841,
    MAXI_S_H	= 1842,
    MAXI_S_W	= 1843,
    MAXI_U_B	= 1844,
    MAXI_U_D	= 1845,
    MAXI_U_H	= 1846,
    MAXI_U_W	= 1847,
    MAX_A_B	= 1848,
    MAX_A_D	= 1849,
    MAX_A_H	= 1850,
    MAX_A_W	= 1851,
    MAX_D	= 1852,
    MAX_D_MMR6	= 1853,
    MAX_S	= 1854,
    MAX_S_B	= 1855,
    MAX_S_D	= 1856,
    MAX_S_H	= 1857,
    MAX_S_MMR6	= 1858,
    MAX_S_W	= 1859,
    MAX_U_B	= 1860,
    MAX_U_D	= 1861,
    MAX_U_H	= 1862,
    MAX_U_W	= 1863,
    MFC0	= 1864,
    MFC0_MMR6	= 1865,
    MFC1	= 1866,
    MFC1_D64	= 1867,
    MFC1_MM	= 1868,
    MFC1_MMR6	= 1869,
    MFC2	= 1870,
    MFC2_MMR6	= 1871,
    MFGC0	= 1872,
    MFGC0_MM	= 1873,
    MFHC0_MMR6	= 1874,
    MFHC1_D32	= 1875,
    MFHC1_D32_MM	= 1876,
    MFHC1_D64	= 1877,
    MFHC1_D64_MM	= 1878,
    MFHC2_MMR6	= 1879,
    MFHGC0	= 1880,
    MFHGC0_MM	= 1881,
    MFHI	= 1882,
    MFHI16_MM	= 1883,
    MFHI64	= 1884,
    MFHI_DSP	= 1885,
    MFHI_DSP_MM	= 1886,
    MFHI_MM	= 1887,
    MFLO	= 1888,
    MFLO16_MM	= 1889,
    MFLO64	= 1890,
    MFLO_DSP	= 1891,
    MFLO_DSP_MM	= 1892,
    MFLO_MM	= 1893,
    MFTR	= 1894,
    MINA_D	= 1895,
    MINA_D_MMR6	= 1896,
    MINA_S	= 1897,
    MINA_S_MMR6	= 1898,
    MINI_S_B	= 1899,
    MINI_S_D	= 1900,
    MINI_S_H	= 1901,
    MINI_S_W	= 1902,
    MINI_U_B	= 1903,
    MINI_U_D	= 1904,
    MINI_U_H	= 1905,
    MINI_U_W	= 1906,
    MIN_A_B	= 1907,
    MIN_A_D	= 1908,
    MIN_A_H	= 1909,
    MIN_A_W	= 1910,
    MIN_D	= 1911,
    MIN_D_MMR6	= 1912,
    MIN_S	= 1913,
    MIN_S_B	= 1914,
    MIN_S_D	= 1915,
    MIN_S_H	= 1916,
    MIN_S_MMR6	= 1917,
    MIN_S_W	= 1918,
    MIN_U_B	= 1919,
    MIN_U_D	= 1920,
    MIN_U_H	= 1921,
    MIN_U_W	= 1922,
    MOD	= 1923,
    MODSUB	= 1924,
    MODSUB_MM	= 1925,
    MODU	= 1926,
    MODU_MMR6	= 1927,
    MOD_MMR6	= 1928,
    MOD_S_B	= 1929,
    MOD_S_D	= 1930,
    MOD_S_H	= 1931,
    MOD_S_W	= 1932,
    MOD_U_B	= 1933,
    MOD_U_D	= 1934,
    MOD_U_H	= 1935,
    MOD_U_W	= 1936,
    MOVE16_MM	= 1937,
    MOVE16_MMR6	= 1938,
    MOVEP_MM	= 1939,
    MOVEP_MMR6	= 1940,
    MOVE_V	= 1941,
    MOVF_D32	= 1942,
    MOVF_D32_MM	= 1943,
    MOVF_D64	= 1944,
    MOVF_I	= 1945,
    MOVF_I64	= 1946,
    MOVF_I_MM	= 1947,
    MOVF_S	= 1948,
    MOVF_S_MM	= 1949,
    MOVN_I64_D64	= 1950,
    MOVN_I64_I	= 1951,
    MOVN_I64_I64	= 1952,
    MOVN_I64_S	= 1953,
    MOVN_I_D32	= 1954,
    MOVN_I_D32_MM	= 1955,
    MOVN_I_D64	= 1956,
    MOVN_I_I	= 1957,
    MOVN_I_I64	= 1958,
    MOVN_I_MM	= 1959,
    MOVN_I_S	= 1960,
    MOVN_I_S_MM	= 1961,
    MOVT_D32	= 1962,
    MOVT_D32_MM	= 1963,
    MOVT_D64	= 1964,
    MOVT_I	= 1965,
    MOVT_I64	= 1966,
    MOVT_I_MM	= 1967,
    MOVT_S	= 1968,
    MOVT_S_MM	= 1969,
    MOVZ_I64_D64	= 1970,
    MOVZ_I64_I	= 1971,
    MOVZ_I64_I64	= 1972,
    MOVZ_I64_S	= 1973,
    MOVZ_I_D32	= 1974,
    MOVZ_I_D32_MM	= 1975,
    MOVZ_I_D64	= 1976,
    MOVZ_I_I	= 1977,
    MOVZ_I_I64	= 1978,
    MOVZ_I_MM	= 1979,
    MOVZ_I_S	= 1980,
    MOVZ_I_S_MM	= 1981,
    MSUB	= 1982,
    MSUBF_D	= 1983,
    MSUBF_D_MMR6	= 1984,
    MSUBF_S	= 1985,
    MSUBF_S_MMR6	= 1986,
    MSUBR_Q_H	= 1987,
    MSUBR_Q_W	= 1988,
    MSUBU	= 1989,
    MSUBU_DSP	= 1990,
    MSUBU_DSP_MM	= 1991,
    MSUBU_MM	= 1992,
    MSUBV_B	= 1993,
    MSUBV_D	= 1994,
    MSUBV_H	= 1995,
    MSUBV_W	= 1996,
    MSUB_D32	= 1997,
    MSUB_D32_MM	= 1998,
    MSUB_D64	= 1999,
    MSUB_DSP	= 2000,
    MSUB_DSP_MM	= 2001,
    MSUB_MM	= 2002,
    MSUB_Q_H	= 2003,
    MSUB_Q_W	= 2004,
    MSUB_S	= 2005,
    MSUB_S_MM	= 2006,
    MTC0	= 2007,
    MTC0_MMR6	= 2008,
    MTC1	= 2009,
    MTC1_D64	= 2010,
    MTC1_D64_MM	= 2011,
    MTC1_MM	= 2012,
    MTC1_MMR6	= 2013,
    MTC2	= 2014,
    MTC2_MMR6	= 2015,
    MTGC0	= 2016,
    MTGC0_MM	= 2017,
    MTHC0_MMR6	= 2018,
    MTHC1_D32	= 2019,
    MTHC1_D32_MM	= 2020,
    MTHC1_D64	= 2021,
    MTHC1_D64_MM	= 2022,
    MTHC2_MMR6	= 2023,
    MTHGC0	= 2024,
    MTHGC0_MM	= 2025,
    MTHI	= 2026,
    MTHI64	= 2027,
    MTHI_DSP	= 2028,
    MTHI_DSP_MM	= 2029,
    MTHI_MM	= 2030,
    MTHLIP	= 2031,
    MTHLIP_MM	= 2032,
    MTLO	= 2033,
    MTLO64	= 2034,
    MTLO_DSP	= 2035,
    MTLO_DSP_MM	= 2036,
    MTLO_MM	= 2037,
    MTM0	= 2038,
    MTM1	= 2039,
    MTM2	= 2040,
    MTP0	= 2041,
    MTP1	= 2042,
    MTP2	= 2043,
    MTTR	= 2044,
    MUH	= 2045,
    MUHU	= 2046,
    MUHU_MMR6	= 2047,
    MUH_MMR6	= 2048,
    MUL	= 2049,
    MULEQ_S_W_PHL	= 2050,
    MULEQ_S_W_PHL_MM	= 2051,
    MULEQ_S_W_PHR	= 2052,
    MULEQ_S_W_PHR_MM	= 2053,
    MULEU_S_PH_QBL	= 2054,
    MULEU_S_PH_QBL_MM	= 2055,
    MULEU_S_PH_QBR	= 2056,
    MULEU_S_PH_QBR_MM	= 2057,
    MULQ_RS_PH	= 2058,
    MULQ_RS_PH_MM	= 2059,
    MULQ_RS_W	= 2060,
    MULQ_RS_W_MMR2	= 2061,
    MULQ_S_PH	= 2062,
    MULQ_S_PH_MMR2	= 2063,
    MULQ_S_W	= 2064,
    MULQ_S_W_MMR2	= 2065,
    MULR_Q_H	= 2066,
    MULR_Q_W	= 2067,
    MULSAQ_S_W_PH	= 2068,
    MULSAQ_S_W_PH_MM	= 2069,
    MULSA_W_PH	= 2070,
    MULSA_W_PH_MMR2	= 2071,
    MULT	= 2072,
    MULTU_DSP	= 2073,
    MULTU_DSP_MM	= 2074,
    MULT_DSP	= 2075,
    MULT_DSP_MM	= 2076,
    MULT_MM	= 2077,
    MULTu	= 2078,
    MULTu_MM	= 2079,
    MULU	= 2080,
    MULU_MMR6	= 2081,
    MULV_B	= 2082,
    MULV_D	= 2083,
    MULV_H	= 2084,
    MULV_W	= 2085,
    MUL_MM	= 2086,
    MUL_MMR6	= 2087,
    MUL_PH	= 2088,
    MUL_PH_MMR2	= 2089,
    MUL_Q_H	= 2090,
    MUL_Q_W	= 2091,
    MUL_R6	= 2092,
    MUL_S_PH	= 2093,
    MUL_S_PH_MMR2	= 2094,
    Mfhi16	= 2095,
    Mflo16	= 2096,
    Move32R16	= 2097,
    MoveR3216	= 2098,
    NLOC_B	= 2099,
    NLOC_D	= 2100,
    NLOC_H	= 2101,
    NLOC_W	= 2102,
    NLZC_B	= 2103,
    NLZC_D	= 2104,
    NLZC_H	= 2105,
    NLZC_W	= 2106,
    NMADD_D32	= 2107,
    NMADD_D32_MM	= 2108,
    NMADD_D64	= 2109,
    NMADD_S	= 2110,
    NMADD_S_MM	= 2111,
    NMSUB_D32	= 2112,
    NMSUB_D32_MM	= 2113,
    NMSUB_D64	= 2114,
    NMSUB_S	= 2115,
    NMSUB_S_MM	= 2116,
    NOR	= 2117,
    NOR64	= 2118,
    NORI_B	= 2119,
    NOR_MM	= 2120,
    NOR_MMR6	= 2121,
    NOR_V	= 2122,
    NOT16_MM	= 2123,
    NOT16_MMR6	= 2124,
    NegRxRy16	= 2125,
    NotRxRy16	= 2126,
    OR	= 2127,
    OR16_MM	= 2128,
    OR16_MMR6	= 2129,
    OR64	= 2130,
    ORI_B	= 2131,
    ORI_MMR6	= 2132,
    OR_MM	= 2133,
    OR_MMR6	= 2134,
    OR_V	= 2135,
    ORi	= 2136,
    ORi64	= 2137,
    ORi_MM	= 2138,
    OrRxRxRy16	= 2139,
    PACKRL_PH	= 2140,
    PACKRL_PH_MM	= 2141,
    PAUSE	= 2142,
    PAUSE_MM	= 2143,
    PAUSE_MMR6	= 2144,
    PCKEV_B	= 2145,
    PCKEV_D	= 2146,
    PCKEV_H	= 2147,
    PCKEV_W	= 2148,
    PCKOD_B	= 2149,
    PCKOD_D	= 2150,
    PCKOD_H	= 2151,
    PCKOD_W	= 2152,
    PCNT_B	= 2153,
    PCNT_D	= 2154,
    PCNT_H	= 2155,
    PCNT_W	= 2156,
    PICK_PH	= 2157,
    PICK_PH_MM	= 2158,
    PICK_QB	= 2159,
    PICK_QB_MM	= 2160,
    PLL_PS64	= 2161,
    PLU_PS64	= 2162,
    POP	= 2163,
    PRECEQU_PH_QBL	= 2164,
    PRECEQU_PH_QBLA	= 2165,
    PRECEQU_PH_QBLA_MM	= 2166,
    PRECEQU_PH_QBL_MM	= 2167,
    PRECEQU_PH_QBR	= 2168,
    PRECEQU_PH_QBRA	= 2169,
    PRECEQU_PH_QBRA_MM	= 2170,
    PRECEQU_PH_QBR_MM	= 2171,
    PRECEQ_W_PHL	= 2172,
    PRECEQ_W_PHL_MM	= 2173,
    PRECEQ_W_PHR	= 2174,
    PRECEQ_W_PHR_MM	= 2175,
    PRECEU_PH_QBL	= 2176,
    PRECEU_PH_QBLA	= 2177,
    PRECEU_PH_QBLA_MM	= 2178,
    PRECEU_PH_QBL_MM	= 2179,
    PRECEU_PH_QBR	= 2180,
    PRECEU_PH_QBRA	= 2181,
    PRECEU_PH_QBRA_MM	= 2182,
    PRECEU_PH_QBR_MM	= 2183,
    PRECRQU_S_QB_PH	= 2184,
    PRECRQU_S_QB_PH_MM	= 2185,
    PRECRQ_PH_W	= 2186,
    PRECRQ_PH_W_MM	= 2187,
    PRECRQ_QB_PH	= 2188,
    PRECRQ_QB_PH_MM	= 2189,
    PRECRQ_RS_PH_W	= 2190,
    PRECRQ_RS_PH_W_MM	= 2191,
    PRECR_QB_PH	= 2192,
    PRECR_QB_PH_MMR2	= 2193,
    PRECR_SRA_PH_W	= 2194,
    PRECR_SRA_PH_W_MMR2	= 2195,
    PRECR_SRA_R_PH_W	= 2196,
    PRECR_SRA_R_PH_W_MMR2	= 2197,
    PREF	= 2198,
    PREFE	= 2199,
    PREFE_MM	= 2200,
    PREFX_MM	= 2201,
    PREF_MM	= 2202,
    PREF_MMR6	= 2203,
    PREF_R6	= 2204,
    PREPEND	= 2205,
    PREPEND_MMR2	= 2206,
    RADDU_W_QB	= 2207,
    RADDU_W_QB_MM	= 2208,
    RDDSP	= 2209,
    RDDSP_MM	= 2210,
    RDHWR	= 2211,
    RDHWR64	= 2212,
    RDHWR_MM	= 2213,
    RDHWR_MMR6	= 2214,
    RDPGPR_MMR6	= 2215,
    RECIP_D32	= 2216,
    RECIP_D32_MM	= 2217,
    RECIP_D64	= 2218,
    RECIP_D64_MM	= 2219,
    RECIP_S	= 2220,
    RECIP_S_MM	= 2221,
    REPLV_PH	= 2222,
    REPLV_PH_MM	= 2223,
    REPLV_QB	= 2224,
    REPLV_QB_MM	= 2225,
    REPL_PH	= 2226,
    REPL_PH_MM	= 2227,
    REPL_QB	= 2228,
    REPL_QB_MM	= 2229,
    RINT_D	= 2230,
    RINT_D_MMR6	= 2231,
    RINT_S	= 2232,
    RINT_S_MMR6	= 2233,
    ROTR	= 2234,
    ROTRV	= 2235,
    ROTRV_MM	= 2236,
    ROTR_MM	= 2237,
    ROUND_L_D64	= 2238,
    ROUND_L_D_MMR6	= 2239,
    ROUND_L_S	= 2240,
    ROUND_L_S_MMR6	= 2241,
    ROUND_W_D32	= 2242,
    ROUND_W_D64	= 2243,
    ROUND_W_D_MMR6	= 2244,
    ROUND_W_MM	= 2245,
    ROUND_W_S	= 2246,
    ROUND_W_S_MM	= 2247,
    ROUND_W_S_MMR6	= 2248,
    RSQRT_D32	= 2249,
    RSQRT_D32_MM	= 2250,
    RSQRT_D64	= 2251,
    RSQRT_D64_MM	= 2252,
    RSQRT_S	= 2253,
    RSQRT_S_MM	= 2254,
    Restore16	= 2255,
    RestoreX16	= 2256,
    SAT_S_B	= 2257,
    SAT_S_D	= 2258,
    SAT_S_H	= 2259,
    SAT_S_W	= 2260,
    SAT_U_B	= 2261,
    SAT_U_D	= 2262,
    SAT_U_H	= 2263,
    SAT_U_W	= 2264,
    SB	= 2265,
    SB16_MM	= 2266,
    SB16_MMR6	= 2267,
    SB64	= 2268,
    SBE	= 2269,
    SBE_MM	= 2270,
    SB_MM	= 2271,
    SB_MMR6	= 2272,
    SC	= 2273,
    SC64	= 2274,
    SC64_R6	= 2275,
    SCD	= 2276,
    SCD_R6	= 2277,
    SCE	= 2278,
    SCE_MM	= 2279,
    SC_MM	= 2280,
    SC_MMR6	= 2281,
    SC_R6	= 2282,
    SD	= 2283,
    SDBBP	= 2284,
    SDBBP16_MM	= 2285,
    SDBBP16_MMR6	= 2286,
    SDBBP_MM	= 2287,
    SDBBP_MMR6	= 2288,
    SDBBP_R6	= 2289,
    SDC1	= 2290,
    SDC164	= 2291,
    SDC1_D64_MMR6	= 2292,
    SDC1_MM	= 2293,
    SDC2	= 2294,
    SDC2_MMR6	= 2295,
    SDC2_R6	= 2296,
    SDC3	= 2297,
    SDIV	= 2298,
    SDIV_MM	= 2299,
    SDL	= 2300,
    SDR	= 2301,
    SDXC1	= 2302,
    SDXC164	= 2303,
    SEB	= 2304,
    SEB64	= 2305,
    SEB_MM	= 2306,
    SEH	= 2307,
    SEH64	= 2308,
    SEH_MM	= 2309,
    SELEQZ	= 2310,
    SELEQZ64	= 2311,
    SELEQZ_D	= 2312,
    SELEQZ_D_MMR6	= 2313,
    SELEQZ_MMR6	= 2314,
    SELEQZ_S	= 2315,
    SELEQZ_S_MMR6	= 2316,
    SELNEZ	= 2317,
    SELNEZ64	= 2318,
    SELNEZ_D	= 2319,
    SELNEZ_D_MMR6	= 2320,
    SELNEZ_MMR6	= 2321,
    SELNEZ_S	= 2322,
    SELNEZ_S_MMR6	= 2323,
    SEL_D	= 2324,
    SEL_D_MMR6	= 2325,
    SEL_S	= 2326,
    SEL_S_MMR6	= 2327,
    SEQ	= 2328,
    SEQi	= 2329,
    SH	= 2330,
    SH16_MM	= 2331,
    SH16_MMR6	= 2332,
    SH64	= 2333,
    SHE	= 2334,
    SHE_MM	= 2335,
    SHF_B	= 2336,
    SHF_H	= 2337,
    SHF_W	= 2338,
    SHILO	= 2339,
    SHILOV	= 2340,
    SHILOV_MM	= 2341,
    SHILO_MM	= 2342,
    SHLLV_PH	= 2343,
    SHLLV_PH_MM	= 2344,
    SHLLV_QB	= 2345,
    SHLLV_QB_MM	= 2346,
    SHLLV_S_PH	= 2347,
    SHLLV_S_PH_MM	= 2348,
    SHLLV_S_W	= 2349,
    SHLLV_S_W_MM	= 2350,
    SHLL_PH	= 2351,
    SHLL_PH_MM	= 2352,
    SHLL_QB	= 2353,
    SHLL_QB_MM	= 2354,
    SHLL_S_PH	= 2355,
    SHLL_S_PH_MM	= 2356,
    SHLL_S_W	= 2357,
    SHLL_S_W_MM	= 2358,
    SHRAV_PH	= 2359,
    SHRAV_PH_MM	= 2360,
    SHRAV_QB	= 2361,
    SHRAV_QB_MMR2	= 2362,
    SHRAV_R_PH	= 2363,
    SHRAV_R_PH_MM	= 2364,
    SHRAV_R_QB	= 2365,
    SHRAV_R_QB_MMR2	= 2366,
    SHRAV_R_W	= 2367,
    SHRAV_R_W_MM	= 2368,
    SHRA_PH	= 2369,
    SHRA_PH_MM	= 2370,
    SHRA_QB	= 2371,
    SHRA_QB_MMR2	= 2372,
    SHRA_R_PH	= 2373,
    SHRA_R_PH_MM	= 2374,
    SHRA_R_QB	= 2375,
    SHRA_R_QB_MMR2	= 2376,
    SHRA_R_W	= 2377,
    SHRA_R_W_MM	= 2378,
    SHRLV_PH	= 2379,
    SHRLV_PH_MMR2	= 2380,
    SHRLV_QB	= 2381,
    SHRLV_QB_MM	= 2382,
    SHRL_PH	= 2383,
    SHRL_PH_MMR2	= 2384,
    SHRL_QB	= 2385,
    SHRL_QB_MM	= 2386,
    SH_MM	= 2387,
    SH_MMR6	= 2388,
    SIGRIE	= 2389,
    SIGRIE_MMR6	= 2390,
    SLDI_B	= 2391,
    SLDI_D	= 2392,
    SLDI_H	= 2393,
    SLDI_W	= 2394,
    SLD_B	= 2395,
    SLD_D	= 2396,
    SLD_H	= 2397,
    SLD_W	= 2398,
    SLL	= 2399,
    SLL16_MM	= 2400,
    SLL16_MMR6	= 2401,
    SLL64_32	= 2402,
    SLL64_64	= 2403,
    SLLI_B	= 2404,
    SLLI_D	= 2405,
    SLLI_H	= 2406,
    SLLI_W	= 2407,
    SLLV	= 2408,
    SLLV_MM	= 2409,
    SLL_B	= 2410,
    SLL_D	= 2411,
    SLL_H	= 2412,
    SLL_MM	= 2413,
    SLL_MMR6	= 2414,
    SLL_W	= 2415,
    SLT	= 2416,
    SLT64	= 2417,
    SLT_MM	= 2418,
    SLTi	= 2419,
    SLTi64	= 2420,
    SLTi_MM	= 2421,
    SLTiu	= 2422,
    SLTiu64	= 2423,
    SLTiu_MM	= 2424,
    SLTu	= 2425,
    SLTu64	= 2426,
    SLTu_MM	= 2427,
    SNE	= 2428,
    SNEi	= 2429,
    SPLATI_B	= 2430,
    SPLATI_D	= 2431,
    SPLATI_H	= 2432,
    SPLATI_W	= 2433,
    SPLAT_B	= 2434,
    SPLAT_D	= 2435,
    SPLAT_H	= 2436,
    SPLAT_W	= 2437,
    SRA	= 2438,
    SRAI_B	= 2439,
    SRAI_D	= 2440,
    SRAI_H	= 2441,
    SRAI_W	= 2442,
    SRARI_B	= 2443,
    SRARI_D	= 2444,
    SRARI_H	= 2445,
    SRARI_W	= 2446,
    SRAR_B	= 2447,
    SRAR_D	= 2448,
    SRAR_H	= 2449,
    SRAR_W	= 2450,
    SRAV	= 2451,
    SRAV_MM	= 2452,
    SRA_B	= 2453,
    SRA_D	= 2454,
    SRA_H	= 2455,
    SRA_MM	= 2456,
    SRA_W	= 2457,
    SRL	= 2458,
    SRL16_MM	= 2459,
    SRL16_MMR6	= 2460,
    SRLI_B	= 2461,
    SRLI_D	= 2462,
    SRLI_H	= 2463,
    SRLI_W	= 2464,
    SRLRI_B	= 2465,
    SRLRI_D	= 2466,
    SRLRI_H	= 2467,
    SRLRI_W	= 2468,
    SRLR_B	= 2469,
    SRLR_D	= 2470,
    SRLR_H	= 2471,
    SRLR_W	= 2472,
    SRLV	= 2473,
    SRLV_MM	= 2474,
    SRL_B	= 2475,
    SRL_D	= 2476,
    SRL_H	= 2477,
    SRL_MM	= 2478,
    SRL_W	= 2479,
    SSNOP	= 2480,
    SSNOP_MM	= 2481,
    SSNOP_MMR6	= 2482,
    ST_B	= 2483,
    ST_D	= 2484,
    ST_H	= 2485,
    ST_W	= 2486,
    SUB	= 2487,
    SUBQH_PH	= 2488,
    SUBQH_PH_MMR2	= 2489,
    SUBQH_R_PH	= 2490,
    SUBQH_R_PH_MMR2	= 2491,
    SUBQH_R_W	= 2492,
    SUBQH_R_W_MMR2	= 2493,
    SUBQH_W	= 2494,
    SUBQH_W_MMR2	= 2495,
    SUBQ_PH	= 2496,
    SUBQ_PH_MM	= 2497,
    SUBQ_S_PH	= 2498,
    SUBQ_S_PH_MM	= 2499,
    SUBQ_S_W	= 2500,
    SUBQ_S_W_MM	= 2501,
    SUBSUS_U_B	= 2502,
    SUBSUS_U_D	= 2503,
    SUBSUS_U_H	= 2504,
    SUBSUS_U_W	= 2505,
    SUBSUU_S_B	= 2506,
    SUBSUU_S_D	= 2507,
    SUBSUU_S_H	= 2508,
    SUBSUU_S_W	= 2509,
    SUBS_S_B	= 2510,
    SUBS_S_D	= 2511,
    SUBS_S_H	= 2512,
    SUBS_S_W	= 2513,
    SUBS_U_B	= 2514,
    SUBS_U_D	= 2515,
    SUBS_U_H	= 2516,
    SUBS_U_W	= 2517,
    SUBU16_MM	= 2518,
    SUBU16_MMR6	= 2519,
    SUBUH_QB	= 2520,
    SUBUH_QB_MMR2	= 2521,
    SUBUH_R_QB	= 2522,
    SUBUH_R_QB_MMR2	= 2523,
    SUBU_MMR6	= 2524,
    SUBU_PH	= 2525,
    SUBU_PH_MMR2	= 2526,
    SUBU_QB	= 2527,
    SUBU_QB_MM	= 2528,
    SUBU_S_PH	= 2529,
    SUBU_S_PH_MMR2	= 2530,
    SUBU_S_QB	= 2531,
    SUBU_S_QB_MM	= 2532,
    SUBVI_B	= 2533,
    SUBVI_D	= 2534,
    SUBVI_H	= 2535,
    SUBVI_W	= 2536,
    SUBV_B	= 2537,
    SUBV_D	= 2538,
    SUBV_H	= 2539,
    SUBV_W	= 2540,
    SUB_MM	= 2541,
    SUB_MMR6	= 2542,
    SUBu	= 2543,
    SUBu_MM	= 2544,
    SUXC1	= 2545,
    SUXC164	= 2546,
    SUXC1_MM	= 2547,
    SW	= 2548,
    SW16_MM	= 2549,
    SW16_MMR6	= 2550,
    SW64	= 2551,
    SWC1	= 2552,
    SWC1_MM	= 2553,
    SWC2	= 2554,
    SWC2_MMR6	= 2555,
    SWC2_R6	= 2556,
    SWC3	= 2557,
    SWDSP	= 2558,
    SWDSP_MM	= 2559,
    SWE	= 2560,
    SWE_MM	= 2561,
    SWL	= 2562,
    SWL64	= 2563,
    SWLE	= 2564,
    SWLE_MM	= 2565,
    SWL_MM	= 2566,
    SWM16_MM	= 2567,
    SWM16_MMR6	= 2568,
    SWM32_MM	= 2569,
    SWP_MM	= 2570,
    SWR	= 2571,
    SWR64	= 2572,
    SWRE	= 2573,
    SWRE_MM	= 2574,
    SWR_MM	= 2575,
    SWSP_MM	= 2576,
    SWSP_MMR6	= 2577,
    SWXC1	= 2578,
    SWXC1_MM	= 2579,
    SW_MM	= 2580,
    SW_MMR6	= 2581,
    SYNC	= 2582,
    SYNCI	= 2583,
    SYNCI_MM	= 2584,
    SYNCI_MMR6	= 2585,
    SYNC_MM	= 2586,
    SYNC_MMR6	= 2587,
    SYSCALL	= 2588,
    SYSCALL_MM	= 2589,
    Save16	= 2590,
    SaveX16	= 2591,
    SbRxRyOffMemX16	= 2592,
    SebRx16	= 2593,
    SehRx16	= 2594,
    ShRxRyOffMemX16	= 2595,
    SllX16	= 2596,
    SllvRxRy16	= 2597,
    SltRxRy16	= 2598,
    SltiRxImm16	= 2599,
    SltiRxImmX16	= 2600,
    SltiuRxImm16	= 2601,
    SltiuRxImmX16	= 2602,
    SltuRxRy16	= 2603,
    SraX16	= 2604,
    SravRxRy16	= 2605,
    SrlX16	= 2606,
    SrlvRxRy16	= 2607,
    SubuRxRyRz16	= 2608,
    SwRxRyOffMemX16	= 2609,
    SwRxSpImmX16	= 2610,
    TEQ	= 2611,
    TEQI	= 2612,
    TEQI_MM	= 2613,
    TEQ_MM	= 2614,
    TGE	= 2615,
    TGEI	= 2616,
    TGEIU	= 2617,
    TGEIU_MM	= 2618,
    TGEI_MM	= 2619,
    TGEU	= 2620,
    TGEU_MM	= 2621,
    TGE_MM	= 2622,
    TLBGINV	= 2623,
    TLBGINVF	= 2624,
    TLBGINVF_MM	= 2625,
    TLBGINV_MM	= 2626,
    TLBGP	= 2627,
    TLBGP_MM	= 2628,
    TLBGR	= 2629,
    TLBGR_MM	= 2630,
    TLBGWI	= 2631,
    TLBGWI_MM	= 2632,
    TLBGWR	= 2633,
    TLBGWR_MM	= 2634,
    TLBINV	= 2635,
    TLBINVF	= 2636,
    TLBINVF_MMR6	= 2637,
    TLBINV_MMR6	= 2638,
    TLBP	= 2639,
    TLBP_MM	= 2640,
    TLBR	= 2641,
    TLBR_MM	= 2642,
    TLBWI	= 2643,
    TLBWI_MM	= 2644,
    TLBWR	= 2645,
    TLBWR_MM	= 2646,
    TLT	= 2647,
    TLTI	= 2648,
    TLTIU_MM	= 2649,
    TLTI_MM	= 2650,
    TLTU	= 2651,
    TLTU_MM	= 2652,
    TLT_MM	= 2653,
    TNE	= 2654,
    TNEI	= 2655,
    TNEI_MM	= 2656,
    TNE_MM	= 2657,
    TRUNC_L_D64	= 2658,
    TRUNC_L_D_MMR6	= 2659,
    TRUNC_L_S	= 2660,
    TRUNC_L_S_MMR6	= 2661,
    TRUNC_W_D32	= 2662,
    TRUNC_W_D64	= 2663,
    TRUNC_W_D_MMR6	= 2664,
    TRUNC_W_MM	= 2665,
    TRUNC_W_S	= 2666,
    TRUNC_W_S_MM	= 2667,
    TRUNC_W_S_MMR6	= 2668,
    TTLTIU	= 2669,
    UDIV	= 2670,
    UDIV_MM	= 2671,
    V3MULU	= 2672,
    VMM0	= 2673,
    VMULU	= 2674,
    VSHF_B	= 2675,
    VSHF_D	= 2676,
    VSHF_H	= 2677,
    VSHF_W	= 2678,
    WAIT	= 2679,
    WAIT_MM	= 2680,
    WAIT_MMR6	= 2681,
    WRDSP	= 2682,
    WRDSP_MM	= 2683,
    WRPGPR_MMR6	= 2684,
    WSBH	= 2685,
    WSBH_MM	= 2686,
    WSBH_MMR6	= 2687,
    XOR	= 2688,
    XOR16_MM	= 2689,
    XOR16_MMR6	= 2690,
    XOR64	= 2691,
    XORI_B	= 2692,
    XORI_MMR6	= 2693,
    XOR_MM	= 2694,
    XOR_MMR6	= 2695,
    XOR_V	= 2696,
    XORi	= 2697,
    XORi64	= 2698,
    XORi_MM	= 2699,
    XorRxRxRy16	= 2700,
    YIELD	= 2701,
    INSTRUCTION_LIST_END = 2702
  };

} // end Mips namespace
} // end llvm namespace
#endif // GET_INSTRINFO_ENUM

#ifdef GET_INSTRINFO_SCHED_ENUM
#undef GET_INSTRINFO_SCHED_ENUM
namespace llvm {

namespace Mips {
namespace Sched {
  enum {
    NoInstrModel	= 0,
    IIPseudo	= 1,
    II_B	= 2,
    II_BCCZAL	= 3,
    II_MTC1	= 4,
    II_MFC1	= 5,
    II_JALR	= 6,
    II_JAL	= 7,
    II_CVT	= 8,
    II_DMULT	= 9,
    II_DMULTU	= 10,
    II_DDIV	= 11,
    II_DDIVU	= 12,
    II_IndirectBranchPseudo	= 13,
    II_MADD	= 14,
    II_MADDU	= 15,
    II_MFHI_MFLO	= 16,
    II_MSUB	= 17,
    II_MSUBU	= 18,
    II_MTHI_MTLO	= 19,
    II_MULT	= 20,
    II_MULTU	= 21,
    II_ReturnPseudo	= 22,
    II_DIV	= 23,
    II_DIVU	= 24,
    II_J	= 25,
    II_JR	= 26,
    II_TRAP	= 27,
    II_ADD	= 28,
    II_ADDIUPC	= 29,
    II_ADDIU	= 30,
    II_ADDU	= 31,
    II_ADDI	= 32,
    II_ALIGN	= 33,
    II_ALUIPC	= 34,
    II_AND	= 35,
    II_ANDI	= 36,
    II_AUI	= 37,
    II_AUIPC	= 38,
    IIM16Alu	= 39,
    II_BADDU	= 40,
    II_BC	= 41,
    II_BALC	= 42,
    II_BBIT	= 43,
    II_BC1CCZ	= 44,
    II_BC1F	= 45,
    II_BC1FL	= 46,
    II_BC1T	= 47,
    II_BC1TL	= 48,
    II_BC2CCZ	= 49,
    II_BCC	= 50,
    II_BCCC	= 51,
    II_BCCZ	= 52,
    II_BCCZC	= 53,
    II_BCCZALS	= 54,
    II_BITSWAP	= 55,
    II_BREAK	= 56,
    II_CACHE	= 57,
    II_CACHEE	= 58,
    II_CEIL	= 59,
    II_CFC1	= 60,
    II_CFC2	= 61,
    II_INS	= 62,
    II_CLASS_D	= 63,
    II_CLASS_S	= 64,
    II_CLO	= 65,
    II_CLZ	= 66,
    II_CMP_CC_D	= 67,
    II_CMP_CC_S	= 68,
    II_CRC32B	= 69,
    II_CRC32CB	= 70,
    II_CRC32CD	= 71,
    II_CRC32CH	= 72,
    II_CRC32CW	= 73,
    II_CRC32D	= 74,
    II_CRC32H	= 75,
    II_CRC32W	= 76,
    II_CTC1	= 77,
    II_CTC2	= 78,
    II_C_CC_D	= 79,
    II_C_CC_S	= 80,
    II_DADD	= 81,
    II_DADDI	= 82,
    II_DADDIU	= 83,
    II_DADDU	= 84,
    II_DAHI	= 85,
    II_DALIGN	= 86,
    II_DATI	= 87,
    II_DAUI	= 88,
    II_DBITSWAP	= 89,
    II_DCLO	= 90,
    II_DCLZ	= 91,
    II_DERET	= 92,
    II_EXT	= 93,
    II_DI	= 94,
    II_DLSA	= 95,
    II_DMFC0	= 96,
    II_DMFC1	= 97,
    II_DMFC2	= 98,
    II_DMFGC0	= 99,
    II_DMOD	= 100,
    II_DMODU	= 101,
    II_DMT	= 102,
    II_DMTC0	= 103,
    II_DMTC1	= 104,
    II_DMTC2	= 105,
    II_DMTGC0	= 106,
    II_DMUH	= 107,
    II_DMUHU	= 108,
    II_DMUL	= 109,
    II_POP	= 110,
    II_DROTR	= 111,
    II_DROTR32	= 112,
    II_DROTRV	= 113,
    II_DSBH	= 114,
    II_DSHD	= 115,
    II_DSLL	= 116,
    II_DSLL32	= 117,
    II_DSLLV	= 118,
    II_DSRA	= 119,
    II_DSRA32	= 120,
    II_DSRAV	= 121,
    II_DSRL	= 122,
    II_DSRL32	= 123,
    II_DSRLV	= 124,
    II_DSUB	= 125,
    II_DSUBU	= 126,
    II_DVP	= 127,
    II_DVPE	= 128,
    II_EHB	= 129,
    II_EI	= 130,
    II_EMT	= 131,
    II_ERET	= 132,
    II_ERETNC	= 133,
    II_EVP	= 134,
    II_EVPE	= 135,
    II_ABS	= 136,
    II_SQRT_D	= 137,
    II_ADD_D	= 138,
    II_ADD_S	= 139,
    II_DIV_D	= 140,
    II_DIV_S	= 141,
    II_FLOOR	= 142,
    II_MOV_D	= 143,
    II_MOV_S	= 144,
    II_MUL_D	= 145,
    II_MUL_S	= 146,
    II_NEG	= 147,
    II_FORK	= 148,
    II_SQRT_S	= 149,
    II_SUB_D	= 150,
    II_SUB_S	= 151,
    II_GINVI	= 152,
    II_GINVT	= 153,
    II_HYPCALL	= 154,
    II_JALR_HB	= 155,
    II_JALRC	= 156,
    II_JALRS	= 157,
    II_JALS	= 158,
    II_JIALC	= 159,
    II_JIC	= 160,
    II_JRADDIUSP	= 161,
    II_JRC	= 162,
    II_JR_HB	= 163,
    II_LB	= 164,
    II_LBE	= 165,
    II_LBU	= 166,
    II_LBUE	= 167,
    II_LD	= 168,
    II_LDC1	= 169,
    II_LDC2	= 170,
    II_LDC3	= 171,
    II_LDL	= 172,
    II_LDPC	= 173,
    II_LDR	= 174,
    II_LDXC1	= 175,
    II_LH	= 176,
    II_LHE	= 177,
    II_LHU	= 178,
    II_LHUE	= 179,
    II_LI	= 180,
    II_LL	= 181,
    II_LLD	= 182,
    II_LLE	= 183,
    II_LSA	= 184,
    II_LUI	= 185,
    II_LUXC1	= 186,
    II_LW	= 187,
    II_LWC1	= 188,
    II_LWC2	= 189,
    II_LWC3	= 190,
    II_LWE	= 191,
    II_LWL	= 192,
    II_LWLE	= 193,
    II_LWM	= 194,
    II_LWPC	= 195,
    II_LWP	= 196,
    II_LWR	= 197,
    II_LWRE	= 198,
    II_LWUPC	= 199,
    II_LWU	= 200,
    II_LWXC1	= 201,
    II_LWXS	= 202,
    II_MADDF_D	= 203,
    II_MADDF_S	= 204,
    II_MADD_D	= 205,
    II_MADD_S	= 206,
    II_MAX_D	= 207,
    II_MAXA_D	= 208,
    II_MAX_S	= 209,
    II_MAXA_S	= 210,
    II_MFC0	= 211,
    II_MFC2	= 212,
    II_MFGC0	= 213,
    II_MFHC0	= 214,
    II_MFHC1	= 215,
    II_MFHGC0	= 216,
    II_MFTR	= 217,
    II_MIN_S	= 218,
    II_MINA_D	= 219,
    II_MIN_D	= 220,
    II_MINA_S	= 221,
    II_MOD	= 222,
    II_MODU	= 223,
    II_MOVE	= 224,
    II_MOVF_D	= 225,
    II_MOVF	= 226,
    II_MOVF_S	= 227,
    II_MOVN_D	= 228,
    II_MOVN	= 229,
    II_MOVN_S	= 230,
    II_MOVT_D	= 231,
    II_MOVT	= 232,
    II_MOVT_S	= 233,
    II_MOVZ_D	= 234,
    II_MOVZ	= 235,
    II_MOVZ_S	= 236,
    II_MSUBF_D	= 237,
    II_MSUBF_S	= 238,
    II_MSUB_D	= 239,
    II_MSUB_S	= 240,
    II_MTC0	= 241,
    II_MTC2	= 242,
    II_MTGC0	= 243,
    II_MTHC0	= 244,
    II_MTHC1	= 245,
    II_MTHGC0	= 246,
    II_MTTR	= 247,
    II_MUH	= 248,
    II_MUHU	= 249,
    II_MUL	= 250,
    II_MULU	= 251,
    II_NMADD_D	= 252,
    II_NMADD_S	= 253,
    II_NMSUB_D	= 254,
    II_NMSUB_S	= 255,
    II_NOR	= 256,
    II_NOT	= 257,
    II_OR	= 258,
    II_ORI	= 259,
    II_PAUSE	= 260,
    II_PREF	= 261,
    II_PREFE	= 262,
    II_RDHWR	= 263,
    II_RDPGPR	= 264,
    II_RECIP_D	= 265,
    II_RECIP_S	= 266,
    II_RINT_D	= 267,
    II_RINT_S	= 268,
    II_ROTR	= 269,
    II_ROTRV	= 270,
    II_ROUND	= 271,
    II_RSQRT_D	= 272,
    II_RSQRT_S	= 273,
    II_RESTORE	= 274,
    II_SB	= 275,
    II_SBE	= 276,
    II_SC	= 277,
    II_SCD	= 278,
    II_SCE	= 279,
    II_SD	= 280,
    II_SDBBP	= 281,
    II_SDC1	= 282,
    II_SDC2	= 283,
    II_SDC3	= 284,
    II_SDL	= 285,
    II_SDR	= 286,
    II_SDXC1	= 287,
    II_SEB	= 288,
    II_SEH	= 289,
    II_SELCCZ	= 290,
    II_SELCCZ_D	= 291,
    II_SELCCZ_S	= 292,
    II_SEL_D	= 293,
    II_SEL_S	= 294,
    II_SEQ_SNE	= 295,
    II_SEQI_SNEI	= 296,
    II_SH	= 297,
    II_SHE	= 298,
    II_SIGRIE	= 299,
    II_SLL	= 300,
    II_SLLV	= 301,
    II_SLT_SLTU	= 302,
    II_SLTI_SLTIU	= 303,
    II_SRA	= 304,
    II_SRAV	= 305,
    II_SRL	= 306,
    II_SRLV	= 307,
    II_SSNOP	= 308,
    II_SUB	= 309,
    II_SUBU	= 310,
    II_SUXC1	= 311,
    II_SW	= 312,
    II_SWC1	= 313,
    II_SWC2	= 314,
    II_SWC3	= 315,
    II_SWE	= 316,
    II_SWL	= 317,
    II_SWLE	= 318,
    II_SWM	= 319,
    II_SWP	= 320,
    II_SWR	= 321,
    II_SWRE	= 322,
    II_SWXC1	= 323,
    II_SYNC	= 324,
    II_SYNCI	= 325,
    II_SYSCALL	= 326,
    II_SAVE	= 327,
    II_TEQ	= 328,
    II_TEQI	= 329,
    II_TGE	= 330,
    II_TGEI	= 331,
    II_TGEIU	= 332,
    II_TGEU	= 333,
    II_TLBGINV	= 334,
    II_TLBGINVF	= 335,
    II_TLBGP	= 336,
    II_TLBGR	= 337,
    II_TLBGWI	= 338,
    II_TLBGWR	= 339,
    II_TLBINV	= 340,
    II_TLBINVF	= 341,
    II_TLBP	= 342,
    II_TLBR	= 343,
    II_TLBWI	= 344,
    II_TLBWR	= 345,
    II_TLT	= 346,
    II_TLTI	= 347,
    II_TTLTIU	= 348,
    II_TLTU	= 349,
    II_TNE	= 350,
    II_TNEI	= 351,
    II_TRUNC	= 352,
    II_WAIT	= 353,
    II_WRPGPR	= 354,
    II_WSBH	= 355,
    II_XOR	= 356,
    II_XORI	= 357,
    II_YIELD	= 358,
    AND	= 359,
    LUi	= 360,
    NOR	= 361,
    OR	= 362,
    SLTi_SLTiu	= 363,
    SUB	= 364,
    SUBu	= 365,
    XOR	= 366,
    SSNOP	= 367,
    NOP	= 368,
    B	= 369,
    BAL	= 370,
    BAL_BR_BGEZAL_BGEZALL_BLTZAL_BLTZALL	= 371,
    BEQ_BEQL_BNE_BNEL	= 372,
    BGEZ_BGEZL_BGTZ_BGTZL_BLEZ_BLEZL_BLTZ_BLTZL	= 373,
    BREAK	= 374,
    DERET	= 375,
    ERET	= 376,
    ERet_RetRA	= 377,
    ERETNC	= 378,
    J_TAILCALL	= 379,
    JR_TAILCALLREG_TAILCALLREGHB	= 380,
    JR_HB	= 381,
    PseudoIndirectBranch_PseudoIndirectHazardBranch	= 382,
    PseudoReturn	= 383,
    SDBBP	= 384,
    SYSCALL	= 385,
    TEQ	= 386,
    TEQI	= 387,
    TGE	= 388,
    TGEI	= 389,
    TGEIU	= 390,
    TGEU	= 391,
    TLT	= 392,
    TLTI	= 393,
    TLTU	= 394,
    TNE	= 395,
    TNEI	= 396,
    TRAP	= 397,
    TTLTIU	= 398,
    WAIT	= 399,
    PAUSE	= 400,
    JAL	= 401,
    JALR_JALRHBPseudo_JALRPseudo	= 402,
    JALR_HB	= 403,
    JALX	= 404,
    TLBINV	= 405,
    TLBINVF	= 406,
    TLBP	= 407,
    TLBR	= 408,
    TLBWI	= 409,
    TLBWR	= 410,
    MFC0	= 411,
    MTC0	= 412,
    MFC2	= 413,
    MTC2	= 414,
    HYPCALL	= 415,
    MFGC0	= 416,
    MFHGC0	= 417,
    MTGC0	= 418,
    MTHGC0	= 419,
    TLBGINV	= 420,
    TLBGINVF	= 421,
    TLBGP	= 422,
    TLBGR	= 423,
    TLBGWI	= 424,
    TLBGWR	= 425,
    LB	= 426,
    LBu	= 427,
    LH	= 428,
    LHu	= 429,
    LW	= 430,
    LL	= 431,
    LWC2	= 432,
    LWC3	= 433,
    LDC2	= 434,
    LDC3	= 435,
    LBE	= 436,
    LBuE	= 437,
    LHE	= 438,
    LHuE	= 439,
    LWE	= 440,
    LLE	= 441,
    LWPC	= 442,
    LWL	= 443,
    LWR	= 444,
    LWLE	= 445,
    LWRE	= 446,
    SB	= 447,
    SH	= 448,
    SW	= 449,
    SWC2	= 450,
    SWC3	= 451,
    SDC2	= 452,
    SDC3	= 453,
    SC	= 454,
    SBE	= 455,
    SHE	= 456,
    SWE	= 457,
    SCE	= 458,
    SWL	= 459,
    SWR	= 460,
    SWLE	= 461,
    SWRE	= 462,
    PREF	= 463,
    PREFE	= 464,
    CACHE	= 465,
    CACHEE	= 466,
    SYNC	= 467,
    SYNCI	= 468,
    CLO	= 469,
    CLZ	= 470,
    DI	= 471,
    EI	= 472,
    MFHI_MFLO_PseudoMFHI_PseudoMFLO	= 473,
    EHB	= 474,
    RDHWR	= 475,
    WSBH	= 476,
    MOVN_I_I	= 477,
    MOVZ_I_I	= 478,
    DIV_PseudoSDIV_SDIV	= 479,
    DIVU_PseudoUDIV_UDIV	= 480,
    MUL	= 481,
    MULT_PseudoMULT	= 482,
    MULTu_PseudoMULTu	= 483,
    MADD_PseudoMADD	= 484,
    MADDU_PseudoMADDU	= 485,
    MSUB_PseudoMSUB	= 486,
    MSUBU_PseudoMSUBU	= 487,
    MTHI_MTLO_PseudoMTLOHI	= 488,
    EXT	= 489,
    INS	= 490,
    ADD	= 491,
    ADDi	= 492,
    ADDiu	= 493,
    ANDi	= 494,
    ORi	= 495,
    ROTR	= 496,
    SEB	= 497,
    SEH	= 498,
    SLT_SLTu	= 499,
    SLL	= 500,
    SRA	= 501,
    SRL	= 502,
    XORi	= 503,
    ADDu	= 504,
    SLLV	= 505,
    SRAV	= 506,
    SRLV	= 507,
    LSA	= 508,
    COPY	= 509,
    VSHF_B_VSHF_D_VSHF_H_VSHF_W	= 510,
    BINSLI_B_BINSLI_D_BINSLI_H_BINSLI_W_BINSL_B_BINSL_D_BINSL_H_BINSL_W	= 511,
    BINSRI_B_BINSRI_D_BINSRI_H_BINSRI_W_BINSR_B_BINSR_D_BINSR_H_BINSR_W	= 512,
    INSERT_B_INSERT_D_INSERT_H_INSERT_W	= 513,
    SLDI_B_SLDI_D_SLDI_H_SLDI_W_SLD_B_SLD_D_SLD_H_SLD_W	= 514,
    BSETI_B_BSETI_D_BSETI_H_BSETI_W_BSET_B_BSET_D_BSET_H_BSET_W	= 515,
    BCLRI_B_BCLRI_D_BCLRI_H_BCLRI_W_BCLR_B_BCLR_D_BCLR_H_BCLR_W	= 516,
    BNEGI_B_BNEGI_D_BNEGI_H_BNEGI_W_BNEG_B_BNEG_D_BNEG_H_BNEG_W	= 517,
    BSELI_B_BSEL_V	= 518,
    BMNZI_B_BMNZ_V_BMZI_B_BMZ_V	= 519,
    BSEL_D_PSEUDO_BSEL_FD_PSEUDO_BSEL_FW_PSEUDO_BSEL_H_PSEUDO_BSEL_W_PSEUDO	= 520,
    PCNT_B_PCNT_D_PCNT_H_PCNT_W	= 521,
    SAT_S_B_SAT_S_D_SAT_S_H_SAT_S_W_SAT_U_B_SAT_U_D_SAT_U_H_SAT_U_W	= 522,
    BNZ_B_BNZ_D_BNZ_H_BNZ_V_BNZ_W_BZ_B_BZ_D_BZ_H_BZ_V_BZ_W	= 523,
    CFCMSA_CTCMSA	= 524,
    FABS_S_FABS_D32_FABS_D64	= 525,
    MOVF_D32_MOVF_D64	= 526,
    MOVF_S	= 527,
    MOVT_D32_MOVT_D64	= 528,
    MOVT_S	= 529,
    FMOV_D32_FMOV_D64	= 530,
    FMOV_S	= 531,
    FNEG_S_FNEG_D32_FNEG_D64	= 532,
    ADD_A_B_ADD_A_D_ADD_A_H_ADD_A_W	= 533,
    ADDS_A_B_ADDS_A_D_ADDS_A_H_ADDS_A_W_ADDS_S_B_ADDS_S_D_ADDS_S_H_ADDS_S_W_ADDS_U_B_ADDS_U_D_ADDS_U_H_ADDS_U_W	= 534,
    ADDVI_B_ADDVI_D_ADDVI_H_ADDVI_W_ADDV_B_ADDV_D_ADDV_H_ADDV_W	= 535,
    ASUB_S_B_ASUB_S_D_ASUB_S_H_ASUB_S_W_ASUB_U_B_ASUB_U_D_ASUB_U_H_ASUB_U_W	= 536,
    AVER_S_B_AVER_S_D_AVER_S_H_AVER_S_W_AVER_U_B_AVER_U_D_AVER_U_H_AVER_U_W_AVE_S_B_AVE_S_D_AVE_S_H_AVE_S_W_AVE_U_B_AVE_U_D_AVE_U_H_AVE_U_W	= 537,
    SHF_B_SHF_H_SHF_W	= 538,
    FILL_B_FILL_D_FILL_H_FILL_W	= 539,
    SPLATI_B_SPLATI_D_SPLATI_H_SPLATI_W_SPLAT_B_SPLAT_D_SPLAT_H_SPLAT_W	= 540,
    MOVE_V	= 541,
    LDI_B_LDI_D_LDI_H_LDI_W	= 542,
    AND_V_NOR_V_OR_V_XOR_V	= 543,
    ANDI_B_NORI_B_ORI_B_XORI_B	= 544,
    AND_V_D_PSEUDO_AND_V_H_PSEUDO_AND_V_W_PSEUDO_NOR_V_D_PSEUDO_NOR_V_H_PSEUDO_NOR_V_W_PSEUDO_OR_V_D_PSEUDO_OR_V_H_PSEUDO_OR_V_W_PSEUDO_XOR_V_D_PSEUDO_XOR_V_H_PSEUDO_XOR_V_W_PSEUDO	= 545,
    FILL_FD_PSEUDO_FILL_FW_PSEUDO	= 546,
    INSERT_FD_PSEUDO_INSERT_FW_PSEUDO	= 547,
    FEXP2_D_FEXP2_W	= 548,
    CLTI_S_B_CLTI_S_D_CLTI_S_H_CLTI_S_W_CLTI_U_B_CLTI_U_D_CLTI_U_H_CLTI_U_W_CLT_S_B_CLT_S_D_CLT_S_H_CLT_S_W_CLT_U_B_CLT_U_D_CLT_U_H_CLT_U_W	= 549,
    CLEI_S_B_CLEI_S_D_CLEI_S_H_CLEI_S_W_CLEI_U_B_CLEI_U_D_CLEI_U_H_CLEI_U_W_CLE_S_B_CLE_S_D_CLE_S_H_CLE_S_W_CLE_U_B_CLE_U_D_CLE_U_H_CLE_U_W	= 550,
    CEQI_B_CEQI_D_CEQI_H_CEQI_W_CEQ_B_CEQ_D_CEQ_H_CEQ_W	= 551,
    CMP_UN_D	= 552,
    CMP_UN_S	= 553,
    CMP_UEQ_D	= 554,
    CMP_UEQ_S	= 555,
    CMP_EQ_D	= 556,
    CMP_EQ_S	= 557,
    CMP_LT_D	= 558,
    CMP_LT_S	= 559,
    CMP_ULT_D	= 560,
    CMP_ULT_S	= 561,
    CMP_LE_D	= 562,
    CMP_LE_S	= 563,
    CMP_ULE_D	= 564,
    CMP_ULE_S	= 565,
    FSAF_D_FSAF_W_FSEQ_D_FSEQ_W_FSLE_D_FSLE_W_FSLT_D_FSLT_W_FSNE_D_FSNE_W_FSOR_D_FSOR_W	= 566,
    FSUEQ_D_FSUEQ_W	= 567,
    FSULE_D_FSULE_W	= 568,
    FSULT_D_FSULT_W	= 569,
    FSUNE_D_FSUNE_W	= 570,
    FSUN_D_FSUN_W	= 571,
    FCAF_D_FCAF_W	= 572,
    FCEQ_D_FCEQ_W	= 573,
    FCLE_D_FCLE_W	= 574,
    FCLT_D_FCLT_W	= 575,
    FCNE_D_FCNE_W	= 576,
    FCOR_D_FCOR_W	= 577,
    FCUEQ_D_FCUEQ_W	= 578,
    FCULE_D_FCULE_W	= 579,
    FCULT_D_FCULT_W	= 580,
    FCUNE_D_FCUNE_W	= 581,
    FCUN_D_FCUN_W	= 582,
    FABS_D_FABS_W	= 583,
    FFINT_S_D_FFINT_S_W_FFINT_U_D_FFINT_U_W	= 584,
    FFQL_D_FFQL_W	= 585,
    FFQR_D_FFQR_W	= 586,
    FTINT_S_D_FTINT_S_W_FTINT_U_D_FTINT_U_W	= 587,
    FRINT_D_FRINT_W	= 588,
    FTQ_H_FTQ_W	= 589,
    FTRUNC_S_D_FTRUNC_S_W_FTRUNC_U_D_FTRUNC_U_W	= 590,
    FEXDO_H_FEXDO_W	= 591,
    FEXUPL_D_FEXUPL_W	= 592,
    FEXUPR_D_FEXUPR_W	= 593,
    FCLASS_D_FCLASS_W	= 594,
    FMAX_A_D_FMAX_A_W	= 595,
    FMAX_D_FMAX_W	= 596,
    FMIN_A_D_FMIN_A_W	= 597,
    FMIN_D_FMIN_W	= 598,
    FLOG2_D_FLOG2_W	= 599,
    ILVL_B_ILVL_D_ILVL_H_ILVL_W_ILVR_B_ILVR_D_ILVR_H_ILVR_W	= 600,
    ILVEV_B_ILVEV_D_ILVEV_H_ILVEV_W_ILVOD_B_ILVOD_D_ILVOD_H_ILVOD_W	= 601,
    INSVE_B_INSVE_D_INSVE_H_INSVE_W	= 602,
    SUBS_S_B_SUBS_S_D_SUBS_S_H_SUBS_S_W_SUBS_U_B_SUBS_U_D_SUBS_U_H_SUBS_U_W	= 603,
    SUBSUS_U_B_SUBSUS_U_D_SUBSUS_U_H_SUBSUS_U_W	= 604,
    SUBSUU_S_B_SUBSUU_S_D_SUBSUU_S_H_SUBSUU_S_W	= 605,
    SUBVI_B_SUBVI_D_SUBVI_H_SUBVI_W	= 606,
    SUBV_B_SUBV_D_SUBV_H_SUBV_W	= 607,
    MOD_S_B_MOD_S_D_MOD_S_H_MOD_S_W_MOD_U_B_MOD_U_D_MOD_U_H_MOD_U_W	= 608,
    DIV_S_B_DIV_S_D_DIV_S_H_DIV_S_W_DIV_U_B_DIV_U_D_DIV_U_H_DIV_U_W	= 609,
    HADD_S_D_HADD_S_H_HADD_S_W_HADD_U_D_HADD_U_H_HADD_U_W	= 610,
    HSUB_S_D_HSUB_S_H_HSUB_S_W_HSUB_U_D_HSUB_U_H_HSUB_U_W	= 611,
    MAX_S_B_MAX_S_D_MAX_S_H_MAX_S_W_MIN_S_B_MIN_S_D_MIN_S_H_MIN_S_W	= 612,
    MAX_U_B_MAX_U_D_MAX_U_H_MAX_U_W_MIN_U_B_MIN_U_D_MIN_U_H_MIN_U_W	= 613,
    MAX_A_B_MAX_A_D_MAX_A_H_MAX_A_W_MIN_A_B_MIN_A_D_MIN_A_H_MIN_A_W	= 614,
    MAXI_S_B_MAXI_S_D_MAXI_S_H_MAXI_S_W_MAXI_U_B_MAXI_U_D_MAXI_U_H_MAXI_U_W_MINI_S_B_MINI_S_D_MINI_S_H_MINI_S_W_MINI_U_B_MINI_U_D_MINI_U_H_MINI_U_W	= 615,
    SRAI_B_SRAI_D_SRAI_H_SRAI_W_SRA_B_SRA_D_SRA_H_SRA_W	= 616,
    SRLI_B_SRLI_D_SRLI_H_SRLI_W_SRL_B_SRL_D_SRL_H_SRL_W	= 617,
    SRARI_B_SRARI_D_SRARI_H_SRARI_W_SRAR_B_SRAR_D_SRAR_H_SRAR_W	= 618,
    SRLRI_B_SRLRI_D_SRLRI_H_SRLRI_W_SRLR_B_SRLR_D_SRLR_H_SRLR_W	= 619,
    SLLI_B_SLLI_D_SLLI_H_SLLI_W_SLL_B_SLL_D_SLL_H_SLL_W	= 620,
    PCKEV_B_PCKEV_D_PCKEV_H_PCKEV_W_PCKOD_B_PCKOD_D_PCKOD_H_PCKOD_W	= 621,
    NLOC_B_NLOC_D_NLOC_H_NLOC_W_NLZC_B_NLZC_D_NLZC_H_NLZC_W	= 622,
    FADD_D32_FADD_D64	= 623,
    FADD_S	= 624,
    FMUL_D32_FMUL_D64	= 625,
    FMUL_S	= 626,
    FSUB_D32_FSUB_D64	= 627,
    FSUB_S	= 628,
    TRUNC_L_D64_TRUNC_L_S_TRUNC_W_D32_TRUNC_W_D64_TRUNC_W_S	= 629,
    CVT_D32_S_CVT_D32_W_CVT_D64_L_CVT_D64_S_CVT_D64_W_CVT_L_D64_CVT_L_S_CVT_S_D32_CVT_S_D64_CVT_S_L_CVT_S_W_CVT_W_D32_CVT_W_D64_CVT_W_S	= 630,
    CVT_PS_S64_CVT_S_PL64_CVT_S_PU64	= 631,
    C_EQ_D32_C_EQ_D64_C_F_D32_C_F_D64_C_LE_D32_C_LE_D64_C_LT_D32_C_LT_D64_C_NGE_D32_C_NGE_D64_C_NGLE_D32_C_NGLE_D64_C_NGL_D32_C_NGL_D64_C_NGT_D32_C_NGT_D64_C_OLE_D32_C_OLE_D64_C_OLT_D32_C_OLT_D64_C_SEQ_D32_C_SEQ_D64_C_SF_D32_C_SF_D64_C_UEQ_D32_C_UEQ_D64_C_ULE_D32_C_ULE_D64_C_ULT_D32_C_ULT_D64_C_UN_D32_C_UN_D64	= 632,
    C_EQ_S_C_F_S_C_LE_S_C_LT_S_C_NGE_S_C_NGLE_S_C_NGL_S_C_NGT_S_C_OLE_S_C_OLT_S_C_SEQ_S_C_SF_S_C_UEQ_S_C_ULE_S_C_ULT_S_C_UN_S	= 633,
    FCMP_D32_FCMP_D64	= 634,
    FCMP_S32	= 635,
    PseudoCVT_D32_W_PseudoCVT_D64_L_PseudoCVT_D64_W_PseudoCVT_S_L_PseudoCVT_S_W	= 636,
    PLL_PS64_PLU_PS64	= 637,
    FDIV_S	= 638,
    FDIV_D32_FDIV_D64	= 639,
    FSQRT_S	= 640,
    FSQRT_D32_FSQRT_D64	= 641,
    FRCP_D_FRCP_W	= 642,
    FRSQRT_D_FRSQRT_W	= 643,
    RECIP_D32_RECIP_D64	= 644,
    RSQRT_D32_RSQRT_D64	= 645,
    RECIP_S	= 646,
    RSQRT_S	= 647,
    FMADD_D_FMADD_W	= 648,
    FMSUB_D_FMSUB_W	= 649,
    FDIV_W	= 650,
    FDIV_D	= 651,
    FSQRT_W	= 652,
    FSQRT_D	= 653,
    FMUL_D_FMUL_W	= 654,
    FADD_D_FADD_W	= 655,
    FSUB_D_FSUB_W	= 656,
    DPADD_S_D_DPADD_S_H_DPADD_S_W_DPADD_U_D_DPADD_U_H_DPADD_U_W	= 657,
    DPSUB_S_D_DPSUB_S_H_DPSUB_S_W_DPSUB_U_D_DPSUB_U_H_DPSUB_U_W	= 658,
    DOTP_S_D_DOTP_S_H_DOTP_S_W_DOTP_U_D_DOTP_U_H_DOTP_U_W	= 659,
    MSUBV_B_MSUBV_D_MSUBV_H_MSUBV_W	= 660,
    MADDV_B_MADDV_D_MADDV_H_MADDV_W	= 661,
    MULV_B_MULV_D_MULV_H_MULV_W	= 662,
    MADDR_Q_H_MADDR_Q_W	= 663,
    MADD_Q_H_MADD_Q_W	= 664,
    MSUBR_Q_H_MSUBR_Q_W	= 665,
    MSUB_Q_H_MSUB_Q_W	= 666,
    MULR_Q_H_MULR_Q_W	= 667,
    MUL_Q_H_MUL_Q_W	= 668,
    MADD_D32_MADD_D64	= 669,
    MADD_S	= 670,
    MSUB_D32_MSUB_D64	= 671,
    MSUB_S	= 672,
    NMADD_D32_NMADD_D64	= 673,
    NMADD_S	= 674,
    NMSUB_D32_NMSUB_D64	= 675,
    NMSUB_S	= 676,
    CTC1	= 677,
    MTC1_MTC1_D64_BuildPairF64_BuildPairF64_64	= 678,
    MTHC1_D32_MTHC1_D64	= 679,
    COPY_U_B_COPY_U_H_COPY_U_W	= 680,
    COPY_S_B_COPY_S_D_COPY_S_H_COPY_S_W	= 681,
    BC1F	= 682,
    BC1FL	= 683,
    BC1T	= 684,
    BC1TL	= 685,
    CFC1	= 686,
    MFC1_MFC1_D64_ExtractElementF64_ExtractElementF64_64	= 687,
    MFHC1_D32_MFHC1_D64	= 688,
    MOVF_I	= 689,
    MOVT_I	= 690,
    SDC1_SDC164	= 691,
    SDXC1_SDXC164	= 692,
    SWC1	= 693,
    SWXC1	= 694,
    SUXC1_SUXC164	= 695,
    ST_B_ST_D_ST_H_ST_W	= 696,
    ST_F16	= 697,
    MOVN_I_D32_MOVN_I_D64	= 698,
    MOVN_I_S	= 699,
    MOVZ_I_D32_MOVZ_I_D64	= 700,
    MOVZ_I_S	= 701,
    LDC1_LDC164	= 702,
    LDXC1_LDXC164	= 703,
    LWC1	= 704,
    LWXC1	= 705,
    LUXC1_LUXC164	= 706,
    LD_B_LD_D_LD_H_LD_W	= 707,
    LD_F16	= 708,
    CEIL_L_D64_CEIL_L_S_CEIL_W_D32_CEIL_W_D64_CEIL_W_S	= 709,
    FLOOR_L_D64_FLOOR_L_S_FLOOR_W_D32_FLOOR_W_D64_FLOOR_W_S	= 710,
    ROUND_L_D64_ROUND_L_S_ROUND_W_D32_ROUND_W_D64_ROUND_W_S	= 711,
    ROTRV	= 712,
    ATOMIC_SWAP_I16_POSTRA_ATOMIC_SWAP_I32_POSTRA_ATOMIC_SWAP_I64_POSTRA_ATOMIC_SWAP_I8_POSTRA	= 713,
    ATOMIC_CMP_SWAP_I16_POSTRA_ATOMIC_CMP_SWAP_I32_POSTRA_ATOMIC_CMP_SWAP_I64_POSTRA_ATOMIC_CMP_SWAP_I8_POSTRA	= 714,
    ATOMIC_LOAD_ADD_I16_POSTRA_ATOMIC_LOAD_ADD_I32_POSTRA_ATOMIC_LOAD_ADD_I64_POSTRA_ATOMIC_LOAD_ADD_I8_POSTRA_ATOMIC_LOAD_AND_I16_POSTRA_ATOMIC_LOAD_AND_I32_POSTRA_ATOMIC_LOAD_AND_I64_POSTRA_ATOMIC_LOAD_AND_I8_POSTRA_ATOMIC_LOAD_NAND_I16_POSTRA_ATOMIC_LOAD_NAND_I32_POSTRA_ATOMIC_LOAD_NAND_I64_POSTRA_ATOMIC_LOAD_NAND_I8_POSTRA_ATOMIC_LOAD_OR_I16_POSTRA_ATOMIC_LOAD_OR_I32_POSTRA_ATOMIC_LOAD_OR_I64_POSTRA_ATOMIC_LOAD_OR_I8_POSTRA_ATOMIC_LOAD_SUB_I16_POSTRA_ATOMIC_LOAD_SUB_I32_POSTRA_ATOMIC_LOAD_SUB_I64_POSTRA_ATOMIC_LOAD_SUB_I8_POSTRA_ATOMIC_LOAD_XOR_I16_POSTRA_ATOMIC_LOAD_XOR_I32_POSTRA_ATOMIC_LOAD_XOR_I64_POSTRA_ATOMIC_LOAD_XOR_I8_POSTRA	= 715,
    LEA_ADDiu	= 716,
    ADDIUPC	= 717,
    ALIGN	= 718,
    ALUIPC	= 719,
    AUI	= 720,
    AUIPC	= 721,
    BITSWAP	= 722,
    CLO_R6	= 723,
    CLZ_R6	= 724,
    LSA_R6	= 725,
    SELEQZ_SELNEZ	= 726,
    AddiuRxImmX16_AddiuRxRxImm16_AddiuRxRxImmX16_AddiuRxRyOffMemX16_AddiuRxPcImmX16_AddiuSpImm16_AddiuSpImmX16_AdduRxRyRz16_AndRxRxRy16_CmpRxRy16_CmpiRxImm16_CmpiRxImmX16_LiRxImm16_LiRxImmX16_LiRxImmAlignX16_Move32R16_MoveR3216_Mfhi16_Mflo16_NegRxRy16_NotRxRy16_OrRxRxRy16_SebRx16_SehRx16_SllX16_SllvRxRy16_SltiRxImm16_SltiRxImmX16_SltiuRxImm16_SltiuRxImmX16_SltRxRy16_SltuRxRy16_SravRxRy16_SraX16_SrlvRxRy16_SrlX16_SubuRxRyRz16_XorRxRxRy16	= 727,
    SltiCCRxImmX16_SltiuCCRxImmX16_SltCCRxRy16_SltuRxRyRz16_SltuCCRxRy16	= 728,
    Constant32_LwConstant32_GotPrologue16_CONSTPOOL_ENTRY	= 729,
    ADDIUPC_MM_ADDIUR1SP_MM_ADDIUR2_MM_ADDIUS5_MM_ADDIUSP_MM_ADDiu_MM_LEA_ADDiu_MM	= 730,
    ADDU16_MM_ADDu_MM	= 731,
    ADD_MM	= 732,
    ADDi_MM	= 733,
    AND16_MM_ANDI16_MM_AND_MM	= 734,
    ANDi_MM	= 735,
    CLO_MM	= 736,
    CLZ_MM	= 737,
    EXT_MM	= 738,
    INS_MM	= 739,
    LI16_MM	= 740,
    LUi_MM	= 741,
    MOVE16_MM	= 742,
    MOVEP_MM	= 743,
    NOR_MM	= 744,
    NOT16_MM	= 745,
    OR16_MM_OR_MM	= 746,
    ORi_MM	= 747,
    ROTRV_MM	= 748,
    ROTR_MM	= 749,
    SEB_MM	= 750,
    SEH_MM	= 751,
    SLL16_MM_SLL_MM	= 752,
    SLLV_MM	= 753,
    SLT_MM_SLTu_MM	= 754,
    SLTi_MM_SLTiu_MM	= 755,
    SRAV_MM	= 756,
    SRA_MM	= 757,
    SRL16_MM_SRL_MM	= 758,
    SRLV_MM	= 759,
    SSNOP_MM	= 760,
    SUBU16_MM_SUBu_MM	= 761,
    SUB_MM	= 762,
    WSBH_MM	= 763,
    XOR16_MM_XOR_MM	= 764,
    XORi_MM	= 765,
    ADDIUPC_MMR6	= 766,
    ADDIU_MMR6	= 767,
    ADDU16_MMR6_ADDU_MMR6	= 768,
    ADD_MMR6	= 769,
    ALIGN_MMR6	= 770,
    ALUIPC_MMR6	= 771,
    AND16_MMR6_ANDI16_MMR6_AND_MMR6	= 772,
    ANDI_MMR6	= 773,
    AUIPC_MMR6	= 774,
    AUI_MMR6	= 775,
    BITSWAP_MMR6	= 776,
    CLO_MMR6	= 777,
    CLZ_MMR6	= 778,
    EXT_MMR6	= 779,
    INS_MMR6	= 780,
    LI16_MMR6	= 781,
    LSA_MMR6	= 782,
    LUI_MMR6	= 783,
    MOVE16_MMR6	= 784,
    NOR_MMR6	= 785,
    NOT16_MMR6	= 786,
    OR16_MMR6_OR_MMR6	= 787,
    ORI_MMR6	= 788,
    SELEQZ_MMR6_SELNEZ_MMR6	= 789,
    SLL16_MMR6_SLL_MMR6	= 790,
    SRL16_MMR6	= 791,
    SSNOP_MMR6	= 792,
    SUBU16_MMR6_SUBU_MMR6	= 793,
    SUB_MMR6	= 794,
    WSBH_MMR6	= 795,
    XOR16_MMR6_XOR_MMR6	= 796,
    XORI_MMR6	= 797,
    AND64_ANDi64	= 798,
    DEXT64_32	= 799,
    DSLL64_32	= 800,
    ORi64	= 801,
    SEB64	= 802,
    SEH64	= 803,
    SLL64_32_SLL64_64	= 804,
    SLT64_SLTu64	= 805,
    SLTi64_SLTiu64	= 806,
    XOR64_XORi64	= 807,
    DADD	= 808,
    DADDi	= 809,
    DADDiu	= 810,
    DADDu	= 811,
    DCLO	= 812,
    DCLZ	= 813,
    DEXT_DEXTM_DEXTU	= 814,
    DINS_DINSM_DINSU	= 815,
    DROTR	= 816,
    DROTR32	= 817,
    DROTRV	= 818,
    DSBH	= 819,
    DSHD	= 820,
    DSLL	= 821,
    DSLL32	= 822,
    DSLLV	= 823,
    DSRA	= 824,
    DSRA32	= 825,
    DSRAV	= 826,
    DSRL	= 827,
    DSRL32	= 828,
    DSRLV	= 829,
    DSUB	= 830,
    DSUBu	= 831,
    LEA_ADDiu64	= 832,
    LUi64	= 833,
    NOR64	= 834,
    OR64	= 835,
    DALIGN	= 836,
    DAHI	= 837,
    DATI	= 838,
    DAUI	= 839,
    DCLO_R6	= 840,
    DCLZ_R6	= 841,
    DBITSWAP	= 842,
    DLSA_DLSA_R6	= 843,
    SELEQZ64_SELNEZ64	= 844,
    MADD	= 845,
    MADDU	= 846,
    MSUB	= 847,
    MSUBU	= 848,
    PseudoMADD_MM	= 849,
    PseudoMADDU_MM	= 850,
    PseudoMSUB_MM	= 851,
    PseudoMSUBU_MM	= 852,
    PseudoMULT_MM	= 853,
    PseudoMULTu_MM	= 854,
    PseudoMULT	= 855,
    PseudoMULTu	= 856,
    PseudoSDIV_SDIV	= 857,
    PseudoUDIV_UDIV	= 858,
    PseudoMFHI_MM_PseudoMFLO_MM	= 859,
    PseudoMTLOHI_MM	= 860,
    MUH	= 861,
    MUHU	= 862,
    MULU	= 863,
    MUL_R6	= 864,
    MOD	= 865,
    MODU	= 866,
    MultRxRy16_MultuRxRy16_MultRxRyRz16_MultuRxRyRz16	= 867,
    DivRxRy16	= 868,
    DivuRxRy16	= 869,
    MULT_MM	= 870,
    MULTu_MM	= 871,
    MADD_MM	= 872,
    MADDU_MM	= 873,
    MSUB_MM	= 874,
    MSUBU_MM	= 875,
    MUL_MM	= 876,
    SDIV_MM_SDIV_MM_Pseudo	= 877,
    UDIV_MM_UDIV_MM_Pseudo	= 878,
    MFHI16_MM_MFLO16_MM_MFHI_MM_MFLO_MM	= 879,
    MOVF_I_MM	= 880,
    MOVT_I_MM	= 881,
    MTHI_MM_MTLO_MM	= 882,
    RDHWR_MM	= 883,
    MUHU_MMR6	= 884,
    MUH_MMR6	= 885,
    MULU_MMR6	= 886,
    MUL_MMR6	= 887,
    MODU_MMR6	= 888,
    MOD_MMR6	= 889,
    DIVU_MMR6	= 890,
    DIV_MMR6	= 891,
    RDHWR_MMR6	= 892,
    DMULU	= 893,
    DMULT_PseudoDMULT	= 894,
    DMULTu_PseudoDMULTu	= 895,
    DSDIV_PseudoDSDIV	= 896,
    DUDIV_PseudoDUDIV	= 897,
    MFHI64_MFLO64_PseudoMFHI64_PseudoMFLO64	= 898,
    PseudoMTLOHI64	= 899,
    MTHI64_MTLO64	= 900,
    RDHWR64	= 901,
    MOVN_I_I64_MOVN_I64_I_MOVN_I64_I64	= 902,
    MOVZ_I_I64_MOVZ_I64_I_MOVZ_I64_I64	= 903,
    DMUH	= 904,
    DMUHU	= 905,
    DMUL_R6	= 906,
    DDIV	= 907,
    DMOD	= 908,
    DDIVU	= 909,
    DMODU	= 910,
    BAL_BR_BLTZAL	= 911,
    BEQ_BNE	= 912,
    BGTZ_BGEZ_BLEZ_BLTZ	= 913,
    J	= 914,
    JR	= 915,
    ERet	= 916,
    BGEZAL	= 917,
    BALC	= 918,
    BEQZALC_BGEZALC_BGTZALC_BLEZALC_BLTZALC_BNEZALC	= 919,
    JIALC	= 920,
    BC	= 921,
    BC2EQZ_BC2NEZ	= 922,
    BEQC_BGEC_BGEUC_BLTC_BLTUC_BNEC_BNVC_BOVC	= 923,
    BEQZC_BGEZC_BGTZC_BLEZC_BLTZC_BNEZC	= 924,
    JIC	= 925,
    JR_HB_R6	= 926,
    SIGRIE	= 927,
    PseudoIndirectBranchR6_PseudoIndrectHazardBranchR6	= 928,
    TAILCALLR6REG_TAILCALLHBR6REG	= 929,
    SDBBP_R6	= 930,
    Bimm16_BimmX16_BeqzRxImm16_BeqzRxImmX16_BnezRxImm16_BnezRxImmX16_Bteqz16_BteqzX16_Btnez16_BtnezX16_JrRa16_JrcRa16_JrcRx16	= 931,
    BteqzT8CmpX16_BteqzT8CmpiX16_BteqzT8SltX16_BteqzT8SltuX16_BteqzT8SltiX16_BteqzT8SltiuX16_BtnezT8CmpX16_BtnezT8CmpiX16_BtnezT8SltX16_BtnezT8SltuX16_BtnezT8SltiX16_BtnezT8SltiuX16_RetRA16	= 932,
    Jal16_JalB16	= 933,
    JumpLinkReg16	= 934,
    Break16	= 935,
    SelBeqZ_SelTBteqZCmp_SelTBteqZCmpi_SelTBteqZSlt_SelTBteqZSlti_SelTBteqZSltu_SelTBteqZSltiu_SelBneZ_SelTBtneZCmp_SelTBtneZCmpi_SelTBtneZSlt_SelTBtneZSlti_SelTBtneZSltu_SelTBtneZSltiu	= 936,
    B16_MM_B_MM	= 937,
    BAL_BR_MM	= 938,
    BC1F_MM	= 939,
    BC1T_MM	= 940,
    BEQZ16_MM_BGEZ_MM_BGTZ_MM_BLEZ_MM_BLTZ_MM_BNEZ16_MM	= 941,
    BEQZC_MM_BNEZC_MM	= 942,
    BEQ_MM_BNE_MM	= 943,
    DERET_MM	= 944,
    ERET_MM	= 945,
    JR16_MM_JR_MM	= 946,
    J_MM	= 947,
    B_MM_Pseudo	= 948,
    BGEZALS_MM_BLTZALS_MM	= 949,
    BGEZAL_MM_BLTZAL_MM	= 950,
    JALR16_MM_JALR_MM	= 951,
    JALRS16_MM_JALRS_MM	= 952,
    JALS_MM	= 953,
    JALX_MM_JAL_MM	= 954,
    TAILCALLREG_MM	= 955,
    TAILCALL_MM	= 956,
    PseudoIndirectBranch_MM	= 957,
    BREAK16_MM_BREAK_MM	= 958,
    SDBBP16_MM_SDBBP_MM	= 959,
    SYSCALL_MM	= 960,
    TEQI_MM	= 961,
    TEQ_MM	= 962,
    TGEIU_MM	= 963,
    TGEI_MM	= 964,
    TGEU_MM	= 965,
    TGE_MM	= 966,
    TLTIU_MM	= 967,
    TLTI_MM	= 968,
    TLTU_MM	= 969,
    TLT_MM	= 970,
    TNEI_MM	= 971,
    TNE_MM	= 972,
    TRAP_MM	= 973,
    BC16_MMR6_BC_MMR6	= 974,
    BC1EQZC_MMR6_BC1NEZC_MMR6	= 975,
    BC2EQZC_MMR6_BC2NEZC_MMR6	= 976,
    BEQC_MMR6_BGEC_MMR6_BGEUC_MMR6_BLTC_MMR6_BLTUC_MMR6_BNEC_MMR6_BNVC_MMR6_BOVC_MMR6	= 977,
    BEQZC16_MMR6_BNEZC16_MMR6	= 978,
    BEQZC_MMR6_BGEZC_MMR6_BGTZC_MMR6_BLEZC_MMR6_BLTZC_MMR6_BNEZC_MMR6	= 979,
    DERET_MMR6	= 980,
    ERETNC_MMR6	= 981,
    JAL_MMR6	= 982,
    ERET_MMR6	= 983,
    JIC_MMR6	= 984,
    JRADDIUSP_JRCADDIUSP_MMR6	= 985,
    JRC16_MM	= 986,
    JRC16_MMR6	= 987,
    SIGRIE_MMR6	= 988,
    B_MMR6_Pseudo	= 989,
    PseudoIndirectBranch_MMR6	= 990,
    BALC_MMR6	= 991,
    BEQZALC_MMR6_BGEZALC_MMR6_BGTZALC_MMR6_BLEZALC_MMR6_BLTZALC_MMR6_BNEZALC_MMR6	= 992,
    JALRC16_MMR6	= 993,
    JALRC_HB_MMR6	= 994,
    JALRC_MMR6	= 995,
    JIALC_MMR6	= 996,
    TAILCALLREG_MMR6	= 997,
    TAILCALL_MMR6	= 998,
    BREAK16_MMR6_BREAK_MMR6	= 999,
    SDBBP_MMR6_SDBBP16_MMR6	= 1000,
    BEQ64_BNE64	= 1001,
    BGEZ64_BGTZ64_BLEZ64_BLTZ64	= 1002,
    JR64	= 1003,
    JALR64_JALR64Pseudo_JALRHB64Pseudo	= 1004,
    JALR_HB64	= 1005,
    JR_HB64	= 1006,
    TAILCALLREG64_TAILCALLREGHB64	= 1007,
    PseudoReturn64	= 1008,
    BEQC64_BGEC64_BGEUC64_BLTC64_BLTUC64_BNEC64	= 1009,
    BEQZC64_BGEZC64_BGTZC64_BLEZC64_BLTZC64_BNEZC64	= 1010,
    JIC64	= 1011,
    PseudoIndirectBranch64_PseudoIndirectHazardBranch64	= 1012,
    JIALC64	= 1013,
    JR_HB64_R6	= 1014,
    TAILCALL64R6REG_TAILCALLHB64R6REG	= 1015,
    PseudoIndirectBranch64R6_PseudoIndrectHazardBranch64R6	= 1016,
    EVP	= 1017,
    DVP	= 1018,
    TLBP_MM	= 1019,
    TLBR_MM	= 1020,
    TLBWI_MM	= 1021,
    TLBWR_MM	= 1022,
    DI_MM	= 1023,
    EI_MM	= 1024,
    EHB_MM	= 1025,
    PAUSE_MM	= 1026,
    WAIT_MM	= 1027,
    RDPGPR_MMR6	= 1028,
    WRPGPR_MMR6	= 1029,
    TLBINV_MMR6	= 1030,
    TLBINVF_MMR6	= 1031,
    MFHC0_MMR6	= 1032,
    MFC0_MMR6	= 1033,
    MFHC2_MMR6_MFC2_MMR6	= 1034,
    MTHC0_MMR6	= 1035,
    MTC0_MMR6	= 1036,
    MTHC2_MMR6_MTC2_MMR6	= 1037,
    EVP_MMR6	= 1038,
    DVP_MMR6	= 1039,
    DI_MMR6	= 1040,
    EI_MMR6	= 1041,
    EHB_MMR6	= 1042,
    PAUSE_MMR6	= 1043,
    WAIT_MMR6	= 1044,
    DMFC0	= 1045,
    DMTC0	= 1046,
    DMFC2	= 1047,
    DMTC2	= 1048,
    CFC2_MM	= 1049,
    CTC2_MM	= 1050,
    DMT	= 1051,
    DVPE	= 1052,
    EMT	= 1053,
    EVPE	= 1054,
    MFTR	= 1055,
    MTTR	= 1056,
    YIELD	= 1057,
    FORK	= 1058,
    DMFGC0	= 1059,
    DMTGC0	= 1060,
    HYPCALL_MM	= 1061,
    TLBGINVF_MM	= 1062,
    TLBGINV_MM	= 1063,
    TLBGP_MM	= 1064,
    TLBGR_MM	= 1065,
    TLBGWI_MM	= 1066,
    TLBGWR_MM	= 1067,
    MFGC0_MM	= 1068,
    MFHGC0_MM	= 1069,
    MTGC0_MM	= 1070,
    MTHGC0_MM	= 1071,
    SC_MMR6	= 1072,
    LDC2_R6	= 1073,
    LL_R6	= 1074,
    LWC2_R6	= 1075,
    SWC2_R6	= 1076,
    SDC2_R6	= 1077,
    SC_R6	= 1078,
    PREF_R6	= 1079,
    CACHE_R6	= 1080,
    GINVI	= 1081,
    GINVT	= 1082,
    LBE_MM	= 1083,
    LBuE_MM	= 1084,
    LHE_MM	= 1085,
    LHuE_MM	= 1086,
    LWE_MM	= 1087,
    LWLE_MM	= 1088,
    LWRE_MM	= 1089,
    LLE_MM	= 1090,
    SBE_MM	= 1091,
    SB_MM	= 1092,
    SHE_MM	= 1093,
    SWE_MM	= 1094,
    SWLE_MM	= 1095,
    SWRE_MM	= 1096,
    SCE_MM	= 1097,
    PREFE_MM	= 1098,
    CACHEE_MM	= 1099,
    Restore16_RestoreX16	= 1100,
    LbRxRyOffMemX16	= 1101,
    LbuRxRyOffMemX16	= 1102,
    LhRxRyOffMemX16	= 1103,
    LhuRxRyOffMemX16	= 1104,
    LwRxRyOffMemX16_LwRxSpImmX16_LwRxPcTcp16_LwRxPcTcpX16	= 1105,
    Save16_SaveX16	= 1106,
    SbRxRyOffMemX16	= 1107,
    ShRxRyOffMemX16	= 1108,
    SwRxRyOffMemX16_SwRxSpImmX16	= 1109,
    LBU16_MM_LBu_MM	= 1110,
    LB_MM	= 1111,
    LHU16_MM_LHu_MM	= 1112,
    LH_MM	= 1113,
    LL_MM	= 1114,
    LW16_MM_LWGP_MM_LWSP_MM_LW_MM	= 1115,
    LWL_MM	= 1116,
    LWM16_MM_LWM32_MM	= 1117,
    LWP_MM	= 1118,
    LWR_MM	= 1119,
    LWU_MM	= 1120,
    LWXS_MM	= 1121,
    SB16_MM	= 1122,
    SC_MM	= 1123,
    SH16_MM_SH_MM	= 1124,
    SW16_MM_SWSP_MM_SW_MM	= 1125,
    SWL_MM	= 1126,
    SWM16_MM_SWM32_MM	= 1127,
    SWM_MM	= 1128,
    SWP_MM	= 1129,
    SWR_MM	= 1130,
    PREF_MM_PREFX_MM	= 1131,
    CACHE_MM	= 1132,
    SYNC_MM	= 1133,
    SYNCI_MM	= 1134,
    GINVI_MMR6	= 1135,
    GINVT_MMR6	= 1136,
    LBU_MMR6	= 1137,
    LB_MMR6	= 1138,
    LDC2_MMR6	= 1139,
    LL_MMR6	= 1140,
    LWM16_MMR6	= 1141,
    LWC2_MMR6	= 1142,
    LWPC_MMR6	= 1143,
    LW_MMR6	= 1144,
    SB16_MMR6_SB_MMR6	= 1145,
    SDC2_MMR6	= 1146,
    SH16_MMR6_SH_MMR6	= 1147,
    SW16_MMR6_SWSP_MMR6_SW_MMR6	= 1148,
    SWC2_MMR6	= 1149,
    SWM16_MMR6	= 1150,
    SYNC_MMR6	= 1151,
    SYNCI_MMR6	= 1152,
    PREF_MMR6	= 1153,
    CACHE_MMR6	= 1154,
    LD	= 1155,
    LL64_LLD	= 1156,
    LWu	= 1157,
    LB64	= 1158,
    LBu64	= 1159,
    LH64	= 1160,
    LHu64	= 1161,
    LW64	= 1162,
    LWL64	= 1163,
    LWR64	= 1164,
    LDL	= 1165,
    LDR	= 1166,
    SD	= 1167,
    SC64_SCD	= 1168,
    SB64	= 1169,
    SH64	= 1170,
    SW64	= 1171,
    SWL64	= 1172,
    SWR64	= 1173,
    SDL	= 1174,
    SDR	= 1175,
    LWUPC	= 1176,
    LDPC	= 1177,
    LLD_R6	= 1178,
    LL64_R6	= 1179,
    SC64_R6	= 1180,
    SCD_R6	= 1181,
    CRC32B	= 1182,
    CRC32H	= 1183,
    CRC32W	= 1184,
    CRC32CB	= 1185,
    CRC32CH	= 1186,
    CRC32CW	= 1187,
    CRC32D	= 1188,
    CRC32CD	= 1189,
    BADDu	= 1190,
    BBIT0_BBIT032_BBIT1_BBIT132	= 1191,
    CINS_CINS32_CINS64_32_CINS_i32	= 1192,
    DMFC2_OCTEON	= 1193,
    DMTC2_OCTEON	= 1194,
    DPOP_POP	= 1195,
    EXTS_EXTS32	= 1196,
    MTM0_MTM1_MTM2_MTP0_MTP1_MTP2	= 1197,
    SEQ_SNE	= 1198,
    SEQi_SNEi	= 1199,
    V3MULU_VMM0_VMULU	= 1200,
    DMUL	= 1201,
    PseudoTRUNC_W_D_PseudoTRUNC_W_D32_PseudoTRUNC_W_S	= 1202,
    MOVT_I64	= 1203,
    MOVF_I64	= 1204,
    MOVZ_I64_S	= 1205,
    MOVN_I64_D64	= 1206,
    MOVN_I64_S	= 1207,
    MOVZ_I64_D64	= 1208,
    SELEQZ_S_SELNEZ_S	= 1209,
    SELEQZ_D_SELNEZ_D	= 1210,
    MAX_S_MAXA_S	= 1211,
    MAX_D_MAXA_D	= 1212,
    MIN_S_MINA_D	= 1213,
    MIN_D_MINA_S	= 1214,
    CLASS_S	= 1215,
    CLASS_D	= 1216,
    RINT_S	= 1217,
    RINT_D	= 1218,
    BC1EQZ_BC1NEZ	= 1219,
    SEL_D	= 1220,
    SEL_S	= 1221,
    MADDF_S	= 1222,
    MSUBF_S	= 1223,
    MADDF_D	= 1224,
    MSUBF_D	= 1225,
    MOVF_D32_MM	= 1226,
    MOVF_S_MM	= 1227,
    MOVN_I_D32_MM	= 1228,
    MOVN_I_S_MM	= 1229,
    MOVT_D32_MM	= 1230,
    MOVT_S_MM	= 1231,
    MOVZ_I_D32_MM	= 1232,
    MOVZ_I_S_MM	= 1233,
    CVT_D32_S_MM_CVT_D32_W_MM_CVT_D64_S_MM_CVT_D64_W_MM_CVT_L_D64_MM_CVT_L_S_MM_CVT_S_D32_MM_CVT_S_D64_MM_CVT_S_W_MM_CVT_W_D32_MM_CVT_W_D64_MM_CVT_W_S_MM	= 1234,
    CEIL_W_MM_CEIL_W_S_MM	= 1235,
    FLOOR_W_MM_FLOOR_W_S_MM	= 1236,
    NMADD_S_MM	= 1237,
    NMADD_D32_MM	= 1238,
    NMSUB_S_MM	= 1239,
    NMSUB_D32_MM	= 1240,
    MADD_S_MM	= 1241,
    MADD_D32_MM	= 1242,
    ROUND_W_MM_ROUND_W_S_MM	= 1243,
    TRUNC_W_MM_TRUNC_W_S_MM	= 1244,
    C_F_D32_MM_C_F_D64_MM	= 1245,
    C_F_S_MM	= 1246,
    C_EQ_D32_MM_C_EQ_D64_MM_C_LE_D32_MM_C_LE_D64_MM_C_LT_D32_MM_C_LT_D64_MM_C_SF_D32_MM_C_SF_D64_MM_C_UN_D32_MM_C_UN_D64_MM	= 1247,
    C_EQ_S_MM_C_LE_S_MM_C_LT_S_MM_C_SF_S_MM_C_UN_S_MM	= 1248,
    C_NGE_D32_MM_C_NGE_D64_MM_C_NGL_D32_MM_C_NGL_D64_MM_C_NGT_D32_MM_C_NGT_D64_MM_C_OLE_D32_MM_C_OLE_D64_MM_C_OLT_D32_MM_C_OLT_D64_MM_C_SEQ_D32_MM_C_SEQ_D64_MM_C_UEQ_D32_MM_C_UEQ_D64_MM_C_ULE_D32_MM_C_ULE_D64_MM_C_ULT_D32_MM_C_ULT_D64_MM	= 1249,
    C_NGE_S_MM_C_NGL_S_MM_C_NGT_S_MM_C_OLE_S_MM_C_OLT_S_MM_C_SEQ_S_MM_C_UEQ_S_MM_C_ULE_S_MM_C_ULT_S_MM	= 1250,
    C_NGLE_D32_MM_C_NGLE_D64_MM	= 1251,
    C_NGLE_S_MM	= 1252,
    FCMP_S32_MM	= 1253,
    FCMP_D32_MM	= 1254,
    MFC1_MM	= 1255,
    MFHC1_D32_MM_MFHC1_D64_MM	= 1256,
    MTC1_MM_MTC1_D64_MM	= 1257,
    MTHC1_D32_MM_MTHC1_D64_MM	= 1258,
    FABS_D32_MM_FABS_D64_MM	= 1259,
    FABS_S_MM	= 1260,
    FNEG_D32_MM_FNEG_D64_MM_FNEG_S_MM	= 1261,
    FADD_D32_MM_FADD_D64_MM	= 1262,
    FADD_S_MM	= 1263,
    FMOV_D32_MM_FMOV_D64_MM	= 1264,
    FMOV_S_MM	= 1265,
    FMUL_D32_MM_FMUL_D64_MM	= 1266,
    FMUL_S_MM	= 1267,
    FSUB_D32_MM_FSUB_D64_MM	= 1268,
    FSUB_S_MM	= 1269,
    MSUB_S_MM	= 1270,
    MSUB_D32_MM	= 1271,
    FDIV_S_MM	= 1272,
    FDIV_D32_MM_FDIV_D64_MM	= 1273,
    FSQRT_S_MM	= 1274,
    FSQRT_D32_MM_FSQRT_D64_MM	= 1275,
    RECIP_S_MM_RSQRT_S_MM	= 1276,
    RECIP_D32_MM_RECIP_D64_MM_RSQRT_D32_MM_RSQRT_D64_MM	= 1277,
    SDC1_MM	= 1278,
    SWC1_MM	= 1279,
    SUXC1_MM	= 1280,
    SWXC1_MM	= 1281,
    CFC1_MM	= 1282,
    CTC1_MM	= 1283,
    LDC1_MM	= 1284,
    LUXC1_MM	= 1285,
    LWC1_MM	= 1286,
    LWXC1_MM	= 1287,
    FNEG_S_MMR6	= 1288,
    CMP_AF_D_MMR6_CMP_EQ_D_MMR6_CMP_LE_D_MMR6_CMP_LT_D_MMR6_CMP_UN_D_MMR6	= 1289,
    CMP_AF_S_MMR6_CMP_EQ_S_MMR6_CMP_LE_S_MMR6_CMP_LT_S_MMR6_CMP_UN_S_MMR6	= 1290,
    CMP_SAF_D_MMR6_CMP_SEQ_D_MMR6_CMP_SLE_D_MMR6_CMP_SLT_D_MMR6_CMP_SUN_D_MMR6_CMP_UEQ_D_MMR6_CMP_ULE_D_MMR6_CMP_ULT_D_MMR6	= 1291,
    CMP_SAF_S_MMR6_CMP_SEQ_S_MMR6_CMP_SLE_S_MMR6_CMP_SLT_S_MMR6_CMP_SUN_S_MMR6_CMP_UEQ_S_MMR6_CMP_ULE_S_MMR6_CMP_ULT_S_MMR6	= 1292,
    CMP_SUEQ_D_MMR6_CMP_SULE_D_MMR6_CMP_SULT_D_MMR6	= 1293,
    CMP_SUEQ_S_MMR6_CMP_SULE_S_MMR6_CMP_SULT_S_MMR6	= 1294,
    CVT_D_L_MMR6_CVT_L_D_MMR6_CVT_L_S_MMR6_CVT_S_L_MMR6_CVT_S_W_MMR6_CVT_W_S_MMR6	= 1295,
    TRUNC_L_D_MMR6_TRUNC_L_S_MMR6_TRUNC_W_D_MMR6_TRUNC_W_S_MMR6	= 1296,
    ROUND_L_D_MMR6_ROUND_L_S_MMR6_ROUND_W_D_MMR6_ROUND_W_S_MMR6	= 1297,
    FLOOR_L_D_MMR6_FLOOR_L_S_MMR6_FLOOR_W_D_MMR6_FLOOR_W_S_MMR6	= 1298,
    CEIL_L_D_MMR6_CEIL_L_S_MMR6_CEIL_W_D_MMR6_CEIL_W_S_MMR6	= 1299,
    MFC1_MMR6	= 1300,
    MTC1_MMR6	= 1301,
    CLASS_S_MMR6_CLASS_D_MMR6	= 1302,
    FADD_S_MMR6	= 1303,
    MAX_D_MMR6	= 1304,
    MAX_S_MMR6	= 1305,
    MIN_D_MMR6	= 1306,
    MIN_S_MMR6	= 1307,
    MAXA_D_MMR6	= 1308,
    MAXA_S_MMR6	= 1309,
    MINA_D_MMR6	= 1310,
    MINA_S_MMR6	= 1311,
    SELEQZ_D_MMR6_SELNEZ_D_MMR6	= 1312,
    SELEQZ_S_MMR6_SELNEZ_S_MMR6	= 1313,
    SEL_D_MMR6	= 1314,
    SEL_S_MMR6	= 1315,
    RINT_S_MMR6_RINT_D_MMR6	= 1316,
    MADDF_D_MMR6	= 1317,
    MADDF_S_MMR6	= 1318,
    MSUBF_D_MMR6	= 1319,
    MSUBF_S_MMR6	= 1320,
    FMOV_S_MMR6	= 1321,
    FMUL_S_MMR6	= 1322,
    FSUB_S_MMR6	= 1323,
    FMOV_D_MMR6	= 1324,
    FDIV_S_MMR6	= 1325,
    SDC1_D64_MMR6	= 1326,
    LDC1_D64_MMR6	= 1327,
    DMFC1	= 1328,
    DMTC1	= 1329,
    SWDSP	= 1330,
    LWDSP	= 1331,
    PseudoMTLOHI_DSP	= 1332,
    EXTRV_RS_W	= 1333,
    EXTRV_R_W	= 1334,
    EXTRV_S_H	= 1335,
    EXTRV_W	= 1336,
    EXTR_RS_W	= 1337,
    EXTR_R_W	= 1338,
    EXTR_S_H	= 1339,
    EXTR_W	= 1340,
    INSV	= 1341,
    MTHLIP	= 1342,
    MTHI_DSP	= 1343,
    MTLO_DSP	= 1344,
    ABSQ_S_PH	= 1345,
    ABSQ_S_W	= 1346,
    ADDQ_PH	= 1347,
    ADDQ_S_PH	= 1348,
    ADDQ_S_W	= 1349,
    ADDSC	= 1350,
    ADDU_QB	= 1351,
    ADDU_S_QB	= 1352,
    ADDWC	= 1353,
    BITREV	= 1354,
    BPOSGE32	= 1355,
    CMPGU_EQ_QB	= 1356,
    CMPGU_LE_QB	= 1357,
    CMPGU_LT_QB	= 1358,
    CMPU_EQ_QB	= 1359,
    CMPU_LE_QB	= 1360,
    CMPU_LT_QB	= 1361,
    CMP_EQ_PH	= 1362,
    CMP_LE_PH	= 1363,
    CMP_LT_PH	= 1364,
    DPAQ_SA_L_W	= 1365,
    DPAQ_S_W_PH	= 1366,
    DPAU_H_QBL	= 1367,
    DPAU_H_QBR	= 1368,
    DPSQ_SA_L_W	= 1369,
    DPSQ_S_W_PH	= 1370,
    DPSU_H_QBL	= 1371,
    DPSU_H_QBR	= 1372,
    EXTPDPV	= 1373,
    EXTPDP	= 1374,
    EXTPV	= 1375,
    EXTP	= 1376,
    LBUX	= 1377,
    LHX	= 1378,
    LWX	= 1379,
    MADDU_DSP	= 1380,
    MADD_DSP	= 1381,
    MAQ_SA_W_PHL	= 1382,
    MAQ_SA_W_PHR	= 1383,
    MAQ_S_W_PHL	= 1384,
    MAQ_S_W_PHR	= 1385,
    MFHI_DSP	= 1386,
    MFLO_DSP	= 1387,
    MODSUB	= 1388,
    MSUBU_DSP	= 1389,
    MSUB_DSP	= 1390,
    MULEQ_S_W_PHL	= 1391,
    MULEQ_S_W_PHR	= 1392,
    MULEU_S_PH_QBL	= 1393,
    MULEU_S_PH_QBR	= 1394,
    MULQ_RS_PH	= 1395,
    MULSAQ_S_W_PH	= 1396,
    MULTU_DSP	= 1397,
    MULT_DSP	= 1398,
    PACKRL_PH	= 1399,
    PICK_PH	= 1400,
    PICK_QB	= 1401,
    PRECEQU_PH_QBLA	= 1402,
    PRECEQU_PH_QBL	= 1403,
    PRECEQU_PH_QBRA	= 1404,
    PRECEQU_PH_QBR	= 1405,
    PRECEQ_W_PHL	= 1406,
    PRECEQ_W_PHR	= 1407,
    PRECEU_PH_QBLA	= 1408,
    PRECEU_PH_QBL	= 1409,
    PRECEU_PH_QBRA	= 1410,
    PRECEU_PH_QBR	= 1411,
    PRECRQU_S_QB_PH	= 1412,
    PRECRQ_PH_W	= 1413,
    PRECRQ_QB_PH	= 1414,
    PRECRQ_RS_PH_W	= 1415,
    RADDU_W_QB	= 1416,
    RDDSP	= 1417,
    REPLV_PH	= 1418,
    REPLV_QB	= 1419,
    REPL_PH	= 1420,
    REPL_QB	= 1421,
    SHILOV	= 1422,
    SHILO	= 1423,
    SHLLV_PH	= 1424,
    SHLLV_QB	= 1425,
    SHLLV_S_PH	= 1426,
    SHLLV_S_W	= 1427,
    SHLL_PH	= 1428,
    SHLL_QB	= 1429,
    SHLL_S_PH	= 1430,
    SHLL_S_W	= 1431,
    SHRAV_PH	= 1432,
    SHRAV_R_PH	= 1433,
    SHRAV_R_W	= 1434,
    SHRA_PH	= 1435,
    SHRA_R_PH	= 1436,
    SHRA_R_W	= 1437,
    SHRLV_QB	= 1438,
    SHRL_QB	= 1439,
    SUBQ_PH	= 1440,
    SUBQ_S_PH	= 1441,
    SUBQ_S_W	= 1442,
    SUBU_QB	= 1443,
    SUBU_S_QB	= 1444,
    WRDSP	= 1445,
    PseudoCMPU_EQ_QB_PseudoCMPU_LE_QB_PseudoCMPU_LT_QB_PseudoCMP_EQ_PH_PseudoCMP_LE_PH_PseudoCMP_LT_PH	= 1446,
    PseudoPICK_PH_PseudoPICK_QB	= 1447,
    ABSQ_S_QB	= 1448,
    ADDQH_PH	= 1449,
    ADDQH_R_PH	= 1450,
    ADDQH_R_W	= 1451,
    ADDQH_W	= 1452,
    ADDUH_QB	= 1453,
    ADDUH_R_QB	= 1454,
    ADDU_PH	= 1455,
    ADDU_S_PH	= 1456,
    APPEND	= 1457,
    BALIGN	= 1458,
    CMPGDU_EQ_QB	= 1459,
    CMPGDU_LE_QB	= 1460,
    CMPGDU_LT_QB	= 1461,
    DPA_W_PH	= 1462,
    DPAQX_SA_W_PH	= 1463,
    DPAQX_S_W_PH	= 1464,
    DPAX_W_PH	= 1465,
    DPS_W_PH	= 1466,
    DPSQX_S_W_PH	= 1467,
    DPSQX_SA_W_PH	= 1468,
    DPSX_W_PH	= 1469,
    MUL_PH	= 1470,
    MUL_S_PH	= 1471,
    MULQ_RS_W	= 1472,
    MULQ_S_PH	= 1473,
    MULQ_S_W	= 1474,
    MULSA_W_PH	= 1475,
    PRECR_QB_PH	= 1476,
    PRECR_SRA_PH_W	= 1477,
    PRECR_SRA_R_PH_W	= 1478,
    PREPEND	= 1479,
    SHRA_QB	= 1480,
    SHRA_R_QB	= 1481,
    SHRAV_QB	= 1482,
    SHRAV_R_QB	= 1483,
    SHRL_PH	= 1484,
    SHRLV_PH	= 1485,
    SUBQH_PH	= 1486,
    SUBQH_R_PH	= 1487,
    SUBQH_W	= 1488,
    SUBQH_R_W	= 1489,
    SUBU_PH	= 1490,
    SUBU_S_PH	= 1491,
    SUBUH_QB	= 1492,
    SUBUH_R_QB	= 1493,
    LWDSP_MM	= 1494,
    SWDSP_MM	= 1495,
    ABSQ_S_PH_MM	= 1496,
    ABSQ_S_W_MM	= 1497,
    ADDQ_PH_MM	= 1498,
    ADDQ_S_PH_MM	= 1499,
    ADDQ_S_W_MM	= 1500,
    ADDSC_MM	= 1501,
    ADDU_QB_MM	= 1502,
    ADDU_S_QB_MM	= 1503,
    ADDWC_MM	= 1504,
    BITREV_MM	= 1505,
    BPOSGE32_MM	= 1506,
    CMPGU_EQ_QB_MM	= 1507,
    CMPGU_LE_QB_MM	= 1508,
    CMPGU_LT_QB_MM	= 1509,
    CMPU_EQ_QB_MM	= 1510,
    CMPU_LE_QB_MM	= 1511,
    CMPU_LT_QB_MM	= 1512,
    CMP_EQ_PH_MM	= 1513,
    CMP_LE_PH_MM	= 1514,
    CMP_LT_PH_MM	= 1515,
    DPAQ_SA_L_W_MM	= 1516,
    DPAQ_S_W_PH_MM	= 1517,
    DPAU_H_QBL_MM	= 1518,
    DPAU_H_QBR_MM	= 1519,
    DPSQ_SA_L_W_MM	= 1520,
    DPSQ_S_W_PH_MM	= 1521,
    DPSU_H_QBL_MM	= 1522,
    DPSU_H_QBR_MM	= 1523,
    EXTPDPV_MM	= 1524,
    EXTPDP_MM	= 1525,
    EXTPV_MM	= 1526,
    EXTP_MM	= 1527,
    EXTRV_RS_W_MM	= 1528,
    EXTRV_R_W_MM	= 1529,
    EXTRV_S_H_MM	= 1530,
    EXTRV_W_MM	= 1531,
    EXTR_RS_W_MM	= 1532,
    EXTR_R_W_MM	= 1533,
    EXTR_S_H_MM	= 1534,
    EXTR_W_MM	= 1535,
    INSV_MM	= 1536,
    LBUX_MM	= 1537,
    LHX_MM	= 1538,
    LWX_MM	= 1539,
    MADDU_DSP_MM	= 1540,
    MADD_DSP_MM	= 1541,
    MAQ_SA_W_PHL_MM	= 1542,
    MAQ_SA_W_PHR_MM	= 1543,
    MAQ_S_W_PHL_MM	= 1544,
    MAQ_S_W_PHR_MM	= 1545,
    MFHI_DSP_MM	= 1546,
    MFLO_DSP_MM	= 1547,
    MODSUB_MM	= 1548,
    MOVEP_MMR6	= 1549,
    MOVN_I_MM	= 1550,
    MOVZ_I_MM	= 1551,
    MSUBU_DSP_MM	= 1552,
    MSUB_DSP_MM	= 1553,
    MTHI_DSP_MM	= 1554,
    MTHLIP_MM	= 1555,
    MTLO_DSP_MM	= 1556,
    MULEQ_S_W_PHL_MM	= 1557,
    MULEQ_S_W_PHR_MM	= 1558,
    MULEU_S_PH_QBL_MM	= 1559,
    MULEU_S_PH_QBR_MM	= 1560,
    MULQ_RS_PH_MM	= 1561,
    MULSAQ_S_W_PH_MM	= 1562,
    MULTU_DSP_MM	= 1563,
    MULT_DSP_MM	= 1564,
    PACKRL_PH_MM	= 1565,
    PICK_PH_MM	= 1566,
    PICK_QB_MM	= 1567,
    PRECEQU_PH_QBLA_MM	= 1568,
    PRECEQU_PH_QBL_MM	= 1569,
    PRECEQU_PH_QBRA_MM	= 1570,
    PRECEQU_PH_QBR_MM	= 1571,
    PRECEQ_W_PHL_MM	= 1572,
    PRECEQ_W_PHR_MM	= 1573,
    PRECEU_PH_QBLA_MM	= 1574,
    PRECEU_PH_QBL_MM	= 1575,
    PRECEU_PH_QBRA_MM	= 1576,
    PRECEU_PH_QBR_MM	= 1577,
    PRECRQU_S_QB_PH_MM	= 1578,
    PRECRQ_PH_W_MM	= 1579,
    PRECRQ_QB_PH_MM	= 1580,
    PRECRQ_RS_PH_W_MM	= 1581,
    RADDU_W_QB_MM	= 1582,
    RDDSP_MM	= 1583,
    REPLV_PH_MM	= 1584,
    REPLV_QB_MM	= 1585,
    REPL_PH_MM	= 1586,
    REPL_QB_MM	= 1587,
    SHILOV_MM	= 1588,
    SHILO_MM	= 1589,
    SHLLV_PH_MM	= 1590,
    SHLLV_QB_MM	= 1591,
    SHLLV_S_PH_MM	= 1592,
    SHLLV_S_W_MM	= 1593,
    SHLL_PH_MM	= 1594,
    SHLL_QB_MM	= 1595,
    SHLL_S_PH_MM	= 1596,
    SHLL_S_W_MM	= 1597,
    SHRAV_PH_MM	= 1598,
    SHRAV_R_PH_MM	= 1599,
    SHRAV_R_W_MM	= 1600,
    SHRA_PH_MM	= 1601,
    SHRA_R_PH_MM	= 1602,
    SHRA_R_W_MM	= 1603,
    SHRLV_QB_MM	= 1604,
    SHRL_QB_MM	= 1605,
    SUBQ_PH_MM	= 1606,
    SUBQ_S_PH_MM	= 1607,
    SUBQ_S_W_MM	= 1608,
    SUBU_QB_MM	= 1609,
    SUBU_S_QB_MM	= 1610,
    WRDSP_MM	= 1611,
    ABSQ_S_QB_MMR2	= 1612,
    ADDQH_PH_MMR2	= 1613,
    ADDQH_R_PH_MMR2	= 1614,
    ADDQH_R_W_MMR2	= 1615,
    ADDQH_W_MMR2	= 1616,
    ADDUH_QB_MMR2	= 1617,
    ADDUH_R_QB_MMR2	= 1618,
    ADDU_PH_MMR2	= 1619,
    ADDU_S_PH_MMR2	= 1620,
    APPEND_MMR2	= 1621,
    BALIGN_MMR2	= 1622,
    CMPGDU_EQ_QB_MMR2	= 1623,
    CMPGDU_LE_QB_MMR2	= 1624,
    CMPGDU_LT_QB_MMR2	= 1625,
    DPA_W_PH_MMR2	= 1626,
    DPAQX_SA_W_PH_MMR2	= 1627,
    DPAQX_S_W_PH_MMR2	= 1628,
    DPAX_W_PH_MMR2	= 1629,
    DPS_W_PH_MMR2	= 1630,
    DPSQX_S_W_PH_MMR2	= 1631,
    DPSQX_SA_W_PH_MMR2	= 1632,
    DPSX_W_PH_MMR2	= 1633,
    MUL_PH_MMR2	= 1634,
    MUL_S_PH_MMR2	= 1635,
    MULQ_RS_W_MMR2	= 1636,
    MULQ_S_PH_MMR2	= 1637,
    MULQ_S_W_MMR2	= 1638,
    MULSA_W_PH_MMR2	= 1639,
    PRECR_QB_PH_MMR2	= 1640,
    PRECR_SRA_PH_W_MMR2	= 1641,
    PRECR_SRA_R_PH_W_MMR2	= 1642,
    PREPEND_MMR2	= 1643,
    SHRA_QB_MMR2	= 1644,
    SHRA_R_QB_MMR2	= 1645,
    SHRAV_QB_MMR2	= 1646,
    SHRAV_R_QB_MMR2	= 1647,
    SHRL_PH_MMR2	= 1648,
    SHRLV_PH_MMR2	= 1649,
    SUBQH_PH_MMR2	= 1650,
    SUBQH_R_PH_MMR2	= 1651,
    SUBQH_W_MMR2	= 1652,
    SUBQH_R_W_MMR2	= 1653,
    SUBU_PH_MMR2	= 1654,
    SUBU_S_PH_MMR2	= 1655,
    SUBUH_QB_MMR2	= 1656,
    SUBUH_R_QB_MMR2	= 1657,
    BPOSGE32C_MMR3	= 1658,
    CMP_F_D	= 1659,
    CMP_F_S	= 1660,
    CMP_SAF_D	= 1661,
    CMP_SAF_S	= 1662,
    CMP_SEQ_D	= 1663,
    CMP_SEQ_S	= 1664,
    CMP_SLE_D	= 1665,
    CMP_SLE_S	= 1666,
    CMP_SLT_D	= 1667,
    CMP_SLT_S	= 1668,
    CMP_SUEQ_D	= 1669,
    CMP_SUEQ_S	= 1670,
    CMP_SULE_D	= 1671,
    CMP_SULE_S	= 1672,
    CMP_SULT_D	= 1673,
    CMP_SULT_S	= 1674,
    CMP_SUN_D	= 1675,
    CMP_SUN_S	= 1676,
    SCHED_LIST_END = 1677
  };
} // end Sched namespace
} // end Mips namespace
} // end llvm namespace
#endif // GET_INSTRINFO_SCHED_ENUM

#ifdef GET_INSTRINFO_MC_DESC
#undef GET_INSTRINFO_MC_DESC
namespace llvm {

static const MCPhysReg ImplicitList1[] = { Mips::SP, 0 };
static const MCPhysReg ImplicitList2[] = { Mips::AT, 0 };
static const MCPhysReg ImplicitList3[] = { Mips::RA, 0 };
static const MCPhysReg ImplicitList4[] = { Mips::DSPPos, 0 };
static const MCPhysReg ImplicitList5[] = { Mips::V0, Mips::V1, 0 };
static const MCPhysReg ImplicitList6[] = { Mips::HI0, Mips::LO0, 0 };
static const MCPhysReg ImplicitList7[] = { Mips::T8, 0 };
static const MCPhysReg ImplicitList8[] = { Mips::DSPOutFlag20, 0 };
static const MCPhysReg ImplicitList9[] = { Mips::DSPCarry, 0 };
static const MCPhysReg ImplicitList10[] = { Mips::DSPCCond, 0 };
static const MCPhysReg ImplicitList11[] = { Mips::HI0, Mips::LO0, Mips::P0, Mips::P1, Mips::P2, 0 };
static const MCPhysReg ImplicitList12[] = { Mips::HI0_64, Mips::LO0_64, 0 };
static const MCPhysReg ImplicitList13[] = { Mips::DSPOutFlag16_19, 0 };
static const MCPhysReg ImplicitList14[] = { Mips::DSPEFI, 0 };
static const MCPhysReg ImplicitList15[] = { Mips::DSPPos, Mips::DSPEFI, 0 };
static const MCPhysReg ImplicitList16[] = { Mips::DSPOutFlag23, 0 };
static const MCPhysReg ImplicitList17[] = { Mips::FCC0, 0 };
static const MCPhysReg ImplicitList18[] = { Mips::DSPPos, Mips::DSPSCount, 0 };
static const MCPhysReg ImplicitList19[] = { Mips::AC0, 0 };
static const MCPhysReg ImplicitList20[] = { Mips::AC0_64, 0 };
static const MCPhysReg ImplicitList21[] = { Mips::HI0, 0 };
static const MCPhysReg ImplicitList22[] = { Mips::HI0_64, 0 };
static const MCPhysReg ImplicitList23[] = { Mips::LO0, 0 };
static const MCPhysReg ImplicitList24[] = { Mips::LO0_64, 0 };
static const MCPhysReg ImplicitList25[] = { Mips::MPL0, Mips::P0, Mips::P1, Mips::P2, 0 };
static const MCPhysReg ImplicitList26[] = { Mips::MPL1, Mips::P0, Mips::P1, Mips::P2, 0 };
static const MCPhysReg ImplicitList27[] = { Mips::MPL2, Mips::P0, Mips::P1, Mips::P2, 0 };
static const MCPhysReg ImplicitList28[] = { Mips::P0, 0 };
static const MCPhysReg ImplicitList29[] = { Mips::P1, 0 };
static const MCPhysReg ImplicitList30[] = { Mips::P2, 0 };
static const MCPhysReg ImplicitList31[] = { Mips::DSPOutFlag21, 0 };
static const MCPhysReg ImplicitList32[] = { Mips::DSPOutFlag22, 0 };
static const MCPhysReg ImplicitList33[] = { Mips::P0, Mips::P1, Mips::P2, 0 };
static const MCPhysReg ImplicitList34[] = { Mips::MPL1, Mips::MPL2, Mips::P0, Mips::P1, Mips::P2, 0 };

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
static const MCOperandInfo OperandInfo32[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo33[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo34[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo35[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo36[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo37[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo38[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo39[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo40[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo41[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo42[] = { { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo43[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo44[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo45[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo46[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo47[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo48[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo49[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo50[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo51[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo52[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo53[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGRCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo54[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo55[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo56[] = { { Mips::FGRCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo57[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo58[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo59[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo60[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo61[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo62[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo63[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo64[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo65[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo66[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo67[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo68[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo69[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo70[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo71[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo72[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo73[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo74[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo75[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo76[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo77[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo78[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo79[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo80[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo81[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo82[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo83[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo84[] = { { Mips::MSA128F16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo85[] = { { Mips::ACC128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo86[] = { { Mips::ACC64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo87[] = { { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo88[] = { { Mips::DSPCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo89[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo90[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo91[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo92[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo93[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo94[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo95[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo96[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo97[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo98[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo99[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo100[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo101[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo102[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo103[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo104[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo105[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::COP0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo106[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo107[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo108[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128F16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo109[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128F16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo110[] = { { Mips::MSA128F16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo111[] = { { Mips::MSA128F16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo112[] = { { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo113[] = { { Mips::COP0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo114[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo115[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo116[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo117[] = { { Mips::DSPCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo118[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo119[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo120[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo121[] = { { Mips::ACC128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo122[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo123[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo124[] = { { Mips::ACC64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo125[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo126[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo127[] = { { Mips::ACC64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo128[] = { { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo129[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo130[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo131[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo132[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo133[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo134[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo135[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo136[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo137[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo138[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo139[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo140[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo141[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo142[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo143[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo144[] = { { Mips::GPR32NONZERORegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo145[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo146[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo147[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo148[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo149[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo150[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo151[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo152[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo153[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo154[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo155[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo156[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo157[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo158[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo159[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo160[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo161[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo162[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo163[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo164[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo165[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo166[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo167[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo168[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo169[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsPlusSPRegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo170[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo171[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo172[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo173[] = { { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo174[] = { { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo175[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo176[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo177[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo178[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo179[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo180[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo181[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo182[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo183[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo184[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo185[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo186[] = { { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo187[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo188[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo189[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo190[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo191[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo192[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CCRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo193[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo194[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSACtrlRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo195[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo196[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo197[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo198[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo199[] = { { Mips::FGRCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo200[] = { { Mips::FGRCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo201[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo202[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo203[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo204[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo205[] = { { Mips::CCRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo206[] = { { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo207[] = { { Mips::MSACtrlRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo208[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo209[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo210[] = { { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo211[] = { { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo212[] = { { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo213[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo214[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo215[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo216[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::COP0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo217[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo218[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo219[] = { { Mips::COP0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo220[] = { { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo221[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo222[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo223[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo224[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo225[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo226[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo227[] = { { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo228[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo229[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo230[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo231[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo232[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo233[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo234[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo235[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo236[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo237[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo238[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo239[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo240[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo241[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo242[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo243[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo244[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo245[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo246[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo247[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo248[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo249[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo250[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo251[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo252[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo253[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo254[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo255[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo256[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo257[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo258[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo259[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo260[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo261[] = { { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo262[] = { { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo263[] = { { Mips::COP3RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo264[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo265[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo266[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo267[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo268[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo269[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo270[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo271[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo272[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo273[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo274[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo275[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo276[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo277[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 3, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo278[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo279[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 2, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo280[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo281[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 2, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo282[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo283[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo284[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo285[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo286[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo287[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo288[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo289[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo290[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo291[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo292[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo293[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo294[] = { { Mips::GPRMM16MovePPairFirstRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16MovePPairSecondRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16MovePRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16MovePRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo295[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo296[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo297[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo298[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo299[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo300[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FCCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo301[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo302[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo303[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo304[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo305[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo306[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo307[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo308[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo309[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo310[] = { { Mips::COP2RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo311[] = { { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::AFGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo312[] = { { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo313[] = { { Mips::HI32DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo314[] = { { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo315[] = { { Mips::LO32DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo316[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo317[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo318[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo319[] = { { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPRMM16RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo320[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo321[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo322[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo323[] = { { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo324[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::HWRegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo325[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::HWRegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo326[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo327[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo328[] = { { Mips::GPRMM16ZeroRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo329[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo330[] = { { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo331[] = { { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGRCCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::FGR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo332[] = { { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { Mips::ACC64DSPRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo333[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo334[] = { { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::DSPRRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo335[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo336[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo337[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo338[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo339[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo340[] = { { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo341[] = { { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128BRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo342[] = { { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128DRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo343[] = { { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128HRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo344[] = { { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::MSA128WRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::GPR32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo345[] = { { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_MEMORY, 0 }, { -1, 0, MCOI::OPERAND_MEMORY, 0 }, };
static const MCOperandInfo OperandInfo346[] = { { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { Mips::CPU16RegsRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };

extern const MCInstrDesc MipsInsts[] = {
  { 0,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #0 = PHI
  { 1,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1 = INLINEASM
  { 2,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2 = INLINEASM_BR
  { 3,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #3 = CFI_INSTRUCTION
  { 4,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #4 = EH_LABEL
  { 5,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #5 = GC_LABEL
  { 6,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #6 = ANNOTATION_LABEL
  { 7,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #7 = KILL
  { 8,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo4, -1 ,nullptr },  // Inst #8 = EXTRACT_SUBREG
  { 9,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo5, -1 ,nullptr },  // Inst #9 = INSERT_SUBREG
  { 10,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #10 = IMPLICIT_DEF
  { 11,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo6, -1 ,nullptr },  // Inst #11 = SUBREG_TO_REG
  { 12,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo4, -1 ,nullptr },  // Inst #12 = COPY_TO_REGCLASS
  { 13,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #13 = DBG_VALUE
  { 14,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #14 = DBG_LABEL
  { 15,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #15 = REG_SEQUENCE
  { 16,	2,	1,	0,	509,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #16 = COPY
  { 17,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #17 = BUNDLE
  { 18,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #18 = LIFETIME_START
  { 19,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #19 = LIFETIME_END
  { 20,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo8, -1 ,nullptr },  // Inst #20 = STACKMAP
  { 21,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #21 = FENTRY_CALL
  { 22,	6,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo9, -1 ,nullptr },  // Inst #22 = PATCHPOINT
  { 23,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo10, -1 ,nullptr },  // Inst #23 = LOAD_STACK_GUARD
  { 24,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #24 = STATEPOINT
  { 25,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo11, -1 ,nullptr },  // Inst #25 = LOCAL_ESCAPE
  { 26,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #26 = FAULTING_OP
  { 27,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #27 = PATCHABLE_OP
  { 28,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #28 = PATCHABLE_FUNCTION_ENTER
  { 29,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #29 = PATCHABLE_RET
  { 30,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #30 = PATCHABLE_FUNCTION_EXIT
  { 31,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #31 = PATCHABLE_TAIL_CALL
  { 32,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo11, -1 ,nullptr },  // Inst #32 = PATCHABLE_EVENT_CALL
  { 33,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo12, -1 ,nullptr },  // Inst #33 = PATCHABLE_TYPED_EVENT_CALL
  { 34,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #34 = ICALL_BRANCH_FUNNEL
  { 35,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #35 = G_ADD
  { 36,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #36 = G_SUB
  { 37,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #37 = G_MUL
  { 38,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #38 = G_SDIV
  { 39,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #39 = G_UDIV
  { 40,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #40 = G_SREM
  { 41,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #41 = G_UREM
  { 42,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #42 = G_AND
  { 43,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #43 = G_OR
  { 44,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #44 = G_XOR
  { 45,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #45 = G_IMPLICIT_DEF
  { 46,	1,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #46 = G_PHI
  { 47,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #47 = G_FRAME_INDEX
  { 48,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #48 = G_GLOBAL_VALUE
  { 49,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo16, -1 ,nullptr },  // Inst #49 = G_EXTRACT
  { 50,	2,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #50 = G_UNMERGE_VALUES
  { 51,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo18, -1 ,nullptr },  // Inst #51 = G_INSERT
  { 52,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #52 = G_MERGE_VALUES
  { 53,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #53 = G_BUILD_VECTOR
  { 54,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #54 = G_BUILD_VECTOR_TRUNC
  { 55,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #55 = G_CONCAT_VECTORS
  { 56,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #56 = G_PTRTOINT
  { 57,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #57 = G_INTTOPTR
  { 58,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #58 = G_BITCAST
  { 59,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #59 = G_INTRINSIC_TRUNC
  { 60,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #60 = G_INTRINSIC_ROUND
  { 61,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #61 = G_LOAD
  { 62,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #62 = G_SEXTLOAD
  { 63,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #63 = G_ZEXTLOAD
  { 64,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #64 = G_STORE
  { 65,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo20, -1 ,nullptr },  // Inst #65 = G_ATOMIC_CMPXCHG_WITH_SUCCESS
  { 66,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #66 = G_ATOMIC_CMPXCHG
  { 67,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #67 = G_ATOMICRMW_XCHG
  { 68,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #68 = G_ATOMICRMW_ADD
  { 69,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #69 = G_ATOMICRMW_SUB
  { 70,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #70 = G_ATOMICRMW_AND
  { 71,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #71 = G_ATOMICRMW_NAND
  { 72,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #72 = G_ATOMICRMW_OR
  { 73,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #73 = G_ATOMICRMW_XOR
  { 74,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #74 = G_ATOMICRMW_MAX
  { 75,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #75 = G_ATOMICRMW_MIN
  { 76,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #76 = G_ATOMICRMW_UMAX
  { 77,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo22, -1 ,nullptr },  // Inst #77 = G_ATOMICRMW_UMIN
  { 78,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo8, -1 ,nullptr },  // Inst #78 = G_FENCE
  { 79,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #79 = G_BRCOND
  { 80,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #80 = G_BRINDIRECT
  { 81,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Variadic), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #81 = G_INTRINSIC
  { 82,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #82 = G_INTRINSIC_W_SIDE_EFFECTS
  { 83,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #83 = G_ANYEXT
  { 84,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #84 = G_TRUNC
  { 85,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #85 = G_CONSTANT
  { 86,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #86 = G_FCONSTANT
  { 87,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo14, -1 ,nullptr },  // Inst #87 = G_VASTART
  { 88,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo16, -1 ,nullptr },  // Inst #88 = G_VAARG
  { 89,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #89 = G_SEXT
  { 90,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #90 = G_ZEXT
  { 91,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #91 = G_SHL
  { 92,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #92 = G_LSHR
  { 93,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #93 = G_ASHR
  { 94,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo24, -1 ,nullptr },  // Inst #94 = G_ICMP
  { 95,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo24, -1 ,nullptr },  // Inst #95 = G_FCMP
  { 96,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #96 = G_SELECT
  { 97,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #97 = G_UADDO
  { 98,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #98 = G_UADDE
  { 99,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #99 = G_USUBO
  { 100,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #100 = G_USUBE
  { 101,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #101 = G_SADDO
  { 102,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #102 = G_SADDE
  { 103,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #103 = G_SSUBO
  { 104,	5,	2,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo25, -1 ,nullptr },  // Inst #104 = G_SSUBE
  { 105,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #105 = G_UMULO
  { 106,	4,	2,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo21, -1 ,nullptr },  // Inst #106 = G_SMULO
  { 107,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #107 = G_UMULH
  { 108,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #108 = G_SMULH
  { 109,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #109 = G_FADD
  { 110,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #110 = G_FSUB
  { 111,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #111 = G_FMUL
  { 112,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo26, -1 ,nullptr },  // Inst #112 = G_FMA
  { 113,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #113 = G_FDIV
  { 114,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #114 = G_FREM
  { 115,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #115 = G_FPOW
  { 116,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #116 = G_FEXP
  { 117,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #117 = G_FEXP2
  { 118,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #118 = G_FLOG
  { 119,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #119 = G_FLOG2
  { 120,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #120 = G_FLOG10
  { 121,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #121 = G_FNEG
  { 122,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #122 = G_FPEXT
  { 123,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #123 = G_FPTRUNC
  { 124,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #124 = G_FPTOSI
  { 125,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #125 = G_FPTOUI
  { 126,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #126 = G_SITOFP
  { 127,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #127 = G_UITOFP
  { 128,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #128 = G_FABS
  { 129,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #129 = G_FCOPYSIGN
  { 130,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #130 = G_FCANONICALIZE
  { 131,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #131 = G_FMINNUM
  { 132,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #132 = G_FMAXNUM
  { 133,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #133 = G_FMINNUM_IEEE
  { 134,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #134 = G_FMAXNUM_IEEE
  { 135,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #135 = G_FMINIMUM
  { 136,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #136 = G_FMAXIMUM
  { 137,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo23, -1 ,nullptr },  // Inst #137 = G_GEP
  { 138,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo27, -1 ,nullptr },  // Inst #138 = G_PTR_MASK
  { 139,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #139 = G_SMIN
  { 140,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #140 = G_SMAX
  { 141,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #141 = G_UMIN
  { 142,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo13, -1 ,nullptr },  // Inst #142 = G_UMAX
  { 143,	1,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #143 = G_BR
  { 144,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo28, -1 ,nullptr },  // Inst #144 = G_BRJT
  { 145,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo29, -1 ,nullptr },  // Inst #145 = G_INSERT_VECTOR_ELT
  { 146,	3,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo30, -1 ,nullptr },  // Inst #146 = G_EXTRACT_VECTOR_ELT
  { 147,	4,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo31, -1 ,nullptr },  // Inst #147 = G_SHUFFLE_VECTOR
  { 148,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #148 = G_CTTZ
  { 149,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #149 = G_CTTZ_ZERO_UNDEF
  { 150,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #150 = G_CTLZ
  { 151,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #151 = G_CTLZ_ZERO_UNDEF
  { 152,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #152 = G_CTPOP
  { 153,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #153 = G_BSWAP
  { 154,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #154 = G_FCEIL
  { 155,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #155 = G_FCOS
  { 156,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #156 = G_FSIN
  { 157,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #157 = G_FSQRT
  { 158,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #158 = G_FFLOOR
  { 159,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #159 = G_FRINT
  { 160,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo19, -1 ,nullptr },  // Inst #160 = G_FNEARBYINT
  { 161,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo17, -1 ,nullptr },  // Inst #161 = G_ADDRSPACE_CAST
  { 162,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #162 = G_BLOCK_ADDR
  { 163,	2,	1,	0,	0,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo15, -1 ,nullptr },  // Inst #163 = G_JUMP_TABLE
  { 164,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #164 = ABSMacro
  { 165,	2,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo8, -1 ,nullptr },  // Inst #165 = ADJCALLSTACKDOWN
  { 166,	2,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo8, -1 ,nullptr },  // Inst #166 = ADJCALLSTACKUP
  { 167,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #167 = AND_V_D_PSEUDO
  { 168,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #168 = AND_V_H_PSEUDO
  { 169,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #169 = AND_V_W_PSEUDO
  { 170,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #170 = ATOMIC_CMP_SWAP_I16
  { 171,	7,	1,	4,	714,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #171 = ATOMIC_CMP_SWAP_I16_POSTRA
  { 172,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #172 = ATOMIC_CMP_SWAP_I32
  { 173,	4,	1,	4,	714,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #173 = ATOMIC_CMP_SWAP_I32_POSTRA
  { 174,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #174 = ATOMIC_CMP_SWAP_I64
  { 175,	4,	1,	4,	714,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #175 = ATOMIC_CMP_SWAP_I64_POSTRA
  { 176,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #176 = ATOMIC_CMP_SWAP_I8
  { 177,	7,	1,	4,	714,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #177 = ATOMIC_CMP_SWAP_I8_POSTRA
  { 178,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #178 = ATOMIC_LOAD_ADD_I16
  { 179,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #179 = ATOMIC_LOAD_ADD_I16_POSTRA
  { 180,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #180 = ATOMIC_LOAD_ADD_I32
  { 181,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #181 = ATOMIC_LOAD_ADD_I32_POSTRA
  { 182,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #182 = ATOMIC_LOAD_ADD_I64
  { 183,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #183 = ATOMIC_LOAD_ADD_I64_POSTRA
  { 184,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #184 = ATOMIC_LOAD_ADD_I8
  { 185,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #185 = ATOMIC_LOAD_ADD_I8_POSTRA
  { 186,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #186 = ATOMIC_LOAD_AND_I16
  { 187,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #187 = ATOMIC_LOAD_AND_I16_POSTRA
  { 188,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #188 = ATOMIC_LOAD_AND_I32
  { 189,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #189 = ATOMIC_LOAD_AND_I32_POSTRA
  { 190,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #190 = ATOMIC_LOAD_AND_I64
  { 191,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #191 = ATOMIC_LOAD_AND_I64_POSTRA
  { 192,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #192 = ATOMIC_LOAD_AND_I8
  { 193,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #193 = ATOMIC_LOAD_AND_I8_POSTRA
  { 194,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #194 = ATOMIC_LOAD_NAND_I16
  { 195,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #195 = ATOMIC_LOAD_NAND_I16_POSTRA
  { 196,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #196 = ATOMIC_LOAD_NAND_I32
  { 197,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #197 = ATOMIC_LOAD_NAND_I32_POSTRA
  { 198,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #198 = ATOMIC_LOAD_NAND_I64
  { 199,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #199 = ATOMIC_LOAD_NAND_I64_POSTRA
  { 200,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #200 = ATOMIC_LOAD_NAND_I8
  { 201,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #201 = ATOMIC_LOAD_NAND_I8_POSTRA
  { 202,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #202 = ATOMIC_LOAD_OR_I16
  { 203,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #203 = ATOMIC_LOAD_OR_I16_POSTRA
  { 204,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #204 = ATOMIC_LOAD_OR_I32
  { 205,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #205 = ATOMIC_LOAD_OR_I32_POSTRA
  { 206,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #206 = ATOMIC_LOAD_OR_I64
  { 207,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #207 = ATOMIC_LOAD_OR_I64_POSTRA
  { 208,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #208 = ATOMIC_LOAD_OR_I8
  { 209,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #209 = ATOMIC_LOAD_OR_I8_POSTRA
  { 210,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #210 = ATOMIC_LOAD_SUB_I16
  { 211,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #211 = ATOMIC_LOAD_SUB_I16_POSTRA
  { 212,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #212 = ATOMIC_LOAD_SUB_I32
  { 213,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #213 = ATOMIC_LOAD_SUB_I32_POSTRA
  { 214,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #214 = ATOMIC_LOAD_SUB_I64
  { 215,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #215 = ATOMIC_LOAD_SUB_I64_POSTRA
  { 216,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #216 = ATOMIC_LOAD_SUB_I8
  { 217,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #217 = ATOMIC_LOAD_SUB_I8_POSTRA
  { 218,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #218 = ATOMIC_LOAD_XOR_I16
  { 219,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #219 = ATOMIC_LOAD_XOR_I16_POSTRA
  { 220,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #220 = ATOMIC_LOAD_XOR_I32
  { 221,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #221 = ATOMIC_LOAD_XOR_I32_POSTRA
  { 222,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #222 = ATOMIC_LOAD_XOR_I64
  { 223,	3,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #223 = ATOMIC_LOAD_XOR_I64_POSTRA
  { 224,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #224 = ATOMIC_LOAD_XOR_I8
  { 225,	6,	1,	4,	715,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #225 = ATOMIC_LOAD_XOR_I8_POSTRA
  { 226,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #226 = ATOMIC_SWAP_I16
  { 227,	6,	1,	4,	713,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #227 = ATOMIC_SWAP_I16_POSTRA
  { 228,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #228 = ATOMIC_SWAP_I32
  { 229,	3,	1,	4,	713,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #229 = ATOMIC_SWAP_I32_POSTRA
  { 230,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #230 = ATOMIC_SWAP_I64
  { 231,	3,	1,	4,	713,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #231 = ATOMIC_SWAP_I64_POSTRA
  { 232,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #232 = ATOMIC_SWAP_I8
  { 233,	6,	1,	4,	713,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #233 = ATOMIC_SWAP_I8_POSTRA
  { 234,	1,	0,	4,	369,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, ImplicitList2, OperandInfo42, -1 ,nullptr },  // Inst #234 = B
  { 235,	1,	0,	4,	911,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, ImplicitList3, OperandInfo42, -1 ,nullptr },  // Inst #235 = BAL_BR
  { 236,	1,	0,	4,	938,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, ImplicitList3, OperandInfo42, -1 ,nullptr },  // Inst #236 = BAL_BR_MM
  { 237,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #237 = BEQLImmMacro
  { 238,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #238 = BGE
  { 239,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #239 = BGEImmMacro
  { 240,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #240 = BGEL
  { 241,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #241 = BGELImmMacro
  { 242,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #242 = BGEU
  { 243,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #243 = BGEUImmMacro
  { 244,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #244 = BGEUL
  { 245,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #245 = BGEULImmMacro
  { 246,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #246 = BGT
  { 247,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #247 = BGTImmMacro
  { 248,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #248 = BGTL
  { 249,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #249 = BGTLImmMacro
  { 250,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #250 = BGTU
  { 251,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #251 = BGTUImmMacro
  { 252,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #252 = BGTUL
  { 253,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #253 = BGTULImmMacro
  { 254,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #254 = BLE
  { 255,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #255 = BLEImmMacro
  { 256,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #256 = BLEL
  { 257,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #257 = BLELImmMacro
  { 258,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #258 = BLEU
  { 259,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #259 = BLEUImmMacro
  { 260,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #260 = BLEUL
  { 261,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #261 = BLEULImmMacro
  { 262,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #262 = BLT
  { 263,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #263 = BLTImmMacro
  { 264,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #264 = BLTL
  { 265,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #265 = BLTLImmMacro
  { 266,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #266 = BLTU
  { 267,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #267 = BLTUImmMacro
  { 268,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #268 = BLTUL
  { 269,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #269 = BLTULImmMacro
  { 270,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #270 = BNELImmMacro
  { 271,	1,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList4, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #271 = BPOSGE32_PSEUDO
  { 272,	4,	1,	4,	520,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #272 = BSEL_D_PSEUDO
  { 273,	4,	1,	4,	520,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #273 = BSEL_FD_PSEUDO
  { 274,	4,	1,	4,	520,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #274 = BSEL_FW_PSEUDO
  { 275,	4,	1,	4,	520,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #275 = BSEL_H_PSEUDO
  { 276,	4,	1,	4,	520,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #276 = BSEL_W_PSEUDO
  { 277,	1,	0,	4,	937,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, ImplicitList2, OperandInfo42, -1 ,nullptr },  // Inst #277 = B_MM
  { 278,	1,	0,	4,	989,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #278 = B_MMR6_Pseudo
  { 279,	1,	0,	4,	948,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #279 = B_MM_Pseudo
  { 280,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #280 = BeqImm
  { 281,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #281 = BneImm
  { 282,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #282 = BteqzT8CmpX16
  { 283,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #283 = BteqzT8CmpiX16
  { 284,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #284 = BteqzT8SltX16
  { 285,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #285 = BteqzT8SltiX16
  { 286,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #286 = BteqzT8SltiuX16
  { 287,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #287 = BteqzT8SltuX16
  { 288,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #288 = BtnezT8CmpX16
  { 289,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #289 = BtnezT8CmpiX16
  { 290,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #290 = BtnezT8SltX16
  { 291,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #291 = BtnezT8SltiX16
  { 292,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #292 = BtnezT8SltiuX16
  { 293,	3,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #293 = BtnezT8SltuX16
  { 294,	3,	1,	4,	678,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #294 = BuildPairF64
  { 295,	3,	1,	4,	678,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #295 = BuildPairF64_64
  { 296,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo53, -1 ,nullptr },  // Inst #296 = CFTC1
  { 297,	3,	0,	2,	729,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::NotDuplicable), 0x0ULL, nullptr, nullptr, OperandInfo4, -1 ,nullptr },  // Inst #297 = CONSTPOOL_ENTRY
  { 298,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo54, -1 ,nullptr },  // Inst #298 = COPY_FD_PSEUDO
  { 299,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #299 = COPY_FW_PSEUDO
  { 300,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo56, -1 ,nullptr },  // Inst #300 = CTTC1
  { 301,	1,	0,	2,	729,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #301 = Constant32
  { 302,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #302 = DMULImmMacro
  { 303,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #303 = DMULMacro
  { 304,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #304 = DMULOMacro
  { 305,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #305 = DMULOUMacro
  { 306,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #306 = DROL
  { 307,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #307 = DROLImm
  { 308,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #308 = DROR
  { 309,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #309 = DRORImm
  { 310,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #310 = DSDivIMacro
  { 311,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #311 = DSDivMacro
  { 312,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #312 = DSRemIMacro
  { 313,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #313 = DSRemMacro
  { 314,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #314 = DUDivIMacro
  { 315,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #315 = DUDivMacro
  { 316,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #316 = DURemIMacro
  { 317,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #317 = DURemMacro
  { 318,	0,	0,	4,	916,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #318 = ERet
  { 319,	3,	1,	4,	687,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo61, -1 ,nullptr },  // Inst #319 = ExtractElementF64
  { 320,	3,	1,	4,	687,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo62, -1 ,nullptr },  // Inst #320 = ExtractElementF64_64
  { 321,	2,	1,	4,	583,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #321 = FABS_D
  { 322,	2,	1,	4,	583,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #322 = FABS_W
  { 323,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #323 = FEXP2_D_1_PSEUDO
  { 324,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #324 = FEXP2_W_1_PSEUDO
  { 325,	2,	1,	4,	546,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo65, -1 ,nullptr },  // Inst #325 = FILL_FD_PSEUDO
  { 326,	2,	1,	4,	546,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #326 = FILL_FW_PSEUDO
  { 327,	4,	2,	2,	729,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo67, -1 ,nullptr },  // Inst #327 = GotPrologue16
  { 328,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #328 = INSERT_B_VIDX64_PSEUDO
  { 329,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #329 = INSERT_B_VIDX_PSEUDO
  { 330,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo70, -1 ,nullptr },  // Inst #330 = INSERT_D_VIDX64_PSEUDO
  { 331,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo71, -1 ,nullptr },  // Inst #331 = INSERT_D_VIDX_PSEUDO
  { 332,	4,	1,	4,	547,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo72, -1 ,nullptr },  // Inst #332 = INSERT_FD_PSEUDO
  { 333,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo73, -1 ,nullptr },  // Inst #333 = INSERT_FD_VIDX64_PSEUDO
  { 334,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo74, -1 ,nullptr },  // Inst #334 = INSERT_FD_VIDX_PSEUDO
  { 335,	4,	1,	4,	547,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo75, -1 ,nullptr },  // Inst #335 = INSERT_FW_PSEUDO
  { 336,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo76, -1 ,nullptr },  // Inst #336 = INSERT_FW_VIDX64_PSEUDO
  { 337,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo77, -1 ,nullptr },  // Inst #337 = INSERT_FW_VIDX_PSEUDO
  { 338,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo78, -1 ,nullptr },  // Inst #338 = INSERT_H_VIDX64_PSEUDO
  { 339,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #339 = INSERT_H_VIDX_PSEUDO
  { 340,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #340 = INSERT_W_VIDX64_PSEUDO
  { 341,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo81, -1 ,nullptr },  // Inst #341 = INSERT_W_VIDX_PSEUDO
  { 342,	1,	0,	4,	1004,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook), 0x10ULL, nullptr, ImplicitList3, OperandInfo82, -1 ,nullptr },  // Inst #342 = JALR64Pseudo
  { 343,	1,	0,	4,	1004,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook), 0x10ULL, nullptr, ImplicitList3, OperandInfo82, -1 ,nullptr },  // Inst #343 = JALRHB64Pseudo
  { 344,	1,	0,	4,	402,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook), 0x10ULL, nullptr, ImplicitList3, OperandInfo45, -1 ,nullptr },  // Inst #344 = JALRHBPseudo
  { 345,	1,	0,	4,	402,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook), 0x10ULL, nullptr, ImplicitList3, OperandInfo45, -1 ,nullptr },  // Inst #345 = JALRPseudo
  { 346,	1,	0,	4,	982,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Call), 0x10ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #346 = JAL_MMR6
  { 347,	1,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #347 = JalOneReg
  { 348,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #348 = JalTwoReg
  { 349,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #349 = LDMacro
  { 350,	3,	1,	4,	708,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo84, -1 ,nullptr },  // Inst #350 = LD_F16
  { 351,	3,	1,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo85, -1 ,nullptr },  // Inst #351 = LOAD_ACC128
  { 352,	3,	1,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #352 = LOAD_ACC64
  { 353,	3,	1,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #353 = LOAD_ACC64DSP
  { 354,	3,	1,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #354 = LOAD_CCOND_DSP
  { 355,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo89, -1 ,nullptr },  // Inst #355 = LONG_BRANCH_ADDiu
  { 356,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #356 = LONG_BRANCH_ADDiu2Op
  { 357,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #357 = LONG_BRANCH_DADDiu
  { 358,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #358 = LONG_BRANCH_DADDiu2Op
  { 359,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #359 = LONG_BRANCH_LUi
  { 360,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo93, -1 ,nullptr },  // Inst #360 = LONG_BRANCH_LUi2Op
  { 361,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo94, -1 ,nullptr },  // Inst #361 = LONG_BRANCH_LUi2Op_64
  { 362,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo95, -1 ,nullptr },  // Inst #362 = LWM_MM
  { 363,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo96, -1 ,nullptr },  // Inst #363 = LoadAddrImm32
  { 364,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #364 = LoadAddrImm64
  { 365,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #365 = LoadAddrReg32
  { 366,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #366 = LoadAddrReg64
  { 367,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #367 = LoadImm32
  { 368,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #368 = LoadImm64
  { 369,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo100, -1 ,nullptr },  // Inst #369 = LoadImmDoubleFGR
  { 370,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #370 = LoadImmDoubleFGR_32
  { 371,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #371 = LoadImmDoubleGPR
  { 372,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #372 = LoadImmSingleFGR
  { 373,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #373 = LoadImmSingleGPR
  { 374,	3,	1,	2,	729,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo103, -1 ,nullptr },  // Inst #374 = LwConstant32
  { 375,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #375 = MFTACX
  { 376,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #376 = MFTC0
  { 377,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo106, -1 ,nullptr },  // Inst #377 = MFTC1
  { 378,	1,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #378 = MFTDSP
  { 379,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #379 = MFTGPR
  { 380,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo106, -1 ,nullptr },  // Inst #380 = MFTHC1
  { 381,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #381 = MFTHI
  { 382,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #382 = MFTLO
  { 383,	2,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x10ULL, ImplicitList5, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #383 = MIPSeh_return32
  { 384,	2,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x10ULL, ImplicitList5, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #384 = MIPSeh_return64
  { 385,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo108, -1 ,nullptr },  // Inst #385 = MSA_FP_EXTEND_D_PSEUDO
  { 386,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #386 = MSA_FP_EXTEND_W_PSEUDO
  { 387,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #387 = MSA_FP_ROUND_D_PSEUDO
  { 388,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #388 = MSA_FP_ROUND_W_PSEUDO
  { 389,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #389 = MTTACX
  { 390,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #390 = MTTC0
  { 391,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #391 = MTTC1
  { 392,	1,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #392 = MTTDSP
  { 393,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #393 = MTTGPR
  { 394,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #394 = MTTHC1
  { 395,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #395 = MTTHI
  { 396,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #396 = MTTLO
  { 397,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #397 = MULImmMacro
  { 398,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #398 = MULOMacro
  { 399,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #399 = MULOUMacro
  { 400,	2,	0,	2,	867,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, ImplicitList6, OperandInfo115, -1 ,nullptr },  // Inst #400 = MultRxRy16
  { 401,	3,	1,	2,	867,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, ImplicitList6, OperandInfo116, -1 ,nullptr },  // Inst #401 = MultRxRyRz16
  { 402,	2,	0,	2,	867,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, ImplicitList6, OperandInfo115, -1 ,nullptr },  // Inst #402 = MultuRxRy16
  { 403,	3,	1,	2,	867,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, ImplicitList6, OperandInfo116, -1 ,nullptr },  // Inst #403 = MultuRxRyRz16
  { 404,	0,	0,	4,	368,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #404 = NOP
  { 405,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #405 = NORImm
  { 406,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #406 = NORImm64
  { 407,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #407 = NOR_V_D_PSEUDO
  { 408,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #408 = NOR_V_H_PSEUDO
  { 409,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #409 = NOR_V_W_PSEUDO
  { 410,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #410 = OR_V_D_PSEUDO
  { 411,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #411 = OR_V_H_PSEUDO
  { 412,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #412 = OR_V_W_PSEUDO
  { 413,	3,	1,	4,	1446,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #413 = PseudoCMPU_EQ_QB
  { 414,	3,	1,	4,	1446,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #414 = PseudoCMPU_LE_QB
  { 415,	3,	1,	4,	1446,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #415 = PseudoCMPU_LT_QB
  { 416,	3,	1,	4,	1446,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #416 = PseudoCMP_EQ_PH
  { 417,	3,	1,	4,	1446,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #417 = PseudoCMP_LE_PH
  { 418,	3,	1,	4,	1446,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #418 = PseudoCMP_LT_PH
  { 419,	2,	1,	4,	636,	0|(1ULL<<MCID::Pseudo), 0x4ULL, nullptr, nullptr, OperandInfo118, -1 ,nullptr },  // Inst #419 = PseudoCVT_D32_W
  { 420,	2,	1,	4,	636,	0|(1ULL<<MCID::Pseudo), 0x4ULL, nullptr, nullptr, OperandInfo119, -1 ,nullptr },  // Inst #420 = PseudoCVT_D64_L
  { 421,	2,	1,	4,	636,	0|(1ULL<<MCID::Pseudo), 0x4ULL, nullptr, nullptr, OperandInfo120, -1 ,nullptr },  // Inst #421 = PseudoCVT_D64_W
  { 422,	2,	1,	4,	636,	0|(1ULL<<MCID::Pseudo), 0x4ULL, nullptr, nullptr, OperandInfo119, -1 ,nullptr },  // Inst #422 = PseudoCVT_S_L
  { 423,	2,	1,	4,	636,	0|(1ULL<<MCID::Pseudo), 0x4ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #423 = PseudoCVT_S_W
  { 424,	3,	1,	4,	894,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo121, -1 ,nullptr },  // Inst #424 = PseudoDMULT
  { 425,	3,	1,	4,	895,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo121, -1 ,nullptr },  // Inst #425 = PseudoDMULTu
  { 426,	3,	1,	4,	896,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo121, -1 ,nullptr },  // Inst #426 = PseudoDSDIV
  { 427,	3,	1,	4,	897,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo121, -1 ,nullptr },  // Inst #427 = PseudoDUDIV
  { 428,	7,	2,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #428 = PseudoD_SELECT_I
  { 429,	7,	2,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #429 = PseudoD_SELECT_I64
  { 430,	1,	0,	4,	382,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #430 = PseudoIndirectBranch
  { 431,	1,	0,	4,	1012,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #431 = PseudoIndirectBranch64
  { 432,	1,	0,	4,	1016,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #432 = PseudoIndirectBranch64R6
  { 433,	1,	0,	4,	928,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #433 = PseudoIndirectBranchR6
  { 434,	1,	0,	4,	957,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #434 = PseudoIndirectBranch_MM
  { 435,	1,	0,	4,	990,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #435 = PseudoIndirectBranch_MMR6
  { 436,	1,	0,	4,	382,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #436 = PseudoIndirectHazardBranch
  { 437,	1,	0,	4,	1012,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #437 = PseudoIndirectHazardBranch64
  { 438,	1,	0,	4,	1016,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #438 = PseudoIndrectHazardBranch64R6
  { 439,	1,	0,	4,	928,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #439 = PseudoIndrectHazardBranchR6
  { 440,	4,	1,	4,	484,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #440 = PseudoMADD
  { 441,	4,	1,	4,	485,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #441 = PseudoMADDU
  { 442,	4,	1,	4,	850,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #442 = PseudoMADDU_MM
  { 443,	4,	1,	4,	849,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #443 = PseudoMADD_MM
  { 444,	2,	1,	4,	473,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #444 = PseudoMFHI
  { 445,	2,	1,	4,	898,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo126, -1 ,nullptr },  // Inst #445 = PseudoMFHI64
  { 446,	2,	1,	4,	859,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #446 = PseudoMFHI_MM
  { 447,	2,	1,	4,	473,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #447 = PseudoMFLO
  { 448,	2,	1,	4,	898,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo126, -1 ,nullptr },  // Inst #448 = PseudoMFLO64
  { 449,	2,	1,	4,	859,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #449 = PseudoMFLO_MM
  { 450,	4,	1,	4,	486,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #450 = PseudoMSUB
  { 451,	4,	1,	4,	487,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #451 = PseudoMSUBU
  { 452,	4,	1,	4,	852,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #452 = PseudoMSUBU_MM
  { 453,	4,	1,	4,	851,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #453 = PseudoMSUB_MM
  { 454,	3,	1,	4,	488,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #454 = PseudoMTLOHI
  { 455,	3,	1,	4,	899,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo121, -1 ,nullptr },  // Inst #455 = PseudoMTLOHI64
  { 456,	3,	1,	4,	1332,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #456 = PseudoMTLOHI_DSP
  { 457,	3,	1,	4,	860,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #457 = PseudoMTLOHI_MM
  { 458,	3,	1,	4,	855,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #458 = PseudoMULT
  { 459,	3,	1,	4,	853,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #459 = PseudoMULT_MM
  { 460,	3,	1,	4,	856,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #460 = PseudoMULTu
  { 461,	3,	1,	4,	854,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #461 = PseudoMULTu_MM
  { 462,	4,	1,	4,	1447,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #462 = PseudoPICK_PH
  { 463,	4,	1,	4,	1447,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #463 = PseudoPICK_QB
  { 464,	1,	0,	4,	383,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #464 = PseudoReturn
  { 465,	1,	0,	4,	1008,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #465 = PseudoReturn64
  { 466,	3,	1,	4,	857,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #466 = PseudoSDIV
  { 467,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #467 = PseudoSELECTFP_F_D32
  { 468,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo131, -1 ,nullptr },  // Inst #468 = PseudoSELECTFP_F_D64
  { 469,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo132, -1 ,nullptr },  // Inst #469 = PseudoSELECTFP_F_I
  { 470,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo133, -1 ,nullptr },  // Inst #470 = PseudoSELECTFP_F_I64
  { 471,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo134, -1 ,nullptr },  // Inst #471 = PseudoSELECTFP_F_S
  { 472,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #472 = PseudoSELECTFP_T_D32
  { 473,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo131, -1 ,nullptr },  // Inst #473 = PseudoSELECTFP_T_D64
  { 474,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo132, -1 ,nullptr },  // Inst #474 = PseudoSELECTFP_T_I
  { 475,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo133, -1 ,nullptr },  // Inst #475 = PseudoSELECTFP_T_I64
  { 476,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo134, -1 ,nullptr },  // Inst #476 = PseudoSELECTFP_T_S
  { 477,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #477 = PseudoSELECT_D32
  { 478,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo136, -1 ,nullptr },  // Inst #478 = PseudoSELECT_D64
  { 479,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo137, -1 ,nullptr },  // Inst #479 = PseudoSELECT_I
  { 480,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo138, -1 ,nullptr },  // Inst #480 = PseudoSELECT_I64
  { 481,	4,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo139, -1 ,nullptr },  // Inst #481 = PseudoSELECT_S
  { 482,	3,	1,	4,	1202,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo140, -1 ,nullptr },  // Inst #482 = PseudoTRUNC_W_D
  { 483,	3,	1,	4,	1202,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo141, -1 ,nullptr },  // Inst #483 = PseudoTRUNC_W_D32
  { 484,	3,	1,	4,	1202,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #484 = PseudoTRUNC_W_S
  { 485,	3,	1,	4,	858,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #485 = PseudoUDIV
  { 486,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #486 = ROL
  { 487,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #487 = ROLImm
  { 488,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #488 = ROR
  { 489,	3,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #489 = RORImm
  { 490,	0,	0,	4,	377,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x10ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #490 = RetRA
  { 491,	0,	0,	2,	932,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #491 = RetRA16
  { 492,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #492 = SDC1_M1
  { 493,	3,	1,	4,	877,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #493 = SDIV_MM_Pseudo
  { 494,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #494 = SDMacro
  { 495,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #495 = SDivIMacro
  { 496,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo144, -1 ,nullptr },  // Inst #496 = SDivMacro
  { 497,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #497 = SEQIMacro
  { 498,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #498 = SEQMacro
  { 499,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #499 = SGE
  { 500,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #500 = SGEImm
  { 501,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #501 = SGEImm64
  { 502,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #502 = SGEU
  { 503,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #503 = SGEUImm
  { 504,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #504 = SGEUImm64
  { 505,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #505 = SGTImm
  { 506,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #506 = SGTImm64
  { 507,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #507 = SGTUImm
  { 508,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #508 = SGTUImm64
  { 509,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #509 = SLTImm64
  { 510,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #510 = SLTUImm64
  { 511,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #511 = SNZ_B_PSEUDO
  { 512,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo146, -1 ,nullptr },  // Inst #512 = SNZ_D_PSEUDO
  { 513,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #513 = SNZ_H_PSEUDO
  { 514,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #514 = SNZ_V_PSEUDO
  { 515,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo148, -1 ,nullptr },  // Inst #515 = SNZ_W_PSEUDO
  { 516,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #516 = SRemIMacro
  { 517,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #517 = SRemMacro
  { 518,	3,	0,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo85, -1 ,nullptr },  // Inst #518 = STORE_ACC128
  { 519,	3,	0,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #519 = STORE_ACC64
  { 520,	3,	0,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #520 = STORE_ACC64DSP
  { 521,	3,	0,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #521 = STORE_CCOND_DSP
  { 522,	3,	0,	4,	697,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo84, -1 ,nullptr },  // Inst #522 = ST_F16
  { 523,	3,	0,	4,	1128,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo95, -1 ,nullptr },  // Inst #523 = SWM_MM
  { 524,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #524 = SZ_B_PSEUDO
  { 525,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo146, -1 ,nullptr },  // Inst #525 = SZ_D_PSEUDO
  { 526,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #526 = SZ_H_PSEUDO
  { 527,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #527 = SZ_V_PSEUDO
  { 528,	2,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo148, -1 ,nullptr },  // Inst #528 = SZ_W_PSEUDO
  { 529,	4,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo149, -1 ,nullptr },  // Inst #529 = SelBeqZ
  { 530,	4,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo149, -1 ,nullptr },  // Inst #530 = SelBneZ
  { 531,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #531 = SelTBteqZCmp
  { 532,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #532 = SelTBteqZCmpi
  { 533,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #533 = SelTBteqZSlt
  { 534,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #534 = SelTBteqZSlti
  { 535,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #535 = SelTBteqZSltiu
  { 536,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #536 = SelTBteqZSltu
  { 537,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #537 = SelTBtneZCmp
  { 538,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #538 = SelTBtneZCmpi
  { 539,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #539 = SelTBtneZSlt
  { 540,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #540 = SelTBtneZSlti
  { 541,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #541 = SelTBtneZSltiu
  { 542,	5,	1,	2,	936,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #542 = SelTBtneZSltu
  { 543,	3,	1,	2,	728,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #543 = SltCCRxRy16
  { 544,	3,	1,	2,	728,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #544 = SltiCCRxImmX16
  { 545,	3,	1,	2,	728,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #545 = SltiuCCRxImmX16
  { 546,	3,	1,	2,	728,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #546 = SltuCCRxRy16
  { 547,	3,	1,	2,	728,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo116, -1 ,nullptr },  // Inst #547 = SltuRxRyRz16
  { 548,	1,	0,	4,	379,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #548 = TAILCALL
  { 549,	1,	0,	4,	1015,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo82, -1 ,nullptr },  // Inst #549 = TAILCALL64R6REG
  { 550,	1,	0,	4,	1015,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo82, -1 ,nullptr },  // Inst #550 = TAILCALLHB64R6REG
  { 551,	1,	0,	4,	929,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo45, -1 ,nullptr },  // Inst #551 = TAILCALLHBR6REG
  { 552,	1,	0,	4,	929,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo45, -1 ,nullptr },  // Inst #552 = TAILCALLR6REG
  { 553,	1,	0,	4,	380,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo45, -1 ,nullptr },  // Inst #553 = TAILCALLREG
  { 554,	1,	0,	4,	1007,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo82, -1 ,nullptr },  // Inst #554 = TAILCALLREG64
  { 555,	1,	0,	4,	380,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo45, -1 ,nullptr },  // Inst #555 = TAILCALLREGHB
  { 556,	1,	0,	4,	1007,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo82, -1 ,nullptr },  // Inst #556 = TAILCALLREGHB64
  { 557,	1,	0,	4,	955,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo45, -1 ,nullptr },  // Inst #557 = TAILCALLREG_MM
  { 558,	1,	0,	4,	997,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo45, -1 ,nullptr },  // Inst #558 = TAILCALLREG_MMR6
  { 559,	1,	0,	4,	956,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #559 = TAILCALL_MM
  { 560,	1,	0,	4,	998,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x10ULL, nullptr, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #560 = TAILCALL_MMR6
  { 561,	0,	0,	4,	397,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #561 = TRAP
  { 562,	0,	0,	4,	973,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x10ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #562 = TRAP_MM
  { 563,	3,	1,	4,	878,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #563 = UDIV_MM_Pseudo
  { 564,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #564 = UDivIMacro
  { 565,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #565 = UDivMacro
  { 566,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #566 = URemIMacro
  { 567,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #567 = URemMacro
  { 568,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #568 = Ulh
  { 569,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #569 = Ulhu
  { 570,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #570 = Ulw
  { 571,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #571 = Ush
  { 572,	3,	1,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #572 = Usw
  { 573,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #573 = XOR_V_D_PSEUDO
  { 574,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #574 = XOR_V_H_PSEUDO
  { 575,	3,	1,	4,	545,	0|(1ULL<<MCID::Pseudo), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #575 = XOR_V_W_PSEUDO
  { 576,	2,	1,	4,	1345,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo153, -1 ,nullptr },  // Inst #576 = ABSQ_S_PH
  { 577,	2,	1,	4,	1496,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo153, -1 ,nullptr },  // Inst #577 = ABSQ_S_PH_MM
  { 578,	2,	1,	4,	1448,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo153, -1 ,nullptr },  // Inst #578 = ABSQ_S_QB
  { 579,	2,	1,	4,	1612,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo153, -1 ,nullptr },  // Inst #579 = ABSQ_S_QB_MMR2
  { 580,	2,	1,	4,	1346,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo32, -1 ,nullptr },  // Inst #580 = ABSQ_S_W
  { 581,	2,	1,	4,	1497,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo32, -1 ,nullptr },  // Inst #581 = ABSQ_S_W_MM
  { 582,	3,	1,	4,	491,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #582 = ADD
  { 583,	2,	1,	4,	717,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #583 = ADDIUPC
  { 584,	2,	1,	4,	730,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #584 = ADDIUPC_MM
  { 585,	2,	1,	4,	766,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #585 = ADDIUPC_MMR6
  { 586,	2,	1,	2,	730,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #586 = ADDIUR1SP_MM
  { 587,	3,	1,	2,	730,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #587 = ADDIUR2_MM
  { 588,	3,	1,	2,	730,	0, 0x0ULL, nullptr, nullptr, OperandInfo156, -1 ,nullptr },  // Inst #588 = ADDIUS5_MM
  { 589,	1,	0,	2,	730,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #589 = ADDIUSP_MM
  { 590,	3,	1,	4,	767,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #590 = ADDIU_MMR6
  { 591,	3,	1,	4,	1449,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #591 = ADDQH_PH
  { 592,	3,	1,	4,	1613,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #592 = ADDQH_PH_MMR2
  { 593,	3,	1,	4,	1450,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #593 = ADDQH_R_PH
  { 594,	3,	1,	4,	1614,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #594 = ADDQH_R_PH_MMR2
  { 595,	3,	1,	4,	1451,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #595 = ADDQH_R_W
  { 596,	3,	1,	4,	1615,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #596 = ADDQH_R_W_MMR2
  { 597,	3,	1,	4,	1452,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #597 = ADDQH_W
  { 598,	3,	1,	4,	1616,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #598 = ADDQH_W_MMR2
  { 599,	3,	1,	4,	1347,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #599 = ADDQ_PH
  { 600,	3,	1,	4,	1498,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #600 = ADDQ_PH_MM
  { 601,	3,	1,	4,	1348,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #601 = ADDQ_S_PH
  { 602,	3,	1,	4,	1499,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #602 = ADDQ_S_PH_MM
  { 603,	3,	1,	4,	1349,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo59, -1 ,nullptr },  // Inst #603 = ADDQ_S_W
  { 604,	3,	1,	4,	1500,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo59, -1 ,nullptr },  // Inst #604 = ADDQ_S_W_MM
  { 605,	3,	1,	4,	1350,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList9, OperandInfo59, -1 ,nullptr },  // Inst #605 = ADDSC
  { 606,	3,	1,	4,	1501,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList9, OperandInfo59, -1 ,nullptr },  // Inst #606 = ADDSC_MM
  { 607,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #607 = ADDS_A_B
  { 608,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #608 = ADDS_A_D
  { 609,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #609 = ADDS_A_H
  { 610,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #610 = ADDS_A_W
  { 611,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #611 = ADDS_S_B
  { 612,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #612 = ADDS_S_D
  { 613,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #613 = ADDS_S_H
  { 614,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #614 = ADDS_S_W
  { 615,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #615 = ADDS_U_B
  { 616,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #616 = ADDS_U_D
  { 617,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #617 = ADDS_U_H
  { 618,	3,	1,	4,	534,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #618 = ADDS_U_W
  { 619,	3,	1,	2,	731,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo159, -1 ,nullptr },  // Inst #619 = ADDU16_MM
  { 620,	3,	1,	2,	768,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo159, -1 ,nullptr },  // Inst #620 = ADDU16_MMR6
  { 621,	3,	1,	4,	1453,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #621 = ADDUH_QB
  { 622,	3,	1,	4,	1617,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #622 = ADDUH_QB_MMR2
  { 623,	3,	1,	4,	1454,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #623 = ADDUH_R_QB
  { 624,	3,	1,	4,	1618,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #624 = ADDUH_R_QB_MMR2
  { 625,	3,	1,	4,	768,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #625 = ADDU_MMR6
  { 626,	3,	1,	4,	1455,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #626 = ADDU_PH
  { 627,	3,	1,	4,	1619,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #627 = ADDU_PH_MMR2
  { 628,	3,	1,	4,	1351,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #628 = ADDU_QB
  { 629,	3,	1,	4,	1502,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #629 = ADDU_QB_MM
  { 630,	3,	1,	4,	1456,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #630 = ADDU_S_PH
  { 631,	3,	1,	4,	1620,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #631 = ADDU_S_PH_MMR2
  { 632,	3,	1,	4,	1352,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #632 = ADDU_S_QB
  { 633,	3,	1,	4,	1503,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #633 = ADDU_S_QB_MM
  { 634,	3,	1,	4,	535,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #634 = ADDVI_B
  { 635,	3,	1,	4,	535,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #635 = ADDVI_D
  { 636,	3,	1,	4,	535,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #636 = ADDVI_H
  { 637,	3,	1,	4,	535,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #637 = ADDVI_W
  { 638,	3,	1,	4,	535,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #638 = ADDV_B
  { 639,	3,	1,	4,	535,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #639 = ADDV_D
  { 640,	3,	1,	4,	535,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #640 = ADDV_H
  { 641,	3,	1,	4,	535,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #641 = ADDV_W
  { 642,	3,	1,	4,	1353,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList9, ImplicitList8, OperandInfo59, -1 ,nullptr },  // Inst #642 = ADDWC
  { 643,	3,	1,	4,	1504,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList9, ImplicitList8, OperandInfo59, -1 ,nullptr },  // Inst #643 = ADDWC_MM
  { 644,	3,	1,	4,	533,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #644 = ADD_A_B
  { 645,	3,	1,	4,	533,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #645 = ADD_A_D
  { 646,	3,	1,	4,	533,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #646 = ADD_A_H
  { 647,	3,	1,	4,	533,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #647 = ADD_A_W
  { 648,	3,	1,	4,	732,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #648 = ADD_MM
  { 649,	3,	1,	4,	769,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #649 = ADD_MMR6
  { 650,	3,	1,	4,	492,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #650 = ADDi
  { 651,	3,	1,	4,	733,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #651 = ADDi_MM
  { 652,	3,	1,	4,	493,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #652 = ADDiu
  { 653,	3,	1,	4,	730,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #653 = ADDiu_MM
  { 654,	3,	1,	4,	504,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #654 = ADDu
  { 655,	3,	1,	4,	731,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #655 = ADDu_MM
  { 656,	4,	1,	4,	718,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #656 = ALIGN
  { 657,	4,	1,	4,	770,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #657 = ALIGN_MMR6
  { 658,	2,	1,	4,	719,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #658 = ALUIPC
  { 659,	2,	1,	4,	771,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #659 = ALUIPC_MMR6
  { 660,	3,	1,	4,	359,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #660 = AND
  { 661,	3,	1,	2,	734,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #661 = AND16_MM
  { 662,	3,	1,	2,	772,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #662 = AND16_MMR6
  { 663,	3,	1,	4,	798,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #663 = AND64
  { 664,	3,	1,	2,	734,	0, 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #664 = ANDI16_MM
  { 665,	3,	1,	2,	772,	0, 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #665 = ANDI16_MMR6
  { 666,	3,	1,	4,	544,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #666 = ANDI_B
  { 667,	3,	1,	4,	773,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #667 = ANDI_MMR6
  { 668,	3,	1,	4,	734,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #668 = AND_MM
  { 669,	3,	1,	4,	772,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #669 = AND_MMR6
  { 670,	3,	1,	4,	543,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #670 = AND_V
  { 671,	3,	1,	4,	494,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #671 = ANDi
  { 672,	3,	1,	4,	798,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #672 = ANDi64
  { 673,	3,	1,	4,	735,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #673 = ANDi_MM
  { 674,	4,	1,	4,	1457,	0, 0x6ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #674 = APPEND
  { 675,	4,	1,	4,	1621,	0, 0x6ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #675 = APPEND_MMR2
  { 676,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #676 = ASUB_S_B
  { 677,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #677 = ASUB_S_D
  { 678,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #678 = ASUB_S_H
  { 679,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #679 = ASUB_S_W
  { 680,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #680 = ASUB_U_B
  { 681,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #681 = ASUB_U_D
  { 682,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #682 = ASUB_U_H
  { 683,	3,	1,	4,	536,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #683 = ASUB_U_W
  { 684,	3,	1,	4,	720,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #684 = AUI
  { 685,	2,	1,	4,	721,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #685 = AUIPC
  { 686,	2,	1,	4,	774,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #686 = AUIPC_MMR6
  { 687,	3,	1,	4,	775,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #687 = AUI_MMR6
  { 688,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #688 = AVER_S_B
  { 689,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #689 = AVER_S_D
  { 690,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #690 = AVER_S_H
  { 691,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #691 = AVER_S_W
  { 692,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #692 = AVER_U_B
  { 693,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #693 = AVER_U_D
  { 694,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #694 = AVER_U_H
  { 695,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #695 = AVER_U_W
  { 696,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #696 = AVE_S_B
  { 697,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #697 = AVE_S_D
  { 698,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #698 = AVE_S_H
  { 699,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #699 = AVE_S_W
  { 700,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #700 = AVE_U_B
  { 701,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #701 = AVE_U_D
  { 702,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #702 = AVE_U_H
  { 703,	3,	1,	4,	537,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #703 = AVE_U_W
  { 704,	2,	1,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo167, -1 ,nullptr },  // Inst #704 = AddiuRxImmX16
  { 705,	2,	1,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo167, -1 ,nullptr },  // Inst #705 = AddiuRxPcImmX16
  { 706,	3,	1,	2,	727,	0|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo168, -1 ,nullptr },  // Inst #706 = AddiuRxRxImm16
  { 707,	3,	1,	4,	727,	0|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo168, -1 ,nullptr },  // Inst #707 = AddiuRxRxImmX16
  { 708,	3,	1,	4,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo169, -1 ,nullptr },  // Inst #708 = AddiuRxRyOffMemX16
  { 709,	1,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo2, -1 ,nullptr },  // Inst #709 = AddiuSpImm16
  { 710,	1,	0,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, OperandInfo2, -1 ,nullptr },  // Inst #710 = AddiuSpImmX16
  { 711,	3,	1,	2,	727,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #711 = AdduRxRyRz16
  { 712,	3,	1,	2,	727,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #712 = AndRxRxRy16
  { 713,	1,	0,	2,	937,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList2, OperandInfo42, -1 ,nullptr },  // Inst #713 = B16_MM
  { 714,	3,	1,	4,	1190,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #714 = BADDu
  { 715,	1,	0,	4,	370,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo42, -1 ,nullptr },  // Inst #715 = BAL
  { 716,	1,	0,	4,	918,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo42, -1 ,nullptr },  // Inst #716 = BALC
  { 717,	1,	0,	4,	991,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo42, -1 ,nullptr },  // Inst #717 = BALC_MMR6
  { 718,	4,	1,	4,	1458,	0, 0x6ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #718 = BALIGN
  { 719,	4,	1,	4,	1622,	0, 0x6ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #719 = BALIGN_MMR2
  { 720,	3,	0,	4,	1191,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x2ULL, nullptr, ImplicitList2, OperandInfo171, -1 ,nullptr },  // Inst #720 = BBIT0
  { 721,	3,	0,	4,	1191,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x2ULL, nullptr, ImplicitList2, OperandInfo171, -1 ,nullptr },  // Inst #721 = BBIT032
  { 722,	3,	0,	4,	1191,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x2ULL, nullptr, ImplicitList2, OperandInfo171, -1 ,nullptr },  // Inst #722 = BBIT1
  { 723,	3,	0,	4,	1191,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x2ULL, nullptr, ImplicitList2, OperandInfo171, -1 ,nullptr },  // Inst #723 = BBIT132
  { 724,	1,	0,	4,	921,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #724 = BC
  { 725,	1,	0,	2,	974,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList2, OperandInfo42, -1 ,nullptr },  // Inst #725 = BC16_MMR6
  { 726,	2,	0,	4,	1219,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo172, -1 ,nullptr },  // Inst #726 = BC1EQZ
  { 727,	2,	0,	4,	975,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo172, -1 ,nullptr },  // Inst #727 = BC1EQZC_MMR6
  { 728,	2,	0,	4,	682,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x85ULL, nullptr, ImplicitList2, OperandInfo173, -1 ,nullptr },  // Inst #728 = BC1F
  { 729,	2,	0,	4,	683,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x85ULL, nullptr, ImplicitList2, OperandInfo173, -1 ,nullptr },  // Inst #729 = BC1FL
  { 730,	2,	0,	4,	939,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x85ULL, nullptr, ImplicitList2, OperandInfo173, -1 ,nullptr },  // Inst #730 = BC1F_MM
  { 731,	2,	0,	4,	1219,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo172, -1 ,nullptr },  // Inst #731 = BC1NEZ
  { 732,	2,	0,	4,	975,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo172, -1 ,nullptr },  // Inst #732 = BC1NEZC_MMR6
  { 733,	2,	0,	4,	684,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x85ULL, nullptr, ImplicitList2, OperandInfo173, -1 ,nullptr },  // Inst #733 = BC1T
  { 734,	2,	0,	4,	685,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x85ULL, nullptr, ImplicitList2, OperandInfo173, -1 ,nullptr },  // Inst #734 = BC1TL
  { 735,	2,	0,	4,	940,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x85ULL, nullptr, ImplicitList2, OperandInfo173, -1 ,nullptr },  // Inst #735 = BC1T_MM
  { 736,	2,	0,	4,	922,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo174, -1 ,nullptr },  // Inst #736 = BC2EQZ
  { 737,	2,	0,	4,	976,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo174, -1 ,nullptr },  // Inst #737 = BC2EQZC_MMR6
  { 738,	2,	0,	4,	922,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo174, -1 ,nullptr },  // Inst #738 = BC2NEZ
  { 739,	2,	0,	4,	976,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo174, -1 ,nullptr },  // Inst #739 = BC2NEZC_MMR6
  { 740,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #740 = BCLRI_B
  { 741,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #741 = BCLRI_D
  { 742,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #742 = BCLRI_H
  { 743,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #743 = BCLRI_W
  { 744,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #744 = BCLR_B
  { 745,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #745 = BCLR_D
  { 746,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #746 = BCLR_H
  { 747,	3,	1,	4,	516,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #747 = BCLR_W
  { 748,	1,	0,	4,	974,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x16ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #748 = BC_MMR6
  { 749,	3,	0,	4,	912,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #749 = BEQ
  { 750,	3,	0,	4,	1001,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #750 = BEQ64
  { 751,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #751 = BEQC
  { 752,	3,	0,	4,	1009,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #752 = BEQC64
  { 753,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #753 = BEQC_MMR6
  { 754,	3,	0,	4,	372,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #754 = BEQL
  { 755,	2,	0,	2,	941,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList2, OperandInfo175, -1 ,nullptr },  // Inst #755 = BEQZ16_MM
  { 756,	2,	0,	4,	919,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #756 = BEQZALC
  { 757,	2,	0,	4,	992,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #757 = BEQZALC_MMR6
  { 758,	2,	0,	4,	924,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #758 = BEQZC
  { 759,	2,	0,	2,	978,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList2, OperandInfo175, -1 ,nullptr },  // Inst #759 = BEQZC16_MMR6
  { 760,	2,	0,	4,	1010,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #760 = BEQZC64
  { 761,	2,	0,	4,	942,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #761 = BEQZC_MM
  { 762,	2,	0,	4,	979,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #762 = BEQZC_MMR6
  { 763,	3,	0,	4,	943,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #763 = BEQ_MM
  { 764,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #764 = BGEC
  { 765,	3,	0,	4,	1009,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #765 = BGEC64
  { 766,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #766 = BGEC_MMR6
  { 767,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #767 = BGEUC
  { 768,	3,	0,	4,	1009,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #768 = BGEUC64
  { 769,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #769 = BGEUC_MMR6
  { 770,	2,	0,	4,	913,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #770 = BGEZ
  { 771,	2,	0,	4,	1002,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #771 = BGEZ64
  { 772,	2,	0,	4,	917,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #772 = BGEZAL
  { 773,	2,	0,	4,	919,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #773 = BGEZALC
  { 774,	2,	0,	4,	992,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #774 = BGEZALC_MMR6
  { 775,	2,	0,	4,	371,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #775 = BGEZALL
  { 776,	2,	0,	4,	949,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #776 = BGEZALS_MM
  { 777,	2,	0,	4,	950,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #777 = BGEZAL_MM
  { 778,	2,	0,	4,	924,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #778 = BGEZC
  { 779,	2,	0,	4,	1010,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #779 = BGEZC64
  { 780,	2,	0,	4,	979,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #780 = BGEZC_MMR6
  { 781,	2,	0,	4,	373,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #781 = BGEZL
  { 782,	2,	0,	4,	941,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #782 = BGEZ_MM
  { 783,	2,	0,	4,	913,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #783 = BGTZ
  { 784,	2,	0,	4,	1002,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #784 = BGTZ64
  { 785,	2,	0,	4,	919,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #785 = BGTZALC
  { 786,	2,	0,	4,	992,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #786 = BGTZALC_MMR6
  { 787,	2,	0,	4,	924,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #787 = BGTZC
  { 788,	2,	0,	4,	1010,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #788 = BGTZC64
  { 789,	2,	0,	4,	979,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #789 = BGTZC_MMR6
  { 790,	2,	0,	4,	373,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #790 = BGTZL
  { 791,	2,	0,	4,	941,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #791 = BGTZ_MM
  { 792,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #792 = BINSLI_B
  { 793,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo177, -1 ,nullptr },  // Inst #793 = BINSLI_D
  { 794,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo178, -1 ,nullptr },  // Inst #794 = BINSLI_H
  { 795,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo179, -1 ,nullptr },  // Inst #795 = BINSLI_W
  { 796,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #796 = BINSL_B
  { 797,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #797 = BINSL_D
  { 798,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #798 = BINSL_H
  { 799,	4,	1,	4,	511,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #799 = BINSL_W
  { 800,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #800 = BINSRI_B
  { 801,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo177, -1 ,nullptr },  // Inst #801 = BINSRI_D
  { 802,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo178, -1 ,nullptr },  // Inst #802 = BINSRI_H
  { 803,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo179, -1 ,nullptr },  // Inst #803 = BINSRI_W
  { 804,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #804 = BINSR_B
  { 805,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #805 = BINSR_D
  { 806,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #806 = BINSR_H
  { 807,	4,	1,	4,	512,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #807 = BINSR_W
  { 808,	2,	1,	4,	1354,	0, 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #808 = BITREV
  { 809,	2,	1,	4,	1505,	0, 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #809 = BITREV_MM
  { 810,	2,	1,	4,	722,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #810 = BITSWAP
  { 811,	2,	1,	4,	776,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #811 = BITSWAP_MMR6
  { 812,	2,	0,	4,	913,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #812 = BLEZ
  { 813,	2,	0,	4,	1002,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #813 = BLEZ64
  { 814,	2,	0,	4,	919,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #814 = BLEZALC
  { 815,	2,	0,	4,	992,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #815 = BLEZALC_MMR6
  { 816,	2,	0,	4,	924,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #816 = BLEZC
  { 817,	2,	0,	4,	1010,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #817 = BLEZC64
  { 818,	2,	0,	4,	979,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #818 = BLEZC_MMR6
  { 819,	2,	0,	4,	373,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #819 = BLEZL
  { 820,	2,	0,	4,	941,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #820 = BLEZ_MM
  { 821,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #821 = BLTC
  { 822,	3,	0,	4,	1009,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #822 = BLTC64
  { 823,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #823 = BLTC_MMR6
  { 824,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #824 = BLTUC
  { 825,	3,	0,	4,	1009,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #825 = BLTUC64
  { 826,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #826 = BLTUC_MMR6
  { 827,	2,	0,	4,	913,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #827 = BLTZ
  { 828,	2,	0,	4,	1002,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #828 = BLTZ64
  { 829,	2,	0,	4,	911,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #829 = BLTZAL
  { 830,	2,	0,	4,	919,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #830 = BLTZALC
  { 831,	2,	0,	4,	992,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #831 = BLTZALC_MMR6
  { 832,	2,	0,	4,	371,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #832 = BLTZALL
  { 833,	2,	0,	4,	949,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #833 = BLTZALS_MM
  { 834,	2,	0,	4,	950,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #834 = BLTZAL_MM
  { 835,	2,	0,	4,	924,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #835 = BLTZC
  { 836,	2,	0,	4,	1010,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #836 = BLTZC64
  { 837,	2,	0,	4,	979,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #837 = BLTZC_MMR6
  { 838,	2,	0,	4,	373,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #838 = BLTZL
  { 839,	2,	0,	4,	941,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #839 = BLTZ_MM
  { 840,	4,	1,	4,	519,	0, 0x6ULL, nullptr, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #840 = BMNZI_B
  { 841,	4,	1,	4,	519,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #841 = BMNZ_V
  { 842,	4,	1,	4,	519,	0, 0x6ULL, nullptr, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #842 = BMZI_B
  { 843,	4,	1,	4,	519,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #843 = BMZ_V
  { 844,	3,	0,	4,	912,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #844 = BNE
  { 845,	3,	0,	4,	1001,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #845 = BNE64
  { 846,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #846 = BNEC
  { 847,	3,	0,	4,	1009,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo91, -1 ,nullptr },  // Inst #847 = BNEC64
  { 848,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #848 = BNEC_MMR6
  { 849,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #849 = BNEGI_B
  { 850,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #850 = BNEGI_D
  { 851,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #851 = BNEGI_H
  { 852,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #852 = BNEGI_W
  { 853,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #853 = BNEG_B
  { 854,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #854 = BNEG_D
  { 855,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #855 = BNEG_H
  { 856,	3,	1,	4,	517,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #856 = BNEG_W
  { 857,	3,	0,	4,	372,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #857 = BNEL
  { 858,	2,	0,	2,	941,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList2, OperandInfo175, -1 ,nullptr },  // Inst #858 = BNEZ16_MM
  { 859,	2,	0,	4,	919,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #859 = BNEZALC
  { 860,	2,	0,	4,	992,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo93, -1 ,nullptr },  // Inst #860 = BNEZALC_MMR6
  { 861,	2,	0,	4,	924,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #861 = BNEZC
  { 862,	2,	0,	2,	978,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList2, OperandInfo175, -1 ,nullptr },  // Inst #862 = BNEZC16_MMR6
  { 863,	2,	0,	4,	1010,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo94, -1 ,nullptr },  // Inst #863 = BNEZC64
  { 864,	2,	0,	4,	942,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #864 = BNEZC_MM
  { 865,	2,	0,	4,	979,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x36ULL, nullptr, ImplicitList2, OperandInfo93, -1 ,nullptr },  // Inst #865 = BNEZC_MMR6
  { 866,	3,	0,	4,	943,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x12ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #866 = BNE_MM
  { 867,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #867 = BNVC
  { 868,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #868 = BNVC_MMR6
  { 869,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo181, -1 ,nullptr },  // Inst #869 = BNZ_B
  { 870,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo182, -1 ,nullptr },  // Inst #870 = BNZ_D
  { 871,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo183, -1 ,nullptr },  // Inst #871 = BNZ_H
  { 872,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo181, -1 ,nullptr },  // Inst #872 = BNZ_V
  { 873,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo184, -1 ,nullptr },  // Inst #873 = BNZ_W
  { 874,	3,	0,	4,	923,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x36ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #874 = BOVC
  { 875,	3,	0,	4,	977,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo44, -1 ,nullptr },  // Inst #875 = BOVC_MMR6
  { 876,	1,	0,	4,	1355,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #876 = BPOSGE32
  { 877,	1,	0,	4,	1658,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #877 = BPOSGE32C_MMR3
  { 878,	1,	0,	4,	1506,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #878 = BPOSGE32_MM
  { 879,	2,	0,	4,	374,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #879 = BREAK
  { 880,	1,	0,	2,	958,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #880 = BREAK16_MM
  { 881,	1,	0,	2,	999,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #881 = BREAK16_MMR6
  { 882,	2,	0,	4,	958,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #882 = BREAK_MM
  { 883,	2,	0,	4,	999,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #883 = BREAK_MMR6
  { 884,	4,	1,	4,	518,	0, 0x6ULL, nullptr, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #884 = BSELI_B
  { 885,	4,	1,	4,	518,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #885 = BSEL_V
  { 886,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #886 = BSETI_B
  { 887,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #887 = BSETI_D
  { 888,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #888 = BSETI_H
  { 889,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #889 = BSETI_W
  { 890,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #890 = BSET_B
  { 891,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #891 = BSET_D
  { 892,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #892 = BSET_H
  { 893,	3,	1,	4,	515,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #893 = BSET_W
  { 894,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo181, -1 ,nullptr },  // Inst #894 = BZ_B
  { 895,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo182, -1 ,nullptr },  // Inst #895 = BZ_D
  { 896,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo183, -1 ,nullptr },  // Inst #896 = BZ_H
  { 897,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo181, -1 ,nullptr },  // Inst #897 = BZ_V
  { 898,	2,	0,	4,	523,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo184, -1 ,nullptr },  // Inst #898 = BZ_W
  { 899,	2,	0,	2,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #899 = BeqzRxImm16
  { 900,	2,	0,	4,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #900 = BeqzRxImmX16
  { 901,	1,	0,	2,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #901 = Bimm16
  { 902,	1,	0,	4,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #902 = BimmX16
  { 903,	2,	0,	2,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #903 = BnezRxImm16
  { 904,	2,	0,	4,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #904 = BnezRxImmX16
  { 905,	0,	0,	2,	935,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #905 = Break16
  { 906,	1,	0,	2,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList7, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #906 = Bteqz16
  { 907,	1,	0,	4,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList7, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #907 = BteqzX16
  { 908,	1,	0,	2,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList7, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #908 = Btnez16
  { 909,	1,	0,	4,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList7, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #909 = BtnezX16
  { 910,	3,	0,	4,	465,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #910 = CACHE
  { 911,	3,	0,	4,	466,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #911 = CACHEE
  { 912,	3,	0,	4,	1099,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #912 = CACHEE_MM
  { 913,	3,	0,	4,	1132,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #913 = CACHE_MM
  { 914,	3,	0,	4,	1154,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #914 = CACHE_MMR6
  { 915,	3,	0,	4,	1080,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #915 = CACHE_R6
  { 916,	2,	1,	4,	709,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #916 = CEIL_L_D64
  { 917,	2,	1,	4,	1299,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #917 = CEIL_L_D_MMR6
  { 918,	2,	1,	4,	709,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #918 = CEIL_L_S
  { 919,	2,	1,	4,	1299,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #919 = CEIL_L_S_MMR6
  { 920,	2,	1,	4,	709,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #920 = CEIL_W_D32
  { 921,	2,	1,	4,	709,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #921 = CEIL_W_D64
  { 922,	2,	1,	4,	1299,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #922 = CEIL_W_D_MMR6
  { 923,	2,	1,	4,	1235,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #923 = CEIL_W_MM
  { 924,	2,	1,	4,	709,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #924 = CEIL_W_S
  { 925,	2,	1,	4,	1235,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #925 = CEIL_W_S_MM
  { 926,	2,	1,	4,	1299,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #926 = CEIL_W_S_MMR6
  { 927,	3,	1,	4,	551,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #927 = CEQI_B
  { 928,	3,	1,	4,	551,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #928 = CEQI_D
  { 929,	3,	1,	4,	551,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #929 = CEQI_H
  { 930,	3,	1,	4,	551,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #930 = CEQI_W
  { 931,	3,	1,	4,	551,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #931 = CEQ_B
  { 932,	3,	1,	4,	551,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #932 = CEQ_D
  { 933,	3,	1,	4,	551,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #933 = CEQ_H
  { 934,	3,	1,	4,	551,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #934 = CEQ_W
  { 935,	2,	1,	4,	686,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo192, -1 ,nullptr },  // Inst #935 = CFC1
  { 936,	2,	1,	4,	1282,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo192, -1 ,nullptr },  // Inst #936 = CFC1_MM
  { 937,	2,	1,	4,	1049,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo193, -1 ,nullptr },  // Inst #937 = CFC2_MM
  { 938,	2,	1,	4,	524,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo194, -1 ,nullptr },  // Inst #938 = CFCMSA
  { 939,	4,	1,	4,	1192,	0, 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #939 = CINS
  { 940,	4,	1,	4,	1192,	0, 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #940 = CINS32
  { 941,	4,	1,	4,	1192,	0, 0x1ULL, nullptr, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #941 = CINS64_32
  { 942,	4,	1,	4,	1192,	0, 0x1ULL, nullptr, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #942 = CINS_i32
  { 943,	2,	1,	4,	1216,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #943 = CLASS_D
  { 944,	2,	1,	4,	1302,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #944 = CLASS_D_MMR6
  { 945,	2,	1,	4,	1215,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #945 = CLASS_S
  { 946,	2,	1,	4,	1302,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #946 = CLASS_S_MMR6
  { 947,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #947 = CLEI_S_B
  { 948,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #948 = CLEI_S_D
  { 949,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #949 = CLEI_S_H
  { 950,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #950 = CLEI_S_W
  { 951,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #951 = CLEI_U_B
  { 952,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #952 = CLEI_U_D
  { 953,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #953 = CLEI_U_H
  { 954,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #954 = CLEI_U_W
  { 955,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #955 = CLE_S_B
  { 956,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #956 = CLE_S_D
  { 957,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #957 = CLE_S_H
  { 958,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #958 = CLE_S_W
  { 959,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #959 = CLE_U_B
  { 960,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #960 = CLE_U_D
  { 961,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #961 = CLE_U_H
  { 962,	3,	1,	4,	550,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #962 = CLE_U_W
  { 963,	2,	1,	4,	469,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #963 = CLO
  { 964,	2,	1,	4,	736,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #964 = CLO_MM
  { 965,	2,	1,	4,	777,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #965 = CLO_MMR6
  { 966,	2,	1,	4,	723,	0, 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #966 = CLO_R6
  { 967,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #967 = CLTI_S_B
  { 968,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #968 = CLTI_S_D
  { 969,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #969 = CLTI_S_H
  { 970,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #970 = CLTI_S_W
  { 971,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #971 = CLTI_U_B
  { 972,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #972 = CLTI_U_D
  { 973,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #973 = CLTI_U_H
  { 974,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #974 = CLTI_U_W
  { 975,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #975 = CLT_S_B
  { 976,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #976 = CLT_S_D
  { 977,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #977 = CLT_S_H
  { 978,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #978 = CLT_S_W
  { 979,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #979 = CLT_U_B
  { 980,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #980 = CLT_U_D
  { 981,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #981 = CLT_U_H
  { 982,	3,	1,	4,	549,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #982 = CLT_U_W
  { 983,	2,	1,	4,	470,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #983 = CLZ
  { 984,	2,	1,	4,	737,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #984 = CLZ_MM
  { 985,	2,	1,	4,	778,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #985 = CLZ_MMR6
  { 986,	2,	1,	4,	724,	0, 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #986 = CLZ_R6
  { 987,	3,	1,	4,	1459,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo198, -1 ,nullptr },  // Inst #987 = CMPGDU_EQ_QB
  { 988,	3,	1,	4,	1623,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo198, -1 ,nullptr },  // Inst #988 = CMPGDU_EQ_QB_MMR2
  { 989,	3,	1,	4,	1460,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo198, -1 ,nullptr },  // Inst #989 = CMPGDU_LE_QB
  { 990,	3,	1,	4,	1624,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo198, -1 ,nullptr },  // Inst #990 = CMPGDU_LE_QB_MMR2
  { 991,	3,	1,	4,	1461,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo198, -1 ,nullptr },  // Inst #991 = CMPGDU_LT_QB
  { 992,	3,	1,	4,	1625,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo198, -1 ,nullptr },  // Inst #992 = CMPGDU_LT_QB_MMR2
  { 993,	3,	1,	4,	1356,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #993 = CMPGU_EQ_QB
  { 994,	3,	1,	4,	1507,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #994 = CMPGU_EQ_QB_MM
  { 995,	3,	1,	4,	1357,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #995 = CMPGU_LE_QB
  { 996,	3,	1,	4,	1508,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #996 = CMPGU_LE_QB_MM
  { 997,	3,	1,	4,	1358,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #997 = CMPGU_LT_QB
  { 998,	3,	1,	4,	1509,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #998 = CMPGU_LT_QB_MM
  { 999,	2,	0,	4,	1359,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #999 = CMPU_EQ_QB
  { 1000,	2,	0,	4,	1510,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1000 = CMPU_EQ_QB_MM
  { 1001,	2,	0,	4,	1360,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1001 = CMPU_LE_QB
  { 1002,	2,	0,	4,	1511,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1002 = CMPU_LE_QB_MM
  { 1003,	2,	0,	4,	1361,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1003 = CMPU_LT_QB
  { 1004,	2,	0,	4,	1512,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1004 = CMPU_LT_QB_MM
  { 1005,	3,	1,	4,	1289,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1005 = CMP_AF_D_MMR6
  { 1006,	3,	1,	4,	1290,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1006 = CMP_AF_S_MMR6
  { 1007,	3,	1,	4,	556,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1007 = CMP_EQ_D
  { 1008,	3,	1,	4,	1289,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1008 = CMP_EQ_D_MMR6
  { 1009,	2,	0,	4,	1362,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1009 = CMP_EQ_PH
  { 1010,	2,	0,	4,	1513,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1010 = CMP_EQ_PH_MM
  { 1011,	3,	1,	4,	557,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1011 = CMP_EQ_S
  { 1012,	3,	1,	4,	1290,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1012 = CMP_EQ_S_MMR6
  { 1013,	3,	1,	4,	1659,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1013 = CMP_F_D
  { 1014,	3,	1,	4,	1660,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1014 = CMP_F_S
  { 1015,	3,	1,	4,	562,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1015 = CMP_LE_D
  { 1016,	3,	1,	4,	1289,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1016 = CMP_LE_D_MMR6
  { 1017,	2,	0,	4,	1363,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1017 = CMP_LE_PH
  { 1018,	2,	0,	4,	1514,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1018 = CMP_LE_PH_MM
  { 1019,	3,	1,	4,	563,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1019 = CMP_LE_S
  { 1020,	3,	1,	4,	1290,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1020 = CMP_LE_S_MMR6
  { 1021,	3,	1,	4,	558,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1021 = CMP_LT_D
  { 1022,	3,	1,	4,	1289,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1022 = CMP_LT_D_MMR6
  { 1023,	2,	0,	4,	1364,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1023 = CMP_LT_PH
  { 1024,	2,	0,	4,	1515,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList10, OperandInfo153, -1 ,nullptr },  // Inst #1024 = CMP_LT_PH_MM
  { 1025,	3,	1,	4,	559,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1025 = CMP_LT_S
  { 1026,	3,	1,	4,	1290,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1026 = CMP_LT_S_MMR6
  { 1027,	3,	1,	4,	1661,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1027 = CMP_SAF_D
  { 1028,	3,	1,	4,	1291,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1028 = CMP_SAF_D_MMR6
  { 1029,	3,	1,	4,	1662,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1029 = CMP_SAF_S
  { 1030,	3,	1,	4,	1292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1030 = CMP_SAF_S_MMR6
  { 1031,	3,	1,	4,	1663,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1031 = CMP_SEQ_D
  { 1032,	3,	1,	4,	1291,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1032 = CMP_SEQ_D_MMR6
  { 1033,	3,	1,	4,	1664,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1033 = CMP_SEQ_S
  { 1034,	3,	1,	4,	1292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1034 = CMP_SEQ_S_MMR6
  { 1035,	3,	1,	4,	1665,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1035 = CMP_SLE_D
  { 1036,	3,	1,	4,	1291,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1036 = CMP_SLE_D_MMR6
  { 1037,	3,	1,	4,	1666,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1037 = CMP_SLE_S
  { 1038,	3,	1,	4,	1292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1038 = CMP_SLE_S_MMR6
  { 1039,	3,	1,	4,	1667,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1039 = CMP_SLT_D
  { 1040,	3,	1,	4,	1291,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1040 = CMP_SLT_D_MMR6
  { 1041,	3,	1,	4,	1668,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1041 = CMP_SLT_S
  { 1042,	3,	1,	4,	1292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1042 = CMP_SLT_S_MMR6
  { 1043,	3,	1,	4,	1669,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1043 = CMP_SUEQ_D
  { 1044,	3,	1,	4,	1293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1044 = CMP_SUEQ_D_MMR6
  { 1045,	3,	1,	4,	1670,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1045 = CMP_SUEQ_S
  { 1046,	3,	1,	4,	1294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1046 = CMP_SUEQ_S_MMR6
  { 1047,	3,	1,	4,	1671,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1047 = CMP_SULE_D
  { 1048,	3,	1,	4,	1293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1048 = CMP_SULE_D_MMR6
  { 1049,	3,	1,	4,	1672,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1049 = CMP_SULE_S
  { 1050,	3,	1,	4,	1294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1050 = CMP_SULE_S_MMR6
  { 1051,	3,	1,	4,	1673,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1051 = CMP_SULT_D
  { 1052,	3,	1,	4,	1293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1052 = CMP_SULT_D_MMR6
  { 1053,	3,	1,	4,	1674,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1053 = CMP_SULT_S
  { 1054,	3,	1,	4,	1294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1054 = CMP_SULT_S_MMR6
  { 1055,	3,	1,	4,	1675,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1055 = CMP_SUN_D
  { 1056,	3,	1,	4,	1291,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1056 = CMP_SUN_D_MMR6
  { 1057,	3,	1,	4,	1676,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1057 = CMP_SUN_S
  { 1058,	3,	1,	4,	1292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1058 = CMP_SUN_S_MMR6
  { 1059,	3,	1,	4,	554,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1059 = CMP_UEQ_D
  { 1060,	3,	1,	4,	1291,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1060 = CMP_UEQ_D_MMR6
  { 1061,	3,	1,	4,	555,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1061 = CMP_UEQ_S
  { 1062,	3,	1,	4,	1292,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1062 = CMP_UEQ_S_MMR6
  { 1063,	3,	1,	4,	564,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1063 = CMP_ULE_D
  { 1064,	3,	1,	4,	1291,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1064 = CMP_ULE_D_MMR6
  { 1065,	3,	1,	4,	565,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1065 = CMP_ULE_S
  { 1066,	3,	1,	4,	1292,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1066 = CMP_ULE_S_MMR6
  { 1067,	3,	1,	4,	560,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1067 = CMP_ULT_D
  { 1068,	3,	1,	4,	1291,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1068 = CMP_ULT_D_MMR6
  { 1069,	3,	1,	4,	561,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1069 = CMP_ULT_S
  { 1070,	3,	1,	4,	1292,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1070 = CMP_ULT_S_MMR6
  { 1071,	3,	1,	4,	552,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1071 = CMP_UN_D
  { 1072,	3,	1,	4,	1289,	0, 0x16ULL, nullptr, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1072 = CMP_UN_D_MMR6
  { 1073,	3,	1,	4,	553,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1073 = CMP_UN_S
  { 1074,	3,	1,	4,	1290,	0, 0x16ULL, nullptr, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1074 = CMP_UN_S_MMR6
  { 1075,	3,	1,	4,	681,	0, 0x6ULL, nullptr, nullptr, OperandInfo201, -1 ,nullptr },  // Inst #1075 = COPY_S_B
  { 1076,	3,	1,	4,	681,	0, 0x6ULL, nullptr, nullptr, OperandInfo202, -1 ,nullptr },  // Inst #1076 = COPY_S_D
  { 1077,	3,	1,	4,	681,	0, 0x6ULL, nullptr, nullptr, OperandInfo203, -1 ,nullptr },  // Inst #1077 = COPY_S_H
  { 1078,	3,	1,	4,	681,	0, 0x6ULL, nullptr, nullptr, OperandInfo204, -1 ,nullptr },  // Inst #1078 = COPY_S_W
  { 1079,	3,	1,	4,	680,	0, 0x6ULL, nullptr, nullptr, OperandInfo201, -1 ,nullptr },  // Inst #1079 = COPY_U_B
  { 1080,	3,	1,	4,	680,	0, 0x6ULL, nullptr, nullptr, OperandInfo203, -1 ,nullptr },  // Inst #1080 = COPY_U_H
  { 1081,	3,	1,	4,	680,	0, 0x6ULL, nullptr, nullptr, OperandInfo204, -1 ,nullptr },  // Inst #1081 = COPY_U_W
  { 1082,	3,	1,	4,	1182,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1082 = CRC32B
  { 1083,	3,	1,	4,	1185,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1083 = CRC32CB
  { 1084,	3,	1,	4,	1189,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1084 = CRC32CD
  { 1085,	3,	1,	4,	1186,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1085 = CRC32CH
  { 1086,	3,	1,	4,	1187,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1086 = CRC32CW
  { 1087,	3,	1,	4,	1188,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1087 = CRC32D
  { 1088,	3,	1,	4,	1183,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1088 = CRC32H
  { 1089,	3,	1,	4,	1184,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1089 = CRC32W
  { 1090,	2,	1,	4,	677,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo205, -1 ,nullptr },  // Inst #1090 = CTC1
  { 1091,	2,	1,	4,	1283,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo205, -1 ,nullptr },  // Inst #1091 = CTC1_MM
  { 1092,	2,	1,	4,	1050,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo206, -1 ,nullptr },  // Inst #1092 = CTC2_MM
  { 1093,	2,	0,	4,	524,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo207, -1 ,nullptr },  // Inst #1093 = CTCMSA
  { 1094,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo208, -1 ,nullptr },  // Inst #1094 = CVT_D32_S
  { 1095,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo208, -1 ,nullptr },  // Inst #1095 = CVT_D32_S_MM
  { 1096,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo208, -1 ,nullptr },  // Inst #1096 = CVT_D32_W
  { 1097,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo208, -1 ,nullptr },  // Inst #1097 = CVT_D32_W_MM
  { 1098,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1098 = CVT_D64_L
  { 1099,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1099 = CVT_D64_S
  { 1100,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1100 = CVT_D64_S_MM
  { 1101,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1101 = CVT_D64_W
  { 1102,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1102 = CVT_D64_W_MM
  { 1103,	2,	1,	4,	1295,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1103 = CVT_D_L_MMR6
  { 1104,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1104 = CVT_L_D64
  { 1105,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1105 = CVT_L_D64_MM
  { 1106,	2,	1,	4,	1295,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1106 = CVT_L_D_MMR6
  { 1107,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1107 = CVT_L_S
  { 1108,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1108 = CVT_L_S_MM
  { 1109,	2,	1,	4,	1295,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1109 = CVT_L_S_MMR6
  { 1110,	3,	1,	4,	631,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo209, -1 ,nullptr },  // Inst #1110 = CVT_PS_S64
  { 1111,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1111 = CVT_S_D32
  { 1112,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1112 = CVT_S_D32_MM
  { 1113,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1113 = CVT_S_D64
  { 1114,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1114 = CVT_S_D64_MM
  { 1115,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1115 = CVT_S_L
  { 1116,	2,	1,	4,	1295,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1116 = CVT_S_L_MMR6
  { 1117,	2,	1,	4,	631,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1117 = CVT_S_PL64
  { 1118,	2,	1,	4,	631,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1118 = CVT_S_PU64
  { 1119,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1119 = CVT_S_W
  { 1120,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1120 = CVT_S_W_MM
  { 1121,	2,	1,	4,	1295,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1121 = CVT_S_W_MMR6
  { 1122,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1122 = CVT_W_D32
  { 1123,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1123 = CVT_W_D32_MM
  { 1124,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1124 = CVT_W_D64
  { 1125,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1125 = CVT_W_D64_MM
  { 1126,	2,	1,	4,	630,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1126 = CVT_W_S
  { 1127,	2,	1,	4,	1234,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1127 = CVT_W_S_MM
  { 1128,	2,	1,	4,	1295,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1128 = CVT_W_S_MMR6
  { 1129,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1129 = C_EQ_D32
  { 1130,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1130 = C_EQ_D32_MM
  { 1131,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1131 = C_EQ_D64
  { 1132,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1132 = C_EQ_D64_MM
  { 1133,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1133 = C_EQ_S
  { 1134,	3,	1,	4,	1248,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1134 = C_EQ_S_MM
  { 1135,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1135 = C_F_D32
  { 1136,	3,	1,	4,	1245,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1136 = C_F_D32_MM
  { 1137,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1137 = C_F_D64
  { 1138,	3,	1,	4,	1245,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1138 = C_F_D64_MM
  { 1139,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1139 = C_F_S
  { 1140,	3,	1,	4,	1246,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1140 = C_F_S_MM
  { 1141,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1141 = C_LE_D32
  { 1142,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1142 = C_LE_D32_MM
  { 1143,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1143 = C_LE_D64
  { 1144,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1144 = C_LE_D64_MM
  { 1145,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1145 = C_LE_S
  { 1146,	3,	1,	4,	1248,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1146 = C_LE_S_MM
  { 1147,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1147 = C_LT_D32
  { 1148,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1148 = C_LT_D32_MM
  { 1149,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1149 = C_LT_D64
  { 1150,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1150 = C_LT_D64_MM
  { 1151,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1151 = C_LT_S
  { 1152,	3,	1,	4,	1248,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1152 = C_LT_S_MM
  { 1153,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1153 = C_NGE_D32
  { 1154,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1154 = C_NGE_D32_MM
  { 1155,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1155 = C_NGE_D64
  { 1156,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1156 = C_NGE_D64_MM
  { 1157,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1157 = C_NGE_S
  { 1158,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1158 = C_NGE_S_MM
  { 1159,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1159 = C_NGLE_D32
  { 1160,	3,	1,	4,	1251,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1160 = C_NGLE_D32_MM
  { 1161,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1161 = C_NGLE_D64
  { 1162,	3,	1,	4,	1251,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1162 = C_NGLE_D64_MM
  { 1163,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1163 = C_NGLE_S
  { 1164,	3,	1,	4,	1252,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1164 = C_NGLE_S_MM
  { 1165,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1165 = C_NGL_D32
  { 1166,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1166 = C_NGL_D32_MM
  { 1167,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1167 = C_NGL_D64
  { 1168,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1168 = C_NGL_D64_MM
  { 1169,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1169 = C_NGL_S
  { 1170,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1170 = C_NGL_S_MM
  { 1171,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1171 = C_NGT_D32
  { 1172,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1172 = C_NGT_D32_MM
  { 1173,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1173 = C_NGT_D64
  { 1174,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1174 = C_NGT_D64_MM
  { 1175,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1175 = C_NGT_S
  { 1176,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1176 = C_NGT_S_MM
  { 1177,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1177 = C_OLE_D32
  { 1178,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1178 = C_OLE_D32_MM
  { 1179,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1179 = C_OLE_D64
  { 1180,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1180 = C_OLE_D64_MM
  { 1181,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1181 = C_OLE_S
  { 1182,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1182 = C_OLE_S_MM
  { 1183,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1183 = C_OLT_D32
  { 1184,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1184 = C_OLT_D32_MM
  { 1185,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1185 = C_OLT_D64
  { 1186,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1186 = C_OLT_D64_MM
  { 1187,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1187 = C_OLT_S
  { 1188,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1188 = C_OLT_S_MM
  { 1189,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1189 = C_SEQ_D32
  { 1190,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1190 = C_SEQ_D32_MM
  { 1191,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1191 = C_SEQ_D64
  { 1192,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1192 = C_SEQ_D64_MM
  { 1193,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1193 = C_SEQ_S
  { 1194,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1194 = C_SEQ_S_MM
  { 1195,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1195 = C_SF_D32
  { 1196,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1196 = C_SF_D32_MM
  { 1197,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1197 = C_SF_D64
  { 1198,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1198 = C_SF_D64_MM
  { 1199,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1199 = C_SF_S
  { 1200,	3,	1,	4,	1248,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1200 = C_SF_S_MM
  { 1201,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1201 = C_UEQ_D32
  { 1202,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1202 = C_UEQ_D32_MM
  { 1203,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1203 = C_UEQ_D64
  { 1204,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1204 = C_UEQ_D64_MM
  { 1205,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1205 = C_UEQ_S
  { 1206,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1206 = C_UEQ_S_MM
  { 1207,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1207 = C_ULE_D32
  { 1208,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1208 = C_ULE_D32_MM
  { 1209,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1209 = C_ULE_D64
  { 1210,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1210 = C_ULE_D64_MM
  { 1211,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1211 = C_ULE_S
  { 1212,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1212 = C_ULE_S_MM
  { 1213,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1213 = C_ULT_D32
  { 1214,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1214 = C_ULT_D32_MM
  { 1215,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1215 = C_ULT_D64
  { 1216,	3,	1,	4,	1249,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1216 = C_ULT_D64_MM
  { 1217,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1217 = C_ULT_S
  { 1218,	3,	1,	4,	1250,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1218 = C_ULT_S_MM
  { 1219,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1219 = C_UN_D32
  { 1220,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1220 = C_UN_D32_MM
  { 1221,	3,	1,	4,	632,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1221 = C_UN_D64
  { 1222,	3,	1,	4,	1247,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1222 = C_UN_D64_MM
  { 1223,	3,	1,	4,	633,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1223 = C_UN_S
  { 1224,	3,	1,	4,	1248,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x84ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1224 = C_UN_S_MM
  { 1225,	2,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo115, -1 ,nullptr },  // Inst #1225 = CmpRxRy16
  { 1226,	2,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo167, -1 ,nullptr },  // Inst #1226 = CmpiRxImm16
  { 1227,	2,	0,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo167, -1 ,nullptr },  // Inst #1227 = CmpiRxImmX16
  { 1228,	3,	1,	4,	808,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1228 = DADD
  { 1229,	3,	1,	4,	809,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1229 = DADDi
  { 1230,	3,	1,	4,	810,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1230 = DADDiu
  { 1231,	3,	1,	4,	811,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1231 = DADDu
  { 1232,	3,	1,	4,	837,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo213, -1 ,nullptr },  // Inst #1232 = DAHI
  { 1233,	4,	1,	4,	836,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo214, -1 ,nullptr },  // Inst #1233 = DALIGN
  { 1234,	3,	1,	4,	838,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo213, -1 ,nullptr },  // Inst #1234 = DATI
  { 1235,	3,	1,	4,	839,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1235 = DAUI
  { 1236,	2,	1,	4,	842,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1236 = DBITSWAP
  { 1237,	2,	1,	4,	812,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1237 = DCLO
  { 1238,	2,	1,	4,	840,	0, 0x6ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1238 = DCLO_R6
  { 1239,	2,	1,	4,	813,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1239 = DCLZ
  { 1240,	2,	1,	4,	841,	0, 0x6ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1240 = DCLZ_R6
  { 1241,	3,	1,	4,	907,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1241 = DDIV
  { 1242,	3,	1,	4,	909,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1242 = DDIVU
  { 1243,	0,	0,	4,	375,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1243 = DERET
  { 1244,	0,	0,	4,	944,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1244 = DERET_MM
  { 1245,	0,	0,	4,	980,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1245 = DERET_MMR6
  { 1246,	4,	1,	4,	814,	0, 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #1246 = DEXT
  { 1247,	4,	1,	4,	799,	0, 0x1ULL, nullptr, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1247 = DEXT64_32
  { 1248,	4,	1,	4,	814,	0, 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #1248 = DEXTM
  { 1249,	4,	1,	4,	814,	0, 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #1249 = DEXTU
  { 1250,	1,	1,	4,	471,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1250 = DI
  { 1251,	5,	1,	4,	815,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo215, -1 ,nullptr },  // Inst #1251 = DINS
  { 1252,	5,	1,	4,	815,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo215, -1 ,nullptr },  // Inst #1252 = DINSM
  { 1253,	5,	1,	4,	815,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo215, -1 ,nullptr },  // Inst #1253 = DINSU
  { 1254,	3,	1,	4,	479,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1254 = DIV
  { 1255,	3,	1,	4,	480,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1255 = DIVU
  { 1256,	3,	1,	4,	890,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1256 = DIVU_MMR6
  { 1257,	3,	1,	4,	891,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1257 = DIV_MMR6
  { 1258,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1258 = DIV_S_B
  { 1259,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1259 = DIV_S_D
  { 1260,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1260 = DIV_S_H
  { 1261,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1261 = DIV_S_W
  { 1262,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1262 = DIV_U_B
  { 1263,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1263 = DIV_U_D
  { 1264,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1264 = DIV_U_H
  { 1265,	3,	1,	4,	609,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1265 = DIV_U_W
  { 1266,	1,	1,	4,	1023,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1266 = DI_MM
  { 1267,	1,	1,	4,	1040,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1267 = DI_MMR6
  { 1268,	4,	1,	4,	843,	0, 0x6ULL, nullptr, nullptr, OperandInfo214, -1 ,nullptr },  // Inst #1268 = DLSA
  { 1269,	4,	1,	4,	843,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo214, -1 ,nullptr },  // Inst #1269 = DLSA_R6
  { 1270,	3,	1,	4,	1045,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo216, -1 ,nullptr },  // Inst #1270 = DMFC0
  { 1271,	2,	1,	4,	1328,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Bitcast), 0x4ULL, nullptr, nullptr, OperandInfo217, -1 ,nullptr },  // Inst #1271 = DMFC1
  { 1272,	3,	1,	4,	1047,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo218, -1 ,nullptr },  // Inst #1272 = DMFC2
  { 1273,	2,	2,	4,	1193,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #1273 = DMFC2_OCTEON
  { 1274,	3,	1,	4,	1059,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo216, -1 ,nullptr },  // Inst #1274 = DMFGC0
  { 1275,	3,	1,	4,	908,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1275 = DMOD
  { 1276,	3,	1,	4,	910,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1276 = DMODU
  { 1277,	1,	1,	4,	1051,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1277 = DMT
  { 1278,	3,	1,	4,	1046,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo219, -1 ,nullptr },  // Inst #1278 = DMTC0
  { 1279,	2,	1,	4,	1329,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Bitcast), 0x4ULL, nullptr, nullptr, OperandInfo119, -1 ,nullptr },  // Inst #1279 = DMTC1
  { 1280,	3,	1,	4,	1048,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo220, -1 ,nullptr },  // Inst #1280 = DMTC2
  { 1281,	2,	2,	4,	1194,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #1281 = DMTC2_OCTEON
  { 1282,	3,	1,	4,	1060,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo219, -1 ,nullptr },  // Inst #1282 = DMTGC0
  { 1283,	3,	1,	4,	904,	0, 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1283 = DMUH
  { 1284,	3,	1,	4,	905,	0, 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1284 = DMUHU
  { 1285,	3,	1,	4,	1201,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, ImplicitList11, OperandInfo58, -1 ,nullptr },  // Inst #1285 = DMUL
  { 1286,	2,	0,	4,	894,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, ImplicitList12, OperandInfo107, -1 ,nullptr },  // Inst #1286 = DMULT
  { 1287,	2,	0,	4,	895,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, ImplicitList12, OperandInfo107, -1 ,nullptr },  // Inst #1287 = DMULTu
  { 1288,	3,	1,	4,	893,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1288 = DMULU
  { 1289,	3,	1,	4,	906,	0, 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1289 = DMUL_R6
  { 1290,	3,	1,	4,	659,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1290 = DOTP_S_D
  { 1291,	3,	1,	4,	659,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1291 = DOTP_S_H
  { 1292,	3,	1,	4,	659,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1292 = DOTP_S_W
  { 1293,	3,	1,	4,	659,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1293 = DOTP_U_D
  { 1294,	3,	1,	4,	659,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1294 = DOTP_U_H
  { 1295,	3,	1,	4,	659,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1295 = DOTP_U_W
  { 1296,	4,	1,	4,	657,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo224, -1 ,nullptr },  // Inst #1296 = DPADD_S_D
  { 1297,	4,	1,	4,	657,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo225, -1 ,nullptr },  // Inst #1297 = DPADD_S_H
  { 1298,	4,	1,	4,	657,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo226, -1 ,nullptr },  // Inst #1298 = DPADD_S_W
  { 1299,	4,	1,	4,	657,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo224, -1 ,nullptr },  // Inst #1299 = DPADD_U_D
  { 1300,	4,	1,	4,	657,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo225, -1 ,nullptr },  // Inst #1300 = DPADD_U_H
  { 1301,	4,	1,	4,	657,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo226, -1 ,nullptr },  // Inst #1301 = DPADD_U_W
  { 1302,	4,	1,	4,	1463,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1302 = DPAQX_SA_W_PH
  { 1303,	4,	1,	4,	1627,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1303 = DPAQX_SA_W_PH_MMR2
  { 1304,	4,	1,	4,	1464,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1304 = DPAQX_S_W_PH
  { 1305,	4,	1,	4,	1628,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1305 = DPAQX_S_W_PH_MMR2
  { 1306,	4,	1,	4,	1365,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1306 = DPAQ_SA_L_W
  { 1307,	4,	1,	4,	1516,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1307 = DPAQ_SA_L_W_MM
  { 1308,	4,	1,	4,	1366,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1308 = DPAQ_S_W_PH
  { 1309,	4,	1,	4,	1517,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1309 = DPAQ_S_W_PH_MM
  { 1310,	4,	1,	4,	1367,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1310 = DPAU_H_QBL
  { 1311,	4,	1,	4,	1518,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1311 = DPAU_H_QBL_MM
  { 1312,	4,	1,	4,	1368,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1312 = DPAU_H_QBR
  { 1313,	4,	1,	4,	1519,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1313 = DPAU_H_QBR_MM
  { 1314,	4,	1,	4,	1465,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1314 = DPAX_W_PH
  { 1315,	4,	1,	4,	1629,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1315 = DPAX_W_PH_MMR2
  { 1316,	4,	1,	4,	1462,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1316 = DPA_W_PH
  { 1317,	4,	1,	4,	1626,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1317 = DPA_W_PH_MMR2
  { 1318,	2,	1,	4,	1195,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1318 = DPOP
  { 1319,	4,	1,	4,	1468,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1319 = DPSQX_SA_W_PH
  { 1320,	4,	1,	4,	1632,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1320 = DPSQX_SA_W_PH_MMR2
  { 1321,	4,	1,	4,	1467,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1321 = DPSQX_S_W_PH
  { 1322,	4,	1,	4,	1631,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1322 = DPSQX_S_W_PH_MMR2
  { 1323,	4,	1,	4,	1369,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1323 = DPSQ_SA_L_W
  { 1324,	4,	1,	4,	1520,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1324 = DPSQ_SA_L_W_MM
  { 1325,	4,	1,	4,	1370,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1325 = DPSQ_S_W_PH
  { 1326,	4,	1,	4,	1521,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1326 = DPSQ_S_W_PH_MM
  { 1327,	4,	1,	4,	658,	0, 0x6ULL, nullptr, nullptr, OperandInfo224, -1 ,nullptr },  // Inst #1327 = DPSUB_S_D
  { 1328,	4,	1,	4,	658,	0, 0x6ULL, nullptr, nullptr, OperandInfo225, -1 ,nullptr },  // Inst #1328 = DPSUB_S_H
  { 1329,	4,	1,	4,	658,	0, 0x6ULL, nullptr, nullptr, OperandInfo226, -1 ,nullptr },  // Inst #1329 = DPSUB_S_W
  { 1330,	4,	1,	4,	658,	0, 0x6ULL, nullptr, nullptr, OperandInfo224, -1 ,nullptr },  // Inst #1330 = DPSUB_U_D
  { 1331,	4,	1,	4,	658,	0, 0x6ULL, nullptr, nullptr, OperandInfo225, -1 ,nullptr },  // Inst #1331 = DPSUB_U_H
  { 1332,	4,	1,	4,	658,	0, 0x6ULL, nullptr, nullptr, OperandInfo226, -1 ,nullptr },  // Inst #1332 = DPSUB_U_W
  { 1333,	4,	1,	4,	1371,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1333 = DPSU_H_QBL
  { 1334,	4,	1,	4,	1522,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1334 = DPSU_H_QBL_MM
  { 1335,	4,	1,	4,	1372,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1335 = DPSU_H_QBR
  { 1336,	4,	1,	4,	1523,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1336 = DPSU_H_QBR_MM
  { 1337,	4,	1,	4,	1469,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1337 = DPSX_W_PH
  { 1338,	4,	1,	4,	1633,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1338 = DPSX_W_PH_MMR2
  { 1339,	4,	1,	4,	1466,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1339 = DPS_W_PH
  { 1340,	4,	1,	4,	1630,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1340 = DPS_W_PH_MMR2
  { 1341,	3,	1,	4,	816,	0, 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1341 = DROTR
  { 1342,	3,	1,	4,	817,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1342 = DROTR32
  { 1343,	3,	1,	4,	818,	0, 0x1ULL, nullptr, nullptr, OperandInfo228, -1 ,nullptr },  // Inst #1343 = DROTRV
  { 1344,	2,	1,	4,	819,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1344 = DSBH
  { 1345,	2,	0,	4,	896,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList12, OperandInfo107, -1 ,nullptr },  // Inst #1345 = DSDIV
  { 1346,	2,	1,	4,	820,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1346 = DSHD
  { 1347,	3,	1,	4,	821,	0, 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1347 = DSLL
  { 1348,	3,	1,	4,	822,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1348 = DSLL32
  { 1349,	2,	1,	4,	800,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo229, -1 ,nullptr },  // Inst #1349 = DSLL64_32
  { 1350,	3,	1,	4,	823,	0, 0x1ULL, nullptr, nullptr, OperandInfo228, -1 ,nullptr },  // Inst #1350 = DSLLV
  { 1351,	3,	1,	4,	824,	0, 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1351 = DSRA
  { 1352,	3,	1,	4,	825,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1352 = DSRA32
  { 1353,	3,	1,	4,	826,	0, 0x1ULL, nullptr, nullptr, OperandInfo228, -1 ,nullptr },  // Inst #1353 = DSRAV
  { 1354,	3,	1,	4,	827,	0, 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1354 = DSRL
  { 1355,	3,	1,	4,	828,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #1355 = DSRL32
  { 1356,	3,	1,	4,	829,	0, 0x1ULL, nullptr, nullptr, OperandInfo228, -1 ,nullptr },  // Inst #1356 = DSRLV
  { 1357,	3,	1,	4,	830,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1357 = DSUB
  { 1358,	3,	1,	4,	831,	0|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #1358 = DSUBu
  { 1359,	2,	0,	4,	897,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList12, OperandInfo107, -1 ,nullptr },  // Inst #1359 = DUDIV
  { 1360,	1,	1,	4,	1018,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1360 = DVP
  { 1361,	1,	1,	4,	1052,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1361 = DVPE
  { 1362,	1,	1,	4,	1039,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1362 = DVP_MMR6
  { 1363,	2,	0,	2,	868,	0, 0x0ULL, nullptr, ImplicitList6, OperandInfo115, -1 ,nullptr },  // Inst #1363 = DivRxRy16
  { 1364,	2,	0,	2,	869,	0, 0x0ULL, nullptr, ImplicitList6, OperandInfo115, -1 ,nullptr },  // Inst #1364 = DivuRxRy16
  { 1365,	0,	0,	4,	474,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1365 = EHB
  { 1366,	0,	0,	4,	1025,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1366 = EHB_MM
  { 1367,	0,	0,	4,	1042,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1367 = EHB_MMR6
  { 1368,	1,	1,	4,	472,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1368 = EI
  { 1369,	1,	1,	4,	1024,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1369 = EI_MM
  { 1370,	1,	1,	4,	1041,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1370 = EI_MMR6
  { 1371,	1,	1,	4,	1053,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1371 = EMT
  { 1372,	0,	0,	4,	376,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1372 = ERET
  { 1373,	0,	0,	4,	378,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1373 = ERETNC
  { 1374,	0,	0,	4,	981,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1374 = ERETNC_MMR6
  { 1375,	0,	0,	4,	945,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1375 = ERET_MM
  { 1376,	0,	0,	4,	983,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1376 = ERET_MMR6
  { 1377,	1,	1,	4,	1017,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1377 = EVP
  { 1378,	1,	1,	4,	1054,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1378 = EVPE
  { 1379,	1,	1,	4,	1038,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1379 = EVP_MMR6
  { 1380,	4,	1,	4,	489,	0, 0x1ULL, nullptr, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1380 = EXT
  { 1381,	3,	1,	4,	1376,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList14, OperandInfo230, -1 ,nullptr },  // Inst #1381 = EXTP
  { 1382,	3,	1,	4,	1374,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList15, OperandInfo230, -1 ,nullptr },  // Inst #1382 = EXTPDP
  { 1383,	3,	1,	4,	1373,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList15, OperandInfo231, -1 ,nullptr },  // Inst #1383 = EXTPDPV
  { 1384,	3,	1,	4,	1524,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList15, OperandInfo231, -1 ,nullptr },  // Inst #1384 = EXTPDPV_MM
  { 1385,	3,	1,	4,	1525,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList15, OperandInfo230, -1 ,nullptr },  // Inst #1385 = EXTPDP_MM
  { 1386,	3,	1,	4,	1375,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList14, OperandInfo231, -1 ,nullptr },  // Inst #1386 = EXTPV
  { 1387,	3,	1,	4,	1526,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList14, OperandInfo231, -1 ,nullptr },  // Inst #1387 = EXTPV_MM
  { 1388,	3,	1,	4,	1527,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, ImplicitList4, ImplicitList14, OperandInfo230, -1 ,nullptr },  // Inst #1388 = EXTP_MM
  { 1389,	3,	1,	4,	1333,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1389 = EXTRV_RS_W
  { 1390,	3,	1,	4,	1528,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1390 = EXTRV_RS_W_MM
  { 1391,	3,	1,	4,	1334,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1391 = EXTRV_R_W
  { 1392,	3,	1,	4,	1529,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1392 = EXTRV_R_W_MM
  { 1393,	3,	1,	4,	1335,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1393 = EXTRV_S_H
  { 1394,	3,	1,	4,	1530,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1394 = EXTRV_S_H_MM
  { 1395,	3,	1,	4,	1336,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1395 = EXTRV_W
  { 1396,	3,	1,	4,	1531,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo231, -1 ,nullptr },  // Inst #1396 = EXTRV_W_MM
  { 1397,	3,	1,	4,	1337,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1397 = EXTR_RS_W
  { 1398,	3,	1,	4,	1532,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1398 = EXTR_RS_W_MM
  { 1399,	3,	1,	4,	1338,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1399 = EXTR_R_W
  { 1400,	3,	1,	4,	1533,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1400 = EXTR_R_W_MM
  { 1401,	3,	1,	4,	1339,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1401 = EXTR_S_H
  { 1402,	3,	1,	4,	1534,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1402 = EXTR_S_H_MM
  { 1403,	3,	1,	4,	1340,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1403 = EXTR_W
  { 1404,	3,	1,	4,	1535,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList16, OperandInfo230, -1 ,nullptr },  // Inst #1404 = EXTR_W_MM
  { 1405,	4,	1,	4,	1196,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #1405 = EXTS
  { 1406,	4,	1,	4,	1196,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #1406 = EXTS32
  { 1407,	4,	1,	4,	738,	0, 0x1ULL, nullptr, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1407 = EXT_MM
  { 1408,	4,	1,	4,	779,	0, 0x1ULL, nullptr, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1408 = EXT_MMR6
  { 1409,	2,	1,	4,	525,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1409 = FABS_D32
  { 1410,	2,	1,	4,	1259,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1410 = FABS_D32_MM
  { 1411,	2,	1,	4,	525,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1411 = FABS_D64
  { 1412,	2,	1,	4,	1259,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1412 = FABS_D64_MM
  { 1413,	2,	1,	4,	525,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1413 = FABS_S
  { 1414,	2,	1,	4,	1260,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1414 = FABS_S_MM
  { 1415,	3,	1,	4,	655,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1415 = FADD_D
  { 1416,	3,	1,	4,	623,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1416 = FADD_D32
  { 1417,	3,	1,	4,	1262,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1417 = FADD_D32_MM
  { 1418,	3,	1,	4,	623,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1418 = FADD_D64
  { 1419,	3,	1,	4,	1262,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1419 = FADD_D64_MM
  { 1420,	3,	1,	4,	624,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1420 = FADD_S
  { 1421,	3,	1,	4,	1263,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1421 = FADD_S_MM
  { 1422,	3,	1,	4,	1303,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1422 = FADD_S_MMR6
  { 1423,	3,	1,	4,	655,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1423 = FADD_W
  { 1424,	3,	1,	4,	572,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1424 = FCAF_D
  { 1425,	3,	1,	4,	572,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1425 = FCAF_W
  { 1426,	3,	1,	4,	573,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1426 = FCEQ_D
  { 1427,	3,	1,	4,	573,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1427 = FCEQ_W
  { 1428,	2,	1,	4,	594,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1428 = FCLASS_D
  { 1429,	2,	1,	4,	594,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1429 = FCLASS_W
  { 1430,	3,	1,	4,	574,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1430 = FCLE_D
  { 1431,	3,	1,	4,	574,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1431 = FCLE_W
  { 1432,	3,	1,	4,	575,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1432 = FCLT_D
  { 1433,	3,	1,	4,	575,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1433 = FCLT_W
  { 1434,	3,	0,	4,	634,	0, 0x84ULL, nullptr, ImplicitList17, OperandInfo236, -1 ,nullptr },  // Inst #1434 = FCMP_D32
  { 1435,	3,	0,	4,	1254,	0, 0x84ULL, nullptr, ImplicitList17, OperandInfo236, -1 ,nullptr },  // Inst #1435 = FCMP_D32_MM
  { 1436,	3,	0,	4,	634,	0, 0x84ULL, nullptr, ImplicitList17, OperandInfo237, -1 ,nullptr },  // Inst #1436 = FCMP_D64
  { 1437,	3,	0,	4,	635,	0, 0x84ULL, nullptr, ImplicitList17, OperandInfo238, -1 ,nullptr },  // Inst #1437 = FCMP_S32
  { 1438,	3,	0,	4,	1253,	0, 0x84ULL, nullptr, ImplicitList17, OperandInfo238, -1 ,nullptr },  // Inst #1438 = FCMP_S32_MM
  { 1439,	3,	1,	4,	576,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1439 = FCNE_D
  { 1440,	3,	1,	4,	576,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1440 = FCNE_W
  { 1441,	3,	1,	4,	577,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1441 = FCOR_D
  { 1442,	3,	1,	4,	577,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1442 = FCOR_W
  { 1443,	3,	1,	4,	578,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1443 = FCUEQ_D
  { 1444,	3,	1,	4,	578,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1444 = FCUEQ_W
  { 1445,	3,	1,	4,	579,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1445 = FCULE_D
  { 1446,	3,	1,	4,	579,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1446 = FCULE_W
  { 1447,	3,	1,	4,	580,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1447 = FCULT_D
  { 1448,	3,	1,	4,	580,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1448 = FCULT_W
  { 1449,	3,	1,	4,	581,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1449 = FCUNE_D
  { 1450,	3,	1,	4,	581,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1450 = FCUNE_W
  { 1451,	3,	1,	4,	582,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1451 = FCUN_D
  { 1452,	3,	1,	4,	582,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1452 = FCUN_W
  { 1453,	3,	1,	4,	651,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1453 = FDIV_D
  { 1454,	3,	1,	4,	639,	0, 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1454 = FDIV_D32
  { 1455,	3,	1,	4,	1273,	0, 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1455 = FDIV_D32_MM
  { 1456,	3,	1,	4,	639,	0, 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1456 = FDIV_D64
  { 1457,	3,	1,	4,	1273,	0, 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1457 = FDIV_D64_MM
  { 1458,	3,	1,	4,	638,	0, 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1458 = FDIV_S
  { 1459,	3,	1,	4,	1272,	0, 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1459 = FDIV_S_MM
  { 1460,	3,	1,	4,	1325,	0, 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1460 = FDIV_S_MMR6
  { 1461,	3,	1,	4,	650,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1461 = FDIV_W
  { 1462,	3,	1,	4,	591,	0, 0x6ULL, nullptr, nullptr, OperandInfo239, -1 ,nullptr },  // Inst #1462 = FEXDO_H
  { 1463,	3,	1,	4,	591,	0, 0x6ULL, nullptr, nullptr, OperandInfo240, -1 ,nullptr },  // Inst #1463 = FEXDO_W
  { 1464,	3,	1,	4,	548,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1464 = FEXP2_D
  { 1465,	3,	1,	4,	548,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1465 = FEXP2_W
  { 1466,	2,	1,	4,	592,	0, 0x6ULL, nullptr, nullptr, OperandInfo241, -1 ,nullptr },  // Inst #1466 = FEXUPL_D
  { 1467,	2,	1,	4,	592,	0, 0x6ULL, nullptr, nullptr, OperandInfo242, -1 ,nullptr },  // Inst #1467 = FEXUPL_W
  { 1468,	2,	1,	4,	593,	0, 0x6ULL, nullptr, nullptr, OperandInfo241, -1 ,nullptr },  // Inst #1468 = FEXUPR_D
  { 1469,	2,	1,	4,	593,	0, 0x6ULL, nullptr, nullptr, OperandInfo242, -1 ,nullptr },  // Inst #1469 = FEXUPR_W
  { 1470,	2,	1,	4,	584,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1470 = FFINT_S_D
  { 1471,	2,	1,	4,	584,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1471 = FFINT_S_W
  { 1472,	2,	1,	4,	584,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1472 = FFINT_U_D
  { 1473,	2,	1,	4,	584,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1473 = FFINT_U_W
  { 1474,	2,	1,	4,	585,	0, 0x6ULL, nullptr, nullptr, OperandInfo241, -1 ,nullptr },  // Inst #1474 = FFQL_D
  { 1475,	2,	1,	4,	585,	0, 0x6ULL, nullptr, nullptr, OperandInfo242, -1 ,nullptr },  // Inst #1475 = FFQL_W
  { 1476,	2,	1,	4,	586,	0, 0x6ULL, nullptr, nullptr, OperandInfo241, -1 ,nullptr },  // Inst #1476 = FFQR_D
  { 1477,	2,	1,	4,	586,	0, 0x6ULL, nullptr, nullptr, OperandInfo242, -1 ,nullptr },  // Inst #1477 = FFQR_W
  { 1478,	2,	1,	4,	539,	0, 0x6ULL, nullptr, nullptr, OperandInfo243, -1 ,nullptr },  // Inst #1478 = FILL_B
  { 1479,	2,	1,	4,	539,	0, 0x6ULL, nullptr, nullptr, OperandInfo244, -1 ,nullptr },  // Inst #1479 = FILL_D
  { 1480,	2,	1,	4,	539,	0, 0x6ULL, nullptr, nullptr, OperandInfo245, -1 ,nullptr },  // Inst #1480 = FILL_H
  { 1481,	2,	1,	4,	539,	0, 0x6ULL, nullptr, nullptr, OperandInfo246, -1 ,nullptr },  // Inst #1481 = FILL_W
  { 1482,	2,	1,	4,	599,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1482 = FLOG2_D
  { 1483,	2,	1,	4,	599,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1483 = FLOG2_W
  { 1484,	2,	1,	4,	710,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1484 = FLOOR_L_D64
  { 1485,	2,	1,	4,	1298,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1485 = FLOOR_L_D_MMR6
  { 1486,	2,	1,	4,	710,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1486 = FLOOR_L_S
  { 1487,	2,	1,	4,	1298,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1487 = FLOOR_L_S_MMR6
  { 1488,	2,	1,	4,	710,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1488 = FLOOR_W_D32
  { 1489,	2,	1,	4,	710,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1489 = FLOOR_W_D64
  { 1490,	2,	1,	4,	1298,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1490 = FLOOR_W_D_MMR6
  { 1491,	2,	1,	4,	1236,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1491 = FLOOR_W_MM
  { 1492,	2,	1,	4,	710,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1492 = FLOOR_W_S
  { 1493,	2,	1,	4,	1236,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1493 = FLOOR_W_S_MM
  { 1494,	2,	1,	4,	1298,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1494 = FLOOR_W_S_MMR6
  { 1495,	4,	1,	4,	648,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #1495 = FMADD_D
  { 1496,	4,	1,	4,	648,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1496 = FMADD_W
  { 1497,	3,	1,	4,	595,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1497 = FMAX_A_D
  { 1498,	3,	1,	4,	595,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1498 = FMAX_A_W
  { 1499,	3,	1,	4,	596,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1499 = FMAX_D
  { 1500,	3,	1,	4,	596,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1500 = FMAX_W
  { 1501,	3,	1,	4,	597,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1501 = FMIN_A_D
  { 1502,	3,	1,	4,	597,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1502 = FMIN_A_W
  { 1503,	3,	1,	4,	598,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1503 = FMIN_D
  { 1504,	3,	1,	4,	598,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1504 = FMIN_W
  { 1505,	2,	1,	4,	530,	0|(1ULL<<MCID::MoveReg), 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1505 = FMOV_D32
  { 1506,	2,	1,	4,	1264,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1506 = FMOV_D32_MM
  { 1507,	2,	1,	4,	530,	0|(1ULL<<MCID::MoveReg), 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1507 = FMOV_D64
  { 1508,	2,	1,	4,	1264,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1508 = FMOV_D64_MM
  { 1509,	2,	1,	4,	1324,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1509 = FMOV_D_MMR6
  { 1510,	2,	1,	4,	531,	0|(1ULL<<MCID::MoveReg), 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1510 = FMOV_S
  { 1511,	2,	1,	4,	1265,	0|(1ULL<<MCID::MoveReg), 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1511 = FMOV_S_MM
  { 1512,	2,	1,	4,	1321,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1512 = FMOV_S_MMR6
  { 1513,	4,	1,	4,	649,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #1513 = FMSUB_D
  { 1514,	4,	1,	4,	649,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1514 = FMSUB_W
  { 1515,	3,	1,	4,	654,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1515 = FMUL_D
  { 1516,	3,	1,	4,	625,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1516 = FMUL_D32
  { 1517,	3,	1,	4,	1266,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1517 = FMUL_D32_MM
  { 1518,	3,	1,	4,	625,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1518 = FMUL_D64
  { 1519,	3,	1,	4,	1266,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1519 = FMUL_D64_MM
  { 1520,	3,	1,	4,	626,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1520 = FMUL_S
  { 1521,	3,	1,	4,	1267,	0|(1ULL<<MCID::Commutable), 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1521 = FMUL_S_MM
  { 1522,	3,	1,	4,	1322,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1522 = FMUL_S_MMR6
  { 1523,	3,	1,	4,	654,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1523 = FMUL_W
  { 1524,	2,	1,	4,	532,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1524 = FNEG_D32
  { 1525,	2,	1,	4,	1261,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1525 = FNEG_D32_MM
  { 1526,	2,	1,	4,	532,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1526 = FNEG_D64
  { 1527,	2,	1,	4,	1261,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1527 = FNEG_D64_MM
  { 1528,	2,	1,	4,	532,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1528 = FNEG_S
  { 1529,	2,	1,	4,	1261,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1529 = FNEG_S_MM
  { 1530,	2,	1,	4,	1288,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1530 = FNEG_S_MMR6
  { 1531,	3,	2,	4,	1058,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1531 = FORK
  { 1532,	2,	1,	4,	642,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1532 = FRCP_D
  { 1533,	2,	1,	4,	642,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1533 = FRCP_W
  { 1534,	2,	1,	4,	588,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1534 = FRINT_D
  { 1535,	2,	1,	4,	588,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1535 = FRINT_W
  { 1536,	2,	1,	4,	643,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1536 = FRSQRT_D
  { 1537,	2,	1,	4,	643,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1537 = FRSQRT_W
  { 1538,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1538 = FSAF_D
  { 1539,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1539 = FSAF_W
  { 1540,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1540 = FSEQ_D
  { 1541,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1541 = FSEQ_W
  { 1542,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1542 = FSLE_D
  { 1543,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1543 = FSLE_W
  { 1544,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1544 = FSLT_D
  { 1545,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1545 = FSLT_W
  { 1546,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1546 = FSNE_D
  { 1547,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1547 = FSNE_W
  { 1548,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1548 = FSOR_D
  { 1549,	3,	1,	4,	566,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1549 = FSOR_W
  { 1550,	2,	1,	4,	653,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1550 = FSQRT_D
  { 1551,	2,	1,	4,	641,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1551 = FSQRT_D32
  { 1552,	2,	1,	4,	1275,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1552 = FSQRT_D32_MM
  { 1553,	2,	1,	4,	641,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1553 = FSQRT_D64
  { 1554,	2,	1,	4,	1275,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1554 = FSQRT_D64_MM
  { 1555,	2,	1,	4,	640,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1555 = FSQRT_S
  { 1556,	2,	1,	4,	1274,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1556 = FSQRT_S_MM
  { 1557,	2,	1,	4,	652,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1557 = FSQRT_W
  { 1558,	3,	1,	4,	656,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1558 = FSUB_D
  { 1559,	3,	1,	4,	627,	0, 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1559 = FSUB_D32
  { 1560,	3,	1,	4,	1268,	0, 0x4ULL, nullptr, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1560 = FSUB_D32_MM
  { 1561,	3,	1,	4,	627,	0, 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1561 = FSUB_D64
  { 1562,	3,	1,	4,	1268,	0, 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1562 = FSUB_D64_MM
  { 1563,	3,	1,	4,	628,	0, 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1563 = FSUB_S
  { 1564,	3,	1,	4,	1269,	0, 0x4ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1564 = FSUB_S_MM
  { 1565,	3,	1,	4,	1323,	0, 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1565 = FSUB_S_MMR6
  { 1566,	3,	1,	4,	656,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1566 = FSUB_W
  { 1567,	3,	1,	4,	567,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1567 = FSUEQ_D
  { 1568,	3,	1,	4,	567,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1568 = FSUEQ_W
  { 1569,	3,	1,	4,	568,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1569 = FSULE_D
  { 1570,	3,	1,	4,	568,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1570 = FSULE_W
  { 1571,	3,	1,	4,	569,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1571 = FSULT_D
  { 1572,	3,	1,	4,	569,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1572 = FSULT_W
  { 1573,	3,	1,	4,	570,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1573 = FSUNE_D
  { 1574,	3,	1,	4,	570,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1574 = FSUNE_W
  { 1575,	3,	1,	4,	571,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1575 = FSUN_D
  { 1576,	3,	1,	4,	571,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1576 = FSUN_W
  { 1577,	2,	1,	4,	587,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1577 = FTINT_S_D
  { 1578,	2,	1,	4,	587,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1578 = FTINT_S_W
  { 1579,	2,	1,	4,	587,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1579 = FTINT_U_D
  { 1580,	2,	1,	4,	587,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1580 = FTINT_U_W
  { 1581,	3,	1,	4,	589,	0, 0x6ULL, nullptr, nullptr, OperandInfo239, -1 ,nullptr },  // Inst #1581 = FTQ_H
  { 1582,	3,	1,	4,	589,	0, 0x6ULL, nullptr, nullptr, OperandInfo240, -1 ,nullptr },  // Inst #1582 = FTQ_W
  { 1583,	2,	1,	4,	590,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1583 = FTRUNC_S_D
  { 1584,	2,	1,	4,	590,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1584 = FTRUNC_S_W
  { 1585,	2,	1,	4,	590,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #1585 = FTRUNC_U_D
  { 1586,	2,	1,	4,	590,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #1586 = FTRUNC_U_W
  { 1587,	1,	0,	4,	1081,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1587 = GINVI
  { 1588,	1,	0,	4,	1135,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1588 = GINVI_MMR6
  { 1589,	2,	0,	4,	1082,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1589 = GINVT
  { 1590,	2,	0,	4,	1136,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1590 = GINVT_MMR6
  { 1591,	3,	1,	4,	610,	0, 0x6ULL, nullptr, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1591 = HADD_S_D
  { 1592,	3,	1,	4,	610,	0, 0x6ULL, nullptr, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1592 = HADD_S_H
  { 1593,	3,	1,	4,	610,	0, 0x6ULL, nullptr, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1593 = HADD_S_W
  { 1594,	3,	1,	4,	610,	0, 0x6ULL, nullptr, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1594 = HADD_U_D
  { 1595,	3,	1,	4,	610,	0, 0x6ULL, nullptr, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1595 = HADD_U_H
  { 1596,	3,	1,	4,	610,	0, 0x6ULL, nullptr, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1596 = HADD_U_W
  { 1597,	3,	1,	4,	611,	0, 0x6ULL, nullptr, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1597 = HSUB_S_D
  { 1598,	3,	1,	4,	611,	0, 0x6ULL, nullptr, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1598 = HSUB_S_H
  { 1599,	3,	1,	4,	611,	0, 0x6ULL, nullptr, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1599 = HSUB_S_W
  { 1600,	3,	1,	4,	611,	0, 0x6ULL, nullptr, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1600 = HSUB_U_D
  { 1601,	3,	1,	4,	611,	0, 0x6ULL, nullptr, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1601 = HSUB_U_H
  { 1602,	3,	1,	4,	611,	0, 0x6ULL, nullptr, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1602 = HSUB_U_W
  { 1603,	1,	0,	4,	415,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1603 = HYPCALL
  { 1604,	1,	0,	4,	1061,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1604 = HYPCALL_MM
  { 1605,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1605 = ILVEV_B
  { 1606,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1606 = ILVEV_D
  { 1607,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1607 = ILVEV_H
  { 1608,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1608 = ILVEV_W
  { 1609,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1609 = ILVL_B
  { 1610,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1610 = ILVL_D
  { 1611,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1611 = ILVL_H
  { 1612,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1612 = ILVL_W
  { 1613,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1613 = ILVOD_B
  { 1614,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1614 = ILVOD_D
  { 1615,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1615 = ILVOD_H
  { 1616,	3,	1,	4,	601,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1616 = ILVOD_W
  { 1617,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1617 = ILVR_B
  { 1618,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1618 = ILVR_D
  { 1619,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1619 = ILVR_H
  { 1620,	3,	1,	4,	600,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1620 = ILVR_W
  { 1621,	5,	1,	4,	490,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1621 = INS
  { 1622,	4,	1,	4,	513,	0, 0x6ULL, nullptr, nullptr, OperandInfo248, -1 ,nullptr },  // Inst #1622 = INSERT_B
  { 1623,	4,	1,	4,	513,	0, 0x6ULL, nullptr, nullptr, OperandInfo249, -1 ,nullptr },  // Inst #1623 = INSERT_D
  { 1624,	4,	1,	4,	513,	0, 0x6ULL, nullptr, nullptr, OperandInfo250, -1 ,nullptr },  // Inst #1624 = INSERT_H
  { 1625,	4,	1,	4,	513,	0, 0x6ULL, nullptr, nullptr, OperandInfo251, -1 ,nullptr },  // Inst #1625 = INSERT_W
  { 1626,	3,	1,	4,	1341,	0|(1ULL<<MCID::MayLoad), 0x6ULL, ImplicitList18, nullptr, OperandInfo252, -1 ,nullptr },  // Inst #1626 = INSV
  { 1627,	5,	1,	4,	602,	0, 0x6ULL, nullptr, nullptr, OperandInfo253, -1 ,nullptr },  // Inst #1627 = INSVE_B
  { 1628,	5,	1,	4,	602,	0, 0x6ULL, nullptr, nullptr, OperandInfo254, -1 ,nullptr },  // Inst #1628 = INSVE_D
  { 1629,	5,	1,	4,	602,	0, 0x6ULL, nullptr, nullptr, OperandInfo255, -1 ,nullptr },  // Inst #1629 = INSVE_H
  { 1630,	5,	1,	4,	602,	0, 0x6ULL, nullptr, nullptr, OperandInfo256, -1 ,nullptr },  // Inst #1630 = INSVE_W
  { 1631,	3,	1,	4,	1536,	0|(1ULL<<MCID::MayLoad), 0x6ULL, ImplicitList18, nullptr, OperandInfo252, -1 ,nullptr },  // Inst #1631 = INSV_MM
  { 1632,	5,	1,	4,	739,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1632 = INS_MM
  { 1633,	5,	1,	4,	780,	0, 0x1ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1633 = INS_MMR6
  { 1634,	1,	0,	4,	914,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x13ULL, nullptr, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #1634 = J
  { 1635,	1,	0,	4,	401,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call), 0x13ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1635 = JAL
  { 1636,	2,	1,	4,	402,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::UnmodeledSideEffects), 0x11ULL, nullptr, ImplicitList3, OperandInfo32, -1 ,nullptr },  // Inst #1636 = JALR
  { 1637,	1,	0,	2,	951,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook), 0x0ULL, nullptr, ImplicitList3, OperandInfo45, -1 ,nullptr },  // Inst #1637 = JALR16_MM
  { 1638,	2,	1,	4,	1004,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::UnmodeledSideEffects), 0x11ULL, nullptr, ImplicitList3, OperandInfo107, -1 ,nullptr },  // Inst #1638 = JALR64
  { 1639,	1,	0,	2,	993,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook), 0x0ULL, nullptr, ImplicitList3, OperandInfo45, -1 ,nullptr },  // Inst #1639 = JALRC16_MMR6
  { 1640,	2,	1,	4,	994,	0|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::UnmodeledSideEffects), 0x3ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1640 = JALRC_HB_MMR6
  { 1641,	2,	1,	4,	995,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList3, OperandInfo32, -1 ,nullptr },  // Inst #1641 = JALRC_MMR6
  { 1642,	1,	0,	2,	952,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo45, -1 ,nullptr },  // Inst #1642 = JALRS16_MM
  { 1643,	2,	1,	4,	952,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList3, OperandInfo32, -1 ,nullptr },  // Inst #1643 = JALRS_MM
  { 1644,	2,	1,	4,	403,	0|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x13ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1644 = JALR_HB
  { 1645,	2,	1,	4,	1005,	0|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x13ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #1645 = JALR_HB64
  { 1646,	2,	1,	4,	951,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::HasPostISelHook)|(1ULL<<MCID::UnmodeledSideEffects), 0x11ULL, nullptr, ImplicitList3, OperandInfo32, -1 ,nullptr },  // Inst #1646 = JALR_MM
  { 1647,	1,	0,	4,	953,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x3ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1647 = JALS_MM
  { 1648,	1,	0,	4,	404,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call), 0x13ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1648 = JALX
  { 1649,	1,	0,	4,	954,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call), 0x13ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1649 = JALX_MM
  { 1650,	1,	0,	4,	954,	0|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Call), 0x13ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1650 = JAL_MM
  { 1651,	2,	0,	4,	920,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo99, -1 ,nullptr },  // Inst #1651 = JIALC
  { 1652,	2,	0,	4,	1013,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList3, OperandInfo97, -1 ,nullptr },  // Inst #1652 = JIALC64
  { 1653,	2,	0,	4,	996,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList3, OperandInfo99, -1 ,nullptr },  // Inst #1653 = JIALC_MMR6
  { 1654,	2,	0,	4,	925,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo99, -1 ,nullptr },  // Inst #1654 = JIC
  { 1655,	2,	0,	4,	1011,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, ImplicitList2, OperandInfo97, -1 ,nullptr },  // Inst #1655 = JIC64
  { 1656,	2,	0,	4,	984,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList2, OperandInfo99, -1 ,nullptr },  // Inst #1656 = JIC_MMR6
  { 1657,	1,	0,	4,	915,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x11ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1657 = JR
  { 1658,	1,	0,	2,	946,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1658 = JR16_MM
  { 1659,	1,	0,	4,	1003,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x11ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #1659 = JR64
  { 1660,	1,	0,	2,	985,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1660 = JRADDIUSP
  { 1661,	1,	0,	2,	986,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1661 = JRC16_MM
  { 1662,	1,	0,	2,	987,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1662 = JRC16_MMR6
  { 1663,	1,	0,	2,	985,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1663 = JRCADDIUSP_MMR6
  { 1664,	1,	0,	4,	381,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x13ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1664 = JR_HB
  { 1665,	1,	0,	4,	1006,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x13ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #1665 = JR_HB64
  { 1666,	1,	0,	4,	1014,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #1666 = JR_HB64_R6
  { 1667,	1,	0,	4,	926,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1667 = JR_HB_R6
  { 1668,	1,	0,	4,	946,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x11ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1668 = JR_MM
  { 1669,	1,	0,	4,	947,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator), 0x13ULL, nullptr, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #1669 = J_MM
  { 1670,	1,	0,	6,	933,	0|(1ULL<<MCID::Call), 0x0ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1670 = Jal16
  { 1671,	1,	0,	6,	933,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1671 = JalB16
  { 1672,	0,	0,	2,	931,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::DelaySlot)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1672 = JrRa16
  { 1673,	0,	0,	2,	931,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1673 = JrcRa16
  { 1674,	1,	0,	2,	931,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x0ULL, nullptr, nullptr, OperandInfo257, -1 ,nullptr },  // Inst #1674 = JrcRx16
  { 1675,	1,	0,	2,	934,	0|(1ULL<<MCID::Call), 0x0ULL, nullptr, ImplicitList3, OperandInfo257, -1 ,nullptr },  // Inst #1675 = JumpLinkReg16
  { 1676,	3,	1,	4,	426,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1676 = LB
  { 1677,	3,	1,	4,	1158,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1677 = LB64
  { 1678,	3,	1,	4,	436,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1678 = LBE
  { 1679,	3,	1,	4,	1083,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1679 = LBE_MM
  { 1680,	3,	1,	2,	1110,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo258, -1 ,nullptr },  // Inst #1680 = LBU16_MM
  { 1681,	3,	1,	4,	1377,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1681 = LBUX
  { 1682,	3,	1,	4,	1537,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1682 = LBUX_MM
  { 1683,	3,	1,	4,	1137,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1683 = LBU_MMR6
  { 1684,	3,	1,	4,	1111,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1684 = LB_MM
  { 1685,	3,	1,	4,	1138,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1685 = LB_MMR6
  { 1686,	3,	1,	4,	427,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1686 = LBu
  { 1687,	3,	1,	4,	1159,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1687 = LBu64
  { 1688,	3,	1,	4,	437,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1688 = LBuE
  { 1689,	3,	1,	4,	1084,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1689 = LBuE_MM
  { 1690,	3,	1,	4,	1110,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1690 = LBu_MM
  { 1691,	3,	1,	4,	1155,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1691 = LD
  { 1692,	3,	1,	4,	702,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1692 = LDC1
  { 1693,	3,	1,	4,	702,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1693 = LDC164
  { 1694,	3,	1,	4,	1327,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1694 = LDC1_D64_MMR6
  { 1695,	3,	1,	4,	1284,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1695 = LDC1_MM
  { 1696,	3,	1,	4,	434,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1696 = LDC2
  { 1697,	3,	1,	4,	1139,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo262, -1 ,nullptr },  // Inst #1697 = LDC2_MMR6
  { 1698,	3,	1,	4,	1073,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1698 = LDC2_R6
  { 1699,	3,	1,	4,	435,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1699 = LDC3
  { 1700,	2,	1,	4,	542,	0, 0x6ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1700 = LDI_B
  { 1701,	2,	1,	4,	542,	0, 0x6ULL, nullptr, nullptr, OperandInfo265, -1 ,nullptr },  // Inst #1701 = LDI_D
  { 1702,	2,	1,	4,	542,	0, 0x6ULL, nullptr, nullptr, OperandInfo266, -1 ,nullptr },  // Inst #1702 = LDI_H
  { 1703,	2,	1,	4,	542,	0, 0x6ULL, nullptr, nullptr, OperandInfo267, -1 ,nullptr },  // Inst #1703 = LDI_W
  { 1704,	4,	1,	4,	1165,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo268, -1 ,nullptr },  // Inst #1704 = LDL
  { 1705,	2,	1,	4,	1177,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #1705 = LDPC
  { 1706,	4,	1,	4,	1166,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo268, -1 ,nullptr },  // Inst #1706 = LDR
  { 1707,	3,	1,	4,	703,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #1707 = LDXC1
  { 1708,	3,	1,	4,	703,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1708 = LDXC164
  { 1709,	3,	1,	4,	707,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #1709 = LD_B
  { 1710,	3,	1,	4,	707,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo272, -1 ,nullptr },  // Inst #1710 = LD_D
  { 1711,	3,	1,	4,	707,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #1711 = LD_H
  { 1712,	3,	1,	4,	707,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo274, -1 ,nullptr },  // Inst #1712 = LD_W
  { 1713,	3,	1,	4,	716,	0, 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1713 = LEA_ADDiu
  { 1714,	3,	1,	4,	832,	0, 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1714 = LEA_ADDiu64
  { 1715,	3,	1,	4,	730,	0, 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1715 = LEA_ADDiu_MM
  { 1716,	3,	1,	4,	428,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1716 = LH
  { 1717,	3,	1,	4,	1160,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1717 = LH64
  { 1718,	3,	1,	4,	438,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1718 = LHE
  { 1719,	3,	1,	4,	1085,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1719 = LHE_MM
  { 1720,	3,	1,	2,	1112,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo258, -1 ,nullptr },  // Inst #1720 = LHU16_MM
  { 1721,	3,	1,	4,	1378,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1721 = LHX
  { 1722,	3,	1,	4,	1538,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1722 = LHX_MM
  { 1723,	3,	1,	4,	1113,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1723 = LH_MM
  { 1724,	3,	1,	4,	429,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1724 = LHu
  { 1725,	3,	1,	4,	1161,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1725 = LHu64
  { 1726,	3,	1,	4,	439,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1726 = LHuE
  { 1727,	3,	1,	4,	1086,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1727 = LHuE_MM
  { 1728,	3,	1,	4,	1112,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1728 = LHu_MM
  { 1729,	2,	1,	2,	740,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1729 = LI16_MM
  { 1730,	2,	1,	2,	781,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1730 = LI16_MMR6
  { 1731,	3,	1,	4,	431,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1731 = LL
  { 1732,	3,	1,	4,	1156,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1732 = LL64
  { 1733,	3,	1,	4,	1179,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1733 = LL64_R6
  { 1734,	3,	1,	4,	1156,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1734 = LLD
  { 1735,	3,	1,	4,	1178,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1735 = LLD_R6
  { 1736,	3,	1,	4,	441,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1736 = LLE
  { 1737,	3,	1,	4,	1090,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1737 = LLE_MM
  { 1738,	3,	1,	4,	1114,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1738 = LL_MM
  { 1739,	3,	1,	4,	1140,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1739 = LL_MMR6
  { 1740,	3,	1,	4,	1074,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1740 = LL_R6
  { 1741,	4,	1,	4,	508,	0, 0x6ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #1741 = LSA
  { 1742,	4,	1,	4,	782,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #1742 = LSA_MMR6
  { 1743,	4,	1,	4,	725,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #1743 = LSA_R6
  { 1744,	2,	1,	4,	783,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1744 = LUI_MMR6
  { 1745,	3,	1,	4,	706,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #1745 = LUXC1
  { 1746,	3,	1,	4,	706,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1746 = LUXC164
  { 1747,	3,	1,	4,	1285,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1747 = LUXC1_MM
  { 1748,	2,	1,	4,	360,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x2ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1748 = LUi
  { 1749,	2,	1,	4,	833,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x2ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #1749 = LUi64
  { 1750,	2,	1,	4,	741,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x2ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1750 = LUi_MM
  { 1751,	3,	1,	4,	430,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1751 = LW
  { 1752,	3,	1,	2,	1115,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo258, -1 ,nullptr },  // Inst #1752 = LW16_MM
  { 1753,	3,	1,	4,	1162,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1753 = LW64
  { 1754,	3,	1,	4,	704,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #1754 = LWC1
  { 1755,	3,	1,	4,	1286,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #1755 = LWC1_MM
  { 1756,	3,	1,	4,	432,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1756 = LWC2
  { 1757,	3,	1,	4,	1142,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo262, -1 ,nullptr },  // Inst #1757 = LWC2_MMR6
  { 1758,	3,	1,	4,	1075,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1758 = LWC2_R6
  { 1759,	3,	1,	4,	433,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1759 = LWC3
  { 1760,	3,	1,	4,	1331,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #1760 = LWDSP
  { 1761,	3,	1,	4,	1494,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #1761 = LWDSP_MM
  { 1762,	3,	1,	4,	440,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1762 = LWE
  { 1763,	3,	1,	4,	1087,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1763 = LWE_MM
  { 1764,	3,	1,	2,	1115,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo277, -1 ,nullptr },  // Inst #1764 = LWGP_MM
  { 1765,	4,	1,	4,	443,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1765 = LWL
  { 1766,	4,	1,	4,	1163,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo268, -1 ,nullptr },  // Inst #1766 = LWL64
  { 1767,	4,	1,	4,	445,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1767 = LWLE
  { 1768,	4,	1,	4,	1088,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1768 = LWLE_MM
  { 1769,	4,	1,	4,	1116,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1769 = LWL_MM
  { 1770,	3,	1,	2,	1117,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo279, -1 ,nullptr },  // Inst #1770 = LWM16_MM
  { 1771,	3,	1,	2,	1141,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo279, -1 ,nullptr },  // Inst #1771 = LWM16_MMR6
  { 1772,	3,	1,	4,	1117,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo95, -1 ,nullptr },  // Inst #1772 = LWM32_MM
  { 1773,	2,	1,	4,	442,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1773 = LWPC
  { 1774,	2,	1,	4,	1143,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1774 = LWPC_MMR6
  { 1775,	4,	2,	4,	1118,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo280, -1 ,nullptr },  // Inst #1775 = LWP_MM
  { 1776,	4,	1,	4,	444,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1776 = LWR
  { 1777,	4,	1,	4,	1164,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo268, -1 ,nullptr },  // Inst #1777 = LWR64
  { 1778,	4,	1,	4,	446,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1778 = LWRE
  { 1779,	4,	1,	4,	1089,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1779 = LWRE_MM
  { 1780,	4,	1,	4,	1119,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1780 = LWR_MM
  { 1781,	3,	1,	2,	1115,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo281, -1 ,nullptr },  // Inst #1781 = LWSP_MM
  { 1782,	2,	1,	4,	1176,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #1782 = LWUPC
  { 1783,	3,	1,	4,	1120,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1783 = LWU_MM
  { 1784,	3,	1,	4,	1379,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1784 = LWX
  { 1785,	3,	1,	4,	705,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo282, -1 ,nullptr },  // Inst #1785 = LWXC1
  { 1786,	3,	1,	4,	1287,	0|(1ULL<<MCID::MayLoad), 0x5ULL, nullptr, nullptr, OperandInfo282, -1 ,nullptr },  // Inst #1786 = LWXC1_MM
  { 1787,	3,	1,	4,	1121,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1787 = LWXS_MM
  { 1788,	3,	1,	4,	1539,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1788 = LWX_MM
  { 1789,	3,	1,	4,	1115,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1789 = LW_MM
  { 1790,	3,	1,	4,	1144,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #1790 = LW_MMR6
  { 1791,	3,	1,	4,	1157,	0|(1ULL<<MCID::FoldableAsLoad)|(1ULL<<MCID::MayLoad), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #1791 = LWu
  { 1792,	3,	1,	4,	1101,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #1792 = LbRxRyOffMemX16
  { 1793,	3,	1,	4,	1102,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #1793 = LbuRxRyOffMemX16
  { 1794,	3,	1,	4,	1103,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #1794 = LhRxRyOffMemX16
  { 1795,	3,	1,	4,	1104,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #1795 = LhuRxRyOffMemX16
  { 1796,	2,	1,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo167, -1 ,nullptr },  // Inst #1796 = LiRxImm16
  { 1797,	2,	1,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo167, -1 ,nullptr },  // Inst #1797 = LiRxImmAlignX16
  { 1798,	2,	1,	4,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo167, -1 ,nullptr },  // Inst #1798 = LiRxImmX16
  { 1799,	3,	1,	2,	1105,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #1799 = LwRxPcTcp16
  { 1800,	3,	1,	4,	1105,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #1800 = LwRxPcTcpX16
  { 1801,	3,	1,	4,	1105,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #1801 = LwRxRyOffMemX16
  { 1802,	3,	1,	4,	1105,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo169, -1 ,nullptr },  // Inst #1802 = LwRxSpImmX16
  { 1803,	2,	0,	4,	845,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1803 = MADD
  { 1804,	4,	1,	4,	1224,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #1804 = MADDF_D
  { 1805,	4,	1,	4,	1317,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #1805 = MADDF_D_MMR6
  { 1806,	4,	1,	4,	1222,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #1806 = MADDF_S
  { 1807,	4,	1,	4,	1318,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #1807 = MADDF_S_MMR6
  { 1808,	4,	1,	4,	663,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1808 = MADDR_Q_H
  { 1809,	4,	1,	4,	663,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1809 = MADDR_Q_W
  { 1810,	2,	0,	4,	846,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1810 = MADDU
  { 1811,	4,	1,	4,	1380,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1811 = MADDU_DSP
  { 1812,	4,	1,	4,	1540,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1812 = MADDU_DSP_MM
  { 1813,	2,	0,	4,	873,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1813 = MADDU_MM
  { 1814,	4,	1,	4,	661,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #1814 = MADDV_B
  { 1815,	4,	1,	4,	661,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #1815 = MADDV_D
  { 1816,	4,	1,	4,	661,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1816 = MADDV_H
  { 1817,	4,	1,	4,	661,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1817 = MADDV_W
  { 1818,	4,	1,	4,	669,	0, 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #1818 = MADD_D32
  { 1819,	4,	1,	4,	1242,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #1819 = MADD_D32_MM
  { 1820,	4,	1,	4,	669,	0, 0x4ULL, nullptr, nullptr, OperandInfo288, -1 ,nullptr },  // Inst #1820 = MADD_D64
  { 1821,	4,	1,	4,	1381,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1821 = MADD_DSP
  { 1822,	4,	1,	4,	1541,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1822 = MADD_DSP_MM
  { 1823,	2,	0,	4,	872,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1823 = MADD_MM
  { 1824,	4,	1,	4,	664,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1824 = MADD_Q_H
  { 1825,	4,	1,	4,	664,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1825 = MADD_Q_W
  { 1826,	4,	1,	4,	670,	0, 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #1826 = MADD_S
  { 1827,	4,	1,	4,	1241,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #1827 = MADD_S_MM
  { 1828,	4,	1,	4,	1382,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1828 = MAQ_SA_W_PHL
  { 1829,	4,	1,	4,	1542,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1829 = MAQ_SA_W_PHL_MM
  { 1830,	4,	1,	4,	1383,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1830 = MAQ_SA_W_PHR
  { 1831,	4,	1,	4,	1543,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1831 = MAQ_SA_W_PHR_MM
  { 1832,	4,	1,	4,	1384,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1832 = MAQ_S_W_PHL
  { 1833,	4,	1,	4,	1544,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1833 = MAQ_S_W_PHL_MM
  { 1834,	4,	1,	4,	1385,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1834 = MAQ_S_W_PHR
  { 1835,	4,	1,	4,	1545,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #1835 = MAQ_S_W_PHR_MM
  { 1836,	3,	1,	4,	1212,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1836 = MAXA_D
  { 1837,	3,	1,	4,	1308,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1837 = MAXA_D_MMR6
  { 1838,	3,	1,	4,	1211,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1838 = MAXA_S
  { 1839,	3,	1,	4,	1309,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1839 = MAXA_S_MMR6
  { 1840,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1840 = MAXI_S_B
  { 1841,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #1841 = MAXI_S_D
  { 1842,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #1842 = MAXI_S_H
  { 1843,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1843 = MAXI_S_W
  { 1844,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1844 = MAXI_U_B
  { 1845,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #1845 = MAXI_U_D
  { 1846,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #1846 = MAXI_U_H
  { 1847,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1847 = MAXI_U_W
  { 1848,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1848 = MAX_A_B
  { 1849,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1849 = MAX_A_D
  { 1850,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1850 = MAX_A_H
  { 1851,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1851 = MAX_A_W
  { 1852,	3,	1,	4,	1212,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1852 = MAX_D
  { 1853,	3,	1,	4,	1304,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1853 = MAX_D_MMR6
  { 1854,	3,	1,	4,	1211,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1854 = MAX_S
  { 1855,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1855 = MAX_S_B
  { 1856,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1856 = MAX_S_D
  { 1857,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1857 = MAX_S_H
  { 1858,	3,	1,	4,	1305,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1858 = MAX_S_MMR6
  { 1859,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1859 = MAX_S_W
  { 1860,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1860 = MAX_U_B
  { 1861,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1861 = MAX_U_D
  { 1862,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1862 = MAX_U_H
  { 1863,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1863 = MAX_U_W
  { 1864,	3,	1,	4,	411,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1864 = MFC0
  { 1865,	3,	1,	4,	1033,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1865 = MFC0_MMR6
  { 1866,	2,	1,	4,	687,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Bitcast), 0x4ULL, nullptr, nullptr, OperandInfo106, -1 ,nullptr },  // Inst #1866 = MFC1
  { 1867,	2,	1,	4,	687,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo290, -1 ,nullptr },  // Inst #1867 = MFC1_D64
  { 1868,	2,	1,	4,	1255,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Bitcast), 0x4ULL, nullptr, nullptr, OperandInfo106, -1 ,nullptr },  // Inst #1868 = MFC1_MM
  { 1869,	2,	1,	4,	1300,	0|(1ULL<<MCID::Bitcast), 0x6ULL, nullptr, nullptr, OperandInfo106, -1 ,nullptr },  // Inst #1869 = MFC1_MMR6
  { 1870,	3,	1,	4,	413,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #1870 = MFC2
  { 1871,	2,	1,	4,	1034,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo193, -1 ,nullptr },  // Inst #1871 = MFC2_MMR6
  { 1872,	3,	1,	4,	416,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1872 = MFGC0
  { 1873,	3,	1,	4,	1068,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1873 = MFGC0_MM
  { 1874,	3,	1,	4,	1032,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1874 = MFHC0_MMR6
  { 1875,	2,	1,	4,	688,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #1875 = MFHC1_D32
  { 1876,	2,	1,	4,	1256,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #1876 = MFHC1_D32_MM
  { 1877,	2,	1,	4,	688,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo290, -1 ,nullptr },  // Inst #1877 = MFHC1_D64
  { 1878,	2,	1,	4,	1256,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo290, -1 ,nullptr },  // Inst #1878 = MFHC1_D64_MM
  { 1879,	2,	1,	4,	1034,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo193, -1 ,nullptr },  // Inst #1879 = MFHC2_MMR6
  { 1880,	3,	1,	4,	417,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1880 = MFHGC0
  { 1881,	3,	1,	4,	1069,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #1881 = MFHGC0_MM
  { 1882,	1,	1,	4,	473,	0|(1ULL<<MCID::MoveReg), 0x1ULL, ImplicitList19, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1882 = MFHI
  { 1883,	1,	1,	2,	879,	0|(1ULL<<MCID::MoveReg), 0x0ULL, ImplicitList19, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1883 = MFHI16_MM
  { 1884,	1,	1,	4,	898,	0|(1ULL<<MCID::MoveReg), 0x1ULL, ImplicitList20, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #1884 = MFHI64
  { 1885,	2,	1,	4,	1386,	0|(1ULL<<MCID::MoveReg), 0x6ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #1885 = MFHI_DSP
  { 1886,	2,	1,	4,	1546,	0, 0x6ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #1886 = MFHI_DSP_MM
  { 1887,	1,	1,	4,	879,	0|(1ULL<<MCID::MoveReg), 0x1ULL, ImplicitList19, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1887 = MFHI_MM
  { 1888,	1,	1,	4,	473,	0|(1ULL<<MCID::MoveReg), 0x1ULL, ImplicitList19, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1888 = MFLO
  { 1889,	1,	1,	2,	879,	0|(1ULL<<MCID::MoveReg), 0x0ULL, ImplicitList19, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1889 = MFLO16_MM
  { 1890,	1,	1,	4,	898,	0|(1ULL<<MCID::MoveReg), 0x1ULL, ImplicitList20, nullptr, OperandInfo82, -1 ,nullptr },  // Inst #1890 = MFLO64
  { 1891,	2,	1,	4,	1387,	0|(1ULL<<MCID::MoveReg), 0x6ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #1891 = MFLO_DSP
  { 1892,	2,	1,	4,	1547,	0, 0x6ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #1892 = MFLO_DSP_MM
  { 1893,	1,	1,	4,	879,	0|(1ULL<<MCID::MoveReg), 0x1ULL, ImplicitList19, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #1893 = MFLO_MM
  { 1894,	5,	1,	4,	1055,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #1894 = MFTR
  { 1895,	3,	1,	4,	1213,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1895 = MINA_D
  { 1896,	3,	1,	4,	1310,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1896 = MINA_D_MMR6
  { 1897,	3,	1,	4,	1214,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1897 = MINA_S
  { 1898,	3,	1,	4,	1311,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1898 = MINA_S_MMR6
  { 1899,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1899 = MINI_S_B
  { 1900,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #1900 = MINI_S_D
  { 1901,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #1901 = MINI_S_H
  { 1902,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1902 = MINI_S_W
  { 1903,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1903 = MINI_U_B
  { 1904,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #1904 = MINI_U_D
  { 1905,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #1905 = MINI_U_H
  { 1906,	3,	1,	4,	615,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1906 = MINI_U_W
  { 1907,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1907 = MIN_A_B
  { 1908,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1908 = MIN_A_D
  { 1909,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1909 = MIN_A_H
  { 1910,	3,	1,	4,	614,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1910 = MIN_A_W
  { 1911,	3,	1,	4,	1214,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1911 = MIN_D
  { 1912,	3,	1,	4,	1306,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1912 = MIN_D_MMR6
  { 1913,	3,	1,	4,	1213,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1913 = MIN_S
  { 1914,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1914 = MIN_S_B
  { 1915,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1915 = MIN_S_D
  { 1916,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1916 = MIN_S_H
  { 1917,	3,	1,	4,	1307,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1917 = MIN_S_MMR6
  { 1918,	3,	1,	4,	612,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1918 = MIN_S_W
  { 1919,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1919 = MIN_U_B
  { 1920,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1920 = MIN_U_D
  { 1921,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1921 = MIN_U_H
  { 1922,	3,	1,	4,	613,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1922 = MIN_U_W
  { 1923,	3,	1,	4,	865,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1923 = MOD
  { 1924,	3,	1,	4,	1388,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1924 = MODSUB
  { 1925,	3,	1,	4,	1548,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1925 = MODSUB_MM
  { 1926,	3,	1,	4,	866,	0|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1926 = MODU
  { 1927,	3,	1,	4,	888,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1927 = MODU_MMR6
  { 1928,	3,	1,	4,	889,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UsesCustomInserter), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #1928 = MOD_MMR6
  { 1929,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1929 = MOD_S_B
  { 1930,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1930 = MOD_S_D
  { 1931,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1931 = MOD_S_H
  { 1932,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1932 = MOD_S_W
  { 1933,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1933 = MOD_U_B
  { 1934,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1934 = MOD_U_D
  { 1935,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1935 = MOD_U_H
  { 1936,	3,	1,	4,	608,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1936 = MOD_U_W
  { 1937,	2,	1,	2,	742,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1937 = MOVE16_MM
  { 1938,	2,	1,	2,	784,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1938 = MOVE16_MMR6
  { 1939,	4,	2,	2,	743,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo294, -1 ,nullptr },  // Inst #1939 = MOVEP_MM
  { 1940,	4,	2,	2,	1549,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo294, -1 ,nullptr },  // Inst #1940 = MOVEP_MMR6
  { 1941,	2,	1,	4,	541,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo295, -1 ,nullptr },  // Inst #1941 = MOVE_V
  { 1942,	4,	1,	4,	526,	0, 0x4ULL, nullptr, nullptr, OperandInfo296, -1 ,nullptr },  // Inst #1942 = MOVF_D32
  { 1943,	4,	1,	4,	1226,	0, 0x4ULL, nullptr, nullptr, OperandInfo296, -1 ,nullptr },  // Inst #1943 = MOVF_D32_MM
  { 1944,	4,	1,	4,	526,	0, 0x4ULL, nullptr, nullptr, OperandInfo297, -1 ,nullptr },  // Inst #1944 = MOVF_D64
  { 1945,	4,	1,	4,	689,	0, 0x4ULL, nullptr, nullptr, OperandInfo298, -1 ,nullptr },  // Inst #1945 = MOVF_I
  { 1946,	4,	1,	4,	1204,	0, 0x4ULL, nullptr, nullptr, OperandInfo299, -1 ,nullptr },  // Inst #1946 = MOVF_I64
  { 1947,	4,	1,	4,	880,	0, 0x4ULL, nullptr, nullptr, OperandInfo298, -1 ,nullptr },  // Inst #1947 = MOVF_I_MM
  { 1948,	4,	1,	4,	527,	0, 0x4ULL, nullptr, nullptr, OperandInfo300, -1 ,nullptr },  // Inst #1948 = MOVF_S
  { 1949,	4,	1,	4,	1227,	0, 0x4ULL, nullptr, nullptr, OperandInfo300, -1 ,nullptr },  // Inst #1949 = MOVF_S_MM
  { 1950,	4,	1,	4,	1206,	0, 0x4ULL, nullptr, nullptr, OperandInfo301, -1 ,nullptr },  // Inst #1950 = MOVN_I64_D64
  { 1951,	4,	1,	4,	902,	0, 0x4ULL, nullptr, nullptr, OperandInfo302, -1 ,nullptr },  // Inst #1951 = MOVN_I64_I
  { 1952,	4,	1,	4,	902,	0, 0x4ULL, nullptr, nullptr, OperandInfo303, -1 ,nullptr },  // Inst #1952 = MOVN_I64_I64
  { 1953,	4,	1,	4,	1207,	0, 0x4ULL, nullptr, nullptr, OperandInfo304, -1 ,nullptr },  // Inst #1953 = MOVN_I64_S
  { 1954,	4,	1,	4,	698,	0, 0x4ULL, nullptr, nullptr, OperandInfo305, -1 ,nullptr },  // Inst #1954 = MOVN_I_D32
  { 1955,	4,	1,	4,	1228,	0, 0x4ULL, nullptr, nullptr, OperandInfo305, -1 ,nullptr },  // Inst #1955 = MOVN_I_D32_MM
  { 1956,	4,	1,	4,	698,	0, 0x4ULL, nullptr, nullptr, OperandInfo306, -1 ,nullptr },  // Inst #1956 = MOVN_I_D64
  { 1957,	4,	1,	4,	477,	0, 0x4ULL, nullptr, nullptr, OperandInfo307, -1 ,nullptr },  // Inst #1957 = MOVN_I_I
  { 1958,	4,	1,	4,	902,	0, 0x4ULL, nullptr, nullptr, OperandInfo308, -1 ,nullptr },  // Inst #1958 = MOVN_I_I64
  { 1959,	4,	1,	4,	1550,	0, 0x4ULL, nullptr, nullptr, OperandInfo307, -1 ,nullptr },  // Inst #1959 = MOVN_I_MM
  { 1960,	4,	1,	4,	699,	0, 0x4ULL, nullptr, nullptr, OperandInfo309, -1 ,nullptr },  // Inst #1960 = MOVN_I_S
  { 1961,	4,	1,	4,	1229,	0, 0x4ULL, nullptr, nullptr, OperandInfo309, -1 ,nullptr },  // Inst #1961 = MOVN_I_S_MM
  { 1962,	4,	1,	4,	528,	0, 0x4ULL, nullptr, nullptr, OperandInfo296, -1 ,nullptr },  // Inst #1962 = MOVT_D32
  { 1963,	4,	1,	4,	1230,	0, 0x4ULL, nullptr, nullptr, OperandInfo296, -1 ,nullptr },  // Inst #1963 = MOVT_D32_MM
  { 1964,	4,	1,	4,	528,	0, 0x4ULL, nullptr, nullptr, OperandInfo297, -1 ,nullptr },  // Inst #1964 = MOVT_D64
  { 1965,	4,	1,	4,	690,	0, 0x4ULL, nullptr, nullptr, OperandInfo298, -1 ,nullptr },  // Inst #1965 = MOVT_I
  { 1966,	4,	1,	4,	1203,	0, 0x4ULL, nullptr, nullptr, OperandInfo299, -1 ,nullptr },  // Inst #1966 = MOVT_I64
  { 1967,	4,	1,	4,	881,	0, 0x4ULL, nullptr, nullptr, OperandInfo298, -1 ,nullptr },  // Inst #1967 = MOVT_I_MM
  { 1968,	4,	1,	4,	529,	0, 0x4ULL, nullptr, nullptr, OperandInfo300, -1 ,nullptr },  // Inst #1968 = MOVT_S
  { 1969,	4,	1,	4,	1231,	0, 0x4ULL, nullptr, nullptr, OperandInfo300, -1 ,nullptr },  // Inst #1969 = MOVT_S_MM
  { 1970,	4,	1,	4,	1208,	0, 0x4ULL, nullptr, nullptr, OperandInfo301, -1 ,nullptr },  // Inst #1970 = MOVZ_I64_D64
  { 1971,	4,	1,	4,	903,	0, 0x4ULL, nullptr, nullptr, OperandInfo302, -1 ,nullptr },  // Inst #1971 = MOVZ_I64_I
  { 1972,	4,	1,	4,	903,	0, 0x4ULL, nullptr, nullptr, OperandInfo303, -1 ,nullptr },  // Inst #1972 = MOVZ_I64_I64
  { 1973,	4,	1,	4,	1205,	0, 0x4ULL, nullptr, nullptr, OperandInfo304, -1 ,nullptr },  // Inst #1973 = MOVZ_I64_S
  { 1974,	4,	1,	4,	700,	0, 0x4ULL, nullptr, nullptr, OperandInfo305, -1 ,nullptr },  // Inst #1974 = MOVZ_I_D32
  { 1975,	4,	1,	4,	1232,	0, 0x4ULL, nullptr, nullptr, OperandInfo305, -1 ,nullptr },  // Inst #1975 = MOVZ_I_D32_MM
  { 1976,	4,	1,	4,	700,	0, 0x4ULL, nullptr, nullptr, OperandInfo306, -1 ,nullptr },  // Inst #1976 = MOVZ_I_D64
  { 1977,	4,	1,	4,	478,	0, 0x4ULL, nullptr, nullptr, OperandInfo307, -1 ,nullptr },  // Inst #1977 = MOVZ_I_I
  { 1978,	4,	1,	4,	903,	0, 0x4ULL, nullptr, nullptr, OperandInfo308, -1 ,nullptr },  // Inst #1978 = MOVZ_I_I64
  { 1979,	4,	1,	4,	1551,	0, 0x4ULL, nullptr, nullptr, OperandInfo307, -1 ,nullptr },  // Inst #1979 = MOVZ_I_MM
  { 1980,	4,	1,	4,	701,	0, 0x4ULL, nullptr, nullptr, OperandInfo309, -1 ,nullptr },  // Inst #1980 = MOVZ_I_S
  { 1981,	4,	1,	4,	1233,	0, 0x4ULL, nullptr, nullptr, OperandInfo309, -1 ,nullptr },  // Inst #1981 = MOVZ_I_S_MM
  { 1982,	2,	0,	4,	847,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1982 = MSUB
  { 1983,	4,	1,	4,	1225,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #1983 = MSUBF_D
  { 1984,	4,	1,	4,	1319,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #1984 = MSUBF_D_MMR6
  { 1985,	4,	1,	4,	1223,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #1985 = MSUBF_S
  { 1986,	4,	1,	4,	1320,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #1986 = MSUBF_S_MMR6
  { 1987,	4,	1,	4,	665,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1987 = MSUBR_Q_H
  { 1988,	4,	1,	4,	665,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1988 = MSUBR_Q_W
  { 1989,	2,	0,	4,	848,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1989 = MSUBU
  { 1990,	4,	1,	4,	1389,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1990 = MSUBU_DSP
  { 1991,	4,	1,	4,	1552,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1991 = MSUBU_DSP_MM
  { 1992,	2,	0,	4,	875,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #1992 = MSUBU_MM
  { 1993,	4,	1,	4,	660,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #1993 = MSUBV_B
  { 1994,	4,	1,	4,	660,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #1994 = MSUBV_D
  { 1995,	4,	1,	4,	660,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1995 = MSUBV_H
  { 1996,	4,	1,	4,	660,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1996 = MSUBV_W
  { 1997,	4,	1,	4,	671,	0, 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #1997 = MSUB_D32
  { 1998,	4,	1,	4,	1271,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #1998 = MSUB_D32_MM
  { 1999,	4,	1,	4,	671,	0, 0x4ULL, nullptr, nullptr, OperandInfo288, -1 ,nullptr },  // Inst #1999 = MSUB_D64
  { 2000,	4,	1,	4,	1390,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #2000 = MSUB_DSP
  { 2001,	4,	1,	4,	1553,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #2001 = MSUB_DSP_MM
  { 2002,	2,	0,	4,	874,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, ImplicitList6, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2002 = MSUB_MM
  { 2003,	4,	1,	4,	666,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #2003 = MSUB_Q_H
  { 2004,	4,	1,	4,	666,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #2004 = MSUB_Q_W
  { 2005,	4,	1,	4,	672,	0, 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2005 = MSUB_S
  { 2006,	4,	1,	4,	1270,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2006 = MSUB_S_MM
  { 2007,	3,	1,	4,	412,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2007 = MTC0
  { 2008,	3,	1,	4,	1036,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2008 = MTC0_MMR6
  { 2009,	2,	1,	4,	678,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Bitcast), 0x4ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #2009 = MTC1
  { 2010,	2,	1,	4,	678,	0|(1ULL<<MCID::MoveReg), 0x4ULL, nullptr, nullptr, OperandInfo120, -1 ,nullptr },  // Inst #2010 = MTC1_D64
  { 2011,	2,	1,	4,	1257,	0|(1ULL<<MCID::MoveReg), 0x4ULL, nullptr, nullptr, OperandInfo120, -1 ,nullptr },  // Inst #2011 = MTC1_D64_MM
  { 2012,	2,	1,	4,	1257,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::Bitcast), 0x4ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #2012 = MTC1_MM
  { 2013,	2,	1,	4,	1301,	0|(1ULL<<MCID::Bitcast), 0x6ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #2013 = MTC1_MMR6
  { 2014,	3,	1,	4,	414,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo310, -1 ,nullptr },  // Inst #2014 = MTC2
  { 2015,	2,	1,	4,	1037,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo206, -1 ,nullptr },  // Inst #2015 = MTC2_MMR6
  { 2016,	3,	1,	4,	418,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2016 = MTGC0
  { 2017,	3,	1,	4,	1070,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2017 = MTGC0_MM
  { 2018,	3,	1,	4,	1035,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2018 = MTHC0_MMR6
  { 2019,	3,	1,	4,	679,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo311, -1 ,nullptr },  // Inst #2019 = MTHC1_D32
  { 2020,	3,	1,	4,	1258,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo311, -1 ,nullptr },  // Inst #2020 = MTHC1_D32_MM
  { 2021,	3,	1,	4,	679,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo312, -1 ,nullptr },  // Inst #2021 = MTHC1_D64
  { 2022,	3,	1,	4,	1258,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo312, -1 ,nullptr },  // Inst #2022 = MTHC1_D64_MM
  { 2023,	2,	1,	4,	1037,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo206, -1 ,nullptr },  // Inst #2023 = MTHC2_MMR6
  { 2024,	3,	1,	4,	419,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2024 = MTHGC0
  { 2025,	3,	1,	4,	1071,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #2025 = MTHGC0_MM
  { 2026,	1,	0,	4,	488,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList21, OperandInfo45, -1 ,nullptr },  // Inst #2026 = MTHI
  { 2027,	1,	0,	4,	900,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList22, OperandInfo82, -1 ,nullptr },  // Inst #2027 = MTHI64
  { 2028,	2,	1,	4,	1343,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo313, -1 ,nullptr },  // Inst #2028 = MTHI_DSP
  { 2029,	2,	1,	4,	1554,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo313, -1 ,nullptr },  // Inst #2029 = MTHI_DSP_MM
  { 2030,	1,	0,	4,	882,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList21, OperandInfo45, -1 ,nullptr },  // Inst #2030 = MTHI_MM
  { 2031,	3,	1,	4,	1342,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList4, OperandInfo314, -1 ,nullptr },  // Inst #2031 = MTHLIP
  { 2032,	3,	1,	4,	1555,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList4, OperandInfo314, -1 ,nullptr },  // Inst #2032 = MTHLIP_MM
  { 2033,	1,	0,	4,	488,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList23, OperandInfo45, -1 ,nullptr },  // Inst #2033 = MTLO
  { 2034,	1,	0,	4,	900,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList24, OperandInfo82, -1 ,nullptr },  // Inst #2034 = MTLO64
  { 2035,	2,	1,	4,	1344,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo315, -1 ,nullptr },  // Inst #2035 = MTLO_DSP
  { 2036,	2,	1,	4,	1556,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo315, -1 ,nullptr },  // Inst #2036 = MTLO_DSP_MM
  { 2037,	1,	0,	4,	882,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList23, OperandInfo45, -1 ,nullptr },  // Inst #2037 = MTLO_MM
  { 2038,	1,	0,	4,	1197,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList25, OperandInfo82, -1 ,nullptr },  // Inst #2038 = MTM0
  { 2039,	1,	0,	4,	1197,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList26, OperandInfo82, -1 ,nullptr },  // Inst #2039 = MTM1
  { 2040,	1,	0,	4,	1197,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList27, OperandInfo82, -1 ,nullptr },  // Inst #2040 = MTM2
  { 2041,	1,	0,	4,	1197,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList28, OperandInfo82, -1 ,nullptr },  // Inst #2041 = MTP0
  { 2042,	1,	0,	4,	1197,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList29, OperandInfo82, -1 ,nullptr },  // Inst #2042 = MTP1
  { 2043,	1,	0,	4,	1197,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, ImplicitList30, OperandInfo82, -1 ,nullptr },  // Inst #2043 = MTP2
  { 2044,	5,	1,	4,	1056,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2044 = MTTR
  { 2045,	3,	1,	4,	861,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2045 = MUH
  { 2046,	3,	1,	4,	862,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2046 = MUHU
  { 2047,	3,	1,	4,	884,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2047 = MUHU_MMR6
  { 2048,	3,	1,	4,	885,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2048 = MUH_MMR6
  { 2049,	3,	1,	4,	481,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, ImplicitList6, OperandInfo59, -1 ,nullptr },  // Inst #2049 = MUL
  { 2050,	3,	1,	4,	1391,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo198, -1 ,nullptr },  // Inst #2050 = MULEQ_S_W_PHL
  { 2051,	3,	1,	4,	1557,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo198, -1 ,nullptr },  // Inst #2051 = MULEQ_S_W_PHL_MM
  { 2052,	3,	1,	4,	1392,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo198, -1 ,nullptr },  // Inst #2052 = MULEQ_S_W_PHR
  { 2053,	3,	1,	4,	1558,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo198, -1 ,nullptr },  // Inst #2053 = MULEQ_S_W_PHR_MM
  { 2054,	3,	1,	4,	1393,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2054 = MULEU_S_PH_QBL
  { 2055,	3,	1,	4,	1559,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2055 = MULEU_S_PH_QBL_MM
  { 2056,	3,	1,	4,	1394,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2056 = MULEU_S_PH_QBR
  { 2057,	3,	1,	4,	1560,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2057 = MULEU_S_PH_QBR_MM
  { 2058,	3,	1,	4,	1395,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2058 = MULQ_RS_PH
  { 2059,	3,	1,	4,	1561,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2059 = MULQ_RS_PH_MM
  { 2060,	3,	1,	4,	1472,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo59, -1 ,nullptr },  // Inst #2060 = MULQ_RS_W
  { 2061,	3,	1,	4,	1636,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo59, -1 ,nullptr },  // Inst #2061 = MULQ_RS_W_MMR2
  { 2062,	3,	1,	4,	1473,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2062 = MULQ_S_PH
  { 2063,	3,	1,	4,	1637,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2063 = MULQ_S_PH_MMR2
  { 2064,	3,	1,	4,	1474,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo59, -1 ,nullptr },  // Inst #2064 = MULQ_S_W
  { 2065,	3,	1,	4,	1638,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo59, -1 ,nullptr },  // Inst #2065 = MULQ_S_W_MMR2
  { 2066,	3,	1,	4,	667,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2066 = MULR_Q_H
  { 2067,	3,	1,	4,	667,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2067 = MULR_Q_W
  { 2068,	4,	1,	4,	1396,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #2068 = MULSAQ_S_W_PH
  { 2069,	4,	1,	4,	1562,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList13, OperandInfo227, -1 ,nullptr },  // Inst #2069 = MULSAQ_S_W_PH_MM
  { 2070,	4,	1,	4,	1475,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #2070 = MULSA_W_PH
  { 2071,	4,	1,	4,	1639,	0, 0x6ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #2071 = MULSA_W_PH_MMR2
  { 2072,	2,	0,	4,	482,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2072 = MULT
  { 2073,	3,	1,	4,	1397,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #2073 = MULTU_DSP
  { 2074,	3,	1,	4,	1563,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #2074 = MULTU_DSP_MM
  { 2075,	3,	1,	4,	1398,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #2075 = MULT_DSP
  { 2076,	3,	1,	4,	1564,	0|(1ULL<<MCID::Commutable), 0x6ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #2076 = MULT_DSP_MM
  { 2077,	2,	0,	4,	870,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2077 = MULT_MM
  { 2078,	2,	0,	4,	483,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2078 = MULTu
  { 2079,	2,	0,	4,	871,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2079 = MULTu_MM
  { 2080,	3,	1,	4,	863,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2080 = MULU
  { 2081,	3,	1,	4,	886,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2081 = MULU_MMR6
  { 2082,	3,	1,	4,	662,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2082 = MULV_B
  { 2083,	3,	1,	4,	662,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2083 = MULV_D
  { 2084,	3,	1,	4,	662,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2084 = MULV_H
  { 2085,	3,	1,	4,	662,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2085 = MULV_W
  { 2086,	3,	1,	4,	876,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, ImplicitList6, OperandInfo59, -1 ,nullptr },  // Inst #2086 = MUL_MM
  { 2087,	3,	1,	4,	887,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2087 = MUL_MMR6
  { 2088,	3,	1,	4,	1470,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2088 = MUL_PH
  { 2089,	3,	1,	4,	1634,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2089 = MUL_PH_MMR2
  { 2090,	3,	1,	4,	668,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2090 = MUL_Q_H
  { 2091,	3,	1,	4,	668,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2091 = MUL_Q_W
  { 2092,	3,	1,	4,	864,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2092 = MUL_R6
  { 2093,	3,	1,	4,	1471,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2093 = MUL_S_PH
  { 2094,	3,	1,	4,	1635,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList31, OperandInfo157, -1 ,nullptr },  // Inst #2094 = MUL_S_PH_MMR2
  { 2095,	1,	1,	2,	727,	0|(1ULL<<MCID::MoveReg), 0x0ULL, ImplicitList21, nullptr, OperandInfo257, -1 ,nullptr },  // Inst #2095 = Mfhi16
  { 2096,	1,	1,	2,	727,	0, 0x0ULL, ImplicitList23, nullptr, OperandInfo257, -1 ,nullptr },  // Inst #2096 = Mflo16
  { 2097,	2,	1,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo316, -1 ,nullptr },  // Inst #2097 = Move32R16
  { 2098,	2,	1,	2,	727,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo317, -1 ,nullptr },  // Inst #2098 = MoveR3216
  { 2099,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo295, -1 ,nullptr },  // Inst #2099 = NLOC_B
  { 2100,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #2100 = NLOC_D
  { 2101,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo318, -1 ,nullptr },  // Inst #2101 = NLOC_H
  { 2102,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #2102 = NLOC_W
  { 2103,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo295, -1 ,nullptr },  // Inst #2103 = NLZC_B
  { 2104,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #2104 = NLZC_D
  { 2105,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo318, -1 ,nullptr },  // Inst #2105 = NLZC_H
  { 2106,	2,	1,	4,	622,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #2106 = NLZC_W
  { 2107,	4,	1,	4,	673,	0, 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2107 = NMADD_D32
  { 2108,	4,	1,	4,	1238,	0, 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2108 = NMADD_D32_MM
  { 2109,	4,	1,	4,	673,	0, 0x4ULL, nullptr, nullptr, OperandInfo288, -1 ,nullptr },  // Inst #2109 = NMADD_D64
  { 2110,	4,	1,	4,	674,	0, 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2110 = NMADD_S
  { 2111,	4,	1,	4,	1237,	0, 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2111 = NMADD_S_MM
  { 2112,	4,	1,	4,	675,	0, 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2112 = NMSUB_D32
  { 2113,	4,	1,	4,	1240,	0, 0x4ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2113 = NMSUB_D32_MM
  { 2114,	4,	1,	4,	675,	0, 0x4ULL, nullptr, nullptr, OperandInfo288, -1 ,nullptr },  // Inst #2114 = NMSUB_D64
  { 2115,	4,	1,	4,	676,	0, 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2115 = NMSUB_S
  { 2116,	4,	1,	4,	1239,	0, 0x4ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2116 = NMSUB_S_MM
  { 2117,	3,	1,	4,	361,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2117 = NOR
  { 2118,	3,	1,	4,	834,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2118 = NOR64
  { 2119,	3,	1,	4,	544,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2119 = NORI_B
  { 2120,	3,	1,	4,	744,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2120 = NOR_MM
  { 2121,	3,	1,	4,	785,	0|(1ULL<<MCID::Commutable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2121 = NOR_MMR6
  { 2122,	3,	1,	4,	543,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2122 = NOR_V
  { 2123,	2,	1,	2,	745,	0, 0x0ULL, nullptr, nullptr, OperandInfo319, -1 ,nullptr },  // Inst #2123 = NOT16_MM
  { 2124,	2,	1,	2,	786,	0, 0x0ULL, nullptr, nullptr, OperandInfo319, -1 ,nullptr },  // Inst #2124 = NOT16_MMR6
  { 2125,	2,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo115, -1 ,nullptr },  // Inst #2125 = NegRxRy16
  { 2126,	2,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo115, -1 ,nullptr },  // Inst #2126 = NotRxRy16
  { 2127,	3,	1,	4,	362,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2127 = OR
  { 2128,	3,	1,	2,	746,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #2128 = OR16_MM
  { 2129,	3,	1,	2,	787,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #2129 = OR16_MMR6
  { 2130,	3,	1,	4,	835,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2130 = OR64
  { 2131,	3,	1,	4,	544,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2131 = ORI_B
  { 2132,	3,	1,	4,	788,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2132 = ORI_MMR6
  { 2133,	3,	1,	4,	746,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2133 = OR_MM
  { 2134,	3,	1,	4,	787,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2134 = OR_MMR6
  { 2135,	3,	1,	4,	543,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2135 = OR_V
  { 2136,	3,	1,	4,	495,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2136 = ORi
  { 2137,	3,	1,	4,	801,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #2137 = ORi64
  { 2138,	3,	1,	4,	747,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2138 = ORi_MM
  { 2139,	3,	1,	2,	727,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #2139 = OrRxRxRy16
  { 2140,	3,	1,	4,	1399,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2140 = PACKRL_PH
  { 2141,	3,	1,	4,	1565,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2141 = PACKRL_PH_MM
  { 2142,	0,	0,	4,	400,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2142 = PAUSE
  { 2143,	0,	0,	4,	1026,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2143 = PAUSE_MM
  { 2144,	0,	0,	4,	1043,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2144 = PAUSE_MMR6
  { 2145,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2145 = PCKEV_B
  { 2146,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2146 = PCKEV_D
  { 2147,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2147 = PCKEV_H
  { 2148,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2148 = PCKEV_W
  { 2149,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2149 = PCKOD_B
  { 2150,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2150 = PCKOD_D
  { 2151,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2151 = PCKOD_H
  { 2152,	3,	1,	4,	621,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2152 = PCKOD_W
  { 2153,	2,	1,	4,	521,	0, 0x6ULL, nullptr, nullptr, OperandInfo295, -1 ,nullptr },  // Inst #2153 = PCNT_B
  { 2154,	2,	1,	4,	521,	0, 0x6ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #2154 = PCNT_D
  { 2155,	2,	1,	4,	521,	0, 0x6ULL, nullptr, nullptr, OperandInfo318, -1 ,nullptr },  // Inst #2155 = PCNT_H
  { 2156,	2,	1,	4,	521,	0, 0x6ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #2156 = PCNT_W
  { 2157,	3,	1,	4,	1400,	0|(1ULL<<MCID::MayLoad), 0x6ULL, ImplicitList10, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2157 = PICK_PH
  { 2158,	3,	1,	4,	1566,	0|(1ULL<<MCID::MayLoad), 0x6ULL, ImplicitList10, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2158 = PICK_PH_MM
  { 2159,	3,	1,	4,	1401,	0|(1ULL<<MCID::MayLoad), 0x6ULL, ImplicitList10, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2159 = PICK_QB
  { 2160,	3,	1,	4,	1567,	0|(1ULL<<MCID::MayLoad), 0x6ULL, ImplicitList10, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2160 = PICK_QB_MM
  { 2161,	3,	1,	4,	637,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #2161 = PLL_PS64
  { 2162,	3,	1,	4,	637,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x4ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #2162 = PLU_PS64
  { 2163,	2,	1,	4,	1195,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2163 = POP
  { 2164,	2,	1,	4,	1403,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2164 = PRECEQU_PH_QBL
  { 2165,	2,	1,	4,	1402,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2165 = PRECEQU_PH_QBLA
  { 2166,	2,	1,	4,	1568,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2166 = PRECEQU_PH_QBLA_MM
  { 2167,	2,	1,	4,	1569,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2167 = PRECEQU_PH_QBL_MM
  { 2168,	2,	1,	4,	1405,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2168 = PRECEQU_PH_QBR
  { 2169,	2,	1,	4,	1404,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2169 = PRECEQU_PH_QBRA
  { 2170,	2,	1,	4,	1570,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2170 = PRECEQU_PH_QBRA_MM
  { 2171,	2,	1,	4,	1571,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2171 = PRECEQU_PH_QBR_MM
  { 2172,	2,	1,	4,	1406,	0, 0x6ULL, nullptr, nullptr, OperandInfo320, -1 ,nullptr },  // Inst #2172 = PRECEQ_W_PHL
  { 2173,	2,	1,	4,	1572,	0, 0x6ULL, nullptr, nullptr, OperandInfo320, -1 ,nullptr },  // Inst #2173 = PRECEQ_W_PHL_MM
  { 2174,	2,	1,	4,	1407,	0, 0x6ULL, nullptr, nullptr, OperandInfo320, -1 ,nullptr },  // Inst #2174 = PRECEQ_W_PHR
  { 2175,	2,	1,	4,	1573,	0, 0x6ULL, nullptr, nullptr, OperandInfo320, -1 ,nullptr },  // Inst #2175 = PRECEQ_W_PHR_MM
  { 2176,	2,	1,	4,	1409,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2176 = PRECEU_PH_QBL
  { 2177,	2,	1,	4,	1408,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2177 = PRECEU_PH_QBLA
  { 2178,	2,	1,	4,	1574,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2178 = PRECEU_PH_QBLA_MM
  { 2179,	2,	1,	4,	1575,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2179 = PRECEU_PH_QBL_MM
  { 2180,	2,	1,	4,	1411,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2180 = PRECEU_PH_QBR
  { 2181,	2,	1,	4,	1410,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2181 = PRECEU_PH_QBRA
  { 2182,	2,	1,	4,	1576,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2182 = PRECEU_PH_QBRA_MM
  { 2183,	2,	1,	4,	1577,	0, 0x6ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #2183 = PRECEU_PH_QBR_MM
  { 2184,	3,	1,	4,	1412,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo157, -1 ,nullptr },  // Inst #2184 = PRECRQU_S_QB_PH
  { 2185,	3,	1,	4,	1578,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo157, -1 ,nullptr },  // Inst #2185 = PRECRQU_S_QB_PH_MM
  { 2186,	3,	1,	4,	1413,	0, 0x6ULL, nullptr, nullptr, OperandInfo321, -1 ,nullptr },  // Inst #2186 = PRECRQ_PH_W
  { 2187,	3,	1,	4,	1579,	0, 0x6ULL, nullptr, nullptr, OperandInfo321, -1 ,nullptr },  // Inst #2187 = PRECRQ_PH_W_MM
  { 2188,	3,	1,	4,	1414,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2188 = PRECRQ_QB_PH
  { 2189,	3,	1,	4,	1580,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2189 = PRECRQ_QB_PH_MM
  { 2190,	3,	1,	4,	1415,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo321, -1 ,nullptr },  // Inst #2190 = PRECRQ_RS_PH_W
  { 2191,	3,	1,	4,	1581,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo321, -1 ,nullptr },  // Inst #2191 = PRECRQ_RS_PH_W_MM
  { 2192,	3,	1,	4,	1476,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2192 = PRECR_QB_PH
  { 2193,	3,	1,	4,	1640,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2193 = PRECR_QB_PH_MMR2
  { 2194,	4,	1,	4,	1477,	0, 0x6ULL, nullptr, nullptr, OperandInfo322, -1 ,nullptr },  // Inst #2194 = PRECR_SRA_PH_W
  { 2195,	4,	1,	4,	1641,	0, 0x6ULL, nullptr, nullptr, OperandInfo322, -1 ,nullptr },  // Inst #2195 = PRECR_SRA_PH_W_MMR2
  { 2196,	4,	1,	4,	1478,	0, 0x6ULL, nullptr, nullptr, OperandInfo322, -1 ,nullptr },  // Inst #2196 = PRECR_SRA_R_PH_W
  { 2197,	4,	1,	4,	1642,	0, 0x6ULL, nullptr, nullptr, OperandInfo322, -1 ,nullptr },  // Inst #2197 = PRECR_SRA_R_PH_W_MMR2
  { 2198,	3,	0,	4,	463,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #2198 = PREF
  { 2199,	3,	0,	4,	464,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #2199 = PREFE
  { 2200,	3,	0,	4,	1098,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #2200 = PREFE_MM
  { 2201,	3,	0,	4,	1131,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo323, -1 ,nullptr },  // Inst #2201 = PREFX_MM
  { 2202,	3,	0,	4,	1131,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #2202 = PREF_MM
  { 2203,	3,	0,	4,	1153,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #2203 = PREF_MMR6
  { 2204,	3,	0,	4,	1079,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #2204 = PREF_R6
  { 2205,	4,	1,	4,	1479,	0, 0x6ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #2205 = PREPEND
  { 2206,	4,	1,	4,	1643,	0, 0x6ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #2206 = PREPEND_MMR2
  { 2207,	2,	1,	4,	1416,	0, 0x6ULL, nullptr, nullptr, OperandInfo320, -1 ,nullptr },  // Inst #2207 = RADDU_W_QB
  { 2208,	2,	1,	4,	1582,	0, 0x6ULL, nullptr, nullptr, OperandInfo320, -1 ,nullptr },  // Inst #2208 = RADDU_W_QB_MM
  { 2209,	2,	1,	4,	1417,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2209 = RDDSP
  { 2210,	2,	1,	4,	1583,	0|(1ULL<<MCID::MayLoad), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2210 = RDDSP_MM
  { 2211,	3,	1,	4,	475,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo324, -1 ,nullptr },  // Inst #2211 = RDHWR
  { 2212,	3,	1,	4,	901,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo325, -1 ,nullptr },  // Inst #2212 = RDHWR64
  { 2213,	3,	1,	4,	883,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo324, -1 ,nullptr },  // Inst #2213 = RDHWR_MM
  { 2214,	3,	1,	4,	892,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo324, -1 ,nullptr },  // Inst #2214 = RDHWR_MMR6
  { 2215,	2,	1,	4,	1028,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2215 = RDPGPR_MMR6
  { 2216,	2,	1,	4,	644,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #2216 = RECIP_D32
  { 2217,	2,	1,	4,	1277,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #2217 = RECIP_D32_MM
  { 2218,	2,	1,	4,	644,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2218 = RECIP_D64
  { 2219,	2,	1,	4,	1277,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2219 = RECIP_D64_MM
  { 2220,	2,	1,	4,	646,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2220 = RECIP_S
  { 2221,	2,	1,	4,	1276,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2221 = RECIP_S_MM
  { 2222,	2,	1,	4,	1418,	0, 0x6ULL, nullptr, nullptr, OperandInfo326, -1 ,nullptr },  // Inst #2222 = REPLV_PH
  { 2223,	2,	1,	4,	1584,	0, 0x6ULL, nullptr, nullptr, OperandInfo326, -1 ,nullptr },  // Inst #2223 = REPLV_PH_MM
  { 2224,	2,	1,	4,	1419,	0, 0x6ULL, nullptr, nullptr, OperandInfo326, -1 ,nullptr },  // Inst #2224 = REPLV_QB
  { 2225,	2,	1,	4,	1585,	0, 0x6ULL, nullptr, nullptr, OperandInfo326, -1 ,nullptr },  // Inst #2225 = REPLV_QB_MM
  { 2226,	2,	1,	4,	1420,	0, 0x6ULL, nullptr, nullptr, OperandInfo327, -1 ,nullptr },  // Inst #2226 = REPL_PH
  { 2227,	2,	1,	4,	1586,	0, 0x6ULL, nullptr, nullptr, OperandInfo327, -1 ,nullptr },  // Inst #2227 = REPL_PH_MM
  { 2228,	2,	1,	4,	1421,	0, 0x6ULL, nullptr, nullptr, OperandInfo327, -1 ,nullptr },  // Inst #2228 = REPL_QB
  { 2229,	2,	1,	4,	1587,	0, 0x6ULL, nullptr, nullptr, OperandInfo327, -1 ,nullptr },  // Inst #2229 = REPL_QB_MM
  { 2230,	2,	1,	4,	1218,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2230 = RINT_D
  { 2231,	2,	1,	4,	1316,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2231 = RINT_D_MMR6
  { 2232,	2,	1,	4,	1217,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2232 = RINT_S
  { 2233,	2,	1,	4,	1316,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2233 = RINT_S_MMR6
  { 2234,	3,	1,	4,	496,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2234 = ROTR
  { 2235,	3,	1,	4,	712,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2235 = ROTRV
  { 2236,	3,	1,	4,	748,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2236 = ROTRV_MM
  { 2237,	3,	1,	4,	749,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2237 = ROTR_MM
  { 2238,	2,	1,	4,	711,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2238 = ROUND_L_D64
  { 2239,	2,	1,	4,	1297,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2239 = ROUND_L_D_MMR6
  { 2240,	2,	1,	4,	711,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #2240 = ROUND_L_S
  { 2241,	2,	1,	4,	1297,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #2241 = ROUND_L_S_MMR6
  { 2242,	2,	1,	4,	711,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #2242 = ROUND_W_D32
  { 2243,	2,	1,	4,	711,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #2243 = ROUND_W_D64
  { 2244,	2,	1,	4,	1297,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2244 = ROUND_W_D_MMR6
  { 2245,	2,	1,	4,	1243,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #2245 = ROUND_W_MM
  { 2246,	2,	1,	4,	711,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2246 = ROUND_W_S
  { 2247,	2,	1,	4,	1243,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2247 = ROUND_W_S_MM
  { 2248,	2,	1,	4,	1297,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2248 = ROUND_W_S_MMR6
  { 2249,	2,	1,	4,	645,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #2249 = RSQRT_D32
  { 2250,	2,	1,	4,	1277,	0, 0x4ULL, nullptr, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #2250 = RSQRT_D32_MM
  { 2251,	2,	1,	4,	645,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2251 = RSQRT_D64
  { 2252,	2,	1,	4,	1277,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2252 = RSQRT_D64_MM
  { 2253,	2,	1,	4,	647,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2253 = RSQRT_S
  { 2254,	2,	1,	4,	1276,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2254 = RSQRT_S_MM
  { 2255,	0,	0,	2,	1100,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #2255 = Restore16
  { 2256,	0,	0,	2,	1100,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #2256 = RestoreX16
  { 2257,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2257 = SAT_S_B
  { 2258,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2258 = SAT_S_D
  { 2259,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2259 = SAT_S_H
  { 2260,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2260 = SAT_S_W
  { 2261,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2261 = SAT_U_B
  { 2262,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2262 = SAT_U_D
  { 2263,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2263 = SAT_U_H
  { 2264,	3,	1,	4,	522,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2264 = SAT_U_W
  { 2265,	3,	0,	4,	447,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2265 = SB
  { 2266,	3,	0,	2,	1122,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo328, -1 ,nullptr },  // Inst #2266 = SB16_MM
  { 2267,	3,	0,	2,	1145,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo328, -1 ,nullptr },  // Inst #2267 = SB16_MMR6
  { 2268,	3,	0,	4,	1169,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2268 = SB64
  { 2269,	3,	0,	4,	455,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2269 = SBE
  { 2270,	3,	0,	4,	1091,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2270 = SBE_MM
  { 2271,	3,	0,	4,	1092,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2271 = SB_MM
  { 2272,	3,	0,	4,	1145,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2272 = SB_MMR6
  { 2273,	4,	1,	4,	454,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2273 = SC
  { 2274,	4,	1,	4,	1168,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2274 = SC64
  { 2275,	4,	1,	4,	1180,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2275 = SC64_R6
  { 2276,	4,	1,	4,	1168,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo330, -1 ,nullptr },  // Inst #2276 = SCD
  { 2277,	4,	1,	4,	1181,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo330, -1 ,nullptr },  // Inst #2277 = SCD_R6
  { 2278,	4,	1,	4,	458,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2278 = SCE
  { 2279,	4,	1,	4,	1097,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2279 = SCE_MM
  { 2280,	4,	1,	4,	1123,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2280 = SC_MM
  { 2281,	4,	1,	4,	1072,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2281 = SC_MMR6
  { 2282,	4,	1,	4,	1078,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo329, -1 ,nullptr },  // Inst #2282 = SC_R6
  { 2283,	3,	0,	4,	1167,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2283 = SD
  { 2284,	1,	0,	4,	384,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2284 = SDBBP
  { 2285,	1,	0,	2,	959,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2285 = SDBBP16_MM
  { 2286,	1,	0,	2,	1000,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2286 = SDBBP16_MMR6
  { 2287,	1,	0,	4,	959,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2287 = SDBBP_MM
  { 2288,	1,	0,	4,	1000,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2288 = SDBBP_MMR6
  { 2289,	1,	0,	4,	930,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2289 = SDBBP_R6
  { 2290,	3,	0,	4,	691,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #2290 = SDC1
  { 2291,	3,	0,	4,	691,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #2291 = SDC164
  { 2292,	3,	0,	4,	1326,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #2292 = SDC1_D64_MMR6
  { 2293,	3,	0,	4,	1278,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #2293 = SDC1_MM
  { 2294,	3,	0,	4,	452,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #2294 = SDC2
  { 2295,	3,	0,	4,	1146,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo262, -1 ,nullptr },  // Inst #2295 = SDC2_MMR6
  { 2296,	3,	0,	4,	1077,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #2296 = SDC2_R6
  { 2297,	3,	0,	4,	453,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #2297 = SDC3
  { 2298,	2,	0,	4,	857,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2298 = SDIV
  { 2299,	2,	0,	4,	877,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2299 = SDIV_MM
  { 2300,	3,	0,	4,	1174,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2300 = SDL
  { 2301,	3,	0,	4,	1175,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2301 = SDR
  { 2302,	3,	0,	4,	692,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #2302 = SDXC1
  { 2303,	3,	0,	4,	692,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2303 = SDXC164
  { 2304,	2,	1,	4,	497,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2304 = SEB
  { 2305,	2,	1,	4,	802,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #2305 = SEB64
  { 2306,	2,	1,	4,	750,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2306 = SEB_MM
  { 2307,	2,	1,	4,	498,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2307 = SEH
  { 2308,	2,	1,	4,	803,	0, 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #2308 = SEH64
  { 2309,	2,	1,	4,	751,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2309 = SEH_MM
  { 2310,	3,	1,	4,	726,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2310 = SELEQZ
  { 2311,	3,	1,	4,	844,	0, 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2311 = SELEQZ64
  { 2312,	3,	1,	4,	1210,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #2312 = SELEQZ_D
  { 2313,	3,	1,	4,	1312,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #2313 = SELEQZ_D_MMR6
  { 2314,	3,	1,	4,	789,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2314 = SELEQZ_MMR6
  { 2315,	3,	1,	4,	1209,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #2315 = SELEQZ_S
  { 2316,	3,	1,	4,	1313,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #2316 = SELEQZ_S_MMR6
  { 2317,	3,	1,	4,	726,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2317 = SELNEZ
  { 2318,	3,	1,	4,	844,	0, 0x6ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2318 = SELNEZ64
  { 2319,	3,	1,	4,	1210,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #2319 = SELNEZ_D
  { 2320,	3,	1,	4,	1312,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #2320 = SELNEZ_D_MMR6
  { 2321,	3,	1,	4,	789,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2321 = SELNEZ_MMR6
  { 2322,	3,	1,	4,	1209,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #2322 = SELNEZ_S
  { 2323,	3,	1,	4,	1313,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #2323 = SELNEZ_S_MMR6
  { 2324,	4,	1,	4,	1220,	0, 0x6ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2324 = SEL_D
  { 2325,	4,	1,	4,	1314,	0, 0x6ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2325 = SEL_D_MMR6
  { 2326,	4,	1,	4,	1221,	0, 0x6ULL, nullptr, nullptr, OperandInfo331, -1 ,nullptr },  // Inst #2326 = SEL_S
  { 2327,	4,	1,	4,	1315,	0, 0x6ULL, nullptr, nullptr, OperandInfo331, -1 ,nullptr },  // Inst #2327 = SEL_S_MMR6
  { 2328,	3,	1,	4,	1198,	0, 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2328 = SEQ
  { 2329,	3,	1,	4,	1199,	0, 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #2329 = SEQi
  { 2330,	3,	0,	4,	448,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2330 = SH
  { 2331,	3,	0,	2,	1124,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo328, -1 ,nullptr },  // Inst #2331 = SH16_MM
  { 2332,	3,	0,	2,	1147,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo328, -1 ,nullptr },  // Inst #2332 = SH16_MMR6
  { 2333,	3,	0,	4,	1170,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2333 = SH64
  { 2334,	3,	0,	4,	456,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2334 = SHE
  { 2335,	3,	0,	4,	1093,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2335 = SHE_MM
  { 2336,	3,	1,	4,	538,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2336 = SHF_B
  { 2337,	3,	1,	4,	538,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2337 = SHF_H
  { 2338,	3,	1,	4,	538,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2338 = SHF_W
  { 2339,	3,	1,	4,	1423,	0, 0x6ULL, nullptr, nullptr, OperandInfo332, -1 ,nullptr },  // Inst #2339 = SHILO
  { 2340,	3,	1,	4,	1422,	0, 0x6ULL, nullptr, nullptr, OperandInfo314, -1 ,nullptr },  // Inst #2340 = SHILOV
  { 2341,	3,	1,	4,	1588,	0, 0x6ULL, nullptr, nullptr, OperandInfo314, -1 ,nullptr },  // Inst #2341 = SHILOV_MM
  { 2342,	3,	1,	4,	1589,	0, 0x6ULL, nullptr, nullptr, OperandInfo332, -1 ,nullptr },  // Inst #2342 = SHILO_MM
  { 2343,	3,	1,	4,	1424,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo333, -1 ,nullptr },  // Inst #2343 = SHLLV_PH
  { 2344,	3,	1,	4,	1590,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo333, -1 ,nullptr },  // Inst #2344 = SHLLV_PH_MM
  { 2345,	3,	1,	4,	1425,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo333, -1 ,nullptr },  // Inst #2345 = SHLLV_QB
  { 2346,	3,	1,	4,	1591,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo333, -1 ,nullptr },  // Inst #2346 = SHLLV_QB_MM
  { 2347,	3,	1,	4,	1426,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo333, -1 ,nullptr },  // Inst #2347 = SHLLV_S_PH
  { 2348,	3,	1,	4,	1592,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo333, -1 ,nullptr },  // Inst #2348 = SHLLV_S_PH_MM
  { 2349,	3,	1,	4,	1427,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo59, -1 ,nullptr },  // Inst #2349 = SHLLV_S_W
  { 2350,	3,	1,	4,	1593,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo59, -1 ,nullptr },  // Inst #2350 = SHLLV_S_W_MM
  { 2351,	3,	1,	4,	1428,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo334, -1 ,nullptr },  // Inst #2351 = SHLL_PH
  { 2352,	3,	1,	4,	1594,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo334, -1 ,nullptr },  // Inst #2352 = SHLL_PH_MM
  { 2353,	3,	1,	4,	1429,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo334, -1 ,nullptr },  // Inst #2353 = SHLL_QB
  { 2354,	3,	1,	4,	1595,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo334, -1 ,nullptr },  // Inst #2354 = SHLL_QB_MM
  { 2355,	3,	1,	4,	1430,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo334, -1 ,nullptr },  // Inst #2355 = SHLL_S_PH
  { 2356,	3,	1,	4,	1596,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo334, -1 ,nullptr },  // Inst #2356 = SHLL_S_PH_MM
  { 2357,	3,	1,	4,	1431,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo60, -1 ,nullptr },  // Inst #2357 = SHLL_S_W
  { 2358,	3,	1,	4,	1597,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList32, OperandInfo60, -1 ,nullptr },  // Inst #2358 = SHLL_S_W_MM
  { 2359,	3,	1,	4,	1432,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2359 = SHRAV_PH
  { 2360,	3,	1,	4,	1598,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2360 = SHRAV_PH_MM
  { 2361,	3,	1,	4,	1482,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2361 = SHRAV_QB
  { 2362,	3,	1,	4,	1646,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2362 = SHRAV_QB_MMR2
  { 2363,	3,	1,	4,	1433,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2363 = SHRAV_R_PH
  { 2364,	3,	1,	4,	1599,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2364 = SHRAV_R_PH_MM
  { 2365,	3,	1,	4,	1483,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2365 = SHRAV_R_QB
  { 2366,	3,	1,	4,	1647,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2366 = SHRAV_R_QB_MMR2
  { 2367,	3,	1,	4,	1434,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2367 = SHRAV_R_W
  { 2368,	3,	1,	4,	1600,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2368 = SHRAV_R_W_MM
  { 2369,	3,	1,	4,	1435,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2369 = SHRA_PH
  { 2370,	3,	1,	4,	1601,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2370 = SHRA_PH_MM
  { 2371,	3,	1,	4,	1480,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2371 = SHRA_QB
  { 2372,	3,	1,	4,	1644,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2372 = SHRA_QB_MMR2
  { 2373,	3,	1,	4,	1436,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2373 = SHRA_R_PH
  { 2374,	3,	1,	4,	1602,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2374 = SHRA_R_PH_MM
  { 2375,	3,	1,	4,	1481,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2375 = SHRA_R_QB
  { 2376,	3,	1,	4,	1645,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2376 = SHRA_R_QB_MMR2
  { 2377,	3,	1,	4,	1437,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2377 = SHRA_R_W
  { 2378,	3,	1,	4,	1603,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2378 = SHRA_R_W_MM
  { 2379,	3,	1,	4,	1485,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2379 = SHRLV_PH
  { 2380,	3,	1,	4,	1649,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2380 = SHRLV_PH_MMR2
  { 2381,	3,	1,	4,	1438,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2381 = SHRLV_QB
  { 2382,	3,	1,	4,	1604,	0, 0x6ULL, nullptr, nullptr, OperandInfo333, -1 ,nullptr },  // Inst #2382 = SHRLV_QB_MM
  { 2383,	3,	1,	4,	1484,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2383 = SHRL_PH
  { 2384,	3,	1,	4,	1648,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2384 = SHRL_PH_MMR2
  { 2385,	3,	1,	4,	1439,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2385 = SHRL_QB
  { 2386,	3,	1,	4,	1605,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo334, -1 ,nullptr },  // Inst #2386 = SHRL_QB_MM
  { 2387,	3,	0,	4,	1124,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2387 = SH_MM
  { 2388,	3,	0,	4,	1147,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2388 = SH_MMR6
  { 2389,	1,	0,	4,	927,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2389 = SIGRIE
  { 2390,	1,	0,	4,	988,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2390 = SIGRIE_MMR6
  { 2391,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #2391 = SLDI_B
  { 2392,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo177, -1 ,nullptr },  // Inst #2392 = SLDI_D
  { 2393,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo178, -1 ,nullptr },  // Inst #2393 = SLDI_H
  { 2394,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo179, -1 ,nullptr },  // Inst #2394 = SLDI_W
  { 2395,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo335, -1 ,nullptr },  // Inst #2395 = SLD_B
  { 2396,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo336, -1 ,nullptr },  // Inst #2396 = SLD_D
  { 2397,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo337, -1 ,nullptr },  // Inst #2397 = SLD_H
  { 2398,	4,	1,	4,	514,	0, 0x6ULL, nullptr, nullptr, OperandInfo338, -1 ,nullptr },  // Inst #2398 = SLD_W
  { 2399,	3,	1,	4,	500,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2399 = SLL
  { 2400,	3,	1,	2,	752,	0, 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #2400 = SLL16_MM
  { 2401,	3,	1,	2,	790,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #2401 = SLL16_MMR6
  { 2402,	2,	1,	4,	804,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, nullptr, OperandInfo229, -1 ,nullptr },  // Inst #2402 = SLL64_32
  { 2403,	2,	1,	4,	804,	0|(1ULL<<MCID::MoveReg), 0x1ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #2403 = SLL64_64
  { 2404,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2404 = SLLI_B
  { 2405,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2405 = SLLI_D
  { 2406,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2406 = SLLI_H
  { 2407,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2407 = SLLI_W
  { 2408,	3,	1,	4,	505,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2408 = SLLV
  { 2409,	3,	1,	4,	753,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2409 = SLLV_MM
  { 2410,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2410 = SLL_B
  { 2411,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2411 = SLL_D
  { 2412,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2412 = SLL_H
  { 2413,	3,	1,	4,	752,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2413 = SLL_MM
  { 2414,	3,	1,	4,	790,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2414 = SLL_MMR6
  { 2415,	3,	1,	4,	620,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2415 = SLL_W
  { 2416,	3,	1,	4,	499,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2416 = SLT
  { 2417,	3,	1,	4,	805,	0, 0x1ULL, nullptr, nullptr, OperandInfo339, -1 ,nullptr },  // Inst #2417 = SLT64
  { 2418,	3,	1,	4,	754,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2418 = SLT_MM
  { 2419,	3,	1,	4,	363,	0, 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2419 = SLTi
  { 2420,	3,	1,	4,	806,	0, 0x2ULL, nullptr, nullptr, OperandInfo340, -1 ,nullptr },  // Inst #2420 = SLTi64
  { 2421,	3,	1,	4,	755,	0, 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2421 = SLTi_MM
  { 2422,	3,	1,	4,	363,	0, 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2422 = SLTiu
  { 2423,	3,	1,	4,	806,	0, 0x2ULL, nullptr, nullptr, OperandInfo340, -1 ,nullptr },  // Inst #2423 = SLTiu64
  { 2424,	3,	1,	4,	755,	0, 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2424 = SLTiu_MM
  { 2425,	3,	1,	4,	499,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2425 = SLTu
  { 2426,	3,	1,	4,	805,	0, 0x1ULL, nullptr, nullptr, OperandInfo339, -1 ,nullptr },  // Inst #2426 = SLTu64
  { 2427,	3,	1,	4,	754,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2427 = SLTu_MM
  { 2428,	3,	1,	4,	1198,	0, 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2428 = SNE
  { 2429,	3,	1,	4,	1199,	0, 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #2429 = SNEi
  { 2430,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2430 = SPLATI_B
  { 2431,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2431 = SPLATI_D
  { 2432,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2432 = SPLATI_H
  { 2433,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2433 = SPLATI_W
  { 2434,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo341, -1 ,nullptr },  // Inst #2434 = SPLAT_B
  { 2435,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo342, -1 ,nullptr },  // Inst #2435 = SPLAT_D
  { 2436,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo343, -1 ,nullptr },  // Inst #2436 = SPLAT_H
  { 2437,	3,	1,	4,	540,	0, 0x6ULL, nullptr, nullptr, OperandInfo344, -1 ,nullptr },  // Inst #2437 = SPLAT_W
  { 2438,	3,	1,	4,	501,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2438 = SRA
  { 2439,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2439 = SRAI_B
  { 2440,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2440 = SRAI_D
  { 2441,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2441 = SRAI_H
  { 2442,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2442 = SRAI_W
  { 2443,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2443 = SRARI_B
  { 2444,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2444 = SRARI_D
  { 2445,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2445 = SRARI_H
  { 2446,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2446 = SRARI_W
  { 2447,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2447 = SRAR_B
  { 2448,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2448 = SRAR_D
  { 2449,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2449 = SRAR_H
  { 2450,	3,	1,	4,	618,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2450 = SRAR_W
  { 2451,	3,	1,	4,	506,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2451 = SRAV
  { 2452,	3,	1,	4,	756,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2452 = SRAV_MM
  { 2453,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2453 = SRA_B
  { 2454,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2454 = SRA_D
  { 2455,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2455 = SRA_H
  { 2456,	3,	1,	4,	757,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2456 = SRA_MM
  { 2457,	3,	1,	4,	616,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2457 = SRA_W
  { 2458,	3,	1,	4,	502,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2458 = SRL
  { 2459,	3,	1,	2,	758,	0, 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #2459 = SRL16_MM
  { 2460,	3,	1,	2,	791,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #2460 = SRL16_MMR6
  { 2461,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2461 = SRLI_B
  { 2462,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2462 = SRLI_D
  { 2463,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2463 = SRLI_H
  { 2464,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2464 = SRLI_W
  { 2465,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2465 = SRLRI_B
  { 2466,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2466 = SRLRI_D
  { 2467,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2467 = SRLRI_H
  { 2468,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2468 = SRLRI_W
  { 2469,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2469 = SRLR_B
  { 2470,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2470 = SRLR_D
  { 2471,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2471 = SRLR_H
  { 2472,	3,	1,	4,	619,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2472 = SRLR_W
  { 2473,	3,	1,	4,	507,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2473 = SRLV
  { 2474,	3,	1,	4,	759,	0, 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2474 = SRLV_MM
  { 2475,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2475 = SRL_B
  { 2476,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2476 = SRL_D
  { 2477,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2477 = SRL_H
  { 2478,	3,	1,	4,	758,	0, 0x1ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2478 = SRL_MM
  { 2479,	3,	1,	4,	617,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2479 = SRL_W
  { 2480,	0,	0,	4,	367,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2480 = SSNOP
  { 2481,	0,	0,	4,	760,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2481 = SSNOP_MM
  { 2482,	0,	0,	4,	792,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2482 = SSNOP_MMR6
  { 2483,	3,	0,	4,	696,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #2483 = ST_B
  { 2484,	3,	0,	4,	696,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo272, -1 ,nullptr },  // Inst #2484 = ST_D
  { 2485,	3,	0,	4,	696,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #2485 = ST_H
  { 2486,	3,	0,	4,	696,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo274, -1 ,nullptr },  // Inst #2486 = ST_W
  { 2487,	3,	1,	4,	364,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2487 = SUB
  { 2488,	3,	1,	4,	1486,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2488 = SUBQH_PH
  { 2489,	3,	1,	4,	1650,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2489 = SUBQH_PH_MMR2
  { 2490,	3,	1,	4,	1487,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2490 = SUBQH_R_PH
  { 2491,	3,	1,	4,	1651,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2491 = SUBQH_R_PH_MMR2
  { 2492,	3,	1,	4,	1489,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2492 = SUBQH_R_W
  { 2493,	3,	1,	4,	1653,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2493 = SUBQH_R_W_MMR2
  { 2494,	3,	1,	4,	1488,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2494 = SUBQH_W
  { 2495,	3,	1,	4,	1652,	0, 0x6ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2495 = SUBQH_W_MMR2
  { 2496,	3,	1,	4,	1440,	0, 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2496 = SUBQ_PH
  { 2497,	3,	1,	4,	1606,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2497 = SUBQ_PH_MM
  { 2498,	3,	1,	4,	1441,	0, 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2498 = SUBQ_S_PH
  { 2499,	3,	1,	4,	1607,	0, 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2499 = SUBQ_S_PH_MM
  { 2500,	3,	1,	4,	1442,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo59, -1 ,nullptr },  // Inst #2500 = SUBQ_S_W
  { 2501,	3,	1,	4,	1608,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo59, -1 ,nullptr },  // Inst #2501 = SUBQ_S_W_MM
  { 2502,	3,	1,	4,	604,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2502 = SUBSUS_U_B
  { 2503,	3,	1,	4,	604,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2503 = SUBSUS_U_D
  { 2504,	3,	1,	4,	604,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2504 = SUBSUS_U_H
  { 2505,	3,	1,	4,	604,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2505 = SUBSUS_U_W
  { 2506,	3,	1,	4,	605,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2506 = SUBSUU_S_B
  { 2507,	3,	1,	4,	605,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2507 = SUBSUU_S_D
  { 2508,	3,	1,	4,	605,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2508 = SUBSUU_S_H
  { 2509,	3,	1,	4,	605,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2509 = SUBSUU_S_W
  { 2510,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2510 = SUBS_S_B
  { 2511,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2511 = SUBS_S_D
  { 2512,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2512 = SUBS_S_H
  { 2513,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2513 = SUBS_S_W
  { 2514,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2514 = SUBS_U_B
  { 2515,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2515 = SUBS_U_D
  { 2516,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2516 = SUBS_U_H
  { 2517,	3,	1,	4,	603,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2517 = SUBS_U_W
  { 2518,	3,	1,	2,	761,	0, 0x0ULL, nullptr, nullptr, OperandInfo159, -1 ,nullptr },  // Inst #2518 = SUBU16_MM
  { 2519,	3,	1,	2,	793,	0, 0x0ULL, nullptr, nullptr, OperandInfo159, -1 ,nullptr },  // Inst #2519 = SUBU16_MMR6
  { 2520,	3,	1,	4,	1492,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2520 = SUBUH_QB
  { 2521,	3,	1,	4,	1656,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2521 = SUBUH_QB_MMR2
  { 2522,	3,	1,	4,	1493,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2522 = SUBUH_R_QB
  { 2523,	3,	1,	4,	1657,	0, 0x6ULL, nullptr, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #2523 = SUBUH_R_QB_MMR2
  { 2524,	3,	1,	4,	793,	0|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2524 = SUBU_MMR6
  { 2525,	3,	1,	4,	1490,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2525 = SUBU_PH
  { 2526,	3,	1,	4,	1654,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2526 = SUBU_PH_MMR2
  { 2527,	3,	1,	4,	1443,	0, 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2527 = SUBU_QB
  { 2528,	3,	1,	4,	1609,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2528 = SUBU_QB_MM
  { 2529,	3,	1,	4,	1491,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2529 = SUBU_S_PH
  { 2530,	3,	1,	4,	1655,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2530 = SUBU_S_PH_MMR2
  { 2531,	3,	1,	4,	1444,	0, 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2531 = SUBU_S_QB
  { 2532,	3,	1,	4,	1610,	0, 0x6ULL, nullptr, ImplicitList8, OperandInfo157, -1 ,nullptr },  // Inst #2532 = SUBU_S_QB_MM
  { 2533,	3,	1,	4,	606,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2533 = SUBVI_B
  { 2534,	3,	1,	4,	606,	0, 0x6ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2534 = SUBVI_D
  { 2535,	3,	1,	4,	606,	0, 0x6ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #2535 = SUBVI_H
  { 2536,	3,	1,	4,	606,	0, 0x6ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #2536 = SUBVI_W
  { 2537,	3,	1,	4,	607,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2537 = SUBV_B
  { 2538,	3,	1,	4,	607,	0, 0x6ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #2538 = SUBV_D
  { 2539,	3,	1,	4,	607,	0, 0x6ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #2539 = SUBV_H
  { 2540,	3,	1,	4,	607,	0, 0x6ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #2540 = SUBV_W
  { 2541,	3,	1,	4,	762,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2541 = SUB_MM
  { 2542,	3,	1,	4,	794,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2542 = SUB_MMR6
  { 2543,	3,	1,	4,	365,	0|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2543 = SUBu
  { 2544,	3,	1,	4,	761,	0|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2544 = SUBu_MM
  { 2545,	3,	0,	4,	695,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #2545 = SUXC1
  { 2546,	3,	0,	4,	695,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2546 = SUXC164
  { 2547,	3,	0,	4,	1280,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x5ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2547 = SUXC1_MM
  { 2548,	3,	0,	4,	449,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2548 = SW
  { 2549,	3,	0,	2,	1125,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo328, -1 ,nullptr },  // Inst #2549 = SW16_MM
  { 2550,	3,	0,	2,	1148,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo328, -1 ,nullptr },  // Inst #2550 = SW16_MMR6
  { 2551,	3,	0,	4,	1171,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2551 = SW64
  { 2552,	3,	0,	4,	693,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #2552 = SWC1
  { 2553,	3,	0,	4,	1279,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #2553 = SWC1_MM
  { 2554,	3,	0,	4,	450,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #2554 = SWC2
  { 2555,	3,	0,	4,	1149,	0|(1ULL<<MCID::MayStore), 0x6ULL, nullptr, nullptr, OperandInfo262, -1 ,nullptr },  // Inst #2555 = SWC2_MMR6
  { 2556,	3,	0,	4,	1076,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #2556 = SWC2_R6
  { 2557,	3,	0,	4,	451,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #2557 = SWC3
  { 2558,	3,	0,	4,	1330,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #2558 = SWDSP
  { 2559,	3,	0,	4,	1495,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #2559 = SWDSP_MM
  { 2560,	3,	0,	4,	457,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2560 = SWE
  { 2561,	3,	0,	4,	1094,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2561 = SWE_MM
  { 2562,	3,	0,	4,	459,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2562 = SWL
  { 2563,	3,	0,	4,	1172,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2563 = SWL64
  { 2564,	3,	0,	4,	461,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2564 = SWLE
  { 2565,	3,	0,	4,	1095,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2565 = SWLE_MM
  { 2566,	3,	0,	4,	1126,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2566 = SWL_MM
  { 2567,	3,	0,	2,	1127,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo279, -1 ,nullptr },  // Inst #2567 = SWM16_MM
  { 2568,	3,	0,	2,	1150,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo279, -1 ,nullptr },  // Inst #2568 = SWM16_MMR6
  { 2569,	3,	0,	4,	1127,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo95, -1 ,nullptr },  // Inst #2569 = SWM32_MM
  { 2570,	4,	0,	4,	1129,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo280, -1 ,nullptr },  // Inst #2570 = SWP_MM
  { 2571,	3,	0,	4,	460,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2571 = SWR
  { 2572,	3,	0,	4,	1173,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #2572 = SWR64
  { 2573,	3,	0,	4,	462,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2573 = SWRE
  { 2574,	3,	0,	4,	1096,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2574 = SWRE_MM
  { 2575,	3,	0,	4,	1130,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2575 = SWR_MM
  { 2576,	3,	0,	2,	1125,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo281, -1 ,nullptr },  // Inst #2576 = SWSP_MM
  { 2577,	3,	0,	2,	1148,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo281, -1 ,nullptr },  // Inst #2577 = SWSP_MMR6
  { 2578,	3,	0,	4,	694,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo282, -1 ,nullptr },  // Inst #2578 = SWXC1
  { 2579,	3,	0,	4,	1281,	0|(1ULL<<MCID::MayStore), 0x5ULL, nullptr, nullptr, OperandInfo282, -1 ,nullptr },  // Inst #2579 = SWXC1_MM
  { 2580,	3,	0,	4,	1125,	0|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2580 = SW_MM
  { 2581,	3,	0,	4,	1148,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo83, -1 ,nullptr },  // Inst #2581 = SW_MMR6
  { 2582,	1,	0,	4,	467,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2582 = SYNC
  { 2583,	2,	0,	4,	468,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo345, -1 ,nullptr },  // Inst #2583 = SYNCI
  { 2584,	2,	0,	4,	1134,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo345, -1 ,nullptr },  // Inst #2584 = SYNCI_MM
  { 2585,	2,	0,	4,	1152,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo345, -1 ,nullptr },  // Inst #2585 = SYNCI_MMR6
  { 2586,	1,	0,	4,	1133,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2586 = SYNC_MM
  { 2587,	1,	0,	4,	1151,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2587 = SYNC_MMR6
  { 2588,	1,	0,	4,	385,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2588 = SYSCALL
  { 2589,	1,	0,	4,	960,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2589 = SYSCALL_MM
  { 2590,	0,	0,	2,	1106,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #2590 = Save16
  { 2591,	0,	0,	2,	1106,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList1, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #2591 = SaveX16
  { 2592,	3,	0,	4,	1107,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #2592 = SbRxRyOffMemX16
  { 2593,	2,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo346, -1 ,nullptr },  // Inst #2593 = SebRx16
  { 2594,	2,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo346, -1 ,nullptr },  // Inst #2594 = SehRx16
  { 2595,	3,	0,	4,	1108,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #2595 = ShRxRyOffMemX16
  { 2596,	3,	1,	4,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #2596 = SllX16
  { 2597,	3,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #2597 = SllvRxRy16
  { 2598,	2,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo115, -1 ,nullptr },  // Inst #2598 = SltRxRy16
  { 2599,	2,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo167, -1 ,nullptr },  // Inst #2599 = SltiRxImm16
  { 2600,	2,	0,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo167, -1 ,nullptr },  // Inst #2600 = SltiRxImmX16
  { 2601,	2,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo167, -1 ,nullptr },  // Inst #2601 = SltiuRxImm16
  { 2602,	2,	0,	4,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo167, -1 ,nullptr },  // Inst #2602 = SltiuRxImmX16
  { 2603,	2,	0,	2,	727,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList7, OperandInfo115, -1 ,nullptr },  // Inst #2603 = SltuRxRy16
  { 2604,	3,	1,	4,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #2604 = SraX16
  { 2605,	3,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #2605 = SravRxRy16
  { 2606,	3,	1,	4,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #2606 = SrlX16
  { 2607,	3,	1,	2,	727,	0, 0x0ULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #2607 = SrlvRxRy16
  { 2608,	3,	1,	2,	727,	0|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #2608 = SubuRxRyRz16
  { 2609,	3,	0,	4,	1109,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #2609 = SwRxRyOffMemX16
  { 2610,	3,	0,	4,	1109,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo169, -1 ,nullptr },  // Inst #2610 = SwRxSpImmX16
  { 2611,	3,	0,	4,	386,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2611 = TEQ
  { 2612,	2,	0,	4,	387,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2612 = TEQI
  { 2613,	2,	0,	4,	961,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2613 = TEQI_MM
  { 2614,	3,	0,	4,	962,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2614 = TEQ_MM
  { 2615,	3,	0,	4,	388,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2615 = TGE
  { 2616,	2,	0,	4,	389,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2616 = TGEI
  { 2617,	2,	0,	4,	390,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2617 = TGEIU
  { 2618,	2,	0,	4,	963,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2618 = TGEIU_MM
  { 2619,	2,	0,	4,	964,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2619 = TGEI_MM
  { 2620,	3,	0,	4,	391,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2620 = TGEU
  { 2621,	3,	0,	4,	965,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2621 = TGEU_MM
  { 2622,	3,	0,	4,	966,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2622 = TGE_MM
  { 2623,	0,	0,	4,	420,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2623 = TLBGINV
  { 2624,	0,	0,	4,	421,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2624 = TLBGINVF
  { 2625,	0,	0,	4,	1062,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2625 = TLBGINVF_MM
  { 2626,	0,	0,	4,	1063,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2626 = TLBGINV_MM
  { 2627,	0,	0,	4,	422,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2627 = TLBGP
  { 2628,	0,	0,	4,	1064,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2628 = TLBGP_MM
  { 2629,	0,	0,	4,	423,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2629 = TLBGR
  { 2630,	0,	0,	4,	1065,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2630 = TLBGR_MM
  { 2631,	0,	0,	4,	424,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2631 = TLBGWI
  { 2632,	0,	0,	4,	1066,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2632 = TLBGWI_MM
  { 2633,	0,	0,	4,	425,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2633 = TLBGWR
  { 2634,	0,	0,	4,	1067,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2634 = TLBGWR_MM
  { 2635,	0,	0,	4,	405,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2635 = TLBINV
  { 2636,	0,	0,	4,	406,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2636 = TLBINVF
  { 2637,	0,	0,	4,	1031,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2637 = TLBINVF_MMR6
  { 2638,	0,	0,	4,	1030,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2638 = TLBINV_MMR6
  { 2639,	0,	0,	4,	407,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2639 = TLBP
  { 2640,	0,	0,	4,	1019,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2640 = TLBP_MM
  { 2641,	0,	0,	4,	408,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2641 = TLBR
  { 2642,	0,	0,	4,	1020,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2642 = TLBR_MM
  { 2643,	0,	0,	4,	409,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2643 = TLBWI
  { 2644,	0,	0,	4,	1021,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2644 = TLBWI_MM
  { 2645,	0,	0,	4,	410,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2645 = TLBWR
  { 2646,	0,	0,	4,	1022,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2646 = TLBWR_MM
  { 2647,	3,	0,	4,	392,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2647 = TLT
  { 2648,	2,	0,	4,	393,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2648 = TLTI
  { 2649,	2,	0,	4,	967,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2649 = TLTIU_MM
  { 2650,	2,	0,	4,	968,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2650 = TLTI_MM
  { 2651,	3,	0,	4,	394,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2651 = TLTU
  { 2652,	3,	0,	4,	969,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2652 = TLTU_MM
  { 2653,	3,	0,	4,	970,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2653 = TLT_MM
  { 2654,	3,	0,	4,	395,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2654 = TNE
  { 2655,	2,	0,	4,	396,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2655 = TNEI
  { 2656,	2,	0,	4,	971,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2656 = TNEI_MM
  { 2657,	3,	0,	4,	972,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x12ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2657 = TNE_MM
  { 2658,	2,	1,	4,	629,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2658 = TRUNC_L_D64
  { 2659,	2,	1,	4,	1296,	0, 0x4ULL, nullptr, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #2659 = TRUNC_L_D_MMR6
  { 2660,	2,	1,	4,	629,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #2660 = TRUNC_L_S
  { 2661,	2,	1,	4,	1296,	0, 0x4ULL, nullptr, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #2661 = TRUNC_L_S_MMR6
  { 2662,	2,	1,	4,	629,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #2662 = TRUNC_W_D32
  { 2663,	2,	1,	4,	629,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #2663 = TRUNC_W_D64
  { 2664,	2,	1,	4,	1296,	0, 0x4ULL, nullptr, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #2664 = TRUNC_W_D_MMR6
  { 2665,	2,	1,	4,	1244,	0, 0x4ULL, nullptr, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #2665 = TRUNC_W_MM
  { 2666,	2,	1,	4,	629,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2666 = TRUNC_W_S
  { 2667,	2,	1,	4,	1244,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2667 = TRUNC_W_S_MM
  { 2668,	2,	1,	4,	1296,	0, 0x4ULL, nullptr, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #2668 = TRUNC_W_S_MMR6
  { 2669,	2,	0,	4,	398,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2669 = TTLTIU
  { 2670,	2,	0,	4,	858,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2670 = UDIV
  { 2671,	2,	0,	4,	878,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList6, OperandInfo32, -1 ,nullptr },  // Inst #2671 = UDIV_MM
  { 2672,	3,	1,	4,	1200,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList33, OperandInfo58, -1 ,nullptr },  // Inst #2672 = V3MULU
  { 2673,	3,	1,	4,	1200,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList25, OperandInfo58, -1 ,nullptr },  // Inst #2673 = VMM0
  { 2674,	3,	1,	4,	1200,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects), 0x1ULL, nullptr, ImplicitList34, OperandInfo58, -1 ,nullptr },  // Inst #2674 = VMULU
  { 2675,	4,	1,	4,	510,	0, 0x6ULL, nullptr, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #2675 = VSHF_B
  { 2676,	4,	1,	4,	510,	0, 0x6ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #2676 = VSHF_D
  { 2677,	4,	1,	4,	510,	0, 0x6ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #2677 = VSHF_H
  { 2678,	4,	1,	4,	510,	0, 0x6ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #2678 = VSHF_W
  { 2679,	0,	0,	4,	399,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x16ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #2679 = WAIT
  { 2680,	1,	0,	4,	1027,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2680 = WAIT_MM
  { 2681,	1,	0,	4,	1044,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #2681 = WAIT_MMR6
  { 2682,	2,	0,	4,	1445,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2682 = WRDSP
  { 2683,	2,	0,	4,	1611,	0|(1ULL<<MCID::MoveReg)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo99, -1 ,nullptr },  // Inst #2683 = WRDSP_MM
  { 2684,	2,	1,	4,	1029,	0, 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2684 = WRPGPR_MMR6
  { 2685,	2,	1,	4,	476,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2685 = WSBH
  { 2686,	2,	1,	4,	763,	0, 0x1ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2686 = WSBH_MM
  { 2687,	2,	1,	4,	795,	0, 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2687 = WSBH_MMR6
  { 2688,	3,	1,	4,	366,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2688 = XOR
  { 2689,	3,	1,	2,	764,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #2689 = XOR16_MM
  { 2690,	3,	1,	2,	796,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #2690 = XOR16_MMR6
  { 2691,	3,	1,	4,	807,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #2691 = XOR64
  { 2692,	3,	1,	4,	544,	0, 0x6ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #2692 = XORI_B
  { 2693,	3,	1,	4,	797,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2693 = XORI_MMR6
  { 2694,	3,	1,	4,	764,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2694 = XOR_MM
  { 2695,	3,	1,	4,	796,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x1ULL, nullptr, nullptr, OperandInfo59, -1 ,nullptr },  // Inst #2695 = XOR_MMR6
  { 2696,	3,	1,	4,	543,	0, 0x6ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #2696 = XOR_V
  { 2697,	3,	1,	4,	503,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2697 = XORi
  { 2698,	3,	1,	4,	807,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #2698 = XORi64
  { 2699,	3,	1,	4,	765,	0|(1ULL<<MCID::Rematerializable), 0x2ULL, nullptr, nullptr, OperandInfo60, -1 ,nullptr },  // Inst #2699 = XORi_MM
  { 2700,	3,	1,	2,	727,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #2700 = XorRxRxRy16
  { 2701,	2,	1,	4,	1057,	0|(1ULL<<MCID::NotDuplicable)|(1ULL<<MCID::UnmodeledSideEffects), 0x6ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #2701 = YIELD
};

extern const char MipsInstrNameData[] = {
  /* 0 */ 'G', '_', 'F', 'L', 'O', 'G', '1', '0', 0,
  /* 9 */ 'D', 'M', 'F', 'C', '0', 0,
  /* 15 */ 'D', 'M', 'F', 'G', 'C', '0', 0,
  /* 22 */ 'M', 'F', 'H', 'G', 'C', '0', 0,
  /* 29 */ 'M', 'T', 'H', 'G', 'C', '0', 0,
  /* 36 */ 'D', 'M', 'T', 'G', 'C', '0', 0,
  /* 43 */ 'M', 'F', 'T', 'C', '0', 0,
  /* 49 */ 'D', 'M', 'T', 'C', '0', 0,
  /* 55 */ 'M', 'T', 'T', 'C', '0', 0,
  /* 61 */ 'V', 'M', 'M', '0', 0,
  /* 66 */ 'M', 'T', 'M', '0', 0,
  /* 71 */ 'M', 'T', 'P', '0', 0,
  /* 76 */ 'B', 'B', 'I', 'T', '0', 0,
  /* 82 */ 'L', 'D', 'C', '1', 0,
  /* 87 */ 'S', 'D', 'C', '1', 0,
  /* 92 */ 'C', 'F', 'C', '1', 0,
  /* 97 */ 'D', 'M', 'F', 'C', '1', 0,
  /* 103 */ 'M', 'F', 'T', 'H', 'C', '1', 0,
  /* 110 */ 'M', 'T', 'T', 'H', 'C', '1', 0,
  /* 117 */ 'C', 'T', 'C', '1', 0,
  /* 122 */ 'C', 'F', 'T', 'C', '1', 0,
  /* 128 */ 'M', 'F', 'T', 'C', '1', 0,
  /* 134 */ 'D', 'M', 'T', 'C', '1', 0,
  /* 140 */ 'C', 'T', 'T', 'C', '1', 0,
  /* 146 */ 'M', 'T', 'T', 'C', '1', 0,
  /* 152 */ 'L', 'W', 'C', '1', 0,
  /* 157 */ 'S', 'W', 'C', '1', 0,
  /* 162 */ 'L', 'D', 'X', 'C', '1', 0,
  /* 168 */ 'S', 'D', 'X', 'C', '1', 0,
  /* 174 */ 'L', 'U', 'X', 'C', '1', 0,
  /* 180 */ 'S', 'U', 'X', 'C', '1', 0,
  /* 186 */ 'L', 'W', 'X', 'C', '1', 0,
  /* 192 */ 'S', 'W', 'X', 'C', '1', 0,
  /* 198 */ 'M', 'T', 'M', '1', 0,
  /* 203 */ 'S', 'D', 'C', '1', '_', 'M', '1', 0,
  /* 211 */ 'M', 'T', 'P', '1', 0,
  /* 216 */ 'B', 'B', 'I', 'T', '1', 0,
  /* 222 */ 'B', 'B', 'I', 'T', '0', '3', '2', 0,
  /* 230 */ 'B', 'B', 'I', 'T', '1', '3', '2', 0,
  /* 238 */ 'D', 'S', 'R', 'A', '3', '2', 0,
  /* 245 */ 'M', 'F', 'H', 'C', '1', '_', 'D', '3', '2', 0,
  /* 255 */ 'M', 'T', 'H', 'C', '1', '_', 'D', '3', '2', 0,
  /* 265 */ 'F', 'S', 'U', 'B', '_', 'D', '3', '2', 0,
  /* 274 */ 'N', 'M', 'S', 'U', 'B', '_', 'D', '3', '2', 0,
  /* 284 */ 'F', 'A', 'D', 'D', '_', 'D', '3', '2', 0,
  /* 293 */ 'N', 'M', 'A', 'D', 'D', '_', 'D', '3', '2', 0,
  /* 303 */ 'C', '_', 'N', 'G', 'E', '_', 'D', '3', '2', 0,
  /* 313 */ 'C', '_', 'N', 'G', 'L', 'E', '_', 'D', '3', '2', 0,
  /* 324 */ 'C', '_', 'O', 'L', 'E', '_', 'D', '3', '2', 0,
  /* 334 */ 'C', '_', 'U', 'L', 'E', '_', 'D', '3', '2', 0,
  /* 344 */ 'C', '_', 'L', 'E', '_', 'D', '3', '2', 0,
  /* 353 */ 'C', '_', 'S', 'F', '_', 'D', '3', '2', 0,
  /* 362 */ 'M', 'O', 'V', 'F', '_', 'D', '3', '2', 0,
  /* 371 */ 'C', '_', 'F', '_', 'D', '3', '2', 0,
  /* 379 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'F', '_', 'D', '3', '2', 0,
  /* 400 */ 'F', 'N', 'E', 'G', '_', 'D', '3', '2', 0,
  /* 409 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'D', '3', '2', 0,
  /* 420 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'D', '3', '2', 0,
  /* 431 */ 'C', '_', 'N', 'G', 'L', '_', 'D', '3', '2', 0,
  /* 441 */ 'F', 'M', 'U', 'L', '_', 'D', '3', '2', 0,
  /* 450 */ 'C', '_', 'U', 'N', '_', 'D', '3', '2', 0,
  /* 459 */ 'R', 'E', 'C', 'I', 'P', '_', 'D', '3', '2', 0,
  /* 469 */ 'F', 'C', 'M', 'P', '_', 'D', '3', '2', 0,
  /* 478 */ 'C', '_', 'S', 'E', 'Q', '_', 'D', '3', '2', 0,
  /* 488 */ 'C', '_', 'U', 'E', 'Q', '_', 'D', '3', '2', 0,
  /* 498 */ 'C', '_', 'E', 'Q', '_', 'D', '3', '2', 0,
  /* 507 */ 'F', 'A', 'B', 'S', '_', 'D', '3', '2', 0,
  /* 516 */ 'C', 'V', 'T', '_', 'S', '_', 'D', '3', '2', 0,
  /* 526 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'D', '3', '2', 0,
  /* 543 */ 'C', '_', 'N', 'G', 'T', '_', 'D', '3', '2', 0,
  /* 553 */ 'C', '_', 'O', 'L', 'T', '_', 'D', '3', '2', 0,
  /* 563 */ 'C', '_', 'U', 'L', 'T', '_', 'D', '3', '2', 0,
  /* 573 */ 'C', '_', 'L', 'T', '_', 'D', '3', '2', 0,
  /* 582 */ 'F', 'S', 'Q', 'R', 'T', '_', 'D', '3', '2', 0,
  /* 592 */ 'R', 'S', 'Q', 'R', 'T', '_', 'D', '3', '2', 0,
  /* 602 */ 'M', 'O', 'V', 'T', '_', 'D', '3', '2', 0,
  /* 611 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'T', '_', 'D', '3', '2', 0,
  /* 632 */ 'F', 'D', 'I', 'V', '_', 'D', '3', '2', 0,
  /* 641 */ 'F', 'M', 'O', 'V', '_', 'D', '3', '2', 0,
  /* 650 */ 'P', 's', 'e', 'u', 'd', 'o', 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'D', '3', '2', 0,
  /* 668 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'D', '3', '2', 0,
  /* 680 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'D', '3', '2', 0,
  /* 691 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'D', '3', '2', 0,
  /* 703 */ 'C', 'V', 'T', '_', 'W', '_', 'D', '3', '2', 0,
  /* 713 */ 'B', 'P', 'O', 'S', 'G', 'E', '3', '2', 0,
  /* 722 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '3', '2', 0,
  /* 742 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '3', '2', 0,
  /* 762 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 783 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 803 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '3', '2', 0,
  /* 819 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '3', '2', 0,
  /* 839 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 859 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 878 */ 'D', 'S', 'L', 'L', '3', '2', 0,
  /* 885 */ 'D', 'S', 'R', 'L', '3', '2', 0,
  /* 892 */ 'D', 'R', 'O', 'T', 'R', '3', '2', 0,
  /* 900 */ 'C', 'I', 'N', 'S', '3', '2', 0,
  /* 907 */ 'E', 'X', 'T', 'S', '3', '2', 0,
  /* 914 */ 'F', 'C', 'M', 'P', '_', 'S', '3', '2', 0,
  /* 923 */ 'D', 'S', 'L', 'L', '6', '4', '_', '3', '2', 0,
  /* 933 */ 'C', 'I', 'N', 'S', '6', '4', '_', '3', '2', 0,
  /* 943 */ 'D', 'E', 'X', 'T', '6', '4', '_', '3', '2', 0,
  /* 953 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', 'D', 'o', 'u', 'b', 'l', 'e', 'F', 'G', 'R', '_', '3', '2', 0,
  /* 973 */ 'L', 'o', 'a', 'd', 'A', 'd', 'd', 'r', 'R', 'e', 'g', '3', '2', 0,
  /* 987 */ 'C', 'I', 'N', 'S', '_', 'i', '3', '2', 0,
  /* 996 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', '3', '2', 0,
  /* 1006 */ 'L', 'o', 'a', 'd', 'A', 'd', 'd', 'r', 'I', 'm', 'm', '3', '2', 0,
  /* 1020 */ 'M', 'I', 'P', 'S', 'e', 'h', '_', 'r', 'e', 't', 'u', 'r', 'n', '3', '2', 0,
  /* 1036 */ 'L', 'w', 'C', 'o', 'n', 's', 't', 'a', 'n', 't', '3', '2', 0,
  /* 1049 */ 'L', 'D', 'C', '2', 0,
  /* 1054 */ 'S', 'D', 'C', '2', 0,
  /* 1059 */ 'D', 'M', 'F', 'C', '2', 0,
  /* 1065 */ 'D', 'M', 'T', 'C', '2', 0,
  /* 1071 */ 'L', 'W', 'C', '2', 0,
  /* 1076 */ 'S', 'W', 'C', '2', 0,
  /* 1081 */ 'G', '_', 'F', 'L', 'O', 'G', '2', 0,
  /* 1089 */ 'M', 'T', 'M', '2', 0,
  /* 1094 */ 'M', 'T', 'P', '2', 0,
  /* 1099 */ 'G', '_', 'F', 'E', 'X', 'P', '2', 0,
  /* 1107 */ 'S', 'H', 'R', 'A', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1120 */ 'C', 'M', 'P', 'G', 'D', 'U', '_', 'L', 'E', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1138 */ 'S', 'U', 'B', 'U', 'H', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1152 */ 'A', 'D', 'D', 'U', 'H', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1166 */ 'C', 'M', 'P', 'G', 'D', 'U', '_', 'E', 'Q', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1184 */ 'S', 'H', 'R', 'A', '_', 'R', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1199 */ 'S', 'U', 'B', 'U', 'H', '_', 'R', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1215 */ 'A', 'D', 'D', 'U', 'H', '_', 'R', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1231 */ 'S', 'H', 'R', 'A', 'V', '_', 'R', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1247 */ 'A', 'B', 'S', 'Q', '_', 'S', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1262 */ 'C', 'M', 'P', 'G', 'D', 'U', '_', 'L', 'T', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1280 */ 'S', 'H', 'R', 'A', 'V', '_', 'Q', 'B', '_', 'M', 'M', 'R', '2', 0,
  /* 1294 */ 'P', 'R', 'E', 'P', 'E', 'N', 'D', '_', 'M', 'M', 'R', '2', 0,
  /* 1307 */ 'A', 'P', 'P', 'E', 'N', 'D', '_', 'M', 'M', 'R', '2', 0,
  /* 1319 */ 'P', 'R', 'E', 'C', 'R', '_', 'Q', 'B', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1336 */ 'S', 'U', 'B', 'Q', 'H', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1350 */ 'A', 'D', 'D', 'Q', 'H', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1364 */ 'S', 'H', 'R', 'L', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1377 */ 'M', 'U', 'L', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1389 */ 'S', 'U', 'B', 'Q', 'H', '_', 'R', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1405 */ 'A', 'D', 'D', 'Q', 'H', '_', 'R', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1421 */ 'M', 'U', 'L', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1435 */ 'M', 'U', 'L', 'Q', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1450 */ 'S', 'U', 'B', 'U', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1465 */ 'A', 'D', 'D', 'U', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1480 */ 'S', 'U', 'B', 'U', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1493 */ 'A', 'D', 'D', 'U', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1506 */ 'S', 'H', 'R', 'L', 'V', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1520 */ 'D', 'P', 'A', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1534 */ 'M', 'U', 'L', 'S', 'A', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1550 */ 'D', 'P', 'A', 'Q', 'X', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1569 */ 'D', 'P', 'S', 'Q', 'X', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1588 */ 'D', 'P', 'S', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1602 */ 'D', 'P', 'A', 'Q', 'X', '_', 'S', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1620 */ 'D', 'P', 'S', 'Q', 'X', '_', 'S', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1638 */ 'D', 'P', 'A', 'X', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1653 */ 'D', 'P', 'S', 'X', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 'R', '2', 0,
  /* 1668 */ 'B', 'A', 'L', 'I', 'G', 'N', '_', 'M', 'M', 'R', '2', 0,
  /* 1680 */ 'P', 'R', 'E', 'C', 'R', '_', 'S', 'R', 'A', '_', 'P', 'H', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1700 */ 'P', 'R', 'E', 'C', 'R', '_', 'S', 'R', 'A', '_', 'R', '_', 'P', 'H', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1722 */ 'S', 'U', 'B', 'Q', 'H', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1735 */ 'A', 'D', 'D', 'Q', 'H', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1748 */ 'S', 'U', 'B', 'Q', 'H', '_', 'R', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1763 */ 'A', 'D', 'D', 'Q', 'H', '_', 'R', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1778 */ 'M', 'U', 'L', 'Q', '_', 'R', 'S', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1793 */ 'M', 'U', 'L', 'Q', '_', 'S', '_', 'W', '_', 'M', 'M', 'R', '2', 0,
  /* 1807 */ 'L', 'D', 'C', '3', 0,
  /* 1812 */ 'S', 'D', 'C', '3', 0,
  /* 1817 */ 'L', 'W', 'C', '3', 0,
  /* 1822 */ 'S', 'W', 'C', '3', 0,
  /* 1827 */ 'B', 'P', 'O', 'S', 'G', 'E', '3', '2', 'C', '_', 'M', 'M', 'R', '3', 0,
  /* 1842 */ 'L', 'D', 'C', '1', '6', '4', 0,
  /* 1849 */ 'S', 'D', 'C', '1', '6', '4', 0,
  /* 1856 */ 'L', 'D', 'X', 'C', '1', '6', '4', 0,
  /* 1864 */ 'S', 'D', 'X', 'C', '1', '6', '4', 0,
  /* 1872 */ 'L', 'U', 'X', 'C', '1', '6', '4', 0,
  /* 1880 */ 'S', 'U', 'X', 'C', '1', '6', '4', 0,
  /* 1888 */ 'S', 'E', 'B', '6', '4', 0,
  /* 1894 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', 'E', 'G', 'H', 'B', '6', '4', 0,
  /* 1910 */ 'J', 'R', '_', 'H', 'B', '6', '4', 0,
  /* 1918 */ 'J', 'A', 'L', 'R', '_', 'H', 'B', '6', '4', 0,
  /* 1928 */ 'L', 'B', '6', '4', 0,
  /* 1933 */ 'S', 'B', '6', '4', 0,
  /* 1938 */ 'L', 'O', 'A', 'D', '_', 'A', 'C', 'C', '6', '4', 0,
  /* 1949 */ 'S', 'T', 'O', 'R', 'E', '_', 'A', 'C', 'C', '6', '4', 0,
  /* 1961 */ 'B', 'G', 'E', 'C', '6', '4', 0,
  /* 1968 */ 'B', 'N', 'E', 'C', '6', '4', 0,
  /* 1975 */ 'J', 'I', 'C', '6', '4', 0,
  /* 1981 */ 'J', 'I', 'A', 'L', 'C', '6', '4', 0,
  /* 1989 */ 'B', 'E', 'Q', 'C', '6', '4', 0,
  /* 1996 */ 'S', 'C', '6', '4', 0,
  /* 2001 */ 'B', 'L', 'T', 'C', '6', '4', 0,
  /* 2008 */ 'B', 'G', 'E', 'U', 'C', '6', '4', 0,
  /* 2016 */ 'B', 'L', 'T', 'U', 'C', '6', '4', 0,
  /* 2024 */ 'B', 'G', 'E', 'Z', 'C', '6', '4', 0,
  /* 2032 */ 'B', 'L', 'E', 'Z', 'C', '6', '4', 0,
  /* 2040 */ 'B', 'N', 'E', 'Z', 'C', '6', '4', 0,
  /* 2048 */ 'B', 'E', 'Q', 'Z', 'C', '6', '4', 0,
  /* 2056 */ 'B', 'G', 'T', 'Z', 'C', '6', '4', 0,
  /* 2064 */ 'B', 'L', 'T', 'Z', 'C', '6', '4', 0,
  /* 2072 */ 'A', 'N', 'D', '6', '4', 0,
  /* 2078 */ 'M', 'F', 'C', '1', '_', 'D', '6', '4', 0,
  /* 2087 */ 'M', 'F', 'H', 'C', '1', '_', 'D', '6', '4', 0,
  /* 2097 */ 'M', 'T', 'H', 'C', '1', '_', 'D', '6', '4', 0,
  /* 2107 */ 'M', 'T', 'C', '1', '_', 'D', '6', '4', 0,
  /* 2116 */ 'M', 'O', 'V', 'N', '_', 'I', '6', '4', '_', 'D', '6', '4', 0,
  /* 2129 */ 'M', 'O', 'V', 'Z', '_', 'I', '6', '4', '_', 'D', '6', '4', 0,
  /* 2142 */ 'F', 'S', 'U', 'B', '_', 'D', '6', '4', 0,
  /* 2151 */ 'N', 'M', 'S', 'U', 'B', '_', 'D', '6', '4', 0,
  /* 2161 */ 'F', 'A', 'D', 'D', '_', 'D', '6', '4', 0,
  /* 2170 */ 'N', 'M', 'A', 'D', 'D', '_', 'D', '6', '4', 0,
  /* 2180 */ 'C', '_', 'N', 'G', 'E', '_', 'D', '6', '4', 0,
  /* 2190 */ 'C', '_', 'N', 'G', 'L', 'E', '_', 'D', '6', '4', 0,
  /* 2201 */ 'C', '_', 'O', 'L', 'E', '_', 'D', '6', '4', 0,
  /* 2211 */ 'C', '_', 'U', 'L', 'E', '_', 'D', '6', '4', 0,
  /* 2221 */ 'C', '_', 'L', 'E', '_', 'D', '6', '4', 0,
  /* 2230 */ 'C', '_', 'S', 'F', '_', 'D', '6', '4', 0,
  /* 2239 */ 'M', 'O', 'V', 'F', '_', 'D', '6', '4', 0,
  /* 2248 */ 'C', '_', 'F', '_', 'D', '6', '4', 0,
  /* 2256 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'F', '_', 'D', '6', '4', 0,
  /* 2277 */ 'F', 'N', 'E', 'G', '_', 'D', '6', '4', 0,
  /* 2286 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'D', '6', '4', 0,
  /* 2297 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'D', '6', '4', 0,
  /* 2308 */ 'C', '_', 'N', 'G', 'L', '_', 'D', '6', '4', 0,
  /* 2318 */ 'F', 'M', 'U', 'L', '_', 'D', '6', '4', 0,
  /* 2327 */ 'T', 'R', 'U', 'N', 'C', '_', 'L', '_', 'D', '6', '4', 0,
  /* 2339 */ 'R', 'O', 'U', 'N', 'D', '_', 'L', '_', 'D', '6', '4', 0,
  /* 2351 */ 'C', 'E', 'I', 'L', '_', 'L', '_', 'D', '6', '4', 0,
  /* 2362 */ 'F', 'L', 'O', 'O', 'R', '_', 'L', '_', 'D', '6', '4', 0,
  /* 2374 */ 'C', 'V', 'T', '_', 'L', '_', 'D', '6', '4', 0,
  /* 2384 */ 'C', '_', 'U', 'N', '_', 'D', '6', '4', 0,
  /* 2393 */ 'R', 'E', 'C', 'I', 'P', '_', 'D', '6', '4', 0,
  /* 2403 */ 'F', 'C', 'M', 'P', '_', 'D', '6', '4', 0,
  /* 2412 */ 'C', '_', 'S', 'E', 'Q', '_', 'D', '6', '4', 0,
  /* 2422 */ 'C', '_', 'U', 'E', 'Q', '_', 'D', '6', '4', 0,
  /* 2432 */ 'C', '_', 'E', 'Q', '_', 'D', '6', '4', 0,
  /* 2441 */ 'F', 'A', 'B', 'S', '_', 'D', '6', '4', 0,
  /* 2450 */ 'C', 'V', 'T', '_', 'S', '_', 'D', '6', '4', 0,
  /* 2460 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'D', '6', '4', 0,
  /* 2477 */ 'C', '_', 'N', 'G', 'T', '_', 'D', '6', '4', 0,
  /* 2487 */ 'C', '_', 'O', 'L', 'T', '_', 'D', '6', '4', 0,
  /* 2497 */ 'C', '_', 'U', 'L', 'T', '_', 'D', '6', '4', 0,
  /* 2507 */ 'C', '_', 'L', 'T', '_', 'D', '6', '4', 0,
  /* 2516 */ 'F', 'S', 'Q', 'R', 'T', '_', 'D', '6', '4', 0,
  /* 2526 */ 'R', 'S', 'Q', 'R', 'T', '_', 'D', '6', '4', 0,
  /* 2536 */ 'M', 'O', 'V', 'T', '_', 'D', '6', '4', 0,
  /* 2545 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'T', '_', 'D', '6', '4', 0,
  /* 2566 */ 'F', 'D', 'I', 'V', '_', 'D', '6', '4', 0,
  /* 2575 */ 'F', 'M', 'O', 'V', '_', 'D', '6', '4', 0,
  /* 2584 */ 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'D', '6', '4', 0,
  /* 2596 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'D', '6', '4', 0,
  /* 2608 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'D', '6', '4', 0,
  /* 2619 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'D', '6', '4', 0,
  /* 2631 */ 'C', 'V', 'T', '_', 'W', '_', 'D', '6', '4', 0,
  /* 2641 */ 'B', 'N', 'E', '6', '4', 0,
  /* 2647 */ 'B', 'u', 'i', 'l', 'd', 'P', 'a', 'i', 'r', 'F', '6', '4', 0,
  /* 2660 */ 'E', 'x', 't', 'r', 'a', 'c', 't', 'E', 'l', 'e', 'm', 'e', 'n', 't', 'F', '6', '4', 0,
  /* 2678 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', 'E', 'G', '6', '4', 0,
  /* 2692 */ 'S', 'E', 'H', '6', '4', 0,
  /* 2698 */ 'L', 'H', '6', '4', 0,
  /* 2703 */ 'S', 'H', '6', '4', 0,
  /* 2708 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'F', 'H', 'I', '6', '4', 0,
  /* 2721 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'T', 'L', 'O', 'H', 'I', '6', '4', 0,
  /* 2736 */ 'M', 'T', 'H', 'I', '6', '4', 0,
  /* 2743 */ 'M', 'O', 'V', 'N', '_', 'I', '6', '4', '_', 'I', '6', '4', 0,
  /* 2756 */ 'M', 'O', 'V', 'Z', '_', 'I', '6', '4', '_', 'I', '6', '4', 0,
  /* 2769 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '6', '4', 0,
  /* 2789 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '6', '4', 0,
  /* 2809 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 2830 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 2850 */ 'M', 'O', 'V', 'F', '_', 'I', '6', '4', 0,
  /* 2859 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'F', '_', 'I', '6', '4', 0,
  /* 2880 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'I', '6', '4', 0,
  /* 2891 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'I', '6', '4', 0,
  /* 2902 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '6', '4', 0,
  /* 2918 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '6', '4', 0,
  /* 2938 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 2958 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 2977 */ 'P', 's', 'e', 'u', 'd', 'o', 'D', '_', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '6', '4', 0,
  /* 2996 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '6', '4', 0,
  /* 3013 */ 'M', 'O', 'V', 'T', '_', 'I', '6', '4', 0,
  /* 3022 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'T', '_', 'I', '6', '4', 0,
  /* 3043 */ 'L', 'L', '6', '4', 0,
  /* 3048 */ 'C', 'V', 'T', '_', 'S', '_', 'P', 'L', '6', '4', 0,
  /* 3059 */ 'L', 'W', 'L', '6', '4', 0,
  /* 3065 */ 'S', 'W', 'L', '6', '4', 0,
  /* 3071 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'F', 'L', 'O', '6', '4', 0,
  /* 3084 */ 'M', 'T', 'L', 'O', '6', '4', 0,
  /* 3091 */ 'B', 'E', 'Q', '6', '4', 0,
  /* 3097 */ 'J', 'R', '6', '4', 0,
  /* 3102 */ 'J', 'A', 'L', 'R', '6', '4', 0,
  /* 3109 */ 'N', 'O', 'R', '6', '4', 0,
  /* 3115 */ 'X', 'O', 'R', '6', '4', 0,
  /* 3121 */ 'R', 'D', 'H', 'W', 'R', '6', '4', 0,
  /* 3129 */ 'L', 'W', 'R', '6', '4', 0,
  /* 3135 */ 'S', 'W', 'R', '6', '4', 0,
  /* 3141 */ 'P', 'L', 'L', '_', 'P', 'S', '6', '4', 0,
  /* 3150 */ 'P', 'L', 'U', '_', 'P', 'S', '6', '4', 0,
  /* 3159 */ 'C', 'V', 'T', '_', 'P', 'S', '_', 'S', '6', '4', 0,
  /* 3170 */ 'S', 'L', 'T', '6', '4', 0,
  /* 3176 */ 'C', 'V', 'T', '_', 'S', '_', 'P', 'U', '6', '4', 0,
  /* 3187 */ 'L', 'W', '6', '4', 0,
  /* 3192 */ 'S', 'W', '6', '4', 0,
  /* 3197 */ 'B', 'G', 'E', 'Z', '6', '4', 0,
  /* 3204 */ 'B', 'L', 'E', 'Z', '6', '4', 0,
  /* 3211 */ 'S', 'E', 'L', 'N', 'E', 'Z', '6', '4', 0,
  /* 3220 */ 'S', 'E', 'L', 'E', 'Q', 'Z', '6', '4', 0,
  /* 3229 */ 'B', 'G', 'T', 'Z', '6', '4', 0,
  /* 3236 */ 'B', 'L', 'T', 'Z', '6', '4', 0,
  /* 3243 */ 'B', 'u', 'i', 'l', 'd', 'P', 'a', 'i', 'r', 'F', '6', '4', '_', '6', '4', 0,
  /* 3259 */ 'E', 'x', 't', 'r', 'a', 'c', 't', 'E', 'l', 'e', 'm', 'e', 'n', 't', 'F', '6', '4', '_', '6', '4', 0,
  /* 3280 */ 'S', 'L', 'L', '6', '4', '_', '6', '4', 0,
  /* 3289 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'L', 'U', 'i', '2', 'O', 'p', '_', '6', '4', 0,
  /* 3311 */ 'L', 'o', 'a', 'd', 'A', 'd', 'd', 'r', 'R', 'e', 'g', '6', '4', 0,
  /* 3325 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'H', 'a', 'z', 'a', 'r', 'd', 'B', 'r', 'a', 'n', 'c', 'h', '6', '4', 0,
  /* 3354 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'B', 'r', 'a', 'n', 'c', 'h', '6', '4', 0,
  /* 3377 */ 'A', 'N', 'D', 'i', '6', '4', 0,
  /* 3384 */ 'X', 'O', 'R', 'i', '6', '4', 0,
  /* 3391 */ 'S', 'L', 'T', 'i', '6', '4', 0,
  /* 3398 */ 'L', 'U', 'i', '6', '4', 0,
  /* 3404 */ 'S', 'G', 'E', 'I', 'm', 'm', '6', '4', 0,
  /* 3413 */ 'N', 'O', 'R', 'I', 'm', 'm', '6', '4', 0,
  /* 3422 */ 'S', 'G', 'T', 'I', 'm', 'm', '6', '4', 0,
  /* 3431 */ 'S', 'L', 'T', 'I', 'm', 'm', '6', '4', 0,
  /* 3440 */ 'S', 'G', 'E', 'U', 'I', 'm', 'm', '6', '4', 0,
  /* 3450 */ 'S', 'G', 'T', 'U', 'I', 'm', 'm', '6', '4', 0,
  /* 3460 */ 'S', 'L', 'T', 'U', 'I', 'm', 'm', '6', '4', 0,
  /* 3470 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', '6', '4', 0,
  /* 3480 */ 'L', 'o', 'a', 'd', 'A', 'd', 'd', 'r', 'I', 'm', 'm', '6', '4', 0,
  /* 3494 */ 'P', 's', 'e', 'u', 'd', 'o', 'R', 'e', 't', 'u', 'r', 'n', '6', '4', 0,
  /* 3509 */ 'M', 'I', 'P', 'S', 'e', 'h', '_', 'r', 'e', 't', 'u', 'r', 'n', '6', '4', 0,
  /* 3525 */ 'L', 'B', 'u', '6', '4', 0,
  /* 3531 */ 'L', 'H', 'u', '6', '4', 0,
  /* 3537 */ 'S', 'L', 'T', 'u', '6', '4', 0,
  /* 3544 */ 'L', 'E', 'A', '_', 'A', 'D', 'D', 'i', 'u', '6', '4', 0,
  /* 3556 */ 'S', 'L', 'T', 'i', 'u', '6', '4', 0,
  /* 3564 */ 'M', 'o', 'v', 'e', 'R', '3', '2', '1', '6', 0,
  /* 3574 */ 'R', 'e', 't', 'R', 'A', '1', '6', 0,
  /* 3582 */ 'J', 'a', 'l', 'B', '1', '6', 0,
  /* 3589 */ 'L', 'D', '_', 'F', '1', '6', 0,
  /* 3596 */ 'S', 'T', '_', 'F', '1', '6', 0,
  /* 3603 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '1', '6', 0,
  /* 3623 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '1', '6', 0,
  /* 3643 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '1', '6', 0,
  /* 3664 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '1', '6', 0,
  /* 3684 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '1', '6', 0,
  /* 3700 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '1', '6', 0,
  /* 3720 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '1', '6', 0,
  /* 3740 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '1', '6', 0,
  /* 3759 */ 'M', 'o', 'v', 'e', '3', '2', 'R', '1', '6', 0,
  /* 3769 */ 'S', 'r', 'a', 'X', '1', '6', 0,
  /* 3776 */ 'R', 'e', 's', 't', 'o', 'r', 'e', 'X', '1', '6', 0,
  /* 3787 */ 'S', 'a', 'v', 'e', 'X', '1', '6', 0,
  /* 3795 */ 'B', 't', 'n', 'e', 'z', 'T', '8', 'C', 'm', 'p', 'i', 'X', '1', '6', 0,
  /* 3810 */ 'B', 't', 'e', 'q', 'z', 'T', '8', 'C', 'm', 'p', 'i', 'X', '1', '6', 0,
  /* 3825 */ 'B', 't', 'n', 'e', 'z', 'T', '8', 'S', 'l', 't', 'i', 'X', '1', '6', 0,
  /* 3840 */ 'B', 't', 'e', 'q', 'z', 'T', '8', 'S', 'l', 't', 'i', 'X', '1', '6', 0,
  /* 3855 */ 'S', 'l', 'l', 'X', '1', '6', 0,
  /* 3862 */ 'S', 'r', 'l', 'X', '1', '6', 0,
  /* 3869 */ 'L', 'b', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3885 */ 'S', 'b', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3901 */ 'L', 'h', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3917 */ 'S', 'h', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3933 */ 'L', 'b', 'u', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3950 */ 'L', 'h', 'u', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3967 */ 'A', 'd', 'd', 'i', 'u', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 3986 */ 'L', 'w', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 4002 */ 'S', 'w', 'R', 'x', 'R', 'y', 'O', 'f', 'f', 'M', 'e', 'm', 'X', '1', '6', 0,
  /* 4018 */ 'A', 'd', 'd', 'i', 'u', 'R', 'x', 'P', 'c', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4034 */ 'A', 'd', 'd', 'i', 'u', 'S', 'p', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4048 */ 'L', 'w', 'R', 'x', 'S', 'p', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4061 */ 'S', 'w', 'R', 'x', 'S', 'p', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4074 */ 'S', 'l', 't', 'i', 'C', 'C', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4089 */ 'S', 'l', 't', 'i', 'u', 'C', 'C', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4105 */ 'L', 'i', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4116 */ 'C', 'm', 'p', 'i', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4129 */ 'S', 'l', 't', 'i', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4142 */ 'A', 'd', 'd', 'i', 'u', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4156 */ 'S', 'l', 't', 'i', 'u', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4170 */ 'A', 'd', 'd', 'i', 'u', 'R', 'x', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4186 */ 'B', 'n', 'e', 'z', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4199 */ 'B', 'e', 'q', 'z', 'R', 'x', 'I', 'm', 'm', 'X', '1', '6', 0,
  /* 4212 */ 'B', 'i', 'm', 'm', 'X', '1', '6', 0,
  /* 4220 */ 'L', 'i', 'R', 'x', 'I', 'm', 'm', 'A', 'l', 'i', 'g', 'n', 'X', '1', '6', 0,
  /* 4236 */ 'L', 'w', 'R', 'x', 'P', 'c', 'T', 'c', 'p', 'X', '1', '6', 0,
  /* 4249 */ 'B', 't', 'n', 'e', 'z', 'T', '8', 'C', 'm', 'p', 'X', '1', '6', 0,
  /* 4263 */ 'B', 't', 'e', 'q', 'z', 'T', '8', 'C', 'm', 'p', 'X', '1', '6', 0,
  /* 4277 */ 'B', 't', 'n', 'e', 'z', 'T', '8', 'S', 'l', 't', 'X', '1', '6', 0,
  /* 4291 */ 'B', 't', 'e', 'q', 'z', 'T', '8', 'S', 'l', 't', 'X', '1', '6', 0,
  /* 4305 */ 'B', 't', 'n', 'e', 'z', 'T', '8', 'S', 'l', 't', 'i', 'u', 'X', '1', '6', 0,
  /* 4321 */ 'B', 't', 'e', 'q', 'z', 'T', '8', 'S', 'l', 't', 'i', 'u', 'X', '1', '6', 0,
  /* 4337 */ 'B', 't', 'n', 'e', 'z', 'T', '8', 'S', 'l', 't', 'u', 'X', '1', '6', 0,
  /* 4352 */ 'B', 't', 'e', 'q', 'z', 'T', '8', 'S', 'l', 't', 'u', 'X', '1', '6', 0,
  /* 4367 */ 'B', 't', 'n', 'e', 'z', 'X', '1', '6', 0,
  /* 4376 */ 'B', 't', 'e', 'q', 'z', 'X', '1', '6', 0,
  /* 4385 */ 'J', 'r', 'c', 'R', 'a', '1', '6', 0,
  /* 4393 */ 'J', 'r', 'R', 'a', '1', '6', 0,
  /* 4400 */ 'R', 'e', 's', 't', 'o', 'r', 'e', '1', '6', 0,
  /* 4410 */ 'G', 'o', 't', 'P', 'r', 'o', 'l', 'o', 'g', 'u', 'e', '1', '6', 0,
  /* 4424 */ 'S', 'a', 'v', 'e', '1', '6', 0,
  /* 4431 */ 'J', 'u', 'm', 'p', 'L', 'i', 'n', 'k', 'R', 'e', 'g', '1', '6', 0,
  /* 4445 */ 'M', 'f', 'h', 'i', '1', '6', 0,
  /* 4452 */ 'B', 'r', 'e', 'a', 'k', '1', '6', 0,
  /* 4460 */ 'J', 'a', 'l', '1', '6', 0,
  /* 4466 */ 'A', 'd', 'd', 'i', 'u', 'S', 'p', 'I', 'm', 'm', '1', '6', 0,
  /* 4479 */ 'L', 'i', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4489 */ 'C', 'm', 'p', 'i', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4501 */ 'S', 'l', 't', 'i', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4513 */ 'S', 'l', 't', 'i', 'u', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4526 */ 'A', 'd', 'd', 'i', 'u', 'R', 'x', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4541 */ 'B', 'n', 'e', 'z', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4553 */ 'B', 'e', 'q', 'z', 'R', 'x', 'I', 'm', 'm', '1', '6', 0,
  /* 4565 */ 'B', 'i', 'm', 'm', '1', '6', 0,
  /* 4572 */ 'M', 'f', 'l', 'o', '1', '6', 0,
  /* 4579 */ 'L', 'w', 'R', 'x', 'P', 'c', 'T', 'c', 'p', '1', '6', 0,
  /* 4591 */ 'S', 'e', 'b', 'R', 'x', '1', '6', 0,
  /* 4599 */ 'J', 'r', 'c', 'R', 'x', '1', '6', 0,
  /* 4607 */ 'S', 'e', 'h', 'R', 'x', '1', '6', 0,
  /* 4615 */ 'S', 'l', 't', 'C', 'C', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4627 */ 'S', 'l', 't', 'u', 'C', 'C', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4640 */ 'N', 'e', 'g', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4650 */ 'C', 'm', 'p', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4660 */ 'S', 'l', 't', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4670 */ 'M', 'u', 'l', 't', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4681 */ 'N', 'o', 't', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4691 */ 'S', 'l', 't', 'u', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4702 */ 'M', 'u', 'l', 't', 'u', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4714 */ 'D', 'i', 'v', 'u', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4725 */ 'S', 'r', 'a', 'v', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4736 */ 'D', 'i', 'v', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4746 */ 'S', 'l', 'l', 'v', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4757 */ 'S', 'r', 'l', 'v', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4768 */ 'A', 'n', 'd', 'R', 'x', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4780 */ 'O', 'r', 'R', 'x', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4791 */ 'X', 'o', 'r', 'R', 'x', 'R', 'x', 'R', 'y', '1', '6', 0,
  /* 4803 */ 'M', 'u', 'l', 't', 'R', 'x', 'R', 'y', 'R', 'z', '1', '6', 0,
  /* 4816 */ 'S', 'u', 'b', 'u', 'R', 'x', 'R', 'y', 'R', 'z', '1', '6', 0,
  /* 4829 */ 'A', 'd', 'd', 'u', 'R', 'x', 'R', 'y', 'R', 'z', '1', '6', 0,
  /* 4842 */ 'S', 'l', 't', 'u', 'R', 'x', 'R', 'y', 'R', 'z', '1', '6', 0,
  /* 4855 */ 'M', 'u', 'l', 't', 'u', 'R', 'x', 'R', 'y', 'R', 'z', '1', '6', 0,
  /* 4869 */ 'B', 't', 'n', 'e', 'z', '1', '6', 0,
  /* 4877 */ 'B', 't', 'e', 'q', 'z', '1', '6', 0,
  /* 4885 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'r', 'e', 'c', 't', 'H', 'a', 'z', 'a', 'r', 'd', 'B', 'r', 'a', 'n', 'c', 'h', '6', '4', 'R', '6', 0,
  /* 4915 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'B', 'r', 'a', 'n', 'c', 'h', '6', '4', 'R', '6', 0,
  /* 4940 */ 'M', 'F', 'C', '0', '_', 'M', 'M', 'R', '6', 0,
  /* 4950 */ 'M', 'F', 'H', 'C', '0', '_', 'M', 'M', 'R', '6', 0,
  /* 4961 */ 'M', 'T', 'H', 'C', '0', '_', 'M', 'M', 'R', '6', 0,
  /* 4972 */ 'M', 'T', 'C', '0', '_', 'M', 'M', 'R', '6', 0,
  /* 4982 */ 'M', 'F', 'C', '1', '_', 'M', 'M', 'R', '6', 0,
  /* 4992 */ 'M', 'T', 'C', '1', '_', 'M', 'M', 'R', '6', 0,
  /* 5002 */ 'L', 'D', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5012 */ 'S', 'D', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5022 */ 'M', 'F', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5032 */ 'M', 'F', 'H', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5043 */ 'M', 'T', 'H', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5054 */ 'M', 'T', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5064 */ 'L', 'W', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5074 */ 'S', 'W', 'C', '2', '_', 'M', 'M', 'R', '6', 0,
  /* 5084 */ 'L', 'D', 'C', '1', '_', 'D', '6', '4', '_', 'M', 'M', 'R', '6', 0,
  /* 5098 */ 'S', 'D', 'C', '1', '_', 'D', '6', '4', '_', 'M', 'M', 'R', '6', 0,
  /* 5112 */ 'S', 'B', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5122 */ 'B', 'C', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5132 */ 'J', 'R', 'C', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5143 */ 'J', 'A', 'L', 'R', 'C', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5156 */ 'B', 'N', 'E', 'Z', 'C', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5169 */ 'B', 'E', 'Q', 'Z', 'C', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5182 */ 'A', 'N', 'D', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5193 */ 'M', 'O', 'V', 'E', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5205 */ 'S', 'H', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5215 */ 'A', 'N', 'D', 'I', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5227 */ 'L', 'I', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5237 */ 'B', 'R', 'E', 'A', 'K', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5250 */ 'S', 'L', 'L', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5261 */ 'S', 'R', 'L', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5272 */ 'L', 'W', 'M', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5283 */ 'S', 'W', 'M', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5294 */ 'S', 'D', 'B', 'B', 'P', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5307 */ 'X', 'O', 'R', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5318 */ 'N', 'O', 'T', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5329 */ 'S', 'U', 'B', 'U', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5341 */ 'A', 'D', 'D', 'U', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5353 */ 'S', 'W', '1', '6', '_', 'M', 'M', 'R', '6', 0,
  /* 5363 */ 'L', 'S', 'A', '_', 'M', 'M', 'R', '6', 0,
  /* 5372 */ 'E', 'H', 'B', '_', 'M', 'M', 'R', '6', 0,
  /* 5381 */ 'J', 'A', 'L', 'R', 'C', '_', 'H', 'B', '_', 'M', 'M', 'R', '6', 0,
  /* 5395 */ 'L', 'B', '_', 'M', 'M', 'R', '6', 0,
  /* 5403 */ 'S', 'B', '_', 'M', 'M', 'R', '6', 0,
  /* 5411 */ 'S', 'U', 'B', '_', 'M', 'M', 'R', '6', 0,
  /* 5420 */ 'B', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5428 */ 'B', 'G', 'E', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5438 */ 'B', 'N', 'E', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5448 */ 'J', 'I', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5457 */ 'B', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5467 */ 'J', 'I', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5478 */ 'B', 'G', 'E', 'Z', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5491 */ 'B', 'L', 'E', 'Z', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5504 */ 'B', 'N', 'E', 'Z', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5517 */ 'B', 'E', 'Q', 'Z', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5530 */ 'B', 'G', 'T', 'Z', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5543 */ 'B', 'L', 'T', 'Z', 'A', 'L', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5556 */ 'E', 'R', 'E', 'T', 'N', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5568 */ 'S', 'Y', 'N', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5578 */ 'A', 'U', 'I', 'P', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5589 */ 'A', 'L', 'U', 'I', 'P', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5601 */ 'A', 'D', 'D', 'I', 'U', 'P', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5614 */ 'L', 'W', 'P', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5624 */ 'B', 'E', 'Q', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5634 */ 'J', 'A', 'L', 'R', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5645 */ 'S', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5653 */ 'B', 'L', 'T', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5663 */ 'B', 'G', 'E', 'U', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5674 */ 'B', 'L', 'T', 'U', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5685 */ 'B', 'N', 'V', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5695 */ 'B', 'O', 'V', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5705 */ 'B', 'G', 'E', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5716 */ 'B', 'L', 'E', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5727 */ 'B', 'C', '1', 'N', 'E', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5740 */ 'B', 'C', '2', 'N', 'E', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5753 */ 'B', 'N', 'E', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5764 */ 'B', 'C', '1', 'E', 'Q', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5777 */ 'B', 'C', '2', 'E', 'Q', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5790 */ 'B', 'E', 'Q', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5801 */ 'B', 'G', 'T', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5812 */ 'B', 'L', 'T', 'Z', 'C', '_', 'M', 'M', 'R', '6', 0,
  /* 5823 */ 'A', 'D', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5832 */ 'A', 'N', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5841 */ 'M', 'O', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5850 */ 'M', 'I', 'N', 'A', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5862 */ 'M', 'A', 'X', 'A', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5874 */ 'C', 'M', 'P', '_', 'S', 'L', 'E', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5889 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'E', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5905 */ 'C', 'M', 'P', '_', 'U', 'L', 'E', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5920 */ 'C', 'M', 'P', '_', 'L', 'E', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5934 */ 'C', 'M', 'P', '_', 'S', 'A', 'F', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5949 */ 'C', 'M', 'P', '_', 'A', 'F', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5963 */ 'M', 'S', 'U', 'B', 'F', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5976 */ 'M', 'A', 'D', 'D', 'F', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 5989 */ 'S', 'E', 'L', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6000 */ 'T', 'R', 'U', 'N', 'C', '_', 'L', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6015 */ 'R', 'O', 'U', 'N', 'D', '_', 'L', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6030 */ 'C', 'E', 'I', 'L', '_', 'L', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6044 */ 'F', 'L', 'O', 'O', 'R', '_', 'L', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6059 */ 'C', 'V', 'T', '_', 'L', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6072 */ 'M', 'I', 'N', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6083 */ 'C', 'M', 'P', '_', 'S', 'U', 'N', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6098 */ 'C', 'M', 'P', '_', 'U', 'N', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6112 */ 'C', 'M', 'P', '_', 'S', 'E', 'Q', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6127 */ 'C', 'M', 'P', '_', 'S', 'U', 'E', 'Q', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6143 */ 'C', 'M', 'P', '_', 'U', 'E', 'Q', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6158 */ 'C', 'M', 'P', '_', 'E', 'Q', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6172 */ 'C', 'L', 'A', 'S', 'S', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6185 */ 'C', 'M', 'P', '_', 'S', 'L', 'T', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6200 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'T', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6216 */ 'C', 'M', 'P', '_', 'U', 'L', 'T', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6231 */ 'C', 'M', 'P', '_', 'L', 'T', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6245 */ 'R', 'I', 'N', 'T', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6257 */ 'F', 'M', 'O', 'V', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6269 */ 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6284 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6299 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6313 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6328 */ 'M', 'A', 'X', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6339 */ 'S', 'E', 'L', 'N', 'E', 'Z', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6353 */ 'S', 'E', 'L', 'E', 'Q', 'Z', '_', 'D', '_', 'M', 'M', 'R', '6', 0,
  /* 6367 */ 'C', 'A', 'C', 'H', 'E', '_', 'M', 'M', 'R', '6', 0,
  /* 6378 */ 'S', 'I', 'G', 'R', 'I', 'E', '_', 'M', 'M', 'R', '6', 0,
  /* 6390 */ 'P', 'A', 'U', 'S', 'E', '_', 'M', 'M', 'R', '6', 0,
  /* 6401 */ 'P', 'R', 'E', 'F', '_', 'M', 'M', 'R', '6', 0,
  /* 6411 */ 'T', 'L', 'B', 'I', 'N', 'V', 'F', '_', 'M', 'M', 'R', '6', 0,
  /* 6424 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', 'E', 'G', '_', 'M', 'M', 'R', '6', 0,
  /* 6441 */ 'W', 'S', 'B', 'H', '_', 'M', 'M', 'R', '6', 0,
  /* 6451 */ 'S', 'H', '_', 'M', 'M', 'R', '6', 0,
  /* 6459 */ 'M', 'U', 'H', '_', 'M', 'M', 'R', '6', 0,
  /* 6468 */ 'S', 'Y', 'N', 'C', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6479 */ 'A', 'N', 'D', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6489 */ 'E', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6497 */ 'X', 'O', 'R', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6507 */ 'A', 'U', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6516 */ 'L', 'U', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6525 */ 'G', 'I', 'N', 'V', 'I', '_', 'M', 'M', 'R', '6', 0,
  /* 6536 */ 'B', 'R', 'E', 'A', 'K', '_', 'M', 'M', 'R', '6', 0,
  /* 6547 */ 'J', 'A', 'L', '_', 'M', 'M', 'R', '6', 0,
  /* 6556 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', '_', 'M', 'M', 'R', '6', 0,
  /* 6570 */ 'S', 'L', 'L', '_', 'M', 'M', 'R', '6', 0,
  /* 6579 */ 'M', 'U', 'L', '_', 'M', 'M', 'R', '6', 0,
  /* 6588 */ 'C', 'V', 'T', '_', 'D', '_', 'L', '_', 'M', 'M', 'R', '6', 0,
  /* 6601 */ 'C', 'V', 'T', '_', 'S', '_', 'L', '_', 'M', 'M', 'R', '6', 0,
  /* 6614 */ 'A', 'L', 'I', 'G', 'N', '_', 'M', 'M', 'R', '6', 0,
  /* 6625 */ 'C', 'L', 'O', '_', 'M', 'M', 'R', '6', 0,
  /* 6634 */ 'B', 'I', 'T', 'S', 'W', 'A', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6647 */ 'S', 'D', 'B', 'B', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6658 */ 'M', 'O', 'V', 'E', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6669 */ 'S', 'S', 'N', 'O', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6680 */ 'J', 'R', 'C', 'A', 'D', 'D', 'I', 'U', 'S', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6696 */ 'S', 'W', 'S', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6706 */ 'D', 'V', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6715 */ 'E', 'V', 'P', '_', 'M', 'M', 'R', '6', 0,
  /* 6724 */ 'N', 'O', 'R', '_', 'M', 'M', 'R', '6', 0,
  /* 6733 */ 'X', 'O', 'R', '_', 'M', 'M', 'R', '6', 0,
  /* 6742 */ 'R', 'D', 'P', 'G', 'P', 'R', '_', 'M', 'M', 'R', '6', 0,
  /* 6754 */ 'W', 'R', 'P', 'G', 'P', 'R', '_', 'M', 'M', 'R', '6', 0,
  /* 6766 */ 'R', 'D', 'H', 'W', 'R', '_', 'M', 'M', 'R', '6', 0,
  /* 6777 */ 'I', 'N', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6786 */ 'M', 'I', 'N', 'A', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6798 */ 'M', 'A', 'X', 'A', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6810 */ 'F', 'S', 'U', 'B', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6822 */ 'F', 'A', 'D', 'D', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6834 */ 'C', 'M', 'P', '_', 'S', 'L', 'E', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6849 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'E', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6865 */ 'C', 'M', 'P', '_', 'U', 'L', 'E', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6880 */ 'C', 'M', 'P', '_', 'L', 'E', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6894 */ 'C', 'M', 'P', '_', 'S', 'A', 'F', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6909 */ 'C', 'M', 'P', '_', 'A', 'F', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6923 */ 'M', 'S', 'U', 'B', 'F', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6936 */ 'M', 'A', 'D', 'D', 'F', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6949 */ 'F', 'N', 'E', 'G', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6961 */ 'S', 'E', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6972 */ 'F', 'M', 'U', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6984 */ 'T', 'R', 'U', 'N', 'C', '_', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 6999 */ 'R', 'O', 'U', 'N', 'D', '_', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7014 */ 'C', 'E', 'I', 'L', '_', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7028 */ 'F', 'L', 'O', 'O', 'R', '_', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7043 */ 'C', 'V', 'T', '_', 'L', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7056 */ 'M', 'I', 'N', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7067 */ 'C', 'M', 'P', '_', 'S', 'U', 'N', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7082 */ 'C', 'M', 'P', '_', 'U', 'N', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7096 */ 'C', 'M', 'P', '_', 'S', 'E', 'Q', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7111 */ 'C', 'M', 'P', '_', 'S', 'U', 'E', 'Q', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7127 */ 'C', 'M', 'P', '_', 'U', 'E', 'Q', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7142 */ 'C', 'M', 'P', '_', 'E', 'Q', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7156 */ 'C', 'L', 'A', 'S', 'S', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7169 */ 'C', 'M', 'P', '_', 'S', 'L', 'T', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7184 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'T', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7200 */ 'C', 'M', 'P', '_', 'U', 'L', 'T', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7215 */ 'C', 'M', 'P', '_', 'L', 'T', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7229 */ 'R', 'I', 'N', 'T', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7241 */ 'F', 'D', 'I', 'V', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7253 */ 'F', 'M', 'O', 'V', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7265 */ 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7280 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7295 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7309 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7324 */ 'C', 'V', 'T', '_', 'W', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7337 */ 'M', 'A', 'X', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7348 */ 'S', 'E', 'L', 'N', 'E', 'Z', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7362 */ 'S', 'E', 'L', 'E', 'Q', 'Z', '_', 'S', '_', 'M', 'M', 'R', '6', 0,
  /* 7376 */ 'D', 'E', 'R', 'E', 'T', '_', 'M', 'M', 'R', '6', 0,
  /* 7387 */ 'W', 'A', 'I', 'T', '_', 'M', 'M', 'R', '6', 0,
  /* 7397 */ 'G', 'I', 'N', 'V', 'T', '_', 'M', 'M', 'R', '6', 0,
  /* 7408 */ 'E', 'X', 'T', '_', 'M', 'M', 'R', '6', 0,
  /* 7417 */ 'L', 'B', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7426 */ 'S', 'U', 'B', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7436 */ 'A', 'D', 'D', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7446 */ 'M', 'O', 'D', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7456 */ 'M', 'U', 'H', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7466 */ 'A', 'D', 'D', 'I', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7477 */ 'M', 'U', 'L', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7487 */ 'D', 'I', 'V', 'U', '_', 'M', 'M', 'R', '6', 0,
  /* 7497 */ 'D', 'I', 'V', '_', 'M', 'M', 'R', '6', 0,
  /* 7506 */ 'T', 'L', 'B', 'I', 'N', 'V', '_', 'M', 'M', 'R', '6', 0,
  /* 7518 */ 'L', 'W', '_', 'M', 'M', 'R', '6', 0,
  /* 7526 */ 'S', 'W', '_', 'M', 'M', 'R', '6', 0,
  /* 7534 */ 'C', 'V', 'T', '_', 'S', '_', 'W', '_', 'M', 'M', 'R', '6', 0,
  /* 7547 */ 'S', 'E', 'L', 'N', 'E', 'Z', '_', 'M', 'M', 'R', '6', 0,
  /* 7559 */ 'C', 'L', 'Z', '_', 'M', 'M', 'R', '6', 0,
  /* 7568 */ 'S', 'E', 'L', 'E', 'Q', 'Z', '_', 'M', 'M', 'R', '6', 0,
  /* 7580 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'B', 'r', 'a', 'n', 'c', 'h', '_', 'M', 'M', 'R', '6', 0,
  /* 7606 */ 'L', 'D', 'C', '2', '_', 'R', '6', 0,
  /* 7614 */ 'S', 'D', 'C', '2', '_', 'R', '6', 0,
  /* 7622 */ 'L', 'W', 'C', '2', '_', 'R', '6', 0,
  /* 7630 */ 'S', 'W', 'C', '2', '_', 'R', '6', 0,
  /* 7638 */ 'J', 'R', '_', 'H', 'B', '6', '4', '_', 'R', '6', 0,
  /* 7649 */ 'S', 'C', '6', '4', '_', 'R', '6', 0,
  /* 7657 */ 'L', 'L', '6', '4', '_', 'R', '6', 0,
  /* 7665 */ 'D', 'L', 'S', 'A', '_', 'R', '6', 0,
  /* 7673 */ 'J', 'R', '_', 'H', 'B', '_', 'R', '6', 0,
  /* 7682 */ 'S', 'C', '_', 'R', '6', 0,
  /* 7688 */ 'S', 'C', 'D', '_', 'R', '6', 0,
  /* 7695 */ 'L', 'L', 'D', '_', 'R', '6', 0,
  /* 7702 */ 'C', 'A', 'C', 'H', 'E', '_', 'R', '6', 0,
  /* 7711 */ 'P', 'R', 'E', 'F', '_', 'R', '6', 0,
  /* 7719 */ 'L', 'L', '_', 'R', '6', 0,
  /* 7725 */ 'D', 'M', 'U', 'L', '_', 'R', '6', 0,
  /* 7733 */ 'D', 'C', 'L', 'O', '_', 'R', '6', 0,
  /* 7741 */ 'S', 'D', 'B', 'B', 'P', '_', 'R', '6', 0,
  /* 7750 */ 'D', 'C', 'L', 'Z', '_', 'R', '6', 0,
  /* 7758 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'r', 'e', 'c', 't', 'H', 'a', 'z', 'a', 'r', 'd', 'B', 'r', 'a', 'n', 'c', 'h', 'R', '6', 0,
  /* 7786 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'B', 'r', 'a', 'n', 'c', 'h', 'R', '6', 0,
  /* 7809 */ 'L', 'O', 'A', 'D', '_', 'A', 'C', 'C', '1', '2', '8', 0,
  /* 7821 */ 'S', 'T', 'O', 'R', 'E', '_', 'A', 'C', 'C', '1', '2', '8', 0,
  /* 7834 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '8', 0,
  /* 7853 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '8', 0,
  /* 7872 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '8', 0,
  /* 7892 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '8', 0,
  /* 7911 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '8', 0,
  /* 7926 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '8', 0,
  /* 7945 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '8', 0,
  /* 7964 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '8', 0,
  /* 7982 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', 'A', 0,
  /* 7997 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', 'A', 0,
  /* 8013 */ 'G', '_', 'F', 'M', 'A', 0,
  /* 8019 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', 'A', 0,
  /* 8034 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', 'A', 0,
  /* 8050 */ 'D', 'S', 'R', 'A', 0,
  /* 8055 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8082 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8109 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8137 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8164 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8187 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8214 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8241 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '3', '2', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8267 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8294 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8321 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8349 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8376 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8399 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8426 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8453 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '6', '4', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8479 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8506 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8533 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8561 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8588 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8611 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8638 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8665 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '1', '6', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8691 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8717 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8743 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8770 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8796 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8818 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8844 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8870 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '8', '_', 'P', 'O', 'S', 'T', 'R', 'A', 0,
  /* 8895 */ 'R', 'e', 't', 'R', 'A', 0,
  /* 8901 */ 'D', 'L', 'S', 'A', 0,
  /* 8906 */ 'C', 'F', 'C', 'M', 'S', 'A', 0,
  /* 8913 */ 'C', 'T', 'C', 'M', 'S', 'A', 0,
  /* 8920 */ 'C', 'R', 'C', '3', '2', 'B', 0,
  /* 8927 */ 'C', 'R', 'C', '3', '2', 'C', 'B', 0,
  /* 8935 */ 'S', 'E', 'B', 0,
  /* 8939 */ 'E', 'H', 'B', 0,
  /* 8943 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', 'E', 'G', 'H', 'B', 0,
  /* 8957 */ 'J', 'R', '_', 'H', 'B', 0,
  /* 8963 */ 'J', 'A', 'L', 'R', '_', 'H', 'B', 0,
  /* 8971 */ 'L', 'B', 0,
  /* 8974 */ 'S', 'H', 'R', 'A', '_', 'Q', 'B', 0,
  /* 8982 */ 'C', 'M', 'P', 'G', 'D', 'U', '_', 'L', 'E', '_', 'Q', 'B', 0,
  /* 8995 */ 'C', 'M', 'P', 'G', 'U', '_', 'L', 'E', '_', 'Q', 'B', 0,
  /* 9007 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'M', 'P', 'U', '_', 'L', 'E', '_', 'Q', 'B', 0,
  /* 9024 */ 'S', 'U', 'B', 'U', 'H', '_', 'Q', 'B', 0,
  /* 9033 */ 'A', 'D', 'D', 'U', 'H', '_', 'Q', 'B', 0,
  /* 9042 */ 'P', 's', 'e', 'u', 'd', 'o', 'P', 'I', 'C', 'K', '_', 'Q', 'B', 0,
  /* 9056 */ 'S', 'H', 'L', 'L', '_', 'Q', 'B', 0,
  /* 9064 */ 'R', 'E', 'P', 'L', '_', 'Q', 'B', 0,
  /* 9072 */ 'S', 'H', 'R', 'L', '_', 'Q', 'B', 0,
  /* 9080 */ 'C', 'M', 'P', 'G', 'D', 'U', '_', 'E', 'Q', '_', 'Q', 'B', 0,
  /* 9093 */ 'C', 'M', 'P', 'G', 'U', '_', 'E', 'Q', '_', 'Q', 'B', 0,
  /* 9105 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'M', 'P', 'U', '_', 'E', 'Q', '_', 'Q', 'B', 0,
  /* 9122 */ 'S', 'H', 'R', 'A', '_', 'R', '_', 'Q', 'B', 0,
  /* 9132 */ 'S', 'U', 'B', 'U', 'H', '_', 'R', '_', 'Q', 'B', 0,
  /* 9143 */ 'A', 'D', 'D', 'U', 'H', '_', 'R', '_', 'Q', 'B', 0,
  /* 9154 */ 'S', 'H', 'R', 'A', 'V', '_', 'R', '_', 'Q', 'B', 0,
  /* 9165 */ 'A', 'B', 'S', 'Q', '_', 'S', '_', 'Q', 'B', 0,
  /* 9175 */ 'S', 'U', 'B', 'U', '_', 'S', '_', 'Q', 'B', 0,
  /* 9185 */ 'A', 'D', 'D', 'U', '_', 'S', '_', 'Q', 'B', 0,
  /* 9195 */ 'C', 'M', 'P', 'G', 'D', 'U', '_', 'L', 'T', '_', 'Q', 'B', 0,
  /* 9208 */ 'C', 'M', 'P', 'G', 'U', '_', 'L', 'T', '_', 'Q', 'B', 0,
  /* 9220 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'M', 'P', 'U', '_', 'L', 'T', '_', 'Q', 'B', 0,
  /* 9237 */ 'S', 'U', 'B', 'U', '_', 'Q', 'B', 0,
  /* 9245 */ 'A', 'D', 'D', 'U', '_', 'Q', 'B', 0,
  /* 9253 */ 'S', 'H', 'R', 'A', 'V', '_', 'Q', 'B', 0,
  /* 9262 */ 'S', 'H', 'L', 'L', 'V', '_', 'Q', 'B', 0,
  /* 9271 */ 'R', 'E', 'P', 'L', 'V', '_', 'Q', 'B', 0,
  /* 9280 */ 'S', 'H', 'R', 'L', 'V', '_', 'Q', 'B', 0,
  /* 9289 */ 'R', 'A', 'D', 'D', 'U', '_', 'W', '_', 'Q', 'B', 0,
  /* 9300 */ 'S', 'B', 0,
  /* 9303 */ 'M', 'O', 'D', 'S', 'U', 'B', 0,
  /* 9310 */ 'G', '_', 'F', 'S', 'U', 'B', 0,
  /* 9317 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'S', 'U', 'B', 0,
  /* 9328 */ 'G', '_', 'S', 'U', 'B', 0,
  /* 9334 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'S', 'U', 'B', 0,
  /* 9350 */ 'S', 'R', 'A', '_', 'B', 0,
  /* 9356 */ 'A', 'D', 'D', '_', 'A', '_', 'B', 0,
  /* 9364 */ 'M', 'I', 'N', '_', 'A', '_', 'B', 0,
  /* 9372 */ 'A', 'D', 'D', 'S', '_', 'A', '_', 'B', 0,
  /* 9381 */ 'M', 'A', 'X', '_', 'A', '_', 'B', 0,
  /* 9389 */ 'N', 'L', 'O', 'C', '_', 'B', 0,
  /* 9396 */ 'N', 'L', 'Z', 'C', '_', 'B', 0,
  /* 9403 */ 'S', 'L', 'D', '_', 'B', 0,
  /* 9409 */ 'P', 'C', 'K', 'O', 'D', '_', 'B', 0,
  /* 9417 */ 'I', 'L', 'V', 'O', 'D', '_', 'B', 0,
  /* 9425 */ 'I', 'N', 'S', 'V', 'E', '_', 'B', 0,
  /* 9433 */ 'V', 'S', 'H', 'F', '_', 'B', 0,
  /* 9440 */ 'B', 'N', 'E', 'G', '_', 'B', 0,
  /* 9447 */ 'S', 'R', 'A', 'I', '_', 'B', 0,
  /* 9454 */ 'S', 'L', 'D', 'I', '_', 'B', 0,
  /* 9461 */ 'A', 'N', 'D', 'I', '_', 'B', 0,
  /* 9468 */ 'B', 'N', 'E', 'G', 'I', '_', 'B', 0,
  /* 9476 */ 'B', 'S', 'E', 'L', 'I', '_', 'B', 0,
  /* 9484 */ 'S', 'L', 'L', 'I', '_', 'B', 0,
  /* 9491 */ 'S', 'R', 'L', 'I', '_', 'B', 0,
  /* 9498 */ 'B', 'I', 'N', 'S', 'L', 'I', '_', 'B', 0,
  /* 9507 */ 'C', 'E', 'Q', 'I', '_', 'B', 0,
  /* 9514 */ 'S', 'R', 'A', 'R', 'I', '_', 'B', 0,
  /* 9522 */ 'B', 'C', 'L', 'R', 'I', '_', 'B', 0,
  /* 9530 */ 'S', 'R', 'L', 'R', 'I', '_', 'B', 0,
  /* 9538 */ 'N', 'O', 'R', 'I', '_', 'B', 0,
  /* 9545 */ 'X', 'O', 'R', 'I', '_', 'B', 0,
  /* 9552 */ 'B', 'I', 'N', 'S', 'R', 'I', '_', 'B', 0,
  /* 9561 */ 'S', 'P', 'L', 'A', 'T', 'I', '_', 'B', 0,
  /* 9570 */ 'B', 'S', 'E', 'T', 'I', '_', 'B', 0,
  /* 9578 */ 'S', 'U', 'B', 'V', 'I', '_', 'B', 0,
  /* 9586 */ 'A', 'D', 'D', 'V', 'I', '_', 'B', 0,
  /* 9594 */ 'B', 'M', 'Z', 'I', '_', 'B', 0,
  /* 9601 */ 'B', 'M', 'N', 'Z', 'I', '_', 'B', 0,
  /* 9609 */ 'F', 'I', 'L', 'L', '_', 'B', 0,
  /* 9616 */ 'S', 'L', 'L', '_', 'B', 0,
  /* 9622 */ 'S', 'R', 'L', '_', 'B', 0,
  /* 9628 */ 'B', 'I', 'N', 'S', 'L', '_', 'B', 0,
  /* 9636 */ 'I', 'L', 'V', 'L', '_', 'B', 0,
  /* 9643 */ 'C', 'E', 'Q', '_', 'B', 0,
  /* 9649 */ 'S', 'R', 'A', 'R', '_', 'B', 0,
  /* 9656 */ 'B', 'C', 'L', 'R', '_', 'B', 0,
  /* 9663 */ 'S', 'R', 'L', 'R', '_', 'B', 0,
  /* 9670 */ 'B', 'I', 'N', 'S', 'R', '_', 'B', 0,
  /* 9678 */ 'I', 'L', 'V', 'R', '_', 'B', 0,
  /* 9685 */ 'A', 'S', 'U', 'B', '_', 'S', '_', 'B', 0,
  /* 9694 */ 'M', 'O', 'D', '_', 'S', '_', 'B', 0,
  /* 9702 */ 'C', 'L', 'E', '_', 'S', '_', 'B', 0,
  /* 9710 */ 'A', 'V', 'E', '_', 'S', '_', 'B', 0,
  /* 9718 */ 'C', 'L', 'E', 'I', '_', 'S', '_', 'B', 0,
  /* 9727 */ 'M', 'I', 'N', 'I', '_', 'S', '_', 'B', 0,
  /* 9736 */ 'C', 'L', 'T', 'I', '_', 'S', '_', 'B', 0,
  /* 9745 */ 'M', 'A', 'X', 'I', '_', 'S', '_', 'B', 0,
  /* 9754 */ 'M', 'I', 'N', '_', 'S', '_', 'B', 0,
  /* 9762 */ 'A', 'V', 'E', 'R', '_', 'S', '_', 'B', 0,
  /* 9771 */ 'S', 'U', 'B', 'S', '_', 'S', '_', 'B', 0,
  /* 9780 */ 'A', 'D', 'D', 'S', '_', 'S', '_', 'B', 0,
  /* 9789 */ 'S', 'A', 'T', '_', 'S', '_', 'B', 0,
  /* 9797 */ 'C', 'L', 'T', '_', 'S', '_', 'B', 0,
  /* 9805 */ 'S', 'U', 'B', 'S', 'U', 'U', '_', 'S', '_', 'B', 0,
  /* 9816 */ 'D', 'I', 'V', '_', 'S', '_', 'B', 0,
  /* 9824 */ 'M', 'A', 'X', '_', 'S', '_', 'B', 0,
  /* 9832 */ 'C', 'O', 'P', 'Y', '_', 'S', '_', 'B', 0,
  /* 9841 */ 'S', 'P', 'L', 'A', 'T', '_', 'B', 0,
  /* 9849 */ 'B', 'S', 'E', 'T', '_', 'B', 0,
  /* 9856 */ 'P', 'C', 'N', 'T', '_', 'B', 0,
  /* 9863 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'B', 0,
  /* 9872 */ 'S', 'T', '_', 'B', 0,
  /* 9877 */ 'A', 'S', 'U', 'B', '_', 'U', '_', 'B', 0,
  /* 9886 */ 'M', 'O', 'D', '_', 'U', '_', 'B', 0,
  /* 9894 */ 'C', 'L', 'E', '_', 'U', '_', 'B', 0,
  /* 9902 */ 'A', 'V', 'E', '_', 'U', '_', 'B', 0,
  /* 9910 */ 'C', 'L', 'E', 'I', '_', 'U', '_', 'B', 0,
  /* 9919 */ 'M', 'I', 'N', 'I', '_', 'U', '_', 'B', 0,
  /* 9928 */ 'C', 'L', 'T', 'I', '_', 'U', '_', 'B', 0,
  /* 9937 */ 'M', 'A', 'X', 'I', '_', 'U', '_', 'B', 0,
  /* 9946 */ 'M', 'I', 'N', '_', 'U', '_', 'B', 0,
  /* 9954 */ 'A', 'V', 'E', 'R', '_', 'U', '_', 'B', 0,
  /* 9963 */ 'S', 'U', 'B', 'S', '_', 'U', '_', 'B', 0,
  /* 9972 */ 'A', 'D', 'D', 'S', '_', 'U', '_', 'B', 0,
  /* 9981 */ 'S', 'U', 'B', 'S', 'U', 'S', '_', 'U', '_', 'B', 0,
  /* 9992 */ 'S', 'A', 'T', '_', 'U', '_', 'B', 0,
  /* 10000 */ 'C', 'L', 'T', '_', 'U', '_', 'B', 0,
  /* 10008 */ 'D', 'I', 'V', '_', 'U', '_', 'B', 0,
  /* 10016 */ 'M', 'A', 'X', '_', 'U', '_', 'B', 0,
  /* 10024 */ 'C', 'O', 'P', 'Y', '_', 'U', '_', 'B', 0,
  /* 10033 */ 'M', 'S', 'U', 'B', 'V', '_', 'B', 0,
  /* 10041 */ 'M', 'A', 'D', 'D', 'V', '_', 'B', 0,
  /* 10049 */ 'P', 'C', 'K', 'E', 'V', '_', 'B', 0,
  /* 10057 */ 'I', 'L', 'V', 'E', 'V', '_', 'B', 0,
  /* 10065 */ 'M', 'U', 'L', 'V', '_', 'B', 0,
  /* 10072 */ 'B', 'Z', '_', 'B', 0,
  /* 10077 */ 'B', 'N', 'Z', '_', 'B', 0,
  /* 10083 */ 'B', 'C', 0,
  /* 10086 */ 'B', 'G', 'E', 'C', 0,
  /* 10091 */ 'B', 'N', 'E', 'C', 0,
  /* 10096 */ 'J', 'I', 'C', 0,
  /* 10100 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', 0,
  /* 10112 */ 'B', 'A', 'L', 'C', 0,
  /* 10117 */ 'J', 'I', 'A', 'L', 'C', 0,
  /* 10123 */ 'B', 'G', 'E', 'Z', 'A', 'L', 'C', 0,
  /* 10131 */ 'B', 'L', 'E', 'Z', 'A', 'L', 'C', 0,
  /* 10139 */ 'B', 'N', 'E', 'Z', 'A', 'L', 'C', 0,
  /* 10147 */ 'B', 'E', 'Q', 'Z', 'A', 'L', 'C', 0,
  /* 10155 */ 'B', 'G', 'T', 'Z', 'A', 'L', 'C', 0,
  /* 10163 */ 'B', 'L', 'T', 'Z', 'A', 'L', 'C', 0,
  /* 10171 */ 'E', 'R', 'E', 'T', 'N', 'C', 0,
  /* 10178 */ 'G', '_', 'F', 'P', 'T', 'R', 'U', 'N', 'C', 0,
  /* 10188 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 10206 */ 'G', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 10214 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 10235 */ 'S', 'Y', 'N', 'C', 0,
  /* 10240 */ 'L', 'D', 'P', 'C', 0,
  /* 10245 */ 'A', 'U', 'I', 'P', 'C', 0,
  /* 10251 */ 'A', 'L', 'U', 'I', 'P', 'C', 0,
  /* 10258 */ 'A', 'D', 'D', 'I', 'U', 'P', 'C', 0,
  /* 10266 */ 'L', 'W', 'U', 'P', 'C', 0,
  /* 10272 */ 'L', 'W', 'P', 'C', 0,
  /* 10277 */ 'B', 'E', 'Q', 'C', 0,
  /* 10282 */ 'A', 'D', 'D', 'S', 'C', 0,
  /* 10288 */ 'B', 'L', 'T', 'C', 0,
  /* 10293 */ 'B', 'G', 'E', 'U', 'C', 0,
  /* 10299 */ 'B', 'L', 'T', 'U', 'C', 0,
  /* 10305 */ 'B', 'N', 'V', 'C', 0,
  /* 10310 */ 'B', 'O', 'V', 'C', 0,
  /* 10315 */ 'A', 'D', 'D', 'W', 'C', 0,
  /* 10321 */ 'B', 'G', 'E', 'Z', 'C', 0,
  /* 10327 */ 'B', 'L', 'E', 'Z', 'C', 0,
  /* 10333 */ 'B', 'N', 'E', 'Z', 'C', 0,
  /* 10339 */ 'B', 'E', 'Q', 'Z', 'C', 0,
  /* 10345 */ 'B', 'G', 'T', 'Z', 'C', 0,
  /* 10351 */ 'B', 'L', 'T', 'Z', 'C', 0,
  /* 10357 */ 'C', 'R', 'C', '3', '2', 'D', 0,
  /* 10364 */ 'G', '_', 'S', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 10375 */ 'G', '_', 'Z', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 10386 */ 'G', '_', 'L', 'O', 'A', 'D', 0,
  /* 10393 */ 'C', 'R', 'C', '3', '2', 'C', 'D', 0,
  /* 10401 */ 'S', 'C', 'D', 0,
  /* 10405 */ 'D', 'A', 'D', 'D', 0,
  /* 10410 */ 'G', '_', 'F', 'A', 'D', 'D', 0,
  /* 10417 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'A', 'D', 'D', 0,
  /* 10428 */ 'G', '_', 'A', 'D', 'D', 0,
  /* 10434 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'D', 'D', 0,
  /* 10450 */ 'D', 'S', 'H', 'D', 0,
  /* 10455 */ 'Y', 'I', 'E', 'L', 'D', 0,
  /* 10461 */ 'L', 'L', 'D', 0,
  /* 10465 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'N', 'A', 'N', 'D', 0,
  /* 10482 */ 'G', '_', 'A', 'N', 'D', 0,
  /* 10488 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'N', 'D', 0,
  /* 10504 */ 'P', 'R', 'E', 'P', 'E', 'N', 'D', 0,
  /* 10512 */ 'A', 'P', 'P', 'E', 'N', 'D', 0,
  /* 10519 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'E', 'N', 'D', 0,
  /* 10532 */ 'G', '_', 'B', 'R', 'C', 'O', 'N', 'D', 0,
  /* 10541 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'R', 'O', 'U', 'N', 'D', 0,
  /* 10559 */ 'D', 'M', 'O', 'D', 0,
  /* 10564 */ 'L', 'O', 'A', 'D', '_', 'S', 'T', 'A', 'C', 'K', '_', 'G', 'U', 'A', 'R', 'D', 0,
  /* 10581 */ 'S', 'D', 0,
  /* 10584 */ 'F', 'L', 'O', 'G', '2', '_', 'D', 0,
  /* 10592 */ 'F', 'E', 'X', 'P', '2', '_', 'D', 0,
  /* 10600 */ 'M', 'I', 'N', 'A', '_', 'D', 0,
  /* 10607 */ 'S', 'R', 'A', '_', 'D', 0,
  /* 10613 */ 'M', 'A', 'X', 'A', '_', 'D', 0,
  /* 10620 */ 'A', 'D', 'D', '_', 'A', '_', 'D', 0,
  /* 10628 */ 'F', 'M', 'I', 'N', '_', 'A', '_', 'D', 0,
  /* 10637 */ 'A', 'D', 'D', 'S', '_', 'A', '_', 'D', 0,
  /* 10646 */ 'F', 'M', 'A', 'X', '_', 'A', '_', 'D', 0,
  /* 10655 */ 'F', 'S', 'U', 'B', '_', 'D', 0,
  /* 10662 */ 'F', 'M', 'S', 'U', 'B', '_', 'D', 0,
  /* 10670 */ 'N', 'L', 'O', 'C', '_', 'D', 0,
  /* 10677 */ 'N', 'L', 'Z', 'C', '_', 'D', 0,
  /* 10684 */ 'F', 'A', 'D', 'D', '_', 'D', 0,
  /* 10691 */ 'F', 'M', 'A', 'D', 'D', '_', 'D', 0,
  /* 10699 */ 'S', 'L', 'D', '_', 'D', 0,
  /* 10705 */ 'P', 'C', 'K', 'O', 'D', '_', 'D', 0,
  /* 10713 */ 'I', 'L', 'V', 'O', 'D', '_', 'D', 0,
  /* 10721 */ 'F', 'C', 'L', 'E', '_', 'D', 0,
  /* 10728 */ 'F', 'S', 'L', 'E', '_', 'D', 0,
  /* 10735 */ 'C', 'M', 'P', '_', 'S', 'L', 'E', '_', 'D', 0,
  /* 10745 */ 'F', 'C', 'U', 'L', 'E', '_', 'D', 0,
  /* 10753 */ 'F', 'S', 'U', 'L', 'E', '_', 'D', 0,
  /* 10761 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'E', '_', 'D', 0,
  /* 10772 */ 'C', 'M', 'P', '_', 'U', 'L', 'E', '_', 'D', 0,
  /* 10782 */ 'C', 'M', 'P', '_', 'L', 'E', '_', 'D', 0,
  /* 10791 */ 'F', 'C', 'N', 'E', '_', 'D', 0,
  /* 10798 */ 'F', 'S', 'N', 'E', '_', 'D', 0,
  /* 10805 */ 'F', 'C', 'U', 'N', 'E', '_', 'D', 0,
  /* 10813 */ 'F', 'S', 'U', 'N', 'E', '_', 'D', 0,
  /* 10821 */ 'I', 'N', 'S', 'V', 'E', '_', 'D', 0,
  /* 10829 */ 'F', 'C', 'A', 'F', '_', 'D', 0,
  /* 10836 */ 'F', 'S', 'A', 'F', '_', 'D', 0,
  /* 10843 */ 'C', 'M', 'P', '_', 'S', 'A', 'F', '_', 'D', 0,
  /* 10853 */ 'M', 'S', 'U', 'B', 'F', '_', 'D', 0,
  /* 10861 */ 'M', 'A', 'D', 'D', 'F', '_', 'D', 0,
  /* 10869 */ 'V', 'S', 'H', 'F', '_', 'D', 0,
  /* 10876 */ 'C', 'M', 'P', '_', 'F', '_', 'D', 0,
  /* 10884 */ 'B', 'N', 'E', 'G', '_', 'D', 0,
  /* 10891 */ 'S', 'R', 'A', 'I', '_', 'D', 0,
  /* 10898 */ 'S', 'L', 'D', 'I', '_', 'D', 0,
  /* 10905 */ 'B', 'N', 'E', 'G', 'I', '_', 'D', 0,
  /* 10913 */ 'S', 'L', 'L', 'I', '_', 'D', 0,
  /* 10920 */ 'S', 'R', 'L', 'I', '_', 'D', 0,
  /* 10927 */ 'B', 'I', 'N', 'S', 'L', 'I', '_', 'D', 0,
  /* 10936 */ 'C', 'E', 'Q', 'I', '_', 'D', 0,
  /* 10943 */ 'S', 'R', 'A', 'R', 'I', '_', 'D', 0,
  /* 10951 */ 'B', 'C', 'L', 'R', 'I', '_', 'D', 0,
  /* 10959 */ 'S', 'R', 'L', 'R', 'I', '_', 'D', 0,
  /* 10967 */ 'B', 'I', 'N', 'S', 'R', 'I', '_', 'D', 0,
  /* 10976 */ 'S', 'P', 'L', 'A', 'T', 'I', '_', 'D', 0,
  /* 10985 */ 'B', 'S', 'E', 'T', 'I', '_', 'D', 0,
  /* 10993 */ 'S', 'U', 'B', 'V', 'I', '_', 'D', 0,
  /* 11001 */ 'A', 'D', 'D', 'V', 'I', '_', 'D', 0,
  /* 11009 */ 'S', 'E', 'L', '_', 'D', 0,
  /* 11015 */ 'F', 'I', 'L', 'L', '_', 'D', 0,
  /* 11022 */ 'S', 'L', 'L', '_', 'D', 0,
  /* 11028 */ 'F', 'E', 'X', 'U', 'P', 'L', '_', 'D', 0,
  /* 11037 */ 'F', 'F', 'Q', 'L', '_', 'D', 0,
  /* 11044 */ 'S', 'R', 'L', '_', 'D', 0,
  /* 11050 */ 'B', 'I', 'N', 'S', 'L', '_', 'D', 0,
  /* 11058 */ 'F', 'M', 'U', 'L', '_', 'D', 0,
  /* 11065 */ 'I', 'L', 'V', 'L', '_', 'D', 0,
  /* 11072 */ 'F', 'M', 'I', 'N', '_', 'D', 0,
  /* 11079 */ 'F', 'C', 'U', 'N', '_', 'D', 0,
  /* 11086 */ 'F', 'S', 'U', 'N', '_', 'D', 0,
  /* 11093 */ 'C', 'M', 'P', '_', 'S', 'U', 'N', '_', 'D', 0,
  /* 11103 */ 'C', 'M', 'P', '_', 'U', 'N', '_', 'D', 0,
  /* 11112 */ 'F', 'R', 'C', 'P', '_', 'D', 0,
  /* 11119 */ 'F', 'C', 'E', 'Q', '_', 'D', 0,
  /* 11126 */ 'F', 'S', 'E', 'Q', '_', 'D', 0,
  /* 11133 */ 'C', 'M', 'P', '_', 'S', 'E', 'Q', '_', 'D', 0,
  /* 11143 */ 'F', 'C', 'U', 'E', 'Q', '_', 'D', 0,
  /* 11151 */ 'F', 'S', 'U', 'E', 'Q', '_', 'D', 0,
  /* 11159 */ 'C', 'M', 'P', '_', 'S', 'U', 'E', 'Q', '_', 'D', 0,
  /* 11170 */ 'C', 'M', 'P', '_', 'U', 'E', 'Q', '_', 'D', 0,
  /* 11180 */ 'C', 'M', 'P', '_', 'E', 'Q', '_', 'D', 0,
  /* 11189 */ 'S', 'R', 'A', 'R', '_', 'D', 0,
  /* 11196 */ 'B', 'C', 'L', 'R', '_', 'D', 0,
  /* 11203 */ 'S', 'R', 'L', 'R', '_', 'D', 0,
  /* 11210 */ 'F', 'C', 'O', 'R', '_', 'D', 0,
  /* 11217 */ 'F', 'S', 'O', 'R', '_', 'D', 0,
  /* 11224 */ 'F', 'E', 'X', 'U', 'P', 'R', '_', 'D', 0,
  /* 11233 */ 'F', 'F', 'Q', 'R', '_', 'D', 0,
  /* 11240 */ 'B', 'I', 'N', 'S', 'R', '_', 'D', 0,
  /* 11248 */ 'I', 'L', 'V', 'R', '_', 'D', 0,
  /* 11255 */ 'F', 'A', 'B', 'S', '_', 'D', 0,
  /* 11262 */ 'F', 'C', 'L', 'A', 'S', 'S', '_', 'D', 0,
  /* 11271 */ 'A', 'S', 'U', 'B', '_', 'S', '_', 'D', 0,
  /* 11280 */ 'H', 'S', 'U', 'B', '_', 'S', '_', 'D', 0,
  /* 11289 */ 'D', 'P', 'S', 'U', 'B', '_', 'S', '_', 'D', 0,
  /* 11299 */ 'F', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'D', 0,
  /* 11310 */ 'H', 'A', 'D', 'D', '_', 'S', '_', 'D', 0,
  /* 11319 */ 'D', 'P', 'A', 'D', 'D', '_', 'S', '_', 'D', 0,
  /* 11329 */ 'M', 'O', 'D', '_', 'S', '_', 'D', 0,
  /* 11337 */ 'C', 'L', 'E', '_', 'S', '_', 'D', 0,
  /* 11345 */ 'A', 'V', 'E', '_', 'S', '_', 'D', 0,
  /* 11353 */ 'C', 'L', 'E', 'I', '_', 'S', '_', 'D', 0,
  /* 11362 */ 'M', 'I', 'N', 'I', '_', 'S', '_', 'D', 0,
  /* 11371 */ 'C', 'L', 'T', 'I', '_', 'S', '_', 'D', 0,
  /* 11380 */ 'M', 'A', 'X', 'I', '_', 'S', '_', 'D', 0,
  /* 11389 */ 'M', 'I', 'N', '_', 'S', '_', 'D', 0,
  /* 11397 */ 'D', 'O', 'T', 'P', '_', 'S', '_', 'D', 0,
  /* 11406 */ 'A', 'V', 'E', 'R', '_', 'S', '_', 'D', 0,
  /* 11415 */ 'S', 'U', 'B', 'S', '_', 'S', '_', 'D', 0,
  /* 11424 */ 'A', 'D', 'D', 'S', '_', 'S', '_', 'D', 0,
  /* 11433 */ 'S', 'A', 'T', '_', 'S', '_', 'D', 0,
  /* 11441 */ 'C', 'L', 'T', '_', 'S', '_', 'D', 0,
  /* 11449 */ 'F', 'F', 'I', 'N', 'T', '_', 'S', '_', 'D', 0,
  /* 11459 */ 'F', 'T', 'I', 'N', 'T', '_', 'S', '_', 'D', 0,
  /* 11469 */ 'S', 'U', 'B', 'S', 'U', 'U', '_', 'S', '_', 'D', 0,
  /* 11480 */ 'D', 'I', 'V', '_', 'S', '_', 'D', 0,
  /* 11488 */ 'M', 'A', 'X', '_', 'S', '_', 'D', 0,
  /* 11496 */ 'C', 'O', 'P', 'Y', '_', 'S', '_', 'D', 0,
  /* 11505 */ 'S', 'P', 'L', 'A', 'T', '_', 'D', 0,
  /* 11513 */ 'B', 'S', 'E', 'T', '_', 'D', 0,
  /* 11520 */ 'F', 'C', 'L', 'T', '_', 'D', 0,
  /* 11527 */ 'F', 'S', 'L', 'T', '_', 'D', 0,
  /* 11534 */ 'C', 'M', 'P', '_', 'S', 'L', 'T', '_', 'D', 0,
  /* 11544 */ 'F', 'C', 'U', 'L', 'T', '_', 'D', 0,
  /* 11552 */ 'F', 'S', 'U', 'L', 'T', '_', 'D', 0,
  /* 11560 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'T', '_', 'D', 0,
  /* 11571 */ 'C', 'M', 'P', '_', 'U', 'L', 'T', '_', 'D', 0,
  /* 11581 */ 'C', 'M', 'P', '_', 'L', 'T', '_', 'D', 0,
  /* 11590 */ 'P', 'C', 'N', 'T', '_', 'D', 0,
  /* 11597 */ 'F', 'R', 'I', 'N', 'T', '_', 'D', 0,
  /* 11605 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'D', 0,
  /* 11614 */ 'F', 'S', 'Q', 'R', 'T', '_', 'D', 0,
  /* 11622 */ 'F', 'R', 'S', 'Q', 'R', 'T', '_', 'D', 0,
  /* 11631 */ 'S', 'T', '_', 'D', 0,
  /* 11636 */ 'A', 'S', 'U', 'B', '_', 'U', '_', 'D', 0,
  /* 11645 */ 'H', 'S', 'U', 'B', '_', 'U', '_', 'D', 0,
  /* 11654 */ 'D', 'P', 'S', 'U', 'B', '_', 'U', '_', 'D', 0,
  /* 11664 */ 'F', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'D', 0,
  /* 11675 */ 'H', 'A', 'D', 'D', '_', 'U', '_', 'D', 0,
  /* 11684 */ 'D', 'P', 'A', 'D', 'D', '_', 'U', '_', 'D', 0,
  /* 11694 */ 'M', 'O', 'D', '_', 'U', '_', 'D', 0,
  /* 11702 */ 'C', 'L', 'E', '_', 'U', '_', 'D', 0,
  /* 11710 */ 'A', 'V', 'E', '_', 'U', '_', 'D', 0,
  /* 11718 */ 'C', 'L', 'E', 'I', '_', 'U', '_', 'D', 0,
  /* 11727 */ 'M', 'I', 'N', 'I', '_', 'U', '_', 'D', 0,
  /* 11736 */ 'C', 'L', 'T', 'I', '_', 'U', '_', 'D', 0,
  /* 11745 */ 'M', 'A', 'X', 'I', '_', 'U', '_', 'D', 0,
  /* 11754 */ 'M', 'I', 'N', '_', 'U', '_', 'D', 0,
  /* 11762 */ 'D', 'O', 'T', 'P', '_', 'U', '_', 'D', 0,
  /* 11771 */ 'A', 'V', 'E', 'R', '_', 'U', '_', 'D', 0,
  /* 11780 */ 'S', 'U', 'B', 'S', '_', 'U', '_', 'D', 0,
  /* 11789 */ 'A', 'D', 'D', 'S', '_', 'U', '_', 'D', 0,
  /* 11798 */ 'S', 'U', 'B', 'S', 'U', 'S', '_', 'U', '_', 'D', 0,
  /* 11809 */ 'S', 'A', 'T', '_', 'U', '_', 'D', 0,
  /* 11817 */ 'C', 'L', 'T', '_', 'U', '_', 'D', 0,
  /* 11825 */ 'F', 'F', 'I', 'N', 'T', '_', 'U', '_', 'D', 0,
  /* 11835 */ 'F', 'T', 'I', 'N', 'T', '_', 'U', '_', 'D', 0,
  /* 11845 */ 'D', 'I', 'V', '_', 'U', '_', 'D', 0,
  /* 11853 */ 'M', 'A', 'X', '_', 'U', '_', 'D', 0,
  /* 11861 */ 'M', 'S', 'U', 'B', 'V', '_', 'D', 0,
  /* 11869 */ 'M', 'A', 'D', 'D', 'V', '_', 'D', 0,
  /* 11877 */ 'P', 'C', 'K', 'E', 'V', '_', 'D', 0,
  /* 11885 */ 'I', 'L', 'V', 'E', 'V', '_', 'D', 0,
  /* 11893 */ 'F', 'D', 'I', 'V', '_', 'D', 0,
  /* 11900 */ 'M', 'U', 'L', 'V', '_', 'D', 0,
  /* 11907 */ 'P', 's', 'e', 'u', 'd', 'o', 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'D', 0,
  /* 11923 */ 'F', 'M', 'A', 'X', '_', 'D', 0,
  /* 11930 */ 'B', 'Z', '_', 'D', 0,
  /* 11935 */ 'S', 'E', 'L', 'N', 'E', 'Z', '_', 'D', 0,
  /* 11944 */ 'B', 'N', 'Z', '_', 'D', 0,
  /* 11950 */ 'S', 'E', 'L', 'E', 'Q', 'Z', '_', 'D', 0,
  /* 11959 */ 'L', 'B', 'E', 0,
  /* 11963 */ 'S', 'B', 'E', 0,
  /* 11967 */ 'G', '_', 'S', 'S', 'U', 'B', 'E', 0,
  /* 11975 */ 'G', '_', 'U', 'S', 'U', 'B', 'E', 0,
  /* 11983 */ 'G', '_', 'F', 'E', 'N', 'C', 'E', 0,
  /* 11991 */ 'R', 'E', 'G', '_', 'S', 'E', 'Q', 'U', 'E', 'N', 'C', 'E', 0,
  /* 12004 */ 'S', 'C', 'E', 0,
  /* 12008 */ 'G', '_', 'S', 'A', 'D', 'D', 'E', 0,
  /* 12016 */ 'G', '_', 'U', 'A', 'D', 'D', 'E', 0,
  /* 12024 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 12039 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 12054 */ 'C', 'A', 'C', 'H', 'E', 'E', 0,
  /* 12061 */ 'P', 'R', 'E', 'F', 'E', 0,
  /* 12067 */ 'B', 'G', 'E', 0,
  /* 12071 */ 'S', 'G', 'E', 0,
  /* 12075 */ 'T', 'G', 'E', 0,
  /* 12079 */ 'C', 'A', 'C', 'H', 'E', 0,
  /* 12085 */ 'L', 'H', 'E', 0,
  /* 12089 */ 'S', 'H', 'E', 0,
  /* 12093 */ 'S', 'I', 'G', 'R', 'I', 'E', 0,
  /* 12100 */ 'G', '_', 'J', 'U', 'M', 'P', '_', 'T', 'A', 'B', 'L', 'E', 0,
  /* 12113 */ 'B', 'U', 'N', 'D', 'L', 'E', 0,
  /* 12120 */ 'L', 'L', 'E', 0,
  /* 12124 */ 'L', 'W', 'L', 'E', 0,
  /* 12129 */ 'S', 'W', 'L', 'E', 0,
  /* 12134 */ 'B', 'N', 'E', 0,
  /* 12138 */ 'S', 'N', 'E', 0,
  /* 12142 */ 'T', 'N', 'E', 0,
  /* 12146 */ 'L', 'O', 'C', 'A', 'L', '_', 'E', 'S', 'C', 'A', 'P', 'E', 0,
  /* 12159 */ 'D', 'V', 'P', 'E', 0,
  /* 12164 */ 'E', 'V', 'P', 'E', 0,
  /* 12169 */ 'G', '_', 'S', 'T', 'O', 'R', 'E', 0,
  /* 12177 */ 'L', 'W', 'R', 'E', 0,
  /* 12182 */ 'S', 'W', 'R', 'E', 0,
  /* 12187 */ 'P', 'A', 'U', 'S', 'E', 0,
  /* 12193 */ 'D', 'B', 'G', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 12203 */ 'G', '_', 'G', 'L', 'O', 'B', 'A', 'L', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 12218 */ 'L', 'W', 'E', 0,
  /* 12222 */ 'S', 'W', 'E', 0,
  /* 12226 */ 'G', '_', 'F', 'C', 'A', 'N', 'O', 'N', 'I', 'C', 'A', 'L', 'I', 'Z', 'E', 0,
  /* 12242 */ 'L', 'B', 'u', 'E', 0,
  /* 12247 */ 'L', 'H', 'u', 'E', 0,
  /* 12252 */ 'B', 'C', '1', 'F', 0,
  /* 12257 */ 'G', '_', 'C', 'T', 'L', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 12275 */ 'G', '_', 'C', 'T', 'T', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 12293 */ 'G', '_', 'I', 'M', 'P', 'L', 'I', 'C', 'I', 'T', '_', 'D', 'E', 'F', 0,
  /* 12308 */ 'P', 'R', 'E', 'F', 0,
  /* 12313 */ 'T', 'L', 'B', 'I', 'N', 'V', 'F', 0,
  /* 12321 */ 'T', 'L', 'B', 'G', 'I', 'N', 'V', 'F', 0,
  /* 12330 */ 'G', '_', 'F', 'N', 'E', 'G', 0,
  /* 12337 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'H', 'B', '6', '4', 'R', '6', 'R', 'E', 'G', 0,
  /* 12355 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', '6', '4', 'R', '6', 'R', 'E', 'G', 0,
  /* 12371 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'H', 'B', 'R', '6', 'R', 'E', 'G', 0,
  /* 12387 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', '6', 'R', 'E', 'G', 0,
  /* 12401 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 12416 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 12430 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', 'E', 'G', 0,
  /* 12442 */ 'S', 'U', 'B', 'R', 'E', 'G', '_', 'T', 'O', '_', 'R', 'E', 'G', 0,
  /* 12456 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', 0,
  /* 12473 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', 0,
  /* 12490 */ 'G', '_', 'F', 'L', 'O', 'G', 0,
  /* 12497 */ 'G', '_', 'V', 'A', 'A', 'R', 'G', 0,
  /* 12505 */ 'C', 'R', 'C', '3', '2', 'H', 0,
  /* 12512 */ 'D', 'S', 'B', 'H', 0,
  /* 12517 */ 'W', 'S', 'B', 'H', 0,
  /* 12522 */ 'C', 'R', 'C', '3', '2', 'C', 'H', 0,
  /* 12530 */ 'S', 'E', 'H', 0,
  /* 12534 */ 'G', '_', 'S', 'M', 'U', 'L', 'H', 0,
  /* 12542 */ 'G', '_', 'U', 'M', 'U', 'L', 'H', 0,
  /* 12550 */ 'S', 'H', 'R', 'A', '_', 'P', 'H', 0,
  /* 12558 */ 'P', 'R', 'E', 'C', 'R', 'Q', '_', 'Q', 'B', '_', 'P', 'H', 0,
  /* 12571 */ 'P', 'R', 'E', 'C', 'R', '_', 'Q', 'B', '_', 'P', 'H', 0,
  /* 12583 */ 'P', 'R', 'E', 'C', 'R', 'Q', 'U', '_', 'S', '_', 'Q', 'B', '_', 'P', 'H', 0,
  /* 12599 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'M', 'P', '_', 'L', 'E', '_', 'P', 'H', 0,
  /* 12615 */ 'S', 'U', 'B', 'Q', 'H', '_', 'P', 'H', 0,
  /* 12624 */ 'A', 'D', 'D', 'Q', 'H', '_', 'P', 'H', 0,
  /* 12633 */ 'P', 's', 'e', 'u', 'd', 'o', 'P', 'I', 'C', 'K', '_', 'P', 'H', 0,
  /* 12647 */ 'S', 'H', 'L', 'L', '_', 'P', 'H', 0,
  /* 12655 */ 'R', 'E', 'P', 'L', '_', 'P', 'H', 0,
  /* 12663 */ 'S', 'H', 'R', 'L', '_', 'P', 'H', 0,
  /* 12671 */ 'P', 'A', 'C', 'K', 'R', 'L', '_', 'P', 'H', 0,
  /* 12681 */ 'M', 'U', 'L', '_', 'P', 'H', 0,
  /* 12688 */ 'S', 'U', 'B', 'Q', '_', 'P', 'H', 0,
  /* 12696 */ 'A', 'D', 'D', 'Q', '_', 'P', 'H', 0,
  /* 12704 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'M', 'P', '_', 'E', 'Q', '_', 'P', 'H', 0,
  /* 12720 */ 'S', 'H', 'R', 'A', '_', 'R', '_', 'P', 'H', 0,
  /* 12730 */ 'S', 'U', 'B', 'Q', 'H', '_', 'R', '_', 'P', 'H', 0,
  /* 12741 */ 'A', 'D', 'D', 'Q', 'H', '_', 'R', '_', 'P', 'H', 0,
  /* 12752 */ 'S', 'H', 'R', 'A', 'V', '_', 'R', '_', 'P', 'H', 0,
  /* 12763 */ 'M', 'U', 'L', 'Q', '_', 'R', 'S', '_', 'P', 'H', 0,
  /* 12774 */ 'S', 'H', 'L', 'L', '_', 'S', '_', 'P', 'H', 0,
  /* 12784 */ 'M', 'U', 'L', '_', 'S', '_', 'P', 'H', 0,
  /* 12793 */ 'S', 'U', 'B', 'Q', '_', 'S', '_', 'P', 'H', 0,
  /* 12803 */ 'A', 'D', 'D', 'Q', '_', 'S', '_', 'P', 'H', 0,
  /* 12813 */ 'M', 'U', 'L', 'Q', '_', 'S', '_', 'P', 'H', 0,
  /* 12823 */ 'A', 'B', 'S', 'Q', '_', 'S', '_', 'P', 'H', 0,
  /* 12833 */ 'S', 'U', 'B', 'U', '_', 'S', '_', 'P', 'H', 0,
  /* 12843 */ 'A', 'D', 'D', 'U', '_', 'S', '_', 'P', 'H', 0,
  /* 12853 */ 'S', 'H', 'L', 'L', 'V', '_', 'S', '_', 'P', 'H', 0,
  /* 12864 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'M', 'P', '_', 'L', 'T', '_', 'P', 'H', 0,
  /* 12880 */ 'S', 'U', 'B', 'U', '_', 'P', 'H', 0,
  /* 12888 */ 'A', 'D', 'D', 'U', '_', 'P', 'H', 0,
  /* 12896 */ 'S', 'H', 'R', 'A', 'V', '_', 'P', 'H', 0,
  /* 12905 */ 'S', 'H', 'L', 'L', 'V', '_', 'P', 'H', 0,
  /* 12914 */ 'R', 'E', 'P', 'L', 'V', '_', 'P', 'H', 0,
  /* 12923 */ 'S', 'H', 'R', 'L', 'V', '_', 'P', 'H', 0,
  /* 12932 */ 'D', 'P', 'A', '_', 'W', '_', 'P', 'H', 0,
  /* 12941 */ 'M', 'U', 'L', 'S', 'A', '_', 'W', '_', 'P', 'H', 0,
  /* 12952 */ 'D', 'P', 'A', 'Q', 'X', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', 0,
  /* 12966 */ 'D', 'P', 'S', 'Q', 'X', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', 0,
  /* 12980 */ 'D', 'P', 'S', '_', 'W', '_', 'P', 'H', 0,
  /* 12989 */ 'D', 'P', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 0,
  /* 13001 */ 'M', 'U', 'L', 'S', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 0,
  /* 13015 */ 'D', 'P', 'S', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 0,
  /* 13027 */ 'D', 'P', 'A', 'Q', 'X', '_', 'S', '_', 'W', '_', 'P', 'H', 0,
  /* 13040 */ 'D', 'P', 'S', 'Q', 'X', '_', 'S', '_', 'W', '_', 'P', 'H', 0,
  /* 13053 */ 'D', 'P', 'A', 'X', '_', 'W', '_', 'P', 'H', 0,
  /* 13063 */ 'D', 'P', 'S', 'X', '_', 'W', '_', 'P', 'H', 0,
  /* 13073 */ 'S', 'H', 0,
  /* 13076 */ 'D', 'M', 'U', 'H', 0,
  /* 13081 */ 'S', 'R', 'A', '_', 'H', 0,
  /* 13087 */ 'A', 'D', 'D', '_', 'A', '_', 'H', 0,
  /* 13095 */ 'M', 'I', 'N', '_', 'A', '_', 'H', 0,
  /* 13103 */ 'A', 'D', 'D', 'S', '_', 'A', '_', 'H', 0,
  /* 13112 */ 'M', 'A', 'X', '_', 'A', '_', 'H', 0,
  /* 13120 */ 'N', 'L', 'O', 'C', '_', 'H', 0,
  /* 13127 */ 'N', 'L', 'Z', 'C', '_', 'H', 0,
  /* 13134 */ 'S', 'L', 'D', '_', 'H', 0,
  /* 13140 */ 'P', 'C', 'K', 'O', 'D', '_', 'H', 0,
  /* 13148 */ 'I', 'L', 'V', 'O', 'D', '_', 'H', 0,
  /* 13156 */ 'I', 'N', 'S', 'V', 'E', '_', 'H', 0,
  /* 13164 */ 'V', 'S', 'H', 'F', '_', 'H', 0,
  /* 13171 */ 'B', 'N', 'E', 'G', '_', 'H', 0,
  /* 13178 */ 'S', 'R', 'A', 'I', '_', 'H', 0,
  /* 13185 */ 'S', 'L', 'D', 'I', '_', 'H', 0,
  /* 13192 */ 'B', 'N', 'E', 'G', 'I', '_', 'H', 0,
  /* 13200 */ 'S', 'L', 'L', 'I', '_', 'H', 0,
  /* 13207 */ 'S', 'R', 'L', 'I', '_', 'H', 0,
  /* 13214 */ 'B', 'I', 'N', 'S', 'L', 'I', '_', 'H', 0,
  /* 13223 */ 'C', 'E', 'Q', 'I', '_', 'H', 0,
  /* 13230 */ 'S', 'R', 'A', 'R', 'I', '_', 'H', 0,
  /* 13238 */ 'B', 'C', 'L', 'R', 'I', '_', 'H', 0,
  /* 13246 */ 'S', 'R', 'L', 'R', 'I', '_', 'H', 0,
  /* 13254 */ 'B', 'I', 'N', 'S', 'R', 'I', '_', 'H', 0,
  /* 13263 */ 'S', 'P', 'L', 'A', 'T', 'I', '_', 'H', 0,
  /* 13272 */ 'B', 'S', 'E', 'T', 'I', '_', 'H', 0,
  /* 13280 */ 'S', 'U', 'B', 'V', 'I', '_', 'H', 0,
  /* 13288 */ 'A', 'D', 'D', 'V', 'I', '_', 'H', 0,
  /* 13296 */ 'F', 'I', 'L', 'L', '_', 'H', 0,
  /* 13303 */ 'S', 'L', 'L', '_', 'H', 0,
  /* 13309 */ 'S', 'R', 'L', '_', 'H', 0,
  /* 13315 */ 'B', 'I', 'N', 'S', 'L', '_', 'H', 0,
  /* 13323 */ 'I', 'L', 'V', 'L', '_', 'H', 0,
  /* 13330 */ 'F', 'E', 'X', 'D', 'O', '_', 'H', 0,
  /* 13338 */ 'C', 'E', 'Q', '_', 'H', 0,
  /* 13344 */ 'F', 'T', 'Q', '_', 'H', 0,
  /* 13350 */ 'M', 'S', 'U', 'B', '_', 'Q', '_', 'H', 0,
  /* 13359 */ 'M', 'A', 'D', 'D', '_', 'Q', '_', 'H', 0,
  /* 13368 */ 'M', 'U', 'L', '_', 'Q', '_', 'H', 0,
  /* 13376 */ 'M', 'S', 'U', 'B', 'R', '_', 'Q', '_', 'H', 0,
  /* 13386 */ 'M', 'A', 'D', 'D', 'R', '_', 'Q', '_', 'H', 0,
  /* 13396 */ 'M', 'U', 'L', 'R', '_', 'Q', '_', 'H', 0,
  /* 13405 */ 'S', 'R', 'A', 'R', '_', 'H', 0,
  /* 13412 */ 'B', 'C', 'L', 'R', '_', 'H', 0,
  /* 13419 */ 'S', 'R', 'L', 'R', '_', 'H', 0,
  /* 13426 */ 'B', 'I', 'N', 'S', 'R', '_', 'H', 0,
  /* 13434 */ 'I', 'L', 'V', 'R', '_', 'H', 0,
  /* 13441 */ 'A', 'S', 'U', 'B', '_', 'S', '_', 'H', 0,
  /* 13450 */ 'H', 'S', 'U', 'B', '_', 'S', '_', 'H', 0,
  /* 13459 */ 'D', 'P', 'S', 'U', 'B', '_', 'S', '_', 'H', 0,
  /* 13469 */ 'H', 'A', 'D', 'D', '_', 'S', '_', 'H', 0,
  /* 13478 */ 'D', 'P', 'A', 'D', 'D', '_', 'S', '_', 'H', 0,
  /* 13488 */ 'M', 'O', 'D', '_', 'S', '_', 'H', 0,
  /* 13496 */ 'C', 'L', 'E', '_', 'S', '_', 'H', 0,
  /* 13504 */ 'A', 'V', 'E', '_', 'S', '_', 'H', 0,
  /* 13512 */ 'C', 'L', 'E', 'I', '_', 'S', '_', 'H', 0,
  /* 13521 */ 'M', 'I', 'N', 'I', '_', 'S', '_', 'H', 0,
  /* 13530 */ 'C', 'L', 'T', 'I', '_', 'S', '_', 'H', 0,
  /* 13539 */ 'M', 'A', 'X', 'I', '_', 'S', '_', 'H', 0,
  /* 13548 */ 'M', 'I', 'N', '_', 'S', '_', 'H', 0,
  /* 13556 */ 'D', 'O', 'T', 'P', '_', 'S', '_', 'H', 0,
  /* 13565 */ 'A', 'V', 'E', 'R', '_', 'S', '_', 'H', 0,
  /* 13574 */ 'E', 'X', 'T', 'R', '_', 'S', '_', 'H', 0,
  /* 13583 */ 'S', 'U', 'B', 'S', '_', 'S', '_', 'H', 0,
  /* 13592 */ 'A', 'D', 'D', 'S', '_', 'S', '_', 'H', 0,
  /* 13601 */ 'S', 'A', 'T', '_', 'S', '_', 'H', 0,
  /* 13609 */ 'C', 'L', 'T', '_', 'S', '_', 'H', 0,
  /* 13617 */ 'S', 'U', 'B', 'S', 'U', 'U', '_', 'S', '_', 'H', 0,
  /* 13628 */ 'D', 'I', 'V', '_', 'S', '_', 'H', 0,
  /* 13636 */ 'E', 'X', 'T', 'R', 'V', '_', 'S', '_', 'H', 0,
  /* 13646 */ 'M', 'A', 'X', '_', 'S', '_', 'H', 0,
  /* 13654 */ 'C', 'O', 'P', 'Y', '_', 'S', '_', 'H', 0,
  /* 13663 */ 'S', 'P', 'L', 'A', 'T', '_', 'H', 0,
  /* 13671 */ 'B', 'S', 'E', 'T', '_', 'H', 0,
  /* 13678 */ 'P', 'C', 'N', 'T', '_', 'H', 0,
  /* 13685 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'H', 0,
  /* 13694 */ 'S', 'T', '_', 'H', 0,
  /* 13699 */ 'A', 'S', 'U', 'B', '_', 'U', '_', 'H', 0,
  /* 13708 */ 'H', 'S', 'U', 'B', '_', 'U', '_', 'H', 0,
  /* 13717 */ 'D', 'P', 'S', 'U', 'B', '_', 'U', '_', 'H', 0,
  /* 13727 */ 'H', 'A', 'D', 'D', '_', 'U', '_', 'H', 0,
  /* 13736 */ 'D', 'P', 'A', 'D', 'D', '_', 'U', '_', 'H', 0,
  /* 13746 */ 'M', 'O', 'D', '_', 'U', '_', 'H', 0,
  /* 13754 */ 'C', 'L', 'E', '_', 'U', '_', 'H', 0,
  /* 13762 */ 'A', 'V', 'E', '_', 'U', '_', 'H', 0,
  /* 13770 */ 'C', 'L', 'E', 'I', '_', 'U', '_', 'H', 0,
  /* 13779 */ 'M', 'I', 'N', 'I', '_', 'U', '_', 'H', 0,
  /* 13788 */ 'C', 'L', 'T', 'I', '_', 'U', '_', 'H', 0,
  /* 13797 */ 'M', 'A', 'X', 'I', '_', 'U', '_', 'H', 0,
  /* 13806 */ 'M', 'I', 'N', '_', 'U', '_', 'H', 0,
  /* 13814 */ 'D', 'O', 'T', 'P', '_', 'U', '_', 'H', 0,
  /* 13823 */ 'A', 'V', 'E', 'R', '_', 'U', '_', 'H', 0,
  /* 13832 */ 'S', 'U', 'B', 'S', '_', 'U', '_', 'H', 0,
  /* 13841 */ 'A', 'D', 'D', 'S', '_', 'U', '_', 'H', 0,
  /* 13850 */ 'S', 'U', 'B', 'S', 'U', 'S', '_', 'U', '_', 'H', 0,
  /* 13861 */ 'S', 'A', 'T', '_', 'U', '_', 'H', 0,
  /* 13869 */ 'C', 'L', 'T', '_', 'U', '_', 'H', 0,
  /* 13877 */ 'D', 'I', 'V', '_', 'U', '_', 'H', 0,
  /* 13885 */ 'M', 'A', 'X', '_', 'U', '_', 'H', 0,
  /* 13893 */ 'C', 'O', 'P', 'Y', '_', 'U', '_', 'H', 0,
  /* 13902 */ 'M', 'S', 'U', 'B', 'V', '_', 'H', 0,
  /* 13910 */ 'M', 'A', 'D', 'D', 'V', '_', 'H', 0,
  /* 13918 */ 'P', 'C', 'K', 'E', 'V', '_', 'H', 0,
  /* 13926 */ 'I', 'L', 'V', 'E', 'V', '_', 'H', 0,
  /* 13934 */ 'M', 'U', 'L', 'V', '_', 'H', 0,
  /* 13941 */ 'B', 'Z', '_', 'H', 0,
  /* 13946 */ 'B', 'N', 'Z', '_', 'H', 0,
  /* 13952 */ 'S', 'Y', 'N', 'C', 'I', 0,
  /* 13958 */ 'D', 'I', 0,
  /* 13961 */ 'T', 'G', 'E', 'I', 0,
  /* 13966 */ 'T', 'N', 'E', 'I', 0,
  /* 13971 */ 'D', 'A', 'H', 'I', 0,
  /* 13976 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'F', 'H', 'I', 0,
  /* 13987 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'T', 'L', 'O', 'H', 'I', 0,
  /* 14000 */ 'G', '_', 'P', 'H', 'I', 0,
  /* 14006 */ 'M', 'F', 'T', 'H', 'I', 0,
  /* 14012 */ 'M', 'T', 'H', 'I', 0,
  /* 14017 */ 'M', 'T', 'T', 'H', 'I', 0,
  /* 14023 */ 'T', 'E', 'Q', 'I', 0,
  /* 14028 */ 'G', '_', 'F', 'P', 'T', 'O', 'S', 'I', 0,
  /* 14037 */ 'D', 'A', 'T', 'I', 0,
  /* 14042 */ 'T', 'L', 'T', 'I', 0,
  /* 14047 */ 'D', 'A', 'U', 'I', 0,
  /* 14052 */ 'G', '_', 'F', 'P', 'T', 'O', 'U', 'I', 0,
  /* 14061 */ 'G', 'I', 'N', 'V', 'I', 0,
  /* 14067 */ 'T', 'L', 'B', 'W', 'I', 0,
  /* 14073 */ 'T', 'L', 'B', 'G', 'W', 'I', 0,
  /* 14080 */ 'M', 'O', 'V', 'N', '_', 'I', '6', '4', '_', 'I', 0,
  /* 14091 */ 'M', 'O', 'V', 'Z', '_', 'I', '6', '4', '_', 'I', 0,
  /* 14102 */ 'M', 'O', 'V', 'F', '_', 'I', 0,
  /* 14109 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'F', '_', 'I', 0,
  /* 14128 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'I', 0,
  /* 14137 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'I', 0,
  /* 14146 */ 'P', 's', 'e', 'u', 'd', 'o', 'D', '_', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', 0,
  /* 14163 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', 0,
  /* 14178 */ 'M', 'O', 'V', 'T', '_', 'I', 0,
  /* 14185 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'T', '_', 'I', 0,
  /* 14204 */ 'J', 0,
  /* 14206 */ 'B', 'R', 'E', 'A', 'K', 0,
  /* 14212 */ 'F', 'O', 'R', 'K', 0,
  /* 14217 */ 'G', '_', 'P', 'T', 'R', '_', 'M', 'A', 'S', 'K', 0,
  /* 14228 */ 'B', 'A', 'L', 0,
  /* 14232 */ 'J', 'A', 'L', 0,
  /* 14236 */ 'B', 'G', 'E', 'Z', 'A', 'L', 0,
  /* 14243 */ 'B', 'L', 'T', 'Z', 'A', 'L', 0,
  /* 14250 */ 'M', 'U', 'L', 'E', 'U', '_', 'S', '_', 'P', 'H', '_', 'Q', 'B', 'L', 0,
  /* 14265 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', 0,
  /* 14279 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', 0,
  /* 14294 */ 'D', 'P', 'A', 'U', '_', 'H', '_', 'Q', 'B', 'L', 0,
  /* 14305 */ 'D', 'P', 'S', 'U', '_', 'H', '_', 'Q', 'B', 'L', 0,
  /* 14316 */ 'L', 'D', 'L', 0,
  /* 14320 */ 'S', 'D', 'L', 0,
  /* 14324 */ 'G', 'C', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 14333 */ 'D', 'B', 'G', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 14343 */ 'E', 'H', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 14352 */ 'A', 'N', 'N', 'O', 'T', 'A', 'T', 'I', 'O', 'N', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 14369 */ 'B', 'G', 'E', 'L', 0,
  /* 14374 */ 'B', 'L', 'E', 'L', 0,
  /* 14379 */ 'B', 'N', 'E', 'L', 0,
  /* 14384 */ 'I', 'C', 'A', 'L', 'L', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'F', 'U', 'N', 'N', 'E', 'L', 0,
  /* 14404 */ 'B', 'C', '1', 'F', 'L', 0,
  /* 14410 */ 'M', 'A', 'Q', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', 'L', 0,
  /* 14423 */ 'P', 'R', 'E', 'C', 'E', 'Q', '_', 'W', '_', 'P', 'H', 'L', 0,
  /* 14436 */ 'M', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'L', 0,
  /* 14448 */ 'M', 'U', 'L', 'E', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'L', 0,
  /* 14462 */ 'G', '_', 'S', 'H', 'L', 0,
  /* 14468 */ 'G', '_', 'F', 'C', 'E', 'I', 'L', 0,
  /* 14476 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 0,
  /* 14485 */ 'H', 'Y', 'P', 'C', 'A', 'L', 'L', 0,
  /* 14493 */ 'S', 'Y', 'S', 'C', 'A', 'L', 'L', 0,
  /* 14501 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'A', 'I', 'L', '_', 'C', 'A', 'L', 'L', 0,
  /* 14521 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'Y', 'P', 'E', 'D', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 14548 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 14569 */ 'F', 'E', 'N', 'T', 'R', 'Y', '_', 'C', 'A', 'L', 'L', 0,
  /* 14581 */ 'B', 'G', 'E', 'Z', 'A', 'L', 'L', 0,
  /* 14589 */ 'B', 'L', 'T', 'Z', 'A', 'L', 'L', 0,
  /* 14597 */ 'K', 'I', 'L', 'L', 0,
  /* 14602 */ 'D', 'S', 'L', 'L', 0,
  /* 14607 */ 'D', 'R', 'O', 'L', 0,
  /* 14612 */ 'B', 'E', 'Q', 'L', 0,
  /* 14617 */ 'D', 'S', 'R', 'L', 0,
  /* 14622 */ 'B', 'C', '1', 'T', 'L', 0,
  /* 14628 */ 'B', 'G', 'T', 'L', 0,
  /* 14633 */ 'B', 'L', 'T', 'L', 0,
  /* 14638 */ 'B', 'G', 'E', 'U', 'L', 0,
  /* 14644 */ 'B', 'L', 'E', 'U', 'L', 0,
  /* 14650 */ 'D', 'M', 'U', 'L', 0,
  /* 14655 */ 'G', '_', 'F', 'M', 'U', 'L', 0,
  /* 14662 */ 'G', '_', 'M', 'U', 'L', 0,
  /* 14668 */ 'B', 'G', 'T', 'U', 'L', 0,
  /* 14674 */ 'B', 'L', 'T', 'U', 'L', 0,
  /* 14680 */ 'L', 'W', 'L', 0,
  /* 14684 */ 'S', 'W', 'L', 0,
  /* 14688 */ 'B', 'G', 'E', 'Z', 'L', 0,
  /* 14694 */ 'B', 'L', 'E', 'Z', 'L', 0,
  /* 14700 */ 'B', 'G', 'T', 'Z', 'L', 0,
  /* 14706 */ 'B', 'L', 'T', 'Z', 'L', 0,
  /* 14712 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'V', 'T', '_', 'D', '6', '4', '_', 'L', 0,
  /* 14728 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'V', 'T', '_', 'S', '_', 'L', 0,
  /* 14742 */ 'G', '_', 'F', 'R', 'E', 'M', 0,
  /* 14749 */ 'G', '_', 'S', 'R', 'E', 'M', 0,
  /* 14756 */ 'G', '_', 'U', 'R', 'E', 'M', 0,
  /* 14763 */ 'M', 'F', 'G', 'C', '0', '_', 'M', 'M', 0,
  /* 14772 */ 'M', 'F', 'H', 'G', 'C', '0', '_', 'M', 'M', 0,
  /* 14782 */ 'M', 'T', 'H', 'G', 'C', '0', '_', 'M', 'M', 0,
  /* 14792 */ 'M', 'T', 'G', 'C', '0', '_', 'M', 'M', 0,
  /* 14801 */ 'L', 'D', 'C', '1', '_', 'M', 'M', 0,
  /* 14809 */ 'S', 'D', 'C', '1', '_', 'M', 'M', 0,
  /* 14817 */ 'C', 'F', 'C', '1', '_', 'M', 'M', 0,
  /* 14825 */ 'M', 'F', 'C', '1', '_', 'M', 'M', 0,
  /* 14833 */ 'C', 'T', 'C', '1', '_', 'M', 'M', 0,
  /* 14841 */ 'M', 'T', 'C', '1', '_', 'M', 'M', 0,
  /* 14849 */ 'L', 'W', 'C', '1', '_', 'M', 'M', 0,
  /* 14857 */ 'S', 'W', 'C', '1', '_', 'M', 'M', 0,
  /* 14865 */ 'L', 'U', 'X', 'C', '1', '_', 'M', 'M', 0,
  /* 14874 */ 'S', 'U', 'X', 'C', '1', '_', 'M', 'M', 0,
  /* 14883 */ 'L', 'W', 'X', 'C', '1', '_', 'M', 'M', 0,
  /* 14892 */ 'S', 'W', 'X', 'C', '1', '_', 'M', 'M', 0,
  /* 14901 */ 'M', 'F', 'H', 'C', '1', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14914 */ 'M', 'T', 'H', 'C', '1', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14927 */ 'F', 'S', 'U', 'B', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14939 */ 'N', 'M', 'S', 'U', 'B', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14952 */ 'F', 'A', 'D', 'D', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14964 */ 'N', 'M', 'A', 'D', 'D', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14977 */ 'C', '_', 'N', 'G', 'E', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 14990 */ 'C', '_', 'N', 'G', 'L', 'E', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15004 */ 'C', '_', 'O', 'L', 'E', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15017 */ 'C', '_', 'U', 'L', 'E', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15030 */ 'C', '_', 'L', 'E', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15042 */ 'C', '_', 'S', 'F', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15054 */ 'M', 'O', 'V', 'F', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15066 */ 'C', '_', 'F', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15077 */ 'F', 'N', 'E', 'G', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15089 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15103 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15117 */ 'C', '_', 'N', 'G', 'L', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15130 */ 'F', 'M', 'U', 'L', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15142 */ 'C', '_', 'U', 'N', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15154 */ 'R', 'E', 'C', 'I', 'P', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15167 */ 'F', 'C', 'M', 'P', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15179 */ 'C', '_', 'S', 'E', 'Q', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15192 */ 'C', '_', 'U', 'E', 'Q', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15205 */ 'C', '_', 'E', 'Q', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15217 */ 'F', 'A', 'B', 'S', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15229 */ 'C', 'V', 'T', '_', 'S', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15242 */ 'C', '_', 'N', 'G', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15255 */ 'C', '_', 'O', 'L', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15268 */ 'C', '_', 'U', 'L', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15281 */ 'C', '_', 'L', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15293 */ 'F', 'S', 'Q', 'R', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15306 */ 'R', 'S', 'Q', 'R', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15319 */ 'M', 'O', 'V', 'T', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15331 */ 'F', 'D', 'I', 'V', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15343 */ 'F', 'M', 'O', 'V', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15355 */ 'C', 'V', 'T', '_', 'W', '_', 'D', '3', '2', '_', 'M', 'M', 0,
  /* 15368 */ 'B', 'P', 'O', 'S', 'G', 'E', '3', '2', '_', 'M', 'M', 0,
  /* 15380 */ 'L', 'W', 'M', '3', '2', '_', 'M', 'M', 0,
  /* 15389 */ 'S', 'W', 'M', '3', '2', '_', 'M', 'M', 0,
  /* 15398 */ 'F', 'C', 'M', 'P', '_', 'S', '3', '2', '_', 'M', 'M', 0,
  /* 15410 */ 'C', 'F', 'C', '2', '_', 'M', 'M', 0,
  /* 15418 */ 'C', 'T', 'C', '2', '_', 'M', 'M', 0,
  /* 15426 */ 'A', 'D', 'D', 'I', 'U', 'R', '2', '_', 'M', 'M', 0,
  /* 15437 */ 'M', 'F', 'H', 'C', '1', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15450 */ 'M', 'T', 'H', 'C', '1', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15463 */ 'M', 'T', 'C', '1', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15475 */ 'F', 'S', 'U', 'B', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15487 */ 'F', 'A', 'D', 'D', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15499 */ 'C', '_', 'N', 'G', 'E', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15512 */ 'C', '_', 'N', 'G', 'L', 'E', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15526 */ 'C', '_', 'O', 'L', 'E', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15539 */ 'C', '_', 'U', 'L', 'E', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15552 */ 'C', '_', 'L', 'E', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15564 */ 'C', '_', 'S', 'F', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15576 */ 'C', '_', 'F', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15587 */ 'F', 'N', 'E', 'G', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15599 */ 'C', '_', 'N', 'G', 'L', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15612 */ 'F', 'M', 'U', 'L', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15624 */ 'C', 'V', 'T', '_', 'L', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15637 */ 'C', '_', 'U', 'N', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15649 */ 'R', 'E', 'C', 'I', 'P', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15662 */ 'C', '_', 'S', 'E', 'Q', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15675 */ 'C', '_', 'U', 'E', 'Q', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15688 */ 'C', '_', 'E', 'Q', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15700 */ 'F', 'A', 'B', 'S', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15712 */ 'C', 'V', 'T', '_', 'S', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15725 */ 'C', '_', 'N', 'G', 'T', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15738 */ 'C', '_', 'O', 'L', 'T', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15751 */ 'C', '_', 'U', 'L', 'T', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15764 */ 'C', '_', 'L', 'T', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15776 */ 'F', 'S', 'Q', 'R', 'T', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15789 */ 'R', 'S', 'Q', 'R', 'T', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15802 */ 'F', 'D', 'I', 'V', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15814 */ 'F', 'M', 'O', 'V', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15826 */ 'C', 'V', 'T', '_', 'W', '_', 'D', '6', '4', '_', 'M', 'M', 0,
  /* 15839 */ 'A', 'D', 'D', 'I', 'U', 'S', '5', '_', 'M', 'M', 0,
  /* 15850 */ 'S', 'B', '1', '6', '_', 'M', 'M', 0,
  /* 15858 */ 'J', 'R', 'C', '1', '6', '_', 'M', 'M', 0,
  /* 15867 */ 'A', 'N', 'D', '1', '6', '_', 'M', 'M', 0,
  /* 15876 */ 'M', 'O', 'V', 'E', '1', '6', '_', 'M', 'M', 0,
  /* 15886 */ 'S', 'H', '1', '6', '_', 'M', 'M', 0,
  /* 15894 */ 'A', 'N', 'D', 'I', '1', '6', '_', 'M', 'M', 0,
  /* 15904 */ 'M', 'F', 'H', 'I', '1', '6', '_', 'M', 'M', 0,
  /* 15914 */ 'L', 'I', '1', '6', '_', 'M', 'M', 0,
  /* 15922 */ 'B', 'R', 'E', 'A', 'K', '1', '6', '_', 'M', 'M', 0,
  /* 15933 */ 'S', 'L', 'L', '1', '6', '_', 'M', 'M', 0,
  /* 15942 */ 'S', 'R', 'L', '1', '6', '_', 'M', 'M', 0,
  /* 15951 */ 'L', 'W', 'M', '1', '6', '_', 'M', 'M', 0,
  /* 15960 */ 'S', 'W', 'M', '1', '6', '_', 'M', 'M', 0,
  /* 15969 */ 'M', 'F', 'L', 'O', '1', '6', '_', 'M', 'M', 0,
  /* 15979 */ 'S', 'D', 'B', 'B', 'P', '1', '6', '_', 'M', 'M', 0,
  /* 15990 */ 'J', 'R', '1', '6', '_', 'M', 'M', 0,
  /* 15998 */ 'J', 'A', 'L', 'R', '1', '6', '_', 'M', 'M', 0,
  /* 16008 */ 'X', 'O', 'R', '1', '6', '_', 'M', 'M', 0,
  /* 16017 */ 'J', 'A', 'L', 'R', 'S', '1', '6', '_', 'M', 'M', 0,
  /* 16028 */ 'N', 'O', 'T', '1', '6', '_', 'M', 'M', 0,
  /* 16037 */ 'L', 'B', 'U', '1', '6', '_', 'M', 'M', 0,
  /* 16046 */ 'S', 'U', 'B', 'U', '1', '6', '_', 'M', 'M', 0,
  /* 16056 */ 'A', 'D', 'D', 'U', '1', '6', '_', 'M', 'M', 0,
  /* 16066 */ 'L', 'H', 'U', '1', '6', '_', 'M', 'M', 0,
  /* 16075 */ 'L', 'W', '1', '6', '_', 'M', 'M', 0,
  /* 16083 */ 'S', 'W', '1', '6', '_', 'M', 'M', 0,
  /* 16091 */ 'B', 'N', 'E', 'Z', '1', '6', '_', 'M', 'M', 0,
  /* 16101 */ 'B', 'E', 'Q', 'Z', '1', '6', '_', 'M', 'M', 0,
  /* 16111 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', 'A', '_', 'M', 'M', 0,
  /* 16129 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', 'A', '_', 'M', 'M', 0,
  /* 16148 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', 'A', '_', 'M', 'M', 0,
  /* 16166 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', 'A', '_', 'M', 'M', 0,
  /* 16185 */ 'S', 'R', 'A', '_', 'M', 'M', 0,
  /* 16192 */ 'S', 'E', 'B', '_', 'M', 'M', 0,
  /* 16199 */ 'E', 'H', 'B', '_', 'M', 'M', 0,
  /* 16206 */ 'L', 'B', '_', 'M', 'M', 0,
  /* 16212 */ 'C', 'M', 'P', 'G', 'U', '_', 'L', 'E', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16227 */ 'C', 'M', 'P', 'U', '_', 'L', 'E', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16241 */ 'P', 'I', 'C', 'K', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16252 */ 'S', 'H', 'L', 'L', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16263 */ 'R', 'E', 'P', 'L', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16274 */ 'S', 'H', 'R', 'L', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16285 */ 'C', 'M', 'P', 'G', 'U', '_', 'E', 'Q', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16300 */ 'C', 'M', 'P', 'U', '_', 'E', 'Q', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16314 */ 'S', 'U', 'B', 'U', '_', 'S', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16327 */ 'A', 'D', 'D', 'U', '_', 'S', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16340 */ 'C', 'M', 'P', 'G', 'U', '_', 'L', 'T', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16355 */ 'C', 'M', 'P', 'U', '_', 'L', 'T', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16369 */ 'S', 'U', 'B', 'U', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16380 */ 'A', 'D', 'D', 'U', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16391 */ 'S', 'H', 'L', 'L', 'V', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16403 */ 'R', 'E', 'P', 'L', 'V', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16415 */ 'S', 'H', 'R', 'L', 'V', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16427 */ 'R', 'A', 'D', 'D', 'U', '_', 'W', '_', 'Q', 'B', '_', 'M', 'M', 0,
  /* 16441 */ 'S', 'B', '_', 'M', 'M', 0,
  /* 16447 */ 'M', 'O', 'D', 'S', 'U', 'B', '_', 'M', 'M', 0,
  /* 16457 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'S', 'U', 'B', '_', 'M', 'M', 0,
  /* 16471 */ 'S', 'Y', 'N', 'C', '_', 'M', 'M', 0,
  /* 16479 */ 'A', 'D', 'D', 'I', 'U', 'P', 'C', '_', 'M', 'M', 0,
  /* 16490 */ 'A', 'D', 'D', 'S', 'C', '_', 'M', 'M', 0,
  /* 16499 */ 'A', 'D', 'D', 'W', 'C', '_', 'M', 'M', 0,
  /* 16508 */ 'B', 'N', 'E', 'Z', 'C', '_', 'M', 'M', 0,
  /* 16517 */ 'B', 'E', 'Q', 'Z', 'C', '_', 'M', 'M', 0,
  /* 16526 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'A', 'D', 'D', '_', 'M', 'M', 0,
  /* 16540 */ 'A', 'N', 'D', '_', 'M', 'M', 0,
  /* 16547 */ 'L', 'B', 'E', '_', 'M', 'M', 0,
  /* 16554 */ 'S', 'B', 'E', '_', 'M', 'M', 0,
  /* 16561 */ 'S', 'C', 'E', '_', 'M', 'M', 0,
  /* 16568 */ 'C', 'A', 'C', 'H', 'E', 'E', '_', 'M', 'M', 0,
  /* 16578 */ 'P', 'R', 'E', 'F', 'E', '_', 'M', 'M', 0,
  /* 16587 */ 'T', 'G', 'E', '_', 'M', 'M', 0,
  /* 16594 */ 'C', 'A', 'C', 'H', 'E', '_', 'M', 'M', 0,
  /* 16603 */ 'L', 'H', 'E', '_', 'M', 'M', 0,
  /* 16610 */ 'S', 'H', 'E', '_', 'M', 'M', 0,
  /* 16617 */ 'L', 'L', 'E', '_', 'M', 'M', 0,
  /* 16624 */ 'L', 'W', 'L', 'E', '_', 'M', 'M', 0,
  /* 16632 */ 'S', 'W', 'L', 'E', '_', 'M', 'M', 0,
  /* 16640 */ 'B', 'N', 'E', '_', 'M', 'M', 0,
  /* 16647 */ 'T', 'N', 'E', '_', 'M', 'M', 0,
  /* 16654 */ 'L', 'W', 'R', 'E', '_', 'M', 'M', 0,
  /* 16662 */ 'S', 'W', 'R', 'E', '_', 'M', 'M', 0,
  /* 16670 */ 'P', 'A', 'U', 'S', 'E', '_', 'M', 'M', 0,
  /* 16679 */ 'L', 'W', 'E', '_', 'M', 'M', 0,
  /* 16686 */ 'S', 'W', 'E', '_', 'M', 'M', 0,
  /* 16693 */ 'L', 'B', 'u', 'E', '_', 'M', 'M', 0,
  /* 16701 */ 'L', 'H', 'u', 'E', '_', 'M', 'M', 0,
  /* 16709 */ 'B', 'C', '1', 'F', '_', 'M', 'M', 0,
  /* 16717 */ 'P', 'R', 'E', 'F', '_', 'M', 'M', 0,
  /* 16725 */ 'T', 'L', 'B', 'G', 'I', 'N', 'V', 'F', '_', 'M', 'M', 0,
  /* 16737 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', 'R', 'E', 'G', '_', 'M', 'M', 0,
  /* 16752 */ 'W', 'S', 'B', 'H', '_', 'M', 'M', 0,
  /* 16760 */ 'S', 'E', 'H', '_', 'M', 'M', 0,
  /* 16767 */ 'L', 'H', '_', 'M', 'M', 0,
  /* 16773 */ 'S', 'H', 'R', 'A', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16784 */ 'P', 'R', 'E', 'C', 'R', 'Q', '_', 'Q', 'B', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16800 */ 'P', 'R', 'E', 'C', 'R', 'Q', 'U', '_', 'S', '_', 'Q', 'B', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16819 */ 'C', 'M', 'P', '_', 'L', 'E', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16832 */ 'P', 'I', 'C', 'K', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16843 */ 'S', 'H', 'L', 'L', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16854 */ 'R', 'E', 'P', 'L', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16865 */ 'P', 'A', 'C', 'K', 'R', 'L', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16878 */ 'S', 'U', 'B', 'Q', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16889 */ 'A', 'D', 'D', 'Q', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16900 */ 'C', 'M', 'P', '_', 'E', 'Q', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16913 */ 'S', 'H', 'R', 'A', '_', 'R', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16926 */ 'S', 'H', 'R', 'A', 'V', '_', 'R', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16940 */ 'M', 'U', 'L', 'Q', '_', 'R', 'S', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16954 */ 'S', 'H', 'L', 'L', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16967 */ 'S', 'U', 'B', 'Q', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16980 */ 'A', 'D', 'D', 'Q', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 16993 */ 'A', 'B', 'S', 'Q', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17006 */ 'S', 'H', 'L', 'L', 'V', '_', 'S', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17020 */ 'C', 'M', 'P', '_', 'L', 'T', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17033 */ 'S', 'H', 'R', 'A', 'V', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17045 */ 'S', 'H', 'L', 'L', 'V', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17057 */ 'R', 'E', 'P', 'L', 'V', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17069 */ 'D', 'P', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17084 */ 'M', 'U', 'L', 'S', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17101 */ 'D', 'P', 'S', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', '_', 'M', 'M', 0,
  /* 17116 */ 'S', 'H', '_', 'M', 'M', 0,
  /* 17122 */ 'E', 'X', 'T', 'R', '_', 'S', '_', 'H', '_', 'M', 'M', 0,
  /* 17134 */ 'E', 'X', 'T', 'R', 'V', '_', 'S', '_', 'H', '_', 'M', 'M', 0,
  /* 17147 */ 'S', 'Y', 'N', 'C', 'I', '_', 'M', 'M', 0,
  /* 17156 */ 'D', 'I', '_', 'M', 'M', 0,
  /* 17162 */ 'T', 'G', 'E', 'I', '_', 'M', 'M', 0,
  /* 17170 */ 'T', 'N', 'E', 'I', '_', 'M', 'M', 0,
  /* 17178 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'F', 'H', 'I', '_', 'M', 'M', 0,
  /* 17192 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'T', 'L', 'O', 'H', 'I', '_', 'M', 'M', 0,
  /* 17208 */ 'M', 'T', 'H', 'I', '_', 'M', 'M', 0,
  /* 17216 */ 'T', 'E', 'Q', 'I', '_', 'M', 'M', 0,
  /* 17224 */ 'T', 'L', 'T', 'I', '_', 'M', 'M', 0,
  /* 17232 */ 'T', 'L', 'B', 'W', 'I', '_', 'M', 'M', 0,
  /* 17241 */ 'T', 'L', 'B', 'G', 'W', 'I', '_', 'M', 'M', 0,
  /* 17251 */ 'M', 'O', 'V', 'F', '_', 'I', '_', 'M', 'M', 0,
  /* 17261 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'M', 'M', 0,
  /* 17271 */ 'M', 'O', 'V', 'T', '_', 'I', '_', 'M', 'M', 0,
  /* 17281 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'M', 'M', 0,
  /* 17291 */ 'J', '_', 'M', 'M', 0,
  /* 17296 */ 'B', 'R', 'E', 'A', 'K', '_', 'M', 'M', 0,
  /* 17305 */ 'J', 'A', 'L', '_', 'M', 'M', 0,
  /* 17312 */ 'B', 'G', 'E', 'Z', 'A', 'L', '_', 'M', 'M', 0,
  /* 17322 */ 'B', 'L', 'T', 'Z', 'A', 'L', '_', 'M', 'M', 0,
  /* 17332 */ 'M', 'U', 'L', 'E', 'U', '_', 'S', '_', 'P', 'H', '_', 'Q', 'B', 'L', '_', 'M', 'M', 0,
  /* 17350 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', '_', 'M', 'M', 0,
  /* 17367 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'L', '_', 'M', 'M', 0,
  /* 17385 */ 'D', 'P', 'A', 'U', '_', 'H', '_', 'Q', 'B', 'L', '_', 'M', 'M', 0,
  /* 17399 */ 'D', 'P', 'S', 'U', '_', 'H', '_', 'Q', 'B', 'L', '_', 'M', 'M', 0,
  /* 17413 */ 'M', 'A', 'Q', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', 'L', '_', 'M', 'M', 0,
  /* 17429 */ 'P', 'R', 'E', 'C', 'E', 'Q', '_', 'W', '_', 'P', 'H', 'L', '_', 'M', 'M', 0,
  /* 17445 */ 'M', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'L', '_', 'M', 'M', 0,
  /* 17460 */ 'M', 'U', 'L', 'E', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'L', '_', 'M', 'M', 0,
  /* 17477 */ 'T', 'A', 'I', 'L', 'C', 'A', 'L', 'L', '_', 'M', 'M', 0,
  /* 17489 */ 'H', 'Y', 'P', 'C', 'A', 'L', 'L', '_', 'M', 'M', 0,
  /* 17500 */ 'S', 'Y', 'S', 'C', 'A', 'L', 'L', '_', 'M', 'M', 0,
  /* 17511 */ 'S', 'L', 'L', '_', 'M', 'M', 0,
  /* 17518 */ 'S', 'R', 'L', '_', 'M', 'M', 0,
  /* 17525 */ 'M', 'U', 'L', '_', 'M', 'M', 0,
  /* 17532 */ 'L', 'W', 'L', '_', 'M', 'M', 0,
  /* 17539 */ 'S', 'W', 'L', '_', 'M', 'M', 0,
  /* 17546 */ 'L', 'W', 'M', '_', 'M', 'M', 0,
  /* 17553 */ 'S', 'W', 'M', '_', 'M', 'M', 0,
  /* 17560 */ 'C', 'L', 'O', '_', 'M', 'M', 0,
  /* 17567 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'F', 'L', 'O', '_', 'M', 'M', 0,
  /* 17581 */ 'S', 'H', 'I', 'L', 'O', '_', 'M', 'M', 0,
  /* 17590 */ 'M', 'T', 'L', 'O', '_', 'M', 'M', 0,
  /* 17598 */ 'T', 'R', 'A', 'P', '_', 'M', 'M', 0,
  /* 17606 */ 'S', 'D', 'B', 'B', 'P', '_', 'M', 'M', 0,
  /* 17615 */ 'T', 'L', 'B', 'P', '_', 'M', 'M', 0,
  /* 17623 */ 'E', 'X', 'T', 'P', 'D', 'P', '_', 'M', 'M', 0,
  /* 17633 */ 'M', 'O', 'V', 'E', 'P', '_', 'M', 'M', 0,
  /* 17642 */ 'T', 'L', 'B', 'G', 'P', '_', 'M', 'M', 0,
  /* 17651 */ 'L', 'W', 'G', 'P', '_', 'M', 'M', 0,
  /* 17659 */ 'M', 'T', 'H', 'L', 'I', 'P', '_', 'M', 'M', 0,
  /* 17669 */ 'S', 'S', 'N', 'O', 'P', '_', 'M', 'M', 0,
  /* 17678 */ 'A', 'D', 'D', 'I', 'U', 'R', '1', 'S', 'P', '_', 'M', 'M', 0,
  /* 17691 */ 'R', 'D', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17700 */ 'W', 'R', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17709 */ 'L', 'W', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17718 */ 'S', 'W', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17727 */ 'M', 'S', 'U', 'B', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17739 */ 'M', 'A', 'D', 'D', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17751 */ 'M', 'F', 'H', 'I', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17763 */ 'M', 'T', 'H', 'I', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17775 */ 'M', 'F', 'L', 'O', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17787 */ 'M', 'T', 'L', 'O', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17799 */ 'M', 'U', 'L', 'T', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17811 */ 'M', 'S', 'U', 'B', 'U', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17824 */ 'M', 'A', 'D', 'D', 'U', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17837 */ 'M', 'U', 'L', 'T', 'U', '_', 'D', 'S', 'P', '_', 'M', 'M', 0,
  /* 17850 */ 'A', 'D', 'D', 'I', 'U', 'S', 'P', '_', 'M', 'M', 0,
  /* 17861 */ 'L', 'W', 'S', 'P', '_', 'M', 'M', 0,
  /* 17869 */ 'S', 'W', 'S', 'P', '_', 'M', 'M', 0,
  /* 17877 */ 'E', 'X', 'T', 'P', '_', 'M', 'M', 0,
  /* 17885 */ 'L', 'W', 'P', '_', 'M', 'M', 0,
  /* 17892 */ 'S', 'W', 'P', '_', 'M', 'M', 0,
  /* 17899 */ 'B', 'E', 'Q', '_', 'M', 'M', 0,
  /* 17906 */ 'T', 'E', 'Q', '_', 'M', 'M', 0,
  /* 17913 */ 'T', 'L', 'B', 'R', '_', 'M', 'M', 0,
  /* 17921 */ 'M', 'U', 'L', 'E', 'U', '_', 'S', '_', 'P', 'H', '_', 'Q', 'B', 'R', '_', 'M', 'M', 0,
  /* 17939 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', '_', 'M', 'M', 0,
  /* 17956 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', '_', 'M', 'M', 0,
  /* 17974 */ 'D', 'P', 'A', 'U', '_', 'H', '_', 'Q', 'B', 'R', '_', 'M', 'M', 0,
  /* 17988 */ 'D', 'P', 'S', 'U', '_', 'H', '_', 'Q', 'B', 'R', '_', 'M', 'M', 0,
  /* 18002 */ 'B', 'A', 'L', '_', 'B', 'R', '_', 'M', 'M', 0,
  /* 18012 */ 'T', 'L', 'B', 'G', 'R', '_', 'M', 'M', 0,
  /* 18021 */ 'M', 'A', 'Q', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', 'R', '_', 'M', 'M', 0,
  /* 18037 */ 'P', 'R', 'E', 'C', 'E', 'Q', '_', 'W', '_', 'P', 'H', 'R', '_', 'M', 'M', 0,
  /* 18053 */ 'M', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'R', '_', 'M', 'M', 0,
  /* 18068 */ 'M', 'U', 'L', 'E', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'R', '_', 'M', 'M', 0,
  /* 18085 */ 'J', 'R', '_', 'M', 'M', 0,
  /* 18091 */ 'J', 'A', 'L', 'R', '_', 'M', 'M', 0,
  /* 18099 */ 'N', 'O', 'R', '_', 'M', 'M', 0,
  /* 18106 */ 'X', 'O', 'R', '_', 'M', 'M', 0,
  /* 18113 */ 'R', 'O', 'T', 'R', '_', 'M', 'M', 0,
  /* 18121 */ 'T', 'L', 'B', 'W', 'R', '_', 'M', 'M', 0,
  /* 18130 */ 'T', 'L', 'B', 'G', 'W', 'R', '_', 'M', 'M', 0,
  /* 18140 */ 'R', 'D', 'H', 'W', 'R', '_', 'M', 'M', 0,
  /* 18149 */ 'L', 'W', 'R', '_', 'M', 'M', 0,
  /* 18156 */ 'S', 'W', 'R', '_', 'M', 'M', 0,
  /* 18163 */ 'J', 'A', 'L', 'S', '_', 'M', 'M', 0,
  /* 18171 */ 'B', 'G', 'E', 'Z', 'A', 'L', 'S', '_', 'M', 'M', 0,
  /* 18182 */ 'B', 'L', 'T', 'Z', 'A', 'L', 'S', '_', 'M', 'M', 0,
  /* 18193 */ 'I', 'N', 'S', '_', 'M', 'M', 0,
  /* 18200 */ 'J', 'A', 'L', 'R', 'S', '_', 'M', 'M', 0,
  /* 18209 */ 'L', 'W', 'X', 'S', '_', 'M', 'M', 0,
  /* 18217 */ 'C', 'V', 'T', '_', 'D', '3', '2', '_', 'S', '_', 'M', 'M', 0,
  /* 18230 */ 'C', 'V', 'T', '_', 'D', '6', '4', '_', 'S', '_', 'M', 'M', 0,
  /* 18243 */ 'F', 'S', 'U', 'B', '_', 'S', '_', 'M', 'M', 0,
  /* 18253 */ 'N', 'M', 'S', 'U', 'B', '_', 'S', '_', 'M', 'M', 0,
  /* 18264 */ 'F', 'A', 'D', 'D', '_', 'S', '_', 'M', 'M', 0,
  /* 18274 */ 'N', 'M', 'A', 'D', 'D', '_', 'S', '_', 'M', 'M', 0,
  /* 18285 */ 'C', '_', 'N', 'G', 'E', '_', 'S', '_', 'M', 'M', 0,
  /* 18296 */ 'C', '_', 'N', 'G', 'L', 'E', '_', 'S', '_', 'M', 'M', 0,
  /* 18308 */ 'C', '_', 'O', 'L', 'E', '_', 'S', '_', 'M', 'M', 0,
  /* 18319 */ 'C', '_', 'U', 'L', 'E', '_', 'S', '_', 'M', 'M', 0,
  /* 18330 */ 'C', '_', 'L', 'E', '_', 'S', '_', 'M', 'M', 0,
  /* 18340 */ 'C', '_', 'S', 'F', '_', 'S', '_', 'M', 'M', 0,
  /* 18350 */ 'M', 'O', 'V', 'F', '_', 'S', '_', 'M', 'M', 0,
  /* 18360 */ 'C', '_', 'F', '_', 'S', '_', 'M', 'M', 0,
  /* 18369 */ 'F', 'N', 'E', 'G', '_', 'S', '_', 'M', 'M', 0,
  /* 18379 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'S', '_', 'M', 'M', 0,
  /* 18391 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'S', '_', 'M', 'M', 0,
  /* 18403 */ 'C', '_', 'N', 'G', 'L', '_', 'S', '_', 'M', 'M', 0,
  /* 18414 */ 'F', 'M', 'U', 'L', '_', 'S', '_', 'M', 'M', 0,
  /* 18424 */ 'C', 'V', 'T', '_', 'L', '_', 'S', '_', 'M', 'M', 0,
  /* 18435 */ 'C', '_', 'U', 'N', '_', 'S', '_', 'M', 'M', 0,
  /* 18445 */ 'R', 'E', 'C', 'I', 'P', '_', 'S', '_', 'M', 'M', 0,
  /* 18456 */ 'C', '_', 'S', 'E', 'Q', '_', 'S', '_', 'M', 'M', 0,
  /* 18467 */ 'C', '_', 'U', 'E', 'Q', '_', 'S', '_', 'M', 'M', 0,
  /* 18478 */ 'C', '_', 'E', 'Q', '_', 'S', '_', 'M', 'M', 0,
  /* 18488 */ 'F', 'A', 'B', 'S', '_', 'S', '_', 'M', 'M', 0,
  /* 18498 */ 'C', '_', 'N', 'G', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18509 */ 'C', '_', 'O', 'L', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18520 */ 'C', '_', 'U', 'L', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18531 */ 'C', '_', 'L', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18541 */ 'F', 'S', 'Q', 'R', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18552 */ 'R', 'S', 'Q', 'R', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18563 */ 'M', 'O', 'V', 'T', '_', 'S', '_', 'M', 'M', 0,
  /* 18573 */ 'F', 'D', 'I', 'V', '_', 'S', '_', 'M', 'M', 0,
  /* 18583 */ 'F', 'M', 'O', 'V', '_', 'S', '_', 'M', 'M', 0,
  /* 18593 */ 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'S', '_', 'M', 'M', 0,
  /* 18606 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'S', '_', 'M', 'M', 0,
  /* 18619 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'S', '_', 'M', 'M', 0,
  /* 18631 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'S', '_', 'M', 'M', 0,
  /* 18644 */ 'C', 'V', 'T', '_', 'W', '_', 'S', '_', 'M', 'M', 0,
  /* 18655 */ 'B', 'C', '1', 'T', '_', 'M', 'M', 0,
  /* 18663 */ 'D', 'E', 'R', 'E', 'T', '_', 'M', 'M', 0,
  /* 18672 */ 'W', 'A', 'I', 'T', '_', 'M', 'M', 0,
  /* 18680 */ 'S', 'L', 'T', '_', 'M', 'M', 0,
  /* 18687 */ 'T', 'L', 'T', '_', 'M', 'M', 0,
  /* 18694 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'U', 'L', 'T', '_', 'M', 'M', 0,
  /* 18708 */ 'E', 'X', 'T', '_', 'M', 'M', 0,
  /* 18715 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'S', 'U', 'B', 'U', '_', 'M', 'M', 0,
  /* 18730 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'A', 'D', 'D', 'U', '_', 'M', 'M', 0,
  /* 18745 */ 'T', 'G', 'E', 'U', '_', 'M', 'M', 0,
  /* 18753 */ 'T', 'G', 'E', 'I', 'U', '_', 'M', 'M', 0,
  /* 18762 */ 'T', 'L', 'T', 'I', 'U', '_', 'M', 'M', 0,
  /* 18771 */ 'T', 'L', 'T', 'U', '_', 'M', 'M', 0,
  /* 18779 */ 'L', 'W', 'U', '_', 'M', 'M', 0,
  /* 18786 */ 'S', 'R', 'A', 'V', '_', 'M', 'M', 0,
  /* 18794 */ 'B', 'I', 'T', 'R', 'E', 'V', '_', 'M', 'M', 0,
  /* 18804 */ 'S', 'D', 'I', 'V', '_', 'M', 'M', 0,
  /* 18812 */ 'U', 'D', 'I', 'V', '_', 'M', 'M', 0,
  /* 18820 */ 'S', 'L', 'L', 'V', '_', 'M', 'M', 0,
  /* 18828 */ 'S', 'R', 'L', 'V', '_', 'M', 'M', 0,
  /* 18836 */ 'T', 'L', 'B', 'G', 'I', 'N', 'V', '_', 'M', 'M', 0,
  /* 18847 */ 'S', 'H', 'I', 'L', 'O', 'V', '_', 'M', 'M', 0,
  /* 18857 */ 'E', 'X', 'T', 'P', 'D', 'P', 'V', '_', 'M', 'M', 0,
  /* 18868 */ 'E', 'X', 'T', 'P', 'V', '_', 'M', 'M', 0,
  /* 18877 */ 'R', 'O', 'T', 'R', 'V', '_', 'M', 'M', 0,
  /* 18886 */ 'I', 'N', 'S', 'V', '_', 'M', 'M', 0,
  /* 18894 */ 'L', 'W', '_', 'M', 'M', 0,
  /* 18900 */ 'S', 'W', '_', 'M', 'M', 0,
  /* 18906 */ 'C', 'V', 'T', '_', 'D', '3', '2', '_', 'W', '_', 'M', 'M', 0,
  /* 18919 */ 'C', 'V', 'T', '_', 'D', '6', '4', '_', 'W', '_', 'M', 'M', 0,
  /* 18932 */ 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'M', 'M', 0,
  /* 18943 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'M', 'M', 0,
  /* 18954 */ 'P', 'R', 'E', 'C', 'R', 'Q', '_', 'P', 'H', '_', 'W', '_', 'M', 'M', 0,
  /* 18969 */ 'P', 'R', 'E', 'C', 'R', 'Q', '_', 'R', 'S', '_', 'P', 'H', '_', 'W', '_', 'M', 'M', 0,
  /* 18987 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'M', 'M', 0,
  /* 18997 */ 'D', 'P', 'A', 'Q', '_', 'S', 'A', '_', 'L', '_', 'W', '_', 'M', 'M', 0,
  /* 19012 */ 'D', 'P', 'S', 'Q', '_', 'S', 'A', '_', 'L', '_', 'W', '_', 'M', 'M', 0,
  /* 19027 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'M', 'M', 0,
  /* 19038 */ 'E', 'X', 'T', 'R', '_', 'W', '_', 'M', 'M', 0,
  /* 19048 */ 'S', 'H', 'R', 'A', '_', 'R', '_', 'W', '_', 'M', 'M', 0,
  /* 19060 */ 'E', 'X', 'T', 'R', '_', 'R', '_', 'W', '_', 'M', 'M', 0,
  /* 19072 */ 'S', 'H', 'R', 'A', 'V', '_', 'R', '_', 'W', '_', 'M', 'M', 0,
  /* 19085 */ 'E', 'X', 'T', 'R', 'V', '_', 'R', '_', 'W', '_', 'M', 'M', 0,
  /* 19098 */ 'E', 'X', 'T', 'R', '_', 'R', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19111 */ 'E', 'X', 'T', 'R', 'V', '_', 'R', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19125 */ 'S', 'H', 'L', 'L', '_', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19137 */ 'S', 'U', 'B', 'Q', '_', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19149 */ 'A', 'D', 'D', 'Q', '_', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19161 */ 'A', 'B', 'S', 'Q', '_', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19173 */ 'C', 'V', 'T', '_', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19184 */ 'S', 'H', 'L', 'L', 'V', '_', 'S', '_', 'W', '_', 'M', 'M', 0,
  /* 19197 */ 'E', 'X', 'T', 'R', 'V', '_', 'W', '_', 'M', 'M', 0,
  /* 19208 */ 'P', 'R', 'E', 'F', 'X', '_', 'M', 'M', 0,
  /* 19217 */ 'L', 'H', 'X', '_', 'M', 'M', 0,
  /* 19224 */ 'J', 'A', 'L', 'X', '_', 'M', 'M', 0,
  /* 19232 */ 'L', 'B', 'U', 'X', '_', 'M', 'M', 0,
  /* 19240 */ 'L', 'W', 'X', '_', 'M', 'M', 0,
  /* 19247 */ 'B', 'G', 'E', 'Z', '_', 'M', 'M', 0,
  /* 19255 */ 'B', 'L', 'E', 'Z', '_', 'M', 'M', 0,
  /* 19263 */ 'C', 'L', 'Z', '_', 'M', 'M', 0,
  /* 19270 */ 'B', 'G', 'T', 'Z', '_', 'M', 'M', 0,
  /* 19278 */ 'B', 'L', 'T', 'Z', '_', 'M', 'M', 0,
  /* 19286 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'B', 'r', 'a', 'n', 'c', 'h', '_', 'M', 'M', 0,
  /* 19310 */ 'A', 'D', 'D', 'i', '_', 'M', 'M', 0,
  /* 19318 */ 'A', 'N', 'D', 'i', '_', 'M', 'M', 0,
  /* 19326 */ 'X', 'O', 'R', 'i', '_', 'M', 'M', 0,
  /* 19334 */ 'S', 'L', 'T', 'i', '_', 'M', 'M', 0,
  /* 19342 */ 'L', 'U', 'i', '_', 'M', 'M', 0,
  /* 19349 */ 'L', 'B', 'u', '_', 'M', 'M', 0,
  /* 19356 */ 'S', 'U', 'B', 'u', '_', 'M', 'M', 0,
  /* 19364 */ 'A', 'D', 'D', 'u', '_', 'M', 'M', 0,
  /* 19372 */ 'L', 'H', 'u', '_', 'M', 'M', 0,
  /* 19379 */ 'S', 'L', 'T', 'u', '_', 'M', 'M', 0,
  /* 19387 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'U', 'L', 'T', 'u', '_', 'M', 'M', 0,
  /* 19402 */ 'L', 'E', 'A', '_', 'A', 'D', 'D', 'i', 'u', '_', 'M', 'M', 0,
  /* 19415 */ 'S', 'L', 'T', 'i', 'u', '_', 'M', 'M', 0,
  /* 19424 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', 0,
  /* 19434 */ 'D', 'I', 'N', 'S', 'M', 0,
  /* 19440 */ 'D', 'E', 'X', 'T', 'M', 0,
  /* 19446 */ 'G', '_', 'F', 'M', 'I', 'N', 'I', 'M', 'U', 'M', 0,
  /* 19457 */ 'G', '_', 'F', 'M', 'A', 'X', 'I', 'M', 'U', 'M', 0,
  /* 19468 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', 0,
  /* 19478 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', 0,
  /* 19488 */ 'B', 'A', 'L', 'I', 'G', 'N', 0,
  /* 19495 */ 'D', 'A', 'L', 'I', 'G', 'N', 0,
  /* 19502 */ 'G', '_', 'F', 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', 0,
  /* 19514 */ 'G', '_', 'S', 'M', 'I', 'N', 0,
  /* 19521 */ 'G', '_', 'U', 'M', 'I', 'N', 0,
  /* 19528 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'I', 'N', 0,
  /* 19545 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'I', 'N', 0,
  /* 19561 */ 'G', '_', 'F', 'S', 'I', 'N', 0,
  /* 19568 */ 'D', 'M', 'F', 'C', '2', '_', 'O', 'C', 'T', 'E', 'O', 'N', 0,
  /* 19581 */ 'D', 'M', 'T', 'C', '2', '_', 'O', 'C', 'T', 'E', 'O', 'N', 0,
  /* 19594 */ 'C', 'F', 'I', '_', 'I', 'N', 'S', 'T', 'R', 'U', 'C', 'T', 'I', 'O', 'N', 0,
  /* 19610 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'D', 'O', 'W', 'N', 0,
  /* 19627 */ 'G', '_', 'S', 'S', 'U', 'B', 'O', 0,
  /* 19635 */ 'G', '_', 'U', 'S', 'U', 'B', 'O', 0,
  /* 19643 */ 'G', '_', 'S', 'A', 'D', 'D', 'O', 0,
  /* 19651 */ 'G', '_', 'U', 'A', 'D', 'D', 'O', 0,
  /* 19659 */ 'F', 'E', 'X', 'P', '2', '_', 'D', '_', '1', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19676 */ 'F', 'E', 'X', 'P', '2', '_', 'W', '_', '1', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19693 */ 'B', 'P', 'O', 'S', 'G', 'E', '3', '2', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19709 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'B', '_', 'V', 'I', 'D', 'X', '6', '4', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19732 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'F', 'D', '_', 'V', 'I', 'D', 'X', '6', '4', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19756 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'D', '_', 'V', 'I', 'D', 'X', '6', '4', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19779 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'H', '_', 'V', 'I', 'D', 'X', '6', '4', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19802 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'F', 'W', '_', 'V', 'I', 'D', 'X', '6', '4', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19826 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'W', '_', 'V', 'I', 'D', 'X', '6', '4', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19849 */ 'S', 'N', 'Z', '_', 'B', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19862 */ 'S', 'Z', '_', 'B', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19874 */ 'B', 'S', 'E', 'L', '_', 'F', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19889 */ 'F', 'I', 'L', 'L', '_', 'F', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19904 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'F', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19921 */ 'C', 'O', 'P', 'Y', '_', 'F', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19936 */ 'M', 'S', 'A', '_', 'F', 'P', '_', 'E', 'X', 'T', 'E', 'N', 'D', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19959 */ 'M', 'S', 'A', '_', 'F', 'P', '_', 'R', 'O', 'U', 'N', 'D', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19981 */ 'B', 'S', 'E', 'L', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 19995 */ 'A', 'N', 'D', '_', 'V', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20010 */ 'N', 'O', 'R', '_', 'V', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20025 */ 'X', 'O', 'R', '_', 'V', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20040 */ 'S', 'N', 'Z', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20053 */ 'S', 'Z', '_', 'D', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20065 */ 'B', 'S', 'E', 'L', '_', 'H', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20079 */ 'A', 'N', 'D', '_', 'V', '_', 'H', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20094 */ 'N', 'O', 'R', '_', 'V', '_', 'H', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20109 */ 'X', 'O', 'R', '_', 'V', '_', 'H', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20124 */ 'S', 'N', 'Z', '_', 'H', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20137 */ 'S', 'Z', '_', 'H', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20149 */ 'S', 'N', 'Z', '_', 'V', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20162 */ 'S', 'Z', '_', 'V', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20174 */ 'B', 'S', 'E', 'L', '_', 'F', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20189 */ 'F', 'I', 'L', 'L', '_', 'F', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20204 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'F', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20221 */ 'C', 'O', 'P', 'Y', '_', 'F', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20236 */ 'M', 'S', 'A', '_', 'F', 'P', '_', 'E', 'X', 'T', 'E', 'N', 'D', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20259 */ 'M', 'S', 'A', '_', 'F', 'P', '_', 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20281 */ 'B', 'S', 'E', 'L', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20295 */ 'A', 'N', 'D', '_', 'V', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20310 */ 'N', 'O', 'R', '_', 'V', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20325 */ 'X', 'O', 'R', '_', 'V', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20340 */ 'S', 'N', 'Z', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20353 */ 'S', 'Z', '_', 'W', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20365 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'B', '_', 'V', 'I', 'D', 'X', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20386 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'F', 'D', '_', 'V', 'I', 'D', 'X', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20408 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'D', '_', 'V', 'I', 'D', 'X', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20429 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'H', '_', 'V', 'I', 'D', 'X', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20450 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'F', 'W', '_', 'V', 'I', 'D', 'X', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20472 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'W', '_', 'V', 'I', 'D', 'X', '_', 'P', 'S', 'E', 'U', 'D', 'O', 0,
  /* 20493 */ 'D', 'C', 'L', 'O', 0,
  /* 20498 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'F', 'L', 'O', 0,
  /* 20509 */ 'S', 'H', 'I', 'L', 'O', 0,
  /* 20515 */ 'M', 'F', 'T', 'L', 'O', 0,
  /* 20521 */ 'M', 'T', 'L', 'O', 0,
  /* 20526 */ 'M', 'T', 'T', 'L', 'O', 0,
  /* 20532 */ 'G', '_', 'S', 'M', 'U', 'L', 'O', 0,
  /* 20540 */ 'G', '_', 'U', 'M', 'U', 'L', 'O', 0,
  /* 20548 */ 'S', 'T', 'A', 'C', 'K', 'M', 'A', 'P', 0,
  /* 20557 */ 'T', 'R', 'A', 'P', 0,
  /* 20562 */ 'G', '_', 'B', 'S', 'W', 'A', 'P', 0,
  /* 20570 */ 'D', 'B', 'I', 'T', 'S', 'W', 'A', 'P', 0,
  /* 20579 */ 'S', 'D', 'B', 'B', 'P', 0,
  /* 20585 */ 'T', 'L', 'B', 'P', 0,
  /* 20590 */ 'E', 'X', 'T', 'P', 'D', 'P', 0,
  /* 20597 */ 'G', '_', 'G', 'E', 'P', 0,
  /* 20603 */ 'G', '_', 'S', 'I', 'T', 'O', 'F', 'P', 0,
  /* 20612 */ 'G', '_', 'U', 'I', 'T', 'O', 'F', 'P', 0,
  /* 20621 */ 'T', 'L', 'B', 'G', 'P', 0,
  /* 20627 */ 'M', 'T', 'H', 'L', 'I', 'P', 0,
  /* 20634 */ 'G', '_', 'F', 'C', 'M', 'P', 0,
  /* 20641 */ 'G', '_', 'I', 'C', 'M', 'P', 0,
  /* 20648 */ 'S', 'S', 'N', 'O', 'P', 0,
  /* 20654 */ 'D', 'P', 'O', 'P', 0,
  /* 20659 */ 'G', '_', 'C', 'T', 'P', 'O', 'P', 0,
  /* 20667 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'O', 'P', 0,
  /* 20680 */ 'F', 'A', 'U', 'L', 'T', 'I', 'N', 'G', '_', 'O', 'P', 0,
  /* 20692 */ 'L', 'O', 'A', 'D', '_', 'A', 'C', 'C', '6', '4', 'D', 'S', 'P', 0,
  /* 20706 */ 'S', 'T', 'O', 'R', 'E', '_', 'A', 'C', 'C', '6', '4', 'D', 'S', 'P', 0,
  /* 20721 */ 'R', 'D', 'D', 'S', 'P', 0,
  /* 20727 */ 'W', 'R', 'D', 'S', 'P', 0,
  /* 20733 */ 'M', 'F', 'T', 'D', 'S', 'P', 0,
  /* 20740 */ 'M', 'T', 'T', 'D', 'S', 'P', 0,
  /* 20747 */ 'L', 'W', 'D', 'S', 'P', 0,
  /* 20753 */ 'S', 'W', 'D', 'S', 'P', 0,
  /* 20759 */ 'M', 'S', 'U', 'B', '_', 'D', 'S', 'P', 0,
  /* 20768 */ 'M', 'A', 'D', 'D', '_', 'D', 'S', 'P', 0,
  /* 20777 */ 'L', 'O', 'A', 'D', '_', 'C', 'C', 'O', 'N', 'D', '_', 'D', 'S', 'P', 0,
  /* 20792 */ 'S', 'T', 'O', 'R', 'E', '_', 'C', 'C', 'O', 'N', 'D', '_', 'D', 'S', 'P', 0,
  /* 20808 */ 'M', 'F', 'H', 'I', '_', 'D', 'S', 'P', 0,
  /* 20817 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'T', 'L', 'O', 'H', 'I', '_', 'D', 'S', 'P', 0,
  /* 20834 */ 'M', 'T', 'H', 'I', '_', 'D', 'S', 'P', 0,
  /* 20843 */ 'M', 'F', 'L', 'O', '_', 'D', 'S', 'P', 0,
  /* 20852 */ 'M', 'T', 'L', 'O', '_', 'D', 'S', 'P', 0,
  /* 20861 */ 'M', 'U', 'L', 'T', '_', 'D', 'S', 'P', 0,
  /* 20870 */ 'M', 'S', 'U', 'B', 'U', '_', 'D', 'S', 'P', 0,
  /* 20880 */ 'M', 'A', 'D', 'D', 'U', '_', 'D', 'S', 'P', 0,
  /* 20890 */ 'M', 'U', 'L', 'T', 'U', '_', 'D', 'S', 'P', 0,
  /* 20900 */ 'J', 'R', 'A', 'D', 'D', 'I', 'U', 'S', 'P', 0,
  /* 20910 */ 'E', 'X', 'T', 'P', 0,
  /* 20915 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'U', 'P', 0,
  /* 20930 */ 'D', 'V', 'P', 0,
  /* 20934 */ 'E', 'V', 'P', 0,
  /* 20938 */ 'G', '_', 'F', 'E', 'X', 'P', 0,
  /* 20945 */ 'B', 'E', 'Q', 0,
  /* 20949 */ 'S', 'E', 'Q', 0,
  /* 20953 */ 'T', 'E', 'Q', 0,
  /* 20957 */ 'T', 'L', 'B', 'R', 0,
  /* 20962 */ 'M', 'U', 'L', 'E', 'U', '_', 'S', '_', 'P', 'H', '_', 'Q', 'B', 'R', 0,
  /* 20977 */ 'P', 'R', 'E', 'C', 'E', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', 0,
  /* 20991 */ 'P', 'R', 'E', 'C', 'E', 'Q', 'U', '_', 'P', 'H', '_', 'Q', 'B', 'R', 0,
  /* 21006 */ 'D', 'P', 'A', 'U', '_', 'H', '_', 'Q', 'B', 'R', 0,
  /* 21017 */ 'D', 'P', 'S', 'U', '_', 'H', '_', 'Q', 'B', 'R', 0,
  /* 21028 */ 'G', '_', 'B', 'R', 0,
  /* 21033 */ 'B', 'A', 'L', '_', 'B', 'R', 0,
  /* 21040 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', '_', 'B', 'R', 0,
  /* 21053 */ 'G', '_', 'B', 'L', 'O', 'C', 'K', '_', 'A', 'D', 'D', 'R', 0,
  /* 21066 */ 'L', 'D', 'R', 0,
  /* 21070 */ 'S', 'D', 'R', 0,
  /* 21074 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'N', 'T', 'E', 'R', 0,
  /* 21099 */ 'T', 'L', 'B', 'G', 'R', 0,
  /* 21105 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', 'D', 'o', 'u', 'b', 'l', 'e', 'F', 'G', 'R', 0,
  /* 21122 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', 'S', 'i', 'n', 'g', 'l', 'e', 'F', 'G', 'R', 0,
  /* 21139 */ 'M', 'A', 'Q', '_', 'S', 'A', '_', 'W', '_', 'P', 'H', 'R', 0,
  /* 21152 */ 'P', 'R', 'E', 'C', 'E', 'Q', '_', 'W', '_', 'P', 'H', 'R', 0,
  /* 21165 */ 'M', 'A', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'R', 0,
  /* 21177 */ 'M', 'U', 'L', 'E', 'Q', '_', 'S', '_', 'W', '_', 'P', 'H', 'R', 0,
  /* 21191 */ 'G', '_', 'A', 'S', 'H', 'R', 0,
  /* 21198 */ 'G', '_', 'L', 'S', 'H', 'R', 0,
  /* 21205 */ 'J', 'R', 0,
  /* 21208 */ 'J', 'A', 'L', 'R', 0,
  /* 21213 */ 'N', 'O', 'R', 0,
  /* 21217 */ 'G', '_', 'F', 'F', 'L', 'O', 'O', 'R', 0,
  /* 21226 */ 'D', 'R', 'O', 'R', 0,
  /* 21231 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 21246 */ 'G', '_', 'S', 'H', 'U', 'F', 'F', 'L', 'E', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 21263 */ 'G', '_', 'X', 'O', 'R', 0,
  /* 21269 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'O', 'R', 0,
  /* 21285 */ 'G', '_', 'O', 'R', 0,
  /* 21290 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'O', 'R', 0,
  /* 21305 */ 'M', 'F', 'T', 'G', 'P', 'R', 0,
  /* 21312 */ 'M', 'T', 'T', 'G', 'P', 'R', 0,
  /* 21319 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', 'D', 'o', 'u', 'b', 'l', 'e', 'G', 'P', 'R', 0,
  /* 21336 */ 'L', 'o', 'a', 'd', 'I', 'm', 'm', 'S', 'i', 'n', 'g', 'l', 'e', 'G', 'P', 'R', 0,
  /* 21353 */ 'M', 'F', 'T', 'R', 0,
  /* 21358 */ 'D', 'R', 'O', 'T', 'R', 0,
  /* 21364 */ 'G', '_', 'I', 'N', 'T', 'T', 'O', 'P', 'T', 'R', 0,
  /* 21375 */ 'M', 'T', 'T', 'R', 0,
  /* 21380 */ 'T', 'L', 'B', 'W', 'R', 0,
  /* 21386 */ 'T', 'L', 'B', 'G', 'W', 'R', 0,
  /* 21393 */ 'R', 'D', 'H', 'W', 'R', 0,
  /* 21399 */ 'L', 'W', 'R', 0,
  /* 21403 */ 'S', 'W', 'R', 0,
  /* 21407 */ 'G', '_', 'F', 'A', 'B', 'S', 0,
  /* 21414 */ 'G', '_', 'U', 'N', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 21431 */ 'G', '_', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 21446 */ 'C', 'I', 'N', 'S', 0,
  /* 21451 */ 'D', 'I', 'N', 'S', 0,
  /* 21456 */ 'G', '_', 'F', 'C', 'O', 'S', 0,
  /* 21463 */ 'G', '_', 'C', 'O', 'N', 'C', 'A', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', 'S', 0,
  /* 21480 */ 'C', 'O', 'P', 'Y', '_', 'T', 'O', '_', 'R', 'E', 'G', 'C', 'L', 'A', 'S', 'S', 0,
  /* 21497 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'W', 'I', 'T', 'H', '_', 'S', 'U', 'C', 'C', 'E', 'S', 'S', 0,
  /* 21527 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'W', '_', 'S', 'I', 'D', 'E', '_', 'E', 'F', 'F', 'E', 'C', 'T', 'S', 0,
  /* 21554 */ 'E', 'X', 'T', 'S', 0,
  /* 21559 */ 'C', 'V', 'T', '_', 'D', '3', '2', '_', 'S', 0,
  /* 21569 */ 'C', 'V', 'T', '_', 'D', '6', '4', '_', 'S', 0,
  /* 21579 */ 'M', 'O', 'V', 'N', '_', 'I', '6', '4', '_', 'S', 0,
  /* 21590 */ 'M', 'O', 'V', 'Z', '_', 'I', '6', '4', '_', 'S', 0,
  /* 21601 */ 'M', 'I', 'N', 'A', '_', 'S', 0,
  /* 21608 */ 'M', 'A', 'X', 'A', '_', 'S', 0,
  /* 21615 */ 'F', 'S', 'U', 'B', '_', 'S', 0,
  /* 21622 */ 'N', 'M', 'S', 'U', 'B', '_', 'S', 0,
  /* 21630 */ 'F', 'A', 'D', 'D', '_', 'S', 0,
  /* 21637 */ 'N', 'M', 'A', 'D', 'D', '_', 'S', 0,
  /* 21645 */ 'C', '_', 'N', 'G', 'E', '_', 'S', 0,
  /* 21653 */ 'C', '_', 'N', 'G', 'L', 'E', '_', 'S', 0,
  /* 21662 */ 'C', '_', 'O', 'L', 'E', '_', 'S', 0,
  /* 21670 */ 'C', 'M', 'P', '_', 'S', 'L', 'E', '_', 'S', 0,
  /* 21680 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'E', '_', 'S', 0,
  /* 21691 */ 'C', '_', 'U', 'L', 'E', '_', 'S', 0,
  /* 21699 */ 'C', 'M', 'P', '_', 'U', 'L', 'E', '_', 'S', 0,
  /* 21709 */ 'C', '_', 'L', 'E', '_', 'S', 0,
  /* 21716 */ 'C', 'M', 'P', '_', 'L', 'E', '_', 'S', 0,
  /* 21725 */ 'C', 'M', 'P', '_', 'S', 'A', 'F', '_', 'S', 0,
  /* 21735 */ 'M', 'S', 'U', 'B', 'F', '_', 'S', 0,
  /* 21743 */ 'M', 'A', 'D', 'D', 'F', '_', 'S', 0,
  /* 21751 */ 'C', '_', 'S', 'F', '_', 'S', 0,
  /* 21758 */ 'M', 'O', 'V', 'F', '_', 'S', 0,
  /* 21765 */ 'C', '_', 'F', '_', 'S', 0,
  /* 21771 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'F', '_', 'S', 0,
  /* 21790 */ 'C', 'M', 'P', '_', 'F', '_', 'S', 0,
  /* 21798 */ 'F', 'N', 'E', 'G', '_', 'S', 0,
  /* 21805 */ 'M', 'O', 'V', 'N', '_', 'I', '_', 'S', 0,
  /* 21814 */ 'M', 'O', 'V', 'Z', '_', 'I', '_', 'S', 0,
  /* 21823 */ 'S', 'E', 'L', '_', 'S', 0,
  /* 21829 */ 'C', '_', 'N', 'G', 'L', '_', 'S', 0,
  /* 21837 */ 'F', 'M', 'U', 'L', '_', 'S', 0,
  /* 21844 */ 'T', 'R', 'U', 'N', 'C', '_', 'L', '_', 'S', 0,
  /* 21854 */ 'R', 'O', 'U', 'N', 'D', '_', 'L', '_', 'S', 0,
  /* 21864 */ 'C', 'E', 'I', 'L', '_', 'L', '_', 'S', 0,
  /* 21873 */ 'F', 'L', 'O', 'O', 'R', '_', 'L', '_', 'S', 0,
  /* 21883 */ 'C', 'V', 'T', '_', 'L', '_', 'S', 0,
  /* 21891 */ 'M', 'I', 'N', '_', 'S', 0,
  /* 21897 */ 'C', 'M', 'P', '_', 'S', 'U', 'N', '_', 'S', 0,
  /* 21907 */ 'C', '_', 'U', 'N', '_', 'S', 0,
  /* 21914 */ 'C', 'M', 'P', '_', 'U', 'N', '_', 'S', 0,
  /* 21923 */ 'R', 'E', 'C', 'I', 'P', '_', 'S', 0,
  /* 21931 */ 'C', '_', 'S', 'E', 'Q', '_', 'S', 0,
  /* 21939 */ 'C', 'M', 'P', '_', 'S', 'E', 'Q', '_', 'S', 0,
  /* 21949 */ 'C', 'M', 'P', '_', 'S', 'U', 'E', 'Q', '_', 'S', 0,
  /* 21960 */ 'C', '_', 'U', 'E', 'Q', '_', 'S', 0,
  /* 21968 */ 'C', 'M', 'P', '_', 'U', 'E', 'Q', '_', 'S', 0,
  /* 21978 */ 'C', '_', 'E', 'Q', '_', 'S', 0,
  /* 21985 */ 'C', 'M', 'P', '_', 'E', 'Q', '_', 'S', 0,
  /* 21994 */ 'F', 'A', 'B', 'S', '_', 'S', 0,
  /* 22001 */ 'C', 'L', 'A', 'S', 'S', '_', 'S', 0,
  /* 22009 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'S', 0,
  /* 22024 */ 'C', '_', 'N', 'G', 'T', '_', 'S', 0,
  /* 22032 */ 'C', '_', 'O', 'L', 'T', '_', 'S', 0,
  /* 22040 */ 'C', 'M', 'P', '_', 'S', 'L', 'T', '_', 'S', 0,
  /* 22050 */ 'C', 'M', 'P', '_', 'S', 'U', 'L', 'T', '_', 'S', 0,
  /* 22061 */ 'C', '_', 'U', 'L', 'T', '_', 'S', 0,
  /* 22069 */ 'C', 'M', 'P', '_', 'U', 'L', 'T', '_', 'S', 0,
  /* 22079 */ 'C', '_', 'L', 'T', '_', 'S', 0,
  /* 22086 */ 'C', 'M', 'P', '_', 'L', 'T', '_', 'S', 0,
  /* 22095 */ 'R', 'I', 'N', 'T', '_', 'S', 0,
  /* 22102 */ 'F', 'S', 'Q', 'R', 'T', '_', 'S', 0,
  /* 22110 */ 'R', 'S', 'Q', 'R', 'T', '_', 'S', 0,
  /* 22118 */ 'M', 'O', 'V', 'T', '_', 'S', 0,
  /* 22125 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'E', 'L', 'E', 'C', 'T', 'F', 'P', '_', 'T', '_', 'S', 0,
  /* 22144 */ 'F', 'D', 'I', 'V', '_', 'S', 0,
  /* 22151 */ 'F', 'M', 'O', 'V', '_', 'S', 0,
  /* 22158 */ 'P', 's', 'e', 'u', 'd', 'o', 'T', 'R', 'U', 'N', 'C', '_', 'W', '_', 'S', 0,
  /* 22174 */ 'R', 'O', 'U', 'N', 'D', '_', 'W', '_', 'S', 0,
  /* 22184 */ 'C', 'E', 'I', 'L', '_', 'W', '_', 'S', 0,
  /* 22193 */ 'F', 'L', 'O', 'O', 'R', '_', 'W', '_', 'S', 0,
  /* 22203 */ 'C', 'V', 'T', '_', 'W', '_', 'S', 0,
  /* 22211 */ 'M', 'A', 'X', '_', 'S', 0,
  /* 22217 */ 'S', 'E', 'L', 'N', 'E', 'Z', '_', 'S', 0,
  /* 22226 */ 'S', 'E', 'L', 'E', 'Q', 'Z', '_', 'S', 0,
  /* 22235 */ 'B', 'C', '1', 'T', 0,
  /* 22240 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 0,
  /* 22250 */ 'G', '_', 'S', 'E', 'L', 'E', 'C', 'T', 0,
  /* 22259 */ 'G', '_', 'B', 'R', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', 0,
  /* 22272 */ 'D', 'E', 'R', 'E', 'T', 0,
  /* 22278 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'R', 'E', 'T', 0,
  /* 22292 */ 'B', 'G', 'T', 0,
  /* 22296 */ 'W', 'A', 'I', 'T', 0,
  /* 22301 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'X', 'I', 'T', 0,
  /* 22325 */ 'G', '_', 'B', 'R', 'J', 'T', 0,
  /* 22332 */ 'B', 'L', 'T', 0,
  /* 22336 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 22357 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 22377 */ 'S', 'L', 'T', 0,
  /* 22381 */ 'T', 'L', 'T', 0,
  /* 22385 */ 'P', 's', 'e', 'u', 'd', 'o', 'D', 'M', 'U', 'L', 'T', 0,
  /* 22397 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'U', 'L', 'T', 0,
  /* 22408 */ 'D', 'M', 'T', 0,
  /* 22412 */ 'E', 'M', 'T', 0,
  /* 22416 */ 'G', '_', 'F', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 22428 */ 'G', '_', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 22439 */ 'S', 'T', 'A', 'T', 'E', 'P', 'O', 'I', 'N', 'T', 0,
  /* 22450 */ 'P', 'A', 'T', 'C', 'H', 'P', 'O', 'I', 'N', 'T', 0,
  /* 22461 */ 'G', '_', 'P', 'T', 'R', 'T', 'O', 'I', 'N', 'T', 0,
  /* 22472 */ 'G', '_', 'F', 'R', 'I', 'N', 'T', 0,
  /* 22480 */ 'G', '_', 'F', 'N', 'E', 'A', 'R', 'B', 'Y', 'I', 'N', 'T', 0,
  /* 22493 */ 'G', '_', 'V', 'A', 'S', 'T', 'A', 'R', 'T', 0,
  /* 22503 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'S', 'T', 'A', 'R', 'T', 0,
  /* 22518 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', 0,
  /* 22527 */ 'G', '_', 'F', 'S', 'Q', 'R', 'T', 0,
  /* 22535 */ 'G', '_', 'B', 'I', 'T', 'C', 'A', 'S', 'T', 0,
  /* 22545 */ 'G', '_', 'A', 'D', 'D', 'R', 'S', 'P', 'A', 'C', 'E', '_', 'C', 'A', 'S', 'T', 0,
  /* 22562 */ 'G', 'I', 'N', 'V', 'T', 0,
  /* 22568 */ 'D', 'E', 'X', 'T', 0,
  /* 22573 */ 'G', '_', 'F', 'P', 'E', 'X', 'T', 0,
  /* 22581 */ 'G', '_', 'S', 'E', 'X', 'T', 0,
  /* 22588 */ 'G', '_', 'A', 'N', 'Y', 'E', 'X', 'T', 0,
  /* 22597 */ 'G', '_', 'Z', 'E', 'X', 'T', 0,
  /* 22604 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'S', 'U', 'B', 'U', 0,
  /* 22616 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'A', 'D', 'D', 'U', 0,
  /* 22628 */ 'D', 'M', 'O', 'D', 'U', 0,
  /* 22634 */ 'B', 'G', 'E', 'U', 0,
  /* 22639 */ 'S', 'G', 'E', 'U', 0,
  /* 22644 */ 'T', 'G', 'E', 'U', 0,
  /* 22649 */ 'B', 'L', 'E', 'U', 0,
  /* 22654 */ 'D', 'M', 'U', 'H', 'U', 0,
  /* 22660 */ 'T', 'G', 'E', 'I', 'U', 0,
  /* 22666 */ 'T', 'T', 'L', 'T', 'I', 'U', 0,
  /* 22673 */ 'V', '3', 'M', 'U', 'L', 'U', 0,
  /* 22680 */ 'D', 'M', 'U', 'L', 'U', 0,
  /* 22686 */ 'V', 'M', 'U', 'L', 'U', 0,
  /* 22692 */ 'D', 'I', 'N', 'S', 'U', 0,
  /* 22698 */ 'B', 'G', 'T', 'U', 0,
  /* 22703 */ 'B', 'L', 'T', 'U', 0,
  /* 22708 */ 'T', 'L', 'T', 'U', 0,
  /* 22713 */ 'D', 'E', 'X', 'T', 'U', 0,
  /* 22719 */ 'D', 'D', 'I', 'V', 'U', 0,
  /* 22725 */ 'D', 'S', 'R', 'A', 'V', 0,
  /* 22731 */ 'B', 'I', 'T', 'R', 'E', 'V', 0,
  /* 22738 */ 'D', 'D', 'I', 'V', 0,
  /* 22743 */ 'G', '_', 'F', 'D', 'I', 'V', 0,
  /* 22750 */ 'P', 's', 'e', 'u', 'd', 'o', 'D', 'S', 'D', 'I', 'V', 0,
  /* 22762 */ 'G', '_', 'S', 'D', 'I', 'V', 0,
  /* 22769 */ 'P', 's', 'e', 'u', 'd', 'o', 'S', 'D', 'I', 'V', 0,
  /* 22780 */ 'P', 's', 'e', 'u', 'd', 'o', 'D', 'U', 'D', 'I', 'V', 0,
  /* 22792 */ 'G', '_', 'U', 'D', 'I', 'V', 0,
  /* 22799 */ 'P', 's', 'e', 'u', 'd', 'o', 'U', 'D', 'I', 'V', 0,
  /* 22810 */ 'D', 'S', 'L', 'L', 'V', 0,
  /* 22816 */ 'D', 'S', 'R', 'L', 'V', 0,
  /* 22822 */ 'T', 'L', 'B', 'I', 'N', 'V', 0,
  /* 22829 */ 'T', 'L', 'B', 'G', 'I', 'N', 'V', 0,
  /* 22837 */ 'S', 'H', 'I', 'L', 'O', 'V', 0,
  /* 22844 */ 'E', 'X', 'T', 'P', 'D', 'P', 'V', 0,
  /* 22852 */ 'E', 'X', 'T', 'P', 'V', 0,
  /* 22858 */ 'D', 'R', 'O', 'T', 'R', 'V', 0,
  /* 22865 */ 'I', 'N', 'S', 'V', 0,
  /* 22870 */ 'A', 'N', 'D', '_', 'V', 0,
  /* 22876 */ 'M', 'O', 'V', 'E', '_', 'V', 0,
  /* 22883 */ 'B', 'S', 'E', 'L', '_', 'V', 0,
  /* 22890 */ 'N', 'O', 'R', '_', 'V', 0,
  /* 22896 */ 'X', 'O', 'R', '_', 'V', 0,
  /* 22902 */ 'B', 'Z', '_', 'V', 0,
  /* 22907 */ 'B', 'M', 'Z', '_', 'V', 0,
  /* 22913 */ 'B', 'N', 'Z', '_', 'V', 0,
  /* 22919 */ 'B', 'M', 'N', 'Z', '_', 'V', 0,
  /* 22926 */ 'C', 'R', 'C', '3', '2', 'W', 0,
  /* 22933 */ 'C', 'R', 'C', '3', '2', 'C', 'W', 0,
  /* 22941 */ 'L', 'W', 0,
  /* 22944 */ 'G', '_', 'F', 'P', 'O', 'W', 0,
  /* 22951 */ 'S', 'W', 0,
  /* 22954 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'V', 'T', '_', 'D', '3', '2', '_', 'W', 0,
  /* 22970 */ 'F', 'L', 'O', 'G', '2', '_', 'W', 0,
  /* 22978 */ 'F', 'E', 'X', 'P', '2', '_', 'W', 0,
  /* 22986 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'V', 'T', '_', 'D', '6', '4', '_', 'W', 0,
  /* 23002 */ 'S', 'R', 'A', '_', 'W', 0,
  /* 23008 */ 'A', 'D', 'D', '_', 'A', '_', 'W', 0,
  /* 23016 */ 'F', 'M', 'I', 'N', '_', 'A', '_', 'W', 0,
  /* 23025 */ 'A', 'D', 'D', 'S', '_', 'A', '_', 'W', 0,
  /* 23034 */ 'F', 'M', 'A', 'X', '_', 'A', '_', 'W', 0,
  /* 23043 */ 'F', 'S', 'U', 'B', '_', 'W', 0,
  /* 23050 */ 'F', 'M', 'S', 'U', 'B', '_', 'W', 0,
  /* 23058 */ 'N', 'L', 'O', 'C', '_', 'W', 0,
  /* 23065 */ 'N', 'L', 'Z', 'C', '_', 'W', 0,
  /* 23072 */ 'F', 'A', 'D', 'D', '_', 'W', 0,
  /* 23079 */ 'F', 'M', 'A', 'D', 'D', '_', 'W', 0,
  /* 23087 */ 'S', 'L', 'D', '_', 'W', 0,
  /* 23093 */ 'P', 'C', 'K', 'O', 'D', '_', 'W', 0,
  /* 23101 */ 'I', 'L', 'V', 'O', 'D', '_', 'W', 0,
  /* 23109 */ 'F', 'C', 'L', 'E', '_', 'W', 0,
  /* 23116 */ 'F', 'S', 'L', 'E', '_', 'W', 0,
  /* 23123 */ 'F', 'C', 'U', 'L', 'E', '_', 'W', 0,
  /* 23131 */ 'F', 'S', 'U', 'L', 'E', '_', 'W', 0,
  /* 23139 */ 'F', 'C', 'N', 'E', '_', 'W', 0,
  /* 23146 */ 'F', 'S', 'N', 'E', '_', 'W', 0,
  /* 23153 */ 'F', 'C', 'U', 'N', 'E', '_', 'W', 0,
  /* 23161 */ 'F', 'S', 'U', 'N', 'E', '_', 'W', 0,
  /* 23169 */ 'I', 'N', 'S', 'V', 'E', '_', 'W', 0,
  /* 23177 */ 'F', 'C', 'A', 'F', '_', 'W', 0,
  /* 23184 */ 'F', 'S', 'A', 'F', '_', 'W', 0,
  /* 23191 */ 'V', 'S', 'H', 'F', '_', 'W', 0,
  /* 23198 */ 'B', 'N', 'E', 'G', '_', 'W', 0,
  /* 23205 */ 'P', 'R', 'E', 'C', 'R', '_', 'S', 'R', 'A', '_', 'P', 'H', '_', 'W', 0,
  /* 23220 */ 'P', 'R', 'E', 'C', 'R', 'Q', '_', 'P', 'H', '_', 'W', 0,
  /* 23232 */ 'P', 'R', 'E', 'C', 'R', '_', 'S', 'R', 'A', '_', 'R', '_', 'P', 'H', '_', 'W', 0,
  /* 23249 */ 'P', 'R', 'E', 'C', 'R', 'Q', '_', 'R', 'S', '_', 'P', 'H', '_', 'W', 0,
  /* 23264 */ 'S', 'U', 'B', 'Q', 'H', '_', 'W', 0,
  /* 23272 */ 'A', 'D', 'D', 'Q', 'H', '_', 'W', 0,
  /* 23280 */ 'S', 'R', 'A', 'I', '_', 'W', 0,
  /* 23287 */ 'S', 'L', 'D', 'I', '_', 'W', 0,
  /* 23294 */ 'B', 'N', 'E', 'G', 'I', '_', 'W', 0,
  /* 23302 */ 'S', 'L', 'L', 'I', '_', 'W', 0,
  /* 23309 */ 'S', 'R', 'L', 'I', '_', 'W', 0,
  /* 23316 */ 'B', 'I', 'N', 'S', 'L', 'I', '_', 'W', 0,
  /* 23325 */ 'C', 'E', 'Q', 'I', '_', 'W', 0,
  /* 23332 */ 'S', 'R', 'A', 'R', 'I', '_', 'W', 0,
  /* 23340 */ 'B', 'C', 'L', 'R', 'I', '_', 'W', 0,
  /* 23348 */ 'S', 'R', 'L', 'R', 'I', '_', 'W', 0,
  /* 23356 */ 'B', 'I', 'N', 'S', 'R', 'I', '_', 'W', 0,
  /* 23365 */ 'S', 'P', 'L', 'A', 'T', 'I', '_', 'W', 0,
  /* 23374 */ 'B', 'S', 'E', 'T', 'I', '_', 'W', 0,
  /* 23382 */ 'S', 'U', 'B', 'V', 'I', '_', 'W', 0,
  /* 23390 */ 'A', 'D', 'D', 'V', 'I', '_', 'W', 0,
  /* 23398 */ 'F', 'I', 'L', 'L', '_', 'W', 0,
  /* 23405 */ 'S', 'L', 'L', '_', 'W', 0,
  /* 23411 */ 'F', 'E', 'X', 'U', 'P', 'L', '_', 'W', 0,
  /* 23420 */ 'F', 'F', 'Q', 'L', '_', 'W', 0,
  /* 23427 */ 'S', 'R', 'L', '_', 'W', 0,
  /* 23433 */ 'B', 'I', 'N', 'S', 'L', '_', 'W', 0,
  /* 23441 */ 'F', 'M', 'U', 'L', '_', 'W', 0,
  /* 23448 */ 'I', 'L', 'V', 'L', '_', 'W', 0,
  /* 23455 */ 'D', 'P', 'A', 'Q', '_', 'S', 'A', '_', 'L', '_', 'W', 0,
  /* 23467 */ 'D', 'P', 'S', 'Q', '_', 'S', 'A', '_', 'L', '_', 'W', 0,
  /* 23479 */ 'F', 'M', 'I', 'N', '_', 'W', 0,
  /* 23486 */ 'F', 'C', 'U', 'N', '_', 'W', 0,
  /* 23493 */ 'F', 'S', 'U', 'N', '_', 'W', 0,
  /* 23500 */ 'F', 'E', 'X', 'D', 'O', '_', 'W', 0,
  /* 23508 */ 'F', 'R', 'C', 'P', '_', 'W', 0,
  /* 23515 */ 'F', 'C', 'E', 'Q', '_', 'W', 0,
  /* 23522 */ 'F', 'S', 'E', 'Q', '_', 'W', 0,
  /* 23529 */ 'F', 'C', 'U', 'E', 'Q', '_', 'W', 0,
  /* 23537 */ 'F', 'S', 'U', 'E', 'Q', '_', 'W', 0,
  /* 23545 */ 'F', 'T', 'Q', '_', 'W', 0,
  /* 23551 */ 'M', 'S', 'U', 'B', '_', 'Q', '_', 'W', 0,
  /* 23560 */ 'M', 'A', 'D', 'D', '_', 'Q', '_', 'W', 0,
  /* 23569 */ 'M', 'U', 'L', '_', 'Q', '_', 'W', 0,
  /* 23577 */ 'M', 'S', 'U', 'B', 'R', '_', 'Q', '_', 'W', 0,
  /* 23587 */ 'M', 'A', 'D', 'D', 'R', '_', 'Q', '_', 'W', 0,
  /* 23597 */ 'M', 'U', 'L', 'R', '_', 'Q', '_', 'W', 0,
  /* 23606 */ 'S', 'R', 'A', 'R', '_', 'W', 0,
  /* 23613 */ 'B', 'C', 'L', 'R', '_', 'W', 0,
  /* 23620 */ 'S', 'R', 'L', 'R', '_', 'W', 0,
  /* 23627 */ 'F', 'C', 'O', 'R', '_', 'W', 0,
  /* 23634 */ 'F', 'S', 'O', 'R', '_', 'W', 0,
  /* 23641 */ 'F', 'E', 'X', 'U', 'P', 'R', '_', 'W', 0,
  /* 23650 */ 'F', 'F', 'Q', 'R', '_', 'W', 0,
  /* 23657 */ 'B', 'I', 'N', 'S', 'R', '_', 'W', 0,
  /* 23665 */ 'E', 'X', 'T', 'R', '_', 'W', 0,
  /* 23672 */ 'I', 'L', 'V', 'R', '_', 'W', 0,
  /* 23679 */ 'S', 'H', 'R', 'A', '_', 'R', '_', 'W', 0,
  /* 23688 */ 'S', 'U', 'B', 'Q', 'H', '_', 'R', '_', 'W', 0,
  /* 23698 */ 'A', 'D', 'D', 'Q', 'H', '_', 'R', '_', 'W', 0,
  /* 23708 */ 'E', 'X', 'T', 'R', '_', 'R', '_', 'W', 0,
  /* 23717 */ 'S', 'H', 'R', 'A', 'V', '_', 'R', '_', 'W', 0,
  /* 23727 */ 'E', 'X', 'T', 'R', 'V', '_', 'R', '_', 'W', 0,
  /* 23737 */ 'F', 'A', 'B', 'S', '_', 'W', 0,
  /* 23744 */ 'M', 'U', 'L', 'Q', '_', 'R', 'S', '_', 'W', 0,
  /* 23754 */ 'E', 'X', 'T', 'R', '_', 'R', 'S', '_', 'W', 0,
  /* 23764 */ 'E', 'X', 'T', 'R', 'V', '_', 'R', 'S', '_', 'W', 0,
  /* 23775 */ 'F', 'C', 'L', 'A', 'S', 'S', '_', 'W', 0,
  /* 23784 */ 'A', 'S', 'U', 'B', '_', 'S', '_', 'W', 0,
  /* 23793 */ 'H', 'S', 'U', 'B', '_', 'S', '_', 'W', 0,
  /* 23802 */ 'D', 'P', 'S', 'U', 'B', '_', 'S', '_', 'W', 0,
  /* 23812 */ 'F', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'W', 0,
  /* 23823 */ 'H', 'A', 'D', 'D', '_', 'S', '_', 'W', 0,
  /* 23832 */ 'D', 'P', 'A', 'D', 'D', '_', 'S', '_', 'W', 0,
  /* 23842 */ 'M', 'O', 'D', '_', 'S', '_', 'W', 0,
  /* 23850 */ 'C', 'L', 'E', '_', 'S', '_', 'W', 0,
  /* 23858 */ 'A', 'V', 'E', '_', 'S', '_', 'W', 0,
  /* 23866 */ 'C', 'L', 'E', 'I', '_', 'S', '_', 'W', 0,
  /* 23875 */ 'M', 'I', 'N', 'I', '_', 'S', '_', 'W', 0,
  /* 23884 */ 'C', 'L', 'T', 'I', '_', 'S', '_', 'W', 0,
  /* 23893 */ 'M', 'A', 'X', 'I', '_', 'S', '_', 'W', 0,
  /* 23902 */ 'S', 'H', 'L', 'L', '_', 'S', '_', 'W', 0,
  /* 23911 */ 'M', 'I', 'N', '_', 'S', '_', 'W', 0,
  /* 23919 */ 'D', 'O', 'T', 'P', '_', 'S', '_', 'W', 0,
  /* 23928 */ 'S', 'U', 'B', 'Q', '_', 'S', '_', 'W', 0,
  /* 23937 */ 'A', 'D', 'D', 'Q', '_', 'S', '_', 'W', 0,
  /* 23946 */ 'M', 'U', 'L', 'Q', '_', 'S', '_', 'W', 0,
  /* 23955 */ 'A', 'B', 'S', 'Q', '_', 'S', '_', 'W', 0,
  /* 23964 */ 'A', 'V', 'E', 'R', '_', 'S', '_', 'W', 0,
  /* 23973 */ 'S', 'U', 'B', 'S', '_', 'S', '_', 'W', 0,
  /* 23982 */ 'A', 'D', 'D', 'S', '_', 'S', '_', 'W', 0,
  /* 23991 */ 'S', 'A', 'T', '_', 'S', '_', 'W', 0,
  /* 23999 */ 'C', 'L', 'T', '_', 'S', '_', 'W', 0,
  /* 24007 */ 'F', 'F', 'I', 'N', 'T', '_', 'S', '_', 'W', 0,
  /* 24017 */ 'F', 'T', 'I', 'N', 'T', '_', 'S', '_', 'W', 0,
  /* 24027 */ 'P', 's', 'e', 'u', 'd', 'o', 'C', 'V', 'T', '_', 'S', '_', 'W', 0,
  /* 24041 */ 'S', 'U', 'B', 'S', 'U', 'U', '_', 'S', '_', 'W', 0,
  /* 24052 */ 'D', 'I', 'V', '_', 'S', '_', 'W', 0,
  /* 24060 */ 'S', 'H', 'L', 'L', 'V', '_', 'S', '_', 'W', 0,
  /* 24070 */ 'M', 'A', 'X', '_', 'S', '_', 'W', 0,
  /* 24078 */ 'C', 'O', 'P', 'Y', '_', 'S', '_', 'W', 0,
  /* 24087 */ 'S', 'P', 'L', 'A', 'T', '_', 'W', 0,
  /* 24095 */ 'B', 'S', 'E', 'T', '_', 'W', 0,
  /* 24102 */ 'F', 'C', 'L', 'T', '_', 'W', 0,
  /* 24109 */ 'F', 'S', 'L', 'T', '_', 'W', 0,
  /* 24116 */ 'F', 'C', 'U', 'L', 'T', '_', 'W', 0,
  /* 24124 */ 'F', 'S', 'U', 'L', 'T', '_', 'W', 0,
  /* 24132 */ 'P', 'C', 'N', 'T', '_', 'W', 0,
  /* 24139 */ 'F', 'R', 'I', 'N', 'T', '_', 'W', 0,
  /* 24147 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'W', 0,
  /* 24156 */ 'F', 'S', 'Q', 'R', 'T', '_', 'W', 0,
  /* 24164 */ 'F', 'R', 'S', 'Q', 'R', 'T', '_', 'W', 0,
  /* 24173 */ 'S', 'T', '_', 'W', 0,
  /* 24178 */ 'A', 'S', 'U', 'B', '_', 'U', '_', 'W', 0,
  /* 24187 */ 'H', 'S', 'U', 'B', '_', 'U', '_', 'W', 0,
  /* 24196 */ 'D', 'P', 'S', 'U', 'B', '_', 'U', '_', 'W', 0,
  /* 24206 */ 'F', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'W', 0,
  /* 24217 */ 'H', 'A', 'D', 'D', '_', 'U', '_', 'W', 0,
  /* 24226 */ 'D', 'P', 'A', 'D', 'D', '_', 'U', '_', 'W', 0,
  /* 24236 */ 'M', 'O', 'D', '_', 'U', '_', 'W', 0,
  /* 24244 */ 'C', 'L', 'E', '_', 'U', '_', 'W', 0,
  /* 24252 */ 'A', 'V', 'E', '_', 'U', '_', 'W', 0,
  /* 24260 */ 'C', 'L', 'E', 'I', '_', 'U', '_', 'W', 0,
  /* 24269 */ 'M', 'I', 'N', 'I', '_', 'U', '_', 'W', 0,
  /* 24278 */ 'C', 'L', 'T', 'I', '_', 'U', '_', 'W', 0,
  /* 24287 */ 'M', 'A', 'X', 'I', '_', 'U', '_', 'W', 0,
  /* 24296 */ 'M', 'I', 'N', '_', 'U', '_', 'W', 0,
  /* 24304 */ 'D', 'O', 'T', 'P', '_', 'U', '_', 'W', 0,
  /* 24313 */ 'A', 'V', 'E', 'R', '_', 'U', '_', 'W', 0,
  /* 24322 */ 'S', 'U', 'B', 'S', '_', 'U', '_', 'W', 0,
  /* 24331 */ 'A', 'D', 'D', 'S', '_', 'U', '_', 'W', 0,
  /* 24340 */ 'S', 'U', 'B', 'S', 'U', 'S', '_', 'U', '_', 'W', 0,
  /* 24351 */ 'S', 'A', 'T', '_', 'U', '_', 'W', 0,
  /* 24359 */ 'C', 'L', 'T', '_', 'U', '_', 'W', 0,
  /* 24367 */ 'F', 'F', 'I', 'N', 'T', '_', 'U', '_', 'W', 0,
  /* 24377 */ 'F', 'T', 'I', 'N', 'T', '_', 'U', '_', 'W', 0,
  /* 24387 */ 'D', 'I', 'V', '_', 'U', '_', 'W', 0,
  /* 24395 */ 'M', 'A', 'X', '_', 'U', '_', 'W', 0,
  /* 24403 */ 'C', 'O', 'P', 'Y', '_', 'U', '_', 'W', 0,
  /* 24412 */ 'M', 'S', 'U', 'B', 'V', '_', 'W', 0,
  /* 24420 */ 'M', 'A', 'D', 'D', 'V', '_', 'W', 0,
  /* 24428 */ 'P', 'C', 'K', 'E', 'V', '_', 'W', 0,
  /* 24436 */ 'I', 'L', 'V', 'E', 'V', '_', 'W', 0,
  /* 24444 */ 'F', 'D', 'I', 'V', '_', 'W', 0,
  /* 24451 */ 'M', 'U', 'L', 'V', '_', 'W', 0,
  /* 24458 */ 'E', 'X', 'T', 'R', 'V', '_', 'W', 0,
  /* 24466 */ 'F', 'M', 'A', 'X', '_', 'W', 0,
  /* 24473 */ 'B', 'Z', '_', 'W', 0,
  /* 24478 */ 'B', 'N', 'Z', '_', 'W', 0,
  /* 24484 */ 'G', '_', 'S', 'M', 'A', 'X', 0,
  /* 24491 */ 'G', '_', 'U', 'M', 'A', 'X', 0,
  /* 24498 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'A', 'X', 0,
  /* 24515 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'A', 'X', 0,
  /* 24531 */ 'M', 'F', 'T', 'A', 'C', 'X', 0,
  /* 24538 */ 'M', 'T', 'T', 'A', 'C', 'X', 0,
  /* 24545 */ 'G', '_', 'F', 'R', 'A', 'M', 'E', '_', 'I', 'N', 'D', 'E', 'X', 0,
  /* 24559 */ 'L', 'H', 'X', 0,
  /* 24563 */ 'J', 'A', 'L', 'X', 0,
  /* 24568 */ 'L', 'B', 'U', 'X', 0,
  /* 24573 */ 'L', 'W', 'X', 0,
  /* 24577 */ 'C', 'O', 'P', 'Y', 0,
  /* 24582 */ 'C', 'O', 'N', 'S', 'T', 'P', 'O', 'O', 'L', '_', 'E', 'N', 'T', 'R', 'Y', 0,
  /* 24598 */ 'B', 'G', 'E', 'Z', 0,
  /* 24603 */ 'B', 'L', 'E', 'Z', 0,
  /* 24608 */ 'B', 'C', '1', 'N', 'E', 'Z', 0,
  /* 24615 */ 'B', 'C', '2', 'N', 'E', 'Z', 0,
  /* 24622 */ 'S', 'E', 'L', 'N', 'E', 'Z', 0,
  /* 24629 */ 'D', 'C', 'L', 'Z', 0,
  /* 24634 */ 'G', '_', 'C', 'T', 'L', 'Z', 0,
  /* 24641 */ 'B', 'C', '1', 'E', 'Q', 'Z', 0,
  /* 24648 */ 'B', 'C', '2', 'E', 'Q', 'Z', 0,
  /* 24655 */ 'S', 'E', 'L', 'E', 'Q', 'Z', 0,
  /* 24662 */ 'B', 'G', 'T', 'Z', 0,
  /* 24667 */ 'B', 'L', 'T', 'Z', 0,
  /* 24672 */ 'G', '_', 'C', 'T', 'T', 'Z', 0,
  /* 24679 */ 'S', 'e', 'l', 'B', 'n', 'e', 'Z', 0,
  /* 24687 */ 'S', 'e', 'l', 'B', 'e', 'q', 'Z', 0,
  /* 24695 */ 'J', 'a', 'l', 'O', 'n', 'e', 'R', 'e', 'g', 0,
  /* 24705 */ 'J', 'a', 'l', 'T', 'w', 'o', 'R', 'e', 'g', 0,
  /* 24715 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'H', 'a', 'z', 'a', 'r', 'd', 'B', 'r', 'a', 'n', 'c', 'h', 0,
  /* 24742 */ 'P', 's', 'e', 'u', 'd', 'o', 'I', 'n', 'd', 'i', 'r', 'e', 'c', 't', 'B', 'r', 'a', 'n', 'c', 'h', 0,
  /* 24763 */ 'U', 'l', 'h', 0,
  /* 24767 */ 'U', 's', 'h', 0,
  /* 24771 */ 'D', 'A', 'D', 'D', 'i', 0,
  /* 24777 */ 'A', 'N', 'D', 'i', 0,
  /* 24782 */ 'S', 'N', 'E', 'i', 0,
  /* 24787 */ 'S', 'E', 'Q', 'i', 0,
  /* 24792 */ 'X', 'O', 'R', 'i', 0,
  /* 24797 */ 'S', 'L', 'T', 'i', 0,
  /* 24802 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'L', 'U', 'i', 0,
  /* 24818 */ 'S', 'e', 'l', 'T', 'B', 't', 'n', 'e', 'Z', 'C', 'm', 'p', 'i', 0,
  /* 24832 */ 'S', 'e', 'l', 'T', 'B', 't', 'e', 'q', 'Z', 'C', 'm', 'p', 'i', 0,
  /* 24846 */ 'S', 'e', 'l', 'T', 'B', 't', 'n', 'e', 'Z', 'S', 'l', 't', 'i', 0,
  /* 24860 */ 'S', 'e', 'l', 'T', 'B', 't', 'e', 'q', 'Z', 'S', 'l', 't', 'i', 0,
  /* 24874 */ 'S', 'G', 'E', 'I', 'm', 'm', 0,
  /* 24881 */ 'D', 'R', 'O', 'L', 'I', 'm', 'm', 0,
  /* 24889 */ 'N', 'O', 'R', 'I', 'm', 'm', 0,
  /* 24896 */ 'D', 'R', 'O', 'R', 'I', 'm', 'm', 0,
  /* 24904 */ 'S', 'G', 'T', 'I', 'm', 'm', 0,
  /* 24911 */ 'S', 'G', 'E', 'U', 'I', 'm', 'm', 0,
  /* 24919 */ 'S', 'G', 'T', 'U', 'I', 'm', 'm', 0,
  /* 24927 */ 'B', 'n', 'e', 'I', 'm', 'm', 0,
  /* 24934 */ 'B', 'e', 'q', 'I', 'm', 'm', 0,
  /* 24941 */ 'P', 's', 'e', 'u', 'd', 'o', 'R', 'e', 't', 'u', 'r', 'n', 0,
  /* 24954 */ 'J', 'A', 'L', 'R', 'H', 'B', '6', '4', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 24969 */ 'J', 'A', 'L', 'R', '6', '4', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 24982 */ 'J', 'A', 'L', 'R', 'H', 'B', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 24995 */ 'J', 'A', 'L', 'R', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 25006 */ 'B', '_', 'M', 'M', 'R', '6', '_', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 25020 */ 'B', '_', 'M', 'M', '_', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 25032 */ 'S', 'D', 'I', 'V', '_', 'M', 'M', '_', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 25047 */ 'U', 'D', 'I', 'V', '_', 'M', 'M', '_', 'P', 's', 'e', 'u', 'd', 'o', 0,
  /* 25062 */ 'L', 'D', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25070 */ 'S', 'D', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25078 */ 'S', 'E', 'Q', 'I', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25088 */ 'D', 'S', 'R', 'e', 'm', 'I', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25100 */ 'D', 'U', 'R', 'e', 'm', 'I', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25112 */ 'D', 'S', 'D', 'i', 'v', 'I', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25124 */ 'D', 'U', 'D', 'i', 'v', 'I', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25136 */ 'D', 'M', 'U', 'L', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25146 */ 'D', 'M', 'U', 'L', 'O', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25157 */ 'S', 'E', 'Q', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25166 */ 'A', 'B', 'S', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25175 */ 'D', 'M', 'U', 'L', 'O', 'U', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25187 */ 'D', 'S', 'R', 'e', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25198 */ 'D', 'U', 'R', 'e', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25209 */ 'B', 'G', 'E', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25221 */ 'B', 'L', 'E', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25233 */ 'B', 'G', 'E', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25246 */ 'B', 'L', 'E', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25259 */ 'B', 'N', 'E', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25272 */ 'B', 'E', 'Q', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25285 */ 'B', 'G', 'T', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25298 */ 'B', 'L', 'T', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25311 */ 'B', 'G', 'E', 'U', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25325 */ 'B', 'L', 'E', 'U', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25339 */ 'D', 'M', 'U', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25352 */ 'B', 'G', 'T', 'U', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25366 */ 'B', 'L', 'T', 'U', 'L', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25380 */ 'B', 'G', 'T', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25392 */ 'B', 'L', 'T', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25404 */ 'B', 'G', 'E', 'U', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25417 */ 'B', 'L', 'E', 'U', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25430 */ 'B', 'G', 'T', 'U', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25443 */ 'B', 'L', 'T', 'U', 'I', 'm', 'm', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25456 */ 'D', 'S', 'D', 'i', 'v', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25467 */ 'D', 'U', 'D', 'i', 'v', 'M', 'a', 'c', 'r', 'o', 0,
  /* 25478 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'L', 'U', 'i', '2', 'O', 'p', 0,
  /* 25497 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'D', 'A', 'D', 'D', 'i', 'u', '2', 'O', 'p', 0,
  /* 25519 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'A', 'D', 'D', 'i', 'u', '2', 'O', 'p', 0,
  /* 25540 */ 'S', 'e', 'l', 'T', 'B', 't', 'n', 'e', 'Z', 'C', 'm', 'p', 0,
  /* 25553 */ 'S', 'e', 'l', 'T', 'B', 't', 'e', 'q', 'Z', 'C', 'm', 'p', 0,
  /* 25566 */ 'E', 'R', 'e', 't', 0,
  /* 25571 */ 'S', 'e', 'l', 'T', 'B', 't', 'n', 'e', 'Z', 'S', 'l', 't', 0,
  /* 25584 */ 'S', 'e', 'l', 'T', 'B', 't', 'e', 'q', 'Z', 'S', 'l', 't', 0,
  /* 25597 */ 'L', 'B', 'u', 0,
  /* 25601 */ 'D', 'S', 'U', 'B', 'u', 0,
  /* 25607 */ 'B', 'A', 'D', 'D', 'u', 0,
  /* 25613 */ 'D', 'A', 'D', 'D', 'u', 0,
  /* 25619 */ 'L', 'H', 'u', 0,
  /* 25623 */ 'S', 'L', 'T', 'u', 0,
  /* 25628 */ 'P', 's', 'e', 'u', 'd', 'o', 'D', 'M', 'U', 'L', 'T', 'u', 0,
  /* 25641 */ 'P', 's', 'e', 'u', 'd', 'o', 'M', 'U', 'L', 'T', 'u', 0,
  /* 25653 */ 'L', 'W', 'u', 0,
  /* 25657 */ 'U', 'l', 'h', 'u', 0,
  /* 25662 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'D', 'A', 'D', 'D', 'i', 'u', 0,
  /* 25681 */ 'L', 'E', 'A', '_', 'A', 'D', 'D', 'i', 'u', 0,
  /* 25691 */ 'L', 'O', 'N', 'G', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'A', 'D', 'D', 'i', 'u', 0,
  /* 25709 */ 'S', 'L', 'T', 'i', 'u', 0,
  /* 25715 */ 'S', 'e', 'l', 'T', 'B', 't', 'n', 'e', 'Z', 'S', 'l', 't', 'i', 'u', 0,
  /* 25730 */ 'S', 'e', 'l', 'T', 'B', 't', 'e', 'q', 'Z', 'S', 'l', 't', 'i', 'u', 0,
  /* 25745 */ 'S', 'e', 'l', 'T', 'B', 't', 'n', 'e', 'Z', 'S', 'l', 't', 'u', 0,
  /* 25759 */ 'S', 'e', 'l', 'T', 'B', 't', 'e', 'q', 'Z', 'S', 'l', 't', 'u', 0,
  /* 25773 */ 'U', 'l', 'w', 0,
  /* 25777 */ 'U', 's', 'w', 0,
};

extern const unsigned MipsInstrNameIndices[] = {
    14002U, 19424U, 21040U, 19594U, 14343U, 14324U, 14352U, 14597U, 
    12401U, 12416U, 12295U, 12442U, 21480U, 12193U, 14333U, 11991U, 
    24577U, 12113U, 22503U, 10519U, 20548U, 14569U, 22450U, 10564U, 
    22439U, 12146U, 20680U, 20667U, 21074U, 22278U, 22301U, 14501U, 
    14548U, 14521U, 14384U, 10428U, 9328U, 14662U, 22762U, 22792U, 
    14749U, 14756U, 10482U, 21285U, 21263U, 12293U, 14000U, 24545U, 
    12203U, 22240U, 21414U, 22518U, 21431U, 21231U, 10214U, 21463U, 
    22461U, 21364U, 22535U, 10188U, 10541U, 10386U, 10364U, 10375U, 
    12169U, 21497U, 12456U, 12473U, 10434U, 9334U, 10488U, 10465U, 
    21290U, 21269U, 24515U, 19545U, 24498U, 19528U, 11983U, 10532U, 
    22259U, 10100U, 21527U, 22588U, 10206U, 22428U, 22416U, 22493U, 
    12497U, 22581U, 22597U, 14462U, 21198U, 21191U, 20641U, 20634U, 
    22250U, 19651U, 12016U, 19635U, 11975U, 19643U, 12008U, 19627U, 
    11967U, 20540U, 20532U, 12542U, 12534U, 10410U, 9310U, 14655U, 
    8013U, 22743U, 14742U, 22944U, 20938U, 1099U, 12490U, 1081U, 
    0U, 12330U, 22573U, 10178U, 14028U, 14052U, 20603U, 20612U, 
    21407U, 19502U, 12226U, 19468U, 19478U, 12024U, 12039U, 19446U, 
    19457U, 20597U, 14217U, 19514U, 24484U, 19521U, 24491U, 21028U, 
    22325U, 22357U, 22336U, 21246U, 24672U, 12275U, 24634U, 12257U, 
    20659U, 20562U, 14468U, 21456U, 19561U, 22527U, 21217U, 22472U, 
    22480U, 22545U, 21053U, 12100U, 25166U, 19610U, 20915U, 19995U, 
    20079U, 20295U, 3700U, 8611U, 819U, 8187U, 2918U, 8399U, 
    7926U, 8818U, 3623U, 8506U, 742U, 8082U, 2789U, 8294U, 
    7853U, 8717U, 3664U, 8561U, 783U, 8137U, 2830U, 8349U, 
    7892U, 8770U, 3643U, 8533U, 762U, 8109U, 2809U, 8321U, 
    7872U, 8743U, 3740U, 8665U, 859U, 8241U, 2958U, 8453U, 
    7964U, 8870U, 3603U, 8479U, 722U, 8055U, 2769U, 8267U, 
    7834U, 8691U, 3720U, 8638U, 839U, 8214U, 2938U, 8426U, 
    7945U, 8844U, 3684U, 8588U, 803U, 8164U, 2902U, 8376U, 
    7911U, 8796U, 8925U, 21033U, 18002U, 25272U, 12067U, 25209U, 
    14369U, 25233U, 22634U, 25404U, 14638U, 25311U, 22292U, 25380U, 
    14628U, 25285U, 22698U, 25430U, 14668U, 25352U, 12109U, 25221U, 
    14374U, 25246U, 22649U, 25417U, 14644U, 25325U, 22332U, 25392U, 
    14633U, 25298U, 22703U, 25443U, 14674U, 25366U, 25259U, 19693U, 
    19981U, 19874U, 20174U, 20065U, 20281U, 16194U, 25006U, 25020U, 
    24934U, 24927U, 4263U, 3810U, 4291U, 3840U, 4321U, 4352U, 
    4249U, 3795U, 4277U, 3825U, 4305U, 4337U, 2647U, 3243U, 
    122U, 24582U, 19921U, 20221U, 140U, 1038U, 25339U, 25136U, 
    25146U, 25175U, 14607U, 24881U, 21226U, 24896U, 25112U, 25456U, 
    25088U, 25187U, 25124U, 25467U, 25100U, 25198U, 25566U, 2660U, 
    3259U, 11255U, 23737U, 19659U, 19676U, 19889U, 20189U, 4410U, 
    19709U, 20365U, 19756U, 20408U, 19904U, 19732U, 20386U, 20204U, 
    19802U, 20450U, 19779U, 20429U, 19826U, 20472U, 24969U, 24954U, 
    24982U, 24995U, 6547U, 24695U, 24705U, 25062U, 3589U, 7809U, 
    1938U, 20692U, 20777U, 25691U, 25519U, 25662U, 25497U, 24802U, 
    25478U, 3289U, 17546U, 1006U, 3480U, 973U, 3311U, 996U, 
    3470U, 21105U, 953U, 21319U, 21122U, 21336U, 1036U, 24531U, 
    43U, 128U, 20733U, 21305U, 103U, 14006U, 20515U, 1020U, 
    3509U, 19936U, 20236U, 19959U, 20259U, 24538U, 55U, 146U, 
    20740U, 21312U, 110U, 14017U, 20526U, 25340U, 25147U, 25176U, 
    4670U, 4803U, 4702U, 4855U, 20650U, 24889U, 3413U, 20010U, 
    20094U, 20310U, 20011U, 20095U, 20311U, 9105U, 9007U, 9220U, 
    12704U, 12599U, 12864U, 22954U, 14712U, 22986U, 14728U, 24027U, 
    22385U, 25628U, 22750U, 22780U, 14146U, 2977U, 24742U, 3354U, 
    4915U, 7786U, 19286U, 7580U, 24715U, 3325U, 4885U, 7758U, 
    10417U, 22616U, 18730U, 16526U, 13976U, 2708U, 17178U, 20498U, 
    3071U, 17567U, 9317U, 22604U, 18715U, 16457U, 13987U, 2721U, 
    20817U, 17192U, 22397U, 18694U, 25641U, 19387U, 12633U, 9042U, 
    24941U, 3494U, 22769U, 379U, 2256U, 14109U, 2859U, 21771U, 
    611U, 2545U, 14185U, 3022U, 22125U, 526U, 2460U, 14163U, 
    2996U, 22009U, 11907U, 650U, 22158U, 22799U, 14608U, 24882U, 
    21227U, 24897U, 8895U, 3574U, 203U, 25032U, 25070U, 25113U, 
    25457U, 25078U, 25157U, 12071U, 24874U, 3404U, 22639U, 24911U, 
    3440U, 24904U, 3422U, 24919U, 3450U, 3431U, 3460U, 19849U, 
    20040U, 20124U, 20149U, 20340U, 25089U, 25188U, 7821U, 1949U, 
    20706U, 20792U, 3596U, 17553U, 19862U, 20053U, 20137U, 20162U, 
    20353U, 24687U, 24679U, 25553U, 24832U, 25584U, 24860U, 25730U, 
    25759U, 25540U, 24818U, 25571U, 24846U, 25715U, 25745U, 4615U, 
    4074U, 4089U, 4627U, 4842U, 14476U, 12355U, 12337U, 12371U, 
    12387U, 12430U, 2678U, 8943U, 1894U, 16737U, 6424U, 17477U, 
    6556U, 20557U, 17598U, 25047U, 25125U, 25468U, 25101U, 25199U, 
    24763U, 25657U, 25773U, 24767U, 25777U, 20025U, 20109U, 20325U, 
    12823U, 16993U, 9165U, 1247U, 23955U, 19161U, 10406U, 10258U, 
    16479U, 5601U, 17678U, 15426U, 15839U, 17850U, 7466U, 12624U, 
    1350U, 12741U, 1405U, 23698U, 1763U, 23272U, 1735U, 12696U, 
    16889U, 12803U, 16980U, 23937U, 19149U, 10282U, 16490U, 9372U, 
    10637U, 13103U, 23025U, 9780U, 11424U, 13592U, 23982U, 9972U, 
    11789U, 13841U, 24331U, 16056U, 5341U, 9033U, 1152U, 9143U, 
    1215U, 7436U, 12888U, 1493U, 9245U, 16380U, 12843U, 1465U, 
    9185U, 16327U, 9586U, 11001U, 13288U, 23390U, 10042U, 11870U, 
    13911U, 24421U, 10315U, 16499U, 9356U, 10620U, 13087U, 23008U, 
    16533U, 5823U, 24772U, 19310U, 25675U, 19406U, 25608U, 19364U, 
    19489U, 6614U, 10251U, 5589U, 10478U, 15867U, 5182U, 2072U, 
    15894U, 5215U, 9461U, 6479U, 16540U, 5832U, 22870U, 24777U, 
    3377U, 19318U, 10512U, 1307U, 9685U, 11271U, 13441U, 23784U, 
    9877U, 11636U, 13699U, 24178U, 14048U, 10245U, 5578U, 6507U, 
    9762U, 11406U, 13565U, 23964U, 9954U, 11771U, 13823U, 24313U, 
    9710U, 11345U, 13504U, 23858U, 9902U, 11710U, 13762U, 24252U, 
    4142U, 4018U, 4526U, 4170U, 3967U, 4466U, 4034U, 4829U, 
    4768U, 15851U, 25607U, 14228U, 10112U, 5457U, 19488U, 1668U, 
    76U, 222U, 216U, 230U, 10083U, 5122U, 24641U, 5764U, 
    12252U, 14404U, 16709U, 24608U, 5727U, 22235U, 14622U, 18655U, 
    24648U, 5777U, 24615U, 5740U, 9522U, 10951U, 13238U, 23340U, 
    9656U, 11196U, 13412U, 23613U, 5420U, 20945U, 3091U, 10277U, 
    1989U, 5624U, 14612U, 16101U, 10147U, 5517U, 10339U, 5169U, 
    2048U, 16517U, 5790U, 17899U, 10086U, 1961U, 5428U, 10293U, 
    2008U, 5663U, 24598U, 3197U, 14236U, 10123U, 5478U, 14581U, 
    18171U, 17312U, 10321U, 2024U, 5705U, 14688U, 19247U, 24662U, 
    3229U, 10155U, 5530U, 10345U, 2056U, 5801U, 14700U, 19270U, 
    9498U, 10927U, 13214U, 23316U, 9628U, 11050U, 13315U, 23433U, 
    9552U, 10967U, 13254U, 23356U, 9670U, 11240U, 13426U, 23657U, 
    22731U, 18794U, 20571U, 6634U, 24603U, 3204U, 10131U, 5491U, 
    10327U, 2032U, 5716U, 14694U, 19255U, 10288U, 2001U, 5653U, 
    10299U, 2016U, 5674U, 24667U, 3236U, 14243U, 10163U, 5543U, 
    14589U, 18182U, 17322U, 10351U, 2064U, 5812U, 14706U, 19278U, 
    9601U, 22919U, 9594U, 22907U, 12134U, 2641U, 10091U, 1968U, 
    5438U, 9468U, 10905U, 13192U, 23294U, 9440U, 10884U, 13171U, 
    23198U, 14379U, 16091U, 10139U, 5504U, 10333U, 5156U, 2040U, 
    16508U, 5753U, 16640U, 10305U, 5685U, 10077U, 11944U, 13946U, 
    22913U, 24478U, 10310U, 5695U, 713U, 1827U, 15368U, 14206U, 
    15922U, 5237U, 17296U, 6536U, 9476U, 22883U, 9570U, 10985U, 
    13272U, 23374U, 9849U, 11513U, 13671U, 24095U, 10072U, 11930U, 
    13941U, 22902U, 24473U, 4553U, 4199U, 4565U, 4212U, 4541U, 
    4186U, 4452U, 4877U, 4376U, 4869U, 4367U, 12079U, 12054U, 
    16568U, 16594U, 6367U, 7702U, 2351U, 6030U, 21864U, 7014U, 
    680U, 2608U, 6299U, 18987U, 22184U, 18619U, 7295U, 9507U, 
    10936U, 13223U, 23325U, 9643U, 11120U, 13338U, 23516U, 92U, 
    14817U, 15410U, 8906U, 21446U, 900U, 933U, 987U, 11263U, 
    6172U, 22001U, 7156U, 9718U, 11353U, 13512U, 23866U, 9910U, 
    11718U, 13770U, 24260U, 9702U, 11337U, 13496U, 23850U, 9894U, 
    11702U, 13754U, 24244U, 20494U, 17560U, 6625U, 7734U, 9736U, 
    11371U, 13530U, 23884U, 9928U, 11736U, 13788U, 24278U, 9797U, 
    11441U, 13609U, 23999U, 10000U, 11817U, 13869U, 24359U, 24630U, 
    19263U, 7559U, 7751U, 9080U, 1166U, 8982U, 1120U, 9195U, 
    1262U, 9093U, 16285U, 8995U, 16212U, 9208U, 16340U, 9111U, 
    16300U, 9013U, 16227U, 9226U, 16355U, 5949U, 6909U, 11180U, 
    6158U, 12710U, 16900U, 21985U, 7142U, 10876U, 21790U, 10782U, 
    5920U, 12605U, 16819U, 21716U, 6880U, 11581U, 6231U, 12870U, 
    17020U, 22086U, 7215U, 10843U, 5934U, 21725U, 6894U, 11133U, 
    6112U, 21939U, 7096U, 10735U, 5874U, 21670U, 6834U, 11534U, 
    6185U, 22040U, 7169U, 11159U, 6127U, 21949U, 7111U, 10761U, 
    5889U, 21680U, 6849U, 11560U, 6200U, 22050U, 7184U, 11093U, 
    6083U, 21897U, 7067U, 11170U, 6143U, 21968U, 7127U, 10772U, 
    5905U, 21699U, 6865U, 11571U, 6216U, 22069U, 7200U, 11103U, 
    6098U, 21914U, 7082U, 9832U, 11496U, 13654U, 24078U, 10024U, 
    13893U, 24403U, 8920U, 8927U, 10393U, 12522U, 22933U, 10357U, 
    12505U, 22926U, 117U, 14833U, 15418U, 8913U, 21559U, 18217U, 
    22960U, 18906U, 14718U, 21569U, 18230U, 22992U, 18919U, 6588U, 
    2374U, 15624U, 6059U, 21883U, 18424U, 7043U, 3159U, 516U, 
    15229U, 2450U, 15712U, 14734U, 6601U, 3048U, 3176U, 24033U, 
    19173U, 7534U, 703U, 15355U, 2631U, 15826U, 22203U, 18644U, 
    7324U, 498U, 15205U, 2432U, 15688U, 21978U, 18478U, 371U, 
    15066U, 2248U, 15576U, 21765U, 18360U, 344U, 15030U, 2221U, 
    15552U, 21709U, 18330U, 573U, 15281U, 2507U, 15764U, 22079U, 
    18531U, 303U, 14977U, 2180U, 15499U, 21645U, 18285U, 313U, 
    14990U, 2190U, 15512U, 21653U, 18296U, 431U, 15117U, 2308U, 
    15599U, 21829U, 18403U, 543U, 15242U, 2477U, 15725U, 22024U, 
    18498U, 324U, 15004U, 2201U, 15526U, 21662U, 18308U, 553U, 
    15255U, 2487U, 15738U, 22032U, 18509U, 478U, 15179U, 2412U, 
    15662U, 21931U, 18456U, 353U, 15042U, 2230U, 15564U, 21751U, 
    18340U, 488U, 15192U, 2422U, 15675U, 21960U, 18467U, 334U, 
    15017U, 2211U, 15539U, 21691U, 18319U, 563U, 15268U, 2497U, 
    15751U, 22061U, 18520U, 450U, 15142U, 2384U, 15637U, 21907U, 
    18435U, 4650U, 4489U, 4116U, 10405U, 24771U, 25674U, 25613U, 
    13971U, 19495U, 14037U, 14047U, 20570U, 20493U, 7733U, 24629U, 
    7750U, 22738U, 22719U, 22272U, 18663U, 7376U, 22568U, 943U, 
    19440U, 22713U, 13958U, 21451U, 19434U, 22692U, 22739U, 22720U, 
    7487U, 7497U, 9816U, 11480U, 13628U, 24052U, 10008U, 11845U, 
    13877U, 24387U, 17156U, 6481U, 8901U, 7665U, 9U, 97U, 
    1059U, 19568U, 15U, 10559U, 22628U, 22408U, 49U, 134U, 
    1065U, 19581U, 36U, 13076U, 22654U, 14650U, 22391U, 25634U, 
    22680U, 7725U, 11397U, 13556U, 23919U, 11762U, 13814U, 24304U, 
    11319U, 13478U, 23832U, 11684U, 13736U, 24226U, 12952U, 1550U, 
    13027U, 1602U, 23455U, 18997U, 12989U, 17069U, 14294U, 17385U, 
    21006U, 17974U, 13053U, 1638U, 12932U, 1520U, 20654U, 12966U, 
    1569U, 13040U, 1620U, 23467U, 19012U, 13015U, 17101U, 11289U, 
    13459U, 23802U, 11654U, 13717U, 24196U, 14305U, 17399U, 21017U, 
    17988U, 13063U, 1653U, 12980U, 1588U, 21358U, 892U, 22858U, 
    12512U, 22756U, 10450U, 14602U, 878U, 923U, 22810U, 8050U, 
    238U, 22725U, 14617U, 885U, 22816U, 9305U, 25601U, 22786U, 
    20930U, 12159U, 6706U, 4736U, 4714U, 8939U, 16199U, 5372U, 
    13963U, 17164U, 6489U, 22412U, 22273U, 10171U, 5556U, 18664U, 
    7377U, 20934U, 12164U, 6715U, 22569U, 20910U, 20590U, 22844U, 
    18857U, 17623U, 22852U, 18868U, 17877U, 23764U, 19111U, 23727U, 
    19085U, 13636U, 17134U, 24458U, 19197U, 23754U, 19098U, 23708U, 
    19060U, 13574U, 17122U, 23665U, 19038U, 21554U, 907U, 18708U, 
    7408U, 507U, 15217U, 2441U, 15700U, 21994U, 18488U, 10684U, 
    284U, 14952U, 2161U, 15487U, 21630U, 18264U, 6822U, 23072U, 
    10829U, 23177U, 11119U, 23515U, 11262U, 23775U, 10721U, 23109U, 
    11520U, 24102U, 469U, 15167U, 2403U, 914U, 15398U, 10791U, 
    23139U, 11210U, 23627U, 11143U, 23529U, 10745U, 23123U, 11544U, 
    24116U, 10805U, 23153U, 11079U, 23486U, 11893U, 632U, 15331U, 
    2566U, 15802U, 22144U, 18573U, 7241U, 24444U, 13330U, 23500U, 
    10592U, 22978U, 11028U, 23411U, 11224U, 23641U, 11449U, 24007U, 
    11825U, 24367U, 11037U, 23420U, 11233U, 23650U, 9609U, 11015U, 
    13296U, 23398U, 10584U, 22970U, 2362U, 6044U, 21873U, 7028U, 
    691U, 2619U, 6313U, 19027U, 22193U, 18631U, 7309U, 10691U, 
    23079U, 10646U, 23034U, 11923U, 24466U, 10628U, 23016U, 11072U, 
    23479U, 641U, 15343U, 2575U, 15814U, 6257U, 22151U, 18583U, 
    7253U, 10662U, 23050U, 11058U, 441U, 15130U, 2318U, 15612U, 
    21837U, 18414U, 6972U, 23441U, 400U, 15077U, 2277U, 15587U, 
    21798U, 18369U, 6949U, 14212U, 11112U, 23508U, 11597U, 24139U, 
    11622U, 24164U, 10836U, 23184U, 11126U, 23522U, 10728U, 23116U, 
    11527U, 24109U, 10798U, 23146U, 11217U, 23634U, 11614U, 582U, 
    15293U, 2516U, 15776U, 22102U, 18541U, 24156U, 10655U, 265U, 
    14927U, 2142U, 15475U, 21615U, 18243U, 6810U, 23043U, 11151U, 
    23537U, 10753U, 23131U, 11552U, 24124U, 10813U, 23161U, 11086U, 
    23493U, 11459U, 24017U, 11835U, 24377U, 13344U, 23545U, 11299U, 
    23812U, 11664U, 24206U, 14061U, 6525U, 22562U, 7397U, 11310U, 
    13469U, 23823U, 11675U, 13727U, 24217U, 11280U, 13450U, 23793U, 
    11645U, 13708U, 24187U, 14485U, 17489U, 10057U, 11885U, 13926U, 
    24436U, 9636U, 11065U, 13323U, 23448U, 9417U, 10713U, 13148U, 
    23101U, 9678U, 11248U, 13434U, 23672U, 21447U, 9863U, 11605U, 
    13685U, 24147U, 22865U, 9425U, 10821U, 13156U, 23169U, 18886U, 
    18193U, 6777U, 14204U, 14232U, 21208U, 15998U, 3102U, 5143U, 
    5381U, 5634U, 16017U, 18200U, 8963U, 1918U, 18091U, 18163U, 
    24563U, 19224U, 17305U, 10117U, 1981U, 5467U, 10096U, 1975U, 
    5448U, 21205U, 15990U, 3097U, 20900U, 15858U, 5132U, 6680U, 
    8957U, 1910U, 7638U, 7673U, 18085U, 17291U, 4460U, 3582U, 
    4393U, 4385U, 4599U, 4431U, 8971U, 1928U, 11959U, 16547U, 
    16037U, 24568U, 19232U, 7417U, 16206U, 5395U, 25597U, 3525U, 
    12242U, 16693U, 19349U, 10458U, 82U, 1842U, 5084U, 14801U, 
    1049U, 5002U, 7606U, 1807U, 9455U, 10899U, 13186U, 23288U, 
    14316U, 10240U, 21066U, 162U, 1856U, 9404U, 10700U, 13135U, 
    23088U, 25681U, 3544U, 19402U, 12539U, 2698U, 12085U, 16603U, 
    16066U, 24559U, 19217U, 16767U, 25619U, 3531U, 12247U, 16701U, 
    19372U, 15914U, 5227U, 14482U, 3043U, 7657U, 10461U, 7695U, 
    12120U, 16617U, 17483U, 6562U, 7719U, 8902U, 5363U, 7666U, 
    6516U, 174U, 1872U, 14865U, 24814U, 3398U, 19342U, 22941U, 
    16075U, 3187U, 152U, 14849U, 1071U, 5064U, 7622U, 1817U, 
    20747U, 17709U, 12218U, 16679U, 17651U, 14680U, 3059U, 12124U, 
    16624U, 17532U, 15951U, 5272U, 15380U, 10272U, 5614U, 17885U, 
    21399U, 3129U, 12177U, 16654U, 18149U, 17861U, 10266U, 18779U, 
    24573U, 186U, 14883U, 18209U, 19240U, 18894U, 7518U, 25653U, 
    3869U, 3933U, 3901U, 3950U, 4479U, 4220U, 4105U, 4579U, 
    4236U, 3986U, 4048U, 10423U, 10861U, 5976U, 21743U, 6936U, 
    13386U, 23587U, 22622U, 20880U, 17824U, 18736U, 10041U, 11869U, 
    13910U, 24420U, 294U, 14965U, 2171U, 20768U, 17739U, 16532U, 
    13359U, 23560U, 21638U, 18275U, 14410U, 17413U, 21139U, 18021U, 
    14436U, 17445U, 21165U, 18053U, 10613U, 5862U, 21608U, 6798U, 
    9745U, 11380U, 13539U, 23893U, 9937U, 11745U, 13797U, 24287U, 
    9381U, 10647U, 13112U, 23035U, 11924U, 6328U, 22211U, 9824U, 
    11488U, 13646U, 7337U, 24070U, 10016U, 11853U, 13885U, 24395U, 
    10U, 4940U, 98U, 2078U, 14825U, 4982U, 1060U, 5022U, 
    16U, 14763U, 4950U, 245U, 14901U, 2087U, 15437U, 5032U, 
    22U, 14772U, 13982U, 15904U, 2714U, 20808U, 17751U, 17184U, 
    20504U, 15969U, 3077U, 20843U, 17775U, 17573U, 21353U, 10600U, 
    5850U, 21601U, 6786U, 9727U, 11362U, 13521U, 23875U, 9919U, 
    11727U, 13779U, 24269U, 9364U, 10629U, 13095U, 23017U, 11073U, 
    6072U, 21891U, 9754U, 11389U, 13548U, 7056U, 23911U, 9946U, 
    11754U, 13806U, 24296U, 10560U, 9303U, 16447U, 22629U, 7446U, 
    5841U, 9694U, 11329U, 13488U, 23842U, 9886U, 11694U, 13746U, 
    24236U, 15876U, 5193U, 17633U, 6658U, 22876U, 362U, 15054U, 
    2239U, 14102U, 2850U, 17251U, 21758U, 18350U, 2116U, 14080U, 
    2743U, 21579U, 409U, 15089U, 2286U, 14128U, 2880U, 17261U, 
    21805U, 18379U, 602U, 15319U, 2536U, 14178U, 3013U, 17271U, 
    22118U, 18563U, 2129U, 14091U, 2756U, 21590U, 420U, 15103U, 
    2297U, 14137U, 2891U, 17281U, 21814U, 18391U, 9323U, 10853U, 
    5963U, 21735U, 6923U, 13376U, 23577U, 22610U, 20870U, 17811U, 
    18721U, 10033U, 11861U, 13902U, 24412U, 275U, 14940U, 2152U, 
    20759U, 17727U, 16463U, 13350U, 23551U, 21623U, 18254U, 50U, 
    4972U, 135U, 2107U, 15463U, 14841U, 4992U, 1066U, 5054U, 
    37U, 14792U, 4961U, 255U, 14914U, 2097U, 15450U, 5043U, 
    29U, 14782U, 14012U, 2736U, 20834U, 17763U, 17208U, 20627U, 
    17659U, 20521U, 3084U, 20852U, 17787U, 17590U, 66U, 198U, 
    1089U, 71U, 211U, 1094U, 21375U, 13077U, 22655U, 7456U, 
    6459U, 14651U, 14448U, 17460U, 21177U, 18068U, 14250U, 17332U, 
    20962U, 17921U, 12763U, 16940U, 23744U, 1778U, 12813U, 1435U, 
    23946U, 1793U, 13396U, 23597U, 13001U, 17084U, 12941U, 1534U, 
    22392U, 20890U, 17837U, 20861U, 17799U, 18700U, 25635U, 19393U, 
    22675U, 7477U, 10065U, 11900U, 13934U, 24451U, 17525U, 6579U, 
    12681U, 1377U, 13368U, 23569U, 7726U, 12784U, 1421U, 4445U, 
    4572U, 3759U, 3564U, 9389U, 10670U, 13120U, 23058U, 9396U, 
    10677U, 13127U, 23065U, 293U, 14964U, 2170U, 21637U, 18274U, 
    274U, 14939U, 2151U, 21622U, 18253U, 21213U, 3109U, 9538U, 
    18099U, 6724U, 22890U, 16028U, 5318U, 4640U, 4681U, 21214U, 
    16009U, 5308U, 3110U, 9539U, 6498U, 18100U, 6725U, 22891U, 
    24793U, 3385U, 19327U, 4780U, 12671U, 16865U, 12187U, 16670U, 
    6390U, 10049U, 11877U, 13918U, 24428U, 9409U, 10705U, 13140U, 
    23093U, 9856U, 11590U, 13678U, 24132U, 12639U, 16832U, 9048U, 
    16241U, 3141U, 3150U, 20655U, 14279U, 7997U, 16129U, 17367U, 
    20991U, 8034U, 16166U, 17956U, 14423U, 17429U, 21152U, 18037U, 
    14265U, 7982U, 16111U, 17350U, 20977U, 8019U, 16148U, 17939U, 
    12583U, 16800U, 23220U, 18954U, 12558U, 16784U, 23249U, 18969U, 
    12571U, 1319U, 23205U, 1680U, 23232U, 1700U, 12308U, 12061U, 
    16578U, 19208U, 16717U, 6401U, 7711U, 10504U, 1294U, 9289U, 
    16427U, 20721U, 17691U, 21393U, 3121U, 18140U, 6766U, 6742U, 
    459U, 15154U, 2393U, 15649U, 21923U, 18445U, 12914U, 17057U, 
    9271U, 16403U, 12655U, 16854U, 9064U, 16263U, 11598U, 6245U, 
    22095U, 7229U, 21359U, 22859U, 18877U, 18113U, 2339U, 6015U, 
    21854U, 6999U, 668U, 2596U, 6284U, 18943U, 22174U, 18606U, 
    7280U, 592U, 15306U, 2526U, 15789U, 22110U, 18552U, 4400U, 
    3776U, 9789U, 11433U, 13601U, 23991U, 9992U, 11809U, 13861U, 
    24351U, 9300U, 15850U, 5112U, 1933U, 11963U, 16554U, 16441U, 
    5403U, 10285U, 1996U, 7649U, 10401U, 7688U, 12004U, 16561U, 
    16493U, 5645U, 7682U, 10581U, 20579U, 15979U, 5294U, 17606U, 
    6647U, 7741U, 87U, 1849U, 5098U, 14809U, 1054U, 5012U, 
    7614U, 1812U, 22757U, 18804U, 14320U, 21070U, 168U, 1864U, 
    8935U, 1888U, 16192U, 12530U, 2692U, 16760U, 24655U, 3220U, 
    11950U, 6353U, 7568U, 22226U, 7362U, 24622U, 3211U, 11935U, 
    6339U, 7547U, 22217U, 7348U, 11009U, 5989U, 21823U, 6961U, 
    20949U, 24787U, 13073U, 15886U, 5205U, 2703U, 12089U, 16610U, 
    9434U, 13165U, 23192U, 20509U, 22837U, 18847U, 17581U, 12905U, 
    17045U, 9262U, 16391U, 12853U, 17006U, 24060U, 19184U, 12647U, 
    16843U, 9056U, 16252U, 12774U, 16954U, 23902U, 19125U, 12896U, 
    17033U, 9253U, 1280U, 12752U, 16926U, 9154U, 1231U, 23717U, 
    19072U, 12550U, 16773U, 8974U, 1107U, 12720U, 16913U, 9122U, 
    1184U, 23679U, 19048U, 12923U, 1506U, 9280U, 16415U, 12663U, 
    1364U, 9072U, 16274U, 17116U, 6451U, 12093U, 6378U, 9454U, 
    10898U, 13185U, 23287U, 9403U, 10699U, 13134U, 23087U, 14603U, 
    15933U, 5250U, 924U, 3280U, 9484U, 10913U, 13200U, 23302U, 
    22811U, 18820U, 9616U, 11022U, 13303U, 17511U, 6570U, 23405U, 
    22377U, 3170U, 18680U, 24797U, 3391U, 19334U, 25709U, 3556U, 
    19415U, 25623U, 3537U, 19379U, 12138U, 24782U, 9561U, 10976U, 
    13263U, 23365U, 9841U, 11505U, 13663U, 24087U, 8051U, 9447U, 
    10891U, 13178U, 23280U, 9514U, 10943U, 13230U, 23332U, 9649U, 
    11189U, 13405U, 23606U, 22726U, 18786U, 9350U, 10607U, 13081U, 
    16185U, 23002U, 14618U, 15942U, 5261U, 9491U, 10920U, 13207U, 
    23309U, 9530U, 10959U, 13246U, 23348U, 9663U, 11203U, 13419U, 
    23620U, 22817U, 18828U, 9622U, 11044U, 13309U, 17518U, 23427U, 
    20648U, 17669U, 6669U, 9872U, 11631U, 13694U, 24173U, 9306U, 
    12615U, 1336U, 12730U, 1389U, 23688U, 1748U, 23264U, 1722U, 
    12688U, 16878U, 12793U, 16967U, 23928U, 19137U, 9981U, 11798U, 
    13850U, 24340U, 9805U, 11469U, 13617U, 24041U, 9771U, 11415U, 
    13583U, 23973U, 9963U, 11780U, 13832U, 24322U, 16046U, 5329U, 
    9024U, 1138U, 9132U, 1199U, 7426U, 12880U, 1480U, 9237U, 
    16369U, 12833U, 1450U, 9175U, 16314U, 9578U, 10993U, 13280U, 
    23382U, 10034U, 11862U, 13903U, 24413U, 16450U, 5411U, 25602U, 
    19356U, 180U, 1880U, 14874U, 22951U, 16083U, 5353U, 3192U, 
    157U, 14857U, 1076U, 5074U, 7630U, 1822U, 20753U, 17718U, 
    12222U, 16686U, 14684U, 3065U, 12129U, 16632U, 17539U, 15960U, 
    5283U, 15389U, 17892U, 21403U, 3135U, 12182U, 16662U, 18156U, 
    17869U, 6696U, 192U, 14892U, 18900U, 7526U, 10235U, 13952U, 
    17147U, 6468U, 16471U, 5568U, 14493U, 17500U, 4424U, 3787U, 
    3885U, 4591U, 4607U, 3917U, 3855U, 4746U, 4660U, 4501U, 
    4129U, 4513U, 4156U, 4691U, 3769U, 4725U, 3862U, 4757U, 
    4816U, 4002U, 4061U, 20953U, 14023U, 17216U, 17906U, 12075U, 
    13961U, 22660U, 18753U, 17162U, 22644U, 18745U, 16587U, 22829U, 
    12321U, 16725U, 18836U, 20621U, 17642U, 21099U, 18012U, 14073U, 
    17241U, 21386U, 18130U, 22822U, 12313U, 6411U, 7506U, 20585U, 
    17615U, 20957U, 17913U, 14067U, 17232U, 21380U, 18121U, 22381U, 
    14042U, 18762U, 17224U, 22708U, 18771U, 18687U, 12142U, 13966U, 
    17170U, 16647U, 2327U, 6000U, 21844U, 6984U, 656U, 2584U, 
    6269U, 18932U, 22164U, 18593U, 7265U, 22666U, 22787U, 18812U, 
    22673U, 61U, 22686U, 9433U, 10869U, 13164U, 23191U, 22296U, 
    18672U, 7387U, 20727U, 17700U, 6754U, 12517U, 16752U, 6441U, 
    21265U, 16008U, 5307U, 3115U, 9545U, 6497U, 18106U, 6733U, 
    22896U, 24792U, 3384U, 19326U, 4791U, 10455U, 
};

static inline void InitMipsMCInstrInfo(MCInstrInfo *II) {
  II->InitMCInstrInfo(MipsInsts, MipsInstrNameIndices, MipsInstrNameData, 2702);
}

} // end llvm namespace
#endif // GET_INSTRINFO_MC_DESC

#ifdef GET_INSTRINFO_HEADER
#undef GET_INSTRINFO_HEADER
namespace llvm {
struct MipsGenInstrInfo : public TargetInstrInfo {
  explicit MipsGenInstrInfo(int CFSetupOpcode = -1, int CFDestroyOpcode = -1, int CatchRetOpcode = -1, int ReturnOpcode = -1);
  ~MipsGenInstrInfo() override = default;

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
extern const MCInstrDesc MipsInsts[];
extern const unsigned MipsInstrNameIndices[];
extern const char MipsInstrNameData[];
MipsGenInstrInfo::MipsGenInstrInfo(int CFSetupOpcode, int CFDestroyOpcode, int CatchRetOpcode, int ReturnOpcode)
  : TargetInstrInfo(CFSetupOpcode, CFDestroyOpcode, CatchRetOpcode, ReturnOpcode) {
  InitMCInstrInfo(MipsInsts, MipsInstrNameIndices, MipsInstrNameData, 2702);
}
} // end llvm namespace
#endif // GET_INSTRINFO_CTOR_DTOR

#ifdef GET_INSTRINFO_OPERAND_ENUM
#undef GET_INSTRINFO_OPERAND_ENUM
namespace llvm {
namespace Mips {
namespace OpName {
enum {
OPERAND_LAST
};
} // end namespace OpName
} // end namespace Mips
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_ENUM

#ifdef GET_INSTRINFO_NAMED_OPS
#undef GET_INSTRINFO_NAMED_OPS
namespace llvm {
namespace Mips {
LLVM_READONLY
int16_t getNamedOperandIdx(uint16_t Opcode, uint16_t NamedIdx) {
  return -1;
}
} // end namespace Mips
} // end namespace llvm
#endif //GET_INSTRINFO_NAMED_OPS

#ifdef GET_INSTRINFO_OPERAND_TYPES_ENUM
#undef GET_INSTRINFO_OPERAND_TYPES_ENUM
namespace llvm {
namespace Mips {
namespace OpTypes {
enum OperandType {
  InvertedImOperand = 0,
  InvertedImOperand64 = 1,
  PtrRC = 2,
  brtarget = 3,
  brtarget10_mm = 4,
  brtarget1SImm16 = 5,
  brtarget21 = 6,
  brtarget21_mm = 7,
  brtarget26 = 8,
  brtarget26_mm = 9,
  brtarget7_mm = 10,
  brtarget_lsl2_mm = 11,
  brtarget_mm = 12,
  brtargetr6 = 13,
  calloffset16 = 14,
  calltarget = 15,
  calltarget_mm = 16,
  condcode = 17,
  cpinst_operand = 18,
  f32imm = 19,
  f64imm = 20,
  i16imm = 21,
  i1imm = 22,
  i32imm = 23,
  i64imm = 24,
  i8imm = 25,
  imm64 = 26,
  jmpoffset16 = 27,
  jmptarget = 28,
  jmptarget_mm = 29,
  li16_imm = 30,
  mem = 31,
  mem16 = 32,
  mem16_ea = 33,
  mem16sp = 34,
  mem_ea = 35,
  mem_mm_11 = 36,
  mem_mm_12 = 37,
  mem_mm_16 = 38,
  mem_mm_4 = 39,
  mem_mm_4_lsl1 = 40,
  mem_mm_4_lsl2 = 41,
  mem_mm_4sp = 42,
  mem_mm_9 = 43,
  mem_mm_gp_simm7_lsl2 = 44,
  mem_mm_sp_imm5_lsl2 = 45,
  mem_msa = 46,
  mem_simm10 = 47,
  mem_simm10_lsl1 = 48,
  mem_simm10_lsl2 = 49,
  mem_simm10_lsl3 = 50,
  mem_simm11 = 51,
  mem_simm12 = 52,
  mem_simm16 = 53,
  mem_simm9 = 54,
  mem_simmptr = 55,
  pcrel16 = 56,
  ptype0 = 57,
  ptype1 = 58,
  ptype2 = 59,
  ptype3 = 60,
  ptype4 = 61,
  ptype5 = 62,
  reglist = 63,
  reglist16 = 64,
  simm10 = 65,
  simm10_64 = 66,
  simm10_lsl1 = 67,
  simm10_lsl2 = 68,
  simm10_lsl3 = 69,
  simm11 = 70,
  simm12 = 71,
  simm16 = 72,
  simm16_64 = 73,
  simm16_relaxed = 74,
  simm18_lsl3 = 75,
  simm19_lsl2 = 76,
  simm23_lsl2 = 77,
  simm32 = 78,
  simm32_relaxed = 79,
  simm3_lsa2 = 80,
  simm4 = 81,
  simm5 = 82,
  simm6 = 83,
  simm7_lsl2 = 84,
  simm9 = 85,
  simm9_addiusp = 86,
  size_ins = 87,
  type0 = 88,
  type1 = 89,
  type2 = 90,
  type3 = 91,
  type4 = 92,
  type5 = 93,
  uimm1 = 94,
  uimm10 = 95,
  uimm16 = 96,
  uimm16_64 = 97,
  uimm16_64_relaxed = 98,
  uimm16_altrelaxed = 99,
  uimm16_relaxed = 100,
  uimm1_ptr = 101,
  uimm2 = 102,
  uimm20 = 103,
  uimm26 = 104,
  uimm2_plus1 = 105,
  uimm2_ptr = 106,
  uimm3 = 107,
  uimm32_coerced = 108,
  uimm3_ptr = 109,
  uimm3_shift = 110,
  uimm4 = 111,
  uimm4_andi = 112,
  uimm4_ptr = 113,
  uimm5 = 114,
  uimm5_64 = 115,
  uimm5_64_report_uimm6 = 116,
  uimm5_inssize_plus1 = 117,
  uimm5_lsl2 = 118,
  uimm5_plus1 = 119,
  uimm5_plus1_report_uimm6 = 120,
  uimm5_plus32 = 121,
  uimm5_plus32_normalize = 122,
  uimm5_plus32_normalize_64 = 123,
  uimm5_plus33 = 124,
  uimm5_report_uimm6 = 125,
  uimm6 = 126,
  uimm6_lsl2 = 127,
  uimm7 = 128,
  uimm8 = 129,
  uimm_range_2_64 = 130,
  uimmz = 131,
  vsplat_simm10 = 132,
  vsplat_simm5 = 133,
  vsplat_uimm1 = 134,
  vsplat_uimm2 = 135,
  vsplat_uimm3 = 136,
  vsplat_uimm4 = 137,
  vsplat_uimm5 = 138,
  vsplat_uimm6 = 139,
  vsplat_uimm8 = 140,
  OPERAND_TYPE_LIST_END
};
} // end namespace OpTypes
} // end namespace Mips
} // end namespace llvm
#endif // GET_INSTRINFO_OPERAND_TYPES_ENUM

#ifdef GET_INSTRINFO_OPERAND_TYPE
#undef GET_INSTRINFO_OPERAND_TYPE
namespace llvm {
namespace Mips {
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
    389,
    391,
    393,
    396,
    399,
    402,
    406,
    413,
    417,
    421,
    425,
    429,
    433,
    440,
    443,
    449,
    452,
    455,
    458,
    461,
    464,
    470,
    473,
    479,
    482,
    485,
    488,
    491,
    494,
    500,
    503,
    509,
    512,
    515,
    518,
    521,
    524,
    530,
    533,
    539,
    542,
    545,
    548,
    551,
    554,
    560,
    563,
    569,
    572,
    575,
    578,
    581,
    584,
    590,
    593,
    599,
    602,
    605,
    608,
    611,
    614,
    620,
    623,
    629,
    632,
    635,
    638,
    641,
    644,
    650,
    651,
    652,
    653,
    656,
    659,
    662,
    665,
    668,
    671,
    674,
    677,
    680,
    683,
    686,
    689,
    692,
    695,
    698,
    701,
    704,
    707,
    710,
    713,
    716,
    719,
    722,
    725,
    728,
    731,
    734,
    737,
    740,
    743,
    746,
    749,
    752,
    755,
    756,
    760,
    764,
    768,
    772,
    776,
    777,
    778,
    779,
    782,
    785,
    788,
    791,
    794,
    797,
    800,
    803,
    806,
    809,
    812,
    815,
    818,
    821,
    824,
    827,
    829,
    832,
    835,
    838,
    840,
    841,
    844,
    847,
    850,
    853,
    856,
    859,
    862,
    865,
    868,
    871,
    874,
    877,
    880,
    883,
    886,
    889,
    889,
    892,
    895,
    897,
    899,
    901,
    903,
    905,
    907,
    911,
    915,
    919,
    923,
    927,
    931,
    935,
    939,
    943,
    947,
    951,
    955,
    959,
    963,
    967,
    968,
    969,
    970,
    971,
    972,
    973,
    975,
    978,
    981,
    984,
    987,
    990,
    993,
    997,
    1000,
    1004,
    1007,
    1010,
    1012,
    1014,
    1017,
    1019,
    1021,
    1024,
    1027,
    1029,
    1031,
    1033,
    1035,
    1037,
    1039,
    1041,
    1044,
    1046,
    1049,
    1051,
    1052,
    1055,
    1057,
    1059,
    1061,
    1063,
    1065,
    1067,
    1069,
    1071,
    1073,
    1075,
    1078,
    1080,
    1081,
    1083,
    1085,
    1087,
    1089,
    1092,
    1095,
    1098,
    1100,
    1103,
    1105,
    1108,
    1108,
    1111,
    1114,
    1117,
    1120,
    1123,
    1126,
    1129,
    1132,
    1135,
    1138,
    1141,
    1144,
    1147,
    1150,
    1152,
    1154,
    1156,
    1158,
    1160,
    1163,
    1166,
    1169,
    1172,
    1179,
    1186,
    1187,
    1188,
    1189,
    1190,
    1191,
    1192,
    1193,
    1194,
    1195,
    1196,
    1200,
    1204,
    1208,
    1212,
    1214,
    1216,
    1218,
    1220,
    1222,
    1224,
    1228,
    1232,
    1236,
    1240,
    1243,
    1246,
    1249,
    1252,
    1255,
    1258,
    1261,
    1264,
    1268,
    1272,
    1273,
    1274,
    1277,
    1281,
    1285,
    1289,
    1293,
    1297,
    1301,
    1305,
    1309,
    1313,
    1317,
    1321,
    1325,
    1329,
    1333,
    1337,
    1340,
    1343,
    1346,
    1349,
    1352,
    1355,
    1358,
    1361,
    1361,
    1361,
    1364,
    1367,
    1370,
    1373,
    1376,
    1379,
    1382,
    1385,
    1388,
    1391,
    1394,
    1397,
    1400,
    1403,
    1406,
    1409,
    1412,
    1415,
    1418,
    1420,
    1422,
    1424,
    1426,
    1428,
    1431,
    1434,
    1437,
    1440,
    1443,
    1446,
    1449,
    1452,
    1454,
    1456,
    1458,
    1460,
    1462,
    1466,
    1470,
    1475,
    1480,
    1485,
    1490,
    1495,
    1500,
    1505,
    1510,
    1515,
    1520,
    1525,
    1530,
    1533,
    1536,
    1539,
    1542,
    1545,
    1546,
    1547,
    1548,
    1549,
    1550,
    1551,
    1552,
    1553,
    1554,
    1555,
    1556,
    1557,
    1558,
    1558,
    1558,
    1561,
    1564,
    1567,
    1570,
    1573,
    1576,
    1579,
    1582,
    1585,
    1588,
    1591,
    1594,
    1597,
    1599,
    1601,
    1603,
    1605,
    1607,
    1609,
    1612,
    1614,
    1616,
    1618,
    1620,
    1623,
    1626,
    1627,
    1630,
    1633,
    1636,
    1639,
    1642,
    1645,
    1648,
    1651,
    1654,
    1657,
    1660,
    1663,
    1666,
    1669,
    1672,
    1675,
    1678,
    1681,
    1684,
    1687,
    1690,
    1693,
    1696,
    1699,
    1702,
    1705,
    1708,
    1711,
    1714,
    1717,
    1720,
    1723,
    1726,
    1729,
    1732,
    1735,
    1738,
    1741,
    1744,
    1747,
    1750,
    1753,
    1756,
    1759,
    1762,
    1765,
    1768,
    1771,
    1774,
    1777,
    1780,
    1783,
    1786,
    1789,
    1792,
    1795,
    1798,
    1801,
    1804,
    1807,
    1810,
    1813,
    1816,
    1819,
    1822,
    1825,
    1829,
    1833,
    1835,
    1837,
    1840,
    1843,
    1846,
    1849,
    1852,
    1855,
    1858,
    1861,
    1864,
    1867,
    1870,
    1873,
    1876,
    1879,
    1883,
    1887,
    1890,
    1893,
    1896,
    1899,
    1902,
    1905,
    1908,
    1911,
    1914,
    1916,
    1918,
    1921,
    1924,
    1927,
    1930,
    1933,
    1936,
    1939,
    1942,
    1945,
    1948,
    1951,
    1954,
    1957,
    1960,
    1963,
    1966,
    1969,
    1971,
    1973,
    1976,
    1979,
    1982,
    1983,
    1984,
    1987,
    1990,
    1991,
    1994,
    1995,
    1996,
    1997,
    2001,
    2005,
    2008,
    2011,
    2014,
    2017,
    2018,
    2019,
    2021,
    2023,
    2025,
    2027,
    2029,
    2031,
    2033,
    2035,
    2037,
    2039,
    2041,
    2043,
    2045,
    2047,
    2050,
    2053,
    2056,
    2059,
    2062,
    2065,
    2068,
    2071,
    2072,
    2075,
    2078,
    2081,
    2084,
    2087,
    2090,
    2092,
    2094,
    2096,
    2098,
    2100,
    2102,
    2104,
    2106,
    2109,
    2112,
    2115,
    2118,
    2121,
    2124,
    2127,
    2129,
    2131,
    2133,
    2135,
    2137,
    2139,
    2141,
    2143,
    2145,
    2147,
    2149,
    2151,
    2153,
    2155,
    2157,
    2159,
    2161,
    2163,
    2165,
    2167,
    2169,
    2171,
    2175,
    2179,
    2183,
    2187,
    2191,
    2195,
    2199,
    2203,
    2207,
    2211,
    2215,
    2219,
    2223,
    2227,
    2231,
    2235,
    2237,
    2239,
    2241,
    2243,
    2245,
    2247,
    2249,
    2251,
    2253,
    2255,
    2257,
    2259,
    2261,
    2264,
    2267,
    2270,
    2273,
    2276,
    2279,
    2281,
    2283,
    2285,
    2287,
    2289,
    2291,
    2293,
    2295,
    2297,
    2299,
    2301,
    2303,
    2305,
    2309,
    2313,
    2317,
    2321,
    2324,
    2327,
    2330,
    2333,
    2336,
    2339,
    2342,
    2345,
    2348,
    2351,
    2354,
    2357,
    2360,
    2363,
    2365,
    2367,
    2369,
    2371,
    2373,
    2375,
    2377,
    2379,
    2382,
    2385,
    2388,
    2390,
    2392,
    2394,
    2396,
    2398,
    2401,
    2404,
    2405,
    2406,
    2407,
    2409,
    2410,
    2411,
    2413,
    2415,
    2419,
    2423,
    2426,
    2429,
    2432,
    2435,
    2438,
    2441,
    2444,
    2447,
    2449,
    2451,
    2453,
    2455,
    2457,
    2459,
    2461,
    2462,
    2463,
    2465,
    2467,
    2467,
    2468,
    2469,
    2470,
    2471,
    2474,
    2477,
    2480,
    2483,
    2486,
    2489,
    2491,
    2493,
    2495,
    2497,
    2499,
    2501,
    2503,
    2505,
    2507,
    2509,
    2511,
    2514,
    2517,
    2520,
    2523,
    2526,
    2529,
    2532,
    2535,
    2537,
    2539,
    2541,
    2543,
    2547,
    2551,
    2555,
    2559,
    2561,
    2563,
    2565,
    2567,
    2570,
    2573,
    2576,
    2579,
    2582,
    2585,
    2588,
    2591,
    2594,
    2597,
    2600,
    2603,
    2606,
    2609,
    2612,
    2615,
    2617,
    2619,
    2621,
    2623,
    2626,
    2629,
    2632,
    2635,
    2638,
    2641,
    2644,
    2647,
    2650,
    2653,
    2656,
    2659,
    2662,
    2665,
    2668,
    2671,
    2673,
    2675,
    2677,
    2679,
    2682,
    2685,
    2688,
    2691,
    2694,
    2697,
    2700,
    2703,
    2706,
    2709,
    2712,
    2715,
    2717,
    2719,
    2721,
    2723,
    2725,
    2727,
    2730,
    2733,
    2736,
    2739,
    2741,
    2743,
    2746,
    2749,
    2752,
    2755,
    2758,
    2761,
    2763,
    2765,
    2768,
    2771,
    2774,
    2777,
    2779,
    2781,
    2784,
    2787,
    2790,
    2793,
    2796,
    2799,
    2802,
    2805,
    2808,
    2811,
    2814,
    2817,
    2820,
    2823,
    2826,
    2829,
    2832,
    2835,
    2838,
    2841,
    2844,
    2847,
    2850,
    2853,
    2856,
    2859,
    2862,
    2865,
    2868,
    2871,
    2874,
    2877,
    2880,
    2883,
    2886,
    2889,
    2892,
    2895,
    2898,
    2901,
    2904,
    2907,
    2910,
    2913,
    2916,
    2919,
    2922,
    2925,
    2928,
    2931,
    2934,
    2937,
    2940,
    2943,
    2946,
    2949,
    2952,
    2955,
    2958,
    2961,
    2964,
    2967,
    2970,
    2973,
    2976,
    2978,
    2980,
    2982,
    2984,
    2986,
    2988,
    2990,
    2992,
    2994,
    2996,
    2998,
    3000,
    3002,
    3004,
    3006,
    3008,
    3010,
    3012,
    3014,
    3016,
    3019,
    3021,
    3023,
    3025,
    3027,
    3029,
    3031,
    3033,
    3035,
    3037,
    3039,
    3041,
    3043,
    3045,
    3047,
    3049,
    3051,
    3053,
    3055,
    3058,
    3061,
    3064,
    3067,
    3070,
    3073,
    3076,
    3079,
    3082,
    3085,
    3088,
    3091,
    3094,
    3097,
    3100,
    3103,
    3106,
    3109,
    3112,
    3115,
    3118,
    3121,
    3124,
    3127,
    3130,
    3133,
    3136,
    3139,
    3142,
    3145,
    3148,
    3151,
    3154,
    3157,
    3160,
    3163,
    3166,
    3169,
    3172,
    3175,
    3178,
    3181,
    3184,
    3187,
    3190,
    3193,
    3196,
    3199,
    3202,
    3205,
    3208,
    3211,
    3214,
    3217,
    3220,
    3223,
    3226,
    3229,
    3232,
    3235,
    3238,
    3241,
    3244,
    3247,
    3250,
    3253,
    3256,
    3259,
    3262,
    3265,
    3268,
    3271,
    3274,
    3277,
    3280,
    3283,
    3286,
    3289,
    3292,
    3295,
    3298,
    3301,
    3304,
    3307,
    3310,
    3313,
    3316,
    3319,
    3322,
    3325,
    3328,
    3331,
    3334,
    3337,
    3340,
    3343,
    3345,
    3347,
    3349,
    3352,
    3355,
    3358,
    3361,
    3364,
    3368,
    3371,
    3374,
    3376,
    3378,
    3380,
    3382,
    3384,
    3387,
    3390,
    3390,
    3390,
    3390,
    3394,
    3398,
    3402,
    3406,
    3407,
    3412,
    3417,
    3422,
    3425,
    3428,
    3431,
    3434,
    3437,
    3440,
    3443,
    3446,
    3449,
    3452,
    3455,
    3458,
    3459,
    3460,
    3464,
    3468,
    3471,
    3473,
    3476,
    3478,
    3481,
    3484,
    3487,
    3488,
    3491,
    3493,
    3496,
    3498,
    3501,
    3504,
    3507,
    3510,
    3512,
    3514,
    3517,
    3520,
    3523,
    3526,
    3529,
    3532,
    3535,
    3538,
    3542,
    3546,
    3550,
    3554,
    3558,
    3562,
    3566,
    3570,
    3574,
    3578,
    3582,
    3586,
    3590,
    3594,
    3598,
    3602,
    3606,
    3610,
    3614,
    3618,
    3622,
    3626,
    3628,
    3632,
    3636,
    3640,
    3644,
    3648,
    3652,
    3656,
    3660,
    3664,
    3668,
    3672,
    3676,
    3680,
    3684,
    3688,
    3692,
    3696,
    3700,
    3704,
    3708,
    3712,
    3716,
    3719,
    3722,
    3725,
    3727,
    3729,
    3731,
    3734,
    3737,
    3739,
    3742,
    3745,
    3748,
    3751,
    3754,
    3757,
    3760,
    3763,
    3766,
    3768,
    3769,
    3770,
    3771,
    3773,
    3775,
    3775,
    3775,
    3775,
    3776,
    3777,
    3778,
    3779,
    3779,
    3779,
    3779,
    3779,
    3779,
    3780,
    3781,
    3782,
    3786,
    3789,
    3792,
    3795,
    3798,
    3801,
    3804,
    3807,
    3810,
    3813,
    3816,
    3819,
    3822,
    3825,
    3828,
    3831,
    3834,
    3837,
    3840,
    3843,
    3846,
    3849,
    3852,
    3855,
    3858,
    3862,
    3866,
    3870,
    3874,
    3876,
    3878,
    3880,
    3882,
    3884,
    3886,
    3889,
    3892,
    3895,
    3898,
    3901,
    3904,
    3907,
    3910,
    3913,
    3916,
    3919,
    3922,
    3925,
    3927,
    3929,
    3932,
    3935,
    3938,
    3941,
    3944,
    3947,
    3950,
    3953,
    3956,
    3959,
    3962,
    3965,
    3968,
    3971,
    3974,
    3977,
    3980,
    3983,
    3986,
    3989,
    3992,
    3995,
    3998,
    4001,
    4004,
    4007,
    4010,
    4013,
    4016,
    4019,
    4022,
    4025,
    4028,
    4031,
    4034,
    4037,
    4039,
    4041,
    4043,
    4045,
    4047,
    4049,
    4051,
    4053,
    4055,
    4057,
    4059,
    4061,
    4063,
    4065,
    4067,
    4069,
    4071,
    4073,
    4075,
    4077,
    4079,
    4081,
    4083,
    4085,
    4087,
    4089,
    4091,
    4093,
    4095,
    4099,
    4103,
    4106,
    4109,
    4112,
    4115,
    4118,
    4121,
    4124,
    4127,
    4129,
    4131,
    4133,
    4135,
    4137,
    4139,
    4141,
    4143,
    4147,
    4151,
    4154,
    4157,
    4160,
    4163,
    4166,
    4169,
    4172,
    4175,
    4178,
    4180,
    4182,
    4184,
    4186,
    4188,
    4190,
    4192,
    4195,
    4197,
    4199,
    4201,
    4203,
    4205,
    4207,
    4210,
    4213,
    4216,
    4219,
    4222,
    4225,
    4228,
    4231,
    4234,
    4237,
    4240,
    4243,
    4245,
    4247,
    4249,
    4251,
    4253,
    4255,
    4257,
    4259,
    4262,
    4265,
    4268,
    4271,
    4274,
    4277,
    4280,
    4283,
    4286,
    4289,
    4292,
    4295,
    4298,
    4301,
    4304,
    4307,
    4310,
    4313,
    4316,
    4318,
    4320,
    4322,
    4324,
    4327,
    4330,
    4332,
    4334,
    4336,
    4338,
    4339,
    4340,
    4342,
    4344,
    4347,
    4350,
    4353,
    4356,
    4359,
    4362,
    4365,
    4368,
    4371,
    4374,
    4377,
    4380,
    4381,
    4382,
    4385,
    4388,
    4391,
    4394,
    4397,
    4400,
    4403,
    4406,
    4409,
    4412,
    4415,
    4418,
    4421,
    4424,
    4427,
    4430,
    4435,
    4439,
    4443,
    4447,
    4451,
    4454,
    4459,
    4464,
    4469,
    4474,
    4477,
    4482,
    4487,
    4488,
    4489,
    4491,
    4492,
    4494,
    4495,
    4497,
    4499,
    4500,
    4502,
    4504,
    4506,
    4508,
    4509,
    4510,
    4511,
    4512,
    4514,
    4516,
    4518,
    4520,
    4522,
    4524,
    4525,
    4526,
    4527,
    4528,
    4529,
    4530,
    4531,
    4532,
    4533,
    4534,
    4535,
    4536,
    4537,
    4538,
    4539,
    4539,
    4539,
    4540,
    4541,
    4544,
    4547,
    4550,
    4553,
    4556,
    4559,
    4562,
    4565,
    4568,
    4571,
    4574,
    4577,
    4580,
    4583,
    4586,
    4589,
    4592,
    4595,
    4598,
    4601,
    4604,
    4607,
    4610,
    4613,
    4615,
    4617,
    4619,
    4621,
    4625,
    4627,
    4631,
    4634,
    4637,
    4640,
    4643,
    4646,
    4649,
    4652,
    4655,
    4658,
    4661,
    4664,
    4667,
    4670,
    4673,
    4676,
    4679,
    4682,
    4685,
    4688,
    4691,
    4694,
    4697,
    4699,
    4701,
    4704,
    4707,
    4710,
    4713,
    4716,
    4719,
    4722,
    4725,
    4728,
    4731,
    4735,
    4739,
    4743,
    4745,
    4748,
    4751,
    4754,
    4756,
    4758,
    4760,
    4763,
    4766,
    4769,
    4772,
    4775,
    4778,
    4781,
    4784,
    4787,
    4790,
    4793,
    4796,
    4799,
    4802,
    4806,
    4810,
    4814,
    4818,
    4822,
    4825,
    4828,
    4831,
    4833,
    4835,
    4839,
    4843,
    4847,
    4851,
    4855,
    4859,
    4862,
    4864,
    4867,
    4870,
    4873,
    4876,
    4879,
    4882,
    4885,
    4888,
    4891,
    4894,
    4897,
    4900,
    4903,
    4905,
    4907,
    4909,
    4912,
    4915,
    4918,
    4921,
    4923,
    4927,
    4931,
    4935,
    4939,
    4943,
    4947,
    4949,
    4953,
    4957,
    4959,
    4963,
    4967,
    4971,
    4975,
    4979,
    4983,
    4987,
    4991,
    4995,
    4997,
    5001,
    5005,
    5009,
    5013,
    5017,
    5021,
    5025,
    5029,
    5033,
    5037,
    5041,
    5045,
    5048,
    5051,
    5054,
    5057,
    5060,
    5063,
    5066,
    5069,
    5072,
    5075,
    5078,
    5081,
    5084,
    5087,
    5090,
    5093,
    5096,
    5099,
    5102,
    5105,
    5108,
    5111,
    5114,
    5117,
    5120,
    5123,
    5126,
    5129,
    5132,
    5135,
    5137,
    5139,
    5141,
    5143,
    5146,
    5148,
    5151,
    5154,
    5157,
    5159,
    5161,
    5163,
    5165,
    5167,
    5170,
    5173,
    5174,
    5175,
    5176,
    5178,
    5180,
    5181,
    5182,
    5183,
    5184,
    5186,
    5188,
    5189,
    5194,
    5197,
    5200,
    5203,
    5206,
    5209,
    5212,
    5215,
    5218,
    5221,
    5224,
    5227,
    5230,
    5233,
    5236,
    5239,
    5242,
    5245,
    5248,
    5251,
    5254,
    5257,
    5260,
    5263,
    5266,
    5269,
    5272,
    5275,
    5278,
    5281,
    5284,
    5287,
    5290,
    5293,
    5296,
    5299,
    5302,
    5305,
    5308,
    5311,
    5314,
    5317,
    5320,
    5322,
    5324,
    5328,
    5332,
    5334,
    5338,
    5342,
    5346,
    5350,
    5354,
    5358,
    5362,
    5366,
    5370,
    5374,
    5378,
    5382,
    5386,
    5390,
    5394,
    5398,
    5402,
    5406,
    5410,
    5414,
    5418,
    5422,
    5426,
    5430,
    5434,
    5438,
    5442,
    5446,
    5450,
    5454,
    5458,
    5462,
    5466,
    5470,
    5474,
    5478,
    5482,
    5486,
    5490,
    5494,
    5496,
    5500,
    5504,
    5508,
    5512,
    5516,
    5520,
    5522,
    5526,
    5530,
    5532,
    5536,
    5540,
    5544,
    5548,
    5552,
    5556,
    5560,
    5564,
    5568,
    5570,
    5574,
    5578,
    5582,
    5586,
    5589,
    5592,
    5594,
    5596,
    5598,
    5600,
    5602,
    5605,
    5607,
    5610,
    5613,
    5616,
    5619,
    5622,
    5625,
    5628,
    5630,
    5633,
    5636,
    5637,
    5638,
    5640,
    5642,
    5643,
    5646,
    5649,
    5650,
    5651,
    5653,
    5655,
    5656,
    5657,
    5658,
    5659,
    5660,
    5661,
    5662,
    5667,
    5670,
    5673,
    5676,
    5679,
    5682,
    5685,
    5688,
    5691,
    5694,
    5697,
    5700,
    5703,
    5706,
    5709,
    5712,
    5715,
    5718,
    5721,
    5724,
    5727,
    5730,
    5733,
    5736,
    5740,
    5744,
    5748,
    5752,
    5754,
    5757,
    5760,
    5763,
    5766,
    5768,
    5770,
    5772,
    5775,
    5778,
    5781,
    5784,
    5787,
    5790,
    5793,
    5796,
    5799,
    5802,
    5805,
    5808,
    5811,
    5814,
    5817,
    5818,
    5819,
    5821,
    5823,
    5825,
    5827,
    5829,
    5831,
    5833,
    5835,
    5837,
    5839,
    5843,
    5847,
    5851,
    5855,
    5859,
    5863,
    5867,
    5871,
    5875,
    5879,
    5882,
    5885,
    5888,
    5891,
    5894,
    5897,
    5899,
    5901,
    5903,
    5905,
    5908,
    5911,
    5914,
    5917,
    5920,
    5923,
    5926,
    5929,
    5932,
    5935,
    5938,
    5941,
    5944,
    5947,
    5950,
    5950,
    5950,
    5950,
    5953,
    5956,
    5959,
    5962,
    5965,
    5968,
    5971,
    5974,
    5976,
    5978,
    5980,
    5982,
    5985,
    5988,
    5991,
    5994,
    5997,
    6000,
    6002,
    6004,
    6006,
    6008,
    6010,
    6012,
    6014,
    6016,
    6018,
    6020,
    6022,
    6024,
    6026,
    6028,
    6030,
    6032,
    6034,
    6036,
    6038,
    6040,
    6042,
    6045,
    6048,
    6051,
    6054,
    6057,
    6060,
    6063,
    6066,
    6069,
    6072,
    6076,
    6080,
    6084,
    6088,
    6091,
    6094,
    6097,
    6100,
    6103,
    6106,
    6109,
    6113,
    6117,
    6119,
    6121,
    6123,
    6125,
    6128,
    6131,
    6134,
    6137,
    6139,
    6141,
    6143,
    6145,
    6147,
    6149,
    6151,
    6153,
    6155,
    6157,
    6159,
    6161,
    6163,
    6165,
    6167,
    6169,
    6171,
    6173,
    6175,
    6178,
    6181,
    6184,
    6187,
    6189,
    6191,
    6193,
    6195,
    6197,
    6199,
    6201,
    6203,
    6205,
    6207,
    6209,
    6211,
    6213,
    6215,
    6217,
    6219,
    6221,
    6221,
    6221,
    6224,
    6227,
    6230,
    6233,
    6236,
    6239,
    6242,
    6245,
    6248,
    6251,
    6254,
    6257,
    6260,
    6263,
    6266,
    6269,
    6273,
    6277,
    6281,
    6285,
    6289,
    6293,
    6297,
    6301,
    6305,
    6309,
    6312,
    6313,
    6314,
    6315,
    6316,
    6317,
    6318,
    6321,
    6324,
    6327,
    6330,
    6333,
    6336,
    6339,
    6342,
    6344,
    6346,
    6349,
    6352,
    6355,
    6358,
    6360,
    6362,
    6364,
    6366,
    6368,
    6370,
    6373,
    6376,
    6379,
    6382,
    6385,
    6388,
    6391,
    6394,
    6397,
    6400,
    6403,
    6406,
    6409,
    6412,
    6416,
    6420,
    6424,
    6428,
    6431,
    6434,
    6437,
    6440,
    6443,
    6446,
    6449,
    6452,
    6455,
    6458,
    6461,
    6464,
    6467,
    6470,
    6473,
    6476,
    6479,
    6482,
    6485,
    6488,
    6491,
    6494,
    6497,
    6500,
    6503,
    6506,
    6509,
    6512,
    6515,
    6518,
    6521,
    6524,
    6527,
    6530,
    6533,
    6536,
    6539,
    6542,
    6545,
    6548,
    6551,
    6554,
    6557,
    6560,
    6563,
    6566,
    6569,
    6572,
    6575,
    6578,
    6581,
    6584,
    6587,
    6590,
    6593,
    6596,
    6599,
    6602,
    6605,
    6608,
    6611,
    6612,
    6613,
    6617,
    6621,
    6625,
    6629,
    6633,
    6637,
    6641,
    6645,
    6648,
    6651,
    6654,
    6656,
    6658,
    6661,
    6664,
    6667,
    6670,
    6673,
    6676,
    6679,
    6682,
    6685,
    6688,
    6691,
    6694,
    6697,
    6700,
    6703,
    6706,
    6709,
    6712,
    6715,
    6718,
    6721,
    6724,
    6727,
    6730,
    6733,
    6736,
    6739,
    6742,
    6745,
    6748,
    6751,
    6754,
    6757,
    6760,
    6763,
    6766,
    6769,
    6772,
    6775,
    6778,
    6781,
    6784,
    6787,
    6790,
    6793,
    6796,
    6799,
    6802,
    6805,
    6808,
    6811,
    6814,
    6817,
    6820,
    6823,
    6826,
    6829,
    6832,
    6835,
    6838,
    6841,
    6844,
    6847,
    6850,
    6853,
    6856,
    6859,
    6862,
    6865,
    6868,
    6871,
    6874,
    6877,
    6880,
    6883,
    6886,
    6886,
    6886,
    6886,
    6889,
    6892,
    6895,
    6898,
    6901,
    6904,
    6907,
    6910,
    6913,
    6916,
    6919,
    6922,
    6925,
    6928,
    6931,
    6934,
    6937,
    6940,
    6943,
    6946,
    6949,
    6952,
    6955,
    6958,
    6961,
    6964,
    6967,
    6970,
    6973,
    6976,
    6979,
    6982,
    6985,
    6988,
    6991,
    6994,
    6997,
    7000,
    7003,
    7006,
    7009,
    7012,
    7015,
    7018,
    7021,
    7024,
    7027,
    7030,
    7033,
    7036,
    7039,
    7042,
    7045,
    7048,
    7051,
    7054,
    7057,
    7060,
    7063,
    7066,
    7069,
    7072,
    7075,
    7078,
    7081,
    7084,
    7087,
    7090,
    7093,
    7096,
    7099,
    7102,
    7105,
    7108,
    7111,
    7114,
    7117,
    7120,
    7123,
    7126,
    7129,
    7132,
    7135,
    7138,
    7141,
    7144,
    7147,
    7151,
    7154,
    7157,
    7160,
    7163,
    7166,
    7169,
    7172,
    7175,
    7178,
    7181,
    7184,
    7185,
    7187,
    7189,
    7191,
    7192,
    7193,
    7194,
    7195,
    7195,
    7195,
    7198,
    7200,
    7202,
    7205,
    7208,
    7211,
    7213,
    7215,
    7217,
    7219,
    7221,
    7223,
    7226,
    7229,
    7232,
    7235,
    7238,
    7241,
    7244,
    7247,
    7249,
    7251,
    7254,
    7257,
    7259,
    7261,
    7263,
    7265,
    7268,
    7271,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7274,
    7277,
    7279,
    7281,
    7283,
    7286,
    7289,
    7292,
    7295,
    7297,
    7299,
    7302,
    7304,
    7306,
    7308,
    7310,
    7312,
    7314,
    7316,
    7318,
    7320,
    7322,
    7324,
    7326,
    7328,
    7330,
    7333,
    7336,
    7339,
    7343,
    7347,
    7351,
    7355,
    7355,
    7356,
    7357,
    7359,
    7361,
    7363,
    7365,
    7367,
    7369,
    7372,
    7375,
    7378,
    7381,
    7384,
    7387,
    7390,
    7393,
    7396,
    7399,
    7402,
    7405,
    7408,
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
    -1, -1, 
    OpTypes::i32imm, OpTypes::i32imm, 
    OpTypes::i32imm, OpTypes::i32imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, 
    OpTypes::brtarget, 
    OpTypes::brtarget, 
    OpTypes::brtarget_mm, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    OpTypes::brtarget, 
    OpTypes::brtarget_mm, 
    OpTypes::brtarget_mm, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, OpTypes::imm64, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::simm16, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::simm16, OpTypes::brtarget, 
    -1, OpTypes::simm16, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::simm16, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::simm16, OpTypes::brtarget, 
    -1, OpTypes::simm16, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    OpTypes::cpinst_operand, OpTypes::cpinst_operand, OpTypes::i32imm, 
    -1, -1, OpTypes::uimm1_ptr, 
    -1, -1, OpTypes::uimm2_ptr, 
    -1, -1, 
    OpTypes::simm32, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::imm64, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    -1, -1, OpTypes::imm64, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    /**/
    -1, -1, OpTypes::i32imm, 
    -1, -1, OpTypes::i32imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::simm16, OpTypes::simm16, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::uimm1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::uimm2, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    OpTypes::calltarget, 
    -1, 
    -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm10, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::brtarget, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    OpTypes::reglist, -1, OpTypes::simm12, 
    -1, OpTypes::i32imm, 
    -1, OpTypes::imm64, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, OpTypes::uimm32_coerced, 
    -1, OpTypes::imm64, 
    -1, OpTypes::imm64, 
    -1, OpTypes::imm64, 
    -1, OpTypes::imm64, 
    -1, OpTypes::imm64, 
    -1, OpTypes::imm64, 
    -1, OpTypes::simm32, OpTypes::simm32, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    /**/
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, OpTypes::imm64, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, 
    -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    /**/
    /**/
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm32, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm32, 
    -1, -1, OpTypes::imm64, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm32_coerced, 
    -1, -1, OpTypes::imm64, 
    -1, -1, OpTypes::simm32, 
    -1, -1, OpTypes::imm64, 
    -1, -1, OpTypes::uimm32_coerced, 
    -1, -1, OpTypes::imm64, 
    -1, -1, OpTypes::imm64, 
    -1, -1, OpTypes::imm64, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm10, 
    OpTypes::reglist, -1, OpTypes::simm12, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    OpTypes::calltarget, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    OpTypes::calltarget, 
    OpTypes::calltarget, 
    /**/
    /**/
    -1, -1, -1, 
    -1, -1, OpTypes::simm32, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm32_relaxed, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::simm19_lsl2, 
    -1, OpTypes::simm23_lsl2, 
    -1, OpTypes::simm19_lsl2, 
    -1, OpTypes::uimm6_lsl2, 
    -1, -1, OpTypes::simm3_lsa2, 
    -1, -1, OpTypes::simm4, 
    OpTypes::simm9_addiusp, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16_relaxed, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16_relaxed, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, OpTypes::uimm2, 
    -1, -1, -1, OpTypes::uimm2, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm4_andi, 
    -1, -1, OpTypes::uimm4_andi, 
    -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, OpTypes::uimm16_64, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    OpTypes::simm16, 
    OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    OpTypes::brtarget10_mm, 
    -1, -1, -1, 
    OpTypes::brtarget, 
    OpTypes::brtarget26, 
    OpTypes::brtarget26_mm, 
    -1, -1, OpTypes::uimm2, -1, 
    -1, -1, OpTypes::uimm2, -1, 
    -1, OpTypes::uimm5_64_report_uimm6, OpTypes::brtarget, 
    -1, OpTypes::uimm5_64, OpTypes::brtarget, 
    -1, OpTypes::uimm5_64_report_uimm6, OpTypes::brtarget, 
    -1, OpTypes::uimm5_64, OpTypes::brtarget, 
    OpTypes::brtarget26, 
    OpTypes::brtarget10_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    OpTypes::brtarget26_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget_lsl2_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget7_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget21, 
    -1, OpTypes::brtarget7_mm, 
    -1, OpTypes::brtarget21, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget21_mm, 
    -1, -1, OpTypes::brtarget_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget_lsl2_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget_lsl2_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_lsl2_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_lsl2_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_lsl2_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget_lsl2_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget_lsl2_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_lsl2_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, -1, -1, 
    -1, -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget_lsl2_mm, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget7_mm, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget21, 
    -1, OpTypes::brtarget7_mm, 
    -1, OpTypes::brtarget21, 
    -1, OpTypes::brtarget_mm, 
    -1, OpTypes::brtarget21_mm, 
    -1, -1, OpTypes::brtarget_mm, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtargetr6, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtarget, 
    -1, -1, OpTypes::brtargetr6, 
    OpTypes::brtarget, 
    OpTypes::brtarget1SImm16, 
    OpTypes::brtarget_mm, 
    OpTypes::uimm10, OpTypes::uimm10, 
    OpTypes::uimm4, 
    OpTypes::uimm4, 
    OpTypes::uimm10, OpTypes::uimm10, 
    OpTypes::uimm10, OpTypes::uimm10, 
    -1, -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    OpTypes::brtarget, 
    OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    -1, OpTypes::brtarget, 
    /**/
    OpTypes::simm16, 
    OpTypes::simm16, 
    OpTypes::simm16, 
    OpTypes::simm16, 
    -1, OpTypes::simm16, OpTypes::uimm5, 
    -1, OpTypes::simm9, OpTypes::uimm5, 
    -1, OpTypes::simm9, OpTypes::uimm5, 
    -1, OpTypes::simm12, OpTypes::uimm5, 
    -1, OpTypes::simm12, OpTypes::uimm5, 
    -1, OpTypes::simm9, OpTypes::uimm5, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm4_ptr, 
    -1, -1, OpTypes::uimm1_ptr, 
    -1, -1, OpTypes::uimm3_ptr, 
    -1, -1, OpTypes::uimm2_ptr, 
    -1, -1, OpTypes::uimm4_ptr, 
    -1, -1, OpTypes::uimm3_ptr, 
    -1, -1, OpTypes::uimm2_ptr, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16_64, 
    -1, -1, OpTypes::simm16_64, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm16_altrelaxed, 
    -1, -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm16_altrelaxed, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    /**/
    /**/
    -1, -1, OpTypes::uimm5_report_uimm6, OpTypes::uimm5_plus1_report_uimm6, 
    -1, -1, OpTypes::uimm5_report_uimm6, OpTypes::uimm5_plus1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_plus33, 
    -1, -1, OpTypes::uimm5_plus32, OpTypes::uimm5_plus1, 
    -1, 
    -1, -1, OpTypes::uimm6, OpTypes::uimm5_inssize_plus1, -1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm_range_2_64, -1, 
    -1, -1, OpTypes::uimm5_plus32, OpTypes::uimm5_inssize_plus1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, 
    -1, 
    -1, -1, -1, OpTypes::uimm2_plus1, 
    -1, -1, -1, OpTypes::uimm2_plus1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, OpTypes::uimm16, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, OpTypes::uimm16, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    /**/
    /**/
    /**/
    -1, 
    -1, 
    -1, 
    -1, 
    /**/
    /**/
    /**/
    /**/
    /**/
    -1, 
    -1, 
    -1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_plus1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_plus1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_plus1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::condcode, 
    -1, -1, OpTypes::condcode, 
    -1, -1, OpTypes::condcode, 
    -1, -1, OpTypes::condcode, 
    -1, -1, OpTypes::condcode, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, 
    -1, OpTypes::uimm2, 
    -1, OpTypes::uimm2, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    OpTypes::uimm10, 
    OpTypes::uimm10, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_inssize_plus1, -1, 
    -1, -1, -1, OpTypes::uimm4, 
    -1, -1, -1, OpTypes::uimm1, 
    -1, -1, -1, OpTypes::uimm3, 
    -1, -1, -1, OpTypes::uimm2, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm4, -1, OpTypes::uimmz, 
    -1, -1, OpTypes::uimm1, -1, OpTypes::uimmz, 
    -1, -1, OpTypes::uimm3, -1, OpTypes::uimmz, 
    -1, -1, OpTypes::uimm2, -1, OpTypes::uimmz, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_inssize_plus1, -1, 
    -1, -1, OpTypes::uimm5, OpTypes::uimm5_inssize_plus1, -1, 
    OpTypes::jmptarget, 
    OpTypes::calltarget, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    OpTypes::calltarget_mm, 
    OpTypes::calltarget, 
    OpTypes::calltarget, 
    OpTypes::calltarget_mm, 
    -1, OpTypes::calloffset16, 
    -1, OpTypes::calloffset16, 
    -1, OpTypes::calloffset16, 
    -1, OpTypes::jmpoffset16, 
    -1, OpTypes::jmpoffset16, 
    -1, OpTypes::jmpoffset16, 
    -1, 
    -1, 
    -1, 
    OpTypes::uimm5_lsl2, 
    -1, 
    -1, 
    OpTypes::uimm5_lsl2, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    OpTypes::jmptarget_mm, 
    OpTypes::uimm26, 
    OpTypes::uimm26, 
    /**/
    /**/
    -1, 
    -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm4, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm16, 
    -1, OpTypes::vsplat_simm10, 
    -1, OpTypes::vsplat_simm10, 
    -1, OpTypes::vsplat_simm10, 
    -1, OpTypes::vsplat_simm10, 
    -1, -1, OpTypes::simm16, -1, 
    -1, OpTypes::simm18_lsl3, 
    -1, -1, OpTypes::simm16, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm10, 
    -1, -1, OpTypes::simm10_lsl3, 
    -1, -1, OpTypes::simm10_lsl1, 
    -1, -1, OpTypes::simm10_lsl2, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm4, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    -1, OpTypes::li16_imm, 
    -1, OpTypes::li16_imm, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm12, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, -1, OpTypes::uimm2_plus1, 
    -1, -1, -1, OpTypes::uimm2_plus1, 
    -1, -1, -1, OpTypes::uimm2_plus1, 
    -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::uimm16_relaxed, 
    -1, OpTypes::uimm16_64_relaxed, 
    -1, OpTypes::uimm16_relaxed, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm7_lsl2, 
    -1, -1, OpTypes::simm16, -1, 
    -1, -1, OpTypes::simm16, -1, 
    -1, -1, OpTypes::simm9, -1, 
    -1, -1, OpTypes::simm9, -1, 
    -1, -1, OpTypes::simm12, -1, 
    OpTypes::reglist16, -1, OpTypes::uimm8, 
    OpTypes::reglist16, -1, OpTypes::uimm8, 
    OpTypes::reglist, -1, OpTypes::simm12, 
    -1, OpTypes::simm19_lsl2, 
    -1, OpTypes::simm19_lsl2, 
    -1, -1, -1, OpTypes::simm12, 
    -1, -1, OpTypes::simm16, -1, 
    -1, -1, OpTypes::simm16, -1, 
    -1, -1, OpTypes::simm9, -1, 
    -1, -1, OpTypes::simm9, -1, 
    -1, -1, OpTypes::simm12, -1, 
    -1, -1, OpTypes::simm5, 
    -1, OpTypes::simm19_lsl2, 
    -1, -1, OpTypes::simm12, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::pcrel16, OpTypes::i32imm, 
    -1, OpTypes::pcrel16, OpTypes::i32imm, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, -1, OpTypes::uimm1, OpTypes::uimm3, OpTypes::uimm1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_simm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, -1, OpTypes::uimm1, OpTypes::uimm3, OpTypes::uimm1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, OpTypes::uimm16_64, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    /**/
    /**/
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, OpTypes::simm16, OpTypes::uimm5, 
    -1, OpTypes::simm9, OpTypes::uimm5, 
    -1, OpTypes::simm9, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, OpTypes::simm12, OpTypes::uimm5, 
    -1, OpTypes::simm12, OpTypes::uimm5, 
    -1, OpTypes::simm9, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, OpTypes::uimm5, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::uimm10, 
    -1, OpTypes::uimm7, 
    -1, -1, OpTypes::uimm8, 
    -1, -1, OpTypes::uimm8, 
    -1, -1, OpTypes::uimm8, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::simm10, 
    -1, OpTypes::simm10, 
    -1, OpTypes::uimm8, 
    -1, OpTypes::uimm8, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    /**/
    /**/
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, OpTypes::simm9, 
    -1, -1, -1, OpTypes::simm16, 
    -1, -1, -1, OpTypes::simm9, 
    -1, -1, -1, OpTypes::simm9, 
    -1, -1, -1, OpTypes::simm9, 
    -1, -1, -1, OpTypes::simm12, 
    -1, -1, -1, OpTypes::simm9, 
    -1, -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    OpTypes::uimm20, 
    OpTypes::uimm4, 
    OpTypes::uimm4, 
    OpTypes::uimm10, 
    OpTypes::uimm20, 
    OpTypes::uimm20, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm16, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm10_64, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::uimm8, 
    -1, -1, OpTypes::uimm8, 
    -1, -1, OpTypes::uimm8, 
    -1, OpTypes::simm6, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::simm6, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    OpTypes::uimm16, 
    OpTypes::uimm16, 
    -1, -1, -1, OpTypes::uimm4, 
    -1, -1, -1, OpTypes::uimm1, 
    -1, -1, -1, OpTypes::uimm3, 
    -1, -1, -1, OpTypes::uimm2, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm3_shift, 
    -1, -1, OpTypes::uimm3_shift, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16_64, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16_64, 
    -1, -1, OpTypes::simm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm10_64, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm1, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm2, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, OpTypes::uimm3_shift, 
    -1, -1, OpTypes::uimm3_shift, 
    -1, -1, OpTypes::vsplat_uimm3, 
    -1, -1, OpTypes::vsplat_uimm6, 
    -1, -1, OpTypes::vsplat_uimm4, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::uimm3, 
    -1, -1, OpTypes::uimm6, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    /**/
    /**/
    /**/
    -1, -1, OpTypes::simm10, 
    -1, -1, OpTypes::simm10_lsl3, 
    -1, -1, OpTypes::simm10_lsl1, 
    -1, -1, OpTypes::simm10_lsl2, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, OpTypes::vsplat_uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm4, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm11, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm12, 
    OpTypes::reglist16, -1, OpTypes::uimm8, 
    OpTypes::reglist16, -1, OpTypes::uimm8, 
    OpTypes::reglist, -1, OpTypes::simm12, 
    -1, -1, -1, OpTypes::simm12, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm9, 
    -1, -1, OpTypes::simm12, 
    -1, -1, OpTypes::simm5, 
    -1, -1, OpTypes::simm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    OpTypes::uimm5, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    OpTypes::uimm5, 
    OpTypes::uimm5, 
    OpTypes::uimm20, 
    OpTypes::uimm10, 
    /**/
    /**/
    -1, -1, OpTypes::simm16, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm5, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm10, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm10, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm10, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    -1, -1, OpTypes::uimm10, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm10, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, OpTypes::uimm10, 
    -1, OpTypes::simm16, 
    -1, OpTypes::simm16, 
    -1, -1, OpTypes::uimm4, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::simm16, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    /**/
    OpTypes::uimm10, 
    OpTypes::uimm10, 
    -1, OpTypes::uimm10, 
    -1, OpTypes::uimm7, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::vsplat_uimm8, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, OpTypes::uimm16_64, 
    -1, -1, OpTypes::uimm16, 
    -1, -1, -1, 
    -1, -1, 
  };
  return OpcodeOperandTypes[Offsets[Opcode] + OpIdx];
}
} // end namespace Mips
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_TYPE

#ifdef GET_INSTRMAP_INFO
#undef GET_INSTRMAP_INFO
namespace llvm {

namespace Mips {

enum Arch {
	Arch_dsp,
	Arch_mmdsp,
	Arch_mipsr6,
	Arch_micromipsr6,
	Arch_se,
	Arch_micromips
};

// Dsp2MicroMips
LLVM_READONLY
int Dsp2MicroMips(uint16_t Opcode, enum Arch inArch) {
static const uint16_t Dsp2MicroMipsTable[][3] = {
  { Mips::ABSQ_S_PH, Mips::ABSQ_S_PH, Mips::ABSQ_S_PH_MM },
  { Mips::ABSQ_S_QB, Mips::ABSQ_S_QB, Mips::ABSQ_S_QB_MMR2 },
  { Mips::ABSQ_S_W, Mips::ABSQ_S_W, Mips::ABSQ_S_W_MM },
  { Mips::ADDQH_PH, Mips::ADDQH_PH, Mips::ADDQH_PH_MMR2 },
  { Mips::ADDQH_R_PH, Mips::ADDQH_R_PH, Mips::ADDQH_R_PH_MMR2 },
  { Mips::ADDQH_R_W, Mips::ADDQH_R_W, Mips::ADDQH_R_W_MMR2 },
  { Mips::ADDQH_W, Mips::ADDQH_W, Mips::ADDQH_W_MMR2 },
  { Mips::ADDQ_PH, Mips::ADDQ_PH, Mips::ADDQ_PH_MM },
  { Mips::ADDQ_S_PH, Mips::ADDQ_S_PH, Mips::ADDQ_S_PH_MM },
  { Mips::ADDQ_S_W, Mips::ADDQ_S_W, Mips::ADDQ_S_W_MM },
  { Mips::ADDSC, Mips::ADDSC, Mips::ADDSC_MM },
  { Mips::ADDUH_QB, Mips::ADDUH_QB, Mips::ADDUH_QB_MMR2 },
  { Mips::ADDUH_R_QB, Mips::ADDUH_R_QB, Mips::ADDUH_R_QB_MMR2 },
  { Mips::ADDU_PH, Mips::ADDU_PH, Mips::ADDU_PH_MMR2 },
  { Mips::ADDU_QB, Mips::ADDU_QB, Mips::ADDU_QB_MM },
  { Mips::ADDU_S_PH, Mips::ADDU_S_PH, Mips::ADDU_S_PH_MMR2 },
  { Mips::ADDU_S_QB, Mips::ADDU_S_QB, Mips::ADDU_S_QB_MM },
  { Mips::ADDWC, Mips::ADDWC, Mips::ADDWC_MM },
  { Mips::APPEND, Mips::APPEND, Mips::APPEND_MMR2 },
  { Mips::BALIGN, Mips::BALIGN, Mips::BALIGN_MMR2 },
  { Mips::BITREV, Mips::BITREV, Mips::BITREV_MM },
  { Mips::BPOSGE32, Mips::BPOSGE32, Mips::BPOSGE32_MM },
  { Mips::CMPGDU_EQ_QB, Mips::CMPGDU_EQ_QB, Mips::CMPGDU_EQ_QB_MMR2 },
  { Mips::CMPGDU_LE_QB, Mips::CMPGDU_LE_QB, Mips::CMPGDU_LE_QB_MMR2 },
  { Mips::CMPGDU_LT_QB, Mips::CMPGDU_LT_QB, Mips::CMPGDU_LT_QB_MMR2 },
  { Mips::CMPGU_EQ_QB, Mips::CMPGU_EQ_QB, Mips::CMPGU_EQ_QB_MM },
  { Mips::CMPGU_LE_QB, Mips::CMPGU_LE_QB, Mips::CMPGU_LE_QB_MM },
  { Mips::CMPGU_LT_QB, Mips::CMPGU_LT_QB, Mips::CMPGU_LT_QB_MM },
  { Mips::CMPU_EQ_QB, Mips::CMPU_EQ_QB, Mips::CMPU_EQ_QB_MM },
  { Mips::CMPU_LE_QB, Mips::CMPU_LE_QB, Mips::CMPU_LE_QB_MM },
  { Mips::CMPU_LT_QB, Mips::CMPU_LT_QB, Mips::CMPU_LT_QB_MM },
  { Mips::CMP_EQ_PH, Mips::CMP_EQ_PH, Mips::CMP_EQ_PH_MM },
  { Mips::CMP_LE_PH, Mips::CMP_LE_PH, Mips::CMP_LE_PH_MM },
  { Mips::CMP_LT_PH, Mips::CMP_LT_PH, Mips::CMP_LT_PH_MM },
  { Mips::DPAQX_SA_W_PH, Mips::DPAQX_SA_W_PH, Mips::DPAQX_SA_W_PH_MMR2 },
  { Mips::DPAQX_S_W_PH, Mips::DPAQX_S_W_PH, Mips::DPAQX_S_W_PH_MMR2 },
  { Mips::DPAQ_SA_L_W, Mips::DPAQ_SA_L_W, Mips::DPAQ_SA_L_W_MM },
  { Mips::DPAQ_S_W_PH, Mips::DPAQ_S_W_PH, Mips::DPAQ_S_W_PH_MM },
  { Mips::DPAU_H_QBL, Mips::DPAU_H_QBL, Mips::DPAU_H_QBL_MM },
  { Mips::DPAU_H_QBR, Mips::DPAU_H_QBR, Mips::DPAU_H_QBR_MM },
  { Mips::DPAX_W_PH, Mips::DPAX_W_PH, Mips::DPAX_W_PH_MMR2 },
  { Mips::DPA_W_PH, Mips::DPA_W_PH, Mips::DPA_W_PH_MMR2 },
  { Mips::DPSQX_SA_W_PH, Mips::DPSQX_SA_W_PH, Mips::DPSQX_SA_W_PH_MMR2 },
  { Mips::DPSQX_S_W_PH, Mips::DPSQX_S_W_PH, Mips::DPSQX_S_W_PH_MMR2 },
  { Mips::DPSQ_SA_L_W, Mips::DPSQ_SA_L_W, Mips::DPSQ_SA_L_W_MM },
  { Mips::DPSQ_S_W_PH, Mips::DPSQ_S_W_PH, Mips::DPSQ_S_W_PH_MM },
  { Mips::DPSU_H_QBL, Mips::DPSU_H_QBL, Mips::DPSU_H_QBL_MM },
  { Mips::DPSU_H_QBR, Mips::DPSU_H_QBR, Mips::DPSU_H_QBR_MM },
  { Mips::DPSX_W_PH, Mips::DPSX_W_PH, Mips::DPSX_W_PH_MMR2 },
  { Mips::DPS_W_PH, Mips::DPS_W_PH, Mips::DPS_W_PH_MMR2 },
  { Mips::EXTP, Mips::EXTP, Mips::EXTP_MM },
  { Mips::EXTPDP, Mips::EXTPDP, Mips::EXTPDP_MM },
  { Mips::EXTPDPV, Mips::EXTPDPV, Mips::EXTPDPV_MM },
  { Mips::EXTPV, Mips::EXTPV, Mips::EXTPV_MM },
  { Mips::EXTRV_RS_W, Mips::EXTRV_RS_W, Mips::EXTRV_RS_W_MM },
  { Mips::EXTRV_R_W, Mips::EXTRV_R_W, Mips::EXTRV_R_W_MM },
  { Mips::EXTRV_S_H, Mips::EXTRV_S_H, Mips::EXTRV_S_H_MM },
  { Mips::EXTRV_W, Mips::EXTRV_W, Mips::EXTRV_W_MM },
  { Mips::EXTR_RS_W, Mips::EXTR_RS_W, Mips::EXTR_RS_W_MM },
  { Mips::EXTR_R_W, Mips::EXTR_R_W, Mips::EXTR_R_W_MM },
  { Mips::EXTR_S_H, Mips::EXTR_S_H, Mips::EXTR_S_H_MM },
  { Mips::EXTR_W, Mips::EXTR_W, Mips::EXTR_W_MM },
  { Mips::INSV, Mips::INSV, Mips::INSV_MM },
  { Mips::LBUX, Mips::LBUX, Mips::LBUX_MM },
  { Mips::LHX, Mips::LHX, Mips::LHX_MM },
  { Mips::LWDSP, Mips::LWDSP, Mips::LWDSP_MM },
  { Mips::LWX, Mips::LWX, Mips::LWX_MM },
  { Mips::MADDU_DSP, Mips::MADDU_DSP, Mips::MADDU_DSP_MM },
  { Mips::MADD_DSP, Mips::MADD_DSP, Mips::MADD_DSP_MM },
  { Mips::MAQ_SA_W_PHL, Mips::MAQ_SA_W_PHL, Mips::MAQ_SA_W_PHL_MM },
  { Mips::MAQ_SA_W_PHR, Mips::MAQ_SA_W_PHR, Mips::MAQ_SA_W_PHR_MM },
  { Mips::MAQ_S_W_PHL, Mips::MAQ_S_W_PHL, Mips::MAQ_S_W_PHL_MM },
  { Mips::MAQ_S_W_PHR, Mips::MAQ_S_W_PHR, Mips::MAQ_S_W_PHR_MM },
  { Mips::MFHI_DSP, Mips::MFHI_DSP, Mips::MFHI_DSP_MM },
  { Mips::MFLO_DSP, Mips::MFLO_DSP, Mips::MFLO_DSP_MM },
  { Mips::MODSUB, Mips::MODSUB, Mips::MODSUB_MM },
  { Mips::MSUBU_DSP, Mips::MSUBU_DSP, Mips::MSUBU_DSP_MM },
  { Mips::MSUB_DSP, Mips::MSUB_DSP, Mips::MSUB_DSP_MM },
  { Mips::MTHI_DSP, Mips::MTHI_DSP, Mips::MTHI_DSP_MM },
  { Mips::MTHLIP, Mips::MTHLIP, Mips::MTHLIP_MM },
  { Mips::MTLO_DSP, Mips::MTLO_DSP, Mips::MTLO_DSP_MM },
  { Mips::MULEQ_S_W_PHL, Mips::MULEQ_S_W_PHL, Mips::MULEQ_S_W_PHL_MM },
  { Mips::MULEQ_S_W_PHR, Mips::MULEQ_S_W_PHR, Mips::MULEQ_S_W_PHR_MM },
  { Mips::MULEU_S_PH_QBL, Mips::MULEU_S_PH_QBL, Mips::MULEU_S_PH_QBL_MM },
  { Mips::MULEU_S_PH_QBR, Mips::MULEU_S_PH_QBR, Mips::MULEU_S_PH_QBR_MM },
  { Mips::MULQ_RS_PH, Mips::MULQ_RS_PH, Mips::MULQ_RS_PH_MM },
  { Mips::MULQ_RS_W, Mips::MULQ_RS_W, Mips::MULQ_RS_W_MMR2 },
  { Mips::MULQ_S_PH, Mips::MULQ_S_PH, Mips::MULQ_S_PH_MMR2 },
  { Mips::MULQ_S_W, Mips::MULQ_S_W, Mips::MULQ_S_W_MMR2 },
  { Mips::MULSAQ_S_W_PH, Mips::MULSAQ_S_W_PH, Mips::MULSAQ_S_W_PH_MM },
  { Mips::MULSA_W_PH, Mips::MULSA_W_PH, Mips::MULSA_W_PH_MMR2 },
  { Mips::MULTU_DSP, Mips::MULTU_DSP, Mips::MULTU_DSP_MM },
  { Mips::MULT_DSP, Mips::MULT_DSP, Mips::MULT_DSP_MM },
  { Mips::MUL_PH, Mips::MUL_PH, Mips::MUL_PH_MMR2 },
  { Mips::MUL_S_PH, Mips::MUL_S_PH, Mips::MUL_S_PH_MMR2 },
  { Mips::PACKRL_PH, Mips::PACKRL_PH, Mips::PACKRL_PH_MM },
  { Mips::PICK_PH, Mips::PICK_PH, Mips::PICK_PH_MM },
  { Mips::PICK_QB, Mips::PICK_QB, Mips::PICK_QB_MM },
  { Mips::PRECEQU_PH_QBL, Mips::PRECEQU_PH_QBL, Mips::PRECEQU_PH_QBL_MM },
  { Mips::PRECEQU_PH_QBLA, Mips::PRECEQU_PH_QBLA, Mips::PRECEQU_PH_QBLA_MM },
  { Mips::PRECEQU_PH_QBR, Mips::PRECEQU_PH_QBR, Mips::PRECEQU_PH_QBR_MM },
  { Mips::PRECEQU_PH_QBRA, Mips::PRECEQU_PH_QBRA, Mips::PRECEQU_PH_QBRA_MM },
  { Mips::PRECEQ_W_PHL, Mips::PRECEQ_W_PHL, Mips::PRECEQ_W_PHL_MM },
  { Mips::PRECEQ_W_PHR, Mips::PRECEQ_W_PHR, Mips::PRECEQ_W_PHR_MM },
  { Mips::PRECEU_PH_QBL, Mips::PRECEU_PH_QBL, Mips::PRECEU_PH_QBL_MM },
  { Mips::PRECEU_PH_QBLA, Mips::PRECEU_PH_QBLA, Mips::PRECEU_PH_QBLA_MM },
  { Mips::PRECEU_PH_QBR, Mips::PRECEU_PH_QBR, Mips::PRECEU_PH_QBR_MM },
  { Mips::PRECEU_PH_QBRA, Mips::PRECEU_PH_QBRA, Mips::PRECEU_PH_QBRA_MM },
  { Mips::PRECRQU_S_QB_PH, Mips::PRECRQU_S_QB_PH, Mips::PRECRQU_S_QB_PH_MM },
  { Mips::PRECRQ_PH_W, Mips::PRECRQ_PH_W, Mips::PRECRQ_PH_W_MM },
  { Mips::PRECRQ_QB_PH, Mips::PRECRQ_QB_PH, Mips::PRECRQ_QB_PH_MM },
  { Mips::PRECRQ_RS_PH_W, Mips::PRECRQ_RS_PH_W, Mips::PRECRQ_RS_PH_W_MM },
  { Mips::PRECR_QB_PH, Mips::PRECR_QB_PH, Mips::PRECR_QB_PH_MMR2 },
  { Mips::PRECR_SRA_PH_W, Mips::PRECR_SRA_PH_W, Mips::PRECR_SRA_PH_W_MMR2 },
  { Mips::PRECR_SRA_R_PH_W, Mips::PRECR_SRA_R_PH_W, Mips::PRECR_SRA_R_PH_W_MMR2 },
  { Mips::PREPEND, Mips::PREPEND, Mips::PREPEND_MMR2 },
  { Mips::RADDU_W_QB, Mips::RADDU_W_QB, Mips::RADDU_W_QB_MM },
  { Mips::RDDSP, Mips::RDDSP, Mips::RDDSP_MM },
  { Mips::REPLV_PH, Mips::REPLV_PH, Mips::REPLV_PH_MM },
  { Mips::REPLV_QB, Mips::REPLV_QB, Mips::REPLV_QB_MM },
  { Mips::REPL_PH, Mips::REPL_PH, Mips::REPL_PH_MM },
  { Mips::REPL_QB, Mips::REPL_QB, Mips::REPL_QB_MM },
  { Mips::SHILO, Mips::SHILO, Mips::SHILO_MM },
  { Mips::SHILOV, Mips::SHILOV, Mips::SHILOV_MM },
  { Mips::SHLLV_PH, Mips::SHLLV_PH, Mips::SHLLV_PH_MM },
  { Mips::SHLLV_QB, Mips::SHLLV_QB, Mips::SHLLV_QB_MM },
  { Mips::SHLLV_S_PH, Mips::SHLLV_S_PH, Mips::SHLLV_S_PH_MM },
  { Mips::SHLLV_S_W, Mips::SHLLV_S_W, Mips::SHLLV_S_W_MM },
  { Mips::SHLL_PH, Mips::SHLL_PH, Mips::SHLL_PH_MM },
  { Mips::SHLL_QB, Mips::SHLL_QB, Mips::SHLL_QB_MM },
  { Mips::SHLL_S_PH, Mips::SHLL_S_PH, Mips::SHLL_S_PH_MM },
  { Mips::SHLL_S_W, Mips::SHLL_S_W, Mips::SHLL_S_W_MM },
  { Mips::SHRAV_PH, Mips::SHRAV_PH, Mips::SHRAV_PH_MM },
  { Mips::SHRAV_QB, Mips::SHRAV_QB, Mips::SHRAV_QB_MMR2 },
  { Mips::SHRAV_R_PH, Mips::SHRAV_R_PH, Mips::SHRAV_R_PH_MM },
  { Mips::SHRAV_R_QB, Mips::SHRAV_R_QB, Mips::SHRAV_R_QB_MMR2 },
  { Mips::SHRAV_R_W, Mips::SHRAV_R_W, Mips::SHRAV_R_W_MM },
  { Mips::SHRA_PH, Mips::SHRA_PH, Mips::SHRA_PH_MM },
  { Mips::SHRA_QB, Mips::SHRA_QB, Mips::SHRA_QB_MMR2 },
  { Mips::SHRA_R_PH, Mips::SHRA_R_PH, Mips::SHRA_R_PH_MM },
  { Mips::SHRA_R_QB, Mips::SHRA_R_QB, Mips::SHRA_R_QB_MMR2 },
  { Mips::SHRA_R_W, Mips::SHRA_R_W, Mips::SHRA_R_W_MM },
  { Mips::SHRLV_PH, Mips::SHRLV_PH, Mips::SHRLV_PH_MMR2 },
  { Mips::SHRLV_QB, Mips::SHRLV_QB, Mips::SHRLV_QB_MM },
  { Mips::SHRL_PH, Mips::SHRL_PH, Mips::SHRL_PH_MMR2 },
  { Mips::SHRL_QB, Mips::SHRL_QB, Mips::SHRL_QB_MM },
  { Mips::SUBQH_PH, Mips::SUBQH_PH, Mips::SUBQH_PH_MMR2 },
  { Mips::SUBQH_R_PH, Mips::SUBQH_R_PH, Mips::SUBQH_R_PH_MMR2 },
  { Mips::SUBQH_R_W, Mips::SUBQH_R_W, Mips::SUBQH_R_W_MMR2 },
  { Mips::SUBQH_W, Mips::SUBQH_W, Mips::SUBQH_W_MMR2 },
  { Mips::SUBQ_PH, Mips::SUBQ_PH, Mips::SUBQ_PH_MM },
  { Mips::SUBQ_S_PH, Mips::SUBQ_S_PH, Mips::SUBQ_S_PH_MM },
  { Mips::SUBQ_S_W, Mips::SUBQ_S_W, Mips::SUBQ_S_W_MM },
  { Mips::SUBUH_QB, Mips::SUBUH_QB, Mips::SUBUH_QB_MMR2 },
  { Mips::SUBUH_R_QB, Mips::SUBUH_R_QB, Mips::SUBUH_R_QB_MMR2 },
  { Mips::SUBU_PH, Mips::SUBU_PH, Mips::SUBU_PH_MMR2 },
  { Mips::SUBU_QB, Mips::SUBU_QB, Mips::SUBU_QB_MM },
  { Mips::SUBU_S_PH, Mips::SUBU_S_PH, Mips::SUBU_S_PH_MMR2 },
  { Mips::SUBU_S_QB, Mips::SUBU_S_QB, Mips::SUBU_S_QB_MM },
  { Mips::SWDSP, Mips::SWDSP, Mips::SWDSP_MM },
}; // End of Dsp2MicroMipsTable

  unsigned mid;
  unsigned start = 0;
  unsigned end = 160;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == Dsp2MicroMipsTable[mid][0]) {
      break;
    }
    if (Opcode < Dsp2MicroMipsTable[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  if (inArch == Arch_dsp)
    return Dsp2MicroMipsTable[mid][1];
  if (inArch == Arch_mmdsp)
    return Dsp2MicroMipsTable[mid][2];
  return -1;}

// MipsR62MicroMipsR6
LLVM_READONLY
int MipsR62MicroMipsR6(uint16_t Opcode, enum Arch inArch) {
static const uint16_t MipsR62MicroMipsR6Table[][3] = {
  { Mips::ADDIUPC, Mips::ADDIUPC, Mips::ADDIUPC_MMR6 },
  { Mips::ALIGN, Mips::ALIGN, Mips::ALIGN_MMR6 },
  { Mips::ALUIPC, Mips::ALUIPC, Mips::ALUIPC_MMR6 },
  { Mips::AUI, Mips::AUI, Mips::AUI_MMR6 },
  { Mips::AUIPC, Mips::AUIPC, Mips::AUIPC_MMR6 },
  { Mips::BALC, Mips::BALC, Mips::BALC_MMR6 },
  { Mips::BC, Mips::BC, Mips::BC_MMR6 },
  { Mips::BEQC, Mips::BEQC, Mips::BEQC_MMR6 },
  { Mips::BEQZALC, Mips::BEQZALC, Mips::BEQZALC_MMR6 },
  { Mips::BEQZC, Mips::BEQZC, Mips::BEQZC_MMR6 },
  { Mips::BGEC, Mips::BGEC, Mips::BGEC_MMR6 },
  { Mips::BGEUC, Mips::BGEUC, Mips::BGEUC_MMR6 },
  { Mips::BGEZALC, Mips::BGEZALC, Mips::BGEZALC_MMR6 },
  { Mips::BGEZC, Mips::BGEZC, Mips::BGEZC_MMR6 },
  { Mips::BGTZALC, Mips::BGTZALC, Mips::BGTZALC_MMR6 },
  { Mips::BGTZC, Mips::BGTZC, Mips::BGTZC_MMR6 },
  { Mips::BITSWAP, Mips::BITSWAP, Mips::BITSWAP_MMR6 },
  { Mips::BLEZALC, Mips::BLEZALC, Mips::BLEZALC_MMR6 },
  { Mips::BLEZC, Mips::BLEZC, Mips::BLEZC_MMR6 },
  { Mips::BLTC, Mips::BLTC, Mips::BLTC_MMR6 },
  { Mips::BLTUC, Mips::BLTUC, Mips::BLTUC_MMR6 },
  { Mips::BLTZALC, Mips::BLTZALC, Mips::BLTZALC_MMR6 },
  { Mips::BLTZC, Mips::BLTZC, Mips::BLTZC_MMR6 },
  { Mips::BNEC, Mips::BNEC, Mips::BNEC_MMR6 },
  { Mips::BNEZALC, Mips::BNEZALC, Mips::BNEZALC_MMR6 },
  { Mips::BNEZC, Mips::BNEZC, Mips::BNEZC_MMR6 },
  { Mips::BNVC, Mips::BNVC, Mips::BNVC_MMR6 },
  { Mips::BOVC, Mips::BOVC, Mips::BOVC_MMR6 },
  { Mips::CACHE_R6, Mips::CACHE_R6, Mips::CACHE_MMR6 },
  { Mips::CLO_R6, Mips::CLO_R6, Mips::CLO_MMR6 },
  { Mips::CLZ_R6, Mips::CLZ_R6, Mips::CLZ_MMR6 },
  { Mips::CMP_EQ_D, Mips::CMP_EQ_D, Mips::CMP_EQ_D_MMR6 },
  { Mips::CMP_EQ_S, Mips::CMP_EQ_S, Mips::CMP_EQ_S_MMR6 },
  { Mips::CMP_F_D, Mips::CMP_F_D, Mips::CMP_AF_D_MMR6 },
  { Mips::CMP_F_S, Mips::CMP_F_S, Mips::CMP_AF_S_MMR6 },
  { Mips::CMP_LE_D, Mips::CMP_LE_D, Mips::CMP_LE_D_MMR6 },
  { Mips::CMP_LE_S, Mips::CMP_LE_S, Mips::CMP_LE_S_MMR6 },
  { Mips::CMP_LT_D, Mips::CMP_LT_D, Mips::CMP_LT_D_MMR6 },
  { Mips::CMP_LT_S, Mips::CMP_LT_S, Mips::CMP_LT_S_MMR6 },
  { Mips::CMP_SAF_D, Mips::CMP_SAF_D, Mips::CMP_SAF_D_MMR6 },
  { Mips::CMP_SAF_S, Mips::CMP_SAF_S, Mips::CMP_SAF_S_MMR6 },
  { Mips::CMP_SEQ_D, Mips::CMP_SEQ_D, Mips::CMP_SEQ_D_MMR6 },
  { Mips::CMP_SEQ_S, Mips::CMP_SEQ_S, Mips::CMP_SEQ_S_MMR6 },
  { Mips::CMP_SLE_D, Mips::CMP_SLE_D, Mips::CMP_SLE_D_MMR6 },
  { Mips::CMP_SLE_S, Mips::CMP_SLE_S, Mips::CMP_SLE_S_MMR6 },
  { Mips::CMP_SLT_D, Mips::CMP_SLT_D, Mips::CMP_SLT_D_MMR6 },
  { Mips::CMP_SLT_S, Mips::CMP_SLT_S, Mips::CMP_SLT_S_MMR6 },
  { Mips::CMP_SUEQ_D, Mips::CMP_SUEQ_D, Mips::CMP_SUEQ_D_MMR6 },
  { Mips::CMP_SUEQ_S, Mips::CMP_SUEQ_S, Mips::CMP_SUEQ_S_MMR6 },
  { Mips::CMP_SULE_D, Mips::CMP_SULE_D, Mips::CMP_SULE_D_MMR6 },
  { Mips::CMP_SULE_S, Mips::CMP_SULE_S, Mips::CMP_SULE_S_MMR6 },
  { Mips::CMP_SULT_D, Mips::CMP_SULT_D, Mips::CMP_SULT_D_MMR6 },
  { Mips::CMP_SULT_S, Mips::CMP_SULT_S, Mips::CMP_SULT_S_MMR6 },
  { Mips::CMP_SUN_D, Mips::CMP_SUN_D, Mips::CMP_SUN_D_MMR6 },
  { Mips::CMP_SUN_S, Mips::CMP_SUN_S, Mips::CMP_SUN_S_MMR6 },
  { Mips::CMP_UEQ_D, Mips::CMP_UEQ_D, Mips::CMP_UEQ_D_MMR6 },
  { Mips::CMP_UEQ_S, Mips::CMP_UEQ_S, Mips::CMP_UEQ_S_MMR6 },
  { Mips::CMP_ULE_D, Mips::CMP_ULE_D, Mips::CMP_ULE_D_MMR6 },
  { Mips::CMP_ULE_S, Mips::CMP_ULE_S, Mips::CMP_ULE_S_MMR6 },
  { Mips::CMP_ULT_D, Mips::CMP_ULT_D, Mips::CMP_ULT_D_MMR6 },
  { Mips::CMP_ULT_S, Mips::CMP_ULT_S, Mips::CMP_ULT_S_MMR6 },
  { Mips::CMP_UN_D, Mips::CMP_UN_D, Mips::CMP_UN_D_MMR6 },
  { Mips::CMP_UN_S, Mips::CMP_UN_S, Mips::CMP_UN_S_MMR6 },
  { Mips::CRC32B, Mips::CRC32B, (uint16_t)-1U },
  { Mips::CRC32CB, Mips::CRC32CB, (uint16_t)-1U },
  { Mips::CRC32CD, Mips::CRC32CD, (uint16_t)-1U },
  { Mips::CRC32CH, Mips::CRC32CH, (uint16_t)-1U },
  { Mips::CRC32CW, Mips::CRC32CW, (uint16_t)-1U },
  { Mips::CRC32D, Mips::CRC32D, (uint16_t)-1U },
  { Mips::CRC32H, Mips::CRC32H, (uint16_t)-1U },
  { Mips::CRC32W, Mips::CRC32W, (uint16_t)-1U },
  { Mips::DIV, Mips::DIV, Mips::DIV_MMR6 },
  { Mips::DIVU, Mips::DIVU, Mips::DIVU_MMR6 },
  { Mips::DVP, Mips::DVP, Mips::DVP_MMR6 },
  { Mips::EVP, Mips::EVP, Mips::EVP_MMR6 },
  { Mips::GINVI, Mips::GINVI, Mips::GINVI_MMR6 },
  { Mips::GINVT, Mips::GINVT, Mips::GINVT_MMR6 },
  { Mips::JIALC, Mips::JIALC, Mips::JIALC_MMR6 },
  { Mips::JIC, Mips::JIC, Mips::JIC_MMR6 },
  { Mips::LSA_R6, Mips::LSA_R6, Mips::LSA_MMR6 },
  { Mips::LWPC, Mips::LWPC, Mips::LWPC_MMR6 },
  { Mips::MOD, Mips::MOD, Mips::MOD_MMR6 },
  { Mips::MODU, Mips::MODU, Mips::MODU_MMR6 },
  { Mips::MUH, Mips::MUH, Mips::MUH_MMR6 },
  { Mips::MUHU, Mips::MUHU, Mips::MUHU_MMR6 },
  { Mips::MULU, Mips::MULU, Mips::MULU_MMR6 },
  { Mips::MUL_R6, Mips::MUL_R6, Mips::MUL_MMR6 },
  { Mips::PREF_R6, Mips::PREF_R6, Mips::PREF_MMR6 },
  { Mips::SELEQZ, Mips::SELEQZ, Mips::SELEQZ_MMR6 },
  { Mips::SELEQZ_D, Mips::SELEQZ_D, Mips::SELEQZ_D_MMR6 },
  { Mips::SELEQZ_S, Mips::SELEQZ_S, Mips::SELEQZ_S_MMR6 },
  { Mips::SELNEZ, Mips::SELNEZ, Mips::SELNEZ_MMR6 },
  { Mips::SELNEZ_D, Mips::SELNEZ_D, Mips::SELNEZ_D_MMR6 },
  { Mips::SELNEZ_S, Mips::SELNEZ_S, Mips::SELNEZ_S_MMR6 },
  { Mips::SEL_D, Mips::SEL_D, Mips::SEL_D_MMR6 },
  { Mips::SEL_S, Mips::SEL_S, Mips::SEL_S_MMR6 },
}; // End of MipsR62MicroMipsR6Table

  unsigned mid;
  unsigned start = 0;
  unsigned end = 96;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == MipsR62MicroMipsR6Table[mid][0]) {
      break;
    }
    if (Opcode < MipsR62MicroMipsR6Table[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  if (inArch == Arch_mipsr6)
    return MipsR62MicroMipsR6Table[mid][1];
  if (inArch == Arch_micromipsr6)
    return MipsR62MicroMipsR6Table[mid][2];
  return -1;}

// Std2MicroMips
LLVM_READONLY
int Std2MicroMips(uint16_t Opcode, enum Arch inArch) {
static const uint16_t Std2MicroMipsTable[][3] = {
  { Mips::ADD, Mips::ADD, Mips::ADD_MM },
  { Mips::ADDi, Mips::ADDi, Mips::ADDi_MM },
  { Mips::ADDiu, Mips::ADDiu, Mips::ADDiu_MM },
  { Mips::ADDu, Mips::ADDu, Mips::ADDu_MM },
  { Mips::AND, Mips::AND, Mips::AND_MM },
  { Mips::ANDi, Mips::ANDi, Mips::ANDi_MM },
  { Mips::BC1F, Mips::BC1F, Mips::BC1F_MM },
  { Mips::BC1FL, Mips::BC1FL, (uint16_t)-1U },
  { Mips::BC1T, Mips::BC1T, Mips::BC1T_MM },
  { Mips::BC1TL, Mips::BC1TL, (uint16_t)-1U },
  { Mips::BEQ, Mips::BEQ, Mips::BEQ_MM },
  { Mips::BEQL, Mips::BEQL, (uint16_t)-1U },
  { Mips::BGEZ, Mips::BGEZ, Mips::BGEZ_MM },
  { Mips::BGEZAL, Mips::BGEZAL, Mips::BGEZAL_MM },
  { Mips::BGEZALL, Mips::BGEZALL, (uint16_t)-1U },
  { Mips::BGEZL, Mips::BGEZL, (uint16_t)-1U },
  { Mips::BGTZ, Mips::BGTZ, Mips::BGTZ_MM },
  { Mips::BGTZL, Mips::BGTZL, (uint16_t)-1U },
  { Mips::BLEZ, Mips::BLEZ, Mips::BLEZ_MM },
  { Mips::BLEZL, Mips::BLEZL, (uint16_t)-1U },
  { Mips::BLTZ, Mips::BLTZ, Mips::BLTZ_MM },
  { Mips::BLTZAL, Mips::BLTZAL, Mips::BLTZAL_MM },
  { Mips::BLTZALL, Mips::BLTZALL, (uint16_t)-1U },
  { Mips::BLTZL, Mips::BLTZL, (uint16_t)-1U },
  { Mips::BNE, Mips::BNE, Mips::BNE_MM },
  { Mips::BNEL, Mips::BNEL, (uint16_t)-1U },
  { Mips::BREAK, Mips::BREAK, Mips::BREAK_MM },
  { Mips::CACHE, Mips::CACHE, Mips::CACHE_MM },
  { Mips::CACHEE, Mips::CACHEE, Mips::CACHEE_MM },
  { Mips::CEIL_W_D32, Mips::CEIL_W_D32, Mips::CEIL_W_MM },
  { Mips::CEIL_W_S, Mips::CEIL_W_S, Mips::CEIL_W_S_MM },
  { Mips::CFC1, Mips::CFC1, Mips::CFC1_MM },
  { Mips::CLO, Mips::CLO, Mips::CLO_MM },
  { Mips::CLZ, Mips::CLZ, Mips::CLZ_MM },
  { Mips::CTC1, Mips::CTC1, Mips::CTC1_MM },
  { Mips::CVT_D32_S, Mips::CVT_D32_S, Mips::CVT_D32_S_MM },
  { Mips::CVT_D32_W, Mips::CVT_D32_W, Mips::CVT_D32_W_MM },
  { Mips::CVT_L_D64, Mips::CVT_L_D64, Mips::CVT_L_D64_MM },
  { Mips::CVT_L_S, Mips::CVT_L_S, Mips::CVT_L_S_MM },
  { Mips::CVT_S_D32, Mips::CVT_S_D32, Mips::CVT_S_D32_MM },
  { Mips::CVT_S_W, Mips::CVT_S_W, Mips::CVT_S_W_MM },
  { Mips::CVT_W_D32, Mips::CVT_W_D32, Mips::CVT_W_D32_MM },
  { Mips::CVT_W_S, Mips::CVT_W_S, Mips::CVT_W_S_MM },
  { Mips::C_EQ_D32, Mips::C_EQ_D32, Mips::C_EQ_D32_MM },
  { Mips::C_EQ_D64, Mips::C_EQ_D64, Mips::C_EQ_D64_MM },
  { Mips::C_EQ_S, Mips::C_EQ_S, Mips::C_EQ_S_MM },
  { Mips::C_F_D32, Mips::C_F_D32, Mips::C_F_D32_MM },
  { Mips::C_F_D64, Mips::C_F_D64, Mips::C_F_D64_MM },
  { Mips::C_F_S, Mips::C_F_S, Mips::C_F_S_MM },
  { Mips::C_LE_D32, Mips::C_LE_D32, Mips::C_LE_D32_MM },
  { Mips::C_LE_D64, Mips::C_LE_D64, Mips::C_LE_D64_MM },
  { Mips::C_LE_S, Mips::C_LE_S, Mips::C_LE_S_MM },
  { Mips::C_LT_D32, Mips::C_LT_D32, Mips::C_LT_D32_MM },
  { Mips::C_LT_D64, Mips::C_LT_D64, Mips::C_LT_D64_MM },
  { Mips::C_LT_S, Mips::C_LT_S, Mips::C_LT_S_MM },
  { Mips::C_NGE_D32, Mips::C_NGE_D32, Mips::C_NGE_D32_MM },
  { Mips::C_NGE_D64, Mips::C_NGE_D64, Mips::C_NGE_D64_MM },
  { Mips::C_NGE_S, Mips::C_NGE_S, Mips::C_NGE_S_MM },
  { Mips::C_NGLE_D32, Mips::C_NGLE_D32, Mips::C_NGLE_D32_MM },
  { Mips::C_NGLE_D64, Mips::C_NGLE_D64, Mips::C_NGLE_D64_MM },
  { Mips::C_NGLE_S, Mips::C_NGLE_S, Mips::C_NGLE_S_MM },
  { Mips::C_NGL_D32, Mips::C_NGL_D32, Mips::C_NGL_D32_MM },
  { Mips::C_NGL_D64, Mips::C_NGL_D64, Mips::C_NGL_D64_MM },
  { Mips::C_NGL_S, Mips::C_NGL_S, Mips::C_NGL_S_MM },
  { Mips::C_NGT_D32, Mips::C_NGT_D32, Mips::C_NGT_D32_MM },
  { Mips::C_NGT_D64, Mips::C_NGT_D64, Mips::C_NGT_D64_MM },
  { Mips::C_NGT_S, Mips::C_NGT_S, Mips::C_NGT_S_MM },
  { Mips::C_OLE_D32, Mips::C_OLE_D32, Mips::C_OLE_D32_MM },
  { Mips::C_OLE_D64, Mips::C_OLE_D64, Mips::C_OLE_D64_MM },
  { Mips::C_OLE_S, Mips::C_OLE_S, Mips::C_OLE_S_MM },
  { Mips::C_OLT_D32, Mips::C_OLT_D32, Mips::C_OLT_D32_MM },
  { Mips::C_OLT_D64, Mips::C_OLT_D64, Mips::C_OLT_D64_MM },
  { Mips::C_OLT_S, Mips::C_OLT_S, Mips::C_OLT_S_MM },
  { Mips::C_SEQ_D32, Mips::C_SEQ_D32, Mips::C_SEQ_D32_MM },
  { Mips::C_SEQ_D64, Mips::C_SEQ_D64, Mips::C_SEQ_D64_MM },
  { Mips::C_SEQ_S, Mips::C_SEQ_S, Mips::C_SEQ_S_MM },
  { Mips::C_SF_D32, Mips::C_SF_D32, Mips::C_SF_D32_MM },
  { Mips::C_SF_D64, Mips::C_SF_D64, Mips::C_SF_D64_MM },
  { Mips::C_SF_S, Mips::C_SF_S, Mips::C_SF_S_MM },
  { Mips::C_UEQ_D32, Mips::C_UEQ_D32, Mips::C_UEQ_D32_MM },
  { Mips::C_UEQ_D64, Mips::C_UEQ_D64, Mips::C_UEQ_D64_MM },
  { Mips::C_UEQ_S, Mips::C_UEQ_S, Mips::C_UEQ_S_MM },
  { Mips::C_ULE_D32, Mips::C_ULE_D32, Mips::C_ULE_D32_MM },
  { Mips::C_ULE_D64, Mips::C_ULE_D64, Mips::C_ULE_D64_MM },
  { Mips::C_ULE_S, Mips::C_ULE_S, Mips::C_ULE_S_MM },
  { Mips::C_ULT_D32, Mips::C_ULT_D32, Mips::C_ULT_D32_MM },
  { Mips::C_ULT_D64, Mips::C_ULT_D64, Mips::C_ULT_D64_MM },
  { Mips::C_ULT_S, Mips::C_ULT_S, Mips::C_ULT_S_MM },
  { Mips::C_UN_D32, Mips::C_UN_D32, Mips::C_UN_D32_MM },
  { Mips::C_UN_D64, Mips::C_UN_D64, Mips::C_UN_D64_MM },
  { Mips::C_UN_S, Mips::C_UN_S, Mips::C_UN_S_MM },
  { Mips::DERET, Mips::DERET, Mips::DERET_MM },
  { Mips::DI, Mips::DI, Mips::DI_MM },
  { Mips::EHB, Mips::EHB, Mips::EHB_MM },
  { Mips::EI, Mips::EI, Mips::EI_MM },
  { Mips::ERET, Mips::ERET, Mips::ERET_MM },
  { Mips::ERETNC, Mips::ERETNC, (uint16_t)-1U },
  { Mips::EXT, Mips::EXT, Mips::EXT_MM },
  { Mips::FABS_D32, Mips::FABS_D32, Mips::FABS_D32_MM },
  { Mips::FABS_S, Mips::FABS_S, Mips::FABS_S_MM },
  { Mips::FADD_D32, Mips::FADD_D32, Mips::FADD_D32_MM },
  { Mips::FADD_S, Mips::FADD_S, Mips::FADD_S_MM },
  { Mips::FCMP_D32, Mips::FCMP_D32, Mips::FCMP_D32_MM },
  { Mips::FCMP_S32, Mips::FCMP_S32, Mips::FCMP_S32_MM },
  { Mips::FDIV_D32, Mips::FDIV_D32, Mips::FDIV_D32_MM },
  { Mips::FDIV_S, Mips::FDIV_S, Mips::FDIV_S_MM },
  { Mips::FLOOR_W_D32, Mips::FLOOR_W_D32, Mips::FLOOR_W_MM },
  { Mips::FLOOR_W_S, Mips::FLOOR_W_S, Mips::FLOOR_W_S_MM },
  { Mips::FMOV_D32, Mips::FMOV_D32, Mips::FMOV_D32_MM },
  { Mips::FMOV_S, Mips::FMOV_S, Mips::FMOV_S_MM },
  { Mips::FMUL_D32, Mips::FMUL_D32, Mips::FMUL_D32_MM },
  { Mips::FMUL_S, Mips::FMUL_S, Mips::FMUL_S_MM },
  { Mips::FNEG_D32, Mips::FNEG_D32, Mips::FNEG_D32_MM },
  { Mips::FNEG_S, Mips::FNEG_S, Mips::FNEG_S_MM },
  { Mips::FSQRT_D32, Mips::FSQRT_D32, Mips::FSQRT_D32_MM },
  { Mips::FSQRT_S, Mips::FSQRT_S, Mips::FSQRT_S_MM },
  { Mips::FSUB_D32, Mips::FSUB_D32, Mips::FSUB_D32_MM },
  { Mips::FSUB_S, Mips::FSUB_S, Mips::FSUB_S_MM },
  { Mips::HYPCALL, Mips::HYPCALL, Mips::HYPCALL_MM },
  { Mips::INS, Mips::INS, Mips::INS_MM },
  { Mips::J, Mips::J, Mips::J_MM },
  { Mips::JAL, Mips::JAL, Mips::JAL_MM },
  { Mips::JALX, Mips::JALX, Mips::JALX_MM },
  { Mips::JR, Mips::JR, Mips::JR_MM },
  { Mips::LB, Mips::LB, Mips::LB_MM },
  { Mips::LBE, Mips::LBE, Mips::LBE_MM },
  { Mips::LBu, Mips::LBu, Mips::LBu_MM },
  { Mips::LBuE, Mips::LBuE, Mips::LBuE_MM },
  { Mips::LDC1, Mips::LDC1, Mips::LDC1_MM },
  { Mips::LEA_ADDiu, Mips::LEA_ADDiu, Mips::LEA_ADDiu_MM },
  { Mips::LH, Mips::LH, Mips::LH_MM },
  { Mips::LHE, Mips::LHE, Mips::LHE_MM },
  { Mips::LHu, Mips::LHu, Mips::LHu_MM },
  { Mips::LHuE, Mips::LHuE, Mips::LHuE_MM },
  { Mips::LLE, Mips::LLE, Mips::LLE_MM },
  { Mips::LUXC1, Mips::LUXC1, Mips::LUXC1_MM },
  { Mips::LUi, Mips::LUi, Mips::LUi_MM },
  { Mips::LW, Mips::LW, Mips::LW_MM },
  { Mips::LWC1, Mips::LWC1, Mips::LWC1_MM },
  { Mips::LWE, Mips::LWE, Mips::LWE_MM },
  { Mips::LWL, Mips::LWL, Mips::LWL_MM },
  { Mips::LWLE, Mips::LWLE, Mips::LWLE_MM },
  { Mips::LWR, Mips::LWR, Mips::LWR_MM },
  { Mips::LWRE, Mips::LWRE, Mips::LWRE_MM },
  { Mips::LWXC1, Mips::LWXC1, Mips::LWXC1_MM },
  { Mips::LWu, Mips::LWu, Mips::LWU_MM },
  { Mips::MADD, Mips::MADD, Mips::MADD_MM },
  { Mips::MADDU, Mips::MADDU, Mips::MADDU_MM },
  { Mips::MADD_D32, Mips::MADD_D32, Mips::MADD_D32_MM },
  { Mips::MADD_S, Mips::MADD_S, Mips::MADD_S_MM },
  { Mips::MFC1, Mips::MFC1, Mips::MFC1_MM },
  { Mips::MFGC0, Mips::MFGC0, Mips::MFGC0_MM },
  { Mips::MFHC1_D32, Mips::MFHC1_D32, Mips::MFHC1_D32_MM },
  { Mips::MFHGC0, Mips::MFHGC0, Mips::MFHGC0_MM },
  { Mips::MFHI, Mips::MFHI, Mips::MFHI_MM },
  { Mips::MFLO, Mips::MFLO, Mips::MFLO_MM },
  { Mips::MOVF_D32, Mips::MOVF_D32, Mips::MOVF_D32_MM },
  { Mips::MOVF_I, Mips::MOVF_I, Mips::MOVF_I_MM },
  { Mips::MOVF_S, Mips::MOVF_S, Mips::MOVF_S_MM },
  { Mips::MOVN_I_D32, Mips::MOVN_I_D32, Mips::MOVN_I_D32_MM },
  { Mips::MOVN_I_I, Mips::MOVN_I_I, Mips::MOVN_I_MM },
  { Mips::MOVN_I_S, Mips::MOVN_I_S, Mips::MOVN_I_S_MM },
  { Mips::MOVT_D32, Mips::MOVT_D32, Mips::MOVT_D32_MM },
  { Mips::MOVT_I, Mips::MOVT_I, Mips::MOVT_I_MM },
  { Mips::MOVT_S, Mips::MOVT_S, Mips::MOVT_S_MM },
  { Mips::MOVZ_I_D32, Mips::MOVZ_I_D32, Mips::MOVZ_I_D32_MM },
  { Mips::MOVZ_I_I, Mips::MOVZ_I_I, Mips::MOVZ_I_MM },
  { Mips::MOVZ_I_S, Mips::MOVZ_I_S, Mips::MOVZ_I_S_MM },
  { Mips::MSUB, Mips::MSUB, Mips::MSUB_MM },
  { Mips::MSUBU, Mips::MSUBU, Mips::MSUBU_MM },
  { Mips::MSUB_D32, Mips::MSUB_D32, Mips::MSUB_D32_MM },
  { Mips::MSUB_S, Mips::MSUB_S, Mips::MSUB_S_MM },
  { Mips::MTC1, Mips::MTC1, Mips::MTC1_MM },
  { Mips::MTGC0, Mips::MTGC0, Mips::MTGC0_MM },
  { Mips::MTHC1_D32, Mips::MTHC1_D32, Mips::MTHC1_D32_MM },
  { Mips::MTHGC0, Mips::MTHGC0, Mips::MTHGC0_MM },
  { Mips::MTHI, Mips::MTHI, Mips::MTHI_MM },
  { Mips::MTLO, Mips::MTLO, Mips::MTLO_MM },
  { Mips::MUL, Mips::MUL, Mips::MUL_MM },
  { Mips::MULT, Mips::MULT, Mips::MULT_MM },
  { Mips::MULTu, Mips::MULTu, Mips::MULTu_MM },
  { Mips::NMADD_D32, Mips::NMADD_D32, Mips::NMADD_D32_MM },
  { Mips::NMADD_S, Mips::NMADD_S, Mips::NMADD_S_MM },
  { Mips::NMSUB_D32, Mips::NMSUB_D32, Mips::NMSUB_D32_MM },
  { Mips::NMSUB_S, Mips::NMSUB_S, Mips::NMSUB_S_MM },
  { Mips::NOR, Mips::NOR, Mips::NOR_MM },
  { Mips::OR, Mips::OR, Mips::OR_MM },
  { Mips::ORi, Mips::ORi, Mips::ORi_MM },
  { Mips::PAUSE, Mips::PAUSE, Mips::PAUSE_MM },
  { Mips::PREF, Mips::PREF, Mips::PREF_MM },
  { Mips::PREFE, Mips::PREFE, Mips::PREFE_MM },
  { Mips::RDHWR, Mips::RDHWR, Mips::RDHWR_MM },
  { Mips::RECIP_D32, Mips::RECIP_D32, Mips::RECIP_D32_MM },
  { Mips::RECIP_D64, Mips::RECIP_D64, Mips::RECIP_D64_MM },
  { Mips::RECIP_S, Mips::RECIP_S, Mips::RECIP_S_MM },
  { Mips::ROTR, Mips::ROTR, Mips::ROTR_MM },
  { Mips::ROTRV, Mips::ROTRV, Mips::ROTRV_MM },
  { Mips::ROUND_W_D32, Mips::ROUND_W_D32, Mips::ROUND_W_MM },
  { Mips::ROUND_W_S, Mips::ROUND_W_S, Mips::ROUND_W_S_MM },
  { Mips::RSQRT_D32, Mips::RSQRT_D32, Mips::RSQRT_D32_MM },
  { Mips::RSQRT_D64, Mips::RSQRT_D64, Mips::RSQRT_D64_MM },
  { Mips::RSQRT_S, Mips::RSQRT_S, Mips::RSQRT_S_MM },
  { Mips::SB, Mips::SB, Mips::SB_MM },
  { Mips::SBE, Mips::SBE, Mips::SBE_MM },
  { Mips::SCE, Mips::SCE, Mips::SCE_MM },
  { Mips::SDBBP, Mips::SDBBP, Mips::SDBBP_MM },
  { Mips::SDC1, Mips::SDC1, Mips::SDC1_MM },
  { Mips::SDIV, Mips::SDIV, Mips::SDIV_MM },
  { Mips::SEB, Mips::SEB, Mips::SEB_MM },
  { Mips::SEH, Mips::SEH, Mips::SEH_MM },
  { Mips::SH, Mips::SH, Mips::SH_MM },
  { Mips::SHE, Mips::SHE, Mips::SHE_MM },
  { Mips::SLL, Mips::SLL, Mips::SLL_MM },
  { Mips::SLLV, Mips::SLLV, Mips::SLLV_MM },
  { Mips::SLT, Mips::SLT, Mips::SLT_MM },
  { Mips::SLTi, Mips::SLTi, Mips::SLTi_MM },
  { Mips::SLTiu, Mips::SLTiu, Mips::SLTiu_MM },
  { Mips::SLTu, Mips::SLTu, Mips::SLTu_MM },
  { Mips::SRA, Mips::SRA, Mips::SRA_MM },
  { Mips::SRAV, Mips::SRAV, Mips::SRAV_MM },
  { Mips::SRL, Mips::SRL, Mips::SRL_MM },
  { Mips::SRLV, Mips::SRLV, Mips::SRLV_MM },
  { Mips::SSNOP, Mips::SSNOP, Mips::SSNOP_MM },
  { Mips::SUB, Mips::SUB, Mips::SUB_MM },
  { Mips::SUBu, Mips::SUBu, Mips::SUBu_MM },
  { Mips::SUXC1, Mips::SUXC1, Mips::SUXC1_MM },
  { Mips::SW, Mips::SW, Mips::SW_MM },
  { Mips::SWC1, Mips::SWC1, Mips::SWC1_MM },
  { Mips::SWE, Mips::SWE, Mips::SWE_MM },
  { Mips::SWL, Mips::SWL, Mips::SWL_MM },
  { Mips::SWLE, Mips::SWLE, Mips::SWLE_MM },
  { Mips::SWR, Mips::SWR, Mips::SWR_MM },
  { Mips::SWRE, Mips::SWRE, Mips::SWRE_MM },
  { Mips::SWXC1, Mips::SWXC1, Mips::SWXC1_MM },
  { Mips::SYNC, Mips::SYNC, Mips::SYNC_MM },
  { Mips::SYNCI, Mips::SYNCI, Mips::SYNCI_MM },
  { Mips::SYSCALL, Mips::SYSCALL, Mips::SYSCALL_MM },
  { Mips::TEQ, Mips::TEQ, Mips::TEQ_MM },
  { Mips::TEQI, Mips::TEQI, Mips::TEQI_MM },
  { Mips::TGE, Mips::TGE, Mips::TGE_MM },
  { Mips::TGEI, Mips::TGEI, Mips::TGEI_MM },
  { Mips::TGEIU, Mips::TGEIU, Mips::TGEIU_MM },
  { Mips::TGEU, Mips::TGEU, Mips::TGEU_MM },
  { Mips::TLBGINV, Mips::TLBGINV, Mips::TLBGINV_MM },
  { Mips::TLBGINVF, Mips::TLBGINVF, Mips::TLBGINVF_MM },
  { Mips::TLBGP, Mips::TLBGP, Mips::TLBGP_MM },
  { Mips::TLBGR, Mips::TLBGR, Mips::TLBGR_MM },
  { Mips::TLBGWI, Mips::TLBGWI, Mips::TLBGWI_MM },
  { Mips::TLBGWR, Mips::TLBGWR, Mips::TLBGWR_MM },
  { Mips::TLBP, Mips::TLBP, Mips::TLBP_MM },
  { Mips::TLBR, Mips::TLBR, Mips::TLBR_MM },
  { Mips::TLBWI, Mips::TLBWI, Mips::TLBWI_MM },
  { Mips::TLBWR, Mips::TLBWR, Mips::TLBWR_MM },
  { Mips::TLT, Mips::TLT, Mips::TLT_MM },
  { Mips::TLTI, Mips::TLTI, Mips::TLTI_MM },
  { Mips::TLTU, Mips::TLTU, Mips::TLTU_MM },
  { Mips::TNE, Mips::TNE, Mips::TNE_MM },
  { Mips::TNEI, Mips::TNEI, Mips::TNEI_MM },
  { Mips::TRUNC_W_D32, Mips::TRUNC_W_D32, Mips::TRUNC_W_MM },
  { Mips::TRUNC_W_S, Mips::TRUNC_W_S, Mips::TRUNC_W_S_MM },
  { Mips::TTLTIU, Mips::TTLTIU, Mips::TLTIU_MM },
  { Mips::UDIV, Mips::UDIV, Mips::UDIV_MM },
  { Mips::WAIT, Mips::WAIT, Mips::WAIT_MM },
  { Mips::WSBH, Mips::WSBH, Mips::WSBH_MM },
  { Mips::XOR, Mips::XOR, Mips::XOR_MM },
  { Mips::XORi, Mips::XORi, Mips::XORi_MM },
}; // End of Std2MicroMipsTable

  unsigned mid;
  unsigned start = 0;
  unsigned end = 266;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == Std2MicroMipsTable[mid][0]) {
      break;
    }
    if (Opcode < Std2MicroMipsTable[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  if (inArch == Arch_se)
    return Std2MicroMipsTable[mid][1];
  if (inArch == Arch_micromips)
    return Std2MicroMipsTable[mid][2];
  return -1;}

// Std2MicroMipsR6
LLVM_READONLY
int Std2MicroMipsR6(uint16_t Opcode, enum Arch inArch) {
static const uint16_t Std2MicroMipsR6Table[][3] = {
  { Mips::ADD, Mips::ADD, Mips::ADD_MMR6 },
  { Mips::ADDiu, Mips::ADDiu, Mips::ADDIU_MMR6 },
  { Mips::ADDu, Mips::ADDu, Mips::ADDU_MMR6 },
  { Mips::AND, Mips::AND, Mips::AND_MMR6 },
  { Mips::ANDi, Mips::ANDi, Mips::ANDI_MMR6 },
  { Mips::BREAK, Mips::BREAK, Mips::BREAK_MMR6 },
  { Mips::CEIL_W_D64, Mips::CEIL_W_D64, Mips::CEIL_W_D_MMR6 },
  { Mips::CEIL_W_S, Mips::CEIL_W_S, Mips::CEIL_W_S_MMR6 },
  { Mips::CVT_W_D64, Mips::CVT_W_D64, (uint16_t)-1U },
  { Mips::DI, Mips::DI, Mips::DI_MMR6 },
  { Mips::EI, Mips::EI, Mips::EI_MMR6 },
  { Mips::EXT, Mips::EXT, Mips::EXT_MMR6 },
  { Mips::FABS_D64, Mips::FABS_D64, (uint16_t)-1U },
  { Mips::FLOOR_W_D64, Mips::FLOOR_W_D64, Mips::FLOOR_W_D_MMR6 },
  { Mips::FLOOR_W_S, Mips::FLOOR_W_S, Mips::FLOOR_W_S_MMR6 },
  { Mips::FMOV_D64, Mips::FMOV_D64, Mips::FMOV_D_MMR6 },
  { Mips::FNEG_D64, Mips::FNEG_D64, (uint16_t)-1U },
  { Mips::FSQRT_D64, Mips::FSQRT_D64, (uint16_t)-1U },
  { Mips::FSQRT_S, Mips::FSQRT_S, (uint16_t)-1U },
  { Mips::INS, Mips::INS, Mips::INS_MMR6 },
  { Mips::LDC1, Mips::LDC1, (uint16_t)-1U },
  { Mips::LDC164, Mips::LDC164, Mips::LDC1_D64_MMR6 },
  { Mips::LDC2, Mips::LDC2, Mips::LDC2_MMR6 },
  { Mips::LW, Mips::LW, Mips::LW_MMR6 },
  { Mips::LWC2, Mips::LWC2, Mips::LWC2_MMR6 },
  { Mips::MFC1, Mips::MFC1, Mips::MFC1_MMR6 },
  { Mips::MTC1, Mips::MTC1, Mips::MTC1_MMR6 },
  { Mips::MTHC1_D32, Mips::MTHC1_D32, (uint16_t)-1U },
  { Mips::NOR, Mips::NOR, Mips::NOR_MMR6 },
  { Mips::OR, Mips::OR, Mips::OR_MMR6 },
  { Mips::ORi, Mips::ORi, Mips::ORI_MMR6 },
  { Mips::PAUSE, Mips::PAUSE, Mips::PAUSE_MMR6 },
  { Mips::ROUND_W_D64, Mips::ROUND_W_D64, Mips::ROUND_W_D_MMR6 },
  { Mips::ROUND_W_S, Mips::ROUND_W_S, Mips::ROUND_W_S_MMR6 },
  { Mips::SB, Mips::SB, Mips::SB_MMR6 },
  { Mips::SDC164, Mips::SDC164, Mips::SDC1_D64_MMR6 },
  { Mips::SDC2, Mips::SDC2, Mips::SDC2_MMR6 },
  { Mips::SEB, Mips::SEB, (uint16_t)-1U },
  { Mips::SEH, Mips::SEH, (uint16_t)-1U },
  { Mips::SSNOP, Mips::SSNOP, Mips::SSNOP_MMR6 },
  { Mips::SUB, Mips::SUB, Mips::SUB_MMR6 },
  { Mips::SUBu, Mips::SUBu, Mips::SUBU_MMR6 },
  { Mips::SW, Mips::SW, Mips::SW_MMR6 },
  { Mips::SWC2, Mips::SWC2, Mips::SWC2_MMR6 },
  { Mips::SYNC, Mips::SYNC, Mips::SYNC_MMR6 },
  { Mips::SYNCI, Mips::SYNCI, Mips::SYNCI_MMR6 },
  { Mips::TRUNC_W_D64, Mips::TRUNC_W_D64, Mips::TRUNC_W_D_MMR6 },
  { Mips::TRUNC_W_S, Mips::TRUNC_W_S, Mips::TRUNC_W_S_MMR6 },
  { Mips::WAIT, Mips::WAIT, Mips::WAIT_MMR6 },
  { Mips::XOR, Mips::XOR, Mips::XOR_MMR6 },
  { Mips::XORi, Mips::XORi, Mips::XORI_MMR6 },
}; // End of Std2MicroMipsR6Table

  unsigned mid;
  unsigned start = 0;
  unsigned end = 51;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == Std2MicroMipsR6Table[mid][0]) {
      break;
    }
    if (Opcode < Std2MicroMipsR6Table[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  if (inArch == Arch_se)
    return Std2MicroMipsR6Table[mid][1];
  if (inArch == Arch_micromipsr6)
    return Std2MicroMipsR6Table[mid][2];
  return -1;}

} // End Mips namespace
} // End llvm namespace
#endif // GET_INSTRMAP_INFO

