/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Machine Code Emitter                                                       *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

uint64_t BPFMCCodeEmitter::getBinaryCodeForInstr(const MCInst &MI,
    SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI) const {
  static const uint64_t InstBits[] = {
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(0),
    UINT64_C(504403158265495552),	// ADD_ri
    UINT64_C(288230376151711744),	// ADD_ri_32
    UINT64_C(1080863910568919040),	// ADD_rr
    UINT64_C(864691128455135232),	// ADD_rr_32
    UINT64_C(6269010681299730432),	// AND_ri
    UINT64_C(6052837899185946624),	// AND_ri_32
    UINT64_C(6845471433603153920),	// AND_rr
    UINT64_C(6629298651489370112),	// AND_rr_32
    UINT64_C(15852670688344145936),	// BE16
    UINT64_C(15852670688344145952),	// BE32
    UINT64_C(15852670688344145984),	// BE64
    UINT64_C(3963167672086036480),	// DIV_ri
    UINT64_C(3746994889972252672),	// DIV_ri_32
    UINT64_C(4539628424389459968),	// DIV_rr
    UINT64_C(4323455642275676160),	// DIV_rr_32
    UINT64_C(1738389456165011456),	// FI_ri
    UINT64_C(9583660007044415488),	// JAL
    UINT64_C(10160120759347838976),	// JALX
    UINT64_C(1513209474796486656),	// JEQ_ri
    UINT64_C(1585267068834414592),	// JEQ_ri_32
    UINT64_C(2089670227099910144),	// JEQ_rr
    UINT64_C(2161727821137838080),	// JEQ_rr_32
    UINT64_C(360287970189639680),	// JMP
    UINT64_C(6124895493223874560),	// JNE_ri
    UINT64_C(6196953087261802496),	// JNE_ri_32
    UINT64_C(6701356245527298048),	// JNE_rr
    UINT64_C(6773413839565225984),	// JNE_rr_32
    UINT64_C(8430738502437568512),	// JSGE_ri
    UINT64_C(8502796096475496448),	// JSGE_ri_32
    UINT64_C(9007199254740992000),	// JSGE_rr
    UINT64_C(9079256848778919936),	// JSGE_rr_32
    UINT64_C(7277816997830721536),	// JSGT_ri
    UINT64_C(7349874591868649472),	// JSGT_ri_32
    UINT64_C(7854277750134145024),	// JSGT_rr
    UINT64_C(7926335344172072960),	// JSGT_rr_32
    UINT64_C(15348267530078650368),	// JSLE_ri
    UINT64_C(15420325124116578304),	// JSLE_ri_32
    UINT64_C(15924728282382073856),	// JSLE_rr
    UINT64_C(15996785876420001792),	// JSLE_rr_32
    UINT64_C(14195346025471803392),	// JSLT_ri
    UINT64_C(14267403619509731328),	// JSLT_ri_32
    UINT64_C(14771806777775226880),	// JSLT_rr
    UINT64_C(14843864371813154816),	// JSLT_rr_32
    UINT64_C(3819052484010180608),	// JUGE_ri
    UINT64_C(3891110078048108544),	// JUGE_ri_32
    UINT64_C(4395513236313604096),	// JUGE_rr
    UINT64_C(4467570830351532032),	// JUGE_rr_32
    UINT64_C(2666130979403333632),	// JUGT_ri
    UINT64_C(2738188573441261568),	// JUGT_ri_32
    UINT64_C(3242591731706757120),	// JUGT_rr
    UINT64_C(3314649325744685056),	// JUGT_rr_32
    UINT64_C(13042424520864956416),	// JULE_ri
    UINT64_C(13114482114902884352),	// JULE_ri_32
    UINT64_C(13618885273168379904),	// JULE_rr
    UINT64_C(13690942867206307840),	// JULE_rr_32
    UINT64_C(11889503016258109440),	// JULT_ri
    UINT64_C(11961560610296037376),	// JULT_ri_32
    UINT64_C(12465963768561532928),	// JULT_rr
    UINT64_C(12538021362599460864),	// JULT_rr_32
    UINT64_C(8142508126285856768),	// LDB
    UINT64_C(8142508126285856768),	// LDB32
    UINT64_C(8718968878589280256),	// LDD
    UINT64_C(7566047373982433280),	// LDH
    UINT64_C(7566047373982433280),	// LDH32
    UINT64_C(6989586621679009792),	// LDW
    UINT64_C(6989586621679009792),	// LDW32
    UINT64_C(3458764513820540928),	// LD_ABS_B
    UINT64_C(2882303761517117440),	// LD_ABS_H
    UINT64_C(2305843009213693952),	// LD_ABS_W
    UINT64_C(5764607523034234880),	// LD_IND_B
    UINT64_C(5188146770730811392),	// LD_IND_H
    UINT64_C(4611686018427387904),	// LD_IND_W
    UINT64_C(1729382256910270464),	// LD_imm64
    UINT64_C(1729382256910270464),	// LD_pseudo
    UINT64_C(15276209936040722448),	// LE16
    UINT64_C(15276209936040722464),	// LE32
    UINT64_C(15276209936040722496),	// LE64
    UINT64_C(13546827679130451968),	// MOV_32_64
    UINT64_C(13186539708940812288),	// MOV_ri
    UINT64_C(12970366926827028480),	// MOV_ri_32
    UINT64_C(13763000461244235776),	// MOV_rr
    UINT64_C(13546827679130451968),	// MOV_rr_32
    UINT64_C(2810246167479189504),	// MUL_ri
    UINT64_C(2594073385365405696),	// MUL_ri_32
    UINT64_C(3386706919782612992),	// MUL_rr
    UINT64_C(3170534137668829184),	// MUL_rr_32
    UINT64_C(9511602413006487552),	// NEG_32
    UINT64_C(9727775195120271360),	// NEG_64
    UINT64_C(13763000461244235776),	// NOP
    UINT64_C(5116089176692883456),	// OR_ri
    UINT64_C(4899916394579099648),	// OR_ri_32
    UINT64_C(5692549928996306944),	// OR_rr
    UINT64_C(5476377146882523136),	// OR_rr_32
    UINT64_C(10736581511651262464),	// RET
    UINT64_C(7421932185906577408),	// SLL_ri
    UINT64_C(7205759403792793600),	// SLL_ri_32
    UINT64_C(7998392938210000896),	// SLL_rr
    UINT64_C(7782220156096217088),	// SLL_rr_32
    UINT64_C(14339461213547659264),	// SRA_ri
    UINT64_C(14123288431433875456),	// SRA_ri_32
    UINT64_C(14915921965851082752),	// SRA_rr
    UINT64_C(14699749183737298944),	// SRA_rr_32
    UINT64_C(8574853690513424384),	// SRL_ri
    UINT64_C(8358680908399640576),	// SRL_ri_32
    UINT64_C(9151314442816847872),	// SRL_rr
    UINT64_C(8935141660703064064),	// SRL_rr_32
    UINT64_C(8286623314361712640),	// STB
    UINT64_C(8286623314361712640),	// STB32
    UINT64_C(8863084066665136128),	// STD
    UINT64_C(7710162562058289152),	// STH
    UINT64_C(7710162562058289152),	// STH32
    UINT64_C(7133701809754865664),	// STW
    UINT64_C(7133701809754865664),	// STW32
    UINT64_C(1657324662872342528),	// SUB_ri
    UINT64_C(1441151880758558720),	// SUB_ri_32
    UINT64_C(2233785415175766016),	// SUB_rr
    UINT64_C(2017612633061982208),	// SUB_rr_32
    UINT64_C(15780613094306217984),	// XADDD
    UINT64_C(14051230837395947520),	// XADDW
    UINT64_C(14051230837395947520),	// XADDW32
    UINT64_C(12033618204333965312),	// XOR_ri
    UINT64_C(11817445422220181504),	// XOR_ri_32
    UINT64_C(12610078956637388800),	// XOR_rr
    UINT64_C(12393906174523604992),	// XOR_rr_32
    UINT64_C(0)
  };
  const unsigned opcode = MI.getOpcode();
  uint64_t Value = InstBits[opcode];
  uint64_t op = 0;
  (void)op;  // suppress warning
  switch (opcode) {
    case BPF::FI_ri:
    case BPF::NOP:
    case BPF::RET: {
      break;
    }
    case BPF::JMP: {
      // op: BrDst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(65535)) << 32;
      break;
    }
    case BPF::JAL:
    case BPF::JALX: {
      // op: BrDst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= op & UINT64_C(4294967295);
      break;
    }
    case BPF::BE16:
    case BPF::BE32:
    case BPF::BE64:
    case BPF::LE16:
    case BPF::LE32:
    case BPF::LE64:
    case BPF::NEG_32:
    case BPF::NEG_64: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      break;
    }
    case BPF::JEQ_ri:
    case BPF::JEQ_ri_32:
    case BPF::JNE_ri:
    case BPF::JNE_ri_32:
    case BPF::JSGE_ri:
    case BPF::JSGE_ri_32:
    case BPF::JSGT_ri:
    case BPF::JSGT_ri_32:
    case BPF::JSLE_ri:
    case BPF::JSLE_ri_32:
    case BPF::JSLT_ri:
    case BPF::JSLT_ri_32:
    case BPF::JUGE_ri:
    case BPF::JUGE_ri_32:
    case BPF::JUGT_ri:
    case BPF::JUGT_ri_32:
    case BPF::JULE_ri:
    case BPF::JULE_ri_32:
    case BPF::JULT_ri:
    case BPF::JULT_ri_32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: BrDst
      op = getMachineOpValue(MI, MI.getOperand(2), Fixups, STI);
      Value |= (op & UINT64_C(65535)) << 32;
      // op: imm
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= op & UINT64_C(4294967295);
      break;
    }
    case BPF::LDB:
    case BPF::LDB32:
    case BPF::LDD:
    case BPF::LDH:
    case BPF::LDH32:
    case BPF::LDW:
    case BPF::LDW32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: addr
      op = getMemoryOpValue(MI, 1, Fixups, STI);
      Value |= (op & UINT64_C(983040)) << 36;
      Value |= (op & UINT64_C(65535)) << 32;
      break;
    }
    case BPF::LD_imm64:
    case BPF::MOV_ri:
    case BPF::MOV_ri_32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: imm
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= op & UINT64_C(4294967295);
      break;
    }
    case BPF::ADD_ri:
    case BPF::ADD_ri_32:
    case BPF::AND_ri:
    case BPF::AND_ri_32:
    case BPF::DIV_ri:
    case BPF::DIV_ri_32:
    case BPF::MUL_ri:
    case BPF::MUL_ri_32:
    case BPF::OR_ri:
    case BPF::OR_ri_32:
    case BPF::SLL_ri:
    case BPF::SLL_ri_32:
    case BPF::SRA_ri:
    case BPF::SRA_ri_32:
    case BPF::SRL_ri:
    case BPF::SRL_ri_32:
    case BPF::SUB_ri:
    case BPF::SUB_ri_32:
    case BPF::XOR_ri:
    case BPF::XOR_ri_32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: imm
      op = getMachineOpValue(MI, MI.getOperand(2), Fixups, STI);
      Value |= op & UINT64_C(4294967295);
      break;
    }
    case BPF::LD_pseudo: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: imm
      op = getMachineOpValue(MI, MI.getOperand(2), Fixups, STI);
      Value |= op & UINT64_C(4294967295);
      // op: pseudo
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      break;
    }
    case BPF::MOV_32_64:
    case BPF::MOV_rr:
    case BPF::MOV_rr_32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: src
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      break;
    }
    case BPF::JEQ_rr:
    case BPF::JEQ_rr_32:
    case BPF::JNE_rr:
    case BPF::JNE_rr_32:
    case BPF::JSGE_rr:
    case BPF::JSGE_rr_32:
    case BPF::JSGT_rr:
    case BPF::JSGT_rr_32:
    case BPF::JSLE_rr:
    case BPF::JSLE_rr_32:
    case BPF::JSLT_rr:
    case BPF::JSLT_rr_32:
    case BPF::JUGE_rr:
    case BPF::JUGE_rr_32:
    case BPF::JUGT_rr:
    case BPF::JUGT_rr_32:
    case BPF::JULE_rr:
    case BPF::JULE_rr_32:
    case BPF::JULT_rr:
    case BPF::JULT_rr_32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: src
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      // op: BrDst
      op = getMachineOpValue(MI, MI.getOperand(2), Fixups, STI);
      Value |= (op & UINT64_C(65535)) << 32;
      break;
    }
    case BPF::ADD_rr:
    case BPF::ADD_rr_32:
    case BPF::AND_rr:
    case BPF::AND_rr_32:
    case BPF::DIV_rr:
    case BPF::DIV_rr_32:
    case BPF::MUL_rr:
    case BPF::MUL_rr_32:
    case BPF::OR_rr:
    case BPF::OR_rr_32:
    case BPF::SLL_rr:
    case BPF::SLL_rr_32:
    case BPF::SRA_rr:
    case BPF::SRA_rr_32:
    case BPF::SRL_rr:
    case BPF::SRL_rr_32:
    case BPF::SUB_rr:
    case BPF::SUB_rr_32:
    case BPF::XOR_rr:
    case BPF::XOR_rr_32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 48;
      // op: src
      op = getMachineOpValue(MI, MI.getOperand(2), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      break;
    }
    case BPF::XADDD:
    case BPF::XADDW:
    case BPF::XADDW32: {
      // op: dst
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      // op: addr
      op = getMemoryOpValue(MI, 1, Fixups, STI);
      Value |= (op & UINT64_C(1048575)) << 32;
      break;
    }
    case BPF::LD_ABS_B:
    case BPF::LD_ABS_H:
    case BPF::LD_ABS_W: {
      // op: imm
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= op & UINT64_C(4294967295);
      break;
    }
    case BPF::STB:
    case BPF::STB32:
    case BPF::STD:
    case BPF::STH:
    case BPF::STH32:
    case BPF::STW:
    case BPF::STW32: {
      // op: src
      op = getMachineOpValue(MI, MI.getOperand(0), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      // op: addr
      op = getMemoryOpValue(MI, 1, Fixups, STI);
      Value |= (op & UINT64_C(1048575)) << 32;
      break;
    }
    case BPF::LD_IND_B:
    case BPF::LD_IND_H:
    case BPF::LD_IND_W: {
      // op: val
      op = getMachineOpValue(MI, MI.getOperand(1), Fixups, STI);
      Value |= (op & UINT64_C(15)) << 52;
      break;
    }
  default:
    std::string msg;
    raw_string_ostream Msg(msg);
    Msg << "Not supported instr: " << MI;
    report_fatal_error(Msg.str());
  }
  return Value;
}

