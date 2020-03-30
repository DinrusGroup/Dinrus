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

namespace PPC {
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
    CFENCE8	= 164,
    CLRLSLDI	= 165,
    CLRLSLDIo	= 166,
    CLRLSLWI	= 167,
    CLRLSLWIo	= 168,
    CLRRDI	= 169,
    CLRRDIo	= 170,
    CLRRWI	= 171,
    CLRRWIo	= 172,
    CP_COPY_FIRST	= 173,
    CP_COPYx	= 174,
    CP_PASTE_LAST	= 175,
    CP_PASTEx	= 176,
    DCBFL	= 177,
    DCBFLP	= 178,
    DCBFx	= 179,
    DCBTCT	= 180,
    DCBTDS	= 181,
    DCBTSTCT	= 182,
    DCBTSTDS	= 183,
    DCBTSTT	= 184,
    DCBTSTx	= 185,
    DCBTT	= 186,
    DCBTx	= 187,
    DFLOADf32	= 188,
    DFLOADf64	= 189,
    DFSTOREf32	= 190,
    DFSTOREf64	= 191,
    EXTLDI	= 192,
    EXTLDIo	= 193,
    EXTLWI	= 194,
    EXTLWIo	= 195,
    EXTRDI	= 196,
    EXTRDIo	= 197,
    EXTRWI	= 198,
    EXTRWIo	= 199,
    INSLWI	= 200,
    INSLWIo	= 201,
    INSRDI	= 202,
    INSRDIo	= 203,
    INSRWI	= 204,
    INSRWIo	= 205,
    LAx	= 206,
    LIWAX	= 207,
    LIWZX	= 208,
    RLWIMIbm	= 209,
    RLWIMIobm	= 210,
    RLWINMbm	= 211,
    RLWINMobm	= 212,
    RLWNMbm	= 213,
    RLWNMobm	= 214,
    ROTRDI	= 215,
    ROTRDIo	= 216,
    ROTRWI	= 217,
    ROTRWIo	= 218,
    SLDI	= 219,
    SLDIo	= 220,
    SLWI	= 221,
    SLWIo	= 222,
    SPILLTOVSR_LD	= 223,
    SPILLTOVSR_LDX	= 224,
    SPILLTOVSR_ST	= 225,
    SPILLTOVSR_STX	= 226,
    SRDI	= 227,
    SRDIo	= 228,
    SRWI	= 229,
    SRWIo	= 230,
    STIWX	= 231,
    SUBI	= 232,
    SUBIC	= 233,
    SUBICo	= 234,
    SUBIS	= 235,
    SUBPCIS	= 236,
    XFLOADf32	= 237,
    XFLOADf64	= 238,
    XFSTOREf32	= 239,
    XFSTOREf64	= 240,
    ADD4	= 241,
    ADD4TLS	= 242,
    ADD4o	= 243,
    ADD8	= 244,
    ADD8TLS	= 245,
    ADD8TLS_	= 246,
    ADD8o	= 247,
    ADDC	= 248,
    ADDC8	= 249,
    ADDC8o	= 250,
    ADDCo	= 251,
    ADDE	= 252,
    ADDE8	= 253,
    ADDE8o	= 254,
    ADDEo	= 255,
    ADDI	= 256,
    ADDI8	= 257,
    ADDIC	= 258,
    ADDIC8	= 259,
    ADDICo	= 260,
    ADDIS	= 261,
    ADDIS8	= 262,
    ADDISdtprelHA	= 263,
    ADDISdtprelHA32	= 264,
    ADDISgotTprelHA	= 265,
    ADDIStlsgdHA	= 266,
    ADDIStlsldHA	= 267,
    ADDIStocHA	= 268,
    ADDIdtprelL	= 269,
    ADDIdtprelL32	= 270,
    ADDItlsgdL	= 271,
    ADDItlsgdL32	= 272,
    ADDItlsgdLADDR	= 273,
    ADDItlsgdLADDR32	= 274,
    ADDItlsldL	= 275,
    ADDItlsldL32	= 276,
    ADDItlsldLADDR	= 277,
    ADDItlsldLADDR32	= 278,
    ADDItocL	= 279,
    ADDME	= 280,
    ADDME8	= 281,
    ADDME8o	= 282,
    ADDMEo	= 283,
    ADDPCIS	= 284,
    ADDZE	= 285,
    ADDZE8	= 286,
    ADDZE8o	= 287,
    ADDZEo	= 288,
    ADJCALLSTACKDOWN	= 289,
    ADJCALLSTACKUP	= 290,
    AND	= 291,
    AND8	= 292,
    AND8o	= 293,
    ANDC	= 294,
    ANDC8	= 295,
    ANDC8o	= 296,
    ANDCo	= 297,
    ANDISo	= 298,
    ANDISo8	= 299,
    ANDIo	= 300,
    ANDIo8	= 301,
    ANDIo_1_EQ_BIT	= 302,
    ANDIo_1_EQ_BIT8	= 303,
    ANDIo_1_GT_BIT	= 304,
    ANDIo_1_GT_BIT8	= 305,
    ANDo	= 306,
    ATOMIC_CMP_SWAP_I16	= 307,
    ATOMIC_CMP_SWAP_I32	= 308,
    ATOMIC_CMP_SWAP_I64	= 309,
    ATOMIC_CMP_SWAP_I8	= 310,
    ATOMIC_LOAD_ADD_I16	= 311,
    ATOMIC_LOAD_ADD_I32	= 312,
    ATOMIC_LOAD_ADD_I64	= 313,
    ATOMIC_LOAD_ADD_I8	= 314,
    ATOMIC_LOAD_AND_I16	= 315,
    ATOMIC_LOAD_AND_I32	= 316,
    ATOMIC_LOAD_AND_I64	= 317,
    ATOMIC_LOAD_AND_I8	= 318,
    ATOMIC_LOAD_MAX_I16	= 319,
    ATOMIC_LOAD_MAX_I32	= 320,
    ATOMIC_LOAD_MAX_I64	= 321,
    ATOMIC_LOAD_MAX_I8	= 322,
    ATOMIC_LOAD_MIN_I16	= 323,
    ATOMIC_LOAD_MIN_I32	= 324,
    ATOMIC_LOAD_MIN_I64	= 325,
    ATOMIC_LOAD_MIN_I8	= 326,
    ATOMIC_LOAD_NAND_I16	= 327,
    ATOMIC_LOAD_NAND_I32	= 328,
    ATOMIC_LOAD_NAND_I64	= 329,
    ATOMIC_LOAD_NAND_I8	= 330,
    ATOMIC_LOAD_OR_I16	= 331,
    ATOMIC_LOAD_OR_I32	= 332,
    ATOMIC_LOAD_OR_I64	= 333,
    ATOMIC_LOAD_OR_I8	= 334,
    ATOMIC_LOAD_SUB_I16	= 335,
    ATOMIC_LOAD_SUB_I32	= 336,
    ATOMIC_LOAD_SUB_I64	= 337,
    ATOMIC_LOAD_SUB_I8	= 338,
    ATOMIC_LOAD_UMAX_I16	= 339,
    ATOMIC_LOAD_UMAX_I32	= 340,
    ATOMIC_LOAD_UMAX_I64	= 341,
    ATOMIC_LOAD_UMAX_I8	= 342,
    ATOMIC_LOAD_UMIN_I16	= 343,
    ATOMIC_LOAD_UMIN_I32	= 344,
    ATOMIC_LOAD_UMIN_I64	= 345,
    ATOMIC_LOAD_UMIN_I8	= 346,
    ATOMIC_LOAD_XOR_I16	= 347,
    ATOMIC_LOAD_XOR_I32	= 348,
    ATOMIC_LOAD_XOR_I64	= 349,
    ATOMIC_LOAD_XOR_I8	= 350,
    ATOMIC_SWAP_I16	= 351,
    ATOMIC_SWAP_I32	= 352,
    ATOMIC_SWAP_I64	= 353,
    ATOMIC_SWAP_I8	= 354,
    ATTN	= 355,
    B	= 356,
    BA	= 357,
    BC	= 358,
    BCC	= 359,
    BCCA	= 360,
    BCCCTR	= 361,
    BCCCTR8	= 362,
    BCCCTRL	= 363,
    BCCCTRL8	= 364,
    BCCL	= 365,
    BCCLA	= 366,
    BCCLR	= 367,
    BCCLRL	= 368,
    BCCTR	= 369,
    BCCTR8	= 370,
    BCCTR8n	= 371,
    BCCTRL	= 372,
    BCCTRL8	= 373,
    BCCTRL8n	= 374,
    BCCTRLn	= 375,
    BCCTRn	= 376,
    BCDCFNo	= 377,
    BCDCFSQo	= 378,
    BCDCFZo	= 379,
    BCDCPSGNo	= 380,
    BCDCTNo	= 381,
    BCDCTSQo	= 382,
    BCDCTZo	= 383,
    BCDSETSGNo	= 384,
    BCDSRo	= 385,
    BCDSo	= 386,
    BCDTRUNCo	= 387,
    BCDUSo	= 388,
    BCDUTRUNCo	= 389,
    BCL	= 390,
    BCLR	= 391,
    BCLRL	= 392,
    BCLRLn	= 393,
    BCLRn	= 394,
    BCLalways	= 395,
    BCLn	= 396,
    BCTR	= 397,
    BCTR8	= 398,
    BCTRL	= 399,
    BCTRL8	= 400,
    BCTRL8_LDinto_toc	= 401,
    BCn	= 402,
    BDNZ	= 403,
    BDNZ8	= 404,
    BDNZA	= 405,
    BDNZAm	= 406,
    BDNZAp	= 407,
    BDNZL	= 408,
    BDNZLA	= 409,
    BDNZLAm	= 410,
    BDNZLAp	= 411,
    BDNZLR	= 412,
    BDNZLR8	= 413,
    BDNZLRL	= 414,
    BDNZLRLm	= 415,
    BDNZLRLp	= 416,
    BDNZLRm	= 417,
    BDNZLRp	= 418,
    BDNZLm	= 419,
    BDNZLp	= 420,
    BDNZm	= 421,
    BDNZp	= 422,
    BDZ	= 423,
    BDZ8	= 424,
    BDZA	= 425,
    BDZAm	= 426,
    BDZAp	= 427,
    BDZL	= 428,
    BDZLA	= 429,
    BDZLAm	= 430,
    BDZLAp	= 431,
    BDZLR	= 432,
    BDZLR8	= 433,
    BDZLRL	= 434,
    BDZLRLm	= 435,
    BDZLRLp	= 436,
    BDZLRm	= 437,
    BDZLRp	= 438,
    BDZLm	= 439,
    BDZLp	= 440,
    BDZm	= 441,
    BDZp	= 442,
    BL	= 443,
    BL8	= 444,
    BL8_NOP	= 445,
    BL8_NOP_TLS	= 446,
    BL8_TLS	= 447,
    BL8_TLS_	= 448,
    BLA	= 449,
    BLA8	= 450,
    BLA8_NOP	= 451,
    BLR	= 452,
    BLR8	= 453,
    BLRL	= 454,
    BL_NOP	= 455,
    BL_TLS	= 456,
    BPERMD	= 457,
    BRINC	= 458,
    CLRBHRB	= 459,
    CMPB	= 460,
    CMPB8	= 461,
    CMPD	= 462,
    CMPDI	= 463,
    CMPEQB	= 464,
    CMPLD	= 465,
    CMPLDI	= 466,
    CMPLW	= 467,
    CMPLWI	= 468,
    CMPRB	= 469,
    CMPRB8	= 470,
    CMPW	= 471,
    CMPWI	= 472,
    CNTLZD	= 473,
    CNTLZDo	= 474,
    CNTLZW	= 475,
    CNTLZW8	= 476,
    CNTLZW8o	= 477,
    CNTLZWo	= 478,
    CNTTZD	= 479,
    CNTTZDo	= 480,
    CNTTZW	= 481,
    CNTTZW8	= 482,
    CNTTZW8o	= 483,
    CNTTZWo	= 484,
    CP_ABORT	= 485,
    CP_COPY	= 486,
    CP_COPY8	= 487,
    CP_PASTE	= 488,
    CP_PASTE8	= 489,
    CP_PASTE8o	= 490,
    CP_PASTEo	= 491,
    CR6SET	= 492,
    CR6UNSET	= 493,
    CRAND	= 494,
    CRANDC	= 495,
    CREQV	= 496,
    CRNAND	= 497,
    CRNOR	= 498,
    CROR	= 499,
    CRORC	= 500,
    CRSET	= 501,
    CRUNSET	= 502,
    CRXOR	= 503,
    CTRL_DEP	= 504,
    DARN	= 505,
    DCBA	= 506,
    DCBF	= 507,
    DCBFEP	= 508,
    DCBI	= 509,
    DCBST	= 510,
    DCBSTEP	= 511,
    DCBT	= 512,
    DCBTEP	= 513,
    DCBTST	= 514,
    DCBTSTEP	= 515,
    DCBZ	= 516,
    DCBZEP	= 517,
    DCBZL	= 518,
    DCBZLEP	= 519,
    DCCCI	= 520,
    DIVD	= 521,
    DIVDE	= 522,
    DIVDEU	= 523,
    DIVDEUo	= 524,
    DIVDEo	= 525,
    DIVDU	= 526,
    DIVDUo	= 527,
    DIVDo	= 528,
    DIVW	= 529,
    DIVWE	= 530,
    DIVWEU	= 531,
    DIVWEUo	= 532,
    DIVWEo	= 533,
    DIVWU	= 534,
    DIVWUo	= 535,
    DIVWo	= 536,
    DSS	= 537,
    DSSALL	= 538,
    DST	= 539,
    DST64	= 540,
    DSTST	= 541,
    DSTST64	= 542,
    DSTSTT	= 543,
    DSTSTT64	= 544,
    DSTT	= 545,
    DSTT64	= 546,
    DYNALLOC	= 547,
    DYNALLOC8	= 548,
    DYNAREAOFFSET	= 549,
    DYNAREAOFFSET8	= 550,
    EFDABS	= 551,
    EFDADD	= 552,
    EFDCFS	= 553,
    EFDCFSF	= 554,
    EFDCFSI	= 555,
    EFDCFSID	= 556,
    EFDCFUF	= 557,
    EFDCFUI	= 558,
    EFDCFUID	= 559,
    EFDCMPEQ	= 560,
    EFDCMPGT	= 561,
    EFDCMPLT	= 562,
    EFDCTSF	= 563,
    EFDCTSI	= 564,
    EFDCTSIDZ	= 565,
    EFDCTSIZ	= 566,
    EFDCTUF	= 567,
    EFDCTUI	= 568,
    EFDCTUIDZ	= 569,
    EFDCTUIZ	= 570,
    EFDDIV	= 571,
    EFDMUL	= 572,
    EFDNABS	= 573,
    EFDNEG	= 574,
    EFDSUB	= 575,
    EFDTSTEQ	= 576,
    EFDTSTGT	= 577,
    EFDTSTLT	= 578,
    EFSABS	= 579,
    EFSADD	= 580,
    EFSCFD	= 581,
    EFSCFSF	= 582,
    EFSCFSI	= 583,
    EFSCFUF	= 584,
    EFSCFUI	= 585,
    EFSCMPEQ	= 586,
    EFSCMPGT	= 587,
    EFSCMPLT	= 588,
    EFSCTSF	= 589,
    EFSCTSI	= 590,
    EFSCTSIZ	= 591,
    EFSCTUF	= 592,
    EFSCTUI	= 593,
    EFSCTUIZ	= 594,
    EFSDIV	= 595,
    EFSMUL	= 596,
    EFSNABS	= 597,
    EFSNEG	= 598,
    EFSSUB	= 599,
    EFSTSTEQ	= 600,
    EFSTSTGT	= 601,
    EFSTSTLT	= 602,
    EH_SjLj_LongJmp32	= 603,
    EH_SjLj_LongJmp64	= 604,
    EH_SjLj_SetJmp32	= 605,
    EH_SjLj_SetJmp64	= 606,
    EH_SjLj_Setup	= 607,
    EQV	= 608,
    EQV8	= 609,
    EQV8o	= 610,
    EQVo	= 611,
    EVABS	= 612,
    EVADDIW	= 613,
    EVADDSMIAAW	= 614,
    EVADDSSIAAW	= 615,
    EVADDUMIAAW	= 616,
    EVADDUSIAAW	= 617,
    EVADDW	= 618,
    EVAND	= 619,
    EVANDC	= 620,
    EVCMPEQ	= 621,
    EVCMPGTS	= 622,
    EVCMPGTU	= 623,
    EVCMPLTS	= 624,
    EVCMPLTU	= 625,
    EVCNTLSW	= 626,
    EVCNTLZW	= 627,
    EVDIVWS	= 628,
    EVDIVWU	= 629,
    EVEQV	= 630,
    EVEXTSB	= 631,
    EVEXTSH	= 632,
    EVFSABS	= 633,
    EVFSADD	= 634,
    EVFSCFSF	= 635,
    EVFSCFSI	= 636,
    EVFSCFUF	= 637,
    EVFSCFUI	= 638,
    EVFSCMPEQ	= 639,
    EVFSCMPGT	= 640,
    EVFSCMPLT	= 641,
    EVFSCTSF	= 642,
    EVFSCTSI	= 643,
    EVFSCTSIZ	= 644,
    EVFSCTUF	= 645,
    EVFSCTUI	= 646,
    EVFSCTUIZ	= 647,
    EVFSDIV	= 648,
    EVFSMUL	= 649,
    EVFSNABS	= 650,
    EVFSNEG	= 651,
    EVFSSUB	= 652,
    EVFSTSTEQ	= 653,
    EVFSTSTGT	= 654,
    EVFSTSTLT	= 655,
    EVLDD	= 656,
    EVLDDX	= 657,
    EVLDH	= 658,
    EVLDHX	= 659,
    EVLDW	= 660,
    EVLDWX	= 661,
    EVLHHESPLAT	= 662,
    EVLHHESPLATX	= 663,
    EVLHHOSSPLAT	= 664,
    EVLHHOSSPLATX	= 665,
    EVLHHOUSPLAT	= 666,
    EVLHHOUSPLATX	= 667,
    EVLWHE	= 668,
    EVLWHEX	= 669,
    EVLWHOS	= 670,
    EVLWHOSX	= 671,
    EVLWHOU	= 672,
    EVLWHOUX	= 673,
    EVLWHSPLAT	= 674,
    EVLWHSPLATX	= 675,
    EVLWWSPLAT	= 676,
    EVLWWSPLATX	= 677,
    EVMERGEHI	= 678,
    EVMERGEHILO	= 679,
    EVMERGELO	= 680,
    EVMERGELOHI	= 681,
    EVMHEGSMFAA	= 682,
    EVMHEGSMFAN	= 683,
    EVMHEGSMIAA	= 684,
    EVMHEGSMIAN	= 685,
    EVMHEGUMIAA	= 686,
    EVMHEGUMIAN	= 687,
    EVMHESMF	= 688,
    EVMHESMFA	= 689,
    EVMHESMFAAW	= 690,
    EVMHESMFANW	= 691,
    EVMHESMI	= 692,
    EVMHESMIA	= 693,
    EVMHESMIAAW	= 694,
    EVMHESMIANW	= 695,
    EVMHESSF	= 696,
    EVMHESSFA	= 697,
    EVMHESSFAAW	= 698,
    EVMHESSFANW	= 699,
    EVMHESSIAAW	= 700,
    EVMHESSIANW	= 701,
    EVMHEUMI	= 702,
    EVMHEUMIA	= 703,
    EVMHEUMIAAW	= 704,
    EVMHEUMIANW	= 705,
    EVMHEUSIAAW	= 706,
    EVMHEUSIANW	= 707,
    EVMHOGSMFAA	= 708,
    EVMHOGSMFAN	= 709,
    EVMHOGSMIAA	= 710,
    EVMHOGSMIAN	= 711,
    EVMHOGUMIAA	= 712,
    EVMHOGUMIAN	= 713,
    EVMHOSMF	= 714,
    EVMHOSMFA	= 715,
    EVMHOSMFAAW	= 716,
    EVMHOSMFANW	= 717,
    EVMHOSMI	= 718,
    EVMHOSMIA	= 719,
    EVMHOSMIAAW	= 720,
    EVMHOSMIANW	= 721,
    EVMHOSSF	= 722,
    EVMHOSSFA	= 723,
    EVMHOSSFAAW	= 724,
    EVMHOSSFANW	= 725,
    EVMHOSSIAAW	= 726,
    EVMHOSSIANW	= 727,
    EVMHOUMI	= 728,
    EVMHOUMIA	= 729,
    EVMHOUMIAAW	= 730,
    EVMHOUMIANW	= 731,
    EVMHOUSIAAW	= 732,
    EVMHOUSIANW	= 733,
    EVMRA	= 734,
    EVMWHSMF	= 735,
    EVMWHSMFA	= 736,
    EVMWHSMI	= 737,
    EVMWHSMIA	= 738,
    EVMWHSSF	= 739,
    EVMWHSSFA	= 740,
    EVMWHUMI	= 741,
    EVMWHUMIA	= 742,
    EVMWLSMIAAW	= 743,
    EVMWLSMIANW	= 744,
    EVMWLSSIAAW	= 745,
    EVMWLSSIANW	= 746,
    EVMWLUMI	= 747,
    EVMWLUMIA	= 748,
    EVMWLUMIAAW	= 749,
    EVMWLUMIANW	= 750,
    EVMWLUSIAAW	= 751,
    EVMWLUSIANW	= 752,
    EVMWSMF	= 753,
    EVMWSMFA	= 754,
    EVMWSMFAA	= 755,
    EVMWSMFAN	= 756,
    EVMWSMI	= 757,
    EVMWSMIA	= 758,
    EVMWSMIAA	= 759,
    EVMWSMIAN	= 760,
    EVMWSSF	= 761,
    EVMWSSFA	= 762,
    EVMWSSFAA	= 763,
    EVMWSSFAN	= 764,
    EVMWUMI	= 765,
    EVMWUMIA	= 766,
    EVMWUMIAA	= 767,
    EVMWUMIAN	= 768,
    EVNAND	= 769,
    EVNEG	= 770,
    EVNOR	= 771,
    EVOR	= 772,
    EVORC	= 773,
    EVRLW	= 774,
    EVRLWI	= 775,
    EVRNDW	= 776,
    EVSEL	= 777,
    EVSLW	= 778,
    EVSLWI	= 779,
    EVSPLATFI	= 780,
    EVSPLATI	= 781,
    EVSRWIS	= 782,
    EVSRWIU	= 783,
    EVSRWS	= 784,
    EVSRWU	= 785,
    EVSTDD	= 786,
    EVSTDDX	= 787,
    EVSTDH	= 788,
    EVSTDHX	= 789,
    EVSTDW	= 790,
    EVSTDWX	= 791,
    EVSTWHE	= 792,
    EVSTWHEX	= 793,
    EVSTWHO	= 794,
    EVSTWHOX	= 795,
    EVSTWWE	= 796,
    EVSTWWEX	= 797,
    EVSTWWO	= 798,
    EVSTWWOX	= 799,
    EVSUBFSMIAAW	= 800,
    EVSUBFSSIAAW	= 801,
    EVSUBFUMIAAW	= 802,
    EVSUBFUSIAAW	= 803,
    EVSUBFW	= 804,
    EVSUBIFW	= 805,
    EVXOR	= 806,
    EXTSB	= 807,
    EXTSB8	= 808,
    EXTSB8_32_64	= 809,
    EXTSB8o	= 810,
    EXTSBo	= 811,
    EXTSH	= 812,
    EXTSH8	= 813,
    EXTSH8_32_64	= 814,
    EXTSH8o	= 815,
    EXTSHo	= 816,
    EXTSW	= 817,
    EXTSWSLI	= 818,
    EXTSWSLI_32_64	= 819,
    EXTSWSLI_32_64o	= 820,
    EXTSWSLIo	= 821,
    EXTSW_32	= 822,
    EXTSW_32_64	= 823,
    EXTSW_32_64o	= 824,
    EXTSWo	= 825,
    EnforceIEIO	= 826,
    FABSD	= 827,
    FABSDo	= 828,
    FABSS	= 829,
    FABSSo	= 830,
    FADD	= 831,
    FADDS	= 832,
    FADDSo	= 833,
    FADDo	= 834,
    FADDrtz	= 835,
    FCFID	= 836,
    FCFIDS	= 837,
    FCFIDSo	= 838,
    FCFIDU	= 839,
    FCFIDUS	= 840,
    FCFIDUSo	= 841,
    FCFIDUo	= 842,
    FCFIDo	= 843,
    FCMPUD	= 844,
    FCMPUS	= 845,
    FCPSGND	= 846,
    FCPSGNDo	= 847,
    FCPSGNS	= 848,
    FCPSGNSo	= 849,
    FCTID	= 850,
    FCTIDU	= 851,
    FCTIDUZ	= 852,
    FCTIDUZo	= 853,
    FCTIDUo	= 854,
    FCTIDZ	= 855,
    FCTIDZo	= 856,
    FCTIDo	= 857,
    FCTIW	= 858,
    FCTIWU	= 859,
    FCTIWUZ	= 860,
    FCTIWUZo	= 861,
    FCTIWUo	= 862,
    FCTIWZ	= 863,
    FCTIWZo	= 864,
    FCTIWo	= 865,
    FDIV	= 866,
    FDIVS	= 867,
    FDIVSo	= 868,
    FDIVo	= 869,
    FMADD	= 870,
    FMADDS	= 871,
    FMADDSo	= 872,
    FMADDo	= 873,
    FMR	= 874,
    FMRo	= 875,
    FMSUB	= 876,
    FMSUBS	= 877,
    FMSUBSo	= 878,
    FMSUBo	= 879,
    FMUL	= 880,
    FMULS	= 881,
    FMULSo	= 882,
    FMULo	= 883,
    FNABSD	= 884,
    FNABSDo	= 885,
    FNABSS	= 886,
    FNABSSo	= 887,
    FNEGD	= 888,
    FNEGDo	= 889,
    FNEGS	= 890,
    FNEGSo	= 891,
    FNMADD	= 892,
    FNMADDS	= 893,
    FNMADDSo	= 894,
    FNMADDo	= 895,
    FNMSUB	= 896,
    FNMSUBS	= 897,
    FNMSUBSo	= 898,
    FNMSUBo	= 899,
    FRE	= 900,
    FRES	= 901,
    FRESo	= 902,
    FREo	= 903,
    FRIMD	= 904,
    FRIMDo	= 905,
    FRIMS	= 906,
    FRIMSo	= 907,
    FRIND	= 908,
    FRINDo	= 909,
    FRINS	= 910,
    FRINSo	= 911,
    FRIPD	= 912,
    FRIPDo	= 913,
    FRIPS	= 914,
    FRIPSo	= 915,
    FRIZD	= 916,
    FRIZDo	= 917,
    FRIZS	= 918,
    FRIZSo	= 919,
    FRSP	= 920,
    FRSPo	= 921,
    FRSQRTE	= 922,
    FRSQRTES	= 923,
    FRSQRTESo	= 924,
    FRSQRTEo	= 925,
    FSELD	= 926,
    FSELDo	= 927,
    FSELS	= 928,
    FSELSo	= 929,
    FSQRT	= 930,
    FSQRTS	= 931,
    FSQRTSo	= 932,
    FSQRTo	= 933,
    FSUB	= 934,
    FSUBS	= 935,
    FSUBSo	= 936,
    FSUBo	= 937,
    FTDIV	= 938,
    FTSQRT	= 939,
    GETtlsADDR	= 940,
    GETtlsADDR32	= 941,
    GETtlsldADDR	= 942,
    GETtlsldADDR32	= 943,
    HRFID	= 944,
    ICBI	= 945,
    ICBIEP	= 946,
    ICBLC	= 947,
    ICBLQ	= 948,
    ICBT	= 949,
    ICBTLS	= 950,
    ICCCI	= 951,
    ISEL	= 952,
    ISEL8	= 953,
    ISYNC	= 954,
    LA	= 955,
    LBARX	= 956,
    LBARXL	= 957,
    LBEPX	= 958,
    LBZ	= 959,
    LBZ8	= 960,
    LBZCIX	= 961,
    LBZU	= 962,
    LBZU8	= 963,
    LBZUX	= 964,
    LBZUX8	= 965,
    LBZX	= 966,
    LBZX8	= 967,
    LBZXTLS	= 968,
    LBZXTLS_	= 969,
    LBZXTLS_32	= 970,
    LD	= 971,
    LDARX	= 972,
    LDARXL	= 973,
    LDAT	= 974,
    LDBRX	= 975,
    LDCIX	= 976,
    LDMX	= 977,
    LDU	= 978,
    LDUX	= 979,
    LDX	= 980,
    LDXTLS	= 981,
    LDXTLS_	= 982,
    LDgotTprelL	= 983,
    LDgotTprelL32	= 984,
    LDtoc	= 985,
    LDtocBA	= 986,
    LDtocCPT	= 987,
    LDtocJTI	= 988,
    LDtocL	= 989,
    LFD	= 990,
    LFDEPX	= 991,
    LFDU	= 992,
    LFDUX	= 993,
    LFDX	= 994,
    LFIWAX	= 995,
    LFIWZX	= 996,
    LFS	= 997,
    LFSU	= 998,
    LFSUX	= 999,
    LFSX	= 1000,
    LHA	= 1001,
    LHA8	= 1002,
    LHARX	= 1003,
    LHARXL	= 1004,
    LHAU	= 1005,
    LHAU8	= 1006,
    LHAUX	= 1007,
    LHAUX8	= 1008,
    LHAX	= 1009,
    LHAX8	= 1010,
    LHBRX	= 1011,
    LHBRX8	= 1012,
    LHEPX	= 1013,
    LHZ	= 1014,
    LHZ8	= 1015,
    LHZCIX	= 1016,
    LHZU	= 1017,
    LHZU8	= 1018,
    LHZUX	= 1019,
    LHZUX8	= 1020,
    LHZX	= 1021,
    LHZX8	= 1022,
    LHZXTLS	= 1023,
    LHZXTLS_	= 1024,
    LHZXTLS_32	= 1025,
    LI	= 1026,
    LI8	= 1027,
    LIS	= 1028,
    LIS8	= 1029,
    LMW	= 1030,
    LSWI	= 1031,
    LVEBX	= 1032,
    LVEHX	= 1033,
    LVEWX	= 1034,
    LVSL	= 1035,
    LVSR	= 1036,
    LVX	= 1037,
    LVXL	= 1038,
    LWA	= 1039,
    LWARX	= 1040,
    LWARXL	= 1041,
    LWAT	= 1042,
    LWAUX	= 1043,
    LWAX	= 1044,
    LWAX_32	= 1045,
    LWA_32	= 1046,
    LWBRX	= 1047,
    LWBRX8	= 1048,
    LWEPX	= 1049,
    LWZ	= 1050,
    LWZ8	= 1051,
    LWZCIX	= 1052,
    LWZU	= 1053,
    LWZU8	= 1054,
    LWZUX	= 1055,
    LWZUX8	= 1056,
    LWZX	= 1057,
    LWZX8	= 1058,
    LWZXTLS	= 1059,
    LWZXTLS_	= 1060,
    LWZXTLS_32	= 1061,
    LWZtoc	= 1062,
    LXSD	= 1063,
    LXSDX	= 1064,
    LXSIBZX	= 1065,
    LXSIHZX	= 1066,
    LXSIWAX	= 1067,
    LXSIWZX	= 1068,
    LXSSP	= 1069,
    LXSSPX	= 1070,
    LXV	= 1071,
    LXVB16X	= 1072,
    LXVD2X	= 1073,
    LXVDSX	= 1074,
    LXVH8X	= 1075,
    LXVL	= 1076,
    LXVLL	= 1077,
    LXVW4X	= 1078,
    LXVWSX	= 1079,
    LXVX	= 1080,
    MADDHD	= 1081,
    MADDHDU	= 1082,
    MADDLD	= 1083,
    MADDLD8	= 1084,
    MBAR	= 1085,
    MCRF	= 1086,
    MCRFS	= 1087,
    MCRXRX	= 1088,
    MFBHRBE	= 1089,
    MFCR	= 1090,
    MFCR8	= 1091,
    MFCTR	= 1092,
    MFCTR8	= 1093,
    MFDCR	= 1094,
    MFFS	= 1095,
    MFFSCDRN	= 1096,
    MFFSCDRNI	= 1097,
    MFFSCE	= 1098,
    MFFSCRN	= 1099,
    MFFSCRNI	= 1100,
    MFFSL	= 1101,
    MFFSo	= 1102,
    MFLR	= 1103,
    MFLR8	= 1104,
    MFMSR	= 1105,
    MFOCRF	= 1106,
    MFOCRF8	= 1107,
    MFPMR	= 1108,
    MFSPR	= 1109,
    MFSPR8	= 1110,
    MFSR	= 1111,
    MFSRIN	= 1112,
    MFTB	= 1113,
    MFTB8	= 1114,
    MFVRD	= 1115,
    MFVRSAVE	= 1116,
    MFVRSAVEv	= 1117,
    MFVSCR	= 1118,
    MFVSRD	= 1119,
    MFVSRLD	= 1120,
    MFVSRWZ	= 1121,
    MODSD	= 1122,
    MODSW	= 1123,
    MODUD	= 1124,
    MODUW	= 1125,
    MSGSYNC	= 1126,
    MSYNC	= 1127,
    MTCRF	= 1128,
    MTCRF8	= 1129,
    MTCTR	= 1130,
    MTCTR8	= 1131,
    MTCTR8loop	= 1132,
    MTCTRloop	= 1133,
    MTDCR	= 1134,
    MTFSB0	= 1135,
    MTFSB1	= 1136,
    MTFSF	= 1137,
    MTFSFI	= 1138,
    MTFSFIo	= 1139,
    MTFSFb	= 1140,
    MTFSFo	= 1141,
    MTLR	= 1142,
    MTLR8	= 1143,
    MTMSR	= 1144,
    MTMSRD	= 1145,
    MTOCRF	= 1146,
    MTOCRF8	= 1147,
    MTPMR	= 1148,
    MTSPR	= 1149,
    MTSPR8	= 1150,
    MTSR	= 1151,
    MTSRIN	= 1152,
    MTVRSAVE	= 1153,
    MTVRSAVEv	= 1154,
    MTVSCR	= 1155,
    MTVSRD	= 1156,
    MTVSRDD	= 1157,
    MTVSRWA	= 1158,
    MTVSRWS	= 1159,
    MTVSRWZ	= 1160,
    MULHD	= 1161,
    MULHDU	= 1162,
    MULHDUo	= 1163,
    MULHDo	= 1164,
    MULHW	= 1165,
    MULHWU	= 1166,
    MULHWUo	= 1167,
    MULHWo	= 1168,
    MULLD	= 1169,
    MULLDo	= 1170,
    MULLI	= 1171,
    MULLI8	= 1172,
    MULLW	= 1173,
    MULLWo	= 1174,
    MoveGOTtoLR	= 1175,
    MovePCtoLR	= 1176,
    MovePCtoLR8	= 1177,
    NAND	= 1178,
    NAND8	= 1179,
    NAND8o	= 1180,
    NANDo	= 1181,
    NAP	= 1182,
    NEG	= 1183,
    NEG8	= 1184,
    NEG8o	= 1185,
    NEGo	= 1186,
    NOP	= 1187,
    NOP_GT_PWR6	= 1188,
    NOP_GT_PWR7	= 1189,
    NOR	= 1190,
    NOR8	= 1191,
    NOR8o	= 1192,
    NORo	= 1193,
    OR	= 1194,
    OR8	= 1195,
    OR8o	= 1196,
    ORC	= 1197,
    ORC8	= 1198,
    ORC8o	= 1199,
    ORCo	= 1200,
    ORI	= 1201,
    ORI8	= 1202,
    ORIS	= 1203,
    ORIS8	= 1204,
    ORo	= 1205,
    POPCNTB	= 1206,
    POPCNTD	= 1207,
    POPCNTW	= 1208,
    PPC32GOT	= 1209,
    PPC32PICGOT	= 1210,
    QVALIGNI	= 1211,
    QVALIGNIb	= 1212,
    QVALIGNIs	= 1213,
    QVESPLATI	= 1214,
    QVESPLATIb	= 1215,
    QVESPLATIs	= 1216,
    QVFABS	= 1217,
    QVFABSs	= 1218,
    QVFADD	= 1219,
    QVFADDS	= 1220,
    QVFADDSs	= 1221,
    QVFCFID	= 1222,
    QVFCFIDS	= 1223,
    QVFCFIDU	= 1224,
    QVFCFIDUS	= 1225,
    QVFCFIDb	= 1226,
    QVFCMPEQ	= 1227,
    QVFCMPEQb	= 1228,
    QVFCMPEQbs	= 1229,
    QVFCMPGT	= 1230,
    QVFCMPGTb	= 1231,
    QVFCMPGTbs	= 1232,
    QVFCMPLT	= 1233,
    QVFCMPLTb	= 1234,
    QVFCMPLTbs	= 1235,
    QVFCPSGN	= 1236,
    QVFCPSGNs	= 1237,
    QVFCTID	= 1238,
    QVFCTIDU	= 1239,
    QVFCTIDUZ	= 1240,
    QVFCTIDZ	= 1241,
    QVFCTIDb	= 1242,
    QVFCTIW	= 1243,
    QVFCTIWU	= 1244,
    QVFCTIWUZ	= 1245,
    QVFCTIWZ	= 1246,
    QVFLOGICAL	= 1247,
    QVFLOGICALb	= 1248,
    QVFLOGICALs	= 1249,
    QVFMADD	= 1250,
    QVFMADDS	= 1251,
    QVFMADDSs	= 1252,
    QVFMR	= 1253,
    QVFMRb	= 1254,
    QVFMRs	= 1255,
    QVFMSUB	= 1256,
    QVFMSUBS	= 1257,
    QVFMSUBSs	= 1258,
    QVFMUL	= 1259,
    QVFMULS	= 1260,
    QVFMULSs	= 1261,
    QVFNABS	= 1262,
    QVFNABSs	= 1263,
    QVFNEG	= 1264,
    QVFNEGs	= 1265,
    QVFNMADD	= 1266,
    QVFNMADDS	= 1267,
    QVFNMADDSs	= 1268,
    QVFNMSUB	= 1269,
    QVFNMSUBS	= 1270,
    QVFNMSUBSs	= 1271,
    QVFPERM	= 1272,
    QVFPERMs	= 1273,
    QVFRE	= 1274,
    QVFRES	= 1275,
    QVFRESs	= 1276,
    QVFRIM	= 1277,
    QVFRIMs	= 1278,
    QVFRIN	= 1279,
    QVFRINs	= 1280,
    QVFRIP	= 1281,
    QVFRIPs	= 1282,
    QVFRIZ	= 1283,
    QVFRIZs	= 1284,
    QVFRSP	= 1285,
    QVFRSPs	= 1286,
    QVFRSQRTE	= 1287,
    QVFRSQRTES	= 1288,
    QVFRSQRTESs	= 1289,
    QVFSEL	= 1290,
    QVFSELb	= 1291,
    QVFSELbb	= 1292,
    QVFSELbs	= 1293,
    QVFSUB	= 1294,
    QVFSUBS	= 1295,
    QVFSUBSs	= 1296,
    QVFTSTNAN	= 1297,
    QVFTSTNANb	= 1298,
    QVFTSTNANbs	= 1299,
    QVFXMADD	= 1300,
    QVFXMADDS	= 1301,
    QVFXMUL	= 1302,
    QVFXMULS	= 1303,
    QVFXXCPNMADD	= 1304,
    QVFXXCPNMADDS	= 1305,
    QVFXXMADD	= 1306,
    QVFXXMADDS	= 1307,
    QVFXXNPMADD	= 1308,
    QVFXXNPMADDS	= 1309,
    QVGPCI	= 1310,
    QVLFCDUX	= 1311,
    QVLFCDUXA	= 1312,
    QVLFCDX	= 1313,
    QVLFCDXA	= 1314,
    QVLFCSUX	= 1315,
    QVLFCSUXA	= 1316,
    QVLFCSX	= 1317,
    QVLFCSXA	= 1318,
    QVLFCSXs	= 1319,
    QVLFDUX	= 1320,
    QVLFDUXA	= 1321,
    QVLFDX	= 1322,
    QVLFDXA	= 1323,
    QVLFDXb	= 1324,
    QVLFIWAX	= 1325,
    QVLFIWAXA	= 1326,
    QVLFIWZX	= 1327,
    QVLFIWZXA	= 1328,
    QVLFSUX	= 1329,
    QVLFSUXA	= 1330,
    QVLFSX	= 1331,
    QVLFSXA	= 1332,
    QVLFSXb	= 1333,
    QVLFSXs	= 1334,
    QVLPCLDX	= 1335,
    QVLPCLSX	= 1336,
    QVLPCLSXint	= 1337,
    QVLPCRDX	= 1338,
    QVLPCRSX	= 1339,
    QVSTFCDUX	= 1340,
    QVSTFCDUXA	= 1341,
    QVSTFCDUXI	= 1342,
    QVSTFCDUXIA	= 1343,
    QVSTFCDX	= 1344,
    QVSTFCDXA	= 1345,
    QVSTFCDXI	= 1346,
    QVSTFCDXIA	= 1347,
    QVSTFCSUX	= 1348,
    QVSTFCSUXA	= 1349,
    QVSTFCSUXI	= 1350,
    QVSTFCSUXIA	= 1351,
    QVSTFCSX	= 1352,
    QVSTFCSXA	= 1353,
    QVSTFCSXI	= 1354,
    QVSTFCSXIA	= 1355,
    QVSTFCSXs	= 1356,
    QVSTFDUX	= 1357,
    QVSTFDUXA	= 1358,
    QVSTFDUXI	= 1359,
    QVSTFDUXIA	= 1360,
    QVSTFDX	= 1361,
    QVSTFDXA	= 1362,
    QVSTFDXI	= 1363,
    QVSTFDXIA	= 1364,
    QVSTFDXb	= 1365,
    QVSTFIWX	= 1366,
    QVSTFIWXA	= 1367,
    QVSTFSUX	= 1368,
    QVSTFSUXA	= 1369,
    QVSTFSUXI	= 1370,
    QVSTFSUXIA	= 1371,
    QVSTFSUXs	= 1372,
    QVSTFSX	= 1373,
    QVSTFSXA	= 1374,
    QVSTFSXI	= 1375,
    QVSTFSXIA	= 1376,
    QVSTFSXs	= 1377,
    RESTORE_CR	= 1378,
    RESTORE_CRBIT	= 1379,
    RESTORE_VRSAVE	= 1380,
    RFCI	= 1381,
    RFDI	= 1382,
    RFEBB	= 1383,
    RFI	= 1384,
    RFID	= 1385,
    RFMCI	= 1386,
    RLDCL	= 1387,
    RLDCLo	= 1388,
    RLDCR	= 1389,
    RLDCRo	= 1390,
    RLDIC	= 1391,
    RLDICL	= 1392,
    RLDICL_32	= 1393,
    RLDICL_32_64	= 1394,
    RLDICL_32o	= 1395,
    RLDICLo	= 1396,
    RLDICR	= 1397,
    RLDICR_32	= 1398,
    RLDICRo	= 1399,
    RLDICo	= 1400,
    RLDIMI	= 1401,
    RLDIMIo	= 1402,
    RLWIMI	= 1403,
    RLWIMI8	= 1404,
    RLWIMI8o	= 1405,
    RLWIMIo	= 1406,
    RLWINM	= 1407,
    RLWINM8	= 1408,
    RLWINM8o	= 1409,
    RLWINMo	= 1410,
    RLWNM	= 1411,
    RLWNM8	= 1412,
    RLWNM8o	= 1413,
    RLWNMo	= 1414,
    ReadTB	= 1415,
    SC	= 1416,
    SELECT_CC_F16	= 1417,
    SELECT_CC_F4	= 1418,
    SELECT_CC_F8	= 1419,
    SELECT_CC_I4	= 1420,
    SELECT_CC_I8	= 1421,
    SELECT_CC_QBRC	= 1422,
    SELECT_CC_QFRC	= 1423,
    SELECT_CC_QSRC	= 1424,
    SELECT_CC_SPE	= 1425,
    SELECT_CC_SPE4	= 1426,
    SELECT_CC_VRRC	= 1427,
    SELECT_CC_VSFRC	= 1428,
    SELECT_CC_VSRC	= 1429,
    SELECT_CC_VSSRC	= 1430,
    SELECT_F16	= 1431,
    SELECT_F4	= 1432,
    SELECT_F8	= 1433,
    SELECT_I4	= 1434,
    SELECT_I8	= 1435,
    SELECT_QBRC	= 1436,
    SELECT_QFRC	= 1437,
    SELECT_QSRC	= 1438,
    SELECT_SPE	= 1439,
    SELECT_SPE4	= 1440,
    SELECT_VRRC	= 1441,
    SELECT_VSFRC	= 1442,
    SELECT_VSRC	= 1443,
    SELECT_VSSRC	= 1444,
    SETB	= 1445,
    SETB8	= 1446,
    SETRND	= 1447,
    SETRNDi	= 1448,
    SLBFEEo	= 1449,
    SLBIA	= 1450,
    SLBIE	= 1451,
    SLBIEG	= 1452,
    SLBMFEE	= 1453,
    SLBMFEV	= 1454,
    SLBMTE	= 1455,
    SLBSYNC	= 1456,
    SLD	= 1457,
    SLDo	= 1458,
    SLW	= 1459,
    SLW8	= 1460,
    SLW8o	= 1461,
    SLWo	= 1462,
    SPELWZ	= 1463,
    SPELWZX	= 1464,
    SPESTW	= 1465,
    SPESTWX	= 1466,
    SPILL_CR	= 1467,
    SPILL_CRBIT	= 1468,
    SPILL_VRSAVE	= 1469,
    SRAD	= 1470,
    SRADI	= 1471,
    SRADI_32	= 1472,
    SRADIo	= 1473,
    SRADo	= 1474,
    SRAW	= 1475,
    SRAWI	= 1476,
    SRAWIo	= 1477,
    SRAWo	= 1478,
    SRD	= 1479,
    SRDo	= 1480,
    SRW	= 1481,
    SRW8	= 1482,
    SRW8o	= 1483,
    SRWo	= 1484,
    STB	= 1485,
    STB8	= 1486,
    STBCIX	= 1487,
    STBCX	= 1488,
    STBEPX	= 1489,
    STBU	= 1490,
    STBU8	= 1491,
    STBUX	= 1492,
    STBUX8	= 1493,
    STBX	= 1494,
    STBX8	= 1495,
    STBXTLS	= 1496,
    STBXTLS_	= 1497,
    STBXTLS_32	= 1498,
    STD	= 1499,
    STDAT	= 1500,
    STDBRX	= 1501,
    STDCIX	= 1502,
    STDCX	= 1503,
    STDU	= 1504,
    STDUX	= 1505,
    STDX	= 1506,
    STDXTLS	= 1507,
    STDXTLS_	= 1508,
    STFD	= 1509,
    STFDEPX	= 1510,
    STFDU	= 1511,
    STFDUX	= 1512,
    STFDX	= 1513,
    STFIWX	= 1514,
    STFS	= 1515,
    STFSU	= 1516,
    STFSUX	= 1517,
    STFSX	= 1518,
    STH	= 1519,
    STH8	= 1520,
    STHBRX	= 1521,
    STHCIX	= 1522,
    STHCX	= 1523,
    STHEPX	= 1524,
    STHU	= 1525,
    STHU8	= 1526,
    STHUX	= 1527,
    STHUX8	= 1528,
    STHX	= 1529,
    STHX8	= 1530,
    STHXTLS	= 1531,
    STHXTLS_	= 1532,
    STHXTLS_32	= 1533,
    STMW	= 1534,
    STOP	= 1535,
    STSWI	= 1536,
    STVEBX	= 1537,
    STVEHX	= 1538,
    STVEWX	= 1539,
    STVX	= 1540,
    STVXL	= 1541,
    STW	= 1542,
    STW8	= 1543,
    STWAT	= 1544,
    STWBRX	= 1545,
    STWCIX	= 1546,
    STWCX	= 1547,
    STWEPX	= 1548,
    STWU	= 1549,
    STWU8	= 1550,
    STWUX	= 1551,
    STWUX8	= 1552,
    STWX	= 1553,
    STWX8	= 1554,
    STWXTLS	= 1555,
    STWXTLS_	= 1556,
    STWXTLS_32	= 1557,
    STXSD	= 1558,
    STXSDX	= 1559,
    STXSIBX	= 1560,
    STXSIBXv	= 1561,
    STXSIHX	= 1562,
    STXSIHXv	= 1563,
    STXSIWX	= 1564,
    STXSSP	= 1565,
    STXSSPX	= 1566,
    STXV	= 1567,
    STXVB16X	= 1568,
    STXVD2X	= 1569,
    STXVH8X	= 1570,
    STXVL	= 1571,
    STXVLL	= 1572,
    STXVW4X	= 1573,
    STXVX	= 1574,
    SUBF	= 1575,
    SUBF8	= 1576,
    SUBF8o	= 1577,
    SUBFC	= 1578,
    SUBFC8	= 1579,
    SUBFC8o	= 1580,
    SUBFCo	= 1581,
    SUBFE	= 1582,
    SUBFE8	= 1583,
    SUBFE8o	= 1584,
    SUBFEo	= 1585,
    SUBFIC	= 1586,
    SUBFIC8	= 1587,
    SUBFME	= 1588,
    SUBFME8	= 1589,
    SUBFME8o	= 1590,
    SUBFMEo	= 1591,
    SUBFZE	= 1592,
    SUBFZE8	= 1593,
    SUBFZE8o	= 1594,
    SUBFZEo	= 1595,
    SUBFo	= 1596,
    SYNC	= 1597,
    TABORT	= 1598,
    TABORTDC	= 1599,
    TABORTDCI	= 1600,
    TABORTWC	= 1601,
    TABORTWCI	= 1602,
    TAILB	= 1603,
    TAILB8	= 1604,
    TAILBA	= 1605,
    TAILBA8	= 1606,
    TAILBCTR	= 1607,
    TAILBCTR8	= 1608,
    TBEGIN	= 1609,
    TBEGIN_RET	= 1610,
    TCHECK	= 1611,
    TCHECK_RET	= 1612,
    TCRETURNai	= 1613,
    TCRETURNai8	= 1614,
    TCRETURNdi	= 1615,
    TCRETURNdi8	= 1616,
    TCRETURNri	= 1617,
    TCRETURNri8	= 1618,
    TD	= 1619,
    TDI	= 1620,
    TEND	= 1621,
    TLBIA	= 1622,
    TLBIE	= 1623,
    TLBIEL	= 1624,
    TLBIVAX	= 1625,
    TLBLD	= 1626,
    TLBLI	= 1627,
    TLBRE	= 1628,
    TLBRE2	= 1629,
    TLBSX	= 1630,
    TLBSX2	= 1631,
    TLBSX2D	= 1632,
    TLBSYNC	= 1633,
    TLBWE	= 1634,
    TLBWE2	= 1635,
    TRAP	= 1636,
    TRECHKPT	= 1637,
    TRECLAIM	= 1638,
    TSR	= 1639,
    TW	= 1640,
    TWI	= 1641,
    UPDATE_VRSAVE	= 1642,
    UpdateGBR	= 1643,
    VABSDUB	= 1644,
    VABSDUH	= 1645,
    VABSDUW	= 1646,
    VADDCUQ	= 1647,
    VADDCUW	= 1648,
    VADDECUQ	= 1649,
    VADDEUQM	= 1650,
    VADDFP	= 1651,
    VADDSBS	= 1652,
    VADDSHS	= 1653,
    VADDSWS	= 1654,
    VADDUBM	= 1655,
    VADDUBS	= 1656,
    VADDUDM	= 1657,
    VADDUHM	= 1658,
    VADDUHS	= 1659,
    VADDUQM	= 1660,
    VADDUWM	= 1661,
    VADDUWS	= 1662,
    VAND	= 1663,
    VANDC	= 1664,
    VAVGSB	= 1665,
    VAVGSH	= 1666,
    VAVGSW	= 1667,
    VAVGUB	= 1668,
    VAVGUH	= 1669,
    VAVGUW	= 1670,
    VBPERMD	= 1671,
    VBPERMQ	= 1672,
    VCFSX	= 1673,
    VCFSX_0	= 1674,
    VCFUX	= 1675,
    VCFUX_0	= 1676,
    VCIPHER	= 1677,
    VCIPHERLAST	= 1678,
    VCLZB	= 1679,
    VCLZD	= 1680,
    VCLZH	= 1681,
    VCLZLSBB	= 1682,
    VCLZW	= 1683,
    VCMPBFP	= 1684,
    VCMPBFPo	= 1685,
    VCMPEQFP	= 1686,
    VCMPEQFPo	= 1687,
    VCMPEQUB	= 1688,
    VCMPEQUBo	= 1689,
    VCMPEQUD	= 1690,
    VCMPEQUDo	= 1691,
    VCMPEQUH	= 1692,
    VCMPEQUHo	= 1693,
    VCMPEQUW	= 1694,
    VCMPEQUWo	= 1695,
    VCMPGEFP	= 1696,
    VCMPGEFPo	= 1697,
    VCMPGTFP	= 1698,
    VCMPGTFPo	= 1699,
    VCMPGTSB	= 1700,
    VCMPGTSBo	= 1701,
    VCMPGTSD	= 1702,
    VCMPGTSDo	= 1703,
    VCMPGTSH	= 1704,
    VCMPGTSHo	= 1705,
    VCMPGTSW	= 1706,
    VCMPGTSWo	= 1707,
    VCMPGTUB	= 1708,
    VCMPGTUBo	= 1709,
    VCMPGTUD	= 1710,
    VCMPGTUDo	= 1711,
    VCMPGTUH	= 1712,
    VCMPGTUHo	= 1713,
    VCMPGTUW	= 1714,
    VCMPGTUWo	= 1715,
    VCMPNEB	= 1716,
    VCMPNEBo	= 1717,
    VCMPNEH	= 1718,
    VCMPNEHo	= 1719,
    VCMPNEW	= 1720,
    VCMPNEWo	= 1721,
    VCMPNEZB	= 1722,
    VCMPNEZBo	= 1723,
    VCMPNEZH	= 1724,
    VCMPNEZHo	= 1725,
    VCMPNEZW	= 1726,
    VCMPNEZWo	= 1727,
    VCTSXS	= 1728,
    VCTSXS_0	= 1729,
    VCTUXS	= 1730,
    VCTUXS_0	= 1731,
    VCTZB	= 1732,
    VCTZD	= 1733,
    VCTZH	= 1734,
    VCTZLSBB	= 1735,
    VCTZW	= 1736,
    VEQV	= 1737,
    VEXPTEFP	= 1738,
    VEXTRACTD	= 1739,
    VEXTRACTUB	= 1740,
    VEXTRACTUH	= 1741,
    VEXTRACTUW	= 1742,
    VEXTSB2D	= 1743,
    VEXTSB2Ds	= 1744,
    VEXTSB2W	= 1745,
    VEXTSB2Ws	= 1746,
    VEXTSH2D	= 1747,
    VEXTSH2Ds	= 1748,
    VEXTSH2W	= 1749,
    VEXTSH2Ws	= 1750,
    VEXTSW2D	= 1751,
    VEXTSW2Ds	= 1752,
    VEXTUBLX	= 1753,
    VEXTUBRX	= 1754,
    VEXTUHLX	= 1755,
    VEXTUHRX	= 1756,
    VEXTUWLX	= 1757,
    VEXTUWRX	= 1758,
    VGBBD	= 1759,
    VINSERTB	= 1760,
    VINSERTD	= 1761,
    VINSERTH	= 1762,
    VINSERTW	= 1763,
    VLOGEFP	= 1764,
    VMADDFP	= 1765,
    VMAXFP	= 1766,
    VMAXSB	= 1767,
    VMAXSD	= 1768,
    VMAXSH	= 1769,
    VMAXSW	= 1770,
    VMAXUB	= 1771,
    VMAXUD	= 1772,
    VMAXUH	= 1773,
    VMAXUW	= 1774,
    VMHADDSHS	= 1775,
    VMHRADDSHS	= 1776,
    VMINFP	= 1777,
    VMINSB	= 1778,
    VMINSD	= 1779,
    VMINSH	= 1780,
    VMINSW	= 1781,
    VMINUB	= 1782,
    VMINUD	= 1783,
    VMINUH	= 1784,
    VMINUW	= 1785,
    VMLADDUHM	= 1786,
    VMRGEW	= 1787,
    VMRGHB	= 1788,
    VMRGHH	= 1789,
    VMRGHW	= 1790,
    VMRGLB	= 1791,
    VMRGLH	= 1792,
    VMRGLW	= 1793,
    VMRGOW	= 1794,
    VMSUMMBM	= 1795,
    VMSUMSHM	= 1796,
    VMSUMSHS	= 1797,
    VMSUMUBM	= 1798,
    VMSUMUHM	= 1799,
    VMSUMUHS	= 1800,
    VMUL10CUQ	= 1801,
    VMUL10ECUQ	= 1802,
    VMUL10EUQ	= 1803,
    VMUL10UQ	= 1804,
    VMULESB	= 1805,
    VMULESH	= 1806,
    VMULESW	= 1807,
    VMULEUB	= 1808,
    VMULEUH	= 1809,
    VMULEUW	= 1810,
    VMULOSB	= 1811,
    VMULOSH	= 1812,
    VMULOSW	= 1813,
    VMULOUB	= 1814,
    VMULOUH	= 1815,
    VMULOUW	= 1816,
    VMULUWM	= 1817,
    VNAND	= 1818,
    VNCIPHER	= 1819,
    VNCIPHERLAST	= 1820,
    VNEGD	= 1821,
    VNEGW	= 1822,
    VNMSUBFP	= 1823,
    VNOR	= 1824,
    VOR	= 1825,
    VORC	= 1826,
    VPERM	= 1827,
    VPERMR	= 1828,
    VPERMXOR	= 1829,
    VPKPX	= 1830,
    VPKSDSS	= 1831,
    VPKSDUS	= 1832,
    VPKSHSS	= 1833,
    VPKSHUS	= 1834,
    VPKSWSS	= 1835,
    VPKSWUS	= 1836,
    VPKUDUM	= 1837,
    VPKUDUS	= 1838,
    VPKUHUM	= 1839,
    VPKUHUS	= 1840,
    VPKUWUM	= 1841,
    VPKUWUS	= 1842,
    VPMSUMB	= 1843,
    VPMSUMD	= 1844,
    VPMSUMH	= 1845,
    VPMSUMW	= 1846,
    VPOPCNTB	= 1847,
    VPOPCNTD	= 1848,
    VPOPCNTH	= 1849,
    VPOPCNTW	= 1850,
    VPRTYBD	= 1851,
    VPRTYBQ	= 1852,
    VPRTYBW	= 1853,
    VREFP	= 1854,
    VRFIM	= 1855,
    VRFIN	= 1856,
    VRFIP	= 1857,
    VRFIZ	= 1858,
    VRLB	= 1859,
    VRLD	= 1860,
    VRLDMI	= 1861,
    VRLDNM	= 1862,
    VRLH	= 1863,
    VRLW	= 1864,
    VRLWMI	= 1865,
    VRLWNM	= 1866,
    VRSQRTEFP	= 1867,
    VSBOX	= 1868,
    VSEL	= 1869,
    VSHASIGMAD	= 1870,
    VSHASIGMAW	= 1871,
    VSL	= 1872,
    VSLB	= 1873,
    VSLD	= 1874,
    VSLDOI	= 1875,
    VSLH	= 1876,
    VSLO	= 1877,
    VSLV	= 1878,
    VSLW	= 1879,
    VSPLTB	= 1880,
    VSPLTBs	= 1881,
    VSPLTH	= 1882,
    VSPLTHs	= 1883,
    VSPLTISB	= 1884,
    VSPLTISH	= 1885,
    VSPLTISW	= 1886,
    VSPLTW	= 1887,
    VSR	= 1888,
    VSRAB	= 1889,
    VSRAD	= 1890,
    VSRAH	= 1891,
    VSRAW	= 1892,
    VSRB	= 1893,
    VSRD	= 1894,
    VSRH	= 1895,
    VSRO	= 1896,
    VSRV	= 1897,
    VSRW	= 1898,
    VSUBCUQ	= 1899,
    VSUBCUW	= 1900,
    VSUBECUQ	= 1901,
    VSUBEUQM	= 1902,
    VSUBFP	= 1903,
    VSUBSBS	= 1904,
    VSUBSHS	= 1905,
    VSUBSWS	= 1906,
    VSUBUBM	= 1907,
    VSUBUBS	= 1908,
    VSUBUDM	= 1909,
    VSUBUHM	= 1910,
    VSUBUHS	= 1911,
    VSUBUQM	= 1912,
    VSUBUWM	= 1913,
    VSUBUWS	= 1914,
    VSUM2SWS	= 1915,
    VSUM4SBS	= 1916,
    VSUM4SHS	= 1917,
    VSUM4UBS	= 1918,
    VSUMSWS	= 1919,
    VUPKHPX	= 1920,
    VUPKHSB	= 1921,
    VUPKHSH	= 1922,
    VUPKHSW	= 1923,
    VUPKLPX	= 1924,
    VUPKLSB	= 1925,
    VUPKLSH	= 1926,
    VUPKLSW	= 1927,
    VXOR	= 1928,
    V_SET0	= 1929,
    V_SET0B	= 1930,
    V_SET0H	= 1931,
    V_SETALLONES	= 1932,
    V_SETALLONESB	= 1933,
    V_SETALLONESH	= 1934,
    WAIT	= 1935,
    WRTEE	= 1936,
    WRTEEI	= 1937,
    XOR	= 1938,
    XOR8	= 1939,
    XOR8o	= 1940,
    XORI	= 1941,
    XORI8	= 1942,
    XORIS	= 1943,
    XORIS8	= 1944,
    XORo	= 1945,
    XSABSDP	= 1946,
    XSABSQP	= 1947,
    XSADDDP	= 1948,
    XSADDQP	= 1949,
    XSADDQPO	= 1950,
    XSADDSP	= 1951,
    XSCMPEQDP	= 1952,
    XSCMPEXPDP	= 1953,
    XSCMPEXPQP	= 1954,
    XSCMPGEDP	= 1955,
    XSCMPGTDP	= 1956,
    XSCMPODP	= 1957,
    XSCMPOQP	= 1958,
    XSCMPUDP	= 1959,
    XSCMPUQP	= 1960,
    XSCPSGNDP	= 1961,
    XSCPSGNQP	= 1962,
    XSCVDPHP	= 1963,
    XSCVDPQP	= 1964,
    XSCVDPSP	= 1965,
    XSCVDPSPN	= 1966,
    XSCVDPSXDS	= 1967,
    XSCVDPSXDSs	= 1968,
    XSCVDPSXWS	= 1969,
    XSCVDPSXWSs	= 1970,
    XSCVDPUXDS	= 1971,
    XSCVDPUXDSs	= 1972,
    XSCVDPUXWS	= 1973,
    XSCVDPUXWSs	= 1974,
    XSCVHPDP	= 1975,
    XSCVQPDP	= 1976,
    XSCVQPDPO	= 1977,
    XSCVQPSDZ	= 1978,
    XSCVQPSWZ	= 1979,
    XSCVQPUDZ	= 1980,
    XSCVQPUWZ	= 1981,
    XSCVSDQP	= 1982,
    XSCVSPDP	= 1983,
    XSCVSPDPN	= 1984,
    XSCVSXDDP	= 1985,
    XSCVSXDSP	= 1986,
    XSCVUDQP	= 1987,
    XSCVUXDDP	= 1988,
    XSCVUXDSP	= 1989,
    XSDIVDP	= 1990,
    XSDIVQP	= 1991,
    XSDIVQPO	= 1992,
    XSDIVSP	= 1993,
    XSIEXPDP	= 1994,
    XSIEXPQP	= 1995,
    XSMADDADP	= 1996,
    XSMADDASP	= 1997,
    XSMADDMDP	= 1998,
    XSMADDMSP	= 1999,
    XSMADDQP	= 2000,
    XSMADDQPO	= 2001,
    XSMAXCDP	= 2002,
    XSMAXDP	= 2003,
    XSMAXJDP	= 2004,
    XSMINCDP	= 2005,
    XSMINDP	= 2006,
    XSMINJDP	= 2007,
    XSMSUBADP	= 2008,
    XSMSUBASP	= 2009,
    XSMSUBMDP	= 2010,
    XSMSUBMSP	= 2011,
    XSMSUBQP	= 2012,
    XSMSUBQPO	= 2013,
    XSMULDP	= 2014,
    XSMULQP	= 2015,
    XSMULQPO	= 2016,
    XSMULSP	= 2017,
    XSNABSDP	= 2018,
    XSNABSQP	= 2019,
    XSNEGDP	= 2020,
    XSNEGQP	= 2021,
    XSNMADDADP	= 2022,
    XSNMADDASP	= 2023,
    XSNMADDMDP	= 2024,
    XSNMADDMSP	= 2025,
    XSNMADDQP	= 2026,
    XSNMADDQPO	= 2027,
    XSNMSUBADP	= 2028,
    XSNMSUBASP	= 2029,
    XSNMSUBMDP	= 2030,
    XSNMSUBMSP	= 2031,
    XSNMSUBQP	= 2032,
    XSNMSUBQPO	= 2033,
    XSRDPI	= 2034,
    XSRDPIC	= 2035,
    XSRDPIM	= 2036,
    XSRDPIP	= 2037,
    XSRDPIZ	= 2038,
    XSREDP	= 2039,
    XSRESP	= 2040,
    XSRQPI	= 2041,
    XSRQPIX	= 2042,
    XSRQPXP	= 2043,
    XSRSP	= 2044,
    XSRSQRTEDP	= 2045,
    XSRSQRTESP	= 2046,
    XSSQRTDP	= 2047,
    XSSQRTQP	= 2048,
    XSSQRTQPO	= 2049,
    XSSQRTSP	= 2050,
    XSSUBDP	= 2051,
    XSSUBQP	= 2052,
    XSSUBQPO	= 2053,
    XSSUBSP	= 2054,
    XSTDIVDP	= 2055,
    XSTSQRTDP	= 2056,
    XSTSTDCDP	= 2057,
    XSTSTDCQP	= 2058,
    XSTSTDCSP	= 2059,
    XSXEXPDP	= 2060,
    XSXEXPQP	= 2061,
    XSXSIGDP	= 2062,
    XSXSIGQP	= 2063,
    XVABSDP	= 2064,
    XVABSSP	= 2065,
    XVADDDP	= 2066,
    XVADDSP	= 2067,
    XVCMPEQDP	= 2068,
    XVCMPEQDPo	= 2069,
    XVCMPEQSP	= 2070,
    XVCMPEQSPo	= 2071,
    XVCMPGEDP	= 2072,
    XVCMPGEDPo	= 2073,
    XVCMPGESP	= 2074,
    XVCMPGESPo	= 2075,
    XVCMPGTDP	= 2076,
    XVCMPGTDPo	= 2077,
    XVCMPGTSP	= 2078,
    XVCMPGTSPo	= 2079,
    XVCPSGNDP	= 2080,
    XVCPSGNSP	= 2081,
    XVCVDPSP	= 2082,
    XVCVDPSXDS	= 2083,
    XVCVDPSXWS	= 2084,
    XVCVDPUXDS	= 2085,
    XVCVDPUXWS	= 2086,
    XVCVHPSP	= 2087,
    XVCVSPDP	= 2088,
    XVCVSPHP	= 2089,
    XVCVSPSXDS	= 2090,
    XVCVSPSXWS	= 2091,
    XVCVSPUXDS	= 2092,
    XVCVSPUXWS	= 2093,
    XVCVSXDDP	= 2094,
    XVCVSXDSP	= 2095,
    XVCVSXWDP	= 2096,
    XVCVSXWSP	= 2097,
    XVCVUXDDP	= 2098,
    XVCVUXDSP	= 2099,
    XVCVUXWDP	= 2100,
    XVCVUXWSP	= 2101,
    XVDIVDP	= 2102,
    XVDIVSP	= 2103,
    XVIEXPDP	= 2104,
    XVIEXPSP	= 2105,
    XVMADDADP	= 2106,
    XVMADDASP	= 2107,
    XVMADDMDP	= 2108,
    XVMADDMSP	= 2109,
    XVMAXDP	= 2110,
    XVMAXSP	= 2111,
    XVMINDP	= 2112,
    XVMINSP	= 2113,
    XVMSUBADP	= 2114,
    XVMSUBASP	= 2115,
    XVMSUBMDP	= 2116,
    XVMSUBMSP	= 2117,
    XVMULDP	= 2118,
    XVMULSP	= 2119,
    XVNABSDP	= 2120,
    XVNABSSP	= 2121,
    XVNEGDP	= 2122,
    XVNEGSP	= 2123,
    XVNMADDADP	= 2124,
    XVNMADDASP	= 2125,
    XVNMADDMDP	= 2126,
    XVNMADDMSP	= 2127,
    XVNMSUBADP	= 2128,
    XVNMSUBASP	= 2129,
    XVNMSUBMDP	= 2130,
    XVNMSUBMSP	= 2131,
    XVRDPI	= 2132,
    XVRDPIC	= 2133,
    XVRDPIM	= 2134,
    XVRDPIP	= 2135,
    XVRDPIZ	= 2136,
    XVREDP	= 2137,
    XVRESP	= 2138,
    XVRSPI	= 2139,
    XVRSPIC	= 2140,
    XVRSPIM	= 2141,
    XVRSPIP	= 2142,
    XVRSPIZ	= 2143,
    XVRSQRTEDP	= 2144,
    XVRSQRTESP	= 2145,
    XVSQRTDP	= 2146,
    XVSQRTSP	= 2147,
    XVSUBDP	= 2148,
    XVSUBSP	= 2149,
    XVTDIVDP	= 2150,
    XVTDIVSP	= 2151,
    XVTSQRTDP	= 2152,
    XVTSQRTSP	= 2153,
    XVTSTDCDP	= 2154,
    XVTSTDCSP	= 2155,
    XVXEXPDP	= 2156,
    XVXEXPSP	= 2157,
    XVXSIGDP	= 2158,
    XVXSIGSP	= 2159,
    XXBRD	= 2160,
    XXBRH	= 2161,
    XXBRQ	= 2162,
    XXBRW	= 2163,
    XXEXTRACTUW	= 2164,
    XXINSERTW	= 2165,
    XXLAND	= 2166,
    XXLANDC	= 2167,
    XXLEQV	= 2168,
    XXLNAND	= 2169,
    XXLNOR	= 2170,
    XXLOR	= 2171,
    XXLORC	= 2172,
    XXLORf	= 2173,
    XXLXOR	= 2174,
    XXLXORdpz	= 2175,
    XXLXORspz	= 2176,
    XXLXORz	= 2177,
    XXMRGHW	= 2178,
    XXMRGLW	= 2179,
    XXPERM	= 2180,
    XXPERMDI	= 2181,
    XXPERMDIs	= 2182,
    XXPERMR	= 2183,
    XXSEL	= 2184,
    XXSLDWI	= 2185,
    XXSLDWIs	= 2186,
    XXSPLTIB	= 2187,
    XXSPLTW	= 2188,
    XXSPLTWs	= 2189,
    gBC	= 2190,
    gBCA	= 2191,
    gBCAat	= 2192,
    gBCCTR	= 2193,
    gBCCTRL	= 2194,
    gBCL	= 2195,
    gBCLA	= 2196,
    gBCLAat	= 2197,
    gBCLR	= 2198,
    gBCLRL	= 2199,
    gBCLat	= 2200,
    gBCat	= 2201,
    INSTRUCTION_LIST_END = 2202
  };

} // end PPC namespace
} // end llvm namespace
#endif // GET_INSTRINFO_ENUM

#ifdef GET_INSTRINFO_SCHED_ENUM
#undef GET_INSTRINFO_SCHED_ENUM
namespace llvm {

namespace PPC {
namespace Sched {
  enum {
    NoInstrModel	= 0,
    IIC_LdStSync	= 1,
    IIC_IntSimple	= 2,
    IIC_IntGeneral	= 3,
    IIC_BrB	= 4,
    IIC_VecFP	= 5,
    IIC_IntCompare	= 6,
    IIC_SprABORT	= 7,
    IIC_LdStCOPY	= 8,
    IIC_LdStPASTE	= 9,
    IIC_BrCR	= 10,
    IIC_LdStLD	= 11,
    IIC_LdStDCBF	= 12,
    IIC_LdStLoad	= 13,
    IIC_IntDivD	= 14,
    IIC_IntDivW	= 15,
    IIC_FPDGeneral	= 16,
    IIC_FPAddSub	= 17,
    IIC_FPDivD	= 18,
    IIC_FPSGeneral	= 19,
    IIC_FPCompare	= 20,
    IIC_FPGeneral	= 21,
    IIC_VecGeneral	= 22,
    IIC_VecComplex	= 23,
    IIC_LdStStore	= 24,
    IIC_IntRotateDI	= 25,
    IIC_FPDivS	= 26,
    IIC_FPFused	= 27,
    IIC_FPSqrtD	= 28,
    IIC_FPSqrtS	= 29,
    IIC_LdStICBI	= 30,
    IIC_IntISEL	= 31,
    IIC_SprISYNC	= 32,
    IIC_LdStLWARX	= 33,
    IIC_LdStLoadUpd	= 34,
    IIC_LdStLoadUpdX	= 35,
    IIC_LdStLDARX	= 36,
    IIC_LdStLDU	= 37,
    IIC_LdStLDUX	= 38,
    IIC_LdStLFD	= 39,
    IIC_LdStLFDU	= 40,
    IIC_LdStLFDUX	= 41,
    IIC_LdStLHA	= 42,
    IIC_LdStLHAU	= 43,
    IIC_LdStLHAUX	= 44,
    IIC_LdStLMW	= 45,
    IIC_LdStLWA	= 46,
    IIC_IntMulHD	= 47,
    IIC_BrMCR	= 48,
    IIC_BrMCRX	= 49,
    IIC_SprMFCR	= 50,
    IIC_SprMFSPR	= 51,
    IIC_IntMFFS	= 52,
    IIC_SprMFMSR	= 53,
    IIC_SprMFCRF	= 54,
    IIC_SprMFPMR	= 55,
    IIC_SprMFSR	= 56,
    IIC_SprMFTB	= 57,
    IIC_SprMSGSYNC	= 58,
    IIC_SprMTSPR	= 59,
    IIC_IntMTFSB0	= 60,
    IIC_SprMTMSR	= 61,
    IIC_SprMTMSRD	= 62,
    IIC_SprMTPMR	= 63,
    IIC_SprMTSR	= 64,
    IIC_IntMulHW	= 65,
    IIC_IntMulHWU	= 66,
    IIC_IntMulLI	= 67,
    IIC_VecPerm	= 68,
    IIC_LdStSTFD	= 69,
    IIC_LdStSTFDU	= 70,
    IIC_SprRFI	= 71,
    IIC_IntRFID	= 72,
    IIC_IntRotateD	= 73,
    IIC_IntRotate	= 74,
    IIC_SprSLBFEE	= 75,
    IIC_SprSLBIA	= 76,
    IIC_SprSLBIE	= 77,
    IIC_SprSLBIEG	= 78,
    IIC_SprSLBMFEE	= 79,
    IIC_SprSLBMFEV	= 80,
    IIC_SprSLBMTE	= 81,
    IIC_SprSLBSYNC	= 82,
    IIC_IntShift	= 83,
    IIC_LdStSTWCX	= 84,
    IIC_LdStSTU	= 85,
    IIC_LdStSTUX	= 86,
    IIC_LdStSTD	= 87,
    IIC_LdStSTDCX	= 88,
    IIC_SprSTOP	= 89,
    IIC_IntTrapD	= 90,
    IIC_SprTLBIA	= 91,
    IIC_SprTLBIE	= 92,
    IIC_SprTLBIEL	= 93,
    IIC_SprTLBSYNC	= 94,
    IIC_IntTrapW	= 95,
    IIC_VecFPCompare	= 96,
    VADDUBM_VADDUDM_VADDUHM_VADDUWM_VEXTSB2D_VEXTSB2Ds_VEXTSB2W_VEXTSB2Ws_VEXTSH2D_VEXTSH2Ds_VEXTSH2W_VEXTSH2Ws_VEXTSW2D_VEXTSW2Ds_VSLD_VSRD_VSUBUBM_VSUBUDM_VSUBUHM_VSUBUWM_VPOPCNTB_VPOPCNTH_VSRAD_MTVSRDD_VEQV_VNAND_VNEGD_VNEGW_VORC_XXLAND_XXLANDC_XXLEQV_XXLNAND_XXLNOR_XXLOR_XXLORf_XXLORC_XXLXOR_XXLXORdpz_XXLXORspz_XXLXORz	= 97,
    VAND_VANDC_V_SET0_V_SET0B_V_SET0H_VSLB_VSLH_VSLW_VSRB_VSRH_VSRW_VRLB_VRLD_VRLH_VRLW_VSRAB_VSRAH_VSRAW_XVABSDP_XVABSSP_XVNABSDP_XVNABSSP_XVCPSGNDP_XVCPSGNSP_XVIEXPDP_XVIEXPSP_XVXEXPDP_XVXEXPSP_VRLDMI_VRLDNM_VRLWMI_VRLWNM_VMRGEW_VMRGOW_VNOR_VOR_VSEL_VXOR_XVNEGDP_XVNEGSP_XSABSQP_XSCPSGNQP_XSIEXPQP_XSNABSQP_XSNEGQP_XSXEXPQP	= 98,
    XXSEL	= 99,
    TABORTDC_TABORTDCI_TABORTWC_TABORTWCI	= 100,
    MTFSB0_MTFSB1	= 101,
    MFFSCDRN_MFFSCDRNI_MFFSCRN_MFFSCRNI	= 102,
    CMPRB_CMPRB8_CMPEQB	= 103,
    TD_TDI	= 104,
    TW_TWI	= 105,
    FCMPUD_FCMPUS_FTDIV_FTSQRT	= 106,
    XSTSTDCDP_XSTSTDCSP	= 107,
    XSMAXCDP_XSMAXDP_XSMAXJDP_XSMINCDP_XSMINDP_XSMINJDP_XSXSIGDP_XSCVSPDPN	= 108,
    XSCMPEQDP_XSCMPEXPDP_XSCMPGEDP_XSCMPGTDP_XSCMPODP_XSCMPUDP_XSTDIVDP_XSTSQRTDP	= 109,
    CNTLZD_CNTLZDo_CNTLZW_CNTLZW8_CNTLZW8o_CNTLZWo_CNTTZD_CNTTZDo_CNTTZW_CNTTZW8_CNTTZW8o_CNTTZWo_POPCNTD_POPCNTW_CMPB_CMPB8_SETB_SETB8_BPERMD	= 110,
    SLD_SRD_SRAD	= 111,
    SRADI_EXTSWSLI_32_64_EXTSWSLI_SRADI_32_RLDIC	= 112,
    MFVRD_MFVSRD_MTVSRD_MTVSRWA_MTVSRWZ_MFVSRWZ	= 113,
    CMPLW_CMPLWI_CMPW_CMPWI_CMPD_CMPDI_CMPLD_CMPLDI	= 114,
    SUBFC_SUBFC8_SUBFIC_SUBFIC8_ANDISo_ANDISo8_ANDIo_ANDIo8_ADDC_ADDC8_ADDIC_ADDIC8_ADDICo_ADDE_ADDE8_ADDE8o_ADDEo_ADDME_ADDME8_ADDME8o_ADDMEo_ADDZE_ADDZE8_ADDZE8o_ADDZEo_SUBF_SUBF8_SUBF8o_SUBFE_SUBFE8_SUBFE8o_SUBFEo_SUBFME_SUBFME8_SUBFME8o_SUBFMEo_SUBFZE_SUBFZE8_SUBFZE8o_SUBFZEo_SUBFo_POPCNTB_LA	= 115,
    ADD4_ADD4o_ADD8_ADD8o_NEG_NEG8_NEG8o_NEGo_ADDI_ADDI8_ADDIS_ADDIS8_LI_LI8_LIS_LIS8_OR_OR8_OR8o_ORI_ORI8_ORIS_ORIS8_ORo_XOR_XOR8_XOR8o_XORI_XORI8_XORIS_XORIS8_XORo_NAND_NAND8_NAND8o_NANDo_AND_AND8_AND8o_ANDC_ANDC8_ANDC8o_ANDCo_ANDo_NOR_NOR8_NOR8o_NORo_ORC_ORC8_ORC8o_ORCo_EQV_EQV8_EQV8o_EQVo_EXTSB_EXTSB8_EXTSB8_32_64_EXTSB8o_EXTSBo_EXTSH_EXTSH8_EXTSH8_32_64_EXTSH8o_EXTSHo_EXTSW_EXTSW_32_EXTSW_32_64_EXTSW_32_64o_EXTSWo_ADD4TLS_ADD8TLS_ADD8TLS__NOP	= 116,
    ADDIStocHA_ADDItocL_COPY	= 117,
    MCRF	= 118,
    MCRXRX	= 119,
    XSNABSDP_XSXEXPDP_XSABSDP_XSNEGDP_XSCPSGNDP	= 120,
    RFEBB	= 121,
    TBEGIN_TRECHKPT	= 122,
    WAIT	= 123,
    RLDCL_RLDCR	= 124,
    RLWIMI_RLWIMI8	= 125,
    RLDICL_RLDICL_32_RLDICL_32_64_RLDICR_RLDICR_32_RLDIMI	= 126,
    MFOCRF_MFOCRF8	= 127,
    MTOCRF_MTOCRF8	= 128,
    CR6SET_CR6UNSET_CRSET_CRUNSET_CRAND_CRANDC_CRNAND_CRNOR_CROR_CRORC_CREQV_CRXOR	= 129,
    SLW_SLW8_SRW_SRW8_RLWINM_RLWINM8_RLWNM_RLWNM8	= 130,
    FABSD_FABSS_FNABSD_FNABSS_FNEGD_FNEGS_FCPSGND_FCPSGNS_FMR	= 131,
    SRAW_SRAWI	= 132,
    ISEL_ISEL8	= 133,
    XSIEXPDP	= 134,
    TRECLAIM_TSR_TABORT	= 135,
    MFVSCR	= 136,
    MTVSCR	= 137,
    VCMPNEZB_VCMPNEZH_VCMPNEZW_VCMPEQUB_VCMPEQUD_VCMPEQUH_VCMPEQUW_VCMPNEB_VCMPNEH_VCMPNEW_VCMPEQFP_VCMPEQFPo_VCMPGEFP_VCMPGEFPo_VCMPGTFP_VCMPGTFPo_VCMPBFP_VCMPBFPo_VCMPGTSB_VCMPGTSBo_VCMPGTSD_VCMPGTSDo_VCMPGTSH_VCMPGTSHo_VCMPGTSW_VCMPGTSWo_VCMPGTUB_VCMPGTUBo_VCMPGTUD_VCMPGTUDo_VCMPGTUH_VCMPGTUHo_VCMPGTUW_VCMPGTUWo_VCMPNEBo_VCMPNEHo_VCMPNEWo_VCMPNEZBo_VCMPNEZHo_VCMPNEZWo_VCMPEQUBo_VCMPEQUDo_VCMPEQUHo_VCMPEQUWo_XVCMPEQDP_XVCMPEQDPo_XVCMPEQSP_XVCMPEQSPo_XVCMPGEDP_XVCMPGEDPo_XVCMPGESP_XVCMPGESPo_XVCMPGTDP_XVCMPGTDPo_XVCMPGTSP_XVCMPGTSPo	= 138,
    VABSDUB_VABSDUH_VABSDUW_VCLZB_VCLZD_VCLZH_VCLZW_VCTZB_VCTZD_VCTZH_VCTZW_VPOPCNTW_VPOPCNTD_VPRTYBD_VPRTYBW	= 139,
    VADDUBS_VADDUHS_VADDUWS_VAVGSB_VAVGSH_VAVGSW_VAVGUB_VAVGUH_VAVGUW_VADDSBS_VADDSHS_VADDSWS_VMAXFP_VMINFP_VMAXSB_VMAXSD_VMAXSH_VMAXSW_VMAXUB_VMAXUD_VMAXUH_VMAXUW_VMINSB_VMINSD_VMINSH_VMINSW_VMINUB_VMINUD_VMINUH_VMINUW_VBPERMD_VADDCUW_VSHASIGMAD_VSHASIGMAW_VSUBSBS_VSUBSHS_VSUBSWS_VSUBUBS_VSUBUHS_VSUBUWS_VSUBCUW_XVMAXDP_XVMAXSP_XVMINDP_XVMINSP_XVTSTDCDP_XVTSTDCSP_XVXSIGDP_XVXSIGSP	= 140,
    XVTDIVDP_XVTDIVSP_XVTSQRTDP_XVTSQRTSP	= 141,
    VADDFP_VCTSXS_VCTSXS_0_VCTUXS_VCTUXS_0_VEXPTEFP_VLOGEFP_VMADDFP_VMHADDSHS_VNMSUBFP_VREFP_VRFIM_VRFIN_VRFIP_VRFIZ_VRSQRTEFP_XVADDDP_XVADDSP_XVCVDPSP_XVCVDPSXDS_XVCVDPSXWS_XVCVDPUXDS_XVCVDPUXWS_XVCVHPSP_XVCVSPDP_XVCVSPHP_XVCVSPSXDS_XVCVSPSXWS_XVCVSPUXDS_XVCVSPUXWS_XVCVSXDDP_XVCVSXDSP_XVCVSXWDP_XVCVSXWSP_XVCVUXDDP_XVCVUXDSP_XVCVUXWDP_XVCVUXWSP_XVMADDADP_XVMADDASP_XVMADDMDP_XVMADDMSP_XVMSUBADP_XVMSUBASP_XVMSUBMDP_XVMSUBMSP_XVMULDP_XVMULSP_XVNMADDADP_XVNMADDASP_XVNMADDMDP_XVNMADDMSP_XVNMSUBADP_XVNMSUBASP_XVNMSUBMDP_XVNMSUBMSP_XVRDPI_XVRDPIC_XVRDPIM_XVRDPIP_XVRDPIZ_XVREDP_XVRESP_XVRSPI_XVRSPIC_XVRSPIM_XVRSPIP_XVRSPIZ_XVRSQRTEDP_XVRSQRTESP_XVSUBDP_XVSUBSP_VCFSX_VCFSX_0_VCFUX_VCFUX_0_VMHRADDSHS_VMLADDUHM_VMSUMMBM_VMSUMSHM_VMSUMSHS_VMSUMUBM_VMSUMUHM_VMSUMUHS_VMULESB_VMULESH_VMULESW_VMULEUB_VMULEUH_VMULEUW_VMULOSB_VMULOSH_VMULOSW_VMULOUB_VMULOUH_VMULOUW_VSUM2SWS_VSUM4SBS_VSUM4SHS_VSUM4UBS_VSUMSWS	= 142,
    VSUBFP_VMULUWM	= 143,
    MADDHD_MADDHDU_MADDLD_MADDLD8_MULLD	= 144,
    MULHD_MULHW_MULLW	= 145,
    MULHDU_MULHWU	= 146,
    MULLI_MULLI8	= 147,
    FRSP_FRIMD_FRIMS_FRIND_FRINS_FRIPD_FRIPS_FRIZD_FRIZS_FRE_FRES_FADDS_FMSUBS_FMADDS_FSUBS_FCFID_FCFIDS_FCFIDU_FCFIDUS_FCTID_FCTIDU_FCTIDUZ_FCTIDZ_FCTIW_FCTIWU_FCTIWUZ_FCTIWZ_FRSQRTE_FRSQRTES_FNMADDS_FNMSUBS_FSELD_FSELS_FMULS	= 148,
    FADD_FSUB	= 149,
    FMSUB_FMADD_FNMADD_FNMSUB_FMUL	= 150,
    XSMADDADP_XSMADDASP_XSMADDMDP_XSMADDMSP_XSMSUBADP_XSMSUBASP_XSMSUBMDP_XSMSUBMSP_XSMULDP_XSMULSP_XSNMADDADP_XSNMADDASP_XSNMADDMDP_XSNMADDMSP_XSNMSUBADP_XSNMSUBASP_XSNMSUBMDP_XSNMSUBMSP	= 151,
    FSELDo_FSELSo	= 152,
    MULHDUo_MULHWUo	= 153,
    MULHDo_MULHWo_MULLWo	= 154,
    MULLDo	= 155,
    FRIMDo_FRIMSo_FRINDo_FRINSo_FRIPDo_FRIPSo_FRIZDo_FRIZSo_FRESo_FREo_FADDSo_FSUBSo_FMSUBSo_FNMSUBSo_FMADDSo_FNMADDSo_FCFIDSo_FCFIDUSo_FCFIDUo_FCFIDo_FCTIDUZo_FCTIDUo_FCTIDZo_FCTIDo_FCTIWUZo_FCTIWUo_FCTIWZo_FCTIWo_FMULSo_FRSQRTESo_FRSQRTEo_FRSPo	= 156,
    FADDo_FSUBo	= 157,
    FMSUBo_FNMSUBo_FMADDo_FNMADDo_FMULo	= 158,
    XSADDDP_XSADDSP_XSCVDPHP_XSCVDPSP_XSCVDPSXDS_XSCVDPSXDSs_XSCVDPSXWS_XSCVDPUXDS_XSCVDPUXDSs_XSCVDPUXWS_XSCVDPSXWSs_XSCVDPUXWSs_XSCVHPDP_XSCVSPDP_XSCVSXDDP_XSCVSXDSP_XSCVUXDDP_XSCVUXDSP_XSRDPI_XSRDPIC_XSRDPIM_XSRDPIP_XSRDPIZ_XSREDP_XSRESP_XSRSQRTEDP_XSRSQRTESP_XSSUBDP_XSSUBSP_XSCVDPSPN_XSRSP	= 159,
    LVSL_LVSR	= 160,
    VSPLTISB_VSPLTISH_VSPLTISW_VSPLTB_VSPLTBs_VSPLTH_VSPLTHs_VSPLTW_XXMRGHW_XXMRGLW_XXPERM_XXPERMR_XXSLDWI_XXSLDWIs_XXSPLTIB_XXSPLTW_XXSPLTWs_XXPERMDI_XXPERMDIs	= 161,
    V_SETALLONES_V_SETALLONESB_V_SETALLONESH_VBPERMQ_VGBBD_VMRGHB_VMRGHH_VMRGHW_VMRGLB_VMRGLH_VMRGLW_VPERM_VPERMR_VPERMXOR_VPKPX_VPKSDSS_VPKSDUS_VPKSHSS_VPKSHUS_VPKSWSS_VPKSWUS_VPKUDUM_VPKUDUS_VPKUHUM_VPKUHUS_VPKUWUM_VPKUWUS_VSL_VSLDOI_VSLO_VSLV_VSR_VSRO_VSRV_VUPKHPX_VUPKHSB_VUPKHSH_VUPKHSW_VUPKLPX_VUPKLSB_VUPKLSH_VUPKLSW_XXBRD_XXBRH_XXBRQ_XXBRW_XXEXTRACTUW_XXINSERTW_VADDCUQ_VADDECUQ_VADDEUQM_VMUL10CUQ_VMUL10ECUQ_VMUL10EUQ_VMUL10UQ_VSUBCUQ_VSUBECUQ_VSUBEUQM_XSTSTDCQP_XSXSIGQP_BCDCFNo_BCDCFZo_BCDCPSGNo_BCDCTNo_BCDCTZo_BCDSETSGNo_BCDSo_BCDTRUNCo_BCDUSo_BCDUTRUNCo	= 162,
    VEXTRACTUB_VEXTRACTUH_VEXTRACTUW_VINSERTB_VINSERTD_VINSERTH_VINSERTW_MFVSRLD_MTVSRWS_VCLZLSBB_VCTZLSBB_VEXTRACTD_VEXTUBLX_VEXTUBRX_VEXTUHLX_VEXTUHRX_VEXTUWLX_VEXTUWRX_VPRTYBQ_VADDUQM_VSUBUQM	= 163,
    XSCMPEXPQP_XSCMPOQP_XSCMPUQP	= 164,
    BCDSRo_XSADDQP_XSADDQPO_XSCVDPQP_XSCVQPDP_XSCVQPDPO_XSCVQPSDZ_XSCVQPSWZ_XSCVQPUDZ_XSCVQPUWZ_XSCVSDQP_XSCVUDQP_XSRQPI_XSRQPIX_XSRQPXP_XSSUBQP_XSSUBQPO	= 165,
    BCDCTSQo	= 166,
    XSMADDQP_XSMADDQPO_XSMSUBQP_XSMSUBQPO_XSMULQP_XSMULQPO_XSNMADDQP_XSNMADDQPO_XSNMSUBQP_XSNMSUBQPO	= 167,
    BCDCFSQo	= 168,
    XSDIVQP_XSDIVQPO	= 169,
    XSSQRTQP_XSSQRTQPO	= 170,
    LXVL_LXVLL	= 171,
    LVEBX_LVEHX_LVEWX_LVX_LVXL	= 172,
    LXSIBZX_LXSIHZX_LXSDX_LXVB16X_LXVD2X_LXVWSX_LXSIWZX_LXV_LXVX_LXSD	= 173,
    DFLOADf64_XFLOADf64_LIWZX	= 174,
    DCBF_DCBFEP_DCBST_DCBSTEP_DCBT_DCBTEP_DCBZ_DCBZEP_DCBZL_DCBZLEP_DCBTST_DCBTSTEP	= 175,
    CP_COPY_CP_COPY8	= 176,
    CP_PASTE_CP_PASTE8	= 177,
    ICBI_ICBIEP	= 178,
    ICBT_ICBTLS_LBZ_LBZ8_LBZCIX_LBZX_LBZX8_LBZXTLS_LBZXTLS__LBZXTLS_32_LDBRX_LDCIX_LHBRX_LHBRX8_LHZ_LHZ8_LHZCIX_LHZX_LHZX8_LHZXTLS_LHZXTLS__LHZXTLS_32_LWBRX_LWBRX8_LWZ_LWZ8_LWZCIX_LWZX_LWZX8_LWZXTLS_LWZXTLS__LWZXTLS_32_EnforceIEIO_LSWI	= 179,
    LBARX_LBARXL_LHARX_LHARXL_LWARX_LWARXL	= 180,
    LD_LDX_LDXTLS_LDXTLS__DARN	= 181,
    LDARX_LDARXL	= 182,
    CP_ABORT	= 183,
    ISYNC	= 184,
    MSGSYNC	= 185,
    TLBSYNC	= 186,
    SYNC	= 187,
    LMW	= 188,
    LFIWZX_LFDX_LFD	= 189,
    SLBIA	= 190,
    SLBIE	= 191,
    SLBMFEE	= 192,
    SLBMFEV	= 193,
    SLBMTE	= 194,
    TLBIEL	= 195,
    LHZU_LHZU8_LWZU_LWZU8	= 196,
    LHZUX_LHZUX8_LWZUX_LWZUX8	= 197,
    TEND	= 198,
    STBCX_STHCX_STWCX	= 199,
    STDCX	= 200,
    LDMX	= 201,
    LHA_LHA8_LHAX_LHAX8_LWAX_LWAX_32	= 202,
    CP_PASTE8o_CP_PASTEo	= 203,
    LWA_LWA_32	= 204,
    TCHECK	= 205,
    LFIWAX	= 206,
    LXSIWAX	= 207,
    LIWAX	= 208,
    LFSX_LFS	= 209,
    LXSSP_LXSSPX	= 210,
    XFLOADf32_DFLOADf32	= 211,
    LHAU_LHAU8	= 212,
    LHAUX_LHAUX8_LWAUX	= 213,
    LXVH8X_LXVDSX_LXVW4X	= 214,
    STFD_STFDX_STFIWX_STFS_STFSX_STXSD_STXSDX_STXSIBX_STXSIBXv_STXSIHX_STXSIHXv_STXSIWX_STXSSP_STXSSPX	= 215,
    STW_STW8_STDBRX_STHBRX_STWBRX_STB_STB8_STH_STH8_STBX_STBX8_STBXTLS_STBXTLS__STBXTLS_32_STHX_STHX8_STHXTLS_STHXTLS__STHXTLS_32_STWX_STWX8_STWXTLS_STWXTLS__STWXTLS_32	= 216,
    DFSTOREf32_DFSTOREf64_XFSTOREf32_XFSTOREf64_STIWX	= 217,
    STD_STDX_STDXTLS_STDXTLS_	= 218,
    STBCIX_STDCIX_STHCIX_STWCIX_STSWI	= 219,
    SLBIEG	= 220,
    STMW	= 221,
    TLBIE	= 222,
    STVEBX_STVEHX_STVEWX_STVX_STVXL	= 223,
    STXV_STXVB16X_STXVD2X_STXVH8X_STXVW4X_STXVX	= 224,
    STXVL_STXVLL	= 225,
    MTCTR_MTCTR8_MTCTR8loop_MTCTRloop_MTLR_MTLR8	= 226,
    MFVRSAVE_MFVRSAVEv_MTVRSAVE_MTVRSAVEv	= 227,
    MFPMR	= 228,
    MTPMR	= 229,
    MFTB_MFTB8	= 230,
    MFCTR_MFCTR8_MFLR_MFLR8_MFSPR_MFSPR8	= 231,
    MFMSR	= 232,
    MTMSR	= 233,
    MTMSRD	= 234,
    MTSPR_MTSPR8	= 235,
    DIVW_DIVWU_MODSW	= 236,
    DIVWE_DIVWEU_MODSD_MODUD_MODUW	= 237,
    DIVD_DIVDU	= 238,
    DIVDE_DIVDEU	= 239,
    DIVWUo_DIVWo	= 240,
    DIVDo_DIVDUo	= 241,
    DIVWEo_DIVWEUo	= 242,
    DIVDEo_DIVDEUo	= 243,
    MTCRF_MTCRF8	= 244,
    ADDC8o_ADDCo_SUBFC8o_SUBFCo	= 245,
    FABSDo_FABSSo_FNABSDo_FNABSSo_FCPSGNDo_FCPSGNSo_FNEGDo_FNEGSo_FMRo	= 246,
    MCRFS	= 247,
    MTFSF_MTFSFo_MTFSFI_MTFSFIo	= 248,
    MTFSFb	= 249,
    RLDCLo_RLDCRo	= 250,
    RLDICLo_RLDICRo_RLDICL_32o_RLDIMIo	= 251,
    RLWIMI8o_RLWIMIo	= 252,
    RLWINM8o_RLWINMo_RLWNM8o_RLWNMo_SLW8o_SLWo_SRW8o_SRWo	= 253,
    SRAWIo_SRAWo	= 254,
    MFFS_MFFSCE_MFFSL_MFFSo	= 255,
    MFCR_MFCR8	= 256,
    EXTSWSLI_32_64o_SRADIo_EXTSWSLIo_RLDICo	= 257,
    SRADo_SLDo_SRDo	= 258,
    FDIV	= 259,
    FDIVo	= 260,
    XSSQRTDP	= 261,
    FSQRT	= 262,
    XVSQRTDP	= 263,
    XVSQRTSP	= 264,
    FSQRTo	= 265,
    XSSQRTSP	= 266,
    FSQRTS	= 267,
    FSQRTSo	= 268,
    XSDIVDP	= 269,
    FDIVS	= 270,
    FDIVSo	= 271,
    XSDIVSP	= 272,
    XVDIVSP	= 273,
    XVDIVDP	= 274,
    LFSU	= 275,
    LFSUX	= 276,
    STFDU_STFDUX_STFSU_STFSUX	= 277,
    STBU_STBU8_STDU_STHU_STHU8_STWU_STWU8	= 278,
    STBUX_STBUX8_STDUX_STHUX_STHUX8_STWUX_STWUX8	= 279,
    LBZU_LBZU8	= 280,
    LBZUX_LBZUX8	= 281,
    LDU	= 282,
    LDUX	= 283,
    LFDU	= 284,
    LFDUX	= 285,
    VPMSUMB_VPMSUMD_VPMSUMH_VPMSUMW_VCIPHER_VCIPHERLAST_VNCIPHER_VNCIPHERLAST_VSBOX	= 286,
    BCCCTR_BCCCTR8_BCCCTRL_BCCCTRL8_BCCL_BCCLA_BCCLR_BCCLRL_BCCTR_BCCTR8_BCCTR8n_BCCTRL_BCCTRL8_BCCTRL8n_BCCTRLn_BCCTRn_BDNZ_BDNZ8_BDNZA_BDNZAm_BDNZAp_BDNZm_BDNZp_BDZ_BDZ8_BDZA_BDZAm_BDZAp_BDZm_BDZp_BDNZL_BDNZLA_BDNZLAm_BDNZLAp_BDNZLR_BDNZLR8_BDNZLRL_BDNZLRLm_BDNZLRLp_BDNZLRm_BDNZLRp_BDNZLm_BDNZLp_BDZL_BDZLA_BDZLAm_BDZLAp_BDZLR_BDZLR8_BDZLRL_BDZLRLm_BDZLRLp_BDZLRm_BDZLRp_BDZLm_BDZLp_BL_BL_NOP_BL_TLS_BL8_BL8_NOP_BL8_NOP_TLS_BL8_TLS_BL8_TLS__BLA_BLA8_BLA8_NOP_BLR_BLR8_BLRL_TAILB_TAILB8_TAILBA_TAILBA8_TAILBCTR_TAILBCTR8_gBC_gBCA_gBCAat_gBCCTR_gBCCTRL_gBCL_gBCLA_gBCLAat_gBCLR_gBCLRL_gBCLat_gBCat_BCLR_BCLRL_BCLRLn_BCLRn_BCTR_BCTR8_BCTRL_BCTRL8_B_BA_BC_BCC_BCCA_BCL_BCLalways_BCLn_BCTRL8_LDinto_toc_BCn_CTRL_DEP	= 287,
    ADDPCIS	= 288,
    LDAT_LWAT	= 289,
    STDAT_STWAT	= 290,
    BRINC	= 291,
    EVABS_EVEQV_EVNAND_EVNEG_EVADDIW_EVADDW_EVAND_EVANDC_EVCMPEQ_EVCMPGTS_EVCMPGTU_EVCMPLTS_EVCMPLTU_EVCNTLSW_EVCNTLZW_EVEXTSB_EVEXTSH_EVMERGEHI_EVMERGEHILO_EVMERGELO_EVMERGELOHI_EVNOR_EVOR_EVORC_EVXOR_EVRLW_EVRLWI_EVRNDW_EVSLW_EVSLWI_EVSPLATFI_EVSPLATI_EVSRWIS_EVSRWIU_EVSRWS_EVSRWU_EVSUBFW_EVSUBIFW	= 292,
    EVMRA_EVADDSMIAAW_EVADDSSIAAW_EVADDUMIAAW_EVADDUSIAAW_EVDIVWS_EVDIVWU_EVMHEGSMFAA_EVMHEGSMFAN_EVMHEGSMIAA_EVMHEGSMIAN_EVMHEGUMIAA_EVMHEGUMIAN_EVMHESMF_EVMHESMFA_EVMHESMFAAW_EVMHESMFANW_EVMHESMI_EVMHESMIA_EVMHESMIAAW_EVMHESMIANW_EVMHESSF_EVMHESSFA_EVMHESSFAAW_EVMHESSFANW_EVMHESSIAAW_EVMHESSIANW_EVMHEUMI_EVMHEUMIA_EVMHEUMIAAW_EVMHEUMIANW_EVMHEUSIAAW_EVMHEUSIANW_EVMHOGSMFAA_EVMHOGSMFAN_EVMHOGSMIAA_EVMHOGSMIAN_EVMHOGUMIAA_EVMHOGUMIAN_EVMHOSMF_EVMHOSMFA_EVMHOSMFAAW_EVMHOSMFANW_EVMHOSMI_EVMHOSMIA_EVMHOSMIAAW_EVMHOSMIANW_EVMHOSSF_EVMHOSSFA_EVMHOSSFAAW_EVMHOSSFANW_EVMHOSSIAAW_EVMHOSSIANW_EVMHOUMI_EVMHOUMIA_EVMHOUMIAAW_EVMHOUMIANW_EVMHOUSIAAW_EVMHOUSIANW_EVMWHSMF_EVMWHSMFA_EVMWHSMI_EVMWHSMIA_EVMWHSSF_EVMWHSSFA_EVMWHUMI_EVMWHUMIA_EVMWLSMIAAW_EVMWLSMIANW_EVMWLSSIAAW_EVMWLSSIANW_EVMWLUMI_EVMWLUMIA_EVMWLUMIAAW_EVMWLUMIANW_EVMWLUSIAAW_EVMWLUSIANW_EVMWSMF_EVMWSMFA_EVMWSMFAA_EVMWSMFAN_EVMWSMI_EVMWSMIA_EVMWSMIAA_EVMWSMIAN_EVMWSSF_EVMWSSFA_EVMWSSFAA_EVMWSSFAN_EVMWUMI_EVMWUMIA_EVMWUMIAA_EVMWUMIAN_EVSUBFSMIAAW_EVSUBFSSIAAW_EVSUBFUMIAAW_EVSUBFUSIAAW	= 293,
    EVLDD_EVLDDX_EVLDH_EVLDHX_EVLDW_EVLDWX_EVLHHESPLAT_EVLHHESPLATX_EVLHHOSSPLAT_EVLHHOSSPLATX_EVLHHOUSPLAT_EVLHHOUSPLATX_EVLWHE_EVLWHEX_EVLWHOS_EVLWHOSX_EVLWHOU_EVLWHOUX_EVLWHSPLAT_EVLWHSPLATX_EVLWWSPLAT_EVLWWSPLATX	= 294,
    EVSTDD_EVSTDDX_EVSTDH_EVSTDHX_EVSTDW_EVSTDWX_EVSTWHE_EVSTWHEX_EVSTWHO_EVSTWHOX_EVSTWWE_EVSTWWEX_EVSTWWO_EVSTWWOX	= 295,
    HRFID_ATTN_CLRBHRB_MFBHRBE_NAP_RFCI_RFDI_RFMCI_SC	= 296,
    RFI	= 297,
    RFID	= 298,
    DSS_DSSALL_DST_DST64_DSTST_DSTST64_DSTSTT_DSTSTT64_DSTT_DSTT64_ICBLQ_LBEPX_LHEPX_LWEPX_TLBIVAX_TLBLD_TLBLI_TLBRE_TLBRE2_TLBSX_TLBSX2_TLBSX2D_TLBWE_TLBWE2_MBAR_TRAP_DCCCI_ICCCI	= 299,
    ICBLC_STBEPX_STHEPX_STWEPX	= 300,
    LFDEPX	= 301,
    STFDEPX	= 302,
    MFSR_MFSRIN	= 303,
    MTSR_MTSRIN	= 304,
    MFDCR	= 305,
    MTDCR	= 306,
    NOP_GT_PWR6_NOP_GT_PWR7	= 307,
    TLBIA	= 308,
    WRTEE_WRTEEI	= 309,
    MSYNC	= 310,
    SLBSYNC	= 311,
    SLBFEEo	= 312,
    STOP	= 313,
    DCBA_DCBI	= 314,
    SCHED_LIST_END = 315
  };
} // end Sched namespace
} // end PPC namespace
} // end llvm namespace
#endif // GET_INSTRINFO_SCHED_ENUM

#ifdef GET_INSTRINFO_MC_DESC
#undef GET_INSTRINFO_MC_DESC
namespace llvm {

static const MCPhysReg ImplicitList1[] = { PPC::CR7, 0 };
static const MCPhysReg ImplicitList2[] = { PPC::RM, 0 };
static const MCPhysReg ImplicitList3[] = { PPC::CR0, 0 };
static const MCPhysReg ImplicitList4[] = { PPC::CARRY, 0 };
static const MCPhysReg ImplicitList5[] = { PPC::CARRY, PPC::CR0, 0 };
static const MCPhysReg ImplicitList6[] = { PPC::X0, PPC::X3, PPC::X4, PPC::X5, PPC::X6, PPC::X7, PPC::X8, PPC::X9, PPC::X10, PPC::X11, PPC::X12, PPC::LR8, PPC::CTR8, PPC::CR0, PPC::CR1, PPC::CR5, PPC::CR6, PPC::CR7, 0 };
static const MCPhysReg ImplicitList7[] = { PPC::R0, PPC::R3, PPC::R4, PPC::R5, PPC::R6, PPC::R7, PPC::R8, PPC::R9, PPC::R10, PPC::R11, PPC::R12, PPC::LR, PPC::CTR, PPC::CR0, PPC::CR1, PPC::CR5, PPC::CR6, PPC::CR7, 0 };
static const MCPhysReg ImplicitList8[] = { PPC::R1, 0 };
static const MCPhysReg ImplicitList9[] = { PPC::CTR, 0 };
static const MCPhysReg ImplicitList10[] = { PPC::CTR8, 0 };
static const MCPhysReg ImplicitList11[] = { PPC::CTR, PPC::RM, 0 };
static const MCPhysReg ImplicitList12[] = { PPC::LR, 0 };
static const MCPhysReg ImplicitList13[] = { PPC::CTR8, PPC::RM, 0 };
static const MCPhysReg ImplicitList14[] = { PPC::LR8, 0 };
static const MCPhysReg ImplicitList15[] = { PPC::LR, PPC::RM, 0 };
static const MCPhysReg ImplicitList16[] = { PPC::CR6, 0 };
static const MCPhysReg ImplicitList17[] = { PPC::LR8, PPC::X2, 0 };
static const MCPhysReg ImplicitList18[] = { PPC::CTR, PPC::LR, PPC::RM, 0 };
static const MCPhysReg ImplicitList19[] = { PPC::CTR8, PPC::LR8, PPC::RM, 0 };
static const MCPhysReg ImplicitList20[] = { PPC::LR8, PPC::RM, 0 };
static const MCPhysReg ImplicitList21[] = { PPC::CR1EQ, 0 };
static const MCPhysReg ImplicitList22[] = { PPC::X1, 0 };
static const MCPhysReg ImplicitList23[] = { PPC::CR1, 0 };
static const MCPhysReg ImplicitList24[] = { PPC::X0, PPC::X4, PPC::X5, PPC::X6, PPC::X7, PPC::X8, PPC::X9, PPC::X10, PPC::X11, PPC::X12, PPC::LR8, PPC::CTR8, PPC::CR0, PPC::CR1, PPC::CR5, PPC::CR6, PPC::CR7, 0 };
static const MCPhysReg ImplicitList25[] = { PPC::R0, PPC::R4, PPC::R5, PPC::R6, PPC::R7, PPC::R8, PPC::R9, PPC::R10, PPC::R11, PPC::R12, PPC::LR, PPC::CTR, PPC::CR0, PPC::CR1, PPC::CR5, PPC::CR6, PPC::CR7, 0 };
static const MCPhysReg ImplicitList26[] = { PPC::LR, PPC::CTR, 0 };

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
static const MCOperandInfo OperandInfo32[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo33[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo34[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo35[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo36[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo37[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo38[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo39[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo40[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo41[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo42[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo43[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo44[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo45[] = { { PPC::SPILLTOVSRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo46[] = { { PPC::SPILLTOVSRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo47[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo48[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo49[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo50[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo51[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo52[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo53[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo54[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo55[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo56[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo57[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo58[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo59[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo60[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo61[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo62[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo63[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo64[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo65[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo66[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo67[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo68[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo69[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo70[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo71[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo72[] = { { -1, 0, MCOI::OPERAND_PCREL, 0 }, };
static const MCOperandInfo OperandInfo73[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo74[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo75[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo76[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo77[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo78[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo79[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo80[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo81[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo82[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo83[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo84[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo85[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo86[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo87[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo88[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo89[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo90[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo91[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo92[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo93[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo94[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo95[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo96[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo97[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo98[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo99[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo100[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo101[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo102[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo103[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo104[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo105[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo106[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo107[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo108[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo109[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo110[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo111[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo112[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo113[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo114[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo115[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo116[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo117[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo118[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo119[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo120[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo121[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo122[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo123[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo124[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo125[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo126[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo127[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo128[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo129[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo130[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo131[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo132[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo133[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo134[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo135[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo136[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo137[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo138[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo139[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo140[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo141[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo142[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo143[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo144[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo145[] = { { PPC::VFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo146[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo147[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo148[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo149[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo150[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo151[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo152[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo153[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo154[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo155[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo156[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo157[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo158[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo159[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRSAVERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo160[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo161[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo162[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo163[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo164[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo165[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo166[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo167[] = { { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo168[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo169[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo170[] = { { PPC::VRSAVERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo171[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo172[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo173[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo174[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo175[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo176[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo177[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo178[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo179[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo180[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo181[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo182[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo183[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo184[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo185[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo186[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo187[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo188[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo189[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo190[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo191[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo192[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo193[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo194[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo195[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo196[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo197[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo198[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo199[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo200[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((1 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo201[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo202[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo203[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo204[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo205[] = { { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo206[] = { { PPC::VRSAVERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo207[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo208[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo209[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo210[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo211[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo212[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo213[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo214[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo215[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo216[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo217[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo218[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo219[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo220[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo221[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo222[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo223[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo224[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo225[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo226[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo227[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo228[] = { { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo229[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo230[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRC_NOR0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo231[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RC_NOX0RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo232[] = { { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QBRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo233[] = { { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo234[] = { { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::QSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo235[] = { { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPERCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo236[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo237[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo238[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo239[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo240[] = { { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo241[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo242[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo243[] = { { PPC::SPE4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo244[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo245[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo246[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo247[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo248[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo249[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::F8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo250[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo251[] = { { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, { PPC::F4RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { 1, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { 0, 0|(1<<MCOI::LookupPtrRegClass), MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo252[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo253[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo254[] = { { -1, 0, MCOI::OPERAND_PCREL, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo255[] = { { PPC::CTRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo256[] = { { PPC::CTRRC8RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo257[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo258[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo259[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo260[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo261[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo262[] = { { PPC::GPRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo263[] = { { PPC::VFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo264[] = { { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo265[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo266[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, };
static const MCOperandInfo OperandInfo267[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo268[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo269[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo270[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo271[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo272[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo273[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo274[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo275[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo276[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo277[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo278[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo279[] = { { PPC::VFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo280[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo281[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo282[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::G8RCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo283[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo284[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo285[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo286[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo287[] = { { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo288[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo289[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo290[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo291[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo292[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo293[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo294[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo295[] = { { PPC::CRRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo296[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo297[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo298[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, ((0 << 16) | (1 << MCOI::TIED_TO)) }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo299[] = { { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo300[] = { { PPC::VSSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo301[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo302[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo303[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSFRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo304[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo305[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo306[] = { { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { PPC::VSRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo307[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo308[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, };
static const MCOperandInfo OperandInfo309[] = { { -1, 0, MCOI::OPERAND_UNKNOWN, 0 }, { PPC::CRBITRCRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };

extern const MCInstrDesc PPCInsts[] = {
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
  { 16,	2,	1,	0,	117,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo7, -1 ,nullptr },  // Inst #16 = COPY
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
  { 164,	1,	0,	4,	1,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #164 = CFENCE8
  { 165,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #165 = CLRLSLDI
  { 166,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #166 = CLRLSLDIo
  { 167,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #167 = CLRLSLWI
  { 168,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #168 = CLRLSLWIo
  { 169,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #169 = CLRRDI
  { 170,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #170 = CLRRDIo
  { 171,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #171 = CLRRWI
  { 172,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #172 = CLRRWIo
  { 173,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #173 = CP_COPY_FIRST
  { 174,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #174 = CP_COPYx
  { 175,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #175 = CP_PASTE_LAST
  { 176,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #176 = CP_PASTEx
  { 177,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #177 = DCBFL
  { 178,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #178 = DCBFLP
  { 179,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #179 = DCBFx
  { 180,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #180 = DCBTCT
  { 181,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #181 = DCBTDS
  { 182,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #182 = DCBTSTCT
  { 183,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #183 = DCBTSTDS
  { 184,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #184 = DCBTSTT
  { 185,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #185 = DCBTSTx
  { 186,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #186 = DCBTT
  { 187,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #187 = DCBTx
  { 188,	3,	1,	4,	211,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #188 = DFLOADf32
  { 189,	3,	1,	4,	174,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #189 = DFLOADf64
  { 190,	3,	0,	4,	217,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo40, -1 ,nullptr },  // Inst #190 = DFSTOREf32
  { 191,	3,	0,	4,	217,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo41, -1 ,nullptr },  // Inst #191 = DFSTOREf64
  { 192,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #192 = EXTLDI
  { 193,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #193 = EXTLDIo
  { 194,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #194 = EXTLWI
  { 195,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #195 = EXTLWIo
  { 196,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #196 = EXTRDI
  { 197,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #197 = EXTRDIo
  { 198,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #198 = EXTRWI
  { 199,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #199 = EXTRWIo
  { 200,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #200 = INSLWI
  { 201,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #201 = INSLWIo
  { 202,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #202 = INSRDI
  { 203,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #203 = INSRDIo
  { 204,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #204 = INSRWI
  { 205,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #205 = INSRWIo
  { 206,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #206 = LAx
  { 207,	3,	1,	4,	208,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #207 = LIWAX
  { 208,	3,	1,	4,	174,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #208 = LIWZX
  { 209,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #209 = RLWIMIbm
  { 210,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #210 = RLWIMIobm
  { 211,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #211 = RLWINMbm
  { 212,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #212 = RLWINMobm
  { 213,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #213 = RLWNMbm
  { 214,	4,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #214 = RLWNMobm
  { 215,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #215 = ROTRDI
  { 216,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #216 = ROTRDIo
  { 217,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #217 = ROTRWI
  { 218,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #218 = ROTRWIo
  { 219,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #219 = SLDI
  { 220,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #220 = SLDIo
  { 221,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #221 = SLWI
  { 222,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #222 = SLWIo
  { 223,	3,	1,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #223 = SPILLTOVSR_LD
  { 224,	3,	1,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #224 = SPILLTOVSR_LDX
  { 225,	3,	0,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #225 = SPILLTOVSR_ST
  { 226,	3,	0,	4,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #226 = SPILLTOVSR_STX
  { 227,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #227 = SRDI
  { 228,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #228 = SRDIo
  { 229,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #229 = SRWI
  { 230,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #230 = SRWIo
  { 231,	3,	0,	4,	217,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #231 = STIWX
  { 232,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #232 = SUBI
  { 233,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #233 = SUBIC
  { 234,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #234 = SUBICo
  { 235,	3,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #235 = SUBIS
  { 236,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #236 = SUBPCIS
  { 237,	3,	1,	4,	211,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #237 = XFLOADf32
  { 238,	3,	1,	4,	174,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #238 = XFLOADf64
  { 239,	3,	0,	4,	217,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #239 = XFSTOREf32
  { 240,	3,	0,	4,	217,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #240 = XFSTOREf64
  { 241,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #241 = ADD4
  { 242,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #242 = ADD4TLS
  { 243,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #243 = ADD4o
  { 244,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #244 = ADD8
  { 245,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #245 = ADD8TLS
  { 246,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #246 = ADD8TLS_
  { 247,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #247 = ADD8o
  { 248,	3,	1,	4,	115,	0|(1ULL<<MCID::Commutable), 0xcULL, nullptr, ImplicitList4, OperandInfo49, -1 ,nullptr },  // Inst #248 = ADDC
  { 249,	3,	1,	4,	115,	0|(1ULL<<MCID::Commutable), 0xcULL, nullptr, ImplicitList4, OperandInfo50, -1 ,nullptr },  // Inst #249 = ADDC8
  { 250,	3,	1,	4,	245,	0|(1ULL<<MCID::Commutable), 0xcULL, nullptr, ImplicitList5, OperandInfo50, -1 ,nullptr },  // Inst #250 = ADDC8o
  { 251,	3,	1,	4,	245,	0|(1ULL<<MCID::Commutable), 0xcULL, nullptr, ImplicitList5, OperandInfo49, -1 ,nullptr },  // Inst #251 = ADDCo
  { 252,	3,	1,	4,	115,	0|(1ULL<<MCID::Commutable), 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo49, -1 ,nullptr },  // Inst #252 = ADDE
  { 253,	3,	1,	4,	115,	0|(1ULL<<MCID::Commutable), 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo50, -1 ,nullptr },  // Inst #253 = ADDE8
  { 254,	3,	1,	4,	115,	0|(1ULL<<MCID::Commutable), 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo50, -1 ,nullptr },  // Inst #254 = ADDE8o
  { 255,	3,	1,	4,	115,	0|(1ULL<<MCID::Commutable), 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo49, -1 ,nullptr },  // Inst #255 = ADDEo
  { 256,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #256 = ADDI
  { 257,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #257 = ADDI8
  { 258,	3,	1,	4,	115,	0, 0xcULL, nullptr, ImplicitList4, OperandInfo36, -1 ,nullptr },  // Inst #258 = ADDIC
  { 259,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo35, -1 ,nullptr },  // Inst #259 = ADDIC8
  { 260,	3,	1,	4,	115,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x8ULL, nullptr, ImplicitList5, OperandInfo36, -1 ,nullptr },  // Inst #260 = ADDICo
  { 261,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #261 = ADDIS
  { 262,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #262 = ADDIS8
  { 263,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #263 = ADDISdtprelHA
  { 264,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #264 = ADDISdtprelHA32
  { 265,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #265 = ADDISgotTprelHA
  { 266,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #266 = ADDIStlsgdHA
  { 267,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #267 = ADDIStlsldHA
  { 268,	3,	1,	4,	117,	0|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #268 = ADDIStocHA
  { 269,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #269 = ADDIdtprelL
  { 270,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #270 = ADDIdtprelL32
  { 271,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #271 = ADDItlsgdL
  { 272,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #272 = ADDItlsgdL32
  { 273,	4,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList6, OperandInfo53, -1 ,nullptr },  // Inst #273 = ADDItlsgdLADDR
  { 274,	4,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList7, OperandInfo54, -1 ,nullptr },  // Inst #274 = ADDItlsgdLADDR32
  { 275,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #275 = ADDItlsldL
  { 276,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #276 = ADDItlsldL32
  { 277,	4,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList6, OperandInfo53, -1 ,nullptr },  // Inst #277 = ADDItlsldLADDR
  { 278,	4,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList7, OperandInfo54, -1 ,nullptr },  // Inst #278 = ADDItlsldLADDR32
  { 279,	3,	1,	4,	117,	0|(1ULL<<MCID::Rematerializable), 0x0ULL, nullptr, nullptr, OperandInfo51, -1 ,nullptr },  // Inst #279 = ADDItocL
  { 280,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo37, -1 ,nullptr },  // Inst #280 = ADDME
  { 281,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo55, -1 ,nullptr },  // Inst #281 = ADDME8
  { 282,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo55, -1 ,nullptr },  // Inst #282 = ADDME8o
  { 283,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo37, -1 ,nullptr },  // Inst #283 = ADDMEo
  { 284,	2,	1,	4,	288,	0, 0x8ULL, nullptr, nullptr, OperandInfo56, -1 ,nullptr },  // Inst #284 = ADDPCIS
  { 285,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo37, -1 ,nullptr },  // Inst #285 = ADDZE
  { 286,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo55, -1 ,nullptr },  // Inst #286 = ADDZE8
  { 287,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo55, -1 ,nullptr },  // Inst #287 = ADDZE8o
  { 288,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo37, -1 ,nullptr },  // Inst #288 = ADDZEo
  { 289,	2,	0,	4,	0,	0, 0x0ULL, ImplicitList8, ImplicitList8, OperandInfo7, -1 ,nullptr },  // Inst #289 = ADJCALLSTACKDOWN
  { 290,	2,	0,	4,	0,	0, 0x0ULL, ImplicitList8, ImplicitList8, OperandInfo7, -1 ,nullptr },  // Inst #290 = ADJCALLSTACKUP
  { 291,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #291 = AND
  { 292,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #292 = AND8
  { 293,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #293 = AND8o
  { 294,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #294 = ANDC
  { 295,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #295 = ANDC8
  { 296,	3,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #296 = ANDC8o
  { 297,	3,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #297 = ANDCo
  { 298,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo36, -1 ,nullptr },  // Inst #298 = ANDISo
  { 299,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo35, -1 ,nullptr },  // Inst #299 = ANDISo8
  { 300,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo36, -1 ,nullptr },  // Inst #300 = ANDIo
  { 301,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo35, -1 ,nullptr },  // Inst #301 = ANDIo8
  { 302,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #302 = ANDIo_1_EQ_BIT
  { 303,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #303 = ANDIo_1_EQ_BIT8
  { 304,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo57, -1 ,nullptr },  // Inst #304 = ANDIo_1_GT_BIT
  { 305,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo58, -1 ,nullptr },  // Inst #305 = ANDIo_1_GT_BIT8
  { 306,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #306 = ANDo
  { 307,	5,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo59, -1 ,nullptr },  // Inst #307 = ATOMIC_CMP_SWAP_I16
  { 308,	5,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo59, -1 ,nullptr },  // Inst #308 = ATOMIC_CMP_SWAP_I32
  { 309,	5,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #309 = ATOMIC_CMP_SWAP_I64
  { 310,	5,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo59, -1 ,nullptr },  // Inst #310 = ATOMIC_CMP_SWAP_I8
  { 311,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #311 = ATOMIC_LOAD_ADD_I16
  { 312,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #312 = ATOMIC_LOAD_ADD_I32
  { 313,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #313 = ATOMIC_LOAD_ADD_I64
  { 314,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #314 = ATOMIC_LOAD_ADD_I8
  { 315,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #315 = ATOMIC_LOAD_AND_I16
  { 316,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #316 = ATOMIC_LOAD_AND_I32
  { 317,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #317 = ATOMIC_LOAD_AND_I64
  { 318,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #318 = ATOMIC_LOAD_AND_I8
  { 319,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #319 = ATOMIC_LOAD_MAX_I16
  { 320,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #320 = ATOMIC_LOAD_MAX_I32
  { 321,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #321 = ATOMIC_LOAD_MAX_I64
  { 322,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #322 = ATOMIC_LOAD_MAX_I8
  { 323,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #323 = ATOMIC_LOAD_MIN_I16
  { 324,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #324 = ATOMIC_LOAD_MIN_I32
  { 325,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #325 = ATOMIC_LOAD_MIN_I64
  { 326,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #326 = ATOMIC_LOAD_MIN_I8
  { 327,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #327 = ATOMIC_LOAD_NAND_I16
  { 328,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #328 = ATOMIC_LOAD_NAND_I32
  { 329,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #329 = ATOMIC_LOAD_NAND_I64
  { 330,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #330 = ATOMIC_LOAD_NAND_I8
  { 331,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #331 = ATOMIC_LOAD_OR_I16
  { 332,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #332 = ATOMIC_LOAD_OR_I32
  { 333,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #333 = ATOMIC_LOAD_OR_I64
  { 334,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #334 = ATOMIC_LOAD_OR_I8
  { 335,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #335 = ATOMIC_LOAD_SUB_I16
  { 336,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #336 = ATOMIC_LOAD_SUB_I32
  { 337,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #337 = ATOMIC_LOAD_SUB_I64
  { 338,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #338 = ATOMIC_LOAD_SUB_I8
  { 339,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #339 = ATOMIC_LOAD_UMAX_I16
  { 340,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #340 = ATOMIC_LOAD_UMAX_I32
  { 341,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #341 = ATOMIC_LOAD_UMAX_I64
  { 342,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #342 = ATOMIC_LOAD_UMAX_I8
  { 343,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #343 = ATOMIC_LOAD_UMIN_I16
  { 344,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #344 = ATOMIC_LOAD_UMIN_I32
  { 345,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #345 = ATOMIC_LOAD_UMIN_I64
  { 346,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #346 = ATOMIC_LOAD_UMIN_I8
  { 347,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #347 = ATOMIC_LOAD_XOR_I16
  { 348,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #348 = ATOMIC_LOAD_XOR_I32
  { 349,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #349 = ATOMIC_LOAD_XOR_I64
  { 350,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #350 = ATOMIC_LOAD_XOR_I8
  { 351,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #351 = ATOMIC_SWAP_I16
  { 352,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #352 = ATOMIC_SWAP_I32
  { 353,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo62, -1 ,nullptr },  // Inst #353 = ATOMIC_SWAP_I64
  { 354,	4,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, ImplicitList3, OperandInfo61, -1 ,nullptr },  // Inst #354 = ATOMIC_SWAP_I8
  { 355,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #355 = ATTN
  { 356,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x38ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #356 = B
  { 357,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #357 = BA
  { 358,	2,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x38ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #358 = BC
  { 359,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #359 = BCC
  { 360,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #360 = BCCA
  { 361,	2,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, nullptr, OperandInfo65, -1 ,nullptr },  // Inst #361 = BCCCTR
  { 362,	2,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList10, nullptr, OperandInfo65, -1 ,nullptr },  // Inst #362 = BCCCTR8
  { 363,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList12, OperandInfo65, -1 ,nullptr },  // Inst #363 = BCCCTRL
  { 364,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList13, ImplicitList14, OperandInfo65, -1 ,nullptr },  // Inst #364 = BCCCTRL8
  { 365,	3,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo64, -1 ,nullptr },  // Inst #365 = BCCL
  { 366,	3,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo64, -1 ,nullptr },  // Inst #366 = BCCLA
  { 367,	2,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList15, nullptr, OperandInfo65, -1 ,nullptr },  // Inst #367 = BCCLR
  { 368,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList15, ImplicitList12, OperandInfo65, -1 ,nullptr },  // Inst #368 = BCCLRL
  { 369,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #369 = BCCTR
  { 370,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList10, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #370 = BCCTR8
  { 371,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList10, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #371 = BCCTR8n
  { 372,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList12, OperandInfo66, -1 ,nullptr },  // Inst #372 = BCCTRL
  { 373,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList13, ImplicitList14, OperandInfo66, -1 ,nullptr },  // Inst #373 = BCCTRL8
  { 374,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList13, ImplicitList14, OperandInfo66, -1 ,nullptr },  // Inst #374 = BCCTRL8n
  { 375,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList12, OperandInfo66, -1 ,nullptr },  // Inst #375 = BCCTRLn
  { 376,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #376 = BCCTRn
  { 377,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo67, -1 ,nullptr },  // Inst #377 = BCDCFNo
  { 378,	3,	1,	4,	168,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo67, -1 ,nullptr },  // Inst #378 = BCDCFSQo
  { 379,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo67, -1 ,nullptr },  // Inst #379 = BCDCFZo
  { 380,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #380 = BCDCPSGNo
  { 381,	2,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo69, -1 ,nullptr },  // Inst #381 = BCDCTNo
  { 382,	2,	1,	4,	166,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo69, -1 ,nullptr },  // Inst #382 = BCDCTSQo
  { 383,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo67, -1 ,nullptr },  // Inst #383 = BCDCTZo
  { 384,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo67, -1 ,nullptr },  // Inst #384 = BCDSETSGNo
  { 385,	4,	1,	4,	165,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo70, -1 ,nullptr },  // Inst #385 = BCDSRo
  { 386,	4,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo70, -1 ,nullptr },  // Inst #386 = BCDSo
  { 387,	4,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo70, -1 ,nullptr },  // Inst #387 = BCDTRUNCo
  { 388,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #388 = BCDUSo
  { 389,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #389 = BCDUTRUNCo
  { 390,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo63, -1 ,nullptr },  // Inst #390 = BCL
  { 391,	1,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList15, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #391 = BCLR
  { 392,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList15, ImplicitList12, OperandInfo66, -1 ,nullptr },  // Inst #392 = BCLRL
  { 393,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList15, ImplicitList12, OperandInfo66, -1 ,nullptr },  // Inst #393 = BCLRLn
  { 394,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #394 = BCLRn
  { 395,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo2, -1 ,nullptr },  // Inst #395 = BCLalways
  { 396,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo63, -1 ,nullptr },  // Inst #396 = BCLn
  { 397,	0,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, nullptr, nullptr, -1 ,nullptr },  // Inst #397 = BCTR
  { 398,	0,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList10, nullptr, nullptr, -1 ,nullptr },  // Inst #398 = BCTR8
  { 399,	0,	0,	4,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList11, ImplicitList12, nullptr, -1 ,nullptr },  // Inst #399 = BCTRL
  { 400,	0,	0,	4,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList13, ImplicitList14, nullptr, -1 ,nullptr },  // Inst #400 = BCTRL8
  { 401,	2,	0,	8,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList13, ImplicitList17, OperandInfo71, -1 ,nullptr },  // Inst #401 = BCTRL8_LDinto_toc
  { 402,	2,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator), 0x38ULL, nullptr, nullptr, OperandInfo63, -1 ,nullptr },  // Inst #402 = BCn
  { 403,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #403 = BDNZ
  { 404,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList10, ImplicitList10, OperandInfo2, -1 ,nullptr },  // Inst #404 = BDNZ8
  { 405,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #405 = BDNZA
  { 406,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #406 = BDNZAm
  { 407,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #407 = BDNZAp
  { 408,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #408 = BDNZL
  { 409,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #409 = BDNZLA
  { 410,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #410 = BDNZLAm
  { 411,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #411 = BDNZLAp
  { 412,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #412 = BDNZLR
  { 413,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList19, ImplicitList10, nullptr, -1 ,nullptr },  // Inst #413 = BDNZLR8
  { 414,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #414 = BDNZLRL
  { 415,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #415 = BDNZLRLm
  { 416,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #416 = BDNZLRLp
  { 417,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #417 = BDNZLRm
  { 418,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #418 = BDNZLRp
  { 419,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #419 = BDNZLm
  { 420,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #420 = BDNZLp
  { 421,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #421 = BDNZm
  { 422,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #422 = BDNZp
  { 423,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #423 = BDZ
  { 424,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList10, ImplicitList10, OperandInfo2, -1 ,nullptr },  // Inst #424 = BDZ8
  { 425,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #425 = BDZA
  { 426,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #426 = BDZAm
  { 427,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #427 = BDZAp
  { 428,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #428 = BDZL
  { 429,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #429 = BDZLA
  { 430,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #430 = BDZLAm
  { 431,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #431 = BDZLAp
  { 432,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #432 = BDZLR
  { 433,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList19, ImplicitList10, nullptr, -1 ,nullptr },  // Inst #433 = BDZLR8
  { 434,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #434 = BDZLRL
  { 435,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #435 = BDZLRLm
  { 436,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #436 = BDZLRLp
  { 437,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #437 = BDZLRm
  { 438,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, nullptr, -1 ,nullptr },  // Inst #438 = BDZLRp
  { 439,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #439 = BDZLm
  { 440,	1,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #440 = BDZLp
  { 441,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #441 = BDZm
  { 442,	1,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList9, ImplicitList9, OperandInfo2, -1 ,nullptr },  // Inst #442 = BDZp
  { 443,	1,	0,	4,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo72, -1 ,nullptr },  // Inst #443 = BL
  { 444,	1,	0,	4,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo72, -1 ,nullptr },  // Inst #444 = BL8
  { 445,	1,	0,	8,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo72, -1 ,nullptr },  // Inst #445 = BL8_NOP
  { 446,	2,	0,	8,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo7, -1 ,nullptr },  // Inst #446 = BL8_NOP_TLS
  { 447,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo7, -1 ,nullptr },  // Inst #447 = BL8_TLS
  { 448,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo7, -1 ,nullptr },  // Inst #448 = BL8_TLS_
  { 449,	1,	0,	4,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo2, -1 ,nullptr },  // Inst #449 = BLA
  { 450,	1,	0,	4,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo2, -1 ,nullptr },  // Inst #450 = BLA8
  { 451,	1,	0,	8,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList14, OperandInfo2, -1 ,nullptr },  // Inst #451 = BLA8_NOP
  { 452,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x38ULL, ImplicitList15, nullptr, nullptr, -1 ,nullptr },  // Inst #452 = BLR
  { 453,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator), 0x38ULL, ImplicitList20, nullptr, nullptr, -1 ,nullptr },  // Inst #453 = BLR8
  { 454,	0,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList15, ImplicitList12, nullptr, -1 ,nullptr },  // Inst #454 = BLRL
  { 455,	1,	0,	8,	287,	0|(1ULL<<MCID::Call), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo72, -1 ,nullptr },  // Inst #455 = BL_NOP
  { 456,	2,	0,	4,	287,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, ImplicitList12, OperandInfo7, -1 ,nullptr },  // Inst #456 = BL_TLS
  { 457,	3,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #457 = BPERMD
  { 458,	3,	1,	4,	291,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #458 = BRINC
  { 459,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #459 = CLRBHRB
  { 460,	3,	1,	4,	110,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #460 = CMPB
  { 461,	3,	1,	4,	110,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #461 = CMPB8
  { 462,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo73, -1 ,nullptr },  // Inst #462 = CMPD
  { 463,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo74, -1 ,nullptr },  // Inst #463 = CMPDI
  { 464,	3,	1,	4,	103,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo75, -1 ,nullptr },  // Inst #464 = CMPEQB
  { 465,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo73, -1 ,nullptr },  // Inst #465 = CMPLD
  { 466,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo74, -1 ,nullptr },  // Inst #466 = CMPLDI
  { 467,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo76, -1 ,nullptr },  // Inst #467 = CMPLW
  { 468,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo77, -1 ,nullptr },  // Inst #468 = CMPLWI
  { 469,	4,	1,	4,	103,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo78, -1 ,nullptr },  // Inst #469 = CMPRB
  { 470,	4,	1,	4,	103,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo78, -1 ,nullptr },  // Inst #470 = CMPRB8
  { 471,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo76, -1 ,nullptr },  // Inst #471 = CMPW
  { 472,	3,	1,	4,	114,	0|(1ULL<<MCID::Compare), 0x8ULL, nullptr, nullptr, OperandInfo77, -1 ,nullptr },  // Inst #472 = CMPWI
  { 473,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #473 = CNTLZD
  { 474,	2,	1,	4,	110,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #474 = CNTLZDo
  { 475,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #475 = CNTLZW
  { 476,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #476 = CNTLZW8
  { 477,	2,	1,	4,	110,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #477 = CNTLZW8o
  { 478,	2,	1,	4,	110,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo37, -1 ,nullptr },  // Inst #478 = CNTLZWo
  { 479,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #479 = CNTTZD
  { 480,	2,	1,	4,	110,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #480 = CNTTZDo
  { 481,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #481 = CNTTZW
  { 482,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #482 = CNTTZW8
  { 483,	2,	1,	4,	110,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #483 = CNTTZW8o
  { 484,	2,	1,	4,	110,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo37, -1 ,nullptr },  // Inst #484 = CNTTZWo
  { 485,	0,	0,	4,	183,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #485 = CP_ABORT
  { 486,	3,	0,	4,	176,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #486 = CP_COPY
  { 487,	3,	0,	4,	176,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #487 = CP_COPY8
  { 488,	3,	0,	4,	177,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #488 = CP_PASTE
  { 489,	3,	0,	4,	177,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #489 = CP_PASTE8
  { 490,	3,	0,	4,	203,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #490 = CP_PASTE8o
  { 491,	3,	0,	4,	203,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo36, -1 ,nullptr },  // Inst #491 = CP_PASTEo
  { 492,	0,	0,	4,	129,	0, 0x0ULL, nullptr, ImplicitList21, nullptr, -1 ,nullptr },  // Inst #492 = CR6SET
  { 493,	0,	0,	4,	129,	0, 0x0ULL, nullptr, ImplicitList21, nullptr, -1 ,nullptr },  // Inst #493 = CR6UNSET
  { 494,	3,	1,	4,	129,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #494 = CRAND
  { 495,	3,	1,	4,	129,	0, 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #495 = CRANDC
  { 496,	3,	1,	4,	129,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #496 = CREQV
  { 497,	3,	1,	4,	129,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #497 = CRNAND
  { 498,	3,	1,	4,	129,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #498 = CRNOR
  { 499,	3,	1,	4,	129,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #499 = CROR
  { 500,	3,	1,	4,	129,	0, 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #500 = CRORC
  { 501,	1,	1,	4,	129,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #501 = CRSET
  { 502,	1,	1,	4,	129,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo66, -1 ,nullptr },  // Inst #502 = CRUNSET
  { 503,	3,	1,	4,	129,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo79, -1 ,nullptr },  // Inst #503 = CRXOR
  { 504,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, nullptr, OperandInfo64, -1 ,nullptr },  // Inst #504 = CTRL_DEP
  { 505,	2,	1,	4,	181,	0, 0x8ULL, nullptr, nullptr, OperandInfo56, -1 ,nullptr },  // Inst #505 = DARN
  { 506,	2,	0,	4,	314,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #506 = DCBA
  { 507,	3,	0,	4,	175,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #507 = DCBF
  { 508,	2,	0,	4,	175,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #508 = DCBFEP
  { 509,	2,	0,	4,	314,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #509 = DCBI
  { 510,	2,	0,	4,	175,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #510 = DCBST
  { 511,	2,	0,	4,	175,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #511 = DCBSTEP
  { 512,	3,	0,	4,	175,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #512 = DCBT
  { 513,	3,	0,	4,	175,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #513 = DCBTEP
  { 514,	3,	0,	4,	175,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x2ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #514 = DCBTST
  { 515,	3,	0,	4,	175,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo39, -1 ,nullptr },  // Inst #515 = DCBTSTEP
  { 516,	2,	0,	4,	175,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #516 = DCBZ
  { 517,	2,	0,	4,	175,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #517 = DCBZEP
  { 518,	2,	0,	4,	175,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #518 = DCBZL
  { 519,	2,	0,	4,	175,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #519 = DCBZLEP
  { 520,	2,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #520 = DCCCI
  { 521,	3,	1,	4,	238,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #521 = DIVD
  { 522,	3,	1,	4,	239,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #522 = DIVDE
  { 523,	3,	1,	4,	239,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #523 = DIVDEU
  { 524,	3,	1,	4,	243,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #524 = DIVDEUo
  { 525,	3,	1,	4,	243,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #525 = DIVDEo
  { 526,	3,	1,	4,	238,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #526 = DIVDU
  { 527,	3,	1,	4,	241,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #527 = DIVDUo
  { 528,	3,	1,	4,	241,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #528 = DIVDo
  { 529,	3,	1,	4,	236,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #529 = DIVW
  { 530,	3,	1,	4,	237,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #530 = DIVWE
  { 531,	3,	1,	4,	237,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #531 = DIVWEU
  { 532,	3,	1,	4,	242,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #532 = DIVWEUo
  { 533,	3,	1,	4,	242,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #533 = DIVWEo
  { 534,	3,	1,	4,	236,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #534 = DIVWU
  { 535,	3,	1,	4,	240,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #535 = DIVWUo
  { 536,	3,	1,	4,	240,	0, 0xdULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #536 = DIVWo
  { 537,	1,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, PPC::DeprecatedDST ,nullptr },  // Inst #537 = DSS
  { 538,	0,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, PPC::DeprecatedDST ,nullptr },  // Inst #538 = DSSALL
  { 539,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo81, PPC::DeprecatedDST ,nullptr },  // Inst #539 = DST
  { 540,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo82, PPC::DeprecatedDST ,nullptr },  // Inst #540 = DST64
  { 541,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo81, PPC::DeprecatedDST ,nullptr },  // Inst #541 = DSTST
  { 542,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo82, PPC::DeprecatedDST ,nullptr },  // Inst #542 = DSTST64
  { 543,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo81, PPC::DeprecatedDST ,nullptr },  // Inst #543 = DSTSTT
  { 544,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo82, PPC::DeprecatedDST ,nullptr },  // Inst #544 = DSTSTT64
  { 545,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo81, PPC::DeprecatedDST ,nullptr },  // Inst #545 = DSTT
  { 546,	3,	0,	4,	299,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo82, PPC::DeprecatedDST ,nullptr },  // Inst #546 = DSTT64
  { 547,	4,	1,	4,	0,	0, 0x0ULL, ImplicitList8, ImplicitList8, OperandInfo83, -1 ,nullptr },  // Inst #547 = DYNALLOC
  { 548,	4,	1,	4,	0,	0, 0x0ULL, ImplicitList22, ImplicitList22, OperandInfo84, -1 ,nullptr },  // Inst #548 = DYNALLOC8
  { 549,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo85, -1 ,nullptr },  // Inst #549 = DYNAREAOFFSET
  { 550,	3,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo85, -1 ,nullptr },  // Inst #550 = DYNAREAOFFSET8
  { 551,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #551 = EFDABS
  { 552,	3,	1,	4,	17,	0, 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #552 = EFDADD
  { 553,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #553 = EFDCFS
  { 554,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #554 = EFDCFSF
  { 555,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo89, -1 ,nullptr },  // Inst #555 = EFDCFSI
  { 556,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo89, -1 ,nullptr },  // Inst #556 = EFDCFSID
  { 557,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #557 = EFDCFUF
  { 558,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo89, -1 ,nullptr },  // Inst #558 = EFDCFUI
  { 559,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo89, -1 ,nullptr },  // Inst #559 = EFDCFUID
  { 560,	3,	1,	4,	16,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #560 = EFDCMPEQ
  { 561,	3,	1,	4,	16,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #561 = EFDCMPGT
  { 562,	3,	1,	4,	16,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #562 = EFDCMPLT
  { 563,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #563 = EFDCTSF
  { 564,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #564 = EFDCTSI
  { 565,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #565 = EFDCTSIDZ
  { 566,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #566 = EFDCTSIZ
  { 567,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #567 = EFDCTUF
  { 568,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #568 = EFDCTUI
  { 569,	2,	1,	4,	16,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #569 = EFDCTUIDZ
  { 570,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo91, -1 ,nullptr },  // Inst #570 = EFDCTUIZ
  { 571,	3,	1,	4,	18,	0, 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #571 = EFDDIV
  { 572,	3,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #572 = EFDMUL
  { 573,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #573 = EFDNABS
  { 574,	2,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #574 = EFDNEG
  { 575,	3,	1,	4,	16,	0, 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #575 = EFDSUB
  { 576,	3,	1,	4,	16,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #576 = EFDTSTEQ
  { 577,	3,	1,	4,	16,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #577 = EFDTSTGT
  { 578,	3,	1,	4,	16,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #578 = EFDTSTLT
  { 579,	2,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #579 = EFSABS
  { 580,	3,	1,	4,	17,	0, 0x0ULL, nullptr, nullptr, OperandInfo93, -1 ,nullptr },  // Inst #580 = EFSADD
  { 581,	2,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo94, -1 ,nullptr },  // Inst #581 = EFSCFD
  { 582,	2,	1,	4,	19,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #582 = EFSCFSF
  { 583,	2,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo95, -1 ,nullptr },  // Inst #583 = EFSCFSI
  { 584,	2,	1,	4,	19,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #584 = EFSCFUF
  { 585,	2,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo95, -1 ,nullptr },  // Inst #585 = EFSCFUI
  { 586,	3,	1,	4,	20,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo96, -1 ,nullptr },  // Inst #586 = EFSCMPEQ
  { 587,	3,	1,	4,	20,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo96, -1 ,nullptr },  // Inst #587 = EFSCMPGT
  { 588,	3,	1,	4,	20,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo96, -1 ,nullptr },  // Inst #588 = EFSCMPLT
  { 589,	2,	1,	4,	19,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #589 = EFSCTSF
  { 590,	2,	1,	4,	19,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #590 = EFSCTSI
  { 591,	2,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #591 = EFSCTSIZ
  { 592,	2,	1,	4,	19,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo88, -1 ,nullptr },  // Inst #592 = EFSCTUF
  { 593,	2,	1,	4,	19,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #593 = EFSCTUI
  { 594,	2,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo97, -1 ,nullptr },  // Inst #594 = EFSCTUIZ
  { 595,	3,	1,	4,	18,	0, 0x0ULL, nullptr, nullptr, OperandInfo93, -1 ,nullptr },  // Inst #595 = EFSDIV
  { 596,	3,	1,	4,	21,	0, 0x0ULL, nullptr, nullptr, OperandInfo93, -1 ,nullptr },  // Inst #596 = EFSMUL
  { 597,	2,	1,	4,	21,	0, 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #597 = EFSNABS
  { 598,	2,	1,	4,	21,	0, 0x0ULL, nullptr, nullptr, OperandInfo92, -1 ,nullptr },  // Inst #598 = EFSNEG
  { 599,	3,	1,	4,	19,	0, 0x0ULL, nullptr, nullptr, OperandInfo93, -1 ,nullptr },  // Inst #599 = EFSSUB
  { 600,	3,	1,	4,	20,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #600 = EFSTSTEQ
  { 601,	3,	1,	4,	20,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #601 = EFSTSTGT
  { 602,	3,	1,	4,	20,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #602 = EFSTSTLT
  { 603,	1,	0,	4,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #603 = EH_SjLj_LongJmp32
  { 604,	1,	0,	4,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo98, -1 ,nullptr },  // Inst #604 = EH_SjLj_LongJmp64
  { 605,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList9, OperandInfo99, -1 ,nullptr },  // Inst #605 = EH_SjLj_SetJmp32
  { 606,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList10, OperandInfo99, -1 ,nullptr },  // Inst #606 = EH_SjLj_SetJmp64
  { 607,	1,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #607 = EH_SjLj_Setup
  { 608,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #608 = EQV
  { 609,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #609 = EQV8
  { 610,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #610 = EQV8o
  { 611,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #611 = EQVo
  { 612,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #612 = EVABS
  { 613,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo100, -1 ,nullptr },  // Inst #613 = EVADDIW
  { 614,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #614 = EVADDSMIAAW
  { 615,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #615 = EVADDSSIAAW
  { 616,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #616 = EVADDUMIAAW
  { 617,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #617 = EVADDUSIAAW
  { 618,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #618 = EVADDW
  { 619,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #619 = EVAND
  { 620,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #620 = EVANDC
  { 621,	3,	1,	4,	292,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #621 = EVCMPEQ
  { 622,	3,	1,	4,	292,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #622 = EVCMPGTS
  { 623,	3,	1,	4,	292,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #623 = EVCMPGTU
  { 624,	3,	1,	4,	292,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #624 = EVCMPLTS
  { 625,	3,	1,	4,	292,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #625 = EVCMPLTU
  { 626,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #626 = EVCNTLSW
  { 627,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #627 = EVCNTLZW
  { 628,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #628 = EVDIVWS
  { 629,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #629 = EVDIVWU
  { 630,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #630 = EVEQV
  { 631,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #631 = EVEXTSB
  { 632,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #632 = EVEXTSH
  { 633,	2,	1,	4,	22,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #633 = EVFSABS
  { 634,	3,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #634 = EVFSADD
  { 635,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #635 = EVFSCFSF
  { 636,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #636 = EVFSCFSI
  { 637,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #637 = EVFSCFUF
  { 638,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #638 = EVFSCFUI
  { 639,	3,	1,	4,	19,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #639 = EVFSCMPEQ
  { 640,	3,	1,	4,	19,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #640 = EVFSCMPGT
  { 641,	3,	1,	4,	19,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #641 = EVFSCMPLT
  { 642,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #642 = EVFSCTSF
  { 643,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #643 = EVFSCTSI
  { 644,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #644 = EVFSCTSIZ
  { 645,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #645 = EVFSCTUF
  { 646,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #646 = EVFSCTUI
  { 647,	2,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #647 = EVFSCTUIZ
  { 648,	3,	1,	4,	18,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #648 = EVFSDIV
  { 649,	3,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #649 = EVFSMUL
  { 650,	2,	1,	4,	22,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #650 = EVFSNABS
  { 651,	2,	1,	4,	22,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #651 = EVFSNEG
  { 652,	3,	1,	4,	23,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #652 = EVFSSUB
  { 653,	3,	1,	4,	22,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #653 = EVFSTSTEQ
  { 654,	3,	1,	4,	22,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #654 = EVFSTSTGT
  { 655,	3,	1,	4,	22,	0|(1ULL<<MCID::Compare)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo90, -1 ,nullptr },  // Inst #655 = EVFSTSTLT
  { 656,	3,	1,	4,	294,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #656 = EVLDD
  { 657,	3,	1,	4,	294,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #657 = EVLDDX
  { 658,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #658 = EVLDH
  { 659,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #659 = EVLDHX
  { 660,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #660 = EVLDW
  { 661,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #661 = EVLDWX
  { 662,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #662 = EVLHHESPLAT
  { 663,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #663 = EVLHHESPLATX
  { 664,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #664 = EVLHHOSSPLAT
  { 665,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #665 = EVLHHOSSPLATX
  { 666,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #666 = EVLHHOUSPLAT
  { 667,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #667 = EVLHHOUSPLATX
  { 668,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #668 = EVLWHE
  { 669,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #669 = EVLWHEX
  { 670,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #670 = EVLWHOS
  { 671,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #671 = EVLWHOSX
  { 672,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #672 = EVLWHOU
  { 673,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #673 = EVLWHOUX
  { 674,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #674 = EVLWHSPLAT
  { 675,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #675 = EVLWHSPLATX
  { 676,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #676 = EVLWWSPLAT
  { 677,	3,	1,	4,	294,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #677 = EVLWWSPLATX
  { 678,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #678 = EVMERGEHI
  { 679,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #679 = EVMERGEHILO
  { 680,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo103, -1 ,nullptr },  // Inst #680 = EVMERGELO
  { 681,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #681 = EVMERGELOHI
  { 682,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #682 = EVMHEGSMFAA
  { 683,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #683 = EVMHEGSMFAN
  { 684,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #684 = EVMHEGSMIAA
  { 685,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #685 = EVMHEGSMIAN
  { 686,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #686 = EVMHEGUMIAA
  { 687,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #687 = EVMHEGUMIAN
  { 688,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #688 = EVMHESMF
  { 689,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #689 = EVMHESMFA
  { 690,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #690 = EVMHESMFAAW
  { 691,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #691 = EVMHESMFANW
  { 692,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #692 = EVMHESMI
  { 693,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #693 = EVMHESMIA
  { 694,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #694 = EVMHESMIAAW
  { 695,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #695 = EVMHESMIANW
  { 696,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #696 = EVMHESSF
  { 697,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #697 = EVMHESSFA
  { 698,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #698 = EVMHESSFAAW
  { 699,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #699 = EVMHESSFANW
  { 700,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #700 = EVMHESSIAAW
  { 701,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #701 = EVMHESSIANW
  { 702,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #702 = EVMHEUMI
  { 703,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #703 = EVMHEUMIA
  { 704,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #704 = EVMHEUMIAAW
  { 705,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #705 = EVMHEUMIANW
  { 706,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #706 = EVMHEUSIAAW
  { 707,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #707 = EVMHEUSIANW
  { 708,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #708 = EVMHOGSMFAA
  { 709,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #709 = EVMHOGSMFAN
  { 710,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #710 = EVMHOGSMIAA
  { 711,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #711 = EVMHOGSMIAN
  { 712,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #712 = EVMHOGUMIAA
  { 713,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #713 = EVMHOGUMIAN
  { 714,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #714 = EVMHOSMF
  { 715,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #715 = EVMHOSMFA
  { 716,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #716 = EVMHOSMFAAW
  { 717,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #717 = EVMHOSMFANW
  { 718,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #718 = EVMHOSMI
  { 719,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #719 = EVMHOSMIA
  { 720,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #720 = EVMHOSMIAAW
  { 721,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #721 = EVMHOSMIANW
  { 722,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #722 = EVMHOSSF
  { 723,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #723 = EVMHOSSFA
  { 724,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #724 = EVMHOSSFAAW
  { 725,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #725 = EVMHOSSFANW
  { 726,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #726 = EVMHOSSIAAW
  { 727,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #727 = EVMHOSSIANW
  { 728,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #728 = EVMHOUMI
  { 729,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #729 = EVMHOUMIA
  { 730,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #730 = EVMHOUMIAAW
  { 731,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #731 = EVMHOUMIANW
  { 732,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #732 = EVMHOUSIAAW
  { 733,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #733 = EVMHOUSIANW
  { 734,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #734 = EVMRA
  { 735,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #735 = EVMWHSMF
  { 736,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #736 = EVMWHSMFA
  { 737,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #737 = EVMWHSMI
  { 738,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #738 = EVMWHSMIA
  { 739,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #739 = EVMWHSSF
  { 740,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #740 = EVMWHSSFA
  { 741,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #741 = EVMWHUMI
  { 742,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #742 = EVMWHUMIA
  { 743,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #743 = EVMWLSMIAAW
  { 744,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #744 = EVMWLSMIANW
  { 745,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #745 = EVMWLSSIAAW
  { 746,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #746 = EVMWLSSIANW
  { 747,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #747 = EVMWLUMI
  { 748,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #748 = EVMWLUMIA
  { 749,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #749 = EVMWLUMIAAW
  { 750,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #750 = EVMWLUMIANW
  { 751,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #751 = EVMWLUSIAAW
  { 752,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #752 = EVMWLUSIANW
  { 753,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #753 = EVMWSMF
  { 754,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #754 = EVMWSMFA
  { 755,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #755 = EVMWSMFAA
  { 756,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #756 = EVMWSMFAN
  { 757,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #757 = EVMWSMI
  { 758,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #758 = EVMWSMIA
  { 759,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #759 = EVMWSMIAA
  { 760,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #760 = EVMWSMIAN
  { 761,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #761 = EVMWSSF
  { 762,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #762 = EVMWSSFA
  { 763,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #763 = EVMWSSFAA
  { 764,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #764 = EVMWSSFAN
  { 765,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #765 = EVMWUMI
  { 766,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #766 = EVMWUMIA
  { 767,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #767 = EVMWUMIAA
  { 768,	3,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #768 = EVMWUMIAN
  { 769,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #769 = EVNAND
  { 770,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #770 = EVNEG
  { 771,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #771 = EVNOR
  { 772,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #772 = EVOR
  { 773,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #773 = EVORC
  { 774,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #774 = EVRLW
  { 775,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo100, -1 ,nullptr },  // Inst #775 = EVRLWI
  { 776,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #776 = EVRNDW
  { 777,	4,	1,	4,	22,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo104, -1 ,nullptr },  // Inst #777 = EVSEL
  { 778,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #778 = EVSLW
  { 779,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo100, -1 ,nullptr },  // Inst #779 = EVSLWI
  { 780,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #780 = EVSPLATFI
  { 781,	2,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo105, -1 ,nullptr },  // Inst #781 = EVSPLATI
  { 782,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo100, -1 ,nullptr },  // Inst #782 = EVSRWIS
  { 783,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo100, -1 ,nullptr },  // Inst #783 = EVSRWIU
  { 784,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #784 = EVSRWS
  { 785,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #785 = EVSRWU
  { 786,	3,	0,	4,	295,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #786 = EVSTDD
  { 787,	3,	0,	4,	295,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #787 = EVSTDDX
  { 788,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #788 = EVSTDH
  { 789,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #789 = EVSTDHX
  { 790,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #790 = EVSTDW
  { 791,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #791 = EVSTDWX
  { 792,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #792 = EVSTWHE
  { 793,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #793 = EVSTWHEX
  { 794,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #794 = EVSTWHO
  { 795,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #795 = EVSTWHOX
  { 796,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #796 = EVSTWWE
  { 797,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #797 = EVSTWWEX
  { 798,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo101, -1 ,nullptr },  // Inst #798 = EVSTWWO
  { 799,	3,	0,	4,	295,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo102, -1 ,nullptr },  // Inst #799 = EVSTWWOX
  { 800,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #800 = EVSUBFSMIAAW
  { 801,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #801 = EVSUBFSSIAAW
  { 802,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #802 = EVSUBFUMIAAW
  { 803,	2,	1,	4,	293,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo86, -1 ,nullptr },  // Inst #803 = EVSUBFUSIAAW
  { 804,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #804 = EVSUBFW
  { 805,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo106, -1 ,nullptr },  // Inst #805 = EVSUBIFW
  { 806,	3,	1,	4,	292,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo87, -1 ,nullptr },  // Inst #806 = EVXOR
  { 807,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #807 = EXTSB
  { 808,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #808 = EXTSB8
  { 809,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #809 = EXTSB8_32_64
  { 810,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #810 = EXTSB8o
  { 811,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo37, -1 ,nullptr },  // Inst #811 = EXTSBo
  { 812,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #812 = EXTSH
  { 813,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #813 = EXTSH8
  { 814,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #814 = EXTSH8_32_64
  { 815,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #815 = EXTSH8o
  { 816,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo37, -1 ,nullptr },  // Inst #816 = EXTSHo
  { 817,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #817 = EXTSW
  { 818,	3,	1,	4,	112,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo35, -1 ,nullptr },  // Inst #818 = EXTSWSLI
  { 819,	3,	1,	4,	112,	0, 0x8ULL, nullptr, nullptr, OperandInfo108, -1 ,nullptr },  // Inst #819 = EXTSWSLI_32_64
  { 820,	3,	1,	4,	257,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo108, -1 ,nullptr },  // Inst #820 = EXTSWSLI_32_64o
  { 821,	3,	1,	4,	257,	0, 0x8ULL, nullptr, ImplicitList5, OperandInfo35, -1 ,nullptr },  // Inst #821 = EXTSWSLIo
  { 822,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #822 = EXTSW_32
  { 823,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo107, -1 ,nullptr },  // Inst #823 = EXTSW_32_64
  { 824,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo107, -1 ,nullptr },  // Inst #824 = EXTSW_32_64o
  { 825,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #825 = EXTSWo
  { 826,	0,	0,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #826 = EnforceIEIO
  { 827,	2,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #827 = FABSD
  { 828,	2,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #828 = FABSDo
  { 829,	2,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #829 = FABSS
  { 830,	2,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #830 = FABSSo
  { 831,	3,	1,	4,	149,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #831 = FADD
  { 832,	3,	1,	4,	148,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #832 = FADDS
  { 833,	3,	1,	4,	156,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo112, -1 ,nullptr },  // Inst #833 = FADDSo
  { 834,	3,	1,	4,	157,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo111, -1 ,nullptr },  // Inst #834 = FADDo
  { 835,	3,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #835 = FADDrtz
  { 836,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #836 = FCFID
  { 837,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #837 = FCFIDS
  { 838,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo113, -1 ,nullptr },  // Inst #838 = FCFIDSo
  { 839,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #839 = FCFIDU
  { 840,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #840 = FCFIDUS
  { 841,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo113, -1 ,nullptr },  // Inst #841 = FCFIDUSo
  { 842,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #842 = FCFIDUo
  { 843,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #843 = FCFIDo
  { 844,	3,	1,	4,	106,	0|(1ULL<<MCID::Compare), 0x18ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #844 = FCMPUD
  { 845,	3,	1,	4,	106,	0|(1ULL<<MCID::Compare), 0x18ULL, nullptr, nullptr, OperandInfo115, -1 ,nullptr },  // Inst #845 = FCMPUS
  { 846,	3,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #846 = FCPSGND
  { 847,	3,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo111, -1 ,nullptr },  // Inst #847 = FCPSGNDo
  { 848,	3,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #848 = FCPSGNS
  { 849,	3,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo112, -1 ,nullptr },  // Inst #849 = FCPSGNSo
  { 850,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #850 = FCTID
  { 851,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #851 = FCTIDU
  { 852,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #852 = FCTIDUZ
  { 853,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #853 = FCTIDUZo
  { 854,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #854 = FCTIDUo
  { 855,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #855 = FCTIDZ
  { 856,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #856 = FCTIDZo
  { 857,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #857 = FCTIDo
  { 858,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #858 = FCTIW
  { 859,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #859 = FCTIWU
  { 860,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #860 = FCTIWUZ
  { 861,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #861 = FCTIWUZo
  { 862,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #862 = FCTIWUo
  { 863,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #863 = FCTIWZ
  { 864,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #864 = FCTIWZo
  { 865,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #865 = FCTIWo
  { 866,	3,	1,	4,	259,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #866 = FDIV
  { 867,	3,	1,	4,	270,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #867 = FDIVS
  { 868,	3,	1,	4,	271,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo112, -1 ,nullptr },  // Inst #868 = FDIVSo
  { 869,	3,	1,	4,	260,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo111, -1 ,nullptr },  // Inst #869 = FDIVo
  { 870,	4,	1,	4,	150,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #870 = FMADD
  { 871,	4,	1,	4,	148,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #871 = FMADDS
  { 872,	4,	1,	4,	156,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo117, -1 ,nullptr },  // Inst #872 = FMADDSo
  { 873,	4,	1,	4,	158,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo116, -1 ,nullptr },  // Inst #873 = FMADDo
  { 874,	2,	1,	4,	131,	0, 0x0ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #874 = FMR
  { 875,	2,	1,	4,	246,	0, 0x0ULL, nullptr, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #875 = FMRo
  { 876,	4,	1,	4,	150,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #876 = FMSUB
  { 877,	4,	1,	4,	148,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #877 = FMSUBS
  { 878,	4,	1,	4,	156,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo117, -1 ,nullptr },  // Inst #878 = FMSUBSo
  { 879,	4,	1,	4,	158,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo116, -1 ,nullptr },  // Inst #879 = FMSUBo
  { 880,	3,	1,	4,	150,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #880 = FMUL
  { 881,	3,	1,	4,	148,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #881 = FMULS
  { 882,	3,	1,	4,	156,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo112, -1 ,nullptr },  // Inst #882 = FMULSo
  { 883,	3,	1,	4,	158,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo111, -1 ,nullptr },  // Inst #883 = FMULo
  { 884,	2,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #884 = FNABSD
  { 885,	2,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #885 = FNABSDo
  { 886,	2,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #886 = FNABSS
  { 887,	2,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #887 = FNABSSo
  { 888,	2,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #888 = FNEGD
  { 889,	2,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #889 = FNEGDo
  { 890,	2,	1,	4,	131,	0, 0x18ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #890 = FNEGS
  { 891,	2,	1,	4,	246,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #891 = FNEGSo
  { 892,	4,	1,	4,	150,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #892 = FNMADD
  { 893,	4,	1,	4,	148,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #893 = FNMADDS
  { 894,	4,	1,	4,	156,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo117, -1 ,nullptr },  // Inst #894 = FNMADDSo
  { 895,	4,	1,	4,	158,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo116, -1 ,nullptr },  // Inst #895 = FNMADDo
  { 896,	4,	1,	4,	150,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #896 = FNMSUB
  { 897,	4,	1,	4,	148,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, nullptr, OperandInfo117, -1 ,nullptr },  // Inst #897 = FNMSUBS
  { 898,	4,	1,	4,	156,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo117, -1 ,nullptr },  // Inst #898 = FNMSUBSo
  { 899,	4,	1,	4,	158,	0|(1ULL<<MCID::Commutable), 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo116, -1 ,nullptr },  // Inst #899 = FNMSUBo
  { 900,	2,	1,	4,	148,	0, 0x18ULL, nullptr, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #900 = FRE
  { 901,	2,	1,	4,	148,	0, 0x18ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #901 = FRES
  { 902,	2,	1,	4,	156,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #902 = FRESo
  { 903,	2,	1,	4,	156,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #903 = FREo
  { 904,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #904 = FRIMD
  { 905,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #905 = FRIMDo
  { 906,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #906 = FRIMS
  { 907,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #907 = FRIMSo
  { 908,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #908 = FRIND
  { 909,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #909 = FRINDo
  { 910,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #910 = FRINS
  { 911,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #911 = FRINSo
  { 912,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #912 = FRIPD
  { 913,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #913 = FRIPDo
  { 914,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #914 = FRIPS
  { 915,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #915 = FRIPSo
  { 916,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #916 = FRIZD
  { 917,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #917 = FRIZDo
  { 918,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #918 = FRIZS
  { 919,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #919 = FRIZSo
  { 920,	2,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo113, -1 ,nullptr },  // Inst #920 = FRSP
  { 921,	2,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo113, -1 ,nullptr },  // Inst #921 = FRSPo
  { 922,	2,	1,	4,	148,	0, 0x18ULL, nullptr, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #922 = FRSQRTE
  { 923,	2,	1,	4,	148,	0, 0x18ULL, nullptr, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #923 = FRSQRTES
  { 924,	2,	1,	4,	156,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #924 = FRSQRTESo
  { 925,	2,	1,	4,	156,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #925 = FRSQRTEo
  { 926,	4,	1,	4,	148,	0, 0x18ULL, nullptr, nullptr, OperandInfo116, -1 ,nullptr },  // Inst #926 = FSELD
  { 927,	4,	1,	4,	152,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo116, -1 ,nullptr },  // Inst #927 = FSELDo
  { 928,	4,	1,	4,	148,	0, 0x18ULL, nullptr, nullptr, OperandInfo118, -1 ,nullptr },  // Inst #928 = FSELS
  { 929,	4,	1,	4,	152,	0, 0x18ULL, nullptr, ImplicitList23, OperandInfo118, -1 ,nullptr },  // Inst #929 = FSELSo
  { 930,	2,	1,	4,	262,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #930 = FSQRT
  { 931,	2,	1,	4,	267,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo110, -1 ,nullptr },  // Inst #931 = FSQRTS
  { 932,	2,	1,	4,	268,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo110, -1 ,nullptr },  // Inst #932 = FSQRTSo
  { 933,	2,	1,	4,	265,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo109, -1 ,nullptr },  // Inst #933 = FSQRTo
  { 934,	3,	1,	4,	149,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo111, -1 ,nullptr },  // Inst #934 = FSUB
  { 935,	3,	1,	4,	148,	0, 0x18ULL, ImplicitList2, nullptr, OperandInfo112, -1 ,nullptr },  // Inst #935 = FSUBS
  { 936,	3,	1,	4,	156,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo112, -1 ,nullptr },  // Inst #936 = FSUBSo
  { 937,	3,	1,	4,	157,	0, 0x18ULL, ImplicitList2, ImplicitList23, OperandInfo111, -1 ,nullptr },  // Inst #937 = FSUBo
  { 938,	3,	1,	4,	106,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x18ULL, nullptr, nullptr, OperandInfo114, -1 ,nullptr },  // Inst #938 = FTDIV
  { 939,	2,	1,	4,	106,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x18ULL, nullptr, nullptr, OperandInfo119, -1 ,nullptr },  // Inst #939 = FTSQRT
  { 940,	3,	1,	8,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList24, OperandInfo35, -1 ,nullptr },  // Inst #940 = GETtlsADDR
  { 941,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList25, OperandInfo36, -1 ,nullptr },  // Inst #941 = GETtlsADDR32
  { 942,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList24, OperandInfo35, -1 ,nullptr },  // Inst #942 = GETtlsldADDR
  { 943,	3,	1,	4,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList25, OperandInfo36, -1 ,nullptr },  // Inst #943 = GETtlsldADDR32
  { 944,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #944 = HRFID
  { 945,	2,	0,	4,	178,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #945 = ICBI
  { 946,	2,	0,	4,	178,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo38, -1 ,nullptr },  // Inst #946 = ICBIEP
  { 947,	3,	0,	4,	300,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #947 = ICBLC
  { 948,	3,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #948 = ICBLQ
  { 949,	3,	0,	4,	179,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #949 = ICBT
  { 950,	3,	0,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo80, -1 ,nullptr },  // Inst #950 = ICBTLS
  { 951,	2,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #951 = ICCCI
  { 952,	4,	1,	4,	133,	0|(1ULL<<MCID::Select), 0x8ULL, nullptr, nullptr, OperandInfo120, -1 ,nullptr },  // Inst #952 = ISEL
  { 953,	4,	1,	4,	133,	0|(1ULL<<MCID::Select), 0x8ULL, nullptr, nullptr, OperandInfo121, -1 ,nullptr },  // Inst #953 = ISEL8
  { 954,	0,	0,	4,	184,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #954 = ISYNC
  { 955,	3,	1,	4,	115,	0, 0x8ULL, nullptr, nullptr, OperandInfo52, -1 ,nullptr },  // Inst #955 = LA
  { 956,	3,	1,	4,	180,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #956 = LBARX
  { 957,	3,	1,	4,	180,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #957 = LBARXL
  { 958,	3,	1,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #958 = LBEPX
  { 959,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #959 = LBZ
  { 960,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #960 = LBZ8
  { 961,	3,	1,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #961 = LBZCIX
  { 962,	4,	2,	4,	280,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #962 = LBZU
  { 963,	4,	2,	4,	280,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #963 = LBZU8
  { 964,	4,	2,	4,	281,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo126, -1 ,nullptr },  // Inst #964 = LBZUX
  { 965,	4,	2,	4,	281,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #965 = LBZUX8
  { 966,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #966 = LBZX
  { 967,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #967 = LBZX8
  { 968,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #968 = LBZXTLS
  { 969,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #969 = LBZXTLS_
  { 970,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #970 = LBZXTLS_32
  { 971,	3,	1,	4,	181,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #971 = LD
  { 972,	3,	1,	4,	182,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #972 = LDARX
  { 973,	3,	1,	4,	182,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #973 = LDARXL
  { 974,	3,	1,	4,	289,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x80ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #974 = LDAT
  { 975,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #975 = LDBRX
  { 976,	3,	1,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #976 = LDCIX
  { 977,	3,	1,	4,	201,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #977 = LDMX
  { 978,	4,	2,	4,	282,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #978 = LDU
  { 979,	4,	2,	4,	283,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #979 = LDUX
  { 980,	3,	1,	4,	181,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #980 = LDX
  { 981,	3,	1,	4,	181,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #981 = LDXTLS
  { 982,	3,	1,	4,	181,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #982 = LDXTLS_
  { 983,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo131, -1 ,nullptr },  // Inst #983 = LDgotTprelL
  { 984,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo132, -1 ,nullptr },  // Inst #984 = LDgotTprelL32
  { 985,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo133, -1 ,nullptr },  // Inst #985 = LDtoc
  { 986,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo133, -1 ,nullptr },  // Inst #986 = LDtocBA
  { 987,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo133, -1 ,nullptr },  // Inst #987 = LDtocCPT
  { 988,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo133, -1 ,nullptr },  // Inst #988 = LDtocJTI
  { 989,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo131, -1 ,nullptr },  // Inst #989 = LDtocL
  { 990,	3,	1,	4,	189,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo134, -1 ,nullptr },  // Inst #990 = LFD
  { 991,	3,	1,	4,	301,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #991 = LFDEPX
  { 992,	4,	2,	4,	284,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo136, -1 ,nullptr },  // Inst #992 = LFDU
  { 993,	4,	2,	4,	285,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo137, -1 ,nullptr },  // Inst #993 = LFDUX
  { 994,	3,	1,	4,	189,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #994 = LFDX
  { 995,	3,	1,	4,	206,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #995 = LFIWAX
  { 996,	3,	1,	4,	189,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #996 = LFIWZX
  { 997,	3,	1,	4,	209,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo138, -1 ,nullptr },  // Inst #997 = LFS
  { 998,	4,	2,	4,	275,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo139, -1 ,nullptr },  // Inst #998 = LFSU
  { 999,	4,	2,	4,	276,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo140, -1 ,nullptr },  // Inst #999 = LFSUX
  { 1000,	3,	1,	4,	209,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo141, -1 ,nullptr },  // Inst #1000 = LFSX
  { 1001,	3,	1,	4,	202,	0|(1ULL<<MCID::MayLoad), 0x14ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1001 = LHA
  { 1002,	3,	1,	4,	202,	0|(1ULL<<MCID::MayLoad), 0x14ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1002 = LHA8
  { 1003,	3,	1,	4,	180,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1003 = LHARX
  { 1004,	3,	1,	4,	180,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1004 = LHARXL
  { 1005,	4,	2,	4,	212,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #1005 = LHAU
  { 1006,	4,	2,	4,	212,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #1006 = LHAU8
  { 1007,	4,	2,	4,	213,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo126, -1 ,nullptr },  // Inst #1007 = LHAUX
  { 1008,	4,	2,	4,	213,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #1008 = LHAUX8
  { 1009,	3,	1,	4,	202,	0|(1ULL<<MCID::MayLoad), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1009 = LHAX
  { 1010,	3,	1,	4,	202,	0|(1ULL<<MCID::MayLoad), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1010 = LHAX8
  { 1011,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1011 = LHBRX
  { 1012,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1012 = LHBRX8
  { 1013,	3,	1,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1013 = LHEPX
  { 1014,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1014 = LHZ
  { 1015,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1015 = LHZ8
  { 1016,	3,	1,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1016 = LHZCIX
  { 1017,	4,	2,	4,	196,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #1017 = LHZU
  { 1018,	4,	2,	4,	196,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #1018 = LHZU8
  { 1019,	4,	2,	4,	197,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo126, -1 ,nullptr },  // Inst #1019 = LHZUX
  { 1020,	4,	2,	4,	197,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #1020 = LHZUX8
  { 1021,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1021 = LHZX
  { 1022,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1022 = LHZX8
  { 1023,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1023 = LHZXTLS
  { 1024,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1024 = LHZXTLS_
  { 1025,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #1025 = LHZXTLS_32
  { 1026,	2,	1,	4,	116,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x8ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #1026 = LI
  { 1027,	2,	1,	4,	116,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x8ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1027 = LI8
  { 1028,	2,	1,	4,	116,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x8ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #1028 = LIS
  { 1029,	2,	1,	4,	116,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x8ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1029 = LIS8
  { 1030,	3,	1,	4,	188,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1030 = LMW
  { 1031,	3,	1,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1031 = LSWI
  { 1032,	3,	1,	4,	172,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1032 = LVEBX
  { 1033,	3,	1,	4,	172,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1033 = LVEHX
  { 1034,	3,	1,	4,	172,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1034 = LVEWX
  { 1035,	3,	1,	4,	160,	0, 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1035 = LVSL
  { 1036,	3,	1,	4,	160,	0, 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1036 = LVSR
  { 1037,	3,	1,	4,	172,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1037 = LVX
  { 1038,	3,	1,	4,	172,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1038 = LVXL
  { 1039,	3,	1,	4,	204,	0|(1ULL<<MCID::MayLoad), 0x14ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1039 = LWA
  { 1040,	3,	1,	4,	180,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1040 = LWARX
  { 1041,	3,	1,	4,	180,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1041 = LWARXL
  { 1042,	3,	1,	4,	289,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x80ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1042 = LWAT
  { 1043,	4,	2,	4,	213,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #1043 = LWAUX
  { 1044,	3,	1,	4,	202,	0|(1ULL<<MCID::MayLoad), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1044 = LWAX
  { 1045,	3,	1,	4,	202,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1045 = LWAX_32
  { 1046,	3,	1,	4,	204,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x14ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1046 = LWA_32
  { 1047,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1047 = LWBRX
  { 1048,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1048 = LWBRX8
  { 1049,	3,	1,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1049 = LWEPX
  { 1050,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1050 = LWZ
  { 1051,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1051 = LWZ8
  { 1052,	3,	1,	4,	179,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1052 = LWZCIX
  { 1053,	4,	2,	4,	196,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo124, -1 ,nullptr },  // Inst #1053 = LWZU
  { 1054,	4,	2,	4,	196,	0|(1ULL<<MCID::MayLoad), 0x10ULL, nullptr, nullptr, OperandInfo125, -1 ,nullptr },  // Inst #1054 = LWZU8
  { 1055,	4,	2,	4,	197,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo126, -1 ,nullptr },  // Inst #1055 = LWZUX
  { 1056,	4,	2,	4,	197,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo127, -1 ,nullptr },  // Inst #1056 = LWZUX8
  { 1057,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1057 = LWZX
  { 1058,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x90ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1058 = LWZX8
  { 1059,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1059 = LWZXTLS
  { 1060,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1060 = LWZXTLS_
  { 1061,	3,	1,	4,	179,	0|(1ULL<<MCID::MayLoad), 0x8ULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #1061 = LWZXTLS_32
  { 1062,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo144, -1 ,nullptr },  // Inst #1062 = LWZtoc
  { 1063,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #1063 = LXSD
  { 1064,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1064 = LXSDX
  { 1065,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1065 = LXSIBZX
  { 1066,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1066 = LXSIHZX
  { 1067,	3,	1,	4,	207,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1067 = LXSIWAX
  { 1068,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1068 = LXSIWZX
  { 1069,	3,	1,	4,	210,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #1069 = LXSSP
  { 1070,	3,	1,	4,	210,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1070 = LXSSPX
  { 1071,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo146, -1 ,nullptr },  // Inst #1071 = LXV
  { 1072,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1072 = LXVB16X
  { 1073,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1073 = LXVD2X
  { 1074,	3,	1,	4,	214,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1074 = LXVDSX
  { 1075,	3,	1,	4,	214,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1075 = LXVH8X
  { 1076,	3,	1,	4,	171,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo148, -1 ,nullptr },  // Inst #1076 = LXVL
  { 1077,	3,	1,	4,	171,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo148, -1 ,nullptr },  // Inst #1077 = LXVLL
  { 1078,	3,	1,	4,	214,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1078 = LXVW4X
  { 1079,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1079 = LXVWSX
  { 1080,	3,	1,	4,	173,	0|(1ULL<<MCID::MayLoad), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1080 = LXVX
  { 1081,	4,	1,	4,	144,	0, 0x8ULL, nullptr, nullptr, OperandInfo149, -1 ,nullptr },  // Inst #1081 = MADDHD
  { 1082,	4,	1,	4,	144,	0, 0x8ULL, nullptr, nullptr, OperandInfo149, -1 ,nullptr },  // Inst #1082 = MADDHDU
  { 1083,	4,	1,	4,	144,	0, 0x8ULL, nullptr, nullptr, OperandInfo150, -1 ,nullptr },  // Inst #1083 = MADDLD
  { 1084,	4,	1,	4,	144,	0, 0x8ULL, nullptr, nullptr, OperandInfo149, -1 ,nullptr },  // Inst #1084 = MADDLD8
  { 1085,	1,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1085 = MBAR
  { 1086,	2,	1,	4,	118,	0, 0x21ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #1086 = MCRF
  { 1087,	2,	1,	4,	247,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo151, -1 ,nullptr },  // Inst #1087 = MCRFS
  { 1088,	1,	1,	4,	119,	0, 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #1088 = MCRXRX
  { 1089,	3,	1,	4,	296,	0, 0x1ULL, nullptr, nullptr, OperandInfo153, -1 ,nullptr },  // Inst #1089 = MFBHRBE
  { 1090,	1,	1,	4,	256,	0|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x20ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1090 = MFCR
  { 1091,	1,	1,	4,	256,	0|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x20ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1091 = MFCR8
  { 1092,	1,	1,	4,	231,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, ImplicitList9, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1092 = MFCTR
  { 1093,	1,	1,	4,	231,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, ImplicitList10, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1093 = MFCTR8
  { 1094,	2,	1,	4,	305,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1094 = MFDCR
  { 1095,	1,	1,	4,	255,	0, 0x1aULL, ImplicitList2, nullptr, OperandInfo156, -1 ,nullptr },  // Inst #1095 = MFFS
  { 1096,	2,	1,	4,	102,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #1096 = MFFSCDRN
  { 1097,	2,	1,	4,	102,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #1097 = MFFSCDRNI
  { 1098,	1,	1,	4,	255,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, nullptr, OperandInfo156, -1 ,nullptr },  // Inst #1098 = MFFSCE
  { 1099,	2,	1,	4,	102,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, nullptr, OperandInfo109, -1 ,nullptr },  // Inst #1099 = MFFSCRN
  { 1100,	2,	1,	4,	102,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, nullptr, OperandInfo157, -1 ,nullptr },  // Inst #1100 = MFFSCRNI
  { 1101,	1,	1,	4,	255,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, nullptr, OperandInfo156, -1 ,nullptr },  // Inst #1101 = MFFSL
  { 1102,	1,	1,	4,	255,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList2, ImplicitList23, OperandInfo156, -1 ,nullptr },  // Inst #1102 = MFFSo
  { 1103,	1,	1,	4,	231,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, ImplicitList12, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1103 = MFLR
  { 1104,	1,	1,	4,	231,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, ImplicitList14, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1104 = MFLR8
  { 1105,	1,	1,	4,	232,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1105 = MFMSR
  { 1106,	2,	1,	4,	127,	0|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x21ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #1106 = MFOCRF
  { 1107,	2,	1,	4,	127,	0|(1ULL<<MCID::ExtraSrcRegAllocReq), 0x21ULL, nullptr, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #1107 = MFOCRF8
  { 1108,	2,	1,	4,	228,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1108 = MFPMR
  { 1109,	2,	1,	4,	231,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1109 = MFSPR
  { 1110,	2,	1,	4,	231,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo56, -1 ,nullptr },  // Inst #1110 = MFSPR8
  { 1111,	2,	1,	4,	303,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #1111 = MFSR
  { 1112,	2,	1,	4,	303,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1112 = MFSRIN
  { 1113,	2,	1,	4,	230,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1113 = MFTB
  { 1114,	1,	1,	4,	230,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, nullptr, OperandInfo32, -1 ,nullptr },  // Inst #1114 = MFTB8
  { 1115,	2,	1,	4,	113,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1115 = MFVRD
  { 1116,	1,	1,	4,	227,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1116 = MFVRSAVE
  { 1117,	2,	1,	4,	227,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, nullptr, OperandInfo159, -1 ,nullptr },  // Inst #1117 = MFVRSAVEv
  { 1118,	1,	1,	4,	136,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1118 = MFVSCR
  { 1119,	2,	1,	4,	113,	0, 0x0ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #1119 = MFVSRD
  { 1120,	2,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo158, -1 ,nullptr },  // Inst #1120 = MFVSRLD
  { 1121,	2,	1,	4,	113,	0, 0x0ULL, nullptr, nullptr, OperandInfo162, -1 ,nullptr },  // Inst #1121 = MFVSRWZ
  { 1122,	3,	1,	4,	237,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1122 = MODSD
  { 1123,	3,	1,	4,	236,	0, 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1123 = MODSW
  { 1124,	3,	1,	4,	237,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1124 = MODUD
  { 1125,	3,	1,	4,	237,	0, 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1125 = MODUW
  { 1126,	0,	0,	4,	185,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1126 = MSGSYNC
  { 1127,	0,	0,	4,	310,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1127 = MSYNC
  { 1128,	2,	0,	4,	244,	0|(1ULL<<MCID::ExtraDefRegAllocReq), 0x20ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1128 = MTCRF
  { 1129,	2,	0,	4,	244,	0|(1ULL<<MCID::ExtraDefRegAllocReq), 0x20ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #1129 = MTCRF8
  { 1130,	1,	0,	4,	226,	0, 0x9ULL, nullptr, ImplicitList9, OperandInfo154, -1 ,nullptr },  // Inst #1130 = MTCTR
  { 1131,	1,	0,	4,	226,	0, 0x9ULL, nullptr, ImplicitList10, OperandInfo32, -1 ,nullptr },  // Inst #1131 = MTCTR8
  { 1132,	1,	0,	4,	226,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, ImplicitList10, OperandInfo32, -1 ,nullptr },  // Inst #1132 = MTCTR8loop
  { 1133,	1,	0,	4,	226,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, ImplicitList9, OperandInfo154, -1 ,nullptr },  // Inst #1133 = MTCTRloop
  { 1134,	2,	0,	4,	306,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1134 = MTDCR
  { 1135,	1,	0,	4,	101,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #1135 = MTFSB0
  { 1136,	1,	0,	4,	101,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, ImplicitList2, OperandInfo2, -1 ,nullptr },  // Inst #1136 = MTFSB1
  { 1137,	4,	0,	4,	248,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #1137 = MTFSF
  { 1138,	3,	1,	4,	248,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #1138 = MTFSFI
  { 1139,	3,	1,	4,	248,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo166, -1 ,nullptr },  // Inst #1139 = MTFSFIo
  { 1140,	2,	0,	4,	249,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x1aULL, ImplicitList2, ImplicitList2, OperandInfo167, -1 ,nullptr },  // Inst #1140 = MTFSFb
  { 1141,	4,	0,	4,	248,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo165, -1 ,nullptr },  // Inst #1141 = MTFSFo
  { 1142,	1,	0,	4,	226,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, ImplicitList12, OperandInfo154, -1 ,nullptr },  // Inst #1142 = MTLR
  { 1143,	1,	0,	4,	226,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x9ULL, nullptr, ImplicitList14, OperandInfo32, -1 ,nullptr },  // Inst #1143 = MTLR8
  { 1144,	2,	0,	4,	233,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1144 = MTMSR
  { 1145,	2,	0,	4,	234,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo155, -1 ,nullptr },  // Inst #1145 = MTMSRD
  { 1146,	2,	1,	4,	128,	0|(1ULL<<MCID::ExtraDefRegAllocReq), 0x21ULL, nullptr, nullptr, OperandInfo168, -1 ,nullptr },  // Inst #1146 = MTOCRF
  { 1147,	2,	1,	4,	128,	0|(1ULL<<MCID::ExtraDefRegAllocReq), 0x21ULL, nullptr, nullptr, OperandInfo169, -1 ,nullptr },  // Inst #1147 = MTOCRF8
  { 1148,	2,	0,	4,	229,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1148 = MTPMR
  { 1149,	2,	0,	4,	235,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo163, -1 ,nullptr },  // Inst #1149 = MTSPR
  { 1150,	2,	0,	4,	235,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo164, -1 ,nullptr },  // Inst #1150 = MTSPR8
  { 1151,	2,	0,	4,	304,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #1151 = MTSR
  { 1152,	2,	0,	4,	304,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1152 = MTSRIN
  { 1153,	1,	0,	4,	227,	0|(1ULL<<MCID::UnmodeledSideEffects), 0xaULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1153 = MTVRSAVE
  { 1154,	2,	1,	4,	227,	0|(1ULL<<MCID::UnmodeledSideEffects), 0xaULL, nullptr, nullptr, OperandInfo170, -1 ,nullptr },  // Inst #1154 = MTVRSAVEv
  { 1155,	1,	0,	4,	137,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1155 = MTVSCR
  { 1156,	2,	1,	4,	113,	0, 0x0ULL, nullptr, nullptr, OperandInfo171, -1 ,nullptr },  // Inst #1156 = MTVSRD
  { 1157,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo172, -1 ,nullptr },  // Inst #1157 = MTVSRDD
  { 1158,	2,	1,	4,	113,	0, 0x0ULL, nullptr, nullptr, OperandInfo173, -1 ,nullptr },  // Inst #1158 = MTVSRWA
  { 1159,	2,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo174, -1 ,nullptr },  // Inst #1159 = MTVSRWS
  { 1160,	2,	1,	4,	113,	0, 0x0ULL, nullptr, nullptr, OperandInfo173, -1 ,nullptr },  // Inst #1160 = MTVSRWZ
  { 1161,	3,	1,	4,	145,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1161 = MULHD
  { 1162,	3,	1,	4,	146,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1162 = MULHDU
  { 1163,	3,	1,	4,	153,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1163 = MULHDUo
  { 1164,	3,	1,	4,	154,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1164 = MULHDo
  { 1165,	3,	1,	4,	145,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1165 = MULHW
  { 1166,	3,	1,	4,	146,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1166 = MULHWU
  { 1167,	3,	1,	4,	153,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1167 = MULHWUo
  { 1168,	3,	1,	4,	154,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1168 = MULHWo
  { 1169,	3,	1,	4,	144,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1169 = MULLD
  { 1170,	3,	1,	4,	155,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1170 = MULLDo
  { 1171,	3,	1,	4,	147,	0, 0x8ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1171 = MULLI
  { 1172,	3,	1,	4,	147,	0, 0x8ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1172 = MULLI8
  { 1173,	3,	1,	4,	145,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1173 = MULLW
  { 1174,	3,	1,	4,	154,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1174 = MULLWo
  { 1175,	0,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, ImplicitList12, nullptr, -1 ,nullptr },  // Inst #1175 = MoveGOTtoLR
  { 1176,	0,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, ImplicitList12, nullptr, -1 ,nullptr },  // Inst #1176 = MovePCtoLR
  { 1177,	0,	0,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, ImplicitList14, nullptr, -1 ,nullptr },  // Inst #1177 = MovePCtoLR8
  { 1178,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1178 = NAND
  { 1179,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1179 = NAND8
  { 1180,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1180 = NAND8o
  { 1181,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1181 = NANDo
  { 1182,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1182 = NAP
  { 1183,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1183 = NEG
  { 1184,	2,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #1184 = NEG8
  { 1185,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo55, -1 ,nullptr },  // Inst #1185 = NEG8o
  { 1186,	2,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo37, -1 ,nullptr },  // Inst #1186 = NEGo
  { 1187,	0,	0,	4,	116,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x8ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1187 = NOP
  { 1188,	0,	0,	4,	307,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x8ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1188 = NOP_GT_PWR6
  { 1189,	0,	0,	4,	307,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x8ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1189 = NOP_GT_PWR7
  { 1190,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1190 = NOR
  { 1191,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1191 = NOR8
  { 1192,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1192 = NOR8o
  { 1193,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1193 = NORo
  { 1194,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1194 = OR
  { 1195,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1195 = OR8
  { 1196,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1196 = OR8o
  { 1197,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1197 = ORC
  { 1198,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1198 = ORC8
  { 1199,	3,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1199 = ORC8o
  { 1200,	3,	1,	4,	116,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1200 = ORCo
  { 1201,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1201 = ORI
  { 1202,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1202 = ORI8
  { 1203,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1203 = ORIS
  { 1204,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1204 = ORIS8
  { 1205,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1205 = ORo
  { 1206,	2,	1,	4,	115,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1206 = POPCNTB
  { 1207,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo55, -1 ,nullptr },  // Inst #1207 = POPCNTD
  { 1208,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1208 = POPCNTW
  { 1209,	1,	1,	4,	0,	0, 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1209 = PPC32GOT
  { 1210,	2,	2,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1210 = PPC32PICGOT
  { 1211,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo175, -1 ,nullptr },  // Inst #1211 = QVALIGNI
  { 1212,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #1212 = QVALIGNIb
  { 1213,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo177, -1 ,nullptr },  // Inst #1213 = QVALIGNIs
  { 1214,	3,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo178, -1 ,nullptr },  // Inst #1214 = QVESPLATI
  { 1215,	3,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo179, -1 ,nullptr },  // Inst #1215 = QVESPLATIb
  { 1216,	3,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo180, -1 ,nullptr },  // Inst #1216 = QVESPLATIs
  { 1217,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1217 = QVFABS
  { 1218,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1218 = QVFABSs
  { 1219,	3,	1,	4,	21,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1219 = QVFADD
  { 1220,	3,	1,	4,	21,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1220 = QVFADDS
  { 1221,	3,	1,	4,	21,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo184, -1 ,nullptr },  // Inst #1221 = QVFADDSs
  { 1222,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1222 = QVFCFID
  { 1223,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1223 = QVFCFIDS
  { 1224,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1224 = QVFCFIDU
  { 1225,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1225 = QVFCFIDUS
  { 1226,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #1226 = QVFCFIDb
  { 1227,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1227 = QVFCMPEQ
  { 1228,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #1228 = QVFCMPEQb
  { 1229,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1229 = QVFCMPEQbs
  { 1230,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1230 = QVFCMPGT
  { 1231,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #1231 = QVFCMPGTb
  { 1232,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1232 = QVFCMPGTbs
  { 1233,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1233 = QVFCMPLT
  { 1234,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #1234 = QVFCMPLTb
  { 1235,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1235 = QVFCMPLTbs
  { 1236,	3,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1236 = QVFCPSGN
  { 1237,	3,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo184, -1 ,nullptr },  // Inst #1237 = QVFCPSGNs
  { 1238,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1238 = QVFCTID
  { 1239,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1239 = QVFCTIDU
  { 1240,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1240 = QVFCTIDUZ
  { 1241,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1241 = QVFCTIDZ
  { 1242,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #1242 = QVFCTIDb
  { 1243,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1243 = QVFCTIW
  { 1244,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1244 = QVFCTIWU
  { 1245,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1245 = QVFCTIWUZ
  { 1246,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1246 = QVFCTIWZ
  { 1247,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo175, -1 ,nullptr },  // Inst #1247 = QVFLOGICAL
  { 1248,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #1248 = QVFLOGICALb
  { 1249,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo176, -1 ,nullptr },  // Inst #1249 = QVFLOGICALs
  { 1250,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1250 = QVFMADD
  { 1251,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1251 = QVFMADDS
  { 1252,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1252 = QVFMADDSs
  { 1253,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1253 = QVFMR
  { 1254,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo185, -1 ,nullptr },  // Inst #1254 = QVFMRb
  { 1255,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1255 = QVFMRs
  { 1256,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1256 = QVFMSUB
  { 1257,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1257 = QVFMSUBS
  { 1258,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1258 = QVFMSUBSs
  { 1259,	3,	1,	4,	21,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1259 = QVFMUL
  { 1260,	3,	1,	4,	21,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1260 = QVFMULS
  { 1261,	3,	1,	4,	21,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo184, -1 ,nullptr },  // Inst #1261 = QVFMULSs
  { 1262,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1262 = QVFNABS
  { 1263,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1263 = QVFNABSs
  { 1264,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1264 = QVFNEG
  { 1265,	2,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1265 = QVFNEGs
  { 1266,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1266 = QVFNMADD
  { 1267,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1267 = QVFNMADDS
  { 1268,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1268 = QVFNMADDSs
  { 1269,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1269 = QVFNMSUB
  { 1270,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1270 = QVFNMSUBS
  { 1271,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo189, -1 ,nullptr },  // Inst #1271 = QVFNMSUBSs
  { 1272,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1272 = QVFPERM
  { 1273,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo190, -1 ,nullptr },  // Inst #1273 = QVFPERMs
  { 1274,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1274 = QVFRE
  { 1275,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1275 = QVFRES
  { 1276,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1276 = QVFRESs
  { 1277,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1277 = QVFRIM
  { 1278,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1278 = QVFRIMs
  { 1279,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1279 = QVFRIN
  { 1280,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1280 = QVFRINs
  { 1281,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1281 = QVFRIP
  { 1282,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1282 = QVFRIPs
  { 1283,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1283 = QVFRIZ
  { 1284,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1284 = QVFRIZs
  { 1285,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1285 = QVFRSP
  { 1286,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo191, -1 ,nullptr },  // Inst #1286 = QVFRSPs
  { 1287,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1287 = QVFRSQRTE
  { 1288,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo181, -1 ,nullptr },  // Inst #1288 = QVFRSQRTES
  { 1289,	2,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo182, -1 ,nullptr },  // Inst #1289 = QVFRSQRTESs
  { 1290,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1290 = QVFSEL
  { 1291,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo192, -1 ,nullptr },  // Inst #1291 = QVFSELb
  { 1292,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo193, -1 ,nullptr },  // Inst #1292 = QVFSELbb
  { 1293,	4,	1,	4,	68,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo194, -1 ,nullptr },  // Inst #1293 = QVFSELbs
  { 1294,	3,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1294 = QVFSUB
  { 1295,	3,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1295 = QVFSUBS
  { 1296,	3,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo184, -1 ,nullptr },  // Inst #1296 = QVFSUBSs
  { 1297,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1297 = QVFTSTNAN
  { 1298,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo186, -1 ,nullptr },  // Inst #1298 = QVFTSTNANb
  { 1299,	3,	1,	4,	20,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo187, -1 ,nullptr },  // Inst #1299 = QVFTSTNANbs
  { 1300,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1300 = QVFXMADD
  { 1301,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1301 = QVFXMADDS
  { 1302,	3,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1302 = QVFXMUL
  { 1303,	3,	1,	4,	21,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo183, -1 ,nullptr },  // Inst #1303 = QVFXMULS
  { 1304,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1304 = QVFXXCPNMADD
  { 1305,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1305 = QVFXXCPNMADDS
  { 1306,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1306 = QVFXXMADD
  { 1307,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1307 = QVFXXMADDS
  { 1308,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1308 = QVFXXNPMADD
  { 1309,	4,	1,	4,	27,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo188, -1 ,nullptr },  // Inst #1309 = QVFXXNPMADDS
  { 1310,	2,	1,	4,	68,	0|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, ImplicitList2, nullptr, OperandInfo195, -1 ,nullptr },  // Inst #1310 = QVGPCI
  { 1311,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1311 = QVLFCDUX
  { 1312,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1312 = QVLFCDUXA
  { 1313,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1313 = QVLFCDX
  { 1314,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1314 = QVLFCDXA
  { 1315,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1315 = QVLFCSUX
  { 1316,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1316 = QVLFCSUXA
  { 1317,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1317 = QVLFCSX
  { 1318,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1318 = QVLFCSXA
  { 1319,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1319 = QVLFCSXs
  { 1320,	4,	2,	4,	40,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo198, -1 ,nullptr },  // Inst #1320 = QVLFDUX
  { 1321,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1321 = QVLFDUXA
  { 1322,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1322 = QVLFDX
  { 1323,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1323 = QVLFDXA
  { 1324,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1324 = QVLFDXb
  { 1325,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1325 = QVLFIWAX
  { 1326,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1326 = QVLFIWAXA
  { 1327,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1327 = QVLFIWZX
  { 1328,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1328 = QVLFIWZXA
  { 1329,	4,	2,	4,	40,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo200, -1 ,nullptr },  // Inst #1329 = QVLFSUX
  { 1330,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1330 = QVLFSUXA
  { 1331,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1331 = QVLFSX
  { 1332,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1332 = QVLFSXA
  { 1333,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x0ULL, ImplicitList2, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1333 = QVLFSXb
  { 1334,	3,	1,	4,	39,	0|(1ULL<<MCID::MayLoad), 0x80ULL, ImplicitList2, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1334 = QVLFSXs
  { 1335,	3,	1,	4,	39,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1335 = QVLPCLDX
  { 1336,	3,	1,	4,	39,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1336 = QVLPCLSX
  { 1337,	2,	1,	4,	39,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo201, -1 ,nullptr },  // Inst #1337 = QVLPCLSXint
  { 1338,	3,	1,	4,	39,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1338 = QVLPCRDX
  { 1339,	3,	1,	4,	39,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1339 = QVLPCRSX
  { 1340,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1340 = QVSTFCDUX
  { 1341,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1341 = QVSTFCDUXA
  { 1342,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1342 = QVSTFCDUXI
  { 1343,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1343 = QVSTFCDUXIA
  { 1344,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1344 = QVSTFCDX
  { 1345,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1345 = QVSTFCDXA
  { 1346,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1346 = QVSTFCDXI
  { 1347,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1347 = QVSTFCDXIA
  { 1348,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1348 = QVSTFCSUX
  { 1349,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1349 = QVSTFCSUXA
  { 1350,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1350 = QVSTFCSUXI
  { 1351,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1351 = QVSTFCSUXIA
  { 1352,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1352 = QVSTFCSX
  { 1353,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1353 = QVSTFCSXA
  { 1354,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1354 = QVSTFCSXI
  { 1355,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1355 = QVSTFCSXIA
  { 1356,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1356 = QVSTFCSXs
  { 1357,	4,	1,	4,	70,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo202, -1 ,nullptr },  // Inst #1357 = QVSTFDUX
  { 1358,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1358 = QVSTFDUXA
  { 1359,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1359 = QVSTFDUXI
  { 1360,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1360 = QVSTFDUXIA
  { 1361,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1361 = QVSTFDX
  { 1362,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1362 = QVSTFDXA
  { 1363,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1363 = QVSTFDXI
  { 1364,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1364 = QVSTFDXIA
  { 1365,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo199, -1 ,nullptr },  // Inst #1365 = QVSTFDXb
  { 1366,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1366 = QVSTFIWX
  { 1367,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1367 = QVSTFIWXA
  { 1368,	4,	1,	4,	70,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo203, -1 ,nullptr },  // Inst #1368 = QVSTFSUX
  { 1369,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1369 = QVSTFSUXA
  { 1370,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1370 = QVSTFSUXI
  { 1371,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1371 = QVSTFSUXIA
  { 1372,	4,	1,	4,	70,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo202, -1 ,nullptr },  // Inst #1372 = QVSTFSUXs
  { 1373,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1373 = QVSTFSX
  { 1374,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1374 = QVSTFSXA
  { 1375,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1375 = QVSTFSXI
  { 1376,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x0ULL, ImplicitList2, nullptr, OperandInfo196, -1 ,nullptr },  // Inst #1376 = QVSTFSXIA
  { 1377,	3,	0,	4,	69,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo197, -1 ,nullptr },  // Inst #1377 = QVSTFSXs
  { 1378,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo204, -1 ,nullptr },  // Inst #1378 = RESTORE_CR
  { 1379,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo205, -1 ,nullptr },  // Inst #1379 = RESTORE_CRBIT
  { 1380,	3,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo206, -1 ,nullptr },  // Inst #1380 = RESTORE_VRSAVE
  { 1381,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1381 = RFCI
  { 1382,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1382 = RFDI
  { 1383,	1,	0,	4,	121,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1383 = RFEBB
  { 1384,	0,	0,	4,	297,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1384 = RFI
  { 1385,	0,	0,	4,	298,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1385 = RFID
  { 1386,	0,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1386 = RFMCI
  { 1387,	4,	1,	4,	124,	0, 0x8ULL, nullptr, nullptr, OperandInfo207, -1 ,nullptr },  // Inst #1387 = RLDCL
  { 1388,	4,	1,	4,	250,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo207, -1 ,nullptr },  // Inst #1388 = RLDCLo
  { 1389,	4,	1,	4,	124,	0, 0x8ULL, nullptr, nullptr, OperandInfo207, -1 ,nullptr },  // Inst #1389 = RLDCR
  { 1390,	4,	1,	4,	250,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo207, -1 ,nullptr },  // Inst #1390 = RLDCRo
  { 1391,	4,	1,	4,	112,	0, 0x8ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1391 = RLDIC
  { 1392,	4,	1,	4,	126,	0, 0x8ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1392 = RLDICL
  { 1393,	4,	1,	4,	126,	0, 0x8ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1393 = RLDICL_32
  { 1394,	4,	1,	4,	126,	0, 0x8ULL, nullptr, nullptr, OperandInfo208, -1 ,nullptr },  // Inst #1394 = RLDICL_32_64
  { 1395,	4,	1,	4,	251,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo34, -1 ,nullptr },  // Inst #1395 = RLDICL_32o
  { 1396,	4,	1,	4,	251,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo33, -1 ,nullptr },  // Inst #1396 = RLDICLo
  { 1397,	4,	1,	4,	126,	0, 0x8ULL, nullptr, nullptr, OperandInfo33, -1 ,nullptr },  // Inst #1397 = RLDICR
  { 1398,	4,	1,	4,	126,	0, 0x8ULL, nullptr, nullptr, OperandInfo34, -1 ,nullptr },  // Inst #1398 = RLDICR_32
  { 1399,	4,	1,	4,	251,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo33, -1 ,nullptr },  // Inst #1399 = RLDICRo
  { 1400,	4,	1,	4,	257,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo33, -1 ,nullptr },  // Inst #1400 = RLDICo
  { 1401,	5,	1,	4,	126,	0, 0x8ULL, nullptr, nullptr, OperandInfo209, -1 ,nullptr },  // Inst #1401 = RLDIMI
  { 1402,	5,	1,	4,	251,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo209, -1 ,nullptr },  // Inst #1402 = RLDIMIo
  { 1403,	6,	1,	4,	125,	0|(1ULL<<MCID::Commutable), 0xcULL, nullptr, nullptr, OperandInfo210, -1 ,nullptr },  // Inst #1403 = RLWIMI
  { 1404,	6,	1,	4,	125,	0, 0xcULL, nullptr, nullptr, OperandInfo211, -1 ,nullptr },  // Inst #1404 = RLWIMI8
  { 1405,	6,	1,	4,	252,	0, 0xcULL, nullptr, ImplicitList3, OperandInfo211, -1 ,nullptr },  // Inst #1405 = RLWIMI8o
  { 1406,	6,	1,	4,	252,	0|(1ULL<<MCID::Commutable), 0xcULL, nullptr, ImplicitList3, OperandInfo210, -1 ,nullptr },  // Inst #1406 = RLWIMIo
  { 1407,	5,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo212, -1 ,nullptr },  // Inst #1407 = RLWINM
  { 1408,	5,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo213, -1 ,nullptr },  // Inst #1408 = RLWINM8
  { 1409,	5,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo213, -1 ,nullptr },  // Inst #1409 = RLWINM8o
  { 1410,	5,	1,	4,	253,	0, 0xcULL, nullptr, ImplicitList3, OperandInfo212, -1 ,nullptr },  // Inst #1410 = RLWINMo
  { 1411,	5,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo214, -1 ,nullptr },  // Inst #1411 = RLWNM
  { 1412,	5,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo215, -1 ,nullptr },  // Inst #1412 = RLWNM8
  { 1413,	5,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo215, -1 ,nullptr },  // Inst #1413 = RLWNM8o
  { 1414,	5,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo214, -1 ,nullptr },  // Inst #1414 = RLWNMo
  { 1415,	2,	2,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1415 = ReadTB
  { 1416,	1,	0,	4,	296,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #1416 = SC
  { 1417,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo216, -1 ,nullptr },  // Inst #1417 = SELECT_CC_F16
  { 1418,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo217, -1 ,nullptr },  // Inst #1418 = SELECT_CC_F4
  { 1419,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo218, -1 ,nullptr },  // Inst #1419 = SELECT_CC_F8
  { 1420,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo219, -1 ,nullptr },  // Inst #1420 = SELECT_CC_I4
  { 1421,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo220, -1 ,nullptr },  // Inst #1421 = SELECT_CC_I8
  { 1422,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo221, -1 ,nullptr },  // Inst #1422 = SELECT_CC_QBRC
  { 1423,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo222, -1 ,nullptr },  // Inst #1423 = SELECT_CC_QFRC
  { 1424,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo223, -1 ,nullptr },  // Inst #1424 = SELECT_CC_QSRC
  { 1425,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo224, -1 ,nullptr },  // Inst #1425 = SELECT_CC_SPE
  { 1426,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo225, -1 ,nullptr },  // Inst #1426 = SELECT_CC_SPE4
  { 1427,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo216, -1 ,nullptr },  // Inst #1427 = SELECT_CC_VRRC
  { 1428,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo218, -1 ,nullptr },  // Inst #1428 = SELECT_CC_VSFRC
  { 1429,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo226, -1 ,nullptr },  // Inst #1429 = SELECT_CC_VSRC
  { 1430,	5,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x2ULL, nullptr, nullptr, OperandInfo217, -1 ,nullptr },  // Inst #1430 = SELECT_CC_VSSRC
  { 1431,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1431 = SELECT_F16
  { 1432,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo228, -1 ,nullptr },  // Inst #1432 = SELECT_F4
  { 1433,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo229, -1 ,nullptr },  // Inst #1433 = SELECT_F8
  { 1434,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo230, -1 ,nullptr },  // Inst #1434 = SELECT_I4
  { 1435,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo231, -1 ,nullptr },  // Inst #1435 = SELECT_I8
  { 1436,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo232, -1 ,nullptr },  // Inst #1436 = SELECT_QBRC
  { 1437,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo233, -1 ,nullptr },  // Inst #1437 = SELECT_QFRC
  { 1438,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, ImplicitList2, nullptr, OperandInfo234, -1 ,nullptr },  // Inst #1438 = SELECT_QSRC
  { 1439,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo235, -1 ,nullptr },  // Inst #1439 = SELECT_SPE
  { 1440,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x0ULL, nullptr, nullptr, OperandInfo236, -1 ,nullptr },  // Inst #1440 = SELECT_SPE4
  { 1441,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo227, -1 ,nullptr },  // Inst #1441 = SELECT_VRRC
  { 1442,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo229, -1 ,nullptr },  // Inst #1442 = SELECT_VSFRC
  { 1443,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo237, -1 ,nullptr },  // Inst #1443 = SELECT_VSRC
  { 1444,	4,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter), 0x2ULL, nullptr, nullptr, OperandInfo228, -1 ,nullptr },  // Inst #1444 = SELECT_VSSRC
  { 1445,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo238, -1 ,nullptr },  // Inst #1445 = SETB
  { 1446,	2,	1,	4,	110,	0, 0x8ULL, nullptr, nullptr, OperandInfo239, -1 ,nullptr },  // Inst #1446 = SETB8
  { 1447,	2,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo240, -1 ,nullptr },  // Inst #1447 = SETRND
  { 1448,	2,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo157, -1 ,nullptr },  // Inst #1448 = SETRNDi
  { 1449,	2,	1,	4,	312,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo37, -1 ,nullptr },  // Inst #1449 = SLBFEEo
  { 1450,	0,	0,	4,	190,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1450 = SLBIA
  { 1451,	1,	0,	4,	191,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1451 = SLBIE
  { 1452,	2,	0,	4,	220,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1452 = SLBIEG
  { 1453,	2,	1,	4,	192,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1453 = SLBMFEE
  { 1454,	2,	1,	4,	193,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1454 = SLBMFEV
  { 1455,	2,	0,	4,	194,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1455 = SLBMTE
  { 1456,	0,	0,	4,	311,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1456 = SLBSYNC
  { 1457,	3,	1,	4,	111,	0, 0x8ULL, nullptr, nullptr, OperandInfo241, -1 ,nullptr },  // Inst #1457 = SLD
  { 1458,	3,	1,	4,	258,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo241, -1 ,nullptr },  // Inst #1458 = SLDo
  { 1459,	3,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1459 = SLW
  { 1460,	3,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1460 = SLW8
  { 1461,	3,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1461 = SLW8o
  { 1462,	3,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1462 = SLWo
  { 1463,	3,	1,	4,	13,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo242, -1 ,nullptr },  // Inst #1463 = SPELWZ
  { 1464,	3,	1,	4,	13,	0|(1ULL<<MCID::MayLoad), 0x0ULL, nullptr, nullptr, OperandInfo243, -1 ,nullptr },  // Inst #1464 = SPELWZX
  { 1465,	3,	0,	4,	24,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo242, -1 ,nullptr },  // Inst #1465 = SPESTW
  { 1466,	3,	0,	4,	24,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo243, -1 ,nullptr },  // Inst #1466 = SPESTWX
  { 1467,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo204, -1 ,nullptr },  // Inst #1467 = SPILL_CR
  { 1468,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo205, -1 ,nullptr },  // Inst #1468 = SPILL_CRBIT
  { 1469,	3,	0,	4,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo206, -1 ,nullptr },  // Inst #1469 = SPILL_VRSAVE
  { 1470,	3,	1,	4,	111,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo241, -1 ,nullptr },  // Inst #1470 = SRAD
  { 1471,	3,	1,	4,	112,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo35, -1 ,nullptr },  // Inst #1471 = SRADI
  { 1472,	3,	1,	4,	112,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo36, -1 ,nullptr },  // Inst #1472 = SRADI_32
  { 1473,	3,	1,	4,	257,	0, 0x8ULL, nullptr, ImplicitList5, OperandInfo35, -1 ,nullptr },  // Inst #1473 = SRADIo
  { 1474,	3,	1,	4,	258,	0, 0x8ULL, nullptr, ImplicitList5, OperandInfo241, -1 ,nullptr },  // Inst #1474 = SRADo
  { 1475,	3,	1,	4,	132,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo49, -1 ,nullptr },  // Inst #1475 = SRAW
  { 1476,	3,	1,	4,	132,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo36, -1 ,nullptr },  // Inst #1476 = SRAWI
  { 1477,	3,	1,	4,	254,	0, 0x8ULL, nullptr, ImplicitList5, OperandInfo36, -1 ,nullptr },  // Inst #1477 = SRAWIo
  { 1478,	3,	1,	4,	254,	0, 0x8ULL, nullptr, ImplicitList5, OperandInfo49, -1 ,nullptr },  // Inst #1478 = SRAWo
  { 1479,	3,	1,	4,	111,	0, 0x8ULL, nullptr, nullptr, OperandInfo241, -1 ,nullptr },  // Inst #1479 = SRD
  { 1480,	3,	1,	4,	258,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo241, -1 ,nullptr },  // Inst #1480 = SRDo
  { 1481,	3,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1481 = SRW
  { 1482,	3,	1,	4,	130,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1482 = SRW8
  { 1483,	3,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1483 = SRW8o
  { 1484,	3,	1,	4,	253,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1484 = SRWo
  { 1485,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1485 = STB
  { 1486,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1486 = STB8
  { 1487,	3,	0,	4,	219,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1487 = STBCIX
  { 1488,	3,	0,	4,	199,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, ImplicitList3, OperandInfo122, -1 ,nullptr },  // Inst #1488 = STBCX
  { 1489,	3,	0,	4,	300,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1489 = STBEPX
  { 1490,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo244, -1 ,nullptr },  // Inst #1490 = STBU
  { 1491,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo245, -1 ,nullptr },  // Inst #1491 = STBU8
  { 1492,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo246, -1 ,nullptr },  // Inst #1492 = STBUX
  { 1493,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1493 = STBUX8
  { 1494,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1494 = STBX
  { 1495,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1495 = STBX8
  { 1496,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1496 = STBXTLS
  { 1497,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1497 = STBXTLS_
  { 1498,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #1498 = STBXTLS_32
  { 1499,	3,	0,	4,	218,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1499 = STD
  { 1500,	3,	0,	4,	290,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1500 = STDAT
  { 1501,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1501 = STDBRX
  { 1502,	3,	0,	4,	219,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1502 = STDCIX
  { 1503,	3,	0,	4,	200,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, ImplicitList3, OperandInfo128, -1 ,nullptr },  // Inst #1503 = STDCX
  { 1504,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo245, -1 ,nullptr },  // Inst #1504 = STDU
  { 1505,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1505 = STDUX
  { 1506,	3,	0,	4,	218,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1506 = STDX
  { 1507,	3,	0,	4,	218,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1507 = STDXTLS
  { 1508,	3,	0,	4,	218,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1508 = STDXTLS_
  { 1509,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo134, -1 ,nullptr },  // Inst #1509 = STFD
  { 1510,	3,	0,	4,	302,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #1510 = STFDEPX
  { 1511,	4,	1,	4,	277,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo248, -1 ,nullptr },  // Inst #1511 = STFDU
  { 1512,	4,	1,	4,	277,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo249, -1 ,nullptr },  // Inst #1512 = STFDUX
  { 1513,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #1513 = STFDX
  { 1514,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo135, -1 ,nullptr },  // Inst #1514 = STFIWX
  { 1515,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo138, -1 ,nullptr },  // Inst #1515 = STFS
  { 1516,	4,	1,	4,	277,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo250, -1 ,nullptr },  // Inst #1516 = STFSU
  { 1517,	4,	1,	4,	277,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo251, -1 ,nullptr },  // Inst #1517 = STFSUX
  { 1518,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo141, -1 ,nullptr },  // Inst #1518 = STFSX
  { 1519,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1519 = STH
  { 1520,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1520 = STH8
  { 1521,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1521 = STHBRX
  { 1522,	3,	0,	4,	219,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1522 = STHCIX
  { 1523,	3,	0,	4,	199,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, ImplicitList3, OperandInfo122, -1 ,nullptr },  // Inst #1523 = STHCX
  { 1524,	3,	0,	4,	300,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1524 = STHEPX
  { 1525,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo244, -1 ,nullptr },  // Inst #1525 = STHU
  { 1526,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo245, -1 ,nullptr },  // Inst #1526 = STHU8
  { 1527,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo246, -1 ,nullptr },  // Inst #1527 = STHUX
  { 1528,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1528 = STHUX8
  { 1529,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1529 = STHX
  { 1530,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1530 = STHX8
  { 1531,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1531 = STHXTLS
  { 1532,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1532 = STHXTLS_
  { 1533,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #1533 = STHXTLS_32
  { 1534,	3,	0,	4,	221,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1534 = STMW
  { 1535,	0,	0,	4,	313,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1535 = STOP
  { 1536,	3,	0,	4,	219,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1536 = STSWI
  { 1537,	3,	0,	4,	223,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1537 = STVEBX
  { 1538,	3,	0,	4,	223,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1538 = STVEHX
  { 1539,	3,	0,	4,	223,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1539 = STVEWX
  { 1540,	3,	0,	4,	223,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1540 = STVX
  { 1541,	3,	0,	4,	223,	0|(1ULL<<MCID::MayStore), 0x90ULL, nullptr, nullptr, OperandInfo143, -1 ,nullptr },  // Inst #1541 = STVXL
  { 1542,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #1542 = STW
  { 1543,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo123, -1 ,nullptr },  // Inst #1543 = STW8
  { 1544,	3,	0,	4,	290,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1544 = STWAT
  { 1545,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1545 = STWBRX
  { 1546,	3,	0,	4,	219,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1546 = STWCIX
  { 1547,	3,	0,	4,	199,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, ImplicitList3, OperandInfo122, -1 ,nullptr },  // Inst #1547 = STWCX
  { 1548,	3,	0,	4,	300,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1548 = STWEPX
  { 1549,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo244, -1 ,nullptr },  // Inst #1549 = STWU
  { 1550,	4,	1,	4,	278,	0|(1ULL<<MCID::MayStore), 0x10ULL, nullptr, nullptr, OperandInfo245, -1 ,nullptr },  // Inst #1550 = STWU8
  { 1551,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo246, -1 ,nullptr },  // Inst #1551 = STWUX
  { 1552,	4,	1,	4,	279,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo247, -1 ,nullptr },  // Inst #1552 = STWUX8
  { 1553,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo122, -1 ,nullptr },  // Inst #1553 = STWX
  { 1554,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0x94ULL, nullptr, nullptr, OperandInfo128, -1 ,nullptr },  // Inst #1554 = STWX8
  { 1555,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1555 = STWXTLS
  { 1556,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo129, -1 ,nullptr },  // Inst #1556 = STWXTLS_
  { 1557,	3,	0,	4,	216,	0|(1ULL<<MCID::MayStore), 0xcULL, nullptr, nullptr, OperandInfo130, -1 ,nullptr },  // Inst #1557 = STWXTLS_32
  { 1558,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #1558 = STXSD
  { 1559,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1559 = STXSDX
  { 1560,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1560 = STXSIBX
  { 1561,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1561 = STXSIBXv
  { 1562,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1562 = STXSIHX
  { 1563,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1563 = STXSIHXv
  { 1564,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #1564 = STXSIWX
  { 1565,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo145, -1 ,nullptr },  // Inst #1565 = STXSSP
  { 1566,	3,	0,	4,	215,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo48, -1 ,nullptr },  // Inst #1566 = STXSSPX
  { 1567,	3,	0,	4,	224,	0|(1ULL<<MCID::MayStore), 0x0ULL, nullptr, nullptr, OperandInfo146, -1 ,nullptr },  // Inst #1567 = STXV
  { 1568,	3,	0,	4,	224,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1568 = STXVB16X
  { 1569,	3,	0,	4,	224,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1569 = STXVD2X
  { 1570,	3,	0,	4,	224,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1570 = STXVH8X
  { 1571,	3,	0,	4,	225,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo148, -1 ,nullptr },  // Inst #1571 = STXVL
  { 1572,	3,	0,	4,	225,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo148, -1 ,nullptr },  // Inst #1572 = STXVLL
  { 1573,	3,	0,	4,	224,	0|(1ULL<<MCID::MayStore), 0x80ULL, ImplicitList2, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1573 = STXVW4X
  { 1574,	3,	0,	4,	224,	0|(1ULL<<MCID::MayStore), 0x80ULL, nullptr, nullptr, OperandInfo147, -1 ,nullptr },  // Inst #1574 = STXVX
  { 1575,	3,	1,	4,	115,	0, 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1575 = SUBF
  { 1576,	3,	1,	4,	115,	0, 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1576 = SUBF8
  { 1577,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1577 = SUBF8o
  { 1578,	3,	1,	4,	115,	0, 0xcULL, nullptr, ImplicitList4, OperandInfo49, -1 ,nullptr },  // Inst #1578 = SUBFC
  { 1579,	3,	1,	4,	115,	0, 0xcULL, nullptr, ImplicitList4, OperandInfo50, -1 ,nullptr },  // Inst #1579 = SUBFC8
  { 1580,	3,	1,	4,	245,	0, 0xcULL, nullptr, ImplicitList5, OperandInfo50, -1 ,nullptr },  // Inst #1580 = SUBFC8o
  { 1581,	3,	1,	4,	245,	0, 0xcULL, nullptr, ImplicitList5, OperandInfo49, -1 ,nullptr },  // Inst #1581 = SUBFCo
  { 1582,	3,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo49, -1 ,nullptr },  // Inst #1582 = SUBFE
  { 1583,	3,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo50, -1 ,nullptr },  // Inst #1583 = SUBFE8
  { 1584,	3,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo50, -1 ,nullptr },  // Inst #1584 = SUBFE8o
  { 1585,	3,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo49, -1 ,nullptr },  // Inst #1585 = SUBFEo
  { 1586,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo36, -1 ,nullptr },  // Inst #1586 = SUBFIC
  { 1587,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList4, OperandInfo35, -1 ,nullptr },  // Inst #1587 = SUBFIC8
  { 1588,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo37, -1 ,nullptr },  // Inst #1588 = SUBFME
  { 1589,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo55, -1 ,nullptr },  // Inst #1589 = SUBFME8
  { 1590,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo55, -1 ,nullptr },  // Inst #1590 = SUBFME8o
  { 1591,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo37, -1 ,nullptr },  // Inst #1591 = SUBFMEo
  { 1592,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo37, -1 ,nullptr },  // Inst #1592 = SUBFZE
  { 1593,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList4, OperandInfo55, -1 ,nullptr },  // Inst #1593 = SUBFZE8
  { 1594,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo55, -1 ,nullptr },  // Inst #1594 = SUBFZE8o
  { 1595,	2,	1,	4,	115,	0, 0x8ULL, ImplicitList4, ImplicitList5, OperandInfo37, -1 ,nullptr },  // Inst #1595 = SUBFZEo
  { 1596,	3,	1,	4,	115,	0, 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1596 = SUBFo
  { 1597,	1,	0,	4,	187,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #1597 = SYNC
  { 1598,	1,	0,	4,	135,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo154, -1 ,nullptr },  // Inst #1598 = TABORT
  { 1599,	3,	0,	4,	100,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo81, -1 ,nullptr },  // Inst #1599 = TABORTDC
  { 1600,	3,	0,	4,	100,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo252, -1 ,nullptr },  // Inst #1600 = TABORTDCI
  { 1601,	3,	0,	4,	100,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo81, -1 ,nullptr },  // Inst #1601 = TABORTWC
  { 1602,	3,	0,	4,	100,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo252, -1 ,nullptr },  // Inst #1602 = TABORTWCI
  { 1603,	1,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, nullptr, OperandInfo72, -1 ,nullptr },  // Inst #1603 = TAILB
  { 1604,	1,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, nullptr, OperandInfo72, -1 ,nullptr },  // Inst #1604 = TAILB8
  { 1605,	1,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1605 = TAILBA
  { 1606,	1,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList2, nullptr, OperandInfo2, -1 ,nullptr },  // Inst #1606 = TAILBA8
  { 1607,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, nullptr, nullptr, -1 ,nullptr },  // Inst #1607 = TAILBCTR
  { 1608,	0,	0,	4,	287,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Branch)|(1ULL<<MCID::IndirectBranch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList13, nullptr, nullptr, -1 ,nullptr },  // Inst #1608 = TAILBCTR8
  { 1609,	1,	0,	4,	122,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1609 = TBEGIN
  { 1610,	2,	1,	4,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo142, -1 ,nullptr },  // Inst #1610 = TBEGIN_RET
  { 1611,	1,	1,	4,	205,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo152, -1 ,nullptr },  // Inst #1611 = TCHECK
  { 1612,	1,	1,	4,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1612 = TCHECK_RET
  { 1613,	2,	0,	4,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator), 0x0ULL, ImplicitList2, nullptr, OperandInfo253, -1 ,nullptr },  // Inst #1613 = TCRETURNai
  { 1614,	2,	0,	4,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator), 0x0ULL, ImplicitList2, nullptr, OperandInfo253, -1 ,nullptr },  // Inst #1614 = TCRETURNai8
  { 1615,	2,	0,	4,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator), 0x0ULL, ImplicitList2, nullptr, OperandInfo254, -1 ,nullptr },  // Inst #1615 = TCRETURNdi
  { 1616,	2,	0,	4,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator), 0x0ULL, ImplicitList2, nullptr, OperandInfo254, -1 ,nullptr },  // Inst #1616 = TCRETURNdi8
  { 1617,	2,	0,	4,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator), 0x0ULL, ImplicitList2, nullptr, OperandInfo255, -1 ,nullptr },  // Inst #1617 = TCRETURNri
  { 1618,	2,	0,	4,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Call)|(1ULL<<MCID::Terminator), 0x0ULL, ImplicitList2, nullptr, OperandInfo256, -1 ,nullptr },  // Inst #1618 = TCRETURNri8
  { 1619,	3,	0,	4,	104,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo257, -1 ,nullptr },  // Inst #1619 = TD
  { 1620,	3,	0,	4,	104,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo258, -1 ,nullptr },  // Inst #1620 = TDI
  { 1621,	1,	0,	4,	198,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1621 = TEND
  { 1622,	0,	0,	4,	308,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1622 = TLBIA
  { 1623,	2,	0,	4,	222,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1623 = TLBIE
  { 1624,	1,	0,	4,	195,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1624 = TLBIEL
  { 1625,	2,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1625 = TLBIVAX
  { 1626,	1,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1626 = TLBLD
  { 1627,	1,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1627 = TLBLI
  { 1628,	0,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1628 = TLBRE
  { 1629,	3,	1,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1629 = TLBRE2
  { 1630,	2,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1630 = TLBSX
  { 1631,	3,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1631 = TLBSX2
  { 1632,	3,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1632 = TLBSX2D
  { 1633,	0,	0,	4,	186,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1633 = TLBSYNC
  { 1634,	0,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1634 = TLBWE
  { 1635,	3,	0,	4,	299,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo259, -1 ,nullptr },  // Inst #1635 = TLBWE2
  { 1636,	0,	0,	4,	299,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, nullptr, -1 ,nullptr },  // Inst #1636 = TRAP
  { 1637,	0,	0,	4,	122,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #1637 = TRECHKPT
  { 1638,	1,	0,	4,	135,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo154, -1 ,nullptr },  // Inst #1638 = TRECLAIM
  { 1639,	1,	0,	4,	135,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, ImplicitList3, OperandInfo2, -1 ,nullptr },  // Inst #1639 = TSR
  { 1640,	3,	0,	4,	105,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo81, -1 ,nullptr },  // Inst #1640 = TW
  { 1641,	3,	0,	4,	105,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo252, -1 ,nullptr },  // Inst #1641 = TWI
  { 1642,	2,	1,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo37, -1 ,nullptr },  // Inst #1642 = UPDATE_VRSAVE
  { 1643,	3,	2,	4,	0,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1643 = UpdateGBR
  { 1644,	3,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1644 = VABSDUB
  { 1645,	3,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1645 = VABSDUH
  { 1646,	3,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1646 = VABSDUW
  { 1647,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1647 = VADDCUQ
  { 1648,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1648 = VADDCUW
  { 1649,	4,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1649 = VADDECUQ
  { 1650,	4,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1650 = VADDEUQM
  { 1651,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1651 = VADDFP
  { 1652,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1652 = VADDSBS
  { 1653,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1653 = VADDSHS
  { 1654,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1654 = VADDSWS
  { 1655,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1655 = VADDUBM
  { 1656,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1656 = VADDUBS
  { 1657,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1657 = VADDUDM
  { 1658,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1658 = VADDUHM
  { 1659,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1659 = VADDUHS
  { 1660,	3,	1,	4,	163,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1660 = VADDUQM
  { 1661,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1661 = VADDUWM
  { 1662,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1662 = VADDUWS
  { 1663,	3,	1,	4,	98,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1663 = VAND
  { 1664,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1664 = VANDC
  { 1665,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1665 = VAVGSB
  { 1666,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1666 = VAVGSH
  { 1667,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1667 = VAVGSW
  { 1668,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1668 = VAVGUB
  { 1669,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1669 = VAVGUH
  { 1670,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1670 = VAVGUW
  { 1671,	3,	1,	4,	140,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1671 = VBPERMD
  { 1672,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1672 = VBPERMQ
  { 1673,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1673 = VCFSX
  { 1674,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1674 = VCFSX_0
  { 1675,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1675 = VCFUX
  { 1676,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1676 = VCFUX_0
  { 1677,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1677 = VCIPHER
  { 1678,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1678 = VCIPHERLAST
  { 1679,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1679 = VCLZB
  { 1680,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1680 = VCLZD
  { 1681,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1681 = VCLZH
  { 1682,	2,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo262, -1 ,nullptr },  // Inst #1682 = VCLZLSBB
  { 1683,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1683 = VCLZW
  { 1684,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1684 = VCMPBFP
  { 1685,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1685 = VCMPBFPo
  { 1686,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1686 = VCMPEQFP
  { 1687,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1687 = VCMPEQFPo
  { 1688,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1688 = VCMPEQUB
  { 1689,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1689 = VCMPEQUBo
  { 1690,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1690 = VCMPEQUD
  { 1691,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1691 = VCMPEQUDo
  { 1692,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1692 = VCMPEQUH
  { 1693,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1693 = VCMPEQUHo
  { 1694,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1694 = VCMPEQUW
  { 1695,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1695 = VCMPEQUWo
  { 1696,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1696 = VCMPGEFP
  { 1697,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1697 = VCMPGEFPo
  { 1698,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1698 = VCMPGTFP
  { 1699,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1699 = VCMPGTFPo
  { 1700,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1700 = VCMPGTSB
  { 1701,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1701 = VCMPGTSBo
  { 1702,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1702 = VCMPGTSD
  { 1703,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1703 = VCMPGTSDo
  { 1704,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1704 = VCMPGTSH
  { 1705,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1705 = VCMPGTSHo
  { 1706,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1706 = VCMPGTSW
  { 1707,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1707 = VCMPGTSWo
  { 1708,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1708 = VCMPGTUB
  { 1709,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1709 = VCMPGTUBo
  { 1710,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1710 = VCMPGTUD
  { 1711,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1711 = VCMPGTUDo
  { 1712,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1712 = VCMPGTUH
  { 1713,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1713 = VCMPGTUHo
  { 1714,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1714 = VCMPGTUW
  { 1715,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1715 = VCMPGTUWo
  { 1716,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1716 = VCMPNEB
  { 1717,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1717 = VCMPNEBo
  { 1718,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1718 = VCMPNEH
  { 1719,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1719 = VCMPNEHo
  { 1720,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1720 = VCMPNEW
  { 1721,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1721 = VCMPNEWo
  { 1722,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1722 = VCMPNEZB
  { 1723,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1723 = VCMPNEZBo
  { 1724,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1724 = VCMPNEZH
  { 1725,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1725 = VCMPNEZHo
  { 1726,	3,	1,	4,	138,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1726 = VCMPNEZW
  { 1727,	3,	1,	4,	138,	0, 0x28ULL, nullptr, ImplicitList16, OperandInfo68, -1 ,nullptr },  // Inst #1727 = VCMPNEZWo
  { 1728,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1728 = VCTSXS
  { 1729,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1729 = VCTSXS_0
  { 1730,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1730 = VCTUXS
  { 1731,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1731 = VCTUXS_0
  { 1732,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1732 = VCTZB
  { 1733,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1733 = VCTZD
  { 1734,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1734 = VCTZH
  { 1735,	2,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo262, -1 ,nullptr },  // Inst #1735 = VCTZLSBB
  { 1736,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1736 = VCTZW
  { 1737,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1737 = VEQV
  { 1738,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1738 = VEXPTEFP
  { 1739,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1739 = VEXTRACTD
  { 1740,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1740 = VEXTRACTUB
  { 1741,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1741 = VEXTRACTUH
  { 1742,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1742 = VEXTRACTUW
  { 1743,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1743 = VEXTSB2D
  { 1744,	2,	1,	4,	97,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1744 = VEXTSB2Ds
  { 1745,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1745 = VEXTSB2W
  { 1746,	2,	1,	4,	97,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1746 = VEXTSB2Ws
  { 1747,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1747 = VEXTSH2D
  { 1748,	2,	1,	4,	97,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1748 = VEXTSH2Ds
  { 1749,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1749 = VEXTSH2W
  { 1750,	2,	1,	4,	97,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1750 = VEXTSH2Ws
  { 1751,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1751 = VEXTSW2D
  { 1752,	2,	1,	4,	97,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo263, -1 ,nullptr },  // Inst #1752 = VEXTSW2Ds
  { 1753,	3,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1753 = VEXTUBLX
  { 1754,	3,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1754 = VEXTUBRX
  { 1755,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1755 = VEXTUHLX
  { 1756,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1756 = VEXTUHRX
  { 1757,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1757 = VEXTUWLX
  { 1758,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo264, -1 ,nullptr },  // Inst #1758 = VEXTUWRX
  { 1759,	2,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1759 = VGBBD
  { 1760,	4,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo265, -1 ,nullptr },  // Inst #1760 = VINSERTB
  { 1761,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1761 = VINSERTD
  { 1762,	4,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo265, -1 ,nullptr },  // Inst #1762 = VINSERTH
  { 1763,	3,	1,	4,	163,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1763 = VINSERTW
  { 1764,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1764 = VLOGEFP
  { 1765,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1765 = VMADDFP
  { 1766,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1766 = VMAXFP
  { 1767,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1767 = VMAXSB
  { 1768,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1768 = VMAXSD
  { 1769,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1769 = VMAXSH
  { 1770,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1770 = VMAXSW
  { 1771,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1771 = VMAXUB
  { 1772,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1772 = VMAXUD
  { 1773,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1773 = VMAXUH
  { 1774,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1774 = VMAXUW
  { 1775,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1775 = VMHADDSHS
  { 1776,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1776 = VMHRADDSHS
  { 1777,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1777 = VMINFP
  { 1778,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1778 = VMINSB
  { 1779,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1779 = VMINSD
  { 1780,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1780 = VMINSH
  { 1781,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1781 = VMINSW
  { 1782,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1782 = VMINUB
  { 1783,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1783 = VMINUD
  { 1784,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1784 = VMINUH
  { 1785,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1785 = VMINUW
  { 1786,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1786 = VMLADDUHM
  { 1787,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1787 = VMRGEW
  { 1788,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1788 = VMRGHB
  { 1789,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1789 = VMRGHH
  { 1790,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1790 = VMRGHW
  { 1791,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1791 = VMRGLB
  { 1792,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1792 = VMRGLH
  { 1793,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1793 = VMRGLW
  { 1794,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1794 = VMRGOW
  { 1795,	4,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1795 = VMSUMMBM
  { 1796,	4,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1796 = VMSUMSHM
  { 1797,	4,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1797 = VMSUMSHS
  { 1798,	4,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1798 = VMSUMUBM
  { 1799,	4,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1799 = VMSUMUHM
  { 1800,	4,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1800 = VMSUMUHS
  { 1801,	2,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1801 = VMUL10CUQ
  { 1802,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1802 = VMUL10ECUQ
  { 1803,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1803 = VMUL10EUQ
  { 1804,	2,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1804 = VMUL10UQ
  { 1805,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1805 = VMULESB
  { 1806,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1806 = VMULESH
  { 1807,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1807 = VMULESW
  { 1808,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1808 = VMULEUB
  { 1809,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1809 = VMULEUH
  { 1810,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1810 = VMULEUW
  { 1811,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1811 = VMULOSB
  { 1812,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1812 = VMULOSH
  { 1813,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1813 = VMULOSW
  { 1814,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1814 = VMULOUB
  { 1815,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1815 = VMULOUH
  { 1816,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1816 = VMULOUW
  { 1817,	3,	1,	4,	143,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1817 = VMULUWM
  { 1818,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1818 = VNAND
  { 1819,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1819 = VNCIPHER
  { 1820,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1820 = VNCIPHERLAST
  { 1821,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1821 = VNEGD
  { 1822,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1822 = VNEGW
  { 1823,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1823 = VNMSUBFP
  { 1824,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1824 = VNOR
  { 1825,	3,	1,	4,	98,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1825 = VOR
  { 1826,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1826 = VORC
  { 1827,	4,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1827 = VPERM
  { 1828,	4,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1828 = VPERMR
  { 1829,	4,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1829 = VPERMXOR
  { 1830,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1830 = VPKPX
  { 1831,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1831 = VPKSDSS
  { 1832,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1832 = VPKSDUS
  { 1833,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1833 = VPKSHSS
  { 1834,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1834 = VPKSHUS
  { 1835,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1835 = VPKSWSS
  { 1836,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1836 = VPKSWUS
  { 1837,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1837 = VPKUDUM
  { 1838,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1838 = VPKUDUS
  { 1839,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1839 = VPKUHUM
  { 1840,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1840 = VPKUHUS
  { 1841,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1841 = VPKUWUM
  { 1842,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1842 = VPKUWUS
  { 1843,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1843 = VPMSUMB
  { 1844,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1844 = VPMSUMD
  { 1845,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1845 = VPMSUMH
  { 1846,	3,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1846 = VPMSUMW
  { 1847,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1847 = VPOPCNTB
  { 1848,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1848 = VPOPCNTD
  { 1849,	2,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1849 = VPOPCNTH
  { 1850,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1850 = VPOPCNTW
  { 1851,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1851 = VPRTYBD
  { 1852,	2,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1852 = VPRTYBQ
  { 1853,	2,	1,	4,	139,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1853 = VPRTYBW
  { 1854,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1854 = VREFP
  { 1855,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1855 = VRFIM
  { 1856,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1856 = VRFIN
  { 1857,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1857 = VRFIP
  { 1858,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1858 = VRFIZ
  { 1859,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1859 = VRLB
  { 1860,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1860 = VRLD
  { 1861,	4,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo266, -1 ,nullptr },  // Inst #1861 = VRLDMI
  { 1862,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1862 = VRLDNM
  { 1863,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1863 = VRLH
  { 1864,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1864 = VRLW
  { 1865,	4,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo266, -1 ,nullptr },  // Inst #1865 = VRLWMI
  { 1866,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1866 = VRLWNM
  { 1867,	2,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1867 = VRSQRTEFP
  { 1868,	2,	1,	4,	286,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1868 = VSBOX
  { 1869,	4,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1869 = VSEL
  { 1870,	4,	1,	4,	140,	0, 0x0ULL, nullptr, nullptr, OperandInfo267, -1 ,nullptr },  // Inst #1870 = VSHASIGMAD
  { 1871,	4,	1,	4,	140,	0, 0x0ULL, nullptr, nullptr, OperandInfo267, -1 ,nullptr },  // Inst #1871 = VSHASIGMAW
  { 1872,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1872 = VSL
  { 1873,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1873 = VSLB
  { 1874,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1874 = VSLD
  { 1875,	4,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo70, -1 ,nullptr },  // Inst #1875 = VSLDOI
  { 1876,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1876 = VSLH
  { 1877,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1877 = VSLO
  { 1878,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1878 = VSLV
  { 1879,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1879 = VSLW
  { 1880,	3,	1,	4,	161,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1880 = VSPLTB
  { 1881,	3,	1,	4,	161,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x28ULL, nullptr, nullptr, OperandInfo268, -1 ,nullptr },  // Inst #1881 = VSPLTBs
  { 1882,	3,	1,	4,	161,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1882 = VSPLTH
  { 1883,	3,	1,	4,	161,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x28ULL, nullptr, nullptr, OperandInfo268, -1 ,nullptr },  // Inst #1883 = VSPLTHs
  { 1884,	2,	1,	4,	161,	0, 0x28ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #1884 = VSPLTISB
  { 1885,	2,	1,	4,	161,	0, 0x28ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #1885 = VSPLTISH
  { 1886,	2,	1,	4,	161,	0, 0x28ULL, nullptr, nullptr, OperandInfo269, -1 ,nullptr },  // Inst #1886 = VSPLTISW
  { 1887,	3,	1,	4,	161,	0, 0x28ULL, nullptr, nullptr, OperandInfo261, -1 ,nullptr },  // Inst #1887 = VSPLTW
  { 1888,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1888 = VSR
  { 1889,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1889 = VSRAB
  { 1890,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1890 = VSRAD
  { 1891,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1891 = VSRAH
  { 1892,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1892 = VSRAW
  { 1893,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1893 = VSRB
  { 1894,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1894 = VSRD
  { 1895,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1895 = VSRH
  { 1896,	3,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1896 = VSRO
  { 1897,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1897 = VSRV
  { 1898,	3,	1,	4,	98,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1898 = VSRW
  { 1899,	3,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1899 = VSUBCUQ
  { 1900,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1900 = VSUBCUW
  { 1901,	4,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1901 = VSUBECUQ
  { 1902,	4,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo260, -1 ,nullptr },  // Inst #1902 = VSUBEUQM
  { 1903,	3,	1,	4,	143,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1903 = VSUBFP
  { 1904,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1904 = VSUBSBS
  { 1905,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1905 = VSUBSHS
  { 1906,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1906 = VSUBSWS
  { 1907,	3,	1,	4,	97,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1907 = VSUBUBM
  { 1908,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1908 = VSUBUBS
  { 1909,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1909 = VSUBUDM
  { 1910,	3,	1,	4,	97,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1910 = VSUBUHM
  { 1911,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1911 = VSUBUHS
  { 1912,	3,	1,	4,	163,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1912 = VSUBUQM
  { 1913,	3,	1,	4,	97,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1913 = VSUBUWM
  { 1914,	3,	1,	4,	140,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1914 = VSUBUWS
  { 1915,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1915 = VSUM2SWS
  { 1916,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1916 = VSUM4SBS
  { 1917,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1917 = VSUM4SHS
  { 1918,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1918 = VSUM4UBS
  { 1919,	3,	1,	4,	142,	0, 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1919 = VSUMSWS
  { 1920,	2,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1920 = VUPKHPX
  { 1921,	2,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1921 = VUPKHSB
  { 1922,	2,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1922 = VUPKHSH
  { 1923,	2,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1923 = VUPKHSW
  { 1924,	2,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1924 = VUPKLPX
  { 1925,	2,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1925 = VUPKLSB
  { 1926,	2,	1,	4,	162,	0, 0x28ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1926 = VUPKLSH
  { 1927,	2,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1927 = VUPKLSW
  { 1928,	3,	1,	4,	98,	0|(1ULL<<MCID::Commutable), 0x28ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1928 = VXOR
  { 1929,	1,	1,	4,	98,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x28ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1929 = V_SET0
  { 1930,	1,	1,	4,	98,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x28ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1930 = V_SET0B
  { 1931,	1,	1,	4,	98,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x28ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1931 = V_SET0H
  { 1932,	1,	1,	4,	162,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x28ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1932 = V_SETALLONES
  { 1933,	1,	1,	4,	162,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x28ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1933 = V_SETALLONESB
  { 1934,	1,	1,	4,	162,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x28ULL, nullptr, nullptr, OperandInfo160, -1 ,nullptr },  // Inst #1934 = V_SETALLONESH
  { 1935,	1,	0,	4,	123,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #1935 = WAIT
  { 1936,	1,	0,	4,	309,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo154, -1 ,nullptr },  // Inst #1936 = WRTEE
  { 1937,	1,	0,	4,	309,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #1937 = WRTEEI
  { 1938,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo49, -1 ,nullptr },  // Inst #1938 = XOR
  { 1939,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, nullptr, OperandInfo50, -1 ,nullptr },  // Inst #1939 = XOR8
  { 1940,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo50, -1 ,nullptr },  // Inst #1940 = XOR8o
  { 1941,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1941 = XORI
  { 1942,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1942 = XORI8
  { 1943,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo36, -1 ,nullptr },  // Inst #1943 = XORIS
  { 1944,	3,	1,	4,	116,	0, 0x8ULL, nullptr, nullptr, OperandInfo35, -1 ,nullptr },  // Inst #1944 = XORIS8
  { 1945,	3,	1,	4,	116,	0|(1ULL<<MCID::Commutable), 0x8ULL, nullptr, ImplicitList3, OperandInfo49, -1 ,nullptr },  // Inst #1945 = XORo
  { 1946,	2,	1,	4,	120,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1946 = XSABSDP
  { 1947,	2,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1947 = XSABSQP
  { 1948,	3,	1,	4,	159,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #1948 = XSADDDP
  { 1949,	3,	1,	4,	165,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1949 = XSADDQP
  { 1950,	3,	1,	4,	165,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1950 = XSADDQPO
  { 1951,	3,	1,	4,	159,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo272, -1 ,nullptr },  // Inst #1951 = XSADDSP
  { 1952,	3,	1,	4,	109,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #1952 = XSCMPEQDP
  { 1953,	3,	1,	4,	109,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo274, -1 ,nullptr },  // Inst #1953 = XSCMPEXPDP
  { 1954,	3,	1,	4,	164,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #1954 = XSCMPEXPQP
  { 1955,	3,	1,	4,	109,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #1955 = XSCMPGEDP
  { 1956,	3,	1,	4,	109,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #1956 = XSCMPGTDP
  { 1957,	3,	1,	4,	109,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo274, -1 ,nullptr },  // Inst #1957 = XSCMPODP
  { 1958,	3,	1,	4,	164,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #1958 = XSCMPOQP
  { 1959,	3,	1,	4,	109,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo274, -1 ,nullptr },  // Inst #1959 = XSCMPUDP
  { 1960,	3,	1,	4,	164,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo275, -1 ,nullptr },  // Inst #1960 = XSCMPUQP
  { 1961,	3,	1,	4,	120,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #1961 = XSCPSGNDP
  { 1962,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1962 = XSCPSGNQP
  { 1963,	2,	1,	4,	159,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1963 = XSCVDPHP
  { 1964,	2,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #1964 = XSCVDPQP
  { 1965,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1965 = XSCVDPSP
  { 1966,	2,	1,	4,	159,	0, 0x0ULL, nullptr, nullptr, OperandInfo277, -1 ,nullptr },  // Inst #1966 = XSCVDPSPN
  { 1967,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1967 = XSCVDPSXDS
  { 1968,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1968 = XSCVDPSXDSs
  { 1969,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1969 = XSCVDPSXWS
  { 1970,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1970 = XSCVDPSXWSs
  { 1971,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1971 = XSCVDPUXDS
  { 1972,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1972 = XSCVDPUXDSs
  { 1973,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1973 = XSCVDPUXWS
  { 1974,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #1974 = XSCVDPUXWSs
  { 1975,	2,	1,	4,	159,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1975 = XSCVHPDP
  { 1976,	2,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo279, -1 ,nullptr },  // Inst #1976 = XSCVQPDP
  { 1977,	2,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo279, -1 ,nullptr },  // Inst #1977 = XSCVQPDPO
  { 1978,	2,	1,	4,	165,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1978 = XSCVQPSDZ
  { 1979,	2,	1,	4,	165,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1979 = XSCVQPSWZ
  { 1980,	2,	1,	4,	165,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1980 = XSCVQPUDZ
  { 1981,	2,	1,	4,	165,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #1981 = XSCVQPUWZ
  { 1982,	2,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #1982 = XSCVSDQP
  { 1983,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1983 = XSCVSPDP
  { 1984,	2,	1,	4,	108,	0, 0x0ULL, nullptr, nullptr, OperandInfo280, -1 ,nullptr },  // Inst #1984 = XSCVSPDPN
  { 1985,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1985 = XSCVSXDDP
  { 1986,	2,	1,	4,	159,	0, 0x0ULL, nullptr, nullptr, OperandInfo281, -1 ,nullptr },  // Inst #1986 = XSCVSXDSP
  { 1987,	2,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo276, -1 ,nullptr },  // Inst #1987 = XSCVUDQP
  { 1988,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #1988 = XSCVUXDDP
  { 1989,	2,	1,	4,	159,	0, 0x0ULL, nullptr, nullptr, OperandInfo281, -1 ,nullptr },  // Inst #1989 = XSCVUXDSP
  { 1990,	3,	1,	4,	269,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #1990 = XSDIVDP
  { 1991,	3,	1,	4,	169,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1991 = XSDIVQP
  { 1992,	3,	1,	4,	169,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #1992 = XSDIVQPO
  { 1993,	3,	1,	4,	272,	0, 0x0ULL, nullptr, nullptr, OperandInfo272, -1 ,nullptr },  // Inst #1993 = XSDIVSP
  { 1994,	3,	1,	4,	134,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo282, -1 ,nullptr },  // Inst #1994 = XSIEXPDP
  { 1995,	3,	1,	4,	98,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo283, -1 ,nullptr },  // Inst #1995 = XSIEXPQP
  { 1996,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #1996 = XSMADDADP
  { 1997,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #1997 = XSMADDASP
  { 1998,	4,	1,	4,	151,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #1998 = XSMADDMDP
  { 1999,	4,	1,	4,	151,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #1999 = XSMADDMSP
  { 2000,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2000 = XSMADDQP
  { 2001,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2001 = XSMADDQPO
  { 2002,	3,	1,	4,	108,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #2002 = XSMAXCDP
  { 2003,	3,	1,	4,	108,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #2003 = XSMAXDP
  { 2004,	3,	1,	4,	108,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #2004 = XSMAXJDP
  { 2005,	3,	1,	4,	108,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #2005 = XSMINCDP
  { 2006,	3,	1,	4,	108,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #2006 = XSMINDP
  { 2007,	3,	1,	4,	108,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo273, -1 ,nullptr },  // Inst #2007 = XSMINJDP
  { 2008,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #2008 = XSMSUBADP
  { 2009,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2009 = XSMSUBASP
  { 2010,	4,	1,	4,	151,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #2010 = XSMSUBMDP
  { 2011,	4,	1,	4,	151,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2011 = XSMSUBMSP
  { 2012,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2012 = XSMSUBQP
  { 2013,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2013 = XSMSUBQPO
  { 2014,	3,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #2014 = XSMULDP
  { 2015,	3,	1,	4,	167,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #2015 = XSMULQP
  { 2016,	3,	1,	4,	167,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #2016 = XSMULQPO
  { 2017,	3,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo272, -1 ,nullptr },  // Inst #2017 = XSMULSP
  { 2018,	2,	1,	4,	120,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2018 = XSNABSDP
  { 2019,	2,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #2019 = XSNABSQP
  { 2020,	2,	1,	4,	120,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2020 = XSNEGDP
  { 2021,	2,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #2021 = XSNEGQP
  { 2022,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #2022 = XSNMADDADP
  { 2023,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2023 = XSNMADDASP
  { 2024,	4,	1,	4,	151,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #2024 = XSNMADDMDP
  { 2025,	4,	1,	4,	151,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2025 = XSNMADDMSP
  { 2026,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2026 = XSNMADDQP
  { 2027,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2027 = XSNMADDQPO
  { 2028,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #2028 = XSNMSUBADP
  { 2029,	4,	1,	4,	151,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2029 = XSNMSUBASP
  { 2030,	4,	1,	4,	151,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo284, -1 ,nullptr },  // Inst #2030 = XSNMSUBMDP
  { 2031,	4,	1,	4,	151,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo285, -1 ,nullptr },  // Inst #2031 = XSNMSUBMSP
  { 2032,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2032 = XSNMSUBQP
  { 2033,	4,	1,	4,	167,	0, 0x0ULL, nullptr, nullptr, OperandInfo286, -1 ,nullptr },  // Inst #2033 = XSNMSUBQPO
  { 2034,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2034 = XSRDPI
  { 2035,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2035 = XSRDPIC
  { 2036,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2036 = XSRDPIM
  { 2037,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2037 = XSRDPIP
  { 2038,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2038 = XSRDPIZ
  { 2039,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2039 = XSREDP
  { 2040,	2,	1,	4,	159,	0, 0x0ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #2040 = XSRESP
  { 2041,	4,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2041 = XSRQPI
  { 2042,	4,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2042 = XSRQPIX
  { 2043,	4,	1,	4,	165,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo287, -1 ,nullptr },  // Inst #2043 = XSRQPXP
  { 2044,	2,	1,	4,	159,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo281, -1 ,nullptr },  // Inst #2044 = XSRSP
  { 2045,	2,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2045 = XSRSQRTEDP
  { 2046,	2,	1,	4,	159,	0, 0x0ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #2046 = XSRSQRTESP
  { 2047,	2,	1,	4,	261,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo270, -1 ,nullptr },  // Inst #2047 = XSSQRTDP
  { 2048,	2,	1,	4,	170,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #2048 = XSSQRTQP
  { 2049,	2,	1,	4,	170,	0, 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #2049 = XSSQRTQPO
  { 2050,	2,	1,	4,	266,	0, 0x0ULL, nullptr, nullptr, OperandInfo278, -1 ,nullptr },  // Inst #2050 = XSSQRTSP
  { 2051,	3,	1,	4,	159,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #2051 = XSSUBDP
  { 2052,	3,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #2052 = XSSUBQP
  { 2053,	3,	1,	4,	165,	0, 0x0ULL, nullptr, nullptr, OperandInfo68, -1 ,nullptr },  // Inst #2053 = XSSUBQPO
  { 2054,	3,	1,	4,	159,	0, 0x0ULL, nullptr, nullptr, OperandInfo272, -1 ,nullptr },  // Inst #2054 = XSSUBSP
  { 2055,	3,	1,	4,	109,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo274, -1 ,nullptr },  // Inst #2055 = XSTDIVDP
  { 2056,	2,	1,	4,	109,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo288, -1 ,nullptr },  // Inst #2056 = XSTSQRTDP
  { 2057,	3,	1,	4,	107,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2057 = XSTSTDCDP
  { 2058,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo290, -1 ,nullptr },  // Inst #2058 = XSTSTDCQP
  { 2059,	3,	1,	4,	107,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo289, -1 ,nullptr },  // Inst #2059 = XSTSTDCSP
  { 2060,	2,	1,	4,	120,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2060 = XSXEXPDP
  { 2061,	2,	1,	4,	98,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #2061 = XSXEXPQP
  { 2062,	2,	1,	4,	108,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo161, -1 ,nullptr },  // Inst #2062 = XSXSIGDP
  { 2063,	2,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo69, -1 ,nullptr },  // Inst #2063 = XSXSIGQP
  { 2064,	2,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2064 = XVABSDP
  { 2065,	2,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2065 = XVABSSP
  { 2066,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2066 = XVADDDP
  { 2067,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2067 = XVADDSP
  { 2068,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2068 = XVCMPEQDP
  { 2069,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, ImplicitList16, OperandInfo292, -1 ,nullptr },  // Inst #2069 = XVCMPEQDPo
  { 2070,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2070 = XVCMPEQSP
  { 2071,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, ImplicitList16, OperandInfo292, -1 ,nullptr },  // Inst #2071 = XVCMPEQSPo
  { 2072,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2072 = XVCMPGEDP
  { 2073,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, ImplicitList16, OperandInfo292, -1 ,nullptr },  // Inst #2073 = XVCMPGEDPo
  { 2074,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2074 = XVCMPGESP
  { 2075,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, ImplicitList16, OperandInfo292, -1 ,nullptr },  // Inst #2075 = XVCMPGESPo
  { 2076,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2076 = XVCMPGTDP
  { 2077,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, ImplicitList16, OperandInfo292, -1 ,nullptr },  // Inst #2077 = XVCMPGTDPo
  { 2078,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2078 = XVCMPGTSP
  { 2079,	3,	1,	4,	138,	0, 0x0ULL, ImplicitList2, ImplicitList16, OperandInfo292, -1 ,nullptr },  // Inst #2079 = XVCMPGTSPo
  { 2080,	3,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2080 = XVCPSGNDP
  { 2081,	3,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2081 = XVCPSGNSP
  { 2082,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2082 = XVCVDPSP
  { 2083,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2083 = XVCVDPSXDS
  { 2084,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2084 = XVCVDPSXWS
  { 2085,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2085 = XVCVDPUXDS
  { 2086,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2086 = XVCVDPUXWS
  { 2087,	2,	1,	4,	142,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2087 = XVCVHPSP
  { 2088,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2088 = XVCVSPDP
  { 2089,	2,	1,	4,	142,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2089 = XVCVSPHP
  { 2090,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2090 = XVCVSPSXDS
  { 2091,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2091 = XVCVSPSXWS
  { 2092,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2092 = XVCVSPUXDS
  { 2093,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2093 = XVCVSPUXWS
  { 2094,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2094 = XVCVSXDDP
  { 2095,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2095 = XVCVSXDSP
  { 2096,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2096 = XVCVSXWDP
  { 2097,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2097 = XVCVSXWSP
  { 2098,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2098 = XVCVUXDDP
  { 2099,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2099 = XVCVUXDSP
  { 2100,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2100 = XVCVUXWDP
  { 2101,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2101 = XVCVUXWSP
  { 2102,	3,	1,	4,	274,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2102 = XVDIVDP
  { 2103,	3,	1,	4,	273,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2103 = XVDIVSP
  { 2104,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2104 = XVIEXPDP
  { 2105,	3,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2105 = XVIEXPSP
  { 2106,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2106 = XVMADDADP
  { 2107,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2107 = XVMADDASP
  { 2108,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2108 = XVMADDMDP
  { 2109,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2109 = XVMADDMSP
  { 2110,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2110 = XVMAXDP
  { 2111,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2111 = XVMAXSP
  { 2112,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2112 = XVMINDP
  { 2113,	3,	1,	4,	140,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2113 = XVMINSP
  { 2114,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2114 = XVMSUBADP
  { 2115,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2115 = XVMSUBASP
  { 2116,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2116 = XVMSUBMDP
  { 2117,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2117 = XVMSUBMSP
  { 2118,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2118 = XVMULDP
  { 2119,	3,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2119 = XVMULSP
  { 2120,	2,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2120 = XVNABSDP
  { 2121,	2,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2121 = XVNABSSP
  { 2122,	2,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2122 = XVNEGDP
  { 2123,	2,	1,	4,	98,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2123 = XVNEGSP
  { 2124,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2124 = XVNMADDADP
  { 2125,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2125 = XVNMADDASP
  { 2126,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2126 = XVNMADDMDP
  { 2127,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2127 = XVNMADDMSP
  { 2128,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2128 = XVNMSUBADP
  { 2129,	4,	1,	4,	142,	0|(1ULL<<MCID::Commutable), 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2129 = XVNMSUBASP
  { 2130,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2130 = XVNMSUBMDP
  { 2131,	4,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo293, -1 ,nullptr },  // Inst #2131 = XVNMSUBMSP
  { 2132,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2132 = XVRDPI
  { 2133,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2133 = XVRDPIC
  { 2134,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2134 = XVRDPIM
  { 2135,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2135 = XVRDPIP
  { 2136,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2136 = XVRDPIZ
  { 2137,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2137 = XVREDP
  { 2138,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2138 = XVRESP
  { 2139,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2139 = XVRSPI
  { 2140,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2140 = XVRSPIC
  { 2141,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2141 = XVRSPIM
  { 2142,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2142 = XVRSPIP
  { 2143,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2143 = XVRSPIZ
  { 2144,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2144 = XVRSQRTEDP
  { 2145,	2,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2145 = XVRSQRTESP
  { 2146,	2,	1,	4,	263,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2146 = XVSQRTDP
  { 2147,	2,	1,	4,	264,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2147 = XVSQRTSP
  { 2148,	3,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2148 = XVSUBDP
  { 2149,	3,	1,	4,	142,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2149 = XVSUBSP
  { 2150,	3,	1,	4,	141,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo294, -1 ,nullptr },  // Inst #2150 = XVTDIVDP
  { 2151,	3,	1,	4,	141,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo294, -1 ,nullptr },  // Inst #2151 = XVTDIVSP
  { 2152,	2,	1,	4,	141,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo295, -1 ,nullptr },  // Inst #2152 = XVTSQRTDP
  { 2153,	2,	1,	4,	141,	0, 0x0ULL, ImplicitList2, nullptr, OperandInfo295, -1 ,nullptr },  // Inst #2153 = XVTSQRTSP
  { 2154,	3,	1,	4,	140,	0, 0x0ULL, nullptr, nullptr, OperandInfo296, -1 ,nullptr },  // Inst #2154 = XVTSTDCDP
  { 2155,	3,	1,	4,	140,	0, 0x0ULL, nullptr, nullptr, OperandInfo296, -1 ,nullptr },  // Inst #2155 = XVTSTDCSP
  { 2156,	2,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2156 = XVXEXPDP
  { 2157,	2,	1,	4,	98,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2157 = XVXEXPSP
  { 2158,	2,	1,	4,	140,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2158 = XVXSIGDP
  { 2159,	2,	1,	4,	140,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2159 = XVXSIGSP
  { 2160,	2,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2160 = XXBRD
  { 2161,	2,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2161 = XXBRH
  { 2162,	2,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2162 = XXBRQ
  { 2163,	2,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo291, -1 ,nullptr },  // Inst #2163 = XXBRW
  { 2164,	3,	1,	4,	162,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo297, -1 ,nullptr },  // Inst #2164 = XXEXTRACTUW
  { 2165,	4,	1,	4,	162,	0, 0x0ULL, nullptr, nullptr, OperandInfo298, -1 ,nullptr },  // Inst #2165 = XXINSERTW
  { 2166,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2166 = XXLAND
  { 2167,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2167 = XXLANDC
  { 2168,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2168 = XXLEQV
  { 2169,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2169 = XXLNAND
  { 2170,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2170 = XXLNOR
  { 2171,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2171 = XXLOR
  { 2172,	3,	1,	4,	97,	0, 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2172 = XXLORC
  { 2173,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo271, -1 ,nullptr },  // Inst #2173 = XXLORf
  { 2174,	3,	1,	4,	97,	0|(1ULL<<MCID::Commutable), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2174 = XXLXOR
  { 2175,	1,	1,	4,	97,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo299, -1 ,nullptr },  // Inst #2175 = XXLXORdpz
  { 2176,	1,	1,	4,	97,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo300, -1 ,nullptr },  // Inst #2176 = XXLXORspz
  { 2177,	1,	1,	4,	97,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove), 0x0ULL, nullptr, nullptr, OperandInfo301, -1 ,nullptr },  // Inst #2177 = XXLXORz
  { 2178,	3,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2178 = XXMRGHW
  { 2179,	3,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2179 = XXMRGLW
  { 2180,	3,	1,	4,	161,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2180 = XXPERM
  { 2181,	4,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo302, -1 ,nullptr },  // Inst #2181 = XXPERMDI
  { 2182,	3,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo303, -1 ,nullptr },  // Inst #2182 = XXPERMDIs
  { 2183,	3,	1,	4,	161,	0|(1ULL<<MCID::UnmodeledSideEffects), 0x0ULL, nullptr, nullptr, OperandInfo292, -1 ,nullptr },  // Inst #2183 = XXPERMR
  { 2184,	4,	1,	4,	99,	0, 0x0ULL, nullptr, nullptr, OperandInfo304, -1 ,nullptr },  // Inst #2184 = XXSEL
  { 2185,	4,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo302, -1 ,nullptr },  // Inst #2185 = XXSLDWI
  { 2186,	3,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo303, -1 ,nullptr },  // Inst #2186 = XXSLDWIs
  { 2187,	2,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo305, -1 ,nullptr },  // Inst #2187 = XXSPLTIB
  { 2188,	3,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo306, -1 ,nullptr },  // Inst #2188 = XXSPLTW
  { 2189,	3,	1,	4,	161,	0, 0x0ULL, nullptr, nullptr, OperandInfo303, -1 ,nullptr },  // Inst #2189 = XXSPLTWs
  { 2190,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo307, -1 ,nullptr },  // Inst #2190 = gBC
  { 2191,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo307, -1 ,nullptr },  // Inst #2191 = gBCA
  { 2192,	4,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo308, -1 ,nullptr },  // Inst #2192 = gBCAat
  { 2193,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, OperandInfo309, -1 ,nullptr },  // Inst #2193 = gBCCTR
  { 2194,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList26, OperandInfo309, -1 ,nullptr },  // Inst #2194 = gBCCTRL
  { 2195,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList26, OperandInfo307, -1 ,nullptr },  // Inst #2195 = gBCL
  { 2196,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList26, OperandInfo307, -1 ,nullptr },  // Inst #2196 = gBCLA
  { 2197,	4,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList26, OperandInfo308, -1 ,nullptr },  // Inst #2197 = gBCLAat
  { 2198,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList9, OperandInfo309, -1 ,nullptr },  // Inst #2198 = gBCLR
  { 2199,	3,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList18, ImplicitList26, OperandInfo309, -1 ,nullptr },  // Inst #2199 = gBCLRL
  { 2200,	4,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList26, OperandInfo308, -1 ,nullptr },  // Inst #2200 = gBCLat
  { 2201,	4,	0,	4,	287,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::UnmodeledSideEffects), 0x38ULL, ImplicitList11, ImplicitList9, OperandInfo308, -1 ,nullptr },  // Inst #2201 = gBCat
};

extern const char PPCInstrNameData[] = {
  /* 0 */ 'G', '_', 'F', 'L', 'O', 'G', '1', '0', 0,
  /* 9 */ 'M', 'T', 'F', 'S', 'B', '0', 0,
  /* 16 */ 'V', '_', 'S', 'E', 'T', '0', 0,
  /* 23 */ 'V', 'C', 'T', 'S', 'X', 'S', '_', '0', 0,
  /* 32 */ 'V', 'C', 'T', 'U', 'X', 'S', '_', '0', 0,
  /* 41 */ 'V', 'C', 'F', 'S', 'X', '_', '0', 0,
  /* 49 */ 'V', 'C', 'F', 'U', 'X', '_', '0', 0,
  /* 57 */ 'M', 'T', 'F', 'S', 'B', '1', 0,
  /* 64 */ 'A', 'D', 'D', 'I', 'S', 'd', 't', 'p', 'r', 'e', 'l', 'H', 'A', '3', '2', 0,
  /* 80 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '3', '2', 0,
  /* 100 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '3', '2', 0,
  /* 120 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 141 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 161 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'I', 'N', '_', 'I', '3', '2', 0,
  /* 182 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'I', 'N', '_', 'I', '3', '2', 0,
  /* 202 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '3', '2', 0,
  /* 218 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '3', '2', 0,
  /* 238 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 258 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 277 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'A', 'X', '_', 'I', '3', '2', 0,
  /* 298 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'A', 'X', '_', 'I', '3', '2', 0,
  /* 318 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'g', 'd', 'L', '3', '2', 0,
  /* 331 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'l', 'd', 'L', '3', '2', 0,
  /* 344 */ 'L', 'D', 'g', 'o', 't', 'T', 'p', 'r', 'e', 'l', 'L', '3', '2', 0,
  /* 358 */ 'A', 'D', 'D', 'I', 'd', 't', 'p', 'r', 'e', 'l', 'L', '3', '2', 0,
  /* 372 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'g', 'd', 'L', 'A', 'D', 'D', 'R', '3', '2', 0,
  /* 389 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'l', 'd', 'L', 'A', 'D', 'D', 'R', '3', '2', 0,
  /* 406 */ 'G', 'E', 'T', 't', 'l', 's', 'l', 'd', 'A', 'D', 'D', 'R', '3', '2', 0,
  /* 421 */ 'G', 'E', 'T', 't', 'l', 's', 'A', 'D', 'D', 'R', '3', '2', 0,
  /* 434 */ 'L', 'W', 'A', '_', '3', '2', 0,
  /* 441 */ 'S', 'R', 'A', 'D', 'I', '_', '3', '2', 0,
  /* 450 */ 'R', 'L', 'D', 'I', 'C', 'L', '_', '3', '2', 0,
  /* 460 */ 'R', 'L', 'D', 'I', 'C', 'R', '_', '3', '2', 0,
  /* 470 */ 'S', 'T', 'B', 'X', 'T', 'L', 'S', '_', '3', '2', 0,
  /* 481 */ 'S', 'T', 'H', 'X', 'T', 'L', 'S', '_', '3', '2', 0,
  /* 492 */ 'S', 'T', 'W', 'X', 'T', 'L', 'S', '_', '3', '2', 0,
  /* 503 */ 'L', 'B', 'Z', 'X', 'T', 'L', 'S', '_', '3', '2', 0,
  /* 514 */ 'L', 'H', 'Z', 'X', 'T', 'L', 'S', '_', '3', '2', 0,
  /* 525 */ 'L', 'W', 'Z', 'X', 'T', 'L', 'S', '_', '3', '2', 0,
  /* 536 */ 'E', 'X', 'T', 'S', 'W', '_', '3', '2', 0,
  /* 545 */ 'L', 'W', 'A', 'X', '_', '3', '2', 0,
  /* 553 */ 'D', 'F', 'L', 'O', 'A', 'D', 'f', '3', '2', 0,
  /* 563 */ 'X', 'F', 'L', 'O', 'A', 'D', 'f', '3', '2', 0,
  /* 573 */ 'D', 'F', 'S', 'T', 'O', 'R', 'E', 'f', '3', '2', 0,
  /* 584 */ 'X', 'F', 'S', 'T', 'O', 'R', 'E', 'f', '3', '2', 0,
  /* 595 */ 'E', 'H', '_', 'S', 'j', 'L', 'j', '_', 'L', 'o', 'n', 'g', 'J', 'm', 'p', '3', '2', 0,
  /* 613 */ 'E', 'H', '_', 'S', 'j', 'L', 'j', '_', 'S', 'e', 't', 'J', 'm', 'p', '3', '2', 0,
  /* 630 */ 'T', 'L', 'B', 'R', 'E', '2', 0,
  /* 637 */ 'T', 'L', 'B', 'W', 'E', '2', 0,
  /* 644 */ 'G', '_', 'F', 'L', 'O', 'G', '2', 0,
  /* 652 */ 'G', '_', 'F', 'E', 'X', 'P', '2', 0,
  /* 660 */ 'T', 'L', 'B', 'S', 'X', '2', 0,
  /* 667 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '6', '4', 0,
  /* 687 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '6', '4', 0,
  /* 707 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 728 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 748 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'I', 'N', '_', 'I', '6', '4', 0,
  /* 769 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'I', 'N', '_', 'I', '6', '4', 0,
  /* 789 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '6', '4', 0,
  /* 805 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '6', '4', 0,
  /* 825 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 845 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 864 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'A', 'X', '_', 'I', '6', '4', 0,
  /* 885 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'A', 'X', '_', 'I', '6', '4', 0,
  /* 905 */ 'D', 'S', 'T', '6', '4', 0,
  /* 911 */ 'D', 'S', 'T', 'S', 'T', '6', '4', 0,
  /* 919 */ 'D', 'S', 'T', 'T', '6', '4', 0,
  /* 926 */ 'D', 'S', 'T', 'S', 'T', 'T', '6', '4', 0,
  /* 935 */ 'E', 'X', 'T', 'S', 'B', '8', '_', '3', '2', '_', '6', '4', 0,
  /* 948 */ 'E', 'X', 'T', 'S', 'H', '8', '_', '3', '2', '_', '6', '4', 0,
  /* 961 */ 'E', 'X', 'T', 'S', 'W', 'S', 'L', 'I', '_', '3', '2', '_', '6', '4', 0,
  /* 976 */ 'R', 'L', 'D', 'I', 'C', 'L', '_', '3', '2', '_', '6', '4', 0,
  /* 989 */ 'E', 'X', 'T', 'S', 'W', '_', '3', '2', '_', '6', '4', 0,
  /* 1001 */ 'D', 'F', 'L', 'O', 'A', 'D', 'f', '6', '4', 0,
  /* 1011 */ 'X', 'F', 'L', 'O', 'A', 'D', 'f', '6', '4', 0,
  /* 1021 */ 'D', 'F', 'S', 'T', 'O', 'R', 'E', 'f', '6', '4', 0,
  /* 1032 */ 'X', 'F', 'S', 'T', 'O', 'R', 'E', 'f', '6', '4', 0,
  /* 1043 */ 'E', 'H', '_', 'S', 'j', 'L', 'j', '_', 'L', 'o', 'n', 'g', 'J', 'm', 'p', '6', '4', 0,
  /* 1061 */ 'E', 'H', '_', 'S', 'j', 'L', 'j', '_', 'S', 'e', 't', 'J', 'm', 'p', '6', '4', 0,
  /* 1078 */ 'A', 'D', 'D', '4', 0,
  /* 1083 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'S', 'P', 'E', '4', 0,
  /* 1098 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'S', 'P', 'E', '4', 0,
  /* 1110 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'F', '4', 0,
  /* 1123 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '4', 0,
  /* 1133 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'I', '4', 0,
  /* 1146 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '4', 0,
  /* 1156 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'F', '1', '6', 0,
  /* 1170 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '1', '6', 0,
  /* 1181 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '1', '6', 0,
  /* 1201 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '1', '6', 0,
  /* 1221 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '1', '6', 0,
  /* 1242 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '1', '6', 0,
  /* 1262 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'I', 'N', '_', 'I', '1', '6', 0,
  /* 1283 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'I', 'N', '_', 'I', '1', '6', 0,
  /* 1303 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '1', '6', 0,
  /* 1319 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '1', '6', 0,
  /* 1339 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '1', '6', 0,
  /* 1359 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '1', '6', 0,
  /* 1378 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'A', 'X', '_', 'I', '1', '6', 0,
  /* 1399 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'A', 'X', '_', 'I', '1', '6', 0,
  /* 1419 */ 'N', 'O', 'P', '_', 'G', 'T', '_', 'P', 'W', 'R', '6', 0,
  /* 1431 */ 'N', 'O', 'P', '_', 'G', 'T', '_', 'P', 'W', 'R', '7', 0,
  /* 1443 */ 'T', 'A', 'I', 'L', 'B', 'A', '8', 0,
  /* 1451 */ 'L', 'H', 'A', '8', 0,
  /* 1456 */ 'B', 'L', 'A', '8', 0,
  /* 1461 */ 'T', 'A', 'I', 'L', 'B', '8', 0,
  /* 1468 */ 'C', 'M', 'P', 'B', '8', 0,
  /* 1474 */ 'C', 'M', 'P', 'R', 'B', '8', 0,
  /* 1481 */ 'E', 'X', 'T', 'S', 'B', '8', 0,
  /* 1488 */ 'S', 'E', 'T', 'B', '8', 0,
  /* 1494 */ 'M', 'F', 'T', 'B', '8', 0,
  /* 1500 */ 'S', 'T', 'B', '8', 0,
  /* 1505 */ 'A', 'D', 'D', 'C', '8', 0,
  /* 1511 */ 'A', 'N', 'D', 'C', '8', 0,
  /* 1517 */ 'S', 'U', 'B', 'F', 'C', '8', 0,
  /* 1524 */ 'A', 'D', 'D', 'I', 'C', '8', 0,
  /* 1531 */ 'S', 'U', 'B', 'F', 'I', 'C', '8', 0,
  /* 1539 */ 'D', 'Y', 'N', 'A', 'L', 'L', 'O', 'C', '8', 0,
  /* 1549 */ 'O', 'R', 'C', '8', 0,
  /* 1554 */ 'A', 'D', 'D', '8', 0,
  /* 1559 */ 'M', 'A', 'D', 'D', 'L', 'D', '8', 0,
  /* 1567 */ 'N', 'A', 'N', 'D', '8', 0,
  /* 1573 */ 'C', 'F', 'E', 'N', 'C', 'E', '8', 0,
  /* 1581 */ 'A', 'D', 'D', 'E', '8', 0,
  /* 1587 */ 'S', 'U', 'B', 'F', 'E', '8', 0,
  /* 1594 */ 'A', 'D', 'D', 'M', 'E', '8', 0,
  /* 1601 */ 'S', 'U', 'B', 'F', 'M', 'E', '8', 0,
  /* 1609 */ 'C', 'P', '_', 'P', 'A', 'S', 'T', 'E', '8', 0,
  /* 1619 */ 'A', 'D', 'D', 'Z', 'E', '8', 0,
  /* 1626 */ 'S', 'U', 'B', 'F', 'Z', 'E', '8', 0,
  /* 1634 */ 'S', 'U', 'B', 'F', '8', 0,
  /* 1640 */ 'M', 'F', 'O', 'C', 'R', 'F', '8', 0,
  /* 1648 */ 'M', 'T', 'O', 'C', 'R', 'F', '8', 0,
  /* 1656 */ 'M', 'T', 'C', 'R', 'F', '8', 0,
  /* 1663 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'F', '8', 0,
  /* 1676 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '8', 0,
  /* 1686 */ 'N', 'E', 'G', '8', 0,
  /* 1691 */ 'E', 'X', 'T', 'S', 'H', '8', 0,
  /* 1698 */ 'S', 'T', 'H', '8', 0,
  /* 1703 */ 'A', 'D', 'D', 'I', '8', 0,
  /* 1709 */ 'M', 'U', 'L', 'L', 'I', '8', 0,
  /* 1716 */ 'R', 'L', 'W', 'I', 'M', 'I', '8', 0,
  /* 1724 */ 'X', 'O', 'R', 'I', '8', 0,
  /* 1730 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'S', 'U', 'B', '_', 'I', '8', 0,
  /* 1749 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'I', '8', 0,
  /* 1762 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'D', 'D', '_', 'I', '8', 0,
  /* 1781 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'N', 'A', 'N', 'D', '_', 'I', '8', 0,
  /* 1801 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'A', 'N', 'D', '_', 'I', '8', 0,
  /* 1820 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'I', 'N', '_', 'I', '8', 0,
  /* 1840 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'I', 'N', '_', 'I', '8', 0,
  /* 1859 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'W', 'A', 'P', '_', 'I', '8', 0,
  /* 1874 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', '_', 'S', 'W', 'A', 'P', '_', 'I', '8', 0,
  /* 1893 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'X', 'O', 'R', '_', 'I', '8', 0,
  /* 1912 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'O', 'R', '_', 'I', '8', 0,
  /* 1930 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '8', 0,
  /* 1940 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'U', 'M', 'A', 'X', '_', 'I', '8', 0,
  /* 1960 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'M', 'A', 'X', '_', 'I', '8', 0,
  /* 1979 */ 'B', 'L', '8', 0,
  /* 1983 */ 'I', 'S', 'E', 'L', '8', 0,
  /* 1989 */ 'B', 'C', 'T', 'R', 'L', '8', 0,
  /* 1996 */ 'B', 'C', 'C', 'T', 'R', 'L', '8', 0,
  /* 2004 */ 'B', 'C', 'C', 'C', 'T', 'R', 'L', '8', 0,
  /* 2013 */ 'R', 'L', 'W', 'I', 'N', 'M', '8', 0,
  /* 2021 */ 'R', 'L', 'W', 'N', 'M', '8', 0,
  /* 2028 */ 'M', 'F', 'C', 'R', '8', 0,
  /* 2034 */ 'B', 'L', 'R', '8', 0,
  /* 2039 */ 'M', 'F', 'L', 'R', '8', 0,
  /* 2045 */ 'M', 'T', 'L', 'R', '8', 0,
  /* 2051 */ 'B', 'D', 'Z', 'L', 'R', '8', 0,
  /* 2058 */ 'B', 'D', 'N', 'Z', 'L', 'R', '8', 0,
  /* 2066 */ 'M', 'o', 'v', 'e', 'P', 'C', 't', 'o', 'L', 'R', '8', 0,
  /* 2078 */ 'N', 'O', 'R', '8', 0,
  /* 2083 */ 'X', 'O', 'R', '8', 0,
  /* 2088 */ 'M', 'F', 'S', 'P', 'R', '8', 0,
  /* 2095 */ 'M', 'T', 'S', 'P', 'R', '8', 0,
  /* 2102 */ 'T', 'A', 'I', 'L', 'B', 'C', 'T', 'R', '8', 0,
  /* 2112 */ 'B', 'C', 'C', 'T', 'R', '8', 0,
  /* 2119 */ 'B', 'C', 'C', 'C', 'T', 'R', '8', 0,
  /* 2127 */ 'M', 'F', 'C', 'T', 'R', '8', 0,
  /* 2134 */ 'M', 'T', 'C', 'T', 'R', '8', 0,
  /* 2141 */ 'A', 'D', 'D', 'I', 'S', '8', 0,
  /* 2148 */ 'L', 'I', 'S', '8', 0,
  /* 2153 */ 'X', 'O', 'R', 'I', 'S', '8', 0,
  /* 2160 */ 'D', 'Y', 'N', 'A', 'R', 'E', 'A', 'O', 'F', 'F', 'S', 'E', 'T', '8', 0,
  /* 2175 */ 'A', 'N', 'D', 'I', 'o', '_', '1', '_', 'E', 'Q', '_', 'B', 'I', 'T', '8', 0,
  /* 2191 */ 'A', 'N', 'D', 'I', 'o', '_', '1', '_', 'G', 'T', '_', 'B', 'I', 'T', '8', 0,
  /* 2207 */ 'L', 'H', 'A', 'U', '8', 0,
  /* 2213 */ 'S', 'T', 'B', 'U', '8', 0,
  /* 2219 */ 'S', 'T', 'H', 'U', '8', 0,
  /* 2225 */ 'S', 'T', 'W', 'U', '8', 0,
  /* 2231 */ 'L', 'B', 'Z', 'U', '8', 0,
  /* 2237 */ 'L', 'H', 'Z', 'U', '8', 0,
  /* 2243 */ 'L', 'W', 'Z', 'U', '8', 0,
  /* 2249 */ 'E', 'Q', 'V', '8', 0,
  /* 2254 */ 'S', 'L', 'W', '8', 0,
  /* 2259 */ 'S', 'R', 'W', '8', 0,
  /* 2264 */ 'S', 'T', 'W', '8', 0,
  /* 2269 */ 'C', 'N', 'T', 'L', 'Z', 'W', '8', 0,
  /* 2277 */ 'C', 'N', 'T', 'T', 'Z', 'W', '8', 0,
  /* 2285 */ 'L', 'H', 'A', 'X', '8', 0,
  /* 2291 */ 'S', 'T', 'B', 'X', '8', 0,
  /* 2297 */ 'S', 'T', 'H', 'X', '8', 0,
  /* 2303 */ 'L', 'H', 'B', 'R', 'X', '8', 0,
  /* 2310 */ 'L', 'W', 'B', 'R', 'X', '8', 0,
  /* 2317 */ 'L', 'H', 'A', 'U', 'X', '8', 0,
  /* 2324 */ 'S', 'T', 'B', 'U', 'X', '8', 0,
  /* 2331 */ 'S', 'T', 'H', 'U', 'X', '8', 0,
  /* 2338 */ 'S', 'T', 'W', 'U', 'X', '8', 0,
  /* 2345 */ 'L', 'B', 'Z', 'U', 'X', '8', 0,
  /* 2352 */ 'L', 'H', 'Z', 'U', 'X', '8', 0,
  /* 2359 */ 'L', 'W', 'Z', 'U', 'X', '8', 0,
  /* 2366 */ 'S', 'T', 'W', 'X', '8', 0,
  /* 2372 */ 'L', 'B', 'Z', 'X', '8', 0,
  /* 2378 */ 'L', 'H', 'Z', 'X', '8', 0,
  /* 2384 */ 'L', 'W', 'Z', 'X', '8', 0,
  /* 2390 */ 'C', 'P', '_', 'C', 'O', 'P', 'Y', '8', 0,
  /* 2399 */ 'L', 'B', 'Z', '8', 0,
  /* 2404 */ 'B', 'D', 'Z', '8', 0,
  /* 2409 */ 'L', 'H', 'Z', '8', 0,
  /* 2414 */ 'B', 'D', 'N', 'Z', '8', 0,
  /* 2420 */ 'L', 'W', 'Z', '8', 0,
  /* 2425 */ 'T', 'C', 'R', 'E', 'T', 'U', 'R', 'N', 'a', 'i', '8', 0,
  /* 2437 */ 'T', 'C', 'R', 'E', 'T', 'U', 'R', 'N', 'd', 'i', '8', 0,
  /* 2449 */ 'T', 'C', 'R', 'E', 'T', 'U', 'R', 'N', 'r', 'i', '8', 0,
  /* 2461 */ 'A', 'N', 'D', 'I', 'o', '8', 0,
  /* 2468 */ 'A', 'N', 'D', 'I', 'S', 'o', '8', 0,
  /* 2476 */ 'E', 'V', 'M', 'H', 'E', 'G', 'S', 'M', 'F', 'A', 'A', 0,
  /* 2488 */ 'E', 'V', 'M', 'H', 'O', 'G', 'S', 'M', 'F', 'A', 'A', 0,
  /* 2500 */ 'E', 'V', 'M', 'W', 'S', 'M', 'F', 'A', 'A', 0,
  /* 2510 */ 'E', 'V', 'M', 'W', 'S', 'S', 'F', 'A', 'A', 0,
  /* 2520 */ 'E', 'V', 'M', 'H', 'E', 'G', 'S', 'M', 'I', 'A', 'A', 0,
  /* 2532 */ 'E', 'V', 'M', 'H', 'O', 'G', 'S', 'M', 'I', 'A', 'A', 0,
  /* 2544 */ 'E', 'V', 'M', 'W', 'S', 'M', 'I', 'A', 'A', 0,
  /* 2554 */ 'E', 'V', 'M', 'H', 'E', 'G', 'U', 'M', 'I', 'A', 'A', 0,
  /* 2566 */ 'E', 'V', 'M', 'H', 'O', 'G', 'U', 'M', 'I', 'A', 'A', 0,
  /* 2578 */ 'E', 'V', 'M', 'W', 'U', 'M', 'I', 'A', 'A', 0,
  /* 2588 */ 'D', 'C', 'B', 'A', 0,
  /* 2593 */ 'T', 'A', 'I', 'L', 'B', 'A', 0,
  /* 2600 */ 'L', 'D', 't', 'o', 'c', 'B', 'A', 0,
  /* 2608 */ 'g', 'B', 'C', 'A', 0,
  /* 2613 */ 'B', 'C', 'C', 'A', 0,
  /* 2618 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'F', 'A', 0,
  /* 2628 */ 'E', 'V', 'M', 'W', 'H', 'S', 'M', 'F', 'A', 0,
  /* 2638 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'F', 'A', 0,
  /* 2648 */ 'E', 'V', 'M', 'W', 'S', 'M', 'F', 'A', 0,
  /* 2657 */ 'E', 'V', 'M', 'H', 'E', 'S', 'S', 'F', 'A', 0,
  /* 2667 */ 'E', 'V', 'M', 'W', 'H', 'S', 'S', 'F', 'A', 0,
  /* 2677 */ 'E', 'V', 'M', 'H', 'O', 'S', 'S', 'F', 'A', 0,
  /* 2687 */ 'E', 'V', 'M', 'W', 'S', 'S', 'F', 'A', 0,
  /* 2696 */ 'L', 'H', 'A', 0,
  /* 2700 */ 'A', 'D', 'D', 'I', 'S', 't', 'o', 'c', 'H', 'A', 0,
  /* 2711 */ 'A', 'D', 'D', 'I', 'S', 't', 'l', 's', 'g', 'd', 'H', 'A', 0,
  /* 2724 */ 'A', 'D', 'D', 'I', 'S', 't', 'l', 's', 'l', 'd', 'H', 'A', 0,
  /* 2737 */ 'A', 'D', 'D', 'I', 'S', 'g', 'o', 't', 'T', 'p', 'r', 'e', 'l', 'H', 'A', 0,
  /* 2753 */ 'A', 'D', 'D', 'I', 'S', 'd', 't', 'p', 'r', 'e', 'l', 'H', 'A', 0,
  /* 2767 */ 'S', 'L', 'B', 'I', 'A', 0,
  /* 2773 */ 'T', 'L', 'B', 'I', 'A', 0,
  /* 2779 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'I', 'A', 0,
  /* 2789 */ 'E', 'V', 'M', 'W', 'H', 'S', 'M', 'I', 'A', 0,
  /* 2799 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'I', 'A', 0,
  /* 2809 */ 'E', 'V', 'M', 'W', 'S', 'M', 'I', 'A', 0,
  /* 2818 */ 'E', 'V', 'M', 'H', 'E', 'U', 'M', 'I', 'A', 0,
  /* 2828 */ 'E', 'V', 'M', 'W', 'H', 'U', 'M', 'I', 'A', 0,
  /* 2838 */ 'E', 'V', 'M', 'W', 'L', 'U', 'M', 'I', 'A', 0,
  /* 2848 */ 'E', 'V', 'M', 'H', 'O', 'U', 'M', 'I', 'A', 0,
  /* 2858 */ 'E', 'V', 'M', 'W', 'U', 'M', 'I', 'A', 0,
  /* 2867 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'X', 'I', 'A', 0,
  /* 2878 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'X', 'I', 'A', 0,
  /* 2888 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'X', 'I', 'A', 0,
  /* 2899 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'X', 'I', 'A', 0,
  /* 2909 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'U', 'X', 'I', 'A', 0,
  /* 2921 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'U', 'X', 'I', 'A', 0,
  /* 2932 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'U', 'X', 'I', 'A', 0,
  /* 2944 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'U', 'X', 'I', 'A', 0,
  /* 2955 */ 'B', 'L', 'A', 0,
  /* 2959 */ 'g', 'B', 'C', 'L', 'A', 0,
  /* 2965 */ 'B', 'C', 'C', 'L', 'A', 0,
  /* 2971 */ 'B', 'D', 'Z', 'L', 'A', 0,
  /* 2977 */ 'B', 'D', 'N', 'Z', 'L', 'A', 0,
  /* 2984 */ 'G', '_', 'F', 'M', 'A', 0,
  /* 2990 */ 'E', 'V', 'M', 'R', 'A', 0,
  /* 2996 */ 'L', 'W', 'A', 0,
  /* 3000 */ 'M', 'T', 'V', 'S', 'R', 'W', 'A', 0,
  /* 3008 */ 'Q', 'V', 'L', 'F', 'I', 'W', 'A', 'X', 'A', 0,
  /* 3018 */ 'Q', 'V', 'L', 'F', 'C', 'D', 'X', 'A', 0,
  /* 3027 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'X', 'A', 0,
  /* 3037 */ 'Q', 'V', 'L', 'F', 'D', 'X', 'A', 0,
  /* 3045 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'X', 'A', 0,
  /* 3054 */ 'Q', 'V', 'L', 'F', 'C', 'S', 'X', 'A', 0,
  /* 3063 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'X', 'A', 0,
  /* 3073 */ 'Q', 'V', 'L', 'F', 'S', 'X', 'A', 0,
  /* 3081 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'X', 'A', 0,
  /* 3090 */ 'Q', 'V', 'L', 'F', 'C', 'D', 'U', 'X', 'A', 0,
  /* 3100 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'U', 'X', 'A', 0,
  /* 3111 */ 'Q', 'V', 'L', 'F', 'D', 'U', 'X', 'A', 0,
  /* 3120 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'U', 'X', 'A', 0,
  /* 3130 */ 'Q', 'V', 'L', 'F', 'C', 'S', 'U', 'X', 'A', 0,
  /* 3140 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'U', 'X', 'A', 0,
  /* 3151 */ 'Q', 'V', 'L', 'F', 'S', 'U', 'X', 'A', 0,
  /* 3160 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'U', 'X', 'A', 0,
  /* 3170 */ 'Q', 'V', 'S', 'T', 'F', 'I', 'W', 'X', 'A', 0,
  /* 3180 */ 'Q', 'V', 'L', 'F', 'I', 'W', 'Z', 'X', 'A', 0,
  /* 3190 */ 'B', 'D', 'Z', 'A', 0,
  /* 3195 */ 'B', 'D', 'N', 'Z', 'A', 0,
  /* 3201 */ 'V', '_', 'S', 'E', 'T', '0', 'B', 0,
  /* 3209 */ 'V', 'S', 'R', 'A', 'B', 0,
  /* 3215 */ 'R', 'F', 'E', 'B', 'B', 0,
  /* 3221 */ 'V', 'C', 'L', 'Z', 'L', 'S', 'B', 'B', 0,
  /* 3230 */ 'V', 'C', 'T', 'Z', 'L', 'S', 'B', 'B', 0,
  /* 3239 */ 'V', 'C', 'M', 'P', 'N', 'E', 'B', 0,
  /* 3247 */ 'V', 'M', 'R', 'G', 'H', 'B', 0,
  /* 3254 */ 'X', 'X', 'S', 'P', 'L', 'T', 'I', 'B', 0,
  /* 3263 */ 'V', 'M', 'R', 'G', 'L', 'B', 0,
  /* 3270 */ 'T', 'A', 'I', 'L', 'B', 0,
  /* 3276 */ 'V', 'R', 'L', 'B', 0,
  /* 3281 */ 'V', 'S', 'L', 'B', 0,
  /* 3286 */ 'V', 'P', 'M', 'S', 'U', 'M', 'B', 0,
  /* 3294 */ 'C', 'M', 'P', 'B', 0,
  /* 3299 */ 'C', 'M', 'P', 'E', 'Q', 'B', 0,
  /* 3306 */ 'C', 'L', 'R', 'B', 'H', 'R', 'B', 0,
  /* 3314 */ 'C', 'M', 'P', 'R', 'B', 0,
  /* 3320 */ 'V', 'S', 'R', 'B', 0,
  /* 3325 */ 'V', 'M', 'U', 'L', 'E', 'S', 'B', 0,
  /* 3333 */ 'V', '_', 'S', 'E', 'T', 'A', 'L', 'L', 'O', 'N', 'E', 'S', 'B', 0,
  /* 3347 */ 'V', 'A', 'V', 'G', 'S', 'B', 0,
  /* 3354 */ 'V', 'U', 'P', 'K', 'H', 'S', 'B', 0,
  /* 3362 */ 'V', 'S', 'P', 'L', 'T', 'I', 'S', 'B', 0,
  /* 3371 */ 'V', 'U', 'P', 'K', 'L', 'S', 'B', 0,
  /* 3379 */ 'V', 'M', 'I', 'N', 'S', 'B', 0,
  /* 3386 */ 'V', 'M', 'U', 'L', 'O', 'S', 'B', 0,
  /* 3394 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'B', 0,
  /* 3403 */ 'E', 'V', 'E', 'X', 'T', 'S', 'B', 0,
  /* 3411 */ 'V', 'M', 'A', 'X', 'S', 'B', 0,
  /* 3418 */ 'S', 'E', 'T', 'B', 0,
  /* 3423 */ 'M', 'F', 'T', 'B', 0,
  /* 3428 */ 'V', 'S', 'P', 'L', 'T', 'B', 0,
  /* 3435 */ 'V', 'P', 'O', 'P', 'C', 'N', 'T', 'B', 0,
  /* 3444 */ 'V', 'I', 'N', 'S', 'E', 'R', 'T', 'B', 0,
  /* 3453 */ 'S', 'T', 'B', 0,
  /* 3457 */ 'R', 'e', 'a', 'd', 'T', 'B', 0,
  /* 3464 */ 'V', 'A', 'B', 'S', 'D', 'U', 'B', 0,
  /* 3472 */ 'V', 'M', 'U', 'L', 'E', 'U', 'B', 0,
  /* 3480 */ 'V', 'A', 'V', 'G', 'U', 'B', 0,
  /* 3487 */ 'V', 'M', 'I', 'N', 'U', 'B', 0,
  /* 3494 */ 'V', 'M', 'U', 'L', 'O', 'U', 'B', 0,
  /* 3502 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'B', 0,
  /* 3511 */ 'E', 'F', 'D', 'S', 'U', 'B', 0,
  /* 3518 */ 'Q', 'V', 'F', 'S', 'U', 'B', 0,
  /* 3525 */ 'G', '_', 'F', 'S', 'U', 'B', 0,
  /* 3532 */ 'Q', 'V', 'F', 'M', 'S', 'U', 'B', 0,
  /* 3540 */ 'Q', 'V', 'F', 'N', 'M', 'S', 'U', 'B', 0,
  /* 3549 */ 'E', 'F', 'S', 'S', 'U', 'B', 0,
  /* 3556 */ 'E', 'V', 'F', 'S', 'S', 'U', 'B', 0,
  /* 3564 */ 'G', '_', 'S', 'U', 'B', 0,
  /* 3570 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'S', 'U', 'B', 0,
  /* 3586 */ 'V', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 'U', 'B', 0,
  /* 3597 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'B', 0,
  /* 3606 */ 'V', 'M', 'A', 'X', 'U', 'B', 0,
  /* 3613 */ 'V', 'C', 'M', 'P', 'N', 'E', 'Z', 'B', 0,
  /* 3622 */ 'V', 'C', 'L', 'Z', 'B', 0,
  /* 3628 */ 'V', 'C', 'T', 'Z', 'B', 0,
  /* 3634 */ 'g', 'B', 'C', 0,
  /* 3638 */ 'B', 'C', 'C', 0,
  /* 3642 */ 'A', 'D', 'D', 'C', 0,
  /* 3647 */ 'X', 'X', 'L', 'A', 'N', 'D', 'C', 0,
  /* 3655 */ 'C', 'R', 'A', 'N', 'D', 'C', 0,
  /* 3662 */ 'E', 'V', 'A', 'N', 'D', 'C', 0,
  /* 3669 */ 'T', 'A', 'B', 'O', 'R', 'T', 'D', 'C', 0,
  /* 3678 */ 'S', 'U', 'B', 'F', 'C', 0,
  /* 3684 */ 'S', 'U', 'B', 'I', 'C', 0,
  /* 3690 */ 'A', 'D', 'D', 'I', 'C', 0,
  /* 3696 */ 'R', 'L', 'D', 'I', 'C', 0,
  /* 3702 */ 'S', 'U', 'B', 'F', 'I', 'C', 0,
  /* 3709 */ 'X', 'S', 'R', 'D', 'P', 'I', 'C', 0,
  /* 3717 */ 'X', 'V', 'R', 'D', 'P', 'I', 'C', 0,
  /* 3725 */ 'X', 'V', 'R', 'S', 'P', 'I', 'C', 0,
  /* 3733 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', 0,
  /* 3745 */ 'I', 'C', 'B', 'L', 'C', 0,
  /* 3751 */ 'B', 'R', 'I', 'N', 'C', 0,
  /* 3757 */ 'G', '_', 'F', 'P', 'T', 'R', 'U', 'N', 'C', 0,
  /* 3767 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 3785 */ 'G', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 3793 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 3814 */ 'S', 'L', 'B', 'S', 'Y', 'N', 'C', 0,
  /* 3822 */ 'T', 'L', 'B', 'S', 'Y', 'N', 'C', 0,
  /* 3830 */ 'M', 'S', 'G', 'S', 'Y', 'N', 'C', 0,
  /* 3838 */ 'I', 'S', 'Y', 'N', 'C', 0,
  /* 3844 */ 'M', 'S', 'Y', 'N', 'C', 0,
  /* 3850 */ 'D', 'Y', 'N', 'A', 'L', 'L', 'O', 'C', 0,
  /* 3859 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'Q', 'B', 'R', 'C', 0,
  /* 3874 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'Q', 'B', 'R', 'C', 0,
  /* 3886 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'Q', 'F', 'R', 'C', 0,
  /* 3901 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'Q', 'F', 'R', 'C', 0,
  /* 3913 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'V', 'S', 'F', 'R', 'C', 0,
  /* 3929 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'V', 'S', 'F', 'R', 'C', 0,
  /* 3942 */ 'X', 'X', 'L', 'O', 'R', 'C', 0,
  /* 3949 */ 'C', 'R', 'O', 'R', 'C', 0,
  /* 3955 */ 'E', 'V', 'O', 'R', 'C', 0,
  /* 3961 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'V', 'R', 'R', 'C', 0,
  /* 3976 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'V', 'R', 'R', 'C', 0,
  /* 3988 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'Q', 'S', 'R', 'C', 0,
  /* 4003 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'Q', 'S', 'R', 'C', 0,
  /* 4015 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'V', 'S', 'S', 'R', 'C', 0,
  /* 4031 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'V', 'S', 'S', 'R', 'C', 0,
  /* 4044 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'V', 'S', 'R', 'C', 0,
  /* 4059 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'V', 'S', 'R', 'C', 0,
  /* 4071 */ 'S', 'C', 0,
  /* 4074 */ 'T', 'A', 'B', 'O', 'R', 'T', 'W', 'C', 0,
  /* 4083 */ 'V', 'E', 'X', 'T', 'S', 'B', '2', 'D', 0,
  /* 4092 */ 'V', 'E', 'X', 'T', 'S', 'H', '2', 'D', 0,
  /* 4101 */ 'V', 'E', 'X', 'T', 'S', 'W', '2', 'D', 0,
  /* 4110 */ 'T', 'L', 'B', 'S', 'X', '2', 'D', 0,
  /* 4118 */ 'V', 'S', 'H', 'A', 'S', 'I', 'G', 'M', 'A', 'D', 0,
  /* 4129 */ 'G', '_', 'S', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 4140 */ 'G', '_', 'Z', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 4151 */ 'G', '_', 'L', 'O', 'A', 'D', 0,
  /* 4158 */ 'V', 'S', 'R', 'A', 'D', 0,
  /* 4164 */ 'V', 'G', 'B', 'B', 'D', 0,
  /* 4170 */ 'V', 'P', 'R', 'T', 'Y', 'B', 'D', 0,
  /* 4178 */ 'E', 'F', 'D', 'A', 'D', 'D', 0,
  /* 4185 */ 'Q', 'V', 'F', 'A', 'D', 'D', 0,
  /* 4192 */ 'G', '_', 'F', 'A', 'D', 'D', 0,
  /* 4199 */ 'Q', 'V', 'F', 'M', 'A', 'D', 'D', 0,
  /* 4207 */ 'Q', 'V', 'F', 'N', 'M', 'A', 'D', 'D', 0,
  /* 4216 */ 'Q', 'V', 'F', 'X', 'X', 'C', 'P', 'N', 'M', 'A', 'D', 'D', 0,
  /* 4229 */ 'Q', 'V', 'F', 'X', 'X', 'N', 'P', 'M', 'A', 'D', 'D', 0,
  /* 4241 */ 'Q', 'V', 'F', 'X', 'M', 'A', 'D', 'D', 0,
  /* 4250 */ 'Q', 'V', 'F', 'X', 'X', 'M', 'A', 'D', 'D', 0,
  /* 4260 */ 'E', 'F', 'S', 'A', 'D', 'D', 0,
  /* 4267 */ 'E', 'V', 'F', 'S', 'A', 'D', 'D', 0,
  /* 4275 */ 'G', '_', 'A', 'D', 'D', 0,
  /* 4281 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'D', 'D', 0,
  /* 4297 */ 'E', 'V', 'L', 'D', 'D', 0,
  /* 4303 */ 'M', 'T', 'V', 'S', 'R', 'D', 'D', 0,
  /* 4311 */ 'E', 'V', 'S', 'T', 'D', 'D', 0,
  /* 4318 */ 'E', 'F', 'S', 'C', 'F', 'D', 0,
  /* 4325 */ 'L', 'F', 'D', 0,
  /* 4329 */ 'S', 'T', 'F', 'D', 0,
  /* 4334 */ 'F', 'N', 'E', 'G', 'D', 0,
  /* 4340 */ 'V', 'N', 'E', 'G', 'D', 0,
  /* 4346 */ 'M', 'A', 'D', 'D', 'H', 'D', 0,
  /* 4353 */ 'M', 'U', 'L', 'H', 'D', 0,
  /* 4359 */ 'Q', 'V', 'F', 'C', 'F', 'I', 'D', 0,
  /* 4367 */ 'H', 'R', 'F', 'I', 'D', 0,
  /* 4373 */ 'E', 'F', 'D', 'C', 'F', 'S', 'I', 'D', 0,
  /* 4382 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'D', 0,
  /* 4390 */ 'E', 'F', 'D', 'C', 'F', 'U', 'I', 'D', 0,
  /* 4399 */ 'T', 'L', 'B', 'L', 'D', 0,
  /* 4405 */ 'M', 'A', 'D', 'D', 'L', 'D', 0,
  /* 4412 */ 'F', 'S', 'E', 'L', 'D', 0,
  /* 4418 */ 'M', 'U', 'L', 'L', 'D', 0,
  /* 4424 */ 'C', 'M', 'P', 'L', 'D', 0,
  /* 4430 */ 'M', 'F', 'V', 'S', 'R', 'L', 'D', 0,
  /* 4438 */ 'V', 'R', 'L', 'D', 0,
  /* 4443 */ 'V', 'S', 'L', 'D', 0,
  /* 4448 */ 'S', 'P', 'I', 'L', 'L', 'T', 'O', 'V', 'S', 'R', '_', 'L', 'D', 0,
  /* 4462 */ 'F', 'R', 'I', 'M', 'D', 0,
  /* 4468 */ 'V', 'B', 'P', 'E', 'R', 'M', 'D', 0,
  /* 4476 */ 'V', 'P', 'M', 'S', 'U', 'M', 'D', 0,
  /* 4484 */ 'X', 'X', 'L', 'A', 'N', 'D', 0,
  /* 4491 */ 'X', 'X', 'L', 'N', 'A', 'N', 'D', 0,
  /* 4499 */ 'C', 'R', 'N', 'A', 'N', 'D', 0,
  /* 4506 */ 'E', 'V', 'N', 'A', 'N', 'D', 0,
  /* 4513 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'N', 'A', 'N', 'D', 0,
  /* 4530 */ 'C', 'R', 'A', 'N', 'D', 0,
  /* 4536 */ 'E', 'V', 'A', 'N', 'D', 0,
  /* 4542 */ 'G', '_', 'A', 'N', 'D', 0,
  /* 4548 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'N', 'D', 0,
  /* 4564 */ 'T', 'E', 'N', 'D', 0,
  /* 4569 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'E', 'N', 'D', 0,
  /* 4582 */ 'F', 'C', 'P', 'S', 'G', 'N', 'D', 0,
  /* 4590 */ 'F', 'R', 'I', 'N', 'D', 0,
  /* 4596 */ 'G', '_', 'B', 'R', 'C', 'O', 'N', 'D', 0,
  /* 4605 */ 'S', 'E', 'T', 'R', 'N', 'D', 0,
  /* 4612 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'R', 'O', 'U', 'N', 'D', 0,
  /* 4630 */ 'F', 'R', 'I', 'P', 'D', 0,
  /* 4636 */ 'C', 'M', 'P', 'D', 0,
  /* 4641 */ 'L', 'O', 'A', 'D', '_', 'S', 'T', 'A', 'C', 'K', '_', 'G', 'U', 'A', 'R', 'D', 0,
  /* 4658 */ 'X', 'X', 'B', 'R', 'D', 0,
  /* 4664 */ 'M', 'T', 'M', 'S', 'R', 'D', 0,
  /* 4671 */ 'M', 'F', 'V', 'S', 'R', 'D', 0,
  /* 4678 */ 'M', 'T', 'V', 'S', 'R', 'D', 0,
  /* 4685 */ 'M', 'F', 'V', 'R', 'D', 0,
  /* 4691 */ 'F', 'A', 'B', 'S', 'D', 0,
  /* 4697 */ 'F', 'N', 'A', 'B', 'S', 'D', 0,
  /* 4704 */ 'M', 'O', 'D', 'S', 'D', 0,
  /* 4710 */ 'V', 'M', 'I', 'N', 'S', 'D', 0,
  /* 4717 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'D', 0,
  /* 4726 */ 'V', 'M', 'A', 'X', 'S', 'D', 0,
  /* 4733 */ 'L', 'X', 'S', 'D', 0,
  /* 4738 */ 'S', 'T', 'X', 'S', 'D', 0,
  /* 4744 */ 'V', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 'D', 0,
  /* 4754 */ 'V', 'P', 'O', 'P', 'C', 'N', 'T', 'D', 0,
  /* 4763 */ 'V', 'I', 'N', 'S', 'E', 'R', 'T', 'D', 0,
  /* 4772 */ 'S', 'T', 'D', 0,
  /* 4776 */ 'M', 'O', 'D', 'U', 'D', 0,
  /* 4782 */ 'V', 'M', 'I', 'N', 'U', 'D', 0,
  /* 4789 */ 'F', 'C', 'M', 'P', 'U', 'D', 0,
  /* 4796 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'D', 0,
  /* 4805 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'D', 0,
  /* 4814 */ 'V', 'M', 'A', 'X', 'U', 'D', 0,
  /* 4821 */ 'D', 'I', 'V', 'D', 0,
  /* 4826 */ 'F', 'R', 'I', 'Z', 'D', 0,
  /* 4832 */ 'V', 'C', 'L', 'Z', 'D', 0,
  /* 4838 */ 'C', 'N', 'T', 'L', 'Z', 'D', 0,
  /* 4845 */ 'V', 'C', 'T', 'Z', 'D', 0,
  /* 4851 */ 'C', 'N', 'T', 'T', 'Z', 'D', 0,
  /* 4858 */ 'M', 'F', 'B', 'H', 'R', 'B', 'E', 0,
  /* 4866 */ 'G', '_', 'S', 'S', 'U', 'B', 'E', 0,
  /* 4874 */ 'G', '_', 'U', 'S', 'U', 'B', 'E', 0,
  /* 4882 */ 'G', '_', 'F', 'E', 'N', 'C', 'E', 0,
  /* 4890 */ 'R', 'E', 'G', '_', 'S', 'E', 'Q', 'U', 'E', 'N', 'C', 'E', 0,
  /* 4903 */ 'M', 'F', 'F', 'S', 'C', 'E', 0,
  /* 4910 */ 'G', '_', 'S', 'A', 'D', 'D', 'E', 0,
  /* 4918 */ 'G', '_', 'U', 'A', 'D', 'D', 'E', 0,
  /* 4926 */ 'D', 'I', 'V', 'D', 'E', 0,
  /* 4932 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 4947 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 4962 */ 'S', 'L', 'B', 'M', 'F', 'E', 'E', 0,
  /* 4970 */ 'W', 'R', 'T', 'E', 'E', 0,
  /* 4976 */ 'S', 'U', 'B', 'F', 'E', 0,
  /* 4982 */ 'E', 'V', 'L', 'W', 'H', 'E', 0,
  /* 4989 */ 'E', 'V', 'S', 'T', 'W', 'H', 'E', 0,
  /* 4997 */ 'S', 'L', 'B', 'I', 'E', 0,
  /* 5003 */ 'T', 'L', 'B', 'I', 'E', 0,
  /* 5009 */ 'G', '_', 'J', 'U', 'M', 'P', '_', 'T', 'A', 'B', 'L', 'E', 0,
  /* 5022 */ 'B', 'U', 'N', 'D', 'L', 'E', 0,
  /* 5029 */ 'A', 'D', 'D', 'M', 'E', 0,
  /* 5035 */ 'S', 'U', 'B', 'F', 'M', 'E', 0,
  /* 5042 */ 'L', 'O', 'C', 'A', 'L', '_', 'E', 'S', 'C', 'A', 'P', 'E', 0,
  /* 5055 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'C', 'C', '_', 'S', 'P', 'E', 0,
  /* 5069 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'S', 'P', 'E', 0,
  /* 5080 */ 'T', 'L', 'B', 'R', 'E', 0,
  /* 5086 */ 'Q', 'V', 'F', 'R', 'E', 0,
  /* 5092 */ 'G', '_', 'S', 'T', 'O', 'R', 'E', 0,
  /* 5100 */ 'S', 'L', 'B', 'M', 'T', 'E', 0,
  /* 5107 */ 'Q', 'V', 'F', 'R', 'S', 'Q', 'R', 'T', 'E', 0,
  /* 5117 */ 'C', 'P', '_', 'P', 'A', 'S', 'T', 'E', 0,
  /* 5126 */ 'D', 'B', 'G', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 5136 */ 'G', '_', 'G', 'L', 'O', 'B', 'A', 'L', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 5151 */ 'M', 'F', 'V', 'R', 'S', 'A', 'V', 'E', 0,
  /* 5160 */ 'M', 'T', 'V', 'R', 'S', 'A', 'V', 'E', 0,
  /* 5169 */ 'R', 'E', 'S', 'T', 'O', 'R', 'E', '_', 'V', 'R', 'S', 'A', 'V', 'E', 0,
  /* 5184 */ 'U', 'P', 'D', 'A', 'T', 'E', '_', 'V', 'R', 'S', 'A', 'V', 'E', 0,
  /* 5198 */ 'S', 'P', 'I', 'L', 'L', '_', 'V', 'R', 'S', 'A', 'V', 'E', 0,
  /* 5211 */ 'T', 'L', 'B', 'W', 'E', 0,
  /* 5217 */ 'D', 'I', 'V', 'W', 'E', 0,
  /* 5223 */ 'E', 'V', 'S', 'T', 'W', 'W', 'E', 0,
  /* 5231 */ 'A', 'D', 'D', 'Z', 'E', 0,
  /* 5237 */ 'S', 'U', 'B', 'F', 'Z', 'E', 0,
  /* 5244 */ 'G', '_', 'F', 'C', 'A', 'N', 'O', 'N', 'I', 'C', 'A', 'L', 'I', 'Z', 'E', 0,
  /* 5260 */ 'D', 'C', 'B', 'F', 0,
  /* 5265 */ 'S', 'U', 'B', 'F', 0,
  /* 5270 */ 'G', '_', 'C', 'T', 'L', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 5288 */ 'G', '_', 'C', 'T', 'T', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 5306 */ 'G', '_', 'I', 'M', 'P', 'L', 'I', 'C', 'I', 'T', '_', 'D', 'E', 'F', 0,
  /* 5321 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'F', 0,
  /* 5330 */ 'E', 'V', 'M', 'W', 'H', 'S', 'M', 'F', 0,
  /* 5339 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'F', 0,
  /* 5348 */ 'E', 'V', 'M', 'W', 'S', 'M', 'F', 0,
  /* 5356 */ 'M', 'C', 'R', 'F', 0,
  /* 5361 */ 'M', 'F', 'O', 'C', 'R', 'F', 0,
  /* 5368 */ 'M', 'T', 'O', 'C', 'R', 'F', 0,
  /* 5375 */ 'M', 'T', 'C', 'R', 'F', 0,
  /* 5381 */ 'E', 'F', 'D', 'C', 'F', 'S', 'F', 0,
  /* 5389 */ 'E', 'F', 'S', 'C', 'F', 'S', 'F', 0,
  /* 5397 */ 'E', 'V', 'F', 'S', 'C', 'F', 'S', 'F', 0,
  /* 5406 */ 'M', 'T', 'F', 'S', 'F', 0,
  /* 5412 */ 'E', 'V', 'M', 'H', 'E', 'S', 'S', 'F', 0,
  /* 5421 */ 'E', 'V', 'M', 'W', 'H', 'S', 'S', 'F', 0,
  /* 5430 */ 'E', 'V', 'M', 'H', 'O', 'S', 'S', 'F', 0,
  /* 5439 */ 'E', 'V', 'M', 'W', 'S', 'S', 'F', 0,
  /* 5447 */ 'E', 'F', 'D', 'C', 'T', 'S', 'F', 0,
  /* 5455 */ 'E', 'F', 'S', 'C', 'T', 'S', 'F', 0,
  /* 5463 */ 'E', 'V', 'F', 'S', 'C', 'T', 'S', 'F', 0,
  /* 5472 */ 'E', 'F', 'D', 'C', 'F', 'U', 'F', 0,
  /* 5480 */ 'E', 'F', 'S', 'C', 'F', 'U', 'F', 0,
  /* 5488 */ 'E', 'V', 'F', 'S', 'C', 'F', 'U', 'F', 0,
  /* 5497 */ 'E', 'F', 'D', 'C', 'T', 'U', 'F', 0,
  /* 5505 */ 'E', 'F', 'S', 'C', 'T', 'U', 'F', 0,
  /* 5513 */ 'E', 'V', 'F', 'S', 'C', 'T', 'U', 'F', 0,
  /* 5522 */ 'S', 'L', 'B', 'I', 'E', 'G', 0,
  /* 5529 */ 'E', 'F', 'D', 'N', 'E', 'G', 0,
  /* 5536 */ 'Q', 'V', 'F', 'N', 'E', 'G', 0,
  /* 5543 */ 'G', '_', 'F', 'N', 'E', 'G', 0,
  /* 5550 */ 'E', 'F', 'S', 'N', 'E', 'G', 0,
  /* 5557 */ 'E', 'V', 'F', 'S', 'N', 'E', 'G', 0,
  /* 5565 */ 'E', 'V', 'N', 'E', 'G', 0,
  /* 5571 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 5586 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 5600 */ 'S', 'U', 'B', 'R', 'E', 'G', '_', 'T', 'O', '_', 'R', 'E', 'G', 0,
  /* 5614 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', 0,
  /* 5631 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', 0,
  /* 5648 */ 'G', '_', 'F', 'L', 'O', 'G', 0,
  /* 5655 */ 'G', '_', 'V', 'A', 'A', 'R', 'G', 0,
  /* 5663 */ 'V', '_', 'S', 'E', 'T', '0', 'H', 0,
  /* 5671 */ 'V', 'S', 'R', 'A', 'H', 0,
  /* 5677 */ 'E', 'V', 'L', 'D', 'H', 0,
  /* 5683 */ 'E', 'V', 'S', 'T', 'D', 'H', 0,
  /* 5690 */ 'V', 'C', 'M', 'P', 'N', 'E', 'H', 0,
  /* 5698 */ 'V', 'M', 'R', 'G', 'H', 'H', 0,
  /* 5705 */ 'V', 'M', 'R', 'G', 'L', 'H', 0,
  /* 5712 */ 'V', 'R', 'L', 'H', 0,
  /* 5717 */ 'V', 'S', 'L', 'H', 0,
  /* 5722 */ 'G', '_', 'S', 'M', 'U', 'L', 'H', 0,
  /* 5730 */ 'G', '_', 'U', 'M', 'U', 'L', 'H', 0,
  /* 5738 */ 'V', 'P', 'M', 'S', 'U', 'M', 'H', 0,
  /* 5746 */ 'X', 'X', 'B', 'R', 'H', 0,
  /* 5752 */ 'V', 'S', 'R', 'H', 0,
  /* 5757 */ 'V', 'M', 'U', 'L', 'E', 'S', 'H', 0,
  /* 5765 */ 'V', '_', 'S', 'E', 'T', 'A', 'L', 'L', 'O', 'N', 'E', 'S', 'H', 0,
  /* 5779 */ 'V', 'A', 'V', 'G', 'S', 'H', 0,
  /* 5786 */ 'V', 'U', 'P', 'K', 'H', 'S', 'H', 0,
  /* 5794 */ 'V', 'S', 'P', 'L', 'T', 'I', 'S', 'H', 0,
  /* 5803 */ 'V', 'U', 'P', 'K', 'L', 'S', 'H', 0,
  /* 5811 */ 'V', 'M', 'I', 'N', 'S', 'H', 0,
  /* 5818 */ 'V', 'M', 'U', 'L', 'O', 'S', 'H', 0,
  /* 5826 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'H', 0,
  /* 5835 */ 'E', 'V', 'E', 'X', 'T', 'S', 'H', 0,
  /* 5843 */ 'V', 'M', 'A', 'X', 'S', 'H', 0,
  /* 5850 */ 'V', 'S', 'P', 'L', 'T', 'H', 0,
  /* 5857 */ 'V', 'P', 'O', 'P', 'C', 'N', 'T', 'H', 0,
  /* 5866 */ 'V', 'I', 'N', 'S', 'E', 'R', 'T', 'H', 0,
  /* 5875 */ 'S', 'T', 'H', 0,
  /* 5879 */ 'V', 'A', 'B', 'S', 'D', 'U', 'H', 0,
  /* 5887 */ 'V', 'M', 'U', 'L', 'E', 'U', 'H', 0,
  /* 5895 */ 'V', 'A', 'V', 'G', 'U', 'H', 0,
  /* 5902 */ 'V', 'M', 'I', 'N', 'U', 'H', 0,
  /* 5909 */ 'V', 'M', 'U', 'L', 'O', 'U', 'H', 0,
  /* 5917 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'H', 0,
  /* 5926 */ 'V', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 'U', 'H', 0,
  /* 5937 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'H', 0,
  /* 5946 */ 'V', 'M', 'A', 'X', 'U', 'H', 0,
  /* 5953 */ 'V', 'C', 'M', 'P', 'N', 'E', 'Z', 'H', 0,
  /* 5962 */ 'V', 'C', 'L', 'Z', 'H', 0,
  /* 5968 */ 'V', 'C', 'T', 'Z', 'H', 0,
  /* 5974 */ 'D', 'C', 'B', 'I', 0,
  /* 5979 */ 'I', 'C', 'B', 'I', 0,
  /* 5984 */ 'S', 'U', 'B', 'I', 0,
  /* 5989 */ 'D', 'C', 'C', 'C', 'I', 0,
  /* 5995 */ 'I', 'C', 'C', 'C', 'I', 0,
  /* 6001 */ 'T', 'A', 'B', 'O', 'R', 'T', 'D', 'C', 'I', 0,
  /* 6011 */ 'R', 'F', 'C', 'I', 0,
  /* 6016 */ 'R', 'F', 'M', 'C', 'I', 0,
  /* 6022 */ 'Q', 'V', 'G', 'P', 'C', 'I', 0,
  /* 6029 */ 'T', 'A', 'B', 'O', 'R', 'T', 'W', 'C', 'I', 0,
  /* 6039 */ 'S', 'R', 'A', 'D', 'I', 0,
  /* 6045 */ 'A', 'D', 'D', 'I', 0,
  /* 6050 */ 'R', 'F', 'D', 'I', 0,
  /* 6055 */ 'C', 'M', 'P', 'L', 'D', 'I', 0,
  /* 6062 */ 'C', 'L', 'R', 'L', 'S', 'L', 'D', 'I', 0,
  /* 6071 */ 'E', 'X', 'T', 'L', 'D', 'I', 0,
  /* 6078 */ 'X', 'X', 'P', 'E', 'R', 'M', 'D', 'I', 0,
  /* 6087 */ 'C', 'M', 'P', 'D', 'I', 0,
  /* 6093 */ 'C', 'L', 'R', 'R', 'D', 'I', 0,
  /* 6100 */ 'I', 'N', 'S', 'R', 'D', 'I', 0,
  /* 6107 */ 'R', 'O', 'T', 'R', 'D', 'I', 0,
  /* 6114 */ 'E', 'X', 'T', 'R', 'D', 'I', 0,
  /* 6121 */ 'T', 'D', 'I', 0,
  /* 6125 */ 'W', 'R', 'T', 'E', 'E', 'I', 0,
  /* 6132 */ 'R', 'F', 'I', 0,
  /* 6136 */ 'M', 'T', 'F', 'S', 'F', 'I', 0,
  /* 6143 */ 'E', 'V', 'S', 'P', 'L', 'A', 'T', 'F', 'I', 0,
  /* 6153 */ 'E', 'V', 'M', 'E', 'R', 'G', 'E', 'H', 'I', 0,
  /* 6163 */ 'E', 'V', 'M', 'E', 'R', 'G', 'E', 'L', 'O', 'H', 'I', 0,
  /* 6175 */ 'G', '_', 'P', 'H', 'I', 0,
  /* 6181 */ 'T', 'L', 'B', 'L', 'I', 0,
  /* 6187 */ 'M', 'U', 'L', 'L', 'I', 0,
  /* 6193 */ 'E', 'X', 'T', 'S', 'W', 'S', 'L', 'I', 0,
  /* 6202 */ 'V', 'R', 'L', 'D', 'M', 'I', 0,
  /* 6209 */ 'R', 'L', 'D', 'I', 'M', 'I', 0,
  /* 6216 */ 'R', 'L', 'W', 'I', 'M', 'I', 0,
  /* 6223 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'I', 0,
  /* 6232 */ 'E', 'V', 'M', 'W', 'H', 'S', 'M', 'I', 0,
  /* 6241 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'I', 0,
  /* 6250 */ 'E', 'V', 'M', 'W', 'S', 'M', 'I', 0,
  /* 6258 */ 'E', 'V', 'M', 'H', 'E', 'U', 'M', 'I', 0,
  /* 6267 */ 'E', 'V', 'M', 'W', 'H', 'U', 'M', 'I', 0,
  /* 6276 */ 'E', 'V', 'M', 'W', 'L', 'U', 'M', 'I', 0,
  /* 6285 */ 'E', 'V', 'M', 'H', 'O', 'U', 'M', 'I', 0,
  /* 6294 */ 'E', 'V', 'M', 'W', 'U', 'M', 'I', 0,
  /* 6302 */ 'V', 'R', 'L', 'W', 'M', 'I', 0,
  /* 6309 */ 'Q', 'V', 'A', 'L', 'I', 'G', 'N', 'I', 0,
  /* 6318 */ 'M', 'F', 'F', 'S', 'C', 'R', 'N', 'I', 0,
  /* 6327 */ 'M', 'F', 'F', 'S', 'C', 'D', 'R', 'N', 'I', 0,
  /* 6337 */ 'V', 'S', 'L', 'D', 'O', 'I', 0,
  /* 6344 */ 'X', 'S', 'R', 'D', 'P', 'I', 0,
  /* 6351 */ 'X', 'V', 'R', 'D', 'P', 'I', 0,
  /* 6358 */ 'X', 'S', 'R', 'Q', 'P', 'I', 0,
  /* 6365 */ 'X', 'V', 'R', 'S', 'P', 'I', 0,
  /* 6372 */ 'X', 'O', 'R', 'I', 0,
  /* 6377 */ 'E', 'F', 'D', 'C', 'F', 'S', 'I', 0,
  /* 6385 */ 'E', 'F', 'S', 'C', 'F', 'S', 'I', 0,
  /* 6393 */ 'E', 'V', 'F', 'S', 'C', 'F', 'S', 'I', 0,
  /* 6402 */ 'G', '_', 'F', 'P', 'T', 'O', 'S', 'I', 0,
  /* 6411 */ 'E', 'F', 'D', 'C', 'T', 'S', 'I', 0,
  /* 6419 */ 'E', 'F', 'S', 'C', 'T', 'S', 'I', 0,
  /* 6427 */ 'E', 'V', 'F', 'S', 'C', 'T', 'S', 'I', 0,
  /* 6436 */ 'Q', 'V', 'E', 'S', 'P', 'L', 'A', 'T', 'I', 0,
  /* 6446 */ 'E', 'V', 'S', 'P', 'L', 'A', 'T', 'I', 0,
  /* 6455 */ 'L', 'D', 't', 'o', 'c', 'J', 'T', 'I', 0,
  /* 6464 */ 'E', 'F', 'D', 'C', 'F', 'U', 'I', 0,
  /* 6472 */ 'E', 'F', 'S', 'C', 'F', 'U', 'I', 0,
  /* 6480 */ 'E', 'V', 'F', 'S', 'C', 'F', 'U', 'I', 0,
  /* 6489 */ 'G', '_', 'F', 'P', 'T', 'O', 'U', 'I', 0,
  /* 6498 */ 'E', 'F', 'D', 'C', 'T', 'U', 'I', 0,
  /* 6506 */ 'E', 'F', 'S', 'C', 'T', 'U', 'I', 0,
  /* 6514 */ 'E', 'V', 'F', 'S', 'C', 'T', 'U', 'I', 0,
  /* 6523 */ 'S', 'R', 'A', 'W', 'I', 0,
  /* 6529 */ 'X', 'X', 'S', 'L', 'D', 'W', 'I', 0,
  /* 6537 */ 'C', 'M', 'P', 'L', 'W', 'I', 0,
  /* 6544 */ 'E', 'V', 'R', 'L', 'W', 'I', 0,
  /* 6551 */ 'C', 'L', 'R', 'L', 'S', 'L', 'W', 'I', 0,
  /* 6560 */ 'I', 'N', 'S', 'L', 'W', 'I', 0,
  /* 6567 */ 'E', 'V', 'S', 'L', 'W', 'I', 0,
  /* 6574 */ 'E', 'X', 'T', 'L', 'W', 'I', 0,
  /* 6581 */ 'C', 'M', 'P', 'W', 'I', 0,
  /* 6587 */ 'C', 'L', 'R', 'R', 'W', 'I', 0,
  /* 6594 */ 'I', 'N', 'S', 'R', 'W', 'I', 0,
  /* 6601 */ 'R', 'O', 'T', 'R', 'W', 'I', 0,
  /* 6608 */ 'E', 'X', 'T', 'R', 'W', 'I', 0,
  /* 6615 */ 'L', 'S', 'W', 'I', 0,
  /* 6620 */ 'S', 'T', 'S', 'W', 'I', 0,
  /* 6626 */ 'T', 'W', 'I', 0,
  /* 6630 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'X', 'I', 0,
  /* 6640 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'X', 'I', 0,
  /* 6649 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'X', 'I', 0,
  /* 6659 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'X', 'I', 0,
  /* 6668 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'U', 'X', 'I', 0,
  /* 6679 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'U', 'X', 'I', 0,
  /* 6689 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'U', 'X', 'I', 0,
  /* 6700 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'U', 'X', 'I', 0,
  /* 6710 */ 'T', 'C', 'H', 'E', 'C', 'K', 0,
  /* 6717 */ 'G', '_', 'P', 'T', 'R', '_', 'M', 'A', 'S', 'K', 0,
  /* 6728 */ 'Q', 'V', 'F', 'L', 'O', 'G', 'I', 'C', 'A', 'L', 0,
  /* 6739 */ 'B', 'L', 0,
  /* 6742 */ 'g', 'B', 'C', 'L', 0,
  /* 6747 */ 'B', 'C', 'C', 'L', 0,
  /* 6752 */ 'R', 'L', 'D', 'C', 'L', 0,
  /* 6758 */ 'R', 'L', 'D', 'I', 'C', 'L', 0,
  /* 6765 */ 'G', 'C', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 6774 */ 'D', 'B', 'G', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 6784 */ 'E', 'H', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 6793 */ 'A', 'N', 'N', 'O', 'T', 'A', 'T', 'I', 'O', 'N', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 6810 */ 'T', 'L', 'B', 'I', 'E', 'L', 0,
  /* 6817 */ 'I', 'C', 'A', 'L', 'L', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'F', 'U', 'N', 'N', 'E', 'L', 0,
  /* 6837 */ 'Q', 'V', 'F', 'S', 'E', 'L', 0,
  /* 6844 */ 'I', 'S', 'E', 'L', 0,
  /* 6849 */ 'E', 'V', 'S', 'E', 'L', 0,
  /* 6855 */ 'X', 'X', 'S', 'E', 'L', 0,
  /* 6861 */ 'D', 'C', 'B', 'F', 'L', 0,
  /* 6867 */ 'G', '_', 'S', 'H', 'L', 0,
  /* 6873 */ 'G', '_', 'F', 'C', 'E', 'I', 'L', 0,
  /* 6881 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'A', 'I', 'L', '_', 'C', 'A', 'L', 'L', 0,
  /* 6901 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'Y', 'P', 'E', 'D', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 6928 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 6949 */ 'F', 'E', 'N', 'T', 'R', 'Y', '_', 'C', 'A', 'L', 'L', 0,
  /* 6961 */ 'D', 'S', 'S', 'A', 'L', 'L', 0,
  /* 6968 */ 'K', 'I', 'L', 'L', 0,
  /* 6973 */ 'L', 'X', 'V', 'L', 'L', 0,
  /* 6979 */ 'S', 'T', 'X', 'V', 'L', 'L', 0,
  /* 6986 */ 'B', 'L', 'R', 'L', 0,
  /* 6991 */ 'g', 'B', 'C', 'L', 'R', 'L', 0,
  /* 6998 */ 'B', 'C', 'C', 'L', 'R', 'L', 0,
  /* 7005 */ 'B', 'D', 'Z', 'L', 'R', 'L', 0,
  /* 7012 */ 'B', 'D', 'N', 'Z', 'L', 'R', 'L', 0,
  /* 7020 */ 'B', 'C', 'T', 'R', 'L', 0,
  /* 7026 */ 'g', 'B', 'C', 'C', 'T', 'R', 'L', 0,
  /* 7034 */ 'B', 'C', 'C', 'C', 'T', 'R', 'L', 0,
  /* 7042 */ 'M', 'F', 'F', 'S', 'L', 0,
  /* 7048 */ 'L', 'V', 'S', 'L', 0,
  /* 7053 */ 'E', 'F', 'D', 'M', 'U', 'L', 0,
  /* 7060 */ 'Q', 'V', 'F', 'M', 'U', 'L', 0,
  /* 7067 */ 'G', '_', 'F', 'M', 'U', 'L', 0,
  /* 7074 */ 'E', 'F', 'S', 'M', 'U', 'L', 0,
  /* 7081 */ 'E', 'V', 'F', 'S', 'M', 'U', 'L', 0,
  /* 7089 */ 'Q', 'V', 'F', 'X', 'M', 'U', 'L', 0,
  /* 7097 */ 'G', '_', 'M', 'U', 'L', 0,
  /* 7103 */ 'L', 'X', 'V', 'L', 0,
  /* 7108 */ 'S', 'T', 'X', 'V', 'L', 0,
  /* 7114 */ 'L', 'B', 'A', 'R', 'X', 'L', 0,
  /* 7121 */ 'L', 'D', 'A', 'R', 'X', 'L', 0,
  /* 7128 */ 'L', 'H', 'A', 'R', 'X', 'L', 0,
  /* 7135 */ 'L', 'W', 'A', 'R', 'X', 'L', 0,
  /* 7142 */ 'L', 'V', 'X', 'L', 0,
  /* 7147 */ 'S', 'T', 'V', 'X', 'L', 0,
  /* 7153 */ 'D', 'C', 'B', 'Z', 'L', 0,
  /* 7159 */ 'B', 'D', 'Z', 'L', 0,
  /* 7164 */ 'B', 'D', 'N', 'Z', 'L', 0,
  /* 7170 */ 'L', 'D', 't', 'o', 'c', 'L', 0,
  /* 7177 */ 'A', 'D', 'D', 'I', 't', 'o', 'c', 'L', 0,
  /* 7186 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'g', 'd', 'L', 0,
  /* 7197 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'l', 'd', 'L', 0,
  /* 7208 */ 'L', 'D', 'g', 'o', 't', 'T', 'p', 'r', 'e', 'l', 'L', 0,
  /* 7220 */ 'A', 'D', 'D', 'I', 'd', 't', 'p', 'r', 'e', 'l', 'L', 0,
  /* 7232 */ 'V', 'M', 'S', 'U', 'M', 'M', 'B', 'M', 0,
  /* 7241 */ 'V', 'S', 'U', 'B', 'U', 'B', 'M', 0,
  /* 7249 */ 'V', 'A', 'D', 'D', 'U', 'B', 'M', 0,
  /* 7257 */ 'V', 'M', 'S', 'U', 'M', 'U', 'B', 'M', 0,
  /* 7266 */ 'V', 'S', 'U', 'B', 'U', 'D', 'M', 0,
  /* 7274 */ 'V', 'A', 'D', 'D', 'U', 'D', 'M', 0,
  /* 7282 */ 'G', '_', 'F', 'R', 'E', 'M', 0,
  /* 7289 */ 'G', '_', 'S', 'R', 'E', 'M', 0,
  /* 7296 */ 'G', '_', 'U', 'R', 'E', 'M', 0,
  /* 7303 */ 'V', 'M', 'S', 'U', 'M', 'S', 'H', 'M', 0,
  /* 7312 */ 'V', 'S', 'U', 'B', 'U', 'H', 'M', 0,
  /* 7320 */ 'V', 'M', 'L', 'A', 'D', 'D', 'U', 'H', 'M', 0,
  /* 7330 */ 'V', 'A', 'D', 'D', 'U', 'H', 'M', 0,
  /* 7338 */ 'V', 'M', 'S', 'U', 'M', 'U', 'H', 'M', 0,
  /* 7347 */ 'T', 'R', 'E', 'C', 'L', 'A', 'I', 'M', 0,
  /* 7356 */ 'V', 'R', 'F', 'I', 'M', 0,
  /* 7362 */ 'X', 'S', 'R', 'D', 'P', 'I', 'M', 0,
  /* 7370 */ 'X', 'V', 'R', 'D', 'P', 'I', 'M', 0,
  /* 7378 */ 'X', 'V', 'R', 'S', 'P', 'I', 'M', 0,
  /* 7386 */ 'Q', 'V', 'F', 'R', 'I', 'M', 0,
  /* 7393 */ 'V', 'R', 'L', 'D', 'N', 'M', 0,
  /* 7400 */ 'R', 'L', 'W', 'I', 'N', 'M', 0,
  /* 7407 */ 'V', 'R', 'L', 'W', 'N', 'M', 0,
  /* 7414 */ 'V', 'S', 'U', 'B', 'U', 'Q', 'M', 0,
  /* 7422 */ 'V', 'A', 'D', 'D', 'U', 'Q', 'M', 0,
  /* 7430 */ 'V', 'S', 'U', 'B', 'E', 'U', 'Q', 'M', 0,
  /* 7439 */ 'V', 'A', 'D', 'D', 'E', 'U', 'Q', 'M', 0,
  /* 7448 */ 'Q', 'V', 'F', 'P', 'E', 'R', 'M', 0,
  /* 7456 */ 'V', 'P', 'E', 'R', 'M', 0,
  /* 7462 */ 'X', 'X', 'P', 'E', 'R', 'M', 0,
  /* 7469 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', 0,
  /* 7479 */ 'V', 'P', 'K', 'U', 'D', 'U', 'M', 0,
  /* 7487 */ 'V', 'P', 'K', 'U', 'H', 'U', 'M', 0,
  /* 7495 */ 'G', '_', 'F', 'M', 'I', 'N', 'I', 'M', 'U', 'M', 0,
  /* 7506 */ 'G', '_', 'F', 'M', 'A', 'X', 'I', 'M', 'U', 'M', 0,
  /* 7517 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', 0,
  /* 7527 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', 0,
  /* 7537 */ 'V', 'P', 'K', 'U', 'W', 'U', 'M', 0,
  /* 7545 */ 'V', 'S', 'U', 'B', 'U', 'W', 'M', 0,
  /* 7553 */ 'V', 'A', 'D', 'D', 'U', 'W', 'M', 0,
  /* 7561 */ 'V', 'M', 'U', 'L', 'U', 'W', 'M', 0,
  /* 7569 */ 'E', 'V', 'M', 'H', 'E', 'G', 'S', 'M', 'F', 'A', 'N', 0,
  /* 7581 */ 'E', 'V', 'M', 'H', 'O', 'G', 'S', 'M', 'F', 'A', 'N', 0,
  /* 7593 */ 'E', 'V', 'M', 'W', 'S', 'M', 'F', 'A', 'N', 0,
  /* 7603 */ 'E', 'V', 'M', 'W', 'S', 'S', 'F', 'A', 'N', 0,
  /* 7613 */ 'E', 'V', 'M', 'H', 'E', 'G', 'S', 'M', 'I', 'A', 'N', 0,
  /* 7625 */ 'E', 'V', 'M', 'H', 'O', 'G', 'S', 'M', 'I', 'A', 'N', 0,
  /* 7637 */ 'E', 'V', 'M', 'W', 'S', 'M', 'I', 'A', 'N', 0,
  /* 7647 */ 'E', 'V', 'M', 'H', 'E', 'G', 'U', 'M', 'I', 'A', 'N', 0,
  /* 7659 */ 'E', 'V', 'M', 'H', 'O', 'G', 'U', 'M', 'I', 'A', 'N', 0,
  /* 7671 */ 'E', 'V', 'M', 'W', 'U', 'M', 'I', 'A', 'N', 0,
  /* 7681 */ 'Q', 'V', 'F', 'T', 'S', 'T', 'N', 'A', 'N', 0,
  /* 7691 */ 'G', '_', 'F', 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', 0,
  /* 7703 */ 'Q', 'V', 'F', 'C', 'P', 'S', 'G', 'N', 0,
  /* 7712 */ 'V', 'R', 'F', 'I', 'N', 0,
  /* 7718 */ 'T', 'B', 'E', 'G', 'I', 'N', 0,
  /* 7725 */ 'G', '_', 'S', 'M', 'I', 'N', 0,
  /* 7732 */ 'G', '_', 'U', 'M', 'I', 'N', 0,
  /* 7739 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'I', 'N', 0,
  /* 7756 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'I', 'N', 0,
  /* 7772 */ 'Q', 'V', 'F', 'R', 'I', 'N', 0,
  /* 7779 */ 'M', 'F', 'S', 'R', 'I', 'N', 0,
  /* 7786 */ 'M', 'T', 'S', 'R', 'I', 'N', 0,
  /* 7793 */ 'G', '_', 'F', 'S', 'I', 'N', 0,
  /* 7800 */ 'C', 'F', 'I', '_', 'I', 'N', 'S', 'T', 'R', 'U', 'C', 'T', 'I', 'O', 'N', 0,
  /* 7816 */ 'X', 'S', 'C', 'V', 'S', 'P', 'D', 'P', 'N', 0,
  /* 7826 */ 'X', 'S', 'C', 'V', 'D', 'P', 'S', 'P', 'N', 0,
  /* 7836 */ 'D', 'A', 'R', 'N', 0,
  /* 7841 */ 'M', 'F', 'F', 'S', 'C', 'R', 'N', 0,
  /* 7849 */ 'M', 'F', 'F', 'S', 'C', 'D', 'R', 'N', 0,
  /* 7858 */ 'A', 'T', 'T', 'N', 0,
  /* 7863 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'D', 'O', 'W', 'N', 0,
  /* 7880 */ 'G', '_', 'S', 'S', 'U', 'B', 'O', 0,
  /* 7888 */ 'G', '_', 'U', 'S', 'U', 'B', 'O', 0,
  /* 7896 */ 'G', '_', 'S', 'A', 'D', 'D', 'O', 0,
  /* 7904 */ 'G', '_', 'U', 'A', 'D', 'D', 'O', 0,
  /* 7912 */ 'E', 'V', 'S', 'T', 'W', 'H', 'O', 0,
  /* 7920 */ 'E', 'n', 'f', 'o', 'r', 'c', 'e', 'I', 'E', 'I', 'O', 0,
  /* 7932 */ 'E', 'V', 'M', 'E', 'R', 'G', 'E', 'L', 'O', 0,
  /* 7942 */ 'E', 'V', 'M', 'E', 'R', 'G', 'E', 'H', 'I', 'L', 'O', 0,
  /* 7954 */ 'V', 'S', 'L', 'O', 0,
  /* 7959 */ 'G', '_', 'S', 'M', 'U', 'L', 'O', 0,
  /* 7967 */ 'G', '_', 'U', 'M', 'U', 'L', 'O', 0,
  /* 7975 */ 'X', 'S', 'C', 'V', 'Q', 'P', 'D', 'P', 'O', 0,
  /* 7985 */ 'X', 'S', 'N', 'M', 'S', 'U', 'B', 'Q', 'P', 'O', 0,
  /* 7996 */ 'X', 'S', 'M', 'S', 'U', 'B', 'Q', 'P', 'O', 0,
  /* 8006 */ 'X', 'S', 'S', 'U', 'B', 'Q', 'P', 'O', 0,
  /* 8015 */ 'X', 'S', 'N', 'M', 'A', 'D', 'D', 'Q', 'P', 'O', 0,
  /* 8026 */ 'X', 'S', 'M', 'A', 'D', 'D', 'Q', 'P', 'O', 0,
  /* 8036 */ 'X', 'S', 'A', 'D', 'D', 'Q', 'P', 'O', 0,
  /* 8045 */ 'X', 'S', 'M', 'U', 'L', 'Q', 'P', 'O', 0,
  /* 8054 */ 'X', 'S', 'S', 'Q', 'R', 'T', 'Q', 'P', 'O', 0,
  /* 8064 */ 'X', 'S', 'D', 'I', 'V', 'Q', 'P', 'O', 0,
  /* 8073 */ 'V', 'S', 'R', 'O', 0,
  /* 8078 */ 'E', 'V', 'S', 'T', 'W', 'W', 'O', 0,
  /* 8086 */ 'S', 'T', 'A', 'C', 'K', 'M', 'A', 'P', 0,
  /* 8095 */ 'N', 'A', 'P', 0,
  /* 8099 */ 'T', 'R', 'A', 'P', 0,
  /* 8104 */ 'G', '_', 'B', 'S', 'W', 'A', 'P', 0,
  /* 8112 */ 'X', 'S', 'N', 'M', 'S', 'U', 'B', 'A', 'D', 'P', 0,
  /* 8123 */ 'X', 'V', 'N', 'M', 'S', 'U', 'B', 'A', 'D', 'P', 0,
  /* 8134 */ 'X', 'S', 'M', 'S', 'U', 'B', 'A', 'D', 'P', 0,
  /* 8144 */ 'X', 'V', 'M', 'S', 'U', 'B', 'A', 'D', 'P', 0,
  /* 8154 */ 'X', 'S', 'N', 'M', 'A', 'D', 'D', 'A', 'D', 'P', 0,
  /* 8165 */ 'X', 'V', 'N', 'M', 'A', 'D', 'D', 'A', 'D', 'P', 0,
  /* 8176 */ 'X', 'S', 'M', 'A', 'D', 'D', 'A', 'D', 'P', 0,
  /* 8186 */ 'X', 'V', 'M', 'A', 'D', 'D', 'A', 'D', 'P', 0,
  /* 8196 */ 'X', 'S', 'S', 'U', 'B', 'D', 'P', 0,
  /* 8204 */ 'X', 'V', 'S', 'U', 'B', 'D', 'P', 0,
  /* 8212 */ 'X', 'S', 'T', 'S', 'T', 'D', 'C', 'D', 'P', 0,
  /* 8222 */ 'X', 'V', 'T', 'S', 'T', 'D', 'C', 'D', 'P', 0,
  /* 8232 */ 'X', 'S', 'M', 'I', 'N', 'C', 'D', 'P', 0,
  /* 8241 */ 'X', 'S', 'M', 'A', 'X', 'C', 'D', 'P', 0,
  /* 8250 */ 'X', 'S', 'A', 'D', 'D', 'D', 'P', 0,
  /* 8258 */ 'X', 'V', 'A', 'D', 'D', 'D', 'P', 0,
  /* 8266 */ 'X', 'S', 'C', 'V', 'S', 'X', 'D', 'D', 'P', 0,
  /* 8276 */ 'X', 'V', 'C', 'V', 'S', 'X', 'D', 'D', 'P', 0,
  /* 8286 */ 'X', 'S', 'C', 'V', 'U', 'X', 'D', 'D', 'P', 0,
  /* 8296 */ 'X', 'V', 'C', 'V', 'U', 'X', 'D', 'D', 'P', 0,
  /* 8306 */ 'X', 'S', 'C', 'M', 'P', 'G', 'E', 'D', 'P', 0,
  /* 8316 */ 'X', 'V', 'C', 'M', 'P', 'G', 'E', 'D', 'P', 0,
  /* 8326 */ 'X', 'S', 'R', 'E', 'D', 'P', 0,
  /* 8333 */ 'X', 'V', 'R', 'E', 'D', 'P', 0,
  /* 8340 */ 'X', 'S', 'R', 'S', 'Q', 'R', 'T', 'E', 'D', 'P', 0,
  /* 8351 */ 'X', 'V', 'R', 'S', 'Q', 'R', 'T', 'E', 'D', 'P', 0,
  /* 8362 */ 'X', 'S', 'N', 'E', 'G', 'D', 'P', 0,
  /* 8370 */ 'X', 'V', 'N', 'E', 'G', 'D', 'P', 0,
  /* 8378 */ 'X', 'S', 'X', 'S', 'I', 'G', 'D', 'P', 0,
  /* 8387 */ 'X', 'V', 'X', 'S', 'I', 'G', 'D', 'P', 0,
  /* 8396 */ 'X', 'S', 'M', 'I', 'N', 'J', 'D', 'P', 0,
  /* 8405 */ 'X', 'S', 'M', 'A', 'X', 'J', 'D', 'P', 0,
  /* 8414 */ 'X', 'S', 'M', 'U', 'L', 'D', 'P', 0,
  /* 8422 */ 'X', 'V', 'M', 'U', 'L', 'D', 'P', 0,
  /* 8430 */ 'X', 'S', 'N', 'M', 'S', 'U', 'B', 'M', 'D', 'P', 0,
  /* 8441 */ 'X', 'V', 'N', 'M', 'S', 'U', 'B', 'M', 'D', 'P', 0,
  /* 8452 */ 'X', 'S', 'M', 'S', 'U', 'B', 'M', 'D', 'P', 0,
  /* 8462 */ 'X', 'V', 'M', 'S', 'U', 'B', 'M', 'D', 'P', 0,
  /* 8472 */ 'X', 'S', 'N', 'M', 'A', 'D', 'D', 'M', 'D', 'P', 0,
  /* 8483 */ 'X', 'V', 'N', 'M', 'A', 'D', 'D', 'M', 'D', 'P', 0,
  /* 8494 */ 'X', 'S', 'M', 'A', 'D', 'D', 'M', 'D', 'P', 0,
  /* 8504 */ 'X', 'V', 'M', 'A', 'D', 'D', 'M', 'D', 'P', 0,
  /* 8514 */ 'X', 'S', 'C', 'P', 'S', 'G', 'N', 'D', 'P', 0,
  /* 8524 */ 'X', 'V', 'C', 'P', 'S', 'G', 'N', 'D', 'P', 0,
  /* 8534 */ 'X', 'S', 'M', 'I', 'N', 'D', 'P', 0,
  /* 8542 */ 'X', 'V', 'M', 'I', 'N', 'D', 'P', 0,
  /* 8550 */ 'X', 'S', 'C', 'M', 'P', 'O', 'D', 'P', 0,
  /* 8559 */ 'X', 'S', 'C', 'V', 'H', 'P', 'D', 'P', 0,
  /* 8568 */ 'X', 'S', 'C', 'V', 'Q', 'P', 'D', 'P', 0,
  /* 8577 */ 'X', 'S', 'C', 'V', 'S', 'P', 'D', 'P', 0,
  /* 8586 */ 'X', 'V', 'C', 'V', 'S', 'P', 'D', 'P', 0,
  /* 8595 */ 'X', 'S', 'I', 'E', 'X', 'P', 'D', 'P', 0,
  /* 8604 */ 'X', 'V', 'I', 'E', 'X', 'P', 'D', 'P', 0,
  /* 8613 */ 'X', 'S', 'C', 'M', 'P', 'E', 'X', 'P', 'D', 'P', 0,
  /* 8624 */ 'X', 'S', 'X', 'E', 'X', 'P', 'D', 'P', 0,
  /* 8633 */ 'X', 'V', 'X', 'E', 'X', 'P', 'D', 'P', 0,
  /* 8642 */ 'X', 'S', 'C', 'M', 'P', 'E', 'Q', 'D', 'P', 0,
  /* 8652 */ 'X', 'V', 'C', 'M', 'P', 'E', 'Q', 'D', 'P', 0,
  /* 8662 */ 'X', 'S', 'N', 'A', 'B', 'S', 'D', 'P', 0,
  /* 8671 */ 'X', 'V', 'N', 'A', 'B', 'S', 'D', 'P', 0,
  /* 8680 */ 'X', 'S', 'A', 'B', 'S', 'D', 'P', 0,
  /* 8688 */ 'X', 'V', 'A', 'B', 'S', 'D', 'P', 0,
  /* 8696 */ 'X', 'S', 'C', 'M', 'P', 'G', 'T', 'D', 'P', 0,
  /* 8706 */ 'X', 'V', 'C', 'M', 'P', 'G', 'T', 'D', 'P', 0,
  /* 8716 */ 'X', 'S', 'S', 'Q', 'R', 'T', 'D', 'P', 0,
  /* 8725 */ 'X', 'S', 'T', 'S', 'Q', 'R', 'T', 'D', 'P', 0,
  /* 8735 */ 'X', 'V', 'T', 'S', 'Q', 'R', 'T', 'D', 'P', 0,
  /* 8745 */ 'X', 'V', 'S', 'Q', 'R', 'T', 'D', 'P', 0,
  /* 8754 */ 'X', 'S', 'C', 'M', 'P', 'U', 'D', 'P', 0,
  /* 8763 */ 'X', 'S', 'D', 'I', 'V', 'D', 'P', 0,
  /* 8771 */ 'X', 'S', 'T', 'D', 'I', 'V', 'D', 'P', 0,
  /* 8780 */ 'X', 'V', 'T', 'D', 'I', 'V', 'D', 'P', 0,
  /* 8789 */ 'X', 'V', 'D', 'I', 'V', 'D', 'P', 0,
  /* 8797 */ 'X', 'V', 'C', 'V', 'S', 'X', 'W', 'D', 'P', 0,
  /* 8807 */ 'X', 'V', 'C', 'V', 'U', 'X', 'W', 'D', 'P', 0,
  /* 8817 */ 'X', 'S', 'M', 'A', 'X', 'D', 'P', 0,
  /* 8825 */ 'X', 'V', 'M', 'A', 'X', 'D', 'P', 0,
  /* 8833 */ 'C', 'T', 'R', 'L', '_', 'D', 'E', 'P', 0,
  /* 8842 */ 'D', 'C', 'B', 'F', 'E', 'P', 0,
  /* 8849 */ 'G', '_', 'G', 'E', 'P', 0,
  /* 8855 */ 'I', 'C', 'B', 'I', 'E', 'P', 0,
  /* 8862 */ 'D', 'C', 'B', 'Z', 'L', 'E', 'P', 0,
  /* 8870 */ 'D', 'C', 'B', 'T', 'E', 'P', 0,
  /* 8877 */ 'D', 'C', 'B', 'S', 'T', 'E', 'P', 0,
  /* 8885 */ 'D', 'C', 'B', 'T', 'S', 'T', 'E', 'P', 0,
  /* 8894 */ 'D', 'C', 'B', 'Z', 'E', 'P', 0,
  /* 8901 */ 'V', 'C', 'M', 'P', 'B', 'F', 'P', 0,
  /* 8909 */ 'V', 'N', 'M', 'S', 'U', 'B', 'F', 'P', 0,
  /* 8918 */ 'V', 'S', 'U', 'B', 'F', 'P', 0,
  /* 8925 */ 'V', 'M', 'A', 'D', 'D', 'F', 'P', 0,
  /* 8933 */ 'V', 'A', 'D', 'D', 'F', 'P', 0,
  /* 8940 */ 'V', 'L', 'O', 'G', 'E', 'F', 'P', 0,
  /* 8948 */ 'V', 'C', 'M', 'P', 'G', 'E', 'F', 'P', 0,
  /* 8957 */ 'V', 'R', 'E', 'F', 'P', 0,
  /* 8963 */ 'V', 'E', 'X', 'P', 'T', 'E', 'F', 'P', 0,
  /* 8972 */ 'V', 'R', 'S', 'Q', 'R', 'T', 'E', 'F', 'P', 0,
  /* 8982 */ 'V', 'M', 'I', 'N', 'F', 'P', 0,
  /* 8989 */ 'G', '_', 'S', 'I', 'T', 'O', 'F', 'P', 0,
  /* 8998 */ 'G', '_', 'U', 'I', 'T', 'O', 'F', 'P', 0,
  /* 9007 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'F', 'P', 0,
  /* 9016 */ 'V', 'C', 'M', 'P', 'G', 'T', 'F', 'P', 0,
  /* 9025 */ 'V', 'M', 'A', 'X', 'F', 'P', 0,
  /* 9032 */ 'X', 'S', 'C', 'V', 'D', 'P', 'H', 'P', 0,
  /* 9041 */ 'X', 'V', 'C', 'V', 'S', 'P', 'H', 'P', 0,
  /* 9050 */ 'V', 'R', 'F', 'I', 'P', 0,
  /* 9056 */ 'X', 'S', 'R', 'D', 'P', 'I', 'P', 0,
  /* 9064 */ 'X', 'V', 'R', 'D', 'P', 'I', 'P', 0,
  /* 9072 */ 'X', 'V', 'R', 'S', 'P', 'I', 'P', 0,
  /* 9080 */ 'Q', 'V', 'F', 'R', 'I', 'P', 0,
  /* 9087 */ 'D', 'C', 'B', 'F', 'L', 'P', 0,
  /* 9094 */ 'G', '_', 'F', 'C', 'M', 'P', 0,
  /* 9101 */ 'G', '_', 'I', 'C', 'M', 'P', 0,
  /* 9108 */ 'B', 'L', 'A', '8', '_', 'N', 'O', 'P', 0,
  /* 9117 */ 'B', 'L', '8', '_', 'N', 'O', 'P', 0,
  /* 9125 */ 'B', 'L', '_', 'N', 'O', 'P', 0,
  /* 9132 */ 'G', '_', 'C', 'T', 'P', 'O', 'P', 0,
  /* 9140 */ 'S', 'T', 'O', 'P', 0,
  /* 9145 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'O', 'P', 0,
  /* 9158 */ 'F', 'A', 'U', 'L', 'T', 'I', 'N', 'G', '_', 'O', 'P', 0,
  /* 9170 */ 'X', 'S', 'N', 'M', 'S', 'U', 'B', 'Q', 'P', 0,
  /* 9180 */ 'X', 'S', 'M', 'S', 'U', 'B', 'Q', 'P', 0,
  /* 9189 */ 'X', 'S', 'S', 'U', 'B', 'Q', 'P', 0,
  /* 9197 */ 'X', 'S', 'T', 'S', 'T', 'D', 'C', 'Q', 'P', 0,
  /* 9207 */ 'X', 'S', 'N', 'M', 'A', 'D', 'D', 'Q', 'P', 0,
  /* 9217 */ 'X', 'S', 'M', 'A', 'D', 'D', 'Q', 'P', 0,
  /* 9226 */ 'X', 'S', 'A', 'D', 'D', 'Q', 'P', 0,
  /* 9234 */ 'X', 'S', 'C', 'V', 'S', 'D', 'Q', 'P', 0,
  /* 9243 */ 'X', 'S', 'C', 'V', 'U', 'D', 'Q', 'P', 0,
  /* 9252 */ 'X', 'S', 'N', 'E', 'G', 'Q', 'P', 0,
  /* 9260 */ 'X', 'S', 'X', 'S', 'I', 'G', 'Q', 'P', 0,
  /* 9269 */ 'X', 'S', 'M', 'U', 'L', 'Q', 'P', 0,
  /* 9277 */ 'X', 'S', 'C', 'P', 'S', 'G', 'N', 'Q', 'P', 0,
  /* 9287 */ 'X', 'S', 'C', 'M', 'P', 'O', 'Q', 'P', 0,
  /* 9296 */ 'X', 'S', 'C', 'V', 'D', 'P', 'Q', 'P', 0,
  /* 9305 */ 'X', 'S', 'I', 'E', 'X', 'P', 'Q', 'P', 0,
  /* 9314 */ 'X', 'S', 'C', 'M', 'P', 'E', 'X', 'P', 'Q', 'P', 0,
  /* 9325 */ 'X', 'S', 'X', 'E', 'X', 'P', 'Q', 'P', 0,
  /* 9334 */ 'X', 'S', 'N', 'A', 'B', 'S', 'Q', 'P', 0,
  /* 9343 */ 'X', 'S', 'A', 'B', 'S', 'Q', 'P', 0,
  /* 9351 */ 'X', 'S', 'S', 'Q', 'R', 'T', 'Q', 'P', 0,
  /* 9360 */ 'X', 'S', 'C', 'M', 'P', 'U', 'Q', 'P', 0,
  /* 9369 */ 'X', 'S', 'D', 'I', 'V', 'Q', 'P', 0,
  /* 9377 */ 'X', 'S', 'N', 'M', 'S', 'U', 'B', 'A', 'S', 'P', 0,
  /* 9388 */ 'X', 'V', 'N', 'M', 'S', 'U', 'B', 'A', 'S', 'P', 0,
  /* 9399 */ 'X', 'S', 'M', 'S', 'U', 'B', 'A', 'S', 'P', 0,
  /* 9409 */ 'X', 'V', 'M', 'S', 'U', 'B', 'A', 'S', 'P', 0,
  /* 9419 */ 'X', 'S', 'N', 'M', 'A', 'D', 'D', 'A', 'S', 'P', 0,
  /* 9430 */ 'X', 'V', 'N', 'M', 'A', 'D', 'D', 'A', 'S', 'P', 0,
  /* 9441 */ 'X', 'S', 'M', 'A', 'D', 'D', 'A', 'S', 'P', 0,
  /* 9451 */ 'X', 'V', 'M', 'A', 'D', 'D', 'A', 'S', 'P', 0,
  /* 9461 */ 'X', 'S', 'S', 'U', 'B', 'S', 'P', 0,
  /* 9469 */ 'X', 'V', 'S', 'U', 'B', 'S', 'P', 0,
  /* 9477 */ 'X', 'S', 'T', 'S', 'T', 'D', 'C', 'S', 'P', 0,
  /* 9487 */ 'X', 'V', 'T', 'S', 'T', 'D', 'C', 'S', 'P', 0,
  /* 9497 */ 'X', 'S', 'A', 'D', 'D', 'S', 'P', 0,
  /* 9505 */ 'X', 'V', 'A', 'D', 'D', 'S', 'P', 0,
  /* 9513 */ 'X', 'S', 'C', 'V', 'S', 'X', 'D', 'S', 'P', 0,
  /* 9523 */ 'X', 'V', 'C', 'V', 'S', 'X', 'D', 'S', 'P', 0,
  /* 9533 */ 'X', 'S', 'C', 'V', 'U', 'X', 'D', 'S', 'P', 0,
  /* 9543 */ 'X', 'V', 'C', 'V', 'U', 'X', 'D', 'S', 'P', 0,
  /* 9553 */ 'X', 'V', 'C', 'M', 'P', 'G', 'E', 'S', 'P', 0,
  /* 9563 */ 'X', 'S', 'R', 'E', 'S', 'P', 0,
  /* 9570 */ 'X', 'V', 'R', 'E', 'S', 'P', 0,
  /* 9577 */ 'X', 'S', 'R', 'S', 'Q', 'R', 'T', 'E', 'S', 'P', 0,
  /* 9588 */ 'X', 'V', 'R', 'S', 'Q', 'R', 'T', 'E', 'S', 'P', 0,
  /* 9599 */ 'X', 'V', 'N', 'E', 'G', 'S', 'P', 0,
  /* 9607 */ 'X', 'V', 'X', 'S', 'I', 'G', 'S', 'P', 0,
  /* 9616 */ 'X', 'S', 'M', 'U', 'L', 'S', 'P', 0,
  /* 9624 */ 'X', 'V', 'M', 'U', 'L', 'S', 'P', 0,
  /* 9632 */ 'X', 'S', 'N', 'M', 'S', 'U', 'B', 'M', 'S', 'P', 0,
  /* 9643 */ 'X', 'V', 'N', 'M', 'S', 'U', 'B', 'M', 'S', 'P', 0,
  /* 9654 */ 'X', 'S', 'M', 'S', 'U', 'B', 'M', 'S', 'P', 0,
  /* 9664 */ 'X', 'V', 'M', 'S', 'U', 'B', 'M', 'S', 'P', 0,
  /* 9674 */ 'X', 'S', 'N', 'M', 'A', 'D', 'D', 'M', 'S', 'P', 0,
  /* 9685 */ 'X', 'V', 'N', 'M', 'A', 'D', 'D', 'M', 'S', 'P', 0,
  /* 9696 */ 'X', 'S', 'M', 'A', 'D', 'D', 'M', 'S', 'P', 0,
  /* 9706 */ 'X', 'V', 'M', 'A', 'D', 'D', 'M', 'S', 'P', 0,
  /* 9716 */ 'X', 'V', 'C', 'P', 'S', 'G', 'N', 'S', 'P', 0,
  /* 9726 */ 'X', 'V', 'M', 'I', 'N', 'S', 'P', 0,
  /* 9734 */ 'X', 'S', 'C', 'V', 'D', 'P', 'S', 'P', 0,
  /* 9743 */ 'X', 'V', 'C', 'V', 'D', 'P', 'S', 'P', 0,
  /* 9752 */ 'X', 'V', 'C', 'V', 'H', 'P', 'S', 'P', 0,
  /* 9761 */ 'X', 'V', 'I', 'E', 'X', 'P', 'S', 'P', 0,
  /* 9770 */ 'X', 'V', 'X', 'E', 'X', 'P', 'S', 'P', 0,
  /* 9779 */ 'X', 'V', 'C', 'M', 'P', 'E', 'Q', 'S', 'P', 0,
  /* 9789 */ 'Q', 'V', 'F', 'R', 'S', 'P', 0,
  /* 9796 */ 'X', 'S', 'R', 'S', 'P', 0,
  /* 9802 */ 'X', 'V', 'N', 'A', 'B', 'S', 'S', 'P', 0,
  /* 9811 */ 'X', 'V', 'A', 'B', 'S', 'S', 'P', 0,
  /* 9819 */ 'L', 'X', 'S', 'S', 'P', 0,
  /* 9825 */ 'S', 'T', 'X', 'S', 'S', 'P', 0,
  /* 9832 */ 'X', 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'P', 0,
  /* 9842 */ 'X', 'S', 'S', 'Q', 'R', 'T', 'S', 'P', 0,
  /* 9851 */ 'X', 'V', 'T', 'S', 'Q', 'R', 'T', 'S', 'P', 0,
  /* 9861 */ 'X', 'V', 'S', 'Q', 'R', 'T', 'S', 'P', 0,
  /* 9870 */ 'X', 'S', 'D', 'I', 'V', 'S', 'P', 0,
  /* 9878 */ 'X', 'V', 'T', 'D', 'I', 'V', 'S', 'P', 0,
  /* 9887 */ 'X', 'V', 'D', 'I', 'V', 'S', 'P', 0,
  /* 9895 */ 'X', 'V', 'C', 'V', 'S', 'X', 'W', 'S', 'P', 0,
  /* 9905 */ 'X', 'V', 'C', 'V', 'U', 'X', 'W', 'S', 'P', 0,
  /* 9915 */ 'X', 'V', 'M', 'A', 'X', 'S', 'P', 0,
  /* 9923 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'U', 'P', 0,
  /* 9938 */ 'G', '_', 'F', 'E', 'X', 'P', 0,
  /* 9945 */ 'X', 'S', 'R', 'Q', 'P', 'X', 'P', 0,
  /* 9953 */ 'V', 'P', 'R', 'T', 'Y', 'B', 'Q', 0,
  /* 9961 */ 'E', 'F', 'D', 'C', 'M', 'P', 'E', 'Q', 0,
  /* 9970 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'E', 'Q', 0,
  /* 9979 */ 'E', 'F', 'S', 'C', 'M', 'P', 'E', 'Q', 0,
  /* 9988 */ 'E', 'V', 'F', 'S', 'C', 'M', 'P', 'E', 'Q', 0,
  /* 9998 */ 'E', 'V', 'C', 'M', 'P', 'E', 'Q', 0,
  /* 10006 */ 'E', 'F', 'D', 'T', 'S', 'T', 'E', 'Q', 0,
  /* 10015 */ 'E', 'F', 'S', 'T', 'S', 'T', 'E', 'Q', 0,
  /* 10024 */ 'E', 'V', 'F', 'S', 'T', 'S', 'T', 'E', 'Q', 0,
  /* 10034 */ 'I', 'C', 'B', 'L', 'Q', 0,
  /* 10040 */ 'V', 'B', 'P', 'E', 'R', 'M', 'Q', 0,
  /* 10048 */ 'X', 'X', 'B', 'R', 'Q', 0,
  /* 10054 */ 'V', 'M', 'U', 'L', '1', '0', 'U', 'Q', 0,
  /* 10063 */ 'V', 'M', 'U', 'L', '1', '0', 'C', 'U', 'Q', 0,
  /* 10073 */ 'V', 'S', 'U', 'B', 'C', 'U', 'Q', 0,
  /* 10081 */ 'V', 'A', 'D', 'D', 'C', 'U', 'Q', 0,
  /* 10089 */ 'V', 'M', 'U', 'L', '1', '0', 'E', 'C', 'U', 'Q', 0,
  /* 10100 */ 'V', 'S', 'U', 'B', 'E', 'C', 'U', 'Q', 0,
  /* 10109 */ 'V', 'A', 'D', 'D', 'E', 'C', 'U', 'Q', 0,
  /* 10118 */ 'V', 'M', 'U', 'L', '1', '0', 'E', 'U', 'Q', 0,
  /* 10128 */ 'M', 'B', 'A', 'R', 0,
  /* 10133 */ 'U', 'p', 'd', 'a', 't', 'e', 'G', 'B', 'R', 0,
  /* 10143 */ 'G', '_', 'B', 'R', 0,
  /* 10148 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', '_', 'B', 'R', 0,
  /* 10161 */ 'M', 'F', 'D', 'C', 'R', 0,
  /* 10167 */ 'R', 'L', 'D', 'C', 'R', 0,
  /* 10173 */ 'M', 'T', 'D', 'C', 'R', 0,
  /* 10179 */ 'M', 'F', 'C', 'R', 0,
  /* 10184 */ 'R', 'L', 'D', 'I', 'C', 'R', 0,
  /* 10191 */ 'M', 'F', 'V', 'S', 'C', 'R', 0,
  /* 10198 */ 'M', 'T', 'V', 'S', 'C', 'R', 0,
  /* 10205 */ 'R', 'E', 'S', 'T', 'O', 'R', 'E', '_', 'C', 'R', 0,
  /* 10216 */ 'S', 'P', 'I', 'L', 'L', '_', 'C', 'R', 0,
  /* 10225 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'g', 'd', 'L', 'A', 'D', 'D', 'R', 0,
  /* 10240 */ 'A', 'D', 'D', 'I', 't', 'l', 's', 'l', 'd', 'L', 'A', 'D', 'D', 'R', 0,
  /* 10255 */ 'G', '_', 'B', 'L', 'O', 'C', 'K', '_', 'A', 'D', 'D', 'R', 0,
  /* 10268 */ 'G', 'E', 'T', 't', 'l', 's', 'l', 'd', 'A', 'D', 'D', 'R', 0,
  /* 10281 */ 'G', 'E', 'T', 't', 'l', 's', 'A', 'D', 'D', 'R', 0,
  /* 10292 */ 'V', 'N', 'C', 'I', 'P', 'H', 'E', 'R', 0,
  /* 10301 */ 'V', 'C', 'I', 'P', 'H', 'E', 'R', 0,
  /* 10309 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'N', 'T', 'E', 'R', 0,
  /* 10334 */ 'G', '_', 'A', 'S', 'H', 'R', 0,
  /* 10341 */ 'G', '_', 'L', 'S', 'H', 'R', 0,
  /* 10348 */ 'B', 'L', 'R', 0,
  /* 10352 */ 'g', 'B', 'C', 'L', 'R', 0,
  /* 10358 */ 'B', 'C', 'C', 'L', 'R', 0,
  /* 10364 */ 'M', 'F', 'L', 'R', 0,
  /* 10369 */ 'M', 'T', 'L', 'R', 0,
  /* 10374 */ 'B', 'D', 'Z', 'L', 'R', 0,
  /* 10380 */ 'B', 'D', 'N', 'Z', 'L', 'R', 0,
  /* 10387 */ 'M', 'o', 'v', 'e', 'P', 'C', 't', 'o', 'L', 'R', 0,
  /* 10398 */ 'M', 'o', 'v', 'e', 'G', 'O', 'T', 't', 'o', 'L', 'R', 0,
  /* 10410 */ 'Q', 'V', 'F', 'M', 'R', 0,
  /* 10416 */ 'M', 'F', 'P', 'M', 'R', 0,
  /* 10422 */ 'M', 'T', 'P', 'M', 'R', 0,
  /* 10428 */ 'V', 'P', 'E', 'R', 'M', 'R', 0,
  /* 10435 */ 'X', 'X', 'P', 'E', 'R', 'M', 'R', 0,
  /* 10443 */ 'X', 'X', 'L', 'O', 'R', 0,
  /* 10449 */ 'X', 'X', 'L', 'N', 'O', 'R', 0,
  /* 10456 */ 'C', 'R', 'N', 'O', 'R', 0,
  /* 10462 */ 'E', 'V', 'N', 'O', 'R', 0,
  /* 10468 */ 'G', '_', 'F', 'F', 'L', 'O', 'O', 'R', 0,
  /* 10477 */ 'C', 'R', 'O', 'R', 0,
  /* 10482 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 10497 */ 'G', '_', 'S', 'H', 'U', 'F', 'F', 'L', 'E', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 10514 */ 'E', 'V', 'O', 'R', 0,
  /* 10519 */ 'X', 'X', 'L', 'X', 'O', 'R', 0,
  /* 10526 */ 'V', 'P', 'E', 'R', 'M', 'X', 'O', 'R', 0,
  /* 10535 */ 'C', 'R', 'X', 'O', 'R', 0,
  /* 10541 */ 'E', 'V', 'X', 'O', 'R', 0,
  /* 10547 */ 'G', '_', 'X', 'O', 'R', 0,
  /* 10553 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'O', 'R', 0,
  /* 10569 */ 'G', '_', 'O', 'R', 0,
  /* 10574 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'O', 'R', 0,
  /* 10589 */ 'M', 'F', 'S', 'P', 'R', 0,
  /* 10595 */ 'M', 'T', 'S', 'P', 'R', 0,
  /* 10601 */ 'M', 'F', 'S', 'R', 0,
  /* 10606 */ 'M', 'F', 'M', 'S', 'R', 0,
  /* 10612 */ 'M', 'T', 'M', 'S', 'R', 0,
  /* 10618 */ 'M', 'T', 'S', 'R', 0,
  /* 10623 */ 'L', 'V', 'S', 'R', 0,
  /* 10628 */ 'T', 'A', 'I', 'L', 'B', 'C', 'T', 'R', 0,
  /* 10637 */ 'g', 'B', 'C', 'C', 'T', 'R', 0,
  /* 10644 */ 'B', 'C', 'C', 'C', 'T', 'R', 0,
  /* 10651 */ 'M', 'F', 'C', 'T', 'R', 0,
  /* 10657 */ 'M', 'T', 'C', 'T', 'R', 0,
  /* 10663 */ 'G', '_', 'I', 'N', 'T', 'T', 'O', 'P', 'T', 'R', 0,
  /* 10674 */ 'E', 'F', 'D', 'A', 'B', 'S', 0,
  /* 10681 */ 'Q', 'V', 'F', 'A', 'B', 'S', 0,
  /* 10688 */ 'G', '_', 'F', 'A', 'B', 'S', 0,
  /* 10695 */ 'E', 'F', 'D', 'N', 'A', 'B', 'S', 0,
  /* 10703 */ 'Q', 'V', 'F', 'N', 'A', 'B', 'S', 0,
  /* 10711 */ 'E', 'F', 'S', 'N', 'A', 'B', 'S', 0,
  /* 10719 */ 'E', 'V', 'F', 'S', 'N', 'A', 'B', 'S', 0,
  /* 10728 */ 'E', 'F', 'S', 'A', 'B', 'S', 0,
  /* 10735 */ 'E', 'V', 'F', 'S', 'A', 'B', 'S', 0,
  /* 10743 */ 'E', 'V', 'A', 'B', 'S', 0,
  /* 10749 */ 'V', 'S', 'U', 'M', '4', 'S', 'B', 'S', 0,
  /* 10758 */ 'V', 'S', 'U', 'B', 'S', 'B', 'S', 0,
  /* 10766 */ 'V', 'A', 'D', 'D', 'S', 'B', 'S', 0,
  /* 10774 */ 'V', 'S', 'U', 'M', '4', 'U', 'B', 'S', 0,
  /* 10783 */ 'V', 'S', 'U', 'B', 'U', 'B', 'S', 0,
  /* 10791 */ 'V', 'A', 'D', 'D', 'U', 'B', 'S', 0,
  /* 10799 */ 'Q', 'V', 'F', 'S', 'U', 'B', 'S', 0,
  /* 10807 */ 'Q', 'V', 'F', 'M', 'S', 'U', 'B', 'S', 0,
  /* 10816 */ 'Q', 'V', 'F', 'N', 'M', 'S', 'U', 'B', 'S', 0,
  /* 10826 */ 'Q', 'V', 'F', 'A', 'D', 'D', 'S', 0,
  /* 10834 */ 'Q', 'V', 'F', 'M', 'A', 'D', 'D', 'S', 0,
  /* 10843 */ 'Q', 'V', 'F', 'N', 'M', 'A', 'D', 'D', 'S', 0,
  /* 10853 */ 'Q', 'V', 'F', 'X', 'X', 'C', 'P', 'N', 'M', 'A', 'D', 'D', 'S', 0,
  /* 10867 */ 'Q', 'V', 'F', 'X', 'X', 'N', 'P', 'M', 'A', 'D', 'D', 'S', 0,
  /* 10880 */ 'Q', 'V', 'F', 'X', 'M', 'A', 'D', 'D', 'S', 0,
  /* 10890 */ 'Q', 'V', 'F', 'X', 'X', 'M', 'A', 'D', 'D', 'S', 0,
  /* 10901 */ 'Q', 'V', 'F', 'C', 'F', 'I', 'D', 'S', 0,
  /* 10910 */ 'D', 'C', 'B', 'T', 'D', 'S', 0,
  /* 10917 */ 'D', 'C', 'B', 'T', 'S', 'T', 'D', 'S', 0,
  /* 10926 */ 'X', 'S', 'C', 'V', 'D', 'P', 'S', 'X', 'D', 'S', 0,
  /* 10937 */ 'X', 'V', 'C', 'V', 'D', 'P', 'S', 'X', 'D', 'S', 0,
  /* 10948 */ 'X', 'V', 'C', 'V', 'S', 'P', 'S', 'X', 'D', 'S', 0,
  /* 10959 */ 'X', 'S', 'C', 'V', 'D', 'P', 'U', 'X', 'D', 'S', 0,
  /* 10970 */ 'X', 'V', 'C', 'V', 'D', 'P', 'U', 'X', 'D', 'S', 0,
  /* 10981 */ 'X', 'V', 'C', 'V', 'S', 'P', 'U', 'X', 'D', 'S', 0,
  /* 10992 */ 'V', '_', 'S', 'E', 'T', 'A', 'L', 'L', 'O', 'N', 'E', 'S', 0,
  /* 11005 */ 'Q', 'V', 'F', 'R', 'E', 'S', 0,
  /* 11012 */ 'Q', 'V', 'F', 'R', 'S', 'Q', 'R', 'T', 'E', 'S', 0,
  /* 11023 */ 'G', '_', 'U', 'N', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 11040 */ 'G', '_', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 11055 */ 'E', 'F', 'D', 'C', 'F', 'S', 0,
  /* 11062 */ 'M', 'F', 'F', 'S', 0,
  /* 11067 */ 'L', 'F', 'S', 0,
  /* 11071 */ 'M', 'C', 'R', 'F', 'S', 0,
  /* 11077 */ 'S', 'T', 'F', 'S', 0,
  /* 11082 */ 'F', 'N', 'E', 'G', 'S', 0,
  /* 11088 */ 'V', 'S', 'U', 'M', '4', 'S', 'H', 'S', 0,
  /* 11097 */ 'V', 'S', 'U', 'B', 'S', 'H', 'S', 0,
  /* 11105 */ 'V', 'M', 'H', 'A', 'D', 'D', 'S', 'H', 'S', 0,
  /* 11115 */ 'V', 'M', 'H', 'R', 'A', 'D', 'D', 'S', 'H', 'S', 0,
  /* 11126 */ 'V', 'A', 'D', 'D', 'S', 'H', 'S', 0,
  /* 11134 */ 'V', 'M', 'S', 'U', 'M', 'S', 'H', 'S', 0,
  /* 11143 */ 'V', 'S', 'U', 'B', 'U', 'H', 'S', 0,
  /* 11151 */ 'V', 'A', 'D', 'D', 'U', 'H', 'S', 0,
  /* 11159 */ 'V', 'M', 'S', 'U', 'M', 'U', 'H', 'S', 0,
  /* 11168 */ 'S', 'U', 'B', 'I', 'S', 0,
  /* 11174 */ 'S', 'U', 'B', 'P', 'C', 'I', 'S', 0,
  /* 11182 */ 'A', 'D', 'D', 'P', 'C', 'I', 'S', 0,
  /* 11190 */ 'A', 'D', 'D', 'I', 'S', 0,
  /* 11196 */ 'L', 'I', 'S', 0,
  /* 11200 */ 'X', 'O', 'R', 'I', 'S', 0,
  /* 11206 */ 'E', 'V', 'S', 'R', 'W', 'I', 'S', 0,
  /* 11214 */ 'F', 'S', 'E', 'L', 'S', 0,
  /* 11220 */ 'A', 'D', 'D', '4', 'T', 'L', 'S', 0,
  /* 11228 */ 'A', 'D', 'D', '8', 'T', 'L', 'S', 0,
  /* 11236 */ 'I', 'C', 'B', 'T', 'L', 'S', 0,
  /* 11243 */ 'S', 'T', 'B', 'X', 'T', 'L', 'S', 0,
  /* 11251 */ 'L', 'D', 'X', 'T', 'L', 'S', 0,
  /* 11258 */ 'S', 'T', 'D', 'X', 'T', 'L', 'S', 0,
  /* 11266 */ 'S', 'T', 'H', 'X', 'T', 'L', 'S', 0,
  /* 11274 */ 'S', 'T', 'W', 'X', 'T', 'L', 'S', 0,
  /* 11282 */ 'L', 'B', 'Z', 'X', 'T', 'L', 'S', 0,
  /* 11290 */ 'L', 'H', 'Z', 'X', 'T', 'L', 'S', 0,
  /* 11298 */ 'L', 'W', 'Z', 'X', 'T', 'L', 'S', 0,
  /* 11306 */ 'B', 'L', '8', '_', 'T', 'L', 'S', 0,
  /* 11314 */ 'B', 'L', '_', 'T', 'L', 'S', 0,
  /* 11321 */ 'B', 'L', '8', '_', 'N', 'O', 'P', '_', 'T', 'L', 'S', 0,
  /* 11333 */ 'Q', 'V', 'F', 'M', 'U', 'L', 'S', 0,
  /* 11341 */ 'Q', 'V', 'F', 'X', 'M', 'U', 'L', 'S', 0,
  /* 11350 */ 'F', 'R', 'I', 'M', 'S', 0,
  /* 11356 */ 'F', 'C', 'P', 'S', 'G', 'N', 'S', 0,
  /* 11364 */ 'F', 'R', 'I', 'N', 'S', 0,
  /* 11370 */ 'G', '_', 'F', 'C', 'O', 'S', 0,
  /* 11377 */ 'E', 'V', 'L', 'W', 'H', 'O', 'S', 0,
  /* 11385 */ 'F', 'R', 'I', 'P', 'S', 0,
  /* 11391 */ 'G', '_', 'C', 'O', 'N', 'C', 'A', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', 'S', 0,
  /* 11408 */ 'C', 'O', 'P', 'Y', '_', 'T', 'O', '_', 'R', 'E', 'G', 'C', 'L', 'A', 'S', 'S', 0,
  /* 11425 */ 'F', 'A', 'B', 'S', 'S', 0,
  /* 11431 */ 'F', 'N', 'A', 'B', 'S', 'S', 0,
  /* 11438 */ 'V', 'P', 'K', 'S', 'D', 'S', 'S', 0,
  /* 11446 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'W', 'I', 'T', 'H', '_', 'S', 'U', 'C', 'C', 'E', 'S', 'S', 0,
  /* 11476 */ 'V', 'P', 'K', 'S', 'H', 'S', 'S', 0,
  /* 11484 */ 'V', 'P', 'K', 'S', 'W', 'S', 'S', 0,
  /* 11492 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'W', '_', 'S', 'I', 'D', 'E', '_', 'E', 'F', 'F', 'E', 'C', 'T', 'S', 0,
  /* 11519 */ 'E', 'V', 'C', 'M', 'P', 'G', 'T', 'S', 0,
  /* 11528 */ 'E', 'V', 'C', 'M', 'P', 'L', 'T', 'S', 0,
  /* 11537 */ 'F', 'S', 'Q', 'R', 'T', 'S', 0,
  /* 11544 */ 'Q', 'V', 'F', 'C', 'F', 'I', 'D', 'U', 'S', 0,
  /* 11554 */ 'V', 'P', 'K', 'S', 'D', 'U', 'S', 0,
  /* 11562 */ 'V', 'P', 'K', 'U', 'D', 'U', 'S', 0,
  /* 11570 */ 'V', 'P', 'K', 'S', 'H', 'U', 'S', 0,
  /* 11578 */ 'V', 'P', 'K', 'U', 'H', 'U', 'S', 0,
  /* 11586 */ 'F', 'C', 'M', 'P', 'U', 'S', 0,
  /* 11593 */ 'V', 'P', 'K', 'S', 'W', 'U', 'S', 0,
  /* 11601 */ 'V', 'P', 'K', 'U', 'W', 'U', 'S', 0,
  /* 11609 */ 'F', 'D', 'I', 'V', 'S', 0,
  /* 11615 */ 'E', 'V', 'S', 'R', 'W', 'S', 0,
  /* 11622 */ 'M', 'T', 'V', 'S', 'R', 'W', 'S', 0,
  /* 11630 */ 'V', 'S', 'U', 'M', '2', 'S', 'W', 'S', 0,
  /* 11639 */ 'V', 'S', 'U', 'B', 'S', 'W', 'S', 0,
  /* 11647 */ 'V', 'A', 'D', 'D', 'S', 'W', 'S', 0,
  /* 11655 */ 'V', 'S', 'U', 'M', 'S', 'W', 'S', 0,
  /* 11663 */ 'V', 'S', 'U', 'B', 'U', 'W', 'S', 0,
  /* 11671 */ 'V', 'A', 'D', 'D', 'U', 'W', 'S', 0,
  /* 11679 */ 'E', 'V', 'D', 'I', 'V', 'W', 'S', 0,
  /* 11687 */ 'X', 'S', 'C', 'V', 'D', 'P', 'S', 'X', 'W', 'S', 0,
  /* 11698 */ 'X', 'V', 'C', 'V', 'D', 'P', 'S', 'X', 'W', 'S', 0,
  /* 11709 */ 'X', 'V', 'C', 'V', 'S', 'P', 'S', 'X', 'W', 'S', 0,
  /* 11720 */ 'X', 'S', 'C', 'V', 'D', 'P', 'U', 'X', 'W', 'S', 0,
  /* 11731 */ 'X', 'V', 'C', 'V', 'D', 'P', 'U', 'X', 'W', 'S', 0,
  /* 11742 */ 'X', 'V', 'C', 'V', 'S', 'P', 'U', 'X', 'W', 'S', 0,
  /* 11753 */ 'V', 'C', 'T', 'S', 'X', 'S', 0,
  /* 11760 */ 'V', 'C', 'T', 'U', 'X', 'S', 0,
  /* 11767 */ 'F', 'R', 'I', 'Z', 'S', 0,
  /* 11773 */ 'L', 'D', 'A', 'T', 0,
  /* 11778 */ 'S', 'T', 'D', 'A', 'T', 0,
  /* 11784 */ 'E', 'V', 'L', 'H', 'H', 'E', 'S', 'P', 'L', 'A', 'T', 0,
  /* 11796 */ 'E', 'V', 'L', 'W', 'H', 'S', 'P', 'L', 'A', 'T', 0,
  /* 11807 */ 'E', 'V', 'L', 'H', 'H', 'O', 'S', 'S', 'P', 'L', 'A', 'T', 0,
  /* 11820 */ 'E', 'V', 'L', 'H', 'H', 'O', 'U', 'S', 'P', 'L', 'A', 'T', 0,
  /* 11833 */ 'E', 'V', 'L', 'W', 'W', 'S', 'P', 'L', 'A', 'T', 0,
  /* 11844 */ 'L', 'W', 'A', 'T', 0,
  /* 11849 */ 'S', 'T', 'W', 'A', 'T', 0,
  /* 11855 */ 'D', 'C', 'B', 'T', 0,
  /* 11860 */ 'I', 'C', 'B', 'T', 0,
  /* 11865 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 0,
  /* 11875 */ 'G', '_', 'S', 'E', 'L', 'E', 'C', 'T', 0,
  /* 11884 */ 'G', '_', 'B', 'R', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', 0,
  /* 11897 */ 'D', 'C', 'B', 'T', 'C', 'T', 0,
  /* 11904 */ 'D', 'C', 'B', 'T', 'S', 'T', 'C', 'T', 0,
  /* 11913 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'R', 'E', 'T', 0,
  /* 11927 */ 'T', 'C', 'H', 'E', 'C', 'K', '_', 'R', 'E', 'T', 0,
  /* 11938 */ 'T', 'B', 'E', 'G', 'I', 'N', '_', 'R', 'E', 'T', 0,
  /* 11949 */ 'C', 'R', '6', 'S', 'E', 'T', 0,
  /* 11956 */ 'D', 'Y', 'N', 'A', 'R', 'E', 'A', 'O', 'F', 'F', 'S', 'E', 'T', 0,
  /* 11970 */ 'C', 'R', '6', 'U', 'N', 'S', 'E', 'T', 0,
  /* 11979 */ 'C', 'R', 'U', 'N', 'S', 'E', 'T', 0,
  /* 11987 */ 'C', 'R', 'S', 'E', 'T', 0,
  /* 11993 */ 'E', 'F', 'D', 'C', 'M', 'P', 'G', 'T', 0,
  /* 12002 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'G', 'T', 0,
  /* 12011 */ 'E', 'F', 'S', 'C', 'M', 'P', 'G', 'T', 0,
  /* 12020 */ 'E', 'V', 'F', 'S', 'C', 'M', 'P', 'G', 'T', 0,
  /* 12030 */ 'E', 'F', 'D', 'T', 'S', 'T', 'G', 'T', 0,
  /* 12039 */ 'E', 'F', 'S', 'T', 'S', 'T', 'G', 'T', 0,
  /* 12048 */ 'E', 'V', 'F', 'S', 'T', 'S', 'T', 'G', 'T', 0,
  /* 12058 */ 'W', 'A', 'I', 'T', 0,
  /* 12063 */ 'R', 'E', 'S', 'T', 'O', 'R', 'E', '_', 'C', 'R', 'B', 'I', 'T', 0,
  /* 12077 */ 'S', 'P', 'I', 'L', 'L', '_', 'C', 'R', 'B', 'I', 'T', 0,
  /* 12089 */ 'A', 'N', 'D', 'I', 'o', '_', '1', '_', 'E', 'Q', '_', 'B', 'I', 'T', 0,
  /* 12104 */ 'A', 'N', 'D', 'I', 'o', '_', '1', '_', 'G', 'T', '_', 'B', 'I', 'T', 0,
  /* 12119 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'X', 'I', 'T', 0,
  /* 12143 */ 'G', '_', 'B', 'R', 'J', 'T', 0,
  /* 12150 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 12171 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 12191 */ 'E', 'F', 'D', 'C', 'M', 'P', 'L', 'T', 0,
  /* 12200 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'L', 'T', 0,
  /* 12209 */ 'E', 'F', 'S', 'C', 'M', 'P', 'L', 'T', 0,
  /* 12218 */ 'E', 'V', 'F', 'S', 'C', 'M', 'P', 'L', 'T', 0,
  /* 12228 */ 'E', 'F', 'D', 'T', 'S', 'T', 'L', 'T', 0,
  /* 12237 */ 'E', 'F', 'S', 'T', 'S', 'T', 'L', 'T', 0,
  /* 12246 */ 'E', 'V', 'F', 'S', 'T', 'S', 'T', 'L', 'T', 0,
  /* 12256 */ 'G', '_', 'F', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 12268 */ 'G', '_', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 12279 */ 'S', 'T', 'A', 'T', 'E', 'P', 'O', 'I', 'N', 'T', 0,
  /* 12290 */ 'P', 'A', 'T', 'C', 'H', 'P', 'O', 'I', 'N', 'T', 0,
  /* 12301 */ 'G', '_', 'P', 'T', 'R', 'T', 'O', 'I', 'N', 'T', 0,
  /* 12312 */ 'G', '_', 'F', 'R', 'I', 'N', 'T', 0,
  /* 12320 */ 'G', '_', 'F', 'N', 'E', 'A', 'R', 'B', 'Y', 'I', 'N', 'T', 0,
  /* 12333 */ 'P', 'P', 'C', '3', '2', 'G', 'O', 'T', 0,
  /* 12342 */ 'P', 'P', 'C', '3', '2', 'P', 'I', 'C', 'G', 'O', 'T', 0,
  /* 12354 */ 'L', 'D', 't', 'o', 'c', 'C', 'P', 'T', 0,
  /* 12363 */ 'T', 'R', 'E', 'C', 'H', 'K', 'P', 'T', 0,
  /* 12372 */ 'G', '_', 'V', 'A', 'S', 'T', 'A', 'R', 'T', 0,
  /* 12382 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'S', 'T', 'A', 'R', 'T', 0,
  /* 12397 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', 0,
  /* 12406 */ 'T', 'A', 'B', 'O', 'R', 'T', 0,
  /* 12413 */ 'C', 'P', '_', 'A', 'B', 'O', 'R', 'T', 0,
  /* 12422 */ 'G', '_', 'F', 'S', 'Q', 'R', 'T', 0,
  /* 12430 */ 'F', 'T', 'S', 'Q', 'R', 'T', 0,
  /* 12437 */ 'G', '_', 'B', 'I', 'T', 'C', 'A', 'S', 'T', 0,
  /* 12447 */ 'G', '_', 'A', 'D', 'D', 'R', 'S', 'P', 'A', 'C', 'E', '_', 'C', 'A', 'S', 'T', 0,
  /* 12464 */ 'V', 'N', 'C', 'I', 'P', 'H', 'E', 'R', 'L', 'A', 'S', 'T', 0,
  /* 12477 */ 'V', 'C', 'I', 'P', 'H', 'E', 'R', 'L', 'A', 'S', 'T', 0,
  /* 12489 */ 'C', 'P', '_', 'P', 'A', 'S', 'T', 'E', '_', 'L', 'A', 'S', 'T', 0,
  /* 12503 */ 'D', 'C', 'B', 'S', 'T', 0,
  /* 12509 */ 'D', 'S', 'T', 0,
  /* 12513 */ 'C', 'P', '_', 'C', 'O', 'P', 'Y', '_', 'F', 'I', 'R', 'S', 'T', 0,
  /* 12527 */ 'D', 'C', 'B', 'T', 'S', 'T', 0,
  /* 12534 */ 'D', 'S', 'T', 'S', 'T', 0,
  /* 12540 */ 'S', 'P', 'I', 'L', 'L', 'T', 'O', 'V', 'S', 'R', '_', 'S', 'T', 0,
  /* 12554 */ 'D', 'C', 'B', 'T', 'T', 0,
  /* 12560 */ 'D', 'S', 'T', 'T', 0,
  /* 12565 */ 'D', 'C', 'B', 'T', 'S', 'T', 'T', 0,
  /* 12573 */ 'D', 'S', 'T', 'S', 'T', 'T', 0,
  /* 12580 */ 'G', '_', 'F', 'P', 'E', 'X', 'T', 0,
  /* 12588 */ 'G', '_', 'S', 'E', 'X', 'T', 0,
  /* 12595 */ 'G', '_', 'A', 'N', 'Y', 'E', 'X', 'T', 0,
  /* 12604 */ 'G', '_', 'Z', 'E', 'X', 'T', 0,
  /* 12611 */ 'L', 'H', 'A', 'U', 0,
  /* 12616 */ 'S', 'T', 'B', 'U', 0,
  /* 12621 */ 'L', 'F', 'D', 'U', 0,
  /* 12626 */ 'S', 'T', 'F', 'D', 'U', 0,
  /* 12632 */ 'M', 'A', 'D', 'D', 'H', 'D', 'U', 0,
  /* 12640 */ 'M', 'U', 'L', 'H', 'D', 'U', 0,
  /* 12647 */ 'Q', 'V', 'F', 'C', 'F', 'I', 'D', 'U', 0,
  /* 12656 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'D', 'U', 0,
  /* 12665 */ 'L', 'D', 'U', 0,
  /* 12669 */ 'S', 'T', 'D', 'U', 0,
  /* 12674 */ 'D', 'I', 'V', 'D', 'U', 0,
  /* 12680 */ 'D', 'I', 'V', 'D', 'E', 'U', 0,
  /* 12687 */ 'D', 'I', 'V', 'W', 'E', 'U', 0,
  /* 12694 */ 'S', 'T', 'H', 'U', 0,
  /* 12699 */ 'E', 'V', 'S', 'R', 'W', 'I', 'U', 0,
  /* 12707 */ 'E', 'V', 'L', 'W', 'H', 'O', 'U', 0,
  /* 12715 */ 'L', 'F', 'S', 'U', 0,
  /* 12720 */ 'S', 'T', 'F', 'S', 'U', 0,
  /* 12726 */ 'E', 'V', 'C', 'M', 'P', 'G', 'T', 'U', 0,
  /* 12735 */ 'E', 'V', 'C', 'M', 'P', 'L', 'T', 'U', 0,
  /* 12744 */ 'M', 'U', 'L', 'H', 'W', 'U', 0,
  /* 12751 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'W', 'U', 0,
  /* 12760 */ 'E', 'V', 'S', 'R', 'W', 'U', 0,
  /* 12767 */ 'S', 'T', 'W', 'U', 0,
  /* 12772 */ 'E', 'V', 'D', 'I', 'V', 'W', 'U', 0,
  /* 12780 */ 'L', 'B', 'Z', 'U', 0,
  /* 12785 */ 'L', 'H', 'Z', 'U', 0,
  /* 12790 */ 'L', 'W', 'Z', 'U', 0,
  /* 12795 */ 'S', 'L', 'B', 'M', 'F', 'E', 'V', 0,
  /* 12803 */ 'E', 'F', 'D', 'D', 'I', 'V', 0,
  /* 12810 */ 'G', '_', 'F', 'D', 'I', 'V', 0,
  /* 12817 */ 'E', 'F', 'S', 'D', 'I', 'V', 0,
  /* 12824 */ 'E', 'V', 'F', 'S', 'D', 'I', 'V', 0,
  /* 12832 */ 'G', '_', 'S', 'D', 'I', 'V', 0,
  /* 12839 */ 'F', 'T', 'D', 'I', 'V', 0,
  /* 12845 */ 'G', '_', 'U', 'D', 'I', 'V', 0,
  /* 12852 */ 'V', 'S', 'L', 'V', 0,
  /* 12857 */ 'X', 'X', 'L', 'E', 'Q', 'V', 0,
  /* 12864 */ 'C', 'R', 'E', 'Q', 'V', 0,
  /* 12870 */ 'E', 'V', 'E', 'Q', 'V', 0,
  /* 12876 */ 'V', 'S', 'R', 'V', 0,
  /* 12881 */ 'L', 'X', 'V', 0,
  /* 12885 */ 'S', 'T', 'X', 'V', 0,
  /* 12890 */ 'V', 'E', 'X', 'T', 'S', 'B', '2', 'W', 0,
  /* 12899 */ 'V', 'E', 'X', 'T', 'S', 'H', '2', 'W', 0,
  /* 12908 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'F', 'A', 'A', 'W', 0,
  /* 12920 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'F', 'A', 'A', 'W', 0,
  /* 12932 */ 'E', 'V', 'M', 'H', 'E', 'S', 'S', 'F', 'A', 'A', 'W', 0,
  /* 12944 */ 'E', 'V', 'M', 'H', 'O', 'S', 'S', 'F', 'A', 'A', 'W', 0,
  /* 12956 */ 'E', 'V', 'A', 'D', 'D', 'S', 'M', 'I', 'A', 'A', 'W', 0,
  /* 12968 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'I', 'A', 'A', 'W', 0,
  /* 12980 */ 'E', 'V', 'S', 'U', 'B', 'F', 'S', 'M', 'I', 'A', 'A', 'W', 0,
  /* 12993 */ 'E', 'V', 'M', 'W', 'L', 'S', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13005 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13017 */ 'E', 'V', 'A', 'D', 'D', 'U', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13029 */ 'E', 'V', 'M', 'H', 'E', 'U', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13041 */ 'E', 'V', 'S', 'U', 'B', 'F', 'U', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13054 */ 'E', 'V', 'M', 'W', 'L', 'U', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13066 */ 'E', 'V', 'M', 'H', 'O', 'U', 'M', 'I', 'A', 'A', 'W', 0,
  /* 13078 */ 'E', 'V', 'A', 'D', 'D', 'S', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13090 */ 'E', 'V', 'M', 'H', 'E', 'S', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13102 */ 'E', 'V', 'S', 'U', 'B', 'F', 'S', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13115 */ 'E', 'V', 'M', 'W', 'L', 'S', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13127 */ 'E', 'V', 'M', 'H', 'O', 'S', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13139 */ 'E', 'V', 'A', 'D', 'D', 'U', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13151 */ 'E', 'V', 'M', 'H', 'E', 'U', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13163 */ 'E', 'V', 'S', 'U', 'B', 'F', 'U', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13176 */ 'E', 'V', 'M', 'W', 'L', 'U', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13188 */ 'E', 'V', 'M', 'H', 'O', 'U', 'S', 'I', 'A', 'A', 'W', 0,
  /* 13200 */ 'V', 'S', 'H', 'A', 'S', 'I', 'G', 'M', 'A', 'W', 0,
  /* 13211 */ 'V', 'S', 'R', 'A', 'W', 0,
  /* 13217 */ 'V', 'P', 'R', 'T', 'Y', 'B', 'W', 0,
  /* 13225 */ 'E', 'V', 'A', 'D', 'D', 'W', 0,
  /* 13232 */ 'E', 'V', 'L', 'D', 'W', 0,
  /* 13238 */ 'E', 'V', 'R', 'N', 'D', 'W', 0,
  /* 13245 */ 'E', 'V', 'S', 'T', 'D', 'W', 0,
  /* 13252 */ 'V', 'M', 'R', 'G', 'E', 'W', 0,
  /* 13259 */ 'V', 'C', 'M', 'P', 'N', 'E', 'W', 0,
  /* 13267 */ 'E', 'V', 'S', 'U', 'B', 'F', 'W', 0,
  /* 13275 */ 'E', 'V', 'S', 'U', 'B', 'I', 'F', 'W', 0,
  /* 13284 */ 'V', 'N', 'E', 'G', 'W', 0,
  /* 13290 */ 'V', 'M', 'R', 'G', 'H', 'W', 0,
  /* 13297 */ 'X', 'X', 'M', 'R', 'G', 'H', 'W', 0,
  /* 13305 */ 'M', 'U', 'L', 'H', 'W', 0,
  /* 13311 */ 'E', 'V', 'A', 'D', 'D', 'I', 'W', 0,
  /* 13319 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'W', 0,
  /* 13327 */ 'V', 'M', 'R', 'G', 'L', 'W', 0,
  /* 13334 */ 'X', 'X', 'M', 'R', 'G', 'L', 'W', 0,
  /* 13342 */ 'M', 'U', 'L', 'L', 'W', 0,
  /* 13348 */ 'C', 'M', 'P', 'L', 'W', 0,
  /* 13354 */ 'E', 'V', 'R', 'L', 'W', 0,
  /* 13360 */ 'E', 'V', 'S', 'L', 'W', 0,
  /* 13366 */ 'L', 'M', 'W', 0,
  /* 13370 */ 'S', 'T', 'M', 'W', 0,
  /* 13375 */ 'V', 'P', 'M', 'S', 'U', 'M', 'W', 0,
  /* 13383 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'F', 'A', 'N', 'W', 0,
  /* 13395 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'F', 'A', 'N', 'W', 0,
  /* 13407 */ 'E', 'V', 'M', 'H', 'E', 'S', 'S', 'F', 'A', 'N', 'W', 0,
  /* 13419 */ 'E', 'V', 'M', 'H', 'O', 'S', 'S', 'F', 'A', 'N', 'W', 0,
  /* 13431 */ 'E', 'V', 'M', 'H', 'E', 'S', 'M', 'I', 'A', 'N', 'W', 0,
  /* 13443 */ 'E', 'V', 'M', 'W', 'L', 'S', 'M', 'I', 'A', 'N', 'W', 0,
  /* 13455 */ 'E', 'V', 'M', 'H', 'O', 'S', 'M', 'I', 'A', 'N', 'W', 0,
  /* 13467 */ 'E', 'V', 'M', 'H', 'E', 'U', 'M', 'I', 'A', 'N', 'W', 0,
  /* 13479 */ 'E', 'V', 'M', 'W', 'L', 'U', 'M', 'I', 'A', 'N', 'W', 0,
  /* 13491 */ 'E', 'V', 'M', 'H', 'O', 'U', 'M', 'I', 'A', 'N', 'W', 0,
  /* 13503 */ 'E', 'V', 'M', 'H', 'E', 'S', 'S', 'I', 'A', 'N', 'W', 0,
  /* 13515 */ 'E', 'V', 'M', 'W', 'L', 'S', 'S', 'I', 'A', 'N', 'W', 0,
  /* 13527 */ 'E', 'V', 'M', 'H', 'O', 'S', 'S', 'I', 'A', 'N', 'W', 0,
  /* 13539 */ 'E', 'V', 'M', 'H', 'E', 'U', 'S', 'I', 'A', 'N', 'W', 0,
  /* 13551 */ 'E', 'V', 'M', 'W', 'L', 'U', 'S', 'I', 'A', 'N', 'W', 0,
  /* 13563 */ 'E', 'V', 'M', 'H', 'O', 'U', 'S', 'I', 'A', 'N', 'W', 0,
  /* 13575 */ 'V', 'M', 'R', 'G', 'O', 'W', 0,
  /* 13582 */ 'G', '_', 'F', 'P', 'O', 'W', 0,
  /* 13589 */ 'C', 'M', 'P', 'W', 0,
  /* 13594 */ 'X', 'X', 'B', 'R', 'W', 0,
  /* 13600 */ 'V', 'S', 'R', 'W', 0,
  /* 13605 */ 'M', 'O', 'D', 'S', 'W', 0,
  /* 13611 */ 'V', 'M', 'U', 'L', 'E', 'S', 'W', 0,
  /* 13619 */ 'V', 'A', 'V', 'G', 'S', 'W', 0,
  /* 13626 */ 'V', 'U', 'P', 'K', 'H', 'S', 'W', 0,
  /* 13634 */ 'V', 'S', 'P', 'L', 'T', 'I', 'S', 'W', 0,
  /* 13643 */ 'V', 'U', 'P', 'K', 'L', 'S', 'W', 0,
  /* 13651 */ 'E', 'V', 'C', 'N', 'T', 'L', 'S', 'W', 0,
  /* 13660 */ 'V', 'M', 'I', 'N', 'S', 'W', 0,
  /* 13667 */ 'V', 'M', 'U', 'L', 'O', 'S', 'W', 0,
  /* 13675 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'W', 0,
  /* 13684 */ 'E', 'X', 'T', 'S', 'W', 0,
  /* 13690 */ 'V', 'M', 'A', 'X', 'S', 'W', 0,
  /* 13697 */ 'V', 'S', 'P', 'L', 'T', 'W', 0,
  /* 13704 */ 'X', 'X', 'S', 'P', 'L', 'T', 'W', 0,
  /* 13712 */ 'V', 'P', 'O', 'P', 'C', 'N', 'T', 'W', 0,
  /* 13721 */ 'V', 'I', 'N', 'S', 'E', 'R', 'T', 'W', 0,
  /* 13730 */ 'X', 'X', 'I', 'N', 'S', 'E', 'R', 'T', 'W', 0,
  /* 13740 */ 'S', 'P', 'E', 'S', 'T', 'W', 0,
  /* 13747 */ 'V', 'S', 'U', 'B', 'C', 'U', 'W', 0,
  /* 13755 */ 'V', 'A', 'D', 'D', 'C', 'U', 'W', 0,
  /* 13763 */ 'M', 'O', 'D', 'U', 'W', 0,
  /* 13769 */ 'V', 'A', 'B', 'S', 'D', 'U', 'W', 0,
  /* 13777 */ 'V', 'M', 'U', 'L', 'E', 'U', 'W', 0,
  /* 13785 */ 'V', 'A', 'V', 'G', 'U', 'W', 0,
  /* 13792 */ 'V', 'M', 'I', 'N', 'U', 'W', 0,
  /* 13799 */ 'V', 'M', 'U', 'L', 'O', 'U', 'W', 0,
  /* 13807 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'W', 0,
  /* 13816 */ 'V', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 'U', 'W', 0,
  /* 13827 */ 'X', 'X', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 'U', 'W', 0,
  /* 13839 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'W', 0,
  /* 13848 */ 'V', 'M', 'A', 'X', 'U', 'W', 0,
  /* 13855 */ 'D', 'I', 'V', 'W', 0,
  /* 13860 */ 'V', 'C', 'M', 'P', 'N', 'E', 'Z', 'W', 0,
  /* 13869 */ 'V', 'C', 'L', 'Z', 'W', 0,
  /* 13875 */ 'E', 'V', 'C', 'N', 'T', 'L', 'Z', 'W', 0,
  /* 13884 */ 'V', 'C', 'T', 'Z', 'W', 0,
  /* 13890 */ 'C', 'N', 'T', 'T', 'Z', 'W', 0,
  /* 13897 */ 'L', 'X', 'V', 'D', '2', 'X', 0,
  /* 13904 */ 'S', 'T', 'X', 'V', 'D', '2', 'X', 0,
  /* 13912 */ 'L', 'X', 'V', 'W', '4', 'X', 0,
  /* 13919 */ 'S', 'T', 'X', 'V', 'W', '4', 'X', 0,
  /* 13927 */ 'L', 'X', 'V', 'B', '1', '6', 'X', 0,
  /* 13935 */ 'S', 'T', 'X', 'V', 'B', '1', '6', 'X', 0,
  /* 13944 */ 'L', 'X', 'V', 'H', '8', 'X', 0,
  /* 13951 */ 'S', 'T', 'X', 'V', 'H', '8', 'X', 0,
  /* 13959 */ 'L', 'H', 'A', 'X', 0,
  /* 13964 */ 'G', '_', 'S', 'M', 'A', 'X', 0,
  /* 13971 */ 'G', '_', 'U', 'M', 'A', 'X', 0,
  /* 13978 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'A', 'X', 0,
  /* 13995 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'A', 'X', 0,
  /* 14011 */ 'T', 'L', 'B', 'I', 'V', 'A', 'X', 0,
  /* 14019 */ 'Q', 'V', 'L', 'F', 'I', 'W', 'A', 'X', 0,
  /* 14028 */ 'L', 'I', 'W', 'A', 'X', 0,
  /* 14034 */ 'L', 'X', 'S', 'I', 'W', 'A', 'X', 0,
  /* 14042 */ 'L', 'W', 'A', 'X', 0,
  /* 14047 */ 'L', 'V', 'E', 'B', 'X', 0,
  /* 14053 */ 'S', 'T', 'V', 'E', 'B', 'X', 0,
  /* 14060 */ 'S', 'T', 'X', 'S', 'I', 'B', 'X', 0,
  /* 14068 */ 'S', 'T', 'B', 'X', 0,
  /* 14073 */ 'S', 'T', 'B', 'C', 'X', 0,
  /* 14079 */ 'S', 'T', 'D', 'C', 'X', 0,
  /* 14085 */ 'S', 'T', 'H', 'C', 'X', 0,
  /* 14091 */ 'S', 'T', 'W', 'C', 'X', 0,
  /* 14097 */ 'Q', 'V', 'L', 'F', 'C', 'D', 'X', 0,
  /* 14105 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'X', 0,
  /* 14114 */ 'E', 'V', 'L', 'D', 'D', 'X', 0,
  /* 14121 */ 'E', 'V', 'S', 'T', 'D', 'D', 'X', 0,
  /* 14129 */ 'Q', 'V', 'L', 'F', 'D', 'X', 0,
  /* 14136 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'X', 0,
  /* 14144 */ 'Q', 'V', 'L', 'P', 'C', 'L', 'D', 'X', 0,
  /* 14153 */ 'S', 'P', 'I', 'L', 'L', 'T', 'O', 'V', 'S', 'R', '_', 'L', 'D', 'X', 0,
  /* 14168 */ 'Q', 'V', 'L', 'P', 'C', 'R', 'D', 'X', 0,
  /* 14177 */ 'L', 'X', 'S', 'D', 'X', 0,
  /* 14183 */ 'S', 'T', 'X', 'S', 'D', 'X', 0,
  /* 14190 */ 'S', 'T', 'D', 'X', 0,
  /* 14195 */ 'G', '_', 'F', 'R', 'A', 'M', 'E', '_', 'I', 'N', 'D', 'E', 'X', 0,
  /* 14209 */ 'E', 'V', 'L', 'W', 'H', 'E', 'X', 0,
  /* 14217 */ 'E', 'V', 'S', 'T', 'W', 'H', 'E', 'X', 0,
  /* 14226 */ 'E', 'V', 'S', 'T', 'W', 'W', 'E', 'X', 0,
  /* 14235 */ 'E', 'V', 'L', 'D', 'H', 'X', 0,
  /* 14242 */ 'E', 'V', 'S', 'T', 'D', 'H', 'X', 0,
  /* 14250 */ 'L', 'V', 'E', 'H', 'X', 0,
  /* 14256 */ 'S', 'T', 'V', 'E', 'H', 'X', 0,
  /* 14263 */ 'S', 'T', 'X', 'S', 'I', 'H', 'X', 0,
  /* 14271 */ 'S', 'T', 'H', 'X', 0,
  /* 14276 */ 'S', 'T', 'B', 'C', 'I', 'X', 0,
  /* 14283 */ 'L', 'D', 'C', 'I', 'X', 0,
  /* 14289 */ 'S', 'T', 'D', 'C', 'I', 'X', 0,
  /* 14296 */ 'S', 'T', 'H', 'C', 'I', 'X', 0,
  /* 14303 */ 'S', 'T', 'W', 'C', 'I', 'X', 0,
  /* 14310 */ 'L', 'B', 'Z', 'C', 'I', 'X', 0,
  /* 14317 */ 'L', 'H', 'Z', 'C', 'I', 'X', 0,
  /* 14324 */ 'L', 'W', 'Z', 'C', 'I', 'X', 0,
  /* 14331 */ 'X', 'S', 'R', 'Q', 'P', 'I', 'X', 0,
  /* 14339 */ 'V', 'E', 'X', 'T', 'U', 'B', 'L', 'X', 0,
  /* 14348 */ 'V', 'E', 'X', 'T', 'U', 'H', 'L', 'X', 0,
  /* 14357 */ 'V', 'E', 'X', 'T', 'U', 'W', 'L', 'X', 0,
  /* 14366 */ 'L', 'D', 'M', 'X', 0,
  /* 14371 */ 'V', 'S', 'B', 'O', 'X', 0,
  /* 14377 */ 'E', 'V', 'S', 'T', 'W', 'H', 'O', 'X', 0,
  /* 14386 */ 'E', 'V', 'S', 'T', 'W', 'W', 'O', 'X', 0,
  /* 14395 */ 'L', 'B', 'E', 'P', 'X', 0,
  /* 14401 */ 'S', 'T', 'B', 'E', 'P', 'X', 0,
  /* 14408 */ 'L', 'F', 'D', 'E', 'P', 'X', 0,
  /* 14415 */ 'S', 'T', 'F', 'D', 'E', 'P', 'X', 0,
  /* 14423 */ 'L', 'H', 'E', 'P', 'X', 0,
  /* 14429 */ 'S', 'T', 'H', 'E', 'P', 'X', 0,
  /* 14436 */ 'L', 'W', 'E', 'P', 'X', 0,
  /* 14442 */ 'S', 'T', 'W', 'E', 'P', 'X', 0,
  /* 14449 */ 'V', 'U', 'P', 'K', 'H', 'P', 'X', 0,
  /* 14457 */ 'V', 'P', 'K', 'P', 'X', 0,
  /* 14463 */ 'V', 'U', 'P', 'K', 'L', 'P', 'X', 0,
  /* 14471 */ 'L', 'X', 'S', 'S', 'P', 'X', 0,
  /* 14478 */ 'S', 'T', 'X', 'S', 'S', 'P', 'X', 0,
  /* 14486 */ 'L', 'B', 'A', 'R', 'X', 0,
  /* 14492 */ 'L', 'D', 'A', 'R', 'X', 0,
  /* 14498 */ 'L', 'H', 'A', 'R', 'X', 0,
  /* 14504 */ 'L', 'W', 'A', 'R', 'X', 0,
  /* 14510 */ 'L', 'D', 'B', 'R', 'X', 0,
  /* 14516 */ 'S', 'T', 'D', 'B', 'R', 'X', 0,
  /* 14523 */ 'L', 'H', 'B', 'R', 'X', 0,
  /* 14529 */ 'S', 'T', 'H', 'B', 'R', 'X', 0,
  /* 14536 */ 'V', 'E', 'X', 'T', 'U', 'B', 'R', 'X', 0,
  /* 14545 */ 'L', 'W', 'B', 'R', 'X', 0,
  /* 14551 */ 'S', 'T', 'W', 'B', 'R', 'X', 0,
  /* 14558 */ 'V', 'E', 'X', 'T', 'U', 'H', 'R', 'X', 0,
  /* 14567 */ 'V', 'E', 'X', 'T', 'U', 'W', 'R', 'X', 0,
  /* 14576 */ 'M', 'C', 'R', 'X', 'R', 'X', 0,
  /* 14583 */ 'T', 'L', 'B', 'S', 'X', 0,
  /* 14589 */ 'Q', 'V', 'L', 'F', 'C', 'S', 'X', 0,
  /* 14597 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'X', 0,
  /* 14606 */ 'L', 'X', 'V', 'D', 'S', 'X', 0,
  /* 14613 */ 'V', 'C', 'F', 'S', 'X', 0,
  /* 14619 */ 'Q', 'V', 'L', 'F', 'S', 'X', 0,
  /* 14626 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'X', 0,
  /* 14634 */ 'Q', 'V', 'L', 'P', 'C', 'L', 'S', 'X', 0,
  /* 14643 */ 'E', 'V', 'L', 'W', 'H', 'O', 'S', 'X', 0,
  /* 14652 */ 'Q', 'V', 'L', 'P', 'C', 'R', 'S', 'X', 0,
  /* 14661 */ 'L', 'X', 'V', 'W', 'S', 'X', 0,
  /* 14668 */ 'E', 'V', 'L', 'H', 'H', 'E', 'S', 'P', 'L', 'A', 'T', 'X', 0,
  /* 14681 */ 'E', 'V', 'L', 'W', 'H', 'S', 'P', 'L', 'A', 'T', 'X', 0,
  /* 14693 */ 'E', 'V', 'L', 'H', 'H', 'O', 'S', 'S', 'P', 'L', 'A', 'T', 'X', 0,
  /* 14707 */ 'E', 'V', 'L', 'H', 'H', 'O', 'U', 'S', 'P', 'L', 'A', 'T', 'X', 0,
  /* 14721 */ 'E', 'V', 'L', 'W', 'W', 'S', 'P', 'L', 'A', 'T', 'X', 0,
  /* 14733 */ 'S', 'P', 'I', 'L', 'L', 'T', 'O', 'V', 'S', 'R', '_', 'S', 'T', 'X', 0,
  /* 14748 */ 'L', 'H', 'A', 'U', 'X', 0,
  /* 14754 */ 'L', 'W', 'A', 'U', 'X', 0,
  /* 14760 */ 'S', 'T', 'B', 'U', 'X', 0,
  /* 14766 */ 'Q', 'V', 'L', 'F', 'C', 'D', 'U', 'X', 0,
  /* 14775 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'D', 'U', 'X', 0,
  /* 14785 */ 'Q', 'V', 'L', 'F', 'D', 'U', 'X', 0,
  /* 14793 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'U', 'X', 0,
  /* 14802 */ 'L', 'D', 'U', 'X', 0,
  /* 14807 */ 'S', 'T', 'D', 'U', 'X', 0,
  /* 14813 */ 'V', 'C', 'F', 'U', 'X', 0,
  /* 14819 */ 'S', 'T', 'H', 'U', 'X', 0,
  /* 14825 */ 'E', 'V', 'L', 'W', 'H', 'O', 'U', 'X', 0,
  /* 14834 */ 'Q', 'V', 'L', 'F', 'C', 'S', 'U', 'X', 0,
  /* 14843 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'U', 'X', 0,
  /* 14853 */ 'Q', 'V', 'L', 'F', 'S', 'U', 'X', 0,
  /* 14861 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'U', 'X', 0,
  /* 14870 */ 'S', 'T', 'W', 'U', 'X', 0,
  /* 14876 */ 'L', 'B', 'Z', 'U', 'X', 0,
  /* 14882 */ 'L', 'H', 'Z', 'U', 'X', 0,
  /* 14888 */ 'L', 'W', 'Z', 'U', 'X', 0,
  /* 14894 */ 'L', 'V', 'X', 0,
  /* 14898 */ 'S', 'T', 'V', 'X', 0,
  /* 14903 */ 'L', 'X', 'V', 'X', 0,
  /* 14908 */ 'S', 'T', 'X', 'V', 'X', 0,
  /* 14914 */ 'E', 'V', 'L', 'D', 'W', 'X', 0,
  /* 14921 */ 'E', 'V', 'S', 'T', 'D', 'W', 'X', 0,
  /* 14929 */ 'L', 'V', 'E', 'W', 'X', 0,
  /* 14935 */ 'S', 'T', 'V', 'E', 'W', 'X', 0,
  /* 14942 */ 'Q', 'V', 'S', 'T', 'F', 'I', 'W', 'X', 0,
  /* 14951 */ 'S', 'T', 'X', 'S', 'I', 'W', 'X', 0,
  /* 14959 */ 'S', 'T', 'I', 'W', 'X', 0,
  /* 14965 */ 'S', 'P', 'E', 'S', 'T', 'W', 'X', 0,
  /* 14973 */ 'L', 'X', 'S', 'I', 'B', 'Z', 'X', 0,
  /* 14981 */ 'L', 'B', 'Z', 'X', 0,
  /* 14986 */ 'L', 'X', 'S', 'I', 'H', 'Z', 'X', 0,
  /* 14994 */ 'L', 'H', 'Z', 'X', 0,
  /* 14999 */ 'Q', 'V', 'L', 'F', 'I', 'W', 'Z', 'X', 0,
  /* 15008 */ 'L', 'I', 'W', 'Z', 'X', 0,
  /* 15014 */ 'L', 'X', 'S', 'I', 'W', 'Z', 'X', 0,
  /* 15022 */ 'S', 'P', 'E', 'L', 'W', 'Z', 'X', 0,
  /* 15030 */ 'C', 'P', '_', 'C', 'O', 'P', 'Y', 0,
  /* 15038 */ 'D', 'C', 'B', 'Z', 0,
  /* 15043 */ 'L', 'B', 'Z', 0,
  /* 15047 */ 'B', 'D', 'Z', 0,
  /* 15051 */ 'E', 'F', 'D', 'C', 'T', 'S', 'I', 'D', 'Z', 0,
  /* 15061 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'D', 'Z', 0,
  /* 15070 */ 'E', 'F', 'D', 'C', 'T', 'U', 'I', 'D', 'Z', 0,
  /* 15080 */ 'X', 'S', 'C', 'V', 'Q', 'P', 'S', 'D', 'Z', 0,
  /* 15090 */ 'X', 'S', 'C', 'V', 'Q', 'P', 'U', 'D', 'Z', 0,
  /* 15100 */ 'L', 'H', 'Z', 0,
  /* 15104 */ 'V', 'R', 'F', 'I', 'Z', 0,
  /* 15110 */ 'X', 'S', 'R', 'D', 'P', 'I', 'Z', 0,
  /* 15118 */ 'X', 'V', 'R', 'D', 'P', 'I', 'Z', 0,
  /* 15126 */ 'X', 'V', 'R', 'S', 'P', 'I', 'Z', 0,
  /* 15134 */ 'Q', 'V', 'F', 'R', 'I', 'Z', 0,
  /* 15141 */ 'E', 'F', 'D', 'C', 'T', 'S', 'I', 'Z', 0,
  /* 15150 */ 'E', 'F', 'S', 'C', 'T', 'S', 'I', 'Z', 0,
  /* 15159 */ 'E', 'V', 'F', 'S', 'C', 'T', 'S', 'I', 'Z', 0,
  /* 15169 */ 'E', 'F', 'D', 'C', 'T', 'U', 'I', 'Z', 0,
  /* 15178 */ 'E', 'F', 'S', 'C', 'T', 'U', 'I', 'Z', 0,
  /* 15187 */ 'E', 'V', 'F', 'S', 'C', 'T', 'U', 'I', 'Z', 0,
  /* 15197 */ 'G', '_', 'C', 'T', 'L', 'Z', 0,
  /* 15204 */ 'B', 'D', 'N', 'Z', 0,
  /* 15209 */ 'G', '_', 'C', 'T', 'T', 'Z', 0,
  /* 15216 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'D', 'U', 'Z', 0,
  /* 15226 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'W', 'U', 'Z', 0,
  /* 15236 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'W', 'Z', 0,
  /* 15245 */ 'S', 'P', 'E', 'L', 'W', 'Z', 0,
  /* 15252 */ 'M', 'F', 'V', 'S', 'R', 'W', 'Z', 0,
  /* 15260 */ 'M', 'T', 'V', 'S', 'R', 'W', 'Z', 0,
  /* 15268 */ 'X', 'S', 'C', 'V', 'Q', 'P', 'S', 'W', 'Z', 0,
  /* 15278 */ 'X', 'S', 'C', 'V', 'Q', 'P', 'U', 'W', 'Z', 0,
  /* 15288 */ 'A', 'D', 'D', '8', 'T', 'L', 'S', '_', 0,
  /* 15297 */ 'S', 'T', 'B', 'X', 'T', 'L', 'S', '_', 0,
  /* 15306 */ 'L', 'D', 'X', 'T', 'L', 'S', '_', 0,
  /* 15314 */ 'S', 'T', 'D', 'X', 'T', 'L', 'S', '_', 0,
  /* 15323 */ 'S', 'T', 'H', 'X', 'T', 'L', 'S', '_', 0,
  /* 15332 */ 'S', 'T', 'W', 'X', 'T', 'L', 'S', '_', 0,
  /* 15341 */ 'L', 'B', 'Z', 'X', 'T', 'L', 'S', '_', 0,
  /* 15350 */ 'L', 'H', 'Z', 'X', 'T', 'L', 'S', '_', 0,
  /* 15359 */ 'L', 'W', 'Z', 'X', 'T', 'L', 'S', '_', 0,
  /* 15368 */ 'B', 'L', '8', '_', 'T', 'L', 'S', '_', 0,
  /* 15377 */ 'Q', 'V', 'F', 'C', 'F', 'I', 'D', 'b', 0,
  /* 15386 */ 'Q', 'V', 'F', 'C', 'T', 'I', 'D', 'b', 0,
  /* 15395 */ 'M', 'T', 'F', 'S', 'F', 'b', 0,
  /* 15402 */ 'Q', 'V', 'A', 'L', 'I', 'G', 'N', 'I', 'b', 0,
  /* 15412 */ 'Q', 'V', 'E', 'S', 'P', 'L', 'A', 'T', 'I', 'b', 0,
  /* 15423 */ 'Q', 'V', 'F', 'L', 'O', 'G', 'I', 'C', 'A', 'L', 'b', 0,
  /* 15435 */ 'Q', 'V', 'F', 'S', 'E', 'L', 'b', 0,
  /* 15443 */ 'Q', 'V', 'F', 'T', 'S', 'T', 'N', 'A', 'N', 'b', 0,
  /* 15454 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'E', 'Q', 'b', 0,
  /* 15464 */ 'Q', 'V', 'F', 'M', 'R', 'b', 0,
  /* 15471 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'G', 'T', 'b', 0,
  /* 15481 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'L', 'T', 'b', 0,
  /* 15491 */ 'Q', 'V', 'L', 'F', 'D', 'X', 'b', 0,
  /* 15499 */ 'Q', 'V', 'S', 'T', 'F', 'D', 'X', 'b', 0,
  /* 15508 */ 'Q', 'V', 'L', 'F', 'S', 'X', 'b', 0,
  /* 15516 */ 'Q', 'V', 'F', 'S', 'E', 'L', 'b', 'b', 0,
  /* 15525 */ 'L', 'D', 't', 'o', 'c', 0,
  /* 15531 */ 'L', 'W', 'Z', 't', 'o', 'c', 0,
  /* 15538 */ 'B', 'C', 'T', 'R', 'L', '8', '_', 'L', 'D', 'i', 'n', 't', 'o', '_', 't', 'o', 'c', 0,
  /* 15556 */ 'X', 'X', 'L', 'O', 'R', 'f', 0,
  /* 15563 */ 'S', 'E', 'T', 'R', 'N', 'D', 'i', 0,
  /* 15571 */ 'T', 'C', 'R', 'E', 'T', 'U', 'R', 'N', 'a', 'i', 0,
  /* 15582 */ 'T', 'C', 'R', 'E', 'T', 'U', 'R', 'N', 'd', 'i', 0,
  /* 15593 */ 'T', 'C', 'R', 'E', 'T', 'U', 'R', 'N', 'r', 'i', 0,
  /* 15604 */ 'B', 'D', 'Z', 'L', 'A', 'm', 0,
  /* 15611 */ 'B', 'D', 'N', 'Z', 'L', 'A', 'm', 0,
  /* 15619 */ 'B', 'D', 'Z', 'A', 'm', 0,
  /* 15625 */ 'B', 'D', 'N', 'Z', 'A', 'm', 0,
  /* 15632 */ 'B', 'D', 'Z', 'L', 'R', 'L', 'm', 0,
  /* 15640 */ 'B', 'D', 'N', 'Z', 'L', 'R', 'L', 'm', 0,
  /* 15649 */ 'B', 'D', 'Z', 'L', 'm', 0,
  /* 15655 */ 'B', 'D', 'N', 'Z', 'L', 'm', 0,
  /* 15662 */ 'B', 'D', 'Z', 'L', 'R', 'm', 0,
  /* 15669 */ 'B', 'D', 'N', 'Z', 'L', 'R', 'm', 0,
  /* 15677 */ 'B', 'D', 'Z', 'm', 0,
  /* 15682 */ 'B', 'D', 'N', 'Z', 'm', 0,
  /* 15688 */ 'R', 'L', 'W', 'I', 'M', 'I', 'b', 'm', 0,
  /* 15697 */ 'R', 'L', 'W', 'I', 'N', 'M', 'b', 'm', 0,
  /* 15706 */ 'R', 'L', 'W', 'N', 'M', 'b', 'm', 0,
  /* 15714 */ 'R', 'L', 'W', 'I', 'M', 'I', 'o', 'b', 'm', 0,
  /* 15724 */ 'R', 'L', 'W', 'I', 'N', 'M', 'o', 'b', 'm', 0,
  /* 15734 */ 'R', 'L', 'W', 'N', 'M', 'o', 'b', 'm', 0,
  /* 15743 */ 'B', 'C', 'C', 'T', 'R', 'L', '8', 'n', 0,
  /* 15752 */ 'B', 'C', 'C', 'T', 'R', '8', 'n', 0,
  /* 15760 */ 'B', 'C', 'n', 0,
  /* 15764 */ 'B', 'C', 'L', 'n', 0,
  /* 15769 */ 'B', 'C', 'L', 'R', 'L', 'n', 0,
  /* 15776 */ 'B', 'C', 'C', 'T', 'R', 'L', 'n', 0,
  /* 15784 */ 'B', 'C', 'L', 'R', 'n', 0,
  /* 15790 */ 'B', 'C', 'C', 'T', 'R', 'n', 0,
  /* 15797 */ 'R', 'L', 'D', 'I', 'C', 'L', '_', '3', '2', 'o', 0,
  /* 15808 */ 'E', 'X', 'T', 'S', 'W', 'S', 'L', 'I', '_', '3', '2', '_', '6', '4', 'o', 0,
  /* 15824 */ 'E', 'X', 'T', 'S', 'W', '_', '3', '2', '_', '6', '4', 'o', 0,
  /* 15837 */ 'A', 'D', 'D', '4', 'o', 0,
  /* 15843 */ 'E', 'X', 'T', 'S', 'B', '8', 'o', 0,
  /* 15851 */ 'A', 'D', 'D', 'C', '8', 'o', 0,
  /* 15858 */ 'A', 'N', 'D', 'C', '8', 'o', 0,
  /* 15865 */ 'S', 'U', 'B', 'F', 'C', '8', 'o', 0,
  /* 15873 */ 'O', 'R', 'C', '8', 'o', 0,
  /* 15879 */ 'A', 'D', 'D', '8', 'o', 0,
  /* 15885 */ 'N', 'A', 'N', 'D', '8', 'o', 0,
  /* 15892 */ 'A', 'D', 'D', 'E', '8', 'o', 0,
  /* 15899 */ 'S', 'U', 'B', 'F', 'E', '8', 'o', 0,
  /* 15907 */ 'A', 'D', 'D', 'M', 'E', '8', 'o', 0,
  /* 15915 */ 'S', 'U', 'B', 'F', 'M', 'E', '8', 'o', 0,
  /* 15924 */ 'C', 'P', '_', 'P', 'A', 'S', 'T', 'E', '8', 'o', 0,
  /* 15935 */ 'A', 'D', 'D', 'Z', 'E', '8', 'o', 0,
  /* 15943 */ 'S', 'U', 'B', 'F', 'Z', 'E', '8', 'o', 0,
  /* 15952 */ 'S', 'U', 'B', 'F', '8', 'o', 0,
  /* 15959 */ 'N', 'E', 'G', '8', 'o', 0,
  /* 15965 */ 'E', 'X', 'T', 'S', 'H', '8', 'o', 0,
  /* 15973 */ 'R', 'L', 'W', 'I', 'M', 'I', '8', 'o', 0,
  /* 15982 */ 'R', 'L', 'W', 'I', 'N', 'M', '8', 'o', 0,
  /* 15991 */ 'R', 'L', 'W', 'N', 'M', '8', 'o', 0,
  /* 15999 */ 'N', 'O', 'R', '8', 'o', 0,
  /* 16005 */ 'X', 'O', 'R', '8', 'o', 0,
  /* 16011 */ 'E', 'Q', 'V', '8', 'o', 0,
  /* 16017 */ 'S', 'L', 'W', '8', 'o', 0,
  /* 16023 */ 'S', 'R', 'W', '8', 'o', 0,
  /* 16029 */ 'C', 'N', 'T', 'L', 'Z', 'W', '8', 'o', 0,
  /* 16038 */ 'C', 'N', 'T', 'T', 'Z', 'W', '8', 'o', 0,
  /* 16047 */ 'V', 'C', 'M', 'P', 'N', 'E', 'B', 'o', 0,
  /* 16056 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'B', 'o', 0,
  /* 16066 */ 'E', 'X', 'T', 'S', 'B', 'o', 0,
  /* 16073 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'B', 'o', 0,
  /* 16083 */ 'F', 'S', 'U', 'B', 'o', 0,
  /* 16089 */ 'F', 'M', 'S', 'U', 'B', 'o', 0,
  /* 16096 */ 'F', 'N', 'M', 'S', 'U', 'B', 'o', 0,
  /* 16104 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'B', 'o', 0,
  /* 16114 */ 'V', 'C', 'M', 'P', 'N', 'E', 'Z', 'B', 'o', 0,
  /* 16124 */ 'A', 'D', 'D', 'C', 'o', 0,
  /* 16130 */ 'A', 'N', 'D', 'C', 'o', 0,
  /* 16136 */ 'S', 'U', 'B', 'F', 'C', 'o', 0,
  /* 16143 */ 'S', 'U', 'B', 'I', 'C', 'o', 0,
  /* 16150 */ 'A', 'D', 'D', 'I', 'C', 'o', 0,
  /* 16157 */ 'R', 'L', 'D', 'I', 'C', 'o', 0,
  /* 16164 */ 'B', 'C', 'D', 'T', 'R', 'U', 'N', 'C', 'o', 0,
  /* 16174 */ 'B', 'C', 'D', 'U', 'T', 'R', 'U', 'N', 'C', 'o', 0,
  /* 16185 */ 'O', 'R', 'C', 'o', 0,
  /* 16190 */ 'S', 'R', 'A', 'D', 'o', 0,
  /* 16196 */ 'F', 'A', 'D', 'D', 'o', 0,
  /* 16202 */ 'F', 'M', 'A', 'D', 'D', 'o', 0,
  /* 16209 */ 'F', 'N', 'M', 'A', 'D', 'D', 'o', 0,
  /* 16217 */ 'F', 'N', 'E', 'G', 'D', 'o', 0,
  /* 16224 */ 'M', 'U', 'L', 'H', 'D', 'o', 0,
  /* 16231 */ 'F', 'C', 'F', 'I', 'D', 'o', 0,
  /* 16238 */ 'F', 'C', 'T', 'I', 'D', 'o', 0,
  /* 16245 */ 'F', 'S', 'E', 'L', 'D', 'o', 0,
  /* 16252 */ 'M', 'U', 'L', 'L', 'D', 'o', 0,
  /* 16259 */ 'S', 'L', 'D', 'o', 0,
  /* 16264 */ 'F', 'R', 'I', 'M', 'D', 'o', 0,
  /* 16271 */ 'N', 'A', 'N', 'D', 'o', 0,
  /* 16277 */ 'F', 'C', 'P', 'S', 'G', 'N', 'D', 'o', 0,
  /* 16286 */ 'F', 'R', 'I', 'N', 'D', 'o', 0,
  /* 16293 */ 'F', 'R', 'I', 'P', 'D', 'o', 0,
  /* 16300 */ 'S', 'R', 'D', 'o', 0,
  /* 16305 */ 'F', 'A', 'B', 'S', 'D', 'o', 0,
  /* 16312 */ 'F', 'N', 'A', 'B', 'S', 'D', 'o', 0,
  /* 16320 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'D', 'o', 0,
  /* 16330 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'D', 'o', 0,
  /* 16340 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'D', 'o', 0,
  /* 16350 */ 'D', 'I', 'V', 'D', 'o', 0,
  /* 16356 */ 'F', 'R', 'I', 'Z', 'D', 'o', 0,
  /* 16363 */ 'C', 'N', 'T', 'L', 'Z', 'D', 'o', 0,
  /* 16371 */ 'C', 'N', 'T', 'T', 'Z', 'D', 'o', 0,
  /* 16379 */ 'A', 'D', 'D', 'E', 'o', 0,
  /* 16385 */ 'D', 'I', 'V', 'D', 'E', 'o', 0,
  /* 16392 */ 'S', 'L', 'B', 'F', 'E', 'E', 'o', 0,
  /* 16400 */ 'S', 'U', 'B', 'F', 'E', 'o', 0,
  /* 16407 */ 'A', 'D', 'D', 'M', 'E', 'o', 0,
  /* 16414 */ 'S', 'U', 'B', 'F', 'M', 'E', 'o', 0,
  /* 16422 */ 'F', 'R', 'E', 'o', 0,
  /* 16427 */ 'F', 'R', 'S', 'Q', 'R', 'T', 'E', 'o', 0,
  /* 16436 */ 'C', 'P', '_', 'P', 'A', 'S', 'T', 'E', 'o', 0,
  /* 16446 */ 'D', 'I', 'V', 'W', 'E', 'o', 0,
  /* 16453 */ 'A', 'D', 'D', 'Z', 'E', 'o', 0,
  /* 16460 */ 'S', 'U', 'B', 'F', 'Z', 'E', 'o', 0,
  /* 16468 */ 'S', 'U', 'B', 'F', 'o', 0,
  /* 16474 */ 'M', 'T', 'F', 'S', 'F', 'o', 0,
  /* 16481 */ 'N', 'E', 'G', 'o', 0,
  /* 16486 */ 'V', 'C', 'M', 'P', 'N', 'E', 'H', 'o', 0,
  /* 16495 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'H', 'o', 0,
  /* 16505 */ 'E', 'X', 'T', 'S', 'H', 'o', 0,
  /* 16512 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'H', 'o', 0,
  /* 16522 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'H', 'o', 0,
  /* 16532 */ 'V', 'C', 'M', 'P', 'N', 'E', 'Z', 'H', 'o', 0,
  /* 16542 */ 'S', 'R', 'A', 'D', 'I', 'o', 0,
  /* 16549 */ 'C', 'L', 'R', 'L', 'S', 'L', 'D', 'I', 'o', 0,
  /* 16559 */ 'E', 'X', 'T', 'L', 'D', 'I', 'o', 0,
  /* 16567 */ 'A', 'N', 'D', 'I', 'o', 0,
  /* 16573 */ 'C', 'L', 'R', 'R', 'D', 'I', 'o', 0,
  /* 16581 */ 'I', 'N', 'S', 'R', 'D', 'I', 'o', 0,
  /* 16589 */ 'R', 'O', 'T', 'R', 'D', 'I', 'o', 0,
  /* 16597 */ 'E', 'X', 'T', 'R', 'D', 'I', 'o', 0,
  /* 16605 */ 'M', 'T', 'F', 'S', 'F', 'I', 'o', 0,
  /* 16613 */ 'E', 'X', 'T', 'S', 'W', 'S', 'L', 'I', 'o', 0,
  /* 16623 */ 'R', 'L', 'D', 'I', 'M', 'I', 'o', 0,
  /* 16631 */ 'R', 'L', 'W', 'I', 'M', 'I', 'o', 0,
  /* 16639 */ 'S', 'R', 'A', 'W', 'I', 'o', 0,
  /* 16646 */ 'C', 'L', 'R', 'L', 'S', 'L', 'W', 'I', 'o', 0,
  /* 16656 */ 'I', 'N', 'S', 'L', 'W', 'I', 'o', 0,
  /* 16664 */ 'E', 'X', 'T', 'L', 'W', 'I', 'o', 0,
  /* 16672 */ 'C', 'L', 'R', 'R', 'W', 'I', 'o', 0,
  /* 16680 */ 'I', 'N', 'S', 'R', 'W', 'I', 'o', 0,
  /* 16688 */ 'R', 'O', 'T', 'R', 'W', 'I', 'o', 0,
  /* 16696 */ 'E', 'X', 'T', 'R', 'W', 'I', 'o', 0,
  /* 16704 */ 'R', 'L', 'D', 'C', 'L', 'o', 0,
  /* 16711 */ 'R', 'L', 'D', 'I', 'C', 'L', 'o', 0,
  /* 16719 */ 'F', 'M', 'U', 'L', 'o', 0,
  /* 16725 */ 'R', 'L', 'W', 'I', 'N', 'M', 'o', 0,
  /* 16733 */ 'R', 'L', 'W', 'N', 'M', 'o', 0,
  /* 16740 */ 'B', 'C', 'D', 'C', 'F', 'N', 'o', 0,
  /* 16748 */ 'B', 'C', 'D', 'C', 'P', 'S', 'G', 'N', 'o', 0,
  /* 16758 */ 'B', 'C', 'D', 'S', 'E', 'T', 'S', 'G', 'N', 'o', 0,
  /* 16769 */ 'B', 'C', 'D', 'C', 'T', 'N', 'o', 0,
  /* 16777 */ 'X', 'V', 'C', 'M', 'P', 'G', 'E', 'D', 'P', 'o', 0,
  /* 16788 */ 'X', 'V', 'C', 'M', 'P', 'E', 'Q', 'D', 'P', 'o', 0,
  /* 16799 */ 'X', 'V', 'C', 'M', 'P', 'G', 'T', 'D', 'P', 'o', 0,
  /* 16810 */ 'V', 'C', 'M', 'P', 'B', 'F', 'P', 'o', 0,
  /* 16819 */ 'V', 'C', 'M', 'P', 'G', 'E', 'F', 'P', 'o', 0,
  /* 16829 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'F', 'P', 'o', 0,
  /* 16839 */ 'V', 'C', 'M', 'P', 'G', 'T', 'F', 'P', 'o', 0,
  /* 16849 */ 'X', 'V', 'C', 'M', 'P', 'G', 'E', 'S', 'P', 'o', 0,
  /* 16860 */ 'X', 'V', 'C', 'M', 'P', 'E', 'Q', 'S', 'P', 'o', 0,
  /* 16871 */ 'F', 'R', 'S', 'P', 'o', 0,
  /* 16877 */ 'X', 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'P', 'o', 0,
  /* 16888 */ 'B', 'C', 'D', 'C', 'F', 'S', 'Q', 'o', 0,
  /* 16897 */ 'B', 'C', 'D', 'C', 'T', 'S', 'Q', 'o', 0,
  /* 16906 */ 'R', 'L', 'D', 'C', 'R', 'o', 0,
  /* 16913 */ 'R', 'L', 'D', 'I', 'C', 'R', 'o', 0,
  /* 16921 */ 'F', 'M', 'R', 'o', 0,
  /* 16926 */ 'N', 'O', 'R', 'o', 0,
  /* 16931 */ 'X', 'O', 'R', 'o', 0,
  /* 16936 */ 'B', 'C', 'D', 'S', 'R', 'o', 0,
  /* 16943 */ 'F', 'S', 'U', 'B', 'S', 'o', 0,
  /* 16950 */ 'F', 'M', 'S', 'U', 'B', 'S', 'o', 0,
  /* 16958 */ 'F', 'N', 'M', 'S', 'U', 'B', 'S', 'o', 0,
  /* 16967 */ 'B', 'C', 'D', 'S', 'o', 0,
  /* 16973 */ 'F', 'A', 'D', 'D', 'S', 'o', 0,
  /* 16980 */ 'F', 'M', 'A', 'D', 'D', 'S', 'o', 0,
  /* 16988 */ 'F', 'N', 'M', 'A', 'D', 'D', 'S', 'o', 0,
  /* 16997 */ 'F', 'C', 'F', 'I', 'D', 'S', 'o', 0,
  /* 17005 */ 'F', 'R', 'E', 'S', 'o', 0,
  /* 17011 */ 'F', 'R', 'S', 'Q', 'R', 'T', 'E', 'S', 'o', 0,
  /* 17021 */ 'M', 'F', 'F', 'S', 'o', 0,
  /* 17027 */ 'F', 'N', 'E', 'G', 'S', 'o', 0,
  /* 17034 */ 'A', 'N', 'D', 'I', 'S', 'o', 0,
  /* 17041 */ 'F', 'S', 'E', 'L', 'S', 'o', 0,
  /* 17048 */ 'F', 'M', 'U', 'L', 'S', 'o', 0,
  /* 17055 */ 'F', 'R', 'I', 'M', 'S', 'o', 0,
  /* 17062 */ 'F', 'C', 'P', 'S', 'G', 'N', 'S', 'o', 0,
  /* 17071 */ 'F', 'R', 'I', 'N', 'S', 'o', 0,
  /* 17078 */ 'F', 'R', 'I', 'P', 'S', 'o', 0,
  /* 17085 */ 'F', 'A', 'B', 'S', 'S', 'o', 0,
  /* 17092 */ 'F', 'N', 'A', 'B', 'S', 'S', 'o', 0,
  /* 17100 */ 'F', 'S', 'Q', 'R', 'T', 'S', 'o', 0,
  /* 17108 */ 'B', 'C', 'D', 'U', 'S', 'o', 0,
  /* 17115 */ 'F', 'C', 'F', 'I', 'D', 'U', 'S', 'o', 0,
  /* 17124 */ 'F', 'D', 'I', 'V', 'S', 'o', 0,
  /* 17131 */ 'F', 'R', 'I', 'Z', 'S', 'o', 0,
  /* 17138 */ 'F', 'S', 'Q', 'R', 'T', 'o', 0,
  /* 17145 */ 'M', 'U', 'L', 'H', 'D', 'U', 'o', 0,
  /* 17153 */ 'F', 'C', 'F', 'I', 'D', 'U', 'o', 0,
  /* 17161 */ 'F', 'C', 'T', 'I', 'D', 'U', 'o', 0,
  /* 17169 */ 'D', 'I', 'V', 'D', 'U', 'o', 0,
  /* 17176 */ 'D', 'I', 'V', 'D', 'E', 'U', 'o', 0,
  /* 17184 */ 'D', 'I', 'V', 'W', 'E', 'U', 'o', 0,
  /* 17192 */ 'M', 'U', 'L', 'H', 'W', 'U', 'o', 0,
  /* 17200 */ 'F', 'C', 'T', 'I', 'W', 'U', 'o', 0,
  /* 17208 */ 'D', 'I', 'V', 'W', 'U', 'o', 0,
  /* 17215 */ 'F', 'D', 'I', 'V', 'o', 0,
  /* 17221 */ 'E', 'Q', 'V', 'o', 0,
  /* 17226 */ 'S', 'R', 'A', 'W', 'o', 0,
  /* 17232 */ 'V', 'C', 'M', 'P', 'N', 'E', 'W', 'o', 0,
  /* 17241 */ 'M', 'U', 'L', 'H', 'W', 'o', 0,
  /* 17248 */ 'F', 'C', 'T', 'I', 'W', 'o', 0,
  /* 17255 */ 'M', 'U', 'L', 'L', 'W', 'o', 0,
  /* 17262 */ 'S', 'L', 'W', 'o', 0,
  /* 17267 */ 'S', 'R', 'W', 'o', 0,
  /* 17272 */ 'V', 'C', 'M', 'P', 'G', 'T', 'S', 'W', 'o', 0,
  /* 17282 */ 'E', 'X', 'T', 'S', 'W', 'o', 0,
  /* 17289 */ 'V', 'C', 'M', 'P', 'E', 'Q', 'U', 'W', 'o', 0,
  /* 17299 */ 'V', 'C', 'M', 'P', 'G', 'T', 'U', 'W', 'o', 0,
  /* 17309 */ 'D', 'I', 'V', 'W', 'o', 0,
  /* 17315 */ 'V', 'C', 'M', 'P', 'N', 'E', 'Z', 'W', 'o', 0,
  /* 17325 */ 'C', 'N', 'T', 'L', 'Z', 'W', 'o', 0,
  /* 17333 */ 'C', 'N', 'T', 'T', 'Z', 'W', 'o', 0,
  /* 17341 */ 'F', 'C', 'T', 'I', 'D', 'Z', 'o', 0,
  /* 17349 */ 'B', 'C', 'D', 'C', 'F', 'Z', 'o', 0,
  /* 17357 */ 'B', 'C', 'D', 'C', 'T', 'Z', 'o', 0,
  /* 17365 */ 'F', 'C', 'T', 'I', 'D', 'U', 'Z', 'o', 0,
  /* 17374 */ 'F', 'C', 'T', 'I', 'W', 'U', 'Z', 'o', 0,
  /* 17383 */ 'F', 'C', 'T', 'I', 'W', 'Z', 'o', 0,
  /* 17391 */ 'B', 'D', 'Z', 'L', 'A', 'p', 0,
  /* 17398 */ 'B', 'D', 'N', 'Z', 'L', 'A', 'p', 0,
  /* 17406 */ 'B', 'D', 'Z', 'A', 'p', 0,
  /* 17412 */ 'B', 'D', 'N', 'Z', 'A', 'p', 0,
  /* 17419 */ 'B', 'D', 'Z', 'L', 'R', 'L', 'p', 0,
  /* 17427 */ 'B', 'D', 'N', 'Z', 'L', 'R', 'L', 'p', 0,
  /* 17436 */ 'B', 'D', 'Z', 'L', 'p', 0,
  /* 17442 */ 'B', 'D', 'N', 'Z', 'L', 'p', 0,
  /* 17449 */ 'B', 'D', 'Z', 'L', 'R', 'p', 0,
  /* 17456 */ 'B', 'D', 'N', 'Z', 'L', 'R', 'p', 0,
  /* 17464 */ 'B', 'D', 'Z', 'p', 0,
  /* 17469 */ 'B', 'D', 'N', 'Z', 'p', 0,
  /* 17475 */ 'M', 'T', 'C', 'T', 'R', '8', 'l', 'o', 'o', 'p', 0,
  /* 17486 */ 'M', 'T', 'C', 'T', 'R', 'l', 'o', 'o', 'p', 0,
  /* 17496 */ 'E', 'H', '_', 'S', 'j', 'L', 'j', '_', 'S', 'e', 't', 'u', 'p', 0,
  /* 17510 */ 'V', 'S', 'P', 'L', 'T', 'B', 's', 0,
  /* 17518 */ 'V', 'E', 'X', 'T', 'S', 'B', '2', 'D', 's', 0,
  /* 17528 */ 'V', 'E', 'X', 'T', 'S', 'H', '2', 'D', 's', 0,
  /* 17538 */ 'V', 'E', 'X', 'T', 'S', 'W', '2', 'D', 's', 0,
  /* 17548 */ 'Q', 'V', 'F', 'N', 'E', 'G', 's', 0,
  /* 17556 */ 'V', 'S', 'P', 'L', 'T', 'H', 's', 0,
  /* 17564 */ 'X', 'X', 'P', 'E', 'R', 'M', 'D', 'I', 's', 0,
  /* 17574 */ 'Q', 'V', 'A', 'L', 'I', 'G', 'N', 'I', 's', 0,
  /* 17584 */ 'Q', 'V', 'E', 'S', 'P', 'L', 'A', 'T', 'I', 's', 0,
  /* 17595 */ 'X', 'X', 'S', 'L', 'D', 'W', 'I', 's', 0,
  /* 17604 */ 'Q', 'V', 'F', 'L', 'O', 'G', 'I', 'C', 'A', 'L', 's', 0,
  /* 17616 */ 'Q', 'V', 'F', 'R', 'I', 'M', 's', 0,
  /* 17624 */ 'Q', 'V', 'F', 'P', 'E', 'R', 'M', 's', 0,
  /* 17633 */ 'Q', 'V', 'F', 'C', 'P', 'S', 'G', 'N', 's', 0,
  /* 17643 */ 'Q', 'V', 'F', 'R', 'I', 'N', 's', 0,
  /* 17651 */ 'Q', 'V', 'F', 'R', 'I', 'P', 's', 0,
  /* 17659 */ 'Q', 'V', 'F', 'R', 'S', 'P', 's', 0,
  /* 17667 */ 'Q', 'V', 'F', 'M', 'R', 's', 0,
  /* 17674 */ 'Q', 'V', 'F', 'A', 'B', 'S', 's', 0,
  /* 17682 */ 'Q', 'V', 'F', 'N', 'A', 'B', 'S', 's', 0,
  /* 17691 */ 'Q', 'V', 'F', 'S', 'U', 'B', 'S', 's', 0,
  /* 17700 */ 'Q', 'V', 'F', 'M', 'S', 'U', 'B', 'S', 's', 0,
  /* 17710 */ 'Q', 'V', 'F', 'N', 'M', 'S', 'U', 'B', 'S', 's', 0,
  /* 17721 */ 'Q', 'V', 'F', 'A', 'D', 'D', 'S', 's', 0,
  /* 17730 */ 'Q', 'V', 'F', 'M', 'A', 'D', 'D', 'S', 's', 0,
  /* 17740 */ 'Q', 'V', 'F', 'N', 'M', 'A', 'D', 'D', 'S', 's', 0,
  /* 17751 */ 'X', 'S', 'C', 'V', 'D', 'P', 'S', 'X', 'D', 'S', 's', 0,
  /* 17763 */ 'X', 'S', 'C', 'V', 'D', 'P', 'U', 'X', 'D', 'S', 's', 0,
  /* 17775 */ 'Q', 'V', 'F', 'R', 'E', 'S', 's', 0,
  /* 17783 */ 'Q', 'V', 'F', 'R', 'S', 'Q', 'R', 'T', 'E', 'S', 's', 0,
  /* 17795 */ 'Q', 'V', 'F', 'M', 'U', 'L', 'S', 's', 0,
  /* 17804 */ 'X', 'S', 'C', 'V', 'D', 'P', 'S', 'X', 'W', 'S', 's', 0,
  /* 17816 */ 'X', 'S', 'C', 'V', 'D', 'P', 'U', 'X', 'W', 'S', 's', 0,
  /* 17828 */ 'V', 'E', 'X', 'T', 'S', 'B', '2', 'W', 's', 0,
  /* 17838 */ 'V', 'E', 'X', 'T', 'S', 'H', '2', 'W', 's', 0,
  /* 17848 */ 'X', 'X', 'S', 'P', 'L', 'T', 'W', 's', 0,
  /* 17857 */ 'Q', 'V', 'L', 'F', 'C', 'S', 'X', 's', 0,
  /* 17866 */ 'Q', 'V', 'S', 'T', 'F', 'C', 'S', 'X', 's', 0,
  /* 17876 */ 'Q', 'V', 'L', 'F', 'S', 'X', 's', 0,
  /* 17884 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'X', 's', 0,
  /* 17893 */ 'Q', 'V', 'S', 'T', 'F', 'S', 'U', 'X', 's', 0,
  /* 17903 */ 'Q', 'V', 'F', 'R', 'I', 'Z', 's', 0,
  /* 17911 */ 'Q', 'V', 'F', 'S', 'E', 'L', 'b', 's', 0,
  /* 17920 */ 'Q', 'V', 'F', 'T', 'S', 'T', 'N', 'A', 'N', 'b', 's', 0,
  /* 17932 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'E', 'Q', 'b', 's', 0,
  /* 17943 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'G', 'T', 'b', 's', 0,
  /* 17954 */ 'Q', 'V', 'F', 'C', 'M', 'P', 'L', 'T', 'b', 's', 0,
  /* 17965 */ 'B', 'C', 'L', 'a', 'l', 'w', 'a', 'y', 's', 0,
  /* 17975 */ 'g', 'B', 'C', 'A', 'a', 't', 0,
  /* 17982 */ 'g', 'B', 'C', 'L', 'A', 'a', 't', 0,
  /* 17990 */ 'g', 'B', 'C', 'a', 't', 0,
  /* 17996 */ 'g', 'B', 'C', 'L', 'a', 't', 0,
  /* 18003 */ 'Q', 'V', 'L', 'P', 'C', 'L', 'S', 'X', 'i', 'n', 't', 0,
  /* 18015 */ 'M', 'F', 'V', 'R', 'S', 'A', 'V', 'E', 'v', 0,
  /* 18025 */ 'M', 'T', 'V', 'R', 'S', 'A', 'V', 'E', 'v', 0,
  /* 18035 */ 'S', 'T', 'X', 'S', 'I', 'B', 'X', 'v', 0,
  /* 18044 */ 'S', 'T', 'X', 'S', 'I', 'H', 'X', 'v', 0,
  /* 18053 */ 'L', 'A', 'x', 0,
  /* 18057 */ 'C', 'P', '_', 'P', 'A', 'S', 'T', 'E', 'x', 0,
  /* 18067 */ 'D', 'C', 'B', 'F', 'x', 0,
  /* 18073 */ 'D', 'C', 'B', 'T', 'x', 0,
  /* 18079 */ 'D', 'C', 'B', 'T', 'S', 'T', 'x', 0,
  /* 18087 */ 'C', 'P', '_', 'C', 'O', 'P', 'Y', 'x', 0,
  /* 18096 */ 'X', 'X', 'L', 'X', 'O', 'R', 'z', 0,
  /* 18104 */ 'X', 'X', 'L', 'X', 'O', 'R', 'd', 'p', 'z', 0,
  /* 18114 */ 'X', 'X', 'L', 'X', 'O', 'R', 's', 'p', 'z', 0,
  /* 18124 */ 'F', 'A', 'D', 'D', 'r', 't', 'z', 0,
};

extern const unsigned PPCInstrNameIndices[] = {
    6177U, 7469U, 10148U, 7800U, 6784U, 6765U, 6793U, 6968U, 
    5571U, 5586U, 5308U, 5600U, 11408U, 5126U, 6774U, 4890U, 
    15033U, 5022U, 12382U, 4569U, 8086U, 6949U, 12290U, 4641U, 
    12279U, 5042U, 9158U, 9145U, 10309U, 11913U, 12119U, 6881U, 
    6928U, 6901U, 6817U, 4275U, 3564U, 7097U, 12832U, 12845U, 
    7289U, 7296U, 4542U, 10569U, 10547U, 5306U, 6175U, 14195U, 
    5136U, 11865U, 11023U, 12397U, 11040U, 10482U, 3793U, 11391U, 
    12301U, 10663U, 12437U, 3767U, 4612U, 4151U, 4129U, 4140U, 
    5092U, 11446U, 5614U, 5631U, 4281U, 3570U, 4548U, 4513U, 
    10574U, 10553U, 13995U, 7756U, 13978U, 7739U, 4882U, 4596U, 
    11884U, 3733U, 11492U, 12595U, 3785U, 12268U, 12256U, 12372U, 
    5655U, 12588U, 12604U, 6867U, 10341U, 10334U, 9101U, 9094U, 
    11875U, 7904U, 4918U, 7888U, 4874U, 7896U, 4910U, 7880U, 
    4866U, 7967U, 7959U, 5730U, 5722U, 4192U, 3525U, 7067U, 
    2984U, 12810U, 7282U, 13582U, 9938U, 652U, 5648U, 644U, 
    0U, 5543U, 12580U, 3757U, 6402U, 6489U, 8989U, 8998U, 
    10688U, 7691U, 5244U, 7517U, 7527U, 4932U, 4947U, 7495U, 
    7506U, 8849U, 6717U, 7725U, 13964U, 7732U, 13971U, 10143U, 
    12143U, 12171U, 12150U, 10497U, 15209U, 5288U, 15197U, 5270U, 
    9132U, 8104U, 6873U, 11370U, 7793U, 12422U, 10468U, 12312U, 
    12320U, 12447U, 10255U, 5009U, 1573U, 6062U, 16549U, 6551U, 
    16646U, 6093U, 16573U, 6587U, 16672U, 12513U, 18087U, 12489U, 
    18057U, 6861U, 9087U, 18067U, 11897U, 10910U, 11904U, 10917U, 
    12565U, 18079U, 12554U, 18073U, 553U, 1001U, 573U, 1021U, 
    6071U, 16559U, 6574U, 16664U, 6114U, 16597U, 6608U, 16696U, 
    6560U, 16656U, 6100U, 16581U, 6594U, 16680U, 18053U, 14028U, 
    15008U, 15688U, 15714U, 15697U, 15724U, 15706U, 15734U, 6107U, 
    16589U, 6601U, 16688U, 6066U, 16553U, 6555U, 16650U, 4448U, 
    14153U, 12540U, 14733U, 6102U, 16583U, 6596U, 16682U, 14959U, 
    5984U, 3684U, 16143U, 11168U, 11174U, 563U, 1011U, 584U, 
    1032U, 1078U, 11220U, 15837U, 1554U, 11228U, 15288U, 15879U, 
    3642U, 1505U, 15851U, 16124U, 4913U, 1581U, 15892U, 16379U, 
    6045U, 1703U, 3690U, 1524U, 16150U, 11190U, 2141U, 2753U, 
    64U, 2737U, 2711U, 2724U, 2700U, 7220U, 358U, 7186U, 
    318U, 10225U, 372U, 7197U, 331U, 10240U, 389U, 7177U, 
    5029U, 1594U, 15907U, 16407U, 11182U, 5231U, 1619U, 15935U, 
    16453U, 7863U, 9923U, 4487U, 1568U, 15886U, 3650U, 1511U, 
    15858U, 16130U, 17034U, 2468U, 16567U, 2461U, 12089U, 2175U, 
    12104U, 2191U, 16272U, 1319U, 218U, 805U, 1874U, 1201U, 
    100U, 687U, 1762U, 1242U, 141U, 728U, 1801U, 1399U, 
    298U, 885U, 1960U, 1283U, 182U, 769U, 1840U, 1221U, 
    120U, 707U, 1781U, 1359U, 258U, 845U, 1912U, 1181U, 
    80U, 667U, 1730U, 1378U, 277U, 864U, 1940U, 1262U, 
    161U, 748U, 1820U, 1339U, 238U, 825U, 1893U, 1303U, 
    202U, 789U, 1859U, 7858U, 3207U, 2590U, 3635U, 3638U, 
    2613U, 10644U, 2119U, 7034U, 2004U, 6747U, 2965U, 10358U, 
    6998U, 10638U, 2112U, 15752U, 7027U, 1996U, 15743U, 15776U, 
    15790U, 16740U, 16888U, 17349U, 16748U, 16769U, 16897U, 17357U, 
    16758U, 16936U, 16967U, 16164U, 17108U, 16174U, 6743U, 10353U, 
    6992U, 15769U, 15784U, 17965U, 15764U, 10632U, 2106U, 7020U, 
    1989U, 15538U, 15760U, 15204U, 2414U, 3195U, 15625U, 17412U, 
    7164U, 2977U, 15611U, 17398U, 10380U, 2058U, 7012U, 15640U, 
    17427U, 15669U, 17456U, 15655U, 17442U, 15682U, 17469U, 15047U, 
    2404U, 3190U, 15619U, 17406U, 7159U, 2971U, 15604U, 17391U, 
    10374U, 2051U, 7005U, 15632U, 17419U, 15662U, 17449U, 15649U, 
    17436U, 15677U, 17464U, 6739U, 1979U, 9117U, 11321U, 11306U, 
    15368U, 2955U, 1456U, 9108U, 10348U, 2034U, 6986U, 9125U, 
    11314U, 4469U, 3751U, 3306U, 3294U, 1468U, 4636U, 6087U, 
    3299U, 4424U, 6055U, 13348U, 6537U, 3314U, 1474U, 13589U, 
    6581U, 4838U, 16363U, 13877U, 2269U, 16029U, 17325U, 4851U, 
    16371U, 13890U, 2277U, 16038U, 17333U, 12413U, 15030U, 2390U, 
    5117U, 1609U, 15924U, 16436U, 11949U, 11970U, 4530U, 3655U, 
    12864U, 4499U, 10456U, 10477U, 3949U, 11987U, 11979U, 10535U, 
    8833U, 7836U, 2588U, 5260U, 8842U, 5974U, 12503U, 8877U, 
    11855U, 8870U, 12527U, 8885U, 15038U, 8894U, 7153U, 8862U, 
    5989U, 4821U, 4926U, 12680U, 17176U, 16385U, 12674U, 17169U, 
    16350U, 13855U, 5217U, 12687U, 17184U, 16446U, 12774U, 17208U, 
    17309U, 11442U, 6961U, 12509U, 905U, 12534U, 911U, 12573U, 
    926U, 12560U, 919U, 3850U, 1539U, 11956U, 2160U, 10674U, 
    4178U, 11055U, 5381U, 6377U, 4373U, 5472U, 6464U, 4390U, 
    9961U, 11993U, 12191U, 5447U, 6411U, 15051U, 15141U, 5497U, 
    6498U, 15070U, 15169U, 12803U, 7053U, 10695U, 5529U, 3511U, 
    10006U, 12030U, 12228U, 10728U, 4260U, 4318U, 5389U, 6385U, 
    5480U, 6472U, 9979U, 12011U, 12209U, 5455U, 6419U, 15150U, 
    5505U, 6506U, 15178U, 12817U, 7074U, 10711U, 5550U, 3549U, 
    10015U, 12039U, 12237U, 595U, 1043U, 613U, 1061U, 17496U, 
    12860U, 2249U, 16011U, 17221U, 10743U, 13311U, 12956U, 13078U, 
    13017U, 13139U, 13225U, 4536U, 3662U, 9998U, 11519U, 12726U, 
    11528U, 12735U, 13651U, 13875U, 11679U, 12772U, 12870U, 3403U, 
    5835U, 10735U, 4267U, 5397U, 6393U, 5488U, 6480U, 9988U, 
    12020U, 12218U, 5463U, 6427U, 15159U, 5513U, 6514U, 15187U, 
    12824U, 7081U, 10719U, 5557U, 3556U, 10024U, 12048U, 12246U, 
    4297U, 14114U, 5677U, 14235U, 13232U, 14914U, 11784U, 14668U, 
    11807U, 14693U, 11820U, 14707U, 4982U, 14209U, 11377U, 14643U, 
    12707U, 14825U, 11796U, 14681U, 11833U, 14721U, 6153U, 7942U, 
    7932U, 6163U, 2476U, 7569U, 2520U, 7613U, 2554U, 7647U, 
    5321U, 2618U, 12908U, 13383U, 6223U, 2779U, 12968U, 13431U, 
    5412U, 2657U, 12932U, 13407U, 13090U, 13503U, 6258U, 2818U, 
    13029U, 13467U, 13151U, 13539U, 2488U, 7581U, 2532U, 7625U, 
    2566U, 7659U, 5339U, 2638U, 12920U, 13395U, 6241U, 2799U, 
    13005U, 13455U, 5430U, 2677U, 12944U, 13419U, 13127U, 13527U, 
    6285U, 2848U, 13066U, 13491U, 13188U, 13563U, 2990U, 5330U, 
    2628U, 6232U, 2789U, 5421U, 2667U, 6267U, 2828U, 12993U, 
    13443U, 13115U, 13515U, 6276U, 2838U, 13054U, 13479U, 13176U, 
    13551U, 5348U, 2648U, 2500U, 7593U, 6250U, 2809U, 2544U, 
    7637U, 5439U, 2687U, 2510U, 7603U, 6294U, 2858U, 2578U, 
    7671U, 4506U, 5565U, 10462U, 10514U, 3955U, 13354U, 6544U, 
    13238U, 6849U, 13360U, 6567U, 6143U, 6446U, 11206U, 12699U, 
    11615U, 12760U, 4311U, 14121U, 5683U, 14242U, 13245U, 14921U, 
    4989U, 14217U, 7912U, 14377U, 5223U, 14226U, 8078U, 14386U, 
    12980U, 13102U, 13041U, 13163U, 13267U, 13275U, 10541U, 3405U, 
    1481U, 935U, 15843U, 16066U, 5837U, 1691U, 948U, 15965U, 
    16505U, 13684U, 6193U, 961U, 15808U, 16613U, 536U, 989U, 
    15824U, 17282U, 7920U, 4691U, 16305U, 11425U, 17085U, 4187U, 
    10828U, 16973U, 16196U, 18124U, 4361U, 10903U, 16997U, 12649U, 
    11546U, 17115U, 17153U, 16231U, 4789U, 11586U, 4582U, 16277U, 
    11356U, 17062U, 4384U, 12658U, 15218U, 17365U, 17161U, 15063U, 
    17341U, 16238U, 13321U, 12753U, 15228U, 17374U, 17200U, 15238U, 
    17383U, 17248U, 12812U, 11609U, 17124U, 17215U, 4201U, 10836U, 
    16980U, 16202U, 10412U, 16921U, 3534U, 10809U, 16950U, 16089U, 
    7062U, 11335U, 17048U, 16719U, 4697U, 16312U, 11431U, 17092U, 
    4334U, 16217U, 11082U, 17027U, 4209U, 10845U, 16988U, 16209U, 
    3542U, 10818U, 16958U, 16096U, 5088U, 11007U, 17005U, 16422U, 
    4462U, 16264U, 11350U, 17055U, 4590U, 16286U, 11364U, 17071U, 
    4630U, 16293U, 11385U, 17078U, 4826U, 16356U, 11767U, 17131U, 
    9791U, 16871U, 5109U, 11014U, 17011U, 16427U, 4412U, 16245U, 
    11214U, 17041U, 12424U, 11537U, 17100U, 17138U, 3520U, 10801U, 
    16943U, 16083U, 12839U, 12430U, 10281U, 421U, 10268U, 406U, 
    4367U, 5979U, 8855U, 3745U, 10034U, 11860U, 11236U, 5995U, 
    6844U, 1983U, 3838U, 2956U, 14486U, 7114U, 14395U, 15043U, 
    2399U, 14310U, 12780U, 2231U, 14876U, 2345U, 14981U, 2372U, 
    11282U, 15341U, 503U, 4402U, 14492U, 7121U, 11773U, 14510U, 
    14283U, 14366U, 12665U, 14802U, 14149U, 11251U, 15306U, 7208U, 
    344U, 15525U, 2600U, 12354U, 6455U, 7170U, 4325U, 14408U, 
    12621U, 14787U, 14131U, 14021U, 15001U, 11067U, 12715U, 14855U, 
    14621U, 2696U, 1451U, 14498U, 7128U, 12611U, 2207U, 14748U, 
    2317U, 13959U, 2285U, 14523U, 2303U, 14423U, 15100U, 2409U, 
    14317U, 12785U, 2237U, 14882U, 2352U, 14994U, 2378U, 11290U, 
    15350U, 514U, 6184U, 1712U, 11196U, 2148U, 13366U, 6615U, 
    14047U, 14250U, 14929U, 7048U, 10623U, 14894U, 7142U, 2996U, 
    14504U, 7135U, 11844U, 14754U, 14042U, 545U, 434U, 14545U, 
    2310U, 14436U, 15248U, 2420U, 14324U, 12790U, 2243U, 14888U, 
    2359U, 15025U, 2384U, 11298U, 15359U, 525U, 15531U, 4733U, 
    14177U, 14973U, 14986U, 14034U, 15014U, 9819U, 14471U, 12881U, 
    13927U, 13897U, 14606U, 13944U, 7103U, 6973U, 13912U, 14661U, 
    14903U, 4346U, 12632U, 4405U, 1559U, 10128U, 5356U, 11071U, 
    14576U, 4858U, 10179U, 2028U, 10651U, 2127U, 10161U, 11062U, 
    7849U, 6327U, 4903U, 7841U, 6318U, 7042U, 17021U, 10364U, 
    2039U, 10606U, 5361U, 1640U, 10416U, 10589U, 2088U, 10601U, 
    7779U, 3423U, 1494U, 4685U, 5151U, 18015U, 10191U, 4671U, 
    4430U, 15252U, 4704U, 13605U, 4776U, 13763U, 3830U, 3844U, 
    5375U, 1656U, 10657U, 2134U, 17475U, 17486U, 10173U, 9U, 
    57U, 5406U, 6136U, 16605U, 15395U, 16474U, 10369U, 2045U, 
    10612U, 4664U, 5368U, 1648U, 10422U, 10595U, 2095U, 10618U, 
    7786U, 5160U, 18025U, 10198U, 4678U, 4303U, 3000U, 11622U, 
    15260U, 4353U, 12640U, 17145U, 16224U, 13305U, 12744U, 17192U, 
    17241U, 4418U, 16252U, 6187U, 1709U, 13342U, 17255U, 10398U, 
    10387U, 2066U, 4494U, 1567U, 15885U, 16271U, 8095U, 5532U, 
    1686U, 15959U, 16481U, 9113U, 1419U, 1431U, 10452U, 2078U, 
    15999U, 16926U, 10446U, 2079U, 16000U, 3945U, 1549U, 15873U, 
    16185U, 6373U, 1725U, 11201U, 2154U, 16927U, 3436U, 4755U, 
    13713U, 12333U, 12342U, 6309U, 15402U, 17574U, 6436U, 15412U, 
    17584U, 10681U, 17674U, 4185U, 10826U, 17721U, 4359U, 10901U, 
    12647U, 11544U, 15377U, 9970U, 15454U, 17932U, 12002U, 15471U, 
    17943U, 12200U, 15481U, 17954U, 7703U, 17633U, 4382U, 12656U, 
    15216U, 15061U, 15386U, 13319U, 12751U, 15226U, 15236U, 6728U, 
    15423U, 17604U, 4199U, 10834U, 17730U, 10410U, 15464U, 17667U, 
    3532U, 10807U, 17700U, 7060U, 11333U, 17795U, 10703U, 17682U, 
    5536U, 17548U, 4207U, 10843U, 17740U, 3540U, 10816U, 17710U, 
    7448U, 17624U, 5086U, 11005U, 17775U, 7386U, 17616U, 7772U, 
    17643U, 9080U, 17651U, 15134U, 17903U, 9789U, 17659U, 5107U, 
    11012U, 17783U, 6837U, 15435U, 15516U, 17911U, 3518U, 10799U, 
    17691U, 7681U, 15443U, 17920U, 4241U, 10880U, 7089U, 11341U, 
    4216U, 10853U, 4250U, 10890U, 4229U, 10867U, 6022U, 14766U, 
    3090U, 14097U, 3018U, 14834U, 3130U, 14589U, 3054U, 17857U, 
    14785U, 3111U, 14129U, 3037U, 15491U, 14019U, 3008U, 14999U, 
    3180U, 14853U, 3151U, 14619U, 3073U, 15508U, 17876U, 14144U, 
    14634U, 18003U, 14168U, 14652U, 14775U, 3100U, 6668U, 2909U, 
    14105U, 3027U, 6630U, 2867U, 14843U, 3140U, 6689U, 2932U, 
    14597U, 3063U, 6649U, 2888U, 17866U, 14793U, 3120U, 6679U, 
    2921U, 14136U, 3045U, 6640U, 2878U, 15499U, 14942U, 3170U, 
    14861U, 3160U, 6700U, 2944U, 17893U, 14626U, 3081U, 6659U, 
    2899U, 17884U, 10205U, 12063U, 5169U, 6011U, 6050U, 3215U, 
    6132U, 4368U, 6016U, 6752U, 16704U, 10167U, 16906U, 3696U, 
    6758U, 450U, 976U, 15797U, 16711U, 10184U, 460U, 16913U, 
    16157U, 6209U, 16623U, 6216U, 1716U, 15973U, 16631U, 7400U, 
    2013U, 15982U, 16725U, 7408U, 2021U, 15991U, 16733U, 3457U, 
    4071U, 1156U, 1110U, 1663U, 1133U, 1749U, 3859U, 3886U, 
    3988U, 5055U, 1083U, 3961U, 3913U, 4044U, 4015U, 1170U, 
    1123U, 1676U, 1146U, 1930U, 3874U, 3901U, 4003U, 5069U, 
    1098U, 3976U, 3929U, 4059U, 4031U, 3418U, 1488U, 4605U, 
    15563U, 16392U, 2767U, 4997U, 5522U, 4962U, 12795U, 5100U, 
    3814U, 4444U, 16259U, 13362U, 2254U, 16017U, 17262U, 15245U, 
    15022U, 13740U, 14965U, 10216U, 12077U, 5198U, 4159U, 6039U, 
    441U, 16542U, 16190U, 13212U, 6523U, 16639U, 17226U, 4667U, 
    16300U, 13601U, 2259U, 16023U, 17267U, 3453U, 1500U, 14276U, 
    14073U, 14401U, 12616U, 2213U, 14760U, 2324U, 14068U, 2291U, 
    11243U, 15297U, 470U, 4772U, 11778U, 14516U, 14289U, 14079U, 
    12669U, 14807U, 14190U, 11258U, 15314U, 4329U, 14415U, 12626U, 
    14795U, 14138U, 14944U, 11077U, 12720U, 14863U, 14628U, 5875U, 
    1698U, 14529U, 14296U, 14085U, 14429U, 12694U, 2219U, 14819U, 
    2331U, 14271U, 2297U, 11266U, 15323U, 481U, 13370U, 9140U, 
    6620U, 14053U, 14256U, 14935U, 14898U, 7147U, 13743U, 2264U, 
    11849U, 14551U, 14303U, 14091U, 14442U, 12767U, 2225U, 14870U, 
    2338U, 14968U, 2366U, 11274U, 15332U, 492U, 4738U, 14183U, 
    14060U, 18035U, 14263U, 18044U, 14951U, 9825U, 14478U, 12885U, 
    13935U, 13904U, 13951U, 7108U, 6979U, 13919U, 14908U, 5265U, 
    1634U, 15952U, 3678U, 1517U, 15865U, 16136U, 4976U, 1587U, 
    15899U, 16400U, 3702U, 1531U, 5035U, 1601U, 15915U, 16414U, 
    5237U, 1626U, 15943U, 16460U, 16468U, 3817U, 12406U, 3669U, 
    6001U, 4074U, 6029U, 3270U, 1461U, 2593U, 1443U, 10628U, 
    2102U, 7718U, 11938U, 6710U, 11927U, 15571U, 2425U, 15582U, 
    2437U, 15593U, 2449U, 4751U, 6121U, 4564U, 2773U, 5003U, 
    6810U, 14011U, 4399U, 6181U, 5080U, 630U, 14583U, 660U, 
    4110U, 3822U, 5211U, 637U, 8099U, 12363U, 7347U, 10619U, 
    13701U, 6626U, 5184U, 10133U, 3464U, 5879U, 13769U, 10081U, 
    13755U, 10109U, 7439U, 8933U, 10766U, 11126U, 11647U, 7249U, 
    10791U, 7274U, 7330U, 11151U, 7422U, 7553U, 11671U, 4537U, 
    3663U, 3347U, 5779U, 13619U, 3480U, 5895U, 13785U, 4468U, 
    10040U, 14613U, 41U, 14813U, 49U, 10301U, 12477U, 3622U, 
    4832U, 5962U, 3221U, 13869U, 8901U, 16810U, 9007U, 16829U, 
    3502U, 16073U, 4796U, 16330U, 5917U, 16512U, 13807U, 17289U, 
    8948U, 16819U, 9016U, 16839U, 3394U, 16056U, 4717U, 16320U, 
    5826U, 16495U, 13675U, 17272U, 3597U, 16104U, 4805U, 16340U, 
    5937U, 16522U, 13839U, 17299U, 3239U, 16047U, 5690U, 16486U, 
    13259U, 17232U, 3613U, 16114U, 5953U, 16532U, 13860U, 17315U, 
    11753U, 23U, 11760U, 32U, 3628U, 4845U, 5968U, 3230U, 
    13884U, 12871U, 8963U, 4744U, 3586U, 5926U, 13816U, 4083U, 
    17518U, 12890U, 17828U, 4092U, 17528U, 12899U, 17838U, 4101U, 
    17538U, 14339U, 14536U, 14348U, 14558U, 14357U, 14567U, 4164U, 
    3444U, 4763U, 5866U, 13721U, 8940U, 8925U, 9025U, 3411U, 
    4726U, 5843U, 13690U, 3606U, 4814U, 5946U, 13848U, 11105U, 
    11115U, 8982U, 3379U, 4710U, 5811U, 13660U, 3487U, 4782U, 
    5902U, 13792U, 7320U, 13252U, 3247U, 5698U, 13290U, 3263U, 
    5705U, 13327U, 13575U, 7232U, 7303U, 11134U, 7257U, 7338U, 
    11159U, 10063U, 10089U, 10118U, 10054U, 3325U, 5757U, 13611U, 
    3472U, 5887U, 13777U, 3386U, 5818U, 13667U, 3494U, 5909U, 
    13799U, 7561U, 4507U, 10292U, 12464U, 4340U, 13284U, 8909U, 
    10463U, 10515U, 3956U, 7456U, 10428U, 10526U, 14457U, 11438U, 
    11554U, 11476U, 11570U, 11484U, 11593U, 7479U, 11562U, 7487U, 
    11578U, 7537U, 11601U, 3286U, 4476U, 5738U, 13375U, 3435U, 
    4754U, 5857U, 13712U, 4170U, 9953U, 13217U, 8957U, 7356U, 
    7712U, 9050U, 15104U, 3276U, 4438U, 6202U, 7393U, 5712U, 
    13355U, 6302U, 7407U, 8972U, 14371U, 6850U, 4118U, 13200U, 
    7049U, 3281U, 4443U, 6337U, 5717U, 7954U, 12852U, 13361U, 
    3428U, 17510U, 5850U, 17556U, 3362U, 5794U, 13634U, 13697U, 
    10624U, 3209U, 4158U, 5671U, 13211U, 3320U, 4673U, 5752U, 
    8073U, 12876U, 13600U, 10073U, 13747U, 10100U, 7430U, 8918U, 
    10758U, 11097U, 11639U, 7241U, 10783U, 7266U, 7312U, 11143U, 
    7414U, 7545U, 11663U, 11630U, 10749U, 11088U, 10774U, 11655U, 
    14449U, 3354U, 5786U, 13626U, 14463U, 3371U, 5803U, 13643U, 
    10542U, 16U, 3201U, 5663U, 10992U, 3333U, 5765U, 12058U, 
    4970U, 6125U, 10522U, 2083U, 16005U, 6372U, 1724U, 11200U, 
    2153U, 16931U, 8680U, 9343U, 8250U, 9226U, 8036U, 9497U, 
    8642U, 8613U, 9314U, 8306U, 8696U, 8550U, 9287U, 8754U, 
    9360U, 8514U, 9277U, 9032U, 9296U, 9734U, 7826U, 10926U, 
    17751U, 11687U, 17804U, 10959U, 17763U, 11720U, 17816U, 8559U, 
    8568U, 7975U, 15080U, 15268U, 15090U, 15278U, 9234U, 8577U, 
    7816U, 8266U, 9513U, 9243U, 8286U, 9533U, 8763U, 9369U, 
    8064U, 9870U, 8595U, 9305U, 8176U, 9441U, 8494U, 9696U, 
    9217U, 8026U, 8241U, 8817U, 8405U, 8232U, 8534U, 8396U, 
    8134U, 9399U, 8452U, 9654U, 9180U, 7996U, 8414U, 9269U, 
    8045U, 9616U, 8662U, 9334U, 8362U, 9252U, 8154U, 9419U, 
    8472U, 9674U, 9207U, 8015U, 8112U, 9377U, 8430U, 9632U, 
    9170U, 7985U, 6344U, 3709U, 7362U, 9056U, 15110U, 8326U, 
    9563U, 6358U, 14331U, 9945U, 9796U, 8340U, 9577U, 8716U, 
    9351U, 8054U, 9842U, 8196U, 9189U, 8006U, 9461U, 8771U, 
    8725U, 8212U, 9197U, 9477U, 8624U, 9325U, 8378U, 9260U, 
    8688U, 9811U, 8258U, 9505U, 8652U, 16788U, 9779U, 16860U, 
    8316U, 16777U, 9553U, 16849U, 8706U, 16799U, 9832U, 16877U, 
    8524U, 9716U, 9743U, 10937U, 11698U, 10970U, 11731U, 9752U, 
    8586U, 9041U, 10948U, 11709U, 10981U, 11742U, 8276U, 9523U, 
    8797U, 9895U, 8296U, 9543U, 8807U, 9905U, 8789U, 9887U, 
    8604U, 9761U, 8186U, 9451U, 8504U, 9706U, 8825U, 9915U, 
    8542U, 9726U, 8144U, 9409U, 8462U, 9664U, 8422U, 9624U, 
    8671U, 9802U, 8370U, 9599U, 8165U, 9430U, 8483U, 9685U, 
    8123U, 9388U, 8441U, 9643U, 6351U, 3717U, 7370U, 9064U, 
    15118U, 8333U, 9570U, 6365U, 3725U, 7378U, 9072U, 15126U, 
    8351U, 9588U, 8745U, 9861U, 8204U, 9469U, 8780U, 9878U, 
    8735U, 9851U, 8222U, 9487U, 8633U, 9770U, 8387U, 9607U, 
    4658U, 5746U, 10048U, 13594U, 13827U, 13730U, 4484U, 3647U, 
    12857U, 4491U, 10449U, 10443U, 3942U, 15556U, 10519U, 18104U, 
    18114U, 18096U, 13297U, 13334U, 7462U, 6078U, 17564U, 10435U, 
    6855U, 6529U, 17595U, 3254U, 13704U, 17848U, 3634U, 2608U, 
    17975U, 10637U, 7026U, 6742U, 2959U, 17982U, 10352U, 6991U, 
    17996U, 17990U, 
};

static inline void InitPPCMCInstrInfo(MCInstrInfo *II) {
  II->InitMCInstrInfo(PPCInsts, PPCInstrNameIndices, PPCInstrNameData, 2202);
}

} // end llvm namespace
#endif // GET_INSTRINFO_MC_DESC

#ifdef GET_INSTRINFO_HEADER
#undef GET_INSTRINFO_HEADER
namespace llvm {
struct PPCGenInstrInfo : public TargetInstrInfo {
  explicit PPCGenInstrInfo(int CFSetupOpcode = -1, int CFDestroyOpcode = -1, int CatchRetOpcode = -1, int ReturnOpcode = -1);
  ~PPCGenInstrInfo() override = default;

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
extern const MCInstrDesc PPCInsts[];
extern const unsigned PPCInstrNameIndices[];
extern const char PPCInstrNameData[];
PPCGenInstrInfo::PPCGenInstrInfo(int CFSetupOpcode, int CFDestroyOpcode, int CatchRetOpcode, int ReturnOpcode)
  : TargetInstrInfo(CFSetupOpcode, CFDestroyOpcode, CatchRetOpcode, ReturnOpcode) {
  InitMCInstrInfo(PPCInsts, PPCInstrNameIndices, PPCInstrNameData, 2202);
}
} // end llvm namespace
#endif // GET_INSTRINFO_CTOR_DTOR

#ifdef GET_INSTRINFO_OPERAND_ENUM
#undef GET_INSTRINFO_OPERAND_ENUM
namespace llvm {
namespace PPC {
namespace OpName {
enum {
OPERAND_LAST
};
} // end namespace OpName
} // end namespace PPC
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_ENUM

#ifdef GET_INSTRINFO_NAMED_OPS
#undef GET_INSTRINFO_NAMED_OPS
namespace llvm {
namespace PPC {
LLVM_READONLY
int16_t getNamedOperandIdx(uint16_t Opcode, uint16_t NamedIdx) {
  return -1;
}
} // end namespace PPC
} // end namespace llvm
#endif //GET_INSTRINFO_NAMED_OPS

#ifdef GET_INSTRINFO_OPERAND_TYPES_ENUM
#undef GET_INSTRINFO_OPERAND_TYPES_ENUM
namespace llvm {
namespace PPC {
namespace OpTypes {
enum OperandType {
  abscalltarget = 0,
  abscondbrtarget = 1,
  absdirectbrtarget = 2,
  atimm = 3,
  calltarget = 4,
  condbrtarget = 5,
  crbitm = 6,
  directbrtarget = 7,
  dispRI = 8,
  dispRIX = 9,
  dispRIX16 = 10,
  dispSPE2 = 11,
  dispSPE4 = 12,
  dispSPE8 = 13,
  f32imm = 14,
  f64imm = 15,
  i16imm = 16,
  i1imm = 17,
  i32imm = 18,
  i64imm = 19,
  i8imm = 20,
  imm32SExt16 = 21,
  imm64SExt16 = 22,
  imm64ZExt32 = 23,
  memr = 24,
  memri = 25,
  memrix = 26,
  memrix16 = 27,
  memrr = 28,
  pred = 29,
  ptr_rc_idx = 30,
  ptr_rc_nor0 = 31,
  ptype0 = 32,
  ptype1 = 33,
  ptype2 = 34,
  ptype3 = 35,
  ptype4 = 36,
  ptype5 = 37,
  s16imm = 38,
  s16imm64 = 39,
  s17imm = 40,
  s17imm64 = 41,
  s5imm = 42,
  spe2dis = 43,
  spe4dis = 44,
  spe8dis = 45,
  tlscall = 46,
  tlscall32 = 47,
  tlsgd = 48,
  tlsgd32 = 49,
  tlsreg = 50,
  tlsreg32 = 51,
  tocentry = 52,
  tocentry32 = 53,
  type0 = 54,
  type1 = 55,
  type2 = 56,
  type3 = 57,
  type4 = 58,
  type5 = 59,
  u10imm = 60,
  u12imm = 61,
  u16imm = 62,
  u16imm64 = 63,
  u1imm = 64,
  u2imm = 65,
  u3imm = 66,
  u4imm = 67,
  u5imm = 68,
  u6imm = 69,
  u7imm = 70,
  u8imm = 71,
  OPERAND_TYPE_LIST_END
};
} // end namespace OpTypes
} // end namespace PPC
} // end namespace llvm
#endif // GET_INSTRINFO_OPERAND_TYPES_ENUM

#ifdef GET_INSTRINFO_OPERAND_TYPE
#undef GET_INSTRINFO_OPERAND_TYPE
namespace llvm {
namespace PPC {
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
    388,
    392,
    396,
    400,
    404,
    407,
    410,
    413,
    416,
    418,
    420,
    422,
    424,
    426,
    428,
    430,
    433,
    436,
    439,
    442,
    444,
    446,
    448,
    450,
    453,
    456,
    459,
    462,
    466,
    470,
    474,
    478,
    482,
    486,
    490,
    494,
    498,
    502,
    506,
    510,
    514,
    518,
    521,
    524,
    527,
    531,
    535,
    539,
    543,
    547,
    551,
    554,
    557,
    560,
    563,
    566,
    569,
    572,
    575,
    578,
    581,
    584,
    587,
    590,
    593,
    596,
    599,
    602,
    605,
    608,
    611,
    614,
    616,
    619,
    622,
    625,
    628,
    631,
    634,
    637,
    640,
    643,
    646,
    649,
    652,
    655,
    658,
    661,
    664,
    667,
    670,
    673,
    676,
    679,
    682,
    685,
    688,
    691,
    694,
    697,
    700,
    703,
    706,
    709,
    712,
    715,
    718,
    721,
    724,
    728,
    732,
    735,
    738,
    742,
    746,
    749,
    751,
    753,
    755,
    757,
    759,
    761,
    763,
    765,
    767,
    769,
    771,
    774,
    777,
    780,
    783,
    786,
    789,
    792,
    795,
    798,
    801,
    804,
    806,
    808,
    810,
    812,
    815,
    820,
    825,
    830,
    835,
    839,
    843,
    847,
    851,
    855,
    859,
    863,
    867,
    871,
    875,
    879,
    883,
    887,
    891,
    895,
    899,
    903,
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
    971,
    975,
    979,
    983,
    987,
    991,
    995,
    999,
    1003,
    1007,
    1011,
    1011,
    1012,
    1013,
    1015,
    1018,
    1021,
    1023,
    1025,
    1027,
    1029,
    1032,
    1035,
    1037,
    1039,
    1040,
    1041,
    1042,
    1043,
    1044,
    1045,
    1046,
    1047,
    1050,
    1053,
    1056,
    1059,
    1061,
    1063,
    1066,
    1069,
    1073,
    1077,
    1081,
    1084,
    1087,
    1089,
    1090,
    1091,
    1092,
    1093,
    1094,
    1096,
    1096,
    1096,
    1096,
    1096,
    1098,
    1100,
    1101,
    1102,
    1103,
    1104,
    1105,
    1106,
    1107,
    1108,
    1109,
    1109,
    1109,
    1109,
    1109,
    1109,
    1109,
    1109,
    1110,
    1111,
    1112,
    1113,
    1114,
    1115,
    1116,
    1117,
    1118,
    1119,
    1120,
    1121,
    1122,
    1122,
    1122,
    1122,
    1122,
    1122,
    1122,
    1122,
    1123,
    1124,
    1125,
    1126,
    1127,
    1128,
    1129,
    1131,
    1133,
    1135,
    1136,
    1137,
    1138,
    1138,
    1138,
    1138,
    1139,
    1141,
    1144,
    1147,
    1147,
    1150,
    1153,
    1156,
    1159,
    1162,
    1165,
    1168,
    1171,
    1174,
    1178,
    1182,
    1185,
    1188,
    1190,
    1192,
    1194,
    1196,
    1198,
    1200,
    1202,
    1204,
    1206,
    1208,
    1210,
    1212,
    1212,
    1215,
    1218,
    1221,
    1224,
    1227,
    1230,
    1230,
    1230,
    1233,
    1236,
    1239,
    1242,
    1245,
    1248,
    1251,
    1252,
    1253,
    1256,
    1259,
    1261,
    1263,
    1266,
    1268,
    1270,
    1272,
    1274,
    1277,
    1280,
    1283,
    1286,
    1288,
    1290,
    1292,
    1294,
    1296,
    1299,
    1302,
    1305,
    1308,
    1311,
    1314,
    1317,
    1320,
    1323,
    1326,
    1329,
    1332,
    1335,
    1338,
    1341,
    1344,
    1345,
    1345,
    1348,
    1351,
    1354,
    1357,
    1360,
    1363,
    1366,
    1369,
    1373,
    1377,
    1380,
    1383,
    1385,
    1388,
    1390,
    1392,
    1394,
    1396,
    1398,
    1400,
    1402,
    1405,
    1408,
    1411,
    1413,
    1415,
    1417,
    1419,
    1421,
    1423,
    1425,
    1427,
    1430,
    1433,
    1435,
    1437,
    1440,
    1443,
    1446,
    1449,
    1451,
    1454,
    1456,
    1458,
    1460,
    1462,
    1464,
    1467,
    1470,
    1473,
    1475,
    1477,
    1479,
    1481,
    1483,
    1485,
    1488,
    1491,
    1493,
    1495,
    1498,
    1501,
    1504,
    1507,
    1508,
    1509,
    1511,
    1513,
    1514,
    1517,
    1520,
    1523,
    1526,
    1528,
    1531,
    1533,
    1535,
    1537,
    1539,
    1542,
    1545,
    1548,
    1551,
    1554,
    1557,
    1560,
    1563,
    1565,
    1567,
    1570,
    1573,
    1576,
    1578,
    1580,
    1582,
    1585,
    1587,
    1589,
    1591,
    1593,
    1596,
    1599,
    1602,
    1604,
    1606,
    1608,
    1610,
    1612,
    1614,
    1617,
    1620,
    1622,
    1624,
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
    1828,
    1831,
    1834,
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
    1872,
    1875,
    1878,
    1881,
    1884,
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
    1917,
    1920,
    1923,
    1926,
    1929,
    1932,
    1935,
    1938,
    1941,
    1944,
    1947,
    1950,
    1953,
    1956,
    1959,
    1962,
    1965,
    1968,
    1971,
    1974,
    1977,
    1979,
    1982,
    1985,
    1988,
    1991,
    1994,
    1996,
    2000,
    2003,
    2006,
    2008,
    2010,
    2013,
    2016,
    2019,
    2022,
    2025,
    2028,
    2031,
    2034,
    2037,
    2040,
    2043,
    2046,
    2049,
    2052,
    2055,
    2058,
    2061,
    2064,
    2066,
    2068,
    2070,
    2072,
    2075,
    2078,
    2081,
    2083,
    2085,
    2087,
    2089,
    2091,
    2093,
    2095,
    2097,
    2099,
    2101,
    2103,
    2106,
    2109,
    2112,
    2115,
    2117,
    2119,
    2121,
    2123,
    2123,
    2125,
    2127,
    2129,
    2131,
    2134,
    2137,
    2140,
    2143,
    2146,
    2148,
    2150,
    2152,
    2154,
    2156,
    2158,
    2160,
    2162,
    2165,
    2168,
    2171,
    2174,
    2177,
    2180,
    2182,
    2184,
    2186,
    2188,
    2190,
    2192,
    2194,
    2196,
    2198,
    2200,
    2202,
    2204,
    2206,
    2208,
    2210,
    2212,
    2215,
    2218,
    2221,
    2224,
    2228,
    2232,
    2236,
    2240,
    2242,
    2244,
    2248,
    2252,
    2256,
    2260,
    2263,
    2266,
    2269,
    2272,
    2274,
    2276,
    2278,
    2280,
    2282,
    2284,
    2286,
    2288,
    2292,
    2296,
    2300,
    2304,
    2308,
    2312,
    2316,
    2320,
    2322,
    2324,
    2326,
    2328,
    2330,
    2332,
    2334,
    2336,
    2338,
    2340,
    2342,
    2344,
    2346,
    2348,
    2350,
    2352,
    2354,
    2356,
    2358,
    2360,
    2362,
    2364,
    2366,
    2368,
    2370,
    2372,
    2376,
    2380,
    2384,
    2388,
    2390,
    2392,
    2394,
    2396,
    2399,
    2402,
    2405,
    2408,
    2411,
    2413,
    2416,
    2419,
    2422,
    2425,
    2425,
    2427,
    2429,
    2432,
    2435,
    2438,
    2441,
    2443,
    2447,
    2451,
    2451,
    2454,
    2457,
    2460,
    2463,
    2466,
    2469,
    2472,
    2476,
    2480,
    2484,
    2488,
    2491,
    2494,
    2497,
    2500,
    2503,
    2506,
    2509,
    2512,
    2515,
    2518,
    2521,
    2524,
    2528,
    2532,
    2535,
    2538,
    2541,
    2544,
    2547,
    2550,
    2553,
    2556,
    2559,
    2562,
    2565,
    2568,
    2572,
    2576,
    2579,
    2582,
    2585,
    2588,
    2592,
    2596,
    2599,
    2602,
    2605,
    2608,
    2611,
    2615,
    2619,
    2623,
    2627,
    2630,
    2633,
    2636,
    2639,
    2642,
    2645,
    2648,
    2651,
    2655,
    2659,
    2663,
    2667,
    2670,
    2673,
    2676,
    2679,
    2682,
    2684,
    2686,
    2688,
    2690,
    2693,
    2696,
    2699,
    2702,
    2705,
    2708,
    2711,
    2714,
    2717,
    2720,
    2723,
    2726,
    2729,
    2733,
    2736,
    2739,
    2742,
    2745,
    2748,
    2751,
    2754,
    2757,
    2760,
    2764,
    2768,
    2772,
    2776,
    2779,
    2782,
    2785,
    2788,
    2791,
    2794,
    2797,
    2800,
    2803,
    2806,
    2809,
    2812,
    2815,
    2818,
    2821,
    2824,
    2827,
    2830,
    2833,
    2836,
    2839,
    2842,
    2845,
    2848,
    2852,
    2856,
    2860,
    2864,
    2865,
    2867,
    2869,
    2870,
    2873,
    2874,
    2875,
    2876,
    2877,
    2879,
    2880,
    2882,
    2884,
    2885,
    2887,
    2889,
    2890,
    2891,
    2892,
    2893,
    2894,
    2896,
    2898,
    2900,
    2902,
    2904,
    2906,
    2908,
    2910,
    2911,
    2913,
    2914,
    2916,
    2917,
    2919,
    2921,
    2923,
    2926,
    2929,
    2932,
    2935,
    2935,
    2935,
    2937,
    2939,
    2940,
    2941,
    2942,
    2943,
    2945,
    2946,
    2947,
    2951,
    2954,
    2957,
    2959,
    2963,
    2964,
    2965,
    2967,
    2969,
    2971,
    2973,
    2975,
    2977,
    2979,
    2981,
    2983,
    2984,
    2986,
    2987,
    2989,
    2992,
    2994,
    2996,
    2998,
    3001,
    3004,
    3007,
    3010,
    3013,
    3016,
    3019,
    3022,
    3025,
    3028,
    3031,
    3034,
    3037,
    3040,
    3040,
    3040,
    3040,
    3043,
    3046,
    3049,
    3052,
    3052,
    3054,
    3056,
    3058,
    3060,
    3060,
    3060,
    3060,
    3063,
    3066,
    3069,
    3072,
    3075,
    3078,
    3081,
    3084,
    3087,
    3090,
    3093,
    3096,
    3099,
    3102,
    3105,
    3108,
    3110,
    3112,
    3114,
    3115,
    3117,
    3121,
    3125,
    3129,
    3132,
    3135,
    3138,
    3140,
    3142,
    3145,
    3148,
    3151,
    3153,
    3155,
    3157,
    3159,
    3161,
    3164,
    3167,
    3170,
    3173,
    3176,
    3179,
    3182,
    3185,
    3188,
    3191,
    3194,
    3196,
    3198,
    3200,
    3202,
    3204,
    3206,
    3208,
    3210,
    3212,
    3216,
    3220,
    3224,
    3228,
    3232,
    3236,
    3238,
    3240,
    3242,
    3246,
    3250,
    3254,
    3257,
    3260,
    3263,
    3265,
    3267,
    3269,
    3271,
    3275,
    3279,
    3283,
    3287,
    3291,
    3295,
    3299,
    3303,
    3305,
    3307,
    3309,
    3311,
    3313,
    3315,
    3317,
    3319,
    3321,
    3323,
    3325,
    3327,
    3329,
    3331,
    3333,
    3335,
    3339,
    3343,
    3347,
    3351,
    3354,
    3357,
    3360,
    3363,
    3366,
    3369,
    3373,
    3377,
    3380,
    3383,
    3387,
    3391,
    3395,
    3399,
    3403,
    3407,
    3409,
    3412,
    3415,
    3418,
    3421,
    3424,
    3427,
    3430,
    3433,
    3436,
    3440,
    3443,
    3446,
    3449,
    3452,
    3455,
    3458,
    3461,
    3464,
    3468,
    3471,
    3474,
    3477,
    3480,
    3483,
    3486,
    3489,
    3491,
    3494,
    3497,
    3500,
    3503,
    3506,
    3509,
    3512,
    3515,
    3518,
    3521,
    3524,
    3527,
    3530,
    3533,
    3536,
    3539,
    3542,
    3545,
    3548,
    3552,
    3555,
    3558,
    3561,
    3564,
    3567,
    3570,
    3573,
    3576,
    3579,
    3582,
    3586,
    3589,
    3592,
    3595,
    3599,
    3602,
    3605,
    3608,
    3611,
    3614,
    3617,
    3620,
    3623,
    3623,
    3623,
    3624,
    3624,
    3624,
    3624,
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
    3685,
    3690,
    3696,
    3702,
    3708,
    3714,
    3719,
    3724,
    3729,
    3734,
    3739,
    3744,
    3749,
    3754,
    3756,
    3757,
    3762,
    3767,
    3772,
    3777,
    3782,
    3787,
    3792,
    3797,
    3802,
    3807,
    3812,
    3817,
    3822,
    3827,
    3831,
    3835,
    3839,
    3843,
    3847,
    3851,
    3855,
    3859,
    3863,
    3867,
    3871,
    3875,
    3879,
    3883,
    3885,
    3887,
    3889,
    3891,
    3893,
    3893,
    3894,
    3896,
    3898,
    3900,
    3902,
    3902,
    3905,
    3908,
    3911,
    3914,
    3917,
    3920,
    3923,
    3926,
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
    4005,
    4009,
    4013,
    4017,
    4020,
    4023,
    4026,
    4029,
    4032,
    4035,
    4038,
    4041,
    4044,
    4047,
    4051,
    4055,
    4058,
    4061,
    4064,
    4067,
    4070,
    4074,
    4078,
    4081,
    4084,
    4087,
    4091,
    4095,
    4098,
    4101,
    4104,
    4107,
    4110,
    4113,
    4116,
    4120,
    4124,
    4128,
    4132,
    4135,
    4138,
    4141,
    4144,
    4147,
    4150,
    4150,
    4153,
    4156,
    4159,
    4162,
    4165,
    4168,
    4171,
    4174,
    4177,
    4180,
    4183,
    4186,
    4189,
    4193,
    4197,
    4201,
    4205,
    4208,
    4211,
    4214,
    4217,
    4220,
    4223,
    4226,
    4229,
    4232,
    4235,
    4238,
    4241,
    4244,
    4247,
    4250,
    4253,
    4256,
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
    4312,
    4314,
    4316,
    4318,
    4320,
    4322,
    4324,
    4326,
    4329,
    4330,
    4331,
    4334,
    4337,
    4340,
    4343,
    4344,
    4345,
    4346,
    4347,
    4347,
    4347,
    4348,
    4350,
    4351,
    4352,
    4354,
    4356,
    4358,
    4360,
    4362,
    4364,
    4367,
    4370,
    4371,
    4371,
    4373,
    4374,
    4376,
    4377,
    4378,
    4378,
    4381,
    4383,
    4386,
    4389,
    4389,
    4389,
    4392,
    4392,
    4392,
    4393,
    4394,
    4397,
    4400,
    4402,
    4405,
    4408,
    4411,
    4414,
    4417,
    4420,
    4424,
    4428,
    4431,
    4434,
    4437,
    4440,
    4443,
    4446,
    4449,
    4452,
    4455,
    4458,
    4461,
    4464,
    4467,
    4470,
    4473,
    4476,
    4479,
    4482,
    4485,
    4488,
    4491,
    4494,
    4497,
    4499,
    4502,
    4504,
    4507,
    4510,
    4512,
    4514,
    4516,
    4518,
    4520,
    4523,
    4526,
    4529,
    4532,
    4535,
    4538,
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
    4616,
    4619,
    4622,
    4625,
    4628,
    4631,
    4634,
    4637,
    4640,
    4643,
    4646,
    4649,
    4652,
    4655,
    4657,
    4660,
    4662,
    4664,
    4666,
    4668,
    4670,
    4672,
    4675,
    4677,
    4680,
    4683,
    4686,
    4689,
    4691,
    4693,
    4695,
    4697,
    4699,
    4701,
    4703,
    4705,
    4707,
    4709,
    4712,
    4715,
    4718,
    4721,
    4724,
    4727,
    4729,
    4733,
    4736,
    4740,
    4743,
    4745,
    4749,
    4752,
    4755,
    4758,
    4761,
    4764,
    4767,
    4770,
    4773,
    4776,
    4780,
    4784,
    4787,
    4790,
    4793,
    4796,
    4799,
    4802,
    4805,
    4808,
    4811,
    4815,
    4818,
    4821,
    4824,
    4827,
    4830,
    4833,
    4836,
    4839,
    4843,
    4847,
    4851,
    4855,
    4859,
    4863,
    4865,
    4868,
    4871,
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
    4906,
    4909,
    4912,
    4915,
    4918,
    4921,
    4923,
    4925,
    4929,
    4932,
    4935,
    4938,
    4942,
    4946,
    4950,
    4953,
    4956,
    4959,
    4962,
    4965,
    4968,
    4971,
    4974,
    4977,
    4980,
    4983,
    4986,
    4989,
    4992,
    4995,
    4998,
    5001,
    5003,
    5005,
    5007,
    5009,
    5011,
    5013,
    5015,
    5017,
    5019,
    5021,
    5023,
    5025,
    5028,
    5031,
    5035,
    5038,
    5041,
    5044,
    5048,
    5051,
    5053,
    5055,
    5059,
    5063,
    5067,
    5070,
    5073,
    5076,
    5080,
    5083,
    5086,
    5089,
    5092,
    5095,
    5098,
    5101,
    5104,
    5106,
    5108,
    5110,
    5113,
    5116,
    5119,
    5122,
    5125,
    5128,
    5131,
    5134,
    5137,
    5140,
    5143,
    5146,
    5149,
    5152,
    5156,
    5160,
    5163,
    5166,
    5169,
    5172,
    5175,
    5178,
    5181,
    5184,
    5187,
    5190,
    5193,
    5196,
    5199,
    5202,
    5205,
    5208,
    5211,
    5213,
    5215,
    5217,
    5219,
    5221,
    5223,
    5225,
    5227,
    5230,
    5231,
    5232,
    5233,
    5234,
    5235,
    5236,
    5237,
    5238,
    5239,
    5242,
    5245,
    5248,
    5251,
    5254,
    5257,
    5260,
    5263,
    5265,
    5267,
    5270,
    5273,
    5276,
    5279,
    5282,
    5285,
    5288,
    5291,
    5294,
    5297,
    5300,
    5303,
    5306,
    5309,
    5312,
    5314,
    5316,
    5318,
    5320,
    5322,
    5324,
    5326,
    5328,
    5330,
    5332,
    5334,
    5336,
    5338,
    5340,
    5342,
    5344,
    5346,
    5348,
    5350,
    5352,
    5354,
    5356,
    5358,
    5360,
    5362,
    5364,
    5366,
    5369,
    5372,
    5375,
    5378,
    5381,
    5384,
    5388,
    5392,
    5396,
    5400,
    5404,
    5408,
    5411,
    5414,
    5417,
    5420,
    5423,
    5426,
    5430,
    5434,
    5438,
    5442,
    5446,
    5450,
    5453,
    5456,
    5459,
    5462,
    5464,
    5466,
    5468,
    5470,
    5474,
    5478,
    5482,
    5486,
    5490,
    5494,
    5498,
    5502,
    5506,
    5510,
    5514,
    5518,
    5520,
    5522,
    5524,
    5526,
    5528,
    5530,
    5532,
    5536,
    5540,
    5544,
    5546,
    5548,
    5550,
    5552,
    5554,
    5556,
    5558,
    5561,
    5564,
    5567,
    5570,
    5573,
    5575,
    5578,
    5581,
    5584,
    5586,
    5588,
    5590,
    5592,
    5594,
    5596,
    5599,
    5602,
    5605,
    5608,
    5611,
    5614,
    5617,
    5620,
    5623,
    5626,
    5629,
    5632,
    5635,
    5638,
    5641,
    5644,
    5646,
    5648,
    5650,
    5652,
    5654,
    5656,
    5658,
    5660,
    5662,
    5664,
    5666,
    5668,
    5670,
    5672,
    5674,
    5676,
    5678,
    5680,
    5682,
    5684,
    5687,
    5690,
    5693,
    5696,
    5700,
    5704,
    5708,
    5712,
    5715,
    5718,
    5721,
    5724,
    5728,
    5732,
    5736,
    5740,
    5743,
    5746,
    5748,
    5750,
    5752,
    5754,
    5758,
    5762,
    5766,
    5770,
    5774,
    5778,
    5782,
    5786,
    5788,
    5790,
    5792,
    5794,
    5796,
    5798,
    5800,
    5802,
    5804,
    5806,
    5808,
    5810,
    5812,
    5814,
    5816,
    5818,
    5821,
    5824,
    5827,
    5830,
    5832,
    5834,
    5837,
    5840,
    5842,
    5844,
    5846,
    5848,
    5850,
    5852,
    5854,
    5856,
    5859,
    5863,
    5866,
    5869,
    5872,
    5875,
    5878,
    5881,
    5884,
    5887,
    5890,
    5891,
    5892,
    5893,
    5896,
    5899,
    5902,
    5906,
    5909,
    5912,
    5916,
    5920,
    5923,
    5925,
    5928,
    5931,
    5934,
    5937,
    5941,
    5944,
    5947,
    5950,
    5953,
    5957,
    5960,
    5963,
    5967,
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
    -1, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, OpTypes::u5imm, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, OpTypes::u5imm, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, OpTypes::u5imm, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, OpTypes::u5imm, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, OpTypes::u5imm, OpTypes::i32imm, 
    -1, -1, OpTypes::u5imm, OpTypes::i32imm, 
    -1, -1, OpTypes::u5imm, OpTypes::i32imm, 
    -1, -1, OpTypes::u5imm, OpTypes::i32imm, 
    -1, -1, OpTypes::u5imm, OpTypes::i32imm, 
    -1, -1, OpTypes::u5imm, OpTypes::i32imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm, 
    -1, OpTypes::s16imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, -1, OpTypes::tlsreg32, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::tlsreg, 
    -1, -1, OpTypes::tlsreg, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s17imm, 
    -1, -1, OpTypes::s17imm64, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::i64imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, OpTypes::tlsgd, 
    -1, -1, OpTypes::s16imm, OpTypes::tlsgd32, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, OpTypes::tlsgd, 
    -1, -1, OpTypes::s16imm, OpTypes::tlsgd32, 
    -1, -1, OpTypes::i64imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::i32imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    OpTypes::u16imm, OpTypes::u16imm, 
    OpTypes::u16imm, OpTypes::u16imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u16imm, 
    -1, -1, OpTypes::u16imm64, 
    -1, -1, OpTypes::u16imm, 
    -1, -1, OpTypes::u16imm64, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, -1, 
    /**/
    OpTypes::directbrtarget, 
    OpTypes::absdirectbrtarget, 
    -1, OpTypes::condbrtarget, 
    OpTypes::i32imm, -1, OpTypes::condbrtarget, 
    OpTypes::i32imm, -1, OpTypes::abscondbrtarget, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, OpTypes::condbrtarget, 
    OpTypes::i32imm, -1, OpTypes::abscondbrtarget, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, -1, OpTypes::u1imm, 
    -1, -1, -1, OpTypes::u1imm, 
    -1, -1, -1, OpTypes::u1imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::condbrtarget, 
    -1, 
    -1, 
    -1, 
    -1, 
    OpTypes::condbrtarget, 
    -1, OpTypes::condbrtarget, 
    /**/
    /**/
    /**/
    /**/
    OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    OpTypes::abscondbrtarget, 
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::condbrtarget, 
    OpTypes::calltarget, 
    OpTypes::calltarget, 
    OpTypes::calltarget, 
    OpTypes::calltarget, OpTypes::tlsgd, 
    OpTypes::calltarget, OpTypes::tlsgd, 
    OpTypes::calltarget, OpTypes::tlsgd, 
    OpTypes::abscalltarget, 
    OpTypes::abscalltarget, 
    OpTypes::abscalltarget, 
    /**/
    /**/
    /**/
    OpTypes::calltarget, 
    OpTypes::calltarget, OpTypes::tlsgd32, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u16imm64, 
    -1, -1, -1, 
    -1, -1, OpTypes::u16imm, 
    -1, OpTypes::u1imm, -1, -1, 
    -1, OpTypes::u1imm, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::s16imm, 
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
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    -1, -1, OpTypes::u1imm, 
    /**/
    /**/
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, 
    -1, 
    -1, -1, -1, 
    OpTypes::i32imm, -1, OpTypes::condbrtarget, 
    -1, OpTypes::i32imm, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::u5imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::u5imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, OpTypes::u5imm, 
    OpTypes::u5imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, OpTypes::u5imm, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
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
    OpTypes::u5imm, 
    /**/
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, -1, 
    -1, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::i32imm, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::i64imm, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, 
    -1, -1, -1, 
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
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
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
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, 
    OpTypes::directbrtarget, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::u5imm, 
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
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
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
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::dispSPE8, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE8, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE8, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE2, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE2, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE2, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::s5imm, 
    -1, OpTypes::s5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::dispSPE8, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE8, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE8, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispSPE4, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::u5imm, -1, 
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
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    /**/
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
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
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
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
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::tlsgd, 
    -1, -1, OpTypes::tlsgd32, 
    -1, -1, OpTypes::tlsgd, 
    -1, -1, OpTypes::tlsgd32, 
    /**/
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::u4imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::u4imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::u4imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::u4imm, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    /**/
    -1, -1, OpTypes::s16imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::s16imm64, -1, 
    -1, OpTypes::s16imm, -1, 
    -1, OpTypes::i64imm, -1, 
    -1, OpTypes::i64imm, -1, 
    -1, OpTypes::i64imm, -1, 
    -1, OpTypes::i64imm, -1, 
    -1, OpTypes::i64imm, -1, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::s16imm, 
    -1, OpTypes::s16imm64, 
    -1, OpTypes::s17imm, 
    -1, OpTypes::s17imm64, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::i32imm, -1, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX16, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, -1, 
    -1, OpTypes::ptr_rc_nor0, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    OpTypes::u5imm, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, OpTypes::u10imm, OpTypes::u10imm, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, OpTypes::i32imm, 
    -1, 
    -1, -1, 
    -1, OpTypes::u3imm, 
    -1, 
    -1, -1, 
    -1, OpTypes::u2imm, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, OpTypes::crbitm, 
    -1, OpTypes::crbitm, 
    -1, OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    -1, OpTypes::u4imm, 
    -1, -1, 
    -1, OpTypes::i32imm, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    /**/
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, OpTypes::i32imm, 
    OpTypes::u5imm, 
    OpTypes::u5imm, 
    OpTypes::i32imm, -1, OpTypes::i32imm, OpTypes::i32imm, 
    -1, OpTypes::i32imm, OpTypes::i32imm, 
    -1, OpTypes::i32imm, OpTypes::i32imm, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, OpTypes::i32imm, OpTypes::i32imm, 
    -1, 
    -1, 
    -1, OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::crbitm, -1, 
    OpTypes::crbitm, -1, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    OpTypes::i32imm, -1, 
    -1, OpTypes::u4imm, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
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
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    /**/
    /**/
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u16imm, 
    -1, -1, OpTypes::u16imm64, 
    -1, -1, OpTypes::u16imm, 
    -1, -1, OpTypes::u16imm64, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, -1, -1, OpTypes::u2imm, 
    -1, -1, -1, OpTypes::u2imm, 
    -1, -1, -1, OpTypes::u2imm, 
    -1, -1, OpTypes::u2imm, 
    -1, -1, OpTypes::u2imm, 
    -1, -1, OpTypes::u2imm, 
    -1, -1, 
    -1, -1, 
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
    -1, -1, -1, OpTypes::u12imm, 
    -1, -1, -1, OpTypes::u12imm, 
    -1, -1, -1, OpTypes::u12imm, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, OpTypes::u12imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    /**/
    /**/
    OpTypes::u1imm, 
    /**/
    /**/
    /**/
    -1, -1, -1, OpTypes::u6imm, 
    -1, -1, -1, OpTypes::u6imm, 
    -1, -1, -1, OpTypes::u6imm, 
    -1, -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, -1, OpTypes::u6imm, OpTypes::u6imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, -1, OpTypes::u5imm, OpTypes::u5imm, 
    -1, -1, 
    OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
    -1, -1, -1, -1, OpTypes::i32imm, 
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
    -1, -1, 
    -1, -1, 
    -1, OpTypes::u2imm, 
    -1, -1, 
    /**/
    -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    /**/
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, -1, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, OpTypes::u6imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, OpTypes::u5imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    /**/
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    -1, -1, OpTypes::u5imm, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::dispRI, OpTypes::ptr_rc_nor0, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    OpTypes::ptr_rc_nor0, -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::tlsreg, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::dispRIX16, OpTypes::ptr_rc_nor0, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, -1, 
    -1, OpTypes::ptr_rc_nor0, -1, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, OpTypes::ptr_rc_nor0, OpTypes::ptr_rc_idx, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::s16imm, 
    -1, -1, OpTypes::s16imm64, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    OpTypes::i32imm, 
    -1, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, OpTypes::u5imm, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, OpTypes::u5imm, 
    OpTypes::calltarget, 
    OpTypes::calltarget, 
    OpTypes::abscalltarget, 
    OpTypes::abscalltarget, 
    /**/
    /**/
    OpTypes::u1imm, 
    -1, OpTypes::u1imm, 
    -1, 
    -1, 
    OpTypes::abscalltarget, OpTypes::i32imm, 
    OpTypes::abscalltarget, OpTypes::i32imm, 
    OpTypes::calltarget, OpTypes::i32imm, 
    OpTypes::calltarget, OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, OpTypes::s16imm, 
    OpTypes::u1imm, 
    /**/
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, 
    /**/
    -1, -1, OpTypes::i1imm, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    /**/
    /**/
    -1, -1, OpTypes::i1imm, 
    /**/
    /**/
    -1, 
    OpTypes::u1imm, 
    OpTypes::u5imm, -1, -1, 
    OpTypes::u5imm, -1, OpTypes::s16imm, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, OpTypes::u4imm, -1, 
    -1, OpTypes::u4imm, -1, 
    -1, OpTypes::u4imm, -1, 
    -1, OpTypes::u4imm, -1, 
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
    -1, -1, 
    -1, -1, OpTypes::u4imm, -1, 
    -1, OpTypes::u4imm, -1, 
    -1, -1, OpTypes::u4imm, -1, 
    -1, OpTypes::u4imm, -1, 
    -1, -1, 
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
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, OpTypes::u1imm, OpTypes::u4imm, 
    -1, -1, OpTypes::u1imm, OpTypes::u4imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, OpTypes::u4imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, OpTypes::u5imm, -1, 
    -1, OpTypes::s5imm, 
    -1, OpTypes::s5imm, 
    -1, OpTypes::s5imm, 
    -1, OpTypes::u5imm, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    -1, 
    OpTypes::i32imm, 
    -1, 
    OpTypes::i1imm, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, OpTypes::u16imm, 
    -1, -1, OpTypes::u16imm64, 
    -1, -1, OpTypes::u16imm, 
    -1, -1, OpTypes::u16imm64, 
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
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, OpTypes::u1imm, -1, OpTypes::u2imm, 
    -1, OpTypes::u1imm, -1, OpTypes::u2imm, 
    -1, OpTypes::u1imm, -1, OpTypes::u2imm, 
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
    -1, -1, 
    -1, OpTypes::u7imm, -1, 
    -1, OpTypes::u7imm, -1, 
    -1, OpTypes::u7imm, -1, 
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
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
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
    -1, -1, 
    -1, -1, 
    -1, OpTypes::u7imm, -1, 
    -1, OpTypes::u7imm, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, 
    -1, -1, OpTypes::u4imm, 
    -1, -1, -1, OpTypes::u4imm, 
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
    -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, 
    -1, -1, -1, OpTypes::u2imm, 
    -1, -1, OpTypes::u2imm, 
    -1, -1, -1, 
    -1, -1, -1, -1, 
    -1, -1, -1, OpTypes::u2imm, 
    -1, -1, OpTypes::u2imm, 
    -1, OpTypes::u8imm, 
    -1, -1, OpTypes::u2imm, 
    -1, -1, OpTypes::u2imm, 
    OpTypes::u5imm, -1, OpTypes::condbrtarget, 
    OpTypes::u5imm, -1, OpTypes::abscondbrtarget, 
    OpTypes::u5imm, OpTypes::atimm, -1, OpTypes::abscondbrtarget, 
    OpTypes::u5imm, -1, OpTypes::i32imm, 
    OpTypes::u5imm, -1, OpTypes::i32imm, 
    OpTypes::u5imm, -1, OpTypes::condbrtarget, 
    OpTypes::u5imm, -1, OpTypes::abscondbrtarget, 
    OpTypes::u5imm, OpTypes::atimm, -1, OpTypes::abscondbrtarget, 
    OpTypes::u5imm, -1, OpTypes::i32imm, 
    OpTypes::u5imm, -1, OpTypes::i32imm, 
    OpTypes::u5imm, OpTypes::atimm, -1, OpTypes::condbrtarget, 
    OpTypes::u5imm, OpTypes::atimm, -1, OpTypes::condbrtarget, 
  };
  return OpcodeOperandTypes[Offsets[Opcode] + OpIdx];
}
} // end namespace PPC
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_TYPE

#ifdef GET_INSTRMAP_INFO
#undef GET_INSTRMAP_INFO
namespace llvm {

namespace PPC {

enum IsVSXFMAAlt {
	IsVSXFMAAlt_1
};

enum RC {
	RC_0,
	RC_1
};

// getAltVSXFMAOpcode
LLVM_READONLY
int getAltVSXFMAOpcode(uint16_t Opcode) {
static const uint16_t getAltVSXFMAOpcodeTable[][2] = {
  { PPC::XSMADDADP, PPC::XSMADDMDP },
  { PPC::XSMADDASP, PPC::XSMADDMSP },
  { PPC::XSMSUBADP, PPC::XSMSUBMDP },
  { PPC::XSMSUBASP, PPC::XSMSUBMSP },
  { PPC::XSNMADDADP, PPC::XSNMADDMDP },
  { PPC::XSNMADDASP, PPC::XSNMADDMSP },
  { PPC::XSNMSUBADP, PPC::XSNMSUBMDP },
  { PPC::XSNMSUBASP, PPC::XSNMSUBMSP },
  { PPC::XVMADDADP, PPC::XVMADDMDP },
  { PPC::XVMADDASP, PPC::XVMADDMSP },
  { PPC::XVMSUBADP, PPC::XVMSUBMDP },
  { PPC::XVMSUBASP, PPC::XVMSUBMSP },
  { PPC::XVNMADDADP, PPC::XVNMADDMDP },
  { PPC::XVNMADDASP, PPC::XVNMADDMSP },
  { PPC::XVNMSUBADP, PPC::XVNMSUBMDP },
  { PPC::XVNMSUBASP, PPC::XVNMSUBMSP },
}; // End of getAltVSXFMAOpcodeTable

  unsigned mid;
  unsigned start = 0;
  unsigned end = 16;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == getAltVSXFMAOpcodeTable[mid][0]) {
      break;
    }
    if (Opcode < getAltVSXFMAOpcodeTable[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  return getAltVSXFMAOpcodeTable[mid][1];
}

// getNonRecordFormOpcode
LLVM_READONLY
int getNonRecordFormOpcode(uint16_t Opcode) {
static const uint16_t getNonRecordFormOpcodeTable[][2] = {
  { PPC::ADD4o, PPC::ADD4 },
  { PPC::ADD8o, PPC::ADD8 },
  { PPC::ADDC8o, PPC::ADDC8 },
  { PPC::ADDCo, PPC::ADDC },
  { PPC::ADDE8o, PPC::ADDE8 },
  { PPC::ADDEo, PPC::ADDE },
  { PPC::ADDICo, PPC::ADDIC },
  { PPC::ADDME8o, PPC::ADDME8 },
  { PPC::ADDMEo, PPC::ADDME },
  { PPC::ADDZE8o, PPC::ADDZE8 },
  { PPC::ADDZEo, PPC::ADDZE },
  { PPC::AND8o, PPC::AND8 },
  { PPC::ANDC8o, PPC::ANDC8 },
  { PPC::ANDCo, PPC::ANDC },
  { PPC::ANDo, PPC::AND },
  { PPC::CNTLZDo, PPC::CNTLZD },
  { PPC::CNTLZW8o, PPC::CNTLZW8 },
  { PPC::CNTLZWo, PPC::CNTLZW },
  { PPC::CNTTZDo, PPC::CNTTZD },
  { PPC::CNTTZW8o, PPC::CNTTZW8 },
  { PPC::CNTTZWo, PPC::CNTTZW },
  { PPC::DIVDUo, PPC::DIVDU },
  { PPC::DIVDo, PPC::DIVD },
  { PPC::DIVWUo, PPC::DIVWU },
  { PPC::DIVWo, PPC::DIVW },
  { PPC::EQV8o, PPC::EQV8 },
  { PPC::EQVo, PPC::EQV },
  { PPC::EXTSB8o, PPC::EXTSB8 },
  { PPC::EXTSBo, PPC::EXTSB },
  { PPC::EXTSH8o, PPC::EXTSH8 },
  { PPC::EXTSHo, PPC::EXTSH },
  { PPC::EXTSWSLI_32_64o, PPC::EXTSWSLI_32_64 },
  { PPC::EXTSWSLIo, PPC::EXTSWSLI },
  { PPC::EXTSW_32_64o, PPC::EXTSW_32_64 },
  { PPC::EXTSWo, PPC::EXTSW },
  { PPC::FABSDo, PPC::FABSD },
  { PPC::FABSSo, PPC::FABSS },
  { PPC::FADDSo, PPC::FADDS },
  { PPC::FADDo, PPC::FADD },
  { PPC::FCFIDSo, PPC::FCFIDS },
  { PPC::FCFIDUSo, PPC::FCFIDUS },
  { PPC::FCFIDUo, PPC::FCFIDU },
  { PPC::FCFIDo, PPC::FCFID },
  { PPC::FCPSGNDo, PPC::FCPSGND },
  { PPC::FCPSGNSo, PPC::FCPSGNS },
  { PPC::FCTIDUZo, PPC::FCTIDUZ },
  { PPC::FCTIDUo, PPC::FCTIDU },
  { PPC::FCTIDZo, PPC::FCTIDZ },
  { PPC::FCTIDo, PPC::FCTID },
  { PPC::FCTIWUZo, PPC::FCTIWUZ },
  { PPC::FCTIWUo, PPC::FCTIWU },
  { PPC::FCTIWZo, PPC::FCTIWZ },
  { PPC::FCTIWo, PPC::FCTIW },
  { PPC::FDIVSo, PPC::FDIVS },
  { PPC::FDIVo, PPC::FDIV },
  { PPC::FMADDSo, PPC::FMADDS },
  { PPC::FMADDo, PPC::FMADD },
  { PPC::FMRo, PPC::FMR },
  { PPC::FMSUBSo, PPC::FMSUBS },
  { PPC::FMSUBo, PPC::FMSUB },
  { PPC::FMULSo, PPC::FMULS },
  { PPC::FMULo, PPC::FMUL },
  { PPC::FNABSDo, PPC::FNABSD },
  { PPC::FNABSSo, PPC::FNABSS },
  { PPC::FNEGDo, PPC::FNEGD },
  { PPC::FNEGSo, PPC::FNEGS },
  { PPC::FNMADDSo, PPC::FNMADDS },
  { PPC::FNMADDo, PPC::FNMADD },
  { PPC::FNMSUBSo, PPC::FNMSUBS },
  { PPC::FNMSUBo, PPC::FNMSUB },
  { PPC::FRESo, PPC::FRES },
  { PPC::FREo, PPC::FRE },
  { PPC::FRIMDo, PPC::FRIMD },
  { PPC::FRIMSo, PPC::FRIMS },
  { PPC::FRINDo, PPC::FRIND },
  { PPC::FRINSo, PPC::FRINS },
  { PPC::FRIPDo, PPC::FRIPD },
  { PPC::FRIPSo, PPC::FRIPS },
  { PPC::FRIZDo, PPC::FRIZD },
  { PPC::FRIZSo, PPC::FRIZS },
  { PPC::FRSPo, PPC::FRSP },
  { PPC::FRSQRTESo, PPC::FRSQRTES },
  { PPC::FRSQRTEo, PPC::FRSQRTE },
  { PPC::FSELDo, PPC::FSELD },
  { PPC::FSELSo, PPC::FSELS },
  { PPC::FSQRTSo, PPC::FSQRTS },
  { PPC::FSQRTo, PPC::FSQRT },
  { PPC::FSUBSo, PPC::FSUBS },
  { PPC::FSUBo, PPC::FSUB },
  { PPC::MULHDUo, PPC::MULHDU },
  { PPC::MULHDo, PPC::MULHD },
  { PPC::MULHWUo, PPC::MULHWU },
  { PPC::MULHWo, PPC::MULHW },
  { PPC::MULLDo, PPC::MULLD },
  { PPC::MULLWo, PPC::MULLW },
  { PPC::NAND8o, PPC::NAND8 },
  { PPC::NANDo, PPC::NAND },
  { PPC::NEG8o, PPC::NEG8 },
  { PPC::NEGo, PPC::NEG },
  { PPC::NOR8o, PPC::NOR8 },
  { PPC::NORo, PPC::NOR },
  { PPC::OR8o, PPC::OR8 },
  { PPC::ORC8o, PPC::ORC8 },
  { PPC::ORCo, PPC::ORC },
  { PPC::ORo, PPC::OR },
  { PPC::RLDCLo, PPC::RLDCL },
  { PPC::RLDCRo, PPC::RLDCR },
  { PPC::RLDICL_32o, PPC::RLDICL_32 },
  { PPC::RLDICLo, PPC::RLDICL },
  { PPC::RLDICRo, PPC::RLDICR },
  { PPC::RLDICo, PPC::RLDIC },
  { PPC::RLDIMIo, PPC::RLDIMI },
  { PPC::RLWIMI8o, PPC::RLWIMI8 },
  { PPC::RLWIMIo, PPC::RLWIMI },
  { PPC::RLWINM8o, PPC::RLWINM8 },
  { PPC::RLWINMo, PPC::RLWINM },
  { PPC::RLWNM8o, PPC::RLWNM8 },
  { PPC::RLWNMo, PPC::RLWNM },
  { PPC::SLDo, PPC::SLD },
  { PPC::SLW8o, PPC::SLW8 },
  { PPC::SLWo, PPC::SLW },
  { PPC::SRADIo, PPC::SRADI },
  { PPC::SRADo, PPC::SRAD },
  { PPC::SRAWIo, PPC::SRAWI },
  { PPC::SRAWo, PPC::SRAW },
  { PPC::SRDo, PPC::SRD },
  { PPC::SRW8o, PPC::SRW8 },
  { PPC::SRWo, PPC::SRW },
  { PPC::SUBF8o, PPC::SUBF8 },
  { PPC::SUBFC8o, PPC::SUBFC8 },
  { PPC::SUBFCo, PPC::SUBFC },
  { PPC::SUBFE8o, PPC::SUBFE8 },
  { PPC::SUBFEo, PPC::SUBFE },
  { PPC::SUBFME8o, PPC::SUBFME8 },
  { PPC::SUBFMEo, PPC::SUBFME },
  { PPC::SUBFZE8o, PPC::SUBFZE8 },
  { PPC::SUBFZEo, PPC::SUBFZE },
  { PPC::SUBFo, PPC::SUBF },
  { PPC::XOR8o, PPC::XOR8 },
  { PPC::XORo, PPC::XOR },
}; // End of getNonRecordFormOpcodeTable

  unsigned mid;
  unsigned start = 0;
  unsigned end = 140;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == getNonRecordFormOpcodeTable[mid][0]) {
      break;
    }
    if (Opcode < getNonRecordFormOpcodeTable[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  return getNonRecordFormOpcodeTable[mid][1];
}

// getRecordFormOpcode
LLVM_READONLY
int getRecordFormOpcode(uint16_t Opcode) {
static const uint16_t getRecordFormOpcodeTable[][2] = {
  { PPC::ADD4, PPC::ADD4o },
  { PPC::ADD8, PPC::ADD8o },
  { PPC::ADDC, PPC::ADDCo },
  { PPC::ADDC8, PPC::ADDC8o },
  { PPC::ADDE, PPC::ADDEo },
  { PPC::ADDE8, PPC::ADDE8o },
  { PPC::ADDIC, PPC::ADDICo },
  { PPC::ADDME, PPC::ADDMEo },
  { PPC::ADDME8, PPC::ADDME8o },
  { PPC::ADDZE, PPC::ADDZEo },
  { PPC::ADDZE8, PPC::ADDZE8o },
  { PPC::AND, PPC::ANDo },
  { PPC::AND8, PPC::AND8o },
  { PPC::ANDC, PPC::ANDCo },
  { PPC::ANDC8, PPC::ANDC8o },
  { PPC::CNTLZD, PPC::CNTLZDo },
  { PPC::CNTLZW, PPC::CNTLZWo },
  { PPC::CNTLZW8, PPC::CNTLZW8o },
  { PPC::CNTTZD, PPC::CNTTZDo },
  { PPC::CNTTZW, PPC::CNTTZWo },
  { PPC::CNTTZW8, PPC::CNTTZW8o },
  { PPC::DIVD, PPC::DIVDo },
  { PPC::DIVDU, PPC::DIVDUo },
  { PPC::DIVW, PPC::DIVWo },
  { PPC::DIVWU, PPC::DIVWUo },
  { PPC::EQV, PPC::EQVo },
  { PPC::EQV8, PPC::EQV8o },
  { PPC::EXTSB, PPC::EXTSBo },
  { PPC::EXTSB8, PPC::EXTSB8o },
  { PPC::EXTSH, PPC::EXTSHo },
  { PPC::EXTSH8, PPC::EXTSH8o },
  { PPC::EXTSW, PPC::EXTSWo },
  { PPC::EXTSWSLI, PPC::EXTSWSLIo },
  { PPC::EXTSWSLI_32_64, PPC::EXTSWSLI_32_64o },
  { PPC::EXTSW_32_64, PPC::EXTSW_32_64o },
  { PPC::FABSD, PPC::FABSDo },
  { PPC::FABSS, PPC::FABSSo },
  { PPC::FADD, PPC::FADDo },
  { PPC::FADDS, PPC::FADDSo },
  { PPC::FCFID, PPC::FCFIDo },
  { PPC::FCFIDS, PPC::FCFIDSo },
  { PPC::FCFIDU, PPC::FCFIDUo },
  { PPC::FCFIDUS, PPC::FCFIDUSo },
  { PPC::FCPSGND, PPC::FCPSGNDo },
  { PPC::FCPSGNS, PPC::FCPSGNSo },
  { PPC::FCTID, PPC::FCTIDo },
  { PPC::FCTIDU, PPC::FCTIDUo },
  { PPC::FCTIDUZ, PPC::FCTIDUZo },
  { PPC::FCTIDZ, PPC::FCTIDZo },
  { PPC::FCTIW, PPC::FCTIWo },
  { PPC::FCTIWU, PPC::FCTIWUo },
  { PPC::FCTIWUZ, PPC::FCTIWUZo },
  { PPC::FCTIWZ, PPC::FCTIWZo },
  { PPC::FDIV, PPC::FDIVo },
  { PPC::FDIVS, PPC::FDIVSo },
  { PPC::FMADD, PPC::FMADDo },
  { PPC::FMADDS, PPC::FMADDSo },
  { PPC::FMR, PPC::FMRo },
  { PPC::FMSUB, PPC::FMSUBo },
  { PPC::FMSUBS, PPC::FMSUBSo },
  { PPC::FMUL, PPC::FMULo },
  { PPC::FMULS, PPC::FMULSo },
  { PPC::FNABSD, PPC::FNABSDo },
  { PPC::FNABSS, PPC::FNABSSo },
  { PPC::FNEGD, PPC::FNEGDo },
  { PPC::FNEGS, PPC::FNEGSo },
  { PPC::FNMADD, PPC::FNMADDo },
  { PPC::FNMADDS, PPC::FNMADDSo },
  { PPC::FNMSUB, PPC::FNMSUBo },
  { PPC::FNMSUBS, PPC::FNMSUBSo },
  { PPC::FRE, PPC::FREo },
  { PPC::FRES, PPC::FRESo },
  { PPC::FRIMD, PPC::FRIMDo },
  { PPC::FRIMS, PPC::FRIMSo },
  { PPC::FRIND, PPC::FRINDo },
  { PPC::FRINS, PPC::FRINSo },
  { PPC::FRIPD, PPC::FRIPDo },
  { PPC::FRIPS, PPC::FRIPSo },
  { PPC::FRIZD, PPC::FRIZDo },
  { PPC::FRIZS, PPC::FRIZSo },
  { PPC::FRSP, PPC::FRSPo },
  { PPC::FRSQRTE, PPC::FRSQRTEo },
  { PPC::FRSQRTES, PPC::FRSQRTESo },
  { PPC::FSELD, PPC::FSELDo },
  { PPC::FSELS, PPC::FSELSo },
  { PPC::FSQRT, PPC::FSQRTo },
  { PPC::FSQRTS, PPC::FSQRTSo },
  { PPC::FSUB, PPC::FSUBo },
  { PPC::FSUBS, PPC::FSUBSo },
  { PPC::MULHD, PPC::MULHDo },
  { PPC::MULHDU, PPC::MULHDUo },
  { PPC::MULHW, PPC::MULHWo },
  { PPC::MULHWU, PPC::MULHWUo },
  { PPC::MULLD, PPC::MULLDo },
  { PPC::MULLW, PPC::MULLWo },
  { PPC::NAND, PPC::NANDo },
  { PPC::NAND8, PPC::NAND8o },
  { PPC::NEG, PPC::NEGo },
  { PPC::NEG8, PPC::NEG8o },
  { PPC::NOR, PPC::NORo },
  { PPC::NOR8, PPC::NOR8o },
  { PPC::OR, PPC::ORo },
  { PPC::OR8, PPC::OR8o },
  { PPC::ORC, PPC::ORCo },
  { PPC::ORC8, PPC::ORC8o },
  { PPC::RLDCL, PPC::RLDCLo },
  { PPC::RLDCR, PPC::RLDCRo },
  { PPC::RLDIC, PPC::RLDICo },
  { PPC::RLDICL, PPC::RLDICLo },
  { PPC::RLDICL_32, PPC::RLDICL_32o },
  { PPC::RLDICR, PPC::RLDICRo },
  { PPC::RLDIMI, PPC::RLDIMIo },
  { PPC::RLWIMI, PPC::RLWIMIo },
  { PPC::RLWIMI8, PPC::RLWIMI8o },
  { PPC::RLWINM, PPC::RLWINMo },
  { PPC::RLWINM8, PPC::RLWINM8o },
  { PPC::RLWNM, PPC::RLWNMo },
  { PPC::RLWNM8, PPC::RLWNM8o },
  { PPC::SLD, PPC::SLDo },
  { PPC::SLW, PPC::SLWo },
  { PPC::SLW8, PPC::SLW8o },
  { PPC::SRAD, PPC::SRADo },
  { PPC::SRADI, PPC::SRADIo },
  { PPC::SRAW, PPC::SRAWo },
  { PPC::SRAWI, PPC::SRAWIo },
  { PPC::SRD, PPC::SRDo },
  { PPC::SRW, PPC::SRWo },
  { PPC::SRW8, PPC::SRW8o },
  { PPC::SUBF, PPC::SUBFo },
  { PPC::SUBF8, PPC::SUBF8o },
  { PPC::SUBFC, PPC::SUBFCo },
  { PPC::SUBFC8, PPC::SUBFC8o },
  { PPC::SUBFE, PPC::SUBFEo },
  { PPC::SUBFE8, PPC::SUBFE8o },
  { PPC::SUBFME, PPC::SUBFMEo },
  { PPC::SUBFME8, PPC::SUBFME8o },
  { PPC::SUBFZE, PPC::SUBFZEo },
  { PPC::SUBFZE8, PPC::SUBFZE8o },
  { PPC::XOR, PPC::XORo },
  { PPC::XOR8, PPC::XOR8o },
}; // End of getRecordFormOpcodeTable

  unsigned mid;
  unsigned start = 0;
  unsigned end = 140;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == getRecordFormOpcodeTable[mid][0]) {
      break;
    }
    if (Opcode < getRecordFormOpcodeTable[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  return getRecordFormOpcodeTable[mid][1];
}

} // End PPC namespace
} // End llvm namespace
#endif // GET_INSTRMAP_INFO

