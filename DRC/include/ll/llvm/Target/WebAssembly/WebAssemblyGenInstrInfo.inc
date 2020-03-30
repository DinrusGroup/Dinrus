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

namespace WebAssembly {
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
    CATCHRET	= 164,
    CATCHRET_S	= 165,
    CLEANUPRET	= 166,
    CLEANUPRET_S	= 167,
    COMPILER_FENCE	= 168,
    COMPILER_FENCE_S	= 169,
    RETHROW_IN_CATCH	= 170,
    RETHROW_IN_CATCH_S	= 171,
    ABS_F32	= 172,
    ABS_F32_S	= 173,
    ABS_F64	= 174,
    ABS_F64_S	= 175,
    ABS_v2f64	= 176,
    ABS_v2f64_S	= 177,
    ABS_v4f32	= 178,
    ABS_v4f32_S	= 179,
    ADD_F32	= 180,
    ADD_F32_S	= 181,
    ADD_F64	= 182,
    ADD_F64_S	= 183,
    ADD_I32	= 184,
    ADD_I32_S	= 185,
    ADD_I64	= 186,
    ADD_I64_S	= 187,
    ADD_SAT_S_v16i8	= 188,
    ADD_SAT_S_v16i8_S	= 189,
    ADD_SAT_S_v8i16	= 190,
    ADD_SAT_S_v8i16_S	= 191,
    ADD_SAT_U_v16i8	= 192,
    ADD_SAT_U_v16i8_S	= 193,
    ADD_SAT_U_v8i16	= 194,
    ADD_SAT_U_v8i16_S	= 195,
    ADD_v16i8	= 196,
    ADD_v16i8_S	= 197,
    ADD_v2f64	= 198,
    ADD_v2f64_S	= 199,
    ADD_v2i64	= 200,
    ADD_v2i64_S	= 201,
    ADD_v4f32	= 202,
    ADD_v4f32_S	= 203,
    ADD_v4i32	= 204,
    ADD_v4i32_S	= 205,
    ADD_v8i16	= 206,
    ADD_v8i16_S	= 207,
    ADJCALLSTACKDOWN	= 208,
    ADJCALLSTACKDOWN_S	= 209,
    ADJCALLSTACKUP	= 210,
    ADJCALLSTACKUP_S	= 211,
    ALLTRUE_v16i8	= 212,
    ALLTRUE_v16i8_S	= 213,
    ALLTRUE_v2i64	= 214,
    ALLTRUE_v2i64_S	= 215,
    ALLTRUE_v4i32	= 216,
    ALLTRUE_v4i32_S	= 217,
    ALLTRUE_v8i16	= 218,
    ALLTRUE_v8i16_S	= 219,
    AND_I32	= 220,
    AND_I32_S	= 221,
    AND_I64	= 222,
    AND_I64_S	= 223,
    AND_v16i8	= 224,
    AND_v16i8_S	= 225,
    AND_v2i64	= 226,
    AND_v2i64_S	= 227,
    AND_v4i32	= 228,
    AND_v4i32_S	= 229,
    AND_v8i16	= 230,
    AND_v8i16_S	= 231,
    ANYTRUE_v16i8	= 232,
    ANYTRUE_v16i8_S	= 233,
    ANYTRUE_v2i64	= 234,
    ANYTRUE_v2i64_S	= 235,
    ANYTRUE_v4i32	= 236,
    ANYTRUE_v4i32_S	= 237,
    ANYTRUE_v8i16	= 238,
    ANYTRUE_v8i16_S	= 239,
    ARGUMENT_exnref	= 240,
    ARGUMENT_exnref_S	= 241,
    ARGUMENT_f32	= 242,
    ARGUMENT_f32_S	= 243,
    ARGUMENT_f64	= 244,
    ARGUMENT_f64_S	= 245,
    ARGUMENT_i32	= 246,
    ARGUMENT_i32_S	= 247,
    ARGUMENT_i64	= 248,
    ARGUMENT_i64_S	= 249,
    ARGUMENT_v16i8	= 250,
    ARGUMENT_v16i8_S	= 251,
    ARGUMENT_v2f64	= 252,
    ARGUMENT_v2f64_S	= 253,
    ARGUMENT_v2i64	= 254,
    ARGUMENT_v2i64_S	= 255,
    ARGUMENT_v4f32	= 256,
    ARGUMENT_v4f32_S	= 257,
    ARGUMENT_v4i32	= 258,
    ARGUMENT_v4i32_S	= 259,
    ARGUMENT_v8i16	= 260,
    ARGUMENT_v8i16_S	= 261,
    ATOMIC_LOAD16_U_I32	= 262,
    ATOMIC_LOAD16_U_I32_S	= 263,
    ATOMIC_LOAD16_U_I64	= 264,
    ATOMIC_LOAD16_U_I64_S	= 265,
    ATOMIC_LOAD32_U_I64	= 266,
    ATOMIC_LOAD32_U_I64_S	= 267,
    ATOMIC_LOAD8_U_I32	= 268,
    ATOMIC_LOAD8_U_I32_S	= 269,
    ATOMIC_LOAD8_U_I64	= 270,
    ATOMIC_LOAD8_U_I64_S	= 271,
    ATOMIC_LOAD_I32	= 272,
    ATOMIC_LOAD_I32_S	= 273,
    ATOMIC_LOAD_I64	= 274,
    ATOMIC_LOAD_I64_S	= 275,
    ATOMIC_NOTIFY	= 276,
    ATOMIC_NOTIFY_S	= 277,
    ATOMIC_RMW16_U_ADD_I32	= 278,
    ATOMIC_RMW16_U_ADD_I32_S	= 279,
    ATOMIC_RMW16_U_ADD_I64	= 280,
    ATOMIC_RMW16_U_ADD_I64_S	= 281,
    ATOMIC_RMW16_U_AND_I32	= 282,
    ATOMIC_RMW16_U_AND_I32_S	= 283,
    ATOMIC_RMW16_U_AND_I64	= 284,
    ATOMIC_RMW16_U_AND_I64_S	= 285,
    ATOMIC_RMW16_U_CMPXCHG_I32	= 286,
    ATOMIC_RMW16_U_CMPXCHG_I32_S	= 287,
    ATOMIC_RMW16_U_CMPXCHG_I64	= 288,
    ATOMIC_RMW16_U_CMPXCHG_I64_S	= 289,
    ATOMIC_RMW16_U_OR_I32	= 290,
    ATOMIC_RMW16_U_OR_I32_S	= 291,
    ATOMIC_RMW16_U_OR_I64	= 292,
    ATOMIC_RMW16_U_OR_I64_S	= 293,
    ATOMIC_RMW16_U_SUB_I32	= 294,
    ATOMIC_RMW16_U_SUB_I32_S	= 295,
    ATOMIC_RMW16_U_SUB_I64	= 296,
    ATOMIC_RMW16_U_SUB_I64_S	= 297,
    ATOMIC_RMW16_U_XCHG_I32	= 298,
    ATOMIC_RMW16_U_XCHG_I32_S	= 299,
    ATOMIC_RMW16_U_XCHG_I64	= 300,
    ATOMIC_RMW16_U_XCHG_I64_S	= 301,
    ATOMIC_RMW16_U_XOR_I32	= 302,
    ATOMIC_RMW16_U_XOR_I32_S	= 303,
    ATOMIC_RMW16_U_XOR_I64	= 304,
    ATOMIC_RMW16_U_XOR_I64_S	= 305,
    ATOMIC_RMW32_U_ADD_I64	= 306,
    ATOMIC_RMW32_U_ADD_I64_S	= 307,
    ATOMIC_RMW32_U_AND_I64	= 308,
    ATOMIC_RMW32_U_AND_I64_S	= 309,
    ATOMIC_RMW32_U_CMPXCHG_I64	= 310,
    ATOMIC_RMW32_U_CMPXCHG_I64_S	= 311,
    ATOMIC_RMW32_U_OR_I64	= 312,
    ATOMIC_RMW32_U_OR_I64_S	= 313,
    ATOMIC_RMW32_U_SUB_I64	= 314,
    ATOMIC_RMW32_U_SUB_I64_S	= 315,
    ATOMIC_RMW32_U_XCHG_I64	= 316,
    ATOMIC_RMW32_U_XCHG_I64_S	= 317,
    ATOMIC_RMW32_U_XOR_I64	= 318,
    ATOMIC_RMW32_U_XOR_I64_S	= 319,
    ATOMIC_RMW8_U_ADD_I32	= 320,
    ATOMIC_RMW8_U_ADD_I32_S	= 321,
    ATOMIC_RMW8_U_ADD_I64	= 322,
    ATOMIC_RMW8_U_ADD_I64_S	= 323,
    ATOMIC_RMW8_U_AND_I32	= 324,
    ATOMIC_RMW8_U_AND_I32_S	= 325,
    ATOMIC_RMW8_U_AND_I64	= 326,
    ATOMIC_RMW8_U_AND_I64_S	= 327,
    ATOMIC_RMW8_U_CMPXCHG_I32	= 328,
    ATOMIC_RMW8_U_CMPXCHG_I32_S	= 329,
    ATOMIC_RMW8_U_CMPXCHG_I64	= 330,
    ATOMIC_RMW8_U_CMPXCHG_I64_S	= 331,
    ATOMIC_RMW8_U_OR_I32	= 332,
    ATOMIC_RMW8_U_OR_I32_S	= 333,
    ATOMIC_RMW8_U_OR_I64	= 334,
    ATOMIC_RMW8_U_OR_I64_S	= 335,
    ATOMIC_RMW8_U_SUB_I32	= 336,
    ATOMIC_RMW8_U_SUB_I32_S	= 337,
    ATOMIC_RMW8_U_SUB_I64	= 338,
    ATOMIC_RMW8_U_SUB_I64_S	= 339,
    ATOMIC_RMW8_U_XCHG_I32	= 340,
    ATOMIC_RMW8_U_XCHG_I32_S	= 341,
    ATOMIC_RMW8_U_XCHG_I64	= 342,
    ATOMIC_RMW8_U_XCHG_I64_S	= 343,
    ATOMIC_RMW8_U_XOR_I32	= 344,
    ATOMIC_RMW8_U_XOR_I32_S	= 345,
    ATOMIC_RMW8_U_XOR_I64	= 346,
    ATOMIC_RMW8_U_XOR_I64_S	= 347,
    ATOMIC_RMW_ADD_I32	= 348,
    ATOMIC_RMW_ADD_I32_S	= 349,
    ATOMIC_RMW_ADD_I64	= 350,
    ATOMIC_RMW_ADD_I64_S	= 351,
    ATOMIC_RMW_AND_I32	= 352,
    ATOMIC_RMW_AND_I32_S	= 353,
    ATOMIC_RMW_AND_I64	= 354,
    ATOMIC_RMW_AND_I64_S	= 355,
    ATOMIC_RMW_CMPXCHG_I32	= 356,
    ATOMIC_RMW_CMPXCHG_I32_S	= 357,
    ATOMIC_RMW_CMPXCHG_I64	= 358,
    ATOMIC_RMW_CMPXCHG_I64_S	= 359,
    ATOMIC_RMW_OR_I32	= 360,
    ATOMIC_RMW_OR_I32_S	= 361,
    ATOMIC_RMW_OR_I64	= 362,
    ATOMIC_RMW_OR_I64_S	= 363,
    ATOMIC_RMW_SUB_I32	= 364,
    ATOMIC_RMW_SUB_I32_S	= 365,
    ATOMIC_RMW_SUB_I64	= 366,
    ATOMIC_RMW_SUB_I64_S	= 367,
    ATOMIC_RMW_XCHG_I32	= 368,
    ATOMIC_RMW_XCHG_I32_S	= 369,
    ATOMIC_RMW_XCHG_I64	= 370,
    ATOMIC_RMW_XCHG_I64_S	= 371,
    ATOMIC_RMW_XOR_I32	= 372,
    ATOMIC_RMW_XOR_I32_S	= 373,
    ATOMIC_RMW_XOR_I64	= 374,
    ATOMIC_RMW_XOR_I64_S	= 375,
    ATOMIC_STORE16_I32	= 376,
    ATOMIC_STORE16_I32_S	= 377,
    ATOMIC_STORE16_I64	= 378,
    ATOMIC_STORE16_I64_S	= 379,
    ATOMIC_STORE32_I64	= 380,
    ATOMIC_STORE32_I64_S	= 381,
    ATOMIC_STORE8_I32	= 382,
    ATOMIC_STORE8_I32_S	= 383,
    ATOMIC_STORE8_I64	= 384,
    ATOMIC_STORE8_I64_S	= 385,
    ATOMIC_STORE_I32	= 386,
    ATOMIC_STORE_I32_S	= 387,
    ATOMIC_STORE_I64	= 388,
    ATOMIC_STORE_I64_S	= 389,
    ATOMIC_WAIT_I32	= 390,
    ATOMIC_WAIT_I32_S	= 391,
    ATOMIC_WAIT_I64	= 392,
    ATOMIC_WAIT_I64_S	= 393,
    BITSELECT_v16i8	= 394,
    BITSELECT_v16i8_S	= 395,
    BITSELECT_v2f64	= 396,
    BITSELECT_v2f64_S	= 397,
    BITSELECT_v2i64	= 398,
    BITSELECT_v2i64_S	= 399,
    BITSELECT_v4f32	= 400,
    BITSELECT_v4f32_S	= 401,
    BITSELECT_v4i32	= 402,
    BITSELECT_v4i32_S	= 403,
    BITSELECT_v8i16	= 404,
    BITSELECT_v8i16_S	= 405,
    BLOCK	= 406,
    BLOCK_S	= 407,
    BR	= 408,
    BR_IF	= 409,
    BR_IF_S	= 410,
    BR_ON_EXN	= 411,
    BR_ON_EXN_S	= 412,
    BR_S	= 413,
    BR_TABLE_I32	= 414,
    BR_TABLE_I32_S	= 415,
    BR_TABLE_I64	= 416,
    BR_TABLE_I64_S	= 417,
    BR_UNLESS	= 418,
    BR_UNLESS_S	= 419,
    CALL_INDIRECT_VOID	= 420,
    CALL_INDIRECT_VOID_S	= 421,
    CALL_INDIRECT_exnref	= 422,
    CALL_INDIRECT_exnref_S	= 423,
    CALL_INDIRECT_f32	= 424,
    CALL_INDIRECT_f32_S	= 425,
    CALL_INDIRECT_f64	= 426,
    CALL_INDIRECT_f64_S	= 427,
    CALL_INDIRECT_i32	= 428,
    CALL_INDIRECT_i32_S	= 429,
    CALL_INDIRECT_i64	= 430,
    CALL_INDIRECT_i64_S	= 431,
    CALL_INDIRECT_v16i8	= 432,
    CALL_INDIRECT_v16i8_S	= 433,
    CALL_INDIRECT_v2f64	= 434,
    CALL_INDIRECT_v2f64_S	= 435,
    CALL_INDIRECT_v2i64	= 436,
    CALL_INDIRECT_v2i64_S	= 437,
    CALL_INDIRECT_v4f32	= 438,
    CALL_INDIRECT_v4f32_S	= 439,
    CALL_INDIRECT_v4i32	= 440,
    CALL_INDIRECT_v4i32_S	= 441,
    CALL_INDIRECT_v8i16	= 442,
    CALL_INDIRECT_v8i16_S	= 443,
    CALL_VOID	= 444,
    CALL_VOID_S	= 445,
    CALL_exnref	= 446,
    CALL_exnref_S	= 447,
    CALL_f32	= 448,
    CALL_f32_S	= 449,
    CALL_f64	= 450,
    CALL_f64_S	= 451,
    CALL_i32	= 452,
    CALL_i32_S	= 453,
    CALL_i64	= 454,
    CALL_i64_S	= 455,
    CALL_v16i8	= 456,
    CALL_v16i8_S	= 457,
    CALL_v2f64	= 458,
    CALL_v2f64_S	= 459,
    CALL_v2i64	= 460,
    CALL_v2i64_S	= 461,
    CALL_v4f32	= 462,
    CALL_v4f32_S	= 463,
    CALL_v4i32	= 464,
    CALL_v4i32_S	= 465,
    CALL_v8i16	= 466,
    CALL_v8i16_S	= 467,
    CATCH	= 468,
    CATCH_S	= 469,
    CEIL_F32	= 470,
    CEIL_F32_S	= 471,
    CEIL_F64	= 472,
    CEIL_F64_S	= 473,
    CLZ_I32	= 474,
    CLZ_I32_S	= 475,
    CLZ_I64	= 476,
    CLZ_I64_S	= 477,
    CONST_F32	= 478,
    CONST_F32_S	= 479,
    CONST_F64	= 480,
    CONST_F64_S	= 481,
    CONST_I32	= 482,
    CONST_I32_S	= 483,
    CONST_I64	= 484,
    CONST_I64_S	= 485,
    CONST_V128_v16i8	= 486,
    CONST_V128_v16i8_S	= 487,
    CONST_V128_v2f64	= 488,
    CONST_V128_v2f64_S	= 489,
    CONST_V128_v2i64	= 490,
    CONST_V128_v2i64_S	= 491,
    CONST_V128_v4f32	= 492,
    CONST_V128_v4f32_S	= 493,
    CONST_V128_v4i32	= 494,
    CONST_V128_v4i32_S	= 495,
    CONST_V128_v8i16	= 496,
    CONST_V128_v8i16_S	= 497,
    COPYSIGN_F32	= 498,
    COPYSIGN_F32_S	= 499,
    COPYSIGN_F64	= 500,
    COPYSIGN_F64_S	= 501,
    COPY_EXNREF	= 502,
    COPY_EXNREF_S	= 503,
    COPY_F32	= 504,
    COPY_F32_S	= 505,
    COPY_F64	= 506,
    COPY_F64_S	= 507,
    COPY_I32	= 508,
    COPY_I32_S	= 509,
    COPY_I64	= 510,
    COPY_I64_S	= 511,
    COPY_V128	= 512,
    COPY_V128_S	= 513,
    CTZ_I32	= 514,
    CTZ_I32_S	= 515,
    CTZ_I64	= 516,
    CTZ_I64_S	= 517,
    DATA_DROP	= 518,
    DATA_DROP_S	= 519,
    DIV_F32	= 520,
    DIV_F32_S	= 521,
    DIV_F64	= 522,
    DIV_F64_S	= 523,
    DIV_S_I32	= 524,
    DIV_S_I32_S	= 525,
    DIV_S_I64	= 526,
    DIV_S_I64_S	= 527,
    DIV_U_I32	= 528,
    DIV_U_I32_S	= 529,
    DIV_U_I64	= 530,
    DIV_U_I64_S	= 531,
    DIV_v2f64	= 532,
    DIV_v2f64_S	= 533,
    DIV_v4f32	= 534,
    DIV_v4f32_S	= 535,
    DROP_EXNREF	= 536,
    DROP_EXNREF_S	= 537,
    DROP_F32	= 538,
    DROP_F32_S	= 539,
    DROP_F64	= 540,
    DROP_F64_S	= 541,
    DROP_I32	= 542,
    DROP_I32_S	= 543,
    DROP_I64	= 544,
    DROP_I64_S	= 545,
    DROP_V128	= 546,
    DROP_V128_S	= 547,
    ELSE	= 548,
    ELSE_S	= 549,
    END	= 550,
    END_BLOCK	= 551,
    END_BLOCK_S	= 552,
    END_FUNCTION	= 553,
    END_FUNCTION_S	= 554,
    END_IF	= 555,
    END_IF_S	= 556,
    END_LOOP	= 557,
    END_LOOP_S	= 558,
    END_S	= 559,
    END_TRY	= 560,
    END_TRY_S	= 561,
    EQZ_I32	= 562,
    EQZ_I32_S	= 563,
    EQZ_I64	= 564,
    EQZ_I64_S	= 565,
    EQ_F32	= 566,
    EQ_F32_S	= 567,
    EQ_F64	= 568,
    EQ_F64_S	= 569,
    EQ_I32	= 570,
    EQ_I32_S	= 571,
    EQ_I64	= 572,
    EQ_I64_S	= 573,
    EQ_v16i8	= 574,
    EQ_v16i8_S	= 575,
    EQ_v2f64	= 576,
    EQ_v2f64_S	= 577,
    EQ_v4f32	= 578,
    EQ_v4f32_S	= 579,
    EQ_v4i32	= 580,
    EQ_v4i32_S	= 581,
    EQ_v8i16	= 582,
    EQ_v8i16_S	= 583,
    EXTRACT_EXCEPTION_I32	= 584,
    EXTRACT_EXCEPTION_I32_S	= 585,
    EXTRACT_LANE_v16i8_s	= 586,
    EXTRACT_LANE_v16i8_s_S	= 587,
    EXTRACT_LANE_v16i8_u	= 588,
    EXTRACT_LANE_v16i8_u_S	= 589,
    EXTRACT_LANE_v2f64	= 590,
    EXTRACT_LANE_v2f64_S	= 591,
    EXTRACT_LANE_v2i64	= 592,
    EXTRACT_LANE_v2i64_S	= 593,
    EXTRACT_LANE_v4f32	= 594,
    EXTRACT_LANE_v4f32_S	= 595,
    EXTRACT_LANE_v4i32	= 596,
    EXTRACT_LANE_v4i32_S	= 597,
    EXTRACT_LANE_v8i16_s	= 598,
    EXTRACT_LANE_v8i16_s_S	= 599,
    EXTRACT_LANE_v8i16_u	= 600,
    EXTRACT_LANE_v8i16_u_S	= 601,
    F32_CONVERT_S_I32	= 602,
    F32_CONVERT_S_I32_S	= 603,
    F32_CONVERT_S_I64	= 604,
    F32_CONVERT_S_I64_S	= 605,
    F32_CONVERT_U_I32	= 606,
    F32_CONVERT_U_I32_S	= 607,
    F32_CONVERT_U_I64	= 608,
    F32_CONVERT_U_I64_S	= 609,
    F32_DEMOTE_F64	= 610,
    F32_DEMOTE_F64_S	= 611,
    F32_REINTERPRET_I32	= 612,
    F32_REINTERPRET_I32_S	= 613,
    F64_CONVERT_S_I32	= 614,
    F64_CONVERT_S_I32_S	= 615,
    F64_CONVERT_S_I64	= 616,
    F64_CONVERT_S_I64_S	= 617,
    F64_CONVERT_U_I32	= 618,
    F64_CONVERT_U_I32_S	= 619,
    F64_CONVERT_U_I64	= 620,
    F64_CONVERT_U_I64_S	= 621,
    F64_PROMOTE_F32	= 622,
    F64_PROMOTE_F32_S	= 623,
    F64_REINTERPRET_I64	= 624,
    F64_REINTERPRET_I64_S	= 625,
    FALLTHROUGH_RETURN_EXNREF	= 626,
    FALLTHROUGH_RETURN_EXNREF_S	= 627,
    FALLTHROUGH_RETURN_F32	= 628,
    FALLTHROUGH_RETURN_F32_S	= 629,
    FALLTHROUGH_RETURN_F64	= 630,
    FALLTHROUGH_RETURN_F64_S	= 631,
    FALLTHROUGH_RETURN_I32	= 632,
    FALLTHROUGH_RETURN_I32_S	= 633,
    FALLTHROUGH_RETURN_I64	= 634,
    FALLTHROUGH_RETURN_I64_S	= 635,
    FALLTHROUGH_RETURN_VOID	= 636,
    FALLTHROUGH_RETURN_VOID_S	= 637,
    FALLTHROUGH_RETURN_v16i8	= 638,
    FALLTHROUGH_RETURN_v16i8_S	= 639,
    FALLTHROUGH_RETURN_v2f64	= 640,
    FALLTHROUGH_RETURN_v2f64_S	= 641,
    FALLTHROUGH_RETURN_v2i64	= 642,
    FALLTHROUGH_RETURN_v2i64_S	= 643,
    FALLTHROUGH_RETURN_v4f32	= 644,
    FALLTHROUGH_RETURN_v4f32_S	= 645,
    FALLTHROUGH_RETURN_v4i32	= 646,
    FALLTHROUGH_RETURN_v4i32_S	= 647,
    FALLTHROUGH_RETURN_v8i16	= 648,
    FALLTHROUGH_RETURN_v8i16_S	= 649,
    FLOOR_F32	= 650,
    FLOOR_F32_S	= 651,
    FLOOR_F64	= 652,
    FLOOR_F64_S	= 653,
    FP_TO_SINT_I32_F32	= 654,
    FP_TO_SINT_I32_F32_S	= 655,
    FP_TO_SINT_I32_F64	= 656,
    FP_TO_SINT_I32_F64_S	= 657,
    FP_TO_SINT_I64_F32	= 658,
    FP_TO_SINT_I64_F32_S	= 659,
    FP_TO_SINT_I64_F64	= 660,
    FP_TO_SINT_I64_F64_S	= 661,
    FP_TO_UINT_I32_F32	= 662,
    FP_TO_UINT_I32_F32_S	= 663,
    FP_TO_UINT_I32_F64	= 664,
    FP_TO_UINT_I32_F64_S	= 665,
    FP_TO_UINT_I64_F32	= 666,
    FP_TO_UINT_I64_F32_S	= 667,
    FP_TO_UINT_I64_F64	= 668,
    FP_TO_UINT_I64_F64_S	= 669,
    GE_F32	= 670,
    GE_F32_S	= 671,
    GE_F64	= 672,
    GE_F64_S	= 673,
    GE_S_I32	= 674,
    GE_S_I32_S	= 675,
    GE_S_I64	= 676,
    GE_S_I64_S	= 677,
    GE_S_v16i8	= 678,
    GE_S_v16i8_S	= 679,
    GE_S_v4i32	= 680,
    GE_S_v4i32_S	= 681,
    GE_S_v8i16	= 682,
    GE_S_v8i16_S	= 683,
    GE_U_I32	= 684,
    GE_U_I32_S	= 685,
    GE_U_I64	= 686,
    GE_U_I64_S	= 687,
    GE_U_v16i8	= 688,
    GE_U_v16i8_S	= 689,
    GE_U_v4i32	= 690,
    GE_U_v4i32_S	= 691,
    GE_U_v8i16	= 692,
    GE_U_v8i16_S	= 693,
    GE_v2f64	= 694,
    GE_v2f64_S	= 695,
    GE_v4f32	= 696,
    GE_v4f32_S	= 697,
    GLOBAL_GET_EXNREF	= 698,
    GLOBAL_GET_EXNREF_S	= 699,
    GLOBAL_GET_F32	= 700,
    GLOBAL_GET_F32_S	= 701,
    GLOBAL_GET_F64	= 702,
    GLOBAL_GET_F64_S	= 703,
    GLOBAL_GET_I32	= 704,
    GLOBAL_GET_I32_S	= 705,
    GLOBAL_GET_I64	= 706,
    GLOBAL_GET_I64_S	= 707,
    GLOBAL_GET_V128	= 708,
    GLOBAL_GET_V128_S	= 709,
    GLOBAL_SET_EXNREF	= 710,
    GLOBAL_SET_EXNREF_S	= 711,
    GLOBAL_SET_F32	= 712,
    GLOBAL_SET_F32_S	= 713,
    GLOBAL_SET_F64	= 714,
    GLOBAL_SET_F64_S	= 715,
    GLOBAL_SET_I32	= 716,
    GLOBAL_SET_I32_S	= 717,
    GLOBAL_SET_I64	= 718,
    GLOBAL_SET_I64_S	= 719,
    GLOBAL_SET_V128	= 720,
    GLOBAL_SET_V128_S	= 721,
    GT_F32	= 722,
    GT_F32_S	= 723,
    GT_F64	= 724,
    GT_F64_S	= 725,
    GT_S_I32	= 726,
    GT_S_I32_S	= 727,
    GT_S_I64	= 728,
    GT_S_I64_S	= 729,
    GT_S_v16i8	= 730,
    GT_S_v16i8_S	= 731,
    GT_S_v4i32	= 732,
    GT_S_v4i32_S	= 733,
    GT_S_v8i16	= 734,
    GT_S_v8i16_S	= 735,
    GT_U_I32	= 736,
    GT_U_I32_S	= 737,
    GT_U_I64	= 738,
    GT_U_I64_S	= 739,
    GT_U_v16i8	= 740,
    GT_U_v16i8_S	= 741,
    GT_U_v4i32	= 742,
    GT_U_v4i32_S	= 743,
    GT_U_v8i16	= 744,
    GT_U_v8i16_S	= 745,
    GT_v2f64	= 746,
    GT_v2f64_S	= 747,
    GT_v4f32	= 748,
    GT_v4f32_S	= 749,
    I32_EXTEND16_S_I32	= 750,
    I32_EXTEND16_S_I32_S	= 751,
    I32_EXTEND8_S_I32	= 752,
    I32_EXTEND8_S_I32_S	= 753,
    I32_REINTERPRET_F32	= 754,
    I32_REINTERPRET_F32_S	= 755,
    I32_TRUNC_S_F32	= 756,
    I32_TRUNC_S_F32_S	= 757,
    I32_TRUNC_S_F64	= 758,
    I32_TRUNC_S_F64_S	= 759,
    I32_TRUNC_S_SAT_F32	= 760,
    I32_TRUNC_S_SAT_F32_S	= 761,
    I32_TRUNC_S_SAT_F64	= 762,
    I32_TRUNC_S_SAT_F64_S	= 763,
    I32_TRUNC_U_F32	= 764,
    I32_TRUNC_U_F32_S	= 765,
    I32_TRUNC_U_F64	= 766,
    I32_TRUNC_U_F64_S	= 767,
    I32_TRUNC_U_SAT_F32	= 768,
    I32_TRUNC_U_SAT_F32_S	= 769,
    I32_TRUNC_U_SAT_F64	= 770,
    I32_TRUNC_U_SAT_F64_S	= 771,
    I32_WRAP_I64	= 772,
    I32_WRAP_I64_S	= 773,
    I64_EXTEND16_S_I64	= 774,
    I64_EXTEND16_S_I64_S	= 775,
    I64_EXTEND32_S_I64	= 776,
    I64_EXTEND32_S_I64_S	= 777,
    I64_EXTEND8_S_I64	= 778,
    I64_EXTEND8_S_I64_S	= 779,
    I64_EXTEND_S_I32	= 780,
    I64_EXTEND_S_I32_S	= 781,
    I64_EXTEND_U_I32	= 782,
    I64_EXTEND_U_I32_S	= 783,
    I64_REINTERPRET_F64	= 784,
    I64_REINTERPRET_F64_S	= 785,
    I64_TRUNC_S_F32	= 786,
    I64_TRUNC_S_F32_S	= 787,
    I64_TRUNC_S_F64	= 788,
    I64_TRUNC_S_F64_S	= 789,
    I64_TRUNC_S_SAT_F32	= 790,
    I64_TRUNC_S_SAT_F32_S	= 791,
    I64_TRUNC_S_SAT_F64	= 792,
    I64_TRUNC_S_SAT_F64_S	= 793,
    I64_TRUNC_U_F32	= 794,
    I64_TRUNC_U_F32_S	= 795,
    I64_TRUNC_U_F64	= 796,
    I64_TRUNC_U_F64_S	= 797,
    I64_TRUNC_U_SAT_F32	= 798,
    I64_TRUNC_U_SAT_F32_S	= 799,
    I64_TRUNC_U_SAT_F64	= 800,
    I64_TRUNC_U_SAT_F64_S	= 801,
    IF	= 802,
    IF_S	= 803,
    LE_F32	= 804,
    LE_F32_S	= 805,
    LE_F64	= 806,
    LE_F64_S	= 807,
    LE_S_I32	= 808,
    LE_S_I32_S	= 809,
    LE_S_I64	= 810,
    LE_S_I64_S	= 811,
    LE_S_v16i8	= 812,
    LE_S_v16i8_S	= 813,
    LE_S_v4i32	= 814,
    LE_S_v4i32_S	= 815,
    LE_S_v8i16	= 816,
    LE_S_v8i16_S	= 817,
    LE_U_I32	= 818,
    LE_U_I32_S	= 819,
    LE_U_I64	= 820,
    LE_U_I64_S	= 821,
    LE_U_v16i8	= 822,
    LE_U_v16i8_S	= 823,
    LE_U_v4i32	= 824,
    LE_U_v4i32_S	= 825,
    LE_U_v8i16	= 826,
    LE_U_v8i16_S	= 827,
    LE_v2f64	= 828,
    LE_v2f64_S	= 829,
    LE_v4f32	= 830,
    LE_v4f32_S	= 831,
    LOAD16_S_I32	= 832,
    LOAD16_S_I32_S	= 833,
    LOAD16_S_I64	= 834,
    LOAD16_S_I64_S	= 835,
    LOAD16_U_I32	= 836,
    LOAD16_U_I32_S	= 837,
    LOAD16_U_I64	= 838,
    LOAD16_U_I64_S	= 839,
    LOAD32_S_I64	= 840,
    LOAD32_S_I64_S	= 841,
    LOAD32_U_I64	= 842,
    LOAD32_U_I64_S	= 843,
    LOAD8_S_I32	= 844,
    LOAD8_S_I32_S	= 845,
    LOAD8_S_I64	= 846,
    LOAD8_S_I64_S	= 847,
    LOAD8_U_I32	= 848,
    LOAD8_U_I32_S	= 849,
    LOAD8_U_I64	= 850,
    LOAD8_U_I64_S	= 851,
    LOAD_F32	= 852,
    LOAD_F32_S	= 853,
    LOAD_F64	= 854,
    LOAD_F64_S	= 855,
    LOAD_I32	= 856,
    LOAD_I32_S	= 857,
    LOAD_I64	= 858,
    LOAD_I64_S	= 859,
    LOAD_v16i8	= 860,
    LOAD_v16i8_S	= 861,
    LOAD_v2f64	= 862,
    LOAD_v2f64_S	= 863,
    LOAD_v2i64	= 864,
    LOAD_v2i64_S	= 865,
    LOAD_v4f32	= 866,
    LOAD_v4f32_S	= 867,
    LOAD_v4i32	= 868,
    LOAD_v4i32_S	= 869,
    LOAD_v8i16	= 870,
    LOAD_v8i16_S	= 871,
    LOCAL_GET_EXNREF	= 872,
    LOCAL_GET_EXNREF_S	= 873,
    LOCAL_GET_F32	= 874,
    LOCAL_GET_F32_S	= 875,
    LOCAL_GET_F64	= 876,
    LOCAL_GET_F64_S	= 877,
    LOCAL_GET_I32	= 878,
    LOCAL_GET_I32_S	= 879,
    LOCAL_GET_I64	= 880,
    LOCAL_GET_I64_S	= 881,
    LOCAL_GET_V128	= 882,
    LOCAL_GET_V128_S	= 883,
    LOCAL_SET_EXNREF	= 884,
    LOCAL_SET_EXNREF_S	= 885,
    LOCAL_SET_F32	= 886,
    LOCAL_SET_F32_S	= 887,
    LOCAL_SET_F64	= 888,
    LOCAL_SET_F64_S	= 889,
    LOCAL_SET_I32	= 890,
    LOCAL_SET_I32_S	= 891,
    LOCAL_SET_I64	= 892,
    LOCAL_SET_I64_S	= 893,
    LOCAL_SET_V128	= 894,
    LOCAL_SET_V128_S	= 895,
    LOCAL_TEE_EXNREF	= 896,
    LOCAL_TEE_EXNREF_S	= 897,
    LOCAL_TEE_F32	= 898,
    LOCAL_TEE_F32_S	= 899,
    LOCAL_TEE_F64	= 900,
    LOCAL_TEE_F64_S	= 901,
    LOCAL_TEE_I32	= 902,
    LOCAL_TEE_I32_S	= 903,
    LOCAL_TEE_I64	= 904,
    LOCAL_TEE_I64_S	= 905,
    LOCAL_TEE_V128	= 906,
    LOCAL_TEE_V128_S	= 907,
    LOOP	= 908,
    LOOP_S	= 909,
    LT_F32	= 910,
    LT_F32_S	= 911,
    LT_F64	= 912,
    LT_F64_S	= 913,
    LT_S_I32	= 914,
    LT_S_I32_S	= 915,
    LT_S_I64	= 916,
    LT_S_I64_S	= 917,
    LT_S_v16i8	= 918,
    LT_S_v16i8_S	= 919,
    LT_S_v4i32	= 920,
    LT_S_v4i32_S	= 921,
    LT_S_v8i16	= 922,
    LT_S_v8i16_S	= 923,
    LT_U_I32	= 924,
    LT_U_I32_S	= 925,
    LT_U_I64	= 926,
    LT_U_I64_S	= 927,
    LT_U_v16i8	= 928,
    LT_U_v16i8_S	= 929,
    LT_U_v4i32	= 930,
    LT_U_v4i32_S	= 931,
    LT_U_v8i16	= 932,
    LT_U_v8i16_S	= 933,
    LT_v2f64	= 934,
    LT_v2f64_S	= 935,
    LT_v4f32	= 936,
    LT_v4f32_S	= 937,
    MAX_F32	= 938,
    MAX_F32_S	= 939,
    MAX_F64	= 940,
    MAX_F64_S	= 941,
    MAX_v2f64	= 942,
    MAX_v2f64_S	= 943,
    MAX_v4f32	= 944,
    MAX_v4f32_S	= 945,
    MEMORY_COPY	= 946,
    MEMORY_COPY_S	= 947,
    MEMORY_FILL	= 948,
    MEMORY_FILL_S	= 949,
    MEMORY_GROW_I32	= 950,
    MEMORY_GROW_I32_S	= 951,
    MEMORY_INIT	= 952,
    MEMORY_INIT_S	= 953,
    MEMORY_SIZE_I32	= 954,
    MEMORY_SIZE_I32_S	= 955,
    MIN_F32	= 956,
    MIN_F32_S	= 957,
    MIN_F64	= 958,
    MIN_F64_S	= 959,
    MIN_v2f64	= 960,
    MIN_v2f64_S	= 961,
    MIN_v4f32	= 962,
    MIN_v4f32_S	= 963,
    MUL_F32	= 964,
    MUL_F32_S	= 965,
    MUL_F64	= 966,
    MUL_F64_S	= 967,
    MUL_I32	= 968,
    MUL_I32_S	= 969,
    MUL_I64	= 970,
    MUL_I64_S	= 971,
    MUL_v16i8	= 972,
    MUL_v16i8_S	= 973,
    MUL_v2f64	= 974,
    MUL_v2f64_S	= 975,
    MUL_v4f32	= 976,
    MUL_v4f32_S	= 977,
    MUL_v4i32	= 978,
    MUL_v4i32_S	= 979,
    MUL_v8i16	= 980,
    MUL_v8i16_S	= 981,
    NEAREST_F32	= 982,
    NEAREST_F32_S	= 983,
    NEAREST_F64	= 984,
    NEAREST_F64_S	= 985,
    NEG_F32	= 986,
    NEG_F32_S	= 987,
    NEG_F64	= 988,
    NEG_F64_S	= 989,
    NEG_v16i8	= 990,
    NEG_v16i8_S	= 991,
    NEG_v2f64	= 992,
    NEG_v2f64_S	= 993,
    NEG_v2i64	= 994,
    NEG_v2i64_S	= 995,
    NEG_v4f32	= 996,
    NEG_v4f32_S	= 997,
    NEG_v4i32	= 998,
    NEG_v4i32_S	= 999,
    NEG_v8i16	= 1000,
    NEG_v8i16_S	= 1001,
    NE_F32	= 1002,
    NE_F32_S	= 1003,
    NE_F64	= 1004,
    NE_F64_S	= 1005,
    NE_I32	= 1006,
    NE_I32_S	= 1007,
    NE_I64	= 1008,
    NE_I64_S	= 1009,
    NE_v16i8	= 1010,
    NE_v16i8_S	= 1011,
    NE_v2f64	= 1012,
    NE_v2f64_S	= 1013,
    NE_v4f32	= 1014,
    NE_v4f32_S	= 1015,
    NE_v4i32	= 1016,
    NE_v4i32_S	= 1017,
    NE_v8i16	= 1018,
    NE_v8i16_S	= 1019,
    NOP	= 1020,
    NOP_S	= 1021,
    NOT_v16i8	= 1022,
    NOT_v16i8_S	= 1023,
    NOT_v2i64	= 1024,
    NOT_v2i64_S	= 1025,
    NOT_v4i32	= 1026,
    NOT_v4i32_S	= 1027,
    NOT_v8i16	= 1028,
    NOT_v8i16_S	= 1029,
    OR_I32	= 1030,
    OR_I32_S	= 1031,
    OR_I64	= 1032,
    OR_I64_S	= 1033,
    OR_v16i8	= 1034,
    OR_v16i8_S	= 1035,
    OR_v2i64	= 1036,
    OR_v2i64_S	= 1037,
    OR_v4i32	= 1038,
    OR_v4i32_S	= 1039,
    OR_v8i16	= 1040,
    OR_v8i16_S	= 1041,
    PCALL_INDIRECT_VOID	= 1042,
    PCALL_INDIRECT_VOID_S	= 1043,
    PCALL_INDIRECT_exnref	= 1044,
    PCALL_INDIRECT_exnref_S	= 1045,
    PCALL_INDIRECT_f32	= 1046,
    PCALL_INDIRECT_f32_S	= 1047,
    PCALL_INDIRECT_f64	= 1048,
    PCALL_INDIRECT_f64_S	= 1049,
    PCALL_INDIRECT_i32	= 1050,
    PCALL_INDIRECT_i32_S	= 1051,
    PCALL_INDIRECT_i64	= 1052,
    PCALL_INDIRECT_i64_S	= 1053,
    PCALL_INDIRECT_v16i8	= 1054,
    PCALL_INDIRECT_v16i8_S	= 1055,
    PCALL_INDIRECT_v2f64	= 1056,
    PCALL_INDIRECT_v2f64_S	= 1057,
    PCALL_INDIRECT_v2i64	= 1058,
    PCALL_INDIRECT_v2i64_S	= 1059,
    PCALL_INDIRECT_v4f32	= 1060,
    PCALL_INDIRECT_v4f32_S	= 1061,
    PCALL_INDIRECT_v4i32	= 1062,
    PCALL_INDIRECT_v4i32_S	= 1063,
    PCALL_INDIRECT_v8i16	= 1064,
    PCALL_INDIRECT_v8i16_S	= 1065,
    POPCNT_I32	= 1066,
    POPCNT_I32_S	= 1067,
    POPCNT_I64	= 1068,
    POPCNT_I64_S	= 1069,
    PRET_CALL_INDIRECT	= 1070,
    PRET_CALL_INDIRECT_S	= 1071,
    REM_S_I32	= 1072,
    REM_S_I32_S	= 1073,
    REM_S_I64	= 1074,
    REM_S_I64_S	= 1075,
    REM_U_I32	= 1076,
    REM_U_I32_S	= 1077,
    REM_U_I64	= 1078,
    REM_U_I64_S	= 1079,
    REPLACE_LANE_v16i8	= 1080,
    REPLACE_LANE_v16i8_S	= 1081,
    REPLACE_LANE_v2f64	= 1082,
    REPLACE_LANE_v2f64_S	= 1083,
    REPLACE_LANE_v2i64	= 1084,
    REPLACE_LANE_v2i64_S	= 1085,
    REPLACE_LANE_v4f32	= 1086,
    REPLACE_LANE_v4f32_S	= 1087,
    REPLACE_LANE_v4i32	= 1088,
    REPLACE_LANE_v4i32_S	= 1089,
    REPLACE_LANE_v8i16	= 1090,
    REPLACE_LANE_v8i16_S	= 1091,
    RETHROW	= 1092,
    RETHROW_S	= 1093,
    RETURN_EXNREF	= 1094,
    RETURN_EXNREF_S	= 1095,
    RETURN_F32	= 1096,
    RETURN_F32_S	= 1097,
    RETURN_F64	= 1098,
    RETURN_F64_S	= 1099,
    RETURN_I32	= 1100,
    RETURN_I32_S	= 1101,
    RETURN_I64	= 1102,
    RETURN_I64_S	= 1103,
    RETURN_VOID	= 1104,
    RETURN_VOID_S	= 1105,
    RETURN_v16i8	= 1106,
    RETURN_v16i8_S	= 1107,
    RETURN_v2f64	= 1108,
    RETURN_v2f64_S	= 1109,
    RETURN_v2i64	= 1110,
    RETURN_v2i64_S	= 1111,
    RETURN_v4f32	= 1112,
    RETURN_v4f32_S	= 1113,
    RETURN_v4i32	= 1114,
    RETURN_v4i32_S	= 1115,
    RETURN_v8i16	= 1116,
    RETURN_v8i16_S	= 1117,
    RET_CALL	= 1118,
    RET_CALL_INDIRECT	= 1119,
    RET_CALL_INDIRECT_S	= 1120,
    RET_CALL_S	= 1121,
    ROTL_I32	= 1122,
    ROTL_I32_S	= 1123,
    ROTL_I64	= 1124,
    ROTL_I64_S	= 1125,
    ROTR_I32	= 1126,
    ROTR_I32_S	= 1127,
    ROTR_I64	= 1128,
    ROTR_I64_S	= 1129,
    SELECT_EXNREF	= 1130,
    SELECT_EXNREF_S	= 1131,
    SELECT_F32	= 1132,
    SELECT_F32_S	= 1133,
    SELECT_F64	= 1134,
    SELECT_F64_S	= 1135,
    SELECT_I32	= 1136,
    SELECT_I32_S	= 1137,
    SELECT_I64	= 1138,
    SELECT_I64_S	= 1139,
    SHL_I32	= 1140,
    SHL_I32_S	= 1141,
    SHL_I64	= 1142,
    SHL_I64_S	= 1143,
    SHL_v16i8	= 1144,
    SHL_v16i8_S	= 1145,
    SHL_v2i64	= 1146,
    SHL_v2i64_S	= 1147,
    SHL_v4i32	= 1148,
    SHL_v4i32_S	= 1149,
    SHL_v8i16	= 1150,
    SHL_v8i16_S	= 1151,
    SHR_S_I32	= 1152,
    SHR_S_I32_S	= 1153,
    SHR_S_I64	= 1154,
    SHR_S_I64_S	= 1155,
    SHR_S_v16i8	= 1156,
    SHR_S_v16i8_S	= 1157,
    SHR_S_v2i64	= 1158,
    SHR_S_v2i64_S	= 1159,
    SHR_S_v4i32	= 1160,
    SHR_S_v4i32_S	= 1161,
    SHR_S_v8i16	= 1162,
    SHR_S_v8i16_S	= 1163,
    SHR_U_I32	= 1164,
    SHR_U_I32_S	= 1165,
    SHR_U_I64	= 1166,
    SHR_U_I64_S	= 1167,
    SHR_U_v16i8	= 1168,
    SHR_U_v16i8_S	= 1169,
    SHR_U_v2i64	= 1170,
    SHR_U_v2i64_S	= 1171,
    SHR_U_v4i32	= 1172,
    SHR_U_v4i32_S	= 1173,
    SHR_U_v8i16	= 1174,
    SHR_U_v8i16_S	= 1175,
    SHUFFLE	= 1176,
    SHUFFLE_S	= 1177,
    SPLAT_v16i8	= 1178,
    SPLAT_v16i8_S	= 1179,
    SPLAT_v2f64	= 1180,
    SPLAT_v2f64_S	= 1181,
    SPLAT_v2i64	= 1182,
    SPLAT_v2i64_S	= 1183,
    SPLAT_v4f32	= 1184,
    SPLAT_v4f32_S	= 1185,
    SPLAT_v4i32	= 1186,
    SPLAT_v4i32_S	= 1187,
    SPLAT_v8i16	= 1188,
    SPLAT_v8i16_S	= 1189,
    SQRT_F32	= 1190,
    SQRT_F32_S	= 1191,
    SQRT_F64	= 1192,
    SQRT_F64_S	= 1193,
    SQRT_v2f64	= 1194,
    SQRT_v2f64_S	= 1195,
    SQRT_v4f32	= 1196,
    SQRT_v4f32_S	= 1197,
    STORE16_I32	= 1198,
    STORE16_I32_S	= 1199,
    STORE16_I64	= 1200,
    STORE16_I64_S	= 1201,
    STORE32_I64	= 1202,
    STORE32_I64_S	= 1203,
    STORE8_I32	= 1204,
    STORE8_I32_S	= 1205,
    STORE8_I64	= 1206,
    STORE8_I64_S	= 1207,
    STORE_F32	= 1208,
    STORE_F32_S	= 1209,
    STORE_F64	= 1210,
    STORE_F64_S	= 1211,
    STORE_I32	= 1212,
    STORE_I32_S	= 1213,
    STORE_I64	= 1214,
    STORE_I64_S	= 1215,
    STORE_v16i8	= 1216,
    STORE_v16i8_S	= 1217,
    STORE_v2f64	= 1218,
    STORE_v2f64_S	= 1219,
    STORE_v2i64	= 1220,
    STORE_v2i64_S	= 1221,
    STORE_v4f32	= 1222,
    STORE_v4f32_S	= 1223,
    STORE_v4i32	= 1224,
    STORE_v4i32_S	= 1225,
    STORE_v8i16	= 1226,
    STORE_v8i16_S	= 1227,
    SUB_F32	= 1228,
    SUB_F32_S	= 1229,
    SUB_F64	= 1230,
    SUB_F64_S	= 1231,
    SUB_I32	= 1232,
    SUB_I32_S	= 1233,
    SUB_I64	= 1234,
    SUB_I64_S	= 1235,
    SUB_SAT_S_v16i8	= 1236,
    SUB_SAT_S_v16i8_S	= 1237,
    SUB_SAT_S_v8i16	= 1238,
    SUB_SAT_S_v8i16_S	= 1239,
    SUB_SAT_U_v16i8	= 1240,
    SUB_SAT_U_v16i8_S	= 1241,
    SUB_SAT_U_v8i16	= 1242,
    SUB_SAT_U_v8i16_S	= 1243,
    SUB_v16i8	= 1244,
    SUB_v16i8_S	= 1245,
    SUB_v2f64	= 1246,
    SUB_v2f64_S	= 1247,
    SUB_v2i64	= 1248,
    SUB_v2i64_S	= 1249,
    SUB_v4f32	= 1250,
    SUB_v4f32_S	= 1251,
    SUB_v4i32	= 1252,
    SUB_v4i32_S	= 1253,
    SUB_v8i16	= 1254,
    SUB_v8i16_S	= 1255,
    TEE_EXNREF	= 1256,
    TEE_EXNREF_S	= 1257,
    TEE_F32	= 1258,
    TEE_F32_S	= 1259,
    TEE_F64	= 1260,
    TEE_F64_S	= 1261,
    TEE_I32	= 1262,
    TEE_I32_S	= 1263,
    TEE_I64	= 1264,
    TEE_I64_S	= 1265,
    TEE_V128	= 1266,
    TEE_V128_S	= 1267,
    THROW	= 1268,
    THROW_S	= 1269,
    TRUNC_F32	= 1270,
    TRUNC_F32_S	= 1271,
    TRUNC_F64	= 1272,
    TRUNC_F64_S	= 1273,
    TRY	= 1274,
    TRY_S	= 1275,
    UNREACHABLE	= 1276,
    UNREACHABLE_S	= 1277,
    XOR_I32	= 1278,
    XOR_I32_S	= 1279,
    XOR_I64	= 1280,
    XOR_I64_S	= 1281,
    XOR_v16i8	= 1282,
    XOR_v16i8_S	= 1283,
    XOR_v2i64	= 1284,
    XOR_v2i64_S	= 1285,
    XOR_v4i32	= 1286,
    XOR_v4i32_S	= 1287,
    XOR_v8i16	= 1288,
    XOR_v8i16_S	= 1289,
    fp_to_sint_v2i64_v2f64	= 1290,
    fp_to_sint_v2i64_v2f64_S	= 1291,
    fp_to_sint_v4i32_v4f32	= 1292,
    fp_to_sint_v4i32_v4f32_S	= 1293,
    fp_to_uint_v2i64_v2f64	= 1294,
    fp_to_uint_v2i64_v2f64_S	= 1295,
    fp_to_uint_v4i32_v4f32	= 1296,
    fp_to_uint_v4i32_v4f32_S	= 1297,
    sint_to_fp_v2f64_v2i64	= 1298,
    sint_to_fp_v2f64_v2i64_S	= 1299,
    sint_to_fp_v4f32_v4i32	= 1300,
    sint_to_fp_v4f32_v4i32_S	= 1301,
    uint_to_fp_v2f64_v2i64	= 1302,
    uint_to_fp_v2f64_v2i64_S	= 1303,
    uint_to_fp_v4f32_v4i32	= 1304,
    uint_to_fp_v4f32_v4i32_S	= 1305,
    INSTRUCTION_LIST_END = 1306
  };

} // end WebAssembly namespace
} // end llvm namespace
#endif // GET_INSTRINFO_ENUM

