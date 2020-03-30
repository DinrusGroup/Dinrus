/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Assembly Matcher Source Fragment                                           *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/


#ifdef GET_ASSEMBLER_HEADER
#undef GET_ASSEMBLER_HEADER
  // This should be included into the middle of the declaration of
  // your subclasses implementation of MCTargetAsmParser.
  FeatureBitset ComputeAvailableFeatures(const FeatureBitset& FB) const;
  void convertToMCInst(unsigned Kind, MCInst &Inst, unsigned Opcode,
                       const OperandVector &Operands);
  void convertToMapAndConstraints(unsigned Kind,
                           const OperandVector &Operands) override;
  unsigned MatchInstructionImpl(const OperandVector &Operands,
                                MCInst &Inst,
                                uint64_t &ErrorInfo,
                                FeatureBitset &MissingFeatures,
                                bool matchingInlineAsm,
                                unsigned VariantID = 0);
  unsigned MatchInstructionImpl(const OperandVector &Operands,
                                MCInst &Inst,
                                uint64_t &ErrorInfo,
                                bool matchingInlineAsm,
                                unsigned VariantID = 0) {
    FeatureBitset MissingFeatures;
    return MatchInstructionImpl(Operands, Inst, ErrorInfo, MissingFeatures,
                                matchingInlineAsm, VariantID);
  }

#endif // GET_ASSEMBLER_HEADER_INFO


#ifdef GET_OPERAND_DIAGNOSTIC_TYPES
#undef GET_OPERAND_DIAGNOSTIC_TYPES

#endif // GET_OPERAND_DIAGNOSTIC_TYPES


#ifdef GET_REGISTER_MATCHER
#undef GET_REGISTER_MATCHER

// Bits for subtarget features that participate in instruction matching.
enum SubtargetFeatureBits : uint8_t {
  Feature_HasSIMD128Bit = 5,
  Feature_HasUnimplementedSIMD128Bit = 8,
  Feature_HasAtomicsBit = 0,
  Feature_HasMultivalueBit = 3,
  Feature_HasNontrappingFPToIntBit = 4,
  Feature_NotHasNontrappingFPToIntBit = 9,
  Feature_HasSignExtBit = 6,
  Feature_HasTailCallBit = 7,
  Feature_HasExceptionHandlingBit = 2,
  Feature_HasBulkMemoryBit = 1,
};

#endif // GET_REGISTER_MATCHER


#ifdef GET_SUBTARGET_FEATURE_NAME
#undef GET_SUBTARGET_FEATURE_NAME

// User-level names for subtarget features that participate in
// instruction matching.
static const char *getSubtargetFeatureName(uint64_t Val) {
  switch(Val) {
  case Feature_HasSIMD128Bit: return "simd128";
  case Feature_HasUnimplementedSIMD128Bit: return "unimplemented-simd128";
  case Feature_HasAtomicsBit: return "atomics";
  case Feature_HasMultivalueBit: return "multivalue";
  case Feature_HasNontrappingFPToIntBit: return "nontrapping-fptoint";
  case Feature_NotHasNontrappingFPToIntBit: return "nontrapping-fptoint";
  case Feature_HasSignExtBit: return "sign-ext";
  case Feature_HasTailCallBit: return "tail-call";
  case Feature_HasExceptionHandlingBit: return "exception-handling";
  case Feature_HasBulkMemoryBit: return "bulk-memory";
  default: return "(unknown)";
  }
}

#endif // GET_SUBTARGET_FEATURE_NAME


#ifdef GET_MATCHER_IMPLEMENTATION
#undef GET_MATCHER_IMPLEMENTATION

static const uint8_t TiedAsmOperandTable[][3] = { /* empty  */ {0, 0, 0} };

namespace {
enum OperatorConversionKind {
  CVT_Done,
  CVT_Reg,
  CVT_Tied,
  CVT_95_addImmOperands,
  CVT_95_addBrListOperands,
  CVT_imm_95_0,
  CVT_95_addFPImmOperands,
  CVT_NUM_CONVERTERS
};

enum InstructionConversionKind {
  Convert__Imm1_1__Imm1_0,
  Convert__Imm1_0,
  Convert__Imm1_0__Imm1_1,
  Convert__BrList1_0,
  Convert__Imm1_0__imm_95_0,
  Convert_NoOperands,
  Convert__imm_95_0__imm_95_0,
  Convert__FPImm1_0,
  Convert__FPImm1_0__FPImm1_1,
  Convert__FPImm1_0__FPImm1_1__FPImm1_2__FPImm1_3,
  Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3,
  Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7,
  Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7__Imm1_8__Imm1_9__Imm1_10__Imm1_11__Imm1_12__Imm1_13__Imm1_14__Imm1_15,
  CVT_NUM_SIGNATURES
};

} // end anonymous namespace

static const uint8_t ConversionTable[CVT_NUM_SIGNATURES][33] = {
  // Convert__Imm1_1__Imm1_0
  { CVT_95_addImmOperands, 2, CVT_95_addImmOperands, 1, CVT_Done },
  // Convert__Imm1_0
  { CVT_95_addImmOperands, 1, CVT_Done },
  // Convert__Imm1_0__Imm1_1
  { CVT_95_addImmOperands, 1, CVT_95_addImmOperands, 2, CVT_Done },
  // Convert__BrList1_0
  { CVT_95_addBrListOperands, 1, CVT_Done },
  // Convert__Imm1_0__imm_95_0
  { CVT_95_addImmOperands, 1, CVT_imm_95_0, 0, CVT_Done },
  // Convert_NoOperands
  { CVT_Done },
  // Convert__imm_95_0__imm_95_0
  { CVT_imm_95_0, 0, CVT_imm_95_0, 0, CVT_Done },
  // Convert__FPImm1_0
  { CVT_95_addFPImmOperands, 1, CVT_Done },
  // Convert__FPImm1_0__FPImm1_1
  { CVT_95_addFPImmOperands, 1, CVT_95_addFPImmOperands, 2, CVT_Done },
  // Convert__FPImm1_0__FPImm1_1__FPImm1_2__FPImm1_3
  { CVT_95_addFPImmOperands, 1, CVT_95_addFPImmOperands, 2, CVT_95_addFPImmOperands, 3, CVT_95_addFPImmOperands, 4, CVT_Done },
  // Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3
  { CVT_95_addImmOperands, 1, CVT_95_addImmOperands, 2, CVT_95_addImmOperands, 3, CVT_95_addImmOperands, 4, CVT_Done },
  // Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7
  { CVT_95_addImmOperands, 1, CVT_95_addImmOperands, 2, CVT_95_addImmOperands, 3, CVT_95_addImmOperands, 4, CVT_95_addImmOperands, 5, CVT_95_addImmOperands, 6, CVT_95_addImmOperands, 7, CVT_95_addImmOperands, 8, CVT_Done },
  // Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7__Imm1_8__Imm1_9__Imm1_10__Imm1_11__Imm1_12__Imm1_13__Imm1_14__Imm1_15
  { CVT_95_addImmOperands, 1, CVT_95_addImmOperands, 2, CVT_95_addImmOperands, 3, CVT_95_addImmOperands, 4, CVT_95_addImmOperands, 5, CVT_95_addImmOperands, 6, CVT_95_addImmOperands, 7, CVT_95_addImmOperands, 8, CVT_95_addImmOperands, 9, CVT_95_addImmOperands, 10, CVT_95_addImmOperands, 11, CVT_95_addImmOperands, 12, CVT_95_addImmOperands, 13, CVT_95_addImmOperands, 14, CVT_95_addImmOperands, 15, CVT_95_addImmOperands, 16, CVT_Done },
};

void WebAssemblyAsmParser::
convertToMCInst(unsigned Kind, MCInst &Inst, unsigned Opcode,
                const OperandVector &Operands) {
  assert(Kind < CVT_NUM_SIGNATURES && "Invalid signature!");
  const uint8_t *Converter = ConversionTable[Kind];
  unsigned OpIdx;
  Inst.setOpcode(Opcode);
  for (const uint8_t *p = Converter; *p; p+= 2) {
    OpIdx = *(p + 1);
    switch (*p) {
    default: llvm_unreachable("invalid conversion entry!");
    case CVT_Reg:
      static_cast<WebAssemblyOperand&>(*Operands[OpIdx]).addRegOperands(Inst, 1);
      break;
    case CVT_Tied: {
      assert(OpIdx < (size_t)(std::end(TiedAsmOperandTable) -
                          std::begin(TiedAsmOperandTable)) &&
             "Tied operand not found");
      unsigned TiedResOpnd = TiedAsmOperandTable[OpIdx][0];
      if (TiedResOpnd != (uint8_t) -1)
        Inst.addOperand(Inst.getOperand(TiedResOpnd));
      break;
    }
    case CVT_95_addImmOperands:
      static_cast<WebAssemblyOperand&>(*Operands[OpIdx]).addImmOperands(Inst, 1);
      break;
    case CVT_95_addBrListOperands:
      static_cast<WebAssemblyOperand&>(*Operands[OpIdx]).addBrListOperands(Inst, 1);
      break;
    case CVT_imm_95_0:
      Inst.addOperand(MCOperand::createImm(0));
      break;
    case CVT_95_addFPImmOperands:
      static_cast<WebAssemblyOperand&>(*Operands[OpIdx]).addFPImmOperands(Inst, 1);
      break;
    }
  }
}

void WebAssemblyAsmParser::
convertToMapAndConstraints(unsigned Kind,
                           const OperandVector &Operands) {
  assert(Kind < CVT_NUM_SIGNATURES && "Invalid signature!");
  unsigned NumMCOperands = 0;
  const uint8_t *Converter = ConversionTable[Kind];
  for (const uint8_t *p = Converter; *p; p+= 2) {
    switch (*p) {
    default: llvm_unreachable("invalid conversion entry!");
    case CVT_Reg:
      Operands[*(p + 1)]->setMCOperandNum(NumMCOperands);
      Operands[*(p + 1)]->setConstraint("r");
      ++NumMCOperands;
      break;
    case CVT_Tied:
      ++NumMCOperands;
      break;
    case CVT_95_addImmOperands:
      Operands[*(p + 1)]->setMCOperandNum(NumMCOperands);
      Operands[*(p + 1)]->setConstraint("m");
      NumMCOperands += 1;
      break;
    case CVT_95_addBrListOperands:
      Operands[*(p + 1)]->setMCOperandNum(NumMCOperands);
      Operands[*(p + 1)]->setConstraint("m");
      NumMCOperands += 1;
      break;
    case CVT_imm_95_0:
      Operands[*(p + 1)]->setMCOperandNum(NumMCOperands);
      Operands[*(p + 1)]->setConstraint("");
      ++NumMCOperands;
      break;
    case CVT_95_addFPImmOperands:
      Operands[*(p + 1)]->setMCOperandNum(NumMCOperands);
      Operands[*(p + 1)]->setConstraint("m");
      NumMCOperands += 1;
      break;
    }
  }
}

