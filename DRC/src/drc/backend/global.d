/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1984-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/глоб2.d, backend/глоб2.d)
 */
module drc.backend.глоб2;

// Online documentation: https://dlang.org/phobos/dmd_backend_global.html

/*extern (C++):*/
/*:*/


import cidrus;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.cc : Symbol, block, Classsym, Blockx;
import drc.backend.code_x86 : code;
import drc.backend.code;
import drc.backend.dlist;
import drc.backend.el;
import drc.backend.el : elem;
import drc.backend.mem;
import drc.backend.тип;
//import drc.backend.obj;

import drc.backend.barray;

alias drc.backend.ty.tym_t tym_t;

extern 
{
    сим debuga;            // cg - watch assignaddr()
    сим debugb;            // watch block optimization
    сим debugc;            // watch code generated
    сим debugd;            // watch debug information generated
    сим debuge;            // dump eh info
    сим debugf;            // trees after dooptim
    сим debugg;            // trees for code generator
    сим debugo;            // watch optimizer
    сим debugr;            // watch register allocation
    сим debugs;            // watch common subexp eliminator
    сим debugt;            // do test points
    сим debugu;
    сим debugw;            // watch progress
    сим debugx;            // suppress predefined CPP stuff
    сим debugy;            // watch output to il буфер
}

const CR = '\r';             // Used because the MPW version of the compiler warps
const LF = '\n';             // \n into \r and \r into \n.  The translator version
                            // does not and this causes problems with the compilation
                            // with the translator
const CR_STR = "\r";
const LF_STR = "\n";

extern 
{
    const бцел[32] mask;            // bit masks
    const бцел[32] maskl;           // bit masks

    ткст0 argv0;
    ткст0 finname, foutname, foutdir;

    сим OPTIMIZER,PARSER;
    symtab_t globsym;

//    Config config;                  // precompiled part of configuration
    сим[SCMAX] sytab;

    extern (C) /*volatile*/ цел controlc_saw;    // a control C was seen
    бцел maxblks;                   // массив max for all block stuff
    бцел numblks;                   // number of basic blocks (if optimized)
    block* startblock;              // beginning block of function

    Barray!(block*) dfo;            // массив of depth first order

    block* curblock;                // current block being читай in
    block* block_last;

    цел errcnt;
    regm_t fregsaved;

    tym_t pointertype;              // default данные pointer тип

    // cg.c
    Symbol* localgot;
    Symbol* tls_get_addr_sym;
}

version (Dinrus)
     Configv configv;                // non-ph part of configuration
else
    extern  Configv configv;                // non-ph part of configuration

// iasm.c
Symbol *asm_define_label(ткст0 ид);

// cpp.c
version (SCPP)
    ткст0 cpp_mangle(Symbol* s);
else version (Dinrus)
    ткст0 cpp_mangle(Symbol* s);
else
    ткст0 cpp_mangle(Symbol* s) { return &s.Sident[0]; }

// ee.c
проц eecontext_convs(бцел marksi);
проц eecontext_parse();

// exp2.c
//#define REP_THRESHOLD (REGSIZE * (6+ (REGSIZE == 4)))
        /* doesn't belong here, but func to OPxxx is in exp2 */
проц exp2_setstrthis(elem *e,Symbol *s,targ_т_мера смещение,тип *t);
Symbol *exp2_qualified_lookup(Classsym *sclass, цел flags, цел *pflags);
elem *exp2_copytotemp(elem *e);

/* util.c */
//#if __clang__
//проц util_exit(цел) __attribute__((noreturn));
//проц util_assert(сим*, цел) __attribute__((noreturn));
//#elif _MSC_VER
//__declspec(noreturn) проц util_exit(цел);
//__declspec(noreturn) проц util_assert(сим*, цел);
//#else
проц util_exit(цел);
проц util_assert(сим*, цел);
//#if __DMC__
//#pragma ZTC noreturn(util_exit)
//#pragma ZTC noreturn(util_assert)
//#endif
//#endif

проц util_progress();
проц util_set16();
проц util_set32();
проц util_set64();
цел ispow2(uint64_t);

version (Posix)
{
ук util_malloc(бцел n,бцел size) { return mem_malloc(n * size); }
ук util_calloc(бцел n,бцел size) { return mem_calloc(n * size); }
проц util_free(проц *p) { mem_free(p); }
проц *util_realloc(проц *oldp,бцел n,бцел size) { return mem_realloc(oldp, n * size); }
//#define parc_malloc     mem_malloc
//#define parc_calloc     mem_calloc
//#define parc_realloc    mem_realloc
//#define parc_strdup     mem_strdup
//#define parc_free       mem_free
}
else
{
проц *util_malloc(бцел n,бцел size);
проц *util_calloc(бцел n,бцел size);
проц util_free(проц *p);
проц *util_realloc(проц *oldp,бцел n,бцел size);
проц *parc_malloc(т_мера len);
проц *parc_calloc(т_мера len);
проц *parc_realloc(проц *oldp,т_мера len);
сим *parc_strdup(ткст0 s);
проц parc_free(проц *p);
}