#ifdef GET_INSTRINFO_SCHED_ENUM
#undef GET_INSTRINFO_SCHED_ENUM
namespace llvm {

namespace WebAssembly {
namespace Sched {
  enum {
    NoInstrModel	= 0,
    SCHED_LIST_END = 1
  };
} // end Sched namespace
} // end WebAssembly namespace
} // end llvm namespace
#endif // GET_INSTRINFO_SCHED_ENUM

#ifdef GET_INSTRINFO_MC_DESC
#undef GET_INSTRINFO_MC_DESC
namespace llvm {

static const MCPhysReg ImplicitList1[] = { WebAssembly::ARGUMENTS, 0 };
static const MCPhysReg ImplicitList2[] = { WebAssembly::SP32, WebAssembly::SP64, 0 };
static const MCPhysReg ImplicitList3[] = { WebAssembly::VALUE_STACK, 0 };

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
static const MCOperandInfo OperandInfo32[] = { { -1, 0, WebAssembly::OPERAND_BASIC_BLOCK, 0 }, { -1, 0, WebAssembly::OPERAND_BASIC_BLOCK, 0 }, };
static const MCOperandInfo OperandInfo33[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo34[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo35[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo36[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo37[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo38[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo39[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo40[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo41[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo42[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo43[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo44[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo45[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo46[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo47[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo48[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo49[] = { { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, };
static const MCOperandInfo OperandInfo50[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo51[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo52[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo53[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo54[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo55[] = { { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo56[] = { { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo57[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo58[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo59[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo60[] = { { -1, 0, WebAssembly::OPERAND_SIGNATURE, 0 }, };
static const MCOperandInfo OperandInfo61[] = { { -1, 0, WebAssembly::OPERAND_BASIC_BLOCK, 0 }, };
static const MCOperandInfo OperandInfo62[] = { { -1, 0, WebAssembly::OPERAND_BASIC_BLOCK, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo63[] = { { -1, 0, WebAssembly::OPERAND_BASIC_BLOCK, 0 }, { -1, 0, WebAssembly::OPERAND_EVENT, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo64[] = { { -1, 0, WebAssembly::OPERAND_BASIC_BLOCK, 0 }, { -1, 0, WebAssembly::OPERAND_EVENT, 0 }, };
static const MCOperandInfo OperandInfo65[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo66[] = { { -1, 0, WebAssembly::OPERAND_BRLIST, 0 }, };
static const MCOperandInfo OperandInfo67[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo68[] = { { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo69[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo70[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo71[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo72[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo73[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo74[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_TYPEINDEX, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, };
static const MCOperandInfo OperandInfo75[] = { { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo76[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo77[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo78[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo79[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo80[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo81[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_FUNCTION32, 0 }, };
static const MCOperandInfo OperandInfo82[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo83[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo84[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo85[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, };
static const MCOperandInfo OperandInfo86[] = { { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, };
static const MCOperandInfo OperandInfo87[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_F64IMM, 0 }, };
static const MCOperandInfo OperandInfo88[] = { { -1, 0, WebAssembly::OPERAND_F64IMM, 0 }, };
static const MCOperandInfo OperandInfo89[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, };
static const MCOperandInfo OperandInfo90[] = { { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, };
static const MCOperandInfo OperandInfo91[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_I64IMM, 0 }, };
static const MCOperandInfo OperandInfo92[] = { { -1, 0, WebAssembly::OPERAND_I64IMM, 0 }, };
static const MCOperandInfo OperandInfo93[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo94[] = { { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo95[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_F64IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F64IMM, 0 }, };
static const MCOperandInfo OperandInfo96[] = { { -1, 0, WebAssembly::OPERAND_F64IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F64IMM, 0 }, };
static const MCOperandInfo OperandInfo97[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I64IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I64IMM, 0 }, };
static const MCOperandInfo OperandInfo98[] = { { -1, 0, WebAssembly::OPERAND_VEC_I64IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I64IMM, 0 }, };
static const MCOperandInfo OperandInfo99[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, };
static const MCOperandInfo OperandInfo100[] = { { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_F32IMM, 0 }, };
static const MCOperandInfo OperandInfo101[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, };
static const MCOperandInfo OperandInfo102[] = { { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I32IMM, 0 }, };
static const MCOperandInfo OperandInfo103[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, };
static const MCOperandInfo OperandInfo104[] = { { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I16IMM, 0 }, };
static const MCOperandInfo OperandInfo105[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo106[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo107[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo108[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo109[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo110[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo111[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo112[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo113[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo114[] = { { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo115[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo116[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo117[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo118[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo119[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo120[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo121[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo122[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo123[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo124[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo125[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo126[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo127[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo128[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo129[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo130[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo131[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo132[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo133[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo134[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, };
static const MCOperandInfo OperandInfo135[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo136[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo137[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo138[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo139[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo140[] = { { -1, 0, WebAssembly::OPERAND_GLOBAL, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo141[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo142[] = { { -1, 0, WebAssembly::OPERAND_SIGNATURE, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo143[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo144[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo145[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo146[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo147[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo148[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo149[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo150[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo151[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo152[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, };
static const MCOperandInfo OperandInfo153[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo154[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo155[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo156[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo157[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo158[] = { { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo159[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo160[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo161[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo162[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo163[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo164[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_LOCAL, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo165[] = { { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo166[] = { { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, };
static const MCOperandInfo OperandInfo167[] = { { -1, 0, WebAssembly::OPERAND_I32IMM, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo168[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, MCOI::OPERAND_IMMEDIATE, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo169[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo170[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo171[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo172[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo173[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo174[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo175[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo176[] = { { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo177[] = { { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo178[] = { { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo179[] = { { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo180[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo181[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, { -1, 0, WebAssembly::OPERAND_VEC_I8IMM, 0 }, };
static const MCOperandInfo OperandInfo182[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo183[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::I64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo184[] = { { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo185[] = { { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo186[] = { { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::F64RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo187[] = { { -1, 0, WebAssembly::OPERAND_P2ALIGN, 0 }, { -1, 0, WebAssembly::OPERAND_OFFSET32, 0 }, { WebAssembly::I32RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::V128RegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo188[] = { { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, { WebAssembly::EXNREFRegClassID, 0, MCOI::OPERAND_REGISTER, 0 }, };
static const MCOperandInfo OperandInfo189[] = { { -1, 0, WebAssembly::OPERAND_EVENT, 0 }, };

extern const MCInstrDesc WebAssemblyInsts[] = {
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
  { 164,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::EHScopeReturn)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #164 = CATCHRET
  { 165,	2,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::EHScopeReturn)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo32, -1 ,nullptr },  // Inst #165 = CATCHRET_S
  { 166,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::EHScopeReturn)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #166 = CLEANUPRET
  { 167,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::EHScopeReturn)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #167 = CLEANUPRET_S
  { 168,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #168 = COMPILER_FENCE
  { 169,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #169 = COMPILER_FENCE_S
  { 170,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #170 = RETHROW_IN_CATCH
  { 171,	0,	0,	0,	0,	0|(1ULL<<MCID::Pseudo)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #171 = RETHROW_IN_CATCH_S
  { 172,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #172 = ABS_F32
  { 173,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #173 = ABS_F32_S
  { 174,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #174 = ABS_F64
  { 175,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #175 = ABS_F64_S
  { 176,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #176 = ABS_v2f64
  { 177,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #177 = ABS_v2f64_S
  { 178,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #178 = ABS_v4f32
  { 179,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #179 = ABS_v4f32_S
  { 180,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #180 = ADD_F32
  { 181,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #181 = ADD_F32_S
  { 182,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #182 = ADD_F64
  { 183,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #183 = ADD_F64_S
  { 184,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #184 = ADD_I32
  { 185,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #185 = ADD_I32_S
  { 186,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #186 = ADD_I64
  { 187,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #187 = ADD_I64_S
  { 188,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #188 = ADD_SAT_S_v16i8
  { 189,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #189 = ADD_SAT_S_v16i8_S
  { 190,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #190 = ADD_SAT_S_v8i16
  { 191,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #191 = ADD_SAT_S_v8i16_S
  { 192,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #192 = ADD_SAT_U_v16i8
  { 193,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #193 = ADD_SAT_U_v16i8_S
  { 194,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #194 = ADD_SAT_U_v8i16
  { 195,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #195 = ADD_SAT_U_v8i16_S
  { 196,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #196 = ADD_v16i8
  { 197,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #197 = ADD_v16i8_S
  { 198,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #198 = ADD_v2f64
  { 199,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #199 = ADD_v2f64_S
  { 200,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #200 = ADD_v2i64
  { 201,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #201 = ADD_v2i64_S
  { 202,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #202 = ADD_v4f32
  { 203,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #203 = ADD_v4f32_S
  { 204,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #204 = ADD_v4i32
  { 205,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #205 = ADD_v4i32_S
  { 206,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #206 = ADD_v8i16
  { 207,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #207 = ADD_v8i16_S
  { 208,	2,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo8, -1 ,nullptr },  // Inst #208 = ADJCALLSTACKDOWN
  { 209,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo8, -1 ,nullptr },  // Inst #209 = ADJCALLSTACKDOWN_S
  { 210,	2,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo8, -1 ,nullptr },  // Inst #210 = ADJCALLSTACKUP
  { 211,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList2, OperandInfo8, -1 ,nullptr },  // Inst #211 = ADJCALLSTACKUP_S
  { 212,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #212 = ALLTRUE_v16i8
  { 213,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #213 = ALLTRUE_v16i8_S
  { 214,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #214 = ALLTRUE_v2i64
  { 215,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #215 = ALLTRUE_v2i64_S
  { 216,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #216 = ALLTRUE_v4i32
  { 217,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #217 = ALLTRUE_v4i32_S
  { 218,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #218 = ALLTRUE_v8i16
  { 219,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #219 = ALLTRUE_v8i16_S
  { 220,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #220 = AND_I32
  { 221,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #221 = AND_I32_S
  { 222,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #222 = AND_I64
  { 223,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #223 = AND_I64_S
  { 224,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #224 = AND_v16i8
  { 225,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #225 = AND_v16i8_S
  { 226,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #226 = AND_v2i64
  { 227,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #227 = AND_v2i64_S
  { 228,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #228 = AND_v4i32
  { 229,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #229 = AND_v4i32_S
  { 230,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #230 = AND_v8i16
  { 231,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #231 = AND_v8i16_S
  { 232,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #232 = ANYTRUE_v16i8
  { 233,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #233 = ANYTRUE_v16i8_S
  { 234,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #234 = ANYTRUE_v2i64
  { 235,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #235 = ANYTRUE_v2i64_S
  { 236,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #236 = ANYTRUE_v4i32
  { 237,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #237 = ANYTRUE_v4i32_S
  { 238,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo41, -1 ,nullptr },  // Inst #238 = ANYTRUE_v8i16
  { 239,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #239 = ANYTRUE_v8i16_S
  { 240,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo42, -1 ,nullptr },  // Inst #240 = ARGUMENT_exnref
  { 241,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #241 = ARGUMENT_exnref_S
  { 242,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo43, -1 ,nullptr },  // Inst #242 = ARGUMENT_f32
  { 243,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #243 = ARGUMENT_f32_S
  { 244,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo44, -1 ,nullptr },  // Inst #244 = ARGUMENT_f64
  { 245,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #245 = ARGUMENT_f64_S
  { 246,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo45, -1 ,nullptr },  // Inst #246 = ARGUMENT_i32
  { 247,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #247 = ARGUMENT_i32_S
  { 248,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo46, -1 ,nullptr },  // Inst #248 = ARGUMENT_i64
  { 249,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #249 = ARGUMENT_i64_S
  { 250,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #250 = ARGUMENT_v16i8
  { 251,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #251 = ARGUMENT_v16i8_S
  { 252,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #252 = ARGUMENT_v2f64
  { 253,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #253 = ARGUMENT_v2f64_S
  { 254,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #254 = ARGUMENT_v2i64
  { 255,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #255 = ARGUMENT_v2i64_S
  { 256,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #256 = ARGUMENT_v4f32
  { 257,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #257 = ARGUMENT_v4f32_S
  { 258,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #258 = ARGUMENT_v4i32
  { 259,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #259 = ARGUMENT_v4i32_S
  { 260,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo47, -1 ,nullptr },  // Inst #260 = ARGUMENT_v8i16
  { 261,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList1, nullptr, OperandInfo3, -1 ,nullptr },  // Inst #261 = ARGUMENT_v8i16_S
  { 262,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #262 = ATOMIC_LOAD16_U_I32
  { 263,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #263 = ATOMIC_LOAD16_U_I32_S
  { 264,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #264 = ATOMIC_LOAD16_U_I64
  { 265,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #265 = ATOMIC_LOAD16_U_I64_S
  { 266,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #266 = ATOMIC_LOAD32_U_I64
  { 267,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #267 = ATOMIC_LOAD32_U_I64_S
  { 268,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #268 = ATOMIC_LOAD8_U_I32
  { 269,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #269 = ATOMIC_LOAD8_U_I32_S
  { 270,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #270 = ATOMIC_LOAD8_U_I64
  { 271,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #271 = ATOMIC_LOAD8_U_I64_S
  { 272,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #272 = ATOMIC_LOAD_I32
  { 273,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #273 = ATOMIC_LOAD_I32_S
  { 274,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #274 = ATOMIC_LOAD_I64
  { 275,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #275 = ATOMIC_LOAD_I64_S
  { 276,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #276 = ATOMIC_NOTIFY
  { 277,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #277 = ATOMIC_NOTIFY_S
  { 278,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #278 = ATOMIC_RMW16_U_ADD_I32
  { 279,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #279 = ATOMIC_RMW16_U_ADD_I32_S
  { 280,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #280 = ATOMIC_RMW16_U_ADD_I64
  { 281,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #281 = ATOMIC_RMW16_U_ADD_I64_S
  { 282,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #282 = ATOMIC_RMW16_U_AND_I32
  { 283,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #283 = ATOMIC_RMW16_U_AND_I32_S
  { 284,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #284 = ATOMIC_RMW16_U_AND_I64
  { 285,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #285 = ATOMIC_RMW16_U_AND_I64_S
  { 286,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo53, -1 ,nullptr },  // Inst #286 = ATOMIC_RMW16_U_CMPXCHG_I32
  { 287,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #287 = ATOMIC_RMW16_U_CMPXCHG_I32_S
  { 288,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #288 = ATOMIC_RMW16_U_CMPXCHG_I64
  { 289,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #289 = ATOMIC_RMW16_U_CMPXCHG_I64_S
  { 290,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #290 = ATOMIC_RMW16_U_OR_I32
  { 291,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #291 = ATOMIC_RMW16_U_OR_I32_S
  { 292,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #292 = ATOMIC_RMW16_U_OR_I64
  { 293,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #293 = ATOMIC_RMW16_U_OR_I64_S
  { 294,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #294 = ATOMIC_RMW16_U_SUB_I32
  { 295,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #295 = ATOMIC_RMW16_U_SUB_I32_S
  { 296,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #296 = ATOMIC_RMW16_U_SUB_I64
  { 297,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #297 = ATOMIC_RMW16_U_SUB_I64_S
  { 298,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #298 = ATOMIC_RMW16_U_XCHG_I32
  { 299,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #299 = ATOMIC_RMW16_U_XCHG_I32_S
  { 300,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #300 = ATOMIC_RMW16_U_XCHG_I64
  { 301,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #301 = ATOMIC_RMW16_U_XCHG_I64_S
  { 302,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #302 = ATOMIC_RMW16_U_XOR_I32
  { 303,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #303 = ATOMIC_RMW16_U_XOR_I32_S
  { 304,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #304 = ATOMIC_RMW16_U_XOR_I64
  { 305,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #305 = ATOMIC_RMW16_U_XOR_I64_S
  { 306,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #306 = ATOMIC_RMW32_U_ADD_I64
  { 307,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #307 = ATOMIC_RMW32_U_ADD_I64_S
  { 308,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #308 = ATOMIC_RMW32_U_AND_I64
  { 309,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #309 = ATOMIC_RMW32_U_AND_I64_S
  { 310,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #310 = ATOMIC_RMW32_U_CMPXCHG_I64
  { 311,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #311 = ATOMIC_RMW32_U_CMPXCHG_I64_S
  { 312,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #312 = ATOMIC_RMW32_U_OR_I64
  { 313,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #313 = ATOMIC_RMW32_U_OR_I64_S
  { 314,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #314 = ATOMIC_RMW32_U_SUB_I64
  { 315,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #315 = ATOMIC_RMW32_U_SUB_I64_S
  { 316,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #316 = ATOMIC_RMW32_U_XCHG_I64
  { 317,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #317 = ATOMIC_RMW32_U_XCHG_I64_S
  { 318,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #318 = ATOMIC_RMW32_U_XOR_I64
  { 319,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #319 = ATOMIC_RMW32_U_XOR_I64_S
  { 320,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #320 = ATOMIC_RMW8_U_ADD_I32
  { 321,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #321 = ATOMIC_RMW8_U_ADD_I32_S
  { 322,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #322 = ATOMIC_RMW8_U_ADD_I64
  { 323,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #323 = ATOMIC_RMW8_U_ADD_I64_S
  { 324,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #324 = ATOMIC_RMW8_U_AND_I32
  { 325,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #325 = ATOMIC_RMW8_U_AND_I32_S
  { 326,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #326 = ATOMIC_RMW8_U_AND_I64
  { 327,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #327 = ATOMIC_RMW8_U_AND_I64_S
  { 328,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo53, -1 ,nullptr },  // Inst #328 = ATOMIC_RMW8_U_CMPXCHG_I32
  { 329,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #329 = ATOMIC_RMW8_U_CMPXCHG_I32_S
  { 330,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #330 = ATOMIC_RMW8_U_CMPXCHG_I64
  { 331,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #331 = ATOMIC_RMW8_U_CMPXCHG_I64_S
  { 332,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #332 = ATOMIC_RMW8_U_OR_I32
  { 333,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #333 = ATOMIC_RMW8_U_OR_I32_S
  { 334,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #334 = ATOMIC_RMW8_U_OR_I64
  { 335,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #335 = ATOMIC_RMW8_U_OR_I64_S
  { 336,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #336 = ATOMIC_RMW8_U_SUB_I32
  { 337,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #337 = ATOMIC_RMW8_U_SUB_I32_S
  { 338,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #338 = ATOMIC_RMW8_U_SUB_I64
  { 339,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #339 = ATOMIC_RMW8_U_SUB_I64_S
  { 340,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #340 = ATOMIC_RMW8_U_XCHG_I32
  { 341,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #341 = ATOMIC_RMW8_U_XCHG_I32_S
  { 342,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #342 = ATOMIC_RMW8_U_XCHG_I64
  { 343,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #343 = ATOMIC_RMW8_U_XCHG_I64_S
  { 344,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #344 = ATOMIC_RMW8_U_XOR_I32
  { 345,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #345 = ATOMIC_RMW8_U_XOR_I32_S
  { 346,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #346 = ATOMIC_RMW8_U_XOR_I64
  { 347,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #347 = ATOMIC_RMW8_U_XOR_I64_S
  { 348,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #348 = ATOMIC_RMW_ADD_I32
  { 349,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #349 = ATOMIC_RMW_ADD_I32_S
  { 350,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #350 = ATOMIC_RMW_ADD_I64
  { 351,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #351 = ATOMIC_RMW_ADD_I64_S
  { 352,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #352 = ATOMIC_RMW_AND_I32
  { 353,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #353 = ATOMIC_RMW_AND_I32_S
  { 354,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #354 = ATOMIC_RMW_AND_I64
  { 355,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #355 = ATOMIC_RMW_AND_I64_S
  { 356,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo53, -1 ,nullptr },  // Inst #356 = ATOMIC_RMW_CMPXCHG_I32
  { 357,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #357 = ATOMIC_RMW_CMPXCHG_I32_S
  { 358,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo54, -1 ,nullptr },  // Inst #358 = ATOMIC_RMW_CMPXCHG_I64
  { 359,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #359 = ATOMIC_RMW_CMPXCHG_I64_S
  { 360,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #360 = ATOMIC_RMW_OR_I32
  { 361,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #361 = ATOMIC_RMW_OR_I32_S
  { 362,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #362 = ATOMIC_RMW_OR_I64
  { 363,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #363 = ATOMIC_RMW_OR_I64_S
  { 364,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #364 = ATOMIC_RMW_SUB_I32
  { 365,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #365 = ATOMIC_RMW_SUB_I32_S
  { 366,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #366 = ATOMIC_RMW_SUB_I64
  { 367,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #367 = ATOMIC_RMW_SUB_I64_S
  { 368,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #368 = ATOMIC_RMW_XCHG_I32
  { 369,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #369 = ATOMIC_RMW_XCHG_I32_S
  { 370,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #370 = ATOMIC_RMW_XCHG_I64
  { 371,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #371 = ATOMIC_RMW_XCHG_I64_S
  { 372,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo51, -1 ,nullptr },  // Inst #372 = ATOMIC_RMW_XOR_I32
  { 373,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #373 = ATOMIC_RMW_XOR_I32_S
  { 374,	5,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo52, -1 ,nullptr },  // Inst #374 = ATOMIC_RMW_XOR_I64
  { 375,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #375 = ATOMIC_RMW_XOR_I64_S
  { 376,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #376 = ATOMIC_STORE16_I32
  { 377,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #377 = ATOMIC_STORE16_I32_S
  { 378,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #378 = ATOMIC_STORE16_I64
  { 379,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #379 = ATOMIC_STORE16_I64_S
  { 380,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #380 = ATOMIC_STORE32_I64
  { 381,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #381 = ATOMIC_STORE32_I64_S
  { 382,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #382 = ATOMIC_STORE8_I32
  { 383,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #383 = ATOMIC_STORE8_I32_S
  { 384,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #384 = ATOMIC_STORE8_I64
  { 385,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #385 = ATOMIC_STORE8_I64_S
  { 386,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #386 = ATOMIC_STORE_I32
  { 387,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #387 = ATOMIC_STORE_I32_S
  { 388,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #388 = ATOMIC_STORE_I64
  { 389,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #389 = ATOMIC_STORE_I64_S
  { 390,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo57, -1 ,nullptr },  // Inst #390 = ATOMIC_WAIT_I32
  { 391,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #391 = ATOMIC_WAIT_I32_S
  { 392,	6,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo58, -1 ,nullptr },  // Inst #392 = ATOMIC_WAIT_I64
  { 393,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #393 = ATOMIC_WAIT_I64_S
  { 394,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #394 = BITSELECT_v16i8
  { 395,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #395 = BITSELECT_v16i8_S
  { 396,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #396 = BITSELECT_v2f64
  { 397,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #397 = BITSELECT_v2f64_S
  { 398,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #398 = BITSELECT_v2i64
  { 399,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #399 = BITSELECT_v2i64_S
  { 400,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #400 = BITSELECT_v4f32
  { 401,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #401 = BITSELECT_v4f32_S
  { 402,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #402 = BITSELECT_v4i32
  { 403,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #403 = BITSELECT_v4i32_S
  { 404,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo59, -1 ,nullptr },  // Inst #404 = BITSELECT_v8i16
  { 405,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #405 = BITSELECT_v8i16_S
  { 406,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #406 = BLOCK
  { 407,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #407 = BLOCK_S
  { 408,	1,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #408 = BR
  { 409,	2,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo62, -1 ,nullptr },  // Inst #409 = BR_IF
  { 410,	1,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #410 = BR_IF_S
  { 411,	3,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo63, -1 ,nullptr },  // Inst #411 = BR_ON_EXN
  { 412,	2,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo64, -1 ,nullptr },  // Inst #412 = BR_ON_EXN_S
  { 413,	1,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #413 = BR_S
  { 414,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #414 = BR_TABLE_I32
  { 415,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo66, -1 ,nullptr },  // Inst #415 = BR_TABLE_I32_S
  { 416,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo67, -1 ,nullptr },  // Inst #416 = BR_TABLE_I64
  { 417,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo66, -1 ,nullptr },  // Inst #417 = BR_TABLE_I64_S
  { 418,	2,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo62, -1 ,nullptr },  // Inst #418 = BR_UNLESS
  { 419,	1,	0,	0,	0,	0|(1ULL<<MCID::Branch)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo61, -1 ,nullptr },  // Inst #419 = BR_UNLESS_S
  { 420,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #420 = CALL_INDIRECT_VOID
  { 421,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #421 = CALL_INDIRECT_VOID_S
  { 422,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo69, -1 ,nullptr },  // Inst #422 = CALL_INDIRECT_exnref
  { 423,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #423 = CALL_INDIRECT_exnref_S
  { 424,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo70, -1 ,nullptr },  // Inst #424 = CALL_INDIRECT_f32
  { 425,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #425 = CALL_INDIRECT_f32_S
  { 426,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo71, -1 ,nullptr },  // Inst #426 = CALL_INDIRECT_f64
  { 427,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #427 = CALL_INDIRECT_f64_S
  { 428,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo72, -1 ,nullptr },  // Inst #428 = CALL_INDIRECT_i32
  { 429,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #429 = CALL_INDIRECT_i32_S
  { 430,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo73, -1 ,nullptr },  // Inst #430 = CALL_INDIRECT_i64
  { 431,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #431 = CALL_INDIRECT_i64_S
  { 432,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo74, -1 ,nullptr },  // Inst #432 = CALL_INDIRECT_v16i8
  { 433,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #433 = CALL_INDIRECT_v16i8_S
  { 434,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo74, -1 ,nullptr },  // Inst #434 = CALL_INDIRECT_v2f64
  { 435,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #435 = CALL_INDIRECT_v2f64_S
  { 436,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo74, -1 ,nullptr },  // Inst #436 = CALL_INDIRECT_v2i64
  { 437,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #437 = CALL_INDIRECT_v2i64_S
  { 438,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo74, -1 ,nullptr },  // Inst #438 = CALL_INDIRECT_v4f32
  { 439,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #439 = CALL_INDIRECT_v4f32_S
  { 440,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo74, -1 ,nullptr },  // Inst #440 = CALL_INDIRECT_v4i32
  { 441,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #441 = CALL_INDIRECT_v4i32_S
  { 442,	3,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo74, -1 ,nullptr },  // Inst #442 = CALL_INDIRECT_v8i16
  { 443,	2,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #443 = CALL_INDIRECT_v8i16_S
  { 444,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #444 = CALL_VOID
  { 445,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #445 = CALL_VOID_S
  { 446,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo76, -1 ,nullptr },  // Inst #446 = CALL_exnref
  { 447,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #447 = CALL_exnref_S
  { 448,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo77, -1 ,nullptr },  // Inst #448 = CALL_f32
  { 449,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #449 = CALL_f32_S
  { 450,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo78, -1 ,nullptr },  // Inst #450 = CALL_f64
  { 451,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #451 = CALL_f64_S
  { 452,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo79, -1 ,nullptr },  // Inst #452 = CALL_i32
  { 453,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #453 = CALL_i32_S
  { 454,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo80, -1 ,nullptr },  // Inst #454 = CALL_i64
  { 455,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #455 = CALL_i64_S
  { 456,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo81, -1 ,nullptr },  // Inst #456 = CALL_v16i8
  { 457,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #457 = CALL_v16i8_S
  { 458,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo81, -1 ,nullptr },  // Inst #458 = CALL_v2f64
  { 459,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #459 = CALL_v2f64_S
  { 460,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo81, -1 ,nullptr },  // Inst #460 = CALL_v2i64
  { 461,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #461 = CALL_v2i64_S
  { 462,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo81, -1 ,nullptr },  // Inst #462 = CALL_v4f32
  { 463,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #463 = CALL_v4f32_S
  { 464,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo81, -1 ,nullptr },  // Inst #464 = CALL_v4i32
  { 465,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #465 = CALL_v4i32_S
  { 466,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo81, -1 ,nullptr },  // Inst #466 = CALL_v8i16
  { 467,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #467 = CALL_v8i16_S
  { 468,	1,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo82, -1 ,nullptr },  // Inst #468 = CATCH
  { 469,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #469 = CATCH_S
  { 470,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #470 = CEIL_F32
  { 471,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #471 = CEIL_F32_S
  { 472,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #472 = CEIL_F64
  { 473,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #473 = CEIL_F64_S
  { 474,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #474 = CLZ_I32
  { 475,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #475 = CLZ_I32_S
  { 476,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #476 = CLZ_I64
  { 477,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #477 = CLZ_I64_S
  { 478,	2,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo85, -1 ,nullptr },  // Inst #478 = CONST_F32
  { 479,	1,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo86, -1 ,nullptr },  // Inst #479 = CONST_F32_S
  { 480,	2,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo87, -1 ,nullptr },  // Inst #480 = CONST_F64
  { 481,	1,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo88, -1 ,nullptr },  // Inst #481 = CONST_F64_S
  { 482,	2,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo89, -1 ,nullptr },  // Inst #482 = CONST_I32
  { 483,	1,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo90, -1 ,nullptr },  // Inst #483 = CONST_I32_S
  { 484,	2,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo91, -1 ,nullptr },  // Inst #484 = CONST_I64
  { 485,	1,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo92, -1 ,nullptr },  // Inst #485 = CONST_I64_S
  { 486,	17,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo93, -1 ,nullptr },  // Inst #486 = CONST_V128_v16i8
  { 487,	16,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo94, -1 ,nullptr },  // Inst #487 = CONST_V128_v16i8_S
  { 488,	3,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo95, -1 ,nullptr },  // Inst #488 = CONST_V128_v2f64
  { 489,	2,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo96, -1 ,nullptr },  // Inst #489 = CONST_V128_v2f64_S
  { 490,	3,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo97, -1 ,nullptr },  // Inst #490 = CONST_V128_v2i64
  { 491,	2,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo98, -1 ,nullptr },  // Inst #491 = CONST_V128_v2i64_S
  { 492,	5,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo99, -1 ,nullptr },  // Inst #492 = CONST_V128_v4f32
  { 493,	4,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo100, -1 ,nullptr },  // Inst #493 = CONST_V128_v4f32_S
  { 494,	5,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo101, -1 ,nullptr },  // Inst #494 = CONST_V128_v4i32
  { 495,	4,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo102, -1 ,nullptr },  // Inst #495 = CONST_V128_v4i32_S
  { 496,	9,	1,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo103, -1 ,nullptr },  // Inst #496 = CONST_V128_v8i16
  { 497,	8,	0,	0,	0,	0|(1ULL<<MCID::MoveImm)|(1ULL<<MCID::Rematerializable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo104, -1 ,nullptr },  // Inst #497 = CONST_V128_v8i16_S
  { 498,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #498 = COPYSIGN_F32
  { 499,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #499 = COPYSIGN_F32_S
  { 500,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #500 = COPYSIGN_F64
  { 501,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #501 = COPYSIGN_F64_S
  { 502,	2,	1,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo105, -1 ,nullptr },  // Inst #502 = COPY_EXNREF
  { 503,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #503 = COPY_EXNREF_S
  { 504,	2,	1,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #504 = COPY_F32
  { 505,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #505 = COPY_F32_S
  { 506,	2,	1,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #506 = COPY_F64
  { 507,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #507 = COPY_F64_S
  { 508,	2,	1,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #508 = COPY_I32
  { 509,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #509 = COPY_I32_S
  { 510,	2,	1,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #510 = COPY_I64
  { 511,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #511 = COPY_I64_S
  { 512,	2,	1,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #512 = COPY_V128
  { 513,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #513 = COPY_V128_S
  { 514,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #514 = CTZ_I32
  { 515,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #515 = CTZ_I32_S
  { 516,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #516 = CTZ_I64
  { 517,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #517 = CTZ_I64_S
  { 518,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo90, -1 ,nullptr },  // Inst #518 = DATA_DROP
  { 519,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo90, -1 ,nullptr },  // Inst #519 = DATA_DROP_S
  { 520,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #520 = DIV_F32
  { 521,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #521 = DIV_F32_S
  { 522,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #522 = DIV_F64
  { 523,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #523 = DIV_F64_S
  { 524,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #524 = DIV_S_I32
  { 525,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #525 = DIV_S_I32_S
  { 526,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #526 = DIV_S_I64
  { 527,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #527 = DIV_S_I64_S
  { 528,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #528 = DIV_U_I32
  { 529,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #529 = DIV_U_I32_S
  { 530,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #530 = DIV_U_I64
  { 531,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #531 = DIV_U_I64_S
  { 532,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #532 = DIV_v2f64
  { 533,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #533 = DIV_v2f64_S
  { 534,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #534 = DIV_v4f32
  { 535,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #535 = DIV_v4f32_S
  { 536,	1,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo82, -1 ,nullptr },  // Inst #536 = DROP_EXNREF
  { 537,	0,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #537 = DROP_EXNREF_S
  { 538,	1,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo106, -1 ,nullptr },  // Inst #538 = DROP_F32
  { 539,	0,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #539 = DROP_F32_S
  { 540,	1,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo107, -1 ,nullptr },  // Inst #540 = DROP_F64
  { 541,	0,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #541 = DROP_F64_S
  { 542,	1,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #542 = DROP_I32
  { 543,	0,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #543 = DROP_I32_S
  { 544,	1,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo67, -1 ,nullptr },  // Inst #544 = DROP_I64
  { 545,	0,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #545 = DROP_I64_S
  { 546,	1,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #546 = DROP_V128
  { 547,	0,	0,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #547 = DROP_V128_S
  { 548,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #548 = ELSE
  { 549,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #549 = ELSE_S
  { 550,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #550 = END
  { 551,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #551 = END_BLOCK
  { 552,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #552 = END_BLOCK_S
  { 553,	0,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #553 = END_FUNCTION
  { 554,	0,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #554 = END_FUNCTION_S
  { 555,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #555 = END_IF
  { 556,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #556 = END_IF_S
  { 557,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #557 = END_LOOP
  { 558,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #558 = END_LOOP_S
  { 559,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #559 = END_S
  { 560,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #560 = END_TRY
  { 561,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, nullptr, -1 ,nullptr },  // Inst #561 = END_TRY_S
  { 562,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #562 = EQZ_I32
  { 563,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #563 = EQZ_I32_S
  { 564,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo109, -1 ,nullptr },  // Inst #564 = EQZ_I64
  { 565,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #565 = EQZ_I64_S
  { 566,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo110, -1 ,nullptr },  // Inst #566 = EQ_F32
  { 567,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #567 = EQ_F32_S
  { 568,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo111, -1 ,nullptr },  // Inst #568 = EQ_F64
  { 569,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #569 = EQ_F64_S
  { 570,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #570 = EQ_I32
  { 571,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #571 = EQ_I32_S
  { 572,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #572 = EQ_I64
  { 573,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #573 = EQ_I64_S
  { 574,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #574 = EQ_v16i8
  { 575,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #575 = EQ_v16i8_S
  { 576,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #576 = EQ_v2f64
  { 577,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #577 = EQ_v2f64_S
  { 578,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #578 = EQ_v4f32
  { 579,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #579 = EQ_v4f32_S
  { 580,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #580 = EQ_v4i32
  { 581,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #581 = EQ_v4i32_S
  { 582,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #582 = EQ_v8i16
  { 583,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #583 = EQ_v8i16_S
  { 584,	1,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #584 = EXTRACT_EXCEPTION_I32
  { 585,	1,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #585 = EXTRACT_EXCEPTION_I32_S
  { 586,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo113, -1 ,nullptr },  // Inst #586 = EXTRACT_LANE_v16i8_s
  { 587,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #587 = EXTRACT_LANE_v16i8_s_S
  { 588,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo113, -1 ,nullptr },  // Inst #588 = EXTRACT_LANE_v16i8_u
  { 589,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #589 = EXTRACT_LANE_v16i8_u_S
  { 590,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo115, -1 ,nullptr },  // Inst #590 = EXTRACT_LANE_v2f64
  { 591,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #591 = EXTRACT_LANE_v2f64_S
  { 592,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo116, -1 ,nullptr },  // Inst #592 = EXTRACT_LANE_v2i64
  { 593,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #593 = EXTRACT_LANE_v2i64_S
  { 594,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo117, -1 ,nullptr },  // Inst #594 = EXTRACT_LANE_v4f32
  { 595,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #595 = EXTRACT_LANE_v4f32_S
  { 596,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo113, -1 ,nullptr },  // Inst #596 = EXTRACT_LANE_v4i32
  { 597,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #597 = EXTRACT_LANE_v4i32_S
  { 598,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo113, -1 ,nullptr },  // Inst #598 = EXTRACT_LANE_v8i16_s
  { 599,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #599 = EXTRACT_LANE_v8i16_s_S
  { 600,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo113, -1 ,nullptr },  // Inst #600 = EXTRACT_LANE_v8i16_u
  { 601,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #601 = EXTRACT_LANE_v8i16_u_S
  { 602,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo118, -1 ,nullptr },  // Inst #602 = F32_CONVERT_S_I32
  { 603,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #603 = F32_CONVERT_S_I32_S
  { 604,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo119, -1 ,nullptr },  // Inst #604 = F32_CONVERT_S_I64
  { 605,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #605 = F32_CONVERT_S_I64_S
  { 606,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo118, -1 ,nullptr },  // Inst #606 = F32_CONVERT_U_I32
  { 607,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #607 = F32_CONVERT_U_I32_S
  { 608,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo119, -1 ,nullptr },  // Inst #608 = F32_CONVERT_U_I64
  { 609,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #609 = F32_CONVERT_U_I64_S
  { 610,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo120, -1 ,nullptr },  // Inst #610 = F32_DEMOTE_F64
  { 611,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #611 = F32_DEMOTE_F64_S
  { 612,	2,	1,	0,	0,	0|(1ULL<<MCID::Bitcast)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo118, -1 ,nullptr },  // Inst #612 = F32_REINTERPRET_I32
  { 613,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #613 = F32_REINTERPRET_I32_S
  { 614,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo121, -1 ,nullptr },  // Inst #614 = F64_CONVERT_S_I32
  { 615,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #615 = F64_CONVERT_S_I32_S
  { 616,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo122, -1 ,nullptr },  // Inst #616 = F64_CONVERT_S_I64
  { 617,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #617 = F64_CONVERT_S_I64_S
  { 618,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo121, -1 ,nullptr },  // Inst #618 = F64_CONVERT_U_I32
  { 619,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #619 = F64_CONVERT_U_I32_S
  { 620,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo122, -1 ,nullptr },  // Inst #620 = F64_CONVERT_U_I64
  { 621,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #621 = F64_CONVERT_U_I64_S
  { 622,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo123, -1 ,nullptr },  // Inst #622 = F64_PROMOTE_F32
  { 623,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #623 = F64_PROMOTE_F32_S
  { 624,	2,	1,	0,	0,	0|(1ULL<<MCID::Bitcast)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo122, -1 ,nullptr },  // Inst #624 = F64_REINTERPRET_I64
  { 625,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #625 = F64_REINTERPRET_I64_S
  { 626,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo82, -1 ,nullptr },  // Inst #626 = FALLTHROUGH_RETURN_EXNREF
  { 627,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #627 = FALLTHROUGH_RETURN_EXNREF_S
  { 628,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo106, -1 ,nullptr },  // Inst #628 = FALLTHROUGH_RETURN_F32
  { 629,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #629 = FALLTHROUGH_RETURN_F32_S
  { 630,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo107, -1 ,nullptr },  // Inst #630 = FALLTHROUGH_RETURN_F64
  { 631,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #631 = FALLTHROUGH_RETURN_F64_S
  { 632,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #632 = FALLTHROUGH_RETURN_I32
  { 633,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #633 = FALLTHROUGH_RETURN_I32_S
  { 634,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo67, -1 ,nullptr },  // Inst #634 = FALLTHROUGH_RETURN_I64
  { 635,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #635 = FALLTHROUGH_RETURN_I64_S
  { 636,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #636 = FALLTHROUGH_RETURN_VOID
  { 637,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #637 = FALLTHROUGH_RETURN_VOID_S
  { 638,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #638 = FALLTHROUGH_RETURN_v16i8
  { 639,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #639 = FALLTHROUGH_RETURN_v16i8_S
  { 640,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #640 = FALLTHROUGH_RETURN_v2f64
  { 641,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #641 = FALLTHROUGH_RETURN_v2f64_S
  { 642,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #642 = FALLTHROUGH_RETURN_v2i64
  { 643,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #643 = FALLTHROUGH_RETURN_v2i64_S
  { 644,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #644 = FALLTHROUGH_RETURN_v4f32
  { 645,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #645 = FALLTHROUGH_RETURN_v4f32_S
  { 646,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #646 = FALLTHROUGH_RETURN_v4i32
  { 647,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #647 = FALLTHROUGH_RETURN_v4i32_S
  { 648,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #648 = FALLTHROUGH_RETURN_v8i16
  { 649,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #649 = FALLTHROUGH_RETURN_v8i16_S
  { 650,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #650 = FLOOR_F32
  { 651,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #651 = FLOOR_F32_S
  { 652,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #652 = FLOOR_F64
  { 653,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #653 = FLOOR_F64_S
  { 654,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #654 = FP_TO_SINT_I32_F32
  { 655,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #655 = FP_TO_SINT_I32_F32_S
  { 656,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo125, -1 ,nullptr },  // Inst #656 = FP_TO_SINT_I32_F64
  { 657,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #657 = FP_TO_SINT_I32_F64_S
  { 658,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo126, -1 ,nullptr },  // Inst #658 = FP_TO_SINT_I64_F32
  { 659,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #659 = FP_TO_SINT_I64_F32_S
  { 660,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #660 = FP_TO_SINT_I64_F64
  { 661,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #661 = FP_TO_SINT_I64_F64_S
  { 662,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #662 = FP_TO_UINT_I32_F32
  { 663,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #663 = FP_TO_UINT_I32_F32_S
  { 664,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo125, -1 ,nullptr },  // Inst #664 = FP_TO_UINT_I32_F64
  { 665,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #665 = FP_TO_UINT_I32_F64_S
  { 666,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo126, -1 ,nullptr },  // Inst #666 = FP_TO_UINT_I64_F32
  { 667,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #667 = FP_TO_UINT_I64_F32_S
  { 668,	2,	1,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #668 = FP_TO_UINT_I64_F64
  { 669,	0,	0,	0,	0,	0|(1ULL<<MCID::UsesCustomInserter)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #669 = FP_TO_UINT_I64_F64_S
  { 670,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo110, -1 ,nullptr },  // Inst #670 = GE_F32
  { 671,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #671 = GE_F32_S
  { 672,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo111, -1 ,nullptr },  // Inst #672 = GE_F64
  { 673,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #673 = GE_F64_S
  { 674,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #674 = GE_S_I32
  { 675,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #675 = GE_S_I32_S
  { 676,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #676 = GE_S_I64
  { 677,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #677 = GE_S_I64_S
  { 678,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #678 = GE_S_v16i8
  { 679,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #679 = GE_S_v16i8_S
  { 680,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #680 = GE_S_v4i32
  { 681,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #681 = GE_S_v4i32_S
  { 682,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #682 = GE_S_v8i16
  { 683,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #683 = GE_S_v8i16_S
  { 684,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #684 = GE_U_I32
  { 685,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #685 = GE_U_I32_S
  { 686,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #686 = GE_U_I64
  { 687,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #687 = GE_U_I64_S
  { 688,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #688 = GE_U_v16i8
  { 689,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #689 = GE_U_v16i8_S
  { 690,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #690 = GE_U_v4i32
  { 691,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #691 = GE_U_v4i32_S
  { 692,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #692 = GE_U_v8i16
  { 693,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #693 = GE_U_v8i16_S
  { 694,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #694 = GE_v2f64
  { 695,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #695 = GE_v2f64_S
  { 696,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #696 = GE_v4f32
  { 697,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #697 = GE_v4f32_S
  { 698,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo128, -1 ,nullptr },  // Inst #698 = GLOBAL_GET_EXNREF
  { 699,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #699 = GLOBAL_GET_EXNREF_S
  { 700,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo130, -1 ,nullptr },  // Inst #700 = GLOBAL_GET_F32
  { 701,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #701 = GLOBAL_GET_F32_S
  { 702,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo131, -1 ,nullptr },  // Inst #702 = GLOBAL_GET_F64
  { 703,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #703 = GLOBAL_GET_F64_S
  { 704,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo132, -1 ,nullptr },  // Inst #704 = GLOBAL_GET_I32
  { 705,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #705 = GLOBAL_GET_I32_S
  { 706,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo133, -1 ,nullptr },  // Inst #706 = GLOBAL_GET_I64
  { 707,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #707 = GLOBAL_GET_I64_S
  { 708,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo134, -1 ,nullptr },  // Inst #708 = GLOBAL_GET_V128
  { 709,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #709 = GLOBAL_GET_V128_S
  { 710,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo135, -1 ,nullptr },  // Inst #710 = GLOBAL_SET_EXNREF
  { 711,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #711 = GLOBAL_SET_EXNREF_S
  { 712,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo136, -1 ,nullptr },  // Inst #712 = GLOBAL_SET_F32
  { 713,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #713 = GLOBAL_SET_F32_S
  { 714,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo137, -1 ,nullptr },  // Inst #714 = GLOBAL_SET_F64
  { 715,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #715 = GLOBAL_SET_F64_S
  { 716,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo138, -1 ,nullptr },  // Inst #716 = GLOBAL_SET_I32
  { 717,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #717 = GLOBAL_SET_I32_S
  { 718,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo139, -1 ,nullptr },  // Inst #718 = GLOBAL_SET_I64
  { 719,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #719 = GLOBAL_SET_I64_S
  { 720,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo140, -1 ,nullptr },  // Inst #720 = GLOBAL_SET_V128
  { 721,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo129, -1 ,nullptr },  // Inst #721 = GLOBAL_SET_V128_S
  { 722,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo110, -1 ,nullptr },  // Inst #722 = GT_F32
  { 723,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #723 = GT_F32_S
  { 724,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo111, -1 ,nullptr },  // Inst #724 = GT_F64
  { 725,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #725 = GT_F64_S
  { 726,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #726 = GT_S_I32
  { 727,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #727 = GT_S_I32_S
  { 728,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #728 = GT_S_I64
  { 729,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #729 = GT_S_I64_S
  { 730,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #730 = GT_S_v16i8
  { 731,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #731 = GT_S_v16i8_S
  { 732,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #732 = GT_S_v4i32
  { 733,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #733 = GT_S_v4i32_S
  { 734,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #734 = GT_S_v8i16
  { 735,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #735 = GT_S_v8i16_S
  { 736,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #736 = GT_U_I32
  { 737,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #737 = GT_U_I32_S
  { 738,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #738 = GT_U_I64
  { 739,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #739 = GT_U_I64_S
  { 740,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #740 = GT_U_v16i8
  { 741,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #741 = GT_U_v16i8_S
  { 742,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #742 = GT_U_v4i32
  { 743,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #743 = GT_U_v4i32_S
  { 744,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #744 = GT_U_v8i16
  { 745,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #745 = GT_U_v8i16_S
  { 746,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #746 = GT_v2f64
  { 747,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #747 = GT_v2f64_S
  { 748,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #748 = GT_v4f32
  { 749,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #749 = GT_v4f32_S
  { 750,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #750 = I32_EXTEND16_S_I32
  { 751,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #751 = I32_EXTEND16_S_I32_S
  { 752,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #752 = I32_EXTEND8_S_I32
  { 753,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #753 = I32_EXTEND8_S_I32_S
  { 754,	2,	1,	0,	0,	0|(1ULL<<MCID::Bitcast)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #754 = I32_REINTERPRET_F32
  { 755,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #755 = I32_REINTERPRET_F32_S
  { 756,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #756 = I32_TRUNC_S_F32
  { 757,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #757 = I32_TRUNC_S_F32_S
  { 758,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo125, -1 ,nullptr },  // Inst #758 = I32_TRUNC_S_F64
  { 759,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #759 = I32_TRUNC_S_F64_S
  { 760,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #760 = I32_TRUNC_S_SAT_F32
  { 761,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #761 = I32_TRUNC_S_SAT_F32_S
  { 762,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo125, -1 ,nullptr },  // Inst #762 = I32_TRUNC_S_SAT_F64
  { 763,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #763 = I32_TRUNC_S_SAT_F64_S
  { 764,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #764 = I32_TRUNC_U_F32
  { 765,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #765 = I32_TRUNC_U_F32_S
  { 766,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo125, -1 ,nullptr },  // Inst #766 = I32_TRUNC_U_F64
  { 767,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #767 = I32_TRUNC_U_F64_S
  { 768,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo124, -1 ,nullptr },  // Inst #768 = I32_TRUNC_U_SAT_F32
  { 769,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #769 = I32_TRUNC_U_SAT_F32_S
  { 770,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo125, -1 ,nullptr },  // Inst #770 = I32_TRUNC_U_SAT_F64
  { 771,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #771 = I32_TRUNC_U_SAT_F64_S
  { 772,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo109, -1 ,nullptr },  // Inst #772 = I32_WRAP_I64
  { 773,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #773 = I32_WRAP_I64_S
  { 774,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #774 = I64_EXTEND16_S_I64
  { 775,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #775 = I64_EXTEND16_S_I64_S
  { 776,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #776 = I64_EXTEND32_S_I64
  { 777,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #777 = I64_EXTEND32_S_I64_S
  { 778,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #778 = I64_EXTEND8_S_I64
  { 779,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #779 = I64_EXTEND8_S_I64_S
  { 780,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo141, -1 ,nullptr },  // Inst #780 = I64_EXTEND_S_I32
  { 781,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #781 = I64_EXTEND_S_I32_S
  { 782,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo141, -1 ,nullptr },  // Inst #782 = I64_EXTEND_U_I32
  { 783,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #783 = I64_EXTEND_U_I32_S
  { 784,	2,	1,	0,	0,	0|(1ULL<<MCID::Bitcast)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #784 = I64_REINTERPRET_F64
  { 785,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #785 = I64_REINTERPRET_F64_S
  { 786,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo126, -1 ,nullptr },  // Inst #786 = I64_TRUNC_S_F32
  { 787,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #787 = I64_TRUNC_S_F32_S
  { 788,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #788 = I64_TRUNC_S_F64
  { 789,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #789 = I64_TRUNC_S_F64_S
  { 790,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo126, -1 ,nullptr },  // Inst #790 = I64_TRUNC_S_SAT_F32
  { 791,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #791 = I64_TRUNC_S_SAT_F32_S
  { 792,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #792 = I64_TRUNC_S_SAT_F64
  { 793,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #793 = I64_TRUNC_S_SAT_F64_S
  { 794,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo126, -1 ,nullptr },  // Inst #794 = I64_TRUNC_U_F32
  { 795,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #795 = I64_TRUNC_U_F32_S
  { 796,	2,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #796 = I64_TRUNC_U_F64
  { 797,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #797 = I64_TRUNC_U_F64_S
  { 798,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo126, -1 ,nullptr },  // Inst #798 = I64_TRUNC_U_SAT_F32
  { 799,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #799 = I64_TRUNC_U_SAT_F32_S
  { 800,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo127, -1 ,nullptr },  // Inst #800 = I64_TRUNC_U_SAT_F64
  { 801,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #801 = I64_TRUNC_U_SAT_F64_S
  { 802,	2,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo142, -1 ,nullptr },  // Inst #802 = IF
  { 803,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #803 = IF_S
  { 804,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo110, -1 ,nullptr },  // Inst #804 = LE_F32
  { 805,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #805 = LE_F32_S
  { 806,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo111, -1 ,nullptr },  // Inst #806 = LE_F64
  { 807,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #807 = LE_F64_S
  { 808,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #808 = LE_S_I32
  { 809,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #809 = LE_S_I32_S
  { 810,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #810 = LE_S_I64
  { 811,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #811 = LE_S_I64_S
  { 812,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #812 = LE_S_v16i8
  { 813,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #813 = LE_S_v16i8_S
  { 814,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #814 = LE_S_v4i32
  { 815,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #815 = LE_S_v4i32_S
  { 816,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #816 = LE_S_v8i16
  { 817,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #817 = LE_S_v8i16_S
  { 818,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #818 = LE_U_I32
  { 819,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #819 = LE_U_I32_S
  { 820,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #820 = LE_U_I64
  { 821,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #821 = LE_U_I64_S
  { 822,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #822 = LE_U_v16i8
  { 823,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #823 = LE_U_v16i8_S
  { 824,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #824 = LE_U_v4i32
  { 825,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #825 = LE_U_v4i32_S
  { 826,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #826 = LE_U_v8i16
  { 827,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #827 = LE_U_v8i16_S
  { 828,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #828 = LE_v2f64
  { 829,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #829 = LE_v2f64_S
  { 830,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #830 = LE_v4f32
  { 831,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #831 = LE_v4f32_S
  { 832,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #832 = LOAD16_S_I32
  { 833,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #833 = LOAD16_S_I32_S
  { 834,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #834 = LOAD16_S_I64
  { 835,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #835 = LOAD16_S_I64_S
  { 836,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #836 = LOAD16_U_I32
  { 837,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #837 = LOAD16_U_I32_S
  { 838,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #838 = LOAD16_U_I64
  { 839,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #839 = LOAD16_U_I64_S
  { 840,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #840 = LOAD32_S_I64
  { 841,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #841 = LOAD32_S_I64_S
  { 842,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #842 = LOAD32_U_I64
  { 843,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #843 = LOAD32_U_I64_S
  { 844,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #844 = LOAD8_S_I32
  { 845,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #845 = LOAD8_S_I32_S
  { 846,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #846 = LOAD8_S_I64
  { 847,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #847 = LOAD8_S_I64_S
  { 848,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #848 = LOAD8_U_I32
  { 849,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #849 = LOAD8_U_I32_S
  { 850,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #850 = LOAD8_U_I64
  { 851,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #851 = LOAD8_U_I64_S
  { 852,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo143, -1 ,nullptr },  // Inst #852 = LOAD_F32
  { 853,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #853 = LOAD_F32_S
  { 854,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo144, -1 ,nullptr },  // Inst #854 = LOAD_F64
  { 855,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #855 = LOAD_F64_S
  { 856,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo48, -1 ,nullptr },  // Inst #856 = LOAD_I32
  { 857,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #857 = LOAD_I32_S
  { 858,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo50, -1 ,nullptr },  // Inst #858 = LOAD_I64
  { 859,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #859 = LOAD_I64_S
  { 860,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo145, -1 ,nullptr },  // Inst #860 = LOAD_v16i8
  { 861,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #861 = LOAD_v16i8_S
  { 862,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo145, -1 ,nullptr },  // Inst #862 = LOAD_v2f64
  { 863,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #863 = LOAD_v2f64_S
  { 864,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo145, -1 ,nullptr },  // Inst #864 = LOAD_v2i64
  { 865,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #865 = LOAD_v2i64_S
  { 866,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo145, -1 ,nullptr },  // Inst #866 = LOAD_v4f32
  { 867,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #867 = LOAD_v4f32_S
  { 868,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo145, -1 ,nullptr },  // Inst #868 = LOAD_v4i32
  { 869,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #869 = LOAD_v4i32_S
  { 870,	4,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo145, -1 ,nullptr },  // Inst #870 = LOAD_v8i16
  { 871,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #871 = LOAD_v8i16_S
  { 872,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo146, -1 ,nullptr },  // Inst #872 = LOCAL_GET_EXNREF
  { 873,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #873 = LOCAL_GET_EXNREF_S
  { 874,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo148, -1 ,nullptr },  // Inst #874 = LOCAL_GET_F32
  { 875,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #875 = LOCAL_GET_F32_S
  { 876,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo149, -1 ,nullptr },  // Inst #876 = LOCAL_GET_F64
  { 877,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #877 = LOCAL_GET_F64_S
  { 878,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo150, -1 ,nullptr },  // Inst #878 = LOCAL_GET_I32
  { 879,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #879 = LOCAL_GET_I32_S
  { 880,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo151, -1 ,nullptr },  // Inst #880 = LOCAL_GET_I64
  { 881,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #881 = LOCAL_GET_I64_S
  { 882,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo152, -1 ,nullptr },  // Inst #882 = LOCAL_GET_V128
  { 883,	1,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #883 = LOCAL_GET_V128_S
  { 884,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo153, -1 ,nullptr },  // Inst #884 = LOCAL_SET_EXNREF
  { 885,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #885 = LOCAL_SET_EXNREF_S
  { 886,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo154, -1 ,nullptr },  // Inst #886 = LOCAL_SET_F32
  { 887,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #887 = LOCAL_SET_F32_S
  { 888,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo155, -1 ,nullptr },  // Inst #888 = LOCAL_SET_F64
  { 889,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #889 = LOCAL_SET_F64_S
  { 890,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo156, -1 ,nullptr },  // Inst #890 = LOCAL_SET_I32
  { 891,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #891 = LOCAL_SET_I32_S
  { 892,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo157, -1 ,nullptr },  // Inst #892 = LOCAL_SET_I64
  { 893,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #893 = LOCAL_SET_I64_S
  { 894,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo158, -1 ,nullptr },  // Inst #894 = LOCAL_SET_V128
  { 895,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #895 = LOCAL_SET_V128_S
  { 896,	3,	1,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo159, -1 ,nullptr },  // Inst #896 = LOCAL_TEE_EXNREF
  { 897,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #897 = LOCAL_TEE_EXNREF_S
  { 898,	3,	1,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo160, -1 ,nullptr },  // Inst #898 = LOCAL_TEE_F32
  { 899,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #899 = LOCAL_TEE_F32_S
  { 900,	3,	1,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo161, -1 ,nullptr },  // Inst #900 = LOCAL_TEE_F64
  { 901,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #901 = LOCAL_TEE_F64_S
  { 902,	3,	1,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo162, -1 ,nullptr },  // Inst #902 = LOCAL_TEE_I32
  { 903,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #903 = LOCAL_TEE_I32_S
  { 904,	3,	1,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo163, -1 ,nullptr },  // Inst #904 = LOCAL_TEE_I64
  { 905,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #905 = LOCAL_TEE_I64_S
  { 906,	3,	1,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo164, -1 ,nullptr },  // Inst #906 = LOCAL_TEE_V128
  { 907,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo147, -1 ,nullptr },  // Inst #907 = LOCAL_TEE_V128_S
  { 908,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #908 = LOOP
  { 909,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #909 = LOOP_S
  { 910,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo110, -1 ,nullptr },  // Inst #910 = LT_F32
  { 911,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #911 = LT_F32_S
  { 912,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo111, -1 ,nullptr },  // Inst #912 = LT_F64
  { 913,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #913 = LT_F64_S
  { 914,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #914 = LT_S_I32
  { 915,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #915 = LT_S_I32_S
  { 916,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #916 = LT_S_I64
  { 917,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #917 = LT_S_I64_S
  { 918,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #918 = LT_S_v16i8
  { 919,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #919 = LT_S_v16i8_S
  { 920,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #920 = LT_S_v4i32
  { 921,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #921 = LT_S_v4i32_S
  { 922,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #922 = LT_S_v8i16
  { 923,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #923 = LT_S_v8i16_S
  { 924,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #924 = LT_U_I32
  { 925,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #925 = LT_U_I32_S
  { 926,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #926 = LT_U_I64
  { 927,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #927 = LT_U_I64_S
  { 928,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #928 = LT_U_v16i8
  { 929,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #929 = LT_U_v16i8_S
  { 930,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #930 = LT_U_v4i32
  { 931,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #931 = LT_U_v4i32_S
  { 932,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #932 = LT_U_v8i16
  { 933,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #933 = LT_U_v8i16_S
  { 934,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #934 = LT_v2f64
  { 935,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #935 = LT_v2f64_S
  { 936,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #936 = LT_v4f32
  { 937,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #937 = LT_v4f32_S
  { 938,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #938 = MAX_F32
  { 939,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #939 = MAX_F32_S
  { 940,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #940 = MAX_F64
  { 941,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #941 = MAX_F64_S
  { 942,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #942 = MAX_v2f64
  { 943,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #943 = MAX_v2f64_S
  { 944,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #944 = MAX_v4f32
  { 945,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #945 = MAX_v4f32_S
  { 946,	5,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo165, -1 ,nullptr },  // Inst #946 = MEMORY_COPY
  { 947,	2,	0,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo166, -1 ,nullptr },  // Inst #947 = MEMORY_COPY_S
  { 948,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo167, -1 ,nullptr },  // Inst #948 = MEMORY_FILL
  { 949,	1,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo90, -1 ,nullptr },  // Inst #949 = MEMORY_FILL_S
  { 950,	3,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo168, -1 ,nullptr },  // Inst #950 = MEMORY_GROW_I32
  { 951,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo3, -1 ,nullptr },  // Inst #951 = MEMORY_GROW_I32_S
  { 952,	5,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo165, -1 ,nullptr },  // Inst #952 = MEMORY_INIT
  { 953,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo166, -1 ,nullptr },  // Inst #953 = MEMORY_INIT_S
  { 954,	2,	1,	0,	0,	0|(1ULL<<MCID::MayLoad)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo45, -1 ,nullptr },  // Inst #954 = MEMORY_SIZE_I32
  { 955,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo3, -1 ,nullptr },  // Inst #955 = MEMORY_SIZE_I32_S
  { 956,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #956 = MIN_F32
  { 957,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #957 = MIN_F32_S
  { 958,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #958 = MIN_F64
  { 959,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #959 = MIN_F64_S
  { 960,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #960 = MIN_v2f64
  { 961,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #961 = MIN_v2f64_S
  { 962,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #962 = MIN_v4f32
  { 963,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #963 = MIN_v4f32_S
  { 964,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #964 = MUL_F32
  { 965,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #965 = MUL_F32_S
  { 966,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #966 = MUL_F64
  { 967,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #967 = MUL_F64_S
  { 968,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #968 = MUL_I32
  { 969,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #969 = MUL_I32_S
  { 970,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #970 = MUL_I64
  { 971,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #971 = MUL_I64_S
  { 972,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #972 = MUL_v16i8
  { 973,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #973 = MUL_v16i8_S
  { 974,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #974 = MUL_v2f64
  { 975,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #975 = MUL_v2f64_S
  { 976,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #976 = MUL_v4f32
  { 977,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #977 = MUL_v4f32_S
  { 978,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #978 = MUL_v4i32
  { 979,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #979 = MUL_v4i32_S
  { 980,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #980 = MUL_v8i16
  { 981,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #981 = MUL_v8i16_S
  { 982,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #982 = NEAREST_F32
  { 983,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #983 = NEAREST_F32_S
  { 984,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #984 = NEAREST_F64
  { 985,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #985 = NEAREST_F64_S
  { 986,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #986 = NEG_F32
  { 987,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #987 = NEG_F32_S
  { 988,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #988 = NEG_F64
  { 989,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #989 = NEG_F64_S
  { 990,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #990 = NEG_v16i8
  { 991,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #991 = NEG_v16i8_S
  { 992,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #992 = NEG_v2f64
  { 993,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #993 = NEG_v2f64_S
  { 994,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #994 = NEG_v2i64
  { 995,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #995 = NEG_v2i64_S
  { 996,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #996 = NEG_v4f32
  { 997,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #997 = NEG_v4f32_S
  { 998,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #998 = NEG_v4i32
  { 999,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #999 = NEG_v4i32_S
  { 1000,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1000 = NEG_v8i16
  { 1001,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1001 = NEG_v8i16_S
  { 1002,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo110, -1 ,nullptr },  // Inst #1002 = NE_F32
  { 1003,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1003 = NE_F32_S
  { 1004,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo111, -1 ,nullptr },  // Inst #1004 = NE_F64
  { 1005,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1005 = NE_F64_S
  { 1006,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1006 = NE_I32
  { 1007,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1007 = NE_I32_S
  { 1008,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo112, -1 ,nullptr },  // Inst #1008 = NE_I64
  { 1009,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1009 = NE_I64_S
  { 1010,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1010 = NE_v16i8
  { 1011,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1011 = NE_v16i8_S
  { 1012,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1012 = NE_v2f64
  { 1013,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1013 = NE_v2f64_S
  { 1014,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1014 = NE_v4f32
  { 1015,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1015 = NE_v4f32_S
  { 1016,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1016 = NE_v4i32
  { 1017,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1017 = NE_v4i32_S
  { 1018,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1018 = NE_v8i16
  { 1019,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1019 = NE_v8i16_S
  { 1020,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1020 = NOP
  { 1021,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1021 = NOP_S
  { 1022,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1022 = NOT_v16i8
  { 1023,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1023 = NOT_v16i8_S
  { 1024,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1024 = NOT_v2i64
  { 1025,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1025 = NOT_v2i64_S
  { 1026,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1026 = NOT_v4i32
  { 1027,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1027 = NOT_v4i32_S
  { 1028,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1028 = NOT_v8i16
  { 1029,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1029 = NOT_v8i16_S
  { 1030,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1030 = OR_I32
  { 1031,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1031 = OR_I32_S
  { 1032,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1032 = OR_I64
  { 1033,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1033 = OR_I64_S
  { 1034,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1034 = OR_v16i8
  { 1035,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1035 = OR_v16i8_S
  { 1036,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1036 = OR_v2i64
  { 1037,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1037 = OR_v2i64_S
  { 1038,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1038 = OR_v4i32
  { 1039,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1039 = OR_v4i32_S
  { 1040,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1040 = OR_v8i16
  { 1041,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1041 = OR_v8i16_S
  { 1042,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1042 = PCALL_INDIRECT_VOID
  { 1043,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1043 = PCALL_INDIRECT_VOID_S
  { 1044,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo169, -1 ,nullptr },  // Inst #1044 = PCALL_INDIRECT_exnref
  { 1045,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1045 = PCALL_INDIRECT_exnref_S
  { 1046,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo118, -1 ,nullptr },  // Inst #1046 = PCALL_INDIRECT_f32
  { 1047,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1047 = PCALL_INDIRECT_f32_S
  { 1048,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo121, -1 ,nullptr },  // Inst #1048 = PCALL_INDIRECT_f64
  { 1049,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1049 = PCALL_INDIRECT_f64_S
  { 1050,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #1050 = PCALL_INDIRECT_i32
  { 1051,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1051 = PCALL_INDIRECT_i32_S
  { 1052,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo141, -1 ,nullptr },  // Inst #1052 = PCALL_INDIRECT_i64
  { 1053,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1053 = PCALL_INDIRECT_i64_S
  { 1054,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1054 = PCALL_INDIRECT_v16i8
  { 1055,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1055 = PCALL_INDIRECT_v16i8_S
  { 1056,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1056 = PCALL_INDIRECT_v2f64
  { 1057,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1057 = PCALL_INDIRECT_v2f64_S
  { 1058,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1058 = PCALL_INDIRECT_v2i64
  { 1059,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1059 = PCALL_INDIRECT_v2i64_S
  { 1060,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1060 = PCALL_INDIRECT_v4f32
  { 1061,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1061 = PCALL_INDIRECT_v4f32_S
  { 1062,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1062 = PCALL_INDIRECT_v4i32
  { 1063,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1063 = PCALL_INDIRECT_v4i32_S
  { 1064,	2,	1,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1064 = PCALL_INDIRECT_v8i16
  { 1065,	1,	0,	0,	0,	0|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1065 = PCALL_INDIRECT_v8i16_S
  { 1066,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo83, -1 ,nullptr },  // Inst #1066 = POPCNT_I32
  { 1067,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1067 = POPCNT_I32_S
  { 1068,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo84, -1 ,nullptr },  // Inst #1068 = POPCNT_I64
  { 1069,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1069 = POPCNT_I64_S
  { 1070,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1070 = PRET_CALL_INDIRECT
  { 1071,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1071 = PRET_CALL_INDIRECT_S
  { 1072,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1072 = REM_S_I32
  { 1073,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1073 = REM_S_I32_S
  { 1074,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1074 = REM_S_I64
  { 1075,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1075 = REM_S_I64_S
  { 1076,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1076 = REM_U_I32
  { 1077,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1077 = REM_U_I32_S
  { 1078,	3,	1,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1078 = REM_U_I64
  { 1079,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1079 = REM_U_I64_S
  { 1080,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo171, -1 ,nullptr },  // Inst #1080 = REPLACE_LANE_v16i8
  { 1081,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #1081 = REPLACE_LANE_v16i8_S
  { 1082,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo172, -1 ,nullptr },  // Inst #1082 = REPLACE_LANE_v2f64
  { 1083,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #1083 = REPLACE_LANE_v2f64_S
  { 1084,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo173, -1 ,nullptr },  // Inst #1084 = REPLACE_LANE_v2i64
  { 1085,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #1085 = REPLACE_LANE_v2i64_S
  { 1086,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo174, -1 ,nullptr },  // Inst #1086 = REPLACE_LANE_v4f32
  { 1087,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #1087 = REPLACE_LANE_v4f32_S
  { 1088,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo171, -1 ,nullptr },  // Inst #1088 = REPLACE_LANE_v4i32
  { 1089,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #1089 = REPLACE_LANE_v4i32_S
  { 1090,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo171, -1 ,nullptr },  // Inst #1090 = REPLACE_LANE_v8i16
  { 1091,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo114, -1 ,nullptr },  // Inst #1091 = REPLACE_LANE_v8i16_S
  { 1092,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo82, -1 ,nullptr },  // Inst #1092 = RETHROW
  { 1093,	0,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1093 = RETHROW_S
  { 1094,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo82, -1 ,nullptr },  // Inst #1094 = RETURN_EXNREF
  { 1095,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1095 = RETURN_EXNREF_S
  { 1096,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo106, -1 ,nullptr },  // Inst #1096 = RETURN_F32
  { 1097,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1097 = RETURN_F32_S
  { 1098,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo107, -1 ,nullptr },  // Inst #1098 = RETURN_F64
  { 1099,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1099 = RETURN_F64_S
  { 1100,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo65, -1 ,nullptr },  // Inst #1100 = RETURN_I32
  { 1101,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1101 = RETURN_I32_S
  { 1102,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo67, -1 ,nullptr },  // Inst #1102 = RETURN_I64
  { 1103,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1103 = RETURN_I64_S
  { 1104,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1104 = RETURN_VOID
  { 1105,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1105 = RETURN_VOID_S
  { 1106,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #1106 = RETURN_v16i8
  { 1107,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1107 = RETURN_v16i8_S
  { 1108,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #1108 = RETURN_v2f64
  { 1109,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1109 = RETURN_v2f64_S
  { 1110,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #1110 = RETURN_v2i64
  { 1111,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1111 = RETURN_v2i64_S
  { 1112,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #1112 = RETURN_v4f32
  { 1113,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1113 = RETURN_v4f32_S
  { 1114,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #1114 = RETURN_v4i32
  { 1115,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1115 = RETURN_v4i32_S
  { 1116,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo108, -1 ,nullptr },  // Inst #1116 = RETURN_v8i16
  { 1117,	0,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1117 = RETURN_v8i16_S
  { 1118,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #1118 = RET_CALL
  { 1119,	2,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Call)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #1119 = RET_CALL_INDIRECT
  { 1120,	2,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo68, -1 ,nullptr },  // Inst #1120 = RET_CALL_INDIRECT_S
  { 1121,	1,	0,	0,	0,	0|(1ULL<<MCID::Return)|(1ULL<<MCID::Call)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList2, ImplicitList1, OperandInfo75, -1 ,nullptr },  // Inst #1121 = RET_CALL_S
  { 1122,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1122 = ROTL_I32
  { 1123,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1123 = ROTL_I32_S
  { 1124,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1124 = ROTL_I64
  { 1125,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1125 = ROTL_I64_S
  { 1126,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1126 = ROTR_I32
  { 1127,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1127 = ROTR_I32_S
  { 1128,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1128 = ROTR_I64
  { 1129,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1129 = ROTR_I64_S
  { 1130,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo175, -1 ,nullptr },  // Inst #1130 = SELECT_EXNREF
  { 1131,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1131 = SELECT_EXNREF_S
  { 1132,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo176, -1 ,nullptr },  // Inst #1132 = SELECT_F32
  { 1133,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1133 = SELECT_F32_S
  { 1134,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo177, -1 ,nullptr },  // Inst #1134 = SELECT_F64
  { 1135,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1135 = SELECT_F64_S
  { 1136,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo178, -1 ,nullptr },  // Inst #1136 = SELECT_I32
  { 1137,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1137 = SELECT_I32_S
  { 1138,	4,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo179, -1 ,nullptr },  // Inst #1138 = SELECT_I64
  { 1139,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1139 = SELECT_I64_S
  { 1140,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1140 = SHL_I32
  { 1141,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1141 = SHL_I32_S
  { 1142,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1142 = SHL_I64
  { 1143,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1143 = SHL_I64_S
  { 1144,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1144 = SHL_v16i8
  { 1145,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1145 = SHL_v16i8_S
  { 1146,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1146 = SHL_v2i64
  { 1147,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1147 = SHL_v2i64_S
  { 1148,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1148 = SHL_v4i32
  { 1149,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1149 = SHL_v4i32_S
  { 1150,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1150 = SHL_v8i16
  { 1151,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1151 = SHL_v8i16_S
  { 1152,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1152 = SHR_S_I32
  { 1153,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1153 = SHR_S_I32_S
  { 1154,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1154 = SHR_S_I64
  { 1155,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1155 = SHR_S_I64_S
  { 1156,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1156 = SHR_S_v16i8
  { 1157,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1157 = SHR_S_v16i8_S
  { 1158,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1158 = SHR_S_v2i64
  { 1159,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1159 = SHR_S_v2i64_S
  { 1160,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1160 = SHR_S_v4i32
  { 1161,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1161 = SHR_S_v4i32_S
  { 1162,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1162 = SHR_S_v8i16
  { 1163,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1163 = SHR_S_v8i16_S
  { 1164,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1164 = SHR_U_I32
  { 1165,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1165 = SHR_U_I32_S
  { 1166,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1166 = SHR_U_I64
  { 1167,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1167 = SHR_U_I64_S
  { 1168,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1168 = SHR_U_v16i8
  { 1169,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1169 = SHR_U_v16i8_S
  { 1170,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1170 = SHR_U_v2i64
  { 1171,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1171 = SHR_U_v2i64_S
  { 1172,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1172 = SHR_U_v4i32
  { 1173,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1173 = SHR_U_v4i32_S
  { 1174,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo180, -1 ,nullptr },  // Inst #1174 = SHR_U_v8i16
  { 1175,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1175 = SHR_U_v8i16_S
  { 1176,	19,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo181, -1 ,nullptr },  // Inst #1176 = SHUFFLE
  { 1177,	16,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo94, -1 ,nullptr },  // Inst #1177 = SHUFFLE_S
  { 1178,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1178 = SPLAT_v16i8
  { 1179,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1179 = SPLAT_v16i8_S
  { 1180,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo182, -1 ,nullptr },  // Inst #1180 = SPLAT_v2f64
  { 1181,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1181 = SPLAT_v2f64_S
  { 1182,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo183, -1 ,nullptr },  // Inst #1182 = SPLAT_v2i64
  { 1183,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1183 = SPLAT_v2i64_S
  { 1184,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo184, -1 ,nullptr },  // Inst #1184 = SPLAT_v4f32
  { 1185,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1185 = SPLAT_v4f32_S
  { 1186,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1186 = SPLAT_v4i32
  { 1187,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1187 = SPLAT_v4i32_S
  { 1188,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo170, -1 ,nullptr },  // Inst #1188 = SPLAT_v8i16
  { 1189,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1189 = SPLAT_v8i16_S
  { 1190,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #1190 = SQRT_F32
  { 1191,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1191 = SQRT_F32_S
  { 1192,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #1192 = SQRT_F64
  { 1193,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1193 = SQRT_F64_S
  { 1194,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1194 = SQRT_v2f64
  { 1195,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1195 = SQRT_v2f64_S
  { 1196,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1196 = SQRT_v4f32
  { 1197,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1197 = SQRT_v4f32_S
  { 1198,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #1198 = STORE16_I32
  { 1199,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1199 = STORE16_I32_S
  { 1200,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #1200 = STORE16_I64
  { 1201,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1201 = STORE16_I64_S
  { 1202,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #1202 = STORE32_I64
  { 1203,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1203 = STORE32_I64_S
  { 1204,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #1204 = STORE8_I32
  { 1205,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1205 = STORE8_I32_S
  { 1206,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #1206 = STORE8_I64
  { 1207,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1207 = STORE8_I64_S
  { 1208,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo185, -1 ,nullptr },  // Inst #1208 = STORE_F32
  { 1209,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1209 = STORE_F32_S
  { 1210,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo186, -1 ,nullptr },  // Inst #1210 = STORE_F64
  { 1211,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1211 = STORE_F64_S
  { 1212,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo55, -1 ,nullptr },  // Inst #1212 = STORE_I32
  { 1213,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1213 = STORE_I32_S
  { 1214,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo56, -1 ,nullptr },  // Inst #1214 = STORE_I64
  { 1215,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1215 = STORE_I64_S
  { 1216,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo187, -1 ,nullptr },  // Inst #1216 = STORE_v16i8
  { 1217,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1217 = STORE_v16i8_S
  { 1218,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo187, -1 ,nullptr },  // Inst #1218 = STORE_v2f64
  { 1219,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1219 = STORE_v2f64_S
  { 1220,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo187, -1 ,nullptr },  // Inst #1220 = STORE_v2i64
  { 1221,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1221 = STORE_v2i64_S
  { 1222,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo187, -1 ,nullptr },  // Inst #1222 = STORE_v4f32
  { 1223,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1223 = STORE_v4f32_S
  { 1224,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo187, -1 ,nullptr },  // Inst #1224 = STORE_v4i32
  { 1225,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1225 = STORE_v4i32_S
  { 1226,	4,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo187, -1 ,nullptr },  // Inst #1226 = STORE_v8i16
  { 1227,	2,	0,	0,	0,	0|(1ULL<<MCID::MayStore)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo49, -1 ,nullptr },  // Inst #1227 = STORE_v8i16_S
  { 1228,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #1228 = SUB_F32
  { 1229,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1229 = SUB_F32_S
  { 1230,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #1230 = SUB_F64
  { 1231,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1231 = SUB_F64_S
  { 1232,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1232 = SUB_I32
  { 1233,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1233 = SUB_I32_S
  { 1234,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1234 = SUB_I64
  { 1235,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1235 = SUB_I64_S
  { 1236,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1236 = SUB_SAT_S_v16i8
  { 1237,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1237 = SUB_SAT_S_v16i8_S
  { 1238,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1238 = SUB_SAT_S_v8i16
  { 1239,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1239 = SUB_SAT_S_v8i16_S
  { 1240,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1240 = SUB_SAT_U_v16i8
  { 1241,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1241 = SUB_SAT_U_v16i8_S
  { 1242,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1242 = SUB_SAT_U_v8i16
  { 1243,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1243 = SUB_SAT_U_v8i16_S
  { 1244,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1244 = SUB_v16i8
  { 1245,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1245 = SUB_v16i8_S
  { 1246,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1246 = SUB_v2f64
  { 1247,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1247 = SUB_v2f64_S
  { 1248,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1248 = SUB_v2i64
  { 1249,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1249 = SUB_v2i64_S
  { 1250,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1250 = SUB_v4f32
  { 1251,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1251 = SUB_v4f32_S
  { 1252,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1252 = SUB_v4i32
  { 1253,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1253 = SUB_v4i32_S
  { 1254,	3,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1254 = SUB_v8i16
  { 1255,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1255 = SUB_v8i16_S
  { 1256,	3,	2,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo188, -1 ,nullptr },  // Inst #1256 = TEE_EXNREF
  { 1257,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1257 = TEE_EXNREF_S
  { 1258,	3,	2,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo36, -1 ,nullptr },  // Inst #1258 = TEE_F32
  { 1259,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1259 = TEE_F32_S
  { 1260,	3,	2,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo37, -1 ,nullptr },  // Inst #1260 = TEE_F64
  { 1261,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1261 = TEE_F64_S
  { 1262,	3,	2,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1262 = TEE_I32
  { 1263,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1263 = TEE_I32_S
  { 1264,	3,	2,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1264 = TEE_I64
  { 1265,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1265 = TEE_I64_S
  { 1266,	3,	2,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1266 = TEE_V128
  { 1267,	0,	0,	0,	0,	0|(1ULL<<MCID::CheapAsAMove)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1267 = TEE_V128_S
  { 1268,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::Variadic)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo189, -1 ,nullptr },  // Inst #1268 = THROW
  { 1269,	1,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo189, -1 ,nullptr },  // Inst #1269 = THROW_S
  { 1270,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo33, -1 ,nullptr },  // Inst #1270 = TRUNC_F32
  { 1271,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1271 = TRUNC_F32_S
  { 1272,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo34, -1 ,nullptr },  // Inst #1272 = TRUNC_F64
  { 1273,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1273 = TRUNC_F64_S
  { 1274,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #1274 = TRY
  { 1275,	1,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, ImplicitList3, ImplicitList3, OperandInfo60, -1 ,nullptr },  // Inst #1275 = TRY_S
  { 1276,	0,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1276 = UNREACHABLE
  { 1277,	0,	0,	0,	0,	0|(1ULL<<MCID::Barrier)|(1ULL<<MCID::Terminator)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1277 = UNREACHABLE_S
  { 1278,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo38, -1 ,nullptr },  // Inst #1278 = XOR_I32
  { 1279,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1279 = XOR_I32_S
  { 1280,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo39, -1 ,nullptr },  // Inst #1280 = XOR_I64
  { 1281,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1281 = XOR_I64_S
  { 1282,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1282 = XOR_v16i8
  { 1283,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1283 = XOR_v16i8_S
  { 1284,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1284 = XOR_v2i64
  { 1285,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1285 = XOR_v2i64_S
  { 1286,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1286 = XOR_v4i32
  { 1287,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1287 = XOR_v4i32_S
  { 1288,	3,	1,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo40, -1 ,nullptr },  // Inst #1288 = XOR_v8i16
  { 1289,	0,	0,	0,	0,	0|(1ULL<<MCID::Commutable)|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1289 = XOR_v8i16_S
  { 1290,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1290 = fp_to_sint_v2i64_v2f64
  { 1291,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1291 = fp_to_sint_v2i64_v2f64_S
  { 1292,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1292 = fp_to_sint_v4i32_v4f32
  { 1293,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1293 = fp_to_sint_v4i32_v4f32_S
  { 1294,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1294 = fp_to_uint_v2i64_v2f64
  { 1295,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1295 = fp_to_uint_v2i64_v2f64_S
  { 1296,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1296 = fp_to_uint_v4i32_v4f32
  { 1297,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1297 = fp_to_uint_v4i32_v4f32_S
  { 1298,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1298 = sint_to_fp_v2f64_v2i64
  { 1299,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1299 = sint_to_fp_v2f64_v2i64_S
  { 1300,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1300 = sint_to_fp_v4f32_v4i32
  { 1301,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1301 = sint_to_fp_v4f32_v4i32_S
  { 1302,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1302 = uint_to_fp_v2f64_v2i64
  { 1303,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1303 = uint_to_fp_v2f64_v2i64_S
  { 1304,	2,	1,	0,	0,	0|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, OperandInfo35, -1 ,nullptr },  // Inst #1304 = uint_to_fp_v4f32_v4i32
  { 1305,	0,	0,	0,	0,	0|(1ULL<<MCID::UnmodeledSideEffects)|(1ULL<<MCID::ExtraSrcRegAllocReq)|(1ULL<<MCID::ExtraDefRegAllocReq), 0x0ULL, nullptr, ImplicitList1, nullptr, -1 ,nullptr },  // Inst #1305 = uint_to_fp_v4f32_v4i32_S
};

extern const char WebAssemblyInstrNameData[] = {
  /* 0 */ 'G', '_', 'F', 'L', 'O', 'G', '1', '0', 0,
  /* 9 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '3', '2', 0,
  /* 28 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '3', '2', 0,
  /* 47 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '3', '2', 0,
  /* 66 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '3', '2', 0,
  /* 85 */ 'S', 'U', 'B', '_', 'F', '3', '2', 0,
  /* 93 */ 'T', 'R', 'U', 'N', 'C', '_', 'F', '3', '2', 0,
  /* 103 */ 'L', 'O', 'A', 'D', '_', 'F', '3', '2', 0,
  /* 112 */ 'A', 'D', 'D', '_', 'F', '3', '2', 0,
  /* 120 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'F', '3', '2', 0,
  /* 134 */ 'G', 'E', '_', 'F', '3', '2', 0,
  /* 141 */ 'L', 'E', '_', 'F', '3', '2', 0,
  /* 148 */ 'N', 'E', '_', 'F', '3', '2', 0,
  /* 155 */ 'S', 'T', 'O', 'R', 'E', '_', 'F', '3', '2', 0,
  /* 165 */ 'F', '6', '4', '_', 'P', 'R', 'O', 'M', 'O', 'T', 'E', '_', 'F', '3', '2', 0,
  /* 181 */ 'N', 'E', 'G', '_', 'F', '3', '2', 0,
  /* 189 */ 'C', 'E', 'I', 'L', '_', 'F', '3', '2', 0,
  /* 198 */ 'M', 'U', 'L', '_', 'F', '3', '2', 0,
  /* 206 */ 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', '_', 'F', '3', '2', 0,
  /* 219 */ 'M', 'I', 'N', '_', 'F', '3', '2', 0,
  /* 227 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'F', '3', '2', 0,
  /* 250 */ 'D', 'R', 'O', 'P', '_', 'F', '3', '2', 0,
  /* 259 */ 'E', 'Q', '_', 'F', '3', '2', 0,
  /* 266 */ 'F', 'L', 'O', 'O', 'R', '_', 'F', '3', '2', 0,
  /* 276 */ 'A', 'B', 'S', '_', 'F', '3', '2', 0,
  /* 284 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '3', '2', 0,
  /* 300 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '3', '2', 0,
  /* 316 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '3', '2', 0,
  /* 336 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '3', '2', 0,
  /* 356 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '3', '2', 0,
  /* 376 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '3', '2', 0,
  /* 396 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '3', '2', 0,
  /* 407 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '3', '2', 0,
  /* 422 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '3', '2', 0,
  /* 436 */ 'I', '3', '2', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'F', '3', '2', 0,
  /* 456 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '3', '2', 0,
  /* 471 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '3', '2', 0,
  /* 485 */ 'G', 'T', '_', 'F', '3', '2', 0,
  /* 492 */ 'L', 'T', '_', 'F', '3', '2', 0,
  /* 499 */ 'S', 'Q', 'R', 'T', '_', 'F', '3', '2', 0,
  /* 508 */ 'N', 'E', 'A', 'R', 'E', 'S', 'T', '_', 'F', '3', '2', 0,
  /* 520 */ 'C', 'O', 'N', 'S', 'T', '_', 'F', '3', '2', 0,
  /* 530 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '3', '2', 0,
  /* 546 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '3', '2', 0,
  /* 562 */ 'D', 'I', 'V', '_', 'F', '3', '2', 0,
  /* 570 */ 'M', 'A', 'X', '_', 'F', '3', '2', 0,
  /* 578 */ 'C', 'O', 'P', 'Y', '_', 'F', '3', '2', 0,
  /* 587 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '1', '6', '_', 'I', '3', '2', 0,
  /* 606 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '8', '_', 'I', '3', '2', 0,
  /* 624 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '3', '2', 0,
  /* 647 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '3', '2', 0,
  /* 669 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'S', 'U', 'B', '_', 'I', '3', '2', 0,
  /* 688 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'I', '3', '2', 0,
  /* 704 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '3', '2', 0,
  /* 727 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '3', '2', 0,
  /* 749 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'D', 'D', '_', 'I', '3', '2', 0,
  /* 768 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 791 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 813 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'N', 'D', '_', 'I', '3', '2', 0,
  /* 832 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'I', '3', '2', 0,
  /* 846 */ 'B', 'R', '_', 'T', 'A', 'B', 'L', 'E', '_', 'I', '3', '2', 0,
  /* 859 */ 'N', 'E', '_', 'I', '3', '2', 0,
  /* 866 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '_', 'I', '3', '2', 0,
  /* 883 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'S', 'I', 'Z', 'E', '_', 'I', '3', '2', 0,
  /* 899 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', 0,
  /* 926 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', 0,
  /* 952 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', 0,
  /* 975 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', 0,
  /* 999 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', 0,
  /* 1022 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', 0,
  /* 1042 */ 'S', 'H', 'L', '_', 'I', '3', '2', 0,
  /* 1050 */ 'R', 'O', 'T', 'L', '_', 'I', '3', '2', 0,
  /* 1059 */ 'M', 'U', 'L', '_', 'I', '3', '2', 0,
  /* 1067 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'E', 'X', 'C', 'E', 'P', 'T', 'I', 'O', 'N', '_', 'I', '3', '2', 0,
  /* 1089 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'I', '3', '2', 0,
  /* 1112 */ 'D', 'R', 'O', 'P', '_', 'I', '3', '2', 0,
  /* 1121 */ 'E', 'Q', '_', 'I', '3', '2', 0,
  /* 1128 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 1151 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 1173 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 1192 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 1214 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 1235 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'O', 'R', '_', 'I', '3', '2', 0,
  /* 1253 */ 'R', 'O', 'T', 'R', '_', 'I', '3', '2', 0,
  /* 1262 */ 'L', 'O', 'A', 'D', '1', '6', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1275 */ 'I', '3', '2', '_', 'E', 'X', 'T', 'E', 'N', 'D', '1', '6', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1294 */ 'L', 'O', 'A', 'D', '8', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1306 */ 'I', '3', '2', '_', 'E', 'X', 'T', 'E', 'N', 'D', '8', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1324 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1341 */ 'G', 'E', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1350 */ 'L', 'E', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1359 */ 'R', 'E', 'M', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1369 */ 'S', 'H', 'R', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1379 */ 'G', 'T', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1388 */ 'L', 'T', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1397 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1415 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1433 */ 'D', 'I', 'V', '_', 'S', '_', 'I', '3', '2', 0,
  /* 1443 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '3', '2', 0,
  /* 1454 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '3', '2', 0,
  /* 1469 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '3', '2', 0,
  /* 1483 */ 'F', '3', '2', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'I', '3', '2', 0,
  /* 1503 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '3', '2', 0,
  /* 1518 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '3', '2', 0,
  /* 1532 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'W', 'A', 'I', 'T', '_', 'I', '3', '2', 0,
  /* 1548 */ 'P', 'O', 'P', 'C', 'N', 'T', '_', 'I', '3', '2', 0,
  /* 1559 */ 'C', 'O', 'N', 'S', 'T', '_', 'I', '3', '2', 0,
  /* 1569 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '1', '6', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1589 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '8', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1608 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1625 */ 'G', 'E', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1634 */ 'L', 'E', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1643 */ 'R', 'E', 'M', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1653 */ 'S', 'H', 'R', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1663 */ 'G', 'T', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1672 */ 'L', 'T', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1681 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1699 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1717 */ 'D', 'I', 'V', '_', 'U', '_', 'I', '3', '2', 0,
  /* 1727 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'G', 'R', 'O', 'W', '_', 'I', '3', '2', 0,
  /* 1743 */ 'C', 'O', 'P', 'Y', '_', 'I', '3', '2', 0,
  /* 1752 */ 'C', 'L', 'Z', '_', 'I', '3', '2', 0,
  /* 1760 */ 'E', 'Q', 'Z', '_', 'I', '3', '2', 0,
  /* 1768 */ 'C', 'T', 'Z', '_', 'I', '3', '2', 0,
  /* 1776 */ 'f', 'p', '_', 't', 'o', '_', 's', 'i', 'n', 't', '_', 'v', '4', 'i', '3', '2', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1799 */ 'f', 'p', '_', 't', 'o', '_', 'u', 'i', 'n', 't', '_', 'v', '4', 'i', '3', '2', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1822 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1839 */ 'S', 'U', 'B', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1849 */ 'L', 'O', 'A', 'D', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1860 */ 'A', 'D', 'D', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1870 */ 'G', 'E', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1879 */ 'L', 'E', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1888 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1907 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1926 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1938 */ 'N', 'E', 'G', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1948 */ 'C', 'A', 'L', 'L', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1959 */ 'M', 'U', 'L', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1969 */ 'M', 'I', 'N', '_', 'v', '4', 'f', '3', '2', 0,
  /* 1979 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2004 */ 'E', 'Q', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2013 */ 'A', 'B', 'S', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2023 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2035 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2051 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2072 */ 'G', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2081 */ 'L', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2090 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2105 */ 'S', 'Q', 'R', 'T', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2116 */ 'D', 'I', 'V', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2126 */ 'M', 'A', 'X', '_', 'v', '4', 'f', '3', '2', 0,
  /* 2136 */ 'C', 'A', 'L', 'L', '_', 'f', '3', '2', 0,
  /* 2145 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'f', '3', '2', 0,
  /* 2164 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'f', '3', '2', 0,
  /* 2177 */ 's', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '4', 'f', '3', '2', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2200 */ 'u', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '4', 'f', '3', '2', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2223 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2240 */ 'S', 'U', 'B', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2250 */ 'L', 'O', 'A', 'D', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2261 */ 'A', 'D', 'D', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2271 */ 'A', 'N', 'D', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2281 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2300 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2319 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2331 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2345 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2359 */ 'N', 'E', 'G', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2369 */ 'S', 'H', 'L', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2379 */ 'C', 'A', 'L', 'L', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2390 */ 'M', 'U', 'L', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2400 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2425 */ 'E', 'Q', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2434 */ 'X', 'O', 'R', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2444 */ 'G', 'E', '_', 'S', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2455 */ 'L', 'E', '_', 'S', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2466 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2478 */ 'G', 'T', '_', 'S', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2489 */ 'L', 'T', '_', 'S', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2500 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2512 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2528 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2549 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2564 */ 'N', 'O', 'T', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2574 */ 'G', 'E', '_', 'U', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2585 */ 'L', 'E', '_', 'U', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2596 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2608 */ 'G', 'T', '_', 'U', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2619 */ 'L', 'T', '_', 'U', '_', 'v', '4', 'i', '3', '2', 0,
  /* 2630 */ 'C', 'A', 'L', 'L', '_', 'i', '3', '2', 0,
  /* 2639 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'i', '3', '2', 0,
  /* 2658 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'i', '3', '2', 0,
  /* 2671 */ 'G', '_', 'F', 'L', 'O', 'G', '2', 0,
  /* 2679 */ 'G', '_', 'F', 'E', 'X', 'P', '2', 0,
  /* 2687 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '6', '4', 0,
  /* 2706 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '6', '4', 0,
  /* 2725 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '6', '4', 0,
  /* 2744 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '6', '4', 0,
  /* 2763 */ 'S', 'U', 'B', '_', 'F', '6', '4', 0,
  /* 2771 */ 'T', 'R', 'U', 'N', 'C', '_', 'F', '6', '4', 0,
  /* 2781 */ 'L', 'O', 'A', 'D', '_', 'F', '6', '4', 0,
  /* 2790 */ 'A', 'D', 'D', '_', 'F', '6', '4', 0,
  /* 2798 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'F', '6', '4', 0,
  /* 2812 */ 'G', 'E', '_', 'F', '6', '4', 0,
  /* 2819 */ 'L', 'E', '_', 'F', '6', '4', 0,
  /* 2826 */ 'N', 'E', '_', 'F', '6', '4', 0,
  /* 2833 */ 'S', 'T', 'O', 'R', 'E', '_', 'F', '6', '4', 0,
  /* 2843 */ 'F', '3', '2', '_', 'D', 'E', 'M', 'O', 'T', 'E', '_', 'F', '6', '4', 0,
  /* 2858 */ 'N', 'E', 'G', '_', 'F', '6', '4', 0,
  /* 2866 */ 'C', 'E', 'I', 'L', '_', 'F', '6', '4', 0,
  /* 2875 */ 'M', 'U', 'L', '_', 'F', '6', '4', 0,
  /* 2883 */ 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', '_', 'F', '6', '4', 0,
  /* 2896 */ 'M', 'I', 'N', '_', 'F', '6', '4', 0,
  /* 2904 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'F', '6', '4', 0,
  /* 2927 */ 'D', 'R', 'O', 'P', '_', 'F', '6', '4', 0,
  /* 2936 */ 'E', 'Q', '_', 'F', '6', '4', 0,
  /* 2943 */ 'F', 'L', 'O', 'O', 'R', '_', 'F', '6', '4', 0,
  /* 2953 */ 'A', 'B', 'S', '_', 'F', '6', '4', 0,
  /* 2961 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '6', '4', 0,
  /* 2977 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '6', '4', 0,
  /* 2993 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '6', '4', 0,
  /* 3013 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '6', '4', 0,
  /* 3033 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '6', '4', 0,
  /* 3053 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '6', '4', 0,
  /* 3073 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '6', '4', 0,
  /* 3084 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '6', '4', 0,
  /* 3099 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '6', '4', 0,
  /* 3113 */ 'I', '6', '4', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'F', '6', '4', 0,
  /* 3133 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '6', '4', 0,
  /* 3148 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '6', '4', 0,
  /* 3162 */ 'G', 'T', '_', 'F', '6', '4', 0,
  /* 3169 */ 'L', 'T', '_', 'F', '6', '4', 0,
  /* 3176 */ 'S', 'Q', 'R', 'T', '_', 'F', '6', '4', 0,
  /* 3185 */ 'N', 'E', 'A', 'R', 'E', 'S', 'T', '_', 'F', '6', '4', 0,
  /* 3197 */ 'C', 'O', 'N', 'S', 'T', '_', 'F', '6', '4', 0,
  /* 3207 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '6', '4', 0,
  /* 3223 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '6', '4', 0,
  /* 3239 */ 'D', 'I', 'V', '_', 'F', '6', '4', 0,
  /* 3247 */ 'M', 'A', 'X', '_', 'F', '6', '4', 0,
  /* 3255 */ 'C', 'O', 'P', 'Y', '_', 'F', '6', '4', 0,
  /* 3264 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '3', '2', '_', 'I', '6', '4', 0,
  /* 3283 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '1', '6', '_', 'I', '6', '4', 0,
  /* 3302 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '8', '_', 'I', '6', '4', 0,
  /* 3320 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '6', '4', 0,
  /* 3343 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '6', '4', 0,
  /* 3366 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '6', '4', 0,
  /* 3388 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'S', 'U', 'B', '_', 'I', '6', '4', 0,
  /* 3407 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'I', '6', '4', 0,
  /* 3423 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '6', '4', 0,
  /* 3446 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '6', '4', 0,
  /* 3469 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '6', '4', 0,
  /* 3491 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'D', 'D', '_', 'I', '6', '4', 0,
  /* 3510 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 3533 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 3556 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 3578 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'N', 'D', '_', 'I', '6', '4', 0,
  /* 3597 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'I', '6', '4', 0,
  /* 3611 */ 'B', 'R', '_', 'T', 'A', 'B', 'L', 'E', '_', 'I', '6', '4', 0,
  /* 3624 */ 'N', 'E', '_', 'I', '6', '4', 0,
  /* 3631 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '_', 'I', '6', '4', 0,
  /* 3648 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3675 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3702 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3728 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3751 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3775 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3799 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3822 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', 0,
  /* 3842 */ 'S', 'H', 'L', '_', 'I', '6', '4', 0,
  /* 3850 */ 'R', 'O', 'T', 'L', '_', 'I', '6', '4', 0,
  /* 3859 */ 'M', 'U', 'L', '_', 'I', '6', '4', 0,
  /* 3867 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'I', '6', '4', 0,
  /* 3890 */ 'I', '3', '2', '_', 'W', 'R', 'A', 'P', '_', 'I', '6', '4', 0,
  /* 3903 */ 'D', 'R', 'O', 'P', '_', 'I', '6', '4', 0,
  /* 3912 */ 'E', 'Q', '_', 'I', '6', '4', 0,
  /* 3919 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 3942 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 3965 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 3987 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 4006 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 4028 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 4050 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 4071 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'O', 'R', '_', 'I', '6', '4', 0,
  /* 4089 */ 'R', 'O', 'T', 'R', '_', 'I', '6', '4', 0,
  /* 4098 */ 'L', 'O', 'A', 'D', '3', '2', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4111 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '3', '2', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4130 */ 'L', 'O', 'A', 'D', '1', '6', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4143 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '1', '6', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4162 */ 'L', 'O', 'A', 'D', '8', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4174 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '8', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4192 */ 'G', 'E', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4201 */ 'L', 'E', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4210 */ 'R', 'E', 'M', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4220 */ 'S', 'H', 'R', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4230 */ 'G', 'T', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4239 */ 'L', 'T', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4248 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4266 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4284 */ 'D', 'I', 'V', '_', 'S', '_', 'I', '6', '4', 0,
  /* 4294 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '6', '4', 0,
  /* 4305 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '6', '4', 0,
  /* 4320 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '6', '4', 0,
  /* 4334 */ 'F', '6', '4', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'I', '6', '4', 0,
  /* 4354 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '6', '4', 0,
  /* 4369 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '6', '4', 0,
  /* 4383 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'W', 'A', 'I', 'T', '_', 'I', '6', '4', 0,
  /* 4399 */ 'P', 'O', 'P', 'C', 'N', 'T', '_', 'I', '6', '4', 0,
  /* 4410 */ 'C', 'O', 'N', 'S', 'T', '_', 'I', '6', '4', 0,
  /* 4420 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '3', '2', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4440 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '1', '6', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4460 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '8', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4479 */ 'G', 'E', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4488 */ 'L', 'E', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4497 */ 'R', 'E', 'M', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4507 */ 'S', 'H', 'R', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4517 */ 'G', 'T', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4526 */ 'L', 'T', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4535 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4553 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4571 */ 'D', 'I', 'V', '_', 'U', '_', 'I', '6', '4', 0,
  /* 4581 */ 'C', 'O', 'P', 'Y', '_', 'I', '6', '4', 0,
  /* 4590 */ 'C', 'L', 'Z', '_', 'I', '6', '4', 0,
  /* 4598 */ 'E', 'Q', 'Z', '_', 'I', '6', '4', 0,
  /* 4606 */ 'C', 'T', 'Z', '_', 'I', '6', '4', 0,
  /* 4614 */ 'f', 'p', '_', 't', 'o', '_', 's', 'i', 'n', 't', '_', 'v', '2', 'i', '6', '4', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4637 */ 'f', 'p', '_', 't', 'o', '_', 'u', 'i', 'n', 't', '_', 'v', '2', 'i', '6', '4', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4660 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4677 */ 'S', 'U', 'B', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4687 */ 'L', 'O', 'A', 'D', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4698 */ 'A', 'D', 'D', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4708 */ 'G', 'E', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4717 */ 'L', 'E', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4726 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4745 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4764 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4776 */ 'N', 'E', 'G', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4786 */ 'C', 'A', 'L', 'L', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4797 */ 'M', 'U', 'L', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4807 */ 'M', 'I', 'N', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4817 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4842 */ 'E', 'Q', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4851 */ 'A', 'B', 'S', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4861 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4873 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4889 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4910 */ 'G', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4919 */ 'L', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4928 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4943 */ 'S', 'Q', 'R', 'T', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4954 */ 'D', 'I', 'V', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4964 */ 'M', 'A', 'X', '_', 'v', '2', 'f', '6', '4', 0,
  /* 4974 */ 'C', 'A', 'L', 'L', '_', 'f', '6', '4', 0,
  /* 4983 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'f', '6', '4', 0,
  /* 5002 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'f', '6', '4', 0,
  /* 5015 */ 's', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '2', 'f', '6', '4', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5038 */ 'u', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '2', 'f', '6', '4', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5061 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5078 */ 'S', 'U', 'B', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5088 */ 'L', 'O', 'A', 'D', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5099 */ 'A', 'D', 'D', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5109 */ 'A', 'N', 'D', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5119 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5138 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5157 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5169 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5183 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5197 */ 'N', 'E', 'G', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5207 */ 'S', 'H', 'L', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5217 */ 'C', 'A', 'L', 'L', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5228 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5253 */ 'X', 'O', 'R', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5263 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5275 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5287 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5303 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5324 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5339 */ 'N', 'O', 'T', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5349 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '2', 'i', '6', '4', 0,
  /* 5361 */ 'C', 'A', 'L', 'L', '_', 'i', '6', '4', 0,
  /* 5370 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'i', '6', '4', 0,
  /* 5389 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'i', '6', '4', 0,
  /* 5402 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5419 */ 'S', 'U', 'B', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5429 */ 'L', 'O', 'A', 'D', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5440 */ 'A', 'D', 'D', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5450 */ 'A', 'N', 'D', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5460 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5479 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5491 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5505 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5519 */ 'N', 'E', 'G', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5529 */ 'S', 'H', 'L', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5539 */ 'C', 'A', 'L', 'L', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5550 */ 'M', 'U', 'L', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5560 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5585 */ 'E', 'Q', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5594 */ 'X', 'O', 'R', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5604 */ 'G', 'E', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5615 */ 'L', 'E', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5626 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5638 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5654 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5670 */ 'G', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5681 */ 'L', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5692 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5704 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5720 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5741 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5756 */ 'N', 'O', 'T', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5766 */ 'G', 'E', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5777 */ 'L', 'E', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5788 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5800 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5816 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5832 */ 'G', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5843 */ 'L', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', 0,
  /* 5854 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'V', '1', '2', '8', 0,
  /* 5869 */ 'D', 'R', 'O', 'P', '_', 'V', '1', '2', '8', 0,
  /* 5879 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'V', '1', '2', '8', 0,
  /* 5895 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'V', '1', '2', '8', 0,
  /* 5910 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'V', '1', '2', '8', 0,
  /* 5926 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'V', '1', '2', '8', 0,
  /* 5941 */ 'C', 'O', 'P', 'Y', '_', 'V', '1', '2', '8', 0,
  /* 5951 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '1', '6', 'i', '8', 0,
  /* 5968 */ 'S', 'U', 'B', '_', 'v', '1', '6', 'i', '8', 0,
  /* 5978 */ 'L', 'O', 'A', 'D', '_', 'v', '1', '6', 'i', '8', 0,
  /* 5989 */ 'A', 'D', 'D', '_', 'v', '1', '6', 'i', '8', 0,
  /* 5999 */ 'A', 'N', 'D', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6009 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6028 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6040 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6054 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6068 */ 'N', 'E', 'G', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6078 */ 'S', 'H', 'L', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6088 */ 'C', 'A', 'L', 'L', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6099 */ 'M', 'U', 'L', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6109 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6134 */ 'E', 'Q', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6143 */ 'X', 'O', 'R', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6153 */ 'G', 'E', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6164 */ 'L', 'E', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6175 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6187 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6203 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6219 */ 'G', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6230 */ 'L', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6241 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6253 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6269 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6290 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6305 */ 'N', 'O', 'T', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6315 */ 'G', 'E', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6326 */ 'L', 'E', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6337 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6349 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6365 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6381 */ 'G', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6392 */ 'L', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', 0,
  /* 6403 */ 'G', '_', 'F', 'M', 'A', 0,
  /* 6409 */ 'G', '_', 'F', 'S', 'U', 'B', 0,
  /* 6416 */ 'G', '_', 'S', 'U', 'B', 0,
  /* 6422 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'S', 'U', 'B', 0,
  /* 6438 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', 0,
  /* 6450 */ 'G', '_', 'F', 'P', 'T', 'R', 'U', 'N', 'C', 0,
  /* 6460 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 6478 */ 'G', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 6486 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'T', 'R', 'U', 'N', 'C', 0,
  /* 6507 */ 'G', '_', 'S', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 6518 */ 'G', '_', 'Z', 'E', 'X', 'T', 'L', 'O', 'A', 'D', 0,
  /* 6529 */ 'G', '_', 'L', 'O', 'A', 'D', 0,
  /* 6536 */ 'G', '_', 'F', 'A', 'D', 'D', 0,
  /* 6543 */ 'G', '_', 'A', 'D', 'D', 0,
  /* 6549 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'D', 'D', 0,
  /* 6565 */ 'C', 'A', 'L', 'L', '_', 'V', 'O', 'I', 'D', 0,
  /* 6575 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'V', 'O', 'I', 'D', 0,
  /* 6599 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'V', 'O', 'I', 'D', 0,
  /* 6619 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'N', 'A', 'N', 'D', 0,
  /* 6636 */ 'G', '_', 'A', 'N', 'D', 0,
  /* 6642 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'A', 'N', 'D', 0,
  /* 6658 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'E', 'N', 'D', 0,
  /* 6671 */ 'G', '_', 'B', 'R', 'C', 'O', 'N', 'D', 0,
  /* 6680 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'R', 'O', 'U', 'N', 'D', 0,
  /* 6698 */ 'L', 'O', 'A', 'D', '_', 'S', 'T', 'A', 'C', 'K', '_', 'G', 'U', 'A', 'R', 'D', 0,
  /* 6715 */ 'G', '_', 'S', 'S', 'U', 'B', 'E', 0,
  /* 6723 */ 'G', '_', 'U', 'S', 'U', 'B', 'E', 0,
  /* 6731 */ 'G', '_', 'F', 'E', 'N', 'C', 'E', 0,
  /* 6739 */ 'C', 'O', 'M', 'P', 'I', 'L', 'E', 'R', '_', 'F', 'E', 'N', 'C', 'E', 0,
  /* 6754 */ 'R', 'E', 'G', '_', 'S', 'E', 'Q', 'U', 'E', 'N', 'C', 'E', 0,
  /* 6767 */ 'G', '_', 'S', 'A', 'D', 'D', 'E', 0,
  /* 6775 */ 'G', '_', 'U', 'A', 'D', 'D', 'E', 0,
  /* 6783 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 6798 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', '_', 'I', 'E', 'E', 'E', 0,
  /* 6813 */ 'U', 'N', 'R', 'E', 'A', 'C', 'H', 'A', 'B', 'L', 'E', 0,
  /* 6825 */ 'G', '_', 'J', 'U', 'M', 'P', '_', 'T', 'A', 'B', 'L', 'E', 0,
  /* 6838 */ 'B', 'U', 'N', 'D', 'L', 'E', 0,
  /* 6845 */ 'S', 'H', 'U', 'F', 'F', 'L', 'E', 0,
  /* 6853 */ 'L', 'O', 'C', 'A', 'L', '_', 'E', 'S', 'C', 'A', 'P', 'E', 0,
  /* 6866 */ 'G', '_', 'S', 'T', 'O', 'R', 'E', 0,
  /* 6874 */ 'E', 'L', 'S', 'E', 0,
  /* 6879 */ 'D', 'B', 'G', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 6889 */ 'G', '_', 'G', 'L', 'O', 'B', 'A', 'L', '_', 'V', 'A', 'L', 'U', 'E', 0,
  /* 6904 */ 'G', '_', 'F', 'C', 'A', 'N', 'O', 'N', 'I', 'C', 'A', 'L', 'I', 'Z', 'E', 0,
  /* 6920 */ 'G', '_', 'C', 'T', 'L', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 6938 */ 'G', '_', 'C', 'T', 'T', 'Z', '_', 'Z', 'E', 'R', 'O', '_', 'U', 'N', 'D', 'E', 'F', 0,
  /* 6956 */ 'G', '_', 'I', 'M', 'P', 'L', 'I', 'C', 'I', 'T', '_', 'D', 'E', 'F', 0,
  /* 6971 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 6988 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7014 */ 'D', 'R', 'O', 'P', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7026 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7040 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7058 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7075 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7093 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7110 */ 'C', 'O', 'P', 'Y', '_', 'E', 'X', 'N', 'R', 'E', 'F', 0,
  /* 7122 */ 'E', 'N', 'D', '_', 'I', 'F', 0,
  /* 7129 */ 'B', 'R', '_', 'I', 'F', 0,
  /* 7135 */ 'G', '_', 'F', 'N', 'E', 'G', 0,
  /* 7142 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 7157 */ 'I', 'N', 'S', 'E', 'R', 'T', '_', 'S', 'U', 'B', 'R', 'E', 'G', 0,
  /* 7171 */ 'S', 'U', 'B', 'R', 'E', 'G', '_', 'T', 'O', '_', 'R', 'E', 'G', 0,
  /* 7185 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', 0,
  /* 7202 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', 0,
  /* 7219 */ 'G', '_', 'F', 'L', 'O', 'G', 0,
  /* 7226 */ 'G', '_', 'V', 'A', 'A', 'R', 'G', 0,
  /* 7234 */ 'R', 'E', 'T', 'H', 'R', 'O', 'W', '_', 'I', 'N', '_', 'C', 'A', 'T', 'C', 'H', 0,
  /* 7251 */ 'G', '_', 'S', 'M', 'U', 'L', 'H', 0,
  /* 7259 */ 'G', '_', 'U', 'M', 'U', 'L', 'H', 0,
  /* 7267 */ 'G', '_', 'P', 'H', 'I', 0,
  /* 7273 */ 'G', '_', 'F', 'P', 'T', 'O', 'S', 'I', 0,
  /* 7282 */ 'G', '_', 'F', 'P', 'T', 'O', 'U', 'I', 0,
  /* 7291 */ 'E', 'N', 'D', '_', 'B', 'L', 'O', 'C', 'K', 0,
  /* 7301 */ 'G', '_', 'P', 'T', 'R', '_', 'M', 'A', 'S', 'K', 0,
  /* 7312 */ 'G', 'C', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 7321 */ 'D', 'B', 'G', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 7331 */ 'E', 'H', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 7340 */ 'A', 'N', 'N', 'O', 'T', 'A', 'T', 'I', 'O', 'N', '_', 'L', 'A', 'B', 'E', 'L', 0,
  /* 7357 */ 'I', 'C', 'A', 'L', 'L', '_', 'B', 'R', 'A', 'N', 'C', 'H', '_', 'F', 'U', 'N', 'N', 'E', 'L', 0,
  /* 7377 */ 'G', '_', 'S', 'H', 'L', 0,
  /* 7383 */ 'G', '_', 'F', 'C', 'E', 'I', 'L', 0,
  /* 7391 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'A', 'I', 'L', '_', 'C', 'A', 'L', 'L', 0,
  /* 7411 */ 'R', 'E', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 7420 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'T', 'Y', 'P', 'E', 'D', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 7447 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'E', 'V', 'E', 'N', 'T', '_', 'C', 'A', 'L', 'L', 0,
  /* 7468 */ 'F', 'E', 'N', 'T', 'R', 'Y', '_', 'C', 'A', 'L', 'L', 0,
  /* 7480 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'F', 'I', 'L', 'L', 0,
  /* 7492 */ 'K', 'I', 'L', 'L', 0,
  /* 7497 */ 'G', '_', 'F', 'M', 'U', 'L', 0,
  /* 7504 */ 'G', '_', 'M', 'U', 'L', 0,
  /* 7510 */ 'G', '_', 'F', 'R', 'E', 'M', 0,
  /* 7517 */ 'G', '_', 'S', 'R', 'E', 'M', 0,
  /* 7524 */ 'G', '_', 'U', 'R', 'E', 'M', 0,
  /* 7531 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', 0,
  /* 7541 */ 'G', '_', 'F', 'M', 'I', 'N', 'I', 'M', 'U', 'M', 0,
  /* 7552 */ 'G', '_', 'F', 'M', 'A', 'X', 'I', 'M', 'U', 'M', 0,
  /* 7563 */ 'G', '_', 'F', 'M', 'I', 'N', 'N', 'U', 'M', 0,
  /* 7573 */ 'G', '_', 'F', 'M', 'A', 'X', 'N', 'U', 'M', 0,
  /* 7583 */ 'G', '_', 'F', 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', 0,
  /* 7595 */ 'G', '_', 'S', 'M', 'I', 'N', 0,
  /* 7602 */ 'G', '_', 'U', 'M', 'I', 'N', 0,
  /* 7609 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'I', 'N', 0,
  /* 7626 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'I', 'N', 0,
  /* 7642 */ 'G', '_', 'F', 'S', 'I', 'N', 0,
  /* 7649 */ 'E', 'N', 'D', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', 0,
  /* 7662 */ 'C', 'F', 'I', '_', 'I', 'N', 'S', 'T', 'R', 'U', 'C', 'T', 'I', 'O', 'N', 0,
  /* 7678 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'D', 'O', 'W', 'N', 0,
  /* 7695 */ 'B', 'R', '_', 'O', 'N', '_', 'E', 'X', 'N', 0,
  /* 7705 */ 'G', '_', 'S', 'S', 'U', 'B', 'O', 0,
  /* 7713 */ 'G', '_', 'U', 'S', 'U', 'B', 'O', 0,
  /* 7721 */ 'G', '_', 'S', 'A', 'D', 'D', 'O', 0,
  /* 7729 */ 'G', '_', 'U', 'A', 'D', 'D', 'O', 0,
  /* 7737 */ 'G', '_', 'S', 'M', 'U', 'L', 'O', 0,
  /* 7745 */ 'G', '_', 'U', 'M', 'U', 'L', 'O', 0,
  /* 7753 */ 'S', 'T', 'A', 'C', 'K', 'M', 'A', 'P', 0,
  /* 7762 */ 'G', '_', 'B', 'S', 'W', 'A', 'P', 0,
  /* 7770 */ 'G', '_', 'G', 'E', 'P', 0,
  /* 7776 */ 'G', '_', 'S', 'I', 'T', 'O', 'F', 'P', 0,
  /* 7785 */ 'G', '_', 'U', 'I', 'T', 'O', 'F', 'P', 0,
  /* 7794 */ 'G', '_', 'F', 'C', 'M', 'P', 0,
  /* 7801 */ 'G', '_', 'I', 'C', 'M', 'P', 0,
  /* 7808 */ 'N', 'O', 'P', 0,
  /* 7812 */ 'E', 'N', 'D', '_', 'L', 'O', 'O', 'P', 0,
  /* 7821 */ 'G', '_', 'C', 'T', 'P', 'O', 'P', 0,
  /* 7829 */ 'D', 'A', 'T', 'A', '_', 'D', 'R', 'O', 'P', 0,
  /* 7839 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'O', 'P', 0,
  /* 7852 */ 'F', 'A', 'U', 'L', 'T', 'I', 'N', 'G', '_', 'O', 'P', 0,
  /* 7864 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'U', 'P', 0,
  /* 7879 */ 'G', '_', 'F', 'E', 'X', 'P', 0,
  /* 7886 */ 'G', '_', 'B', 'R', 0,
  /* 7891 */ 'I', 'N', 'L', 'I', 'N', 'E', 'A', 'S', 'M', '_', 'B', 'R', 0,
  /* 7904 */ 'G', '_', 'B', 'L', 'O', 'C', 'K', '_', 'A', 'D', 'D', 'R', 0,
  /* 7917 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'N', 'T', 'E', 'R', 0,
  /* 7942 */ 'G', '_', 'A', 'S', 'H', 'R', 0,
  /* 7949 */ 'G', '_', 'L', 'S', 'H', 'R', 0,
  /* 7956 */ 'G', '_', 'F', 'F', 'L', 'O', 'O', 'R', 0,
  /* 7965 */ 'G', '_', 'B', 'U', 'I', 'L', 'D', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 7980 */ 'G', '_', 'S', 'H', 'U', 'F', 'F', 'L', 'E', '_', 'V', 'E', 'C', 'T', 'O', 'R', 0,
  /* 7997 */ 'G', '_', 'X', 'O', 'R', 0,
  /* 8003 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'X', 'O', 'R', 0,
  /* 8019 */ 'G', '_', 'O', 'R', 0,
  /* 8024 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'O', 'R', 0,
  /* 8039 */ 'G', '_', 'I', 'N', 'T', 'T', 'O', 'P', 'T', 'R', 0,
  /* 8050 */ 'G', '_', 'F', 'A', 'B', 'S', 0,
  /* 8057 */ 'G', '_', 'U', 'N', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 8074 */ 'G', '_', 'M', 'E', 'R', 'G', 'E', '_', 'V', 'A', 'L', 'U', 'E', 'S', 0,
  /* 8089 */ 'G', '_', 'F', 'C', 'O', 'S', 0,
  /* 8096 */ 'G', '_', 'C', 'O', 'N', 'C', 'A', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', 'S', 0,
  /* 8113 */ 'C', 'O', 'P', 'Y', '_', 'T', 'O', '_', 'R', 'E', 'G', 'C', 'L', 'A', 'S', 'S', 0,
  /* 8130 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'W', 'I', 'T', 'H', '_', 'S', 'U', 'C', 'C', 'E', 'S', 'S', 0,
  /* 8160 */ 'B', 'R', '_', 'U', 'N', 'L', 'E', 'S', 'S', 0,
  /* 8170 */ 'G', '_', 'I', 'N', 'T', 'R', 'I', 'N', 'S', 'I', 'C', '_', 'W', '_', 'S', 'I', 'D', 'E', '_', 'E', 'F', 'F', 'E', 'C', 'T', 'S', 0,
  /* 8197 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8218 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8239 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8260 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8281 */ 'S', 'U', 'B', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8291 */ 'T', 'R', 'U', 'N', 'C', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8303 */ 'L', 'O', 'A', 'D', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8314 */ 'A', 'D', 'D', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8324 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8340 */ 'G', 'E', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8349 */ 'L', 'E', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8358 */ 'N', 'E', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8367 */ 'S', 'T', 'O', 'R', 'E', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8379 */ 'F', '6', '4', '_', 'P', 'R', 'O', 'M', 'O', 'T', 'E', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8397 */ 'N', 'E', 'G', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8407 */ 'C', 'E', 'I', 'L', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8418 */ 'M', 'U', 'L', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8428 */ 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8443 */ 'M', 'I', 'N', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8453 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8478 */ 'D', 'R', 'O', 'P', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8489 */ 'E', 'Q', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8498 */ 'F', 'L', 'O', 'O', 'R', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8510 */ 'A', 'B', 'S', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8520 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8538 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8556 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8578 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8600 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8622 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8644 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8657 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8674 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8690 */ 'I', '3', '2', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8712 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8729 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8745 */ 'G', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8754 */ 'L', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8763 */ 'S', 'Q', 'R', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8774 */ 'N', 'E', 'A', 'R', 'E', 'S', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8788 */ 'C', 'O', 'N', 'S', 'T', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8800 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8818 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8836 */ 'D', 'I', 'V', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8846 */ 'M', 'A', 'X', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8856 */ 'C', 'O', 'P', 'Y', '_', 'F', '3', '2', '_', 'S', 0,
  /* 8867 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '1', '6', '_', 'I', '3', '2', '_', 'S', 0,
  /* 8888 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '8', '_', 'I', '3', '2', '_', 'S', 0,
  /* 8908 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '3', '2', '_', 'S', 0,
  /* 8933 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '3', '2', '_', 'S', 0,
  /* 8957 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'S', 'U', 'B', '_', 'I', '3', '2', '_', 'S', 0,
  /* 8978 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 8996 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9021 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9045 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'D', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9066 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9091 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9115 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'N', 'D', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9136 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9152 */ 'B', 'R', '_', 'T', 'A', 'B', 'L', 'E', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9167 */ 'N', 'E', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9176 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9195 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'S', 'I', 'Z', 'E', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9213 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9242 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9270 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9295 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9321 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9346 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9368 */ 'S', 'H', 'L', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9378 */ 'R', 'O', 'T', 'L', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9389 */ 'M', 'U', 'L', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9399 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'E', 'X', 'C', 'E', 'P', 'T', 'I', 'O', 'N', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9423 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9448 */ 'D', 'R', 'O', 'P', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9459 */ 'E', 'Q', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9468 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9493 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9517 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'O', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9538 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'O', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9562 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'O', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9585 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'O', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9605 */ 'R', 'O', 'T', 'R', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9616 */ 'L', 'O', 'A', 'D', '1', '6', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9631 */ 'I', '3', '2', '_', 'E', 'X', 'T', 'E', 'N', 'D', '1', '6', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9652 */ 'L', 'O', 'A', 'D', '8', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9666 */ 'I', '3', '2', '_', 'E', 'X', 'T', 'E', 'N', 'D', '8', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9686 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9705 */ 'G', 'E', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9716 */ 'L', 'E', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9727 */ 'R', 'E', 'M', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9739 */ 'S', 'H', 'R', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9751 */ 'G', 'T', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9762 */ 'L', 'T', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9773 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9793 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9813 */ 'D', 'I', 'V', '_', 'S', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9825 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9838 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9855 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9871 */ 'F', '3', '2', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9893 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9910 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9926 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'W', 'A', 'I', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9944 */ 'P', 'O', 'P', 'C', 'N', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9957 */ 'C', 'O', 'N', 'S', 'T', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9969 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '1', '6', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 9991 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '8', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10012 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10031 */ 'G', 'E', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10042 */ 'L', 'E', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10053 */ 'R', 'E', 'M', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10065 */ 'S', 'H', 'R', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10077 */ 'G', 'T', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10088 */ 'L', 'T', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10099 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10119 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10139 */ 'D', 'I', 'V', '_', 'U', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10151 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'G', 'R', 'O', 'W', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10169 */ 'C', 'O', 'P', 'Y', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10180 */ 'C', 'L', 'Z', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10190 */ 'E', 'Q', 'Z', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10200 */ 'C', 'T', 'Z', '_', 'I', '3', '2', '_', 'S', 0,
  /* 10210 */ 'f', 'p', '_', 't', 'o', '_', 's', 'i', 'n', 't', '_', 'v', '4', 'i', '3', '2', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10235 */ 'f', 'p', '_', 't', 'o', '_', 'u', 'i', 'n', 't', '_', 'v', '4', 'i', '3', '2', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10260 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10279 */ 'S', 'U', 'B', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10291 */ 'L', 'O', 'A', 'D', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10304 */ 'A', 'D', 'D', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10316 */ 'G', 'E', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10327 */ 'L', 'E', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10338 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10359 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10380 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10394 */ 'N', 'E', 'G', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10406 */ 'C', 'A', 'L', 'L', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10419 */ 'M', 'U', 'L', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10431 */ 'M', 'I', 'N', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10443 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10470 */ 'E', 'Q', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10481 */ 'A', 'B', 'S', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10493 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10507 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10525 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10548 */ 'G', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10559 */ 'L', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10570 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10587 */ 'S', 'Q', 'R', 'T', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10600 */ 'D', 'I', 'V', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10612 */ 'M', 'A', 'X', '_', 'v', '4', 'f', '3', '2', '_', 'S', 0,
  /* 10624 */ 'C', 'A', 'L', 'L', '_', 'f', '3', '2', '_', 'S', 0,
  /* 10635 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'f', '3', '2', '_', 'S', 0,
  /* 10656 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'f', '3', '2', '_', 'S', 0,
  /* 10671 */ 's', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '4', 'f', '3', '2', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10696 */ 'u', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '4', 'f', '3', '2', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10721 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10740 */ 'S', 'U', 'B', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10752 */ 'L', 'O', 'A', 'D', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10765 */ 'A', 'D', 'D', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10777 */ 'A', 'N', 'D', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10789 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10810 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10831 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10845 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10861 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10877 */ 'N', 'E', 'G', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10889 */ 'S', 'H', 'L', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10901 */ 'C', 'A', 'L', 'L', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10914 */ 'M', 'U', 'L', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10926 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10953 */ 'E', 'Q', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10964 */ 'X', 'O', 'R', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10976 */ 'G', 'E', '_', 'S', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 10989 */ 'L', 'E', '_', 'S', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11002 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11016 */ 'G', 'T', '_', 'S', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11029 */ 'L', 'T', '_', 'S', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11042 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11056 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11074 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11097 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11114 */ 'N', 'O', 'T', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11126 */ 'G', 'E', '_', 'U', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11139 */ 'L', 'E', '_', 'U', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11152 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11166 */ 'G', 'T', '_', 'U', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11179 */ 'L', 'T', '_', 'U', '_', 'v', '4', 'i', '3', '2', '_', 'S', 0,
  /* 11192 */ 'C', 'A', 'L', 'L', '_', 'i', '3', '2', '_', 'S', 0,
  /* 11203 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'i', '3', '2', '_', 'S', 0,
  /* 11224 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'i', '3', '2', '_', 'S', 0,
  /* 11239 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11260 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '3', '2', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11281 */ 'F', 'P', '_', 'T', 'O', '_', 'S', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11302 */ 'F', 'P', '_', 'T', 'O', '_', 'U', 'I', 'N', 'T', '_', 'I', '6', '4', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11323 */ 'S', 'U', 'B', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11333 */ 'T', 'R', 'U', 'N', 'C', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11345 */ 'L', 'O', 'A', 'D', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11356 */ 'A', 'D', 'D', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11366 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11382 */ 'G', 'E', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11391 */ 'L', 'E', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11400 */ 'N', 'E', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11409 */ 'S', 'T', 'O', 'R', 'E', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11421 */ 'F', '3', '2', '_', 'D', 'E', 'M', 'O', 'T', 'E', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11438 */ 'N', 'E', 'G', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11448 */ 'C', 'E', 'I', 'L', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11459 */ 'M', 'U', 'L', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11469 */ 'C', 'O', 'P', 'Y', 'S', 'I', 'G', 'N', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11484 */ 'M', 'I', 'N', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11494 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11519 */ 'D', 'R', 'O', 'P', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11530 */ 'E', 'Q', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11539 */ 'F', 'L', 'O', 'O', 'R', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11551 */ 'A', 'B', 'S', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11561 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11579 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11597 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11619 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'S', '_', 'S', 'A', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11641 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11663 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'S', 'A', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11685 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11698 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11715 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11731 */ 'I', '6', '4', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11753 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11770 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11786 */ 'G', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11795 */ 'L', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11804 */ 'S', 'Q', 'R', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11815 */ 'N', 'E', 'A', 'R', 'E', 'S', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11829 */ 'C', 'O', 'N', 'S', 'T', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11841 */ 'I', '3', '2', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11859 */ 'I', '6', '4', '_', 'T', 'R', 'U', 'N', 'C', '_', 'U', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11877 */ 'D', 'I', 'V', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11887 */ 'M', 'A', 'X', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11897 */ 'C', 'O', 'P', 'Y', '_', 'F', '6', '4', '_', 'S', 0,
  /* 11908 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '3', '2', '_', 'I', '6', '4', '_', 'S', 0,
  /* 11929 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '1', '6', '_', 'I', '6', '4', '_', 'S', 0,
  /* 11950 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '8', '_', 'I', '6', '4', '_', 'S', 0,
  /* 11970 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '6', '4', '_', 'S', 0,
  /* 11995 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12020 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'S', 'U', 'B', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12044 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'S', 'U', 'B', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12065 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12083 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12108 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12133 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'D', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12157 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'D', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12178 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12203 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12228 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'A', 'N', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12252 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'A', 'N', 'D', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12273 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12289 */ 'B', 'R', '_', 'T', 'A', 'B', 'L', 'E', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12304 */ 'N', 'E', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12313 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'S', 'T', 'O', 'R', 'E', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12332 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12361 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12390 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12418 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'C', 'M', 'P', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12443 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12469 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12495 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12520 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'C', 'H', 'G', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12542 */ 'S', 'H', 'L', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12552 */ 'R', 'O', 'T', 'L', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12563 */ 'M', 'U', 'L', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12573 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12598 */ 'I', '3', '2', '_', 'W', 'R', 'A', 'P', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12613 */ 'D', 'R', 'O', 'P', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12624 */ 'E', 'Q', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12633 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12658 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12683 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'X', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12707 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'X', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12728 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '3', '2', '_', 'U', '_', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12752 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '1', '6', '_', 'U', '_', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12776 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '8', '_', 'U', '_', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12799 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'R', 'M', 'W', '_', 'O', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12819 */ 'R', 'O', 'T', 'R', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12830 */ 'L', 'O', 'A', 'D', '3', '2', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12845 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '3', '2', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12866 */ 'L', 'O', 'A', 'D', '1', '6', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12881 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '1', '6', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12902 */ 'L', 'O', 'A', 'D', '8', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12916 */ 'I', '6', '4', '_', 'E', 'X', 'T', 'E', 'N', 'D', '8', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12936 */ 'G', 'E', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12947 */ 'L', 'E', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12958 */ 'R', 'E', 'M', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12970 */ 'S', 'H', 'R', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12982 */ 'G', 'T', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 12993 */ 'L', 'T', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13004 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13024 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13044 */ 'D', 'I', 'V', '_', 'S', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13056 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13069 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13086 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13102 */ 'F', '6', '4', '_', 'R', 'E', 'I', 'N', 'T', 'E', 'R', 'P', 'R', 'E', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13124 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13141 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13157 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'W', 'A', 'I', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13175 */ 'P', 'O', 'P', 'C', 'N', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13188 */ 'C', 'O', 'N', 'S', 'T', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13200 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '3', '2', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13222 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '1', '6', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13244 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'L', 'O', 'A', 'D', '8', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13265 */ 'G', 'E', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13276 */ 'L', 'E', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13287 */ 'R', 'E', 'M', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13299 */ 'S', 'H', 'R', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13311 */ 'G', 'T', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13322 */ 'L', 'T', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13333 */ 'F', '3', '2', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13353 */ 'F', '6', '4', '_', 'C', 'O', 'N', 'V', 'E', 'R', 'T', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13373 */ 'D', 'I', 'V', '_', 'U', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13385 */ 'C', 'O', 'P', 'Y', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13396 */ 'C', 'L', 'Z', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13406 */ 'E', 'Q', 'Z', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13416 */ 'C', 'T', 'Z', '_', 'I', '6', '4', '_', 'S', 0,
  /* 13426 */ 'f', 'p', '_', 't', 'o', '_', 's', 'i', 'n', 't', '_', 'v', '2', 'i', '6', '4', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13451 */ 'f', 'p', '_', 't', 'o', '_', 'u', 'i', 'n', 't', '_', 'v', '2', 'i', '6', '4', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13476 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13495 */ 'S', 'U', 'B', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13507 */ 'L', 'O', 'A', 'D', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13520 */ 'A', 'D', 'D', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13532 */ 'G', 'E', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13543 */ 'L', 'E', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13554 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13575 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13596 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13610 */ 'N', 'E', 'G', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13622 */ 'C', 'A', 'L', 'L', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13635 */ 'M', 'U', 'L', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13647 */ 'M', 'I', 'N', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13659 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13686 */ 'E', 'Q', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13697 */ 'A', 'B', 'S', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13709 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13723 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13741 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13764 */ 'G', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13775 */ 'L', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13786 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13803 */ 'S', 'Q', 'R', 'T', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13816 */ 'D', 'I', 'V', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13828 */ 'M', 'A', 'X', '_', 'v', '2', 'f', '6', '4', '_', 'S', 0,
  /* 13840 */ 'C', 'A', 'L', 'L', '_', 'f', '6', '4', '_', 'S', 0,
  /* 13851 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'f', '6', '4', '_', 'S', 0,
  /* 13872 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'f', '6', '4', '_', 'S', 0,
  /* 13887 */ 's', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '2', 'f', '6', '4', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 13912 */ 'u', 'i', 'n', 't', '_', 't', 'o', '_', 'f', 'p', '_', 'v', '2', 'f', '6', '4', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 13937 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 13956 */ 'S', 'U', 'B', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 13968 */ 'L', 'O', 'A', 'D', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 13981 */ 'A', 'D', 'D', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 13993 */ 'A', 'N', 'D', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14005 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14026 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14047 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14061 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14077 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14093 */ 'N', 'E', 'G', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14105 */ 'S', 'H', 'L', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14117 */ 'C', 'A', 'L', 'L', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14130 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14157 */ 'X', 'O', 'R', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14169 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14183 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14197 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14215 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14238 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14255 */ 'N', 'O', 'T', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14267 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '2', 'i', '6', '4', '_', 'S', 0,
  /* 14281 */ 'C', 'A', 'L', 'L', '_', 'i', '6', '4', '_', 'S', 0,
  /* 14292 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'i', '6', '4', '_', 'S', 0,
  /* 14313 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'i', '6', '4', '_', 'S', 0,
  /* 14328 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14347 */ 'S', 'U', 'B', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14359 */ 'L', 'O', 'A', 'D', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14372 */ 'A', 'D', 'D', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14384 */ 'A', 'N', 'D', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14396 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14417 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14431 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14447 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14463 */ 'N', 'E', 'G', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14475 */ 'S', 'H', 'L', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14487 */ 'C', 'A', 'L', 'L', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14500 */ 'M', 'U', 'L', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14512 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14539 */ 'E', 'Q', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14550 */ 'X', 'O', 'R', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14562 */ 'G', 'E', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14575 */ 'L', 'E', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14588 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14602 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14620 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14638 */ 'G', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14651 */ 'L', 'T', '_', 'S', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14664 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14678 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14696 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14719 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14736 */ 'N', 'O', 'T', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14748 */ 'G', 'E', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14761 */ 'L', 'E', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14774 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14788 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14806 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14824 */ 'G', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14837 */ 'L', 'T', '_', 'U', '_', 'v', '8', 'i', '1', '6', '_', 'S', 0,
  /* 14850 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14867 */ 'D', 'R', 'O', 'P', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14879 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14897 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14914 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14932 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14949 */ 'C', 'O', 'P', 'Y', '_', 'V', '1', '2', '8', '_', 'S', 0,
  /* 14961 */ 'C', 'O', 'N', 'S', 'T', '_', 'V', '1', '2', '8', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 14980 */ 'S', 'U', 'B', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 14992 */ 'L', 'O', 'A', 'D', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15005 */ 'A', 'D', 'D', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15017 */ 'A', 'N', 'D', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15029 */ 'R', 'E', 'P', 'L', 'A', 'C', 'E', '_', 'L', 'A', 'N', 'E', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15050 */ 'S', 'T', 'O', 'R', 'E', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15064 */ 'A', 'L', 'L', 'T', 'R', 'U', 'E', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15080 */ 'A', 'N', 'Y', 'T', 'R', 'U', 'E', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15096 */ 'N', 'E', 'G', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15108 */ 'S', 'H', 'L', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15120 */ 'C', 'A', 'L', 'L', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15133 */ 'M', 'U', 'L', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15145 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15172 */ 'E', 'Q', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15183 */ 'X', 'O', 'R', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15195 */ 'G', 'E', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15208 */ 'L', 'E', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15221 */ 'S', 'H', 'R', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15235 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15253 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15271 */ 'G', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15284 */ 'L', 'T', '_', 'S', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15297 */ 'S', 'P', 'L', 'A', 'T', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15311 */ 'B', 'I', 'T', 'S', 'E', 'L', 'E', 'C', 'T', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15329 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15352 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15369 */ 'N', 'O', 'T', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15381 */ 'G', 'E', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15394 */ 'L', 'E', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15407 */ 'S', 'H', 'R', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15421 */ 'S', 'U', 'B', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15439 */ 'A', 'D', 'D', '_', 'S', 'A', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15457 */ 'G', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15470 */ 'L', 'T', '_', 'U', '_', 'v', '1', '6', 'i', '8', '_', 'S', 0,
  /* 15483 */ 'C', 'A', 'L', 'L', '_', 'V', 'O', 'I', 'D', '_', 'S', 0,
  /* 15495 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'V', 'O', 'I', 'D', '_', 'S', 0,
  /* 15521 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'V', 'O', 'I', 'D', '_', 'S', 0,
  /* 15543 */ 'E', 'N', 'D', '_', 'S', 0,
  /* 15549 */ 'C', 'O', 'M', 'P', 'I', 'L', 'E', 'R', '_', 'F', 'E', 'N', 'C', 'E', '_', 'S', 0,
  /* 15566 */ 'U', 'N', 'R', 'E', 'A', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'S', 0,
  /* 15580 */ 'S', 'H', 'U', 'F', 'F', 'L', 'E', '_', 'S', 0,
  /* 15590 */ 'E', 'L', 'S', 'E', '_', 'S', 0,
  /* 15597 */ 'L', 'O', 'C', 'A', 'L', '_', 'T', 'E', 'E', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15616 */ 'F', 'A', 'L', 'L', 'T', 'H', 'R', 'O', 'U', 'G', 'H', '_', 'R', 'E', 'T', 'U', 'R', 'N', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15644 */ 'D', 'R', 'O', 'P', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15658 */ 'S', 'E', 'L', 'E', 'C', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15674 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'G', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15694 */ 'L', 'O', 'C', 'A', 'L', '_', 'G', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15713 */ 'G', 'L', 'O', 'B', 'A', 'L', '_', 'S', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15733 */ 'L', 'O', 'C', 'A', 'L', '_', 'S', 'E', 'T', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15752 */ 'C', 'O', 'P', 'Y', '_', 'E', 'X', 'N', 'R', 'E', 'F', '_', 'S', 0,
  /* 15766 */ 'E', 'N', 'D', '_', 'I', 'F', '_', 'S', 0,
  /* 15775 */ 'B', 'R', '_', 'I', 'F', '_', 'S', 0,
  /* 15783 */ 'R', 'E', 'T', 'H', 'R', 'O', 'W', '_', 'I', 'N', '_', 'C', 'A', 'T', 'C', 'H', '_', 'S', 0,
  /* 15802 */ 'E', 'N', 'D', '_', 'B', 'L', 'O', 'C', 'K', '_', 'S', 0,
  /* 15814 */ 'R', 'E', 'T', '_', 'C', 'A', 'L', 'L', '_', 'S', 0,
  /* 15825 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'F', 'I', 'L', 'L', '_', 'S', 0,
  /* 15839 */ 'E', 'N', 'D', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'S', 0,
  /* 15854 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'D', 'O', 'W', 'N', '_', 'S', 0,
  /* 15873 */ 'B', 'R', '_', 'O', 'N', '_', 'E', 'X', 'N', '_', 'S', 0,
  /* 15885 */ 'N', 'O', 'P', '_', 'S', 0,
  /* 15891 */ 'E', 'N', 'D', '_', 'L', 'O', 'O', 'P', '_', 'S', 0,
  /* 15902 */ 'D', 'A', 'T', 'A', '_', 'D', 'R', 'O', 'P', '_', 'S', 0,
  /* 15914 */ 'A', 'D', 'J', 'C', 'A', 'L', 'L', 'S', 'T', 'A', 'C', 'K', 'U', 'P', '_', 'S', 0,
  /* 15931 */ 'B', 'R', '_', 'S', 0,
  /* 15936 */ 'B', 'R', '_', 'U', 'N', 'L', 'E', 'S', 'S', '_', 'S', 0,
  /* 15948 */ 'P', 'R', 'E', 'T', '_', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'S', 0,
  /* 15969 */ 'C', 'A', 'T', 'C', 'H', 'R', 'E', 'T', '_', 'S', 0,
  /* 15980 */ 'C', 'L', 'E', 'A', 'N', 'U', 'P', 'R', 'E', 'T', '_', 'S', 0,
  /* 15993 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'I', 'N', 'I', 'T', '_', 'S', 0,
  /* 16007 */ 'R', 'E', 'T', 'H', 'R', 'O', 'W', '_', 'S', 0,
  /* 16017 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'N', 'O', 'T', 'I', 'F', 'Y', '_', 'S', 0,
  /* 16033 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'C', 'O', 'P', 'Y', '_', 'S', 0,
  /* 16047 */ 'E', 'N', 'D', '_', 'T', 'R', 'Y', '_', 'S', 0,
  /* 16057 */ 'C', 'A', 'L', 'L', '_', 'e', 'x', 'n', 'r', 'e', 'f', '_', 'S', 0,
  /* 16071 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'e', 'x', 'n', 'r', 'e', 'f', '_', 'S', 0,
  /* 16095 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'e', 'x', 'n', 'r', 'e', 'f', '_', 'S', 0,
  /* 16113 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '8', 'i', '1', '6', '_', 's', '_', 'S', 0,
  /* 16136 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '1', '6', 'i', '8', '_', 's', '_', 'S', 0,
  /* 16159 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '8', 'i', '1', '6', '_', 'u', '_', 'S', 0,
  /* 16182 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '1', '6', 'i', '8', '_', 'u', '_', 'S', 0,
  /* 16205 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', 0,
  /* 16215 */ 'G', '_', 'S', 'E', 'L', 'E', 'C', 'T', 0,
  /* 16224 */ 'G', '_', 'B', 'R', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', 0,
  /* 16237 */ 'P', 'R', 'E', 'T', '_', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', 0,
  /* 16256 */ 'C', 'A', 'T', 'C', 'H', 'R', 'E', 'T', 0,
  /* 16265 */ 'C', 'L', 'E', 'A', 'N', 'U', 'P', 'R', 'E', 'T', 0,
  /* 16276 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'R', 'E', 'T', 0,
  /* 16290 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'I', 'N', 'I', 'T', 0,
  /* 16302 */ 'P', 'A', 'T', 'C', 'H', 'A', 'B', 'L', 'E', '_', 'F', 'U', 'N', 'C', 'T', 'I', 'O', 'N', '_', 'E', 'X', 'I', 'T', 0,
  /* 16326 */ 'G', '_', 'B', 'R', 'J', 'T', 0,
  /* 16333 */ 'G', '_', 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 16354 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', '_', 'V', 'E', 'C', 'T', 'O', 'R', '_', 'E', 'L', 'T', 0,
  /* 16374 */ 'G', '_', 'F', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 16386 */ 'G', '_', 'C', 'O', 'N', 'S', 'T', 'A', 'N', 'T', 0,
  /* 16397 */ 'S', 'T', 'A', 'T', 'E', 'P', 'O', 'I', 'N', 'T', 0,
  /* 16408 */ 'P', 'A', 'T', 'C', 'H', 'P', 'O', 'I', 'N', 'T', 0,
  /* 16419 */ 'G', '_', 'P', 'T', 'R', 'T', 'O', 'I', 'N', 'T', 0,
  /* 16430 */ 'G', '_', 'F', 'R', 'I', 'N', 'T', 0,
  /* 16438 */ 'G', '_', 'F', 'N', 'E', 'A', 'R', 'B', 'Y', 'I', 'N', 'T', 0,
  /* 16451 */ 'G', '_', 'V', 'A', 'S', 'T', 'A', 'R', 'T', 0,
  /* 16461 */ 'L', 'I', 'F', 'E', 'T', 'I', 'M', 'E', '_', 'S', 'T', 'A', 'R', 'T', 0,
  /* 16476 */ 'G', '_', 'I', 'N', 'S', 'E', 'R', 'T', 0,
  /* 16485 */ 'G', '_', 'F', 'S', 'Q', 'R', 'T', 0,
  /* 16493 */ 'G', '_', 'B', 'I', 'T', 'C', 'A', 'S', 'T', 0,
  /* 16503 */ 'G', '_', 'A', 'D', 'D', 'R', 'S', 'P', 'A', 'C', 'E', '_', 'C', 'A', 'S', 'T', 0,
  /* 16520 */ 'G', '_', 'F', 'P', 'E', 'X', 'T', 0,
  /* 16528 */ 'G', '_', 'S', 'E', 'X', 'T', 0,
  /* 16535 */ 'G', '_', 'A', 'N', 'Y', 'E', 'X', 'T', 0,
  /* 16544 */ 'G', '_', 'Z', 'E', 'X', 'T', 0,
  /* 16551 */ 'G', '_', 'F', 'D', 'I', 'V', 0,
  /* 16558 */ 'G', '_', 'S', 'D', 'I', 'V', 0,
  /* 16565 */ 'G', '_', 'U', 'D', 'I', 'V', 0,
  /* 16572 */ 'G', '_', 'F', 'P', 'O', 'W', 0,
  /* 16579 */ 'R', 'E', 'T', 'H', 'R', 'O', 'W', 0,
  /* 16587 */ 'G', '_', 'S', 'M', 'A', 'X', 0,
  /* 16594 */ 'G', '_', 'U', 'M', 'A', 'X', 0,
  /* 16601 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'U', 'M', 'A', 'X', 0,
  /* 16618 */ 'G', '_', 'A', 'T', 'O', 'M', 'I', 'C', 'R', 'M', 'W', '_', 'M', 'A', 'X', 0,
  /* 16634 */ 'G', '_', 'F', 'R', 'A', 'M', 'E', '_', 'I', 'N', 'D', 'E', 'X', 0,
  /* 16648 */ 'A', 'T', 'O', 'M', 'I', 'C', '_', 'N', 'O', 'T', 'I', 'F', 'Y', 0,
  /* 16662 */ 'M', 'E', 'M', 'O', 'R', 'Y', '_', 'C', 'O', 'P', 'Y', 0,
  /* 16674 */ 'E', 'N', 'D', '_', 'T', 'R', 'Y', 0,
  /* 16682 */ 'G', '_', 'C', 'T', 'L', 'Z', 0,
  /* 16689 */ 'G', '_', 'C', 'T', 'T', 'Z', 0,
  /* 16696 */ 'C', 'A', 'L', 'L', '_', 'e', 'x', 'n', 'r', 'e', 'f', 0,
  /* 16708 */ 'P', 'C', 'A', 'L', 'L', '_', 'I', 'N', 'D', 'I', 'R', 'E', 'C', 'T', '_', 'e', 'x', 'n', 'r', 'e', 'f', 0,
  /* 16730 */ 'A', 'R', 'G', 'U', 'M', 'E', 'N', 'T', '_', 'e', 'x', 'n', 'r', 'e', 'f', 0,
  /* 16746 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '8', 'i', '1', '6', '_', 's', 0,
  /* 16767 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '1', '6', 'i', '8', '_', 's', 0,
  /* 16788 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '8', 'i', '1', '6', '_', 'u', 0,
  /* 16809 */ 'E', 'X', 'T', 'R', 'A', 'C', 'T', '_', 'L', 'A', 'N', 'E', '_', 'v', '1', '6', 'i', '8', '_', 'u', 0,
};

extern const unsigned WebAssemblyInstrNameIndices[] = {
    7269U, 7531U, 7891U, 7662U, 7331U, 7312U, 7340U, 7492U, 
    7142U, 7157U, 6958U, 7171U, 8113U, 6879U, 7321U, 6754U, 
    16669U, 6838U, 16461U, 6658U, 7753U, 7468U, 16408U, 6698U, 
    16397U, 6853U, 7852U, 7839U, 7917U, 16276U, 16302U, 7391U, 
    7447U, 7420U, 7357U, 6543U, 6416U, 7504U, 16558U, 16565U, 
    7517U, 7524U, 6636U, 8019U, 7997U, 6956U, 7267U, 16634U, 
    6889U, 16205U, 8057U, 16476U, 8074U, 7965U, 6486U, 8096U, 
    16419U, 8039U, 16493U, 6460U, 6680U, 6529U, 6507U, 6518U, 
    6866U, 8130U, 7185U, 7202U, 6549U, 6422U, 6642U, 6619U, 
    8024U, 8003U, 16618U, 7626U, 16601U, 7609U, 6731U, 6671U, 
    16224U, 6438U, 8170U, 16535U, 6478U, 16386U, 16374U, 16451U, 
    7226U, 16528U, 16544U, 7377U, 7949U, 7942U, 7801U, 7794U, 
    16215U, 7729U, 6775U, 7713U, 6723U, 7721U, 6767U, 7705U, 
    6715U, 7745U, 7737U, 7259U, 7251U, 6536U, 6409U, 7497U, 
    6403U, 16551U, 7510U, 16572U, 7879U, 2679U, 7219U, 2671U, 
    0U, 7135U, 16520U, 6450U, 7273U, 7282U, 7776U, 7785U, 
    8050U, 7583U, 6904U, 7563U, 7573U, 6783U, 6798U, 7541U, 
    7552U, 7770U, 7301U, 7595U, 16587U, 7602U, 16594U, 7886U, 
    16326U, 16354U, 16333U, 7980U, 16689U, 6938U, 16682U, 6920U, 
    7821U, 7762U, 7383U, 8089U, 7642U, 16485U, 7956U, 16430U, 
    16438U, 16503U, 7904U, 6825U, 16256U, 15969U, 16265U, 15980U, 
    6739U, 15549U, 7234U, 15783U, 276U, 8510U, 2953U, 11551U, 
    4851U, 13697U, 2013U, 10481U, 112U, 8314U, 2790U, 11356U, 
    719U, 9011U, 3438U, 12098U, 6203U, 15253U, 5654U, 14620U, 
    6365U, 15439U, 5816U, 14806U, 5989U, 15005U, 4698U, 13520U, 
    5099U, 13981U, 1860U, 10304U, 2261U, 10765U, 5440U, 14372U, 
    7678U, 15854U, 7864U, 15914U, 6040U, 15064U, 5169U, 14061U, 
    2331U, 10845U, 5491U, 14431U, 783U, 9081U, 3525U, 12193U, 
    5999U, 15017U, 5109U, 13993U, 2271U, 10777U, 5450U, 14384U, 
    6054U, 15080U, 5183U, 14077U, 2345U, 10861U, 5505U, 14447U, 
    16730U, 16095U, 2164U, 10656U, 5002U, 13872U, 2658U, 11224U, 
    5389U, 14313U, 6290U, 15352U, 4928U, 13786U, 5324U, 14238U, 
    2090U, 10570U, 2549U, 11097U, 5741U, 14719U, 1569U, 9969U, 
    4440U, 13222U, 4420U, 13200U, 1589U, 9991U, 4460U, 13244U, 
    688U, 8978U, 3407U, 12065U, 16648U, 16017U, 704U, 8996U, 
    3446U, 12108U, 768U, 9066U, 3533U, 12203U, 899U, 9213U, 
    3675U, 12361U, 1192U, 9538U, 4028U, 12752U, 624U, 8908U, 
    3343U, 11995U, 975U, 9295U, 3775U, 12469U, 1128U, 9468U, 
    3942U, 12658U, 3423U, 12083U, 3510U, 12178U, 3648U, 12332U, 
    4006U, 12728U, 3320U, 11970U, 3751U, 12443U, 3919U, 12633U, 
    727U, 9021U, 3469U, 12133U, 791U, 9091U, 3556U, 12228U, 
    926U, 9242U, 3702U, 12390U, 1214U, 9562U, 4050U, 12776U, 
    647U, 8933U, 3366U, 12020U, 999U, 9321U, 3799U, 12495U, 
    1151U, 9493U, 3965U, 12683U, 749U, 9045U, 3491U, 12157U, 
    813U, 9115U, 3578U, 12252U, 952U, 9270U, 3728U, 12418U, 
    1235U, 9585U, 4071U, 12799U, 669U, 8957U, 3388U, 12044U, 
    1022U, 9346U, 3822U, 12520U, 1173U, 9517U, 3987U, 12707U, 
    587U, 8867U, 3283U, 11929U, 3264U, 11908U, 606U, 8888U, 
    3302U, 11950U, 866U, 9176U, 3631U, 12313U, 1532U, 9926U, 
    4383U, 13157U, 6253U, 15311U, 4873U, 13723U, 5287U, 14197U, 
    2035U, 10507U, 2512U, 11056U, 5704U, 14678U, 7295U, 15806U, 
    7888U, 7129U, 15775U, 7695U, 15873U, 15931U, 846U, 9152U, 
    3611U, 12289U, 8160U, 15936U, 6600U, 15522U, 16709U, 16072U, 
    2146U, 10636U, 4984U, 13852U, 2640U, 11204U, 5371U, 14293U, 
    6270U, 15330U, 4890U, 13742U, 5304U, 14216U, 2052U, 10526U, 
    2529U, 11075U, 5721U, 14697U, 6565U, 15483U, 16696U, 16057U, 
    2136U, 10624U, 4974U, 13840U, 2630U, 11192U, 5361U, 14281U, 
    6088U, 15120U, 4786U, 13622U, 5217U, 14117U, 1948U, 10406U, 
    2379U, 10901U, 5539U, 14487U, 7245U, 15794U, 189U, 8407U, 
    2866U, 11448U, 1752U, 10180U, 4590U, 13396U, 520U, 8788U, 
    3197U, 11829U, 1559U, 9957U, 4410U, 13188U, 5951U, 14961U, 
    4660U, 13476U, 5061U, 13937U, 1822U, 10260U, 2223U, 10721U, 
    5402U, 14328U, 206U, 8428U, 2883U, 11469U, 7110U, 15752U, 
    578U, 8856U, 3255U, 11897U, 1743U, 10169U, 4581U, 13385U, 
    5941U, 14949U, 1768U, 10200U, 4606U, 13416U, 7829U, 15902U, 
    562U, 8836U, 3239U, 11877U, 1433U, 9813U, 4284U, 13044U, 
    1717U, 10139U, 4571U, 13373U, 4954U, 13816U, 2116U, 10600U, 
    7014U, 15644U, 250U, 8478U, 2927U, 11519U, 1112U, 9448U, 
    3903U, 12613U, 5869U, 14867U, 6874U, 15590U, 6667U, 7291U, 
    15802U, 7649U, 15839U, 7122U, 15766U, 7812U, 15891U, 15543U, 
    16674U, 16047U, 1760U, 10190U, 4598U, 13406U, 259U, 8489U, 
    2936U, 11530U, 1121U, 9459U, 3912U, 12624U, 6134U, 15172U, 
    4842U, 13686U, 2004U, 10470U, 2425U, 10953U, 5585U, 14539U, 
    1067U, 9399U, 16767U, 16136U, 16809U, 16182U, 4745U, 13575U, 
    5138U, 14026U, 1907U, 10359U, 2300U, 10810U, 16746U, 16113U, 
    16788U, 16159U, 1397U, 9773U, 4248U, 13004U, 1681U, 10099U, 
    4535U, 13333U, 2843U, 11421U, 1483U, 9871U, 1415U, 9793U, 
    4266U, 13024U, 1699U, 10119U, 4553U, 13353U, 165U, 8379U, 
    4334U, 13102U, 6988U, 15616U, 227U, 8453U, 2904U, 11494U, 
    1089U, 9423U, 3867U, 12573U, 6575U, 15495U, 6109U, 15145U, 
    4817U, 13659U, 5228U, 14130U, 1979U, 10443U, 2400U, 10926U, 
    5560U, 14512U, 266U, 8498U, 2943U, 11539U, 9U, 8197U, 
    2687U, 11239U, 47U, 8239U, 2725U, 11281U, 28U, 8218U, 
    2706U, 11260U, 66U, 8260U, 2744U, 11302U, 134U, 8340U, 
    2812U, 11382U, 1341U, 9705U, 4192U, 12936U, 6153U, 15195U, 
    2444U, 10976U, 5604U, 14562U, 1625U, 10031U, 4479U, 13265U, 
    6315U, 15381U, 2574U, 11126U, 5766U, 14748U, 4708U, 13532U, 
    1870U, 10316U, 7040U, 15674U, 407U, 8657U, 3084U, 11698U, 
    1454U, 9838U, 4305U, 13069U, 5879U, 14879U, 7075U, 15713U, 
    456U, 8712U, 3133U, 11753U, 1503U, 9893U, 4354U, 13124U, 
    5910U, 14914U, 485U, 8745U, 3162U, 11786U, 1379U, 9751U, 
    4230U, 12982U, 6219U, 15271U, 2478U, 11016U, 5670U, 14638U, 
    1663U, 10077U, 4517U, 13311U, 6381U, 15457U, 2608U, 11166U, 
    5832U, 14824U, 4910U, 13764U, 2072U, 10548U, 1275U, 9631U, 
    1306U, 9666U, 436U, 8690U, 284U, 8520U, 2961U, 11561U, 
    316U, 8556U, 2993U, 11597U, 530U, 8800U, 3207U, 11841U, 
    356U, 8600U, 3033U, 11641U, 3890U, 12598U, 4143U, 12881U, 
    4111U, 12845U, 4174U, 12916U, 1324U, 9686U, 1608U, 10012U, 
    3113U, 11731U, 300U, 8538U, 2977U, 11579U, 336U, 8578U, 
    3013U, 11619U, 546U, 8818U, 3223U, 11859U, 376U, 8622U, 
    3053U, 11663U, 7126U, 15770U, 141U, 8349U, 2819U, 11391U, 
    1350U, 9716U, 4201U, 12947U, 6164U, 15208U, 2455U, 10989U, 
    5615U, 14575U, 1634U, 10042U, 4488U, 13276U, 6326U, 15394U, 
    2585U, 11139U, 5777U, 14761U, 4717U, 13543U, 1879U, 10327U, 
    1262U, 9616U, 4130U, 12866U, 1576U, 9976U, 4447U, 13229U, 
    4098U, 12830U, 4427U, 13207U, 1294U, 9652U, 4162U, 12902U, 
    1596U, 9998U, 4467U, 13251U, 103U, 8303U, 2781U, 11345U, 
    695U, 8985U, 3414U, 12072U, 5978U, 14992U, 4687U, 13507U, 
    5088U, 13968U, 1849U, 10291U, 2250U, 10752U, 5429U, 14359U, 
    7058U, 15694U, 422U, 8674U, 3099U, 11715U, 1469U, 9855U, 
    4320U, 13086U, 5895U, 14897U, 7093U, 15733U, 471U, 8729U, 
    3148U, 11770U, 1518U, 9910U, 4369U, 13141U, 5926U, 14932U, 
    6971U, 15597U, 120U, 8324U, 2798U, 11366U, 832U, 9136U, 
    3597U, 12273U, 5854U, 14850U, 7816U, 15895U, 492U, 8754U, 
    3169U, 11795U, 1388U, 9762U, 4239U, 12993U, 6230U, 15284U, 
    2489U, 11029U, 5681U, 14651U, 1672U, 10088U, 4526U, 13322U, 
    6392U, 15470U, 2619U, 11179U, 5843U, 14837U, 4919U, 13775U, 
    2081U, 10559U, 570U, 8846U, 3247U, 11887U, 4964U, 13828U, 
    2126U, 10612U, 16662U, 16033U, 7480U, 15825U, 1727U, 10151U, 
    16290U, 15993U, 883U, 9195U, 219U, 8443U, 2896U, 11484U, 
    4807U, 13647U, 1969U, 10431U, 198U, 8418U, 2875U, 11459U, 
    1059U, 9389U, 3859U, 12563U, 6099U, 15133U, 4797U, 13635U, 
    1959U, 10419U, 2390U, 10914U, 5550U, 14500U, 508U, 8774U, 
    3185U, 11815U, 181U, 8397U, 2858U, 11438U, 6068U, 15096U, 
    4776U, 13610U, 5197U, 14093U, 1938U, 10394U, 2359U, 10877U, 
    5519U, 14463U, 148U, 8358U, 2826U, 11400U, 859U, 9167U, 
    3624U, 12304U, 6019U, 15039U, 4736U, 13564U, 1898U, 10348U, 
    2291U, 10799U, 5470U, 14406U, 7808U, 15885U, 6305U, 15369U, 
    5339U, 14255U, 2564U, 11114U, 5756U, 14736U, 1144U, 9484U, 
    3935U, 12649U, 6144U, 15184U, 5254U, 14158U, 2435U, 10965U, 
    5595U, 14551U, 6599U, 15521U, 16708U, 16071U, 2145U, 10635U, 
    4983U, 13851U, 2639U, 11203U, 5370U, 14292U, 6269U, 15329U, 
    4889U, 13741U, 5303U, 14215U, 2051U, 10525U, 2528U, 11074U, 
    5720U, 14696U, 1548U, 9944U, 4399U, 13175U, 16237U, 15948U, 
    1359U, 9727U, 4210U, 12958U, 1643U, 10053U, 4497U, 13287U, 
    6009U, 15029U, 4726U, 13554U, 5119U, 14005U, 1888U, 10338U, 
    2281U, 10789U, 5460U, 14396U, 16579U, 16007U, 7000U, 15628U, 
    239U, 8465U, 2916U, 11506U, 1101U, 9435U, 3879U, 12585U, 
    6587U, 15507U, 6121U, 15157U, 4829U, 13671U, 5240U, 14142U, 
    1991U, 10455U, 2412U, 10938U, 5572U, 14524U, 7411U, 16238U, 
    15949U, 15814U, 1050U, 9378U, 3850U, 12552U, 1253U, 9605U, 
    4089U, 12819U, 7026U, 15658U, 396U, 8644U, 3073U, 11685U, 
    1443U, 9825U, 4294U, 13056U, 1042U, 9368U, 3842U, 12542U, 
    6078U, 15108U, 5207U, 14105U, 2369U, 10889U, 5529U, 14475U, 
    1369U, 9739U, 4220U, 12970U, 6175U, 15221U, 5263U, 14169U, 
    2466U, 11002U, 5626U, 14588U, 1653U, 10065U, 4507U, 13299U, 
    6337U, 15407U, 5349U, 14267U, 2596U, 11152U, 5788U, 14774U, 
    6845U, 15580U, 6241U, 15297U, 4861U, 13709U, 5275U, 14183U, 
    2023U, 10493U, 2500U, 11042U, 5692U, 14664U, 499U, 8763U, 
    3176U, 11804U, 4943U, 13803U, 2105U, 10587U, 594U, 8874U, 
    3290U, 11936U, 3271U, 11915U, 613U, 8895U, 3309U, 11957U, 
    155U, 8367U, 2833U, 11409U, 873U, 9183U, 3638U, 12320U, 
    6028U, 15050U, 4764U, 13596U, 5157U, 14047U, 1926U, 10380U, 
    2319U, 10831U, 5479U, 14417U, 85U, 8281U, 2763U, 11323U, 
    639U, 8923U, 3335U, 11985U, 6187U, 15235U, 5638U, 14602U, 
    6349U, 15421U, 5800U, 14788U, 5968U, 14980U, 4677U, 13495U, 
    5078U, 13956U, 1839U, 10279U, 2240U, 10740U, 5419U, 14347U, 
    6977U, 15603U, 126U, 8330U, 2804U, 11372U, 838U, 9142U, 
    3603U, 12279U, 5860U, 14856U, 16581U, 16009U, 93U, 8291U, 
    2771U, 11333U, 16678U, 16051U, 6813U, 15566U, 1143U, 9483U, 
    3934U, 12648U, 6143U, 15183U, 5253U, 14157U, 2434U, 10964U, 
    5594U, 14550U, 4614U, 13426U, 1776U, 10210U, 4637U, 13451U, 
    1799U, 10235U, 5015U, 13887U, 2177U, 10671U, 5038U, 13912U, 
    2200U, 10696U, 
};

static inline void InitWebAssemblyMCInstrInfo(MCInstrInfo *II) {
  II->InitMCInstrInfo(WebAssemblyInsts, WebAssemblyInstrNameIndices, WebAssemblyInstrNameData, 1306);
}

} // end llvm namespace
#endif // GET_INSTRINFO_MC_DESC

#ifdef GET_INSTRINFO_HEADER
#undef GET_INSTRINFO_HEADER
namespace llvm {
struct WebAssemblyGenInstrInfo : public TargetInstrInfo {
  explicit WebAssemblyGenInstrInfo(int CFSetupOpcode = -1, int CFDestroyOpcode = -1, int CatchRetOpcode = -1, int ReturnOpcode = -1);
  ~WebAssemblyGenInstrInfo() override = default;

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
extern const MCInstrDesc WebAssemblyInsts[];
extern const unsigned WebAssemblyInstrNameIndices[];
extern const char WebAssemblyInstrNameData[];
WebAssemblyGenInstrInfo::WebAssemblyGenInstrInfo(int CFSetupOpcode, int CFDestroyOpcode, int CatchRetOpcode, int ReturnOpcode)
  : TargetInstrInfo(CFSetupOpcode, CFDestroyOpcode, CatchRetOpcode, ReturnOpcode) {
  InitMCInstrInfo(WebAssemblyInsts, WebAssemblyInstrNameIndices, WebAssemblyInstrNameData, 1306);
}
} // end llvm namespace
#endif // GET_INSTRINFO_CTOR_DTOR

#ifdef GET_INSTRINFO_OPERAND_ENUM
#undef GET_INSTRINFO_OPERAND_ENUM
namespace llvm {
namespace WebAssembly {
namespace OpName {
enum {
  addr = 3,
  count = 4,
  dst = 0,
  exp = 6,
  new_ = 7,
  off = 2,
  p2align = 1,
  timeout = 8,
  val = 5,
  vec = 9,
OPERAND_LAST
};
} // end namespace OpName
} // end namespace WebAssembly
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_ENUM

#ifdef GET_INSTRINFO_NAMED_OPS
#undef GET_INSTRINFO_NAMED_OPS
namespace llvm {
namespace WebAssembly {
LLVM_READONLY
int16_t getNamedOperandIdx(uint16_t Opcode, uint16_t NamedIdx) {
  static const int16_t OperandMap [][10] = {
{0, 1, 2, 3, -1, -1, -1, -1, -1, -1, },
{0, 1, 2, 3, 4, -1, -1, -1, -1, -1, },
{0, 1, 2, 3, -1, 4, -1, -1, -1, -1, },
{0, 1, 2, 3, -1, -1, 4, 5, -1, -1, },
{0, 1, 2, 3, -1, -1, 4, -1, 5, -1, },
{-1, 0, 1, -1, -1, -1, -1, -1, -1, -1, },
{-1, 0, 1, 2, -1, 3, -1, -1, -1, -1, },
{-1, 0, 1, 2, -1, -1, -1, -1, -1, 3, },
};
  switch(Opcode) {
  case WebAssembly::ATOMIC_LOAD16_U_I32:
  case WebAssembly::ATOMIC_LOAD16_U_I64:
  case WebAssembly::ATOMIC_LOAD32_U_I64:
  case WebAssembly::ATOMIC_LOAD8_U_I32:
  case WebAssembly::ATOMIC_LOAD8_U_I64:
  case WebAssembly::ATOMIC_LOAD_I32:
  case WebAssembly::ATOMIC_LOAD_I64:
  case WebAssembly::LOAD16_S_I32:
  case WebAssembly::LOAD16_S_I64:
  case WebAssembly::LOAD16_U_I32:
  case WebAssembly::LOAD16_U_I64:
  case WebAssembly::LOAD32_S_I64:
  case WebAssembly::LOAD32_U_I64:
  case WebAssembly::LOAD8_S_I32:
  case WebAssembly::LOAD8_S_I64:
  case WebAssembly::LOAD8_U_I32:
  case WebAssembly::LOAD8_U_I64:
  case WebAssembly::LOAD_F32:
  case WebAssembly::LOAD_F64:
  case WebAssembly::LOAD_I32:
  case WebAssembly::LOAD_I64:
  case WebAssembly::LOAD_v16i8:
  case WebAssembly::LOAD_v2f64:
  case WebAssembly::LOAD_v2i64:
  case WebAssembly::LOAD_v4f32:
  case WebAssembly::LOAD_v4i32:
  case WebAssembly::LOAD_v8i16:
    return OperandMap[0][NamedIdx];
  case WebAssembly::ATOMIC_NOTIFY:
    return OperandMap[1][NamedIdx];
  case WebAssembly::ATOMIC_RMW16_U_ADD_I32:
  case WebAssembly::ATOMIC_RMW16_U_ADD_I64:
  case WebAssembly::ATOMIC_RMW16_U_AND_I32:
  case WebAssembly::ATOMIC_RMW16_U_AND_I64:
  case WebAssembly::ATOMIC_RMW16_U_OR_I32:
  case WebAssembly::ATOMIC_RMW16_U_OR_I64:
  case WebAssembly::ATOMIC_RMW16_U_SUB_I32:
  case WebAssembly::ATOMIC_RMW16_U_SUB_I64:
  case WebAssembly::ATOMIC_RMW16_U_XCHG_I32:
  case WebAssembly::ATOMIC_RMW16_U_XCHG_I64:
  case WebAssembly::ATOMIC_RMW16_U_XOR_I32:
  case WebAssembly::ATOMIC_RMW16_U_XOR_I64:
  case WebAssembly::ATOMIC_RMW32_U_ADD_I64:
  case WebAssembly::ATOMIC_RMW32_U_AND_I64:
  case WebAssembly::ATOMIC_RMW32_U_OR_I64:
  case WebAssembly::ATOMIC_RMW32_U_SUB_I64:
  case WebAssembly::ATOMIC_RMW32_U_XCHG_I64:
  case WebAssembly::ATOMIC_RMW32_U_XOR_I64:
  case WebAssembly::ATOMIC_RMW8_U_ADD_I32:
  case WebAssembly::ATOMIC_RMW8_U_ADD_I64:
  case WebAssembly::ATOMIC_RMW8_U_AND_I32:
  case WebAssembly::ATOMIC_RMW8_U_AND_I64:
  case WebAssembly::ATOMIC_RMW8_U_OR_I32:
  case WebAssembly::ATOMIC_RMW8_U_OR_I64:
  case WebAssembly::ATOMIC_RMW8_U_SUB_I32:
  case WebAssembly::ATOMIC_RMW8_U_SUB_I64:
  case WebAssembly::ATOMIC_RMW8_U_XCHG_I32:
  case WebAssembly::ATOMIC_RMW8_U_XCHG_I64:
  case WebAssembly::ATOMIC_RMW8_U_XOR_I32:
  case WebAssembly::ATOMIC_RMW8_U_XOR_I64:
  case WebAssembly::ATOMIC_RMW_ADD_I32:
  case WebAssembly::ATOMIC_RMW_ADD_I64:
  case WebAssembly::ATOMIC_RMW_AND_I32:
  case WebAssembly::ATOMIC_RMW_AND_I64:
  case WebAssembly::ATOMIC_RMW_OR_I32:
  case WebAssembly::ATOMIC_RMW_OR_I64:
  case WebAssembly::ATOMIC_RMW_SUB_I32:
  case WebAssembly::ATOMIC_RMW_SUB_I64:
  case WebAssembly::ATOMIC_RMW_XCHG_I32:
  case WebAssembly::ATOMIC_RMW_XCHG_I64:
  case WebAssembly::ATOMIC_RMW_XOR_I32:
  case WebAssembly::ATOMIC_RMW_XOR_I64:
    return OperandMap[2][NamedIdx];
  case WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I32:
  case WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I64:
  case WebAssembly::ATOMIC_RMW32_U_CMPXCHG_I64:
  case WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I32:
  case WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I64:
  case WebAssembly::ATOMIC_RMW_CMPXCHG_I32:
  case WebAssembly::ATOMIC_RMW_CMPXCHG_I64:
    return OperandMap[3][NamedIdx];
  case WebAssembly::ATOMIC_WAIT_I32:
  case WebAssembly::ATOMIC_WAIT_I64:
    return OperandMap[4][NamedIdx];
  case WebAssembly::ATOMIC_LOAD16_U_I32_S:
  case WebAssembly::ATOMIC_LOAD16_U_I64_S:
  case WebAssembly::ATOMIC_LOAD32_U_I64_S:
  case WebAssembly::ATOMIC_LOAD8_U_I32_S:
  case WebAssembly::ATOMIC_LOAD8_U_I64_S:
  case WebAssembly::ATOMIC_LOAD_I32_S:
  case WebAssembly::ATOMIC_LOAD_I64_S:
  case WebAssembly::ATOMIC_NOTIFY_S:
  case WebAssembly::ATOMIC_RMW16_U_ADD_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_ADD_I64_S:
  case WebAssembly::ATOMIC_RMW16_U_AND_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_AND_I64_S:
  case WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I64_S:
  case WebAssembly::ATOMIC_RMW16_U_OR_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_OR_I64_S:
  case WebAssembly::ATOMIC_RMW16_U_SUB_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_SUB_I64_S:
  case WebAssembly::ATOMIC_RMW16_U_XCHG_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_XCHG_I64_S:
  case WebAssembly::ATOMIC_RMW16_U_XOR_I32_S:
  case WebAssembly::ATOMIC_RMW16_U_XOR_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_ADD_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_AND_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_CMPXCHG_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_OR_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_SUB_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_XCHG_I64_S:
  case WebAssembly::ATOMIC_RMW32_U_XOR_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_ADD_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_ADD_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_AND_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_AND_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_OR_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_OR_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_SUB_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_SUB_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_XCHG_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_XCHG_I64_S:
  case WebAssembly::ATOMIC_RMW8_U_XOR_I32_S:
  case WebAssembly::ATOMIC_RMW8_U_XOR_I64_S:
  case WebAssembly::ATOMIC_RMW_ADD_I32_S:
  case WebAssembly::ATOMIC_RMW_ADD_I64_S:
  case WebAssembly::ATOMIC_RMW_AND_I32_S:
  case WebAssembly::ATOMIC_RMW_AND_I64_S:
  case WebAssembly::ATOMIC_RMW_CMPXCHG_I32_S:
  case WebAssembly::ATOMIC_RMW_CMPXCHG_I64_S:
  case WebAssembly::ATOMIC_RMW_OR_I32_S:
  case WebAssembly::ATOMIC_RMW_OR_I64_S:
  case WebAssembly::ATOMIC_RMW_SUB_I32_S:
  case WebAssembly::ATOMIC_RMW_SUB_I64_S:
  case WebAssembly::ATOMIC_RMW_XCHG_I32_S:
  case WebAssembly::ATOMIC_RMW_XCHG_I64_S:
  case WebAssembly::ATOMIC_RMW_XOR_I32_S:
  case WebAssembly::ATOMIC_RMW_XOR_I64_S:
  case WebAssembly::ATOMIC_STORE16_I32_S:
  case WebAssembly::ATOMIC_STORE16_I64_S:
  case WebAssembly::ATOMIC_STORE32_I64_S:
  case WebAssembly::ATOMIC_STORE8_I32_S:
  case WebAssembly::ATOMIC_STORE8_I64_S:
  case WebAssembly::ATOMIC_STORE_I32_S:
  case WebAssembly::ATOMIC_STORE_I64_S:
  case WebAssembly::ATOMIC_WAIT_I32_S:
  case WebAssembly::ATOMIC_WAIT_I64_S:
  case WebAssembly::LOAD16_S_I32_S:
  case WebAssembly::LOAD16_S_I64_S:
  case WebAssembly::LOAD16_U_I32_S:
  case WebAssembly::LOAD16_U_I64_S:
  case WebAssembly::LOAD32_S_I64_S:
  case WebAssembly::LOAD32_U_I64_S:
  case WebAssembly::LOAD8_S_I32_S:
  case WebAssembly::LOAD8_S_I64_S:
  case WebAssembly::LOAD8_U_I32_S:
  case WebAssembly::LOAD8_U_I64_S:
  case WebAssembly::LOAD_F32_S:
  case WebAssembly::LOAD_F64_S:
  case WebAssembly::LOAD_I32_S:
  case WebAssembly::LOAD_I64_S:
  case WebAssembly::LOAD_v16i8_S:
  case WebAssembly::LOAD_v2f64_S:
  case WebAssembly::LOAD_v2i64_S:
  case WebAssembly::LOAD_v4f32_S:
  case WebAssembly::LOAD_v4i32_S:
  case WebAssembly::LOAD_v8i16_S:
  case WebAssembly::STORE16_I32_S:
  case WebAssembly::STORE16_I64_S:
  case WebAssembly::STORE32_I64_S:
  case WebAssembly::STORE8_I32_S:
  case WebAssembly::STORE8_I64_S:
  case WebAssembly::STORE_F32_S:
  case WebAssembly::STORE_F64_S:
  case WebAssembly::STORE_I32_S:
  case WebAssembly::STORE_I64_S:
  case WebAssembly::STORE_v16i8_S:
  case WebAssembly::STORE_v2f64_S:
  case WebAssembly::STORE_v2i64_S:
  case WebAssembly::STORE_v4f32_S:
  case WebAssembly::STORE_v4i32_S:
  case WebAssembly::STORE_v8i16_S:
    return OperandMap[5][NamedIdx];
  case WebAssembly::ATOMIC_STORE16_I32:
  case WebAssembly::ATOMIC_STORE16_I64:
  case WebAssembly::ATOMIC_STORE32_I64:
  case WebAssembly::ATOMIC_STORE8_I32:
  case WebAssembly::ATOMIC_STORE8_I64:
  case WebAssembly::ATOMIC_STORE_I32:
  case WebAssembly::ATOMIC_STORE_I64:
  case WebAssembly::STORE16_I32:
  case WebAssembly::STORE16_I64:
  case WebAssembly::STORE32_I64:
  case WebAssembly::STORE8_I32:
  case WebAssembly::STORE8_I64:
  case WebAssembly::STORE_F32:
  case WebAssembly::STORE_F64:
  case WebAssembly::STORE_I32:
  case WebAssembly::STORE_I64:
    return OperandMap[6][NamedIdx];
  case WebAssembly::STORE_v16i8:
  case WebAssembly::STORE_v2f64:
  case WebAssembly::STORE_v2i64:
  case WebAssembly::STORE_v4f32:
  case WebAssembly::STORE_v4i32:
  case WebAssembly::STORE_v8i16:
    return OperandMap[7][NamedIdx];
    default: return -1;
  }
}
} // end namespace WebAssembly
} // end namespace llvm
#endif //GET_INSTRINFO_NAMED_OPS

#ifdef GET_INSTRINFO_OPERAND_TYPES_ENUM
#undef GET_INSTRINFO_OPERAND_TYPES_ENUM
namespace llvm {
namespace WebAssembly {
namespace OpTypes {
enum OperandType {
  P2Align = 0,
  Signature = 1,
  TypeIndex = 2,
  bb_op = 3,
  brlist = 4,
  event_op = 5,
  f32imm = 6,
  f32imm_op = 7,
  f64imm = 8,
  f64imm_op = 9,
  function32_op = 10,
  global_op = 11,
  i16imm = 12,
  i1imm = 13,
  i32imm = 14,
  i32imm_op = 15,
  i64imm = 16,
  i64imm_op = 17,
  i8imm = 18,
  local_op = 19,
  offset32_op = 20,
  ptype0 = 21,
  ptype1 = 22,
  ptype2 = 23,
  ptype3 = 24,
  ptype4 = 25,
  ptype5 = 26,
  type0 = 27,
  type1 = 28,
  type2 = 29,
  type3 = 30,
  type4 = 31,
  type5 = 32,
  vec_i16imm_op = 33,
  vec_i32imm_op = 34,
  vec_i64imm_op = 35,
  vec_i8imm_op = 36,
  OPERAND_TYPE_LIST_END
};
} // end namespace OpTypes
} // end namespace WebAssembly
} // end namespace llvm
#endif // GET_INSTRINFO_OPERAND_TYPES_ENUM

#ifdef GET_INSTRINFO_OPERAND_TYPE
#undef GET_INSTRINFO_OPERAND_TYPE
namespace llvm {
namespace WebAssembly {
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
    391,
    391,
    391,
    391,
    391,
    391,
    393,
    393,
    395,
    395,
    397,
    397,
    399,
    399,
    402,
    402,
    405,
    405,
    408,
    408,
    411,
    411,
    414,
    414,
    417,
    417,
    420,
    420,
    423,
    423,
    426,
    426,
    429,
    429,
    432,
    432,
    435,
    435,
    438,
    438,
    441,
    441,
    443,
    445,
    447,
    449,
    451,
    451,
    453,
    453,
    455,
    455,
    457,
    457,
    460,
    460,
    463,
    463,
    466,
    466,
    469,
    469,
    472,
    472,
    475,
    475,
    477,
    477,
    479,
    479,
    481,
    481,
    483,
    483,
    485,
    486,
    488,
    489,
    491,
    492,
    494,
    495,
    497,
    498,
    500,
    501,
    503,
    504,
    506,
    507,
    509,
    510,
    512,
    513,
    515,
    516,
    520,
    522,
    526,
    528,
    532,
    534,
    538,
    540,
    544,
    546,
    550,
    552,
    556,
    558,
    563,
    565,
    570,
    572,
    577,
    579,
    584,
    586,
    591,
    593,
    599,
    601,
    607,
    609,
    614,
    616,
    621,
    623,
    628,
    630,
    635,
    637,
    642,
    644,
    649,
    651,
    656,
    658,
    663,
    665,
    670,
    672,
    677,
    679,
    685,
    687,
    692,
    694,
    699,
    701,
    706,
    708,
    713,
    715,
    720,
    722,
    727,
    729,
    734,
    736,
    741,
    743,
    749,
    751,
    757,
    759,
    764,
    766,
    771,
    773,
    778,
    780,
    785,
    787,
    792,
    794,
    799,
    801,
    806,
    808,
    813,
    815,
    820,
    822,
    827,
    829,
    834,
    836,
    841,
    843,
    849,
    851,
    857,
    859,
    864,
    866,
    871,
    873,
    878,
    880,
    885,
    887,
    892,
    894,
    899,
    901,
    906,
    908,
    913,
    915,
    919,
    921,
    925,
    927,
    931,
    933,
    937,
    939,
    943,
    945,
    949,
    951,
    955,
    957,
    963,
    965,
    971,
    973,
    977,
    977,
    981,
    981,
    985,
    985,
    989,
    989,
    993,
    993,
    997,
    997,
    998,
    999,
    1000,
    1002,
    1003,
    1006,
    1008,
    1009,
    1010,
    1011,
    1012,
    1013,
    1015,
    1016,
    1018,
    1020,
    1023,
    1025,
    1028,
    1030,
    1033,
    1035,
    1038,
    1040,
    1043,
    1045,
    1048,
    1050,
    1053,
    1055,
    1058,
    1060,
    1063,
    1065,
    1068,
    1070,
    1073,
    1075,
    1076,
    1077,
    1079,
    1080,
    1082,
    1083,
    1085,
    1086,
    1088,
    1089,
    1091,
    1092,
    1094,
    1095,
    1097,
    1098,
    1100,
    1101,
    1103,
    1104,
    1106,
    1107,
    1109,
    1110,
    1111,
    1111,
    1113,
    1113,
    1115,
    1115,
    1117,
    1117,
    1119,
    1119,
    1121,
    1122,
    1124,
    1125,
    1127,
    1128,
    1130,
    1131,
    1148,
    1164,
    1167,
    1169,
    1172,
    1174,
    1179,
    1183,
    1188,
    1192,
    1201,
    1209,
    1212,
    1212,
    1215,
    1215,
    1217,
    1217,
    1219,
    1219,
    1221,
    1221,
    1223,
    1223,
    1225,
    1225,
    1227,
    1227,
    1229,
    1229,
    1231,
    1231,
    1232,
    1233,
    1236,
    1236,
    1239,
    1239,
    1242,
    1242,
    1245,
    1245,
    1248,
    1248,
    1251,
    1251,
    1254,
    1254,
    1257,
    1257,
    1258,
    1258,
    1259,
    1259,
    1260,
    1260,
    1261,
    1261,
    1262,
    1262,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1263,
    1265,
    1265,
    1267,
    1267,
    1270,
    1270,
    1273,
    1273,
    1276,
    1276,
    1279,
    1279,
    1282,
    1282,
    1285,
    1285,
    1288,
    1288,
    1291,
    1291,
    1294,
    1294,
    1295,
    1296,
    1299,
    1300,
    1303,
    1304,
    1307,
    1308,
    1311,
    1312,
    1315,
    1316,
    1319,
    1320,
    1323,
    1324,
    1327,
    1328,
    1330,
    1330,
    1332,
    1332,
    1334,
    1334,
    1336,
    1336,
    1338,
    1338,
    1340,
    1340,
    1342,
    1342,
    1344,
    1344,
    1346,
    1346,
    1348,
    1348,
    1350,
    1350,
    1352,
    1352,
    1353,
    1353,
    1354,
    1354,
    1355,
    1355,
    1356,
    1356,
    1357,
    1357,
    1357,
    1357,
    1358,
    1358,
    1359,
    1359,
    1360,
    1360,
    1361,
    1361,
    1362,
    1362,
    1363,
    1363,
    1365,
    1365,
    1367,
    1367,
    1369,
    1369,
    1371,
    1371,
    1373,
    1373,
    1375,
    1375,
    1377,
    1377,
    1379,
    1379,
    1381,
    1381,
    1383,
    1383,
    1386,
    1386,
    1389,
    1389,
    1392,
    1392,
    1395,
    1395,
    1398,
    1398,
    1401,
    1401,
    1404,
    1404,
    1407,
    1407,
    1410,
    1410,
    1413,
    1413,
    1416,
    1416,
    1419,
    1419,
    1422,
    1422,
    1425,
    1425,
    1427,
    1428,
    1430,
    1431,
    1433,
    1434,
    1436,
    1437,
    1439,
    1440,
    1442,
    1443,
    1445,
    1446,
    1448,
    1449,
    1451,
    1452,
    1454,
    1455,
    1457,
    1458,
    1460,
    1461,
    1464,
    1464,
    1467,
    1467,
    1470,
    1470,
    1473,
    1473,
    1476,
    1476,
    1479,
    1479,
    1482,
    1482,
    1485,
    1485,
    1488,
    1488,
    1491,
    1491,
    1494,
    1494,
    1497,
    1497,
    1500,
    1500,
    1503,
    1503,
    1505,
    1505,
    1507,
    1507,
    1509,
    1509,
    1511,
    1511,
    1513,
    1513,
    1515,
    1515,
    1517,
    1517,
    1519,
    1519,
    1521,
    1521,
    1523,
    1523,
    1525,
    1525,
    1527,
    1527,
    1529,
    1529,
    1531,
    1531,
    1533,
    1533,
    1535,
    1535,
    1537,
    1537,
    1539,
    1539,
    1541,
    1541,
    1543,
    1543,
    1545,
    1545,
    1547,
    1547,
    1549,
    1549,
    1551,
    1551,
    1553,
    1553,
    1555,
    1555,
    1557,
    1558,
    1561,
    1561,
    1564,
    1564,
    1567,
    1567,
    1570,
    1570,
    1573,
    1573,
    1576,
    1576,
    1579,
    1579,
    1582,
    1582,
    1585,
    1585,
    1588,
    1588,
    1591,
    1591,
    1594,
    1594,
    1597,
    1597,
    1600,
    1600,
    1604,
    1606,
    1610,
    1612,
    1616,
    1618,
    1622,
    1624,
    1628,
    1630,
    1634,
    1636,
    1640,
    1642,
    1646,
    1648,
    1652,
    1654,
    1658,
    1660,
    1664,
    1666,
    1670,
    1672,
    1676,
    1678,
    1682,
    1684,
    1688,
    1690,
    1694,
    1696,
    1700,
    1702,
    1706,
    1708,
    1712,
    1714,
    1718,
    1720,
    1722,
    1723,
    1725,
    1726,
    1728,
    1729,
    1731,
    1732,
    1734,
    1735,
    1737,
    1738,
    1740,
    1741,
    1743,
    1744,
    1746,
    1747,
    1749,
    1750,
    1752,
    1753,
    1755,
    1756,
    1759,
    1760,
    1763,
    1764,
    1767,
    1768,
    1771,
    1772,
    1775,
    1776,
    1779,
    1780,
    1781,
    1782,
    1785,
    1785,
    1788,
    1788,
    1791,
    1791,
    1794,
    1794,
    1797,
    1797,
    1800,
    1800,
    1803,
    1803,
    1806,
    1806,
    1809,
    1809,
    1812,
    1812,
    1815,
    1815,
    1818,
    1818,
    1821,
    1821,
    1824,
    1824,
    1827,
    1827,
    1830,
    1830,
    1833,
    1833,
    1836,
    1836,
    1841,
    1843,
    1847,
    1848,
    1851,
    1852,
    1857,
    1859,
    1861,
    1862,
    1865,
    1865,
    1868,
    1868,
    1871,
    1871,
    1874,
    1874,
    1877,
    1877,
    1880,
    1880,
    1883,
    1883,
    1886,
    1886,
    1889,
    1889,
    1892,
    1892,
    1895,
    1895,
    1898,
    1898,
    1901,
    1901,
    1903,
    1903,
    1905,
    1905,
    1907,
    1907,
    1909,
    1909,
    1911,
    1911,
    1913,
    1913,
    1915,
    1915,
    1917,
    1917,
    1919,
    1919,
    1921,
    1921,
    1924,
    1924,
    1927,
    1927,
    1930,
    1930,
    1933,
    1933,
    1936,
    1936,
    1939,
    1939,
    1942,
    1942,
    1945,
    1945,
    1948,
    1948,
    1948,
    1948,
    1950,
    1950,
    1952,
    1952,
    1954,
    1954,
    1956,
    1956,
    1959,
    1959,
    1962,
    1962,
    1965,
    1965,
    1968,
    1968,
    1971,
    1971,
    1974,
    1974,
    1975,
    1976,
    1978,
    1979,
    1981,
    1982,
    1984,
    1985,
    1987,
    1988,
    1990,
    1991,
    1993,
    1994,
    1996,
    1997,
    1999,
    2000,
    2002,
    2003,
    2005,
    2006,
    2008,
    2009,
    2011,
    2011,
    2013,
    2013,
    2014,
    2015,
    2018,
    2018,
    2021,
    2021,
    2024,
    2024,
    2027,
    2027,
    2031,
    2032,
    2036,
    2037,
    2041,
    2042,
    2046,
    2047,
    2051,
    2052,
    2056,
    2057,
    2058,
    2058,
    2059,
    2059,
    2060,
    2060,
    2061,
    2061,
    2062,
    2062,
    2063,
    2063,
    2063,
    2063,
    2064,
    2064,
    2065,
    2065,
    2066,
    2066,
    2067,
    2067,
    2068,
    2068,
    2069,
    2069,
    2070,
    2072,
    2074,
    2075,
    2078,
    2078,
    2081,
    2081,
    2084,
    2084,
    2087,
    2087,
    2091,
    2091,
    2095,
    2095,
    2099,
    2099,
    2103,
    2103,
    2107,
    2107,
    2110,
    2110,
    2113,
    2113,
    2116,
    2116,
    2119,
    2119,
    2122,
    2122,
    2125,
    2125,
    2128,
    2128,
    2131,
    2131,
    2134,
    2134,
    2137,
    2137,
    2140,
    2140,
    2143,
    2143,
    2146,
    2146,
    2149,
    2149,
    2152,
    2152,
    2155,
    2155,
    2158,
    2158,
    2161,
    2161,
    2180,
    2196,
    2198,
    2198,
    2200,
    2200,
    2202,
    2202,
    2204,
    2204,
    2206,
    2206,
    2208,
    2208,
    2210,
    2210,
    2212,
    2212,
    2214,
    2214,
    2216,
    2216,
    2220,
    2222,
    2226,
    2228,
    2232,
    2234,
    2238,
    2240,
    2244,
    2246,
    2250,
    2252,
    2256,
    2258,
    2262,
    2264,
    2268,
    2270,
    2274,
    2276,
    2280,
    2282,
    2286,
    2288,
    2292,
    2294,
    2298,
    2300,
    2304,
    2306,
    2309,
    2309,
    2312,
    2312,
    2315,
    2315,
    2318,
    2318,
    2321,
    2321,
    2324,
    2324,
    2327,
    2327,
    2330,
    2330,
    2333,
    2333,
    2336,
    2336,
    2339,
    2339,
    2342,
    2342,
    2345,
    2345,
    2348,
    2348,
    2351,
    2351,
    2354,
    2354,
    2357,
    2357,
    2360,
    2360,
    2363,
    2363,
    2366,
    2366,
    2367,
    2368,
    2370,
    2370,
    2372,
    2372,
    2373,
    2374,
    2374,
    2374,
    2377,
    2377,
    2380,
    2380,
    2383,
    2383,
    2386,
    2386,
    2389,
    2389,
    2392,
    2392,
    2394,
    2394,
    2396,
    2396,
    2398,
    2398,
    2400,
    2400,
    2402,
    2402,
    2404,
    2404,
    2406,
    2406,
    2408,
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
    OpTypes::bb_op, OpTypes::bb_op, 
    OpTypes::bb_op, OpTypes::bb_op, 
    /**/
    /**/
    /**/
    /**/
    /**/
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    OpTypes::i32imm, OpTypes::i32imm, 
    OpTypes::i32imm, OpTypes::i32imm, 
    OpTypes::i32imm, OpTypes::i32imm, 
    OpTypes::i32imm, OpTypes::i32imm, 
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    OpTypes::Signature, 
    OpTypes::Signature, 
    OpTypes::bb_op, 
    OpTypes::bb_op, -1, 
    OpTypes::bb_op, 
    OpTypes::bb_op, OpTypes::event_op, -1, 
    OpTypes::bb_op, OpTypes::event_op, 
    OpTypes::bb_op, 
    -1, 
    OpTypes::brlist, 
    -1, 
    OpTypes::brlist, 
    OpTypes::bb_op, -1, 
    OpTypes::bb_op, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    -1, OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, OpTypes::function32_op, 
    OpTypes::function32_op, 
    -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, OpTypes::f32imm_op, 
    OpTypes::f32imm_op, 
    -1, OpTypes::f64imm_op, 
    OpTypes::f64imm_op, 
    -1, OpTypes::i32imm_op, 
    OpTypes::i32imm_op, 
    -1, OpTypes::i64imm_op, 
    OpTypes::i64imm_op, 
    -1, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, 
    -1, OpTypes::f64imm_op, OpTypes::f64imm_op, 
    OpTypes::f64imm_op, OpTypes::f64imm_op, 
    -1, OpTypes::vec_i64imm_op, OpTypes::vec_i64imm_op, 
    OpTypes::vec_i64imm_op, OpTypes::vec_i64imm_op, 
    -1, OpTypes::f32imm_op, OpTypes::f32imm_op, OpTypes::f32imm_op, OpTypes::f32imm_op, 
    OpTypes::f32imm_op, OpTypes::f32imm_op, OpTypes::f32imm_op, OpTypes::f32imm_op, 
    -1, OpTypes::vec_i32imm_op, OpTypes::vec_i32imm_op, OpTypes::vec_i32imm_op, OpTypes::vec_i32imm_op, 
    OpTypes::vec_i32imm_op, OpTypes::vec_i32imm_op, OpTypes::vec_i32imm_op, OpTypes::vec_i32imm_op, 
    -1, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, 
    OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, OpTypes::vec_i16imm_op, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    OpTypes::i32imm_op, 
    OpTypes::i32imm_op, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
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
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, 
    -1, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, 
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    /**/
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, OpTypes::global_op, 
    OpTypes::global_op, 
    -1, OpTypes::global_op, 
    OpTypes::global_op, 
    -1, OpTypes::global_op, 
    OpTypes::global_op, 
    -1, OpTypes::global_op, 
    OpTypes::global_op, 
    -1, OpTypes::global_op, 
    OpTypes::global_op, 
    -1, OpTypes::global_op, 
    OpTypes::global_op, 
    OpTypes::global_op, -1, 
    OpTypes::global_op, 
    OpTypes::global_op, -1, 
    OpTypes::global_op, 
    OpTypes::global_op, -1, 
    OpTypes::global_op, 
    OpTypes::global_op, -1, 
    OpTypes::global_op, 
    OpTypes::global_op, -1, 
    OpTypes::global_op, 
    OpTypes::global_op, -1, 
    OpTypes::global_op, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    OpTypes::Signature, -1, 
    OpTypes::Signature, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::P2Align, OpTypes::offset32_op, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, OpTypes::local_op, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, 
    OpTypes::local_op, 
    OpTypes::local_op, -1, 
    OpTypes::local_op, 
    OpTypes::local_op, -1, 
    OpTypes::local_op, 
    OpTypes::local_op, -1, 
    OpTypes::local_op, 
    OpTypes::local_op, -1, 
    OpTypes::local_op, 
    OpTypes::local_op, -1, 
    OpTypes::local_op, 
    OpTypes::local_op, -1, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, -1, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, -1, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, -1, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, -1, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, -1, 
    OpTypes::local_op, 
    -1, OpTypes::local_op, -1, 
    OpTypes::local_op, 
    OpTypes::Signature, 
    OpTypes::Signature, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    OpTypes::i32imm_op, OpTypes::i32imm_op, -1, -1, -1, 
    OpTypes::i32imm_op, OpTypes::i32imm_op, 
    OpTypes::i32imm_op, -1, -1, -1, 
    OpTypes::i32imm_op, 
    -1, OpTypes::i32imm, -1, 
    OpTypes::i32imm, 
    OpTypes::i32imm_op, OpTypes::i32imm_op, -1, -1, -1, 
    OpTypes::i32imm_op, OpTypes::i32imm_op, 
    -1, OpTypes::i32imm, 
    OpTypes::i32imm, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    /**/
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    -1, 
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, 
    -1, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, OpTypes::vec_i8imm_op, -1, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, -1, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, -1, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, -1, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, -1, 
    OpTypes::vec_i8imm_op, 
    -1, -1, OpTypes::vec_i8imm_op, -1, 
    OpTypes::vec_i8imm_op, 
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    /**/
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    -1, 
    /**/
    OpTypes::function32_op, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::TypeIndex, OpTypes::i32imm, 
    OpTypes::function32_op, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, 
    OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, OpTypes::vec_i8imm_op, 
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    OpTypes::P2Align, OpTypes::offset32_op, -1, -1, 
    OpTypes::P2Align, OpTypes::offset32_op, 
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    OpTypes::event_op, 
    OpTypes::event_op, 
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    OpTypes::Signature, 
    OpTypes::Signature, 
    /**/
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
    /**/
    -1, -1, 
  };
  return OpcodeOperandTypes[Offsets[Opcode] + OpIdx];
}
} // end namespace WebAssembly
} // end namespace llvm
#endif //GET_INSTRINFO_OPERAND_TYPE

#ifdef GET_INSTRMAP_INFO
#undef GET_INSTRMAP_INFO
namespace llvm {

namespace WebAssembly {

enum StackBased {
	StackBased_true
};

// getStackOpcode
LLVM_READONLY
int getStackOpcode(uint16_t Opcode) {
static const uint16_t getStackOpcodeTable[][2] = {
  { WebAssembly::CATCHRET, WebAssembly::CATCHRET_S },
  { WebAssembly::CLEANUPRET, WebAssembly::CLEANUPRET_S },
  { WebAssembly::COMPILER_FENCE, WebAssembly::COMPILER_FENCE_S },
  { WebAssembly::RETHROW_IN_CATCH, WebAssembly::RETHROW_IN_CATCH_S },
  { WebAssembly::ABS_F32, WebAssembly::ABS_F32_S },
  { WebAssembly::ABS_F64, WebAssembly::ABS_F64_S },
  { WebAssembly::ABS_v2f64, WebAssembly::ABS_v2f64_S },
  { WebAssembly::ABS_v4f32, WebAssembly::ABS_v4f32_S },
  { WebAssembly::ADD_F32, WebAssembly::ADD_F32_S },
  { WebAssembly::ADD_F64, WebAssembly::ADD_F64_S },
  { WebAssembly::ADD_I32, WebAssembly::ADD_I32_S },
  { WebAssembly::ADD_I64, WebAssembly::ADD_I64_S },
  { WebAssembly::ADD_SAT_S_v16i8, WebAssembly::ADD_SAT_S_v16i8_S },
  { WebAssembly::ADD_SAT_S_v8i16, WebAssembly::ADD_SAT_S_v8i16_S },
  { WebAssembly::ADD_SAT_U_v16i8, WebAssembly::ADD_SAT_U_v16i8_S },
  { WebAssembly::ADD_SAT_U_v8i16, WebAssembly::ADD_SAT_U_v8i16_S },
  { WebAssembly::ADD_v16i8, WebAssembly::ADD_v16i8_S },
  { WebAssembly::ADD_v2f64, WebAssembly::ADD_v2f64_S },
  { WebAssembly::ADD_v2i64, WebAssembly::ADD_v2i64_S },
  { WebAssembly::ADD_v4f32, WebAssembly::ADD_v4f32_S },
  { WebAssembly::ADD_v4i32, WebAssembly::ADD_v4i32_S },
  { WebAssembly::ADD_v8i16, WebAssembly::ADD_v8i16_S },
  { WebAssembly::ADJCALLSTACKDOWN, WebAssembly::ADJCALLSTACKDOWN_S },
  { WebAssembly::ADJCALLSTACKUP, WebAssembly::ADJCALLSTACKUP_S },
  { WebAssembly::ALLTRUE_v16i8, WebAssembly::ALLTRUE_v16i8_S },
  { WebAssembly::ALLTRUE_v2i64, WebAssembly::ALLTRUE_v2i64_S },
  { WebAssembly::ALLTRUE_v4i32, WebAssembly::ALLTRUE_v4i32_S },
  { WebAssembly::ALLTRUE_v8i16, WebAssembly::ALLTRUE_v8i16_S },
  { WebAssembly::AND_I32, WebAssembly::AND_I32_S },
  { WebAssembly::AND_I64, WebAssembly::AND_I64_S },
  { WebAssembly::AND_v16i8, WebAssembly::AND_v16i8_S },
  { WebAssembly::AND_v2i64, WebAssembly::AND_v2i64_S },
  { WebAssembly::AND_v4i32, WebAssembly::AND_v4i32_S },
  { WebAssembly::AND_v8i16, WebAssembly::AND_v8i16_S },
  { WebAssembly::ANYTRUE_v16i8, WebAssembly::ANYTRUE_v16i8_S },
  { WebAssembly::ANYTRUE_v2i64, WebAssembly::ANYTRUE_v2i64_S },
  { WebAssembly::ANYTRUE_v4i32, WebAssembly::ANYTRUE_v4i32_S },
  { WebAssembly::ANYTRUE_v8i16, WebAssembly::ANYTRUE_v8i16_S },
  { WebAssembly::ARGUMENT_exnref, WebAssembly::ARGUMENT_exnref_S },
  { WebAssembly::ARGUMENT_f32, WebAssembly::ARGUMENT_f32_S },
  { WebAssembly::ARGUMENT_f64, WebAssembly::ARGUMENT_f64_S },
  { WebAssembly::ARGUMENT_i32, WebAssembly::ARGUMENT_i32_S },
  { WebAssembly::ARGUMENT_i64, WebAssembly::ARGUMENT_i64_S },
  { WebAssembly::ARGUMENT_v16i8, WebAssembly::ARGUMENT_v16i8_S },
  { WebAssembly::ARGUMENT_v2f64, WebAssembly::ARGUMENT_v2f64_S },
  { WebAssembly::ARGUMENT_v2i64, WebAssembly::ARGUMENT_v2i64_S },
  { WebAssembly::ARGUMENT_v4f32, WebAssembly::ARGUMENT_v4f32_S },
  { WebAssembly::ARGUMENT_v4i32, WebAssembly::ARGUMENT_v4i32_S },
  { WebAssembly::ARGUMENT_v8i16, WebAssembly::ARGUMENT_v8i16_S },
  { WebAssembly::ATOMIC_LOAD16_U_I32, WebAssembly::ATOMIC_LOAD16_U_I32_S },
  { WebAssembly::ATOMIC_LOAD16_U_I64, WebAssembly::ATOMIC_LOAD16_U_I64_S },
  { WebAssembly::ATOMIC_LOAD32_U_I64, WebAssembly::ATOMIC_LOAD32_U_I64_S },
  { WebAssembly::ATOMIC_LOAD8_U_I32, WebAssembly::ATOMIC_LOAD8_U_I32_S },
  { WebAssembly::ATOMIC_LOAD8_U_I64, WebAssembly::ATOMIC_LOAD8_U_I64_S },
  { WebAssembly::ATOMIC_LOAD_I32, WebAssembly::ATOMIC_LOAD_I32_S },
  { WebAssembly::ATOMIC_LOAD_I64, WebAssembly::ATOMIC_LOAD_I64_S },
  { WebAssembly::ATOMIC_NOTIFY, WebAssembly::ATOMIC_NOTIFY_S },
  { WebAssembly::ATOMIC_RMW16_U_ADD_I32, WebAssembly::ATOMIC_RMW16_U_ADD_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_ADD_I64, WebAssembly::ATOMIC_RMW16_U_ADD_I64_S },
  { WebAssembly::ATOMIC_RMW16_U_AND_I32, WebAssembly::ATOMIC_RMW16_U_AND_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_AND_I64, WebAssembly::ATOMIC_RMW16_U_AND_I64_S },
  { WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I32, WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I64, WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I64_S },
  { WebAssembly::ATOMIC_RMW16_U_OR_I32, WebAssembly::ATOMIC_RMW16_U_OR_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_OR_I64, WebAssembly::ATOMIC_RMW16_U_OR_I64_S },
  { WebAssembly::ATOMIC_RMW16_U_SUB_I32, WebAssembly::ATOMIC_RMW16_U_SUB_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_SUB_I64, WebAssembly::ATOMIC_RMW16_U_SUB_I64_S },
  { WebAssembly::ATOMIC_RMW16_U_XCHG_I32, WebAssembly::ATOMIC_RMW16_U_XCHG_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_XCHG_I64, WebAssembly::ATOMIC_RMW16_U_XCHG_I64_S },
  { WebAssembly::ATOMIC_RMW16_U_XOR_I32, WebAssembly::ATOMIC_RMW16_U_XOR_I32_S },
  { WebAssembly::ATOMIC_RMW16_U_XOR_I64, WebAssembly::ATOMIC_RMW16_U_XOR_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_ADD_I64, WebAssembly::ATOMIC_RMW32_U_ADD_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_AND_I64, WebAssembly::ATOMIC_RMW32_U_AND_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_CMPXCHG_I64, WebAssembly::ATOMIC_RMW32_U_CMPXCHG_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_OR_I64, WebAssembly::ATOMIC_RMW32_U_OR_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_SUB_I64, WebAssembly::ATOMIC_RMW32_U_SUB_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_XCHG_I64, WebAssembly::ATOMIC_RMW32_U_XCHG_I64_S },
  { WebAssembly::ATOMIC_RMW32_U_XOR_I64, WebAssembly::ATOMIC_RMW32_U_XOR_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_ADD_I32, WebAssembly::ATOMIC_RMW8_U_ADD_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_ADD_I64, WebAssembly::ATOMIC_RMW8_U_ADD_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_AND_I32, WebAssembly::ATOMIC_RMW8_U_AND_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_AND_I64, WebAssembly::ATOMIC_RMW8_U_AND_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I32, WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I64, WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_OR_I32, WebAssembly::ATOMIC_RMW8_U_OR_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_OR_I64, WebAssembly::ATOMIC_RMW8_U_OR_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_SUB_I32, WebAssembly::ATOMIC_RMW8_U_SUB_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_SUB_I64, WebAssembly::ATOMIC_RMW8_U_SUB_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_XCHG_I32, WebAssembly::ATOMIC_RMW8_U_XCHG_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_XCHG_I64, WebAssembly::ATOMIC_RMW8_U_XCHG_I64_S },
  { WebAssembly::ATOMIC_RMW8_U_XOR_I32, WebAssembly::ATOMIC_RMW8_U_XOR_I32_S },
  { WebAssembly::ATOMIC_RMW8_U_XOR_I64, WebAssembly::ATOMIC_RMW8_U_XOR_I64_S },
  { WebAssembly::ATOMIC_RMW_ADD_I32, WebAssembly::ATOMIC_RMW_ADD_I32_S },
  { WebAssembly::ATOMIC_RMW_ADD_I64, WebAssembly::ATOMIC_RMW_ADD_I64_S },
  { WebAssembly::ATOMIC_RMW_AND_I32, WebAssembly::ATOMIC_RMW_AND_I32_S },
  { WebAssembly::ATOMIC_RMW_AND_I64, WebAssembly::ATOMIC_RMW_AND_I64_S },
  { WebAssembly::ATOMIC_RMW_CMPXCHG_I32, WebAssembly::ATOMIC_RMW_CMPXCHG_I32_S },
  { WebAssembly::ATOMIC_RMW_CMPXCHG_I64, WebAssembly::ATOMIC_RMW_CMPXCHG_I64_S },
  { WebAssembly::ATOMIC_RMW_OR_I32, WebAssembly::ATOMIC_RMW_OR_I32_S },
  { WebAssembly::ATOMIC_RMW_OR_I64, WebAssembly::ATOMIC_RMW_OR_I64_S },
  { WebAssembly::ATOMIC_RMW_SUB_I32, WebAssembly::ATOMIC_RMW_SUB_I32_S },
  { WebAssembly::ATOMIC_RMW_SUB_I64, WebAssembly::ATOMIC_RMW_SUB_I64_S },
  { WebAssembly::ATOMIC_RMW_XCHG_I32, WebAssembly::ATOMIC_RMW_XCHG_I32_S },
  { WebAssembly::ATOMIC_RMW_XCHG_I64, WebAssembly::ATOMIC_RMW_XCHG_I64_S },
  { WebAssembly::ATOMIC_RMW_XOR_I32, WebAssembly::ATOMIC_RMW_XOR_I32_S },
  { WebAssembly::ATOMIC_RMW_XOR_I64, WebAssembly::ATOMIC_RMW_XOR_I64_S },
  { WebAssembly::ATOMIC_STORE16_I32, WebAssembly::ATOMIC_STORE16_I32_S },
  { WebAssembly::ATOMIC_STORE16_I64, WebAssembly::ATOMIC_STORE16_I64_S },
  { WebAssembly::ATOMIC_STORE32_I64, WebAssembly::ATOMIC_STORE32_I64_S },
  { WebAssembly::ATOMIC_STORE8_I32, WebAssembly::ATOMIC_STORE8_I32_S },
  { WebAssembly::ATOMIC_STORE8_I64, WebAssembly::ATOMIC_STORE8_I64_S },
  { WebAssembly::ATOMIC_STORE_I32, WebAssembly::ATOMIC_STORE_I32_S },
  { WebAssembly::ATOMIC_STORE_I64, WebAssembly::ATOMIC_STORE_I64_S },
  { WebAssembly::ATOMIC_WAIT_I32, WebAssembly::ATOMIC_WAIT_I32_S },
  { WebAssembly::ATOMIC_WAIT_I64, WebAssembly::ATOMIC_WAIT_I64_S },
  { WebAssembly::BITSELECT_v16i8, WebAssembly::BITSELECT_v16i8_S },
  { WebAssembly::BITSELECT_v2f64, WebAssembly::BITSELECT_v2f64_S },
  { WebAssembly::BITSELECT_v2i64, WebAssembly::BITSELECT_v2i64_S },
  { WebAssembly::BITSELECT_v4f32, WebAssembly::BITSELECT_v4f32_S },
  { WebAssembly::BITSELECT_v4i32, WebAssembly::BITSELECT_v4i32_S },
  { WebAssembly::BITSELECT_v8i16, WebAssembly::BITSELECT_v8i16_S },
  { WebAssembly::BLOCK, WebAssembly::BLOCK_S },
  { WebAssembly::BR, WebAssembly::BR_S },
  { WebAssembly::BR_IF, WebAssembly::BR_IF_S },
  { WebAssembly::BR_ON_EXN, WebAssembly::BR_ON_EXN_S },
  { WebAssembly::BR_TABLE_I32, WebAssembly::BR_TABLE_I32_S },
  { WebAssembly::BR_TABLE_I64, WebAssembly::BR_TABLE_I64_S },
  { WebAssembly::BR_UNLESS, WebAssembly::BR_UNLESS_S },
  { WebAssembly::CALL_INDIRECT_VOID, WebAssembly::CALL_INDIRECT_VOID_S },
  { WebAssembly::CALL_INDIRECT_exnref, WebAssembly::CALL_INDIRECT_exnref_S },
  { WebAssembly::CALL_INDIRECT_f32, WebAssembly::CALL_INDIRECT_f32_S },
  { WebAssembly::CALL_INDIRECT_f64, WebAssembly::CALL_INDIRECT_f64_S },
  { WebAssembly::CALL_INDIRECT_i32, WebAssembly::CALL_INDIRECT_i32_S },
  { WebAssembly::CALL_INDIRECT_i64, WebAssembly::CALL_INDIRECT_i64_S },
  { WebAssembly::CALL_INDIRECT_v16i8, WebAssembly::CALL_INDIRECT_v16i8_S },
  { WebAssembly::CALL_INDIRECT_v2f64, WebAssembly::CALL_INDIRECT_v2f64_S },
  { WebAssembly::CALL_INDIRECT_v2i64, WebAssembly::CALL_INDIRECT_v2i64_S },
  { WebAssembly::CALL_INDIRECT_v4f32, WebAssembly::CALL_INDIRECT_v4f32_S },
  { WebAssembly::CALL_INDIRECT_v4i32, WebAssembly::CALL_INDIRECT_v4i32_S },
  { WebAssembly::CALL_INDIRECT_v8i16, WebAssembly::CALL_INDIRECT_v8i16_S },
  { WebAssembly::CALL_VOID, WebAssembly::CALL_VOID_S },
  { WebAssembly::CALL_exnref, WebAssembly::CALL_exnref_S },
  { WebAssembly::CALL_f32, WebAssembly::CALL_f32_S },
  { WebAssembly::CALL_f64, WebAssembly::CALL_f64_S },
  { WebAssembly::CALL_i32, WebAssembly::CALL_i32_S },
  { WebAssembly::CALL_i64, WebAssembly::CALL_i64_S },
  { WebAssembly::CALL_v16i8, WebAssembly::CALL_v16i8_S },
  { WebAssembly::CALL_v2f64, WebAssembly::CALL_v2f64_S },
  { WebAssembly::CALL_v2i64, WebAssembly::CALL_v2i64_S },
  { WebAssembly::CALL_v4f32, WebAssembly::CALL_v4f32_S },
  { WebAssembly::CALL_v4i32, WebAssembly::CALL_v4i32_S },
  { WebAssembly::CALL_v8i16, WebAssembly::CALL_v8i16_S },
  { WebAssembly::CATCH, WebAssembly::CATCH_S },
  { WebAssembly::CEIL_F32, WebAssembly::CEIL_F32_S },
  { WebAssembly::CEIL_F64, WebAssembly::CEIL_F64_S },
  { WebAssembly::CLZ_I32, WebAssembly::CLZ_I32_S },
  { WebAssembly::CLZ_I64, WebAssembly::CLZ_I64_S },
  { WebAssembly::CONST_F32, WebAssembly::CONST_F32_S },
  { WebAssembly::CONST_F64, WebAssembly::CONST_F64_S },
  { WebAssembly::CONST_I32, WebAssembly::CONST_I32_S },
  { WebAssembly::CONST_I64, WebAssembly::CONST_I64_S },
  { WebAssembly::CONST_V128_v16i8, WebAssembly::CONST_V128_v16i8_S },
  { WebAssembly::CONST_V128_v2f64, WebAssembly::CONST_V128_v2f64_S },
  { WebAssembly::CONST_V128_v2i64, WebAssembly::CONST_V128_v2i64_S },
  { WebAssembly::CONST_V128_v4f32, WebAssembly::CONST_V128_v4f32_S },
  { WebAssembly::CONST_V128_v4i32, WebAssembly::CONST_V128_v4i32_S },
  { WebAssembly::CONST_V128_v8i16, WebAssembly::CONST_V128_v8i16_S },
  { WebAssembly::COPYSIGN_F32, WebAssembly::COPYSIGN_F32_S },
  { WebAssembly::COPYSIGN_F64, WebAssembly::COPYSIGN_F64_S },
  { WebAssembly::COPY_EXNREF, WebAssembly::COPY_EXNREF_S },
  { WebAssembly::COPY_F32, WebAssembly::COPY_F32_S },
  { WebAssembly::COPY_F64, WebAssembly::COPY_F64_S },
  { WebAssembly::COPY_I32, WebAssembly::COPY_I32_S },
  { WebAssembly::COPY_I64, WebAssembly::COPY_I64_S },
  { WebAssembly::COPY_V128, WebAssembly::COPY_V128_S },
  { WebAssembly::CTZ_I32, WebAssembly::CTZ_I32_S },
  { WebAssembly::CTZ_I64, WebAssembly::CTZ_I64_S },
  { WebAssembly::DATA_DROP, WebAssembly::DATA_DROP_S },
  { WebAssembly::DIV_F32, WebAssembly::DIV_F32_S },
  { WebAssembly::DIV_F64, WebAssembly::DIV_F64_S },
  { WebAssembly::DIV_S_I32, WebAssembly::DIV_S_I32_S },
  { WebAssembly::DIV_S_I64, WebAssembly::DIV_S_I64_S },
  { WebAssembly::DIV_U_I32, WebAssembly::DIV_U_I32_S },
  { WebAssembly::DIV_U_I64, WebAssembly::DIV_U_I64_S },
  { WebAssembly::DIV_v2f64, WebAssembly::DIV_v2f64_S },
  { WebAssembly::DIV_v4f32, WebAssembly::DIV_v4f32_S },
  { WebAssembly::DROP_EXNREF, WebAssembly::DROP_EXNREF_S },
  { WebAssembly::DROP_F32, WebAssembly::DROP_F32_S },
  { WebAssembly::DROP_F64, WebAssembly::DROP_F64_S },
  { WebAssembly::DROP_I32, WebAssembly::DROP_I32_S },
  { WebAssembly::DROP_I64, WebAssembly::DROP_I64_S },
  { WebAssembly::DROP_V128, WebAssembly::DROP_V128_S },
  { WebAssembly::ELSE, WebAssembly::ELSE_S },
  { WebAssembly::END, WebAssembly::END_S },
  { WebAssembly::END_BLOCK, WebAssembly::END_BLOCK_S },
  { WebAssembly::END_FUNCTION, WebAssembly::END_FUNCTION_S },
  { WebAssembly::END_IF, WebAssembly::END_IF_S },
  { WebAssembly::END_LOOP, WebAssembly::END_LOOP_S },
  { WebAssembly::END_TRY, WebAssembly::END_TRY_S },
  { WebAssembly::EQZ_I32, WebAssembly::EQZ_I32_S },
  { WebAssembly::EQZ_I64, WebAssembly::EQZ_I64_S },
  { WebAssembly::EQ_F32, WebAssembly::EQ_F32_S },
  { WebAssembly::EQ_F64, WebAssembly::EQ_F64_S },
  { WebAssembly::EQ_I32, WebAssembly::EQ_I32_S },
  { WebAssembly::EQ_I64, WebAssembly::EQ_I64_S },
  { WebAssembly::EQ_v16i8, WebAssembly::EQ_v16i8_S },
  { WebAssembly::EQ_v2f64, WebAssembly::EQ_v2f64_S },
  { WebAssembly::EQ_v4f32, WebAssembly::EQ_v4f32_S },
  { WebAssembly::EQ_v4i32, WebAssembly::EQ_v4i32_S },
  { WebAssembly::EQ_v8i16, WebAssembly::EQ_v8i16_S },
  { WebAssembly::EXTRACT_EXCEPTION_I32, WebAssembly::EXTRACT_EXCEPTION_I32_S },
  { WebAssembly::EXTRACT_LANE_v16i8_s, WebAssembly::EXTRACT_LANE_v16i8_s_S },
  { WebAssembly::EXTRACT_LANE_v16i8_u, WebAssembly::EXTRACT_LANE_v16i8_u_S },
  { WebAssembly::EXTRACT_LANE_v2f64, WebAssembly::EXTRACT_LANE_v2f64_S },
  { WebAssembly::EXTRACT_LANE_v2i64, WebAssembly::EXTRACT_LANE_v2i64_S },
  { WebAssembly::EXTRACT_LANE_v4f32, WebAssembly::EXTRACT_LANE_v4f32_S },
  { WebAssembly::EXTRACT_LANE_v4i32, WebAssembly::EXTRACT_LANE_v4i32_S },
  { WebAssembly::EXTRACT_LANE_v8i16_s, WebAssembly::EXTRACT_LANE_v8i16_s_S },
  { WebAssembly::EXTRACT_LANE_v8i16_u, WebAssembly::EXTRACT_LANE_v8i16_u_S },
  { WebAssembly::F32_CONVERT_S_I32, WebAssembly::F32_CONVERT_S_I32_S },
  { WebAssembly::F32_CONVERT_S_I64, WebAssembly::F32_CONVERT_S_I64_S },
  { WebAssembly::F32_CONVERT_U_I32, WebAssembly::F32_CONVERT_U_I32_S },
  { WebAssembly::F32_CONVERT_U_I64, WebAssembly::F32_CONVERT_U_I64_S },
  { WebAssembly::F32_DEMOTE_F64, WebAssembly::F32_DEMOTE_F64_S },
  { WebAssembly::F32_REINTERPRET_I32, WebAssembly::F32_REINTERPRET_I32_S },
  { WebAssembly::F64_CONVERT_S_I32, WebAssembly::F64_CONVERT_S_I32_S },
  { WebAssembly::F64_CONVERT_S_I64, WebAssembly::F64_CONVERT_S_I64_S },
  { WebAssembly::F64_CONVERT_U_I32, WebAssembly::F64_CONVERT_U_I32_S },
  { WebAssembly::F64_CONVERT_U_I64, WebAssembly::F64_CONVERT_U_I64_S },
  { WebAssembly::F64_PROMOTE_F32, WebAssembly::F64_PROMOTE_F32_S },
  { WebAssembly::F64_REINTERPRET_I64, WebAssembly::F64_REINTERPRET_I64_S },
  { WebAssembly::FALLTHROUGH_RETURN_EXNREF, WebAssembly::FALLTHROUGH_RETURN_EXNREF_S },
  { WebAssembly::FALLTHROUGH_RETURN_F32, WebAssembly::FALLTHROUGH_RETURN_F32_S },
  { WebAssembly::FALLTHROUGH_RETURN_F64, WebAssembly::FALLTHROUGH_RETURN_F64_S },
  { WebAssembly::FALLTHROUGH_RETURN_I32, WebAssembly::FALLTHROUGH_RETURN_I32_S },
  { WebAssembly::FALLTHROUGH_RETURN_I64, WebAssembly::FALLTHROUGH_RETURN_I64_S },
  { WebAssembly::FALLTHROUGH_RETURN_VOID, WebAssembly::FALLTHROUGH_RETURN_VOID_S },
  { WebAssembly::FALLTHROUGH_RETURN_v16i8, WebAssembly::FALLTHROUGH_RETURN_v16i8_S },
  { WebAssembly::FALLTHROUGH_RETURN_v2f64, WebAssembly::FALLTHROUGH_RETURN_v2f64_S },
  { WebAssembly::FALLTHROUGH_RETURN_v2i64, WebAssembly::FALLTHROUGH_RETURN_v2i64_S },
  { WebAssembly::FALLTHROUGH_RETURN_v4f32, WebAssembly::FALLTHROUGH_RETURN_v4f32_S },
  { WebAssembly::FALLTHROUGH_RETURN_v4i32, WebAssembly::FALLTHROUGH_RETURN_v4i32_S },
  { WebAssembly::FALLTHROUGH_RETURN_v8i16, WebAssembly::FALLTHROUGH_RETURN_v8i16_S },
  { WebAssembly::FLOOR_F32, WebAssembly::FLOOR_F32_S },
  { WebAssembly::FLOOR_F64, WebAssembly::FLOOR_F64_S },
  { WebAssembly::FP_TO_SINT_I32_F32, WebAssembly::FP_TO_SINT_I32_F32_S },
  { WebAssembly::FP_TO_SINT_I32_F64, WebAssembly::FP_TO_SINT_I32_F64_S },
  { WebAssembly::FP_TO_SINT_I64_F32, WebAssembly::FP_TO_SINT_I64_F32_S },
  { WebAssembly::FP_TO_SINT_I64_F64, WebAssembly::FP_TO_SINT_I64_F64_S },
  { WebAssembly::FP_TO_UINT_I32_F32, WebAssembly::FP_TO_UINT_I32_F32_S },
  { WebAssembly::FP_TO_UINT_I32_F64, WebAssembly::FP_TO_UINT_I32_F64_S },
  { WebAssembly::FP_TO_UINT_I64_F32, WebAssembly::FP_TO_UINT_I64_F32_S },
  { WebAssembly::FP_TO_UINT_I64_F64, WebAssembly::FP_TO_UINT_I64_F64_S },
  { WebAssembly::GE_F32, WebAssembly::GE_F32_S },
  { WebAssembly::GE_F64, WebAssembly::GE_F64_S },
  { WebAssembly::GE_S_I32, WebAssembly::GE_S_I32_S },
  { WebAssembly::GE_S_I64, WebAssembly::GE_S_I64_S },
  { WebAssembly::GE_S_v16i8, WebAssembly::GE_S_v16i8_S },
  { WebAssembly::GE_S_v4i32, WebAssembly::GE_S_v4i32_S },
  { WebAssembly::GE_S_v8i16, WebAssembly::GE_S_v8i16_S },
  { WebAssembly::GE_U_I32, WebAssembly::GE_U_I32_S },
  { WebAssembly::GE_U_I64, WebAssembly::GE_U_I64_S },
  { WebAssembly::GE_U_v16i8, WebAssembly::GE_U_v16i8_S },
  { WebAssembly::GE_U_v4i32, WebAssembly::GE_U_v4i32_S },
  { WebAssembly::GE_U_v8i16, WebAssembly::GE_U_v8i16_S },
  { WebAssembly::GE_v2f64, WebAssembly::GE_v2f64_S },
  { WebAssembly::GE_v4f32, WebAssembly::GE_v4f32_S },
  { WebAssembly::GLOBAL_GET_EXNREF, WebAssembly::GLOBAL_GET_EXNREF_S },
  { WebAssembly::GLOBAL_GET_F32, WebAssembly::GLOBAL_GET_F32_S },
  { WebAssembly::GLOBAL_GET_F64, WebAssembly::GLOBAL_GET_F64_S },
  { WebAssembly::GLOBAL_GET_I32, WebAssembly::GLOBAL_GET_I32_S },
  { WebAssembly::GLOBAL_GET_I64, WebAssembly::GLOBAL_GET_I64_S },
  { WebAssembly::GLOBAL_GET_V128, WebAssembly::GLOBAL_GET_V128_S },
  { WebAssembly::GLOBAL_SET_EXNREF, WebAssembly::GLOBAL_SET_EXNREF_S },
  { WebAssembly::GLOBAL_SET_F32, WebAssembly::GLOBAL_SET_F32_S },
  { WebAssembly::GLOBAL_SET_F64, WebAssembly::GLOBAL_SET_F64_S },
  { WebAssembly::GLOBAL_SET_I32, WebAssembly::GLOBAL_SET_I32_S },
  { WebAssembly::GLOBAL_SET_I64, WebAssembly::GLOBAL_SET_I64_S },
  { WebAssembly::GLOBAL_SET_V128, WebAssembly::GLOBAL_SET_V128_S },
  { WebAssembly::GT_F32, WebAssembly::GT_F32_S },
  { WebAssembly::GT_F64, WebAssembly::GT_F64_S },
  { WebAssembly::GT_S_I32, WebAssembly::GT_S_I32_S },
  { WebAssembly::GT_S_I64, WebAssembly::GT_S_I64_S },
  { WebAssembly::GT_S_v16i8, WebAssembly::GT_S_v16i8_S },
  { WebAssembly::GT_S_v4i32, WebAssembly::GT_S_v4i32_S },
  { WebAssembly::GT_S_v8i16, WebAssembly::GT_S_v8i16_S },
  { WebAssembly::GT_U_I32, WebAssembly::GT_U_I32_S },
  { WebAssembly::GT_U_I64, WebAssembly::GT_U_I64_S },
  { WebAssembly::GT_U_v16i8, WebAssembly::GT_U_v16i8_S },
  { WebAssembly::GT_U_v4i32, WebAssembly::GT_U_v4i32_S },
  { WebAssembly::GT_U_v8i16, WebAssembly::GT_U_v8i16_S },
  { WebAssembly::GT_v2f64, WebAssembly::GT_v2f64_S },
  { WebAssembly::GT_v4f32, WebAssembly::GT_v4f32_S },
  { WebAssembly::I32_EXTEND16_S_I32, WebAssembly::I32_EXTEND16_S_I32_S },
  { WebAssembly::I32_EXTEND8_S_I32, WebAssembly::I32_EXTEND8_S_I32_S },
  { WebAssembly::I32_REINTERPRET_F32, WebAssembly::I32_REINTERPRET_F32_S },
  { WebAssembly::I32_TRUNC_S_F32, WebAssembly::I32_TRUNC_S_F32_S },
  { WebAssembly::I32_TRUNC_S_F64, WebAssembly::I32_TRUNC_S_F64_S },
  { WebAssembly::I32_TRUNC_S_SAT_F32, WebAssembly::I32_TRUNC_S_SAT_F32_S },
  { WebAssembly::I32_TRUNC_S_SAT_F64, WebAssembly::I32_TRUNC_S_SAT_F64_S },
  { WebAssembly::I32_TRUNC_U_F32, WebAssembly::I32_TRUNC_U_F32_S },
  { WebAssembly::I32_TRUNC_U_F64, WebAssembly::I32_TRUNC_U_F64_S },
  { WebAssembly::I32_TRUNC_U_SAT_F32, WebAssembly::I32_TRUNC_U_SAT_F32_S },
  { WebAssembly::I32_TRUNC_U_SAT_F64, WebAssembly::I32_TRUNC_U_SAT_F64_S },
  { WebAssembly::I32_WRAP_I64, WebAssembly::I32_WRAP_I64_S },
  { WebAssembly::I64_EXTEND16_S_I64, WebAssembly::I64_EXTEND16_S_I64_S },
  { WebAssembly::I64_EXTEND32_S_I64, WebAssembly::I64_EXTEND32_S_I64_S },
  { WebAssembly::I64_EXTEND8_S_I64, WebAssembly::I64_EXTEND8_S_I64_S },
  { WebAssembly::I64_EXTEND_S_I32, WebAssembly::I64_EXTEND_S_I32_S },
  { WebAssembly::I64_EXTEND_U_I32, WebAssembly::I64_EXTEND_U_I32_S },
  { WebAssembly::I64_REINTERPRET_F64, WebAssembly::I64_REINTERPRET_F64_S },
  { WebAssembly::I64_TRUNC_S_F32, WebAssembly::I64_TRUNC_S_F32_S },
  { WebAssembly::I64_TRUNC_S_F64, WebAssembly::I64_TRUNC_S_F64_S },
  { WebAssembly::I64_TRUNC_S_SAT_F32, WebAssembly::I64_TRUNC_S_SAT_F32_S },
  { WebAssembly::I64_TRUNC_S_SAT_F64, WebAssembly::I64_TRUNC_S_SAT_F64_S },
  { WebAssembly::I64_TRUNC_U_F32, WebAssembly::I64_TRUNC_U_F32_S },
  { WebAssembly::I64_TRUNC_U_F64, WebAssembly::I64_TRUNC_U_F64_S },
  { WebAssembly::I64_TRUNC_U_SAT_F32, WebAssembly::I64_TRUNC_U_SAT_F32_S },
  { WebAssembly::I64_TRUNC_U_SAT_F64, WebAssembly::I64_TRUNC_U_SAT_F64_S },
  { WebAssembly::IF, WebAssembly::IF_S },
  { WebAssembly::LE_F32, WebAssembly::LE_F32_S },
  { WebAssembly::LE_F64, WebAssembly::LE_F64_S },
  { WebAssembly::LE_S_I32, WebAssembly::LE_S_I32_S },
  { WebAssembly::LE_S_I64, WebAssembly::LE_S_I64_S },
  { WebAssembly::LE_S_v16i8, WebAssembly::LE_S_v16i8_S },
  { WebAssembly::LE_S_v4i32, WebAssembly::LE_S_v4i32_S },
  { WebAssembly::LE_S_v8i16, WebAssembly::LE_S_v8i16_S },
  { WebAssembly::LE_U_I32, WebAssembly::LE_U_I32_S },
  { WebAssembly::LE_U_I64, WebAssembly::LE_U_I64_S },
  { WebAssembly::LE_U_v16i8, WebAssembly::LE_U_v16i8_S },
  { WebAssembly::LE_U_v4i32, WebAssembly::LE_U_v4i32_S },
  { WebAssembly::LE_U_v8i16, WebAssembly::LE_U_v8i16_S },
  { WebAssembly::LE_v2f64, WebAssembly::LE_v2f64_S },
  { WebAssembly::LE_v4f32, WebAssembly::LE_v4f32_S },
  { WebAssembly::LOAD16_S_I32, WebAssembly::LOAD16_S_I32_S },
  { WebAssembly::LOAD16_S_I64, WebAssembly::LOAD16_S_I64_S },
  { WebAssembly::LOAD16_U_I32, WebAssembly::LOAD16_U_I32_S },
  { WebAssembly::LOAD16_U_I64, WebAssembly::LOAD16_U_I64_S },
  { WebAssembly::LOAD32_S_I64, WebAssembly::LOAD32_S_I64_S },
  { WebAssembly::LOAD32_U_I64, WebAssembly::LOAD32_U_I64_S },
  { WebAssembly::LOAD8_S_I32, WebAssembly::LOAD8_S_I32_S },
  { WebAssembly::LOAD8_S_I64, WebAssembly::LOAD8_S_I64_S },
  { WebAssembly::LOAD8_U_I32, WebAssembly::LOAD8_U_I32_S },
  { WebAssembly::LOAD8_U_I64, WebAssembly::LOAD8_U_I64_S },
  { WebAssembly::LOAD_F32, WebAssembly::LOAD_F32_S },
  { WebAssembly::LOAD_F64, WebAssembly::LOAD_F64_S },
  { WebAssembly::LOAD_I32, WebAssembly::LOAD_I32_S },
  { WebAssembly::LOAD_I64, WebAssembly::LOAD_I64_S },
  { WebAssembly::LOAD_v16i8, WebAssembly::LOAD_v16i8_S },
  { WebAssembly::LOAD_v2f64, WebAssembly::LOAD_v2f64_S },
  { WebAssembly::LOAD_v2i64, WebAssembly::LOAD_v2i64_S },
  { WebAssembly::LOAD_v4f32, WebAssembly::LOAD_v4f32_S },
  { WebAssembly::LOAD_v4i32, WebAssembly::LOAD_v4i32_S },
  { WebAssembly::LOAD_v8i16, WebAssembly::LOAD_v8i16_S },
  { WebAssembly::LOCAL_GET_EXNREF, WebAssembly::LOCAL_GET_EXNREF_S },
  { WebAssembly::LOCAL_GET_F32, WebAssembly::LOCAL_GET_F32_S },
  { WebAssembly::LOCAL_GET_F64, WebAssembly::LOCAL_GET_F64_S },
  { WebAssembly::LOCAL_GET_I32, WebAssembly::LOCAL_GET_I32_S },
  { WebAssembly::LOCAL_GET_I64, WebAssembly::LOCAL_GET_I64_S },
  { WebAssembly::LOCAL_GET_V128, WebAssembly::LOCAL_GET_V128_S },
  { WebAssembly::LOCAL_SET_EXNREF, WebAssembly::LOCAL_SET_EXNREF_S },
  { WebAssembly::LOCAL_SET_F32, WebAssembly::LOCAL_SET_F32_S },
  { WebAssembly::LOCAL_SET_F64, WebAssembly::LOCAL_SET_F64_S },
  { WebAssembly::LOCAL_SET_I32, WebAssembly::LOCAL_SET_I32_S },
  { WebAssembly::LOCAL_SET_I64, WebAssembly::LOCAL_SET_I64_S },
  { WebAssembly::LOCAL_SET_V128, WebAssembly::LOCAL_SET_V128_S },
  { WebAssembly::LOCAL_TEE_EXNREF, WebAssembly::LOCAL_TEE_EXNREF_S },
  { WebAssembly::LOCAL_TEE_F32, WebAssembly::LOCAL_TEE_F32_S },
  { WebAssembly::LOCAL_TEE_F64, WebAssembly::LOCAL_TEE_F64_S },
  { WebAssembly::LOCAL_TEE_I32, WebAssembly::LOCAL_TEE_I32_S },
  { WebAssembly::LOCAL_TEE_I64, WebAssembly::LOCAL_TEE_I64_S },
  { WebAssembly::LOCAL_TEE_V128, WebAssembly::LOCAL_TEE_V128_S },
  { WebAssembly::LOOP, WebAssembly::LOOP_S },
  { WebAssembly::LT_F32, WebAssembly::LT_F32_S },
  { WebAssembly::LT_F64, WebAssembly::LT_F64_S },
  { WebAssembly::LT_S_I32, WebAssembly::LT_S_I32_S },
  { WebAssembly::LT_S_I64, WebAssembly::LT_S_I64_S },
  { WebAssembly::LT_S_v16i8, WebAssembly::LT_S_v16i8_S },
  { WebAssembly::LT_S_v4i32, WebAssembly::LT_S_v4i32_S },
  { WebAssembly::LT_S_v8i16, WebAssembly::LT_S_v8i16_S },
  { WebAssembly::LT_U_I32, WebAssembly::LT_U_I32_S },
  { WebAssembly::LT_U_I64, WebAssembly::LT_U_I64_S },
  { WebAssembly::LT_U_v16i8, WebAssembly::LT_U_v16i8_S },
  { WebAssembly::LT_U_v4i32, WebAssembly::LT_U_v4i32_S },
  { WebAssembly::LT_U_v8i16, WebAssembly::LT_U_v8i16_S },
  { WebAssembly::LT_v2f64, WebAssembly::LT_v2f64_S },
  { WebAssembly::LT_v4f32, WebAssembly::LT_v4f32_S },
  { WebAssembly::MAX_F32, WebAssembly::MAX_F32_S },
  { WebAssembly::MAX_F64, WebAssembly::MAX_F64_S },
  { WebAssembly::MAX_v2f64, WebAssembly::MAX_v2f64_S },
  { WebAssembly::MAX_v4f32, WebAssembly::MAX_v4f32_S },
  { WebAssembly::MEMORY_COPY, WebAssembly::MEMORY_COPY_S },
  { WebAssembly::MEMORY_FILL, WebAssembly::MEMORY_FILL_S },
  { WebAssembly::MEMORY_GROW_I32, WebAssembly::MEMORY_GROW_I32_S },
  { WebAssembly::MEMORY_INIT, WebAssembly::MEMORY_INIT_S },
  { WebAssembly::MEMORY_SIZE_I32, WebAssembly::MEMORY_SIZE_I32_S },
  { WebAssembly::MIN_F32, WebAssembly::MIN_F32_S },
  { WebAssembly::MIN_F64, WebAssembly::MIN_F64_S },
  { WebAssembly::MIN_v2f64, WebAssembly::MIN_v2f64_S },
  { WebAssembly::MIN_v4f32, WebAssembly::MIN_v4f32_S },
  { WebAssembly::MUL_F32, WebAssembly::MUL_F32_S },
  { WebAssembly::MUL_F64, WebAssembly::MUL_F64_S },
  { WebAssembly::MUL_I32, WebAssembly::MUL_I32_S },
  { WebAssembly::MUL_I64, WebAssembly::MUL_I64_S },
  { WebAssembly::MUL_v16i8, WebAssembly::MUL_v16i8_S },
  { WebAssembly::MUL_v2f64, WebAssembly::MUL_v2f64_S },
  { WebAssembly::MUL_v4f32, WebAssembly::MUL_v4f32_S },
  { WebAssembly::MUL_v4i32, WebAssembly::MUL_v4i32_S },
  { WebAssembly::MUL_v8i16, WebAssembly::MUL_v8i16_S },
  { WebAssembly::NEAREST_F32, WebAssembly::NEAREST_F32_S },
  { WebAssembly::NEAREST_F64, WebAssembly::NEAREST_F64_S },
  { WebAssembly::NEG_F32, WebAssembly::NEG_F32_S },
  { WebAssembly::NEG_F64, WebAssembly::NEG_F64_S },
  { WebAssembly::NEG_v16i8, WebAssembly::NEG_v16i8_S },
  { WebAssembly::NEG_v2f64, WebAssembly::NEG_v2f64_S },
  { WebAssembly::NEG_v2i64, WebAssembly::NEG_v2i64_S },
  { WebAssembly::NEG_v4f32, WebAssembly::NEG_v4f32_S },
  { WebAssembly::NEG_v4i32, WebAssembly::NEG_v4i32_S },
  { WebAssembly::NEG_v8i16, WebAssembly::NEG_v8i16_S },
  { WebAssembly::NE_F32, WebAssembly::NE_F32_S },
  { WebAssembly::NE_F64, WebAssembly::NE_F64_S },
  { WebAssembly::NE_I32, WebAssembly::NE_I32_S },
  { WebAssembly::NE_I64, WebAssembly::NE_I64_S },
  { WebAssembly::NE_v16i8, WebAssembly::NE_v16i8_S },
  { WebAssembly::NE_v2f64, WebAssembly::NE_v2f64_S },
  { WebAssembly::NE_v4f32, WebAssembly::NE_v4f32_S },
  { WebAssembly::NE_v4i32, WebAssembly::NE_v4i32_S },
  { WebAssembly::NE_v8i16, WebAssembly::NE_v8i16_S },
  { WebAssembly::NOP, WebAssembly::NOP_S },
  { WebAssembly::NOT_v16i8, WebAssembly::NOT_v16i8_S },
  { WebAssembly::NOT_v2i64, WebAssembly::NOT_v2i64_S },
  { WebAssembly::NOT_v4i32, WebAssembly::NOT_v4i32_S },
  { WebAssembly::NOT_v8i16, WebAssembly::NOT_v8i16_S },
  { WebAssembly::OR_I32, WebAssembly::OR_I32_S },
  { WebAssembly::OR_I64, WebAssembly::OR_I64_S },
  { WebAssembly::OR_v16i8, WebAssembly::OR_v16i8_S },
  { WebAssembly::OR_v2i64, WebAssembly::OR_v2i64_S },
  { WebAssembly::OR_v4i32, WebAssembly::OR_v4i32_S },
  { WebAssembly::OR_v8i16, WebAssembly::OR_v8i16_S },
  { WebAssembly::PCALL_INDIRECT_VOID, WebAssembly::PCALL_INDIRECT_VOID_S },
  { WebAssembly::PCALL_INDIRECT_exnref, WebAssembly::PCALL_INDIRECT_exnref_S },
  { WebAssembly::PCALL_INDIRECT_f32, WebAssembly::PCALL_INDIRECT_f32_S },
  { WebAssembly::PCALL_INDIRECT_f64, WebAssembly::PCALL_INDIRECT_f64_S },
  { WebAssembly::PCALL_INDIRECT_i32, WebAssembly::PCALL_INDIRECT_i32_S },
  { WebAssembly::PCALL_INDIRECT_i64, WebAssembly::PCALL_INDIRECT_i64_S },
  { WebAssembly::PCALL_INDIRECT_v16i8, WebAssembly::PCALL_INDIRECT_v16i8_S },
  { WebAssembly::PCALL_INDIRECT_v2f64, WebAssembly::PCALL_INDIRECT_v2f64_S },
  { WebAssembly::PCALL_INDIRECT_v2i64, WebAssembly::PCALL_INDIRECT_v2i64_S },
  { WebAssembly::PCALL_INDIRECT_v4f32, WebAssembly::PCALL_INDIRECT_v4f32_S },
  { WebAssembly::PCALL_INDIRECT_v4i32, WebAssembly::PCALL_INDIRECT_v4i32_S },
  { WebAssembly::PCALL_INDIRECT_v8i16, WebAssembly::PCALL_INDIRECT_v8i16_S },
  { WebAssembly::POPCNT_I32, WebAssembly::POPCNT_I32_S },
  { WebAssembly::POPCNT_I64, WebAssembly::POPCNT_I64_S },
  { WebAssembly::PRET_CALL_INDIRECT, WebAssembly::PRET_CALL_INDIRECT_S },
  { WebAssembly::REM_S_I32, WebAssembly::REM_S_I32_S },
  { WebAssembly::REM_S_I64, WebAssembly::REM_S_I64_S },
  { WebAssembly::REM_U_I32, WebAssembly::REM_U_I32_S },
  { WebAssembly::REM_U_I64, WebAssembly::REM_U_I64_S },
  { WebAssembly::REPLACE_LANE_v16i8, WebAssembly::REPLACE_LANE_v16i8_S },
  { WebAssembly::REPLACE_LANE_v2f64, WebAssembly::REPLACE_LANE_v2f64_S },
  { WebAssembly::REPLACE_LANE_v2i64, WebAssembly::REPLACE_LANE_v2i64_S },
  { WebAssembly::REPLACE_LANE_v4f32, WebAssembly::REPLACE_LANE_v4f32_S },
  { WebAssembly::REPLACE_LANE_v4i32, WebAssembly::REPLACE_LANE_v4i32_S },
  { WebAssembly::REPLACE_LANE_v8i16, WebAssembly::REPLACE_LANE_v8i16_S },
  { WebAssembly::RETHROW, WebAssembly::RETHROW_S },
  { WebAssembly::RETURN_EXNREF, WebAssembly::RETURN_EXNREF_S },
  { WebAssembly::RETURN_F32, WebAssembly::RETURN_F32_S },
  { WebAssembly::RETURN_F64, WebAssembly::RETURN_F64_S },
  { WebAssembly::RETURN_I32, WebAssembly::RETURN_I32_S },
  { WebAssembly::RETURN_I64, WebAssembly::RETURN_I64_S },
  { WebAssembly::RETURN_VOID, WebAssembly::RETURN_VOID_S },
  { WebAssembly::RETURN_v16i8, WebAssembly::RETURN_v16i8_S },
  { WebAssembly::RETURN_v2f64, WebAssembly::RETURN_v2f64_S },
  { WebAssembly::RETURN_v2i64, WebAssembly::RETURN_v2i64_S },
  { WebAssembly::RETURN_v4f32, WebAssembly::RETURN_v4f32_S },
  { WebAssembly::RETURN_v4i32, WebAssembly::RETURN_v4i32_S },
  { WebAssembly::RETURN_v8i16, WebAssembly::RETURN_v8i16_S },
  { WebAssembly::RET_CALL, WebAssembly::RET_CALL_S },
  { WebAssembly::RET_CALL_INDIRECT, WebAssembly::RET_CALL_INDIRECT_S },
  { WebAssembly::ROTL_I32, WebAssembly::ROTL_I32_S },
  { WebAssembly::ROTL_I64, WebAssembly::ROTL_I64_S },
  { WebAssembly::ROTR_I32, WebAssembly::ROTR_I32_S },
  { WebAssembly::ROTR_I64, WebAssembly::ROTR_I64_S },
  { WebAssembly::SELECT_EXNREF, WebAssembly::SELECT_EXNREF_S },
  { WebAssembly::SELECT_F32, WebAssembly::SELECT_F32_S },
  { WebAssembly::SELECT_F64, WebAssembly::SELECT_F64_S },
  { WebAssembly::SELECT_I32, WebAssembly::SELECT_I32_S },
  { WebAssembly::SELECT_I64, WebAssembly::SELECT_I64_S },
  { WebAssembly::SHL_I32, WebAssembly::SHL_I32_S },
  { WebAssembly::SHL_I64, WebAssembly::SHL_I64_S },
  { WebAssembly::SHL_v16i8, WebAssembly::SHL_v16i8_S },
  { WebAssembly::SHL_v2i64, WebAssembly::SHL_v2i64_S },
  { WebAssembly::SHL_v4i32, WebAssembly::SHL_v4i32_S },
  { WebAssembly::SHL_v8i16, WebAssembly::SHL_v8i16_S },
  { WebAssembly::SHR_S_I32, WebAssembly::SHR_S_I32_S },
  { WebAssembly::SHR_S_I64, WebAssembly::SHR_S_I64_S },
  { WebAssembly::SHR_S_v16i8, WebAssembly::SHR_S_v16i8_S },
  { WebAssembly::SHR_S_v2i64, WebAssembly::SHR_S_v2i64_S },
  { WebAssembly::SHR_S_v4i32, WebAssembly::SHR_S_v4i32_S },
  { WebAssembly::SHR_S_v8i16, WebAssembly::SHR_S_v8i16_S },
  { WebAssembly::SHR_U_I32, WebAssembly::SHR_U_I32_S },
  { WebAssembly::SHR_U_I64, WebAssembly::SHR_U_I64_S },
  { WebAssembly::SHR_U_v16i8, WebAssembly::SHR_U_v16i8_S },
  { WebAssembly::SHR_U_v2i64, WebAssembly::SHR_U_v2i64_S },
  { WebAssembly::SHR_U_v4i32, WebAssembly::SHR_U_v4i32_S },
  { WebAssembly::SHR_U_v8i16, WebAssembly::SHR_U_v8i16_S },
  { WebAssembly::SHUFFLE, WebAssembly::SHUFFLE_S },
  { WebAssembly::SPLAT_v16i8, WebAssembly::SPLAT_v16i8_S },
  { WebAssembly::SPLAT_v2f64, WebAssembly::SPLAT_v2f64_S },
  { WebAssembly::SPLAT_v2i64, WebAssembly::SPLAT_v2i64_S },
  { WebAssembly::SPLAT_v4f32, WebAssembly::SPLAT_v4f32_S },
  { WebAssembly::SPLAT_v4i32, WebAssembly::SPLAT_v4i32_S },
  { WebAssembly::SPLAT_v8i16, WebAssembly::SPLAT_v8i16_S },
  { WebAssembly::SQRT_F32, WebAssembly::SQRT_F32_S },
  { WebAssembly::SQRT_F64, WebAssembly::SQRT_F64_S },
  { WebAssembly::SQRT_v2f64, WebAssembly::SQRT_v2f64_S },
  { WebAssembly::SQRT_v4f32, WebAssembly::SQRT_v4f32_S },
  { WebAssembly::STORE16_I32, WebAssembly::STORE16_I32_S },
  { WebAssembly::STORE16_I64, WebAssembly::STORE16_I64_S },
  { WebAssembly::STORE32_I64, WebAssembly::STORE32_I64_S },
  { WebAssembly::STORE8_I32, WebAssembly::STORE8_I32_S },
  { WebAssembly::STORE8_I64, WebAssembly::STORE8_I64_S },
  { WebAssembly::STORE_F32, WebAssembly::STORE_F32_S },
  { WebAssembly::STORE_F64, WebAssembly::STORE_F64_S },
  { WebAssembly::STORE_I32, WebAssembly::STORE_I32_S },
  { WebAssembly::STORE_I64, WebAssembly::STORE_I64_S },
  { WebAssembly::STORE_v16i8, WebAssembly::STORE_v16i8_S },
  { WebAssembly::STORE_v2f64, WebAssembly::STORE_v2f64_S },
  { WebAssembly::STORE_v2i64, WebAssembly::STORE_v2i64_S },
  { WebAssembly::STORE_v4f32, WebAssembly::STORE_v4f32_S },
  { WebAssembly::STORE_v4i32, WebAssembly::STORE_v4i32_S },
  { WebAssembly::STORE_v8i16, WebAssembly::STORE_v8i16_S },
  { WebAssembly::SUB_F32, WebAssembly::SUB_F32_S },
  { WebAssembly::SUB_F64, WebAssembly::SUB_F64_S },
  { WebAssembly::SUB_I32, WebAssembly::SUB_I32_S },
  { WebAssembly::SUB_I64, WebAssembly::SUB_I64_S },
  { WebAssembly::SUB_SAT_S_v16i8, WebAssembly::SUB_SAT_S_v16i8_S },
  { WebAssembly::SUB_SAT_S_v8i16, WebAssembly::SUB_SAT_S_v8i16_S },
  { WebAssembly::SUB_SAT_U_v16i8, WebAssembly::SUB_SAT_U_v16i8_S },
  { WebAssembly::SUB_SAT_U_v8i16, WebAssembly::SUB_SAT_U_v8i16_S },
  { WebAssembly::SUB_v16i8, WebAssembly::SUB_v16i8_S },
  { WebAssembly::SUB_v2f64, WebAssembly::SUB_v2f64_S },
  { WebAssembly::SUB_v2i64, WebAssembly::SUB_v2i64_S },
  { WebAssembly::SUB_v4f32, WebAssembly::SUB_v4f32_S },
  { WebAssembly::SUB_v4i32, WebAssembly::SUB_v4i32_S },
  { WebAssembly::SUB_v8i16, WebAssembly::SUB_v8i16_S },
  { WebAssembly::TEE_EXNREF, WebAssembly::TEE_EXNREF_S },
  { WebAssembly::TEE_F32, WebAssembly::TEE_F32_S },
  { WebAssembly::TEE_F64, WebAssembly::TEE_F64_S },
  { WebAssembly::TEE_I32, WebAssembly::TEE_I32_S },
  { WebAssembly::TEE_I64, WebAssembly::TEE_I64_S },
  { WebAssembly::TEE_V128, WebAssembly::TEE_V128_S },
  { WebAssembly::THROW, WebAssembly::THROW_S },
  { WebAssembly::TRUNC_F32, WebAssembly::TRUNC_F32_S },
  { WebAssembly::TRUNC_F64, WebAssembly::TRUNC_F64_S },
  { WebAssembly::TRY, WebAssembly::TRY_S },
  { WebAssembly::UNREACHABLE, WebAssembly::UNREACHABLE_S },
  { WebAssembly::XOR_I32, WebAssembly::XOR_I32_S },
  { WebAssembly::XOR_I64, WebAssembly::XOR_I64_S },
  { WebAssembly::XOR_v16i8, WebAssembly::XOR_v16i8_S },
  { WebAssembly::XOR_v2i64, WebAssembly::XOR_v2i64_S },
  { WebAssembly::XOR_v4i32, WebAssembly::XOR_v4i32_S },
  { WebAssembly::XOR_v8i16, WebAssembly::XOR_v8i16_S },
  { WebAssembly::fp_to_sint_v2i64_v2f64, WebAssembly::fp_to_sint_v2i64_v2f64_S },
  { WebAssembly::fp_to_sint_v4i32_v4f32, WebAssembly::fp_to_sint_v4i32_v4f32_S },
  { WebAssembly::fp_to_uint_v2i64_v2f64, WebAssembly::fp_to_uint_v2i64_v2f64_S },
  { WebAssembly::fp_to_uint_v4i32_v4f32, WebAssembly::fp_to_uint_v4i32_v4f32_S },
  { WebAssembly::sint_to_fp_v2f64_v2i64, WebAssembly::sint_to_fp_v2f64_v2i64_S },
  { WebAssembly::sint_to_fp_v4f32_v4i32, WebAssembly::sint_to_fp_v4f32_v4i32_S },
  { WebAssembly::uint_to_fp_v2f64_v2i64, WebAssembly::uint_to_fp_v2f64_v2i64_S },
  { WebAssembly::uint_to_fp_v4f32_v4i32, WebAssembly::uint_to_fp_v4f32_v4i32_S },
}; // End of getStackOpcodeTable

  unsigned mid;
  unsigned start = 0;
  unsigned end = 571;
  while (start < end) {
    mid = start + (end - start)/2;
    if (Opcode == getStackOpcodeTable[mid][0]) {
      break;
    }
    if (Opcode < getStackOpcodeTable[mid][0])
      end = mid;
    else
      start = mid + 1;
  }
  if (start == end)
    return -1; // Instruction doesn't exist in this table.

  return getStackOpcodeTable[mid][1];
}

} // End WebAssembly namespace
} // End llvm namespace
#endif // GET_INSTRMAP_INFO