namespace {

/// MatchClassKind - The kinds of classes which participate in
/// instruction matching.
enum MatchClassKind {
  InvalidMatchClass = 0,
  OptionalMatchClass = 1,
  MCK_LAST_TOKEN = OptionalMatchClass,
  MCK_EXNREF, // register class 'EXNREF'
  MCK_F32, // register class 'F32'
  MCK_F64, // register class 'F64'
  MCK_V128, // register class 'V128'
  MCK_I32, // register class 'I32'
  MCK_I64, // register class 'I64'
  MCK_LAST_REGISTER = MCK_I64,
  MCK_BrList, // user defined class 'BrListAsmOperand'
  MCK_FPImm, // user defined class 'FPImmAsmOperand'
  MCK_Imm, // user defined class 'ImmAsmOperand'
  NumMatchClassKinds
};

}

static unsigned getDiagKindFromRegisterClass(MatchClassKind RegisterClass) {
  return MCTargetAsmParser::Match_InvalidOperand;
}

static MatchClassKind matchTokenString(StringRef Name) {
  return InvalidMatchClass;
}

/// isSubclass - Compute whether \p A is a subclass of \p B.
static bool isSubclass(MatchClassKind A, MatchClassKind B) {
  if (A == B)
    return true;

  return false;
}

static unsigned validateOperandClass(MCParsedAsmOperand &GOp, MatchClassKind Kind) {
  WebAssemblyOperand &Operand = (WebAssemblyOperand&)GOp;
  if (Kind == InvalidMatchClass)
    return MCTargetAsmParser::Match_InvalidOperand;

  if (Operand.isToken() && Kind <= MCK_LAST_TOKEN)
    return isSubclass(matchTokenString(Operand.getToken()), Kind) ?
             MCTargetAsmParser::Match_Success :
             MCTargetAsmParser::Match_InvalidOperand;

  switch (Kind) {
  default: break;
  // 'BrList' class
  case MCK_BrList: {
    DiagnosticPredicate DP(Operand.isBrList());
    if (DP.isMatch())
      return MCTargetAsmParser::Match_Success;
    break;
    }
  // 'FPImm' class
  case MCK_FPImm: {
    DiagnosticPredicate DP(Operand.isFPImm());
    if (DP.isMatch())
      return MCTargetAsmParser::Match_Success;
    break;
    }
  // 'Imm' class
  case MCK_Imm: {
    DiagnosticPredicate DP(Operand.isImm());
    if (DP.isMatch())
      return MCTargetAsmParser::Match_Success;
    break;
    }
  } // end switch (Kind)

  if (Operand.isReg()) {
    MatchClassKind OpKind;
    switch (Operand.getReg()) {
    default: OpKind = InvalidMatchClass; break;
    case WebAssembly::FP32: OpKind = MCK_I32; break;
    case WebAssembly::FP64: OpKind = MCK_I64; break;
    case WebAssembly::SP32: OpKind = MCK_I32; break;
    case WebAssembly::SP64: OpKind = MCK_I64; break;
    case WebAssembly::I32_0: OpKind = MCK_I32; break;
    case WebAssembly::I64_0: OpKind = MCK_I64; break;
    case WebAssembly::F32_0: OpKind = MCK_F32; break;
    case WebAssembly::F64_0: OpKind = MCK_F64; break;
    case WebAssembly::V128_0: OpKind = MCK_V128; break;
    case WebAssembly::EXNREF_0: OpKind = MCK_EXNREF; break;
    }
    return isSubclass(OpKind, Kind) ? (unsigned)MCTargetAsmParser::Match_Success :
                                      getDiagKindFromRegisterClass(Kind);
  }

  if (Kind > MCK_LAST_TOKEN && Kind <= MCK_LAST_REGISTER)
    return getDiagKindFromRegisterClass(Kind);

  return MCTargetAsmParser::Match_InvalidOperand;
}

#ifndef NDEBUG
const char *getMatchClassName(MatchClassKind Kind) {
  switch (Kind) {
  case InvalidMatchClass: return "InvalidMatchClass";
  case OptionalMatchClass: return "OptionalMatchClass";
  case MCK_EXNREF: return "MCK_EXNREF";
  case MCK_F32: return "MCK_F32";
  case MCK_F64: return "MCK_F64";
  case MCK_V128: return "MCK_V128";
  case MCK_I32: return "MCK_I32";
  case MCK_I64: return "MCK_I64";
  case MCK_BrList: return "MCK_BrList";
  case MCK_FPImm: return "MCK_FPImm";
  case MCK_Imm: return "MCK_Imm";
  case NumMatchClassKinds: return "NumMatchClassKinds";
  }
  llvm_unreachable("unhandled MatchClassKind!");
}

#endif // NDEBUG
FeatureBitset WebAssemblyAsmParser::
ComputeAvailableFeatures(const FeatureBitset& FB) const {
  FeatureBitset Features;
  if ((FB[WebAssembly::FeatureSIMD128]))
    Features[Feature_HasSIMD128Bit] = 1;
  if ((FB[WebAssembly::FeatureUnimplementedSIMD128]))
    Features[Feature_HasUnimplementedSIMD128Bit] = 1;
  if ((FB[WebAssembly::FeatureAtomics]))
    Features[Feature_HasAtomicsBit] = 1;
  if ((FB[WebAssembly::FeatureMultivalue]))
    Features[Feature_HasMultivalueBit] = 1;
  if ((FB[WebAssembly::FeatureNontrappingFPToInt]))
    Features[Feature_HasNontrappingFPToIntBit] = 1;
  if ((!FB[WebAssembly::FeatureNontrappingFPToInt]))
    Features[Feature_NotHasNontrappingFPToIntBit] = 1;
  if ((FB[WebAssembly::FeatureSignExt]))
    Features[Feature_HasSignExtBit] = 1;
  if ((FB[WebAssembly::FeatureTailCall]))
    Features[Feature_HasTailCallBit] = 1;
  if ((FB[WebAssembly::FeatureExceptionHandling]))
    Features[Feature_HasExceptionHandlingBit] = 1;
  if ((FB[WebAssembly::FeatureBulkMemory]))
    Features[Feature_HasBulkMemoryBit] = 1;
  return Features;
}

static bool checkAsmTiedOperandConstraints(const WebAssemblyAsmParser&AsmParser,
                               unsigned Kind,
                               const OperandVector &Operands,
                               uint64_t &ErrorInfo) {
  assert(Kind < CVT_NUM_SIGNATURES && "Invalid signature!");
  const uint8_t *Converter = ConversionTable[Kind];
  for (const uint8_t *p = Converter; *p; p+= 2) {
    switch (*p) {
    case CVT_Tied: {
      unsigned OpIdx = *(p+1);
      assert(OpIdx < (size_t)(std::end(TiedAsmOperandTable) -
                              std::begin(TiedAsmOperandTable)) &&
             "Tied operand not found");
      unsigned OpndNum1 = TiedAsmOperandTable[OpIdx][1];
      unsigned OpndNum2 = TiedAsmOperandTable[OpIdx][2];
      if (OpndNum1 != OpndNum2) {
        auto &SrcOp1 = Operands[OpndNum1];
        auto &SrcOp2 = Operands[OpndNum2];
        if (SrcOp1->isReg() && SrcOp2->isReg()) {
          if (!AsmParser.regsEqual(*SrcOp1, *SrcOp2)) {
            ErrorInfo = OpndNum2;
            return false;
          }
        }
      }
      break;
    }
    default:
      break;
    }
  }
  return true;
}