проц swap(цел *, цел *);
//проц crlf(FILE *);
сим *unsstr(бцел);
цел isignore(цел);
цел isillegal(цел);

//#if !defined(__DMC__) && !defined(_MSC_VER)
цел ishex(цел);
//#endif

/* from cgcs.c */
проц comsubs();
проц cgcs_term();

/* errmsgs.c */
сим *dlcmsgs(цел);
проц errmsgs_term();

/* from evalu8.c */
цел boolres(elem *);
цел iftrue(elem *);
цел iffalse(elem *);
elem *poptelem(elem *);
elem *poptelem2(elem *);
elem *poptelem3(elem *);
elem *poptelem4(elem *);
elem *selecte1(elem *, тип *);

//extern       тип *declar(тип *,сим *,цел);

/* from err.c */
проц err_message(ткст0 format,...);
проц dll_printf(ткст0 format,...);
проц cmderr(бцел,...);
цел synerr(бцел,...);
проц preerr(бцел,...);

//#if __clang__
//проц err_exit() __attribute__((analyzer_noreturn));
//проц err_nomem() __attribute__((analyzer_noreturn));
//проц err_fatal(бцел,...) __attribute__((analyzer_noreturn));
//#else
проц err_exit();
проц err_nomem();
проц err_fatal(бцел,...);
//#if __DMC__
//#pragma ZTC noreturn(err_exit)
//#pragma ZTC noreturn(err_nomem)
//#pragma ZTC noreturn(err_fatal)
//#endif
//#endif

цел cpperr(бцел,...);
цел tx86err(бцел,...);
extern  цел errmsgs_tx86idx;
проц warerr(бцел,...);
проц err_warning_enable(бцел warnum, цел on);
проц lexerr(бцел,...);

цел typerr(цел,тип *,тип *, ...);
проц err_noctor(Classsym *stag,list_t arglist);
проц err_nomatch(сим*, list_t);
проц err_ambiguous(Symbol *,Symbol *);
проц err_noinstance(Symbol *s1,Symbol *s2);
проц err_redeclar(Symbol *s,тип *t1,тип *t2);
проц err_override(Symbol *sfbase,Symbol *sfder);
проц err_notamember(ткст0 ид, Classsym *s, Symbol *alternate = null);

/* exp.c */
elem *Выражение();
elem *const_exp();
elem *assign_exp();
elem *exp_simplecast(тип *);

/* файл.c */
сим *file_getsource(ткст0 iname);
цел file_isdir(ткст0 fname);
проц file_progress();
проц file_remove(сим *fname);
цел file_exists(ткст0 fname);
цел file_size(ткст0 fname);
проц file_term();
сим *file_unique();

/* from msc.c */
тип *newpointer(тип *);
тип *newpointer_share(тип *);
тип *reftoptr(тип *t);
тип *newref(тип *);
тип *topointer(тип *);
тип *type_ptr(elem *, тип *);
цел type_chksize(бцел);
tym_t tym_conv( тип *);
тип* type_arrayroot(inout тип *);
проц chklvalue(elem *);
цел tolvalue(elem **);
проц chkassign(elem *);
проц chknosu( elem *);
проц chkunass( elem *);
проц chknoabstract( тип *);
targ_llong msc_getnum();
targ_т_мера alignmember( тип *,targ_т_мера,targ_т_мера);
targ_т_мера _align(targ_т_мера,targ_т_мера);

/* nteh.c */
ббайт *nteh_context_string();
проц nteh_declarvars(Blockx *bx);
elem *nteh_setScopeTableIndex(Blockx *blx, цел scope_index);
Symbol *nteh_contextsym();
бцел nteh_contextsym_size();
Symbol *nteh_ecodesym();
code *nteh_unwind(regm_t retregs,бцел index);
code *linux_unwind(regm_t retregs,бцел index);
цел nteh_offset_sindex();
цел nteh_offset_sindex_seh();
цел nteh_offset_info();