#ifdef ENABLE_INSTR_PREDICATE_VERIFIER
#undef ENABLE_INSTR_PREDICATE_VERIFIER
#include <sstream>

// Bits for subtarget features that participate in instruction matching.
enum SubtargetFeatureBits : uint8_t {
};

#ifndef NDEBUG
static const char *SubtargetFeatureNames[] = {
  nullptr
};

#endif // NDEBUG
FeatureBitset BPFMCCodeEmitter::
computeAvailableFeatures(const FeatureBitset& FB) const {
  FeatureBitset Features;
  return Features;
}

#ifndef NDEBUG
// Feature bitsets.
enum : uint8_t {
  CEFBS_None,
};

const static FeatureBitset FeatureBitsets[] {
  {}, // CEFBS_None
};
#endif // NDEBUG

void BPFMCCodeEmitter::verifyInstructionPredicates(
    const MCInst &Inst, const FeatureBitset &AvailableFeatures) const {
#ifndef NDEBUG
  static uint8_t RequiredFeaturesRefs[] = {
    CEFBS_None, // PHI = 0
    CEFBS_None, // INLINEASM = 1
    CEFBS_None, // INLINEASM_BR = 2
    CEFBS_None, // CFI_INSTRUCTION = 3
    CEFBS_None, // EH_LABEL = 4
    CEFBS_None, // GC_LABEL = 5
    CEFBS_None, // ANNOTATION_LABEL = 6
    CEFBS_None, // KILL = 7
    CEFBS_None, // EXTRACT_SUBREG = 8
    CEFBS_None, // INSERT_SUBREG = 9
    CEFBS_None, // IMPLICIT_DEF = 10
    CEFBS_None, // SUBREG_TO_REG = 11
    CEFBS_None, // COPY_TO_REGCLASS = 12
    CEFBS_None, // DBG_VALUE = 13
    CEFBS_None, // DBG_LABEL = 14
    CEFBS_None, // REG_SEQUENCE = 15
    CEFBS_None, // COPY = 16
    CEFBS_None, // BUNDLE = 17
    CEFBS_None, // LIFETIME_START = 18
    CEFBS_None, // LIFETIME_END = 19
    CEFBS_None, // STACKMAP = 20
    CEFBS_None, // FENTRY_CALL = 21
    CEFBS_None, // PATCHPOINT = 22
    CEFBS_None, // LOAD_STACK_GUARD = 23
    CEFBS_None, // STATEPOINT = 24
    CEFBS_None, // LOCAL_ESCAPE = 25
    CEFBS_None, // FAULTING_OP = 26
    CEFBS_None, // PATCHABLE_OP = 27
    CEFBS_None, // PATCHABLE_FUNCTION_ENTER = 28
    CEFBS_None, // PATCHABLE_RET = 29
    CEFBS_None, // PATCHABLE_FUNCTION_EXIT = 30
    CEFBS_None, // PATCHABLE_TAIL_CALL = 31
    CEFBS_None, // PATCHABLE_EVENT_CALL = 32
    CEFBS_None, // PATCHABLE_TYPED_EVENT_CALL = 33
    CEFBS_None, // ICALL_BRANCH_FUNNEL = 34
    CEFBS_None, // G_ADD = 35
    CEFBS_None, // G_SUB = 36
    CEFBS_None, // G_MUL = 37
    CEFBS_None, // G_SDIV = 38
    CEFBS_None, // G_UDIV = 39
    CEFBS_None, // G_SREM = 40
    CEFBS_None, // G_UREM = 41
    CEFBS_None, // G_AND = 42
    CEFBS_None, // G_OR = 43
    CEFBS_None, // G_XOR = 44
    CEFBS_None, // G_IMPLICIT_DEF = 45
    CEFBS_None, // G_PHI = 46
    CEFBS_None, // G_FRAME_INDEX = 47
    CEFBS_None, // G_GLOBAL_VALUE = 48
    CEFBS_None, // G_EXTRACT = 49
    CEFBS_None, // G_UNMERGE_VALUES = 50
    CEFBS_None, // G_INSERT = 51
    CEFBS_None, // G_MERGE_VALUES = 52
    CEFBS_None, // G_BUILD_VECTOR = 53
    CEFBS_None, // G_BUILD_VECTOR_TRUNC = 54
    CEFBS_None, // G_CONCAT_VECTORS = 55
    CEFBS_None, // G_PTRTOINT = 56
    CEFBS_None, // G_INTTOPTR = 57
    CEFBS_None, // G_BITCAST = 58
    CEFBS_None, // G_INTRINSIC_TRUNC = 59
    CEFBS_None, // G_INTRINSIC_ROUND = 60
    CEFBS_None, // G_LOAD = 61
    CEFBS_None, // G_SEXTLOAD = 62
    CEFBS_None, // G_ZEXTLOAD = 63
    CEFBS_None, // G_STORE = 64
    CEFBS_None, // G_ATOMIC_CMPXCHG_WITH_SUCCESS = 65
    CEFBS_None, // G_ATOMIC_CMPXCHG = 66
    CEFBS_None, // G_ATOMICRMW_XCHG = 67
    CEFBS_None, // G_ATOMICRMW_ADD = 68
    CEFBS_None, // G_ATOMICRMW_SUB = 69
    CEFBS_None, // G_ATOMICRMW_AND = 70
    CEFBS_None, // G_ATOMICRMW_NAND = 71
    CEFBS_None, // G_ATOMICRMW_OR = 72
    CEFBS_None, // G_ATOMICRMW_XOR = 73
    CEFBS_None, // G_ATOMICRMW_MAX = 74
    CEFBS_None, // G_ATOMICRMW_MIN = 75
    CEFBS_None, // G_ATOMICRMW_UMAX = 76
    CEFBS_None, // G_ATOMICRMW_UMIN = 77
    CEFBS_None, // G_FENCE = 78
    CEFBS_None, // G_BRCOND = 79
    CEFBS_None, // G_BRINDIRECT = 80
    CEFBS_None, // G_INTRINSIC = 81
    CEFBS_None, // G_INTRINSIC_W_SIDE_EFFECTS = 82
    CEFBS_None, // G_ANYEXT = 83
    CEFBS_None, // G_TRUNC = 84
    CEFBS_None, // G_CONSTANT = 85
    CEFBS_None, // G_FCONSTANT = 86
    CEFBS_None, // G_VASTART = 87
    CEFBS_None, // G_VAARG = 88
    CEFBS_None, // G_SEXT = 89
    CEFBS_None, // G_ZEXT = 90
    CEFBS_None, // G_SHL = 91
    CEFBS_None, // G_LSHR = 92
    CEFBS_None, // G_ASHR = 93
    CEFBS_None, // G_ICMP = 94
    CEFBS_None, // G_FCMP = 95
    CEFBS_None, // G_SELECT = 96
    CEFBS_None, // G_UADDO = 97
    CEFBS_None, // G_UADDE = 98
    CEFBS_None, // G_USUBO = 99
    CEFBS_None, // G_USUBE = 100
    CEFBS_None, // G_SADDO = 101
    CEFBS_None, // G_SADDE = 102
    CEFBS_None, // G_SSUBO = 103
    CEFBS_None, // G_SSUBE = 104
    CEFBS_None, // G_UMULO = 105
    CEFBS_None, // G_SMULO = 106
    CEFBS_None, // G_UMULH = 107
    CEFBS_None, // G_SMULH = 108
    CEFBS_None, // G_FADD = 109
    CEFBS_None, // G_FSUB = 110
    CEFBS_None, // G_FMUL = 111
    CEFBS_None, // G_FMA = 112
    CEFBS_None, // G_FDIV = 113
    CEFBS_None, // G_FREM = 114
    CEFBS_None, // G_FPOW = 115
    CEFBS_None, // G_FEXP = 116
    CEFBS_None, // G_FEXP2 = 117
    CEFBS_None, // G_FLOG = 118
    CEFBS_None, // G_FLOG2 = 119
    CEFBS_None, // G_FLOG10 = 120
    CEFBS_None, // G_FNEG = 121
    CEFBS_None, // G_FPEXT = 122
    CEFBS_None, // G_FPTRUNC = 123
    CEFBS_None, // G_FPTOSI = 124
    CEFBS_None, // G_FPTOUI = 125
    CEFBS_None, // G_SITOFP = 126
    CEFBS_None, // G_UITOFP = 127
    CEFBS_None, // G_FABS = 128
    CEFBS_None, // G_FCOPYSIGN = 129
    CEFBS_None, // G_FCANONICALIZE = 130
    CEFBS_None, // G_FMINNUM = 131
    CEFBS_None, // G_FMAXNUM = 132
    CEFBS_None, // G_FMINNUM_IEEE = 133
    CEFBS_None, // G_FMAXNUM_IEEE = 134
    CEFBS_None, // G_FMINIMUM = 135
    CEFBS_None, // G_FMAXIMUM = 136
    CEFBS_None, // G_GEP = 137
    CEFBS_None, // G_PTR_MASK = 138
    CEFBS_None, // G_SMIN = 139
    CEFBS_None, // G_SMAX = 140
    CEFBS_None, // G_UMIN = 141
    CEFBS_None, // G_UMAX = 142
    CEFBS_None, // G_BR = 143
    CEFBS_None, // G_BRJT = 144
    CEFBS_None, // G_INSERT_VECTOR_ELT = 145
    CEFBS_None, // G_EXTRACT_VECTOR_ELT = 146
    CEFBS_None, // G_SHUFFLE_VECTOR = 147
    CEFBS_None, // G_CTTZ = 148
    CEFBS_None, // G_CTTZ_ZERO_UNDEF = 149
    CEFBS_None, // G_CTLZ = 150
    CEFBS_None, // G_CTLZ_ZERO_UNDEF = 151
    CEFBS_None, // G_CTPOP = 152
    CEFBS_None, // G_BSWAP = 153
    CEFBS_None, // G_FCEIL = 154
    CEFBS_None, // G_FCOS = 155
    CEFBS_None, // G_FSIN = 156
    CEFBS_None, // G_FSQRT = 157
    CEFBS_None, // G_FFLOOR = 158
    CEFBS_None, // G_FRINT = 159
    CEFBS_None, // G_FNEARBYINT = 160
    CEFBS_None, // G_ADDRSPACE_CAST = 161
    CEFBS_None, // G_BLOCK_ADDR = 162
    CEFBS_None, // G_JUMP_TABLE = 163
    CEFBS_None, // ADJCALLSTACKDOWN = 164
    CEFBS_None, // ADJCALLSTACKUP = 165
    CEFBS_None, // MEMCPY = 166
    CEFBS_None, // Select = 167
    CEFBS_None, // Select_32 = 168
    CEFBS_None, // Select_32_64 = 169
    CEFBS_None, // Select_64_32 = 170
    CEFBS_None, // Select_Ri = 171
    CEFBS_None, // Select_Ri_32 = 172
    CEFBS_None, // Select_Ri_32_64 = 173
    CEFBS_None, // Select_Ri_64_32 = 174
    CEFBS_None, // ADD_ri = 175
    CEFBS_None, // ADD_ri_32 = 176
    CEFBS_None, // ADD_rr = 177
    CEFBS_None, // ADD_rr_32 = 178
    CEFBS_None, // AND_ri = 179
    CEFBS_None, // AND_ri_32 = 180
    CEFBS_None, // AND_rr = 181
    CEFBS_None, // AND_rr_32 = 182
    CEFBS_None, // BE16 = 183
    CEFBS_None, // BE32 = 184
    CEFBS_None, // BE64 = 185
    CEFBS_None, // DIV_ri = 186
    CEFBS_None, // DIV_ri_32 = 187
    CEFBS_None, // DIV_rr = 188
    CEFBS_None, // DIV_rr_32 = 189
    CEFBS_None, // FI_ri = 190
    CEFBS_None, // JAL = 191
    CEFBS_None, // JALX = 192
    CEFBS_None, // JEQ_ri = 193
    CEFBS_None, // JEQ_ri_32 = 194
    CEFBS_None, // JEQ_rr = 195
    CEFBS_None, // JEQ_rr_32 = 196
    CEFBS_None, // JMP = 197
    CEFBS_None, // JNE_ri = 198
    CEFBS_None, // JNE_ri_32 = 199
    CEFBS_None, // JNE_rr = 200
    CEFBS_None, // JNE_rr_32 = 201
    CEFBS_None, // JSGE_ri = 202
    CEFBS_None, // JSGE_ri_32 = 203
    CEFBS_None, // JSGE_rr = 204
    CEFBS_None, // JSGE_rr_32 = 205
    CEFBS_None, // JSGT_ri = 206
    CEFBS_None, // JSGT_ri_32 = 207
    CEFBS_None, // JSGT_rr = 208
    CEFBS_None, // JSGT_rr_32 = 209
    CEFBS_None, // JSLE_ri = 210
    CEFBS_None, // JSLE_ri_32 = 211
    CEFBS_None, // JSLE_rr = 212
    CEFBS_None, // JSLE_rr_32 = 213
    CEFBS_None, // JSLT_ri = 214
    CEFBS_None, // JSLT_ri_32 = 215
    CEFBS_None, // JSLT_rr = 216
    CEFBS_None, // JSLT_rr_32 = 217
    CEFBS_None, // JUGE_ri = 218
    CEFBS_None, // JUGE_ri_32 = 219
    CEFBS_None, // JUGE_rr = 220
    CEFBS_None, // JUGE_rr_32 = 221
    CEFBS_None, // JUGT_ri = 222
    CEFBS_None, // JUGT_ri_32 = 223
    CEFBS_None, // JUGT_rr = 224
    CEFBS_None, // JUGT_rr_32 = 225
    CEFBS_None, // JULE_ri = 226
    CEFBS_None, // JULE_ri_32 = 227
    CEFBS_None, // JULE_rr = 228
    CEFBS_None, // JULE_rr_32 = 229
    CEFBS_None, // JULT_ri = 230
    CEFBS_None, // JULT_ri_32 = 231
    CEFBS_None, // JULT_rr = 232
    CEFBS_None, // JULT_rr_32 = 233
    CEFBS_None, // LDB = 234
    CEFBS_None, // LDB32 = 235
    CEFBS_None, // LDD = 236
    CEFBS_None, // LDH = 237
    CEFBS_None, // LDH32 = 238
    CEFBS_None, // LDW = 239
    CEFBS_None, // LDW32 = 240
    CEFBS_None, // LD_ABS_B = 241
    CEFBS_None, // LD_ABS_H = 242
    CEFBS_None, // LD_ABS_W = 243
    CEFBS_None, // LD_IND_B = 244
    CEFBS_None, // LD_IND_H = 245
    CEFBS_None, // LD_IND_W = 246
    CEFBS_None, // LD_imm64 = 247
    CEFBS_None, // LD_pseudo = 248
    CEFBS_None, // LE16 = 249
    CEFBS_None, // LE32 = 250
    CEFBS_None, // LE64 = 251
    CEFBS_None, // MOV_32_64 = 252
    CEFBS_None, // MOV_ri = 253
    CEFBS_None, // MOV_ri_32 = 254
    CEFBS_None, // MOV_rr = 255
    CEFBS_None, // MOV_rr_32 = 256
    CEFBS_None, // MUL_ri = 257
    CEFBS_None, // MUL_ri_32 = 258
    CEFBS_None, // MUL_rr = 259
    CEFBS_None, // MUL_rr_32 = 260
    CEFBS_None, // NEG_32 = 261
    CEFBS_None, // NEG_64 = 262
    CEFBS_None, // NOP = 263
    CEFBS_None, // OR_ri = 264
    CEFBS_None, // OR_ri_32 = 265
    CEFBS_None, // OR_rr = 266
    CEFBS_None, // OR_rr_32 = 267
    CEFBS_None, // RET = 268
    CEFBS_None, // SLL_ri = 269
    CEFBS_None, // SLL_ri_32 = 270
    CEFBS_None, // SLL_rr = 271
    CEFBS_None, // SLL_rr_32 = 272
    CEFBS_None, // SRA_ri = 273
    CEFBS_None, // SRA_ri_32 = 274
    CEFBS_None, // SRA_rr = 275
    CEFBS_None, // SRA_rr_32 = 276
    CEFBS_None, // SRL_ri = 277
    CEFBS_None, // SRL_ri_32 = 278
    CEFBS_None, // SRL_rr = 279
    CEFBS_None, // SRL_rr_32 = 280
    CEFBS_None, // STB = 281
    CEFBS_None, // STB32 = 282
    CEFBS_None, // STD = 283
    CEFBS_None, // STH = 284
    CEFBS_None, // STH32 = 285
    CEFBS_None, // STW = 286
    CEFBS_None, // STW32 = 287
    CEFBS_None, // SUB_ri = 288
    CEFBS_None, // SUB_ri_32 = 289
    CEFBS_None, // SUB_rr = 290
    CEFBS_None, // SUB_rr_32 = 291
    CEFBS_None, // XADDD = 292
    CEFBS_None, // XADDW = 293
    CEFBS_None, // XADDW32 = 294
    CEFBS_None, // XOR_ri = 295
    CEFBS_None, // XOR_ri_32 = 296
    CEFBS_None, // XOR_rr = 297
    CEFBS_None, // XOR_rr_32 = 298
  };

  assert(Inst.getOpcode() < 299);
  const FeatureBitset &RequiredFeatures = FeatureBitsets[RequiredFeaturesRefs[Inst.getOpcode()]];
  FeatureBitset MissingFeatures =
      (AvailableFeatures & RequiredFeatures) ^
      RequiredFeatures;
  if (MissingFeatures.any()) {
    std::ostringstream Msg;
    Msg << "Attempting to emit " << MCII.getName(Inst.getOpcode()).str()
        << " instruction but the ";
    for (unsigned i = 0, e = MissingFeatures.size(); i != e; ++i)
      if (MissingFeatures.test(i))
        Msg << SubtargetFeatureNames[i] << " ";
    Msg << "predicate(s) are not met";
    report_fatal_error(Msg.str());
  }
#else
// Silence unused variable warning on targets that don't use MCII for other purposes (e.g. BPF).
(void)MCII;
#endif // NDEBUG
}
#endif