static const char *const MnemonicTable =
    "\015atomic.notify\005block\002br\005br_if\tbr_on_exn\010br_table\004cal"
    "l\015call_indirect\005catch\010catchret\ncleanupret\016compiler_fence\t"
    "data.drop\004drop\004else\003end\tend_block\014end_function\006end_if\010"
    "end_loop\007end_try\013exnref.call\024exnref.call_indirect\015exnref.se"
    "lect\007f32.abs\007f32.add\010f32.call\021f32.call_indirect\010f32.ceil"
    "\tf32.const\021f32.convert_i32_s\021f32.convert_i32_u\021f32.convert_i6"
    "4_s\021f32.convert_i64_u\014f32.copysign\016f32.demote_f64\007f32.div\006"
    "f32.eq\tf32.floor\006f32.ge\006f32.gt\006f32.le\010f32.load\006f32.lt\007"
    "f32.max\007f32.min\007f32.mul\006f32.ne\013f32.nearest\007f32.neg\023f3"
    "2.reinterpret_i32\nf32.select\010f32.sqrt\tf32.store\007f32.sub\tf32.tr"
    "unc\tf32x4.abs\tf32x4.add\025f32x4.convert_i32x4_s\025f32x4.convert_i32"
    "x4_u\tf32x4.div\010f32x4.eq\022f32x4.extract_lane\010f32x4.ge\010f32x4."
    "gt\010f32x4.le\010f32x4.lt\tf32x4.max\tf32x4.min\tf32x4.mul\010f32x4.ne"
    "\tf32x4.neg\022f32x4.replace_lane\013f32x4.splat\nf32x4.sqrt\tf32x4.sub"
    "\007f64.abs\007f64.add\010f64.call\021f64.call_indirect\010f64.ceil\tf6"
    "4.const\021f64.convert_i32_s\021f64.convert_i32_u\021f64.convert_i64_s\021"
    "f64.convert_i64_u\014f64.copysign\007f64.div\006f64.eq\tf64.floor\006f6"
    "4.ge\006f64.gt\006f64.le\010f64.load\006f64.lt\007f64.max\007f64.min\007"
    "f64.mul\006f64.ne\013f64.nearest\007f64.neg\017f64.promote_f32\023f64.r"
    "einterpret_i64\nf64.select\010f64.sqrt\tf64.store\007f64.sub\tf64.trunc"
    "\tf64x2.abs\tf64x2.add\025f64x2.convert_i64x2_s\025f64x2.convert_i64x2_"
    "u\tf64x2.div\010f64x2.eq\022f64x2.extract_lane\010f64x2.ge\010f64x2.gt\010"
    "f64x2.le\010f64x2.lt\tf64x2.max\tf64x2.min\tf64x2.mul\010f64x2.ne\tf64x"
    "2.neg\022f64x2.replace_lane\013f64x2.splat\nf64x2.sqrt\tf64x2.sub\nglob"
    "al.get\nglobal.set\ti16x8.add\024i16x8.add_saturate_s\024i16x8.add_satu"
    "rate_u\016i16x8.all_true\016i16x8.any_true\010i16x8.eq\024i16x8.extract"
    "_lane_s\024i16x8.extract_lane_u\ni16x8.ge_s\ni16x8.ge_u\ni16x8.gt_s\ni1"
    "6x8.gt_u\ni16x8.le_s\ni16x8.le_u\ni16x8.lt_s\ni16x8.lt_u\ti16x8.mul\010"
    "i16x8.ne\ti16x8.neg\022i16x8.replace_lane\ti16x8.shl\013i16x8.shr_s\013"
    "i16x8.shr_u\013i16x8.splat\ti16x8.sub\024i16x8.sub_saturate_s\024i16x8."
    "sub_saturate_u\007i32.add\007i32.and\017i32.atomic.load\023i32.atomic.l"
    "oad16_u\022i32.atomic.load8_u\022i32.atomic.rmw.add\022i32.atomic.rmw.a"
    "nd\026i32.atomic.rmw.cmpxchg\021i32.atomic.rmw.or\022i32.atomic.rmw.sub"
    "\023i32.atomic.rmw.xchg\022i32.atomic.rmw.xor\026i32.atomic.rmw16.add_u"
    "\026i32.atomic.rmw16.and_u\032i32.atomic.rmw16.cmpxchg_u\025i32.atomic."
    "rmw16.or_u\026i32.atomic.rmw16.sub_u\027i32.atomic.rmw16.xchg_u\026i32."
    "atomic.rmw16.xor_u\025i32.atomic.rmw8.add_u\025i32.atomic.rmw8.and_u\031"
    "i32.atomic.rmw8.cmpxchg_u\024i32.atomic.rmw8.or_u\025i32.atomic.rmw8.su"
    "b_u\026i32.atomic.rmw8.xchg_u\025i32.atomic.rmw8.xor_u\020i32.atomic.st"
    "ore\022i32.atomic.store16\021i32.atomic.store8\017i32.atomic.wait\010i3"
    "2.call\021i32.call_indirect\007i32.clz\ti32.const\007i32.ctz\ti32.div_s"
    "\ti32.div_u\006i32.eq\007i32.eqz\016i32.extend16_s\015i32.extend8_s\010"
    "i32.ge_s\010i32.ge_u\010i32.gt_s\010i32.gt_u\010i32.le_s\010i32.le_u\010"
    "i32.load\014i32.load16_s\014i32.load16_u\013i32.load8_s\013i32.load8_u\010"
    "i32.lt_s\010i32.lt_u\007i32.mul\006i32.ne\006i32.or\ni32.popcnt\023i32."
    "reinterpret_f32\ti32.rem_s\ti32.rem_u\010i32.rotl\010i32.rotr\ni32.sele"
    "ct\007i32.shl\ti32.shr_s\ti32.shr_u\ti32.store\013i32.store16\ni32.stor"
    "e8\007i32.sub\017i32.trunc_f32_s\017i32.trunc_f32_u\017i32.trunc_f64_s\017"
    "i32.trunc_f64_u\023i32.trunc_sat_f32_s\023i32.trunc_sat_f32_u\023i32.tr"
    "unc_sat_f64_s\023i32.trunc_sat_f64_u\014i32.wrap_i64\007i32.xor\ti32x4."
    "add\016i32x4.all_true\016i32x4.any_true\010i32x4.eq\022i32x4.extract_la"
    "ne\ni32x4.ge_s\ni32x4.ge_u\ni32x4.gt_s\ni32x4.gt_u\ni32x4.le_s\ni32x4.l"
    "e_u\ni32x4.lt_s\ni32x4.lt_u\ti32x4.mul\010i32x4.ne\ti32x4.neg\022i32x4."
    "replace_lane\ti32x4.shl\013i32x4.shr_s\013i32x4.shr_u\013i32x4.splat\ti"
    "32x4.sub\027i32x4.trunc_sat_f32x4_s\027i32x4.trunc_sat_f32x4_u\007i64.a"
    "dd\007i64.and\017i64.atomic.load\023i64.atomic.load16_u\023i64.atomic.l"
    "oad32_u\022i64.atomic.load8_u\022i64.atomic.rmw.add\022i64.atomic.rmw.a"
    "nd\026i64.atomic.rmw.cmpxchg\021i64.atomic.rmw.or\022i64.atomic.rmw.sub"
    "\023i64.atomic.rmw.xchg\022i64.atomic.rmw.xor\026i64.atomic.rmw16.add_u"
    "\026i64.atomic.rmw16.and_u\032i64.atomic.rmw16.cmpxchg_u\025i64.atomic."
    "rmw16.or_u\026i64.atomic.rmw16.sub_u\027i64.atomic.rmw16.xchg_u\026i64."
    "atomic.rmw16.xor_u\026i64.atomic.rmw32.add_u\026i64.atomic.rmw32.and_u\032"
    "i64.atomic.rmw32.cmpxchg_u\025i64.atomic.rmw32.or_u\026i64.atomic.rmw32"
    ".sub_u\027i64.atomic.rmw32.xchg_u\026i64.atomic.rmw32.xor_u\025i64.atom"
    "ic.rmw8.add_u\025i64.atomic.rmw8.and_u\031i64.atomic.rmw8.cmpxchg_u\024"
    "i64.atomic.rmw8.or_u\025i64.atomic.rmw8.sub_u\026i64.atomic.rmw8.xchg_u"
    "\025i64.atomic.rmw8.xor_u\020i64.atomic.store\022i64.atomic.store16\022"
    "i64.atomic.store32\021i64.atomic.store8\017i64.atomic.wait\010i64.call\021"
    "i64.call_indirect\007i64.clz\ti64.const\007i64.ctz\ti64.div_s\ti64.div_"
    "u\006i64.eq\007i64.eqz\016i64.extend16_s\016i64.extend32_s\015i64.exten"
    "d8_s\020i64.extend_i32_s\020i64.extend_i32_u\010i64.ge_s\010i64.ge_u\010"
    "i64.gt_s\010i64.gt_u\010i64.le_s\010i64.le_u\010i64.load\014i64.load16_"
    "s\014i64.load16_u\014i64.load32_s\014i64.load32_u\013i64.load8_s\013i64"
    ".load8_u\010i64.lt_s\010i64.lt_u\007i64.mul\006i64.ne\006i64.or\ni64.po"
    "pcnt\023i64.reinterpret_f64\ti64.rem_s\ti64.rem_u\010i64.rotl\010i64.ro"
    "tr\ni64.select\007i64.shl\ti64.shr_s\ti64.shr_u\ti64.store\013i64.store"
    "16\013i64.store32\ni64.store8\007i64.sub\017i64.trunc_f32_s\017i64.trun"
    "c_f32_u\017i64.trunc_f64_s\017i64.trunc_f64_u\023i64.trunc_sat_f32_s\023"
    "i64.trunc_sat_f32_u\023i64.trunc_sat_f64_s\023i64.trunc_sat_f64_u\007i6"
    "4.xor\ti64x2.add\016i64x2.all_true\016i64x2.any_true\022i64x2.extract_l"
    "ane\ti64x2.neg\022i64x2.replace_lane\ti64x2.shl\013i64x2.shr_s\013i64x2"
    ".shr_u\013i64x2.splat\ti64x2.sub\027i64x2.trunc_sat_f64x2_s\027i64x2.tr"
    "unc_sat_f64x2_u\ti8x16.add\024i8x16.add_saturate_s\024i8x16.add_saturat"
    "e_u\016i8x16.all_true\016i8x16.any_true\010i8x16.eq\024i8x16.extract_la"
    "ne_s\024i8x16.extract_lane_u\ni8x16.ge_s\ni8x16.ge_u\ni8x16.gt_s\ni8x16"
    ".gt_u\ni8x16.le_s\ni8x16.le_u\ni8x16.lt_s\ni8x16.lt_u\ti8x16.mul\010i8x"
    "16.ne\ti8x16.neg\022i8x16.replace_lane\ti8x16.shl\013i8x16.shr_s\013i8x"
    "16.shr_u\013i8x16.splat\ti8x16.sub\024i8x16.sub_saturate_s\024i8x16.sub"
    "_saturate_u\002if\tlocal.get\tlocal.set\tlocal.tee\004loop\013memory.co"
    "py\013memory.fill\013memory.grow\013memory.init\013memory.size\003nop\007"
    "rethrow\020rethrow_in_catch\006return\013return_call\024return_call_ind"
    "irect\005throw\003try\013unreachable\010v128.and\016v128.bitselect\tv12"
    "8.call\022v128.call_indirect\nv128.const\tv128.load\010v128.not\007v128"
    ".or\nv128.store\010v128.xor\015v8x16.shuffle";

// Feature bitsets.
enum : uint8_t {
  AMFBS_None,
  AMFBS_HasAtomics,
  AMFBS_HasBulkMemory,
  AMFBS_HasExceptionHandling,
  AMFBS_HasNontrappingFPToInt,
  AMFBS_HasSIMD128,
  AMFBS_HasSignExt,
  AMFBS_HasTailCall,
  AMFBS_HasSIMD128_HasUnimplementedSIMD128,
};

const static FeatureBitset FeatureBitsets[] {
  {}, // AMFBS_None
  {Feature_HasAtomicsBit, },
  {Feature_HasBulkMemoryBit, },
  {Feature_HasExceptionHandlingBit, },
  {Feature_HasNontrappingFPToIntBit, },
  {Feature_HasSIMD128Bit, },
  {Feature_HasSignExtBit, },
  {Feature_HasTailCallBit, },
  {Feature_HasSIMD128Bit, Feature_HasUnimplementedSIMD128Bit, },
};

namespace {
  struct MatchEntry {
    uint16_t Mnemonic;
    uint16_t Opcode;
    uint8_t ConvertFn;
    uint8_t RequiredFeaturesIdx;
    uint8_t Classes[16];
    StringRef getMnemonic() const {
      return StringRef(MnemonicTable + Mnemonic + 1,
                       MnemonicTable[Mnemonic]);
    }
  };

  // Predicate for searching for an opcode.
  struct LessOpcode {
    bool operator()(const MatchEntry &LHS, StringRef RHS) {
      return LHS.getMnemonic() < RHS;
    }
    bool operator()(StringRef LHS, const MatchEntry &RHS) {
      return LHS < RHS.getMnemonic();
    }
    bool operator()(const MatchEntry &LHS, const MatchEntry &RHS) {
      return LHS.getMnemonic() < RHS.getMnemonic();
    }
  };
} // end anonymous namespace.