/* ос.c */
проц *globalrealloc(проц *oldp,т_мера члобайт);
проц *vmem_baseaddr();
проц vmem_reservesize(бцел *psize);
бцел vmem_physmem();
проц *vmem_reserve(проц *ptr,бцел size);
цел   vmem_commit(проц *ptr, бцел size);
проц vmem_decommit(проц *ptr,бцел size);
проц vmem_release(проц *ptr,бцел size);
проц *vmem_mapfile(ткст0 имяф,проц *ptr,бцел size,цел флаг);
проц vmem_setfilesize(бцел size);
проц vmem_unmapfile();
проц os_loadlibrary(ткст0 dllname);
проц os_freelibrary();
проц *os_getprocaddress(ткст0 funcname);
проц os_heapinit();
проц os_heapterm();
проц os_term();
бцел os_unique();
цел os_file_exists(ткст0 имя);
цел os_file_mtime(ткст0 имя);
long os_file_size(цел fd);
long os_file_size(ткст0 имяф);
сим *file_8dot3name(ткст0 имяф);
цел file_write(сим *имя, проц *буфер, бцел len);
цел file_createdirs(сим *имя);

/* pseudo.c */
Symbol *pseudo_declar(сим *);
extern 
{
    ббайт[24] pseudoreg;
    regm_t[24] pseudomask;
}

/* Symbol.c */
extern (C) Symbol **symtab_realloc(Symbol **tab, т_мера symmax);
Symbol **symtab_malloc(т_мера symmax);
Symbol **symtab_calloc(т_мера symmax);
проц symtab_free(Symbol **tab);
//#if TERMCODE
//проц symbol_keep(Symbol *s);
//#else
//#define symbol_keep(s) (()(s))
//#endif
проц symbol_keep(Symbol *s) { }
проц symbol_print( Symbol* s);
проц symbol_term();
ткст0 symbol_ident( Symbol *s);
Symbol *symbol_calloc(ткст0 ид);
Symbol *symbol_calloc(ткст0 ид, бцел len);
Symbol *symbol_name(ткст0 имя, цел sclass, тип *t);
Symbol *symbol_name(ткст0 имя, бцел len, цел sclass, тип *t);
Symbol *symbol_generate(цел sclass, тип *t);
Symbol *symbol_genauto(тип *t);
Symbol *symbol_genauto(elem *e);
Symbol *symbol_genauto(tym_t ty);
проц symbol_func(Symbol *);
//проц symbol_struct_addField(Symbol *s, ткст0 имя, тип *t, бцел смещение);
Funcsym *symbol_funcalias(Funcsym *sf);
Symbol *defsy(ткст0 p, Symbol **родитель);
проц symbol_addtotree(Symbol **родитель,Symbol *s);
//Symbol *lookupsym(ткст0 p);
Symbol *findsy(ткст0 p, Symbol *rover);
проц createglobalsymtab();
проц createlocalsymtab();
проц deletesymtab();
проц meminit_free(meminit_t *m);
baseclass_t *baseclass_find(baseclass_t *bm,Classsym *sbase);
baseclass_t *baseclass_find_nest(baseclass_t *bm,Classsym *sbase);
цел baseclass_nitems(baseclass_t *b);
проц symbol_free(Symbol *s);
SYMIDX symbol_add(Symbol *s);
SYMIDX symbol_add(symtab_t*, Symbol *s);
SYMIDX symbol_insert(symtab_t*, Symbol *s, SYMIDX n);
проц freesymtab(Symbol **stab, SYMIDX n1, SYMIDX n2);
Symbol *symbol_copy(Symbol *s);
Symbol *symbol_searchlist(symlist_t sl, ткст0 vident);
проц symbol_reset(Symbol *s);
tym_t symbol_pointerType( Symbol* s);

// cg87.c
проц cg87_reset();

ббайт loadconst(elem *e, цел im);

/* From cgopt.c */
проц opt();


// objrecor.c
проц objfile_open(сим*);
проц objfile_close(проц *данные, бцел len);
проц objfile_delete();
проц objfile_term();

/* cod3.c */
проц cod3_thunk(Symbol *sthunk,Symbol *sfunc,бцел p,tym_t thisty,
        бцел d,цел i,бцел d2);

/* out.c */
проц outfilename(сим *имя,цел номстр);
проц outcsegname(сим *csegname);
extern (C) проц outthunk(Symbol *sthunk, Symbol *sfunc, бцел p, tym_t thisty, targ_т_мера d, цел i, targ_т_мера d2);
проц outdata(Symbol *s);
проц outcommon(Symbol *s, targ_т_мера n);
проц out_readonly(Symbol *s);
проц out_readonly_comdat(Symbol *s, ук p, бцел len, бцел nzeros);
проц out_regcand(symtab_t *);
проц writefunc(Symbol *sfunc);
проц alignOffset(цел seg,targ_т_мера datasize);
проц out_reset();
Symbol *out_readonly_sym(tym_t ty, проц *p, цел len);
Symbol *out_string_literal(ткст0 str, бцел len, бцел sz);

/* blockopt.c */
//extern  бцел[BCMAX] bc_goal;
extern  бцел[20] bc_goal;


