/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/code.d, backend/_code.d)
 */

module drc.backend.code;

// Online documentation: https://dlang.org/phobos/dmd_backend_code.html

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code_x86;
import drc.backend.codebuilder : CodeBuilder;
import drc.backend.el : elem;
import drc.backend.oper : OPMAX;
import drc.backend.outbuf;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/


alias drc.backend.cc.Symbol Symbol;
alias drc.backend.ty.tym_t tym_t;

alias цел segidx_t;           // index into SegData[]

/**********************************
 * Code данные тип
 */

struct _Declaration;
struct _LabelDsymbol;

union evc
{
    targ_int    Vint;           /// also используется for tmp numbers (FLtmp)
    targ_uns    Vuns;
    targ_long   Vlong;
    targ_llong  Vllong;
    targ_т_мера Vт_мера;
    struct
    {
        targ_т_мера Vpointer;
        цел Vseg;               /// segment the pointer is in
    }
    Srcpos      Vsrcpos;        /// source position for OPlinnum
    elem       *Vtor;           /// OPctor/OPdtor elem
    block      *Vswitch;        /// when FLswitch and we have a switch table
    code       *Vcode;          /// when code is target of a jump (FLcode)
    block      *Vblock;         /// when block " (FLblock)
    struct
    {
        targ_т_мера Voffset;    /// смещение from symbol
        Symbol  *Vsym;          /// pointer to symbol table (FLfunc,FLextern)
    }

    struct
    {
        targ_т_мера Vdoffset;   /// смещение from symbol
        _Declaration *Vdsym;    /// pointer to D symbol table
    }

    struct
    {
        targ_т_мера Vloffset;   /// смещение from symbol
        _LabelDsymbol *Vlsym;   /// pointer to D Label
    }

    struct
    {
        т_мера len;
        сим *bytes;
    }                           // asm узел (FLasm)
}

/********************** PUBLIC FUNCTIONS *******************/

code *code_calloc();
проц code_free(code *);
проц code_term();

code *code_next(code *c) { return c.следщ; }

code *code_chunk_alloc();
extern  code *code_list;

code *code_malloc()
{
    //printf("code %d\n", sizeof(code));
    code *c = code_list ? code_list : code_chunk_alloc();
    code_list = code_next(c);
    //printf("code_malloc: %p\n",c);
    return c;
}

extern  con_t regcon;

/************************************
 * Register save state.
 */

struct REGSAVE
{
    targ_т_мера off;            // смещение on stack
    бцел top;                   // high water mark
    бцел idx;                   // current number in use
    цел alignment;              // 8 or 16

  
    проц сбрось() { off = 0; top = 0; idx = 0; alignment = _tysize[TYnptr]/*REGSIZE*/; }
    проц save(ref CodeBuilder cdb, reg_t reg, бцел *pidx) { REGSAVE_save(this, cdb, reg, *pidx); }
    проц restore(ref CodeBuilder cdb, reg_t reg, бцел idx) { REGSAVE_restore(this, cdb, reg, idx); }
}

проц REGSAVE_save(ref REGSAVE regsave, ref CodeBuilder cdb, reg_t reg, out бцел idx);
проц REGSAVE_restore(ref REGSAVE regsave, ref CodeBuilder cdb, reg_t reg, бцел idx);

extern  REGSAVE regsave;

/************************************
 * Local sections on the stack
 */
struct LocalSection
{
    targ_т_мера смещение;         // смещение of section from frame pointer
    targ_т_мера size;           // size of section
    цел alignment;              // alignment size

  
    проц init()                 // initialize
    {   смещение = 0;
        size = 0;
        alignment = 0;
    }
}

/*******************************
 * As we generate code, collect information about
 * what parts of NT exception handling we need.
 */

extern  бцел usednteh;

enum
{
    NTEH_try        = 1,      // используется _try инструкция
    NTEH_except     = 2,      // используется _except инструкция
    NTEHexcspec     = 4,      // had C++ exception specification
    NTEHcleanup     = 8,      // destructors need to be called
    NTEHtry         = 0x10,   // had C++ try инструкция
    NTEHcpp         = (NTEHexcspec | NTEHcleanup | NTEHtry),
    EHcleanup       = 0x20,   // has destructors in the 'code' instructions
    EHtry           = 0x40,   // has BCtry or BC_try blocks
    NTEHjmonitor    = 0x80,   // uses Mars monitor
    NTEHpassthru    = 0x100,
}

