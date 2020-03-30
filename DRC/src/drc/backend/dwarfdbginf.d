/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/dwarfdbginf.d, backend/dwarfdbginf.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/dwarfdbginf.d
 */

// Emit Dwarf symbolic debug info

/*
Some generic information for debug info on macOS:

The linker on macOS will удали any debug info, i.e. every section with the
`S_ATTR_DEBUG` флаг, this includes everything in the `__DWARF` section. By using
the `S_REGULAR` флаг the linker will not удали this section. This allows to get
the filenames and line numbers for backtraces from the executable.

Normally the linker removes all the debug info but adds a reference to the
объект files. The debugger can then читай the объект files to get имяф and
line number information. It's also possible to use an additional tool that
generates a separate `.dSYM` файл. This файл can then later be deployed with the
application if debug info is needed when the application is deployed.
*/

module drc.backend.dwarfdbginf;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

version(Windows)
{
    extern (C) ткст0 getcwd(ткст0 буфер, т_мера maxlen);
    extern (C) цел* _errno();   // not the multi-threaded version
}
else
{
    import core.sys.posix.unistd : getcwd;
}

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.mem;
import drc.backend.dlist;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.ty;
import drc.backend.тип;

static if (ELFOBJ || MACHOBJ)
{

import drc.backend.aarray;

static if (ELFOBJ)
    import drc.backend.melf;

static if (MACHOBJ)
    import drc.backend.mach;

import drc.backend.dwarf;
import drc.backend.dwarf2;


/*extern (C++):*/



цел REGSIZE();


public{
extern цел seg_count;

static if (MACHOBJ)
{
цел except_table_seg = 0;       // __gcc_except_tab segment
цел except_table_num = 0;       // sequence number for GCC_except_table%d symbols
цел eh_frame_seg = 0;           // __eh_frame segment
Symbol *eh_frame_sym = null;            // past end of __eh_frame
}

бцел CIE_offset_unwind;     // CIE смещение for unwind данные
бцел CIE_offset_no_unwind;  // CIE смещение for no unwind данные

static if (ELFOBJ)
{
IDXSYM elf_addsym(IDXSTR nam, targ_т_мера val, бцел sz,
        бцел typ, бцел bind, IDXSEC sec,
        ббайт visibility = STV_DEFAULT);
проц addSegmentToComdat(segidx_t seg, segidx_t comdatseg);
}

Symbol* getRtlsymPersonality();

private Outbuffer  *reset_symbuf;        // Keep pointers to сбрось symbols
}

/***********************************
 * Determine if generating a eh_frame with full
 * unwinding information.
 * This decision is done on a per-function basis.
 * Возвращает:
 *      да if unwinding needs to be done
 */
бул doUnwindEhFrame()
{
    if (funcsym_p.Sfunc.Fflags3 & Feh_none)
    {
        return (config.exe & (EX_FREEBSD | EX_FREEBSD64 | EX_DRAGONFLYBSD64)) != 0;
    }

    /* FreeBSD fails when having some frames as having unwinding info and some not.
     * (It hangs in unittests for std.datetime.)
     * g++ on FreeBSD does not generate mixed frames, while g++ on OSX and Linux does.
     */
    assert(!(usednteh & ~(EHtry | EHcleanup)));
    return (usednteh & (EHtry | EHcleanup)) ||
           (config.exe & (EX_FREEBSD | EX_FREEBSD64 | EX_DRAGONFLYBSD64)) && config.useExceptions;
}

static if (ELFOBJ)
    SYMIDX MAP_SEG2SYMIDX(цел seg) { return SegData[seg].SDsymidx; }
else
    SYMIDX MAP_SEG2SYMIDX(цел seg) { assert(0); }


цел OFFSET_FAC() { return REGSIZE(); }

цел dwarf_getsegment(ткст0 имя, цел align_, цел flags)
{
static if (ELFOBJ)
    return Obj.getsegment(имя, null, flags, 0, align_ * 4);
else static if (MACHOBJ)
    return Obj.getsegment(имя, "__DWARF", align_ * 2, flags);
else
    assert(0);
}

static if (ELFOBJ)
{
цел dwarf_getsegment_alloc(ткст0 имя, ткст0 suffix, цел align_)
{
    return Obj.getsegment(имя, suffix, SHT_PROGBITS, SHF_ALLOC, align_ * 4);
}
}

цел dwarf_except_table_alloc(Symbol *s)
{
    //printf("dwarf_except_table_alloc('%s')\n", s.Sident.ptr);
static if (ELFOBJ)
{
    /* If `s` is in a COMDAT, then this table needs to go into
     * a unique section, which then gets added to the COMDAT group
     * associated with `s`.
     */
    seg_data *pseg = SegData[s.Sseg];
    if (pseg.SDassocseg)
    {
        ткст0 suffix = s.Sident.ptr; // cpp_mangle(s);
        segidx_t tableseg = Obj.getsegment(".gcc_except_table.", suffix, SHT_PROGBITS, SHF_ALLOC|SHF_GROUP, 1);
        addSegmentToComdat(tableseg, s.Sseg);
        return tableseg;
    }
    else
        return dwarf_getsegment_alloc(".gcc_except_table", null, 1);
}
else static if (MACHOBJ)
{
    цел seg = Obj.getsegment("__gcc_except_tab", "__TEXT", 2, S_REGULAR);
    except_table_seg = seg;
    return seg;
}
else
    assert(0);
}

цел dwarf_eh_frame_alloc()
{
static if (ELFOBJ)
    return dwarf_getsegment_alloc(".eh_frame", null, I64 ? 2 : 1);
else static if (MACHOBJ)
{
    цел seg = Obj.getsegment("__eh_frame", "__TEXT", I64 ? 3 : 2,
        S_COALESCED | S_ATTR_NO_TOC | S_ATTR_STRIP_STATIC_SYMS | S_ATTR_LIVE_SUPPORT);
    /* Generate symbol for it to use for fixups
     */
    if (!eh_frame_sym)
    {
        тип *t = tspvoid;
        t.Tcount++;
        type_setmangle(&t, mTYman_sys);         // no leading '_' for mangled имя
        eh_frame_sym = symbol_name("EH_frame0", SCstatic, t);
        Obj.pubdef(seg, eh_frame_sym, 0);
        symbol_keep(eh_frame_sym);
        eh_frame_seg = seg;
    }
    return seg;
}
else
    assert(0);
}

// machobj.c
const RELaddr = 0;       // straight address
const RELrel  = 1;       // relative to location to be fixed up

проц dwarf_addrel(цел seg, targ_т_мера смещение, цел targseg, targ_т_мера val = 0)
{
static if (ELFOBJ)
    Obj.addrel(seg, смещение, I64 ? R_X86_64_32 : R_386_32, MAP_SEG2SYMIDX(targseg), val);
else static if (MACHOBJ)
    Obj.addrel(seg, смещение, null, targseg, RELaddr, cast(бцел)val);
else
    assert(0);
}

проц dwarf_addrel64(цел seg, targ_т_мера смещение, цел targseg, targ_т_мера val)
{
static if (ELFOBJ)
    Obj.addrel(seg, смещение, R_X86_64_64, MAP_SEG2SYMIDX(targseg), val);
else static if (MACHOBJ)
    Obj.addrel(seg, смещение, null, targseg, RELaddr, cast(бцел)val);
else
    assert(0);
}

проц dwarf_appreladdr(цел seg, Outbuffer *буф, цел targseg, targ_т_мера val)
{
    if (I64)
    {
        dwarf_addrel64(seg, буф.size(), targseg, val);
        буф.write64(0);
    }
    else
    {
        dwarf_addrel(seg, буф.size(), targseg, 0);
        буф.write32(cast(бцел)val);
    }
}

проц dwarf_apprel32(цел seg, Outbuffer *буф, цел targseg, targ_т_мера val)
{
    dwarf_addrel(seg, буф.size(), targseg, I64 ? val : 0);
    буф.write32(I64 ? 0 : cast(бцел)val);
}

проц append_addr(Outbuffer *буф, targ_т_мера addr)
{
    if (I64)
        буф.write64(addr);
    else
        буф.write32(cast(бцел)addr);
}


/************************  DWARF DEBUG OUTPUT ********************************/

// Dwarf Symbolic Debugging Information

// CFA = значение of the stack pointer at the call site in the previous frame

struct CFA_reg
{
    цел смещение;                 // смещение from CFA
}

// Current CFA state for .debug_frame
struct CFA_state
{
    т_мера location;
    цел reg;                    // CFA register number
    цел смещение;                 // CFA register смещение
    CFA_reg[17] regstates;      // register states
}

/***********************
 * Convert CPU register number to Dwarf register number.
 * Параметры:
 *      reg = CPU register
 * Возвращает:
 *      dwarf register
 */
цел dwarf_regno(цел reg)
{
    assert(reg < NUMGENREGS);
    if (I32)
    {
static if (MACHOBJ)
{
        if (reg == BP || reg == SP)
            reg ^= BP ^ SP;     // swap EBP and ESP register values for OSX (!)
}
        return reg;
    }
    else
    {
        assert(I64);
        /* See https://software.intel.com/sites/default/files/article/402129/mpx-linux64-abi.pdf
         * Figure 3.3.8 pg. 62
         * R8..15    :  8..15
         * XMM0..15  : 17..32
         * ST0..7    : 33..40
         * MM0..7    : 41..48
         * XMM16..31 : 67..82
         */
        static const цел[8] to_amd64_reg_map =
        // AX CX DX BX SP BP SI DI
        [   0, 2, 1, 3, 7, 6, 4, 5 ];
        return reg < 8 ? to_amd64_reg_map[reg] : reg;
    }
}

private 
{
CFA_state CFA_state_init_32 =       // initial CFA state as defined by CIE
{   0,                // location
    -1,               // register
    4,                // смещение
    [   { 0 },        // 0: EAX
        { 0 },        // 1: ECX
        { 0 },        // 2: EDX
        { 0 },        // 3: EBX
        { 0 },        // 4: ESP
        { 0 },        // 5: EBP
        { 0 },        // 6: ESI
        { 0 },        // 7: EDI
        { -4 },       // 8: EIP
    ]
};

CFA_state CFA_state_init_64 =       // initial CFA state as defined by CIE
{   0,                // location
    -1,               // register
    8,                // смещение
    [   { 0 },        // 0: RAX
        { 0 },        // 1: RBX
        { 0 },        // 2: RCX
        { 0 },        // 3: RDX
        { 0 },        // 4: RSI
        { 0 },        // 5: RDI
        { 0 },        // 6: RBP
        { 0 },        // 7: RSP
        { 0 },        // 8: R8
        { 0 },        // 9: R9
        { 0 },        // 10: R10
        { 0 },        // 11: R11
        { 0 },        // 12: R12
        { 0 },        // 13: R13
        { 0 },        // 14: R14
        { 0 },        // 15: R15
        { -8 },       // 16: RIP
    ]
};

    CFA_state CFA_state_current;     // current CFA state
    Outbuffer cfa_buf;               // CFA instructions
}

/***********************************
 * Set the location, i.e. the смещение from the start
 * of the function. It must always be greater than
 * the current location.
 * Параметры:
 *      location = смещение from the start of the function
 */
проц dwarf_CFA_set_loc(бцел location)
{
    assert(location >= CFA_state_current.location);
    бцел inc = cast(бцел)(location - CFA_state_current.location);
    if (inc <= 63)
        cfa_buf.пишиБайт(DW_CFA_advance_loc + inc);
    else if (inc <= 255)
    {   cfa_buf.пишиБайт(DW_CFA_advance_loc1);
        cfa_buf.пишиБайт(inc);
    }
    else if (inc <= 0xFFFF)
    {   cfa_buf.пишиБайт(DW_CFA_advance_loc2);
        cfa_buf.writeWord(inc);
    }
    else
    {   cfa_buf.пишиБайт(DW_CFA_advance_loc4);
        cfa_buf.write32(inc);
    }
    CFA_state_current.location = location;
}

/*******************************************
 * Set the frame register, and its смещение.
 * Параметры:
 *      reg = machine register
 *      смещение = смещение from frame register
 */
проц dwarf_CFA_set_reg_offset(цел reg, цел смещение)
{
    цел dw_reg = dwarf_regno(reg);
    if (dw_reg != CFA_state_current.reg)
    {
        if (смещение == CFA_state_current.смещение)
        {
            cfa_buf.пишиБайт(DW_CFA_def_cfa_register);
            cfa_buf.writeuLEB128(dw_reg);
        }
        else if (смещение < 0)
        {
            cfa_buf.пишиБайт(DW_CFA_def_cfa_sf);
            cfa_buf.writeuLEB128(dw_reg);
            cfa_buf.writesLEB128(смещение / -OFFSET_FAC);
        }
        else
        {
            cfa_buf.пишиБайт(DW_CFA_def_cfa);
            cfa_buf.writeuLEB128(dw_reg);
            cfa_buf.writeuLEB128(смещение);
        }
    }
    else if (смещение < 0)
    {
        cfa_buf.пишиБайт(DW_CFA_def_cfa_offset_sf);
        cfa_buf.writesLEB128(смещение / -OFFSET_FAC);
    }
    else
    {
        cfa_buf.пишиБайт(DW_CFA_def_cfa_offset);
        cfa_buf.writeuLEB128(смещение);
    }
    CFA_state_current.reg = dw_reg;
    CFA_state_current.смещение = смещение;
}

/***********************************************
 * Set reg to be at смещение from frame register.
 * Параметры:
 *      reg = machine register
 *      смещение = смещение from frame register
 */
проц dwarf_CFA_offset(цел reg, цел смещение)
{
    цел dw_reg = dwarf_regno(reg);
    if (CFA_state_current.regstates[dw_reg].смещение != смещение)
    {
        if (смещение <= 0)
        {
            cfa_buf.пишиБайт(DW_CFA_offset + dw_reg);
            cfa_buf.writeuLEB128(смещение / -OFFSET_FAC);
        }
        else
        {
            cfa_buf.пишиБайт(DW_CFA_offset_extended_sf);
            cfa_buf.writeuLEB128(dw_reg);
            cfa_buf.writesLEB128(смещение / -OFFSET_FAC);
        }
    }
    CFA_state_current.regstates[dw_reg].смещение = смещение;
}

/**************************************
 * Set total size of arguments pushed on the stack.
 * Параметры:
 *      sz = total size
 */
проц dwarf_CFA_args_size(т_мера sz)
{
    cfa_buf.пишиБайт(DW_CFA_GNU_args_size);
    cfa_buf.writeuLEB128(cast(бцел)sz);
}

struct Section
{
    segidx_t seg = 0;
    IDXSEC secidx = 0;
    Outbuffer *буф = null;
    ткст0 имя;

    static if (MACHOBJ)
        const flags = S_ATTR_DEBUG;
    else
        const flags = SHT_PROGBITS;

    /* Allocate and initialize Section
     */
     проц initialize()
    {
        const segidx_t segi = dwarf_getsegment(имя, 0, flags);
        seg = segi;
        secidx = SegData[segi].SDshtidx;
        буф = SegData[segi].SDbuf;
        буф.резервируй(1000);
    }
}


private 
{

static if (MACHOBJ)
{
    Section debug_pubnames = { имя: "__debug_pubnames" };
    Section debug_aranges  = { имя: "__debug_aranges" };
    Section debug_ranges   = { имя: "__debug_ranges" };
    Section debug_loc      = { имя: "__debug_loc" };
    Section debug_abbrev   = { имя: "__debug_abbrev" };
    Section debug_info     = { имя: "__debug_info" };
    Section debug_str      = { имя: "__debug_str" };
// We use S_REGULAR to make sure the linker doesn't удали this section. Needed
// for filenames and line numbers in backtraces.
    Section debug_line     = { имя: "__debug_line", flags: S_REGULAR };
}
else static if (ELFOBJ)
{
    Section debug_pubnames = { имя: ".debug_pubnames" };
    Section debug_aranges  = { имя: ".debug_aranges" };
    Section debug_ranges   = { имя: ".debug_ranges" };
    Section debug_loc      = { имя: ".debug_loc" };
    Section debug_abbrev   = { имя: ".debug_abbrev" };
    Section debug_info     = { имя: ".debug_info" };
    Section debug_str      = { имя: ".debug_str" };
    Section debug_line     = { имя: ".debug_line" };
}

static if (MACHOBJ)
    const ткст0 debug_frame_name = "__debug_frame";
else static if (ELFOBJ)
    const ткст0 debug_frame_name = ".debug_frame";


/* DWARF 7.5.3: "Each declaration begins with an unsigned LEB128 number
 * representing the abbreviation code itself."
 */
бцел abbrevcode = 1;
AApair *abbrev_table;
цел hasModname;    // 1 if has DW_TAG_module

// .debug_info
AAchars *infoFileName_table;

AApair *type_table;
AApair *functype_table;  // not sure why this cannot be combined with type_table
Outbuffer *functypebuf;

struct DebugInfoHeader
{
  align (1):
    бцел total_length;
    ushort version_;
    бцел abbrev_offset;
    ббайт address_size;
}
// Workaround https://issues.dlang.org/show_bug.cgi?ид=16563
// Struct alignment is ignored due to 2.072 regression.
static assert((DebugInfoHeader.alignof == 1 && DebugInfoHeader.sizeof == 11) ||
              (DebugInfoHeader.alignof == 4 && DebugInfoHeader.sizeof == 12));

DebugInfoHeader debuginfo_init =
{       0,      // total_length
        3,      // version_
        0,      // abbrev_offset
        4       // address_size
};

DebugInfoHeader debuginfo;

// .debug_line
т_мера linebuf_filetab_end;

struct DebugLineHeader
{
  align (1):
    бцел total_length;
    ushort version_;
    бцел prologue_length;
    ббайт minimum_instruction_length;
    ббайт default_is_stmt;
    byte line_base;
    ббайт line_range;
    ббайт opcode_base;
    ббайт[9] standard_opcode_lengths;
}
static assert(DebugLineHeader.sizeof == 24);

DebugLineHeader debugline_init =
{       0,      // total_length
        2,      // version_
        0,      // prologue_length
        1,      // minimum_instruction_length
        да,   // default_is_stmt
        -5,     // line_base
        14,     // line_range
        10,     // opcode_base
        [ 0,1,1,1,1,0,0,0,1 ]
};

DebugLineHeader debugline;

public бцел[TYMAX] typidx_tab;
}

/*****************************************
 * Append .debug_frame header to буф.
 * Параметры:
 *      буф = пиши raw данные here
 */
проц writeDebugFrameHeader(Outbuffer *буф)
{
    struct DebugFrameHeader
    {
      align (1):
        бцел length;
        бцел CIE_id;
        ббайт version_;
        ббайт augmentation;
        ббайт code_alignment_factor;
        ббайт data_alignment_factor;
        ббайт return_address_register;
        ббайт[11] opcodes;
    }
    static assert(DebugFrameHeader.sizeof == 24);

     DebugFrameHeader debugFrameHeader =
    {   16,             // length
        0xFFFFFFFF,     // CIE_id
        1,              // version_
        0,              // augmentation
        1,              // code alignment factor
        0x7C,           // данные alignment factor (-4)
        8,              // return address register
      [
        DW_CFA_def_cfa, 4,4,    // r4,4 [r7,8]
        DW_CFA_offset   +8,1,   // r8,1 [r16,1]
        DW_CFA_nop, DW_CFA_nop,
        DW_CFA_nop, DW_CFA_nop, // 64 padding
        DW_CFA_nop, DW_CFA_nop, // 64 padding
      ]
    };
    if (I64)
    {   debugFrameHeader.length = 20;
        debugFrameHeader.data_alignment_factor = 0x78;          // (-8)
        debugFrameHeader.return_address_register = 16;
        debugFrameHeader.opcodes[1] = 7;                        // RSP
        debugFrameHeader.opcodes[2] = 8;
        debugFrameHeader.opcodes[3] = DW_CFA_offset + 16;       // RIP
    }
    assert(debugFrameHeader.data_alignment_factor == 0x80 - OFFSET_FAC);

    буф.writen(&debugFrameHeader,debugFrameHeader.length + 4);
}

/*****************************************
 * Append .eh_frame header to буф.
 * Almost identical to .debug_frame
 * Параметры:
 *      dfseg = SegData[] index for .eh_frame
 *      буф = пиши raw данные here
 *      personality = "__dmd_personality_v0"
 *      ehunwind = will have EH unwind table
 * Возвращает:
 *      смещение of start of this header
 * See_Also:
 *      https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA/ehframechpt.html
 */
private бцел writeEhFrameHeader(IDXSEC dfseg, Outbuffer *буф, Symbol *personality, бул ehunwind)
{
    /* Augmentation ткст:
     *  z = first character, means Augmentation Data field is present
     *  eh = EH Data field is present
     *  P = Augmentation Data содержит 2 args:
     *          1. encoding of 2nd arg
     *          2. address of personality routine
     *  L = Augmentation Data содержит 1 arg:
     *          1. the encoding используется for Augmentation Data in FDE
     *      Augmentation Data in FDE:
     *          1. address of LSDA (gcc_except_table)
     *  R = Augmentation Data содержит 1 arg:
     *          1. encoding of addresses in FDE
     * Non-EH code: "zR"
     * EH code: "zPLR"
     */

    const бцел startsize = cast(бцел)буф.size();

    // Length of CIE, not including padding
    const бцел cielen = 4 + 4 + 1 +
        (ehunwind ? 5 : 3) +
        1 + 1 + 1 +
        (ehunwind ? 8 : 2) +
        5;

    const бцел pad = -cielen & (I64 ? 7 : 3);      // pad to addressing unit size boundary
    const бцел length = cielen + pad - 4;

    буф.резервируй(length + 4);
    буф.write32(length);       // length of CIE, not including length and extended length fields
    буф.write32(0);            // CIE ID
    буф.writeByten(1);         // version_
    if (ehunwind)
        буф.пиши("zPLR".ptr, 5);  // Augmentation String
    else
        буф.writen("zR".ptr, 3);
    // not present: EH Data: 4 bytes for I32, 8 bytes for I64
    буф.writeByten(1);                 // code alignment factor
    буф.writeByten(cast(ббайт)(0x80 - OFFSET_FAC)); // данные alignment factor (I64 ? -8 : -4)
    буф.writeByten(I64 ? 16 : 8);      // return address register
    if (ehunwind)
    {
static if (ELFOBJ)
{
        const ббайт personality_pointer_encoding = config.flags3 & CFG3pic
                ? DW_EH_PE_indirect | DW_EH_PE_pcrel | DW_EH_PE_sdata4
                : DW_EH_PE_absptr | DW_EH_PE_udata4;
        const ббайт LSDA_pointer_encoding = config.flags3 & CFG3pic
                ? DW_EH_PE_pcrel | DW_EH_PE_sdata4
                : DW_EH_PE_absptr | DW_EH_PE_udata4;
        const ббайт address_pointer_encoding =
                DW_EH_PE_pcrel | DW_EH_PE_sdata4;
}
else static if (MACHOBJ)
{
        const ббайт personality_pointer_encoding =
                DW_EH_PE_indirect | DW_EH_PE_pcrel | DW_EH_PE_sdata4;
        const ббайт LSDA_pointer_encoding =
                DW_EH_PE_pcrel | DW_EH_PE_ptr;
        const ббайт address_pointer_encoding =
                DW_EH_PE_pcrel | DW_EH_PE_ptr;
}
        буф.writeByten(7);                                  // Augmentation Length
        буф.writeByten(personality_pointer_encoding);       // P: personality routine address encoding
        /* MACHOBJ 64: pcrel 1 length 2 extern 1 RELOC_GOT
         *         32: [4] address x0013 pcrel 0 length 2 значение xfc тип 4 RELOC_LOCAL_SECTDIFF
         *             [5] address x0000 pcrel 0 length 2 значение xc7 тип 1 RELOC_PAIR
         */
        dwarf_reftoident(dfseg, буф.size(), personality, 0);
        буф.writeByten(LSDA_pointer_encoding);              // L: address encoding for LSDA in FDE
        буф.writeByten(address_pointer_encoding);           // R: encoding of addresses in FDE
    }
    else
    {
        буф.writeByten(1);                                  // Augmentation Length

static if (ELFOBJ)
        буф.writeByten(DW_EH_PE_pcrel | DW_EH_PE_sdata4);   // R: encoding of addresses in FDE
static if (MACHOBJ)
        буф.writeByten(DW_EH_PE_pcrel | DW_EH_PE_ptr);      // R: encoding of addresses in FDE
    }

    // Set CFA beginning state at function entry point
    if (I64)
    {
        буф.writeByten(DW_CFA_def_cfa);        // DEF_CFA r7,8   RSP is at смещение 8
        буф.writeByten(7);                     // r7 is RSP
        буф.writeByten(8);

        буф.writeByten(DW_CFA_offset + 16);    // OFFSET r16,1   RIP is at -8*1[RSP]
        буф.writeByten(1);
    }
    else
    {
        буф.writeByten(DW_CFA_def_cfa);        // DEF_CFA ESP,4
        буф.writeByten(cast(ббайт)dwarf_regno(SP));
        буф.writeByten(4);

        буф.writeByten(DW_CFA_offset + 8);     // OFFSET r8,1
        буф.writeByten(1);
    }

    for (бцел i = 0; i < pad; ++i)
        буф.writeByten(DW_CFA_nop);

    assert(startsize + length + 4 == буф.size());
    return startsize;
}

/*********************************************
 * Generate function's Frame Description Entry into .debug_frame
 * Параметры:
 *      dfseg = SegData[] index for .debug_frame
 *      sfunc = the function
 */
проц writeDebugFrameFDE(IDXSEC dfseg, Symbol *sfunc)
{
    if (I64)
    {
        struct DebugFrameFDE64
        {
          align (1):
            бцел length;
            бцел CIE_pointer;
            бдол initial_location;
            бдол address_range;
        }
        static assert(DebugFrameFDE64.sizeof == 24);

         DebugFrameFDE64 debugFrameFDE64 =
        {   20,             // length
            0,              // CIE_pointer
            0,              // initial_location
            0,              // address_range
        };

        // Pad to 8 byte boundary
        for (бцел n = (-cfa_buf.size() & 7); n; n--)
            cfa_buf.пишиБайт(DW_CFA_nop);

        debugFrameFDE64.length = 20 + cast(бцел)cfa_buf.size();
        debugFrameFDE64.address_range = sfunc.Ssize;
        // Do we need this?
        //debugFrameFDE64.initial_location = sfunc.Soffset;

        Outbuffer *debug_frame_buf = SegData[dfseg].SDbuf;
        бцел debug_frame_buf_offset = cast(бцел)(debug_frame_buf.p - debug_frame_buf.буф);
        debug_frame_buf.резервируй(1000);
        debug_frame_buf.writen(&debugFrameFDE64,debugFrameFDE64.sizeof);
        debug_frame_buf.пиши(&cfa_buf);

static if (ELFOBJ)
        // Absolute address for debug_frame, relative смещение for eh_frame
        dwarf_addrel(dfseg,debug_frame_buf_offset + 4,dfseg,0);

        dwarf_addrel64(dfseg,debug_frame_buf_offset + 8,sfunc.Sseg,0);
    }
    else
    {
        struct DebugFrameFDE32
        {
          align (1):
            бцел length;
            бцел CIE_pointer;
            бцел initial_location;
            бцел address_range;
        }
        static assert(DebugFrameFDE32.sizeof == 16);

         DebugFrameFDE32 debugFrameFDE32 =
        {   12,             // length
            0,              // CIE_pointer
            0,              // initial_location
            0,              // address_range
        };

        // Pad to 4 byte boundary
        for (бцел n = (-cfa_buf.size() & 3); n; n--)
            cfa_buf.пишиБайт(DW_CFA_nop);

        debugFrameFDE32.length = 12 + cast(бцел)cfa_buf.size();
        debugFrameFDE32.address_range = cast(бцел)sfunc.Ssize;
        // Do we need this?
        //debugFrameFDE32.initial_location = sfunc.Soffset;

        Outbuffer *debug_frame_buf = SegData[dfseg].SDbuf;
        бцел debug_frame_buf_offset = cast(бцел)(debug_frame_buf.p - debug_frame_buf.буф);
        debug_frame_buf.резервируй(1000);
        debug_frame_buf.writen(&debugFrameFDE32,debugFrameFDE32.sizeof);
        debug_frame_buf.пиши(&cfa_buf);

static if (ELFOBJ)
        // Absolute address for debug_frame, relative смещение for eh_frame
        dwarf_addrel(dfseg,debug_frame_buf_offset + 4,dfseg,0);

        dwarf_addrel(dfseg,debug_frame_buf_offset + 8,sfunc.Sseg,0);
    }
}

/*********************************************
 * Append function's FDE (Frame Description Entry) to .eh_frame
 * Параметры:
 *      dfseg = SegData[] index for .eh_frame
 *      sfunc = the function
 *      ehunwind = will have EH unwind table
 *      CIE_offset = смещение of enclosing CIE
 */
проц writeEhFrameFDE(IDXSEC dfseg, Symbol *sfunc, бул ehunwind, бцел CIE_offset)
{
    Outbuffer *буф = SegData[dfseg].SDbuf;
    const бцел startsize = cast(бцел)буф.size();

static if (MACHOBJ)
{
    /* Create symbol named "funcname.eh" for the start of the FDE
     */
    Symbol *fdesym;
    {
        const т_мера len = strlen(sfunc.Sident.ptr);
        сим *имя = cast(сим *)malloc(len + 3 + 1);
        if (!имя)
            err_nomem();
        memcpy(имя, sfunc.Sident.ptr, len);
        memcpy(имя + len, ".eh".ptr, 3 + 1);
        fdesym = symbol_name(имя, SCglobal, tspvoid);
        Obj.pubdef(dfseg, fdesym, startsize);
        symbol_keep(fdesym);
    }
}

    if (sfunc.ty() & mTYnaked)
    {
        /* Do not have info on naked functions. Assume they are set up as:
         *   сунь RBP
         *   mov  RSP,RSP
         */
        цел off = 2 * REGSIZE;
        dwarf_CFA_set_loc(1);
        dwarf_CFA_set_reg_offset(SP, off);
        dwarf_CFA_offset(BP, -off);
        dwarf_CFA_set_loc(I64 ? 4 : 3);
        dwarf_CFA_set_reg_offset(BP, off);
    }

    // Length of FDE, not including padding
static if (ELFOBJ)
    const бцел fdelen = 4 + 4
        + 4 + 4
        + (ehunwind ? 5 : 1) + cast(бцел)cfa_buf.size();
else static if (MACHOBJ)
    const бцел fdelen = 4 + 4
        + (I64 ? 8 + 8 : 4 + 4)                         // PC_Begin + PC_Range
        + (ehunwind ? (I64 ? 9 : 5) : 1) + cast(бцел)cfa_buf.size();

    const бцел pad = -fdelen & (I64 ? 7 : 3);      // pad to addressing unit size boundary
    const бцел length = fdelen + pad - 4;

    буф.резервируй(length + 4);
    буф.write32(length);                               // Length (no Extended Length)
    буф.write32((startsize + 4) - CIE_offset);         // CIE Pointer
static if (ELFOBJ)
{
    цел fixup = I64 ? R_X86_64_PC32 : R_386_PC32;
    буф.write32(cast(бцел)(I64 ? 0 : sfunc.Soffset));             // address of function
    Obj.addrel(dfseg, startsize + 8, fixup, MAP_SEG2SYMIDX(sfunc.Sseg), sfunc.Soffset);
    //Obj.reftoident(dfseg, startsize + 8, sfunc, 0, CFpc32 | CFoff); // PC_begin
    буф.write32(cast(бцел)sfunc.Ssize);                         // PC Range
}
else static if (MACHOBJ)
{
    dwarf_eh_frame_fixup(dfseg, буф.size(), sfunc, 0, fdesym);

    if (I64)
        буф.write64(sfunc.Ssize);                     // PC Range
    else
        буф.write32(cast(бцел)sfunc.Ssize);           // PC Range
}
else
    assert(0);

    if (ehunwind)
    {
        цел etseg = dwarf_except_table_alloc(sfunc);
static if (ELFOBJ)
{
        буф.writeByten(4);                             // Augmentation Data Length
        буф.write32(I64 ? 0 : sfunc.Sfunc.LSDAoffset); // address of LSDA (".gcc_except_table")
        if (config.flags3 & CFG3pic)
        {
            Obj.addrel(dfseg, буф.size() - 4, fixup, MAP_SEG2SYMIDX(etseg), sfunc.Sfunc.LSDAoffset);
        }
        else
            dwarf_addrel(dfseg, буф.size() - 4, etseg, sfunc.Sfunc.LSDAoffset);      // and the fixup
}
else static if (MACHOBJ)
{
        буф.writeByten(I64 ? 8 : 4);                   // Augmentation Data Length
        dwarf_eh_frame_fixup(dfseg, буф.size(), sfunc.Sfunc.LSDAsym, 0, fdesym);
}
    }
    else
        буф.writeByten(0);                             // Augmentation Data Length

    буф.пиши(&cfa_buf);

    for (бцел i = 0; i < pad; ++i)
        буф.writeByten(DW_CFA_nop);

    assert(startsize + length + 4 == буф.size());
}

проц dwarf_initfile(ткст0 имяф)
{
    if (config.ehmethod == EHmethod.EH_DWARF)
    {
static if (MACHOBJ)
{
        except_table_seg = 0;
        except_table_num = 0;
        eh_frame_seg = 0;
        eh_frame_sym = null;
}
        CIE_offset_unwind = ~0;
        CIE_offset_no_unwind = ~0;
        //dwarf_except_table_alloc();
        dwarf_eh_frame_alloc();
    }
    if (!config.fulltypes)
        return;
    if (config.ehmethod == EHmethod.EH_DM)
    {
static if (MACHOBJ)
        цел flags = S_ATTR_DEBUG;
else static if (ELFOBJ)
        цел flags = SHT_PROGBITS;

        цел seg = dwarf_getsegment(debug_frame_name, 1, flags);
        Outbuffer *буф = SegData[seg].SDbuf;
        буф.резервируй(1000);
        writeDebugFrameHeader(буф);
    }

    /* ======================================== */

    if (reset_symbuf)
    {
        Symbol **p = cast(Symbol **)reset_symbuf.буф;
        const т_мера n = reset_symbuf.size() / (Symbol *).sizeof;
        for (т_мера i = 0; i < n; ++i)
            symbol_reset(p[i]);
        reset_symbuf.устРазм(0);
    }
    else
    {
        reset_symbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(reset_symbuf);
        reset_symbuf.enlarge(50 * (Symbol *).sizeof);
    }

    /* ======================================== */

    debug_str.initialize();
    //Outbuffer *debug_str_buf = debug_str.буф;

    /* ======================================== */

    debug_ranges.initialize();

    /* ======================================== */

    debug_loc.initialize();

    /* ======================================== */

    if (infoFileName_table)
    {
        AAchars.разрушь(infoFileName_table);
        infoFileName_table = null;
    }

    debug_line.initialize();

    debugline = debugline_init;

    debug_line.буф.пиши(&debugline, debugline.sizeof);

    // include_directories
version (SCPP)
    for (т_мера i = 0; i < pathlist.length(); ++i)
    {
        debug_line.буф.writeString(pathlist[i]);
        debug_line.буф.пишиБайт(0);
    }

version (Dinrus) version (none)
    for (цел i = 0; i < глоб2.парамы.imppath.dim; i++)
    {
        debug_line.буф.writeString((*глоб2.парамы.imppath)[i]);
        debug_line.буф.пишиБайт(0);
    }

    debug_line.буф.пишиБайт(0);              // terminated with 0 byte

    /* ======================================== */

    debug_abbrev.initialize();
    abbrevcode = 1;

    // Free only if starting another файл. Waste of time otherwise.
    if (abbrev_table)
    {
        AApair.разрушь(abbrev_table);
        abbrev_table = null;
    }

    static const ббайт[21] abbrevHeader =
    [
        1,                      // abbreviation code
        DW_TAG_compile_unit,
        1,
        DW_AT_producer,  DW_FORM_string,
        DW_AT_language,  DW_FORM_data1,
        DW_AT_name,      DW_FORM_string,
        DW_AT_comp_dir,  DW_FORM_string,
        DW_AT_low_pc,    DW_FORM_addr,
        DW_AT_entry_pc,  DW_FORM_addr,
        DW_AT_ranges,    DW_FORM_data4,
        DW_AT_stmt_list, DW_FORM_data4,
        0,               0,
    ];

    debug_abbrev.буф.пиши(abbrevHeader.ptr,abbrevHeader.sizeof);

    /* ======================================== */

    debug_info.initialize();

    debuginfo = debuginfo_init;
    if (I64)
        debuginfo.address_size = 8;

    // Workaround https://issues.dlang.org/show_bug.cgi?ид=16563
    // Struct alignment is ignored due to 2.072 regression.
    static if (debuginfo.alignof == 1)
        debug_info.буф.пиши(&debuginfo, debuginfo.sizeof);
    else
    {
        debug_info.буф.пиши(&debuginfo.total_length, 4);
        debug_info.буф.пиши(&debuginfo.version_, 2);
        debug_info.буф.пиши(&debuginfo.abbrev_offset, 4);
        debug_info.буф.пиши(&debuginfo.address_size, 1);
    }
static if (ELFOBJ)
    dwarf_addrel(debug_info.seg,6,debug_abbrev.seg);

    debug_info.буф.writeuLEB128(1);                   // abbreviation code

version (Dinrus)
{
    debug_info.буф.пиши("Digital Mars D ");
    debug_info.буф.пиши(config._version);     // DW_AT_producer
    // DW_AT_language
    debug_info.буф.пишиБайт((config.fulltypes == CVDWARF_D) ? DW_LANG_D : DW_LANG_C89);
}
else version (SCPP)
{
    debug_info.буф.пиши("Digital Mars C ");
    debug_info.буф.writeString(глоб2._version);      // DW_AT_producer
    debug_info.буф.пишиБайт(DW_LANG_C89);            // DW_AT_language
}
else
    static assert(0);

    debug_info.буф.writeString(имяф);             // DW_AT_name

static if (0)
{
    // This relies on an extension to POSIX.1 not always implemented
    сим *cwd = getcwd(null, 0);
}
else
{
    сим *cwd;
    т_мера sz = 80;
    while (1)
    {
        errno = 0;
        cwd = cast(сим *)malloc(sz + 1);
        if (!cwd)
            err_nomem();
        сим *буф = getcwd(cwd, sz);
        if (буф)
        {   cwd[sz] = 0;        // man page doesn't say if always 0 terminated
            break;
        }
        if (errno == ERANGE)
        {
            sz += 80;
            free(cwd);
            continue;
        }
        cwd[0] = 0;
        break;
    }
}
    //debug_info.буф.write32(Obj.addstr(debug_str_buf, cwd)); // DW_AT_comp_dir as DW_FORM_strp, doesn't work on some systems
    debug_info.буф.writeString(cwd);                  // DW_AT_comp_dir as DW_FORM_string
    free(cwd);

    append_addr(debug_info.буф, 0);               // DW_AT_low_pc
    append_addr(debug_info.буф, 0);               // DW_AT_entry_pc

static if (ELFOBJ)
    dwarf_addrel(debug_info.seg,debug_info.буф.size(),debug_ranges.seg);

    debug_info.буф.write32(0);                        // DW_AT_ranges

static if (ELFOBJ)
    dwarf_addrel(debug_info.seg,debug_info.буф.size(),debug_line.seg);

    debug_info.буф.write32(0);                        // DW_AT_stmt_list

    memset(typidx_tab.ptr, 0, typidx_tab.sizeof);

    /* ======================================== */

    debug_pubnames.initialize();
    цел seg = debug_pubnames.seg;

    debug_pubnames.буф.write32(0);             // unit_length
    debug_pubnames.буф.writeWord(2);           // version_

static if (ELFOBJ)
    dwarf_addrel(seg,debug_pubnames.буф.size(),debug_info.seg);

    debug_pubnames.буф.write32(0);             // debug_info_offset
    debug_pubnames.буф.write32(0);             // debug_info_length

    /* ======================================== */

    debug_aranges.initialize();

    debug_aranges.буф.write32(0);              // unit_length
    debug_aranges.буф.writeWord(2);            // version_

static if (ELFOBJ)
    dwarf_addrel(debug_aranges.seg,debug_aranges.буф.size(),debug_info.seg);

    debug_aranges.буф.write32(0);              // debug_info_offset
    debug_aranges.буф.пишиБайт(I64 ? 8 : 4);  // address_size
    debug_aranges.буф.пишиБайт(0);            // segment_size
    debug_aranges.буф.write32(0);              // pad to 16
}


/*************************************
 * Add a файл to the .debug_line header
 */
цел dwarf_line_addfile(ткст0 имяф)
{
    if (!infoFileName_table) {
        infoFileName_table = AAchars.создай();
        linebuf_filetab_end = debug_line.буф.size();
    }

    бцел *pidx = infoFileName_table.get(имяф, cast(бцел)strlen(имяф));
    if (!*pidx)                 // if no idx assigned yet
    {
        *pidx = infoFileName_table.length(); // assign newly computed idx

        т_мера before = debug_line.буф.size();
        debug_line.буф.writeString(имяф);
        debug_line.буф.пишиБайт(0);      // directory table index
        debug_line.буф.пишиБайт(0);      // mtime
        debug_line.буф.пишиБайт(0);      // length
        linebuf_filetab_end += debug_line.буф.size() - before;
    }

    return *pidx;
}

проц dwarf_initmodule(ткст0 имяф, ткст0 modname)
{
    if (modname)
    {
        static const ббайт[6] abbrevModule =
        [
            DW_TAG_module,
            //1,                // one children
            0,                  // no children
            DW_AT_name,         DW_FORM_string, // module имя
            0,                  0,
        ];
        abbrevcode++;
        debug_abbrev.буф.writeuLEB128(abbrevcode);
        debug_abbrev.буф.пиши(abbrevModule.ptr, abbrevModule.sizeof);
        debug_info.буф.writeuLEB128(abbrevcode);      // abbreviation code
        debug_info.буф.writeString(modname);          // DW_AT_name
        //hasModname = 1;
    }
    else
        hasModname = 0;

    dwarf_line_addfile(имяф);
}

проц dwarf_termmodule()
{
    if (hasModname)
        debug_info.буф.пишиБайт(0);  // end of DW_TAG_module's children
}

/*************************************
 * Finish writing Dwarf debug info to объект файл.
 */

проц dwarf_termfile()
{
    //printf("dwarf_termfile()\n");

    /* ======================================== */

    // Put out line number info

    // file_names
    бцел last_filenumber = 0;
    ткст0 last_filename = null;
    for (бцел seg = 1; seg <= seg_count; seg++)
    {
        for (бцел i = 0; i < SegData[seg].SDlinnum_count; i++)
        {
            linnum_data *ld = &SegData[seg].SDlinnum_data[i];
            ткст0 имяф;
version (Dinrus)
            имяф = ld.имяф;
else
{
            Sfile *sf = ld.filptr;
            if (sf)
                имяф = sf.SFname;
            else
                имяф = .имяф;
}
            if (last_filename == имяф)
            {
                ld.filenumber = last_filenumber;
            }
            else
            {
                ld.filenumber = dwarf_line_addfile(имяф);

                last_filenumber = ld.filenumber;
                last_filename = имяф;
            }
        }
    }
    // assert we haven't emitted anything but файл table entries
    assert(debug_line.буф.size() == linebuf_filetab_end);
    debug_line.буф.пишиБайт(0);              // end of file_names

    debugline.prologue_length = cast(бцел)debug_line.буф.size() - 10;

    for (бцел seg = 1; seg <= seg_count; seg++)
    {
        seg_data *sd = SegData[seg];
        бцел addressmax = 0;
        бцел linestart = ~0;

        if (!sd.SDlinnum_count)
            continue;

static if (ELFOBJ)
        if (!sd.SDsym) // gdb ignores line number данные without a DW_AT_name
            continue;

        //printf("sd = %x, SDlinnum_count = %d\n", sd, sd.SDlinnum_count);
        for (цел i = 0; i < sd.SDlinnum_count; i++)
        {   linnum_data *ld = &sd.SDlinnum_data[i];

            // Set address to start of segment with DW_LNE_set_address
            debug_line.буф.пишиБайт(0);
            debug_line.буф.пишиБайт(_tysize[TYnptr] + 1);
            debug_line.буф.пишиБайт(DW_LNE_set_address);

            dwarf_appreladdr(debug_line.seg,debug_line.буф,seg,0);

            // Dwarf2 6.2.2 State machine registers
            бцел address = 0;       // instruction address
            бцел файл = ld.filenumber;
            бцел line = 1;          // line numbers beginning with 1

            debug_line.буф.пишиБайт(DW_LNS_set_file);
            debug_line.буф.writeuLEB128(файл);

            for (цел j = 0; j < ld.linoff_count; j++)
            {   цел lininc = ld.linoff[j][0] - line;
                цел addinc = ld.linoff[j][1] - address;

                //printf("\tld[%d] line = %d смещение = x%x lininc = %d addinc = %d\n", j, ld.linoff[j][0], ld.linoff[j][1], lininc, addinc);

                //assert(addinc >= 0);
                if (addinc < 0)
                    continue;
                if (j && lininc == 0 && !(addinc && j + 1 == ld.linoff_count))
                    continue;
                line += lininc;
                if (line < linestart)
                    linestart = line;
                address += addinc;
                if (address >= addressmax)
                    addressmax = address + 1;
                if (lininc >= debugline.line_base && lininc < debugline.line_base + debugline.line_range)
                {   бцел opcode = lininc - debugline.line_base +
                                    debugline.line_range * addinc +
                                    debugline.opcode_base;

                    if (opcode <= 255)
                    {   debug_line.буф.пишиБайт(opcode);
                        continue;
                    }
                }
                if (lininc)
                {
                    debug_line.буф.пишиБайт(DW_LNS_advance_line);
                    debug_line.буф.writesLEB128(cast(цел)lininc);
                }
                if (addinc)
                {
                    debug_line.буф.пишиБайт(DW_LNS_advance_pc);
                    debug_line.буф.writeuLEB128(cast(бцел)addinc);
                }
                if (lininc || addinc)
                    debug_line.буф.пишиБайт(DW_LNS_copy);
            }

            // Write DW_LNS_advance_pc to cover the function prologue
            debug_line.буф.пишиБайт(DW_LNS_advance_pc);
            debug_line.буф.writeuLEB128(cast(бцел)(sd.SDbuf.size() - address));

            // Write DW_LNE_end_sequence
            debug_line.буф.пишиБайт(0);
            debug_line.буф.пишиБайт(1);
            debug_line.буф.пишиБайт(1);

            // сбрось linnum_data
            ld.linoff_count = 0;
        }
    }

    debugline.total_length = cast(бцел)debug_line.буф.size() - 4;
    memcpy(debug_line.буф.буф, &debugline, debugline.sizeof);

    // Bugzilla 3502, workaround OSX's ld64-77 bug.
    // Don't emit the the debug_line section if nothing has been written to the line table.
    if (debugline.prologue_length + 10 == debugline.total_length + 4)
        debug_line.буф.сбрось();

    /* ================================================= */

    debug_abbrev.буф.пишиБайт(0);

    /* ================================================= */

    debug_info.буф.пишиБайт(0);      // ending abbreviation code

    debuginfo.total_length = cast(бцел)debug_info.буф.size() - 4;
    // Workaround https://issues.dlang.org/show_bug.cgi?ид=16563
    // Struct alignment is ignored due to 2.072 regression.
    static if (debuginfo.alignof == 1)
        memcpy(debug_info.буф.буф, &debuginfo, debuginfo.sizeof);
    else
    {
        memcpy(debug_info.буф.буф, &debuginfo.total_length, 4);
        memcpy(debug_info.буф.буф+4, &debuginfo.version_, 2);
        memcpy(debug_info.буф.буф+6, &debuginfo.abbrev_offset, 4);
        memcpy(debug_info.буф.буф+10, &debuginfo.address_size, 1);
    }

    /* ================================================= */

    // Terminate by смещение field containing 0
    debug_pubnames.буф.write32(0);

    // Plug final sizes into header
    *cast(бцел *)debug_pubnames.буф.буф = cast(бцел)debug_pubnames.буф.size() - 4;
    *cast(бцел *)(debug_pubnames.буф.буф + 10) = cast(бцел)debug_info.буф.size();

    /* ================================================= */

    // Terminate by address/length fields containing 0
    append_addr(debug_aranges.буф, 0);
    append_addr(debug_aranges.буф, 0);

    // Plug final sizes into header
    *cast(бцел *)debug_aranges.буф.буф = cast(бцел)debug_aranges.буф.size() - 4;

    /* ================================================= */

    // Terminate by beg address/end address fields containing 0
    append_addr(debug_ranges.буф, 0);
    append_addr(debug_ranges.буф, 0);

    /* ================================================= */

    // Free only if starting another файл. Waste of time otherwise.
    if (type_table)
    {
        AApair.разрушь(type_table);
        type_table = null;
    }
    if (functype_table)
    {
        AApair.разрушь(functype_table);
        functype_table = null;
    }
    if (functypebuf)
        functypebuf.устРазм(0);
}

/*****************************************
 * Start of code gen for function.
 */
проц dwarf_func_start(Symbol *sfunc)
{
    //printf("dwarf_func_start(%s)\n", sfunc.Sident.ptr);
    if (I16 || I32)
        CFA_state_current = CFA_state_init_32;
    else if (I64)
        CFA_state_current = CFA_state_init_64;
    else
        assert(0);
    CFA_state_current.reg = dwarf_regno(SP);
    assert(CFA_state_current.смещение == OFFSET_FAC);
    cfa_buf.сбрось();
}

/*****************************************
 * End of code gen for function.
 */
проц dwarf_func_term(Symbol *sfunc)
{
   //printf("dwarf_func_term(sfunc = '%s')\n", sfunc.Sident.ptr);

    if (config.ehmethod == EHmethod.EH_DWARF)
    {
        бул ehunwind = doUnwindEhFrame();

        IDXSEC dfseg = dwarf_eh_frame_alloc();

        Outbuffer *буф = SegData[dfseg].SDbuf;
        буф.резервируй(1000);

        бцел *poffset = ehunwind ? &CIE_offset_unwind : &CIE_offset_no_unwind;
        if (*poffset == ~0)
            *poffset = writeEhFrameHeader(dfseg, буф, getRtlsymPersonality(), ehunwind);

        writeEhFrameFDE(dfseg, sfunc, ehunwind, *poffset);
    }
    if (!config.fulltypes)
        return;

version (Dinrus)
{
    if (sfunc.Sflags & SFLnodebug)
        return;
    ткст0 имяф = sfunc.Sfunc.Fstartline.Sfilename;
    if (!имяф)
        return;
}

    бцел funcabbrevcode;

    if (ehmethod(sfunc) == EHmethod.EH_DM)
    {
static if (MACHOBJ)
        цел flags = S_ATTR_DEBUG;
else static if (ELFOBJ)
        цел flags = SHT_PROGBITS;

        IDXSEC dfseg = dwarf_getsegment(debug_frame_name, 1, flags);
        writeDebugFrameFDE(dfseg, sfunc);
    }

    IDXSEC seg = sfunc.Sseg;
    seg_data *sd = SegData[seg];

version (Dinrus)
    цел filenum = dwarf_line_addfile(имяф);
else
    цел filenum = 1;

        бцел ret_type = dwarf_typidx(sfunc.Stype.Tnext);
        if (tybasic(sfunc.Stype.Tnext.Tty) == TYvoid)
            ret_type = 0;

        // See if there are any parameters
        цел haveparameters = 0;
        бцел formalcode = 0;
        бцел autocode = 0;
        for (SYMIDX si = 0; si < globsym.top; si++)
        {
            Symbol *sa = globsym.tab[si];

version (Dinrus)
            if (sa.Sflags & SFLnodebug) continue;

             ббайт[12] formal =
            [
                DW_TAG_formal_parameter,
                0,
                DW_AT_name,       DW_FORM_string,
                DW_AT_type,       DW_FORM_ref4,
                DW_AT_artificial, DW_FORM_flag,
                DW_AT_location,   DW_FORM_block1,
                0,                0,
            ];

            switch (sa.Sclass)
            {
                case SCparameter:
                case SCregpar:
                case SCfastpar:
                    dwarf_typidx(sa.Stype);
                    formal[0] = DW_TAG_formal_parameter;
                    if (!formalcode)
                        formalcode = dwarf_abbrev_code(formal.ptr, formal.sizeof);
                    haveparameters = 1;
                    break;

                case SCauto:
                case SCbprel:
                case SCregister:
                case SCpseudo:
                    dwarf_typidx(sa.Stype);
                    formal[0] = DW_TAG_variable;
                    if (!autocode)
                        autocode = dwarf_abbrev_code(formal.ptr, formal.sizeof);
                    haveparameters = 1;
                    break;

                default:
                    break;
            }
        }

        Outbuffer abuf;
        abuf.пишиБайт(DW_TAG_subprogram);
        abuf.пишиБайт(haveparameters);          // have children?
        if (haveparameters)
        {
            abuf.пишиБайт(DW_AT_sibling);  abuf.пишиБайт(DW_FORM_ref4);
        }
        abuf.пишиБайт(DW_AT_name);      abuf.пишиБайт(DW_FORM_string);

static if (DWARF_VERSION >= 4)
{
        abuf.writeuLEB128(DW_AT_linkage_name);      abuf.пишиБайт(DW_FORM_string);
}
else
{
        abuf.writeuLEB128(DW_AT_MIPS_linkage_name); abuf.пишиБайт(DW_FORM_string);
}

        abuf.пишиБайт(DW_AT_decl_file); abuf.пишиБайт(DW_FORM_data1);
        abuf.пишиБайт(DW_AT_decl_line); abuf.пишиБайт(DW_FORM_data2);
        if (ret_type)
        {
            abuf.пишиБайт(DW_AT_type);  abuf.пишиБайт(DW_FORM_ref4);
        }
        if (sfunc.Sclass == SCglobal)
        {
            abuf.пишиБайт(DW_AT_external);       abuf.пишиБайт(DW_FORM_flag);
        }
        abuf.пишиБайт(DW_AT_low_pc);     abuf.пишиБайт(DW_FORM_addr);
        abuf.пишиБайт(DW_AT_high_pc);    abuf.пишиБайт(DW_FORM_addr);
        abuf.пишиБайт(DW_AT_frame_base); abuf.пишиБайт(DW_FORM_data4);
        abuf.пишиБайт(0);                abuf.пишиБайт(0);

        funcabbrevcode = dwarf_abbrev_code(abuf.буф, abuf.size());

        бцел idxsibling = 0;
        бцел siblingoffset;

        бцел infobuf_offset = cast(бцел)debug_info.буф.size();
        debug_info.буф.writeuLEB128(funcabbrevcode);  // abbreviation code
        if (haveparameters)
        {
            siblingoffset = cast(бцел)debug_info.буф.size();
            debug_info.буф.write32(idxsibling);       // DW_AT_sibling
        }

        ткст0 имя;

version (Dinrus)
        имя = sfunc.prettyIdent ? sfunc.prettyIdent : sfunc.Sident.ptr;
else
        имя = sfunc.Sident.ptr;

        debug_info.буф.writeString(имя);             // DW_AT_name
        debug_info.буф.writeString(sfunc.Sident.ptr);    // DW_AT_MIPS_linkage_name
        debug_info.буф.пишиБайт(filenum);            // DW_AT_decl_file
        debug_info.буф.writeWord(sfunc.Sfunc.Fstartline.Slinnum);   // DW_AT_decl_line
        if (ret_type)
            debug_info.буф.write32(ret_type);         // DW_AT_type

        if (sfunc.Sclass == SCglobal)
            debug_info.буф.пишиБайт(1);              // DW_AT_external

        // DW_AT_low_pc and DW_AT_high_pc
        dwarf_appreladdr(debug_info.seg, debug_info.буф, seg, funcoffset);
        dwarf_appreladdr(debug_info.seg, debug_info.буф, seg, funcoffset + sfunc.Ssize);

        // DW_AT_frame_base
static if (ELFOBJ)
        dwarf_apprel32(debug_info.seg, debug_info.буф, debug_loc.seg, debug_loc.буф.size());
else
        // 64-bit DWARF relocations don't work for OSX64 codegen
        debug_info.буф.write32(cast(бцел)debug_loc.буф.size());

        if (haveparameters)
        {
            for (SYMIDX si = 0; si < globsym.top; si++)
            {
                Symbol *sa = globsym.tab[si];

version (Dinrus)
                if (sa.Sflags & SFLnodebug) continue;

                бцел vcode;

                switch (sa.Sclass)
                {
                    case SCparameter:
                    case SCregpar:
                    case SCfastpar:
                        vcode = formalcode;
                        goto L1;
                    case SCauto:
                    case SCregister:
                    case SCpseudo:
                    case SCbprel:
                        vcode = autocode;
                    L1:
                    {
                        бцел soffset;
                        бцел tidx = dwarf_typidx(sa.Stype);

                        debug_info.буф.writeuLEB128(vcode);           // abbreviation code
                        debug_info.буф.writeString(sa.Sident.ptr);       // DW_AT_name
                        debug_info.буф.write32(tidx);                 // DW_AT_type
                        debug_info.буф.пишиБайт(sa.Sflags & SFLartifical ? 1 : 0); // DW_FORM_tag
                        soffset = cast(бцел)debug_info.буф.size();
                        debug_info.буф.пишиБайт(2);                  // DW_FORM_block1
                        if (sa.Sfl == FLreg || sa.Sclass == SCpseudo)
                        {   // BUG: register pairs not supported in Dwarf?
                            debug_info.буф.пишиБайт(DW_OP_reg0 + sa.Sreglsw);
                        }
                        else if (sa.Sscope && vcode == autocode)
                        {
                            assert(sa.Sscope.Stype.Tnext && sa.Sscope.Stype.Tnext.Tty == TYstruct);

                            /* найди member смещение in closure */
                            targ_т_мера memb_off = 0;
                            struct_t *st = sa.Sscope.Stype.Tnext.Ttag.Sstruct; // Sscope is __closptr
                            foreach (sl; ListRange(st.Sfldlst))
                            {
                                Symbol *sf = list_symbol(sl);
                                if (sf.Sclass == SCmember)
                                {
                                    if(strcmp(sa.Sident.ptr, sf.Sident.ptr) == 0)
                                    {
                                        memb_off = sf.Smemoff;
                                        goto L2;
                                    }
                                }
                            }
                            L2:
                            targ_т_мера closptr_off = sa.Sscope.Soffset; // __closptr смещение
                            //printf("dwarf closure: sym: %s, closptr: %s, ptr_off: %lli, memb_off: %lli\n",
                            //    sa.Sident.ptr, sa.Sscope.Sident.ptr, closptr_off, memb_off);

                            debug_info.буф.пишиБайт(DW_OP_fbreg);
                            debug_info.буф.writesLEB128(cast(бцел)(Auto.size + BPoff - Para.size + closptr_off)); // closure pointer смещение from frame base
                            debug_info.буф.пишиБайт(DW_OP_deref);
                            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
                            debug_info.буф.writeuLEB128(cast(бцел)memb_off); // closure variable смещение
                        }
                        else
                        {
                            debug_info.буф.пишиБайт(DW_OP_fbreg);
                            if (sa.Sclass == SCregpar ||
                                sa.Sclass == SCparameter)
                                debug_info.буф.writesLEB128(cast(цел)sa.Soffset);
                            else if (sa.Sclass == SCfastpar)
                                debug_info.буф.writesLEB128(cast(цел)(Fast.size + BPoff - Para.size + sa.Soffset));
                            else if (sa.Sclass == SCbprel)
                                debug_info.буф.writesLEB128(cast(цел)(-Para.size + sa.Soffset));
                            else
                                debug_info.буф.writesLEB128(cast(цел)(Auto.size + BPoff - Para.size + sa.Soffset));
                        }
                        debug_info.буф.буф[soffset] = cast(ббайт)(debug_info.буф.size() - soffset - 1);
                        break;
                    }

                    default:
                        break;
                }
            }
            debug_info.буф.пишиБайт(0);              // end of параметр children

            idxsibling = cast(бцел)debug_info.буф.size();
            *cast(бцел *)(debug_info.буф.буф + siblingoffset) = idxsibling;
        }

        /* ============= debug_pubnames =========================== */

        debug_pubnames.буф.write32(infobuf_offset);
        // Should be the fully qualified имя, not the simple DW_AT_name
        debug_pubnames.буф.writeString(sfunc.Sident.ptr);

        /* ============= debug_aranges =========================== */

        if (sd.SDaranges_offset)
            // Extend existing entry size
            *cast(бдол *)(debug_aranges.буф.буф + sd.SDaranges_offset + _tysize[TYnptr]) = funcoffset + sfunc.Ssize;
        else
        {   // Add entry
            sd.SDaranges_offset = cast(бцел)debug_aranges.буф.size();
            // address of start of .text segment
            dwarf_appreladdr(debug_aranges.seg, debug_aranges.буф, seg, 0);
            // size of .text segment
            append_addr(debug_aranges.буф, funcoffset + sfunc.Ssize);
        }

        /* ============= debug_ranges =========================== */

        /* Each function gets written into its own segment,
         * indicate this by adding to the debug_ranges
         */
        // start of function and end of function
        dwarf_appreladdr(debug_ranges.seg, debug_ranges.буф, seg, funcoffset);
        dwarf_appreladdr(debug_ranges.seg, debug_ranges.буф, seg, funcoffset + sfunc.Ssize);

        /* ============= debug_loc =========================== */

        assert(Para.size >= 2 * REGSIZE);
        assert(Para.size < 63); // avoid sLEB128 encoding
        ushort op_size = 0x0002;
        ushort loc_op;

        // set the entry for this function in .debug_loc segment
        // after call
        dwarf_appreladdr(debug_loc.seg, debug_loc.буф, seg, funcoffset + 0);
        dwarf_appreladdr(debug_loc.seg, debug_loc.буф, seg, funcoffset + 1);

        loc_op = cast(ushort)(((Para.size - REGSIZE) << 8) | (DW_OP_breg0 + dwarf_regno(SP)));
        debug_loc.буф.write32(loc_op << 16 | op_size);

        // after сунь EBP
        dwarf_appreladdr(debug_loc.seg, debug_loc.буф, seg, funcoffset + 1);
        dwarf_appreladdr(debug_loc.seg, debug_loc.буф, seg, funcoffset + 3);

        loc_op = cast(ushort)(((Para.size) << 8) | (DW_OP_breg0 + dwarf_regno(SP)));
        debug_loc.буф.write32(loc_op << 16 | op_size);

        // after mov EBP, ESP
        dwarf_appreladdr(debug_loc.seg, debug_loc.буф, seg, funcoffset + 3);
        dwarf_appreladdr(debug_loc.seg, debug_loc.буф, seg, funcoffset + sfunc.Ssize);

        loc_op = cast(ushort)(((Para.size) << 8) | (DW_OP_breg0 + dwarf_regno(BP)));
        debug_loc.буф.write32(loc_op << 16 | op_size);

        // 2 нуль addresses to end loc_list
        append_addr(debug_loc.буф, 0);
        append_addr(debug_loc.буф, 0);
}


/******************************************
 * Write out symbol table for current function.
 */

проц cv_outsym(Symbol *s)
{
    //printf("cv_outsym('%s')\n",s.Sident.ptr);
    //symbol_print(s);

    symbol_debug(s);

version (Dinrus)
{
    if (s.Sflags & SFLnodebug)
        return;
}
    тип *t = s.Stype;
    type_debug(t);
    tym_t tym = tybasic(t.Tty);
    if (tyfunc(tym) && s.Sclass != SCtypedef)
        return;

    Outbuffer abuf;
    бцел code;
    бцел typidx;
    бцел soffset;
    switch (s.Sclass)
    {
        case SCglobal:
            typidx = dwarf_typidx(t);

            abuf.пишиБайт(DW_TAG_variable);
            abuf.пишиБайт(0);                  // no children
            abuf.пишиБайт(DW_AT_name);         abuf.пишиБайт(DW_FORM_string);
            abuf.пишиБайт(DW_AT_type);         abuf.пишиБайт(DW_FORM_ref4);
            abuf.пишиБайт(DW_AT_external);     abuf.пишиБайт(DW_FORM_flag);
            abuf.пишиБайт(DW_AT_location);     abuf.пишиБайт(DW_FORM_block1);
            abuf.пишиБайт(0);                  abuf.пишиБайт(0);
            code = dwarf_abbrev_code(abuf.буф, abuf.size());

            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString(s.Sident.ptr);    // DW_AT_name
            debug_info.буф.write32(typidx);           // DW_AT_type
            debug_info.буф.пишиБайт(1);              // DW_AT_external

            soffset = cast(бцел)debug_info.буф.size();
            debug_info.буф.пишиБайт(2);                      // DW_FORM_block1

static if (ELFOBJ)
{
            // debug info for TLS variables
            assert(s.Sxtrnnum);
            if (s.Sfl == FLtlsdata)
            {
                if (I64)
                {
                    debug_info.буф.пишиБайт(DW_OP_const8u);
                    Obj.addrel(debug_info.seg, debug_info.буф.size(), R_X86_64_DTPOFF32, s.Sxtrnnum, 0);
                    debug_info.буф.write64(0);
                }
                else
                {
                    debug_info.буф.пишиБайт(DW_OP_const4u);
                    Obj.addrel(debug_info.seg, debug_info.буф.size(), R_386_TLS_LDO_32, s.Sxtrnnum, 0);
                    debug_info.буф.write32(0);
                }
                debug_info.буф.пишиБайт(DW_OP_GNU_push_tls_address);
            }
            else
            {
                debug_info.буф.пишиБайт(DW_OP_addr);
                dwarf_appreladdr(debug_info.seg, debug_info.буф, s.Sseg, s.Soffset); // address of глоб2
            }
}
else
{
            debug_info.буф.пишиБайт(DW_OP_addr);
            dwarf_appreladdr(debug_info.seg, debug_info.буф, s.Sseg, s.Soffset); // address of глоб2
}

            debug_info.буф.буф[soffset] = cast(ббайт)(debug_info.буф.size() - soffset - 1);
            break;

        default:
            break;
    }
}


/******************************************
 * Write out any deferred symbols.
 */

проц cv_outlist()
{
}


/******************************************
 * Write out symbol table for current function.
 */

проц cv_func(Funcsym *s)
{
}

/* =================== Cached Types in debug_info ================= */

ббайт dwarf_classify_struct(бцел sflags)
{
    if (sflags & STRclass)
        return DW_TAG_class_type;

    if (sflags & STRunion)
        return DW_TAG_union_type;

    return DW_TAG_structure_type;
}

/* ======================= Тип Index ============================== */

бцел dwarf_typidx(тип *t)
{   бцел idx = 0;
    бцел nextidx;
    бцел keyidx;
    бцел pvoididx;
    бцел code;
    тип *tnext;
    тип *tbase;
    ткст0 p;

    static const ббайт[10] abbrevTypeBasic =
    [
        DW_TAG_base_type,
        0,                      // no children
        DW_AT_name,             DW_FORM_string,
        DW_AT_byte_size,        DW_FORM_data1,
        DW_AT_encoding,         DW_FORM_data1,
        0,                      0,
    ];
    static const ббайт[12] abbrevWchar =
    [
        DW_TAG_typedef,
        0,                      // no children
        DW_AT_name,             DW_FORM_string,
        DW_AT_type,             DW_FORM_ref4,
        DW_AT_decl_file,        DW_FORM_data1,
        DW_AT_decl_line,        DW_FORM_data2,
        0,                      0,
    ];
    static const ббайт[6] abbrevTypePointer =
    [
        DW_TAG_pointer_type,
        0,                      // no children
        DW_AT_type,             DW_FORM_ref4,
        0,                      0,
    ];
    static const ббайт[4] abbrevTypePointerVoid =
    [
        DW_TAG_pointer_type,
        0,                      // no children
        0,                      0,
    ];
    static const ббайт[6] abbrevTypeRef =
    [
        DW_TAG_reference_type,
        0,                      // no children
        DW_AT_type,             DW_FORM_ref4,
        0,                      0,
    ];
    static const ббайт[6] abbrevTypeConst =
    [
        DW_TAG_const_type,
        0,                      // no children
        DW_AT_type,             DW_FORM_ref4,
        0,                      0,
    ];
    static const ббайт[4] abbrevTypeConstVoid =
    [
        DW_TAG_const_type,
        0,                      // no children
        0,                      0,
    ];
    static const ббайт[6] abbrevTypeVolatile =
    [
        DW_TAG_volatile_type,
        0,                      // no children
        DW_AT_type,             DW_FORM_ref4,
        0,                      0,
    ];
    static const ббайт[4] abbrevTypeVolatileVoid =
    [
        DW_TAG_volatile_type,
        0,                      // no children
        0,                      0,
    ];

    if (!t)
        return 0;

    if (t.Tty & mTYconst)
    {   // We make a копируй of the тип to strip off the const qualifier and
        // recurse, and then add the const abbrev code. To avoid ending in a
        // loop if the тип references the const version of itself somehow,
        // we need to set TFforward here, because setting TFforward during
        // member generation of dwarf_typidx(tnext) has no effect on t itself.
        ushort old_flags = t.Tflags;
        t.Tflags |= TFforward;

        tnext = type_copy(t);
        tnext.Tcount++;
        tnext.Tty &= ~mTYconst;
        nextidx = dwarf_typidx(tnext);

        t.Tflags = old_flags;

        code = nextidx
            ? dwarf_abbrev_code(abbrevTypeConst.ptr, (abbrevTypeConst).sizeof)
            : dwarf_abbrev_code(abbrevTypeConstVoid.ptr, (abbrevTypeConstVoid).sizeof);
        goto Lcv;
    }

    if (t.Tty & mTYvolatile)
    {   tnext = type_copy(t);
        tnext.Tcount++;
        tnext.Tty &= ~mTYvolatile;
        nextidx = dwarf_typidx(tnext);
        code = nextidx
            ? dwarf_abbrev_code(abbrevTypeVolatile.ptr, (abbrevTypeVolatile).sizeof)
            : dwarf_abbrev_code(abbrevTypeVolatileVoid.ptr, (abbrevTypeVolatileVoid).sizeof);
    Lcv:
        idx = cast(бцел)debug_info.буф.size();
        debug_info.буф.writeuLEB128(code);    // abbreviation code
        if (nextidx)
            debug_info.буф.write32(nextidx);  // DW_AT_type
        goto Lret;
    }

    tym_t ty;
    ty = tybasic(t.Tty);
    if (!(t.Tnext && (ty == TYdarray || ty == TYdelegate)))
    {   // use cached basic тип if it's not TYdarray or TYdelegate
        idx = typidx_tab[ty];
        if (idx)
            return idx;
    }

    ббайт ate;
    ate = tyuns(t.Tty) ? DW_ATE_unsigned : DW_ATE_signed;

    static const ббайт[8] abbrevTypeStruct =
    [
        DW_TAG_structure_type,
        1,                      // children
        DW_AT_name,             DW_FORM_string,
        DW_AT_byte_size,        DW_FORM_data1,
        0,                      0,
    ];

    static const ббайт[10] abbrevTypeMember =
    [
        DW_TAG_member,
        0,                      // no children
        DW_AT_name,             DW_FORM_string,
        DW_AT_type,             DW_FORM_ref4,
        DW_AT_data_member_location, DW_FORM_block1,
        0,                      0,
    ];

    switch (tybasic(t.Tty))
    {
        Lnptr:
            nextidx = dwarf_typidx(t.Tnext);
            code = nextidx
                ? dwarf_abbrev_code(abbrevTypePointer.ptr, (abbrevTypePointer).sizeof)
                : dwarf_abbrev_code(abbrevTypePointerVoid.ptr, (abbrevTypePointerVoid).sizeof);
            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            if (nextidx)
                debug_info.буф.write32(nextidx);      // DW_AT_type
            break;

        case TYullong:
        case TYucent:
            if (!t.Tnext)
            {   p = (tybasic(t.Tty) == TYullong) ? "бцел long long" : "ucent";
                goto Lsigned;
            }

            /* It's really TYdarray, and Tnext is the
             * element тип
             */
            {
            бцел lenidx = I64 ? dwarf_typidx(tstypes[TYulong]) : dwarf_typidx(tstypes[TYuint]);

            {
                тип *tdata = type_alloc(TYnptr);
                tdata.Tnext = t.Tnext;
                t.Tnext.Tcount++;
                tdata.Tcount++;
                nextidx = dwarf_typidx(tdata);
                type_free(tdata);
            }

            code = dwarf_abbrev_code(abbrevTypeStruct.ptr, (abbrevTypeStruct).sizeof);
            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.пиши("_Массив_".ptr, 7);       // DW_AT_name
            if (tybasic(t.Tnext.Tty))
                debug_info.буф.writeString(tystring[tybasic(t.Tnext.Tty)]);
            else
                debug_info.буф.пишиБайт(0);
            debug_info.буф.пишиБайт(tysize(t.Tty)); // DW_AT_byte_size

            // length
            code = dwarf_abbrev_code(abbrevTypeMember.ptr, (abbrevTypeMember).sizeof);
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString("length");     // DW_AT_name
            debug_info.буф.write32(lenidx);           // DW_AT_type

            debug_info.буф.пишиБайт(2);              // DW_AT_data_member_location
            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
            debug_info.буф.пишиБайт(0);

            // ptr
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString("ptr");        // DW_AT_name
            debug_info.буф.write32(nextidx);          // DW_AT_type

            debug_info.буф.пишиБайт(2);              // DW_AT_data_member_location
            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
            debug_info.буф.пишиБайт(I64 ? 8 : 4);

            debug_info.буф.пишиБайт(0);              // no more children
            }
            break;

        case TYllong:
        case TYcent:
            if (!t.Tnext)
            {   p = (tybasic(t.Tty) == TYllong) ? "long long" : "cent";
                goto Lsigned;
            }
            /* It's really TYdelegate, and Tnext is the
             * function тип
             */
            {
                тип *tp = type_fake(TYnptr);
                tp.Tcount++;
                pvoididx = dwarf_typidx(tp);    // ук

                tp.Tnext = t.Tnext;           // fptr*
                tp.Tnext.Tcount++;
                nextidx = dwarf_typidx(tp);
                type_free(tp);
            }

            code = dwarf_abbrev_code(abbrevTypeStruct.ptr, (abbrevTypeStruct).sizeof);
            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString("_Delegate");  // DW_AT_name
            debug_info.буф.пишиБайт(tysize(t.Tty)); // DW_AT_byte_size

            // ctxptr
            code = dwarf_abbrev_code(abbrevTypeMember.ptr, (abbrevTypeMember).sizeof);
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString("ctxptr");     // DW_AT_name
            debug_info.буф.write32(pvoididx);         // DW_AT_type

            debug_info.буф.пишиБайт(2);              // DW_AT_data_member_location
            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
            debug_info.буф.пишиБайт(0);

            // funcptr
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString("funcptr");    // DW_AT_name
            debug_info.буф.write32(nextidx);          // DW_AT_type

            debug_info.буф.пишиБайт(2);              // DW_AT_data_member_location
            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
            debug_info.буф.пишиБайт(I64 ? 8 : 4);

            debug_info.буф.пишиБайт(0);              // no more children
            break;

        case TYnref:
        case TYref:
            nextidx = dwarf_typidx(t.Tnext);
            assert(nextidx);
            code = dwarf_abbrev_code(abbrevTypeRef.ptr, (abbrevTypeRef).sizeof);
            idx = cast(бцел)cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.write32(nextidx);          // DW_AT_type
            break;

        case TYnptr:
            if (!t.Tkey)
                goto Lnptr;

            /* It's really TYaarray, and Tnext is the
             * element тип, Tkey is the ключ тип
             */
            {
                тип *tp = type_fake(TYnptr);
                tp.Tcount++;
                pvoididx = dwarf_typidx(tp);    // ук
            }

            code = dwarf_abbrev_code(abbrevTypeStruct.ptr, (abbrevTypeStruct).sizeof);
            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.пиши("_AМассив_".ptr, 8);      // DW_AT_name
            if (tybasic(t.Tkey.Tty))
                p = tystring[tybasic(t.Tkey.Tty)];
            else
                p = "ключ";
            debug_info.буф.пиши(p, cast(бцел)strlen(p));

            debug_info.буф.пишиБайт('_');
            if (tybasic(t.Tnext.Tty))
                p = tystring[tybasic(t.Tnext.Tty)];
            else
                p = "значение";
            debug_info.буф.writeString(p);

            debug_info.буф.пишиБайт(tysize(t.Tty)); // DW_AT_byte_size

            // ptr
            code = dwarf_abbrev_code(abbrevTypeMember.ptr, (abbrevTypeMember).sizeof);
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString("ptr");        // DW_AT_name
            debug_info.буф.write32(pvoididx);         // DW_AT_type

            debug_info.буф.пишиБайт(2);              // DW_AT_data_member_location
            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
            debug_info.буф.пишиБайт(0);

            debug_info.буф.пишиБайт(0);              // no more children
            break;

        case TYvoid:        return 0;
        case TYбул:        p = "_Bool";         ate = DW_ATE_булean;       goto Lsigned;
        case TYchar:        p = "сим";          ate = (config.flags & CFGuchar) ? DW_ATE_unsigned_char : DW_ATE_signed_char;   goto Lsigned;
        case TYschar:       p = "signed сим";   ate = DW_ATE_signed_char;   goto Lsigned;
        case TYuchar:       p = "ббайт"; ate = DW_ATE_unsigned_char; goto Lsigned;
        case TYshort:       p = "short";                goto Lsigned;
        case TYushort:      p = "ushort";       goto Lsigned;
        case TYint:         p = "цел";                  goto Lsigned;
        case TYuint:        p = "бцел";             goto Lsigned;
        case TYlong:        p = "long";                 goto Lsigned;
        case TYulong:       p = "бцел long";        goto Lsigned;
        case TYdchar:       p = "dchar";                goto Lsigned;
        case TYfloat:       p = "float";        ate = DW_ATE_float;     goto Lsigned;
        case TYdouble_alias:
        case TYdouble:      p = "double";       ate = DW_ATE_float;     goto Lsigned;
        case TYldouble:     p = "long double";  ate = DW_ATE_float;     goto Lsigned;
        case TYifloat:      p = "imaginary float";       ate = DW_ATE_imaginary_float;  goto Lsigned;
        case TYidouble:     p = "imaginary double";      ate = DW_ATE_imaginary_float;  goto Lsigned;
        case TYildouble:    p = "imaginary long double"; ate = DW_ATE_imaginary_float;  goto Lsigned;
        case TYcfloat:      p = "complex float";         ate = DW_ATE_complex_float;    goto Lsigned;
        case TYcdouble:     p = "complex double";        ate = DW_ATE_complex_float;    goto Lsigned;
        case TYcldouble:    p = "complex long double";   ate = DW_ATE_complex_float;    goto Lsigned;
        Lsigned:
            code = dwarf_abbrev_code(abbrevTypeBasic.ptr, (abbrevTypeBasic).sizeof);
            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);        // abbreviation code
            debug_info.буф.writeString(p);            // DW_AT_name
            debug_info.буф.пишиБайт(tysize(t.Tty)); // DW_AT_byte_size
            debug_info.буф.пишиБайт(ate);            // DW_AT_encoding
            typidx_tab[ty] = idx;
            return idx;

        case TYnsfunc:
        case TYnpfunc:
        case TYjfunc:

        case TYnfunc:
        {
            /* The dwarf typidx for the function тип is completely determined by
             * the return тип typidx and the параметр typidx's. Thus, by
             * caching these, we can cache the function typidx.
             * Cache them in functypebuf[]
             */
            Outbuffer tmpbuf;
            nextidx = dwarf_typidx(t.Tnext);                   // function return тип
            tmpbuf.write32(nextidx);
            бцел парамы = 0;
            for (param_t *p2 = t.Tparamtypes; p2; p2 = p2.Pnext)
            {   парамы = 1;
                бцел paramidx = dwarf_typidx(p2.Ptype);
                //printf("1: paramidx = %d\n", paramidx);

                debug
                if (!paramidx) type_print(p2.Ptype);

                assert(paramidx);
                tmpbuf.write32(paramidx);
            }

            if (!functypebuf)
            {
                functypebuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
                assert(functypebuf);
            }
            бцел functypebufidx = cast(бцел)functypebuf.size();
            functypebuf.пиши(tmpbuf.буф, cast(бцел)tmpbuf.size());
            /* If it's in the cache already, return the existing typidx
             */
            if (!functype_table)
                functype_table = AApair.создай(&functypebuf.буф);
            бцел *pidx = cast(бцел *)functype_table.get(functypebufidx, cast(бцел)functypebuf.size());
            if (*pidx)
            {   // Reuse existing typidx
                functypebuf.устРазм(functypebufidx);
                return *pidx;
            }

            /* Not in the cache, создай a new typidx
             */
            Outbuffer abuf;             // for abbrev
            abuf.пишиБайт(DW_TAG_subroutine_type);
            if (парамы)
                abuf.пишиБайт(1);      // children
            else
                abuf.пишиБайт(0);      // no children
            abuf.пишиБайт(DW_AT_prototyped);   abuf.пишиБайт(DW_FORM_flag);
            if (nextidx != 0)           // Don't пиши DW_AT_type for проц
            {   abuf.пишиБайт(DW_AT_type);     abuf.пишиБайт(DW_FORM_ref4);
            }

            abuf.пишиБайт(0);                  abuf.пишиБайт(0);
            code = dwarf_abbrev_code(abuf.буф, abuf.size());

            бцел paramcode;
            if (парамы)
            {   abuf.сбрось();
                abuf.пишиБайт(DW_TAG_formal_parameter);
                abuf.пишиБайт(0);
                abuf.пишиБайт(DW_AT_type);     abuf.пишиБайт(DW_FORM_ref4);
                abuf.пишиБайт(0);              abuf.пишиБайт(0);
                paramcode = dwarf_abbrev_code(abuf.буф, abuf.size());
            }

            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);
            debug_info.буф.пишиБайт(1);              // DW_AT_prototyped
            if (nextidx)                        // if return тип is not проц
                debug_info.буф.write32(nextidx);      // DW_AT_type

            if (парамы)
            {   бцел *pparamidx = cast(бцел *)(functypebuf.буф + functypebufidx);
                //printf("2: functypebufidx = %x, pparamidx = %p, size = %x\n", functypebufidx, pparamidx, functypebuf.size());
                for (param_t *p2 = t.Tparamtypes; p2; p2 = p2.Pnext)
                {   debug_info.буф.writeuLEB128(paramcode);
                    //бцел x = dwarf_typidx(p2.Ptype);
                    бцел paramidx = *++pparamidx;
                    //printf("paramidx = %d\n", paramidx);
                    assert(paramidx);
                    debug_info.буф.write32(paramidx);        // DW_AT_type
                }
                debug_info.буф.пишиБайт(0);          // end параметр list
            }

            *pidx = idx;                        // remember it in the functype_table[] cache
            break;
        }

        case TYarray:
        {
            static const ббайт[6] abbrevTypeArray =
            [
                DW_TAG_array_type,
                1,                      // child (the subrange тип)
                DW_AT_type,             DW_FORM_ref4,
                0,                      0,
            ];
            static const ббайт[4] abbrevTypeArrayVoid =
            [
                DW_TAG_array_type,
                1,                      // child (the subrange тип)
                0,                      0,
            ];
            static const ббайт[8] abbrevTypeSubrange =
            [
                DW_TAG_subrange_type,
                0,                      // no children
                DW_AT_type,             DW_FORM_ref4,
                DW_AT_upper_bound,      DW_FORM_data4,
                0,                      0,
            ];
            static const ббайт[6] abbrevTypeSubrange2 =
            [
                DW_TAG_subrange_type,
                0,                      // no children
                DW_AT_type,             DW_FORM_ref4,
                0,                      0,
            ];
            бцел code2 = (t.Tflags & TFsizeunknown)
                ? dwarf_abbrev_code(abbrevTypeSubrange2.ptr, (abbrevTypeSubrange2).sizeof)
                : dwarf_abbrev_code(abbrevTypeSubrange.ptr, (abbrevTypeSubrange).sizeof);
            бцел idxbase = dwarf_typidx(tssize);
            nextidx = dwarf_typidx(t.Tnext);
            бцел code1 = nextidx ? dwarf_abbrev_code(abbrevTypeArray.ptr, (abbrevTypeArray).sizeof)
                                 : dwarf_abbrev_code(abbrevTypeArrayVoid.ptr, (abbrevTypeArrayVoid).sizeof);
            idx = cast(бцел)debug_info.буф.size();

            debug_info.буф.writeuLEB128(code1);       // DW_TAG_array_type
            if (nextidx)
                debug_info.буф.write32(nextidx);      // DW_AT_type

            debug_info.буф.writeuLEB128(code2);       // DW_TAG_subrange_type
            debug_info.буф.write32(idxbase);          // DW_AT_type
            if (!(t.Tflags & TFsizeunknown))
                debug_info.буф.write32(t.Tdim ? cast(бцел)t.Tdim - 1 : 0);    // DW_AT_upper_bound

            debug_info.буф.пишиБайт(0);              // no more children
            break;
        }

        // SIMD vector types
        case TYfloat16:
        case TYfloat8:
        case TYfloat4:   tbase = tstypes[TYfloat];  goto Lvector;
        case TYdouble8:
        case TYdouble4:
        case TYdouble2:  tbase = tstypes[TYdouble]; goto Lvector;
        case TYschar64:
        case TYschar32:
        case TYschar16:  tbase = tstypes[TYschar];  goto Lvector;
        case TYuchar64:
        case TYuchar32:
        case TYuchar16:  tbase = tstypes[TYuchar];  goto Lvector;
        case TYshort32:
        case TYshort16:
        case TYshort8:   tbase = tstypes[TYshort];  goto Lvector;
        case TYushort32:
        case TYushort16:
        case TYushort8:  tbase = tstypes[TYushort]; goto Lvector;
        case TYlong16:
        case TYlong8:
        case TYlong4:    tbase = tstypes[TYlong];   goto Lvector;
        case TYulong16:
        case TYulong8:
        case TYulong4:   tbase = tstypes[TYulong];  goto Lvector;
        case TYllong8:
        case TYllong4:
        case TYllong2:   tbase = tstypes[TYllong];  goto Lvector;
        case TYullong8:
        case TYullong4:
        case TYullong2:  tbase = tstypes[TYullong]; goto Lvector;
        Lvector:
        {
            static const ббайт[9] abbrevTypeМассив2 =
            [
                DW_TAG_array_type,
                1,                      // child (the subrange тип)
                (DW_AT_GNU_vector & 0x7F) | 0x80, DW_AT_GNU_vector >> 7,        DW_FORM_flag,
                DW_AT_type,             DW_FORM_ref4,
                0,                      0,
            ];
            static const ббайт[6] abbrevSubRange =
            [
                DW_TAG_subrange_type,
                0,                                // no children
                DW_AT_upper_bound, DW_FORM_data1, // length of vector
                0,                 0,
            ];

            бцел code2 = dwarf_abbrev_code(abbrevTypeМассив2.ptr, (abbrevTypeМассив2).sizeof);
            бцел idxbase = dwarf_typidx(tbase);

            idx = cast(бцел)debug_info.буф.size();

            debug_info.буф.writeuLEB128(code2);       // DW_TAG_array_type
            debug_info.буф.пишиБайт(1);              // DW_AT_GNU_vector
            debug_info.буф.write32(idxbase);          // DW_AT_type

            // vector length stored as subrange тип
            code2 = dwarf_abbrev_code(abbrevSubRange.ptr, (abbrevSubRange).sizeof);
            debug_info.буф.writeuLEB128(code2);        // DW_TAG_subrange_type
            ббайт dim = cast(ббайт)(tysize(t.Tty) / tysize(tbase.Tty));
            debug_info.буф.пишиБайт(dim - 1);        // DW_AT_upper_bound

            debug_info.буф.пишиБайт(0);              // no more children
            break;
        }

        case TYwchar_t:
        {
            бцел code3 = dwarf_abbrev_code(abbrevWchar.ptr, (abbrevWchar).sizeof);
            бцел typebase = dwarf_typidx(tstypes[TYint]);
            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code3);       // abbreviation code
            debug_info.буф.writeString("wchar_t");    // DW_AT_name
            debug_info.буф.write32(typebase);         // DW_AT_type
            debug_info.буф.пишиБайт(1);              // DW_AT_decl_file
            debug_info.буф.writeWord(1);              // DW_AT_decl_line
            typidx_tab[ty] = idx;
            break;
        }


        case TYstruct:
        {
            Classsym *s = t.Ttag;
            struct_t *st = s.Sstruct;

            if (s.Stypidx)
                return s.Stypidx;

             ббайт[8] abbrevTypeStruct0 =
            [
                DW_TAG_structure_type,
                0,                      // no children
                DW_AT_name,             DW_FORM_string,
                DW_AT_byte_size,        DW_FORM_data1,
                0,                      0,
            ];
             ббайт[8] abbrevTypeStruct1 =
            [
                DW_TAG_structure_type,
                0,                      // no children
                DW_AT_name,             DW_FORM_string,
                DW_AT_declaration,      DW_FORM_flag,
                0,                      0,
            ];

            if (t.Tflags & (TFsizeunknown | TFforward))
            {
                abbrevTypeStruct1[0] = dwarf_classify_struct(st.Sflags);
                code = dwarf_abbrev_code(abbrevTypeStruct1.ptr, (abbrevTypeStruct1).sizeof);
                idx = cast(бцел)debug_info.буф.size();
                debug_info.буф.writeuLEB128(code);
                debug_info.буф.writeString(s.Sident.ptr);        // DW_AT_name
                debug_info.буф.пишиБайт(1);                  // DW_AT_declaration
                break;                  // don't set Stypidx
            }

            Outbuffer fieldidx;

            // Count number of fields
            бцел nfields = 0;
            t.Tflags |= TFforward;
            foreach (sl; ListRange(st.Sfldlst))
            {
                Symbol *sf = list_symbol(sl);
                switch (sf.Sclass)
                {
                    case SCmember:
                        fieldidx.write32(dwarf_typidx(sf.Stype));
                        nfields++;
                        break;

                    default:
                        break;
                }
            }
            t.Tflags &= ~TFforward;
            if (nfields == 0)
            {
                abbrevTypeStruct0[0] = dwarf_classify_struct(st.Sflags);
                abbrevTypeStruct0[1] = 0;               // no children
                abbrevTypeStruct0[5] = DW_FORM_data1;   // DW_AT_byte_size
                code = dwarf_abbrev_code(abbrevTypeStruct0.ptr, (abbrevTypeStruct0).sizeof);
                idx = cast(бцел)debug_info.буф.size();
                debug_info.буф.writeuLEB128(code);
                debug_info.буф.writeString(s.Sident.ptr);        // DW_AT_name
                debug_info.буф.пишиБайт(0);                  // DW_AT_byte_size
            }
            else
            {
                Outbuffer abuf;         // for abbrev
                abuf.пишиБайт(dwarf_classify_struct(st.Sflags));
                abuf.пишиБайт(1);              // children
                abuf.пишиБайт(DW_AT_name);     abuf.пишиБайт(DW_FORM_string);
                abuf.пишиБайт(DW_AT_byte_size);

                т_мера sz = cast(бцел)st.Sstructsize;
                if (sz <= 0xFF)
                    abuf.пишиБайт(DW_FORM_data1);      // DW_AT_byte_size
                else if (sz <= 0xFFFF)
                    abuf.пишиБайт(DW_FORM_data2);      // DW_AT_byte_size
                else
                    abuf.пишиБайт(DW_FORM_data4);      // DW_AT_byte_size
                abuf.пишиБайт(0);              abuf.пишиБайт(0);

                code = dwarf_abbrev_code(abuf.буф, abuf.size());

                бцел membercode;
                abuf.сбрось();
                abuf.пишиБайт(DW_TAG_member);
                abuf.пишиБайт(0);              // no children
                abuf.пишиБайт(DW_AT_name);
                abuf.пишиБайт(DW_FORM_string);
                abuf.пишиБайт(DW_AT_type);
                abuf.пишиБайт(DW_FORM_ref4);
                abuf.пишиБайт(DW_AT_data_member_location);
                abuf.пишиБайт(DW_FORM_block1);
                abuf.пишиБайт(0);
                abuf.пишиБайт(0);
                membercode = dwarf_abbrev_code(abuf.буф, abuf.size());

                idx = cast(бцел)debug_info.буф.size();
                debug_info.буф.writeuLEB128(code);
                debug_info.буф.writeString(s.Sident.ptr);        // DW_AT_name
                if (sz <= 0xFF)
                    debug_info.буф.пишиБайт(cast(бцел)sz);     // DW_AT_byte_size
                else if (sz <= 0xFFFF)
                    debug_info.буф.writeWord(cast(бцел)sz);     // DW_AT_byte_size
                else
                    debug_info.буф.write32(cast(бцел)sz);       // DW_AT_byte_size

                s.Stypidx = idx;
                бцел n = 0;
                foreach (sl; ListRange(st.Sfldlst))
                {
                    Symbol *sf = list_symbol(sl);
                    т_мера soffset;

                    switch (sf.Sclass)
                    {
                        case SCmember:
                            debug_info.буф.writeuLEB128(membercode);
                            debug_info.буф.writeString(sf.Sident.ptr);
                            //debug_info.буф.write32(dwarf_typidx(sf.Stype));
                            бцел fi = (cast(бцел *)fieldidx.буф)[n];
                            debug_info.буф.write32(fi);
                            n++;
                            soffset = debug_info.буф.size();
                            debug_info.буф.пишиБайт(2);
                            debug_info.буф.пишиБайт(DW_OP_plus_uconst);
                            debug_info.буф.writeuLEB128(cast(бцел)sf.Smemoff);
                            debug_info.буф.буф[soffset] = cast(ббайт)(debug_info.буф.size() - soffset - 1);
                            break;

                        default:
                            break;
                    }
                }

                debug_info.буф.пишиБайт(0);          // no more children
            }
            s.Stypidx = idx;
            reset_symbuf.пиши(&s, (s).sizeof);
            return idx;                 // no need to cache it
        }

        case TYenum:
        {   static const ббайт[8] abbrevTypeEnum =
            [
                DW_TAG_enumeration_type,
                1,                      // child (the subrange тип)
                DW_AT_name,             DW_FORM_string,
                DW_AT_byte_size,        DW_FORM_data1,
                0,                      0,
            ];
            static const ббайт[8] abbrevTypeEnumMember =
            [
                DW_TAG_enumerator,
                0,                      // no children
                DW_AT_name,             DW_FORM_string,
                DW_AT_const_value,      DW_FORM_data1,
                0,                      0,
            ];

            Symbol *s = t.Ttag;
            enum_t *se = s.Senum;
            тип *tbase2 = s.Stype.Tnext;
            бцел sz = cast(бцел)type_size(tbase2);
            symlist_t sl;

            if (s.Stypidx)
                return s.Stypidx;

            if (se.SEflags & SENforward)
            {
                static const ббайт[8] abbrevTypeEnumForward =
                [
                    DW_TAG_enumeration_type,
                    0,                  // no children
                    DW_AT_name,         DW_FORM_string,
                    DW_AT_declaration,  DW_FORM_flag,
                    0,                  0,
                ];
                code = dwarf_abbrev_code(abbrevTypeEnumForward.ptr, abbrevTypeEnumForward.sizeof);
                idx = cast(бцел)debug_info.буф.size();
                debug_info.буф.writeuLEB128(code);
                debug_info.буф.writeString(s.Sident.ptr);        // DW_AT_name
                debug_info.буф.пишиБайт(1);                  // DW_AT_declaration
                break;                  // don't set Stypidx
            }

            Outbuffer abuf;             // for abbrev
            abuf.пиши(abbrevTypeEnum.ptr, abbrevTypeEnum.sizeof);
            code = dwarf_abbrev_code(abuf.буф, abuf.size());

            бцел membercode;
            abuf.сбрось();
            abuf.пишиБайт(DW_TAG_enumerator);
            abuf.пишиБайт(0);
            abuf.пишиБайт(DW_AT_name);
            abuf.пишиБайт(DW_FORM_string);
            abuf.пишиБайт(DW_AT_const_value);
            if (tyuns(tbase2.Tty))
                abuf.пишиБайт(DW_FORM_udata);
            else
                abuf.пишиБайт(DW_FORM_sdata);
            abuf.пишиБайт(0);
            abuf.пишиБайт(0);
            membercode = dwarf_abbrev_code(abuf.буф, abuf.size());

            idx = cast(бцел)debug_info.буф.size();
            debug_info.буф.writeuLEB128(code);
            debug_info.буф.writeString(s.Sident.ptr);    // DW_AT_name
            debug_info.буф.пишиБайт(sz);             // DW_AT_byte_size

            foreach (sl2; ListRange(s.Senum.SEenumlist))
            {
                Symbol *sf = cast(Symbol *)list_ptr(sl2);
                const значение = cast(бцел)el_tolongt(sf.Svalue);

                debug_info.буф.writeuLEB128(membercode);
                debug_info.буф.writeString(sf.Sident.ptr);
                if (tyuns(tbase2.Tty))
                    debug_info.буф.writeuLEB128(значение);
                else
                    debug_info.буф.writesLEB128(значение);
            }

            debug_info.буф.пишиБайт(0);              // no more children

            s.Stypidx = idx;
            reset_symbuf.пиши(&s, s.sizeof);
            return idx;                 // no need to cache it
        }

        default:
            return 0;
    }