block* block_calloc();
проц block_init();
проц block_term();
проц block_next(цел,block *);
проц block_next(Blockx *bctx,цел bc,block *bn);
block *block_goto(Blockx *bctx, BC bc,block *bn);
проц block_setlabel(бцел lbl);
проц block_goto();
проц block_goto(block *);
проц block_goto(block *bgoto, block *bnew);
проц block_ptr();
проц block_pred();
проц block_clearvisit();
проц block_visit(block *b);
проц block_compbcount();
проц blocklist_free(block **pb);
проц block_optimizer_free(block *b);
проц block_free(block *b);
проц blocklist_hydrate(block **pb);
проц blocklist_dehydrate(block **pb);
проц block_appendexp(block *b, elem *e);
проц block_initvar(Symbol *s);
проц block_endfunc(цел флаг);
проц brcombine();
проц blockopt(цел);
проц compdfo();

//#define block_initvar(s) (curblock->Binitvar = (s))

/* debug.c */
extern  сим*[32] regstring;

проц WRclass(цел c);
проц WRTYxx(tym_t t);
проц WROP(бцел oper);
проц WRBC(бцел bc);
проц WRarglst(list_t a);
проц WRblock(block *b);
проц WRblocklist(list_t bl);
проц WReqn(elem *e);
проц numberBlocks(block* startblock);
проц WRfunc();
проц WRdefnod();
проц WRFL(FL);
сим *sym_ident(SYMIDX si);

/* cgelem.c     */
elem *doptelem(elem *, goal_t);
проц postoptelem(elem *);
цел elemisone(elem *);

/* msc.c */
targ_т_мера size(tym_t);
Symbol *symboldata(targ_т_мера смещение,tym_t ty);
бул dom(block *A , block *B);
бцел revop(бцел op);
бцел invrel(бцел op);
цел binary(ткст0 p, сим** tab, цел high);
цел binary(ткст0 p, т_мера len, сим** tab, цел high);

/* go.c */
проц go_term();
цел go_flag(сим *cp);
проц optfunc();

/* имяф.c */
version (SCPP)
{
    extern  Srcfiles srcfiles;
    Sfile **filename_indirect(Sfile *sf);
    Sfile  *filename_search(ткст0 имя);
    Sfile *filename_add(ткст0 имя);
    проц filename_hydrate(Srcfiles *fn);
    проц filename_dehydrate(Srcfiles *fn);
    проц filename_merge(Srcfiles *fn);
    проц filename_mergefl(Sfile *sf);
    проц filename_translate(Srcpos *);
    проц filename_free();
    цел filename_cmp(ткст0 f1,ткст0 f2);
    проц srcpos_hydrate(Srcpos *);
    проц srcpos_dehydrate(Srcpos *);
}
version (SPP)
{
    extern  Srcfiles srcfiles;
    Sfile **filename_indirect(Sfile *sf);
    Sfile  *filename_search(ткст0 имя);
    Sfile *filename_add(ткст0 имя);
    цел filename_cmp(ткст0 f1,ткст0 f2);
    проц filename_translate(Srcpos *);
}
version (HTOD)
{
    extern  Srcfiles srcfiles;
    Sfile **filename_indirect(Sfile *sf);
    Sfile  *filename_search(ткст0 имя);
    Sfile *filename_add(ткст0 имя);
    проц filename_hydrate(Srcfiles *fn);
    проц filename_dehydrate(Srcfiles *fn);
    проц filename_merge(Srcfiles *fn);
    проц filename_mergefl(Sfile *sf);
    цел filename_cmp(ткст0 f1,ткст0 f2);
    проц filename_translate(Srcpos *);
    проц srcpos_hydrate(Srcpos *);
    проц srcpos_dehydrate(Srcpos *);
}

// tdb.c
бцел tdb_gettimestamp();
проц tdb_write(проц *буф,бцел size,бцел numindices);
бцел tdb_typidx(проц *буф);
//бцел tdb_typidx(ббайт *буф,бцел length);
проц tdb_term();

// rtlsym.c
проц rtlsym_init();
проц rtlsym_reset();
проц rtlsym_term();

// compress.c
extern(C) сим *id_compress(сим *ид, цел idlen, т_мера *plen);

// Dwarf
проц dwarf_CFA_set_loc(бцел location);
проц dwarf_CFA_set_reg_offset(цел reg, цел смещение);
проц dwarf_CFA_offset(цел reg, цел смещение);
проц dwarf_CFA_args_size(т_мера sz);

// TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS
elem *exp_isconst();
elem *lnx_builtin_next_arg(elem *efunc,list_t arglist);
сим *lnx_redirect_funcname(сим*);
проц  lnx_funcdecl(Symbol *,SC,enum_SC,цел);
цел  lnx_attributes(цел hinttype, проц *hint, тип **ptyp, tym_t *ptym,цел *pattrtype);