static const MatchEntry MatchTable0[] = {
  { 0 /* atomic.notify */, WebAssembly::ATOMIC_NOTIFY_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 14 /* block */, WebAssembly::BLOCK_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 20 /* br */, WebAssembly::BR_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 23 /* br_if */, WebAssembly::BR_IF_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 29 /* br_on_exn */, WebAssembly::BR_ON_EXN_S, Convert__Imm1_0__Imm1_1, AMFBS_HasExceptionHandling, { MCK_Imm, MCK_Imm }, },
  { 39 /* br_table */, WebAssembly::BR_TABLE_I32_S, Convert__BrList1_0, AMFBS_None, { MCK_BrList }, },
  { 39 /* br_table */, WebAssembly::BR_TABLE_I64_S, Convert__BrList1_0, AMFBS_None, { MCK_BrList }, },
  { 48 /* call */, WebAssembly::CALL_VOID_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 53 /* call_indirect */, WebAssembly::CALL_INDIRECT_VOID_S, Convert__Imm1_0__imm_95_0, AMFBS_None, { MCK_Imm }, },
  { 67 /* catch */, WebAssembly::CATCH_S, Convert_NoOperands, AMFBS_HasExceptionHandling, {  }, },
  { 73 /* catchret */, WebAssembly::CATCHRET_S, Convert__imm_95_0__imm_95_0, AMFBS_HasExceptionHandling, {  }, },
  { 82 /* cleanupret */, WebAssembly::CLEANUPRET_S, Convert_NoOperands, AMFBS_HasExceptionHandling, {  }, },
  { 93 /* compiler_fence */, WebAssembly::COMPILER_FENCE_S, Convert_NoOperands, AMFBS_HasAtomics, {  }, },
  { 108 /* data.drop */, WebAssembly::DATA_DROP_S, Convert__Imm1_0, AMFBS_HasBulkMemory, { MCK_Imm }, },
  { 118 /* drop */, WebAssembly::DROP_EXNREF_S, Convert_NoOperands, AMFBS_HasExceptionHandling, {  }, },
  { 118 /* drop */, WebAssembly::DROP_V128_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 118 /* drop */, WebAssembly::DROP_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 118 /* drop */, WebAssembly::DROP_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 118 /* drop */, WebAssembly::DROP_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 118 /* drop */, WebAssembly::DROP_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 123 /* else */, WebAssembly::ELSE_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 128 /* end */, WebAssembly::END_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 132 /* end_block */, WebAssembly::END_BLOCK_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 142 /* end_function */, WebAssembly::END_FUNCTION_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 155 /* end_if */, WebAssembly::END_IF_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 162 /* end_loop */, WebAssembly::END_LOOP_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 171 /* end_try */, WebAssembly::END_TRY_S, Convert_NoOperands, AMFBS_HasExceptionHandling, {  }, },
  { 179 /* exnref.call */, WebAssembly::CALL_exnref_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 191 /* exnref.call_indirect */, WebAssembly::CALL_INDIRECT_exnref_S, Convert__Imm1_0__imm_95_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 212 /* exnref.select */, WebAssembly::SELECT_EXNREF_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 226 /* f32.abs */, WebAssembly::ABS_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 234 /* f32.add */, WebAssembly::ADD_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 242 /* f32.call */, WebAssembly::CALL_f32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 251 /* f32.call_indirect */, WebAssembly::CALL_INDIRECT_f32_S, Convert__Imm1_0__imm_95_0, AMFBS_None, { MCK_Imm }, },
  { 269 /* f32.ceil */, WebAssembly::CEIL_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 278 /* f32.const */, WebAssembly::CONST_F32_S, Convert__FPImm1_0, AMFBS_None, { MCK_FPImm }, },
  { 288 /* f32.convert_i32_s */, WebAssembly::F32_CONVERT_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 306 /* f32.convert_i32_u */, WebAssembly::F32_CONVERT_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 324 /* f32.convert_i64_s */, WebAssembly::F32_CONVERT_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 342 /* f32.convert_i64_u */, WebAssembly::F32_CONVERT_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 360 /* f32.copysign */, WebAssembly::COPYSIGN_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 373 /* f32.demote_f64 */, WebAssembly::F32_DEMOTE_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 388 /* f32.div */, WebAssembly::DIV_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 396 /* f32.eq */, WebAssembly::EQ_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 403 /* f32.floor */, WebAssembly::FLOOR_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 413 /* f32.ge */, WebAssembly::GE_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 420 /* f32.gt */, WebAssembly::GT_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 427 /* f32.le */, WebAssembly::LE_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 434 /* f32.load */, WebAssembly::LOAD_F32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 443 /* f32.lt */, WebAssembly::LT_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 450 /* f32.max */, WebAssembly::MAX_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 458 /* f32.min */, WebAssembly::MIN_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 466 /* f32.mul */, WebAssembly::MUL_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 474 /* f32.ne */, WebAssembly::NE_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 481 /* f32.nearest */, WebAssembly::NEAREST_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 493 /* f32.neg */, WebAssembly::NEG_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 501 /* f32.reinterpret_i32 */, WebAssembly::F32_REINTERPRET_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 521 /* f32.select */, WebAssembly::SELECT_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 532 /* f32.sqrt */, WebAssembly::SQRT_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 541 /* f32.store */, WebAssembly::STORE_F32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 551 /* f32.sub */, WebAssembly::SUB_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 559 /* f32.trunc */, WebAssembly::TRUNC_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 569 /* f32x4.abs */, WebAssembly::ABS_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 579 /* f32x4.add */, WebAssembly::ADD_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 589 /* f32x4.convert_i32x4_s */, WebAssembly::sint_to_fp_v4f32_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 611 /* f32x4.convert_i32x4_u */, WebAssembly::uint_to_fp_v4f32_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 633 /* f32x4.div */, WebAssembly::DIV_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128_HasUnimplementedSIMD128, {  }, },
  { 643 /* f32x4.eq */, WebAssembly::EQ_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 652 /* f32x4.extract_lane */, WebAssembly::EXTRACT_LANE_v4f32_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 671 /* f32x4.ge */, WebAssembly::GE_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 680 /* f32x4.gt */, WebAssembly::GT_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 689 /* f32x4.le */, WebAssembly::LE_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 698 /* f32x4.lt */, WebAssembly::LT_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 707 /* f32x4.max */, WebAssembly::MAX_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 717 /* f32x4.min */, WebAssembly::MIN_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 727 /* f32x4.mul */, WebAssembly::MUL_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 737 /* f32x4.ne */, WebAssembly::NE_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 746 /* f32x4.neg */, WebAssembly::NEG_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 756 /* f32x4.replace_lane */, WebAssembly::REPLACE_LANE_v4f32_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 775 /* f32x4.splat */, WebAssembly::SPLAT_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 787 /* f32x4.sqrt */, WebAssembly::SQRT_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128_HasUnimplementedSIMD128, {  }, },
  { 798 /* f32x4.sub */, WebAssembly::SUB_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 808 /* f64.abs */, WebAssembly::ABS_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 816 /* f64.add */, WebAssembly::ADD_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 824 /* f64.call */, WebAssembly::CALL_f64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 833 /* f64.call_indirect */, WebAssembly::CALL_INDIRECT_f64_S, Convert__Imm1_0__imm_95_0, AMFBS_None, { MCK_Imm }, },
  { 851 /* f64.ceil */, WebAssembly::CEIL_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 860 /* f64.const */, WebAssembly::CONST_F64_S, Convert__FPImm1_0, AMFBS_None, { MCK_FPImm }, },
  { 870 /* f64.convert_i32_s */, WebAssembly::F64_CONVERT_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 888 /* f64.convert_i32_u */, WebAssembly::F64_CONVERT_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 906 /* f64.convert_i64_s */, WebAssembly::F64_CONVERT_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 924 /* f64.convert_i64_u */, WebAssembly::F64_CONVERT_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 942 /* f64.copysign */, WebAssembly::COPYSIGN_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 955 /* f64.div */, WebAssembly::DIV_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 963 /* f64.eq */, WebAssembly::EQ_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 970 /* f64.floor */, WebAssembly::FLOOR_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 980 /* f64.ge */, WebAssembly::GE_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 987 /* f64.gt */, WebAssembly::GT_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 994 /* f64.le */, WebAssembly::LE_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1001 /* f64.load */, WebAssembly::LOAD_F64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 1010 /* f64.lt */, WebAssembly::LT_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1017 /* f64.max */, WebAssembly::MAX_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1025 /* f64.min */, WebAssembly::MIN_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1033 /* f64.mul */, WebAssembly::MUL_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1041 /* f64.ne */, WebAssembly::NE_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1048 /* f64.nearest */, WebAssembly::NEAREST_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1060 /* f64.neg */, WebAssembly::NEG_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1068 /* f64.promote_f32 */, WebAssembly::F64_PROMOTE_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1084 /* f64.reinterpret_i64 */, WebAssembly::F64_REINTERPRET_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1104 /* f64.select */, WebAssembly::SELECT_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1115 /* f64.sqrt */, WebAssembly::SQRT_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1124 /* f64.store */, WebAssembly::STORE_F64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 1134 /* f64.sub */, WebAssembly::SUB_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1142 /* f64.trunc */, WebAssembly::TRUNC_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1152 /* f64x2.abs */, WebAssembly::ABS_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1162 /* f64x2.add */, WebAssembly::ADD_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1172 /* f64x2.convert_i64x2_s */, WebAssembly::sint_to_fp_v2f64_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1194 /* f64x2.convert_i64x2_u */, WebAssembly::uint_to_fp_v2f64_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1216 /* f64x2.div */, WebAssembly::DIV_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128_HasUnimplementedSIMD128, {  }, },
  { 1226 /* f64x2.eq */, WebAssembly::EQ_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1235 /* f64x2.extract_lane */, WebAssembly::EXTRACT_LANE_v2f64_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 1254 /* f64x2.ge */, WebAssembly::GE_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1263 /* f64x2.gt */, WebAssembly::GT_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1272 /* f64x2.le */, WebAssembly::LE_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1281 /* f64x2.lt */, WebAssembly::LT_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1290 /* f64x2.max */, WebAssembly::MAX_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1300 /* f64x2.min */, WebAssembly::MIN_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1310 /* f64x2.mul */, WebAssembly::MUL_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1320 /* f64x2.ne */, WebAssembly::NE_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1329 /* f64x2.neg */, WebAssembly::NEG_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1339 /* f64x2.replace_lane */, WebAssembly::REPLACE_LANE_v2f64_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 1358 /* f64x2.splat */, WebAssembly::SPLAT_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1370 /* f64x2.sqrt */, WebAssembly::SQRT_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128_HasUnimplementedSIMD128, {  }, },
  { 1381 /* f64x2.sub */, WebAssembly::SUB_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1391 /* global.get */, WebAssembly::GLOBAL_GET_EXNREF_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 1391 /* global.get */, WebAssembly::GLOBAL_GET_V128_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 1391 /* global.get */, WebAssembly::GLOBAL_GET_F32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1391 /* global.get */, WebAssembly::GLOBAL_GET_F64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1391 /* global.get */, WebAssembly::GLOBAL_GET_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1391 /* global.get */, WebAssembly::GLOBAL_GET_I64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1402 /* global.set */, WebAssembly::GLOBAL_SET_EXNREF_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 1402 /* global.set */, WebAssembly::GLOBAL_SET_V128_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 1402 /* global.set */, WebAssembly::GLOBAL_SET_F32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1402 /* global.set */, WebAssembly::GLOBAL_SET_F64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1402 /* global.set */, WebAssembly::GLOBAL_SET_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1402 /* global.set */, WebAssembly::GLOBAL_SET_I64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 1413 /* i16x8.add */, WebAssembly::ADD_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1423 /* i16x8.add_saturate_s */, WebAssembly::ADD_SAT_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1444 /* i16x8.add_saturate_u */, WebAssembly::ADD_SAT_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1465 /* i16x8.all_true */, WebAssembly::ALLTRUE_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1480 /* i16x8.any_true */, WebAssembly::ANYTRUE_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1495 /* i16x8.eq */, WebAssembly::EQ_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1504 /* i16x8.extract_lane_s */, WebAssembly::EXTRACT_LANE_v8i16_s_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 1525 /* i16x8.extract_lane_u */, WebAssembly::EXTRACT_LANE_v8i16_u_S, Convert__Imm1_0, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_Imm }, },
  { 1546 /* i16x8.ge_s */, WebAssembly::GE_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1557 /* i16x8.ge_u */, WebAssembly::GE_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1568 /* i16x8.gt_s */, WebAssembly::GT_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1579 /* i16x8.gt_u */, WebAssembly::GT_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1590 /* i16x8.le_s */, WebAssembly::LE_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1601 /* i16x8.le_u */, WebAssembly::LE_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1612 /* i16x8.lt_s */, WebAssembly::LT_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1623 /* i16x8.lt_u */, WebAssembly::LT_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1634 /* i16x8.mul */, WebAssembly::MUL_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1644 /* i16x8.ne */, WebAssembly::NE_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1653 /* i16x8.neg */, WebAssembly::NEG_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1663 /* i16x8.replace_lane */, WebAssembly::REPLACE_LANE_v8i16_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 1682 /* i16x8.shl */, WebAssembly::SHL_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1692 /* i16x8.shr_s */, WebAssembly::SHR_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1704 /* i16x8.shr_u */, WebAssembly::SHR_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1716 /* i16x8.splat */, WebAssembly::SPLAT_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1728 /* i16x8.sub */, WebAssembly::SUB_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1738 /* i16x8.sub_saturate_s */, WebAssembly::SUB_SAT_S_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1759 /* i16x8.sub_saturate_u */, WebAssembly::SUB_SAT_U_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 1780 /* i32.add */, WebAssembly::ADD_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1788 /* i32.and */, WebAssembly::AND_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 1796 /* i32.atomic.load */, WebAssembly::ATOMIC_LOAD_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1812 /* i32.atomic.load16_u */, WebAssembly::ATOMIC_LOAD16_U_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1832 /* i32.atomic.load8_u */, WebAssembly::ATOMIC_LOAD8_U_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1851 /* i32.atomic.rmw.add */, WebAssembly::ATOMIC_RMW_ADD_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1870 /* i32.atomic.rmw.and */, WebAssembly::ATOMIC_RMW_AND_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1889 /* i32.atomic.rmw.cmpxchg */, WebAssembly::ATOMIC_RMW_CMPXCHG_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1912 /* i32.atomic.rmw.or */, WebAssembly::ATOMIC_RMW_OR_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1930 /* i32.atomic.rmw.sub */, WebAssembly::ATOMIC_RMW_SUB_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1949 /* i32.atomic.rmw.xchg */, WebAssembly::ATOMIC_RMW_XCHG_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1969 /* i32.atomic.rmw.xor */, WebAssembly::ATOMIC_RMW_XOR_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 1988 /* i32.atomic.rmw16.add_u */, WebAssembly::ATOMIC_RMW16_U_ADD_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2011 /* i32.atomic.rmw16.and_u */, WebAssembly::ATOMIC_RMW16_U_AND_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2034 /* i32.atomic.rmw16.cmpxchg_u */, WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2061 /* i32.atomic.rmw16.or_u */, WebAssembly::ATOMIC_RMW16_U_OR_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2083 /* i32.atomic.rmw16.sub_u */, WebAssembly::ATOMIC_RMW16_U_SUB_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2106 /* i32.atomic.rmw16.xchg_u */, WebAssembly::ATOMIC_RMW16_U_XCHG_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2130 /* i32.atomic.rmw16.xor_u */, WebAssembly::ATOMIC_RMW16_U_XOR_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2153 /* i32.atomic.rmw8.add_u */, WebAssembly::ATOMIC_RMW8_U_ADD_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2175 /* i32.atomic.rmw8.and_u */, WebAssembly::ATOMIC_RMW8_U_AND_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2197 /* i32.atomic.rmw8.cmpxchg_u */, WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2223 /* i32.atomic.rmw8.or_u */, WebAssembly::ATOMIC_RMW8_U_OR_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2244 /* i32.atomic.rmw8.sub_u */, WebAssembly::ATOMIC_RMW8_U_SUB_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2266 /* i32.atomic.rmw8.xchg_u */, WebAssembly::ATOMIC_RMW8_U_XCHG_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2289 /* i32.atomic.rmw8.xor_u */, WebAssembly::ATOMIC_RMW8_U_XOR_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2311 /* i32.atomic.store */, WebAssembly::ATOMIC_STORE_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2328 /* i32.atomic.store16 */, WebAssembly::ATOMIC_STORE16_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2347 /* i32.atomic.store8 */, WebAssembly::ATOMIC_STORE8_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2365 /* i32.atomic.wait */, WebAssembly::ATOMIC_WAIT_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 2381 /* i32.call */, WebAssembly::CALL_i32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 2390 /* i32.call_indirect */, WebAssembly::CALL_INDIRECT_i32_S, Convert__Imm1_0__imm_95_0, AMFBS_None, { MCK_Imm }, },
  { 2408 /* i32.clz */, WebAssembly::CLZ_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2416 /* i32.const */, WebAssembly::CONST_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 2426 /* i32.ctz */, WebAssembly::CTZ_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2434 /* i32.div_s */, WebAssembly::DIV_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2444 /* i32.div_u */, WebAssembly::DIV_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2454 /* i32.eq */, WebAssembly::EQ_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2461 /* i32.eqz */, WebAssembly::EQZ_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2469 /* i32.extend16_s */, WebAssembly::I32_EXTEND16_S_I32_S, Convert_NoOperands, AMFBS_HasSignExt, {  }, },
  { 2484 /* i32.extend8_s */, WebAssembly::I32_EXTEND8_S_I32_S, Convert_NoOperands, AMFBS_HasSignExt, {  }, },
  { 2498 /* i32.ge_s */, WebAssembly::GE_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2507 /* i32.ge_u */, WebAssembly::GE_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2516 /* i32.gt_s */, WebAssembly::GT_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2525 /* i32.gt_u */, WebAssembly::GT_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2534 /* i32.le_s */, WebAssembly::LE_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2543 /* i32.le_u */, WebAssembly::LE_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2552 /* i32.load */, WebAssembly::LOAD_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2561 /* i32.load16_s */, WebAssembly::LOAD16_S_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2574 /* i32.load16_u */, WebAssembly::LOAD16_U_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2587 /* i32.load8_s */, WebAssembly::LOAD8_S_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2599 /* i32.load8_u */, WebAssembly::LOAD8_U_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2611 /* i32.lt_s */, WebAssembly::LT_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2620 /* i32.lt_u */, WebAssembly::LT_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2629 /* i32.mul */, WebAssembly::MUL_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2637 /* i32.ne */, WebAssembly::NE_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2644 /* i32.or */, WebAssembly::OR_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2651 /* i32.popcnt */, WebAssembly::POPCNT_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2662 /* i32.reinterpret_f32 */, WebAssembly::I32_REINTERPRET_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2682 /* i32.rem_s */, WebAssembly::REM_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2692 /* i32.rem_u */, WebAssembly::REM_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2702 /* i32.rotl */, WebAssembly::ROTL_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2711 /* i32.rotr */, WebAssembly::ROTR_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2720 /* i32.select */, WebAssembly::SELECT_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2731 /* i32.shl */, WebAssembly::SHL_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2739 /* i32.shr_s */, WebAssembly::SHR_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2749 /* i32.shr_u */, WebAssembly::SHR_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2759 /* i32.store */, WebAssembly::STORE_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2769 /* i32.store16 */, WebAssembly::STORE16_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2781 /* i32.store8 */, WebAssembly::STORE8_I32_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 2792 /* i32.sub */, WebAssembly::SUB_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2800 /* i32.trunc_f32_s */, WebAssembly::I32_TRUNC_S_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2816 /* i32.trunc_f32_u */, WebAssembly::I32_TRUNC_U_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2832 /* i32.trunc_f64_s */, WebAssembly::I32_TRUNC_S_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2848 /* i32.trunc_f64_u */, WebAssembly::I32_TRUNC_U_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2864 /* i32.trunc_sat_f32_s */, WebAssembly::I32_TRUNC_S_SAT_F32_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 2884 /* i32.trunc_sat_f32_u */, WebAssembly::I32_TRUNC_U_SAT_F32_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 2904 /* i32.trunc_sat_f64_s */, WebAssembly::I32_TRUNC_S_SAT_F64_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 2924 /* i32.trunc_sat_f64_u */, WebAssembly::I32_TRUNC_U_SAT_F64_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 2944 /* i32.wrap_i64 */, WebAssembly::I32_WRAP_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2957 /* i32.xor */, WebAssembly::XOR_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 2965 /* i32x4.add */, WebAssembly::ADD_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 2975 /* i32x4.all_true */, WebAssembly::ALLTRUE_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 2990 /* i32x4.any_true */, WebAssembly::ANYTRUE_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3005 /* i32x4.eq */, WebAssembly::EQ_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3014 /* i32x4.extract_lane */, WebAssembly::EXTRACT_LANE_v4i32_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 3033 /* i32x4.ge_s */, WebAssembly::GE_S_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3044 /* i32x4.ge_u */, WebAssembly::GE_U_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3055 /* i32x4.gt_s */, WebAssembly::GT_S_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3066 /* i32x4.gt_u */, WebAssembly::GT_U_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3077 /* i32x4.le_s */, WebAssembly::LE_S_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3088 /* i32x4.le_u */, WebAssembly::LE_U_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3099 /* i32x4.lt_s */, WebAssembly::LT_S_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3110 /* i32x4.lt_u */, WebAssembly::LT_U_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3121 /* i32x4.mul */, WebAssembly::MUL_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3131 /* i32x4.ne */, WebAssembly::NE_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3140 /* i32x4.neg */, WebAssembly::NEG_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3150 /* i32x4.replace_lane */, WebAssembly::REPLACE_LANE_v4i32_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 3169 /* i32x4.shl */, WebAssembly::SHL_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3179 /* i32x4.shr_s */, WebAssembly::SHR_S_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3191 /* i32x4.shr_u */, WebAssembly::SHR_U_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3203 /* i32x4.splat */, WebAssembly::SPLAT_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3215 /* i32x4.sub */, WebAssembly::SUB_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3225 /* i32x4.trunc_sat_f32x4_s */, WebAssembly::fp_to_sint_v4i32_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3249 /* i32x4.trunc_sat_f32x4_u */, WebAssembly::fp_to_uint_v4i32_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 3273 /* i64.add */, WebAssembly::ADD_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 3281 /* i64.and */, WebAssembly::AND_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 3289 /* i64.atomic.load */, WebAssembly::ATOMIC_LOAD_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3305 /* i64.atomic.load16_u */, WebAssembly::ATOMIC_LOAD16_U_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3325 /* i64.atomic.load32_u */, WebAssembly::ATOMIC_LOAD32_U_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3345 /* i64.atomic.load8_u */, WebAssembly::ATOMIC_LOAD8_U_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3364 /* i64.atomic.rmw.add */, WebAssembly::ATOMIC_RMW_ADD_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3383 /* i64.atomic.rmw.and */, WebAssembly::ATOMIC_RMW_AND_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3402 /* i64.atomic.rmw.cmpxchg */, WebAssembly::ATOMIC_RMW_CMPXCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3425 /* i64.atomic.rmw.or */, WebAssembly::ATOMIC_RMW_OR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3443 /* i64.atomic.rmw.sub */, WebAssembly::ATOMIC_RMW_SUB_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3462 /* i64.atomic.rmw.xchg */, WebAssembly::ATOMIC_RMW_XCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3482 /* i64.atomic.rmw.xor */, WebAssembly::ATOMIC_RMW_XOR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3501 /* i64.atomic.rmw16.add_u */, WebAssembly::ATOMIC_RMW16_U_ADD_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3524 /* i64.atomic.rmw16.and_u */, WebAssembly::ATOMIC_RMW16_U_AND_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3547 /* i64.atomic.rmw16.cmpxchg_u */, WebAssembly::ATOMIC_RMW16_U_CMPXCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3574 /* i64.atomic.rmw16.or_u */, WebAssembly::ATOMIC_RMW16_U_OR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3596 /* i64.atomic.rmw16.sub_u */, WebAssembly::ATOMIC_RMW16_U_SUB_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3619 /* i64.atomic.rmw16.xchg_u */, WebAssembly::ATOMIC_RMW16_U_XCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3643 /* i64.atomic.rmw16.xor_u */, WebAssembly::ATOMIC_RMW16_U_XOR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3666 /* i64.atomic.rmw32.add_u */, WebAssembly::ATOMIC_RMW32_U_ADD_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3689 /* i64.atomic.rmw32.and_u */, WebAssembly::ATOMIC_RMW32_U_AND_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3712 /* i64.atomic.rmw32.cmpxchg_u */, WebAssembly::ATOMIC_RMW32_U_CMPXCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3739 /* i64.atomic.rmw32.or_u */, WebAssembly::ATOMIC_RMW32_U_OR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3761 /* i64.atomic.rmw32.sub_u */, WebAssembly::ATOMIC_RMW32_U_SUB_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3784 /* i64.atomic.rmw32.xchg_u */, WebAssembly::ATOMIC_RMW32_U_XCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3808 /* i64.atomic.rmw32.xor_u */, WebAssembly::ATOMIC_RMW32_U_XOR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3831 /* i64.atomic.rmw8.add_u */, WebAssembly::ATOMIC_RMW8_U_ADD_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3853 /* i64.atomic.rmw8.and_u */, WebAssembly::ATOMIC_RMW8_U_AND_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3875 /* i64.atomic.rmw8.cmpxchg_u */, WebAssembly::ATOMIC_RMW8_U_CMPXCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3901 /* i64.atomic.rmw8.or_u */, WebAssembly::ATOMIC_RMW8_U_OR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3922 /* i64.atomic.rmw8.sub_u */, WebAssembly::ATOMIC_RMW8_U_SUB_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3944 /* i64.atomic.rmw8.xchg_u */, WebAssembly::ATOMIC_RMW8_U_XCHG_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3967 /* i64.atomic.rmw8.xor_u */, WebAssembly::ATOMIC_RMW8_U_XOR_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 3989 /* i64.atomic.store */, WebAssembly::ATOMIC_STORE_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 4006 /* i64.atomic.store16 */, WebAssembly::ATOMIC_STORE16_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 4025 /* i64.atomic.store32 */, WebAssembly::ATOMIC_STORE32_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 4044 /* i64.atomic.store8 */, WebAssembly::ATOMIC_STORE8_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 4062 /* i64.atomic.wait */, WebAssembly::ATOMIC_WAIT_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasAtomics, { MCK_Imm, MCK_Imm }, },
  { 4078 /* i64.call */, WebAssembly::CALL_i64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 4087 /* i64.call_indirect */, WebAssembly::CALL_INDIRECT_i64_S, Convert__Imm1_0__imm_95_0, AMFBS_None, { MCK_Imm }, },
  { 4105 /* i64.clz */, WebAssembly::CLZ_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4113 /* i64.const */, WebAssembly::CONST_I64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 4123 /* i64.ctz */, WebAssembly::CTZ_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4131 /* i64.div_s */, WebAssembly::DIV_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4141 /* i64.div_u */, WebAssembly::DIV_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4151 /* i64.eq */, WebAssembly::EQ_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4158 /* i64.eqz */, WebAssembly::EQZ_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4166 /* i64.extend16_s */, WebAssembly::I64_EXTEND16_S_I64_S, Convert_NoOperands, AMFBS_HasSignExt, {  }, },
  { 4181 /* i64.extend32_s */, WebAssembly::I64_EXTEND32_S_I64_S, Convert_NoOperands, AMFBS_HasSignExt, {  }, },
  { 4196 /* i64.extend8_s */, WebAssembly::I64_EXTEND8_S_I64_S, Convert_NoOperands, AMFBS_HasSignExt, {  }, },
  { 4210 /* i64.extend_i32_s */, WebAssembly::I64_EXTEND_S_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4227 /* i64.extend_i32_u */, WebAssembly::I64_EXTEND_U_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4244 /* i64.ge_s */, WebAssembly::GE_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4253 /* i64.ge_u */, WebAssembly::GE_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4262 /* i64.gt_s */, WebAssembly::GT_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4271 /* i64.gt_u */, WebAssembly::GT_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4280 /* i64.le_s */, WebAssembly::LE_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4289 /* i64.le_u */, WebAssembly::LE_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4298 /* i64.load */, WebAssembly::LOAD_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4307 /* i64.load16_s */, WebAssembly::LOAD16_S_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4320 /* i64.load16_u */, WebAssembly::LOAD16_U_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4333 /* i64.load32_s */, WebAssembly::LOAD32_S_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4346 /* i64.load32_u */, WebAssembly::LOAD32_U_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4359 /* i64.load8_s */, WebAssembly::LOAD8_S_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4371 /* i64.load8_u */, WebAssembly::LOAD8_U_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4383 /* i64.lt_s */, WebAssembly::LT_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4392 /* i64.lt_u */, WebAssembly::LT_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4401 /* i64.mul */, WebAssembly::MUL_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4409 /* i64.ne */, WebAssembly::NE_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4416 /* i64.or */, WebAssembly::OR_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4423 /* i64.popcnt */, WebAssembly::POPCNT_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4434 /* i64.reinterpret_f64 */, WebAssembly::I64_REINTERPRET_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4454 /* i64.rem_s */, WebAssembly::REM_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4464 /* i64.rem_u */, WebAssembly::REM_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4474 /* i64.rotl */, WebAssembly::ROTL_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4483 /* i64.rotr */, WebAssembly::ROTR_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4492 /* i64.select */, WebAssembly::SELECT_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4503 /* i64.shl */, WebAssembly::SHL_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4511 /* i64.shr_s */, WebAssembly::SHR_S_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4521 /* i64.shr_u */, WebAssembly::SHR_U_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4531 /* i64.store */, WebAssembly::STORE_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4541 /* i64.store16 */, WebAssembly::STORE16_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4553 /* i64.store32 */, WebAssembly::STORE32_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4565 /* i64.store8 */, WebAssembly::STORE8_I64_S, Convert__Imm1_1__Imm1_0, AMFBS_None, { MCK_Imm, MCK_Imm }, },
  { 4576 /* i64.sub */, WebAssembly::SUB_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4584 /* i64.trunc_f32_s */, WebAssembly::I64_TRUNC_S_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4600 /* i64.trunc_f32_u */, WebAssembly::I64_TRUNC_U_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4616 /* i64.trunc_f64_s */, WebAssembly::I64_TRUNC_S_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4632 /* i64.trunc_f64_u */, WebAssembly::I64_TRUNC_U_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4648 /* i64.trunc_sat_f32_s */, WebAssembly::I64_TRUNC_S_SAT_F32_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 4668 /* i64.trunc_sat_f32_u */, WebAssembly::I64_TRUNC_U_SAT_F32_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 4688 /* i64.trunc_sat_f64_s */, WebAssembly::I64_TRUNC_S_SAT_F64_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 4708 /* i64.trunc_sat_f64_u */, WebAssembly::I64_TRUNC_U_SAT_F64_S, Convert_NoOperands, AMFBS_HasNontrappingFPToInt, {  }, },
  { 4728 /* i64.xor */, WebAssembly::XOR_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 4736 /* i64x2.add */, WebAssembly::ADD_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4746 /* i64x2.all_true */, WebAssembly::ALLTRUE_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4761 /* i64x2.any_true */, WebAssembly::ANYTRUE_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4776 /* i64x2.extract_lane */, WebAssembly::EXTRACT_LANE_v2i64_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 4795 /* i64x2.neg */, WebAssembly::NEG_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4805 /* i64x2.replace_lane */, WebAssembly::REPLACE_LANE_v2i64_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 4824 /* i64x2.shl */, WebAssembly::SHL_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4834 /* i64x2.shr_s */, WebAssembly::SHR_S_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4846 /* i64x2.shr_u */, WebAssembly::SHR_U_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4858 /* i64x2.splat */, WebAssembly::SPLAT_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4870 /* i64x2.sub */, WebAssembly::SUB_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4880 /* i64x2.trunc_sat_f64x2_s */, WebAssembly::fp_to_sint_v2i64_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4904 /* i64x2.trunc_sat_f64x2_u */, WebAssembly::fp_to_uint_v2i64_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4928 /* i8x16.add */, WebAssembly::ADD_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4938 /* i8x16.add_saturate_s */, WebAssembly::ADD_SAT_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4959 /* i8x16.add_saturate_u */, WebAssembly::ADD_SAT_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4980 /* i8x16.all_true */, WebAssembly::ALLTRUE_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 4995 /* i8x16.any_true */, WebAssembly::ANYTRUE_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5010 /* i8x16.eq */, WebAssembly::EQ_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5019 /* i8x16.extract_lane_s */, WebAssembly::EXTRACT_LANE_v16i8_s_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5040 /* i8x16.extract_lane_u */, WebAssembly::EXTRACT_LANE_v16i8_u_S, Convert__Imm1_0, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_Imm }, },
  { 5061 /* i8x16.ge_s */, WebAssembly::GE_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5072 /* i8x16.ge_u */, WebAssembly::GE_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5083 /* i8x16.gt_s */, WebAssembly::GT_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5094 /* i8x16.gt_u */, WebAssembly::GT_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5105 /* i8x16.le_s */, WebAssembly::LE_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5116 /* i8x16.le_u */, WebAssembly::LE_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5127 /* i8x16.lt_s */, WebAssembly::LT_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5138 /* i8x16.lt_u */, WebAssembly::LT_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5149 /* i8x16.mul */, WebAssembly::MUL_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5159 /* i8x16.ne */, WebAssembly::NE_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5168 /* i8x16.neg */, WebAssembly::NEG_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5178 /* i8x16.replace_lane */, WebAssembly::REPLACE_LANE_v16i8_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5197 /* i8x16.shl */, WebAssembly::SHL_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5207 /* i8x16.shr_s */, WebAssembly::SHR_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5219 /* i8x16.shr_u */, WebAssembly::SHR_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5231 /* i8x16.splat */, WebAssembly::SPLAT_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5243 /* i8x16.sub */, WebAssembly::SUB_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5253 /* i8x16.sub_saturate_s */, WebAssembly::SUB_SAT_S_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5274 /* i8x16.sub_saturate_u */, WebAssembly::SUB_SAT_U_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5295 /* if */, WebAssembly::IF_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5298 /* local.get */, WebAssembly::LOCAL_GET_EXNREF_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 5298 /* local.get */, WebAssembly::LOCAL_GET_V128_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5298 /* local.get */, WebAssembly::LOCAL_GET_F32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5298 /* local.get */, WebAssembly::LOCAL_GET_F64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5298 /* local.get */, WebAssembly::LOCAL_GET_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5298 /* local.get */, WebAssembly::LOCAL_GET_I64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5308 /* local.set */, WebAssembly::LOCAL_SET_EXNREF_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 5308 /* local.set */, WebAssembly::LOCAL_SET_V128_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5308 /* local.set */, WebAssembly::LOCAL_SET_F32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5308 /* local.set */, WebAssembly::LOCAL_SET_F64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5308 /* local.set */, WebAssembly::LOCAL_SET_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5308 /* local.set */, WebAssembly::LOCAL_SET_I64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5318 /* local.tee */, WebAssembly::LOCAL_TEE_EXNREF_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 5318 /* local.tee */, WebAssembly::LOCAL_TEE_V128_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5318 /* local.tee */, WebAssembly::LOCAL_TEE_F32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5318 /* local.tee */, WebAssembly::LOCAL_TEE_F64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5318 /* local.tee */, WebAssembly::LOCAL_TEE_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5318 /* local.tee */, WebAssembly::LOCAL_TEE_I64_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5328 /* loop */, WebAssembly::LOOP_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5333 /* memory.copy */, WebAssembly::MEMORY_COPY_S, Convert__Imm1_0__Imm1_1, AMFBS_HasBulkMemory, { MCK_Imm, MCK_Imm }, },
  { 5345 /* memory.fill */, WebAssembly::MEMORY_FILL_S, Convert__Imm1_0, AMFBS_HasBulkMemory, { MCK_Imm }, },
  { 5357 /* memory.grow */, WebAssembly::MEMORY_GROW_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5369 /* memory.init */, WebAssembly::MEMORY_INIT_S, Convert__Imm1_0__Imm1_1, AMFBS_HasBulkMemory, { MCK_Imm, MCK_Imm }, },
  { 5381 /* memory.size */, WebAssembly::MEMORY_SIZE_I32_S, Convert__Imm1_0, AMFBS_None, { MCK_Imm }, },
  { 5393 /* nop */, WebAssembly::NOP_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5397 /* rethrow */, WebAssembly::RETHROW_S, Convert_NoOperands, AMFBS_HasExceptionHandling, {  }, },
  { 5405 /* rethrow_in_catch */, WebAssembly::RETHROW_IN_CATCH_S, Convert_NoOperands, AMFBS_HasExceptionHandling, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_EXNREF_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_F32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_F64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_I32_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_I64_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5422 /* return */, WebAssembly::RETURN_VOID_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5429 /* return_call */, WebAssembly::RET_CALL_S, Convert__Imm1_0, AMFBS_HasTailCall, { MCK_Imm }, },
  { 5441 /* return_call_indirect */, WebAssembly::RET_CALL_INDIRECT_S, Convert__Imm1_0__imm_95_0, AMFBS_HasTailCall, { MCK_Imm }, },
  { 5462 /* throw */, WebAssembly::THROW_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 5468 /* try */, WebAssembly::TRY_S, Convert__Imm1_0, AMFBS_HasExceptionHandling, { MCK_Imm }, },
  { 5472 /* unreachable */, WebAssembly::UNREACHABLE_S, Convert_NoOperands, AMFBS_None, {  }, },
  { 5484 /* v128.and */, WebAssembly::AND_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5484 /* v128.and */, WebAssembly::AND_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5484 /* v128.and */, WebAssembly::AND_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5484 /* v128.and */, WebAssembly::AND_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5493 /* v128.bitselect */, WebAssembly::BITSELECT_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5493 /* v128.bitselect */, WebAssembly::BITSELECT_v2f64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5493 /* v128.bitselect */, WebAssembly::BITSELECT_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5493 /* v128.bitselect */, WebAssembly::BITSELECT_v4f32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5493 /* v128.bitselect */, WebAssembly::BITSELECT_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5493 /* v128.bitselect */, WebAssembly::BITSELECT_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5508 /* v128.call */, WebAssembly::CALL_v16i8_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5508 /* v128.call */, WebAssembly::CALL_v2f64_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5508 /* v128.call */, WebAssembly::CALL_v2i64_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5508 /* v128.call */, WebAssembly::CALL_v4f32_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5508 /* v128.call */, WebAssembly::CALL_v4i32_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5508 /* v128.call */, WebAssembly::CALL_v8i16_S, Convert__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5518 /* v128.call_indirect */, WebAssembly::CALL_INDIRECT_v16i8_S, Convert__Imm1_0__imm_95_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5518 /* v128.call_indirect */, WebAssembly::CALL_INDIRECT_v2f64_S, Convert__Imm1_0__imm_95_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5518 /* v128.call_indirect */, WebAssembly::CALL_INDIRECT_v2i64_S, Convert__Imm1_0__imm_95_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5518 /* v128.call_indirect */, WebAssembly::CALL_INDIRECT_v4f32_S, Convert__Imm1_0__imm_95_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5518 /* v128.call_indirect */, WebAssembly::CALL_INDIRECT_v4i32_S, Convert__Imm1_0__imm_95_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5518 /* v128.call_indirect */, WebAssembly::CALL_INDIRECT_v8i16_S, Convert__Imm1_0__imm_95_0, AMFBS_HasSIMD128, { MCK_Imm }, },
  { 5537 /* v128.const */, WebAssembly::CONST_V128_v2f64_S, Convert__FPImm1_0__FPImm1_1, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_FPImm, MCK_FPImm }, },
  { 5537 /* v128.const */, WebAssembly::CONST_V128_v2i64_S, Convert__Imm1_0__Imm1_1, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5537 /* v128.const */, WebAssembly::CONST_V128_v4f32_S, Convert__FPImm1_0__FPImm1_1__FPImm1_2__FPImm1_3, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_FPImm, MCK_FPImm, MCK_FPImm, MCK_FPImm }, },
  { 5537 /* v128.const */, WebAssembly::CONST_V128_v4i32_S, Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm }, },
  { 5537 /* v128.const */, WebAssembly::CONST_V128_v8i16_S, Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm }, },
  { 5537 /* v128.const */, WebAssembly::CONST_V128_v16i8_S, Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7__Imm1_8__Imm1_9__Imm1_10__Imm1_11__Imm1_12__Imm1_13__Imm1_14__Imm1_15, AMFBS_HasSIMD128_HasUnimplementedSIMD128, { MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm }, },
  { 5548 /* v128.load */, WebAssembly::LOAD_v16i8_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5548 /* v128.load */, WebAssembly::LOAD_v2f64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5548 /* v128.load */, WebAssembly::LOAD_v2i64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5548 /* v128.load */, WebAssembly::LOAD_v4f32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5548 /* v128.load */, WebAssembly::LOAD_v4i32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5548 /* v128.load */, WebAssembly::LOAD_v8i16_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5558 /* v128.not */, WebAssembly::NOT_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5558 /* v128.not */, WebAssembly::NOT_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5558 /* v128.not */, WebAssembly::NOT_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5558 /* v128.not */, WebAssembly::NOT_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5567 /* v128.or */, WebAssembly::OR_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5567 /* v128.or */, WebAssembly::OR_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5567 /* v128.or */, WebAssembly::OR_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5567 /* v128.or */, WebAssembly::OR_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5575 /* v128.store */, WebAssembly::STORE_v16i8_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5575 /* v128.store */, WebAssembly::STORE_v2f64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5575 /* v128.store */, WebAssembly::STORE_v2i64_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5575 /* v128.store */, WebAssembly::STORE_v4f32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5575 /* v128.store */, WebAssembly::STORE_v4i32_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5575 /* v128.store */, WebAssembly::STORE_v8i16_S, Convert__Imm1_1__Imm1_0, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm }, },
  { 5586 /* v128.xor */, WebAssembly::XOR_v16i8_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5586 /* v128.xor */, WebAssembly::XOR_v2i64_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5586 /* v128.xor */, WebAssembly::XOR_v4i32_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5586 /* v128.xor */, WebAssembly::XOR_v8i16_S, Convert_NoOperands, AMFBS_HasSIMD128, {  }, },
  { 5595 /* v8x16.shuffle */, WebAssembly::SHUFFLE_S, Convert__Imm1_0__Imm1_1__Imm1_2__Imm1_3__Imm1_4__Imm1_5__Imm1_6__Imm1_7__Imm1_8__Imm1_9__Imm1_10__Imm1_11__Imm1_12__Imm1_13__Imm1_14__Imm1_15, AMFBS_HasSIMD128, { MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm, MCK_Imm }, },
};

