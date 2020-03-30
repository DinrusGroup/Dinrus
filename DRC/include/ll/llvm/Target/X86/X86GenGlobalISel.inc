/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Global Instruction Selector for the X86 target                             *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

#ifdef GET_GLOBALISEL_PREDICATE_BITSET
const unsigned MAX_SUBTARGET_PREDICATES = 114;
using PredicateBitset = llvm::PredicateBitsetImpl<MAX_SUBTARGET_PREDICATES>;
#endif // ifdef GET_GLOBALISEL_PREDICATE_BITSET

#ifdef GET_GLOBALISEL_TEMPORARIES_DECL
  mutable MatcherState State;
  typedef ComplexRendererFns(X86InstructionSelector::*ComplexMatcherMemFn)(MachineOperand &) const;
  typedef void(X86InstructionSelector::*CustomRendererFn)(MachineInstrBuilder &, const MachineInstr&) const;
  const ISelInfoTy<PredicateBitset, ComplexMatcherMemFn, CustomRendererFn> ISelInfo;
  static X86InstructionSelector::ComplexMatcherMemFn ComplexPredicateFns[];
  static X86InstructionSelector::CustomRendererFn CustomRenderers[];
  bool testImmPredicate_I64(unsigned PredicateID, int64_t Imm) const override;
  bool testImmPredicate_APInt(unsigned PredicateID, const APInt &Imm) const override;
  bool testImmPredicate_APFloat(unsigned PredicateID, const APFloat &Imm) const override;
  const int64_t *getMatchTable() const override;
  bool testMIPredicate_MI(unsigned PredicateID, const MachineInstr &MI) const override;
#endif // ifdef GET_GLOBALISEL_TEMPORARIES_DECL

#ifdef GET_GLOBALISEL_TEMPORARIES_INIT
, State(0),
ISelInfo(TypeObjects, NumTypeObjects, FeatureBitsets, ComplexPredicateFns, CustomRenderers)
#endif // ifdef GET_GLOBALISEL_TEMPORARIES_INIT

#ifdef GET_GLOBALISEL_IMPL
// Bits for subtarget features that participate in instruction matching.
enum SubtargetFeatureBits : uint8_t {
  Feature_TruePredicateBit = 49,
  Feature_HasCMovBit = 20,
  Feature_NoCMovBit = 102,
  Feature_HasMMXBit = 83,
  Feature_Has3DNowBit = 85,
  Feature_HasSSE1Bit = 35,
  Feature_UseSSE1Bit = 43,
  Feature_HasSSE2Bit = 36,
  Feature_UseSSE2Bit = 44,
  Feature_HasSSE3Bit = 27,
  Feature_UseSSE3Bit = 52,
  Feature_HasSSSE3Bit = 84,
  Feature_UseSSSE3Bit = 53,
  Feature_UseSSE41Bit = 50,
  Feature_HasSSE42Bit = 57,
  Feature_UseSSE42Bit = 56,
  Feature_HasSSE4ABit = 66,
  Feature_NoAVXBit = 62,
  Feature_HasAVXBit = 45,
  Feature_HasAVX2Bit = 39,
  Feature_HasAVX1OnlyBit = 37,
  Feature_HasAVX512Bit = 69,
  Feature_UseAVXBit = 41,
  Feature_NoAVX512Bit = 32,
  Feature_HasCDIBit = 73,
  Feature_HasVPOPCNTDQBit = 77,
  Feature_HasERIBit = 76,
  Feature_HasDQIBit = 71,
  Feature_NoDQIBit = 54,
  Feature_HasBWIBit = 72,
  Feature_NoBWIBit = 51,
  Feature_HasVLXBit = 70,
  Feature_NoVLXBit = 31,
  Feature_NoVLX_Or_NoBWIBit = 48,
  Feature_HasVNNIBit = 79,
  Feature_HasVP2INTERSECTBit = 81,
  Feature_HasBF16Bit = 82,
  Feature_HasBITALGBit = 80,
  Feature_HasPOPCNTBit = 55,
  Feature_HasAESBit = 59,
  Feature_HasVAESBit = 61,
  Feature_NoVLX_Or_NoVAESBit = 60,
  Feature_HasFXSRBit = 28,
  Feature_HasXSAVEBit = 91,
  Feature_HasXSAVEOPTBit = 92,
  Feature_HasXSAVECBit = 93,
  Feature_HasXSAVESBit = 94,
  Feature_HasPCLMULBit = 63,
  Feature_NoVLX_Or_NoVPCLMULQDQBit = 64,
  Feature_HasVPCLMULQDQBit = 65,
  Feature_HasGFNIBit = 68,
  Feature_HasFMABit = 29,
  Feature_HasFMA4Bit = 33,
  Feature_NoFMA4Bit = 30,
  Feature_HasXOPBit = 34,
  Feature_HasTBMBit = 9,
  Feature_NoTBMBit = 106,
  Feature_HasLWPBit = 10,
  Feature_HasMOVBEBit = 3,
  Feature_HasRDRANDBit = 4,
  Feature_HasF16CBit = 67,
  Feature_HasFSGSBaseBit = 95,
  Feature_HasLZCNTBit = 6,
  Feature_HasBMIBit = 7,
  Feature_HasBMI2Bit = 8,
  Feature_NoBMI2Bit = 105,
  Feature_HasVBMIBit = 74,
  Feature_HasVBMI2Bit = 78,
  Feature_HasIFMABit = 75,
  Feature_HasRTMBit = 89,
  Feature_HasSHABit = 58,
  Feature_HasRDSEEDBit = 5,
  Feature_HasSSEPrefetchBit = 46,
  Feature_NoSSEPrefetchBit = 86,
  Feature_HasPrefetchWBit = 87,
  Feature_HasPREFETCHWT1Bit = 88,
  Feature_HasLAHFSAHFBit = 2,
  Feature_HasMWAITXBit = 11,
  Feature_HasCLDEMOTEBit = 18,
  Feature_HasMOVDIRIBit = 13,
  Feature_HasMOVDIR64BBit = 14,
  Feature_HasPTWRITEBit = 98,
  Feature_FPStackf32Bit = 25,
  Feature_FPStackf64Bit = 26,
  Feature_HasCLFLUSHOPTBit = 16,
  Feature_HasCLWBBit = 17,
  Feature_HasWBNOINVDBit = 90,
  Feature_HasRDPIDBit = 97,
  Feature_HasWAITPKGBit = 12,
  Feature_HasINVPCIDBit = 96,
  Feature_HasCmpxchg8bBit = 103,
  Feature_HasCmpxchg16bBit = 104,
  Feature_HasENQCMDBit = 15,
  Feature_Not64BitModeBit = 0,
  Feature_In64BitModeBit = 1,
  Feature_IsLP64Bit = 100,
  Feature_NotLP64Bit = 99,
  Feature_NotWin64WithoutFPBit = 101,
  Feature_IsPS4Bit = 109,
  Feature_NotPS4Bit = 108,
  Feature_KernelCodeBit = 110,
  Feature_NearDataBit = 112,
  Feature_IsNotPICBit = 111,
  Feature_OptForSizeBit = 40,
  Feature_OptForMinSizeBit = 38,
  Feature_OptForSpeedBit = 107,
  Feature_UseIncDecBit = 19,
  Feature_NoSSE41_Or_OptForSizeBit = 42,
  Feature_CallImmAddrBit = 113,
  Feature_FavorMemIndirectCallBit = 21,
  Feature_HasFastSHLDRotateBit = 24,
  Feature_HasMFenceBit = 47,
  Feature_UseRetpolineIndirectCallsBit = 23,
  Feature_NotUseRetpolineIndirectCallsBit = 22,
};

PredicateBitset X86InstructionSelector::
computeAvailableModuleFeatures(const X86Subtarget *Subtarget) const {
  PredicateBitset Features;
  if (true)
    Features[Feature_TruePredicateBit] = 1;
  if (Subtarget->hasCMov())
    Features[Feature_HasCMovBit] = 1;
  if (!Subtarget->hasCMov())
    Features[Feature_NoCMovBit] = 1;
  if (Subtarget->hasMMX())
    Features[Feature_HasMMXBit] = 1;
  if (Subtarget->has3DNow())
    Features[Feature_Has3DNowBit] = 1;
  if (Subtarget->hasSSE1())
    Features[Feature_HasSSE1Bit] = 1;
  if (Subtarget->hasSSE1() && !Subtarget->hasAVX())
    Features[Feature_UseSSE1Bit] = 1;
  if (Subtarget->hasSSE2())
    Features[Feature_HasSSE2Bit] = 1;
  if (Subtarget->hasSSE2() && !Subtarget->hasAVX())
    Features[Feature_UseSSE2Bit] = 1;
  if (Subtarget->hasSSE3())
    Features[Feature_HasSSE3Bit] = 1;
  if (Subtarget->hasSSE3() && !Subtarget->hasAVX())
    Features[Feature_UseSSE3Bit] = 1;
  if (Subtarget->hasSSSE3())
    Features[Feature_HasSSSE3Bit] = 1;
  if (Subtarget->hasSSSE3() && !Subtarget->hasAVX())
    Features[Feature_UseSSSE3Bit] = 1;
  if (Subtarget->hasSSE41() && !Subtarget->hasAVX())
    Features[Feature_UseSSE41Bit] = 1;
  if (Subtarget->hasSSE42())
    Features[Feature_HasSSE42Bit] = 1;
  if (Subtarget->hasSSE42() && !Subtarget->hasAVX())
    Features[Feature_UseSSE42Bit] = 1;
  if (Subtarget->hasSSE4A())
    Features[Feature_HasSSE4ABit] = 1;
  if (!Subtarget->hasAVX())
    Features[Feature_NoAVXBit] = 1;
  if (Subtarget->hasAVX())
    Features[Feature_HasAVXBit] = 1;
  if (Subtarget->hasAVX2())
    Features[Feature_HasAVX2Bit] = 1;
  if (Subtarget->hasAVX() && !Subtarget->hasAVX2())
    Features[Feature_HasAVX1OnlyBit] = 1;
  if (Subtarget->hasAVX512())
    Features[Feature_HasAVX512Bit] = 1;
  if (Subtarget->hasAVX() && !Subtarget->hasAVX512())
    Features[Feature_UseAVXBit] = 1;
  if (!Subtarget->hasAVX512())
    Features[Feature_NoAVX512Bit] = 1;
  if (Subtarget->hasCDI())
    Features[Feature_HasCDIBit] = 1;
  if (Subtarget->hasVPOPCNTDQ())
    Features[Feature_HasVPOPCNTDQBit] = 1;
  if (Subtarget->hasERI())
    Features[Feature_HasERIBit] = 1;
  if (Subtarget->hasDQI())
    Features[Feature_HasDQIBit] = 1;
  if (!Subtarget->hasDQI())
    Features[Feature_NoDQIBit] = 1;
  if (Subtarget->hasBWI())
    Features[Feature_HasBWIBit] = 1;
  if (!Subtarget->hasBWI())
    Features[Feature_NoBWIBit] = 1;
  if (Subtarget->hasVLX())
    Features[Feature_HasVLXBit] = 1;
  if (!Subtarget->hasVLX())
    Features[Feature_NoVLXBit] = 1;
  if (!Subtarget->hasVLX() || !Subtarget->hasBWI())
    Features[Feature_NoVLX_Or_NoBWIBit] = 1;
  if (Subtarget->hasVNNI())
    Features[Feature_HasVNNIBit] = 1;
  if (Subtarget->hasVP2INTERSECT())
    Features[Feature_HasVP2INTERSECTBit] = 1;
  if (Subtarget->hasBF16())
    Features[Feature_HasBF16Bit] = 1;
  if (Subtarget->hasBITALG())
    Features[Feature_HasBITALGBit] = 1;
  if (Subtarget->hasPOPCNT())
    Features[Feature_HasPOPCNTBit] = 1;
  if (Subtarget->hasAES())
    Features[Feature_HasAESBit] = 1;
  if (Subtarget->hasVAES())
    Features[Feature_HasVAESBit] = 1;
  if (!Subtarget->hasVLX() || !Subtarget->hasVAES())
    Features[Feature_NoVLX_Or_NoVAESBit] = 1;
  if (Subtarget->hasFXSR())
    Features[Feature_HasFXSRBit] = 1;
  if (Subtarget->hasXSAVE())
    Features[Feature_HasXSAVEBit] = 1;
  if (Subtarget->hasXSAVEOPT())
    Features[Feature_HasXSAVEOPTBit] = 1;
  if (Subtarget->hasXSAVEC())
    Features[Feature_HasXSAVECBit] = 1;
  if (Subtarget->hasXSAVES())
    Features[Feature_HasXSAVESBit] = 1;
  if (Subtarget->hasPCLMUL())
    Features[Feature_HasPCLMULBit] = 1;
  if (!Subtarget->hasVLX() || !Subtarget->hasVPCLMULQDQ())
    Features[Feature_NoVLX_Or_NoVPCLMULQDQBit] = 1;
  if (Subtarget->hasVPCLMULQDQ())
    Features[Feature_HasVPCLMULQDQBit] = 1;
  if (Subtarget->hasGFNI())
    Features[Feature_HasGFNIBit] = 1;
  if (Subtarget->hasFMA())
    Features[Feature_HasFMABit] = 1;
  if (Subtarget->hasFMA4())
    Features[Feature_HasFMA4Bit] = 1;
  if (!Subtarget->hasFMA4())
    Features[Feature_NoFMA4Bit] = 1;
  if (Subtarget->hasXOP())
    Features[Feature_HasXOPBit] = 1;
  if (Subtarget->hasTBM())
    Features[Feature_HasTBMBit] = 1;
  if (!Subtarget->hasTBM())
    Features[Feature_NoTBMBit] = 1;
  if (Subtarget->hasLWP())
    Features[Feature_HasLWPBit] = 1;
  if (Subtarget->hasMOVBE())
    Features[Feature_HasMOVBEBit] = 1;
  if (Subtarget->hasRDRAND())
    Features[Feature_HasRDRANDBit] = 1;
  if (Subtarget->hasF16C())
    Features[Feature_HasF16CBit] = 1;
  if (Subtarget->hasFSGSBase())
    Features[Feature_HasFSGSBaseBit] = 1;
  if (Subtarget->hasLZCNT())
    Features[Feature_HasLZCNTBit] = 1;
  if (Subtarget->hasBMI())
    Features[Feature_HasBMIBit] = 1;
  if (Subtarget->hasBMI2())
    Features[Feature_HasBMI2Bit] = 1;
  if (!Subtarget->hasBMI2())
    Features[Feature_NoBMI2Bit] = 1;
  if (Subtarget->hasVBMI())
    Features[Feature_HasVBMIBit] = 1;
  if (Subtarget->hasVBMI2())
    Features[Feature_HasVBMI2Bit] = 1;
  if (Subtarget->hasIFMA())
    Features[Feature_HasIFMABit] = 1;
  if (Subtarget->hasRTM())
    Features[Feature_HasRTMBit] = 1;
  if (Subtarget->hasSHA())
    Features[Feature_HasSHABit] = 1;
  if (Subtarget->hasRDSEED())
    Features[Feature_HasRDSEEDBit] = 1;
  if (Subtarget->hasSSEPrefetch())
    Features[Feature_HasSSEPrefetchBit] = 1;
  if (!Subtarget->hasSSEPrefetch())
    Features[Feature_NoSSEPrefetchBit] = 1;
  if (Subtarget->hasPRFCHW())
    Features[Feature_HasPrefetchWBit] = 1;
  if (Subtarget->hasPREFETCHWT1())
    Features[Feature_HasPREFETCHWT1Bit] = 1;
  if (Subtarget->hasLAHFSAHF())
    Features[Feature_HasLAHFSAHFBit] = 1;
  if (Subtarget->hasMWAITX())
    Features[Feature_HasMWAITXBit] = 1;
  if (Subtarget->hasCLDEMOTE())
    Features[Feature_HasCLDEMOTEBit] = 1;
  if (Subtarget->hasMOVDIRI())
    Features[Feature_HasMOVDIRIBit] = 1;
  if (Subtarget->hasMOVDIR64B())
    Features[Feature_HasMOVDIR64BBit] = 1;
  if (Subtarget->hasPTWRITE())
    Features[Feature_HasPTWRITEBit] = 1;
  if (!Subtarget->hasSSE1())
    Features[Feature_FPStackf32Bit] = 1;
  if (!Subtarget->hasSSE2())
    Features[Feature_FPStackf64Bit] = 1;
  if (Subtarget->hasCLFLUSHOPT())
    Features[Feature_HasCLFLUSHOPTBit] = 1;
  if (Subtarget->hasCLWB())
    Features[Feature_HasCLWBBit] = 1;
  if (Subtarget->hasWBNOINVD())
    Features[Feature_HasWBNOINVDBit] = 1;
  if (Subtarget->hasRDPID())
    Features[Feature_HasRDPIDBit] = 1;
  if (Subtarget->hasWAITPKG())
    Features[Feature_HasWAITPKGBit] = 1;
  if (Subtarget->hasINVPCID())
    Features[Feature_HasINVPCIDBit] = 1;
  if (Subtarget->hasCmpxchg8b())
    Features[Feature_HasCmpxchg8bBit] = 1;
  if (Subtarget->hasCmpxchg16b())
    Features[Feature_HasCmpxchg16bBit] = 1;
  if (Subtarget->hasENQCMD())
    Features[Feature_HasENQCMDBit] = 1;
  if (!Subtarget->is64Bit())
    Features[Feature_Not64BitModeBit] = 1;
  if (Subtarget->is64Bit())
    Features[Feature_In64BitModeBit] = 1;
  if (Subtarget->isTarget64BitLP64())
    Features[Feature_IsLP64Bit] = 1;
  if (!Subtarget->isTarget64BitLP64())
    Features[Feature_NotLP64Bit] = 1;
  if (Subtarget->isTargetPS4())
    Features[Feature_IsPS4Bit] = 1;
  if (!Subtarget->isTargetPS4())
    Features[Feature_NotPS4Bit] = 1;
  if (TM.getCodeModel() == CodeModel::Kernel)
    Features[Feature_KernelCodeBit] = 1;
  if (TM.getCodeModel() == CodeModel::Small ||TM.getCodeModel() == CodeModel::Kernel)
    Features[Feature_NearDataBit] = 1;
  if (!TM.isPositionIndependent())
    Features[Feature_IsNotPICBit] = 1;
  if (Subtarget->isLegalToCallImmediateAddr())
    Features[Feature_CallImmAddrBit] = 1;
  if (!Subtarget->slowTwoMemOps())
    Features[Feature_FavorMemIndirectCallBit] = 1;
  if (Subtarget->hasFastSHLDRotate())
    Features[Feature_HasFastSHLDRotateBit] = 1;
  if (Subtarget->hasMFence())
    Features[Feature_HasMFenceBit] = 1;
  if (Subtarget->useRetpolineIndirectCalls())
    Features[Feature_UseRetpolineIndirectCallsBit] = 1;
  if (!Subtarget->useRetpolineIndirectCalls())
    Features[Feature_NotUseRetpolineIndirectCallsBit] = 1;
  return Features;
}

PredicateBitset X86InstructionSelector::
computeAvailableFunctionFeatures(const X86Subtarget *Subtarget, const MachineFunction *MF) const {
  PredicateBitset Features;
  if (!Subtarget->isTargetWin64() ||Subtarget->getFrameLowering()->hasFP(*MF))
    Features[Feature_NotWin64WithoutFPBit] = 1;
  if (MF->getFunction().hasOptSize())
    Features[Feature_OptForSizeBit] = 1;
  if (MF->getFunction().hasMinSize())
    Features[Feature_OptForMinSizeBit] = 1;
  if (!MF->getFunction().hasOptSize())
    Features[Feature_OptForSpeedBit] = 1;
  if (!Subtarget->slowIncDec() || MF->getFunction().hasOptSize())
    Features[Feature_UseIncDecBit] = 1;
  if (MF->getFunction().hasOptSize() || !Subtarget->hasSSE41())
    Features[Feature_NoSSE41_Or_OptForSizeBit] = 1;
  return Features;
}

// LLT Objects.
enum {
  GILLT_s1,
  GILLT_s8,
  GILLT_s16,
  GILLT_s32,
  GILLT_s64,
  GILLT_s80,
  GILLT_s128,
  GILLT_v2s1,
  GILLT_v2s64,
  GILLT_v4s1,
  GILLT_v4s32,
  GILLT_v4s64,
  GILLT_v8s1,
  GILLT_v8s16,
  GILLT_v8s32,
  GILLT_v8s64,
  GILLT_v16s1,
  GILLT_v16s8,
  GILLT_v16s16,
  GILLT_v16s32,
  GILLT_v32s1,
  GILLT_v32s8,
  GILLT_v32s16,
  GILLT_v64s1,
  GILLT_v64s8,
};
const static size_t NumTypeObjects = 25;
const static LLT TypeObjects[] = {
  LLT::scalar(1),
  LLT::scalar(8),
  LLT::scalar(16),
  LLT::scalar(32),
  LLT::scalar(64),
  LLT::scalar(80),
  LLT::scalar(128),
  LLT::vector(2, 1),
  LLT::vector(2, 64),
  LLT::vector(4, 1),
  LLT::vector(4, 32),
  LLT::vector(4, 64),
  LLT::vector(8, 1),
  LLT::vector(8, 16),
  LLT::vector(8, 32),
  LLT::vector(8, 64),
  LLT::vector(16, 1),
  LLT::vector(16, 8),
  LLT::vector(16, 16),
  LLT::vector(16, 32),
  LLT::vector(32, 1),
  LLT::vector(32, 8),
  LLT::vector(32, 16),
  LLT::vector(64, 1),
  LLT::vector(64, 8),
};

// Feature bitsets.
enum {
  GIFBS_Invalid,
  GIFBS_FPStackf32,
  GIFBS_FPStackf64,
  GIFBS_Has3DNow,
  GIFBS_HasAVX,
  GIFBS_HasAVX1Only,
  GIFBS_HasAVX2,
  GIFBS_HasAVX512,
  GIFBS_HasBITALG,
  GIFBS_HasBMI,
  GIFBS_HasBMI2,
  GIFBS_HasBWI,
  GIFBS_HasCDI,
  GIFBS_HasDQI,
  GIFBS_HasLWP,
  GIFBS_HasMFence,
  GIFBS_HasMMX,
  GIFBS_HasMOVBE,
  GIFBS_HasPTWRITE,
  GIFBS_HasRTM,
  GIFBS_HasSHA,
  GIFBS_HasSSE1,
  GIFBS_HasSSE2,
  GIFBS_HasSSE42,
  GIFBS_HasSSE4A,
  GIFBS_HasTBM,
  GIFBS_HasVLX,
  GIFBS_HasVPOPCNTDQ,
  GIFBS_HasWAITPKG,
  GIFBS_HasWBNOINVD,
  GIFBS_HasXOP,
  GIFBS_In64BitMode,
  GIFBS_NoDQI,
  GIFBS_Not64BitMode,
  GIFBS_UseAVX,
  GIFBS_UseIncDec,
  GIFBS_UseSSE1,
  GIFBS_UseSSE2,
  GIFBS_UseSSE41,
  GIFBS_UseSSSE3,
  GIFBS_HasAES_HasAVX,
  GIFBS_HasAES_NoAVX,
  GIFBS_HasAVX_NoVLX,
  GIFBS_HasAVX_NoVLX_Or_NoBWI,
  GIFBS_HasAVX2_NoVLX,
  GIFBS_HasAVX2_NoVLX_Or_NoBWI,
  GIFBS_HasAVX512_HasVAES,
  GIFBS_HasAVX512_HasVLX,
  GIFBS_HasAVX512_HasVPCLMULQDQ,
  GIFBS_HasAVX512_NoBWI,
  GIFBS_HasBITALG_HasVLX,
  GIFBS_HasBWI_HasVLX,
  GIFBS_HasCDI_HasVLX,
  GIFBS_HasDQI_HasVLX,
  GIFBS_HasDQI_NoBWI,
  GIFBS_HasFSGSBase_In64BitMode,
  GIFBS_HasPCLMUL_NoAVX,
  GIFBS_HasPTWRITE_In64BitMode,
  GIFBS_HasRDPID_Not64BitMode,
  GIFBS_HasSSE2_NoAVX512,
  GIFBS_HasVAES_HasVLX,
  GIFBS_HasVAES_NoVLX,
  GIFBS_HasVLX_HasVPCLMULQDQ,
  GIFBS_HasVLX_HasVPOPCNTDQ,
  GIFBS_HasVPCLMULQDQ_NoVLX,
  GIFBS_HasWAITPKG_In64BitMode,
  GIFBS_HasWAITPKG_Not64BitMode,
  GIFBS_Not64BitMode_OptForSize,
  GIFBS_NotWin64WithoutFP_OptForMinSize,
  GIFBS_HasAES_HasAVX_NoVLX_Or_NoVAES,
  GIFBS_HasAVX_HasPCLMUL_NoVLX_Or_NoVPCLMULQDQ,
  GIFBS_HasDQI_HasVLX_NoBWI,
};
const static PredicateBitset FeatureBitsets[] {
  {}, // GIFBS_Invalid
  {Feature_FPStackf32Bit, },
  {Feature_FPStackf64Bit, },
  {Feature_Has3DNowBit, },
  {Feature_HasAVXBit, },
  {Feature_HasAVX1OnlyBit, },
  {Feature_HasAVX2Bit, },
  {Feature_HasAVX512Bit, },
  {Feature_HasBITALGBit, },
  {Feature_HasBMIBit, },
  {Feature_HasBMI2Bit, },
  {Feature_HasBWIBit, },
  {Feature_HasCDIBit, },
  {Feature_HasDQIBit, },
  {Feature_HasLWPBit, },
  {Feature_HasMFenceBit, },
  {Feature_HasMMXBit, },
  {Feature_HasMOVBEBit, },
  {Feature_HasPTWRITEBit, },
  {Feature_HasRTMBit, },
  {Feature_HasSHABit, },
  {Feature_HasSSE1Bit, },
  {Feature_HasSSE2Bit, },
  {Feature_HasSSE42Bit, },
  {Feature_HasSSE4ABit, },
  {Feature_HasTBMBit, },
  {Feature_HasVLXBit, },
  {Feature_HasVPOPCNTDQBit, },
  {Feature_HasWAITPKGBit, },
  {Feature_HasWBNOINVDBit, },
  {Feature_HasXOPBit, },
  {Feature_In64BitModeBit, },
  {Feature_NoDQIBit, },
  {Feature_Not64BitModeBit, },
  {Feature_UseAVXBit, },
  {Feature_UseIncDecBit, },
  {Feature_UseSSE1Bit, },
  {Feature_UseSSE2Bit, },
  {Feature_UseSSE41Bit, },
  {Feature_UseSSSE3Bit, },
  {Feature_HasAESBit, Feature_HasAVXBit, },
  {Feature_HasAESBit, Feature_NoAVXBit, },
  {Feature_HasAVXBit, Feature_NoVLXBit, },
  {Feature_HasAVXBit, Feature_NoVLX_Or_NoBWIBit, },
  {Feature_HasAVX2Bit, Feature_NoVLXBit, },
  {Feature_HasAVX2Bit, Feature_NoVLX_Or_NoBWIBit, },
  {Feature_HasAVX512Bit, Feature_HasVAESBit, },
  {Feature_HasAVX512Bit, Feature_HasVLXBit, },
  {Feature_HasAVX512Bit, Feature_HasVPCLMULQDQBit, },
  {Feature_HasAVX512Bit, Feature_NoBWIBit, },
  {Feature_HasBITALGBit, Feature_HasVLXBit, },
  {Feature_HasBWIBit, Feature_HasVLXBit, },
  {Feature_HasCDIBit, Feature_HasVLXBit, },
  {Feature_HasDQIBit, Feature_HasVLXBit, },
  {Feature_HasDQIBit, Feature_NoBWIBit, },
  {Feature_HasFSGSBaseBit, Feature_In64BitModeBit, },
  {Feature_HasPCLMULBit, Feature_NoAVXBit, },
  {Feature_HasPTWRITEBit, Feature_In64BitModeBit, },
  {Feature_HasRDPIDBit, Feature_Not64BitModeBit, },
  {Feature_HasSSE2Bit, Feature_NoAVX512Bit, },
  {Feature_HasVAESBit, Feature_HasVLXBit, },
  {Feature_HasVAESBit, Feature_NoVLXBit, },
  {Feature_HasVLXBit, Feature_HasVPCLMULQDQBit, },
  {Feature_HasVLXBit, Feature_HasVPOPCNTDQBit, },
  {Feature_HasVPCLMULQDQBit, Feature_NoVLXBit, },
  {Feature_HasWAITPKGBit, Feature_In64BitModeBit, },
  {Feature_HasWAITPKGBit, Feature_Not64BitModeBit, },
  {Feature_Not64BitModeBit, Feature_OptForSizeBit, },
  {Feature_NotWin64WithoutFPBit, Feature_OptForMinSizeBit, },
  {Feature_HasAESBit, Feature_HasAVXBit, Feature_NoVLX_Or_NoVAESBit, },
  {Feature_HasAVXBit, Feature_HasPCLMULBit, Feature_NoVLX_Or_NoVPCLMULQDQBit, },
  {Feature_HasDQIBit, Feature_HasVLXBit, Feature_NoBWIBit, },
};

// ComplexPattern predicates.
enum {
  GICP_Invalid,
};
// See constructor for table contents

// PatFrag predicates.
enum {
  GIPFP_I64_Predicate_AndMask64 = GIPFP_I64_Invalid + 1,
  GIPFP_I64_Predicate_BTCBTSMask64,
  GIPFP_I64_Predicate_BTRMask64,
  GIPFP_I64_Predicate_PrefetchWT1Level,
  GIPFP_I64_Predicate_i16immSExt8,
  GIPFP_I64_Predicate_i32immSExt8,
  GIPFP_I64_Predicate_i64immSExt32,
  GIPFP_I64_Predicate_i64immSExt8,
  GIPFP_I64_Predicate_i64immZExt32,
  GIPFP_I64_Predicate_i64immZExt32SExt8,
  GIPFP_I64_Predicate_immff00_ffff,
};
bool X86InstructionSelector::testImmPredicate_I64(unsigned PredicateID, int64_t Imm) const {
  switch (PredicateID) {
  case GIPFP_I64_Predicate_AndMask64: {
    
  return isMask_64(Imm) && !isUInt<32>(Imm);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_BTCBTSMask64: {
    
  return !isInt<32>(Imm) && isPowerOf2_64(Imm);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_BTRMask64: {
    
  return !isUInt<32>(Imm) && !isInt<32>(Imm) && isPowerOf2_64(~Imm);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_PrefetchWT1Level: {
    
  return Imm < 3;

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_i16immSExt8: {
     return isInt<8>(Imm); 
    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_i32immSExt8: {
     return isInt<8>(Imm); 
    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_i64immSExt32: {
     return isInt<32>(Imm); 
    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_i64immSExt8: {
     return isInt<8>(Imm); 
    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_i64immZExt32: {
     return isUInt<32>(Imm); 
    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_i64immZExt32SExt8: {
    
  return isUInt<32>(Imm) && isInt<8>(static_cast<int32_t>(Imm));

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_I64_Predicate_immff00_ffff: {
    
  return Imm >= 0xff00 && Imm <= 0xffff;

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  }
  llvm_unreachable("Unknown predicate");
  return false;
}
// PatFrag predicates.
enum {
  GIPFP_APFloat_Predicate_fpimm0 = GIPFP_APFloat_Invalid + 1,
  GIPFP_APFloat_Predicate_fpimm1,
  GIPFP_APFloat_Predicate_fpimmneg0,
  GIPFP_APFloat_Predicate_fpimmneg1,
};
bool X86InstructionSelector::testImmPredicate_APFloat(unsigned PredicateID, const APFloat & Imm) const {
  switch (PredicateID) {
  case GIPFP_APFloat_Predicate_fpimm0: {
    
  return Imm.isExactlyValue(+0.0);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_APFloat_Predicate_fpimm1: {
    
  return Imm.isExactlyValue(+1.0);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_APFloat_Predicate_fpimmneg0: {
    
  return Imm.isExactlyValue(-0.0);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  case GIPFP_APFloat_Predicate_fpimmneg1: {
    
  return Imm.isExactlyValue(-1.0);

    llvm_unreachable("ImmediateCode should have returned");
    return false;
  }
  }
  llvm_unreachable("Unknown predicate");
  return false;
}
bool X86InstructionSelector::testImmPredicate_APInt(unsigned PredicateID, const APInt & Imm) const {
  llvm_unreachable("Unknown predicate");
  return false;
}
bool X86InstructionSelector::testMIPredicate_MI(unsigned PredicateID, const MachineInstr & MI) const {
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();
  (void)MRI;
  llvm_unreachable("Unknown predicate");
  return false;
}

X86InstructionSelector::ComplexMatcherMemFn
X86InstructionSelector::ComplexPredicateFns[] = {
  nullptr, // GICP_Invalid
};

// Custom renderers.
enum {
  GICR_Invalid,
};
X86InstructionSelector::CustomRendererFn
X86InstructionSelector::CustomRenderers[] = {
  nullptr, // GICP_Invalid
};

bool X86InstructionSelector::selectImpl(MachineInstr &I, CodeGenCoverage &CoverageInfo) const {
  MachineFunction &MF = *I.getParent()->getParent();
  MachineRegisterInfo &MRI = MF.getRegInfo();
  // FIXME: This should be computed on a per-function basis rather than per-insn.
  AvailableFunctionFeatures = computeAvailableFunctionFeatures(&STI, &MF);
  const PredicateBitset AvailableFeatures = getAvailableFeatures();
  NewMIVector OutMIs;
  State.MIs.clear();
  State.MIs.push_back(&I);

  if (executeMatchTable(*this, OutMIs, State, ISelInfo, getMatchTable(), TII, MRI, TRI, RBI, AvailableFeatures, CoverageInfo)) {
    return true;
  }

  return false;
}

const int64_t *X86InstructionSelector::getMatchTable() const {
  constexpr static int64_t MatchTable0[] = {
    GIM_SwitchOpcode, /*MI*/0, /*[*/35, 158, /*)*//*default:*//*Label 45*/ 33704,
    /*TargetOpcode::G_ADD*//*Label 0*/ 128,
    /*TargetOpcode::G_SUB*//*Label 1*/ 1745,
    /*TargetOpcode::G_MUL*//*Label 2*/ 2826, 0, 0, 0, 0,
    /*TargetOpcode::G_AND*//*Label 3*/ 3592,
    /*TargetOpcode::G_OR*//*Label 4*/ 7097,
    /*TargetOpcode::G_XOR*//*Label 5*/ 10351, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    /*TargetOpcode::G_CONCAT_VECTORS*//*Label 6*/ 12907, 0, 0,
    /*TargetOpcode::G_BITCAST*//*Label 7*/ 13063, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    /*TargetOpcode::G_INTRINSIC*//*Label 8*/ 13463,
    /*TargetOpcode::G_INTRINSIC_W_SIDE_EFFECTS*//*Label 9*/ 19558,
    /*TargetOpcode::G_ANYEXT*//*Label 10*/ 20929,
    /*TargetOpcode::G_TRUNC*//*Label 11*/ 21475,
    /*TargetOpcode::G_CONSTANT*//*Label 12*/ 21858,
    /*TargetOpcode::G_FCONSTANT*//*Label 13*/ 22061, 0, 0,
    /*TargetOpcode::G_SEXT*//*Label 14*/ 22254,
    /*TargetOpcode::G_ZEXT*//*Label 15*/ 23059,
    /*TargetOpcode::G_SHL*//*Label 16*/ 23473,
    /*TargetOpcode::G_LSHR*//*Label 17*/ 23788,
    /*TargetOpcode::G_ASHR*//*Label 18*/ 24087, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    /*TargetOpcode::G_UMULH*//*Label 19*/ 24386,
    /*TargetOpcode::G_SMULH*//*Label 20*/ 24574,
    /*TargetOpcode::G_FADD*//*Label 21*/ 24762,
    /*TargetOpcode::G_FSUB*//*Label 22*/ 25384,
    /*TargetOpcode::G_FMUL*//*Label 23*/ 26006, 0,
    /*TargetOpcode::G_FDIV*//*Label 24*/ 26628, 0, 0, 0, 0, 0, 0, 0,
    /*TargetOpcode::G_FNEG*//*Label 25*/ 27250,
    /*TargetOpcode::G_FPEXT*//*Label 26*/ 27348,
    /*TargetOpcode::G_FPTRUNC*//*Label 27*/ 27624,
    /*TargetOpcode::G_FPTOSI*//*Label 28*/ 27909,
    /*TargetOpcode::G_FPTOUI*//*Label 29*/ 28226,
    /*TargetOpcode::G_SITOFP*//*Label 30*/ 28329,
    /*TargetOpcode::G_UITOFP*//*Label 31*/ 29159,
    /*TargetOpcode::G_FABS*//*Label 32*/ 29613, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    /*TargetOpcode::G_SMIN*//*Label 33*/ 29711,
    /*TargetOpcode::G_SMAX*//*Label 34*/ 30344,
    /*TargetOpcode::G_UMIN*//*Label 35*/ 30977,
    /*TargetOpcode::G_UMAX*//*Label 36*/ 31610,
    /*TargetOpcode::G_BR*//*Label 37*/ 32243, 0, 0, 0, 0, 0,
    /*TargetOpcode::G_CTTZ_ZERO_UNDEF*//*Label 38*/ 32256,
    /*TargetOpcode::G_CTLZ*//*Label 39*/ 32341, 0,
    /*TargetOpcode::G_CTPOP*//*Label 40*/ 32504,
    /*TargetOpcode::G_BSWAP*//*Label 41*/ 32816, 0,
    /*TargetOpcode::G_FCOS*//*Label 42*/ 32906,
    /*TargetOpcode::G_FSIN*//*Label 43*/ 33004,
    /*TargetOpcode::G_FSQRT*//*Label 44*/ 33102,
    // Label 0: @128
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 25, /*)*//*default:*//*Label 62*/ 1744,
    /*GILLT_s8*//*Label 46*/ 158,
    /*GILLT_s16*//*Label 47*/ 272,
    /*GILLT_s32*//*Label 48*/ 444,
    /*GILLT_s64*//*Label 49*/ 616, 0, 0, 0,
    /*GILLT_v2s64*//*Label 50*/ 816, 0,
    /*GILLT_v4s32*//*Label 51*/ 897,
    /*GILLT_v4s64*//*Label 52*/ 1100, 0,
    /*GILLT_v8s16*//*Label 53*/ 1158,
    /*GILLT_v8s32*//*Label 54*/ 1361,
    /*GILLT_v8s64*//*Label 55*/ 1419, 0,
    /*GILLT_v16s8*//*Label 56*/ 1451,
    /*GILLT_v16s16*//*Label 57*/ 1532,
    /*GILLT_v16s32*//*Label 58*/ 1590, 0,
    /*GILLT_v32s8*//*Label 59*/ 1622,
    /*GILLT_v32s16*//*Label 60*/ 1680, 0,
    /*GILLT_v64s8*//*Label 61*/ 1712,
    // Label 46: @158
    GIM_Try, /*On fail goto*//*Label 63*/ 271,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 64*/ 200, // Rule ID 16010 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (add:{ *:[i8] } GR8:{ *:[i8] }:$src, 1:{ *:[i8] })  =>  (INC8r:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INC8r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16010,
        GIR_Done,
      // Label 64: @200
      GIM_Try, /*On fail goto*//*Label 65*/ 224, // Rule ID 16014 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (add:{ *:[i8] } GR8:{ *:[i8] }:$src, -1:{ *:[i8] })  =>  (DEC8r:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::DEC8r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16014,
        GIR_Done,
      // Label 65: @224
      GIM_Try, /*On fail goto*//*Label 66*/ 254, // Rule ID 15965 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (ADD8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15965,
        GIR_Done,
      // Label 66: @254
      GIM_Try, /*On fail goto*//*Label 67*/ 270, // Rule ID 15957 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR8RegClassID,
        // (add:{ *:[i8] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)  =>  (ADD8rr:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD8rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15957,
        GIR_Done,
      // Label 67: @270
      GIM_Reject,
    // Label 63: @271
    GIM_Reject,
    // Label 47: @272
    GIM_Try, /*On fail goto*//*Label 68*/ 443,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 69*/ 315, // Rule ID 15819 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 128,
        // (add:{ *:[i16] } GR16:{ *:[i16] }:$src1, 128:{ *:[i16] })  =>  (SUB16ri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, -128:{ *:[i16] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB16ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_AddImm, /*InsnID*/0, /*Imm*/-128,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15819,
        GIR_Done,
      // Label 69: @315
      GIM_Try, /*On fail goto*//*Label 70*/ 339, // Rule ID 16011 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (add:{ *:[i16] } GR16:{ *:[i16] }:$src, 1:{ *:[i16] })  =>  (INC16r:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INC16r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16011,
        GIR_Done,
      // Label 70: @339
      GIM_Try, /*On fail goto*//*Label 71*/ 363, // Rule ID 16015 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (add:{ *:[i16] } GR16:{ *:[i16] }:$src, -1:{ *:[i16] })  =>  (DEC16r:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::DEC16r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16015,
        GIR_Done,
      // Label 71: @363
      GIM_Try, /*On fail goto*//*Label 72*/ 396, // Rule ID 15968 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i16immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)  =>  (ADD16ri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD16ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15968,
        GIR_Done,
      // Label 72: @396
      GIM_Try, /*On fail goto*//*Label 73*/ 426, // Rule ID 15966 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)  =>  (ADD16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15966,
        GIR_Done,
      // Label 73: @426
      GIM_Try, /*On fail goto*//*Label 74*/ 442, // Rule ID 15958 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR16RegClassID,
        // (add:{ *:[i16] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (ADD16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD16rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15958,
        GIR_Done,
      // Label 74: @442
      GIM_Reject,
    // Label 68: @443
    GIM_Reject,
    // Label 48: @444
    GIM_Try, /*On fail goto*//*Label 75*/ 615,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      GIM_Try, /*On fail goto*//*Label 76*/ 487, // Rule ID 15821 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 128,
        // (add:{ *:[i32] } GR32:{ *:[i32] }:$src1, 128:{ *:[i32] })  =>  (SUB32ri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, -128:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB32ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_AddImm, /*InsnID*/0, /*Imm*/-128,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15821,
        GIR_Done,
      // Label 76: @487
      GIM_Try, /*On fail goto*//*Label 77*/ 511, // Rule ID 16012 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] })  =>  (INC32r:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INC32r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16012,
        GIR_Done,
      // Label 77: @511
      GIM_Try, /*On fail goto*//*Label 78*/ 535, // Rule ID 16016 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] })  =>  (DEC32r:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::DEC32r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16016,
        GIR_Done,
      // Label 78: @535
      GIM_Try, /*On fail goto*//*Label 79*/ 568, // Rule ID 15969 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)  =>  (ADD32ri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD32ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15969,
        GIR_Done,
      // Label 79: @568
      GIM_Try, /*On fail goto*//*Label 80*/ 598, // Rule ID 15967 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)  =>  (ADD32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15967,
        GIR_Done,
      // Label 80: @598
      GIM_Try, /*On fail goto*//*Label 81*/ 614, // Rule ID 15959 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (add:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (ADD32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD32rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15959,
        GIR_Done,
      // Label 81: @614
      GIM_Reject,
    // Label 75: @615
    GIM_Reject,
    // Label 49: @616
    GIM_Try, /*On fail goto*//*Label 82*/ 815,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      GIM_Try, /*On fail goto*//*Label 83*/ 659, // Rule ID 15823 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 128,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src1, 128:{ *:[i64] })  =>  (SUB64ri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, -128:{ *:[i64] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB64ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_AddImm, /*InsnID*/0, /*Imm*/-128,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15823,
        GIR_Done,
      // Label 83: @659
      GIM_Try, /*On fail goto*//*Label 84*/ 684, // Rule ID 15828 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 2147483648,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src1, 2147483648:{ *:[i64] })  =>  (SUB64ri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, -2147483648:{ *:[i64] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB64ri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_AddImm, /*InsnID*/0, /*Imm*/-2147483648,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15828,
        GIR_Done,
      // Label 84: @684
      GIM_Try, /*On fail goto*//*Label 85*/ 708, // Rule ID 16013 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] })  =>  (INC64r:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INC64r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16013,
        GIR_Done,
      // Label 85: @708
      GIM_Try, /*On fail goto*//*Label 86*/ 732, // Rule ID 16017 //
        GIM_CheckFeatures, GIFBS_UseIncDec,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] })  =>  (DEC64r:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::DEC64r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16017,
        GIR_Done,
      // Label 86: @732
      GIM_Try, /*On fail goto*//*Label 87*/ 765, // Rule ID 15970 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)  =>  (ADD64ri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD64ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15970,
        GIR_Done,
      // Label 87: @765
      GIM_Try, /*On fail goto*//*Label 88*/ 798, // Rule ID 15971 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)  =>  (ADD64ri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD64ri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15971,
        GIR_Done,
      // Label 88: @798
      GIM_Try, /*On fail goto*//*Label 89*/ 814, // Rule ID 15960 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (add:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (ADD64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD64rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15960,
        GIR_Done,
      // Label 89: @814
      GIM_Reject,
    // Label 82: @815
    GIM_Reject,
    // Label 50: @816
    GIM_Try, /*On fail goto*//*Label 90*/ 896,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 91*/ 849, // Rule ID 1684 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VPADDQrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDQrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1684,
        GIR_Done,
      // Label 91: @849
      GIM_Try, /*On fail goto*//*Label 92*/ 872, // Rule ID 1686 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (PADDQrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PADDQrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1686,
        GIR_Done,
      // Label 92: @872
      GIM_Try, /*On fail goto*//*Label 93*/ 895, // Rule ID 3687 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (add:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPADDQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3687,
        GIR_Done,
      // Label 93: @895
      GIM_Reject,
    // Label 90: @896
    GIM_Reject,
    // Label 51: @897
    GIM_Try, /*On fail goto*//*Label 94*/ 1099,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 95*/ 968, // Rule ID 12016 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_MUL,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[v4i32] } (mul:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2), VR128:{ *:[v4i32] }:$src3)  =>  (VPMACSDDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSDDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12016,
        GIR_Done,
      // Label 95: @968
      GIM_Try, /*On fail goto*//*Label 96*/ 1029, // Rule ID 17894 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_MUL,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src3, (mul:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2))  =>  (VPMACSDDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSDDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17894,
        GIR_Done,
      // Label 96: @1029
      GIM_Try, /*On fail goto*//*Label 97*/ 1052, // Rule ID 1678 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPADDDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1678,
        GIR_Done,
      // Label 97: @1052
      GIM_Try, /*On fail goto*//*Label 98*/ 1075, // Rule ID 1680 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PADDDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PADDDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1680,
        GIR_Done,
      // Label 98: @1075
      GIM_Try, /*On fail goto*//*Label 99*/ 1098, // Rule ID 3714 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (add:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPADDDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3714,
        GIR_Done,
      // Label 99: @1098
      GIM_Reject,
    // Label 94: @1099
    GIM_Reject,
    // Label 52: @1100
    GIM_Try, /*On fail goto*//*Label 100*/ 1157,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 101*/ 1133, // Rule ID 1688 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (add:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VPADDQYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDQYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1688,
        GIR_Done,
      // Label 101: @1133
      GIM_Try, /*On fail goto*//*Label 102*/ 1156, // Rule ID 3678 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (add:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPADDQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3678,
        GIR_Done,
      // Label 102: @1156
      GIM_Reject,
    // Label 100: @1157
    GIM_Reject,
    // Label 53: @1158
    GIM_Try, /*On fail goto*//*Label 103*/ 1360,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 104*/ 1229, // Rule ID 12015 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_MUL,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[v8i16] } (mul:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2), VR128:{ *:[v8i16] }:$src3)  =>  (VPMACSWWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v8i16] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSWWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12015,
        GIR_Done,
      // Label 104: @1229
      GIM_Try, /*On fail goto*//*Label 105*/ 1290, // Rule ID 17893 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_MUL,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (add:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src3, (mul:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2))  =>  (VPMACSWWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v8i16] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSWWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17893,
        GIR_Done,
      // Label 105: @1290
      GIM_Try, /*On fail goto*//*Label 106*/ 1313, // Rule ID 1672 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPADDWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1672,
        GIR_Done,
      // Label 106: @1313
      GIM_Try, /*On fail goto*//*Label 107*/ 1336, // Rule ID 1674 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PADDWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PADDWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1674,
        GIR_Done,
      // Label 107: @1336
      GIM_Try, /*On fail goto*//*Label 108*/ 1359, // Rule ID 3735 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (add:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPADDWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3735,
        GIR_Done,
      // Label 108: @1359
      GIM_Reject,
    // Label 103: @1360
    GIM_Reject,
    // Label 54: @1361
    GIM_Try, /*On fail goto*//*Label 109*/ 1418,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 110*/ 1394, // Rule ID 1682 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (add:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPADDDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1682,
        GIR_Done,
      // Label 110: @1394
      GIM_Try, /*On fail goto*//*Label 111*/ 1417, // Rule ID 3705 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (add:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPADDDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3705,
        GIR_Done,
      // Label 111: @1417
      GIM_Reject,
    // Label 109: @1418
    GIM_Reject,
    // Label 55: @1419
    GIM_Try, /*On fail goto*//*Label 112*/ 1450, // Rule ID 3669 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (add:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPADDQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3669,
      GIR_Done,
    // Label 112: @1450
    GIM_Reject,
    // Label 56: @1451
    GIM_Try, /*On fail goto*//*Label 113*/ 1531,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 114*/ 1484, // Rule ID 1666 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPADDBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1666,
        GIR_Done,
      // Label 114: @1484
      GIM_Try, /*On fail goto*//*Label 115*/ 1507, // Rule ID 1668 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (add:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PADDBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PADDBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1668,
        GIR_Done,
      // Label 115: @1507
      GIM_Try, /*On fail goto*//*Label 116*/ 1530, // Rule ID 3753 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (add:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPADDBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDBZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3753,
        GIR_Done,
      // Label 116: @1530
      GIM_Reject,
    // Label 113: @1531
    GIM_Reject,
    // Label 57: @1532
    GIM_Try, /*On fail goto*//*Label 117*/ 1589,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 118*/ 1565, // Rule ID 1676 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (add:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPADDWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1676,
        GIR_Done,
      // Label 118: @1565
      GIM_Try, /*On fail goto*//*Label 119*/ 1588, // Rule ID 3729 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (add:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPADDWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3729,
        GIR_Done,
      // Label 119: @1588
      GIM_Reject,
    // Label 117: @1589
    GIM_Reject,
    // Label 58: @1590
    GIM_Try, /*On fail goto*//*Label 120*/ 1621, // Rule ID 3696 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (add:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPADDDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3696,
      GIR_Done,
    // Label 120: @1621
    GIM_Reject,
    // Label 59: @1622
    GIM_Try, /*On fail goto*//*Label 121*/ 1679,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 122*/ 1655, // Rule ID 1670 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (add:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPADDBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDBYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1670,
        GIR_Done,
      // Label 122: @1655
      GIM_Try, /*On fail goto*//*Label 123*/ 1678, // Rule ID 3747 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (add:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPADDBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDBZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3747,
        GIR_Done,
      // Label 123: @1678
      GIM_Reject,
    // Label 121: @1679
    GIM_Reject,
    // Label 60: @1680
    GIM_Try, /*On fail goto*//*Label 124*/ 1711, // Rule ID 3723 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (add:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPADDWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3723,
      GIR_Done,
    // Label 124: @1711
    GIM_Reject,
    // Label 61: @1712
    GIM_Try, /*On fail goto*//*Label 125*/ 1743, // Rule ID 3741 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (add:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPADDBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPADDBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3741,
      GIR_Done,
    // Label 125: @1743
    GIM_Reject,
    // Label 62: @1744
    GIM_Reject,
    // Label 1: @1745
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 25, /*)*//*default:*//*Label 142*/ 2825,
    /*GILLT_s8*//*Label 126*/ 1775,
    /*GILLT_s16*//*Label 127*/ 1841,
    /*GILLT_s32*//*Label 128*/ 1940,
    /*GILLT_s64*//*Label 129*/ 2039, 0, 0, 0,
    /*GILLT_v2s64*//*Label 130*/ 2141, 0,
    /*GILLT_v4s32*//*Label 131*/ 2222,
    /*GILLT_v4s64*//*Label 132*/ 2303, 0,
    /*GILLT_v8s16*//*Label 133*/ 2361,
    /*GILLT_v8s32*//*Label 134*/ 2442,
    /*GILLT_v8s64*//*Label 135*/ 2500, 0,
    /*GILLT_v16s8*//*Label 136*/ 2532,
    /*GILLT_v16s16*//*Label 137*/ 2613,
    /*GILLT_v16s32*//*Label 138*/ 2671, 0,
    /*GILLT_v32s8*//*Label 139*/ 2703,
    /*GILLT_v32s16*//*Label 140*/ 2761, 0,
    /*GILLT_v64s8*//*Label 141*/ 2793,
    // Label 126: @1775
    GIM_Try, /*On fail goto*//*Label 143*/ 1840,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 144*/ 1823, // Rule ID 15980 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SUB8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15980,
        GIR_Done,
      // Label 144: @1823
      GIM_Try, /*On fail goto*//*Label 145*/ 1839, // Rule ID 15972 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR8RegClassID,
        // (sub:{ *:[i8] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)  =>  (SUB8rr:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB8rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15972,
        GIR_Done,
      // Label 145: @1839
      GIM_Reject,
    // Label 143: @1840
    GIM_Reject,
    // Label 127: @1841
    GIM_Try, /*On fail goto*//*Label 146*/ 1939,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 147*/ 1892, // Rule ID 15983 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i16immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)  =>  (SUB16ri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB16ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15983,
        GIR_Done,
      // Label 147: @1892
      GIM_Try, /*On fail goto*//*Label 148*/ 1922, // Rule ID 15981 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)  =>  (SUB16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15981,
        GIR_Done,
      // Label 148: @1922
      GIM_Try, /*On fail goto*//*Label 149*/ 1938, // Rule ID 15973 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR16RegClassID,
        // (sub:{ *:[i16] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (SUB16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB16rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15973,
        GIR_Done,
      // Label 149: @1938
      GIM_Reject,
    // Label 146: @1939
    GIM_Reject,
    // Label 128: @1940
    GIM_Try, /*On fail goto*//*Label 150*/ 2038,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      GIM_Try, /*On fail goto*//*Label 151*/ 1991, // Rule ID 15984 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)  =>  (SUB32ri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB32ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15984,
        GIR_Done,
      // Label 151: @1991
      GIM_Try, /*On fail goto*//*Label 152*/ 2021, // Rule ID 15982 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)  =>  (SUB32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15982,
        GIR_Done,
      // Label 152: @2021
      GIM_Try, /*On fail goto*//*Label 153*/ 2037, // Rule ID 15974 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (sub:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (SUB32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB32rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15974,
        GIR_Done,
      // Label 153: @2037
      GIM_Reject,
    // Label 150: @2038
    GIM_Reject,
    // Label 129: @2039
    GIM_Try, /*On fail goto*//*Label 154*/ 2140,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      GIM_Try, /*On fail goto*//*Label 155*/ 2090, // Rule ID 15985 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)  =>  (SUB64ri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB64ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15985,
        GIR_Done,
      // Label 155: @2090
      GIM_Try, /*On fail goto*//*Label 156*/ 2123, // Rule ID 15986 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sub:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)  =>  (SUB64ri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SUB64ri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15986,
        GIR_Done,
      // Label 156: @2123
      GIM_Try, /*On fail goto*//*Label 157*/ 2139, // Rule ID 15975 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (sub:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (SUB64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB64rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15975,
        GIR_Done,
      // Label 157: @2139
      GIM_Reject,
    // Label 154: @2140
    GIM_Reject,
    // Label 130: @2141
    GIM_Try, /*On fail goto*//*Label 158*/ 2221,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 159*/ 2174, // Rule ID 1750 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VPSUBQrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBQrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1750,
        GIR_Done,
      // Label 159: @2174
      GIM_Try, /*On fail goto*//*Label 160*/ 2197, // Rule ID 1752 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (PSUBQrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PSUBQrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1752,
        GIR_Done,
      // Label 160: @2197
      GIM_Try, /*On fail goto*//*Label 161*/ 2220, // Rule ID 3777 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (sub:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPSUBQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3777,
        GIR_Done,
      // Label 161: @2220
      GIM_Reject,
    // Label 158: @2221
    GIM_Reject,
    // Label 131: @2222
    GIM_Try, /*On fail goto*//*Label 162*/ 2302,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 163*/ 2255, // Rule ID 1744 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPSUBDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1744,
        GIR_Done,
      // Label 163: @2255
      GIM_Try, /*On fail goto*//*Label 164*/ 2278, // Rule ID 1746 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PSUBDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PSUBDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1746,
        GIR_Done,
      // Label 164: @2278
      GIM_Try, /*On fail goto*//*Label 165*/ 2301, // Rule ID 3804 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (sub:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPSUBDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3804,
        GIR_Done,
      // Label 165: @2301
      GIM_Reject,
    // Label 162: @2302
    GIM_Reject,
    // Label 132: @2303
    GIM_Try, /*On fail goto*//*Label 166*/ 2360,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 167*/ 2336, // Rule ID 1754 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (sub:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VPSUBQYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBQYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1754,
        GIR_Done,
      // Label 167: @2336
      GIM_Try, /*On fail goto*//*Label 168*/ 2359, // Rule ID 3768 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (sub:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPSUBQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3768,
        GIR_Done,
      // Label 168: @2359
      GIM_Reject,
    // Label 166: @2360
    GIM_Reject,
    // Label 133: @2361
    GIM_Try, /*On fail goto*//*Label 169*/ 2441,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 170*/ 2394, // Rule ID 1738 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPSUBWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1738,
        GIR_Done,
      // Label 170: @2394
      GIM_Try, /*On fail goto*//*Label 171*/ 2417, // Rule ID 1740 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PSUBWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PSUBWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1740,
        GIR_Done,
      // Label 171: @2417
      GIM_Try, /*On fail goto*//*Label 172*/ 2440, // Rule ID 3825 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (sub:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPSUBWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3825,
        GIR_Done,
      // Label 172: @2440
      GIM_Reject,
    // Label 169: @2441
    GIM_Reject,
    // Label 134: @2442
    GIM_Try, /*On fail goto*//*Label 173*/ 2499,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 174*/ 2475, // Rule ID 1748 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (sub:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPSUBDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1748,
        GIR_Done,
      // Label 174: @2475
      GIM_Try, /*On fail goto*//*Label 175*/ 2498, // Rule ID 3795 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (sub:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPSUBDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3795,
        GIR_Done,
      // Label 175: @2498
      GIM_Reject,
    // Label 173: @2499
    GIM_Reject,
    // Label 135: @2500
    GIM_Try, /*On fail goto*//*Label 176*/ 2531, // Rule ID 3759 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (sub:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPSUBQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3759,
      GIR_Done,
    // Label 176: @2531
    GIM_Reject,
    // Label 136: @2532
    GIM_Try, /*On fail goto*//*Label 177*/ 2612,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 178*/ 2565, // Rule ID 1732 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPSUBBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1732,
        GIR_Done,
      // Label 178: @2565
      GIM_Try, /*On fail goto*//*Label 179*/ 2588, // Rule ID 1734 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (sub:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PSUBBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PSUBBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1734,
        GIR_Done,
      // Label 179: @2588
      GIM_Try, /*On fail goto*//*Label 180*/ 2611, // Rule ID 3843 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (sub:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPSUBBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBBZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3843,
        GIR_Done,
      // Label 180: @2611
      GIM_Reject,
    // Label 177: @2612
    GIM_Reject,
    // Label 137: @2613
    GIM_Try, /*On fail goto*//*Label 181*/ 2670,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 182*/ 2646, // Rule ID 1742 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (sub:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPSUBWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1742,
        GIR_Done,
      // Label 182: @2646
      GIM_Try, /*On fail goto*//*Label 183*/ 2669, // Rule ID 3819 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (sub:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPSUBWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3819,
        GIR_Done,
      // Label 183: @2669
      GIM_Reject,
    // Label 181: @2670
    GIM_Reject,
    // Label 138: @2671
    GIM_Try, /*On fail goto*//*Label 184*/ 2702, // Rule ID 3786 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (sub:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPSUBDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3786,
      GIR_Done,
    // Label 184: @2702
    GIM_Reject,
    // Label 139: @2703
    GIM_Try, /*On fail goto*//*Label 185*/ 2760,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 186*/ 2736, // Rule ID 1736 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (sub:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPSUBBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBBYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1736,
        GIR_Done,
      // Label 186: @2736
      GIM_Try, /*On fail goto*//*Label 187*/ 2759, // Rule ID 3837 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (sub:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPSUBBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBBZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3837,
        GIR_Done,
      // Label 187: @2759
      GIM_Reject,
    // Label 185: @2760
    GIM_Reject,
    // Label 140: @2761
    GIM_Try, /*On fail goto*//*Label 188*/ 2792, // Rule ID 3813 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (sub:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPSUBWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3813,
      GIR_Done,
    // Label 188: @2792
    GIM_Reject,
    // Label 141: @2793
    GIM_Try, /*On fail goto*//*Label 189*/ 2824, // Rule ID 3831 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (sub:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPSUBBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPSUBBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3831,
      GIR_Done,
    // Label 189: @2824
    GIM_Reject,
    // Label 142: @2825
    GIM_Reject,
    // Label 2: @2826
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/2, 23, /*)*//*default:*//*Label 202*/ 3591,
    /*GILLT_s16*//*Label 190*/ 2853,
    /*GILLT_s32*//*Label 191*/ 2952,
    /*GILLT_s64*//*Label 192*/ 3051, 0, 0, 0,
    /*GILLT_v2s64*//*Label 193*/ 3153, 0,
    /*GILLT_v4s32*//*Label 194*/ 3185,
    /*GILLT_v4s64*//*Label 195*/ 3266, 0,
    /*GILLT_v8s16*//*Label 196*/ 3298,
    /*GILLT_v8s32*//*Label 197*/ 3379,
    /*GILLT_v8s64*//*Label 198*/ 3437, 0, 0,
    /*GILLT_v16s16*//*Label 199*/ 3469,
    /*GILLT_v16s32*//*Label 200*/ 3527, 0, 0,
    /*GILLT_v32s16*//*Label 201*/ 3559,
    // Label 190: @2853
    GIM_Try, /*On fail goto*//*Label 203*/ 2951,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 204*/ 2904, // Rule ID 16000 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i16immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (mul:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)  =>  (IMUL16rri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::IMUL16rri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16000,
        GIR_Done,
      // Label 204: @2904
      GIM_Try, /*On fail goto*//*Label 205*/ 2934, // Rule ID 15998 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (mul:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)  =>  (IMUL16rri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::IMUL16rri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15998,
        GIR_Done,
      // Label 205: @2934
      GIM_Try, /*On fail goto*//*Label 206*/ 2950, // Rule ID 15992 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR16RegClassID,
        // (mul:{ *:[i16] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (IMUL16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::IMUL16rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15992,
        GIR_Done,
      // Label 206: @2950
      GIM_Reject,
    // Label 203: @2951
    GIM_Reject,
    // Label 191: @2952
    GIM_Try, /*On fail goto*//*Label 207*/ 3050,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      GIM_Try, /*On fail goto*//*Label 208*/ 3003, // Rule ID 16001 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (mul:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)  =>  (IMUL32rri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::IMUL32rri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16001,
        GIR_Done,
      // Label 208: @3003
      GIM_Try, /*On fail goto*//*Label 209*/ 3033, // Rule ID 15999 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (mul:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)  =>  (IMUL32rri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::IMUL32rri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15999,
        GIR_Done,
      // Label 209: @3033
      GIM_Try, /*On fail goto*//*Label 210*/ 3049, // Rule ID 15993 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (mul:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (IMUL32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::IMUL32rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15993,
        GIR_Done,
      // Label 210: @3049
      GIM_Reject,
    // Label 207: @3050
    GIM_Reject,
    // Label 192: @3051
    GIM_Try, /*On fail goto*//*Label 211*/ 3152,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      GIM_Try, /*On fail goto*//*Label 212*/ 3102, // Rule ID 16002 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (mul:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)  =>  (IMUL64rri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::IMUL64rri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16002,
        GIR_Done,
      // Label 212: @3102
      GIM_Try, /*On fail goto*//*Label 213*/ 3135, // Rule ID 16003 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (mul:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)  =>  (IMUL64rri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::IMUL64rri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16003,
        GIR_Done,
      // Label 213: @3135
      GIM_Try, /*On fail goto*//*Label 214*/ 3151, // Rule ID 15994 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (mul:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (IMUL64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::IMUL64rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15994,
        GIR_Done,
      // Label 214: @3151
      GIM_Reject,
    // Label 211: @3152
    GIM_Reject,
    // Label 193: @3153
    GIM_Try, /*On fail goto*//*Label 215*/ 3184, // Rule ID 4056 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
      // (mul:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPMULLQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4056,
      GIR_Done,
    // Label 215: @3184
    GIM_Reject,
    // Label 194: @3185
    GIM_Try, /*On fail goto*//*Label 216*/ 3265,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 217*/ 3218, // Rule ID 2363 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mul:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPMULLDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2363,
        GIR_Done,
      // Label 217: @3218
      GIM_Try, /*On fail goto*//*Label 218*/ 3241, // Rule ID 2371 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mul:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PMULLDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMULLDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2371,
        GIR_Done,
      // Label 218: @3241
      GIM_Try, /*On fail goto*//*Label 219*/ 3264, // Rule ID 4011 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (mul:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPMULLDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4011,
        GIR_Done,
      // Label 219: @3264
      GIM_Reject,
    // Label 216: @3265
    GIM_Reject,
    // Label 195: @3266
    GIM_Try, /*On fail goto*//*Label 220*/ 3297, // Rule ID 4047 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
      // (mul:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPMULLQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4047,
      GIR_Done,
    // Label 220: @3297
    GIM_Reject,
    // Label 196: @3298
    GIM_Try, /*On fail goto*//*Label 221*/ 3378,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 222*/ 3331, // Rule ID 1714 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mul:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMULLWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1714,
        GIR_Done,
      // Label 222: @3331
      GIM_Try, /*On fail goto*//*Label 223*/ 3354, // Rule ID 1716 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mul:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMULLWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMULLWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1716,
        GIR_Done,
      // Label 223: @3354
      GIM_Try, /*On fail goto*//*Label 224*/ 3377, // Rule ID 4032 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (mul:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMULLWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4032,
        GIR_Done,
      // Label 224: @3377
      GIM_Reject,
    // Label 221: @3378
    GIM_Reject,
    // Label 197: @3379
    GIM_Try, /*On fail goto*//*Label 225*/ 3436,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 226*/ 3412, // Rule ID 2367 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (mul:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPMULLDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2367,
        GIR_Done,
      // Label 226: @3412
      GIM_Try, /*On fail goto*//*Label 227*/ 3435, // Rule ID 4002 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (mul:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPMULLDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4002,
        GIR_Done,
      // Label 227: @3435
      GIM_Reject,
    // Label 225: @3436
    GIM_Reject,
    // Label 198: @3437
    GIM_Try, /*On fail goto*//*Label 228*/ 3468, // Rule ID 4038 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (mul:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPMULLQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4038,
      GIR_Done,
    // Label 228: @3468
    GIM_Reject,
    // Label 199: @3469
    GIM_Try, /*On fail goto*//*Label 229*/ 3526,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 230*/ 3502, // Rule ID 1718 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (mul:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMULLWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1718,
        GIR_Done,
      // Label 230: @3502
      GIM_Try, /*On fail goto*//*Label 231*/ 3525, // Rule ID 4026 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (mul:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMULLWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4026,
        GIR_Done,
      // Label 231: @3525
      GIM_Reject,
    // Label 229: @3526
    GIM_Reject,
    // Label 200: @3527
    GIM_Try, /*On fail goto*//*Label 232*/ 3558, // Rule ID 3993 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (mul:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPMULLDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3993,
      GIR_Done,
    // Label 232: @3558
    GIM_Reject,
    // Label 201: @3559
    GIM_Try, /*On fail goto*//*Label 233*/ 3590, // Rule ID 4020 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (mul:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMULLWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULLWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4020,
      GIR_Done,
    // Label 233: @3590
    GIM_Reject,
    // Label 202: @3591
    GIM_Reject,
    // Label 3: @3592
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/0, 25, /*)*//*default:*//*Label 257*/ 7096,
    /*GILLT_s1*//*Label 234*/ 3623,
    /*GILLT_s8*//*Label 235*/ 3921,
    /*GILLT_s16*//*Label 236*/ 3987,
    /*GILLT_s32*//*Label 237*/ 4086,
    /*GILLT_s64*//*Label 238*/ 5057, 0, 0,
    /*GILLT_v2s1*//*Label 239*/ 5929,
    /*GILLT_v2s64*//*Label 240*/ 6022,
    /*GILLT_v4s1*//*Label 241*/ 6103,
    /*GILLT_v4s32*//*Label 242*/ 6196,
    /*GILLT_v4s64*//*Label 243*/ 6277,
    /*GILLT_v8s1*//*Label 244*/ 6358,
    /*GILLT_v8s16*//*Label 245*/ 6467,
    /*GILLT_v8s32*//*Label 246*/ 6548,
    /*GILLT_v8s64*//*Label 247*/ 6629,
    /*GILLT_v16s1*//*Label 248*/ 6661,
    /*GILLT_v16s8*//*Label 249*/ 6693,
    /*GILLT_v16s16*//*Label 250*/ 6774,
    /*GILLT_v16s32*//*Label 251*/ 6855,
    /*GILLT_v32s1*//*Label 252*/ 6887,
    /*GILLT_v32s8*//*Label 253*/ 6919,
    /*GILLT_v32s16*//*Label 254*/ 7000,
    /*GILLT_v64s1*//*Label 255*/ 7032,
    /*GILLT_v64s8*//*Label 256*/ 7064,
    // Label 234: @3623
    GIM_Try, /*On fail goto*//*Label 258*/ 3920,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_Try, /*On fail goto*//*Label 259*/ 3738, // Rule ID 13349 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s1,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s1,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK1RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[v1i1] } (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, -1:{ *:[v1i1] }), VK1:{ *:[v1i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KANDNWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KANDNWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 13349,
        GIR_Done,
      // Label 259: @3738
      GIM_Try, /*On fail goto*//*Label 260*/ 3839, // Rule ID 18046 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s1,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s1,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src2, (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, -1:{ *:[v1i1] }))  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KANDNWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/1, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KANDNWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 18046,
        GIR_Done,
      // Label 260: @3839
      GIM_Try, /*On fail goto*//*Label 261*/ 3919, // Rule ID 13345 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK1RegClassID,
        // (and:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, VK1:{ *:[v1i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KANDWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KANDWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 13345,
        GIR_Done,
      // Label 261: @3919
      GIM_Reject,
    // Label 258: @3920
    GIM_Reject,
    // Label 235: @3921
    GIM_Try, /*On fail goto*//*Label 262*/ 3986,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 263*/ 3969, // Rule ID 16064 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (AND8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16064,
        GIR_Done,
      // Label 263: @3969
      GIM_Try, /*On fail goto*//*Label 264*/ 3985, // Rule ID 16056 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR8RegClassID,
        // (and:{ *:[i8] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)  =>  (AND8rr:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::AND8rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16056,
        GIR_Done,
      // Label 264: @3985
      GIM_Reject,
    // Label 262: @3986
    GIM_Reject,
    // Label 236: @3987
    GIM_Try, /*On fail goto*//*Label 265*/ 4085,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 266*/ 4038, // Rule ID 16067 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i16immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)  =>  (AND16ri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND16ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16067,
        GIR_Done,
      // Label 266: @4038
      GIM_Try, /*On fail goto*//*Label 267*/ 4068, // Rule ID 16065 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)  =>  (AND16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16065,
        GIR_Done,
      // Label 267: @4068
      GIM_Try, /*On fail goto*//*Label 268*/ 4084, // Rule ID 16057 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR16RegClassID,
        // (and:{ *:[i16] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (AND16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::AND16rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16057,
        GIR_Done,
      // Label 268: @4084
      GIM_Reject,
    // Label 265: @4085
    GIM_Reject,
    // Label 237: @4086
    GIM_Try, /*On fail goto*//*Label 269*/ 5056,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 270*/ 4167, // Rule ID 17817 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (BLCIC32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCIC32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17817,
        GIR_Done,
      // Label 270: @4167
      GIM_Try, /*On fail goto*//*Label 271*/ 4242, // Rule ID 17829 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (TZMSK32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::TZMSK32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17829,
        GIR_Done,
      // Label 271: @4242
      GIM_Try, /*On fail goto*//*Label 272*/ 4317, // Rule ID 11841 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i32] } (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }))  =>  (BLCIC32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCIC32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11841,
        GIR_Done,
      // Label 272: @4317
      GIM_Try, /*On fail goto*//*Label 273*/ 4392, // Rule ID 11853 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i32] } (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (TZMSK32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::TZMSK32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11853,
        GIR_Done,
      // Label 273: @4392
      GIM_Try, /*On fail goto*//*Label 274*/ 4446, // Rule ID 17799 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLSR32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSR32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17799,
        GIR_Done,
      // Label 274: @4446
      GIM_Try, /*On fail goto*//*Label 275*/ 4500, // Rule ID 17811 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLCFILL32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCFILL32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17811,
        GIR_Done,
      // Label 275: @4500
      GIM_Try, /*On fail goto*//*Label 276*/ 4554, // Rule ID 17803 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, 0,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/2,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } (sub:{ *:[i32] } 0:{ *:[i32] }, GR32:{ *:[i32] }:$src), GR32:{ *:[i32] }:$src)  =>  (BLSI32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSI32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17803,
        GIR_Done,
      // Label 276: @4554
      GIM_Try, /*On fail goto*//*Label 277*/ 4608, // Rule ID 11817 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src, (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (BLSR32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSR32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11817,
        GIR_Done,
      // Label 277: @4608
      GIM_Try, /*On fail goto*//*Label 278*/ 4662, // Rule ID 11835 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src, (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }))  =>  (BLCFILL32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCFILL32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11835,
        GIR_Done,
      // Label 278: @4662
      GIM_Try, /*On fail goto*//*Label 279*/ 4716, // Rule ID 11821 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, 0,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/2, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src, (sub:{ *:[i32] } 0:{ *:[i32] }, GR32:{ *:[i32] }:$src))  =>  (BLSI32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSI32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11821,
        GIR_Done,
      // Label 279: @4716
      GIM_Try, /*On fail goto*//*Label 280*/ 4767, // Rule ID 15833 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 65535,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src1, 65535:{ *:[i32] })  =>  (MOVZX32rr16:{ *:[i32] } (EXTRACT_SUBREG:{ *:[i16] } GR32:{ *:[i32] }:$src1, sub_16bit:{ *:[i32] }))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s16,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_CopySubReg, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, /*SubRegIdx*/4, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOVZX32rr16,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15833,
        GIR_Done,
      // Label 280: @4767
      GIM_Try, /*On fail goto*//*Label 281*/ 4818, // Rule ID 15834 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 255,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src1, 255:{ *:[i32] })  =>  (MOVZX32rr8:{ *:[i32] } (EXTRACT_SUBREG:{ *:[i8] } GR32:{ *:[i32] }:$src1, sub_8bit:{ *:[i32] }))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s8,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_CopySubReg, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, /*SubRegIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOVZX32rr8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15834,
        GIR_Done,
      // Label 281: @4818
      GIM_Try, /*On fail goto*//*Label 282*/ 4863, // Rule ID 16068 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)  =>  (AND32ri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND32ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16068,
        GIR_Done,
      // Label 282: @4863
      GIM_Try, /*On fail goto*//*Label 283*/ 4905, // Rule ID 16066 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)  =>  (AND32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16066,
        GIR_Done,
      // Label 283: @4905
      GIM_Try, /*On fail goto*//*Label 284*/ 4966, // Rule ID 11881 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } (xor:{ *:[i32] } GR32:{ *:[i32] }:$src1, -1:{ *:[i32] }), GR32:{ *:[i32] }:$src2)  =>  (ANDN32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ANDN32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11881,
        GIR_Done,
      // Label 284: @4966
      GIM_Try, /*On fail goto*//*Label 285*/ 5027, // Rule ID 17849 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src2, (xor:{ *:[i32] } GR32:{ *:[i32] }:$src1, -1:{ *:[i32] }))  =>  (ANDN32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ANDN32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17849,
        GIR_Done,
      // Label 285: @5027
      GIM_Try, /*On fail goto*//*Label 286*/ 5055, // Rule ID 16058 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (and:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (AND32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::AND32rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16058,
        GIR_Done,
      // Label 286: @5055
      GIM_Reject,
    // Label 269: @5056
    GIM_Reject,
    // Label 238: @5057
    GIM_Try, /*On fail goto*//*Label 287*/ 5928,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 288*/ 5138, // Rule ID 17818 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (BLCIC64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCIC64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17818,
        GIR_Done,
      // Label 288: @5138
      GIM_Try, /*On fail goto*//*Label 289*/ 5213, // Rule ID 17830 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (TZMSK64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::TZMSK64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17830,
        GIR_Done,
      // Label 289: @5213
      GIM_Try, /*On fail goto*//*Label 290*/ 5288, // Rule ID 11842 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i64] } (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }))  =>  (BLCIC64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCIC64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11842,
        GIR_Done,
      // Label 290: @5288
      GIM_Try, /*On fail goto*//*Label 291*/ 5363, // Rule ID 11854 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (and:{ *:[i64] } (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (TZMSK64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::TZMSK64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11854,
        GIR_Done,
      // Label 291: @5363
      GIM_Try, /*On fail goto*//*Label 292*/ 5417, // Rule ID 17800 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLSR64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSR64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17800,
        GIR_Done,
      // Label 292: @5417
      GIM_Try, /*On fail goto*//*Label 293*/ 5471, // Rule ID 17812 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLCFILL64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCFILL64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17812,
        GIR_Done,
      // Label 293: @5471
      GIM_Try, /*On fail goto*//*Label 294*/ 5525, // Rule ID 17804 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, 0,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/2,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } (sub:{ *:[i64] } 0:{ *:[i64] }, GR64:{ *:[i64] }:$src), GR64:{ *:[i64] }:$src)  =>  (BLSI64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSI64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17804,
        GIR_Done,
      // Label 294: @5525
      GIM_Try, /*On fail goto*//*Label 295*/ 5579, // Rule ID 11818 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src, (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (BLSR64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSR64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11818,
        GIR_Done,
      // Label 295: @5579
      GIM_Try, /*On fail goto*//*Label 296*/ 5633, // Rule ID 11836 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src, (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }))  =>  (BLCFILL64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCFILL64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11836,
        GIR_Done,
      // Label 296: @5633
      GIM_Try, /*On fail goto*//*Label 297*/ 5687, // Rule ID 11822 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, 0,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/2, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src, (sub:{ *:[i64] } 0:{ *:[i64] }, GR64:{ *:[i64] }:$src))  =>  (BLSI64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSI64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11822,
        GIR_Done,
      // Label 297: @5687
      GIM_Try, /*On fail goto*//*Label 298*/ 5732, // Rule ID 16069 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)  =>  (AND64ri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND64ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16069,
        GIR_Done,
      // Label 298: @5732
      GIM_Try, /*On fail goto*//*Label 299*/ 5777, // Rule ID 16070 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)  =>  (AND64ri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AND64ri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16070,
        GIR_Done,
      // Label 299: @5777
      GIM_Try, /*On fail goto*//*Label 300*/ 5838, // Rule ID 11882 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } (xor:{ *:[i64] } GR64:{ *:[i64] }:$src1, -1:{ *:[i64] }), GR64:{ *:[i64] }:$src2)  =>  (ANDN64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ANDN64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11882,
        GIR_Done,
      // Label 300: @5838
      GIM_Try, /*On fail goto*//*Label 301*/ 5899, // Rule ID 17850 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src2, (xor:{ *:[i64] } GR64:{ *:[i64] }:$src1, -1:{ *:[i64] }))  =>  (ANDN64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ANDN64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17850,
        GIR_Done,
      // Label 301: @5899
      GIM_Try, /*On fail goto*//*Label 302*/ 5927, // Rule ID 16059 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (and:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (AND64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::AND64rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16059,
        GIR_Done,
      // Label 302: @5927
      GIM_Reject,
    // Label 287: @5928
    GIM_Reject,
    // Label 239: @5929
    GIM_Try, /*On fail goto*//*Label 303*/ 6021, // Rule ID 13346 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK2RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK2RegClassID,
      // (and:{ *:[v2i1] } VK2:{ *:[v2i1] }:$src1, VK2:{ *:[v2i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v2i1] } (KANDWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK2:{ *:[v2i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK2:{ *:[v2i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KANDWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13346,
      GIR_Done,
    // Label 303: @6021
    GIM_Reject,
    // Label 240: @6022
    GIM_Try, /*On fail goto*//*Label 304*/ 6102,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 305*/ 6055, // Rule ID 1406 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VPANDrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1406,
        GIR_Done,
      // Label 305: @6055
      GIM_Try, /*On fail goto*//*Label 306*/ 6078, // Rule ID 1408 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (PANDrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1408,
        GIR_Done,
      // Label 306: @6078
      GIM_Try, /*On fail goto*//*Label 307*/ 6101, // Rule ID 4740 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (and:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPANDQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4740,
        GIR_Done,
      // Label 307: @6101
      GIM_Reject,
    // Label 304: @6102
    GIM_Reject,
    // Label 241: @6103
    GIM_Try, /*On fail goto*//*Label 308*/ 6195, // Rule ID 13347 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK4RegClassID,
      // (and:{ *:[v4i1] } VK4:{ *:[v4i1] }:$src1, VK4:{ *:[v4i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v4i1] } (KANDWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK4:{ *:[v4i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK4:{ *:[v4i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KANDWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13347,
      GIR_Done,
    // Label 308: @6195
    GIM_Reject,
    // Label 242: @6196
    GIM_Try, /*On fail goto*//*Label 309*/ 6276,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 310*/ 6229, // Rule ID 4767 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (and:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPANDDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4767,
        GIR_Done,
      // Label 310: @6229
      GIM_Try, /*On fail goto*//*Label 311*/ 6252, // Rule ID 12221 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPANDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12221,
        GIR_Done,
      // Label 311: @6252
      GIM_Try, /*On fail goto*//*Label 312*/ 6275, // Rule ID 12245 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PANDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12245,
        GIR_Done,
      // Label 312: @6275
      GIM_Reject,
    // Label 309: @6276
    GIM_Reject,
    // Label 243: @6277
    GIM_Try, /*On fail goto*//*Label 313*/ 6357,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 314*/ 6310, // Rule ID 1410 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VPANDYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1410,
        GIR_Done,
      // Label 314: @6310
      GIM_Try, /*On fail goto*//*Label 315*/ 6333, // Rule ID 4731 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (and:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPANDQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4731,
        GIR_Done,
      // Label 315: @6333
      GIM_Try, /*On fail goto*//*Label 316*/ 6356, // Rule ID 12190 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VANDPSYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VANDPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12190,
        GIR_Done,
      // Label 316: @6356
      GIM_Reject,
    // Label 313: @6357
    GIM_Reject,
    // Label 244: @6358
    GIM_Try, /*On fail goto*//*Label 317*/ 6466,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK8RegClassID,
      GIM_Try, /*On fail goto*//*Label 318*/ 6391, // Rule ID 3457 //
        GIM_CheckFeatures, GIFBS_HasDQI,
        // (and:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (KANDBrr:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KANDBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3457,
        GIR_Done,
      // Label 318: @6391
      GIM_Try, /*On fail goto*//*Label 319*/ 6465, // Rule ID 13344 //
        GIM_CheckFeatures, GIFBS_NoDQI,
        // (and:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v8i1] } (KANDWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src2, VK16:{ *:[i32] })), VK8:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KANDWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK8*/12,
        // GIR_Coverage, 13344,
        GIR_Done,
      // Label 319: @6465
      GIM_Reject,
    // Label 317: @6466
    GIM_Reject,
    // Label 245: @6467
    GIM_Try, /*On fail goto*//*Label 320*/ 6547,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 321*/ 6500, // Rule ID 12220 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPANDrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12220,
        GIR_Done,
      // Label 321: @6500
      GIM_Try, /*On fail goto*//*Label 322*/ 6523, // Rule ID 12244 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PANDrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12244,
        GIR_Done,
      // Label 322: @6523
      GIM_Try, /*On fail goto*//*Label 323*/ 6546, // Rule ID 13771 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (and:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPANDQZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13771,
        GIR_Done,
      // Label 323: @6546
      GIM_Reject,
    // Label 320: @6547
    GIM_Reject,
    // Label 246: @6548
    GIM_Try, /*On fail goto*//*Label 324*/ 6628,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 325*/ 6581, // Rule ID 4758 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (and:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPANDDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4758,
        GIR_Done,
      // Label 325: @6581
      GIM_Try, /*On fail goto*//*Label 326*/ 6604, // Rule ID 12165 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPANDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12165,
        GIR_Done,
      // Label 326: @6604
      GIM_Try, /*On fail goto*//*Label 327*/ 6627, // Rule ID 12189 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VANDPSYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VANDPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12189,
        GIR_Done,
      // Label 327: @6627
      GIM_Reject,
    // Label 324: @6628
    GIM_Reject,
    // Label 247: @6629
    GIM_Try, /*On fail goto*//*Label 328*/ 6660, // Rule ID 4722 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (and:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPANDQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4722,
      GIR_Done,
    // Label 328: @6660
    GIM_Reject,
    // Label 248: @6661
    GIM_Try, /*On fail goto*//*Label 329*/ 6692, // Rule ID 3458 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK16RegClassID,
      // (and:{ *:[v16i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)  =>  (KANDWrr:{ *:[v16i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KANDWrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3458,
      GIR_Done,
    // Label 329: @6692
    GIM_Reject,
    // Label 249: @6693
    GIM_Try, /*On fail goto*//*Label 330*/ 6773,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 331*/ 6726, // Rule ID 12219 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPANDrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12219,
        GIR_Done,
      // Label 331: @6726
      GIM_Try, /*On fail goto*//*Label 332*/ 6749, // Rule ID 12243 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (and:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PANDrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PANDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12243,
        GIR_Done,
      // Label 332: @6749
      GIM_Try, /*On fail goto*//*Label 333*/ 6772, // Rule ID 13770 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (and:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPANDQZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13770,
        GIR_Done,
      // Label 333: @6772
      GIM_Reject,
    // Label 330: @6773
    GIM_Reject,
    // Label 250: @6774
    GIM_Try, /*On fail goto*//*Label 334*/ 6854,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 335*/ 6807, // Rule ID 12164 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPANDYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12164,
        GIR_Done,
      // Label 335: @6807
      GIM_Try, /*On fail goto*//*Label 336*/ 6830, // Rule ID 12188 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VANDPSYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VANDPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12188,
        GIR_Done,
      // Label 336: @6830
      GIM_Try, /*On fail goto*//*Label 337*/ 6853, // Rule ID 13795 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (and:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPANDQZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13795,
        GIR_Done,
      // Label 337: @6853
      GIM_Reject,
    // Label 334: @6854
    GIM_Reject,
    // Label 251: @6855
    GIM_Try, /*On fail goto*//*Label 338*/ 6886, // Rule ID 4749 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (and:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPANDDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4749,
      GIR_Done,
    // Label 338: @6886
    GIM_Reject,
    // Label 252: @6887
    GIM_Try, /*On fail goto*//*Label 339*/ 6918, // Rule ID 3459 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK32RegClassID,
      // (and:{ *:[v32i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)  =>  (KANDDrr:{ *:[v32i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KANDDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3459,
      GIR_Done,
    // Label 339: @6918
    GIM_Reject,
    // Label 253: @6919
    GIM_Try, /*On fail goto*//*Label 340*/ 6999,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 341*/ 6952, // Rule ID 12163 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPANDYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12163,
        GIR_Done,
      // Label 341: @6952
      GIM_Try, /*On fail goto*//*Label 342*/ 6975, // Rule ID 12187 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (and:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VANDPSYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VANDPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12187,
        GIR_Done,
      // Label 342: @6975
      GIM_Try, /*On fail goto*//*Label 343*/ 6998, // Rule ID 13794 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (and:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPANDQZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13794,
        GIR_Done,
      // Label 343: @6998
      GIM_Reject,
    // Label 340: @6999
    GIM_Reject,
    // Label 254: @7000
    GIM_Try, /*On fail goto*//*Label 344*/ 7031, // Rule ID 13819 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (and:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPANDQZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13819,
      GIR_Done,
    // Label 344: @7031
    GIM_Reject,
    // Label 255: @7032
    GIM_Try, /*On fail goto*//*Label 345*/ 7063, // Rule ID 3460 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK64RegClassID,
      // (and:{ *:[v64i1] } VK64:{ *:[v64i1] }:$src1, VK64:{ *:[v64i1] }:$src2)  =>  (KANDQrr:{ *:[v64i1] } VK64:{ *:[v64i1] }:$src1, VK64:{ *:[v64i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KANDQrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3460,
      GIR_Done,
    // Label 345: @7063
    GIM_Reject,
    // Label 256: @7064
    GIM_Try, /*On fail goto*//*Label 346*/ 7095, // Rule ID 13818 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (and:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPANDQZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPANDQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13818,
      GIR_Done,
    // Label 346: @7095
    GIM_Reject,
    // Label 257: @7096
    GIM_Reject,
    // Label 4: @7097
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/0, 25, /*)*//*default:*//*Label 370*/ 10350,
    /*GILLT_s1*//*Label 347*/ 7128,
    /*GILLT_s8*//*Label 348*/ 7221,
    /*GILLT_s16*//*Label 349*/ 7287,
    /*GILLT_s32*//*Label 350*/ 7386,
    /*GILLT_s64*//*Label 351*/ 8283, 0, 0,
    /*GILLT_v2s1*//*Label 352*/ 9183,
    /*GILLT_v2s64*//*Label 353*/ 9276,
    /*GILLT_v4s1*//*Label 354*/ 9357,
    /*GILLT_v4s32*//*Label 355*/ 9450,
    /*GILLT_v4s64*//*Label 356*/ 9531,
    /*GILLT_v8s1*//*Label 357*/ 9612,
    /*GILLT_v8s16*//*Label 358*/ 9721,
    /*GILLT_v8s32*//*Label 359*/ 9802,
    /*GILLT_v8s64*//*Label 360*/ 9883,
    /*GILLT_v16s1*//*Label 361*/ 9915,
    /*GILLT_v16s8*//*Label 362*/ 9947,
    /*GILLT_v16s16*//*Label 363*/ 10028,
    /*GILLT_v16s32*//*Label 364*/ 10109,
    /*GILLT_v32s1*//*Label 365*/ 10141,
    /*GILLT_v32s8*//*Label 366*/ 10173,
    /*GILLT_v32s16*//*Label 367*/ 10254,
    /*GILLT_v64s1*//*Label 368*/ 10286,
    /*GILLT_v64s8*//*Label 369*/ 10318,
    // Label 347: @7128
    GIM_Try, /*On fail goto*//*Label 371*/ 7220, // Rule ID 13353 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK1RegClassID,
      // (or:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, VK1:{ *:[v1i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KORWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13353,
      GIR_Done,
    // Label 371: @7220
    GIM_Reject,
    // Label 348: @7221
    GIM_Try, /*On fail goto*//*Label 372*/ 7286,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 373*/ 7269, // Rule ID 16034 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (OR8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16034,
        GIR_Done,
      // Label 373: @7269
      GIM_Try, /*On fail goto*//*Label 374*/ 7285, // Rule ID 16026 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR8RegClassID,
        // (or:{ *:[i8] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)  =>  (OR8rr:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::OR8rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16026,
        GIR_Done,
      // Label 374: @7285
      GIM_Reject,
    // Label 372: @7286
    GIM_Reject,
    // Label 349: @7287
    GIM_Try, /*On fail goto*//*Label 375*/ 7385,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 376*/ 7338, // Rule ID 16037 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i16immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)  =>  (OR16ri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR16ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16037,
        GIR_Done,
      // Label 376: @7338
      GIM_Try, /*On fail goto*//*Label 377*/ 7368, // Rule ID 16035 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)  =>  (OR16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16035,
        GIR_Done,
      // Label 377: @7368
      GIM_Try, /*On fail goto*//*Label 378*/ 7384, // Rule ID 16027 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR16RegClassID,
        // (or:{ *:[i16] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (OR16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::OR16rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16027,
        GIR_Done,
      // Label 378: @7384
      GIM_Reject,
    // Label 375: @7385
    GIM_Reject,
    // Label 350: @7386
    GIM_Try, /*On fail goto*//*Label 379*/ 8282,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 380*/ 7467, // Rule ID 17825 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (BLSIC32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSIC32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17825,
        GIR_Done,
      // Label 380: @7467
      GIM_Try, /*On fail goto*//*Label 381*/ 7542, // Rule ID 17827 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (T1MSKC32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::T1MSKC32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17827,
        GIR_Done,
      // Label 381: @7542
      GIM_Try, /*On fail goto*//*Label 382*/ 7617, // Rule ID 17813 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/1, /*OpIdx*/1, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/2, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/2, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i32] } (xor:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), -1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLCI32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/2, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17813,
        GIR_Done,
      // Label 382: @7617
      GIM_Try, /*On fail goto*//*Label 383*/ 7692, // Rule ID 11849 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i32] } (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (BLSIC32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSIC32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11849,
        GIR_Done,
      // Label 383: @7692
      GIM_Try, /*On fail goto*//*Label 384*/ 7767, // Rule ID 11851 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i32] } (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }))  =>  (T1MSKC32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::T1MSKC32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11851,
        GIR_Done,
      // Label 384: @7767
      GIM_Try, /*On fail goto*//*Label 385*/ 7842, // Rule ID 11837 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/1, /*OpIdx*/1, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src, (xor:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), -1:{ *:[i32] }))  =>  (BLCI32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11837,
        GIR_Done,
      // Label 385: @7842
      GIM_Try, /*On fail goto*//*Label 386*/ 7896, // Rule ID 17821 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLCS32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCS32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17821,
        GIR_Done,
      // Label 386: @7896
      GIM_Try, /*On fail goto*//*Label 387*/ 7950, // Rule ID 17823 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLSFILL32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSFILL32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17823,
        GIR_Done,
      // Label 387: @7950
      GIM_Try, /*On fail goto*//*Label 388*/ 8004, // Rule ID 17815 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, -2,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/2,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } (sub:{ *:[i32] } -2:{ *:[i32] }, GR32:{ *:[i32] }:$src), GR32:{ *:[i32] }:$src)  =>  (BLCI32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17815,
        GIR_Done,
      // Label 388: @8004
      GIM_Try, /*On fail goto*//*Label 389*/ 8058, // Rule ID 11845 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src, (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }))  =>  (BLCS32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCS32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11845,
        GIR_Done,
      // Label 389: @8058
      GIM_Try, /*On fail goto*//*Label 390*/ 8112, // Rule ID 11847 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src, (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (BLSFILL32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSFILL32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11847,
        GIR_Done,
      // Label 390: @8112
      GIM_Try, /*On fail goto*//*Label 391*/ 8166, // Rule ID 11839 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, -2,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/2, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src, (sub:{ *:[i32] } -2:{ *:[i32] }, GR32:{ *:[i32] }:$src))  =>  (BLCI32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11839,
        GIR_Done,
      // Label 391: @8166
      GIM_Try, /*On fail goto*//*Label 392*/ 8211, // Rule ID 16038 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)  =>  (OR32ri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR32ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16038,
        GIR_Done,
      // Label 392: @8211
      GIM_Try, /*On fail goto*//*Label 393*/ 8253, // Rule ID 16036 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)  =>  (OR32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16036,
        GIR_Done,
      // Label 393: @8253
      GIM_Try, /*On fail goto*//*Label 394*/ 8281, // Rule ID 16028 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (or:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (OR32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::OR32rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16028,
        GIR_Done,
      // Label 394: @8281
      GIM_Reject,
    // Label 379: @8282
    GIM_Reject,
    // Label 351: @8283
    GIM_Try, /*On fail goto*//*Label 395*/ 9182,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 396*/ 8364, // Rule ID 17826 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (BLSIC64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSIC64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17826,
        GIR_Done,
      // Label 396: @8364
      GIM_Try, /*On fail goto*//*Label 397*/ 8439, // Rule ID 17828 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (T1MSKC64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::T1MSKC64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17828,
        GIR_Done,
      // Label 397: @8439
      GIM_Try, /*On fail goto*//*Label 398*/ 8514, // Rule ID 17814 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/1, /*OpIdx*/1, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/2, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/2, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i64] } (xor:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), -1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLCI64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/2, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17814,
        GIR_Done,
      // Label 398: @8514
      GIM_Try, /*On fail goto*//*Label 399*/ 8589, // Rule ID 11850 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i64] } (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (BLSIC64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSIC64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11850,
        GIR_Done,
      // Label 399: @8589
      GIM_Try, /*On fail goto*//*Label 400*/ 8664, // Rule ID 11852 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i64] } (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }))  =>  (T1MSKC64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::T1MSKC64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11852,
        GIR_Done,
      // Label 400: @8664
      GIM_Try, /*On fail goto*//*Label 401*/ 8739, // Rule ID 11838 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_RecordInsn, /*DefineMI*/2, /*MI*/1, /*OpIdx*/1, // MIs[2]
        GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[2] src
        GIM_CheckIsSameOperand, /*MI*/2, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/2, /*Op*/2, 1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/2,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src, (xor:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), -1:{ *:[i64] }))  =>  (BLCI64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11838,
        GIR_Done,
      // Label 401: @8739
      GIM_Try, /*On fail goto*//*Label 402*/ 8793, // Rule ID 17822 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLCS64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCS64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17822,
        GIR_Done,
      // Label 402: @8793
      GIM_Try, /*On fail goto*//*Label 403*/ 8847, // Rule ID 17824 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLSFILL64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSFILL64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17824,
        GIR_Done,
      // Label 403: @8847
      GIM_Try, /*On fail goto*//*Label 404*/ 8901, // Rule ID 17816 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, -2,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/2,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } (sub:{ *:[i64] } -2:{ *:[i64] }, GR64:{ *:[i64] }:$src), GR64:{ *:[i64] }:$src)  =>  (BLCI64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17816,
        GIR_Done,
      // Label 404: @8901
      GIM_Try, /*On fail goto*//*Label 405*/ 8955, // Rule ID 11846 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src, (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }))  =>  (BLCS64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCS64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11846,
        GIR_Done,
      // Label 405: @8955
      GIM_Try, /*On fail goto*//*Label 406*/ 9009, // Rule ID 11848 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src, (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (BLSFILL64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSFILL64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11848,
        GIR_Done,
      // Label 406: @9009
      GIM_Try, /*On fail goto*//*Label 407*/ 9063, // Rule ID 11840 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_SUB,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/1, -2,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/2, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src, (sub:{ *:[i64] } -2:{ *:[i64] }, GR64:{ *:[i64] }:$src))  =>  (BLCI64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCI64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11840,
        GIR_Done,
      // Label 407: @9063
      GIM_Try, /*On fail goto*//*Label 408*/ 9108, // Rule ID 16039 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)  =>  (OR64ri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR64ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16039,
        GIR_Done,
      // Label 408: @9108
      GIM_Try, /*On fail goto*//*Label 409*/ 9153, // Rule ID 16040 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)  =>  (OR64ri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::OR64ri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16040,
        GIR_Done,
      // Label 409: @9153
      GIM_Try, /*On fail goto*//*Label 410*/ 9181, // Rule ID 16029 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (or:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (OR64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::OR64rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16029,
        GIR_Done,
      // Label 410: @9181
      GIM_Reject,
    // Label 395: @9182
    GIM_Reject,
    // Label 352: @9183
    GIM_Try, /*On fail goto*//*Label 411*/ 9275, // Rule ID 13354 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK2RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK2RegClassID,
      // (or:{ *:[v2i1] } VK2:{ *:[v2i1] }:$src1, VK2:{ *:[v2i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v2i1] } (KORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK2:{ *:[v2i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK2:{ *:[v2i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KORWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13354,
      GIR_Done,
    // Label 411: @9275
    GIM_Reject,
    // Label 353: @9276
    GIM_Try, /*On fail goto*//*Label 412*/ 9356,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 413*/ 9309, // Rule ID 1412 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VPORrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1412,
        GIR_Done,
      // Label 413: @9309
      GIM_Try, /*On fail goto*//*Label 414*/ 9332, // Rule ID 1414 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (PORrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1414,
        GIR_Done,
      // Label 414: @9332
      GIM_Try, /*On fail goto*//*Label 415*/ 9355, // Rule ID 4794 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (or:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPORQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4794,
        GIR_Done,
      // Label 415: @9355
      GIM_Reject,
    // Label 412: @9356
    GIM_Reject,
    // Label 354: @9357
    GIM_Try, /*On fail goto*//*Label 416*/ 9449, // Rule ID 13355 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK4RegClassID,
      // (or:{ *:[v4i1] } VK4:{ *:[v4i1] }:$src1, VK4:{ *:[v4i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v4i1] } (KORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK4:{ *:[v4i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK4:{ *:[v4i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KORWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13355,
      GIR_Done,
    // Label 416: @9449
    GIM_Reject,
    // Label 355: @9450
    GIM_Try, /*On fail goto*//*Label 417*/ 9530,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 418*/ 9483, // Rule ID 4821 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (or:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPORDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4821,
        GIR_Done,
      // Label 418: @9483
      GIM_Try, /*On fail goto*//*Label 419*/ 9506, // Rule ID 12224 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPORrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12224,
        GIR_Done,
      // Label 419: @9506
      GIM_Try, /*On fail goto*//*Label 420*/ 9529, // Rule ID 12248 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PORrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12248,
        GIR_Done,
      // Label 420: @9529
      GIM_Reject,
    // Label 417: @9530
    GIM_Reject,
    // Label 356: @9531
    GIM_Try, /*On fail goto*//*Label 421*/ 9611,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 422*/ 9564, // Rule ID 1416 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VPORYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1416,
        GIR_Done,
      // Label 422: @9564
      GIM_Try, /*On fail goto*//*Label 423*/ 9587, // Rule ID 4785 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (or:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPORQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4785,
        GIR_Done,
      // Label 423: @9587
      GIM_Try, /*On fail goto*//*Label 424*/ 9610, // Rule ID 12194 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VORPSYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12194,
        GIR_Done,
      // Label 424: @9610
      GIM_Reject,
    // Label 421: @9611
    GIM_Reject,
    // Label 357: @9612
    GIM_Try, /*On fail goto*//*Label 425*/ 9720,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK8RegClassID,
      GIM_Try, /*On fail goto*//*Label 426*/ 9645, // Rule ID 3461 //
        GIM_CheckFeatures, GIFBS_HasDQI,
        // (or:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (KORBrr:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KORBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3461,
        GIR_Done,
      // Label 426: @9645
      GIM_Try, /*On fail goto*//*Label 427*/ 9719, // Rule ID 13352 //
        GIM_CheckFeatures, GIFBS_NoDQI,
        // (or:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v8i1] } (KORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src2, VK16:{ *:[i32] })), VK8:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KORWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK8*/12,
        // GIR_Coverage, 13352,
        GIR_Done,
      // Label 427: @9719
      GIM_Reject,
    // Label 425: @9720
    GIM_Reject,
    // Label 358: @9721
    GIM_Try, /*On fail goto*//*Label 428*/ 9801,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 429*/ 9754, // Rule ID 12223 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPORrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12223,
        GIR_Done,
      // Label 429: @9754
      GIM_Try, /*On fail goto*//*Label 430*/ 9777, // Rule ID 12247 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PORrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12247,
        GIR_Done,
      // Label 430: @9777
      GIM_Try, /*On fail goto*//*Label 431*/ 9800, // Rule ID 13773 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (or:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPORQZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13773,
        GIR_Done,
      // Label 431: @9800
      GIM_Reject,
    // Label 428: @9801
    GIM_Reject,
    // Label 359: @9802
    GIM_Try, /*On fail goto*//*Label 432*/ 9882,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 433*/ 9835, // Rule ID 4812 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (or:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPORDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4812,
        GIR_Done,
      // Label 433: @9835
      GIM_Try, /*On fail goto*//*Label 434*/ 9858, // Rule ID 12168 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPORYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12168,
        GIR_Done,
      // Label 434: @9858
      GIM_Try, /*On fail goto*//*Label 435*/ 9881, // Rule ID 12193 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VORPSYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12193,
        GIR_Done,
      // Label 435: @9881
      GIM_Reject,
    // Label 432: @9882
    GIM_Reject,
    // Label 360: @9883
    GIM_Try, /*On fail goto*//*Label 436*/ 9914, // Rule ID 4776 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (or:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPORQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4776,
      GIR_Done,
    // Label 436: @9914
    GIM_Reject,
    // Label 361: @9915
    GIM_Try, /*On fail goto*//*Label 437*/ 9946, // Rule ID 3462 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK16RegClassID,
      // (or:{ *:[v16i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)  =>  (KORWrr:{ *:[v16i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KORWrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3462,
      GIR_Done,
    // Label 437: @9946
    GIM_Reject,
    // Label 362: @9947
    GIM_Try, /*On fail goto*//*Label 438*/ 10027,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 439*/ 9980, // Rule ID 12222 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPORrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12222,
        GIR_Done,
      // Label 439: @9980
      GIM_Try, /*On fail goto*//*Label 440*/ 10003, // Rule ID 12246 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (or:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PORrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12246,
        GIR_Done,
      // Label 440: @10003
      GIM_Try, /*On fail goto*//*Label 441*/ 10026, // Rule ID 13772 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (or:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPORQZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13772,
        GIR_Done,
      // Label 441: @10026
      GIM_Reject,
    // Label 438: @10027
    GIM_Reject,
    // Label 363: @10028
    GIM_Try, /*On fail goto*//*Label 442*/ 10108,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 443*/ 10061, // Rule ID 12167 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPORYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12167,
        GIR_Done,
      // Label 443: @10061
      GIM_Try, /*On fail goto*//*Label 444*/ 10084, // Rule ID 12192 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VORPSYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12192,
        GIR_Done,
      // Label 444: @10084
      GIM_Try, /*On fail goto*//*Label 445*/ 10107, // Rule ID 13797 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (or:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPORQZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13797,
        GIR_Done,
      // Label 445: @10107
      GIM_Reject,
    // Label 442: @10108
    GIM_Reject,
    // Label 364: @10109
    GIM_Try, /*On fail goto*//*Label 446*/ 10140, // Rule ID 4803 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (or:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPORDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4803,
      GIR_Done,
    // Label 446: @10140
    GIM_Reject,
    // Label 365: @10141
    GIM_Try, /*On fail goto*//*Label 447*/ 10172, // Rule ID 3463 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK32RegClassID,
      // (or:{ *:[v32i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)  =>  (KORDrr:{ *:[v32i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KORDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3463,
      GIR_Done,
    // Label 447: @10172
    GIM_Reject,
    // Label 366: @10173
    GIM_Try, /*On fail goto*//*Label 448*/ 10253,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 449*/ 10206, // Rule ID 12166 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPORYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12166,
        GIR_Done,
      // Label 449: @10206
      GIM_Try, /*On fail goto*//*Label 450*/ 10229, // Rule ID 12191 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (or:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VORPSYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12191,
        GIR_Done,
      // Label 450: @10229
      GIM_Try, /*On fail goto*//*Label 451*/ 10252, // Rule ID 13796 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (or:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPORQZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13796,
        GIR_Done,
      // Label 451: @10252
      GIM_Reject,
    // Label 448: @10253
    GIM_Reject,
    // Label 367: @10254
    GIM_Try, /*On fail goto*//*Label 452*/ 10285, // Rule ID 13821 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (or:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPORQZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13821,
      GIR_Done,
    // Label 452: @10285
    GIM_Reject,
    // Label 368: @10286
    GIM_Try, /*On fail goto*//*Label 453*/ 10317, // Rule ID 3464 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK64RegClassID,
      // (or:{ *:[v64i1] } VK64:{ *:[v64i1] }:$src1, VK64:{ *:[v64i1] }:$src2)  =>  (KORQrr:{ *:[v64i1] } VK64:{ *:[v64i1] }:$src1, VK64:{ *:[v64i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KORQrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3464,
      GIR_Done,
    // Label 453: @10317
    GIM_Reject,
    // Label 369: @10318
    GIM_Try, /*On fail goto*//*Label 454*/ 10349, // Rule ID 13820 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (or:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPORQZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPORQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13820,
      GIR_Done,
    // Label 454: @10349
    GIM_Reject,
    // Label 370: @10350
    GIM_Reject,
    // Label 5: @10351
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/0, 25, /*)*//*default:*//*Label 478*/ 12906,
    /*GILLT_s1*//*Label 455*/ 10382,
    /*GILLT_s8*//*Label 456*/ 10781,
    /*GILLT_s16*//*Label 457*/ 10869,
    /*GILLT_s32*//*Label 458*/ 10990,
    /*GILLT_s64*//*Label 459*/ 11363, 0, 0,
    /*GILLT_v2s1*//*Label 460*/ 11739,
    /*GILLT_v2s64*//*Label 461*/ 11832,
    /*GILLT_v4s1*//*Label 462*/ 11913,
    /*GILLT_v4s32*//*Label 463*/ 12006,
    /*GILLT_v4s64*//*Label 464*/ 12087,
    /*GILLT_v8s1*//*Label 465*/ 12168,
    /*GILLT_v8s16*//*Label 466*/ 12277,
    /*GILLT_v8s32*//*Label 467*/ 12358,
    /*GILLT_v8s64*//*Label 468*/ 12439,
    /*GILLT_v16s1*//*Label 469*/ 12471,
    /*GILLT_v16s8*//*Label 470*/ 12503,
    /*GILLT_v16s16*//*Label 471*/ 12584,
    /*GILLT_v16s32*//*Label 472*/ 12665,
    /*GILLT_v32s1*//*Label 473*/ 12697,
    /*GILLT_v32s8*//*Label 474*/ 12729,
    /*GILLT_v32s16*//*Label 475*/ 12810,
    /*GILLT_v64s1*//*Label 476*/ 12842,
    /*GILLT_v64s8*//*Label 477*/ 12874,
    // Label 455: @10382
    GIM_Try, /*On fail goto*//*Label 479*/ 10780,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_Try, /*On fail goto*//*Label 480*/ 10497, // Rule ID 18058 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s1,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s1,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK1RegClassID,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[v1i1] } (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, -1:{ *:[v1i1] }), VK1:{ *:[v1i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KXNORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXNORWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 18058,
        GIR_Done,
      // Label 480: @10497
      GIM_Try, /*On fail goto*//*Label 481*/ 10598, // Rule ID 13357 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s1,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s1,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/X86::VK1RegClassID,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[v1i1] } (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, VK1:{ *:[v1i1] }:$src2), -1:{ *:[v1i1] })  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KXNORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/1, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXNORWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 13357,
        GIR_Done,
      // Label 481: @10598
      GIM_Try, /*On fail goto*//*Label 482*/ 10699, // Rule ID 18059 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_XOR,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s1,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s1,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src2, (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, -1:{ *:[v1i1] }))  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KXNORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/1, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/1, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXNORWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 18059,
        GIR_Done,
      // Label 482: @10699
      GIM_Try, /*On fail goto*//*Label 483*/ 10779, // Rule ID 13361 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK1RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK1RegClassID,
        // (xor:{ *:[v1i1] } VK1:{ *:[v1i1] }:$src1, VK1:{ *:[v1i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v1i1] } (KXORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK1:{ *:[v1i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXORWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
        // GIR_Coverage, 13361,
        GIR_Done,
      // Label 483: @10779
      GIM_Reject,
    // Label 479: @10780
    GIM_Reject,
    // Label 456: @10781
    GIM_Try, /*On fail goto*//*Label 484*/ 10868,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 485*/ 10821, // Rule ID 156 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (xor:{ *:[i8] } GR8:{ *:[i8] }:$src1, -1:{ *:[i8] })  =>  (NOT8r:{ *:[i8] } GR8:{ *:[i8] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::NOT8r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 156,
        GIR_Done,
      // Label 485: @10821
      GIM_Try, /*On fail goto*//*Label 486*/ 10851, // Rule ID 16049 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (XOR8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16049,
        GIR_Done,
      // Label 486: @10851
      GIM_Try, /*On fail goto*//*Label 487*/ 10867, // Rule ID 16041 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR8RegClassID,
        // (xor:{ *:[i8] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)  =>  (XOR8rr:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::XOR8rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16041,
        GIR_Done,
      // Label 487: @10867
      GIM_Reject,
    // Label 484: @10868
    GIM_Reject,
    // Label 457: @10869
    GIM_Try, /*On fail goto*//*Label 488*/ 10989,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 489*/ 10909, // Rule ID 157 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (xor:{ *:[i16] } GR16:{ *:[i16] }:$src1, -1:{ *:[i16] })  =>  (NOT16r:{ *:[i16] } GR16:{ *:[i16] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::NOT16r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 157,
        GIR_Done,
      // Label 489: @10909
      GIM_Try, /*On fail goto*//*Label 490*/ 10942, // Rule ID 16052 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i16immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)  =>  (XOR16ri8:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] })<<P:Predicate_i16immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR16ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16052,
        GIR_Done,
      // Label 490: @10942
      GIM_Try, /*On fail goto*//*Label 491*/ 10972, // Rule ID 16050 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)  =>  (XOR16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i16] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16050,
        GIR_Done,
      // Label 491: @10972
      GIM_Try, /*On fail goto*//*Label 492*/ 10988, // Rule ID 16042 //
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR16RegClassID,
        // (xor:{ *:[i16] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (XOR16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::XOR16rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16042,
        GIR_Done,
      // Label 492: @10988
      GIM_Reject,
    // Label 488: @10989
    GIM_Reject,
    // Label 458: @10990
    GIM_Try, /*On fail goto*//*Label 493*/ 11362,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 494*/ 11050, // Rule ID 17801 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLSMSK32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSMSK32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17801,
        GIR_Done,
      // Label 494: @11050
      GIM_Try, /*On fail goto*//*Label 495*/ 11104, // Rule ID 17819 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i32] } (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }), GR32:{ *:[i32] }:$src)  =>  (BLCMSK32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCMSK32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17819,
        GIR_Done,
      // Label 495: @11104
      GIM_Try, /*On fail goto*//*Label 496*/ 11158, // Rule ID 11819 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, (add:{ *:[i32] } GR32:{ *:[i32] }:$src, -1:{ *:[i32] }))  =>  (BLSMSK32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSMSK32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11819,
        GIR_Done,
      // Label 496: @11158
      GIM_Try, /*On fail goto*//*Label 497*/ 11212, // Rule ID 11843 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i32] } GR32:{ *:[i32] }:$src, (add:{ *:[i32] } GR32:{ *:[i32] }:$src, 1:{ *:[i32] }))  =>  (BLCMSK32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCMSK32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11843,
        GIR_Done,
      // Label 497: @11212
      GIM_Try, /*On fail goto*//*Label 498*/ 11246, // Rule ID 158 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (xor:{ *:[i32] } GR32:{ *:[i32] }:$src1, -1:{ *:[i32] })  =>  (NOT32r:{ *:[i32] } GR32:{ *:[i32] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::NOT32r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 158,
        GIR_Done,
      // Label 498: @11246
      GIM_Try, /*On fail goto*//*Label 499*/ 11291, // Rule ID 16053 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)  =>  (XOR32ri8:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR32ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16053,
        GIR_Done,
      // Label 499: @11291
      GIM_Try, /*On fail goto*//*Label 500*/ 11333, // Rule ID 16051 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)  =>  (XOR32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16051,
        GIR_Done,
      // Label 500: @11333
      GIM_Try, /*On fail goto*//*Label 501*/ 11361, // Rule ID 16043 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (xor:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (XOR32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::XOR32rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16043,
        GIR_Done,
      // Label 501: @11361
      GIM_Reject,
    // Label 493: @11362
    GIM_Reject,
    // Label 459: @11363
    GIM_Try, /*On fail goto*//*Label 502*/ 11738,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 503*/ 11423, // Rule ID 17802 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLSMSK64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSMSK64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17802,
        GIR_Done,
      // Label 503: @11423
      GIM_Try, /*On fail goto*//*Label 504*/ 11477, // Rule ID 17820 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        // MIs[0] src
        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/2, /*OtherMI*/1, /*OtherOpIdx*/1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i64] } (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }), GR64:{ *:[i64] }:$src)  =>  (BLCMSK64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCMSK64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 17820,
        GIR_Done,
      // Label 504: @11477
      GIM_Try, /*On fail goto*//*Label 505*/ 11531, // Rule ID 11820 //
        GIM_CheckFeatures, GIFBS_HasBMI,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, -1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, (add:{ *:[i64] } GR64:{ *:[i64] }:$src, -1:{ *:[i64] }))  =>  (BLSMSK64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLSMSK64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11820,
        GIR_Done,
      // Label 505: @11531
      GIM_Try, /*On fail goto*//*Label 506*/ 11585, // Rule ID 11844 //
        GIM_CheckFeatures, GIFBS_HasTBM,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ADD,
        GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s64,
        // MIs[1] src
        GIM_CheckIsSameOperand, /*MI*/1, /*OpIdx*/1, /*OtherMI*/0, /*OtherOpIdx*/1,
        GIM_CheckConstantInt, /*MI*/1, /*Op*/2, 1,
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i64] } GR64:{ *:[i64] }:$src, (add:{ *:[i64] } GR64:{ *:[i64] }:$src, 1:{ *:[i64] }))  =>  (BLCMSK64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::BLCMSK64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11844,
        GIR_Done,
      // Label 506: @11585
      GIM_Try, /*On fail goto*//*Label 507*/ 11619, // Rule ID 159 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, -1,
        // (xor:{ *:[i64] } GR64:{ *:[i64] }:$src1, -1:{ *:[i64] })  =>  (NOT64r:{ *:[i64] } GR64:{ *:[i64] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::NOT64r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 159,
        GIR_Done,
      // Label 507: @11619
      GIM_Try, /*On fail goto*//*Label 508*/ 11664, // Rule ID 16054 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)  =>  (XOR64ri8:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR64ri8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16054,
        GIR_Done,
      // Label 508: @11664
      GIM_Try, /*On fail goto*//*Label 509*/ 11709, // Rule ID 16055 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        GIM_CheckI64ImmPredicate, /*MI*/1, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (xor:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)  =>  (XOR64ri32:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XOR64ri32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16055,
        GIR_Done,
      // Label 509: @11709
      GIM_Try, /*On fail goto*//*Label 510*/ 11737, // Rule ID 16044 //
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (xor:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (XOR64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::XOR64rr,
        GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 16044,
        GIR_Done,
      // Label 510: @11737
      GIM_Reject,
    // Label 502: @11738
    GIM_Reject,
    // Label 460: @11739
    GIM_Try, /*On fail goto*//*Label 511*/ 11831, // Rule ID 13362 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK2RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK2RegClassID,
      // (xor:{ *:[v2i1] } VK2:{ *:[v2i1] }:$src1, VK2:{ *:[v2i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v2i1] } (KXORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK2:{ *:[v2i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK2:{ *:[v2i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXORWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13362,
      GIR_Done,
    // Label 511: @11831
    GIM_Reject,
    // Label 461: @11832
    GIM_Try, /*On fail goto*//*Label 512*/ 11912,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 513*/ 11865, // Rule ID 1418 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VPXORrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1418,
        GIR_Done,
      // Label 513: @11865
      GIM_Try, /*On fail goto*//*Label 514*/ 11888, // Rule ID 1420 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (PXORrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1420,
        GIR_Done,
      // Label 514: @11888
      GIM_Try, /*On fail goto*//*Label 515*/ 11911, // Rule ID 4848 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (xor:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPXORQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4848,
        GIR_Done,
      // Label 515: @11911
      GIM_Reject,
    // Label 512: @11912
    GIM_Reject,
    // Label 462: @11913
    GIM_Try, /*On fail goto*//*Label 516*/ 12005, // Rule ID 13363 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK1RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK4RegClassID,
      // (xor:{ *:[v4i1] } VK4:{ *:[v4i1] }:$src1, VK4:{ *:[v4i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v4i1] } (KXORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK4:{ *:[v4i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK4:{ *:[v4i1] }:$src2, VK16:{ *:[i32] })), VK1:{ *:[i32] })
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
      GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
      GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
      GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
      GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
      GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
      GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXORWrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK1*/8,
      // GIR_Coverage, 13363,
      GIR_Done,
    // Label 516: @12005
    GIM_Reject,
    // Label 463: @12006
    GIM_Try, /*On fail goto*//*Label 517*/ 12086,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 518*/ 12039, // Rule ID 4875 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (xor:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPXORDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4875,
        GIR_Done,
      // Label 518: @12039
      GIM_Try, /*On fail goto*//*Label 519*/ 12062, // Rule ID 12227 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPXORrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12227,
        GIR_Done,
      // Label 519: @12062
      GIM_Try, /*On fail goto*//*Label 520*/ 12085, // Rule ID 12251 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PXORrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12251,
        GIR_Done,
      // Label 520: @12085
      GIM_Reject,
    // Label 517: @12086
    GIM_Reject,
    // Label 464: @12087
    GIM_Try, /*On fail goto*//*Label 521*/ 12167,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 522*/ 12120, // Rule ID 1422 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VPXORYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1422,
        GIR_Done,
      // Label 522: @12120
      GIM_Try, /*On fail goto*//*Label 523*/ 12143, // Rule ID 4839 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (xor:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPXORQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4839,
        GIR_Done,
      // Label 523: @12143
      GIM_Try, /*On fail goto*//*Label 524*/ 12166, // Rule ID 12198 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VXORPSYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VXORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12198,
        GIR_Done,
      // Label 524: @12166
      GIM_Reject,
    // Label 521: @12167
    GIM_Reject,
    // Label 465: @12168
    GIM_Try, /*On fail goto*//*Label 525*/ 12276,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK8RegClassID,
      GIM_Try, /*On fail goto*//*Label 526*/ 12201, // Rule ID 3469 //
        GIM_CheckFeatures, GIFBS_HasDQI,
        // (xor:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (KXORBrr:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KXORBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3469,
        GIR_Done,
      // Label 526: @12201
      GIM_Try, /*On fail goto*//*Label 527*/ 12275, // Rule ID 13360 //
        GIM_CheckFeatures, GIFBS_NoDQI,
        // (xor:{ *:[v8i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (COPY_TO_REGCLASS:{ *:[v8i1] } (KXORWrr:{ *:[v16i1] } (COPY_TO_REGCLASS:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src1, VK16:{ *:[i32] }), (COPY_TO_REGCLASS:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src2, VK16:{ *:[i32] })), VK8:{ *:[i32] })
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/1, /*TypeID*/GILLT_v16s1,
        GIR_MakeTempReg, /*TempRegID*/2, /*TypeID*/GILLT_v16s1,
        GIR_BuildMI, /*InsnID*/3, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/3, /*TempRegID*/2, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/3, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_ConstrainSelectedInstOperands, /*InsnID*/3,
        GIR_BuildMI, /*InsnID*/2, /*Opcode*/TargetOpcode::COPY,
        GIR_AddTempRegister, /*InsnID*/2, /*TempRegID*/1, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/2, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_ConstrainSelectedInstOperands, /*InsnID*/2,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::KXORWrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/1, /*TempRegFlags*/0,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/2, /*TempRegFlags*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK8*/12,
        // GIR_Coverage, 13360,
        GIR_Done,
      // Label 527: @12275
      GIM_Reject,
    // Label 525: @12276
    GIM_Reject,
    // Label 466: @12277
    GIM_Try, /*On fail goto*//*Label 528*/ 12357,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 529*/ 12310, // Rule ID 12226 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPXORrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12226,
        GIR_Done,
      // Label 529: @12310
      GIM_Try, /*On fail goto*//*Label 530*/ 12333, // Rule ID 12250 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PXORrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12250,
        GIR_Done,
      // Label 530: @12333
      GIM_Try, /*On fail goto*//*Label 531*/ 12356, // Rule ID 13775 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (xor:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPXORQZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13775,
        GIR_Done,
      // Label 531: @12356
      GIM_Reject,
    // Label 528: @12357
    GIM_Reject,
    // Label 467: @12358
    GIM_Try, /*On fail goto*//*Label 532*/ 12438,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 533*/ 12391, // Rule ID 4866 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (xor:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPXORDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4866,
        GIR_Done,
      // Label 533: @12391
      GIM_Try, /*On fail goto*//*Label 534*/ 12414, // Rule ID 12171 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPXORYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12171,
        GIR_Done,
      // Label 534: @12414
      GIM_Try, /*On fail goto*//*Label 535*/ 12437, // Rule ID 12197 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VXORPSYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VXORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12197,
        GIR_Done,
      // Label 535: @12437
      GIM_Reject,
    // Label 532: @12438
    GIM_Reject,
    // Label 468: @12439
    GIM_Try, /*On fail goto*//*Label 536*/ 12470, // Rule ID 4830 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (xor:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPXORQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4830,
      GIR_Done,
    // Label 536: @12470
    GIM_Reject,
    // Label 469: @12471
    GIM_Try, /*On fail goto*//*Label 537*/ 12502, // Rule ID 3470 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK16RegClassID,
      // (xor:{ *:[v16i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)  =>  (KXORWrr:{ *:[v16i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KXORWrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3470,
      GIR_Done,
    // Label 537: @12502
    GIM_Reject,
    // Label 470: @12503
    GIM_Try, /*On fail goto*//*Label 538*/ 12583,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 539*/ 12536, // Rule ID 12225 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPXORrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12225,
        GIR_Done,
      // Label 539: @12536
      GIM_Try, /*On fail goto*//*Label 540*/ 12559, // Rule ID 12249 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (xor:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PXORrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PXORrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12249,
        GIR_Done,
      // Label 540: @12559
      GIM_Try, /*On fail goto*//*Label 541*/ 12582, // Rule ID 13774 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (xor:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPXORQZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13774,
        GIR_Done,
      // Label 541: @12582
      GIM_Reject,
    // Label 538: @12583
    GIM_Reject,
    // Label 471: @12584
    GIM_Try, /*On fail goto*//*Label 542*/ 12664,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 543*/ 12617, // Rule ID 12170 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPXORYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12170,
        GIR_Done,
      // Label 543: @12617
      GIM_Try, /*On fail goto*//*Label 544*/ 12640, // Rule ID 12196 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VXORPSYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VXORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12196,
        GIR_Done,
      // Label 544: @12640
      GIM_Try, /*On fail goto*//*Label 545*/ 12663, // Rule ID 13799 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (xor:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPXORQZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13799,
        GIR_Done,
      // Label 545: @12663
      GIM_Reject,
    // Label 542: @12664
    GIM_Reject,
    // Label 472: @12665
    GIM_Try, /*On fail goto*//*Label 546*/ 12696, // Rule ID 4857 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (xor:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPXORDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4857,
      GIR_Done,
    // Label 546: @12696
    GIM_Reject,
    // Label 473: @12697
    GIM_Try, /*On fail goto*//*Label 547*/ 12728, // Rule ID 3471 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK32RegClassID,
      // (xor:{ *:[v32i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)  =>  (KXORDrr:{ *:[v32i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KXORDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3471,
      GIR_Done,
    // Label 547: @12728
    GIM_Reject,
    // Label 474: @12729
    GIM_Try, /*On fail goto*//*Label 548*/ 12809,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 549*/ 12762, // Rule ID 12169 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPXORYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12169,
        GIR_Done,
      // Label 549: @12762
      GIM_Try, /*On fail goto*//*Label 550*/ 12785, // Rule ID 12195 //
        GIM_CheckFeatures, GIFBS_HasAVX1Only,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (xor:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VXORPSYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VXORPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12195,
        GIR_Done,
      // Label 550: @12785
      GIM_Try, /*On fail goto*//*Label 551*/ 12808, // Rule ID 13798 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (xor:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPXORQZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13798,
        GIR_Done,
      // Label 551: @12808
      GIM_Reject,
    // Label 548: @12809
    GIM_Reject,
    // Label 475: @12810
    GIM_Try, /*On fail goto*//*Label 552*/ 12841, // Rule ID 13823 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (xor:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPXORQZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13823,
      GIR_Done,
    // Label 552: @12841
    GIM_Reject,
    // Label 476: @12842
    GIM_Try, /*On fail goto*//*Label 553*/ 12873, // Rule ID 3472 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s1,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK64RegClassID,
      // (xor:{ *:[v64i1] } VK64:{ *:[v64i1] }:$src1, VK64:{ *:[v64i1] }:$src2)  =>  (KXORQrr:{ *:[v64i1] } VK64:{ *:[v64i1] }:$src1, VK64:{ *:[v64i1] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::KXORQrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3472,
      GIR_Done,
    // Label 553: @12873
    GIM_Reject,
    // Label 477: @12874
    GIM_Try, /*On fail goto*//*Label 554*/ 12905, // Rule ID 13822 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (xor:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPXORQZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPXORQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13822,
      GIR_Done,
    // Label 554: @12905
    GIM_Reject,
    // Label 478: @12906
    GIM_Reject,
    // Label 6: @12907
    GIM_Try, /*On fail goto*//*Label 555*/ 13062,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/3,
      GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/16, 24, /*)*//*default:*//*Label 559*/ 13061,
      /*GILLT_v16s1*//*Label 556*/ 12926, 0, 0, 0,
      /*GILLT_v32s1*//*Label 557*/ 12971, 0, 0,
      /*GILLT_v64s1*//*Label 558*/ 13016,
      // Label 556: @12926
      GIM_Try, /*On fail goto*//*Label 560*/ 12970, // Rule ID 13364 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK16RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK8RegClassID,
        // (concat_vectors:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src1, VK8:{ *:[v8i1] }:$src2)  =>  (KUNPCKBWrr:{ *:[v16i1] } VK8:{ *:[v8i1] }:$src2, VK8:{ *:[v8i1] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::KUNPCKBWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13364,
        GIR_Done,
      // Label 560: @12970
      GIM_Reject,
      // Label 557: @12971
      GIM_Try, /*On fail goto*//*Label 561*/ 13015, // Rule ID 13365 //
        GIM_CheckFeatures, GIFBS_HasBWI,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK16RegClassID,
        // (concat_vectors:{ *:[v32i1] } VK16:{ *:[v16i1] }:$src1, VK16:{ *:[v16i1] }:$src2)  =>  (KUNPCKWDrr:{ *:[v32i1] } VK16:{ *:[v16i1] }:$src2, VK16:{ *:[v16i1] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::KUNPCKWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13365,
        GIR_Done,
      // Label 561: @13015
      GIM_Reject,
      // Label 558: @13016
      GIM_Try, /*On fail goto*//*Label 562*/ 13060, // Rule ID 13366 //
        GIM_CheckFeatures, GIFBS_HasBWI,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VK32RegClassID,
        // (concat_vectors:{ *:[v64i1] } VK32:{ *:[v32i1] }:$src1, VK32:{ *:[v32i1] }:$src2)  =>  (KUNPCKDQrr:{ *:[v64i1] } VK32:{ *:[v32i1] }:$src2, VK32:{ *:[v32i1] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::KUNPCKDQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 13366,
        GIR_Done,
      // Label 562: @13060
      GIM_Reject,
      // Label 559: @13061
      GIM_Reject,
    // Label 555: @13062
    GIM_Reject,
    // Label 7: @13063
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 24, /*)*//*default:*//*Label 567*/ 13462,
    /*GILLT_s32*//*Label 563*/ 13090,
    /*GILLT_s64*//*Label 564*/ 13252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    /*GILLT_v32s1*//*Label 565*/ 13414, 0, 0,
    /*GILLT_v64s1*//*Label 566*/ 13438,
    // Label 563: @13090
    GIM_Try, /*On fail goto*//*Label 568*/ 13113, // Rule ID 2059 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (bitconvert:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (VMOVDI2SSrr:{ *:[f32] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOVDI2SSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2059,
      GIR_Done,
    // Label 568: @13113
    GIM_Try, /*On fail goto*//*Label 569*/ 13136, // Rule ID 2060 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (bitconvert:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (MOVDI2SSrr:{ *:[f32] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVDI2SSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2060,
      GIR_Done,
    // Label 569: @13136
    GIM_Try, /*On fail goto*//*Label 570*/ 13159, // Rule ID 2069 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
      // (bitconvert:{ *:[i32] } FR32:{ *:[f32] }:$src)  =>  (VMOVSS2DIrr:{ *:[i32] } FR32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOVSS2DIrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2069,
      GIR_Done,
    // Label 570: @13159
    GIM_Try, /*On fail goto*//*Label 571*/ 13182, // Rule ID 2070 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
      // (bitconvert:{ *:[i32] } FR32:{ *:[f32] }:$src)  =>  (MOVSS2DIrr:{ *:[i32] } FR32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSS2DIrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2070,
      GIR_Done,
    // Label 571: @13182
    GIM_Try, /*On fail goto*//*Label 572*/ 13205, // Rule ID 3640 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (bitconvert:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (VMOVDI2SSZrr:{ *:[f32] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOVDI2SSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3640,
      GIR_Done,
    // Label 572: @13205
    GIM_Try, /*On fail goto*//*Label 573*/ 13228, // Rule ID 3645 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
      // (bitconvert:{ *:[i32] } FR32X:{ *:[f32] }:$src)  =>  (VMOVSS2DIZrr:{ *:[i32] } FR32X:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOVSS2DIZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3645,
      GIR_Done,
    // Label 573: @13228
    GIM_Try, /*On fail goto*//*Label 574*/ 13251, // Rule ID 13303 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      // (bitconvert:{ *:[i32] } VK32:{ *:[v32i1] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[i32] } VK32:{ *:[v32i1] }:$src, GR32:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR32*/33,
      // GIR_Coverage, 13303,
      GIR_Done,
    // Label 574: @13251
    GIM_Reject,
    // Label 564: @13252
    GIM_Try, /*On fail goto*//*Label 575*/ 13275, // Rule ID 2054 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (bitconvert:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (VMOV64toSDrr:{ *:[f64] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOV64toSDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2054,
      GIR_Done,
    // Label 575: @13275
    GIM_Try, /*On fail goto*//*Label 576*/ 13298, // Rule ID 2058 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (bitconvert:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (MOV64toSDrr:{ *:[f64] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOV64toSDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2058,
      GIR_Done,
    // Label 576: @13298
    GIM_Try, /*On fail goto*//*Label 577*/ 13321, // Rule ID 2067 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (bitconvert:{ *:[i64] } FR64:{ *:[f64] }:$src)  =>  (VMOVSDto64rr:{ *:[i64] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOVSDto64rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2067,
      GIR_Done,
    // Label 577: @13321
    GIM_Try, /*On fail goto*//*Label 578*/ 13344, // Rule ID 2068 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (bitconvert:{ *:[i64] } FR64:{ *:[f64] }:$src)  =>  (MOVSDto64rr:{ *:[i64] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSDto64rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2068,
      GIR_Done,
    // Label 578: @13344
    GIM_Try, /*On fail goto*//*Label 579*/ 13367, // Rule ID 3638 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (bitconvert:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (VMOV64toSDZrr:{ *:[f64] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOV64toSDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3638,
      GIR_Done,
    // Label 579: @13367
    GIM_Try, /*On fail goto*//*Label 580*/ 13390, // Rule ID 3639 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
      // (bitconvert:{ *:[i64] } FR64X:{ *:[f64] }:$src)  =>  (VMOVSDto64Zrr:{ *:[i64] } FR64X:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMOVSDto64Zrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 3639,
      GIR_Done,
    // Label 580: @13390
    GIM_Try, /*On fail goto*//*Label 581*/ 13413, // Rule ID 13305 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK64RegClassID,
      // (bitconvert:{ *:[i64] } VK64:{ *:[v64i1] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[i64] } VK64:{ *:[v64i1] }:$src, GR64:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR64*/65,
      // GIR_Coverage, 13305,
      GIR_Done,
    // Label 581: @13413
    GIM_Reject,
    // Label 565: @13414
    GIM_Try, /*On fail goto*//*Label 582*/ 13437, // Rule ID 13302 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (bitconvert:{ *:[v32i1] } GR32:{ *:[i32] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[v32i1] } GR32:{ *:[i32] }:$src, VK32:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK32*/37,
      // GIR_Coverage, 13302,
      GIR_Done,
    // Label 582: @13437
    GIM_Reject,
    // Label 566: @13438
    GIM_Try, /*On fail goto*//*Label 583*/ 13461, // Rule ID 13304 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VK64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (bitconvert:{ *:[v64i1] } GR64:{ *:[i64] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[v64i1] } GR64:{ *:[i64] }:$src, VK64:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC VK64*/78,
      // GIR_Coverage, 13304,
      GIR_Done,
    // Label 583: @13461
    GIM_Reject,
    // Label 567: @13462
    GIM_Reject,
    // Label 8: @13463
    GIM_Try, /*On fail goto*//*Label 584*/ 14565,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/3,
      GIM_Try, /*On fail goto*//*Label 585*/ 13508, // Rule ID 994 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphsubwd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6929:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src)  =>  (VPHSUBWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHSUBWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 994,
        GIR_Done,
      // Label 585: @13508
      GIM_Try, /*On fail goto*//*Label 586*/ 13548, // Rule ID 996 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphsubdq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6928:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src)  =>  (VPHSUBDQrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHSUBDQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 996,
        GIR_Done,
      // Label 586: @13548
      GIM_Try, /*On fail goto*//*Label 587*/ 13588, // Rule ID 998 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphsubbw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6927:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHSUBBWrr:{ *:[v8i16] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHSUBBWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 998,
        GIR_Done,
      // Label 587: @13588
      GIM_Try, /*On fail goto*//*Label 588*/ 13628, // Rule ID 1000 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddwq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6926:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src)  =>  (VPHADDWQrr:{ *:[v2i64] } VR128:{ *:[v8i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDWQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1000,
        GIR_Done,
      // Label 588: @13628
      GIM_Try, /*On fail goto*//*Label 589*/ 13668, // Rule ID 1002 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddwd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6925:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src)  =>  (VPHADDWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1002,
        GIR_Done,
      // Label 589: @13668
      GIM_Try, /*On fail goto*//*Label 590*/ 13708, // Rule ID 1004 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphadduwq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6924:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src)  =>  (VPHADDUWQrr:{ *:[v2i64] } VR128:{ *:[v8i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDUWQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1004,
        GIR_Done,
      // Label 590: @13708
      GIM_Try, /*On fail goto*//*Label 591*/ 13748, // Rule ID 1006 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphadduwd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6923:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src)  =>  (VPHADDUWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDUWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1006,
        GIR_Done,
      // Label 591: @13748
      GIM_Try, /*On fail goto*//*Label 592*/ 13788, // Rule ID 1008 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddudq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6922:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src)  =>  (VPHADDUDQrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDUDQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1008,
        GIR_Done,
      // Label 592: @13788
      GIM_Try, /*On fail goto*//*Label 593*/ 13828, // Rule ID 1010 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddubw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6921:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHADDUBWrr:{ *:[v8i16] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDUBWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1010,
        GIR_Done,
      // Label 593: @13828
      GIM_Try, /*On fail goto*//*Label 594*/ 13868, // Rule ID 1012 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddubq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6920:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHADDUBQrr:{ *:[v2i64] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDUBQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1012,
        GIR_Done,
      // Label 594: @13868
      GIM_Try, /*On fail goto*//*Label 595*/ 13908, // Rule ID 1014 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddubd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6919:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHADDUBDrr:{ *:[v4i32] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDUBDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1014,
        GIR_Done,
      // Label 595: @13908
      GIM_Try, /*On fail goto*//*Label 596*/ 13948, // Rule ID 1016 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphadddq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6918:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src)  =>  (VPHADDDQrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDDQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1016,
        GIR_Done,
      // Label 596: @13948
      GIM_Try, /*On fail goto*//*Label 597*/ 13988, // Rule ID 1018 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddbw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6917:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHADDBWrr:{ *:[v8i16] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDBWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1018,
        GIR_Done,
      // Label 597: @13988
      GIM_Try, /*On fail goto*//*Label 598*/ 14028, // Rule ID 1020 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddbq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6916:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHADDBQrr:{ *:[v2i64] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDBQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1020,
        GIR_Done,
      // Label 598: @14028
      GIM_Try, /*On fail goto*//*Label 599*/ 14068, // Rule ID 1022 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vphaddbd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6915:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src)  =>  (VPHADDBDrr:{ *:[v4i32] } VR128:{ *:[v16i8] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDBDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1022,
        GIR_Done,
      // Label 599: @14068
      GIM_Try, /*On fail goto*//*Label 600*/ 14108, // Rule ID 1024 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vfrcz_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6910:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src)  =>  (VFRCZSSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VFRCZSSrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1024,
        GIR_Done,
      // Label 600: @14108
      GIM_Try, /*On fail goto*//*Label 601*/ 14148, // Rule ID 1026 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vfrcz_ps,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6907:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src)  =>  (VFRCZPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VFRCZPSrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1026,
        GIR_Done,
      // Label 601: @14148
      GIM_Try, /*On fail goto*//*Label 602*/ 14188, // Rule ID 1028 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vfrcz_ps_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v8f32] } 6908:{ *:[iPTR] }, VR256:{ *:[v8f32] }:$src)  =>  (VFRCZPSYrr:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VFRCZPSYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1028,
        GIR_Done,
      // Label 602: @14188
      GIM_Try, /*On fail goto*//*Label 603*/ 14228, // Rule ID 1030 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vfrcz_sd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2f64] } 6909:{ *:[iPTR] }, VR128:{ *:[v2f64] }:$src)  =>  (VFRCZSDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VFRCZSDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1030,
        GIR_Done,
      // Label 603: @14228
      GIM_Try, /*On fail goto*//*Label 604*/ 14268, // Rule ID 1032 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vfrcz_pd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2f64] } 6905:{ *:[iPTR] }, VR128:{ *:[v2f64] }:$src)  =>  (VFRCZPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VFRCZPDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1032,
        GIR_Done,
      // Label 604: @14268
      GIM_Try, /*On fail goto*//*Label 605*/ 14308, // Rule ID 1034 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vfrcz_pd_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f64] } 6906:{ *:[iPTR] }, VR256:{ *:[v4f64] }:$src)  =>  (VFRCZPDYrr:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VFRCZPDYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1034,
        GIR_Done,
      // Label 605: @14308
      GIM_Try, /*On fail goto*//*Label 606*/ 14348, // Rule ID 2479 //
        GIM_CheckFeatures, GIFBS_HasAES_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesimc,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5831:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1)  =>  (VAESIMCrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESIMCrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2479,
        GIR_Done,
      // Label 606: @14348
      GIM_Try, /*On fail goto*//*Label 607*/ 14388, // Rule ID 2481 //
        GIM_CheckFeatures, GIFBS_HasAES_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesimc,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5831:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1)  =>  (AESIMCrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AESIMCrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2481,
        GIR_Done,
      // Label 607: @14388
      GIM_Try, /*On fail goto*//*Label 608*/ 14432, // Rule ID 12307 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse_rsqrt_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6727:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src)  =>  (RSQRTSSr_Int:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src, VR128:{ *:[v4f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RSQRTSSr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12307,
        GIR_Done,
      // Label 608: @14432
      GIM_Try, /*On fail goto*//*Label 609*/ 14476, // Rule ID 12309 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse_rsqrt_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6727:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src)  =>  (VRSQRTSSr_Int:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src, VR128:{ *:[v4f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VRSQRTSSr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12309,
        GIR_Done,
      // Label 609: @14476
      GIM_Try, /*On fail goto*//*Label 610*/ 14520, // Rule ID 12319 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse_rcp_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6725:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src)  =>  (RCPSSr_Int:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src, VR128:{ *:[v4f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RCPSSr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12319,
        GIR_Done,
      // Label 610: @14520
      GIM_Try, /*On fail goto*//*Label 611*/ 14564, // Rule ID 12321 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse_rcp_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6725:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src)  =>  (VRCPSSr_Int:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src, VR128:{ *:[v4f32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VRCPSSr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12321,
        GIR_Done,
      // Label 611: @14564
      GIM_Reject,
    // Label 584: @14565
    GIM_Try, /*On fail goto*//*Label 612*/ 17491,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/4,
      GIM_Try, /*On fail goto*//*Label 613*/ 14626, // Rule ID 2483 //
        GIM_CheckFeatures, GIFBS_HasAES_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aeskeygenassist,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/3, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5832:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (VAESKEYGENASSIST128rr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESKEYGENASSIST128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2483,
        GIR_Done,
      // Label 613: @14626
      GIM_Try, /*On fail goto*//*Label 614*/ 14682, // Rule ID 2485 //
        GIM_CheckFeatures, GIFBS_HasAES_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aeskeygenassist,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/3, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5832:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (AESKEYGENASSIST128rr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AESKEYGENASSIST128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2485,
        GIR_Done,
      // Label 614: @14682
      GIM_Try, /*On fail goto*//*Label 615*/ 14734, // Rule ID 82 //
        GIM_CheckFeatures, GIFBS_HasBMI2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_bmi_pdep_32,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR32RegClassID,
        // (intrinsic_wo_chain:{ *:[i32] } 6559:{ *:[iPTR] }, GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (PDEP32rr:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PDEP32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 82,
        GIR_Done,
      // Label 615: @14734
      GIM_Try, /*On fail goto*//*Label 616*/ 14786, // Rule ID 84 //
        GIM_CheckFeatures, GIFBS_HasBMI2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_bmi_pdep_64,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR64RegClassID,
        // (intrinsic_wo_chain:{ *:[i64] } 6560:{ *:[iPTR] }, GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (PDEP64rr:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PDEP64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 84,
        GIR_Done,
      // Label 616: @14786
      GIM_Try, /*On fail goto*//*Label 617*/ 14838, // Rule ID 86 //
        GIM_CheckFeatures, GIFBS_HasBMI2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_bmi_pext_32,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR32RegClassID,
        // (intrinsic_wo_chain:{ *:[i32] } 6561:{ *:[iPTR] }, GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (PEXT32rr:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PEXT32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 86,
        GIR_Done,
      // Label 617: @14838
      GIM_Try, /*On fail goto*//*Label 618*/ 14890, // Rule ID 88 //
        GIM_CheckFeatures, GIFBS_HasBMI2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_bmi_pext_64,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR64RegClassID,
        // (intrinsic_wo_chain:{ *:[i64] } 6562:{ *:[iPTR] }, GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (PEXT64rr:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PEXT64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 88,
        GIR_Done,
      // Label 618: @14890
      GIM_Try, /*On fail goto*//*Label 619*/ 14942, // Rule ID 2166 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_psign_b_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v16i8] } 6865:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPSIGNBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPSIGNBrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2166,
        GIR_Done,
      // Label 619: @14942
      GIM_Try, /*On fail goto*//*Label 620*/ 14994, // Rule ID 2168 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_psign_w_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6869:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPSIGNWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPSIGNWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2168,
        GIR_Done,
      // Label 620: @14994
      GIM_Try, /*On fail goto*//*Label 621*/ 15046, // Rule ID 2170 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_psign_d_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6867:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPSIGNDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPSIGNDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2170,
        GIR_Done,
      // Label 621: @15046
      GIM_Try, /*On fail goto*//*Label 622*/ 15098, // Rule ID 2172 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_phadd_sw_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6849:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPHADDSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDSWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2172,
        GIR_Done,
      // Label 622: @15098
      GIM_Try, /*On fail goto*//*Label 623*/ 15150, // Rule ID 2174 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_phsub_sw_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6855:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPHSUBSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHSUBSWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2174,
        GIR_Done,
      // Label 623: @15150
      GIM_Try, /*On fail goto*//*Label 624*/ 15202, // Rule ID 2190 //
        GIM_CheckFeatures, GIFBS_HasAVX2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx2_psign_b,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v32s8,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v32s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v32i8] } 5937:{ *:[iPTR] }, VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPSIGNBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPSIGNBYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2190,
        GIR_Done,
      // Label 624: @15202
      GIM_Try, /*On fail goto*//*Label 625*/ 15254, // Rule ID 2192 //
        GIM_CheckFeatures, GIFBS_HasAVX2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx2_psign_w,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v16i16] } 5939:{ *:[iPTR] }, VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPSIGNWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPSIGNWYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2192,
        GIR_Done,
      // Label 625: @15254
      GIM_Try, /*On fail goto*//*Label 626*/ 15306, // Rule ID 2194 //
        GIM_CheckFeatures, GIFBS_HasAVX2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx2_psign_d,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i32] } 5938:{ *:[iPTR] }, VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPSIGNDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPSIGNDYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2194,
        GIR_Done,
      // Label 626: @15306
      GIM_Try, /*On fail goto*//*Label 627*/ 15358, // Rule ID 2196 //
        GIM_CheckFeatures, GIFBS_HasAVX2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx2_phadd_sw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v16i16] } 5924:{ *:[iPTR] }, VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPHADDSWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHADDSWYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2196,
        GIR_Done,
      // Label 627: @15358
      GIM_Try, /*On fail goto*//*Label 628*/ 15410, // Rule ID 2198 //
        GIM_CheckFeatures, GIFBS_HasAVX2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx2_phsub_sw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v16i16] } 5927:{ *:[iPTR] }, VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPHSUBSWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPHSUBSWYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2198,
        GIR_Done,
      // Label 628: @15410
      GIM_Try, /*On fail goto*//*Label 629*/ 15462, // Rule ID 2208 //
        GIM_CheckFeatures, GIFBS_UseSSSE3,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_psign_b_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v16i8] } 6865:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PSIGNBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PSIGNBrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2208,
        GIR_Done,
      // Label 629: @15462
      GIM_Try, /*On fail goto*//*Label 630*/ 15514, // Rule ID 2210 //
        GIM_CheckFeatures, GIFBS_UseSSSE3,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_psign_w_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6869:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PSIGNWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PSIGNWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2210,
        GIR_Done,
      // Label 630: @15514
      GIM_Try, /*On fail goto*//*Label 631*/ 15566, // Rule ID 2212 //
        GIM_CheckFeatures, GIFBS_UseSSSE3,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_psign_d_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6867:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PSIGNDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PSIGNDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2212,
        GIR_Done,
      // Label 631: @15566
      GIM_Try, /*On fail goto*//*Label 632*/ 15618, // Rule ID 2216 //
        GIM_CheckFeatures, GIFBS_UseSSSE3,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_phadd_sw_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6849:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PHADDSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PHADDSWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2216,
        GIR_Done,
      // Label 632: @15618
      GIM_Try, /*On fail goto*//*Label 633*/ 15670, // Rule ID 2218 //
        GIM_CheckFeatures, GIFBS_UseSSSE3,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_ssse3_phsub_sw_128,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6855:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PHSUBSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PHSUBSWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2218,
        GIR_Done,
      // Label 633: @15670
      GIM_Try, /*On fail goto*//*Label 634*/ 15722, // Rule ID 2434 //
        GIM_CheckFeatures, GIFBS_HasSSE42,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse42_crc32_32_8,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR8RegClassID,
        // (intrinsic_wo_chain:{ *:[i32] } 6823:{ *:[iPTR] }, GR32:{ *:[i32] }:$src1, GR8:{ *:[i8] }:$src2)  =>  (CRC32r32r8:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR8:{ *:[i8] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::CRC32r32r8,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2434,
        GIR_Done,
      // Label 634: @15722
      GIM_Try, /*On fail goto*//*Label 635*/ 15774, // Rule ID 2436 //
        GIM_CheckFeatures, GIFBS_HasSSE42,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse42_crc32_32_16,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR16RegClassID,
        // (intrinsic_wo_chain:{ *:[i32] } 6821:{ *:[iPTR] }, GR32:{ *:[i32] }:$src1, GR16:{ *:[i16] }:$src2)  =>  (CRC32r32r16:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR16:{ *:[i16] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::CRC32r32r16,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2436,
        GIR_Done,
      // Label 635: @15774
      GIM_Try, /*On fail goto*//*Label 636*/ 15826, // Rule ID 2438 //
        GIM_CheckFeatures, GIFBS_HasSSE42,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse42_crc32_32_32,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR32RegClassID,
        // (intrinsic_wo_chain:{ *:[i32] } 6822:{ *:[iPTR] }, GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)  =>  (CRC32r32r32:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::CRC32r32r32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2438,
        GIR_Done,
      // Label 636: @15826
      GIM_Try, /*On fail goto*//*Label 637*/ 15878, // Rule ID 2440 //
        GIM_CheckFeatures, GIFBS_HasSSE42,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse42_crc32_64_64,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::GR64RegClassID,
        // (intrinsic_wo_chain:{ *:[i64] } 6824:{ *:[iPTR] }, GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)  =>  (CRC32r64r64:{ *:[i64] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::CRC32r64r64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2440,
        GIR_Done,
      // Label 637: @15878
      GIM_Try, /*On fail goto*//*Label 638*/ 15930, // Rule ID 2443 //
        GIM_CheckFeatures, GIFBS_HasSHA,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sha1nexte,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6693:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (SHA1NEXTErr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHA1NEXTErr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2443,
        GIR_Done,
      // Label 638: @15930
      GIM_Try, /*On fail goto*//*Label 639*/ 15982, // Rule ID 2445 //
        GIM_CheckFeatures, GIFBS_HasSHA,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sha1msg1,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6691:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (SHA1MSG1rr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHA1MSG1rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2445,
        GIR_Done,
      // Label 639: @15982
      GIM_Try, /*On fail goto*//*Label 640*/ 16034, // Rule ID 2447 //
        GIM_CheckFeatures, GIFBS_HasSHA,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sha1msg2,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6692:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (SHA1MSG2rr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHA1MSG2rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2447,
        GIR_Done,
      // Label 640: @16034
      GIM_Try, /*On fail goto*//*Label 641*/ 16086, // Rule ID 2451 //
        GIM_CheckFeatures, GIFBS_HasSHA,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sha256msg1,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6695:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (SHA256MSG1rr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHA256MSG1rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2451,
        GIR_Done,
      // Label 641: @16086
      GIM_Try, /*On fail goto*//*Label 642*/ 16138, // Rule ID 2453 //
        GIM_CheckFeatures, GIFBS_HasSHA,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sha256msg2,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6696:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (SHA256MSG2rr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHA256MSG2rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2453,
        GIR_Done,
      // Label 642: @16138
      GIM_Try, /*On fail goto*//*Label 643*/ 16190, // Rule ID 2455 //
        GIM_CheckFeatures, GIFBS_HasAES_HasAVX_NoVLX_Or_NoVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenc,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5825:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VAESENCrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2455,
        GIR_Done,
      // Label 643: @16190
      GIM_Try, /*On fail goto*//*Label 644*/ 16242, // Rule ID 2457 //
        GIM_CheckFeatures, GIFBS_HasAES_HasAVX_NoVLX_Or_NoVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenclast,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5828:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VAESENCLASTrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCLASTrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2457,
        GIR_Done,
      // Label 644: @16242
      GIM_Try, /*On fail goto*//*Label 645*/ 16294, // Rule ID 2459 //
        GIM_CheckFeatures, GIFBS_HasAES_HasAVX_NoVLX_Or_NoVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdec,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5819:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VAESDECrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2459,
        GIR_Done,
      // Label 645: @16294
      GIM_Try, /*On fail goto*//*Label 646*/ 16346, // Rule ID 2461 //
        GIM_CheckFeatures, GIFBS_HasAES_HasAVX_NoVLX_Or_NoVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdeclast,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5822:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (VAESDECLASTrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECLASTrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2461,
        GIR_Done,
      // Label 646: @16346
      GIM_Try, /*On fail goto*//*Label 647*/ 16398, // Rule ID 2463 //
        GIM_CheckFeatures, GIFBS_HasVAES_NoVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenc_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5826:{ *:[iPTR] }, VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VAESENCYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2463,
        GIR_Done,
      // Label 647: @16398
      GIM_Try, /*On fail goto*//*Label 648*/ 16450, // Rule ID 2465 //
        GIM_CheckFeatures, GIFBS_HasVAES_NoVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenclast_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5829:{ *:[iPTR] }, VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VAESENCLASTYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCLASTYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2465,
        GIR_Done,
      // Label 648: @16450
      GIM_Try, /*On fail goto*//*Label 649*/ 16502, // Rule ID 2467 //
        GIM_CheckFeatures, GIFBS_HasVAES_NoVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdec_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5820:{ *:[iPTR] }, VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VAESDECYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2467,
        GIR_Done,
      // Label 649: @16502
      GIM_Try, /*On fail goto*//*Label 650*/ 16554, // Rule ID 2469 //
        GIM_CheckFeatures, GIFBS_HasVAES_NoVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdeclast_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5823:{ *:[iPTR] }, VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)  =>  (VAESDECLASTYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECLASTYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2469,
        GIR_Done,
      // Label 650: @16554
      GIM_Try, /*On fail goto*//*Label 651*/ 16606, // Rule ID 2471 //
        GIM_CheckFeatures, GIFBS_HasAES_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenc,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5825:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (AESENCrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AESENCrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2471,
        GIR_Done,
      // Label 651: @16606
      GIM_Try, /*On fail goto*//*Label 652*/ 16658, // Rule ID 2473 //
        GIM_CheckFeatures, GIFBS_HasAES_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenclast,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5828:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (AESENCLASTrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AESENCLASTrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2473,
        GIR_Done,
      // Label 652: @16658
      GIM_Try, /*On fail goto*//*Label 653*/ 16710, // Rule ID 2475 //
        GIM_CheckFeatures, GIFBS_HasAES_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdec,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5819:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (AESDECrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AESDECrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2475,
        GIR_Done,
      // Label 653: @16710
      GIM_Try, /*On fail goto*//*Label 654*/ 16762, // Rule ID 2477 //
        GIM_CheckFeatures, GIFBS_HasAES_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdeclast,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5822:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)  =>  (AESDECLASTrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AESDECLASTrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2477,
        GIR_Done,
      // Label 654: @16762
      GIM_Try, /*On fail goto*//*Label 655*/ 16814, // Rule ID 2494 //
        GIM_CheckFeatures, GIFBS_HasSSE4A,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse4a_extrq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6839:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src, VR128:{ *:[v16i8] }:$mask)  =>  (EXTRQ:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src, VR128:{ *:[v16i8] }:$mask)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::EXTRQ,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // mask
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2494,
        GIR_Done,
      // Label 655: @16814
      GIM_Try, /*On fail goto*//*Label 656*/ 16866, // Rule ID 2496 //
        GIM_CheckFeatures, GIFBS_HasSSE4A,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse4a_insertq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6841:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src, VR128:{ *:[v2i64] }:$mask)  =>  (INSERTQ:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src, VR128:{ *:[v2i64] }:$mask)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INSERTQ,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // mask
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2496,
        GIR_Done,
      // Label 656: @16866
      GIM_Try, /*On fail goto*//*Label 657*/ 16918, // Rule ID 10742 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenc,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128XRegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5825:{ *:[iPTR] }, VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VAESENCZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCZ128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10742,
        GIR_Done,
      // Label 657: @16918
      GIM_Try, /*On fail goto*//*Label 658*/ 16970, // Rule ID 10744 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenc_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256XRegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5826:{ *:[iPTR] }, VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VAESENCZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10744,
        GIR_Done,
      // Label 658: @16970
      GIM_Try, /*On fail goto*//*Label 659*/ 17022, // Rule ID 10746 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenc_512,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR512RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i64] } 5827:{ *:[iPTR] }, VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VAESENCZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10746,
        GIR_Done,
      // Label 659: @17022
      GIM_Try, /*On fail goto*//*Label 660*/ 17074, // Rule ID 10748 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenclast,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128XRegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5828:{ *:[iPTR] }, VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VAESENCLASTZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCLASTZ128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10748,
        GIR_Done,
      // Label 660: @17074
      GIM_Try, /*On fail goto*//*Label 661*/ 17126, // Rule ID 10750 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenclast_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256XRegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5829:{ *:[iPTR] }, VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VAESENCLASTZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCLASTZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10750,
        GIR_Done,
      // Label 661: @17126
      GIM_Try, /*On fail goto*//*Label 662*/ 17178, // Rule ID 10752 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesenclast_512,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR512RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i64] } 5830:{ *:[iPTR] }, VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VAESENCLASTZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESENCLASTZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10752,
        GIR_Done,
      // Label 662: @17178
      GIM_Try, /*On fail goto*//*Label 663*/ 17230, // Rule ID 10754 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdec,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128XRegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5819:{ *:[iPTR] }, VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VAESDECZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECZ128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10754,
        GIR_Done,
      // Label 663: @17230
      GIM_Try, /*On fail goto*//*Label 664*/ 17282, // Rule ID 10756 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdec_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256XRegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5820:{ *:[iPTR] }, VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VAESDECZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10756,
        GIR_Done,
      // Label 664: @17282
      GIM_Try, /*On fail goto*//*Label 665*/ 17334, // Rule ID 10758 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdec_512,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR512RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i64] } 5821:{ *:[iPTR] }, VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VAESDECZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10758,
        GIR_Done,
      // Label 665: @17334
      GIM_Try, /*On fail goto*//*Label 666*/ 17386, // Rule ID 10760 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdeclast,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128XRegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 5822:{ *:[iPTR] }, VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VAESDECLASTZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECLASTZ128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10760,
        GIR_Done,
      // Label 666: @17386
      GIM_Try, /*On fail goto*//*Label 667*/ 17438, // Rule ID 10762 //
        GIM_CheckFeatures, GIFBS_HasVAES_HasVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdeclast_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256XRegClassID,
        // (intrinsic_wo_chain:{ *:[v4i64] } 5823:{ *:[iPTR] }, VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VAESDECLASTZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECLASTZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10762,
        GIR_Done,
      // Label 667: @17438
      GIM_Try, /*On fail goto*//*Label 668*/ 17490, // Rule ID 10764 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVAES,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_aesni_aesdeclast_512,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR512RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i64] } 5824:{ *:[iPTR] }, VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VAESDECLASTZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VAESDECLASTZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10764,
        GIR_Done,
      // Label 668: @17490
      GIM_Reject,
    // Label 612: @17491
    GIM_Try, /*On fail goto*//*Label 669*/ 19557,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/5,
      GIM_Try, /*On fail goto*//*Label 670*/ 17564, // Rule ID 1320 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse_cmp_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6700:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src, (imm:{ *:[i8] }):$cc)  =>  (VCMPSSrr_Int:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src, (imm:{ *:[i8] }):$cc)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCMPSSrr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // cc
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1320,
        GIR_Done,
      // Label 670: @17564
      GIM_Try, /*On fail goto*//*Label 671*/ 17632, // Rule ID 1322 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse2_cmp_sd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2f64] } 6738:{ *:[iPTR] }, VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src, (imm:{ *:[i8] }):$cc)  =>  (VCMPSDrr_Int:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src, (imm:{ *:[i8] }):$cc)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCMPSDrr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // cc
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1322,
        GIR_Done,
      // Label 671: @17632
      GIM_Try, /*On fail goto*//*Label 672*/ 17700, // Rule ID 1324 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse_cmp_ss,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6700:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src, (imm:{ *:[i8] }):$cc)  =>  (CMPSSrr_Int:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src, (imm:{ *:[i8] }):$cc)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::CMPSSrr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // cc
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1324,
        GIR_Done,
      // Label 672: @17700
      GIM_Try, /*On fail goto*//*Label 673*/ 17768, // Rule ID 1326 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse2_cmp_sd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2f64] } 6738:{ *:[iPTR] }, VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src, (imm:{ *:[i8] }):$cc)  =>  (CMPSDrr_Int:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src, (imm:{ *:[i8] }):$cc)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::CMPSDrr_Int,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // cc
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1326,
        GIR_Done,
      // Label 673: @17768
      GIM_Try, /*On fail goto*//*Label 674*/ 17836, // Rule ID 2375 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse41_mpsadbw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6810:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VMPSADBWrri:{ *:[v8i16] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VMPSADBWrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2375,
        GIR_Done,
      // Label 674: @17836
      GIM_Try, /*On fail goto*//*Label 675*/ 17904, // Rule ID 2377 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse41_dpps,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6808:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VDPPSrri:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VDPPSrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2377,
        GIR_Done,
      // Label 675: @17904
      GIM_Try, /*On fail goto*//*Label 676*/ 17972, // Rule ID 2379 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse41_dppd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2f64] } 6807:{ *:[iPTR] }, VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VDPPDrri:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VDPPDrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2379,
        GIR_Done,
      // Label 676: @17972
      GIM_Try, /*On fail goto*//*Label 677*/ 18040, // Rule ID 2381 //
        GIM_CheckFeatures, GIFBS_HasAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx_dp_ps_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v8f32] } 5844:{ *:[iPTR] }, VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VDPPSYrri:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VDPPSYrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2381,
        GIR_Done,
      // Label 677: @18040
      GIM_Try, /*On fail goto*//*Label 678*/ 18108, // Rule ID 2383 //
        GIM_CheckFeatures, GIFBS_HasAVX2,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_avx2_mpsadbw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v16s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v32s8,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v16i16] } 5913:{ *:[iPTR] }, VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VMPSADBWYrri:{ *:[v16i16] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VMPSADBWYrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2383,
        GIR_Done,
      // Label 678: @18108
      GIM_Try, /*On fail goto*//*Label 679*/ 18176, // Rule ID 2385 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse41_mpsadbw,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v16s8,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6810:{ *:[iPTR] }, VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (MPSADBWrri:{ *:[v8i16] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MPSADBWrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2385,
        GIR_Done,
      // Label 679: @18176
      GIM_Try, /*On fail goto*//*Label 680*/ 18244, // Rule ID 2387 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse41_dpps,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4f32] } 6808:{ *:[iPTR] }, VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (DPPSrri:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::DPPSrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2387,
        GIR_Done,
      // Label 680: @18244
      GIM_Try, /*On fail goto*//*Label 681*/ 18312, // Rule ID 2389 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sse41_dppd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2f64] } 6807:{ *:[iPTR] }, VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (DPPDrri:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::DPPDrri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2389,
        GIR_Done,
      // Label 681: @18312
      GIM_Try, /*On fail goto*//*Label 682*/ 18380, // Rule ID 2441 //
        GIM_CheckFeatures, GIFBS_HasSHA,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_sha1rnds4,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6694:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (SHA1RNDS4rri:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHA1RNDS4rri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2441,
        GIR_Done,
      // Label 682: @18380
      GIM_Try, /*On fail goto*//*Label 683*/ 18448, // Rule ID 2487 //
        GIM_CheckFeatures, GIFBS_HasPCLMUL_NoAVX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_pclmulqdq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6663:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (PCLMULQDQrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PCLMULQDQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2487,
        GIR_Done,
      // Label 683: @18448
      GIM_Try, /*On fail goto*//*Label 684*/ 18516, // Rule ID 2489 //
        GIM_CheckFeatures, GIFBS_HasAVX_HasPCLMUL_NoVLX_Or_NoVPCLMULQDQ,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_pclmulqdq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6663:{ *:[iPTR] }, VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VPCLMULQDQrr:{ *:[v2i64] } VR128:{ *:[v2i64] }:$src1, VR128:{ *:[v2i64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPCLMULQDQrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2489,
        GIR_Done,
      // Label 684: @18516
      GIM_Try, /*On fail goto*//*Label 685*/ 18584, // Rule ID 2491 //
        GIM_CheckFeatures, GIFBS_HasVPCLMULQDQ_NoVLX,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_pclmulqdq_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4i64] } 6664:{ *:[iPTR] }, VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VPCLMULQDQYrr:{ *:[v4i64] } VR256:{ *:[v4i64] }:$src1, VR256:{ *:[v4i64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPCLMULQDQYrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2491,
        GIR_Done,
      // Label 685: @18584
      GIM_Try, /*On fail goto*//*Label 686*/ 18652, // Rule ID 10766 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVPCLMULQDQ,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_pclmulqdq_512,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR512RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v8i64] } 6665:{ *:[iPTR] }, VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VPCLMULQDQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPCLMULQDQZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10766,
        GIR_Done,
      // Label 686: @18652
      GIM_Try, /*On fail goto*//*Label 687*/ 18720, // Rule ID 10768 //
        GIM_CheckFeatures, GIFBS_HasVLX_HasVPCLMULQDQ,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_pclmulqdq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128XRegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6663:{ *:[iPTR] }, VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VPCLMULQDQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPCLMULQDQZ128rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10768,
        GIR_Done,
      // Label 687: @18720
      GIM_Try, /*On fail goto*//*Label 688*/ 18788, // Rule ID 10770 //
        GIM_CheckFeatures, GIFBS_HasVLX_HasVPCLMULQDQ,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_pclmulqdq_256,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s64,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_s8,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR256XRegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/4, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_wo_chain:{ *:[v4i64] } 6664:{ *:[iPTR] }, VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2, (imm:{ *:[i8] }):$src3)  =>  (VPCLMULQDQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2, (imm:{ *:[i8] }):$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPCLMULQDQZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 10770,
        GIR_Done,
      // Label 688: @18788
      GIM_Try, /*On fail goto*//*Label 689*/ 18852, // Rule ID 1080 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmadcswd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6941:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)  =>  (VPMADCSWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMADCSWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1080,
        GIR_Done,
      // Label 689: @18852
      GIM_Try, /*On fail goto*//*Label 690*/ 18916, // Rule ID 1082 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmadcsswd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6940:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)  =>  (VPMADCSSWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMADCSSWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1082,
        GIR_Done,
      // Label 690: @18916
      GIM_Try, /*On fail goto*//*Label 691*/ 18980, // Rule ID 1084 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacsww,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6939:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v8i16] }:$src3)  =>  (VPMACSWWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v8i16] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSWWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1084,
        GIR_Done,
      // Label 691: @18980
      GIM_Try, /*On fail goto*//*Label 692*/ 19044, // Rule ID 1086 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacswd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6938:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)  =>  (VPMACSWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1086,
        GIR_Done,
      // Label 692: @19044
      GIM_Try, /*On fail goto*//*Label 693*/ 19108, // Rule ID 1088 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacssww,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v8s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v8i16] } 6937:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v8i16] }:$src3)  =>  (VPMACSSWWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v8i16] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSSWWrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1088,
        GIR_Done,
      // Label 693: @19108
      GIM_Try, /*On fail goto*//*Label 694*/ 19172, // Rule ID 1090 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacsswd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v8s16,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6936:{ *:[iPTR] }, VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)  =>  (VPMACSSWDrr:{ *:[v4i32] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSSWDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1090,
        GIR_Done,
      // Label 694: @19172
      GIM_Try, /*On fail goto*//*Label 695*/ 19236, // Rule ID 1092 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacssdql,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6935:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)  =>  (VPMACSSDQLrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSSDQLrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1092,
        GIR_Done,
      // Label 695: @19236
      GIM_Try, /*On fail goto*//*Label 696*/ 19300, // Rule ID 1094 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacssdqh,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6934:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)  =>  (VPMACSSDQHrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSSDQHrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1094,
        GIR_Done,
      // Label 696: @19300
      GIM_Try, /*On fail goto*//*Label 697*/ 19364, // Rule ID 1096 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacssdd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6933:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v4i32] }:$src3)  =>  (VPMACSSDDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSSDDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1096,
        GIR_Done,
      // Label 697: @19364
      GIM_Try, /*On fail goto*//*Label 698*/ 19428, // Rule ID 1098 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacsdql,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6932:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)  =>  (VPMACSDQLrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSDQLrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1098,
        GIR_Done,
      // Label 698: @19428
      GIM_Try, /*On fail goto*//*Label 699*/ 19492, // Rule ID 1100 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacsdqh,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v2s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v2s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v2i64] } 6931:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)  =>  (VPMACSDQHrr:{ *:[v2i64] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v2i64] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSDQHrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1100,
        GIR_Done,
      // Label 699: @19492
      GIM_Try, /*On fail goto*//*Label 700*/ 19556, // Rule ID 1102 //
        GIM_CheckFeatures, GIFBS_HasXOP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xop_vpmacsdd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_v4s32,
        GIM_CheckType, /*MI*/0, /*Op*/4, /*Type*/GILLT_v4s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/4, /*RC*/X86::VR128RegClassID,
        // (intrinsic_wo_chain:{ *:[v4i32] } 6930:{ *:[iPTR] }, VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v4i32] }:$src3)  =>  (VPMACSDDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2, VR128:{ *:[v4i32] }:$src3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMACSDDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/3, // src2
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/4, // src3
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1102,
        GIR_Done,
      // Label 700: @19556
      GIM_Reject,
    // Label 669: @19557
    GIM_Reject,
    // Label 9: @19558
    GIM_Try, /*On fail goto*//*Label 701*/ 19576, // Rule ID 1654 //
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_sse2_pause,
      // (intrinsic_void 6766:{ *:[iPTR] })  =>  (PAUSE)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PAUSE,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1654,
      GIR_Done,
    // Label 701: @19576
    GIM_Try, /*On fail goto*//*Label 702*/ 19596, // Rule ID 1655 //
      GIM_CheckFeatures, GIFBS_HasSSE1,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_sse_sfence,
      // (intrinsic_void 6728:{ *:[iPTR] })  =>  (SFENCE)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SFENCE,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1655,
      GIR_Done,
    // Label 702: @19596
    GIM_Try, /*On fail goto*//*Label 703*/ 19616, // Rule ID 1656 //
      GIM_CheckFeatures, GIFBS_HasSSE2,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_sse2_lfence,
      // (intrinsic_void 6755:{ *:[iPTR] })  =>  (LFENCE)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LFENCE,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1656,
      GIR_Done,
    // Label 703: @19616
    GIM_Try, /*On fail goto*//*Label 704*/ 19636, // Rule ID 1657 //
      GIM_CheckFeatures, GIFBS_HasMFence,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_sse2_mfence,
      // (intrinsic_void 6759:{ *:[iPTR] })  =>  (MFENCE)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MFENCE,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1657,
      GIR_Done,
    // Label 704: @19636
    GIM_Try, /*On fail goto*//*Label 705*/ 19656, // Rule ID 2529 //
      GIM_CheckFeatures, GIFBS_HasAVX,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_avx_vzeroall,
      // (intrinsic_void 5887:{ *:[iPTR] })  =>  (VZEROALL)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VZEROALL,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2529,
      GIR_Done,
    // Label 705: @19656
    GIM_Try, /*On fail goto*//*Label 706*/ 19676, // Rule ID 2530 //
      GIM_CheckFeatures, GIFBS_HasAVX,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_avx_vzeroupper,
      // (intrinsic_void 5888:{ *:[iPTR] })  =>  (VZEROUPPER)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VZEROUPPER,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2530,
      GIR_Done,
    // Label 706: @19676
    GIM_Try, /*On fail goto*//*Label 707*/ 19696, // Rule ID 11378 //
      GIM_CheckFeatures, GIFBS_HasMMX,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_mmx_emms,
      // (intrinsic_void 6589:{ *:[iPTR] })  =>  (MMX_EMMS:{ *:[x86mmx] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MMX_EMMS,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11378,
      GIR_Done,
    // Label 707: @19696
    GIM_Try, /*On fail goto*//*Label 708*/ 19716, // Rule ID 11597 //
      GIM_CheckFeatures, GIFBS_Has3DNow,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_mmx_femms,
      // (intrinsic_void 6590:{ *:[iPTR] })  =>  (FEMMS:{ *:[x86mmx] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::FEMMS,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11597,
      GIR_Done,
    // Label 708: @19716
    GIM_Try, /*On fail goto*//*Label 709*/ 19736, // Rule ID 11612 //
      GIM_CheckFeatures, GIFBS_HasRTM,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_xend,
      // (intrinsic_void 6903:{ *:[iPTR] })  =>  (XEND)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XEND,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11612,
      GIR_Done,
    // Label 709: @19736
    GIM_Try, /*On fail goto*//*Label 710*/ 19754, // Rule ID 11618 //
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_wbinvd,
      // (intrinsic_void 6890:{ *:[iPTR] })  =>  (WBINVD)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WBINVD,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11618,
      GIR_Done,
    // Label 710: @19754
    GIM_Try, /*On fail goto*//*Label 711*/ 19774, // Rule ID 11619 //
      GIM_CheckFeatures, GIFBS_HasWBNOINVD,
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_wbnoinvd,
      // (intrinsic_void 6891:{ *:[iPTR] })  =>  (WBNOINVD)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WBNOINVD,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11619,
      GIR_Done,
    // Label 711: @19774
    GIM_Try, /*On fail goto*//*Label 712*/ 19792, // Rule ID 11624 //
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_saveprevssp,
      // (intrinsic_void 6686:{ *:[iPTR] })  =>  (SAVEPREVSSP)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAVEPREVSSP,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11624,
      GIR_Done,
    // Label 712: @19792
    GIM_Try, /*On fail goto*//*Label 713*/ 19810, // Rule ID 11630 //
      GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_setssbsy,
      // (intrinsic_void 6690:{ *:[iPTR] })  =>  (SETSSBSY)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SETSSBSY,
      GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11630,
      GIR_Done,
    // Label 713: @19810
    GIM_Try, /*On fail goto*//*Label 714*/ 20710,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/2,
      GIM_Try, /*On fail goto*//*Label 715*/ 19841, // Rule ID 11616 //
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_int,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
        GIM_CheckConstantInt, /*MI*/0, /*Op*/1, 3,
        // (intrinsic_void 6582:{ *:[iPTR] }, 3:{ *:[i8] })  =>  (INT3)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INT3,
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11616,
        GIR_Done,
      // Label 715: @19841
      GIM_Try, /*On fail goto*//*Label 716*/ 19878, // Rule ID 11614 //
        GIM_CheckFeatures, GIFBS_HasRTM,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_xabort,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_void 6901:{ *:[iPTR] }, (imm:{ *:[i8] }):$imm)  =>  (XABORT (imm:{ *:[i8] }):$imm)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XABORT,
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // imm
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, 1, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11614,
        GIR_Done,
      // Label 716: @19878
      GIM_Try, /*On fail goto*//*Label 717*/ 19913, // Rule ID 11617 //
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_int,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_void 6582:{ *:[iPTR] }, (imm:{ *:[i8] }):$trap)  =>  (INT (imm:{ *:[i8] }):$trap)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INT,
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // trap
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, 1, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11617,
        GIR_Done,
      // Label 717: @19913
      GIM_Try, /*On fail goto*//*Label 718*/ 19945, // Rule ID 1 //
        GIM_CheckFeatures, GIFBS_Not64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_flags_read_u32,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6572:{ *:[iPTR] })  =>  (RDFLAGS32:{ *:[i32] }:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDFLAGS32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1,
        GIR_Done,
      // Label 718: @19945
      GIM_Try, /*On fail goto*//*Label 719*/ 19977, // Rule ID 2 //
        GIM_CheckFeatures, GIFBS_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_flags_read_u64,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        // (intrinsic_w_chain:{ *:[i64] } 6573:{ *:[iPTR] })  =>  (RDFLAGS64:{ *:[i64] }:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDFLAGS64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2,
        GIR_Done,
      // Label 719: @19977
      GIM_Try, /*On fail goto*//*Label 720*/ 20009, // Rule ID 95 //
        GIM_CheckFeatures, GIFBS_HasLWP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_slwpcb,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6698:{ *:[iPTR] })  =>  (SLWPCB:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SLWPCB,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 95,
        GIR_Done,
      // Label 720: @20009
      GIM_Try, /*On fail goto*//*Label 721*/ 20041, // Rule ID 97 //
        GIM_CheckFeatures, GIFBS_HasLWP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_slwpcb,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        // (intrinsic_w_chain:{ *:[i64] } 6698:{ *:[iPTR] })  =>  (SLWPCB64:{ *:[i64] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SLWPCB64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 97,
        GIR_Done,
      // Label 721: @20041
      GIM_Try, /*On fail goto*//*Label 722*/ 20073, // Rule ID 11611 //
        GIM_CheckFeatures, GIFBS_HasRTM,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_xbegin,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6902:{ *:[iPTR] })  =>  (XBEGIN:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::XBEGIN,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11611,
        GIR_Done,
      // Label 722: @20073
      GIM_Try, /*On fail goto*//*Label 723*/ 20105, // Rule ID 11647 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdfsbase_32,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6668:{ *:[iPTR] })  =>  (RDFSBASE:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDFSBASE,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11647,
        GIR_Done,
      // Label 723: @20105
      GIM_Try, /*On fail goto*//*Label 724*/ 20137, // Rule ID 11648 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdfsbase_64,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        // (intrinsic_w_chain:{ *:[i64] } 6669:{ *:[iPTR] })  =>  (RDFSBASE64:{ *:[i64] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDFSBASE64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11648,
        GIR_Done,
      // Label 724: @20137
      GIM_Try, /*On fail goto*//*Label 725*/ 20169, // Rule ID 11649 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdgsbase_32,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6670:{ *:[iPTR] })  =>  (RDGSBASE:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDGSBASE,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11649,
        GIR_Done,
      // Label 725: @20169
      GIM_Try, /*On fail goto*//*Label 726*/ 20201, // Rule ID 11650 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdgsbase_64,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        // (intrinsic_w_chain:{ *:[i64] } 6671:{ *:[iPTR] })  =>  (RDGSBASE64:{ *:[i64] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDGSBASE64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11650,
        GIR_Done,
      // Label 726: @20201
      GIM_Try, /*On fail goto*//*Label 727*/ 20233, // Rule ID 11656 //
        GIM_CheckFeatures, GIFBS_HasRDPID_Not64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdpid,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6672:{ *:[iPTR] })  =>  (RDPID32:{ *:[i32] })
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDPID32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11656,
        GIR_Done,
      // Label 727: @20233
      GIM_Try, /*On fail goto*//*Label 728*/ 20265, // Rule ID 3 //
        GIM_CheckFeatures, GIFBS_Not64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_flags_write_u32,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6574:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (WRFLAGS32:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WRFLAGS32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 3,
        GIR_Done,
      // Label 728: @20265
      GIM_Try, /*On fail goto*//*Label 729*/ 20297, // Rule ID 4 //
        GIM_CheckFeatures, GIFBS_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_flags_write_u64,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6575:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (WRFLAGS64:{ *:[i64] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WRFLAGS64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4,
        GIR_Done,
      // Label 729: @20297
      GIM_Try, /*On fail goto*//*Label 730*/ 20329, // Rule ID 94 //
        GIM_CheckFeatures, GIFBS_HasLWP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_llwpcb,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6584:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (LLWPCB GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LLWPCB,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 94,
        GIR_Done,
      // Label 730: @20329
      GIM_Try, /*On fail goto*//*Label 731*/ 20361, // Rule ID 96 //
        GIM_CheckFeatures, GIFBS_HasLWP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_llwpcb,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6584:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (LLWPCB64 GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LLWPCB64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 96,
        GIR_Done,
      // Label 731: @20361
      GIM_Try, /*On fail goto*//*Label 732*/ 20393, // Rule ID 107 //
        GIM_CheckFeatures, GIFBS_HasWAITPKG_Not64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_umonitor,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
        // (intrinsic_void 6875:{ *:[iPTR] }, GR16:{ *:[i16] }:$src)  =>  (UMONITOR16 GR16:{ *:[i16] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::UMONITOR16,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 107,
        GIR_Done,
      // Label 732: @20393
      GIM_Try, /*On fail goto*//*Label 733*/ 20425, // Rule ID 108 //
        GIM_CheckFeatures, GIFBS_HasWAITPKG,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_umonitor,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6875:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (UMONITOR32 GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::UMONITOR32,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 108,
        GIR_Done,
      // Label 733: @20425
      GIM_Try, /*On fail goto*//*Label 734*/ 20457, // Rule ID 109 //
        GIM_CheckFeatures, GIFBS_HasWAITPKG_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_umonitor,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6875:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (UMONITOR64 GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::UMONITOR64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 109,
        GIR_Done,
      // Label 734: @20457
      GIM_Try, /*On fail goto*//*Label 735*/ 20487, // Rule ID 11620 //
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_incsspd,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6580:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (INCSSPD GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INCSSPD,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11620,
        GIR_Done,
      // Label 735: @20487
      GIM_Try, /*On fail goto*//*Label 736*/ 20517, // Rule ID 11621 //
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_incsspq,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6581:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (INCSSPQ GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::INCSSPQ,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11621,
        GIR_Done,
      // Label 736: @20517
      GIM_Try, /*On fail goto*//*Label 737*/ 20549, // Rule ID 11651 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_wrfsbase_32,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6892:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (WRFSBASE GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WRFSBASE,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11651,
        GIR_Done,
      // Label 737: @20549
      GIM_Try, /*On fail goto*//*Label 738*/ 20581, // Rule ID 11652 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_wrfsbase_64,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6893:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (WRFSBASE64 GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WRFSBASE64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11652,
        GIR_Done,
      // Label 738: @20581
      GIM_Try, /*On fail goto*//*Label 739*/ 20613, // Rule ID 11653 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_wrgsbase_32,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6894:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (WRGSBASE GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WRGSBASE,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11653,
        GIR_Done,
      // Label 739: @20613
      GIM_Try, /*On fail goto*//*Label 740*/ 20645, // Rule ID 11654 //
        GIM_CheckFeatures, GIFBS_HasFSGSBase_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_wrgsbase_64,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6895:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (WRGSBASE64 GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::WRGSBASE64,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11654,
        GIR_Done,
      // Label 740: @20645
      GIM_Try, /*On fail goto*//*Label 741*/ 20677, // Rule ID 11659 //
        GIM_CheckFeatures, GIFBS_HasPTWRITE,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_ptwrite32,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        // (intrinsic_void 6666:{ *:[iPTR] }, GR32:{ *:[i32] }:$dst)  =>  (PTWRITEr GR32:{ *:[i32] }:$dst)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PTWRITEr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11659,
        GIR_Done,
      // Label 741: @20677
      GIM_Try, /*On fail goto*//*Label 742*/ 20709, // Rule ID 11660 //
        GIM_CheckFeatures, GIFBS_HasPTWRITE_In64BitMode,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_ptwrite64,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        // (intrinsic_void 6667:{ *:[iPTR] }, GR64:{ *:[i64] }:$dst)  =>  (PTWRITE64r GR64:{ *:[i64] }:$dst)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::PTWRITE64r,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // dst
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11660,
        GIR_Done,
      // Label 742: @20709
      GIM_Reject,
    // Label 714: @20710
    GIM_Try, /*On fail goto*//*Label 743*/ 20800,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/3,
      GIM_Try, /*On fail goto*//*Label 744*/ 20757, // Rule ID 11622 //
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdsspd,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        // (intrinsic_w_chain:{ *:[i32] } 6681:{ *:[iPTR] }, GR32:{ *:[i32] }:$src)  =>  (RDSSPD:{ *:[i32] } GR32:{ *:[i32] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDSSPD,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11622,
        GIR_Done,
      // Label 744: @20757
      GIM_Try, /*On fail goto*//*Label 745*/ 20799, // Rule ID 11623 //
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/1, Intrinsic::x86_rdsspq,
        GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR64RegClassID,
        // (intrinsic_w_chain:{ *:[i64] } 6682:{ *:[iPTR] }, GR64:{ *:[i64] }:$src)  =>  (RDSSPQ:{ *:[i64] } GR64:{ *:[i64] }:$src)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::RDSSPQ,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 11623,
        GIR_Done,
      // Label 745: @20799
      GIM_Reject,
    // Label 743: @20800
    GIM_Try, /*On fail goto*//*Label 746*/ 20928,
      GIM_CheckNumOperands, /*MI*/0, /*Expected*/4,
      GIM_Try, /*On fail goto*//*Label 747*/ 20866, // Rule ID 102 //
        GIM_CheckFeatures, GIFBS_HasLWP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_lwpval32,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/3, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_void 6587:{ *:[iPTR] }, GR32:{ *:[i32] }:$src0, GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$cntl)  =>  (LWPVAL32rri GR32:{ *:[i32] }:$src0, GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$cntl)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LWPVAL32rri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src0
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // cntl
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, 1, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 102,
        GIR_Done,
      // Label 747: @20866
      GIM_Try, /*On fail goto*//*Label 748*/ 20927, // Rule ID 104 //
        GIM_CheckFeatures, GIFBS_HasLWP,
        GIM_CheckIntrinsicID, /*MI*/0, /*Op*/0, Intrinsic::x86_lwpval64,
        GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
        GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::GR32RegClassID,
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/3, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (intrinsic_void 6588:{ *:[iPTR] }, GR64:{ *:[i64] }:$src0, GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$cntl)  =>  (LWPVAL64rri GR64:{ *:[i64] }:$src0, GR32:{ *:[i32] }:$src1, (imm:{ *:[i32] }):$cntl)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LWPVAL64rri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src0
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/2, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // cntl
        GIR_MergeMemOperands, /*InsnID*/0, /*MergeInsnID's*/0, 1, GIU_MergeMemOperands_EndOfList,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 104,
        GIR_Done,
      // Label 748: @20927
      GIM_Reject,
    // Label 746: @20928
    GIM_Reject,
    // Label 10: @20929
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 25, /*)*//*default:*//*Label 762*/ 21474,
    /*GILLT_s32*//*Label 749*/ 20957, 0, 0, 0, 0,
    /*GILLT_v2s64*//*Label 750*/ 21069, 0,
    /*GILLT_v4s32*//*Label 751*/ 21093,
    /*GILLT_v4s64*//*Label 752*/ 21117, 0,
    /*GILLT_v8s16*//*Label 753*/ 21141,
    /*GILLT_v8s32*//*Label 754*/ 21204,
    /*GILLT_v8s64*//*Label 755*/ 21228, 0,
    /*GILLT_v16s8*//*Label 756*/ 21252,
    /*GILLT_v16s16*//*Label 757*/ 21315,
    /*GILLT_v16s32*//*Label 758*/ 21378, 0,
    /*GILLT_v32s8*//*Label 759*/ 21402,
    /*GILLT_v32s16*//*Label 760*/ 21426, 0,
    /*GILLT_v64s8*//*Label 761*/ 21450,
    // Label 749: @20957
    GIM_Try, /*On fail goto*//*Label 763*/ 21002, // Rule ID 13299 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
      GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_BITCAST,
      GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_CheckIsSafeToFold, /*InsnID*/1,
      // (anyext:{ *:[i32] } (bitconvert:{ *:[i16] } VK16:{ *:[v16i1] }:$src))  =>  (COPY_TO_REGCLASS:{ *:[i32] } VK16:{ *:[v16i1] }:$src, GR32:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR32*/33,
      // GIR_Coverage, 13299,
      GIR_Done,
    // Label 763: @21002
    GIM_Try, /*On fail goto*//*Label 764*/ 21047, // Rule ID 13301 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
      GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_BITCAST,
      GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_CheckIsSafeToFold, /*InsnID*/1,
      // (anyext:{ *:[i32] } (bitconvert:{ *:[i8] } VK8:{ *:[v8i1] }:$src))  =>  (COPY_TO_REGCLASS:{ *:[i32] } VK8:{ *:[v8i1] }:$src, GR32:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR32*/33,
      // GIR_Coverage, 13301,
      GIR_Done,
    // Label 764: @21047
    GIM_Try, /*On fail goto*//*Label 765*/ 21068, // Rule ID 15804 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      // (anyext:{ *:[i32] } GR8:{ *:[i8] }:$src)  =>  (MOVZX32rr8:{ *:[i32] } GR8:{ *:[i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVZX32rr8,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15804,
      GIR_Done,
    // Label 765: @21068
    GIM_Reject,
    // Label 750: @21069
    GIM_Try, /*On fail goto*//*Label 766*/ 21092, // Rule ID 15168 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK2RegClassID,
      // (anyext:{ *:[v2i64] } VK2:{ *:[v2i1] }:$src)  =>  (VPMOVM2QZ128rr:{ *:[v2i64] } VK2:{ *:[v2i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2QZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15168,
      GIR_Done,
    // Label 766: @21092
    GIM_Reject,
    // Label 751: @21093
    GIM_Try, /*On fail goto*//*Label 767*/ 21116, // Rule ID 15165 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      // (anyext:{ *:[v4i32] } VK4:{ *:[v4i1] }:$src)  =>  (VPMOVM2DZ128rr:{ *:[v4i32] } VK4:{ *:[v4i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2DZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15165,
      GIR_Done,
    // Label 767: @21116
    GIM_Reject,
    // Label 752: @21117
    GIM_Try, /*On fail goto*//*Label 768*/ 21140, // Rule ID 15167 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      // (anyext:{ *:[v4i64] } VK4:{ *:[v4i1] }:$src)  =>  (VPMOVM2QZ256rr:{ *:[v4i64] } VK4:{ *:[v4i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2QZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15167,
      GIR_Done,
    // Label 768: @21140
    GIM_Reject,
    // Label 753: @21141
    GIM_Try, /*On fail goto*//*Label 769*/ 21203,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_Try, /*On fail goto*//*Label 770*/ 21166, // Rule ID 15162 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        // (anyext:{ *:[v8i16] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVM2WZ128rr:{ *:[v8i16] } VK8:{ *:[v8i1] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2WZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15162,
        GIR_Done,
      // Label 770: @21166
      GIM_Try, /*On fail goto*//*Label 771*/ 21202, // Rule ID 15182 //
        GIM_CheckFeatures, GIFBS_HasDQI_HasVLX_NoBWI,
        // (anyext:{ *:[v8i16] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVDWZ256rr:{ *:[v8i16] } (VPMOVM2DZ256rr:{ *:[v8i32] } VK8:{ *:[v8i1] }:$src))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v8s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVM2DZ256rr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDWZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15182,
        GIR_Done,
      // Label 771: @21202
      GIM_Reject,
    // Label 769: @21203
    GIM_Reject,
    // Label 754: @21204
    GIM_Try, /*On fail goto*//*Label 772*/ 21227, // Rule ID 15164 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      // (anyext:{ *:[v8i32] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVM2DZ256rr:{ *:[v8i32] } VK8:{ *:[v8i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2DZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15164,
      GIR_Done,
    // Label 772: @21227
    GIM_Reject,
    // Label 755: @21228
    GIM_Try, /*On fail goto*//*Label 773*/ 21251, // Rule ID 15166 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      // (anyext:{ *:[v8i64] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVM2QZrr:{ *:[v8i64] } VK8:{ *:[v8i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2QZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15166,
      GIR_Done,
    // Label 773: @21251
    GIM_Reject,
    // Label 756: @21252
    GIM_Try, /*On fail goto*//*Label 774*/ 21314,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_Try, /*On fail goto*//*Label 775*/ 21277, // Rule ID 15159 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        // (anyext:{ *:[v16i8] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVM2BZ128rr:{ *:[v16i8] } VK16:{ *:[v16i1] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2BZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15159,
        GIR_Done,
      // Label 775: @21277
      GIM_Try, /*On fail goto*//*Label 776*/ 21313, // Rule ID 15179 //
        GIM_CheckFeatures, GIFBS_HasDQI_NoBWI,
        // (anyext:{ *:[v16i8] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVDBZrr:{ *:[v16i8] } (VPMOVM2DZrr:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVM2DZrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDBZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15179,
        GIR_Done,
      // Label 776: @21313
      GIM_Reject,
    // Label 774: @21314
    GIM_Reject,
    // Label 757: @21315
    GIM_Try, /*On fail goto*//*Label 777*/ 21377,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_Try, /*On fail goto*//*Label 778*/ 21340, // Rule ID 15161 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        // (anyext:{ *:[v16i16] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVM2WZ256rr:{ *:[v16i16] } VK16:{ *:[v16i1] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2WZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15161,
        GIR_Done,
      // Label 778: @21340
      GIM_Try, /*On fail goto*//*Label 779*/ 21376, // Rule ID 15180 //
        GIM_CheckFeatures, GIFBS_HasDQI_NoBWI,
        // (anyext:{ *:[v16i16] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVDWZrr:{ *:[v16i16] } (VPMOVM2DZrr:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVM2DZrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDWZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15180,
        GIR_Done,
      // Label 779: @21376
      GIM_Reject,
    // Label 777: @21377
    GIM_Reject,
    // Label 758: @21378
    GIM_Try, /*On fail goto*//*Label 780*/ 21401, // Rule ID 15163 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      // (anyext:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVM2DZrr:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2DZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15163,
      GIR_Done,
    // Label 780: @21401
    GIM_Reject,
    // Label 759: @21402
    GIM_Try, /*On fail goto*//*Label 781*/ 21425, // Rule ID 15158 //
      GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      // (anyext:{ *:[v32i8] } VK32:{ *:[v32i1] }:$src)  =>  (VPMOVM2BZ256rr:{ *:[v32i8] } VK32:{ *:[v32i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2BZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15158,
      GIR_Done,
    // Label 781: @21425
    GIM_Reject,
    // Label 760: @21426
    GIM_Try, /*On fail goto*//*Label 782*/ 21449, // Rule ID 15160 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      // (anyext:{ *:[v32i16] } VK32:{ *:[v32i1] }:$src)  =>  (VPMOVM2WZrr:{ *:[v32i16] } VK32:{ *:[v32i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2WZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15160,
      GIR_Done,
    // Label 782: @21449
    GIM_Reject,
    // Label 761: @21450
    GIM_Try, /*On fail goto*//*Label 783*/ 21473, // Rule ID 15157 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK64RegClassID,
      // (anyext:{ *:[v64i8] } VK64:{ *:[v64i1] }:$src)  =>  (VPMOVM2BZrr:{ *:[v64i8] } VK64:{ *:[v64i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2BZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15157,
      GIR_Done,
    // Label 783: @21473
    GIM_Reject,
    // Label 762: @21474
    GIM_Reject,
    // Label 11: @21475
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 22, /*)*//*default:*//*Label 792*/ 21857,
    /*GILLT_s8*//*Label 784*/ 21502,
    /*GILLT_s16*//*Label 785*/ 21581, 0, 0, 0, 0, 0, 0, 0,
    /*GILLT_v4s32*//*Label 786*/ 21619, 0, 0,
    /*GILLT_v8s16*//*Label 787*/ 21643,
    /*GILLT_v8s32*//*Label 788*/ 21690, 0, 0,
    /*GILLT_v16s8*//*Label 789*/ 21714,
    /*GILLT_v16s16*//*Label 790*/ 21809, 0, 0,
    /*GILLT_v32s8*//*Label 791*/ 21833,
    // Label 784: @21502
    GIM_Try, /*On fail goto*//*Label 793*/ 21541, // Rule ID 15858 //
      GIM_CheckFeatures, GIFBS_In64BitMode,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (trunc:{ *:[i8] } GR32:{ *:[i32] }:$src)  =>  (EXTRACT_SUBREG:{ *:[i8] } GR32:{ *:[i32] }:$src, sub_8bit:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopySubReg, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, /*SubRegIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR8*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/1, /*RC GR32*/33,
      // GIR_Coverage, 15858,
      GIR_Done,
    // Label 793: @21541
    GIM_Try, /*On fail goto*//*Label 794*/ 21580, // Rule ID 15859 //
      GIM_CheckFeatures, GIFBS_In64BitMode,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      // (trunc:{ *:[i8] } GR16:{ *:[i16] }:$src)  =>  (EXTRACT_SUBREG:{ *:[i8] } GR16:{ *:[i16] }:$src, sub_8bit:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopySubReg, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, /*SubRegIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR8*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/1, /*RC GR16*/6,
      // GIR_Coverage, 15859,
      GIR_Done,
    // Label 794: @21580
    GIM_Reject,
    // Label 785: @21581
    GIM_Try, /*On fail goto*//*Label 795*/ 21618, // Rule ID 15852 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (trunc:{ *:[i16] } GR32:{ *:[i32] }:$src)  =>  (EXTRACT_SUBREG:{ *:[i16] } GR32:{ *:[i32] }:$src, sub_16bit:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopySubReg, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, /*SubRegIdx*/4, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC GR16*/6,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/1, /*RC GR32*/33,
      // GIR_Coverage, 15852,
      GIR_Done,
    // Label 795: @21618
    GIM_Reject,
    // Label 786: @21619
    GIM_Try, /*On fail goto*//*Label 796*/ 21642, // Rule ID 9079 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (trunc:{ *:[v4i32] } VR256X:{ *:[v4i64] }:$src)  =>  (VPMOVQDZ256rr:{ *:[v4i32] } VR256X:{ *:[v4i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVQDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9079,
      GIR_Done,
    // Label 796: @21642
    GIM_Reject,
    // Label 787: @21643
    GIM_Try, /*On fail goto*//*Label 797*/ 21666, // Rule ID 9055 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (trunc:{ *:[v8i16] } VR512:{ *:[v8i64] }:$src)  =>  (VPMOVQWZrr:{ *:[v8i16] } VR512:{ *:[v8i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVQWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9055,
      GIR_Done,
    // Label 797: @21666
    GIM_Try, /*On fail goto*//*Label 798*/ 21689, // Rule ID 9133 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (trunc:{ *:[v8i16] } VR256X:{ *:[v8i32] }:$src)  =>  (VPMOVDWZ256rr:{ *:[v8i16] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVDWZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9133,
      GIR_Done,
    // Label 798: @21689
    GIM_Reject,
    // Label 788: @21690
    GIM_Try, /*On fail goto*//*Label 799*/ 21713, // Rule ID 9082 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (trunc:{ *:[v8i32] } VR512:{ *:[v8i64] }:$src)  =>  (VPMOVQDZrr:{ *:[v8i32] } VR512:{ *:[v8i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVQDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9082,
      GIR_Done,
    // Label 799: @21713
    GIM_Reject,
    // Label 789: @21714
    GIM_Try, /*On fail goto*//*Label 800*/ 21737, // Rule ID 9109 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (trunc:{ *:[v16i8] } VR512:{ *:[v16i32] }:$src)  =>  (VPMOVDBZrr:{ *:[v16i8] } VR512:{ *:[v16i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVDBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9109,
      GIR_Done,
    // Label 800: @21737
    GIM_Try, /*On fail goto*//*Label 801*/ 21760, // Rule ID 9160 //
      GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (trunc:{ *:[v16i8] } VR256X:{ *:[v16i16] }:$src)  =>  (VPMOVWBZ256rr:{ *:[v16i8] } VR256X:{ *:[v16i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVWBZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9160,
      GIR_Done,
    // Label 801: @21760
    GIM_Try, /*On fail goto*//*Label 802*/ 21808, // Rule ID 15155 //
      GIM_CheckFeatures, GIFBS_HasAVX512_NoBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (trunc:{ *:[v16i8] } VR256X:{ *:[v16i16] }:$src)  =>  (VPMOVDBZrr:{ *:[v16i8] } (VPMOVZXWDZrr:{ *:[v16i32] } VR256X:{ *:[v16i16] }:$src))
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVZXWDZrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDBZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15155,
      GIR_Done,
    // Label 802: @21808
    GIM_Reject,
    // Label 790: @21809
    GIM_Try, /*On fail goto*//*Label 803*/ 21832, // Rule ID 9136 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (trunc:{ *:[v16i16] } VR512:{ *:[v16i32] }:$src)  =>  (VPMOVDWZrr:{ *:[v16i16] } VR512:{ *:[v16i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVDWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9136,
      GIR_Done,
    // Label 803: @21832
    GIM_Reject,
    // Label 791: @21833
    GIM_Try, /*On fail goto*//*Label 804*/ 21856, // Rule ID 9163 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (trunc:{ *:[v32i8] } VR512:{ *:[v32i16] }:$src)  =>  (VPMOVWBZrr:{ *:[v32i8] } VR512:{ *:[v32i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVWBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9163,
      GIR_Done,
    // Label 804: @21856
    GIM_Reject,
    // Label 792: @21857
    GIM_Reject,
    // Label 12: @21858
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 5, /*)*//*default:*//*Label 809*/ 22060,
    /*GILLT_s8*//*Label 805*/ 21868,
    /*GILLT_s16*//*Label 806*/ 21890,
    /*GILLT_s32*//*Label 807*/ 21912,
    /*GILLT_s64*//*Label 808*/ 22009,
    // Label 805: @21868
    GIM_Try, /*On fail goto*//*Label 810*/ 21889, // Rule ID 19 //
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (imm:{ *:[i8] }):$src  =>  (MOV8ri:{ *:[i8] } (imm:{ *:[i8] }):$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV8ri,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/0, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 19,
      GIR_Done,
    // Label 810: @21889
    GIM_Reject,
    // Label 806: @21890
    GIM_Try, /*On fail goto*//*Label 811*/ 21911, // Rule ID 20 //
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (imm:{ *:[i16] }):$src  =>  (MOV16ri:{ *:[i16] } (imm:{ *:[i16] }):$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV16ri,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/0, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 20,
      GIR_Done,
    // Label 811: @21911
    GIM_Reject,
    // Label 807: @21912
    GIM_Try, /*On fail goto*//*Label 812*/ 21934, // Rule ID 11678 //
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      // MIs[0] Operand 1
      GIM_CheckLiteralInt, /*MI*/0, /*Op*/1, 0,
      // 0:{ *:[i32] }  =>  (MOV32r0:{ *:[i32] }:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV32r0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11678,
      GIR_Done,
    // Label 812: @21934
    GIM_Try, /*On fail goto*//*Label 813*/ 21958, // Rule ID 11679 //
      GIM_CheckFeatures, GIFBS_Not64BitMode_OptForSize,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      // MIs[0] Operand 1
      GIM_CheckLiteralInt, /*MI*/0, /*Op*/1, 1,
      // 1:{ *:[i32] }  =>  (MOV32r1:{ *:[i32] }:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV32r1,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11679,
      GIR_Done,
    // Label 813: @21958
    GIM_Try, /*On fail goto*//*Label 814*/ 21982, // Rule ID 11680 //
      GIM_CheckFeatures, GIFBS_Not64BitMode_OptForSize,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      // MIs[0] Operand 1
      GIM_CheckLiteralInt, /*MI*/0, /*Op*/1, -1,
      // -1:{ *:[i32] }  =>  (MOV32r_1:{ *:[i32] }:{ *:[i32] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV32r_1,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11680,
      GIR_Done,
    // Label 814: @21982
    GIM_Try, /*On fail goto*//*Label 815*/ 22008, // Rule ID 11681 //
      GIM_CheckFeatures, GIFBS_NotWin64WithoutFP_OptForMinSize,
      GIM_CheckI64ImmPredicate, /*MI*/0, /*Predicate*/GIPFP_I64_Predicate_i32immSExt8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (imm:{ *:[i32] })<<P:Predicate_i32immSExt8>>:$src  =>  (MOV32ImmSExti8:{ *:[i32] } (imm:{ *:[i32] }):$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV32ImmSExti8,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/0, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11681,
      GIR_Done,
    // Label 815: @22008
    GIM_Reject,
    // Label 808: @22009
    GIM_Try, /*On fail goto*//*Label 816*/ 22035, // Rule ID 11682 //
      GIM_CheckFeatures, GIFBS_NotWin64WithoutFP_OptForMinSize,
      GIM_CheckI64ImmPredicate, /*MI*/0, /*Predicate*/GIPFP_I64_Predicate_i64immSExt8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (imm:{ *:[i64] })<<P:Predicate_i64immSExt8>>:$src  =>  (MOV64ImmSExti8:{ *:[i64] } (imm:{ *:[i64] }):$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV64ImmSExti8,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/0, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11682,
      GIR_Done,
    // Label 816: @22035
    GIM_Try, /*On fail goto*//*Label 817*/ 22059, // Rule ID 22 //
      GIM_CheckI64ImmPredicate, /*MI*/0, /*Predicate*/GIPFP_I64_Predicate_i64immSExt32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (imm:{ *:[i64] })<<P:Predicate_i64immSExt32>>:$src  =>  (MOV64ri32:{ *:[i64] } (imm:{ *:[i64] }):$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::MOV64ri32,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/0, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 22,
      GIR_Done,
    // Label 817: @22059
    GIM_Reject,
    // Label 809: @22060
    GIM_Reject,
    // Label 13: @22061
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 6, /*)*//*default:*//*Label 821*/ 22253,
    /*GILLT_s32*//*Label 818*/ 22070,
    /*GILLT_s64*//*Label 819*/ 22117,
    /*GILLT_s80*//*Label 820*/ 22210,
    // Label 818: @22070
    GIM_Try, /*On fail goto*//*Label 822*/ 22093, // Rule ID 752 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm0,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f32] })<<P:Predicate_fpimm0>>  =>  (LD_Fp032:{ *:[f32] }:{ *:[i16] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LD_Fp032,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 752,
      GIR_Done,
    // Label 822: @22093
    GIM_Try, /*On fail goto*//*Label 823*/ 22116, // Rule ID 753 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f32] })<<P:Predicate_fpimm1>>  =>  (LD_Fp132:{ *:[f32] }:{ *:[i16] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LD_Fp132,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 753,
      GIR_Done,
    // Label 823: @22116
    GIM_Reject,
    // Label 819: @22117
    GIM_Try, /*On fail goto*//*Label 824*/ 22140, // Rule ID 754 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm0,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f64] })<<P:Predicate_fpimm0>>  =>  (LD_Fp064:{ *:[f64] }:{ *:[i16] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LD_Fp064,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 754,
      GIR_Done,
    // Label 824: @22140
    GIM_Try, /*On fail goto*//*Label 825*/ 22163, // Rule ID 755 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f64] })<<P:Predicate_fpimm1>>  =>  (LD_Fp164:{ *:[f64] }:{ *:[i16] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LD_Fp164,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 755,
      GIR_Done,
    // Label 825: @22163
    GIM_Try, /*On fail goto*//*Label 826*/ 22186, // Rule ID 1142 //
      GIM_CheckFeatures, GIFBS_HasSSE2_NoAVX512,
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm0,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f64] })<<P:Predicate_fpimm0>>  =>  (FsFLD0SD:{ *:[f64] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::FsFLD0SD,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1142,
      GIR_Done,
    // Label 826: @22186
    GIM_Try, /*On fail goto*//*Label 827*/ 22209, // Rule ID 2636 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm0,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f64] })<<P:Predicate_fpimm0>>  =>  (AVX512_FsFLD0SD:{ *:[f64] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::AVX512_FsFLD0SD,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 2636,
      GIR_Done,
    // Label 827: @22209
    GIM_Reject,
    // Label 820: @22210
    GIM_Try, /*On fail goto*//*Label 828*/ 22231, // Rule ID 756 //
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm0,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f80] })<<P:Predicate_fpimm0>>  =>  (LD_Fp080:{ *:[f80] }:{ *:[i16] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LD_Fp080,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 756,
      GIR_Done,
    // Label 828: @22231
    GIM_Try, /*On fail goto*//*Label 829*/ 22252, // Rule ID 757 //
      GIM_CheckAPFloatImmPredicate, /*MI*/0, /*Predicate*/GIPFP_APFloat_Predicate_fpimm1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      // MIs[0] Operand 1
      // No operand predicates
      // (fpimm:{ *:[f80] })<<P:Predicate_fpimm1>>  =>  (LD_Fp180:{ *:[f80] }:{ *:[i16] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::LD_Fp180,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 757,
      GIR_Done,
    // Label 829: @22252
    GIM_Reject,
    // Label 821: @22253
    GIM_Reject,
    // Label 14: @22254
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 25, /*)*//*default:*//*Label 844*/ 23058,
    /*GILLT_s32*//*Label 830*/ 22282,
    /*GILLT_s64*//*Label 831*/ 22325, 0, 0, 0,
    /*GILLT_v2s64*//*Label 832*/ 22391, 0,
    /*GILLT_v4s32*//*Label 833*/ 22415,
    /*GILLT_v4s64*//*Label 834*/ 22439, 0,
    /*GILLT_v8s16*//*Label 835*/ 22509,
    /*GILLT_v8s32*//*Label 836*/ 22572,
    /*GILLT_v8s64*//*Label 837*/ 22642, 0,
    /*GILLT_v16s8*//*Label 838*/ 22712,
    /*GILLT_v16s16*//*Label 839*/ 22775,
    /*GILLT_v16s32*//*Label 840*/ 22893, 0,
    /*GILLT_v32s8*//*Label 841*/ 22963,
    /*GILLT_v32s16*//*Label 842*/ 22987, 0,
    /*GILLT_v64s8*//*Label 843*/ 23034,
    // Label 830: @22282
    GIM_Try, /*On fail goto*//*Label 845*/ 22303, // Rule ID 408 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      // (sext:{ *:[i32] } GR8:{ *:[i8] }:$src)  =>  (MOVSX32rr8:{ *:[i32] } GR8:{ *:[i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSX32rr8,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 408,
      GIR_Done,
    // Label 845: @22303
    GIM_Try, /*On fail goto*//*Label 846*/ 22324, // Rule ID 410 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      // (sext:{ *:[i32] } GR16:{ *:[i16] }:$src)  =>  (MOVSX32rr16:{ *:[i32] } GR16:{ *:[i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSX32rr16,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 410,
      GIR_Done,
    // Label 846: @22324
    GIM_Reject,
    // Label 831: @22325
    GIM_Try, /*On fail goto*//*Label 847*/ 22346, // Rule ID 416 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      // (sext:{ *:[i64] } GR8:{ *:[i8] }:$src)  =>  (MOVSX64rr8:{ *:[i64] } GR8:{ *:[i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSX64rr8,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 416,
      GIR_Done,
    // Label 847: @22346
    GIM_Try, /*On fail goto*//*Label 848*/ 22367, // Rule ID 418 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      // (sext:{ *:[i64] } GR16:{ *:[i16] }:$src)  =>  (MOVSX64rr16:{ *:[i64] } GR16:{ *:[i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSX64rr16,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 418,
      GIR_Done,
    // Label 848: @22367
    GIM_Try, /*On fail goto*//*Label 849*/ 22390, // Rule ID 420 //
      GIM_CheckFeatures, GIFBS_In64BitMode,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sext:{ *:[i64] } GR32:{ *:[i32] }:$src)  =>  (MOVSX64rr32:{ *:[i64] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVSX64rr32,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 420,
      GIR_Done,
    // Label 849: @22390
    GIM_Reject,
    // Label 832: @22391
    GIM_Try, /*On fail goto*//*Label 850*/ 22414, // Rule ID 9459 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK2RegClassID,
      // (sext:{ *:[v2i64] } VK2:{ *:[v2i1] }:$src)  =>  (VPMOVM2QZ128rr:{ *:[v2i64] } VK2:{ *:[v2i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2QZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9459,
      GIR_Done,
    // Label 850: @22414
    GIM_Reject,
    // Label 833: @22415
    GIM_Try, /*On fail goto*//*Label 851*/ 22438, // Rule ID 9456 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      // (sext:{ *:[v4i32] } VK4:{ *:[v4i1] }:$src)  =>  (VPMOVM2DZ128rr:{ *:[v4i32] } VK4:{ *:[v4i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2DZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9456,
      GIR_Done,
    // Label 851: @22438
    GIM_Reject,
    // Label 834: @22439
    GIM_Try, /*On fail goto*//*Label 852*/ 22462, // Rule ID 9388 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sext:{ *:[v4i64] } VR128X:{ *:[v4i32] }:$src)  =>  (VPMOVSXDQZ256rr:{ *:[v4i64] } VR128X:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXDQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9388,
      GIR_Done,
    // Label 852: @22462
    GIM_Try, /*On fail goto*//*Label 853*/ 22485, // Rule ID 9458 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK4RegClassID,
      // (sext:{ *:[v4i64] } VK4:{ *:[v4i1] }:$src)  =>  (VPMOVM2QZ256rr:{ *:[v4i64] } VK4:{ *:[v4i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2QZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9458,
      GIR_Done,
    // Label 853: @22485
    GIM_Try, /*On fail goto*//*Label 854*/ 22508, // Rule ID 12392 //
      GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
      // (sext:{ *:[v4i64] } VR128:{ *:[v4i32] }:$src)  =>  (VPMOVSXDQYrr:{ *:[v4i64] } VR128:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXDQYrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12392,
      GIR_Done,
    // Label 854: @22508
    GIM_Reject,
    // Label 835: @22509
    GIM_Try, /*On fail goto*//*Label 855*/ 22571,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_Try, /*On fail goto*//*Label 856*/ 22534, // Rule ID 9453 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        // (sext:{ *:[v8i16] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVM2WZ128rr:{ *:[v8i16] } VK8:{ *:[v8i1] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2WZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 9453,
        GIR_Done,
      // Label 856: @22534
      GIM_Try, /*On fail goto*//*Label 857*/ 22570, // Rule ID 15181 //
        GIM_CheckFeatures, GIFBS_HasDQI_HasVLX_NoBWI,
        // (sext:{ *:[v8i16] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVDWZ256rr:{ *:[v8i16] } (VPMOVM2DZ256rr:{ *:[v8i32] } VK8:{ *:[v8i1] }:$src))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v8s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVM2DZ256rr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDWZ256rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15181,
        GIR_Done,
      // Label 857: @22570
      GIM_Reject,
    // Label 855: @22571
    GIM_Reject,
    // Label 836: @22572
    GIM_Try, /*On fail goto*//*Label 858*/ 22595, // Rule ID 9352 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sext:{ *:[v8i32] } VR128X:{ *:[v8i16] }:$src)  =>  (VPMOVSXWDZ256rr:{ *:[v8i32] } VR128X:{ *:[v8i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXWDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9352,
      GIR_Done,
    // Label 858: @22595
    GIM_Try, /*On fail goto*//*Label 859*/ 22618, // Rule ID 9455 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      // (sext:{ *:[v8i32] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVM2DZ256rr:{ *:[v8i32] } VK8:{ *:[v8i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2DZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9455,
      GIR_Done,
    // Label 859: @22618
    GIM_Try, /*On fail goto*//*Label 860*/ 22641, // Rule ID 12390 //
      GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
      // (sext:{ *:[v8i32] } VR128:{ *:[v8i16] }:$src)  =>  (VPMOVSXWDYrr:{ *:[v8i32] } VR128:{ *:[v8i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXWDYrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12390,
      GIR_Done,
    // Label 860: @22641
    GIM_Reject,
    // Label 837: @22642
    GIM_Try, /*On fail goto*//*Label 861*/ 22665, // Rule ID 9376 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sext:{ *:[v8i64] } VR128X:{ *:[v8i16] }:$src)  =>  (VPMOVSXWQZrr:{ *:[v8i64] } VR128X:{ *:[v8i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXWQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9376,
      GIR_Done,
    // Label 861: @22665
    GIM_Try, /*On fail goto*//*Label 862*/ 22688, // Rule ID 9394 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sext:{ *:[v8i64] } VR256X:{ *:[v8i32] }:$src)  =>  (VPMOVSXDQZrr:{ *:[v8i64] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXDQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9394,
      GIR_Done,
    // Label 862: @22688
    GIM_Try, /*On fail goto*//*Label 863*/ 22711, // Rule ID 9457 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK8RegClassID,
      // (sext:{ *:[v8i64] } VK8:{ *:[v8i1] }:$src)  =>  (VPMOVM2QZrr:{ *:[v8i64] } VK8:{ *:[v8i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2QZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9457,
      GIR_Done,
    // Label 863: @22711
    GIM_Reject,
    // Label 838: @22712
    GIM_Try, /*On fail goto*//*Label 864*/ 22774,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_Try, /*On fail goto*//*Label 865*/ 22737, // Rule ID 9450 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        // (sext:{ *:[v16i8] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVM2BZ128rr:{ *:[v16i8] } VK16:{ *:[v16i1] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2BZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 9450,
        GIR_Done,
      // Label 865: @22737
      GIM_Try, /*On fail goto*//*Label 866*/ 22773, // Rule ID 15177 //
        GIM_CheckFeatures, GIFBS_HasDQI_NoBWI,
        // (sext:{ *:[v16i8] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVDBZrr:{ *:[v16i8] } (VPMOVM2DZrr:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src))
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVM2DZrr,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDBZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15177,
        GIR_Done,
      // Label 866: @22773
      GIM_Reject,
    // Label 864: @22774
    GIM_Reject,
    // Label 839: @22775
    GIM_Try, /*On fail goto*//*Label 867*/ 22798, // Rule ID 9298 //
      GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sext:{ *:[v16i16] } VR128X:{ *:[v16i8] }:$src)  =>  (VPMOVSXBWZ256rr:{ *:[v16i16] } VR128X:{ *:[v16i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXBWZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9298,
      GIR_Done,
    // Label 867: @22798
    GIM_Try, /*On fail goto*//*Label 868*/ 22821, // Rule ID 9452 //
      GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      // (sext:{ *:[v16i16] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVM2WZ256rr:{ *:[v16i16] } VK16:{ *:[v16i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2WZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9452,
      GIR_Done,
    // Label 868: @22821
    GIM_Try, /*On fail goto*//*Label 869*/ 22844, // Rule ID 12387 //
      GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
      // (sext:{ *:[v16i16] } VR128:{ *:[v16i8] }:$src)  =>  (VPMOVSXBWYrr:{ *:[v16i16] } VR128:{ *:[v16i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXBWYrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12387,
      GIR_Done,
    // Label 869: @22844
    GIM_Try, /*On fail goto*//*Label 870*/ 22892, // Rule ID 15178 //
      GIM_CheckFeatures, GIFBS_HasDQI_NoBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      // (sext:{ *:[v16i16] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVDWZrr:{ *:[v16i16] } (VPMOVM2DZrr:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src))
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_v16s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/X86::VPMOVM2DZrr,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_Copy, /*NewInsnID*/1, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VPMOVDWZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 15178,
      GIR_Done,
    // Label 870: @22892
    GIM_Reject,
    // Label 840: @22893
    GIM_Try, /*On fail goto*//*Label 871*/ 22916, // Rule ID 9322 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sext:{ *:[v16i32] } VR128X:{ *:[v16i8] }:$src)  =>  (VPMOVSXBDZrr:{ *:[v16i32] } VR128X:{ *:[v16i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXBDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9322,
      GIR_Done,
    // Label 871: @22916
    GIM_Try, /*On fail goto*//*Label 872*/ 22939, // Rule ID 9358 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sext:{ *:[v16i32] } VR256X:{ *:[v16i16] }:$src)  =>  (VPMOVSXWDZrr:{ *:[v16i32] } VR256X:{ *:[v16i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXWDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9358,
      GIR_Done,
    // Label 872: @22939
    GIM_Try, /*On fail goto*//*Label 873*/ 22962, // Rule ID 9454 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK16RegClassID,
      // (sext:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src)  =>  (VPMOVM2DZrr:{ *:[v16i32] } VK16:{ *:[v16i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2DZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9454,
      GIR_Done,
    // Label 873: @22962
    GIM_Reject,
    // Label 841: @22963
    GIM_Try, /*On fail goto*//*Label 874*/ 22986, // Rule ID 9449 //
      GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      // (sext:{ *:[v32i8] } VK32:{ *:[v32i1] }:$src)  =>  (VPMOVM2BZ256rr:{ *:[v32i8] } VK32:{ *:[v32i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2BZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9449,
      GIR_Done,
    // Label 874: @22986
    GIM_Reject,
    // Label 842: @22987
    GIM_Try, /*On fail goto*//*Label 875*/ 23010, // Rule ID 9304 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sext:{ *:[v32i16] } VR256X:{ *:[v32i8] }:$src)  =>  (VPMOVSXBWZrr:{ *:[v32i16] } VR256X:{ *:[v32i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVSXBWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9304,
      GIR_Done,
    // Label 875: @23010
    GIM_Try, /*On fail goto*//*Label 876*/ 23033, // Rule ID 9451 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK32RegClassID,
      // (sext:{ *:[v32i16] } VK32:{ *:[v32i1] }:$src)  =>  (VPMOVM2WZrr:{ *:[v32i16] } VK32:{ *:[v32i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2WZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9451,
      GIR_Done,
    // Label 876: @23033
    GIM_Reject,
    // Label 843: @23034
    GIM_Try, /*On fail goto*//*Label 877*/ 23057, // Rule ID 9448 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s1,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VK64RegClassID,
      // (sext:{ *:[v64i8] } VK64:{ *:[v64i1] }:$src)  =>  (VPMOVM2BZrr:{ *:[v64i8] } VK64:{ *:[v64i1] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVM2BZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9448,
      GIR_Done,
    // Label 877: @23057
    GIM_Reject,
    // Label 844: @23058
    GIM_Reject,
    // Label 15: @23059
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 23, /*)*//*default:*//*Label 885*/ 23472,
    /*GILLT_s32*//*Label 878*/ 23085, 0, 0, 0, 0, 0, 0, 0,
    /*GILLT_v4s64*//*Label 879*/ 23216, 0, 0,
    /*GILLT_v8s32*//*Label 880*/ 23262,
    /*GILLT_v8s64*//*Label 881*/ 23308, 0, 0,
    /*GILLT_v16s16*//*Label 882*/ 23355,
    /*GILLT_v16s32*//*Label 883*/ 23401, 0, 0,
    /*GILLT_v32s16*//*Label 884*/ 23448,
    // Label 878: @23085
    GIM_Try, /*On fail goto*//*Label 886*/ 23128, // Rule ID 13298 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
      GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_BITCAST,
      GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v16s1,
      GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK16RegClassID,
      GIM_CheckIsSafeToFold, /*InsnID*/1,
      // (zext:{ *:[i32] } (bitconvert:{ *:[i16] } VK16:{ *:[v16i1] }:$src))  =>  (KMOVWrk:{ *:[i32] } VK16:{ *:[v16i1] }:$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::KMOVWrk,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13298,
      GIR_Done,
    // Label 886: @23128
    GIM_Try, /*On fail goto*//*Label 887*/ 23173, // Rule ID 13300 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
      GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_BITCAST,
      GIM_CheckType, /*MI*/1, /*Op*/1, /*Type*/GILLT_v8s1,
      GIM_CheckRegBankForClass, /*MI*/1, /*Op*/1, /*RC*/X86::VK8RegClassID,
      GIM_CheckIsSafeToFold, /*InsnID*/1,
      // (zext:{ *:[i32] } (bitconvert:{ *:[i8] } VK8:{ *:[v8i1] }:$src))  =>  (KMOVBrk:{ *:[i32] } VK8:{ *:[v8i1] }:$src)
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::KMOVBrk,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 13300,
      GIR_Done,
    // Label 887: @23173
    GIM_Try, /*On fail goto*//*Label 888*/ 23194, // Rule ID 412 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      // (zext:{ *:[i32] } GR8:{ *:[i8] }:$src)  =>  (MOVZX32rr8:{ *:[i32] } GR8:{ *:[i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVZX32rr8,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 412,
      GIR_Done,
    // Label 888: @23194
    GIM_Try, /*On fail goto*//*Label 889*/ 23215, // Rule ID 414 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      // (zext:{ *:[i32] } GR16:{ *:[i16] }:$src)  =>  (MOVZX32rr16:{ *:[i32] } GR16:{ *:[i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MOVZX32rr16,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 414,
      GIR_Done,
    // Label 889: @23215
    GIM_Reject,
    // Label 879: @23216
    GIM_Try, /*On fail goto*//*Label 890*/ 23261,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 891*/ 23241, // Rule ID 9280 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        // (zext:{ *:[v4i64] } VR128X:{ *:[v4i32] }:$src)  =>  (VPMOVZXDQZ256rr:{ *:[v4i64] } VR128X:{ *:[v4i32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXDQZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 9280,
        GIR_Done,
      // Label 891: @23241
      GIM_Try, /*On fail goto*//*Label 892*/ 23260, // Rule ID 12413 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (zext:{ *:[v4i64] } VR128:{ *:[v4i32] }:$src)  =>  (VPMOVZXDQYrr:{ *:[v4i64] } VR128:{ *:[v4i32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXDQYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12413,
        GIR_Done,
      // Label 892: @23260
      GIM_Reject,
    // Label 890: @23261
    GIM_Reject,
    // Label 880: @23262
    GIM_Try, /*On fail goto*//*Label 893*/ 23307,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 894*/ 23287, // Rule ID 9244 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        // (zext:{ *:[v8i32] } VR128X:{ *:[v8i16] }:$src)  =>  (VPMOVZXWDZ256rr:{ *:[v8i32] } VR128X:{ *:[v8i16] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXWDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 9244,
        GIR_Done,
      // Label 894: @23287
      GIM_Try, /*On fail goto*//*Label 895*/ 23306, // Rule ID 12411 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (zext:{ *:[v8i32] } VR128:{ *:[v8i16] }:$src)  =>  (VPMOVZXWDYrr:{ *:[v8i32] } VR128:{ *:[v8i16] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXWDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12411,
        GIR_Done,
      // Label 895: @23306
      GIM_Reject,
    // Label 893: @23307
    GIM_Reject,
    // Label 881: @23308
    GIM_Try, /*On fail goto*//*Label 896*/ 23331, // Rule ID 9268 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (zext:{ *:[v8i64] } VR128X:{ *:[v8i16] }:$src)  =>  (VPMOVZXWQZrr:{ *:[v8i64] } VR128X:{ *:[v8i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXWQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9268,
      GIR_Done,
    // Label 896: @23331
    GIM_Try, /*On fail goto*//*Label 897*/ 23354, // Rule ID 9286 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (zext:{ *:[v8i64] } VR256X:{ *:[v8i32] }:$src)  =>  (VPMOVZXDQZrr:{ *:[v8i64] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXDQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9286,
      GIR_Done,
    // Label 897: @23354
    GIM_Reject,
    // Label 882: @23355
    GIM_Try, /*On fail goto*//*Label 898*/ 23400,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 899*/ 23380, // Rule ID 9190 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        // (zext:{ *:[v16i16] } VR128X:{ *:[v16i8] }:$src)  =>  (VPMOVZXBWZ256rr:{ *:[v16i16] } VR128X:{ *:[v16i8] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXBWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 9190,
        GIR_Done,
      // Label 899: @23380
      GIM_Try, /*On fail goto*//*Label 900*/ 23399, // Rule ID 12408 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (zext:{ *:[v16i16] } VR128:{ *:[v16i8] }:$src)  =>  (VPMOVZXBWYrr:{ *:[v16i16] } VR128:{ *:[v16i8] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXBWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12408,
        GIR_Done,
      // Label 900: @23399
      GIM_Reject,
    // Label 898: @23400
    GIM_Reject,
    // Label 883: @23401
    GIM_Try, /*On fail goto*//*Label 901*/ 23424, // Rule ID 9214 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (zext:{ *:[v16i32] } VR128X:{ *:[v16i8] }:$src)  =>  (VPMOVZXBDZrr:{ *:[v16i32] } VR128X:{ *:[v16i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXBDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9214,
      GIR_Done,
    // Label 901: @23424
    GIM_Try, /*On fail goto*//*Label 902*/ 23447, // Rule ID 9250 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (zext:{ *:[v16i32] } VR256X:{ *:[v16i16] }:$src)  =>  (VPMOVZXWDZrr:{ *:[v16i32] } VR256X:{ *:[v16i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXWDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9250,
      GIR_Done,
    // Label 902: @23447
    GIM_Reject,
    // Label 884: @23448
    GIM_Try, /*On fail goto*//*Label 903*/ 23471, // Rule ID 9196 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (zext:{ *:[v32i16] } VR256X:{ *:[v32i8] }:$src)  =>  (VPMOVZXBWZrr:{ *:[v32i16] } VR256X:{ *:[v32i8] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMOVZXBWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 9196,
      GIR_Done,
    // Label 903: @23471
    GIM_Reject,
    // Label 885: @23472
    GIM_Reject,
    // Label 16: @23473
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 5, /*)*//*default:*//*Label 908*/ 23787,
    /*GILLT_s8*//*Label 904*/ 23483,
    /*GILLT_s16*//*Label 905*/ 23559,
    /*GILLT_s32*//*Label 906*/ 23635,
    /*GILLT_s64*//*Label 907*/ 23711,
    // Label 904: @23483
    GIM_Try, /*On fail goto*//*Label 909*/ 23558,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 910*/ 23527, // Rule ID 15874 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (shl:{ *:[i8] } GR8:{ *:[i8] }:$src1, 1:{ *:[i8] })  =>  (ADD8rr:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, GR8:{ *:[i8] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD8rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15874,
        GIR_Done,
      // Label 910: @23527
      GIM_Try, /*On fail goto*//*Label 911*/ 23557, // Rule ID 456 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (shl:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHL8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHL8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 456,
        GIR_Done,
      // Label 911: @23557
      GIM_Reject,
    // Label 909: @23558
    GIM_Reject,
    // Label 905: @23559
    GIM_Try, /*On fail goto*//*Label 912*/ 23634,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 913*/ 23603, // Rule ID 15875 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (shl:{ *:[i16] } GR16:{ *:[i16] }:$src1, 1:{ *:[i8] })  =>  (ADD16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, GR16:{ *:[i16] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD16rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15875,
        GIR_Done,
      // Label 913: @23603
      GIM_Try, /*On fail goto*//*Label 914*/ 23633, // Rule ID 457 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (shl:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHL16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHL16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 457,
        GIR_Done,
      // Label 914: @23633
      GIM_Reject,
    // Label 912: @23634
    GIM_Reject,
    // Label 906: @23635
    GIM_Try, /*On fail goto*//*Label 915*/ 23710,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      GIM_Try, /*On fail goto*//*Label 916*/ 23679, // Rule ID 15876 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (shl:{ *:[i32] } GR32:{ *:[i32] }:$src1, 1:{ *:[i8] })  =>  (ADD32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, GR32:{ *:[i32] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD32rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15876,
        GIR_Done,
      // Label 916: @23679
      GIM_Try, /*On fail goto*//*Label 917*/ 23709, // Rule ID 458 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (shl:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHL32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHL32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 458,
        GIR_Done,
      // Label 917: @23709
      GIM_Reject,
    // Label 915: @23710
    GIM_Reject,
    // Label 907: @23711
    GIM_Try, /*On fail goto*//*Label 918*/ 23786,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      GIM_Try, /*On fail goto*//*Label 919*/ 23755, // Rule ID 15877 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (shl:{ *:[i64] } GR64:{ *:[i64] }:$src1, 1:{ *:[i8] })  =>  (ADD64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, GR64:{ *:[i64] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ADD64rr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 15877,
        GIR_Done,
      // Label 919: @23755
      GIM_Try, /*On fail goto*//*Label 920*/ 23785, // Rule ID 459 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (shl:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHL64ri:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHL64ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 459,
        GIR_Done,
      // Label 920: @23785
      GIM_Reject,
    // Label 918: @23786
    GIM_Reject,
    // Label 908: @23787
    GIM_Reject,
    // Label 17: @23788
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 5, /*)*//*default:*//*Label 925*/ 24086,
    /*GILLT_s8*//*Label 921*/ 23798,
    /*GILLT_s16*//*Label 922*/ 23870,
    /*GILLT_s32*//*Label 923*/ 23942,
    /*GILLT_s64*//*Label 924*/ 24014,
    // Label 921: @23798
    GIM_Try, /*On fail goto*//*Label 926*/ 23869,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 927*/ 23838, // Rule ID 480 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (srl:{ *:[i8] } GR8:{ *:[i8] }:$src1, 1:{ *:[i8] })  =>  (SHR8r1:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR8r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 480,
        GIR_Done,
      // Label 927: @23838
      GIM_Try, /*On fail goto*//*Label 928*/ 23868, // Rule ID 476 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (srl:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHR8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 476,
        GIR_Done,
      // Label 928: @23868
      GIM_Reject,
    // Label 926: @23869
    GIM_Reject,
    // Label 922: @23870
    GIM_Try, /*On fail goto*//*Label 929*/ 23941,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 930*/ 23910, // Rule ID 481 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (srl:{ *:[i16] } GR16:{ *:[i16] }:$src1, 1:{ *:[i8] })  =>  (SHR16r1:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR16r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 481,
        GIR_Done,
      // Label 930: @23910
      GIM_Try, /*On fail goto*//*Label 931*/ 23940, // Rule ID 477 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (srl:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHR16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 477,
        GIR_Done,
      // Label 931: @23940
      GIM_Reject,
    // Label 929: @23941
    GIM_Reject,
    // Label 923: @23942
    GIM_Try, /*On fail goto*//*Label 932*/ 24013,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      GIM_Try, /*On fail goto*//*Label 933*/ 23982, // Rule ID 482 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (srl:{ *:[i32] } GR32:{ *:[i32] }:$src1, 1:{ *:[i8] })  =>  (SHR32r1:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR32r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 482,
        GIR_Done,
      // Label 933: @23982
      GIM_Try, /*On fail goto*//*Label 934*/ 24012, // Rule ID 478 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (srl:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHR32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 478,
        GIR_Done,
      // Label 934: @24012
      GIM_Reject,
    // Label 932: @24013
    GIM_Reject,
    // Label 924: @24014
    GIM_Try, /*On fail goto*//*Label 935*/ 24085,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      GIM_Try, /*On fail goto*//*Label 936*/ 24054, // Rule ID 483 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (srl:{ *:[i64] } GR64:{ *:[i64] }:$src1, 1:{ *:[i8] })  =>  (SHR64r1:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR64r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 483,
        GIR_Done,
      // Label 936: @24054
      GIM_Try, /*On fail goto*//*Label 937*/ 24084, // Rule ID 479 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (srl:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SHR64ri:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SHR64ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 479,
        GIR_Done,
      // Label 937: @24084
      GIM_Reject,
    // Label 935: @24085
    GIM_Reject,
    // Label 925: @24086
    GIM_Reject,
    // Label 18: @24087
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/1, 5, /*)*//*default:*//*Label 942*/ 24385,
    /*GILLT_s8*//*Label 938*/ 24097,
    /*GILLT_s16*//*Label 939*/ 24169,
    /*GILLT_s32*//*Label 940*/ 24241,
    /*GILLT_s64*//*Label 941*/ 24313,
    // Label 938: @24097
    GIM_Try, /*On fail goto*//*Label 943*/ 24168,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR8RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR8RegClassID,
      GIM_Try, /*On fail goto*//*Label 944*/ 24137, // Rule ID 504 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (sra:{ *:[i8] } GR8:{ *:[i8] }:$src1, 1:{ *:[i8] })  =>  (SAR8r1:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR8r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 504,
        GIR_Done,
      // Label 944: @24137
      GIM_Try, /*On fail goto*//*Label 945*/ 24167, // Rule ID 500 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sra:{ *:[i8] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SAR8ri:{ *:[i8] }:{ *:[i32] } GR8:{ *:[i8] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR8ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 500,
        GIR_Done,
      // Label 945: @24167
      GIM_Reject,
    // Label 943: @24168
    GIM_Reject,
    // Label 939: @24169
    GIM_Try, /*On fail goto*//*Label 946*/ 24240,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      GIM_Try, /*On fail goto*//*Label 947*/ 24209, // Rule ID 505 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (sra:{ *:[i16] } GR16:{ *:[i16] }:$src1, 1:{ *:[i8] })  =>  (SAR16r1:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR16r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 505,
        GIR_Done,
      // Label 947: @24209
      GIM_Try, /*On fail goto*//*Label 948*/ 24239, // Rule ID 501 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sra:{ *:[i16] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SAR16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR16ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 501,
        GIR_Done,
      // Label 948: @24239
      GIM_Reject,
    // Label 946: @24240
    GIM_Reject,
    // Label 940: @24241
    GIM_Try, /*On fail goto*//*Label 949*/ 24312,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      GIM_Try, /*On fail goto*//*Label 950*/ 24281, // Rule ID 506 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (sra:{ *:[i32] } GR32:{ *:[i32] }:$src1, 1:{ *:[i8] })  =>  (SAR32r1:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR32r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 506,
        GIR_Done,
      // Label 950: @24281
      GIM_Try, /*On fail goto*//*Label 951*/ 24311, // Rule ID 502 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sra:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SAR32ri:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR32ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 502,
        GIR_Done,
      // Label 951: @24311
      GIM_Reject,
    // Label 949: @24312
    GIM_Reject,
    // Label 941: @24313
    GIM_Try, /*On fail goto*//*Label 952*/ 24384,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      GIM_Try, /*On fail goto*//*Label 953*/ 24353, // Rule ID 507 //
        GIM_CheckConstantInt, /*MI*/0, /*Op*/2, 1,
        // (sra:{ *:[i64] } GR64:{ *:[i64] }:$src1, 1:{ *:[i8] })  =>  (SAR64r1:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR64r1,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 507,
        GIR_Done,
      // Label 953: @24353
      GIM_Try, /*On fail goto*//*Label 954*/ 24383, // Rule ID 503 //
        GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/2, // MIs[1]
        GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_CONSTANT,
        // MIs[1] Operand 1
        // No operand predicates
        GIM_CheckIsSafeToFold, /*InsnID*/1,
        // (sra:{ *:[i64] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i8] }):$src2)  =>  (SAR64ri:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src1, (imm:{ *:[i8] }):$src2)
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::SAR64ri,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src1
        GIR_CopyConstantAsSImm, /*NewInsnID*/0, /*OldInsnID*/1, // src2
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 503,
        GIR_Done,
      // Label 954: @24383
      GIM_Reject,
    // Label 952: @24384
    GIM_Reject,
    // Label 942: @24385
    GIM_Reject,
    // Label 19: @24386
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/13, 23, /*)*//*default:*//*Label 958*/ 24573,
    /*GILLT_v8s16*//*Label 955*/ 24402, 0, 0, 0, 0,
    /*GILLT_v16s16*//*Label 956*/ 24483, 0, 0, 0,
    /*GILLT_v32s16*//*Label 957*/ 24541,
    // Label 955: @24402
    GIM_Try, /*On fail goto*//*Label 959*/ 24482,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 960*/ 24435, // Rule ID 1720 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mulhu:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMULHUWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHUWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1720,
        GIR_Done,
      // Label 960: @24435
      GIM_Try, /*On fail goto*//*Label 961*/ 24458, // Rule ID 1722 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mulhu:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMULHUWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMULHUWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1722,
        GIR_Done,
      // Label 961: @24458
      GIM_Try, /*On fail goto*//*Label 962*/ 24481, // Rule ID 4095 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (mulhu:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMULHUWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHUWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4095,
        GIR_Done,
      // Label 962: @24481
      GIM_Reject,
    // Label 959: @24482
    GIM_Reject,
    // Label 956: @24483
    GIM_Try, /*On fail goto*//*Label 963*/ 24540,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 964*/ 24516, // Rule ID 1724 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (mulhu:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMULHUWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHUWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1724,
        GIR_Done,
      // Label 964: @24516
      GIM_Try, /*On fail goto*//*Label 965*/ 24539, // Rule ID 4089 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (mulhu:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMULHUWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHUWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4089,
        GIR_Done,
      // Label 965: @24539
      GIM_Reject,
    // Label 963: @24540
    GIM_Reject,
    // Label 957: @24541
    GIM_Try, /*On fail goto*//*Label 966*/ 24572, // Rule ID 4083 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (mulhu:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMULHUWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHUWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4083,
      GIR_Done,
    // Label 966: @24572
    GIM_Reject,
    // Label 958: @24573
    GIM_Reject,
    // Label 20: @24574
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/13, 23, /*)*//*default:*//*Label 970*/ 24761,
    /*GILLT_v8s16*//*Label 967*/ 24590, 0, 0, 0, 0,
    /*GILLT_v16s16*//*Label 968*/ 24671, 0, 0, 0,
    /*GILLT_v32s16*//*Label 969*/ 24729,
    // Label 967: @24590
    GIM_Try, /*On fail goto*//*Label 971*/ 24670,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 972*/ 24623, // Rule ID 1726 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mulhs:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMULHWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1726,
        GIR_Done,
      // Label 972: @24623
      GIM_Try, /*On fail goto*//*Label 973*/ 24646, // Rule ID 1728 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (mulhs:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMULHWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMULHWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1728,
        GIR_Done,
      // Label 973: @24646
      GIM_Try, /*On fail goto*//*Label 974*/ 24669, // Rule ID 4077 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (mulhs:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMULHWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4077,
        GIR_Done,
      // Label 974: @24669
      GIM_Reject,
    // Label 971: @24670
    GIM_Reject,
    // Label 968: @24671
    GIM_Try, /*On fail goto*//*Label 975*/ 24728,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 976*/ 24704, // Rule ID 1730 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (mulhs:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMULHWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1730,
        GIR_Done,
      // Label 976: @24704
      GIM_Try, /*On fail goto*//*Label 977*/ 24727, // Rule ID 4071 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (mulhs:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMULHWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4071,
        GIR_Done,
      // Label 977: @24727
      GIM_Reject,
    // Label 975: @24728
    GIM_Reject,
    // Label 969: @24729
    GIM_Try, /*On fail goto*//*Label 978*/ 24760, // Rule ID 4065 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (mulhs:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMULHWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMULHWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4065,
      GIR_Done,
    // Label 978: @24760
    GIM_Reject,
    // Label 970: @24761
    GIM_Reject,
    // Label 21: @24762
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 988*/ 25383,
    /*GILLT_s32*//*Label 979*/ 24785,
    /*GILLT_s64*//*Label 980*/ 24895,
    /*GILLT_s80*//*Label 981*/ 25005, 0, 0,
    /*GILLT_v2s64*//*Label 982*/ 25041, 0,
    /*GILLT_v4s32*//*Label 983*/ 25122,
    /*GILLT_v4s64*//*Label 984*/ 25203, 0, 0,
    /*GILLT_v8s32*//*Label 985*/ 25261,
    /*GILLT_v8s64*//*Label 986*/ 25319, 0, 0, 0,
    /*GILLT_v16s32*//*Label 987*/ 25351,
    // Label 979: @24785
    GIM_Try, /*On fail goto*//*Label 989*/ 24894,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 990*/ 24824, // Rule ID 605 //
        GIM_CheckFeatures, GIFBS_FPStackf32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP32RegClassID,
        // (fadd:{ *:[f32] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)  =>  (ADD_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD_Fp32,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 605,
        GIR_Done,
      // Label 990: @24824
      GIM_Try, /*On fail goto*//*Label 991*/ 24847, // Rule ID 1442 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fadd:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (VADDSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1442,
        GIR_Done,
      // Label 991: @24847
      GIM_Try, /*On fail goto*//*Label 992*/ 24870, // Rule ID 1446 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fadd:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (ADDSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADDSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1446,
        GIR_Done,
      // Label 992: @24870
      GIM_Try, /*On fail goto*//*Label 993*/ 24893, // Rule ID 4944 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32XRegClassID,
        // (fadd:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)  =>  (VADDSSZrr:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDSSZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4944,
        GIR_Done,
      // Label 993: @24893
      GIM_Reject,
    // Label 989: @24894
    GIM_Reject,
    // Label 980: @24895
    GIM_Try, /*On fail goto*//*Label 994*/ 25004,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 995*/ 24934, // Rule ID 606 //
        GIM_CheckFeatures, GIFBS_FPStackf64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP64RegClassID,
        // (fadd:{ *:[f64] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)  =>  (ADD_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD_Fp64,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 606,
        GIR_Done,
      // Label 995: @24934
      GIM_Try, /*On fail goto*//*Label 996*/ 24957, // Rule ID 1444 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fadd:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (VADDSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1444,
        GIR_Done,
      // Label 996: @24957
      GIM_Try, /*On fail goto*//*Label 997*/ 24980, // Rule ID 1448 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fadd:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (ADDSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADDSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1448,
        GIR_Done,
      // Label 997: @24980
      GIM_Try, /*On fail goto*//*Label 998*/ 25003, // Rule ID 4955 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64XRegClassID,
        // (fadd:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)  =>  (VADDSDZrr:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDSDZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4955,
        GIR_Done,
      // Label 998: @25003
      GIM_Reject,
    // Label 994: @25004
    GIM_Reject,
    // Label 981: @25005
    GIM_Try, /*On fail goto*//*Label 999*/ 25040, // Rule ID 607 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP80RegClassID,
      // (fadd:{ *:[f80] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)  =>  (ADD_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADD_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 607,
      GIR_Done,
    // Label 999: @25040
    GIM_Reject,
    // Label 982: @25041
    GIM_Try, /*On fail goto*//*Label 1000*/ 25121,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 1001*/ 25074, // Rule ID 1432 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fadd:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (VADDPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1432,
        GIR_Done,
      // Label 1001: @25074
      GIM_Try, /*On fail goto*//*Label 1002*/ 25097, // Rule ID 1440 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fadd:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (ADDPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADDPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1440,
        GIR_Done,
      // Label 1002: @25097
      GIM_Try, /*On fail goto*//*Label 1003*/ 25120, // Rule ID 5114 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fadd:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)  =>  (VADDPDZ128rr:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5114,
        GIR_Done,
      // Label 1003: @25120
      GIM_Reject,
    // Label 1000: @25121
    GIM_Reject,
    // Label 983: @25122
    GIM_Try, /*On fail goto*//*Label 1004*/ 25202,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1005*/ 25155, // Rule ID 1430 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fadd:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (VADDPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1430,
        GIR_Done,
      // Label 1005: @25155
      GIM_Try, /*On fail goto*//*Label 1006*/ 25178, // Rule ID 1438 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fadd:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (ADDPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ADDPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1438,
        GIR_Done,
      // Label 1006: @25178
      GIM_Try, /*On fail goto*//*Label 1007*/ 25201, // Rule ID 5096 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fadd:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)  =>  (VADDPSZ128rr:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPSZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5096,
        GIR_Done,
      // Label 1007: @25201
      GIM_Reject,
    // Label 1004: @25202
    GIM_Reject,
    // Label 984: @25203
    GIM_Try, /*On fail goto*//*Label 1008*/ 25260,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 1009*/ 25236, // Rule ID 1436 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fadd:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)  =>  (VADDPDYrr:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1436,
        GIR_Done,
      // Label 1009: @25236
      GIM_Try, /*On fail goto*//*Label 1010*/ 25259, // Rule ID 5123 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fadd:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)  =>  (VADDPDZ256rr:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5123,
        GIR_Done,
      // Label 1010: @25259
      GIM_Reject,
    // Label 1008: @25260
    GIM_Reject,
    // Label 985: @25261
    GIM_Try, /*On fail goto*//*Label 1011*/ 25318,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1012*/ 25294, // Rule ID 1434 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fadd:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)  =>  (VADDPSYrr:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1434,
        GIR_Done,
      // Label 1012: @25294
      GIM_Try, /*On fail goto*//*Label 1013*/ 25317, // Rule ID 5105 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fadd:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)  =>  (VADDPSZ256rr:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPSZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5105,
        GIR_Done,
      // Label 1013: @25317
      GIM_Reject,
    // Label 1011: @25318
    GIM_Reject,
    // Label 986: @25319
    GIM_Try, /*On fail goto*//*Label 1014*/ 25350, // Rule ID 5087 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fadd:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)  =>  (VADDPDZrr:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5087,
      GIR_Done,
    // Label 1014: @25350
    GIM_Reject,
    // Label 987: @25351
    GIM_Try, /*On fail goto*//*Label 1015*/ 25382, // Rule ID 5078 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fadd:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)  =>  (VADDPSZrr:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VADDPSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5078,
      GIR_Done,
    // Label 1015: @25382
    GIM_Reject,
    // Label 988: @25383
    GIM_Reject,
    // Label 22: @25384
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 1025*/ 26005,
    /*GILLT_s32*//*Label 1016*/ 25407,
    /*GILLT_s64*//*Label 1017*/ 25517,
    /*GILLT_s80*//*Label 1018*/ 25627, 0, 0,
    /*GILLT_v2s64*//*Label 1019*/ 25663, 0,
    /*GILLT_v4s32*//*Label 1020*/ 25744,
    /*GILLT_v4s64*//*Label 1021*/ 25825, 0, 0,
    /*GILLT_v8s32*//*Label 1022*/ 25883,
    /*GILLT_v8s64*//*Label 1023*/ 25941, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1024*/ 25973,
    // Label 1016: @25407
    GIM_Try, /*On fail goto*//*Label 1026*/ 25516,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 1027*/ 25446, // Rule ID 608 //
        GIM_CheckFeatures, GIFBS_FPStackf32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP32RegClassID,
        // (fsub:{ *:[f32] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)  =>  (SUB_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB_Fp32,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 608,
        GIR_Done,
      // Label 1027: @25446
      GIM_Try, /*On fail goto*//*Label 1028*/ 25469, // Rule ID 1482 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fsub:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (VSUBSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1482,
        GIR_Done,
      // Label 1028: @25469
      GIM_Try, /*On fail goto*//*Label 1029*/ 25492, // Rule ID 1486 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fsub:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (SUBSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUBSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1486,
        GIR_Done,
      // Label 1029: @25492
      GIM_Try, /*On fail goto*//*Label 1030*/ 25515, // Rule ID 4988 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32XRegClassID,
        // (fsub:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)  =>  (VSUBSSZrr:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBSSZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4988,
        GIR_Done,
      // Label 1030: @25515
      GIM_Reject,
    // Label 1026: @25516
    GIM_Reject,
    // Label 1017: @25517
    GIM_Try, /*On fail goto*//*Label 1031*/ 25626,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 1032*/ 25556, // Rule ID 609 //
        GIM_CheckFeatures, GIFBS_FPStackf64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP64RegClassID,
        // (fsub:{ *:[f64] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)  =>  (SUB_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB_Fp64,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 609,
        GIR_Done,
      // Label 1032: @25556
      GIM_Try, /*On fail goto*//*Label 1033*/ 25579, // Rule ID 1484 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fsub:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (VSUBSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1484,
        GIR_Done,
      // Label 1033: @25579
      GIM_Try, /*On fail goto*//*Label 1034*/ 25602, // Rule ID 1488 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fsub:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (SUBSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUBSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1488,
        GIR_Done,
      // Label 1034: @25602
      GIM_Try, /*On fail goto*//*Label 1035*/ 25625, // Rule ID 4999 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64XRegClassID,
        // (fsub:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)  =>  (VSUBSDZrr:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBSDZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4999,
        GIR_Done,
      // Label 1035: @25625
      GIM_Reject,
    // Label 1031: @25626
    GIM_Reject,
    // Label 1018: @25627
    GIM_Try, /*On fail goto*//*Label 1036*/ 25662, // Rule ID 610 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP80RegClassID,
      // (fsub:{ *:[f80] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)  =>  (SUB_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUB_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 610,
      GIR_Done,
    // Label 1036: @25662
    GIM_Reject,
    // Label 1019: @25663
    GIM_Try, /*On fail goto*//*Label 1037*/ 25743,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 1038*/ 25696, // Rule ID 1472 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fsub:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (VSUBPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1472,
        GIR_Done,
      // Label 1038: @25696
      GIM_Try, /*On fail goto*//*Label 1039*/ 25719, // Rule ID 1480 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fsub:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (SUBPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUBPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1480,
        GIR_Done,
      // Label 1039: @25719
      GIM_Try, /*On fail goto*//*Label 1040*/ 25742, // Rule ID 5234 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fsub:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)  =>  (VSUBPDZ128rr:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5234,
        GIR_Done,
      // Label 1040: @25742
      GIM_Reject,
    // Label 1037: @25743
    GIM_Reject,
    // Label 1020: @25744
    GIM_Try, /*On fail goto*//*Label 1041*/ 25824,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1042*/ 25777, // Rule ID 1470 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fsub:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (VSUBPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1470,
        GIR_Done,
      // Label 1042: @25777
      GIM_Try, /*On fail goto*//*Label 1043*/ 25800, // Rule ID 1478 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fsub:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (SUBPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SUBPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1478,
        GIR_Done,
      // Label 1043: @25800
      GIM_Try, /*On fail goto*//*Label 1044*/ 25823, // Rule ID 5216 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fsub:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)  =>  (VSUBPSZ128rr:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPSZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5216,
        GIR_Done,
      // Label 1044: @25823
      GIM_Reject,
    // Label 1041: @25824
    GIM_Reject,
    // Label 1021: @25825
    GIM_Try, /*On fail goto*//*Label 1045*/ 25882,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 1046*/ 25858, // Rule ID 1476 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fsub:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)  =>  (VSUBPDYrr:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1476,
        GIR_Done,
      // Label 1046: @25858
      GIM_Try, /*On fail goto*//*Label 1047*/ 25881, // Rule ID 5243 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fsub:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)  =>  (VSUBPDZ256rr:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5243,
        GIR_Done,
      // Label 1047: @25881
      GIM_Reject,
    // Label 1045: @25882
    GIM_Reject,
    // Label 1022: @25883
    GIM_Try, /*On fail goto*//*Label 1048*/ 25940,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1049*/ 25916, // Rule ID 1474 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fsub:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)  =>  (VSUBPSYrr:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1474,
        GIR_Done,
      // Label 1049: @25916
      GIM_Try, /*On fail goto*//*Label 1050*/ 25939, // Rule ID 5225 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fsub:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)  =>  (VSUBPSZ256rr:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPSZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5225,
        GIR_Done,
      // Label 1050: @25939
      GIM_Reject,
    // Label 1048: @25940
    GIM_Reject,
    // Label 1023: @25941
    GIM_Try, /*On fail goto*//*Label 1051*/ 25972, // Rule ID 5207 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fsub:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)  =>  (VSUBPDZrr:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5207,
      GIR_Done,
    // Label 1051: @25972
    GIM_Reject,
    // Label 1024: @25973
    GIM_Try, /*On fail goto*//*Label 1052*/ 26004, // Rule ID 5198 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fsub:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)  =>  (VSUBPSZrr:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSUBPSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5198,
      GIR_Done,
    // Label 1052: @26004
    GIM_Reject,
    // Label 1025: @26005
    GIM_Reject,
    // Label 23: @26006
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 1062*/ 26627,
    /*GILLT_s32*//*Label 1053*/ 26029,
    /*GILLT_s64*//*Label 1054*/ 26139,
    /*GILLT_s80*//*Label 1055*/ 26249, 0, 0,
    /*GILLT_v2s64*//*Label 1056*/ 26285, 0,
    /*GILLT_v4s32*//*Label 1057*/ 26366,
    /*GILLT_v4s64*//*Label 1058*/ 26447, 0, 0,
    /*GILLT_v8s32*//*Label 1059*/ 26505,
    /*GILLT_v8s64*//*Label 1060*/ 26563, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1061*/ 26595,
    // Label 1053: @26029
    GIM_Try, /*On fail goto*//*Label 1063*/ 26138,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 1064*/ 26068, // Rule ID 611 //
        GIM_CheckFeatures, GIFBS_FPStackf32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP32RegClassID,
        // (fmul:{ *:[f32] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)  =>  (MUL_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MUL_Fp32,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 611,
        GIR_Done,
      // Label 1064: @26068
      GIM_Try, /*On fail goto*//*Label 1065*/ 26091, // Rule ID 1462 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fmul:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (VMULSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1462,
        GIR_Done,
      // Label 1065: @26091
      GIM_Try, /*On fail goto*//*Label 1066*/ 26114, // Rule ID 1466 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fmul:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (MULSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MULSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1466,
        GIR_Done,
      // Label 1066: @26114
      GIM_Try, /*On fail goto*//*Label 1067*/ 26137, // Rule ID 4966 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32XRegClassID,
        // (fmul:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)  =>  (VMULSSZrr:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULSSZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4966,
        GIR_Done,
      // Label 1067: @26137
      GIM_Reject,
    // Label 1063: @26138
    GIM_Reject,
    // Label 1054: @26139
    GIM_Try, /*On fail goto*//*Label 1068*/ 26248,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 1069*/ 26178, // Rule ID 612 //
        GIM_CheckFeatures, GIFBS_FPStackf64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP64RegClassID,
        // (fmul:{ *:[f64] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)  =>  (MUL_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MUL_Fp64,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 612,
        GIR_Done,
      // Label 1069: @26178
      GIM_Try, /*On fail goto*//*Label 1070*/ 26201, // Rule ID 1464 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fmul:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (VMULSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1464,
        GIR_Done,
      // Label 1070: @26201
      GIM_Try, /*On fail goto*//*Label 1071*/ 26224, // Rule ID 1468 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fmul:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (MULSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MULSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1468,
        GIR_Done,
      // Label 1071: @26224
      GIM_Try, /*On fail goto*//*Label 1072*/ 26247, // Rule ID 4977 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64XRegClassID,
        // (fmul:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)  =>  (VMULSDZrr:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULSDZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4977,
        GIR_Done,
      // Label 1072: @26247
      GIM_Reject,
    // Label 1068: @26248
    GIM_Reject,
    // Label 1055: @26249
    GIM_Try, /*On fail goto*//*Label 1073*/ 26284, // Rule ID 613 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP80RegClassID,
      // (fmul:{ *:[f80] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)  =>  (MUL_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MUL_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 613,
      GIR_Done,
    // Label 1073: @26284
    GIM_Reject,
    // Label 1056: @26285
    GIM_Try, /*On fail goto*//*Label 1074*/ 26365,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 1075*/ 26318, // Rule ID 1452 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fmul:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (VMULPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1452,
        GIR_Done,
      // Label 1075: @26318
      GIM_Try, /*On fail goto*//*Label 1076*/ 26341, // Rule ID 1460 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fmul:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (MULPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MULPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1460,
        GIR_Done,
      // Label 1076: @26341
      GIM_Try, /*On fail goto*//*Label 1077*/ 26364, // Rule ID 5174 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fmul:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)  =>  (VMULPDZ128rr:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5174,
        GIR_Done,
      // Label 1077: @26364
      GIM_Reject,
    // Label 1074: @26365
    GIM_Reject,
    // Label 1057: @26366
    GIM_Try, /*On fail goto*//*Label 1078*/ 26446,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1079*/ 26399, // Rule ID 1450 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fmul:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (VMULPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1450,
        GIR_Done,
      // Label 1079: @26399
      GIM_Try, /*On fail goto*//*Label 1080*/ 26422, // Rule ID 1458 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fmul:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (MULPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::MULPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1458,
        GIR_Done,
      // Label 1080: @26422
      GIM_Try, /*On fail goto*//*Label 1081*/ 26445, // Rule ID 5156 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fmul:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)  =>  (VMULPSZ128rr:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPSZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5156,
        GIR_Done,
      // Label 1081: @26445
      GIM_Reject,
    // Label 1078: @26446
    GIM_Reject,
    // Label 1058: @26447
    GIM_Try, /*On fail goto*//*Label 1082*/ 26504,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 1083*/ 26480, // Rule ID 1456 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fmul:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)  =>  (VMULPDYrr:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1456,
        GIR_Done,
      // Label 1083: @26480
      GIM_Try, /*On fail goto*//*Label 1084*/ 26503, // Rule ID 5183 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fmul:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)  =>  (VMULPDZ256rr:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5183,
        GIR_Done,
      // Label 1084: @26503
      GIM_Reject,
    // Label 1082: @26504
    GIM_Reject,
    // Label 1059: @26505
    GIM_Try, /*On fail goto*//*Label 1085*/ 26562,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1086*/ 26538, // Rule ID 1454 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fmul:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)  =>  (VMULPSYrr:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1454,
        GIR_Done,
      // Label 1086: @26538
      GIM_Try, /*On fail goto*//*Label 1087*/ 26561, // Rule ID 5165 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fmul:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)  =>  (VMULPSZ256rr:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPSZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5165,
        GIR_Done,
      // Label 1087: @26561
      GIM_Reject,
    // Label 1085: @26562
    GIM_Reject,
    // Label 1060: @26563
    GIM_Try, /*On fail goto*//*Label 1088*/ 26594, // Rule ID 5147 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fmul:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)  =>  (VMULPDZrr:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5147,
      GIR_Done,
    // Label 1088: @26594
    GIM_Reject,
    // Label 1061: @26595
    GIM_Try, /*On fail goto*//*Label 1089*/ 26626, // Rule ID 5138 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fmul:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)  =>  (VMULPSZrr:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VMULPSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5138,
      GIR_Done,
    // Label 1089: @26626
    GIM_Reject,
    // Label 1062: @26627
    GIM_Reject,
    // Label 24: @26628
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 1099*/ 27249,
    /*GILLT_s32*//*Label 1090*/ 26651,
    /*GILLT_s64*//*Label 1091*/ 26761,
    /*GILLT_s80*//*Label 1092*/ 26871, 0, 0,
    /*GILLT_v2s64*//*Label 1093*/ 26907, 0,
    /*GILLT_v4s32*//*Label 1094*/ 26988,
    /*GILLT_v4s64*//*Label 1095*/ 27069, 0, 0,
    /*GILLT_v8s32*//*Label 1096*/ 27127,
    /*GILLT_v8s64*//*Label 1097*/ 27185, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1098*/ 27217,
    // Label 1090: @26651
    GIM_Try, /*On fail goto*//*Label 1100*/ 26760,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 1101*/ 26690, // Rule ID 614 //
        GIM_CheckFeatures, GIFBS_FPStackf32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP32RegClassID,
        // (fdiv:{ *:[f32] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)  =>  (DIV_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src1, RFP32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIV_Fp32,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 614,
        GIR_Done,
      // Label 1101: @26690
      GIM_Try, /*On fail goto*//*Label 1102*/ 26713, // Rule ID 1502 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fdiv:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (VDIVSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1502,
        GIR_Done,
      // Label 1102: @26713
      GIM_Try, /*On fail goto*//*Label 1103*/ 26736, // Rule ID 1506 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32RegClassID,
        // (fdiv:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)  =>  (DIVSSrr:{ *:[f32] } FR32:{ *:[f32] }:$src1, FR32:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIVSSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1506,
        GIR_Done,
      // Label 1103: @26736
      GIM_Try, /*On fail goto*//*Label 1104*/ 26759, // Rule ID 5010 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR32XRegClassID,
        // (fdiv:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)  =>  (VDIVSSZrr:{ *:[f32] } FR32X:{ *:[f32] }:$src1, FR32X:{ *:[f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVSSZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5010,
        GIR_Done,
      // Label 1104: @26759
      GIM_Reject,
    // Label 1100: @26760
    GIM_Reject,
    // Label 1091: @26761
    GIM_Try, /*On fail goto*//*Label 1105*/ 26870,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 1106*/ 26800, // Rule ID 615 //
        GIM_CheckFeatures, GIFBS_FPStackf64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP64RegClassID,
        // (fdiv:{ *:[f64] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)  =>  (DIV_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src1, RFP64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIV_Fp64,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 615,
        GIR_Done,
      // Label 1106: @26800
      GIM_Try, /*On fail goto*//*Label 1107*/ 26823, // Rule ID 1504 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fdiv:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (VDIVSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1504,
        GIR_Done,
      // Label 1107: @26823
      GIM_Try, /*On fail goto*//*Label 1108*/ 26846, // Rule ID 1508 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64RegClassID,
        // (fdiv:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)  =>  (DIVSDrr:{ *:[f64] } FR64:{ *:[f64] }:$src1, FR64:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIVSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1508,
        GIR_Done,
      // Label 1108: @26846
      GIM_Try, /*On fail goto*//*Label 1109*/ 26869, // Rule ID 5021 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::FR64XRegClassID,
        // (fdiv:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)  =>  (VDIVSDZrr:{ *:[f64] } FR64X:{ *:[f64] }:$src1, FR64X:{ *:[f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVSDZrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5021,
        GIR_Done,
      // Label 1109: @26869
      GIM_Reject,
    // Label 1105: @26870
    GIM_Reject,
    // Label 1092: @26871
    GIM_Try, /*On fail goto*//*Label 1110*/ 26906, // Rule ID 616 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::RFP80RegClassID,
      // (fdiv:{ *:[f80] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)  =>  (DIV_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src1, RFP80:{ *:[f80] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIV_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 616,
      GIR_Done,
    // Label 1110: @26906
    GIM_Reject,
    // Label 1093: @26907
    GIM_Try, /*On fail goto*//*Label 1111*/ 26987,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 1112*/ 26940, // Rule ID 1492 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fdiv:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (VDIVPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1492,
        GIR_Done,
      // Label 1112: @26940
      GIM_Try, /*On fail goto*//*Label 1113*/ 26963, // Rule ID 1500 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fdiv:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)  =>  (DIVPDrr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src1, VR128:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIVPDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1500,
        GIR_Done,
      // Label 1113: @26963
      GIM_Try, /*On fail goto*//*Label 1114*/ 26986, // Rule ID 5294 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fdiv:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)  =>  (VDIVPDZ128rr:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src1, VR128X:{ *:[v2f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5294,
        GIR_Done,
      // Label 1114: @26986
      GIM_Reject,
    // Label 1111: @26987
    GIM_Reject,
    // Label 1094: @26988
    GIM_Try, /*On fail goto*//*Label 1115*/ 27068,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1116*/ 27021, // Rule ID 1490 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fdiv:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (VDIVPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1490,
        GIR_Done,
      // Label 1116: @27021
      GIM_Try, /*On fail goto*//*Label 1117*/ 27044, // Rule ID 1498 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (fdiv:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)  =>  (DIVPSrr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src1, VR128:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::DIVPSrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1498,
        GIR_Done,
      // Label 1117: @27044
      GIM_Try, /*On fail goto*//*Label 1118*/ 27067, // Rule ID 5276 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (fdiv:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)  =>  (VDIVPSZ128rr:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src1, VR128X:{ *:[v4f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPSZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5276,
        GIR_Done,
      // Label 1118: @27067
      GIM_Reject,
    // Label 1115: @27068
    GIM_Reject,
    // Label 1095: @27069
    GIM_Try, /*On fail goto*//*Label 1119*/ 27126,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 1120*/ 27102, // Rule ID 1496 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fdiv:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)  =>  (VDIVPDYrr:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src1, VR256:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1496,
        GIR_Done,
      // Label 1120: @27102
      GIM_Try, /*On fail goto*//*Label 1121*/ 27125, // Rule ID 5303 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fdiv:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)  =>  (VDIVPDZ256rr:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src1, VR256X:{ *:[v4f64] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5303,
        GIR_Done,
      // Label 1121: @27125
      GIM_Reject,
    // Label 1119: @27126
    GIM_Reject,
    // Label 1096: @27127
    GIM_Try, /*On fail goto*//*Label 1122*/ 27184,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1123*/ 27160, // Rule ID 1494 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (fdiv:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)  =>  (VDIVPSYrr:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src1, VR256:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1494,
        GIR_Done,
      // Label 1123: @27160
      GIM_Try, /*On fail goto*//*Label 1124*/ 27183, // Rule ID 5285 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (fdiv:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)  =>  (VDIVPSZ256rr:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src1, VR256X:{ *:[v8f32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPSZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 5285,
        GIR_Done,
      // Label 1124: @27183
      GIM_Reject,
    // Label 1122: @27184
    GIM_Reject,
    // Label 1097: @27185
    GIM_Try, /*On fail goto*//*Label 1125*/ 27216, // Rule ID 5267 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fdiv:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)  =>  (VDIVPDZrr:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src1, VR512:{ *:[v8f64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5267,
      GIR_Done,
    // Label 1125: @27216
    GIM_Reject,
    // Label 1098: @27217
    GIM_Try, /*On fail goto*//*Label 1126*/ 27248, // Rule ID 5258 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (fdiv:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)  =>  (VDIVPSZrr:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src1, VR512:{ *:[v16f32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VDIVPSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5258,
      GIR_Done,
    // Label 1126: @27248
    GIM_Reject,
    // Label 1099: @27249
    GIM_Reject,
    // Label 25: @27250
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 6, /*)*//*default:*//*Label 1130*/ 27347,
    /*GILLT_s32*//*Label 1127*/ 27259,
    /*GILLT_s64*//*Label 1128*/ 27289,
    /*GILLT_s80*//*Label 1129*/ 27319,
    // Label 1127: @27259
    GIM_Try, /*On fail goto*//*Label 1131*/ 27288, // Rule ID 683 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
      // (fneg:{ *:[f32] } RFP32:{ *:[f32] }:$src)  =>  (CHS_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CHS_Fp32,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 683,
      GIR_Done,
    // Label 1131: @27288
    GIM_Reject,
    // Label 1128: @27289
    GIM_Try, /*On fail goto*//*Label 1132*/ 27318, // Rule ID 684 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
      // (fneg:{ *:[f64] } RFP64:{ *:[f64] }:$src)  =>  (CHS_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CHS_Fp64,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 684,
      GIR_Done,
    // Label 1132: @27318
    GIM_Reject,
    // Label 1129: @27319
    GIM_Try, /*On fail goto*//*Label 1133*/ 27346, // Rule ID 685 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fneg:{ *:[f80] } RFP80:{ *:[f80] }:$src)  =>  (CHS_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CHS_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 685,
      GIR_Done,
    // Label 1133: @27346
    GIM_Reject,
    // Label 1130: @27347
    GIM_Reject,
    // Label 26: @27348
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/4, 16, /*)*//*default:*//*Label 1138*/ 27623,
    /*GILLT_s64*//*Label 1134*/ 27366,
    /*GILLT_s80*//*Label 1135*/ 27502, 0, 0, 0, 0, 0,
    /*GILLT_v4s64*//*Label 1136*/ 27553, 0, 0, 0,
    /*GILLT_v8s64*//*Label 1137*/ 27599,
    // Label 1134: @27366
    GIM_Try, /*On fail goto*//*Label 1139*/ 27501,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 1140*/ 27391, // Rule ID 1268 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        // (fpextend:{ *:[f64] } FR32:{ *:[f32] }:$src)  =>  (CVTSS2SDrr:{ *:[f64] } FR32:{ *:[f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTSS2SDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1268,
        GIR_Done,
      // Label 1140: @27391
      GIM_Try, /*On fail goto*//*Label 1141*/ 27412, // Rule ID 11945 //
        GIM_CheckFeatures, GIFBS_FPStackf32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
        // (fpextend:{ *:[f64] } RFP32:{ *:[f32] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[f64] } RFP32:{ *:[f32] }:$src, RFP64:{ *:[i32] })
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
        GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC RFP64*/63,
        // GIR_Coverage, 11945,
        GIR_Done,
      // Label 1141: @27412
      GIM_Try, /*On fail goto*//*Label 1142*/ 27456, // Rule ID 12110 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        // (fpextend:{ *:[f64] } FR32:{ *:[f32] }:$src)  =>  (VCVTSS2SDrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), FR32:{ *:[f32] }:$src)
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSS2SDrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12110,
        GIR_Done,
      // Label 1142: @27456
      GIM_Try, /*On fail goto*//*Label 1143*/ 27500, // Rule ID 14818 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
        // (fpextend:{ *:[f64] } FR32X:{ *:[f32] }:$src)  =>  (VCVTSS2SDZrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), FR32X:{ *:[f32] }:$src)
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSS2SDZrr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 14818,
        GIR_Done,
      // Label 1143: @27500
      GIM_Reject,
    // Label 1139: @27501
    GIM_Reject,
    // Label 1135: @27502
    GIM_Try, /*On fail goto*//*Label 1144*/ 27527, // Rule ID 11946 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
      // (fpextend:{ *:[f80] } RFP32:{ *:[f32] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[f80] } RFP32:{ *:[f32] }:$src, RFP80:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC RFP80*/109,
      // GIR_Coverage, 11946,
      GIR_Done,
    // Label 1144: @27527
    GIM_Try, /*On fail goto*//*Label 1145*/ 27552, // Rule ID 11947 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
      // (fpextend:{ *:[f80] } RFP64:{ *:[f64] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[f80] } RFP64:{ *:[f64] }:$src, RFP80:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC RFP80*/109,
      // GIR_Coverage, 11947,
      GIR_Done,
    // Label 1145: @27552
    GIM_Reject,
    // Label 1136: @27553
    GIM_Try, /*On fail goto*//*Label 1146*/ 27598,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1147*/ 27578, // Rule ID 1296 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (fpextend:{ *:[v4f64] } VR128:{ *:[v4f32] }:$src)  =>  (VCVTPS2PDYrr:{ *:[v4f64] } VR128:{ *:[v4f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTPS2PDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1296,
        GIR_Done,
      // Label 1147: @27578
      GIM_Try, /*On fail goto*//*Label 1148*/ 27597, // Rule ID 7897 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        // (fpextend:{ *:[v4f64] } VR128X:{ *:[v4f32] }:$src)  =>  (VCVTPS2PDZ256rr:{ *:[v4f64] } VR128X:{ *:[v4f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTPS2PDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 7897,
        GIR_Done,
      // Label 1148: @27597
      GIM_Reject,
    // Label 1146: @27598
    GIM_Reject,
    // Label 1137: @27599
    GIM_Try, /*On fail goto*//*Label 1149*/ 27622, // Rule ID 7876 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (fpextend:{ *:[v8f64] } VR256X:{ *:[v8f32] }:$src)  =>  (VCVTPS2PDZrr:{ *:[v8f64] } VR256X:{ *:[v8f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTPS2PDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7876,
      GIR_Done,
    // Label 1149: @27622
    GIM_Reject,
    // Label 1138: @27623
    GIM_Reject,
    // Label 27: @27624
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 15, /*)*//*default:*//*Label 1154*/ 27908,
    /*GILLT_s32*//*Label 1150*/ 27642,
    /*GILLT_s64*//*Label 1151*/ 27812, 0, 0, 0, 0, 0,
    /*GILLT_v4s32*//*Label 1152*/ 27838, 0, 0, 0,
    /*GILLT_v8s32*//*Label 1153*/ 27884,
    // Label 1150: @27642
    GIM_Try, /*On fail goto*//*Label 1155*/ 27665, // Rule ID 1262 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (fpround:{ *:[f32] } FR64:{ *:[f64] }:$src)  =>  (CVTSD2SSrr:{ *:[f32] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTSD2SSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1262,
      GIR_Done,
    // Label 1155: @27665
    GIM_Try, /*On fail goto*//*Label 1156*/ 27690, // Rule ID 11948 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
      // (fpround:{ *:[f32] } RFP64:{ *:[f64] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[f32] } RFP64:{ *:[f64] }:$src, RFP32:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC RFP32*/39,
      // GIR_Coverage, 11948,
      GIR_Done,
    // Label 1156: @27690
    GIM_Try, /*On fail goto*//*Label 1157*/ 27715, // Rule ID 11949 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fpround:{ *:[f32] } RFP80:{ *:[f80] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[f32] } RFP80:{ *:[f80] }:$src, RFP32:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC RFP32*/39,
      // GIR_Coverage, 11949,
      GIR_Done,
    // Label 1157: @27715
    GIM_Try, /*On fail goto*//*Label 1158*/ 27763, // Rule ID 12109 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (fpround:{ *:[f32] } FR64:{ *:[f64] }:$src)  =>  (VCVTSD2SSrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), FR64:{ *:[f64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSD2SSrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12109,
      GIR_Done,
    // Label 1158: @27763
    GIM_Try, /*On fail goto*//*Label 1159*/ 27811, // Rule ID 14820 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
      // (fpround:{ *:[f32] } FR64X:{ *:[f64] }:$src)  =>  (VCVTSD2SSZrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), FR64X:{ *:[f64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSD2SSZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14820,
      GIR_Done,
    // Label 1159: @27811
    GIM_Reject,
    // Label 1151: @27812
    GIM_Try, /*On fail goto*//*Label 1160*/ 27837, // Rule ID 11950 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fpround:{ *:[f64] } RFP80:{ *:[f80] }:$src)  =>  (COPY_TO_REGCLASS:{ *:[f64] } RFP80:{ *:[f80] }:$src, RFP64:{ *:[i32] })
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/TargetOpcode::COPY,
      GIR_ConstrainOperandRC, /*InsnID*/0, /*Op*/0, /*RC RFP64*/63,
      // GIR_Coverage, 11950,
      GIR_Done,
    // Label 1160: @27837
    GIM_Reject,
    // Label 1152: @27838
    GIM_Try, /*On fail goto*//*Label 1161*/ 27883,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 1162*/ 27863, // Rule ID 12136 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        // (fpround:{ *:[v4f32] } VR256:{ *:[v4f64] }:$src)  =>  (VCVTPD2PSYrr:{ *:[v4f32] } VR256:{ *:[v4f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTPD2PSYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12136,
        GIR_Done,
      // Label 1162: @27863
      GIM_Try, /*On fail goto*//*Label 1163*/ 27882, // Rule ID 14832 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        // (fpround:{ *:[v4f32] } VR256X:{ *:[v4f64] }:$src)  =>  (VCVTPD2PSZ256rr:{ *:[v4f32] } VR256X:{ *:[v4f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTPD2PSZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 14832,
        GIR_Done,
      // Label 1163: @27882
      GIM_Reject,
    // Label 1161: @27883
    GIM_Reject,
    // Label 1153: @27884
    GIM_Try, /*On fail goto*//*Label 1164*/ 27907, // Rule ID 14823 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (fpround:{ *:[v8f32] } VR512:{ *:[v8f64] }:$src)  =>  (VCVTPD2PSZrr:{ *:[v8f32] } VR512:{ *:[v8f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTPD2PSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14823,
      GIR_Done,
    // Label 1164: @27907
    GIM_Reject,
    // Label 1154: @27908
    GIM_Reject,
    // Label 28: @27909
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 11, /*)*//*default:*//*Label 1168*/ 28225,
    /*GILLT_s32*//*Label 1165*/ 27923,
    /*GILLT_s64*//*Label 1166*/ 28062, 0, 0, 0, 0, 0,
    /*GILLT_v4s32*//*Label 1167*/ 28201,
    // Label 1165: @27923
    GIM_Try, /*On fail goto*//*Label 1169*/ 27946, // Rule ID 1200 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
      // (fp_to_sint:{ *:[i32] } FR32:{ *:[f32] }:$src)  =>  (VCVTTSS2SIrr:{ *:[i32] } FR32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSS2SIrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1200,
      GIR_Done,
    // Label 1169: @27946
    GIM_Try, /*On fail goto*//*Label 1170*/ 27969, // Rule ID 1204 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (fp_to_sint:{ *:[i32] } FR64:{ *:[f64] }:$src)  =>  (VCVTTSD2SIrr:{ *:[i32] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSD2SIrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1204,
      GIR_Done,
    // Label 1170: @27969
    GIM_Try, /*On fail goto*//*Label 1171*/ 27992, // Rule ID 1208 //
      GIM_CheckFeatures, GIFBS_UseSSE1,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
      // (fp_to_sint:{ *:[i32] } FR32:{ *:[f32] }:$src)  =>  (CVTTSS2SIrr:{ *:[i32] } FR32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTTSS2SIrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1208,
      GIR_Done,
    // Label 1171: @27992
    GIM_Try, /*On fail goto*//*Label 1172*/ 28015, // Rule ID 1212 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (fp_to_sint:{ *:[i32] } FR64:{ *:[f64] }:$src)  =>  (CVTTSD2SIrr:{ *:[i32] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTTSD2SIrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1212,
      GIR_Done,
    // Label 1172: @28015
    GIM_Try, /*On fail goto*//*Label 1173*/ 28038, // Rule ID 7797 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
      // (fp_to_sint:{ *:[i32] } FR32X:{ *:[f32] }:$src)  =>  (VCVTTSS2SIZrr:{ *:[i32] } FR32X:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSS2SIZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7797,
      GIR_Done,
    // Label 1173: @28038
    GIM_Try, /*On fail goto*//*Label 1174*/ 28061, // Rule ID 7807 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
      // (fp_to_sint:{ *:[i32] } FR64X:{ *:[f64] }:$src)  =>  (VCVTTSD2SIZrr:{ *:[i32] } FR64X:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSD2SIZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7807,
      GIR_Done,
    // Label 1174: @28061
    GIM_Reject,
    // Label 1166: @28062
    GIM_Try, /*On fail goto*//*Label 1175*/ 28085, // Rule ID 1202 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
      // (fp_to_sint:{ *:[i64] } FR32:{ *:[f32] }:$src)  =>  (VCVTTSS2SI64rr:{ *:[i64] } FR32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSS2SI64rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1202,
      GIR_Done,
    // Label 1175: @28085
    GIM_Try, /*On fail goto*//*Label 1176*/ 28108, // Rule ID 1206 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (fp_to_sint:{ *:[i64] } FR64:{ *:[f64] }:$src)  =>  (VCVTTSD2SI64rr:{ *:[i64] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSD2SI64rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1206,
      GIR_Done,
    // Label 1176: @28108
    GIM_Try, /*On fail goto*//*Label 1177*/ 28131, // Rule ID 1210 //
      GIM_CheckFeatures, GIFBS_UseSSE1,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
      // (fp_to_sint:{ *:[i64] } FR32:{ *:[f32] }:$src)  =>  (CVTTSS2SI64rr:{ *:[i64] } FR32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTTSS2SI64rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1210,
      GIR_Done,
    // Label 1177: @28131
    GIM_Try, /*On fail goto*//*Label 1178*/ 28154, // Rule ID 1214 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
      // (fp_to_sint:{ *:[i64] } FR64:{ *:[f64] }:$src)  =>  (CVTTSD2SI64rr:{ *:[i64] } FR64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTTSD2SI64rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1214,
      GIR_Done,
    // Label 1178: @28154
    GIM_Try, /*On fail goto*//*Label 1179*/ 28177, // Rule ID 7802 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
      // (fp_to_sint:{ *:[i64] } FR32X:{ *:[f32] }:$src)  =>  (VCVTTSS2SI64Zrr:{ *:[i64] } FR32X:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSS2SI64Zrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7802,
      GIR_Done,
    // Label 1179: @28177
    GIM_Try, /*On fail goto*//*Label 1180*/ 28200, // Rule ID 7812 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
      // (fp_to_sint:{ *:[i64] } FR64X:{ *:[f64] }:$src)  =>  (VCVTTSD2SI64Zrr:{ *:[i64] } FR64X:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSD2SI64Zrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7812,
      GIR_Done,
    // Label 1180: @28200
    GIM_Reject,
    // Label 1167: @28201
    GIM_Try, /*On fail goto*//*Label 1181*/ 28224, // Rule ID 12132 //
      GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
      // (fp_to_sint:{ *:[v4i32] } VR256:{ *:[v4f64] }:$src)  =>  (VCVTTPD2DQYrr:{ *:[v4i32] } VR256:{ *:[v4f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTPD2DQYrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12132,
      GIR_Done,
    // Label 1181: @28224
    GIM_Reject,
    // Label 1168: @28225
    GIM_Reject,
    // Label 29: @28226
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 5, /*)*//*default:*//*Label 1184*/ 28328,
    /*GILLT_s32*//*Label 1182*/ 28234,
    /*GILLT_s64*//*Label 1183*/ 28281,
    // Label 1182: @28234
    GIM_Try, /*On fail goto*//*Label 1185*/ 28257, // Rule ID 7817 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
      // (fp_to_uint:{ *:[i32] } FR32X:{ *:[f32] }:$src)  =>  (VCVTTSS2USIZrr:{ *:[i32] } FR32X:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSS2USIZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7817,
      GIR_Done,
    // Label 1185: @28257
    GIM_Try, /*On fail goto*//*Label 1186*/ 28280, // Rule ID 7827 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
      // (fp_to_uint:{ *:[i32] } FR64X:{ *:[f64] }:$src)  =>  (VCVTTSD2USIZrr:{ *:[i32] } FR64X:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSD2USIZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7827,
      GIR_Done,
    // Label 1186: @28280
    GIM_Reject,
    // Label 1183: @28281
    GIM_Try, /*On fail goto*//*Label 1187*/ 28304, // Rule ID 7822 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
      // (fp_to_uint:{ *:[i64] } FR32X:{ *:[f32] }:$src)  =>  (VCVTTSS2USI64Zrr:{ *:[i64] } FR32X:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSS2USI64Zrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7822,
      GIR_Done,
    // Label 1187: @28304
    GIM_Try, /*On fail goto*//*Label 1188*/ 28327, // Rule ID 7832 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
      // (fp_to_uint:{ *:[i64] } FR64X:{ *:[f64] }:$src)  =>  (VCVTTSD2USI64Zrr:{ *:[i64] } FR64X:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTTSD2USI64Zrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7832,
      GIR_Done,
    // Label 1188: @28327
    GIM_Reject,
    // Label 1184: @28328
    GIM_Reject,
    // Label 30: @28329
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 1197*/ 29158,
    /*GILLT_s32*//*Label 1189*/ 28352,
    /*GILLT_s64*//*Label 1190*/ 28591, 0, 0, 0,
    /*GILLT_v2s64*//*Label 1191*/ 28830, 0,
    /*GILLT_v4s32*//*Label 1192*/ 28854,
    /*GILLT_v4s64*//*Label 1193*/ 28947, 0, 0,
    /*GILLT_v8s32*//*Label 1194*/ 29017,
    /*GILLT_v8s64*//*Label 1195*/ 29087, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1196*/ 29134,
    // Label 1189: @28352
    GIM_Try, /*On fail goto*//*Label 1198*/ 28375, // Rule ID 1216 //
      GIM_CheckFeatures, GIFBS_UseSSE1,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sint_to_fp:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (CVTSI2SSrr:{ *:[f32] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTSI2SSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1216,
      GIR_Done,
    // Label 1198: @28375
    GIM_Try, /*On fail goto*//*Label 1199*/ 28398, // Rule ID 1218 //
      GIM_CheckFeatures, GIFBS_UseSSE1,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (sint_to_fp:{ *:[f32] } GR64:{ *:[i64] }:$src)  =>  (CVTSI642SSrr:{ *:[f32] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTSI642SSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1218,
      GIR_Done,
    // Label 1199: @28398
    GIM_Try, /*On fail goto*//*Label 1200*/ 28446, // Rule ID 12105 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sint_to_fp:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (VCVTSI2SSrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), GR32:{ *:[i32] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI2SSrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12105,
      GIR_Done,
    // Label 1200: @28446
    GIM_Try, /*On fail goto*//*Label 1201*/ 28494, // Rule ID 12106 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (sint_to_fp:{ *:[f32] } GR64:{ *:[i64] }:$src)  =>  (VCVTSI642SSrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), GR64:{ *:[i64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI642SSrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12106,
      GIR_Done,
    // Label 1201: @28494
    GIM_Try, /*On fail goto*//*Label 1202*/ 28542, // Rule ID 14790 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sint_to_fp:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (VCVTSI2SSZrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), GR32:{ *:[i32] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI2SSZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14790,
      GIR_Done,
    // Label 1202: @28542
    GIM_Try, /*On fail goto*//*Label 1203*/ 28590, // Rule ID 14791 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (sint_to_fp:{ *:[f32] } GR64:{ *:[i64] }:$src)  =>  (VCVTSI642SSZrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), GR64:{ *:[i64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI642SSZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14791,
      GIR_Done,
    // Label 1203: @28590
    GIM_Reject,
    // Label 1190: @28591
    GIM_Try, /*On fail goto*//*Label 1204*/ 28614, // Rule ID 1220 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sint_to_fp:{ *:[f64] } GR32:{ *:[i32] }:$src)  =>  (CVTSI2SDrr:{ *:[f64] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTSI2SDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1220,
      GIR_Done,
    // Label 1204: @28614
    GIM_Try, /*On fail goto*//*Label 1205*/ 28637, // Rule ID 1222 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (sint_to_fp:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (CVTSI642SDrr:{ *:[f64] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTSI642SDrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1222,
      GIR_Done,
    // Label 1205: @28637
    GIM_Try, /*On fail goto*//*Label 1206*/ 28685, // Rule ID 12107 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sint_to_fp:{ *:[f64] } GR32:{ *:[i32] }:$src)  =>  (VCVTSI2SDrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), GR32:{ *:[i32] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI2SDrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12107,
      GIR_Done,
    // Label 1206: @28685
    GIM_Try, /*On fail goto*//*Label 1207*/ 28733, // Rule ID 12108 //
      GIM_CheckFeatures, GIFBS_UseAVX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (sint_to_fp:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (VCVTSI642SDrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), GR64:{ *:[i64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI642SDrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 12108,
      GIR_Done,
    // Label 1207: @28733
    GIM_Try, /*On fail goto*//*Label 1208*/ 28781, // Rule ID 14792 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (sint_to_fp:{ *:[f64] } GR32:{ *:[i32] }:$src)  =>  (VCVTSI2SDZrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), GR32:{ *:[i32] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI2SDZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14792,
      GIR_Done,
    // Label 1208: @28781
    GIM_Try, /*On fail goto*//*Label 1209*/ 28829, // Rule ID 14793 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (sint_to_fp:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (VCVTSI642SDZrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), GR64:{ *:[i64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTSI642SDZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14793,
      GIR_Done,
    // Label 1209: @28829
    GIM_Reject,
    // Label 1191: @28830
    GIM_Try, /*On fail goto*//*Label 1210*/ 28853, // Rule ID 8476 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sint_to_fp:{ *:[v2f64] } VR128X:{ *:[v2i64] }:$src)  =>  (VCVTQQ2PDZ128rr:{ *:[v2f64] } VR128X:{ *:[v2i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTQQ2PDZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8476,
      GIR_Done,
    // Label 1210: @28853
    GIM_Reject,
    // Label 1192: @28854
    GIM_Try, /*On fail goto*//*Label 1211*/ 28877, // Rule ID 1256 //
      GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
      // (sint_to_fp:{ *:[v4f32] } VR128:{ *:[v4i32] }:$src)  =>  (VCVTDQ2PSrr:{ *:[v4f32] } VR128:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1256,
      GIR_Done,
    // Label 1211: @28877
    GIM_Try, /*On fail goto*//*Label 1212*/ 28900, // Rule ID 1260 //
      GIM_CheckFeatures, GIFBS_UseSSE2,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
      // (sint_to_fp:{ *:[v4f32] } VR128:{ *:[v4i32] }:$src)  =>  (CVTDQ2PSrr:{ *:[v4f32] } VR128:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::CVTDQ2PSrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1260,
      GIR_Done,
    // Label 1212: @28900
    GIM_Try, /*On fail goto*//*Label 1213*/ 28923, // Rule ID 7945 //
      GIM_CheckFeatures, GIFBS_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sint_to_fp:{ *:[v4f32] } VR128X:{ *:[v4i32] }:$src)  =>  (VCVTDQ2PSZ128rr:{ *:[v4f32] } VR128X:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PSZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7945,
      GIR_Done,
    // Label 1213: @28923
    GIM_Try, /*On fail goto*//*Label 1214*/ 28946, // Rule ID 8536 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sint_to_fp:{ *:[v4f32] } VR256X:{ *:[v4i64] }:$src)  =>  (VCVTQQ2PSZ256rr:{ *:[v4f32] } VR256X:{ *:[v4i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTQQ2PSZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8536,
      GIR_Done,
    // Label 1214: @28946
    GIM_Reject,
    // Label 1193: @28947
    GIM_Try, /*On fail goto*//*Label 1215*/ 28970, // Rule ID 1303 //
      GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
      // (sint_to_fp:{ *:[v4f64] } VR128:{ *:[v4i32] }:$src)  =>  (VCVTDQ2PDYrr:{ *:[v4f64] } VR128:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PDYrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1303,
      GIR_Done,
    // Label 1215: @28970
    GIM_Try, /*On fail goto*//*Label 1216*/ 28993, // Rule ID 7924 //
      GIM_CheckFeatures, GIFBS_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (sint_to_fp:{ *:[v4f64] } VR128X:{ *:[v4i32] }:$src)  =>  (VCVTDQ2PDZ256rr:{ *:[v4f64] } VR128X:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7924,
      GIR_Done,
    // Label 1216: @28993
    GIM_Try, /*On fail goto*//*Label 1217*/ 29016, // Rule ID 8485 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sint_to_fp:{ *:[v4f64] } VR256X:{ *:[v4i64] }:$src)  =>  (VCVTQQ2PDZ256rr:{ *:[v4f64] } VR256X:{ *:[v4i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTQQ2PDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8485,
      GIR_Done,
    // Label 1217: @29016
    GIM_Reject,
    // Label 1194: @29017
    GIM_Try, /*On fail goto*//*Label 1218*/ 29040, // Rule ID 1258 //
      GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
      // (sint_to_fp:{ *:[v8f32] } VR256:{ *:[v8i32] }:$src)  =>  (VCVTDQ2PSYrr:{ *:[v8f32] } VR256:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PSYrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 1258,
      GIR_Done,
    // Label 1218: @29040
    GIM_Try, /*On fail goto*//*Label 1219*/ 29063, // Rule ID 7954 //
      GIM_CheckFeatures, GIFBS_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sint_to_fp:{ *:[v8f32] } VR256X:{ *:[v8i32] }:$src)  =>  (VCVTDQ2PSZ256rr:{ *:[v8f32] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PSZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7954,
      GIR_Done,
    // Label 1219: @29063
    GIM_Try, /*On fail goto*//*Label 1220*/ 29086, // Rule ID 8524 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (sint_to_fp:{ *:[v8f32] } VR512:{ *:[v8i64] }:$src)  =>  (VCVTQQ2PSZrr:{ *:[v8f32] } VR512:{ *:[v8i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTQQ2PSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8524,
      GIR_Done,
    // Label 1220: @29086
    GIM_Reject,
    // Label 1195: @29087
    GIM_Try, /*On fail goto*//*Label 1221*/ 29110, // Rule ID 7906 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (sint_to_fp:{ *:[v8f64] } VR256X:{ *:[v8i32] }:$src)  =>  (VCVTDQ2PDZrr:{ *:[v8f64] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7906,
      GIR_Done,
    // Label 1221: @29110
    GIM_Try, /*On fail goto*//*Label 1222*/ 29133, // Rule ID 8464 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (sint_to_fp:{ *:[v8f64] } VR512:{ *:[v8i64] }:$src)  =>  (VCVTQQ2PDZrr:{ *:[v8f64] } VR512:{ *:[v8i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTQQ2PDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8464,
      GIR_Done,
    // Label 1222: @29133
    GIM_Reject,
    // Label 1196: @29134
    GIM_Try, /*On fail goto*//*Label 1223*/ 29157, // Rule ID 7933 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (sint_to_fp:{ *:[v16f32] } VR512:{ *:[v16i32] }:$src)  =>  (VCVTDQ2PSZrr:{ *:[v16f32] } VR512:{ *:[v16i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTDQ2PSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 7933,
      GIR_Done,
    // Label 1223: @29157
    GIM_Reject,
    // Label 1197: @29158
    GIM_Reject,
    // Label 31: @29159
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 1232*/ 29612,
    /*GILLT_s32*//*Label 1224*/ 29182,
    /*GILLT_s64*//*Label 1225*/ 29279, 0, 0, 0,
    /*GILLT_v2s64*//*Label 1226*/ 29376, 0,
    /*GILLT_v4s32*//*Label 1227*/ 29400,
    /*GILLT_v4s64*//*Label 1228*/ 29447, 0, 0,
    /*GILLT_v8s32*//*Label 1229*/ 29494,
    /*GILLT_v8s64*//*Label 1230*/ 29541, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1231*/ 29588,
    // Label 1224: @29182
    GIM_Try, /*On fail goto*//*Label 1233*/ 29230, // Rule ID 14798 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (uint_to_fp:{ *:[f32] } GR32:{ *:[i32] }:$src)  =>  (VCVTUSI2SSZrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), GR32:{ *:[i32] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTUSI2SSZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14798,
      GIR_Done,
    // Label 1233: @29230
    GIM_Try, /*On fail goto*//*Label 1234*/ 29278, // Rule ID 14799 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (uint_to_fp:{ *:[f32] } GR64:{ *:[i64] }:$src)  =>  (VCVTUSI642SSZrr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), GR64:{ *:[i64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTUSI642SSZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14799,
      GIR_Done,
    // Label 1234: @29278
    GIM_Reject,
    // Label 1225: @29279
    GIM_Try, /*On fail goto*//*Label 1235*/ 29327, // Rule ID 14800 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (uint_to_fp:{ *:[f64] } GR32:{ *:[i32] }:$src)  =>  (VCVTUSI2SDZrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), GR32:{ *:[i32] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTUSI2SDZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14800,
      GIR_Done,
    // Label 1235: @29327
    GIM_Try, /*On fail goto*//*Label 1236*/ 29375, // Rule ID 14801 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (uint_to_fp:{ *:[f64] } GR64:{ *:[i64] }:$src)  =>  (VCVTUSI642SDZrr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), GR64:{ *:[i64] }:$src)
      GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
      GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
      GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VCVTUSI642SDZrr,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 14801,
      GIR_Done,
    // Label 1236: @29375
    GIM_Reject,
    // Label 1226: @29376
    GIM_Try, /*On fail goto*//*Label 1237*/ 29399, // Rule ID 8506 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (uint_to_fp:{ *:[v2f64] } VR128X:{ *:[v2i64] }:$src)  =>  (VCVTUQQ2PDZ128rr:{ *:[v2f64] } VR128X:{ *:[v2i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUQQ2PDZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8506,
      GIR_Done,
    // Label 1237: @29399
    GIM_Reject,
    // Label 1227: @29400
    GIM_Try, /*On fail goto*//*Label 1238*/ 29423, // Rule ID 8104 //
      GIM_CheckFeatures, GIFBS_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (uint_to_fp:{ *:[v4f32] } VR128X:{ *:[v4i32] }:$src)  =>  (VCVTUDQ2PSZ128rr:{ *:[v4f32] } VR128X:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUDQ2PSZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8104,
      GIR_Done,
    // Label 1238: @29423
    GIM_Try, /*On fail goto*//*Label 1239*/ 29446, // Rule ID 8557 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (uint_to_fp:{ *:[v4f32] } VR256X:{ *:[v4i64] }:$src)  =>  (VCVTUQQ2PSZ256rr:{ *:[v4f32] } VR256X:{ *:[v4i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUQQ2PSZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8557,
      GIR_Done,
    // Label 1239: @29446
    GIM_Reject,
    // Label 1228: @29447
    GIM_Try, /*On fail goto*//*Label 1240*/ 29470, // Rule ID 8083 //
      GIM_CheckFeatures, GIFBS_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (uint_to_fp:{ *:[v4f64] } VR128X:{ *:[v4i32] }:$src)  =>  (VCVTUDQ2PDZ256rr:{ *:[v4f64] } VR128X:{ *:[v4i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUDQ2PDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8083,
      GIR_Done,
    // Label 1240: @29470
    GIM_Try, /*On fail goto*//*Label 1241*/ 29493, // Rule ID 8515 //
      GIM_CheckFeatures, GIFBS_HasDQI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (uint_to_fp:{ *:[v4f64] } VR256X:{ *:[v4i64] }:$src)  =>  (VCVTUQQ2PDZ256rr:{ *:[v4f64] } VR256X:{ *:[v4i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUQQ2PDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8515,
      GIR_Done,
    // Label 1241: @29493
    GIM_Reject,
    // Label 1229: @29494
    GIM_Try, /*On fail goto*//*Label 1242*/ 29517, // Rule ID 8113 //
      GIM_CheckFeatures, GIFBS_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (uint_to_fp:{ *:[v8f32] } VR256X:{ *:[v8i32] }:$src)  =>  (VCVTUDQ2PSZ256rr:{ *:[v8f32] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUDQ2PSZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8113,
      GIR_Done,
    // Label 1242: @29517
    GIM_Try, /*On fail goto*//*Label 1243*/ 29540, // Rule ID 8545 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (uint_to_fp:{ *:[v8f32] } VR512:{ *:[v8i64] }:$src)  =>  (VCVTUQQ2PSZrr:{ *:[v8f32] } VR512:{ *:[v8i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUQQ2PSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8545,
      GIR_Done,
    // Label 1243: @29540
    GIM_Reject,
    // Label 1230: @29541
    GIM_Try, /*On fail goto*//*Label 1244*/ 29564, // Rule ID 8065 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (uint_to_fp:{ *:[v8f64] } VR256X:{ *:[v8i32] }:$src)  =>  (VCVTUDQ2PDZrr:{ *:[v8f64] } VR256X:{ *:[v8i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUDQ2PDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8065,
      GIR_Done,
    // Label 1244: @29564
    GIM_Try, /*On fail goto*//*Label 1245*/ 29587, // Rule ID 8494 //
      GIM_CheckFeatures, GIFBS_HasDQI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (uint_to_fp:{ *:[v8f64] } VR512:{ *:[v8i64] }:$src)  =>  (VCVTUQQ2PDZrr:{ *:[v8f64] } VR512:{ *:[v8i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUQQ2PDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8494,
      GIR_Done,
    // Label 1245: @29587
    GIM_Reject,
    // Label 1231: @29588
    GIM_Try, /*On fail goto*//*Label 1246*/ 29611, // Rule ID 8092 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (uint_to_fp:{ *:[v16f32] } VR512:{ *:[v16i32] }:$src)  =>  (VCVTUDQ2PSZrr:{ *:[v16f32] } VR512:{ *:[v16i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VCVTUDQ2PSZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8092,
      GIR_Done,
    // Label 1246: @29611
    GIM_Reject,
    // Label 1232: @29612
    GIM_Reject,
    // Label 32: @29613
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 6, /*)*//*default:*//*Label 1250*/ 29710,
    /*GILLT_s32*//*Label 1247*/ 29622,
    /*GILLT_s64*//*Label 1248*/ 29652,
    /*GILLT_s80*//*Label 1249*/ 29682,
    // Label 1247: @29622
    GIM_Try, /*On fail goto*//*Label 1251*/ 29651, // Rule ID 686 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
      // (fabs:{ *:[f32] } RFP32:{ *:[f32] }:$src)  =>  (ABS_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ABS_Fp32,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 686,
      GIR_Done,
    // Label 1251: @29651
    GIM_Reject,
    // Label 1248: @29652
    GIM_Try, /*On fail goto*//*Label 1252*/ 29681, // Rule ID 687 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
      // (fabs:{ *:[f64] } RFP64:{ *:[f64] }:$src)  =>  (ABS_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ABS_Fp64,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 687,
      GIR_Done,
    // Label 1252: @29681
    GIM_Reject,
    // Label 1249: @29682
    GIM_Try, /*On fail goto*//*Label 1253*/ 29709, // Rule ID 688 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fabs:{ *:[f80] } RFP80:{ *:[f80] }:$src)  =>  (ABS_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::ABS_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 688,
      GIR_Done,
    // Label 1253: @29709
    GIM_Reject,
    // Label 1250: @29710
    GIM_Reject,
    // Label 33: @29711
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/8, 25, /*)*//*default:*//*Label 1266*/ 30343,
    /*GILLT_v2s64*//*Label 1254*/ 29734, 0,
    /*GILLT_v4s32*//*Label 1255*/ 29766,
    /*GILLT_v4s64*//*Label 1256*/ 29847, 0,
    /*GILLT_v8s16*//*Label 1257*/ 29879,
    /*GILLT_v8s32*//*Label 1258*/ 29960,
    /*GILLT_v8s64*//*Label 1259*/ 30018, 0,
    /*GILLT_v16s8*//*Label 1260*/ 30050,
    /*GILLT_v16s16*//*Label 1261*/ 30131,
    /*GILLT_v16s32*//*Label 1262*/ 30189, 0,
    /*GILLT_v32s8*//*Label 1263*/ 30221,
    /*GILLT_v32s16*//*Label 1264*/ 30279, 0,
    /*GILLT_v64s8*//*Label 1265*/ 30311,
    // Label 1254: @29734
    GIM_Try, /*On fail goto*//*Label 1267*/ 29765, // Rule ID 4623 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
      // (smin:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPMINSQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4623,
      GIR_Done,
    // Label 1267: @29765
    GIM_Reject,
    // Label 1255: @29766
    GIM_Try, /*On fail goto*//*Label 1268*/ 29846,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1269*/ 29799, // Rule ID 2309 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smin:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPMINSDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2309,
        GIR_Done,
      // Label 1269: @29799
      GIM_Try, /*On fail goto*//*Label 1270*/ 29822, // Rule ID 2347 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smin:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PMINSDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMINSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2347,
        GIR_Done,
      // Label 1270: @29822
      GIM_Try, /*On fail goto*//*Label 1271*/ 29845, // Rule ID 4596 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (smin:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPMINSDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4596,
        GIR_Done,
      // Label 1271: @29845
      GIM_Reject,
    // Label 1268: @29846
    GIM_Reject,
    // Label 1256: @29847
    GIM_Try, /*On fail goto*//*Label 1272*/ 29878, // Rule ID 4614 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
      // (smin:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPMINSQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4614,
      GIR_Done,
    // Label 1272: @29878
    GIM_Reject,
    // Label 1257: @29879
    GIM_Try, /*On fail goto*//*Label 1273*/ 29959,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 1274*/ 29912, // Rule ID 1786 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smin:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMINSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1786,
        GIR_Done,
      // Label 1274: @29912
      GIM_Try, /*On fail goto*//*Label 1275*/ 29935, // Rule ID 1788 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smin:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMINSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMINSWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1788,
        GIR_Done,
      // Label 1275: @29935
      GIM_Try, /*On fail goto*//*Label 1276*/ 29958, // Rule ID 4572 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (smin:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMINSWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4572,
        GIR_Done,
      // Label 1276: @29958
      GIM_Reject,
    // Label 1273: @29959
    GIM_Reject,
    // Label 1258: @29960
    GIM_Try, /*On fail goto*//*Label 1277*/ 30017,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1278*/ 29993, // Rule ID 2327 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (smin:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPMINSDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2327,
        GIR_Done,
      // Label 1278: @29993
      GIM_Try, /*On fail goto*//*Label 1279*/ 30016, // Rule ID 4587 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (smin:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPMINSDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4587,
        GIR_Done,
      // Label 1279: @30016
      GIM_Reject,
    // Label 1277: @30017
    GIM_Reject,
    // Label 1259: @30018
    GIM_Try, /*On fail goto*//*Label 1280*/ 30049, // Rule ID 4605 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smin:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPMINSQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4605,
      GIR_Done,
    // Label 1280: @30049
    GIM_Reject,
    // Label 1260: @30050
    GIM_Try, /*On fail goto*//*Label 1281*/ 30130,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 1282*/ 30083, // Rule ID 2319 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smin:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPMINSBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2319,
        GIR_Done,
      // Label 1282: @30083
      GIM_Try, /*On fail goto*//*Label 1283*/ 30106, // Rule ID 2345 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smin:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PMINSBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMINSBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2345,
        GIR_Done,
      // Label 1283: @30106
      GIM_Try, /*On fail goto*//*Label 1284*/ 30129, // Rule ID 4554 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (smin:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPMINSBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSBZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4554,
        GIR_Done,
      // Label 1284: @30129
      GIM_Reject,
    // Label 1281: @30130
    GIM_Reject,
    // Label 1261: @30131
    GIM_Try, /*On fail goto*//*Label 1285*/ 30188,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 1286*/ 30164, // Rule ID 1790 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (smin:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMINSWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1790,
        GIR_Done,
      // Label 1286: @30164
      GIM_Try, /*On fail goto*//*Label 1287*/ 30187, // Rule ID 4566 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (smin:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMINSWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4566,
        GIR_Done,
      // Label 1287: @30187
      GIM_Reject,
    // Label 1285: @30188
    GIM_Reject,
    // Label 1262: @30189
    GIM_Try, /*On fail goto*//*Label 1288*/ 30220, // Rule ID 4578 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smin:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPMINSDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4578,
      GIR_Done,
    // Label 1288: @30220
    GIM_Reject,
    // Label 1263: @30221
    GIM_Try, /*On fail goto*//*Label 1289*/ 30278,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 1290*/ 30254, // Rule ID 2337 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (smin:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPMINSBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSBYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2337,
        GIR_Done,
      // Label 1290: @30254
      GIM_Try, /*On fail goto*//*Label 1291*/ 30277, // Rule ID 4548 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (smin:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPMINSBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSBZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4548,
        GIR_Done,
      // Label 1291: @30277
      GIM_Reject,
    // Label 1289: @30278
    GIM_Reject,
    // Label 1264: @30279
    GIM_Try, /*On fail goto*//*Label 1292*/ 30310, // Rule ID 4560 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smin:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMINSWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4560,
      GIR_Done,
    // Label 1292: @30310
    GIM_Reject,
    // Label 1265: @30311
    GIM_Try, /*On fail goto*//*Label 1293*/ 30342, // Rule ID 4542 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smin:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPMINSBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINSBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4542,
      GIR_Done,
    // Label 1293: @30342
    GIM_Reject,
    // Label 1266: @30343
    GIM_Reject,
    // Label 34: @30344
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/8, 25, /*)*//*default:*//*Label 1306*/ 30976,
    /*GILLT_v2s64*//*Label 1294*/ 30367, 0,
    /*GILLT_v4s32*//*Label 1295*/ 30399,
    /*GILLT_v4s64*//*Label 1296*/ 30480, 0,
    /*GILLT_v8s16*//*Label 1297*/ 30512,
    /*GILLT_v8s32*//*Label 1298*/ 30593,
    /*GILLT_v8s64*//*Label 1299*/ 30651, 0,
    /*GILLT_v16s8*//*Label 1300*/ 30683,
    /*GILLT_v16s16*//*Label 1301*/ 30764,
    /*GILLT_v16s32*//*Label 1302*/ 30822, 0,
    /*GILLT_v32s8*//*Label 1303*/ 30854,
    /*GILLT_v32s16*//*Label 1304*/ 30912, 0,
    /*GILLT_v64s8*//*Label 1305*/ 30944,
    // Label 1294: @30367
    GIM_Try, /*On fail goto*//*Label 1307*/ 30398, // Rule ID 4443 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
      // (smax:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPMAXSQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4443,
      GIR_Done,
    // Label 1307: @30398
    GIM_Reject,
    // Label 1295: @30399
    GIM_Try, /*On fail goto*//*Label 1308*/ 30479,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1309*/ 30432, // Rule ID 2313 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smax:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPMAXSDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2313,
        GIR_Done,
      // Label 1309: @30432
      GIM_Try, /*On fail goto*//*Label 1310*/ 30455, // Rule ID 2355 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smax:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PMAXSDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMAXSDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2355,
        GIR_Done,
      // Label 1310: @30455
      GIM_Try, /*On fail goto*//*Label 1311*/ 30478, // Rule ID 4416 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (smax:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPMAXSDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4416,
        GIR_Done,
      // Label 1311: @30478
      GIM_Reject,
    // Label 1308: @30479
    GIM_Reject,
    // Label 1296: @30480
    GIM_Try, /*On fail goto*//*Label 1312*/ 30511, // Rule ID 4434 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
      // (smax:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPMAXSQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4434,
      GIR_Done,
    // Label 1312: @30511
    GIM_Reject,
    // Label 1297: @30512
    GIM_Try, /*On fail goto*//*Label 1313*/ 30592,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 1314*/ 30545, // Rule ID 1798 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smax:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMAXSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1798,
        GIR_Done,
      // Label 1314: @30545
      GIM_Try, /*On fail goto*//*Label 1315*/ 30568, // Rule ID 1800 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smax:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMAXSWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMAXSWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1800,
        GIR_Done,
      // Label 1315: @30568
      GIM_Try, /*On fail goto*//*Label 1316*/ 30591, // Rule ID 4392 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (smax:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMAXSWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4392,
        GIR_Done,
      // Label 1316: @30591
      GIM_Reject,
    // Label 1313: @30592
    GIM_Reject,
    // Label 1298: @30593
    GIM_Try, /*On fail goto*//*Label 1317*/ 30650,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1318*/ 30626, // Rule ID 2331 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (smax:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPMAXSDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2331,
        GIR_Done,
      // Label 1318: @30626
      GIM_Try, /*On fail goto*//*Label 1319*/ 30649, // Rule ID 4407 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (smax:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPMAXSDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4407,
        GIR_Done,
      // Label 1319: @30649
      GIM_Reject,
    // Label 1317: @30650
    GIM_Reject,
    // Label 1299: @30651
    GIM_Try, /*On fail goto*//*Label 1320*/ 30682, // Rule ID 4425 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smax:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPMAXSQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4425,
      GIR_Done,
    // Label 1320: @30682
    GIM_Reject,
    // Label 1300: @30683
    GIM_Try, /*On fail goto*//*Label 1321*/ 30763,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 1322*/ 30716, // Rule ID 2323 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smax:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPMAXSBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2323,
        GIR_Done,
      // Label 1322: @30716
      GIM_Try, /*On fail goto*//*Label 1323*/ 30739, // Rule ID 2353 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (smax:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PMAXSBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMAXSBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2353,
        GIR_Done,
      // Label 1323: @30739
      GIM_Try, /*On fail goto*//*Label 1324*/ 30762, // Rule ID 4374 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (smax:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPMAXSBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSBZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4374,
        GIR_Done,
      // Label 1324: @30762
      GIM_Reject,
    // Label 1321: @30763
    GIM_Reject,
    // Label 1301: @30764
    GIM_Try, /*On fail goto*//*Label 1325*/ 30821,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 1326*/ 30797, // Rule ID 1802 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (smax:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMAXSWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1802,
        GIR_Done,
      // Label 1326: @30797
      GIM_Try, /*On fail goto*//*Label 1327*/ 30820, // Rule ID 4386 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (smax:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMAXSWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4386,
        GIR_Done,
      // Label 1327: @30820
      GIM_Reject,
    // Label 1325: @30821
    GIM_Reject,
    // Label 1302: @30822
    GIM_Try, /*On fail goto*//*Label 1328*/ 30853, // Rule ID 4398 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smax:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPMAXSDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4398,
      GIR_Done,
    // Label 1328: @30853
    GIM_Reject,
    // Label 1303: @30854
    GIM_Try, /*On fail goto*//*Label 1329*/ 30911,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 1330*/ 30887, // Rule ID 2341 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (smax:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPMAXSBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSBYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2341,
        GIR_Done,
      // Label 1330: @30887
      GIM_Try, /*On fail goto*//*Label 1331*/ 30910, // Rule ID 4368 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (smax:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPMAXSBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSBZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4368,
        GIR_Done,
      // Label 1331: @30910
      GIM_Reject,
    // Label 1329: @30911
    GIM_Reject,
    // Label 1304: @30912
    GIM_Try, /*On fail goto*//*Label 1332*/ 30943, // Rule ID 4380 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smax:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMAXSWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4380,
      GIR_Done,
    // Label 1332: @30943
    GIM_Reject,
    // Label 1305: @30944
    GIM_Try, /*On fail goto*//*Label 1333*/ 30975, // Rule ID 4362 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (smax:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPMAXSBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXSBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4362,
      GIR_Done,
    // Label 1333: @30975
    GIM_Reject,
    // Label 1306: @30976
    GIM_Reject,
    // Label 35: @30977
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/8, 25, /*)*//*default:*//*Label 1346*/ 31609,
    /*GILLT_v2s64*//*Label 1334*/ 31000, 0,
    /*GILLT_v4s32*//*Label 1335*/ 31032,
    /*GILLT_v4s64*//*Label 1336*/ 31113, 0,
    /*GILLT_v8s16*//*Label 1337*/ 31145,
    /*GILLT_v8s32*//*Label 1338*/ 31226,
    /*GILLT_v8s64*//*Label 1339*/ 31284, 0,
    /*GILLT_v16s8*//*Label 1340*/ 31316,
    /*GILLT_v16s16*//*Label 1341*/ 31397,
    /*GILLT_v16s32*//*Label 1342*/ 31455, 0,
    /*GILLT_v32s8*//*Label 1343*/ 31487,
    /*GILLT_v32s16*//*Label 1344*/ 31545, 0,
    /*GILLT_v64s8*//*Label 1345*/ 31577,
    // Label 1334: @31000
    GIM_Try, /*On fail goto*//*Label 1347*/ 31031, // Rule ID 4713 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
      // (umin:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPMINUQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4713,
      GIR_Done,
    // Label 1347: @31031
    GIM_Reject,
    // Label 1335: @31032
    GIM_Try, /*On fail goto*//*Label 1348*/ 31112,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1349*/ 31065, // Rule ID 2311 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umin:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPMINUDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2311,
        GIR_Done,
      // Label 1349: @31065
      GIM_Try, /*On fail goto*//*Label 1350*/ 31088, // Rule ID 2349 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umin:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PMINUDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMINUDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2349,
        GIR_Done,
      // Label 1350: @31088
      GIM_Try, /*On fail goto*//*Label 1351*/ 31111, // Rule ID 4686 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (umin:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPMINUDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4686,
        GIR_Done,
      // Label 1351: @31111
      GIM_Reject,
    // Label 1348: @31112
    GIM_Reject,
    // Label 1336: @31113
    GIM_Try, /*On fail goto*//*Label 1352*/ 31144, // Rule ID 4704 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
      // (umin:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPMINUQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4704,
      GIR_Done,
    // Label 1352: @31144
    GIM_Reject,
    // Label 1337: @31145
    GIM_Try, /*On fail goto*//*Label 1353*/ 31225,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 1354*/ 31178, // Rule ID 2321 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umin:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMINUWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2321,
        GIR_Done,
      // Label 1354: @31178
      GIM_Try, /*On fail goto*//*Label 1355*/ 31201, // Rule ID 2351 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umin:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMINUWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMINUWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2351,
        GIR_Done,
      // Label 1355: @31201
      GIM_Try, /*On fail goto*//*Label 1356*/ 31224, // Rule ID 4662 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (umin:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMINUWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4662,
        GIR_Done,
      // Label 1356: @31224
      GIM_Reject,
    // Label 1353: @31225
    GIM_Reject,
    // Label 1338: @31226
    GIM_Try, /*On fail goto*//*Label 1357*/ 31283,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1358*/ 31259, // Rule ID 2329 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (umin:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPMINUDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2329,
        GIR_Done,
      // Label 1358: @31259
      GIM_Try, /*On fail goto*//*Label 1359*/ 31282, // Rule ID 4677 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (umin:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPMINUDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4677,
        GIR_Done,
      // Label 1359: @31282
      GIM_Reject,
    // Label 1357: @31283
    GIM_Reject,
    // Label 1339: @31284
    GIM_Try, /*On fail goto*//*Label 1360*/ 31315, // Rule ID 4695 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umin:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPMINUQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4695,
      GIR_Done,
    // Label 1360: @31315
    GIM_Reject,
    // Label 1340: @31316
    GIM_Try, /*On fail goto*//*Label 1361*/ 31396,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 1362*/ 31349, // Rule ID 1780 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umin:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPMINUBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1780,
        GIR_Done,
      // Label 1362: @31349
      GIM_Try, /*On fail goto*//*Label 1363*/ 31372, // Rule ID 1782 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umin:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PMINUBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMINUBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1782,
        GIR_Done,
      // Label 1363: @31372
      GIM_Try, /*On fail goto*//*Label 1364*/ 31395, // Rule ID 4644 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (umin:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPMINUBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUBZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4644,
        GIR_Done,
      // Label 1364: @31395
      GIM_Reject,
    // Label 1361: @31396
    GIM_Reject,
    // Label 1341: @31397
    GIM_Try, /*On fail goto*//*Label 1365*/ 31454,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 1366*/ 31430, // Rule ID 2339 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (umin:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMINUWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2339,
        GIR_Done,
      // Label 1366: @31430
      GIM_Try, /*On fail goto*//*Label 1367*/ 31453, // Rule ID 4656 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (umin:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMINUWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4656,
        GIR_Done,
      // Label 1367: @31453
      GIM_Reject,
    // Label 1365: @31454
    GIM_Reject,
    // Label 1342: @31455
    GIM_Try, /*On fail goto*//*Label 1368*/ 31486, // Rule ID 4668 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umin:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPMINUDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4668,
      GIR_Done,
    // Label 1368: @31486
    GIM_Reject,
    // Label 1343: @31487
    GIM_Try, /*On fail goto*//*Label 1369*/ 31544,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 1370*/ 31520, // Rule ID 1784 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (umin:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPMINUBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUBYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1784,
        GIR_Done,
      // Label 1370: @31520
      GIM_Try, /*On fail goto*//*Label 1371*/ 31543, // Rule ID 4638 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (umin:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPMINUBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUBZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4638,
        GIR_Done,
      // Label 1371: @31543
      GIM_Reject,
    // Label 1369: @31544
    GIM_Reject,
    // Label 1344: @31545
    GIM_Try, /*On fail goto*//*Label 1372*/ 31576, // Rule ID 4650 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umin:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMINUWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4650,
      GIR_Done,
    // Label 1372: @31576
    GIM_Reject,
    // Label 1345: @31577
    GIM_Try, /*On fail goto*//*Label 1373*/ 31608, // Rule ID 4632 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umin:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPMINUBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMINUBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4632,
      GIR_Done,
    // Label 1373: @31608
    GIM_Reject,
    // Label 1346: @31609
    GIM_Reject,
    // Label 36: @31610
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/8, 25, /*)*//*default:*//*Label 1386*/ 32242,
    /*GILLT_v2s64*//*Label 1374*/ 31633, 0,
    /*GILLT_v4s32*//*Label 1375*/ 31665,
    /*GILLT_v4s64*//*Label 1376*/ 31746, 0,
    /*GILLT_v8s16*//*Label 1377*/ 31778,
    /*GILLT_v8s32*//*Label 1378*/ 31859,
    /*GILLT_v8s64*//*Label 1379*/ 31917, 0,
    /*GILLT_v16s8*//*Label 1380*/ 31949,
    /*GILLT_v16s16*//*Label 1381*/ 32030,
    /*GILLT_v16s32*//*Label 1382*/ 32088, 0,
    /*GILLT_v32s8*//*Label 1383*/ 32120,
    /*GILLT_v32s16*//*Label 1384*/ 32178, 0,
    /*GILLT_v64s8*//*Label 1385*/ 32210,
    // Label 1374: @31633
    GIM_Try, /*On fail goto*//*Label 1387*/ 31664, // Rule ID 4533 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
      // (umax:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)  =>  (VPMAXUQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1, VR128X:{ *:[v2i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4533,
      GIR_Done,
    // Label 1387: @31664
    GIM_Reject,
    // Label 1375: @31665
    GIM_Try, /*On fail goto*//*Label 1388*/ 31745,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1389*/ 31698, // Rule ID 2315 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umax:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (VPMAXUDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2315,
        GIR_Done,
      // Label 1389: @31698
      GIM_Try, /*On fail goto*//*Label 1390*/ 31721, // Rule ID 2357 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umax:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)  =>  (PMAXUDrr:{ *:[v4i32] } VR128:{ *:[v4i32] }:$src1, VR128:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMAXUDrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2357,
        GIR_Done,
      // Label 1390: @31721
      GIM_Try, /*On fail goto*//*Label 1391*/ 31744, // Rule ID 4506 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (umax:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)  =>  (VPMAXUDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1, VR128X:{ *:[v4i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUDZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4506,
        GIR_Done,
      // Label 1391: @31744
      GIM_Reject,
    // Label 1388: @31745
    GIM_Reject,
    // Label 1376: @31746
    GIM_Try, /*On fail goto*//*Label 1392*/ 31777, // Rule ID 4524 //
      GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
      // (umax:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)  =>  (VPMAXUQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1, VR256X:{ *:[v4i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4524,
      GIR_Done,
    // Label 1392: @31777
    GIM_Reject,
    // Label 1377: @31778
    GIM_Try, /*On fail goto*//*Label 1393*/ 31858,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s16,
      GIM_Try, /*On fail goto*//*Label 1394*/ 31811, // Rule ID 2325 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umax:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (VPMAXUWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2325,
        GIR_Done,
      // Label 1394: @31811
      GIM_Try, /*On fail goto*//*Label 1395*/ 31834, // Rule ID 2359 //
        GIM_CheckFeatures, GIFBS_UseSSE41,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umax:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)  =>  (PMAXUWrr:{ *:[v8i16] } VR128:{ *:[v8i16] }:$src1, VR128:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMAXUWrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2359,
        GIR_Done,
      // Label 1395: @31834
      GIM_Try, /*On fail goto*//*Label 1396*/ 31857, // Rule ID 4482 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (umax:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)  =>  (VPMAXUWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1, VR128X:{ *:[v8i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUWZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4482,
        GIR_Done,
      // Label 1396: @31857
      GIM_Reject,
    // Label 1393: @31858
    GIM_Reject,
    // Label 1378: @31859
    GIM_Try, /*On fail goto*//*Label 1397*/ 31916,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1398*/ 31892, // Rule ID 2333 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (umax:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)  =>  (VPMAXUDYrr:{ *:[v8i32] } VR256:{ *:[v8i32] }:$src1, VR256:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUDYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2333,
        GIR_Done,
      // Label 1398: @31892
      GIM_Try, /*On fail goto*//*Label 1399*/ 31915, // Rule ID 4497 //
        GIM_CheckFeatures, GIFBS_HasAVX512_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (umax:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)  =>  (VPMAXUDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1, VR256X:{ *:[v8i32] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUDZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4497,
        GIR_Done,
      // Label 1399: @31915
      GIM_Reject,
    // Label 1397: @31916
    GIM_Reject,
    // Label 1379: @31917
    GIM_Try, /*On fail goto*//*Label 1400*/ 31948, // Rule ID 4515 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umax:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)  =>  (VPMAXUQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1, VR512:{ *:[v8i64] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4515,
      GIR_Done,
    // Label 1400: @31948
    GIM_Reject,
    // Label 1380: @31949
    GIM_Try, /*On fail goto*//*Label 1401*/ 32029,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s8,
      GIM_Try, /*On fail goto*//*Label 1402*/ 31982, // Rule ID 1792 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umax:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (VPMAXUBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1792,
        GIR_Done,
      // Label 1402: @31982
      GIM_Try, /*On fail goto*//*Label 1403*/ 32005, // Rule ID 1794 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128RegClassID,
        // (umax:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)  =>  (PMAXUBrr:{ *:[v16i8] } VR128:{ *:[v16i8] }:$src1, VR128:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::PMAXUBrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1794,
        GIR_Done,
      // Label 1403: @32005
      GIM_Try, /*On fail goto*//*Label 1404*/ 32028, // Rule ID 4464 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR128XRegClassID,
        // (umax:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)  =>  (VPMAXUBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1, VR128X:{ *:[v16i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUBZ128rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4464,
        GIR_Done,
      // Label 1404: @32028
      GIM_Reject,
    // Label 1401: @32029
    GIM_Reject,
    // Label 1381: @32030
    GIM_Try, /*On fail goto*//*Label 1405*/ 32087,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s16,
      GIM_Try, /*On fail goto*//*Label 1406*/ 32063, // Rule ID 2343 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (umax:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)  =>  (VPMAXUWYrr:{ *:[v16i16] } VR256:{ *:[v16i16] }:$src1, VR256:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUWYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 2343,
        GIR_Done,
      // Label 1406: @32063
      GIM_Try, /*On fail goto*//*Label 1407*/ 32086, // Rule ID 4476 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (umax:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)  =>  (VPMAXUWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1, VR256X:{ *:[v16i16] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUWZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4476,
        GIR_Done,
      // Label 1407: @32086
      GIM_Reject,
    // Label 1405: @32087
    GIM_Reject,
    // Label 1382: @32088
    GIM_Try, /*On fail goto*//*Label 1408*/ 32119, // Rule ID 4488 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umax:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)  =>  (VPMAXUDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1, VR512:{ *:[v16i32] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4488,
      GIR_Done,
    // Label 1408: @32119
    GIM_Reject,
    // Label 1383: @32120
    GIM_Try, /*On fail goto*//*Label 1409*/ 32177,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s8,
      GIM_Try, /*On fail goto*//*Label 1410*/ 32153, // Rule ID 1796 //
        GIM_CheckFeatures, GIFBS_HasAVX2_NoVLX_Or_NoBWI,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256RegClassID,
        // (umax:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)  =>  (VPMAXUBYrr:{ *:[v32i8] } VR256:{ *:[v32i8] }:$src1, VR256:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUBYrr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1796,
        GIR_Done,
      // Label 1410: @32153
      GIM_Try, /*On fail goto*//*Label 1411*/ 32176, // Rule ID 4458 //
        GIM_CheckFeatures, GIFBS_HasBWI_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR256XRegClassID,
        // (umax:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)  =>  (VPMAXUBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1, VR256X:{ *:[v32i8] }:$src2)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUBZ256rr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 4458,
        GIR_Done,
      // Label 1411: @32176
      GIM_Reject,
    // Label 1409: @32177
    GIM_Reject,
    // Label 1384: @32178
    GIM_Try, /*On fail goto*//*Label 1412*/ 32209, // Rule ID 4470 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umax:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)  =>  (VPMAXUWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1, VR512:{ *:[v32i16] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4470,
      GIR_Done,
    // Label 1412: @32209
    GIM_Reject,
    // Label 1385: @32210
    GIM_Try, /*On fail goto*//*Label 1413*/ 32241, // Rule ID 4452 //
      GIM_CheckFeatures, GIFBS_HasBWI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/X86::VR512RegClassID,
      // (umax:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)  =>  (VPMAXUBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1, VR512:{ *:[v64i8] }:$src2)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPMAXUBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 4452,
      GIR_Done,
    // Label 1413: @32241
    GIM_Reject,
    // Label 1386: @32242
    GIM_Reject,
    // Label 37: @32243
    GIM_Try, /*On fail goto*//*Label 1414*/ 32255, // Rule ID 424 //
      // MIs[0] dst
      GIM_CheckIsMBB, /*MI*/0, /*Op*/0,
      // (br (bb:{ *:[Other] }):$dst)  =>  (JMP_1 (bb:{ *:[Other] }):$dst)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::JMP_1,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 424,
      GIR_Done,
    // Label 1414: @32255
    GIM_Reject,
    // Label 38: @32256
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/2, 5, /*)*//*default:*//*Label 1418*/ 32340,
    /*GILLT_s16*//*Label 1415*/ 32265,
    /*GILLT_s32*//*Label 1416*/ 32290,
    /*GILLT_s64*//*Label 1417*/ 32315,
    // Label 1415: @32265
    GIM_Try, /*On fail goto*//*Label 1419*/ 32289, // Rule ID 16071 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      // (cttz_zero_undef:{ *:[i16] } GR16:{ *:[i16] }:$src)  =>  (BSF16rr:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::BSF16rr,
      GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 16071,
      GIR_Done,
    // Label 1419: @32289
    GIM_Reject,
    // Label 1416: @32290
    GIM_Try, /*On fail goto*//*Label 1420*/ 32314, // Rule ID 16072 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (cttz_zero_undef:{ *:[i32] } GR32:{ *:[i32] }:$src)  =>  (BSF32rr:{ *:[i32] }:{ *:[i32] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::BSF32rr,
      GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 16072,
      GIR_Done,
    // Label 1420: @32314
    GIM_Reject,
    // Label 1417: @32315
    GIM_Try, /*On fail goto*//*Label 1421*/ 32339, // Rule ID 16073 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (cttz_zero_undef:{ *:[i64] } GR64:{ *:[i64] }:$src)  =>  (BSF64rr:{ *:[i64] }:{ *:[i32] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::BSF64rr,
      GIR_AddImplicitDef, /*InsnID*/0, X86::EFLAGS,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 16073,
      GIR_Done,
    // Label 1421: @32339
    GIM_Reject,
    // Label 1418: @32340
    GIM_Reject,
    // Label 39: @32341
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/8, 20, /*)*//*default:*//*Label 1428*/ 32503,
    /*GILLT_v2s64*//*Label 1422*/ 32359, 0,
    /*GILLT_v4s32*//*Label 1423*/ 32383,
    /*GILLT_v4s64*//*Label 1424*/ 32407, 0, 0,
    /*GILLT_v8s32*//*Label 1425*/ 32431,
    /*GILLT_v8s64*//*Label 1426*/ 32455, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1427*/ 32479,
    // Label 1422: @32359
    GIM_Try, /*On fail goto*//*Label 1429*/ 32382, // Rule ID 10036 //
      GIM_CheckFeatures, GIFBS_HasCDI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (ctlz:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1)  =>  (VPLZCNTQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPLZCNTQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10036,
      GIR_Done,
    // Label 1429: @32382
    GIM_Reject,
    // Label 1423: @32383
    GIM_Try, /*On fail goto*//*Label 1430*/ 32406, // Rule ID 10063 //
      GIM_CheckFeatures, GIFBS_HasCDI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (ctlz:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1)  =>  (VPLZCNTDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPLZCNTDZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10063,
      GIR_Done,
    // Label 1430: @32406
    GIM_Reject,
    // Label 1424: @32407
    GIM_Try, /*On fail goto*//*Label 1431*/ 32430, // Rule ID 10027 //
      GIM_CheckFeatures, GIFBS_HasCDI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (ctlz:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1)  =>  (VPLZCNTQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPLZCNTQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10027,
      GIR_Done,
    // Label 1431: @32430
    GIM_Reject,
    // Label 1425: @32431
    GIM_Try, /*On fail goto*//*Label 1432*/ 32454, // Rule ID 10054 //
      GIM_CheckFeatures, GIFBS_HasCDI_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (ctlz:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1)  =>  (VPLZCNTDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPLZCNTDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10054,
      GIR_Done,
    // Label 1432: @32454
    GIM_Reject,
    // Label 1426: @32455
    GIM_Try, /*On fail goto*//*Label 1433*/ 32478, // Rule ID 10018 //
      GIM_CheckFeatures, GIFBS_HasCDI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (ctlz:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1)  =>  (VPLZCNTQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPLZCNTQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10018,
      GIR_Done,
    // Label 1433: @32478
    GIM_Reject,
    // Label 1427: @32479
    GIM_Try, /*On fail goto*//*Label 1434*/ 32502, // Rule ID 10045 //
      GIM_CheckFeatures, GIFBS_HasCDI,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (ctlz:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1)  =>  (VPLZCNTDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPLZCNTDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10045,
      GIR_Done,
    // Label 1434: @32502
    GIM_Reject,
    // Label 1428: @32503
    GIM_Reject,
    // Label 40: @32504
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/8, 25, /*)*//*default:*//*Label 1447*/ 32815,
    /*GILLT_v2s64*//*Label 1435*/ 32527, 0,
    /*GILLT_v4s32*//*Label 1436*/ 32551,
    /*GILLT_v4s64*//*Label 1437*/ 32575, 0,
    /*GILLT_v8s16*//*Label 1438*/ 32599,
    /*GILLT_v8s32*//*Label 1439*/ 32623,
    /*GILLT_v8s64*//*Label 1440*/ 32647, 0,
    /*GILLT_v16s8*//*Label 1441*/ 32671,
    /*GILLT_v16s16*//*Label 1442*/ 32695,
    /*GILLT_v16s32*//*Label 1443*/ 32719, 0,
    /*GILLT_v32s8*//*Label 1444*/ 32743,
    /*GILLT_v32s16*//*Label 1445*/ 32767, 0,
    /*GILLT_v64s8*//*Label 1446*/ 32791,
    // Label 1435: @32527
    GIM_Try, /*On fail goto*//*Label 1448*/ 32550, // Rule ID 10144 //
      GIM_CheckFeatures, GIFBS_HasVLX_HasVPOPCNTDQ,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (ctpop:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1)  =>  (VPOPCNTQZ128rr:{ *:[v2i64] } VR128X:{ *:[v2i64] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTQZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10144,
      GIR_Done,
    // Label 1448: @32550
    GIM_Reject,
    // Label 1436: @32551
    GIM_Try, /*On fail goto*//*Label 1449*/ 32574, // Rule ID 10171 //
      GIM_CheckFeatures, GIFBS_HasVLX_HasVPOPCNTDQ,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (ctpop:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1)  =>  (VPOPCNTDZ128rr:{ *:[v4i32] } VR128X:{ *:[v4i32] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTDZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10171,
      GIR_Done,
    // Label 1449: @32574
    GIM_Reject,
    // Label 1437: @32575
    GIM_Try, /*On fail goto*//*Label 1450*/ 32598, // Rule ID 10135 //
      GIM_CheckFeatures, GIFBS_HasVLX_HasVPOPCNTDQ,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (ctpop:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1)  =>  (VPOPCNTQZ256rr:{ *:[v4i64] } VR256X:{ *:[v4i64] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTQZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10135,
      GIR_Done,
    // Label 1450: @32598
    GIM_Reject,
    // Label 1438: @32599
    GIM_Try, /*On fail goto*//*Label 1451*/ 32622, // Rule ID 11198 //
      GIM_CheckFeatures, GIFBS_HasBITALG_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (ctpop:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1)  =>  (VPOPCNTWZ128rr:{ *:[v8i16] } VR128X:{ *:[v8i16] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTWZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11198,
      GIR_Done,
    // Label 1451: @32622
    GIM_Reject,
    // Label 1439: @32623
    GIM_Try, /*On fail goto*//*Label 1452*/ 32646, // Rule ID 10162 //
      GIM_CheckFeatures, GIFBS_HasVLX_HasVPOPCNTDQ,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (ctpop:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1)  =>  (VPOPCNTDZ256rr:{ *:[v8i32] } VR256X:{ *:[v8i32] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTDZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10162,
      GIR_Done,
    // Label 1452: @32646
    GIM_Reject,
    // Label 1440: @32647
    GIM_Try, /*On fail goto*//*Label 1453*/ 32670, // Rule ID 10126 //
      GIM_CheckFeatures, GIFBS_HasVPOPCNTDQ,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (ctpop:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1)  =>  (VPOPCNTQZrr:{ *:[v8i64] } VR512:{ *:[v8i64] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTQZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10126,
      GIR_Done,
    // Label 1453: @32670
    GIM_Reject,
    // Label 1441: @32671
    GIM_Try, /*On fail goto*//*Label 1454*/ 32694, // Rule ID 11180 //
      GIM_CheckFeatures, GIFBS_HasBITALG_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
      // (ctpop:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1)  =>  (VPOPCNTBZ128rr:{ *:[v16i8] } VR128X:{ *:[v16i8] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTBZ128rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11180,
      GIR_Done,
    // Label 1454: @32694
    GIM_Reject,
    // Label 1442: @32695
    GIM_Try, /*On fail goto*//*Label 1455*/ 32718, // Rule ID 11192 //
      GIM_CheckFeatures, GIFBS_HasBITALG_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (ctpop:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1)  =>  (VPOPCNTWZ256rr:{ *:[v16i16] } VR256X:{ *:[v16i16] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTWZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11192,
      GIR_Done,
    // Label 1455: @32718
    GIM_Reject,
    // Label 1443: @32719
    GIM_Try, /*On fail goto*//*Label 1456*/ 32742, // Rule ID 10153 //
      GIM_CheckFeatures, GIFBS_HasVPOPCNTDQ,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (ctpop:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1)  =>  (VPOPCNTDZrr:{ *:[v16i32] } VR512:{ *:[v16i32] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTDZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 10153,
      GIR_Done,
    // Label 1456: @32742
    GIM_Reject,
    // Label 1444: @32743
    GIM_Try, /*On fail goto*//*Label 1457*/ 32766, // Rule ID 11174 //
      GIM_CheckFeatures, GIFBS_HasBITALG_HasVLX,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
      // (ctpop:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1)  =>  (VPOPCNTBZ256rr:{ *:[v32i8] } VR256X:{ *:[v32i8] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTBZ256rr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11174,
      GIR_Done,
    // Label 1457: @32766
    GIM_Reject,
    // Label 1445: @32767
    GIM_Try, /*On fail goto*//*Label 1458*/ 32790, // Rule ID 11186 //
      GIM_CheckFeatures, GIFBS_HasBITALG,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v32s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (ctpop:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1)  =>  (VPOPCNTWZrr:{ *:[v32i16] } VR512:{ *:[v32i16] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTWZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11186,
      GIR_Done,
    // Label 1458: @32790
    GIM_Reject,
    // Label 1446: @32791
    GIM_Try, /*On fail goto*//*Label 1459*/ 32814, // Rule ID 11168 //
      GIM_CheckFeatures, GIFBS_HasBITALG,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v64s8,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (ctpop:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1)  =>  (VPOPCNTBZrr:{ *:[v64i8] } VR512:{ *:[v64i8] }:$src1)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VPOPCNTBZrr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 11168,
      GIR_Done,
    // Label 1459: @32814
    GIM_Reject,
    // Label 1447: @32815
    GIM_Reject,
    // Label 41: @32816
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/2, 5, /*)*//*default:*//*Label 1463*/ 32905,
    /*GILLT_s16*//*Label 1460*/ 32825,
    /*GILLT_s32*//*Label 1461*/ 32861,
    /*GILLT_s64*//*Label 1462*/ 32883,
    // Label 1460: @32825
    GIM_Try, /*On fail goto*//*Label 1464*/ 32860, // Rule ID 16077 //
      GIM_CheckFeatures, GIFBS_HasMOVBE,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s16,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR16RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR16RegClassID,
      // (bswap:{ *:[i16] } GR16:{ *:[i16] }:$src)  =>  (ROL16ri:{ *:[i16] }:{ *:[i32] } GR16:{ *:[i16] }:$src, 8:{ *:[i8] })
      GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::ROL16ri,
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
      GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
      GIR_AddImm, /*InsnID*/0, /*Imm*/8,
      GIR_EraseFromParent, /*InsnID*/0,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 16077,
      GIR_Done,
    // Label 1464: @32860
    GIM_Reject,
    // Label 1461: @32861
    GIM_Try, /*On fail goto*//*Label 1465*/ 32882, // Rule ID 5 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR32RegClassID,
      // (bswap:{ *:[i32] } GR32:{ *:[i32] }:$src)  =>  (BSWAP32r:{ *:[i32] } GR32:{ *:[i32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::BSWAP32r,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 5,
      GIR_Done,
    // Label 1465: @32882
    GIM_Reject,
    // Label 1462: @32883
    GIM_Try, /*On fail goto*//*Label 1466*/ 32904, // Rule ID 6 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::GR64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::GR64RegClassID,
      // (bswap:{ *:[i64] } GR64:{ *:[i64] }:$src)  =>  (BSWAP64r:{ *:[i64] } GR64:{ *:[i64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::BSWAP64r,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 6,
      GIR_Done,
    // Label 1466: @32904
    GIM_Reject,
    // Label 1463: @32905
    GIM_Reject,
    // Label 42: @32906
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 6, /*)*//*default:*//*Label 1470*/ 33003,
    /*GILLT_s32*//*Label 1467*/ 32915,
    /*GILLT_s64*//*Label 1468*/ 32945,
    /*GILLT_s80*//*Label 1469*/ 32975,
    // Label 1467: @32915
    GIM_Try, /*On fail goto*//*Label 1471*/ 32944, // Rule ID 695 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
      // (fcos:{ *:[f32] } RFP32:{ *:[f32] }:$src)  =>  (COS_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::COS_Fp32,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 695,
      GIR_Done,
    // Label 1471: @32944
    GIM_Reject,
    // Label 1468: @32945
    GIM_Try, /*On fail goto*//*Label 1472*/ 32974, // Rule ID 696 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
      // (fcos:{ *:[f64] } RFP64:{ *:[f64] }:$src)  =>  (COS_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::COS_Fp64,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 696,
      GIR_Done,
    // Label 1472: @32974
    GIM_Reject,
    // Label 1469: @32975
    GIM_Try, /*On fail goto*//*Label 1473*/ 33002, // Rule ID 697 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fcos:{ *:[f80] } RFP80:{ *:[f80] }:$src)  =>  (COS_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::COS_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 697,
      GIR_Done,
    // Label 1473: @33002
    GIM_Reject,
    // Label 1470: @33003
    GIM_Reject,
    // Label 43: @33004
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 6, /*)*//*default:*//*Label 1477*/ 33101,
    /*GILLT_s32*//*Label 1474*/ 33013,
    /*GILLT_s64*//*Label 1475*/ 33043,
    /*GILLT_s80*//*Label 1476*/ 33073,
    // Label 1474: @33013
    GIM_Try, /*On fail goto*//*Label 1478*/ 33042, // Rule ID 692 //
      GIM_CheckFeatures, GIFBS_FPStackf32,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
      // (fsin:{ *:[f32] } RFP32:{ *:[f32] }:$src)  =>  (SIN_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SIN_Fp32,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 692,
      GIR_Done,
    // Label 1478: @33042
    GIM_Reject,
    // Label 1475: @33043
    GIM_Try, /*On fail goto*//*Label 1479*/ 33072, // Rule ID 693 //
      GIM_CheckFeatures, GIFBS_FPStackf64,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
      // (fsin:{ *:[f64] } RFP64:{ *:[f64] }:$src)  =>  (SIN_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SIN_Fp64,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 693,
      GIR_Done,
    // Label 1479: @33072
    GIM_Reject,
    // Label 1476: @33073
    GIM_Try, /*On fail goto*//*Label 1480*/ 33100, // Rule ID 694 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fsin:{ *:[f80] } RFP80:{ *:[f80] }:$src)  =>  (SIN_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SIN_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 694,
      GIR_Done,
    // Label 1480: @33100
    GIM_Reject,
    // Label 1477: @33101
    GIM_Reject,
    // Label 44: @33102
    GIM_SwitchType, /*MI*/0, /*Op*/0, /*[*/3, 20, /*)*//*default:*//*Label 1490*/ 33703,
    /*GILLT_s32*//*Label 1481*/ 33125,
    /*GILLT_s64*//*Label 1482*/ 33265,
    /*GILLT_s80*//*Label 1483*/ 33405, 0, 0,
    /*GILLT_v2s64*//*Label 1484*/ 33433, 0,
    /*GILLT_v4s32*//*Label 1485*/ 33498,
    /*GILLT_v4s64*//*Label 1486*/ 33563, 0, 0,
    /*GILLT_v8s32*//*Label 1487*/ 33609,
    /*GILLT_v8s64*//*Label 1488*/ 33655, 0, 0, 0,
    /*GILLT_v16s32*//*Label 1489*/ 33679,
    // Label 1481: @33125
    GIM_Try, /*On fail goto*//*Label 1491*/ 33264,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
      GIM_Try, /*On fail goto*//*Label 1492*/ 33156, // Rule ID 689 //
        GIM_CheckFeatures, GIFBS_FPStackf32,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP32RegClassID,
        // (fsqrt:{ *:[f32] } RFP32:{ *:[f32] }:$src)  =>  (SQRT_Fp32:{ *:[f32] }:{ *:[i16] } RFP32:{ *:[f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRT_Fp32,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 689,
        GIR_Done,
      // Label 1492: @33156
      GIM_Try, /*On fail goto*//*Label 1493*/ 33175, // Rule ID 1606 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        // (fsqrt:{ *:[f32] } FR32:{ *:[f32] }:$src1)  =>  (SQRTSSr:{ *:[f32] } FR32:{ *:[f32] }:$src1)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRTSSr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1606,
        GIR_Done,
      // Label 1493: @33175
      GIM_Try, /*On fail goto*//*Label 1494*/ 33219, // Rule ID 12311 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32RegClassID,
        // (fsqrt:{ *:[f32] } FR32:{ *:[f32] }:$src)  =>  (VSQRTSSr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), FR32:{ *:[f32] }:$src)
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VSQRTSSr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12311,
        GIR_Done,
      // Label 1494: @33219
      GIM_Try, /*On fail goto*//*Label 1495*/ 33263, // Rule ID 14950 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR32XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR32XRegClassID,
        // (fsqrt:{ *:[f32] } FR32X:{ *:[f32] }:$src)  =>  (VSQRTSSZr:{ *:[f32] } (IMPLICIT_DEF:{ *:[f32] }), FR32X:{ *:[f32] }:$src)
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s32,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VSQRTSSZr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 14950,
        GIR_Done,
      // Label 1495: @33263
      GIM_Reject,
    // Label 1491: @33264
    GIM_Reject,
    // Label 1482: @33265
    GIM_Try, /*On fail goto*//*Label 1496*/ 33404,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s64,
      GIM_Try, /*On fail goto*//*Label 1497*/ 33296, // Rule ID 690 //
        GIM_CheckFeatures, GIFBS_FPStackf64,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP64RegClassID,
        // (fsqrt:{ *:[f64] } RFP64:{ *:[f64] }:$src)  =>  (SQRT_Fp64:{ *:[f64] }:{ *:[i16] } RFP64:{ *:[f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRT_Fp64,
        GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
        GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 690,
        GIR_Done,
      // Label 1497: @33296
      GIM_Try, /*On fail goto*//*Label 1498*/ 33315, // Rule ID 1614 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        // (fsqrt:{ *:[f64] } FR64:{ *:[f64] }:$src1)  =>  (SQRTSDr:{ *:[f64] } FR64:{ *:[f64] }:$src1)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRTSDr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1614,
        GIR_Done,
      // Label 1498: @33315
      GIM_Try, /*On fail goto*//*Label 1499*/ 33359, // Rule ID 12313 //
        GIM_CheckFeatures, GIFBS_UseAVX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64RegClassID,
        // (fsqrt:{ *:[f64] } FR64:{ *:[f64] }:$src)  =>  (VSQRTSDr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), FR64:{ *:[f64] }:$src)
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VSQRTSDr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 12313,
        GIR_Done,
      // Label 1499: @33359
      GIM_Try, /*On fail goto*//*Label 1500*/ 33403, // Rule ID 14952 //
        GIM_CheckFeatures, GIFBS_HasAVX512,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::FR64XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::FR64XRegClassID,
        // (fsqrt:{ *:[f64] } FR64X:{ *:[f64] }:$src)  =>  (VSQRTSDZr:{ *:[f64] } (IMPLICIT_DEF:{ *:[f64] }), FR64X:{ *:[f64] }:$src)
        GIR_MakeTempReg, /*TempRegID*/0, /*TypeID*/GILLT_s64,
        GIR_BuildMI, /*InsnID*/1, /*Opcode*/TargetOpcode::IMPLICIT_DEF,
        GIR_AddTempRegister, /*InsnID*/1, /*TempRegID*/0, /*TempRegFlags*/RegState::Define,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/1,
        GIR_BuildMI, /*InsnID*/0, /*Opcode*/X86::VSQRTSDZr,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // dst
        GIR_AddTempRegister, /*InsnID*/0, /*TempRegID*/0, /*TempRegFlags*/0,
        GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/1, // src
        GIR_EraseFromParent, /*InsnID*/0,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 14952,
        GIR_Done,
      // Label 1500: @33403
      GIM_Reject,
    // Label 1496: @33404
    GIM_Reject,
    // Label 1483: @33405
    GIM_Try, /*On fail goto*//*Label 1501*/ 33432, // Rule ID 691 //
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s80,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::RFP80RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::RFP80RegClassID,
      // (fsqrt:{ *:[f80] } RFP80:{ *:[f80] }:$src)  =>  (SQRT_Fp80:{ *:[f80] }:{ *:[i16] } RFP80:{ *:[f80] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRT_Fp80,
      GIR_AddImplicitDef, /*InsnID*/0, X86::FPSW,
      GIR_AddImplicitUse, /*InsnID*/0, X86::FPCW,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 691,
      GIR_Done,
    // Label 1501: @33432
    GIM_Reject,
    // Label 1484: @33433
    GIM_Try, /*On fail goto*//*Label 1502*/ 33497,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v2s64,
      GIM_Try, /*On fail goto*//*Label 1503*/ 33458, // Rule ID 1616 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (fsqrt:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src)  =>  (VSQRTPDr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPDr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1616,
        GIR_Done,
      // Label 1503: @33458
      GIM_Try, /*On fail goto*//*Label 1504*/ 33477, // Rule ID 1620 //
        GIM_CheckFeatures, GIFBS_UseSSE2,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (fsqrt:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src)  =>  (SQRTPDr:{ *:[v2f64] } VR128:{ *:[v2f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRTPDr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1620,
        GIR_Done,
      // Label 1504: @33477
      GIM_Try, /*On fail goto*//*Label 1505*/ 33496, // Rule ID 8962 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        // (fsqrt:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src)  =>  (VSQRTPDZ128r:{ *:[v2f64] } VR128X:{ *:[v2f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPDZ128r,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 8962,
        GIR_Done,
      // Label 1505: @33496
      GIM_Reject,
    // Label 1502: @33497
    GIM_Reject,
    // Label 1485: @33498
    GIM_Try, /*On fail goto*//*Label 1506*/ 33562,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s32,
      GIM_Try, /*On fail goto*//*Label 1507*/ 33523, // Rule ID 1608 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (fsqrt:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src)  =>  (VSQRTPSr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPSr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1608,
        GIR_Done,
      // Label 1507: @33523
      GIM_Try, /*On fail goto*//*Label 1508*/ 33542, // Rule ID 1612 //
        GIM_CheckFeatures, GIFBS_UseSSE1,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128RegClassID,
        // (fsqrt:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src)  =>  (SQRTPSr:{ *:[v4f32] } VR128:{ *:[v4f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::SQRTPSr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1612,
        GIR_Done,
      // Label 1508: @33542
      GIM_Try, /*On fail goto*//*Label 1509*/ 33561, // Rule ID 8944 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR128XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR128XRegClassID,
        // (fsqrt:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src)  =>  (VSQRTPSZ128r:{ *:[v4f32] } VR128X:{ *:[v4f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPSZ128r,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 8944,
        GIR_Done,
      // Label 1509: @33561
      GIM_Reject,
    // Label 1506: @33562
    GIM_Reject,
    // Label 1486: @33563
    GIM_Try, /*On fail goto*//*Label 1510*/ 33608,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v4s64,
      GIM_Try, /*On fail goto*//*Label 1511*/ 33588, // Rule ID 1618 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        // (fsqrt:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src)  =>  (VSQRTPDYr:{ *:[v4f64] } VR256:{ *:[v4f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPDYr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1618,
        GIR_Done,
      // Label 1511: @33588
      GIM_Try, /*On fail goto*//*Label 1512*/ 33607, // Rule ID 8971 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        // (fsqrt:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src)  =>  (VSQRTPDZ256r:{ *:[v4f64] } VR256X:{ *:[v4f64] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPDZ256r,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 8971,
        GIR_Done,
      // Label 1512: @33607
      GIM_Reject,
    // Label 1510: @33608
    GIM_Reject,
    // Label 1487: @33609
    GIM_Try, /*On fail goto*//*Label 1513*/ 33654,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s32,
      GIM_Try, /*On fail goto*//*Label 1514*/ 33634, // Rule ID 1610 //
        GIM_CheckFeatures, GIFBS_HasAVX_NoVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256RegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256RegClassID,
        // (fsqrt:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src)  =>  (VSQRTPSYr:{ *:[v8f32] } VR256:{ *:[v8f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPSYr,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 1610,
        GIR_Done,
      // Label 1514: @33634
      GIM_Try, /*On fail goto*//*Label 1515*/ 33653, // Rule ID 8953 //
        GIM_CheckFeatures, GIFBS_HasVLX,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR256XRegClassID,
        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR256XRegClassID,
        // (fsqrt:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src)  =>  (VSQRTPSZ256r:{ *:[v8f32] } VR256X:{ *:[v8f32] }:$src)
        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPSZ256r,
        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
        // GIR_Coverage, 8953,
        GIR_Done,
      // Label 1515: @33653
      GIM_Reject,
    // Label 1513: @33654
    GIM_Reject,
    // Label 1488: @33655
    GIM_Try, /*On fail goto*//*Label 1516*/ 33678, // Rule ID 8935 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v8s64,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (fsqrt:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src)  =>  (VSQRTPDZr:{ *:[v8f64] } VR512:{ *:[v8f64] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPDZr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8935,
      GIR_Done,
    // Label 1516: @33678
    GIM_Reject,
    // Label 1489: @33679
    GIM_Try, /*On fail goto*//*Label 1517*/ 33702, // Rule ID 8926 //
      GIM_CheckFeatures, GIFBS_HasAVX512,
      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_v16s32,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/X86::VR512RegClassID,
      GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/X86::VR512RegClassID,
      // (fsqrt:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src)  =>  (VSQRTPSZr:{ *:[v16f32] } VR512:{ *:[v16f32] }:$src)
      GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/X86::VSQRTPSZr,
      GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
      // GIR_Coverage, 8926,
      GIR_Done,
    // Label 1517: @33702
    GIM_Reject,
    // Label 1490: @33703
    GIM_Reject,
    // Label 45: @33704
    GIM_Reject,
    };
  return MatchTable0;
}
#endif // ifdef GET_GLOBALISEL_IMPL
#ifdef GET_GLOBALISEL_PREDICATES_DECL
PredicateBitset AvailableModuleFeatures;
mutable PredicateBitset AvailableFunctionFeatures;
PredicateBitset getAvailableFeatures() const {
  return AvailableModuleFeatures | AvailableFunctionFeatures;
}
PredicateBitset
computeAvailableModuleFeatures(const X86Subtarget *Subtarget) const;
PredicateBitset
computeAvailableFunctionFeatures(const X86Subtarget *Subtarget,
                                 const MachineFunction *MF) const;
#endif // ifdef GET_GLOBALISEL_PREDICATES_DECL
#ifdef GET_GLOBALISEL_PREDICATES_INIT
AvailableModuleFeatures(computeAvailableModuleFeatures(&STI)),
AvailableFunctionFeatures()
#endif // ifdef GET_GLOBALISEL_PREDICATES_INIT