Lret:
    /* If debug_info.буф.буф[idx .. size()] is already in debug_info.буф,
     * discard this one and use the previous one.
     */
    if (!type_table)
        /* бцел[Adata] type_table;
         * where the table values are the тип indices
         */
        type_table = AApair.создай(&debug_info.буф.буф);

    бцел *pidx = type_table.get(idx, cast(бцел)debug_info.буф.size());
    if (!*pidx)                 // if no idx assigned yet
    {
        *pidx = idx;            // assign newly computed idx
    }
    else
    {   // Reuse existing code
        debug_info.буф.устРазм(idx);  // discard current
        idx = *pidx;
    }
    return idx;
}

/* ======================= Abbreviation Codes ====================== */


бцел dwarf_abbrev_code(ббайт* данные, т_мера члобайт)
{
    if (!abbrev_table)
        /* бцел[Adata] abbrev_table;
         * where the table values are the abbreviation codes.
         */
        abbrev_table = AApair.создай(&debug_abbrev.буф.буф);

    /* Write new entry into debug_abbrev.буф
     */

    бцел idx = cast(бцел)debug_abbrev.буф.size();
    abbrevcode++;
    debug_abbrev.буф.writeuLEB128(abbrevcode);
    т_мера start = debug_abbrev.буф.size();
    debug_abbrev.буф.пиши(данные, cast(бцел)члобайт);
    т_мера end = debug_abbrev.буф.size();

    /* If debug_abbrev.буф.буф[idx .. size()] is already in debug_abbrev.буф,
     * discard this one and use the previous one.
     */

    бцел *pcode = abbrev_table.get(cast(бцел)start, cast(бцел)end);
    if (!*pcode)                // if no code assigned yet
    {
        *pcode = abbrevcode;    // assign newly computed code
    }
    else
    {   // Reuse existing code
        debug_abbrev.буф.устРазм(idx);        // discard current
        abbrevcode--;
    }
    return *pcode;
}