#include "llvm/Support/Debug.h"
#include "llvm/Support/Format.h"

unsigned WebAssemblyAsmParser::
MatchInstructionImpl(const OperandVector &Operands,
                     MCInst &Inst,
                     uint64_t &ErrorInfo,
                     FeatureBitset &MissingFeatures,
                     bool matchingInlineAsm, unsigned VariantID) {
  // Eliminate obvious mismatches.
  if (Operands.size() > 17) {
    ErrorInfo = 17;
    return Match_InvalidOperand;
  }

  // Get the current feature set.
  const FeatureBitset &AvailableFeatures = getAvailableFeatures();

  // Get the instruction mnemonic, which is the first token.
  StringRef Mnemonic = ((WebAssemblyOperand&)*Operands[0]).getToken();

  // Some state to try to produce better error messages.
  bool HadMatchOtherThanFeatures = false;
  bool HadMatchOtherThanPredicate = false;
  unsigned RetCode = Match_InvalidOperand;
  MissingFeatures.set();
  // Set ErrorInfo to the operand that mismatches if it is
  // wrong for all instances of the instruction.
  ErrorInfo = ~0ULL;
  // Find the appropriate table for this asm variant.
  const MatchEntry *Start, *End;
  switch (VariantID) {
  default: llvm_unreachable("invalid variant!");
  case 0: Start = std::begin(MatchTable0); End = std::end(MatchTable0); break;
  }
  // Search the table.
  auto MnemonicRange = std::equal_range(Start, End, Mnemonic, LessOpcode());

  DEBUG_WITH_TYPE("asm-matcher", dbgs() << "AsmMatcher: found " <<
  std::distance(MnemonicRange.first, MnemonicRange.second) << 
  " encodings with mnemonic '" << Mnemonic << "'\n");

  // Return a more specific error code if no mnemonics match.
  if (MnemonicRange.first == MnemonicRange.second)
    return Match_MnemonicFail;

  for (const MatchEntry *it = MnemonicRange.first, *ie = MnemonicRange.second;
       it != ie; ++it) {
    const FeatureBitset &RequiredFeatures = FeatureBitsets[it->RequiredFeaturesIdx];
    bool HasRequiredFeatures =
      (AvailableFeatures & RequiredFeatures) == RequiredFeatures;
    DEBUG_WITH_TYPE("asm-matcher", dbgs() << "Trying to match opcode "
                                          << MII.getName(it->Opcode) << "\n");
    // equal_range guarantees that instruction mnemonic matches.
    assert(Mnemonic == it->getMnemonic());
    bool OperandsValid = true;
    for (unsigned FormalIdx = 0, ActualIdx = 1; FormalIdx != 16; ++FormalIdx) {
      auto Formal = static_cast<MatchClassKind>(it->Classes[FormalIdx]);
      DEBUG_WITH_TYPE("asm-matcher",
                      dbgs() << "  Matching formal operand class " << getMatchClassName(Formal)
                             << " against actual operand at index " << ActualIdx);
      if (ActualIdx < Operands.size())
        DEBUG_WITH_TYPE("asm-matcher", dbgs() << " (";
                        Operands[ActualIdx]->print(dbgs()); dbgs() << "): ");
      else
        DEBUG_WITH_TYPE("asm-matcher", dbgs() << ": ");
      if (ActualIdx >= Operands.size()) {
        DEBUG_WITH_TYPE("asm-matcher", dbgs() << "actual operand index out of range ");
        OperandsValid = (Formal == InvalidMatchClass) || isSubclass(Formal, OptionalMatchClass);
        if (!OperandsValid) ErrorInfo = ActualIdx;
        break;
      }
      MCParsedAsmOperand &Actual = *Operands[ActualIdx];
      unsigned Diag = validateOperandClass(Actual, Formal);
      if (Diag == Match_Success) {
        DEBUG_WITH_TYPE("asm-matcher",
                        dbgs() << "match success using generic matcher\n");
        ++ActualIdx;
        continue;
      }
      // If the generic handler indicates an invalid operand
      // failure, check for a special case.
      if (Diag != Match_Success) {
        unsigned TargetDiag = validateTargetOperandClass(Actual, Formal);
        if (TargetDiag == Match_Success) {
          DEBUG_WITH_TYPE("asm-matcher",
                          dbgs() << "match success using target matcher\n");
          ++ActualIdx;
          continue;
        }
        // If the target matcher returned a specific error code use
        // that, else use the one from the generic matcher.
        if (TargetDiag != Match_InvalidOperand && HasRequiredFeatures)
          Diag = TargetDiag;
      }
      // If current formal operand wasn't matched and it is optional
      // then try to match next formal operand
      if (Diag == Match_InvalidOperand && isSubclass(Formal, OptionalMatchClass)) {
        DEBUG_WITH_TYPE("asm-matcher", dbgs() << "ignoring optional operand\n");
        continue;
      }
      // If this operand is broken for all of the instances of this
      // mnemonic, keep track of it so we can report loc info.
      // If we already had a match that only failed due to a
      // target predicate, that diagnostic is preferred.
      if (!HadMatchOtherThanPredicate &&
          (it == MnemonicRange.first || ErrorInfo <= ActualIdx)) {
        if (HasRequiredFeatures && (ErrorInfo != ActualIdx || Diag != Match_InvalidOperand))
          RetCode = Diag;
        ErrorInfo = ActualIdx;
      }
      // Otherwise, just reject this instance of the mnemonic.
      OperandsValid = false;
      break;
    }

    if (!OperandsValid) {
      DEBUG_WITH_TYPE("asm-matcher", dbgs() << "Opcode result: multiple "
                                               "operand mismatches, ignoring "
                                               "this opcode\n");
      continue;
    }
    if (!HasRequiredFeatures) {
      HadMatchOtherThanFeatures = true;
      FeatureBitset NewMissingFeatures = RequiredFeatures & ~AvailableFeatures;
      DEBUG_WITH_TYPE("asm-matcher", dbgs() << "Missing target features:";
                       for (unsigned I = 0, E = NewMissingFeatures.size(); I != E; ++I)
                         if (NewMissingFeatures[I])
                           dbgs() << ' ' << I;
                       dbgs() << "\n");
      if (NewMissingFeatures.count() <=
          MissingFeatures.count())
        MissingFeatures = NewMissingFeatures;
      continue;
    }

    Inst.clear();

    Inst.setOpcode(it->Opcode);
    // We have a potential match but have not rendered the operands.
    // Check the target predicate to handle any context sensitive
    // constraints.
    // For example, Ties that are referenced multiple times must be
    // checked here to ensure the input is the same for each match
    // constraints. If we leave it any later the ties will have been
    // canonicalized
    unsigned MatchResult;
    if ((MatchResult = checkEarlyTargetMatchPredicate(Inst, Operands)) != Match_Success) {
      Inst.clear();
      DEBUG_WITH_TYPE(
          "asm-matcher",
          dbgs() << "Early target match predicate failed with diag code "
                 << MatchResult << "\n");
      RetCode = MatchResult;
      HadMatchOtherThanPredicate = true;
      continue;
    }

    if (matchingInlineAsm) {
      convertToMapAndConstraints(it->ConvertFn, Operands);
      if (!checkAsmTiedOperandConstraints(*this, it->ConvertFn, Operands, ErrorInfo))
        return Match_InvalidTiedOperand;

      return Match_Success;
    }

    // We have selected a definite instruction, convert the parsed
    // operands into the appropriate MCInst.
    convertToMCInst(it->ConvertFn, Inst, it->Opcode, Operands);

    // We have a potential match. Check the target predicate to
    // handle any context sensitive constraints.
    if ((MatchResult = checkTargetMatchPredicate(Inst)) != Match_Success) {
      DEBUG_WITH_TYPE("asm-matcher",
                      dbgs() << "Target match predicate failed with diag code "
                             << MatchResult << "\n");
      Inst.clear();
      RetCode = MatchResult;
      HadMatchOtherThanPredicate = true;
      continue;
    }

    if (!checkAsmTiedOperandConstraints(*this, it->ConvertFn, Operands, ErrorInfo))
      return Match_InvalidTiedOperand;

    DEBUG_WITH_TYPE(
        "asm-matcher",
        dbgs() << "Opcode result: complete match, selecting this opcode\n");
    return Match_Success;
  }

  // Okay, we had no match.  Try to return a useful error code.
  if (HadMatchOtherThanPredicate || !HadMatchOtherThanFeatures)
    return RetCode;

  ErrorInfo = 0;
  return Match_MissingFeature;
}