/********************** Code Generator State ***************/

struct CGstate
{
    цел stackclean;     // if != 0, then clean the stack after function call

    LocalSection funcarg;       // where function arguments are placed
    targ_т_мера funcargtos;     // current high water уровень of arguments being moved onto
                                // the funcarg section. It is filled from top to bottom,
                                // as if they were 'pushed' on the stack.
                                // Special case: if funcargtos==~0, then no
                                // arguments are there.
    бул accessedTLS;           // set if accessed Thread Local Storage (TLS)
}

// nteh.c
проц nteh_prolog(ref CodeBuilder cdb);
проц nteh_epilog(ref CodeBuilder cdb);
проц nteh_usevars();
проц nteh_filltables();
проц nteh_gentables(Symbol *sfunc);
проц nteh_setsp(ref CodeBuilder cdb, opcode_t op);
проц nteh_filter(ref CodeBuilder cdb, block *b);
проц nteh_framehandler(Symbol *, Symbol *);
проц nteh_gensindex(ref CodeBuilder, цел);
const GENSINDEXSIZE = 7;
проц nteh_monitor_prolog(ref CodeBuilder cdb,Symbol *shandle);
проц nteh_monitor_epilog(ref CodeBuilder cdb,regm_t retregs);
code *nteh_patchindex(code* c, цел index);
проц nteh_unwind(ref CodeBuilder cdb,regm_t retregs,бцел index);

// cgen.c
code *code_last(code *c);
проц code_orflag(code *c,бцел флаг);
проц code_orrex(code *c,бцел rex);
code *setOpcode(code *c, code *cs, opcode_t op);
code *cat(code *c1, code *c2);
code *gen (code *c , code *cs );
code *gen1 (code *c , opcode_t op );
code *gen2 (code *c , opcode_t op , бцел rm );
code *gen2sib(code *c,opcode_t op,бцел rm,бцел sib);
code *genc2 (code *c , opcode_t op , бцел rm , targ_т_мера EV2 );
code *genc (code *c , opcode_t op , бцел rm , бцел FL1 , targ_т_мера EV1 , бцел FL2 , targ_т_мера EV2 );
code *genlinnum(code *,Srcpos);
проц cgen_prelinnum(code **pc,Srcpos srcpos);
code *gennop(code *);
проц gencodelem(ref CodeBuilder cdb,elem *e,regm_t *pretregs,бул constflag);
бул reghasvalue (regm_t regm , targ_т_мера значение , reg_t *preg );
проц regwithvalue(ref CodeBuilder cdb, regm_t regm, targ_т_мера значение, reg_t *preg, regm_t flags);

// cgreg.c
проц cgreg_init();
проц cgreg_term();
проц cgreg_reset();
проц cgreg_used(бцел bi,regm_t используется);
проц cgreg_spillreg_prolog(block *b,Symbol *s,ref CodeBuilder cdbstore,ref CodeBuilder cdbload);
проц cgreg_spillreg_epilog(block *b,Symbol *s,ref CodeBuilder cdbstore,ref CodeBuilder cdbload);
цел cgreg_assign(Symbol *retsym);
проц cgreg_unregister(regm_t conflict);

// cgsched.c
проц cgsched_block(block *b);

alias  бцел IDXSTR;
alias  бцел IDXSEC;
alias  бцел IDXSYM;

struct seg_data
{
    segidx_t             SDseg;         // index into SegData[]
    targ_т_мера          SDoffset;      // starting смещение for данные
    цел                  SDalignment;   // power of 2

    version (Windows) // OMFOBJ
    {
        бул isfarseg;
        цел segidx;                     // internal объект файл segment number
        цел lnameidx;                   // lname idx of segment имя
        цел classidx;                   // lname idx of class имя
        бцел attr;                      // segment attribute
        targ_т_мера origsize;           // original size
        цел seek;                       // seek position in output файл
        ук ledata;                   // (Ledatarec) current one we're filling in
    }

    //ELFOBJ || MACHOBJ
    IDXSEC           SDshtidx;          // section header table index
    Outbuffer       *SDbuf;             // буфер to hold данные
    Outbuffer       *SDrel;             // буфер to hold relocation info