/*****************************************************
 * Write Dwarf-style exception tables.
 * Параметры:
 *      sfunc = function to generate tables for
 *      startoffset = size of function prolog
 *      retoffset = смещение from start of function to epilog
 */
проц dwarf_except_gentables(Funcsym *sfunc, бцел startoffset, бцел retoffset)
{
    if (!doUnwindEhFrame())
        return;

    цел seg = dwarf_except_table_alloc(sfunc);
    Outbuffer *буф = SegData[seg].SDbuf;
    буф.резервируй(100);

static if (ELFOBJ)
    sfunc.Sfunc.LSDAoffset = cast(бцел)буф.size();

static if (MACHOBJ)
{
    сим[16 + (except_table_num).sizeof * 3 + 1] имя = проц;
    sprintf(имя.ptr, "GCC_except_table%d", ++except_table_num);
    тип *t = tspvoid;
    t.Tcount++;
    type_setmangle(&t, mTYman_sys);         // no leading '_' for mangled имя
    Symbol *s = symbol_name(имя.ptr, SCstatic, t);
    Obj.pubdef(seg, s, cast(бцел)буф.size());
    symbol_keep(s);

    sfunc.Sfunc.LSDAsym = s;
}
    genDwarfEh(sfunc, seg, буф, (usednteh & EHcleanup) != 0, startoffset, retoffset);
}

}
else
{
/*extern (C++):*/

проц dwarf_CFA_set_loc(бцел location) { }
проц dwarf_CFA_set_reg_offset(цел reg, цел смещение) { }
проц dwarf_CFA_offset(цел reg, цел смещение) { }
проц dwarf_except_gentables(Funcsym *sfunc, бцел startoffset, бцел retoffset) { }
}

}