#endif // GET_MATCHER_IMPLEMENTATION


#ifdef GET_MNEMONIC_SPELL_CHECKER
#undef GET_MNEMONIC_SPELL_CHECKER

static std::string WebAssemblyMnemonicSpellCheck(StringRef S, const FeatureBitset &FBS, unsigned VariantID) {
  const unsigned MaxEditDist = 2;
  std::vector<StringRef> Candidates;
  StringRef Prev = "";

  // Find the appropriate table for this asm variant.
  const MatchEntry *Start, *End;
  switch (VariantID) {
  default: llvm_unreachable("invalid variant!");
  case 0: Start = std::begin(MatchTable0); End = std::end(MatchTable0); break;
  }

  for (auto I = Start; I < End; I++) {
    // Ignore unsupported instructions.
    const FeatureBitset &RequiredFeatures = FeatureBitsets[I->RequiredFeaturesIdx];
    if ((FBS & RequiredFeatures) != RequiredFeatures)
      continue;

    StringRef T = I->getMnemonic();
    // Avoid recomputing the edit distance for the same string.
    if (T.equals(Prev))
      continue;

    Prev = T;
    unsigned Dist = S.edit_distance(T, false, MaxEditDist);
    if (Dist <= MaxEditDist)
      Candidates.push_back(T);
  }

  if (Candidates.empty())
    return "";

  std::string Res = ", did you mean: ";
  unsigned i = 0;
  for( ; i < Candidates.size() - 1; i++)
    Res += Candidates[i].str() + ", ";
  return Res + Candidates[i].str() + "?";
}

#endif // GET_MNEMONIC_SPELL_CHECKER