    //ELFOBJ
    IDXSYM           SDsymidx;          // each section is in the symbol table
    IDXSEC           SDrelidx;          // section header for relocation info
    targ_т_мера      SDrelmaxoff;       // maximum смещение encountered
    цел              SDrelindex;        // maximum смещение encountered
    цел              SDrelcnt;          // number of relocations added
    IDXSEC           SDshtidxout;       // final section header table index
    Symbol          *SDsym;             // if !=NULL, comdat symbol
    segidx_t         SDassocseg;        // for COMDATs, if !=0, this is the "associated" segment

    бцел             SDaranges_offset;  // if !=0, смещение in .debug_aranges

    бцел             SDlinnum_count;
    бцел             SDlinnum_max;
    linnum_data     *SDlinnum_data;     // массив of line number / смещение данные

  
    version (Windows)
        цел isCode() { return seg_data_isCode(this); }
    version (OSX)
        цел isCode() { return seg_data_isCode(this); }
}

extern цел seg_data_isCode(ref seg_data sd);

struct linnum_data
{
    сим *имяф;
    бцел filenumber;        // corresponding файл number for DW_LNS_set_file

    бцел linoff_count;
    бцел linoff_max;
    бцел[2]* linoff;        // [0] = line number, [1] = смещение
}

extern  seg_data **SegData;

targ_т_мера Offset(цел seg) { return SegData[seg].SDoffset; }
targ_т_мера Doffset() { return Offset(DATA); }
targ_т_мера CDoffset() { return Offset(CDATA); }

/**************************************************/

/* Allocate registers to function parameters
 */

struct FuncParamRegs
{
    //this(tym_t tyf);
    static FuncParamRegs создай(tym_t tyf) { return FuncParamRegs_create(tyf); }

    цел alloc(тип *t, tym_t ty, ббайт *reg1, ббайт *reg2)
    { return FuncParamRegs_alloc(this, t, ty, reg1, reg2); }

  private:
  public: // for the moment
    tym_t tyf;                  // тип of function
    цел i;                      // ith параметр
    цел regcnt;                 // how many general purpose registers are allocated
    цел xmmcnt;                 // how many fp registers are allocated
    бцел numintegerregs;        // number of gp registers that can be allocated
    бцел numfloatregs;          // number of fp registers that can be allocated
    ббайт* argregs;      // map to gp register
    ббайт* floatregs;    // map to fp register
}

extern FuncParamRegs FuncParamRegs_create(tym_t tyf);
extern цел FuncParamRegs_alloc(ref FuncParamRegs fpr, тип *t, tym_t ty, reg_t *preg1, reg_t *preg2);

extern 
{
    regm_t msavereg,mfuncreg,allregs;

    цел BPRM;
    regm_t FLOATREGS;
    regm_t FLOATREGS2;
    regm_t DOUBLEREGS;
    //const сим datafl[],stackfl[],segfl[],flinsymtab[];
    сим needframe,gotref;
    targ_т_мера localsize,
        funcoffset,
        framehandleroffset;
    segidx_t cseg;
    цел STACKALIGN;
    цел TARGET_STACKALIGN;
    LocalSection Para;
    LocalSection Fast;
    LocalSection Auto;
    LocalSection EEStack;
    LocalSection Alloca;
}

/* cgcod.c */
extern  цел pass;
enum
{
    PASSinitial,     // initial pass through code generator
    PASSreg,         // register assignment pass
    PASSfinal,       // final pass
}

extern  цел dfoidx;
extern  бул floatreg;
extern  targ_т_мера prolog_allocoffset;
extern  targ_т_мера startoffset;
extern  targ_т_мера retoffset;
extern  targ_т_мера retsize;
extern  бцел stackpush;
extern  цел stackchanged;
extern  цел refparam;
extern  цел reflocal;
extern  бул anyiasm;
extern  сим calledafunc;
extern  бул calledFinally;

проц stackoffsets(цел);
проц codgen(Symbol *);

debug
{
    reg_t findreg(regm_t regm , цел line, ткст0 файл);
    extern (D) reg_t findreg(regm_t regm , цел line = __LINE__, ткст файл = __FILE__)
    { return findreg(regm, line, файл.ptr); }
}
else
{
    reg_t findreg(regm_t regm);
}

reg_t findregmsw(бцел regm) { return findreg(regm & mMSW); }
reg_t findreglsw(бцел regm) { return findreg(regm & (mLSW | mBP)); }
проц freenode(elem *e);
цел isregvar(elem *e, regm_t *pregm, reg_t *preg);
проц allocreg(ref CodeBuilder cdb, regm_t *pretregs, reg_t *preg, tym_t tym, цел line, ткст0 файл);
проц allocreg(ref CodeBuilder cdb, regm_t *pretregs, reg_t *preg, tym_t tym);
regm_t lpadregs();
проц useregs (regm_t regm);
проц getregs(ref CodeBuilder cdb, regm_t r);
проц getregsNoSave(regm_t r);
проц getregs_imm(ref CodeBuilder cdb, regm_t r);
проц cse_flush(ref CodeBuilder, цел);
бул cse_simple(code *c, elem *e);
бул cssave (elem *e , regm_t regm , бцел opsflag );
бул evalinregister(elem *e);
regm_t getscratch();
проц codelem(ref CodeBuilder cdb, elem *e, regm_t *pretregs, бцел constflag);
проц scodelem(ref CodeBuilder cdb, elem *e, regm_t *pretregs, regm_t keepmsk, бул constflag);
ткст0 regm_str(regm_t rm);
цел numbitsset(regm_t);

/* cdxxx.c: functions that go into cdxxx[] table */
проц cdabs(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdaddass(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdasm(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdbscan(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdbswap(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdbt(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdbtst(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdbyteint(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdcmp(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdcmpxchg(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdcnvt(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdcom(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdcomma(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdcond(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdconvt87(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdctor(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cddctor(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdddtor(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cddtor(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdeq(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cderr(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdfar16(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdframeptr(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdfunc(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdgot(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdhalt(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdind(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdinfo(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdlngsht(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdloglog(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmark(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmemcmp(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmemcpy(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmemset(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmsw(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmul(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdmulass(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdneg(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdnot(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdorth(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdpair(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdpopcnt(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdport(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdpost(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdprefetch(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdrelconst(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdrndtol(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdscale(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdsetjmp(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdshass(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdshift(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdshtlng(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdstrcmp(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdstrcpy(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdstreq(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdstrlen(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdstrthis(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdvecfill(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdvecsto(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdvector(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц cdvoid(ref CodeBuilder cdb, elem* e, regm_t* pretregs);
проц loaddata(ref CodeBuilder cdb, elem* e, regm_t* pretregs);

/* cod1.c */
extern  цел clib_inited;

бул regParamInPreg(Symbol* s);
цел isscaledindex(elem *);
цел ssindex(цел op,targ_uns product);
проц buildEA(code *c,цел base,цел index,цел scale,targ_т_мера disp);
бцел buildModregrm(цел mod, цел reg, цел rm);
проц andregcon (con_t *pregconsave);
проц genEEcode();
проц docommas(ref CodeBuilder cdb,elem **pe);
бцел gensaverestore(regm_t, ref CodeBuilder cdbsave, ref CodeBuilder cdbrestore);
проц genstackclean(ref CodeBuilder cdb,бцел numpara,regm_t keepmsk);
проц logexp(ref CodeBuilder cdb, elem *e, цел jcond, бцел fltarg, code *targ);
бцел getaddrmode(regm_t idxregs);
проц setaddrmode(code *c, regm_t idxregs);
проц fltregs(ref CodeBuilder cdb, code *pcs, tym_t tym);
проц tstрезультат(ref CodeBuilder cdb, regm_t regm, tym_t tym, бцел saveflag);
проц fixрезультат(ref CodeBuilder cdb, elem *e, regm_t retregs, regm_t *pretregs);
проц callclib(ref CodeBuilder cdb, elem *e, бцел clib, regm_t *pretregs, regm_t keepmask);
проц pushParams(ref CodeBuilder cdb,elem *, бцел, tym_t tyf);
проц offsetinreg(ref CodeBuilder cdb, elem *e, regm_t *pretregs);

/* cod2.c */
бул movOnly( elem *e);
regm_t idxregm( code *c);
проц opdouble(ref CodeBuilder cdb, elem *e, regm_t *pretregs, бцел clib);
проц WRcodlst(code *c);
проц getoffset(ref CodeBuilder cdb, elem *e, reg_t reg);

/* cod3.c */

цел cod3_EA(code *c);
regm_t cod3_useBP();
проц cod3_initregs();
проц cod3_setdefault();
проц cod3_set32();
проц cod3_set64();
проц cod3_align_bytes(цел seg, т_мера члобайт);
проц cod3_align(цел seg);
проц cod3_buildmodulector(Outbuffer* буф, цел codeOffset, цел refOffset);
проц cod3_stackadj(ref CodeBuilder cdb, цел члобайт);
проц cod3_stackalign(ref CodeBuilder cdb, цел члобайт);
regm_t regmask(tym_t tym, tym_t tyf);
проц cgreg_dst_regs(reg_t* dst_integer_reg, reg_t* dst_float_reg);
проц cgreg_set_priorities(tym_t ty, reg_t** pseq, reg_t** pseqmsw);
проц outblkexitcode(ref CodeBuilder cdb, block *bl, ref цел anyspill, ткст0 sflsave, Symbol** retsym, regm_t mfuncregsave );
проц outjmptab(block *b);
проц outswitab(block *b);
цел jmpopcode(elem *e);
проц cod3_ptrchk(ref CodeBuilder cdb,code *pcs,regm_t keepmsk);
проц genregs(ref CodeBuilder cdb, opcode_t op, бцел dstreg, бцел srcreg);
проц gentstreg(ref CodeBuilder cdb, бцел reg);
проц genpush(ref CodeBuilder cdb, reg_t reg);
проц genpop(ref CodeBuilder cdb, reg_t reg);
проц gen_storecse(ref CodeBuilder cdb, tym_t tym, reg_t reg, т_мера slot);
проц gen_testcse(ref CodeBuilder cdb, tym_t tym, бцел sz, т_мера i);
проц gen_loadcse(ref CodeBuilder cdb, tym_t tym, reg_t reg, т_мера slot);
code *genmovreg(бцел to, бцел from);
проц genmovreg(ref CodeBuilder cdb, бцел to, бцел from);
проц genmovreg(ref CodeBuilder cdb, бцел to, бцел from, tym_t tym);
проц genmulimm(ref CodeBuilder cdb,бцел r1,бцел r2,targ_int imm);
проц genshift(ref CodeBuilder cdb);
проц movregconst(ref CodeBuilder cdb,reg_t reg,targ_т_мера значение,regm_t flags);
проц genjmp(ref CodeBuilder cdb, opcode_t op, бцел fltarg, block *targ);
проц prolog(ref CodeBuilder cdb);
проц epilog (block *b);
проц gen_spill_reg(ref CodeBuilder cdb, Symbol *s, бул toreg);
проц load_localgot(ref CodeBuilder cdb);
targ_т_мера cod3_spoff();
проц makeitextern (Symbol *s );
проц fltused();
цел branch(block *bl, цел флаг);
проц cod3_adjSymOffsets();
проц assignaddr(block *bl);
проц assignaddrc(code *c);
targ_т_мера cod3_bpoffset(Symbol *s);
проц pinholeopt (code *c , block *bn );
проц simplify_code(code *c);
проц jmpaddr (code *c);
цел code_match(code *c1,code *c2);
бцел calcblksize (code *c);
бцел calccodsize(code *c);
бцел codout(цел seg, code *c);
т_мера addtofixlist(Symbol *s , targ_т_мера soffset , цел seg , targ_т_мера val , цел flags );
проц searchfixlist(Symbol *s) {}
проц outfixlist();
проц code_hydrate(code **pc);
проц code_dehydrate(code **pc);

extern 
{
    цел hasframe;            /* !=0 if this function has a stack frame */
    бул enforcealign;       /* enforced stack alignment */
    targ_т_мера spoff;
    targ_т_мера Foff;        // BP смещение of floating register
    targ_т_мера CSoff;       // смещение of common sub Выражения
    targ_т_мера NDPoff;      // смещение of saved 8087 registers
    targ_т_мера pushoff;     // смещение of saved registers
    бул pushoffuse;         // using pushoff
    цел BPoff;               // смещение from BP
    цел EBPtoESP;            // add to EBP смещение to get ESP смещение
}

проц prolog_ifunc(ref CodeBuilder cdb, tym_t* tyf);
проц prolog_ifunc2(ref CodeBuilder cdb, tym_t tyf, tym_t tym, бул pushds);
проц prolog_16bit_windows_farfunc(ref CodeBuilder cdb, tym_t* tyf, бул* pushds);
проц prolog_frame(ref CodeBuilder cdb, бцел farfunc, бцел* xlocalsize, бул* enter, цел* cfa_offset);
проц prolog_frameadj(ref CodeBuilder cdb, tym_t tyf, бцел xlocalsize, бул enter, бул* pushalloc);
проц prolog_frameadj2(ref CodeBuilder cdb, tym_t tyf, бцел xlocalsize, бул* pushalloc);
проц prolog_setupalloca(ref CodeBuilder cdb);
проц prolog_saveregs(ref CodeBuilder cdb, regm_t topush, цел cfa_offset);
проц prolog_stackalign(ref CodeBuilder cdb);
проц prolog_trace(ref CodeBuilder cdb, бул farfunc, бцел* regsaved);
проц prolog_gen_win64_varargs(ref CodeBuilder cdb);
проц prolog_genvarargs(ref CodeBuilder cdb, Symbol* sv, regm_t namedargs);
проц prolog_loadparams(ref CodeBuilder cdb, tym_t tyf, бул pushalloc, out regm_t namedargs);

/* cod4.c */
extern 
{
const reg_t[4] dblreg;
цел cdcmp_flag;
}

цел doinreg(Symbol *s, elem *e);
проц modEA(ref CodeBuilder cdb, code *c);
проц longcmp(ref CodeBuilder,elem *,бул,бцел,code *);

/* cod5.c */
проц cod5_prol_epi();
проц cod5_noprol();

/* cgxmm.c */
бул isXMMstore(opcode_t op);
проц orthxmm(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц xmmeq(ref CodeBuilder cdb, elem *e, opcode_t op, elem *e1, elem *e2, regm_t *pretregs);
проц xmmcnvt(ref CodeBuilder cdb,elem *e,regm_t *pretregs);
проц xmmopass(ref CodeBuilder cdb,elem *e, regm_t *pretregs);
проц xmmpost(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц xmmneg(ref CodeBuilder cdb,elem *e, regm_t *pretregs);
бцел xmmload(tym_t tym, бул aligned = да);
бцел xmmstore(tym_t tym, бул aligned = да);
бул xmmIsAligned(elem *e);
проц checkSetVex3(code *c);
проц checkSetVex(code *c, tym_t ty);

/* cg87.c */
проц note87(elem *e, бцел смещение, цел i);
проц pop87(цел, сим*);
проц pop87();
проц push87(ref CodeBuilder cdb);
проц save87(ref CodeBuilder cdb);
проц save87regs(ref CodeBuilder cdb, бцел n);
проц gensaverestore87(regm_t, ref CodeBuilder cdbsave, ref CodeBuilder cdbrestore);
//code *genfltreg(code *c,opcode_t opcode,бцел reg,targ_т_мера смещение);
проц genfwait(ref CodeBuilder cdb);
проц comsub87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц fixрезультат87(ref CodeBuilder cdb, elem *e, regm_t retregs, regm_t *pretregs);
проц fixрезультат_complex87(ref CodeBuilder cdb,elem *e,regm_t retregs,regm_t *pretregs);
проц orth87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц load87(ref CodeBuilder cdb, elem *e, бцел eoffset, regm_t *pretregs, elem *eleft, цел op);
цел cmporder87 (elem *e );
проц eq87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц complex_eq87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц opass87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц cdnegass87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц post87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц cnvt87(ref CodeBuilder cdb, elem *e , regm_t *pretregs );
проц neg87(ref CodeBuilder cdb, elem *e , regm_t *pretregs);
проц neg_complex87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц cdind87(ref CodeBuilder cdb,elem *e,regm_t *pretregs);
проц cload87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц cdd_u64(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц cdd_u32(ref CodeBuilder cdb, elem *e, regm_t *pretregs);
проц loadPair87(ref CodeBuilder cdb, elem *e, regm_t *pretregs);

/* iasm.c */
//проц iasm_term();
regm_t iasm_regs(block *bp);


/**********************************
 * Set значение in regimmed for reg.
 * NOTE: For 16 bit generator, this is always a (targ_short) sign-extended
 *      значение.
 */

проц regimmed_set(цел reg, targ_т_мера e)
{
    regcon.immed.значение[reg] = e;
    regcon.immed.mval |= 1 << (reg);
    //printf("regimmed_set %s %d\n", regm_str(1 << reg), cast(цел)e);
}





