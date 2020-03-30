/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2009-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/machobj.d, backend/machobj.d)
 */

module drc.backend.machobj;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.mem;
import drc.backend.aarray;
import drc.backend.dlist;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/



alias extern(C)  цел function( ук,  ук) _compare_fp_t;
extern(C) проц qsort(ук base, т_мера nmemb, т_мера size, _compare_fp_t compar);

static if (MACHOBJ)
{

import drc.backend.dwarf;
import drc.backend.mach;

alias drc.backend.mach.nlist nlist;   // avoid conflict with drc.backend.dlist.nlist

/****************************************
 * Sort the relocation entry буфер.
 * put before  because qsort was not marked  until version 2.086
 */

extern (C) {
private цел rel_fp(ук e1,ук e2)
{   Relocation *r1 = cast(Relocation *)e1;
    Relocation *r2 = cast(Relocation *)e2;

    return cast(цел)(r1.смещение - r2.смещение);
}
}

проц mach_relsort(Outbuffer *буф)
{
    qsort(буф.буф, буф.size() / Relocation.sizeof, Relocation.sizeof, &rel_fp);
}

// for x86_64
enum
{
    X86_64_RELOC_UNSIGNED         = 0,
    X86_64_RELOC_SIGNED           = 1,
    X86_64_RELOC_BRANCH           = 2,
    X86_64_RELOC_GOT_LOAD         = 3,
    X86_64_RELOC_GOT              = 4,
    X86_64_RELOC_SUBTRACTOR       = 5,
    X86_64_RELOC_SIGNED_1         = 6,
    X86_64_RELOC_SIGNED_2         = 7,
    X86_64_RELOC_SIGNED_4         = 8,
    X86_64_RELOC_TLV              = 9, // for thread local variables
}

private  Outbuffer *fobjbuf;

const DEST_LEN = (IDMAX + IDOHD + 1);
сим *obj_mangle2(Symbol *s,сим *dest);

extern  цел except_table_seg;        // segment of __gcc_except_tab
extern  цел eh_frame_seg;            // segment of __eh_frame


/******************************************
 */

/// Возвращает: a reference to the глоб2 смещение table
Symbol* Obj_getGOTsym()
{
     Symbol *GOTsym;
    if (!GOTsym)
    {
        GOTsym = symbol_name("_GLOBAL_OFFSET_TABLE_",SCglobal,tspvoid);
    }
    return GOTsym;
}

проц Obj_refGOTsym()
{
    assert(0);
}

// The объект файл is built is several separate pieces


// String Table  - String table for all other имена
private  Outbuffer *symtab_strings;

// Section Headers
 Outbuffer  *SECbuf;             // Buffer to build section table in
section* SecHdrTab() { return cast(section *)SECbuf.буф; }
section_64* SecHdrTab64() { return cast(section_64 *)SECbuf.буф; }


public{

// The relocation for text and данные seems to get lost.
// Try matching the order gcc output them
// This means defining the sections and then removing them if they are
// not используется.
private цел section_cnt;         // Number of sections in table
const SEC_TAB_INIT = 16;          // Initial number of sections in буфер
const SEC_TAB_INC  = 4;           // Number of sections to increment буфер by

const SYM_TAB_INIT = 100;         // Initial number of symbol entries in буфер
const SYM_TAB_INC  = 50;          // Number of symbols to increment буфер by

/* Three symbol tables, because the different types of symbols
 * are grouped into 3 different types (and a 4th for comdef's).
 */

private Outbuffer *local_symbuf;
private Outbuffer *public_symbuf;
private Outbuffer *extern_symbuf;
}

private проц reset_symbols(Outbuffer *буф)
{
    Symbol **p = cast(Symbol **)буф.буф;
    const т_мера n = буф.size() / (Symbol *).sizeof;
    for (т_мера i = 0; i < n; ++i)
        symbol_reset(p[i]);
}


public{

struct Comdef { Symbol *sym; targ_т_мера size; цел count; }
private Outbuffer *comdef_symbuf;        // Comdef's are stored here

private Outbuffer *indirectsymbuf1;      // indirect symbol table of Symbol*'s
private цел jumpTableSeg;                // segment index for __jump_table

private Outbuffer *indirectsymbuf2;      // indirect symbol table of Symbol*'s
private цел pointersSeg;                 // segment index for __pointers

/* If an Obj_external_def() happens, set this to the ткст index,
 * to be added last to the symbol table.
 * Obviously, there can be only one.
 */
private IDXSTR extdef;
}

static if (0)
{
enum
{
    STI_FILE  = 1,            // Where файл symbol table entry is
    STI_TEXT  = 2,
    STI_DATA  = 3,
    STI_BSS   = 4,
    STI_GCC   = 5,            // Where "gcc2_compiled" symbol is */
    STI_RODAT = 6,            // Symbol for readonly данные
    STI_COM   = 8,
}
}

// Each compiler segment is a section
// Predefined compiler segments CODE,DATA,CDATA,UDATA map to indexes
//      into SegData[]
//      New compiler segments are added to end.

/******************************
 * Возвращает !=0 if this segment is a code segment.
 */

цел seg_data_isCode(ref seg_data sd)
{
    // The codegen assumes that code.данные references are indirect,
    // but when CDATA is treated as code reftoident will emit a direct
    // relocation.
    if (&sd == SegData[CDATA])
        return нет;

    if (I64)
    {
        //printf("SDshtidx = %d, x%x\n", SDshtidx, SecHdrTab64[sd.SDshtidx].flags);
        return strcmp(SecHdrTab64[sd.SDshtidx].segname.ptr, "__TEXT") == 0;
    }
    else
    {
        //printf("SDshtidx = %d, x%x\n", SDshtidx, SecHdrTab[sd.SDshtidx].flags);
        return strcmp(SecHdrTab[sd.SDshtidx].segname.ptr, "__TEXT") == 0;
    }
}




seg_data **SegData;
цел seg_count;
цел seg_max;

/**
 * Section index for the __thread_vars/__tls_data section.
 *
 * This section is используется for the variable symbol for TLS variables.
 */
цел seg_tlsseg = UNKNOWN;

/**
 * Section index for the __thread_bss section.
 *
 * This section is используется for the данные symbol ($tlv$init) for TLS variables
 * without an инициализатор.
 */
цел seg_tlsseg_bss = UNKNOWN;

/**
 * Section index for the __thread_data section.
 *
 * This section is используется for the данные symbol ($tlv$init) for TLS variables
 * with an инициализатор.
 */
цел seg_tlsseg_data = UNKNOWN;


/*******************************************************
 * Because the Mach-O relocations cannot be computed until after
 * all the segments are written out, and we need more information
 * than the Mach-O relocations provide, make our own relocation
 * тип. Later, translate to Mach-O relocation structure.
 */

enum
{
    RELaddr = 0,      // straight address
    RELrel  = 1,      // relative to location to be fixed up
}

struct Relocation
{   // Relocations are attached to the struct seg_data they refer to
    targ_т_мера смещение; // location in segment to be fixed up
    Symbol *funcsym;    // function in which смещение lies, if any
    Symbol *targsym;    // if !=null, then location is to be fixed up
                        // to address of this symbol
    бцел targseg;       // if !=0, then location is to be fixed up
                        // to address of start of this segment
    ббайт rtype;        // RELxxxx
    ббайт флаг;         // 1: emit SUBTRACTOR/UNSIGNED pair
    short val;          // 0, -1, -2, -4
}


/*******************************
 * Output a ткст into a ткст table
 * Input:
 *      strtab  =       ткст table for entry
 *      str     =       ткст to add
 *
 * Возвращает index into the specified ткст table.
 */

IDXSTR Obj_addstr(Outbuffer *strtab, ткст0 str)
{
    //printf("Obj_addstr(strtab = %p str = '%s')\n",strtab,str);
    IDXSTR idx = cast(IDXSTR)strtab.size();        // remember starting смещение
    strtab.writeString(str);
    //printf("\tidx %d, new size %d\n",idx,strtab.size());
    return idx;
}

/*******************************
 * Output a mangled ткст into the symbol ткст table
 * Input:
 *      str     =       ткст to add
 *
 * Возвращает index into the table.
 */

private IDXSTR elf_addmangled(Symbol *s)
{
    //printf("elf_addmangled(%s)\n", s.Sident);
    сим[DEST_LEN] dest = проц;
    сим *destr;
    ткст0 имя;
    IDXSTR namidx;

    namidx = cast(IDXSTR)symtab_strings.size();
    destr = obj_mangle2(s, dest.ptr);
    имя = destr;
    if (CPP && имя[0] == '_' && имя[1] == '_')
    {
        if (strncmp(имя,"__ct__",6) == 0)
            имя += 4;
static if (0)
{
        switch(имя[2])
        {
            case 'c':
                if (strncmp(имя,"__ct__",6) == 0)
                    имя += 4;
                break;
            case 'd':
                if (strcmp(имя,"__dl__FvP") == 0)
                    имя = "__builtin_delete";
                break;
            case 'v':
                //if (strcmp(имя,"__vec_delete__FvPiUIPi") == 0)
                    //имя = "__builtin_vec_del";
                //else
                //if (strcmp(имя,"__vn__FPUI") == 0)
                    //имя = "__builtin_vec_new";
                break;
            case 'n':
                if (strcmp(имя,"__nw__FPUI") == 0)
                    имя = "__builtin_new";
                break;

            default:
                break;
        }
}
    }
    else if (tyfunc(s.ty()) && s.Sfunc && s.Sfunc.Fredirect)
        имя = s.Sfunc.Fredirect;
    т_мера len = strlen(имя);
    symtab_strings.резервируй(cast(бцел)(len+1));
    strcpy(cast(сим *)symtab_strings.p,имя);
    symtab_strings.устРазм(cast(бцел)(namidx+len+1));
    if (destr != dest.ptr)                  // if we resized результат
        mem_free(destr);
    //dbg_printf("\telf_addmagled symtab_strings %s namidx %d len %d size %d\n",имя, namidx,len,symtab_strings.size());
    return namidx;
}

/**************************
 * Ouput читай only данные and generate a symbol for it.
 *
 */

Symbol * Obj_sym_cdata(tym_t ty,сим *p,цел len)
{
    Symbol *s;

static if (0)
{
    if (I64)
    {
        alignOffset(DATA, tysize(ty));
        s = symboldata(Offset(DATA), ty);
        SegData[DATA].SDbuf.пиши(p,len);
        s.Sseg = DATA;
        s.Soffset = Offset(DATA);   // Remember its смещение into DATA section
        Offset(DATA) += len;

        s.Sfl = /*(config.flags3 & CFG3pic) ? FLgotoff :*/ FLextern;
        return s;
    }
}
    //printf("Obj_sym_cdata(ty = %x, p = %x, len = %d, Offset(CDATA) = %x)\n", ty, p, len, Offset(CDATA));
    alignOffset(CDATA, tysize(ty));
    s = symboldata(Offset(CDATA), ty);
    s.Sseg = CDATA;
    //Obj_pubdef(CDATA, s, Offset(CDATA));
    Obj_bytes(CDATA, Offset(CDATA), len, p);

    s.Sfl = /*(config.flags3 & CFG3pic) ? FLgotoff :*/ FLextern;
    return s;
}

/**************************
 * Ouput читай only данные for данные
 *
 */

цел Obj_data_readonly(сим *p, цел len, цел *pseg)
{
    цел oldoff = cast(цел)Offset(CDATA);
    SegData[CDATA].SDbuf.резервируй(len);
    SegData[CDATA].SDbuf.writen(p,len);
    Offset(CDATA) += len;
    *pseg = CDATA;
    return oldoff;
}

цел Obj_data_readonly(сим *p, цел len)
{
    цел pseg;

    return Obj_data_readonly(p, len, &pseg);
}

/*****************************
 * Get segment for readonly ткст literals.
 * The linker will pool strings in this section.
 * Параметры:
 *    sz = number of bytes per character (1, 2, or 4)
 * Возвращает:
 *    segment index
 */
цел Obj_string_literal_segment(бцел sz)
{
    if (sz == 1)
    {
        return Obj_getsegment("__cstring", "__TEXT", 0, S_CSTRING_LITERALS);
    }
    return CDATA;  // no special handling for other wstring, dstring; use __const
}

/******************************
 * Perform initialization that applies to all .o output files.
 *      Called before any other obj_xxx routines
 */

Obj Obj_init(Outbuffer *objbuf, ткст0 имяф, ткст0 csegname)
{
    //printf("Obj_init()\n");
    Obj obj = cast(Obj)mem_calloc(__traits(classInstanceSize, Obj));

    cseg = CODE;
    fobjbuf = objbuf;

    seg_tlsseg = UNKNOWN;
    seg_tlsseg_bss = UNKNOWN;
    seg_tlsseg_data = UNKNOWN;

    // Initialize buffers

    if (symtab_strings)
        symtab_strings.устРазм(1);
    else
    {
        symtab_strings = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(symtab_strings);
        symtab_strings.enlarge(1024);

        symtab_strings.резервируй(2048);
        symtab_strings.пишиБайт(0);
    }

    if (!local_symbuf)
    {
        local_symbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(local_symbuf);
        local_symbuf.enlarge((Symbol *).sizeof * SYM_TAB_INIT);
    }
    local_symbuf.устРазм(0);

    if (public_symbuf)
    {
        reset_symbols(public_symbuf);
        public_symbuf.устРазм(0);
    }
    else
    {
        public_symbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(public_symbuf);
        public_symbuf.enlarge((Symbol *).sizeof * SYM_TAB_INIT);
    }

    if (extern_symbuf)
    {
        reset_symbols(extern_symbuf);
        extern_symbuf.устРазм(0);
    }
    else
    {
        extern_symbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(extern_symbuf);
        extern_symbuf.enlarge((Symbol *).sizeof * SYM_TAB_INIT);
    }

    if (!comdef_symbuf)
    {
        comdef_symbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(comdef_symbuf);
        comdef_symbuf.enlarge((Symbol *).sizeof * SYM_TAB_INIT);
    }
    comdef_symbuf.устРазм(0);

    extdef = 0;

    if (indirectsymbuf1)
        indirectsymbuf1.устРазм(0);
    jumpTableSeg = 0;

    if (indirectsymbuf2)
        indirectsymbuf2.устРазм(0);
    pointersSeg = 0;

    // Initialize segments for CODE, DATA, UDATA and CDATA
    т_мера struct_section_size = I64 ? section_64.sizeof : section.sizeof;
    if (SECbuf)
    {
        SECbuf.устРазм(cast(бцел)struct_section_size);
    }
    else
    {
        SECbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(SECbuf);
        SECbuf.enlarge(cast(бцел)(SYM_TAB_INC * struct_section_size));

        SECbuf.резервируй(cast(бцел)(SEC_TAB_INIT * struct_section_size));
        // Ignore the first section - section numbers start at 1
        SECbuf.writezeros(cast(бцел)struct_section_size);
    }
    section_cnt = 1;

    seg_count = 0;
    цел align_ = I64 ? 4 : 2;            // align to 16 bytes for floating point
    Obj_getsegment("__text",  "__TEXT", 2, S_REGULAR | S_ATTR_PURE_INSTRUCTIONS | S_ATTR_SOME_INSTRUCTIONS);
    Obj_getsegment("__data",  "__DATA", align_, S_REGULAR);     // DATA
    Obj_getsegment("__const", "__TEXT", 2, S_REGULAR);         // CDATA
    Obj_getsegment("__bss",   "__DATA", 4, S_ZEROFILL);        // UDATA
    Obj_getsegment("__const", "__DATA", align_, S_REGULAR);     // CDATAREL

    dwarf_initfile(имяф);
    return obj;
}

/**************************
 * Initialize the start of объект output for this particular .o файл.
 *
 * Input:
 *      имяф:       Name of source файл
 *      csegname:       User specified default code segment имя
 */

проц Obj_initfile(ткст0 имяф, ткст0 csegname, ткст0 modname)
{
    //dbg_printf("Obj_initfile(имяф = %s, modname = %s)\n",имяф,modname);
version (SCPP)
{
    if (csegname && *csegname && strcmp(csegname,".text"))
    {   // Define new section and make it the default for cseg segment
        // NOTE: cseg is initialized to CODE
        IDXSEC newsecidx;
        Elf32_Shdr *newtextsec;
        IDXSYM newsymidx;
        assert(!I64);      // fix later
        SegData[cseg].SDshtidx = newsecidx =
            elf_newsection(csegname,0,SHT_PROGDEF,SHF_ALLOC|SHF_EXECINSTR);
        newtextsec = &SecHdrTab[newsecidx];
        newtextsec.sh_addralign = 4;
        SegData[cseg].SDsymidx =
            elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, newsecidx);
    }
}
    if (config.fulltypes)
        dwarf_initmodule(имяф, modname);
}

/************************************
 * Patch pseg/смещение by adding in the vmaddr difference from
 * pseg/смещение to start of seg.
 */

int32_t *patchAddr(цел seg, targ_т_мера смещение)
{
    return cast(int32_t *)(fobjbuf.буф + SecHdrTab[SegData[seg].SDshtidx].смещение + смещение);
}

int32_t *patchAddr64(цел seg, targ_т_мера смещение)
{
    return cast(int32_t *)(fobjbuf.буф + SecHdrTab64[SegData[seg].SDshtidx].смещение + смещение);
}

проц patch(seg_data *pseg, targ_т_мера смещение, цел seg, targ_т_мера значение)
{
    //printf("patch(смещение = x%04x, seg = %d, значение = x%llx)\n", (бцел)смещение, seg, значение);
    if (I64)
    {
        int32_t *p = cast(int32_t *)(fobjbuf.буф + SecHdrTab64[pseg.SDshtidx].смещение + смещение);
static if (0)
{
        printf("\taddr1 = x%llx\n\taddr2 = x%llx\n\t*p = x%llx\n\tdelta = x%llx\n",
            SecHdrTab64[pseg.SDshtidx].addr,
            SecHdrTab64[SegData[seg].SDshtidx].addr,
            *p,
            SecHdrTab64[SegData[seg].SDshtidx].addr -
            (SecHdrTab64[pseg.SDshtidx].addr + смещение));
}
        *p += SecHdrTab64[SegData[seg].SDshtidx].addr -
              (SecHdrTab64[pseg.SDshtidx].addr - значение);
    }
    else
    {
        int32_t *p = cast(int32_t *)(fobjbuf.буф + SecHdrTab[pseg.SDshtidx].смещение + смещение);
static if (0)
{
        printf("\taddr1 = x%x\n\taddr2 = x%x\n\t*p = x%x\n\tdelta = x%x\n",
            SecHdrTab[pseg.SDshtidx].addr,
            SecHdrTab[SegData[seg].SDshtidx].addr,
            *p,
            SecHdrTab[SegData[seg].SDshtidx].addr -
            (SecHdrTab[pseg.SDshtidx].addr + смещение));
}
        *p += SecHdrTab[SegData[seg].SDshtidx].addr -
              (SecHdrTab[pseg.SDshtidx].addr - значение);
    }
}

/***************************
 * Number symbols so they are
 * ordered as locals, public and then extern/comdef
 */

проц mach_numbersyms()
{
    //printf("mach_numbersyms()\n");
    цел n = 0;

    цел dim;
    dim = cast(цел)(local_symbuf.size() / (Symbol *).sizeof);
    for (цел i = 0; i < dim; i++)
    {   Symbol *s = (cast(Symbol **)local_symbuf.буф)[i];
        s.Sxtrnnum = n;
        n++;
    }

    dim = cast(цел)(public_symbuf.size() / (Symbol *).sizeof);
    for (цел i = 0; i < dim; i++)
    {   Symbol *s = (cast(Symbol **)public_symbuf.буф)[i];
        s.Sxtrnnum = n;
        n++;
    }

    dim = cast(цел)(extern_symbuf.size() / (Symbol *).sizeof);
    for (цел i = 0; i < dim; i++)
    {   Symbol *s = (cast(Symbol **)extern_symbuf.буф)[i];
        s.Sxtrnnum = n;
        n++;
    }

    dim = cast(цел)(comdef_symbuf.size() / Comdef.sizeof);
    for (цел i = 0; i < dim; i++)
    {   Comdef *c = (cast(Comdef *)comdef_symbuf.буф) + i;
        c.sym.Sxtrnnum = n;
        n++;
    }
}


/***************************
 * Fixup and terminate объект файл.
 */

проц Obj_termfile()
{
    //dbg_printf("Obj_termfile\n");
    if (configv.addlinenumbers)
    {
        dwarf_termmodule();
    }
}

/*********************************
 * Terminate package.
 */

проц Obj_term(ткст0 objfilename)
{
    //printf("Obj_term()\n");
version (SCPP)
{
    if (!errcnt)
    {
        outfixlist();           // backpatches
    }
}
else
{
    outfixlist();           // backpatches
}

    if (configv.addlinenumbers)
    {
        dwarf_termfile();
    }

version (SCPP)
{
    if (errcnt)
        return;
}

    /* Write out the объект файл in the following order:
     *  header
     *  commands
     *          segment_command
     *                  { sections }
     *          symtab_command
     *          dysymtab_command
     *  { segment contents }
     *  { relocations }
     *  symbol table
     *  ткст table
     *  indirect symbol table
     */

    бцел foffset;
    бцел headersize;
    бцел sizeofcmds;

    // Write out the bytes for the header
    if (I64)
    {
        mach_header_64 header = проц;

        header.magic = MH_MAGIC_64;
        header.cputype = CPU_TYPE_X86_64;
        header.cpusubtype = CPU_SUBTYPE_I386_ALL;
        header.filetype = MH_OBJECT;
        header.ncmds = 3;
        header.sizeofcmds = cast(бцел)(segment_command_64.sizeof +
                                (section_cnt - 1) * section_64.sizeof +
                            symtab_command.sizeof +
                            dysymtab_command.sizeof);
        header.flags = MH_SUBSECTIONS_VIA_SYMBOLS;
        header.reserved = 0;
        fobjbuf.пиши(&header, header.sizeof);
        foffset = header.sizeof;       // start after header
        headersize = header.sizeof;
        sizeofcmds = header.sizeofcmds;

        // Write the actual данные later
        fobjbuf.writezeros(header.sizeofcmds);
        foffset += header.sizeofcmds;
    }
    else
    {
        mach_header header = проц;

        header.magic = MH_MAGIC;
        header.cputype = CPU_TYPE_I386;
        header.cpusubtype = CPU_SUBTYPE_I386_ALL;
        header.filetype = MH_OBJECT;
        header.ncmds = 3;
        header.sizeofcmds = cast(бцел)(segment_command.sizeof +
                                (section_cnt - 1) * section.sizeof +
                            symtab_command.sizeof +
                            dysymtab_command.sizeof);
        header.flags = MH_SUBSECTIONS_VIA_SYMBOLS;
        fobjbuf.пиши(&header, header.sizeof);
        foffset = header.sizeof;       // start after header
        headersize = header.sizeof;
        sizeofcmds = header.sizeofcmds;

        // Write the actual данные later
        fobjbuf.writezeros(header.sizeofcmds);
        foffset += header.sizeofcmds;
    }

    segment_command segment_cmd = проц;
    segment_command_64 segment_cmd64 = проц;
    symtab_command symtab_cmd = проц;
    dysymtab_command dysymtab_cmd = проц;

    memset(&segment_cmd, 0, segment_cmd.sizeof);
    memset(&segment_cmd64, 0, segment_cmd64.sizeof);
    memset(&symtab_cmd, 0, symtab_cmd.sizeof);
    memset(&dysymtab_cmd, 0, dysymtab_cmd.sizeof);

    if (I64)
    {
        segment_cmd64.cmd = LC_SEGMENT_64;
        segment_cmd64.cmdsize = cast(бцел)(segment_cmd64.sizeof +
                                    (section_cnt - 1) * section_64.sizeof);
        segment_cmd64.nsects = section_cnt - 1;
        segment_cmd64.maxprot = 7;
        segment_cmd64.initprot = 7;
    }
    else
    {
        segment_cmd.cmd = LC_SEGMENT;
        segment_cmd.cmdsize = cast(бцел)(segment_cmd.sizeof +
                                    (section_cnt - 1) * section.sizeof);
        segment_cmd.nsects = section_cnt - 1;
        segment_cmd.maxprot = 7;
        segment_cmd.initprot = 7;
    }

    symtab_cmd.cmd = LC_SYMTAB;
    symtab_cmd.cmdsize = symtab_cmd.sizeof;

    dysymtab_cmd.cmd = LC_DYSYMTAB;
    dysymtab_cmd.cmdsize = dysymtab_cmd.sizeof;

    /* If a __pointers section was emitted, need to set the .reserved1
     * field to the symbol index in the indirect symbol table of the
     * start of the __pointers symbols.
     */
    if (pointersSeg)
    {
        seg_data *pseg = SegData[pointersSeg];
        if (I64)
        {
            section_64 *psechdr = &SecHdrTab64[pseg.SDshtidx]; // corresponding section
            psechdr.reserved1 = cast(бцел)(indirectsymbuf1
                ? indirectsymbuf1.size() / (Symbol *).sizeof
                : 0);
        }
        else
        {
            section *psechdr = &SecHdrTab[pseg.SDshtidx]; // corresponding section
            psechdr.reserved1 = cast(бцел)(indirectsymbuf1
                ? indirectsymbuf1.size() / (Symbol *).sizeof
                : 0);
        }
    }

    // Walk through sections determining size and файл offsets

    //
    // First output individual section данные associate with program
    //  code and данные
    //
    foffset = elf_align(I64 ? 8 : 4, foffset);
    if (I64)
        segment_cmd64.fileoff = foffset;
    else
        segment_cmd.fileoff = foffset;
    бцел vmaddr = 0;

    //printf("Setup offsets and sizes foffset %d\n\tsection_cnt %d, seg_count %d\n",foffset,section_cnt,seg_count);
    // Zero filled segments go at the end, so go through segments twice
    for (цел i = 0; i < 2; i++)
    {
        for (цел seg = 1; seg <= seg_count; seg++)
        {
            seg_data *pseg = SegData[seg];
            if (I64)
            {
                section_64 *psechdr = &SecHdrTab64[pseg.SDshtidx]; // corresponding section

                // Do нуль-fill the second time through this loop
                if (i ^ (psechdr.flags == S_ZEROFILL))
                    continue;

                цел align_ = 1 << psechdr._align;
                while (psechdr._align > 0 && align_ < pseg.SDalignment)
                {
                    psechdr._align += 1;
                    align_ <<= 1;
                }
                foffset = elf_align(align_, foffset);
                vmaddr = (vmaddr + align_ - 1) & ~(align_ - 1);
                if (psechdr.flags == S_ZEROFILL)
                {
                    psechdr.смещение = 0;
                    psechdr.size = pseg.SDoffset; // accumulated size
                }
                else
                {
                    psechdr.смещение = foffset;
                    psechdr.size = 0;
                    //printf("\tsection имя %s,", psechdr.sectname);
                    if (pseg.SDbuf && pseg.SDbuf.size())
                    {
                        //printf("\tsize %d\n", pseg.SDbuf.size());
                        psechdr.size = pseg.SDbuf.size();
                        fobjbuf.пиши(pseg.SDbuf.буф, cast(бцел)psechdr.size);
                        foffset += psechdr.size;
                    }
                }
                psechdr.addr = vmaddr;
                vmaddr += psechdr.size;
                //printf(" assigned смещение %d, size %d\n", foffset, psechdr.sh_size);
            }
            else
            {
                section *psechdr = &SecHdrTab[pseg.SDshtidx]; // corresponding section

                // Do нуль-fill the second time through this loop
                if (i ^ (psechdr.flags == S_ZEROFILL))
                    continue;

                цел align_ = 1 << psechdr._align;
                while (psechdr._align > 0 && align_ < pseg.SDalignment)
                {
                    psechdr._align += 1;
                    align_ <<= 1;
                }
                foffset = elf_align(align_, foffset);
                vmaddr = (vmaddr + align_ - 1) & ~(align_ - 1);
                if (psechdr.flags == S_ZEROFILL)
                {
                    psechdr.смещение = 0;
                    psechdr.size = cast(бцел)pseg.SDoffset; // accumulated size
                }
                else
                {
                    psechdr.смещение = foffset;
                    psechdr.size = 0;
                    //printf("\tsection имя %s,", psechdr.sectname);
                    if (pseg.SDbuf && pseg.SDbuf.size())
                    {
                        //printf("\tsize %d\n", pseg.SDbuf.size());
                        psechdr.size = cast(бцел)pseg.SDbuf.size();
                        fobjbuf.пиши(pseg.SDbuf.буф, psechdr.size);
                        foffset += psechdr.size;
                    }
                }
                psechdr.addr = vmaddr;
                vmaddr += psechdr.size;
                //printf(" assigned смещение %d, size %d\n", foffset, psechdr.sh_size);
            }
        }
    }

    if (I64)
    {
        segment_cmd64.vmsize = vmaddr;
        segment_cmd64.filesize = foffset - segment_cmd64.fileoff;
        /* Bugzilla 5331: Apparently having the filesize field greater than the vmsize field is an
         * error, and is happening sometimes.
         */
        if (segment_cmd64.filesize > vmaddr)
            segment_cmd64.vmsize = segment_cmd64.filesize;
    }
    else
    {
        segment_cmd.vmsize = vmaddr;
        segment_cmd.filesize = foffset - segment_cmd.fileoff;
        /* Bugzilla 5331: Apparently having the filesize field greater than the vmsize field is an
         * error, and is happening sometimes.
         */
        if (segment_cmd.filesize > vmaddr)
            segment_cmd.vmsize = segment_cmd.filesize;
    }

    // Put out relocation данные
    mach_numbersyms();
    for (цел seg = 1; seg <= seg_count; seg++)
    {
        seg_data *pseg = SegData[seg];
        section *psechdr = null;
        section_64 *psechdr64 = null;
        if (I64)
        {
            psechdr64 = &SecHdrTab64[pseg.SDshtidx];   // corresponding section
            //printf("psechdr.addr = x%llx\n", psechdr64.addr);
        }
        else
        {
            psechdr = &SecHdrTab[pseg.SDshtidx];   // corresponding section
            //printf("psechdr.addr = x%x\n", psechdr.addr);
        }
        foffset = elf_align(I64 ? 8 : 4, foffset);
        бцел reloff = foffset;
        бцел nreloc = 0;
        if (pseg.SDrel)
        {   Relocation *r = cast(Relocation *)pseg.SDrel.буф;
            Relocation *rend = cast(Relocation *)(pseg.SDrel.буф + pseg.SDrel.size());
            for (; r != rend; r++)
            {   Symbol *s = r.targsym;
                ткст0 rs = r.rtype == RELaddr ? "addr" : "rel";
                //printf("%d:x%04llx : tseg %d tsym %s REL%s\n", seg, r.смещение, r.targseg, s ? s.Sident.ptr : "0", rs);
                relocation_info rel;
                scattered_relocation_info srel;
                if (s)
                {
                    //printf("Relocation\n");
                    //symbol_print(s);
                    if (r.флаг == 1)
                    {
                        if (I64)
                        {
                            rel.r_type = X86_64_RELOC_SUBTRACTOR;
                            rel.r_address = cast(цел)r.смещение;
                            rel.r_symbolnum = r.funcsym.Sxtrnnum;
                            rel.r_pcrel = 0;
                            rel.r_length = 3;
                            rel.r_extern = 1;
                            fobjbuf.пиши(&rel, rel.sizeof);
                            foffset += (rel).sizeof;
                            ++nreloc;

                            rel.r_type = X86_64_RELOC_UNSIGNED;
                            rel.r_symbolnum = s.Sxtrnnum;
                            fobjbuf.пиши(&rel, rel.sizeof);
                            foffset += rel.sizeof;
                            ++nreloc;

                            // patch with fdesym.Soffset - смещение
                            int64_t *p = cast(int64_t *)patchAddr64(seg, r.смещение);
                            *p += r.funcsym.Soffset - r.смещение;
                            continue;
                        }
                        else
                        {
                            // address = segment + смещение
                            цел targ_address = cast(цел)(SecHdrTab[SegData[s.Sseg].SDshtidx].addr + s.Soffset);
                            цел fixup_address = cast(цел)(psechdr.addr + r.смещение);

                            srel.r_scattered = 1;
                            srel.r_type = GENERIC_RELOC_LOCAL_SECTDIFF;
                            srel.r_address = cast(бцел)r.смещение;
                            srel.r_pcrel = 0;
                            srel.r_length = 2;
                            srel.r_value = targ_address;
                            fobjbuf.пиши((&srel)[0 .. 1]);
                            foffset += srel.sizeof;
                            ++nreloc;

                            srel.r_type = GENERIC_RELOC_PAIR;
                            srel.r_address = 0;
                            srel.r_value = fixup_address;
                            fobjbuf.пиши(&srel, srel.sizeof);
                            foffset += srel.sizeof;
                            ++nreloc;

                            int32_t *p = patchAddr(seg, r.смещение);
                            *p += targ_address - fixup_address;
                            continue;
                        }
                    }
                    else if (pseg.isCode())
                    {
                        if (I64)
                        {
                            rel.r_type = (r.rtype == RELrel)
                                    ? X86_64_RELOC_BRANCH
                                    : X86_64_RELOC_SIGNED;
                            if (r.val == -1)
                                rel.r_type = X86_64_RELOC_SIGNED_1;
                            else if (r.val == -2)
                                rel.r_type = X86_64_RELOC_SIGNED_2;
                            if (r.val == -4)
                                rel.r_type = X86_64_RELOC_SIGNED_4;

                            if (s.Sclass == SCextern ||
                                s.Sclass == SCcomdef ||
                                s.Sclass == SCcomdat ||
                                s.Sclass == SCglobal)
                            {
                                if (I64 && (s.ty() & mTYLINK) == mTYthread && r.rtype == RELaddr)
                                    rel.r_type = X86_64_RELOC_TLV;
                                else if ((s.Sfl == FLfunc || s.Sfl == FLextern || s.Sclass == SCglobal || s.Sclass == SCcomdat || s.Sclass == SCcomdef) && r.rtype == RELaddr)
                                {
                                    rel.r_type = X86_64_RELOC_GOT_LOAD;
                                    if (seg == eh_frame_seg ||
                                        seg == except_table_seg)
                                        rel.r_type = X86_64_RELOC_GOT;
                                }
                                rel.r_address = cast(цел)r.смещение;
                                rel.r_symbolnum = s.Sxtrnnum;
                                rel.r_pcrel = 1;
                                rel.r_length = 2;
                                rel.r_extern = 1;
                                fobjbuf.пиши(&rel, rel.sizeof);
                                foffset += rel.sizeof;
                                nreloc++;
                                continue;
                            }
                            else
                            {
                                rel.r_address = cast(цел)r.смещение;
                                rel.r_symbolnum = s.Sseg;
                                rel.r_pcrel = 1;
                                rel.r_length = 2;
                                rel.r_extern = 0;
                                fobjbuf.пиши(&rel, rel.sizeof);
                                foffset += rel.sizeof;
                                nreloc++;

                                int32_t *p = patchAddr64(seg, r.смещение);
                                // Absolute address; add in addr of start of targ seg
//printf("*p = x%x, .addr = x%x, Soffset = x%x\n", *p, cast(цел)SecHdrTab64[SegData[s.Sseg].SDshtidx].addr, cast(цел)s.Soffset);
//printf("pseg = x%x, r.смещение = x%x\n", (цел)SecHdrTab64[pseg.SDshtidx].addr, cast(цел)r.смещение);
                                *p += SecHdrTab64[SegData[s.Sseg].SDshtidx].addr;
                                *p += s.Soffset;
                                *p -= SecHdrTab64[pseg.SDshtidx].addr + r.смещение + 4;
                                //patch(pseg, r.смещение, s.Sseg, s.Soffset);
                                continue;
                            }
                        }
                    }
                    else
                    {
                        if (s.Sclass == SCextern ||
                            s.Sclass == SCcomdef ||
                            s.Sclass == SCcomdat)
                        {
                            rel.r_address = cast(цел)r.смещение;
                            rel.r_symbolnum = s.Sxtrnnum;
                            rel.r_pcrel = 0;
                            rel.r_length = 2;
                            rel.r_extern = 1;
                            rel.r_type = GENERIC_RELOC_VANILLA;
                            if (I64)
                            {
                                rel.r_type = X86_64_RELOC_UNSIGNED;
                                rel.r_length = 3;
                            }
                            fobjbuf.пиши(&rel, rel.sizeof);
                            foffset += rel.sizeof;
                            nreloc++;
                            continue;
                        }
                        else
                        {
                            rel.r_address = cast(цел)r.смещение;
                            rel.r_symbolnum = s.Sseg;
                            rel.r_pcrel = 0;
                            rel.r_length = 2;
                            rel.r_extern = 0;
                            rel.r_type = GENERIC_RELOC_VANILLA;
                            if (I64)
                            {
                                rel.r_type = X86_64_RELOC_UNSIGNED;
                                rel.r_length = 3;
                                if (0 && s.Sseg != seg)
                                    rel.r_type = X86_64_RELOC_BRANCH;
                            }
                            fobjbuf.пиши(&rel, rel.sizeof);
                            foffset += rel.sizeof;
                            nreloc++;
                            if (I64)
                            {
                                rel.r_length = 3;
                                int32_t *p = patchAddr64(seg, r.смещение);
                                // Absolute address; add in addr of start of targ seg
                                *p += SecHdrTab64[SegData[s.Sseg].SDshtidx].addr + s.Soffset;
                                //patch(pseg, r.смещение, s.Sseg, s.Soffset);
                            }
                            else
                            {
                                int32_t *p = patchAddr(seg, r.смещение);
                                // Absolute address; add in addr of start of targ seg
                                *p += SecHdrTab[SegData[s.Sseg].SDshtidx].addr + s.Soffset;
                                //patch(pseg, r.смещение, s.Sseg, s.Soffset);
                            }
                            continue;
                        }
                    }
                }
                else if (r.rtype == RELaddr && pseg.isCode())
                {
                    srel.r_scattered = 1;

                    srel.r_address = cast(бцел)r.смещение;
                    srel.r_length = 2;
                    if (I64)
                    {
                        int32_t *p64 = patchAddr64(seg, r.смещение);
                        srel.r_type = X86_64_RELOC_GOT;
                        srel.r_value = cast(цел)(SecHdrTab64[SegData[r.targseg].SDshtidx].addr + *p64);
                        //printf("SECTDIFF: x%llx + x%llx = x%x\n", SecHdrTab[SegData[r.targseg].SDshtidx].addr, *p, srel.r_value);
                    }
                    else
                    {
                        int32_t *p = patchAddr(seg, r.смещение);
                        srel.r_type = GENERIC_RELOC_LOCAL_SECTDIFF;
                        srel.r_value = SecHdrTab[SegData[r.targseg].SDshtidx].addr + *p;
                        //printf("SECTDIFF: x%x + x%x = x%x\n", SecHdrTab[SegData[r.targseg].SDshtidx].addr, *p, srel.r_value);
                    }
                    srel.r_pcrel = 0;
                    fobjbuf.пиши(&srel, srel.sizeof);
                    foffset += srel.sizeof;
                    nreloc++;

                    srel.r_address = 0;
                    srel.r_length = 2;
                    if (I64)
                    {
                        srel.r_type = X86_64_RELOC_SIGNED;
                        srel.r_value = cast(цел)(SecHdrTab64[pseg.SDshtidx].addr +
                                r.funcsym.Slocalgotoffset + _tysize[TYnptr]);
                    }
                    else
                    {
                        srel.r_type = GENERIC_RELOC_PAIR;
                        if (r.funcsym)
                            srel.r_value = cast(цел)(SecHdrTab[pseg.SDshtidx].addr +
                                    r.funcsym.Slocalgotoffset + _tysize[TYnptr]);
                        else
                            srel.r_value = cast(цел)(psechdr.addr + r.смещение);
                        //printf("srel.r_value = x%x, psechdr.addr = x%x, r.смещение = x%x\n",
                            //cast(цел)srel.r_value, cast(цел)psechdr.addr, cast(цел)r.смещение);
                    }
                    srel.r_pcrel = 0;
                    fobjbuf.пиши(&srel, srel.sizeof);
                    foffset += srel.sizeof;
                    nreloc++;

                    // Recalc due to possible realloc of fobjbuf.буф
                    if (I64)
                    {
                        int32_t *p64 = patchAddr64(seg, r.смещение);
                        //printf("address = x%x, p64 = %p *p64 = x%llx\n", r.смещение, p64, *p64);
                        *p64 += SecHdrTab64[SegData[r.targseg].SDshtidx].addr -
                              (SecHdrTab64[pseg.SDshtidx].addr + r.funcsym.Slocalgotoffset + _tysize[TYnptr]);
                    }
                    else
                    {
                        int32_t *p = patchAddr(seg, r.смещение);
                        //printf("address = x%x, p = %p *p = x%x\n", r.смещение, p, *p);
                        if (r.funcsym)
                            *p += SecHdrTab[SegData[r.targseg].SDshtidx].addr -
                                  (SecHdrTab[pseg.SDshtidx].addr + r.funcsym.Slocalgotoffset + _tysize[TYnptr]);
                        else
                            // targ_address - fixup_address
                            *p += SecHdrTab[SegData[r.targseg].SDshtidx].addr -
                                  (psechdr.addr + r.смещение);
                    }
                    continue;
                }
                else
                {
                    rel.r_address = cast(цел)r.смещение;
                    rel.r_symbolnum = r.targseg;
                    rel.r_pcrel = (r.rtype == RELaddr) ? 0 : 1;
                    rel.r_length = 2;
                    rel.r_extern = 0;
                    rel.r_type = GENERIC_RELOC_VANILLA;
                    if (I64)
                    {
                        rel.r_type = X86_64_RELOC_UNSIGNED;
                        rel.r_length = 3;
                        if (0 && r.targseg != seg)
                            rel.r_type = X86_64_RELOC_BRANCH;
                    }
                    fobjbuf.пиши(&rel, rel.sizeof);
                    foffset += rel.sizeof;
                    nreloc++;
                    if (I64)
                    {
                        int32_t *p64 = patchAddr64(seg, r.смещение);
                        //int64_t before = *p64;
                        if (rel.r_pcrel)
                            // Relative address
                            patch(pseg, r.смещение, r.targseg, 0);
                        else
                        {   // Absolute address; add in addr of start of targ seg
//printf("*p = x%x, targ.addr = x%x\n", *p64, cast(цел)SecHdrTab64[SegData[r.targseg].SDshtidx].addr);
//printf("pseg = x%x, r.смещение = x%x\n", cast(цел)SecHdrTab64[pseg.SDshtidx].addr, cast(цел)r.смещение);
                            *p64 += SecHdrTab64[SegData[r.targseg].SDshtidx].addr;
                            //*p64 -= SecHdrTab64[pseg.SDshtidx].addr;
                        }
                        //printf("%d:x%04x before = x%04llx, after = x%04llx pcrel = %d\n", seg, r.смещение, before, *p64, rel.r_pcrel);
                    }
                    else
                    {
                        int32_t *p = patchAddr(seg, r.смещение);
                        //int32_t before = *p;
                        if (rel.r_pcrel)
                            // Relative address
                            patch(pseg, r.смещение, r.targseg, 0);
                        else
                            // Absolute address; add in addr of start of targ seg
                            *p += SecHdrTab[SegData[r.targseg].SDshtidx].addr;
                        //printf("%d:x%04x before = x%04x, after = x%04x pcrel = %d\n", seg, r.смещение, before, *p, rel.r_pcrel);
                    }
                    continue;
                }
            }
        }
        if (nreloc)
        {
            if (I64)
            {
                psechdr64.reloff = reloff;
                psechdr64.nreloc = nreloc;
            }
            else
            {
                psechdr.reloff = reloff;
                psechdr.nreloc = nreloc;
            }
        }
    }

    // Put out symbol table
    foffset = elf_align(I64 ? 8 : 4, foffset);
    symtab_cmd.symoff = foffset;
    dysymtab_cmd.ilocalsym = 0;
    dysymtab_cmd.nlocalsym  = cast(бцел)(local_symbuf.size() / (Symbol *).sizeof);
    dysymtab_cmd.iextdefsym = dysymtab_cmd.nlocalsym;
    dysymtab_cmd.nextdefsym = cast(бцел)(public_symbuf.size() / (Symbol *).sizeof);
    dysymtab_cmd.iundefsym = dysymtab_cmd.iextdefsym + dysymtab_cmd.nextdefsym;
    цел nexterns = cast(цел)(extern_symbuf.size() / (Symbol *).sizeof);
    цел ncomdefs = cast(цел)(comdef_symbuf.size() / Comdef.sizeof);
    dysymtab_cmd.nundefsym  = nexterns + ncomdefs;
    symtab_cmd.nsyms =  dysymtab_cmd.nlocalsym +
                        dysymtab_cmd.nextdefsym +
                        dysymtab_cmd.nundefsym;
    fobjbuf.резервируй(cast(бцел)(symtab_cmd.nsyms * (I64 ? nlist_64.sizeof : nlist.sizeof)));
    for (цел i = 0; i < dysymtab_cmd.nlocalsym; i++)
    {   Symbol *s = (cast(Symbol **)local_symbuf.буф)[i];
        nlist_64 sym = проц;
        sym.n_strx = elf_addmangled(s);
        sym.n_type = N_SECT;
        sym.n_desc = 0;
        if (s.Sclass == SCcomdat)
            sym.n_desc = N_WEAK_DEF;
        sym.n_sect = cast(ббайт)s.Sseg;
        if (I64)
        {
            sym.n_value = s.Soffset + SecHdrTab64[SegData[s.Sseg].SDshtidx].addr;
            fobjbuf.пиши(&sym, sym.sizeof);
        }
        else
        {
            nlist sym32 = проц;
            sym32.n_strx = sym.n_strx;
            sym32.n_value = cast(бцел)(s.Soffset + SecHdrTab[SegData[s.Sseg].SDshtidx].addr);
            sym32.n_type = sym.n_type;
            sym32.n_desc = sym.n_desc;
            sym32.n_sect = sym.n_sect;
            fobjbuf.пиши(&sym32, sym32.sizeof);
        }
    }
    for (цел i = 0; i < dysymtab_cmd.nextdefsym; i++)
    {   Symbol *s = (cast(Symbol **)public_symbuf.буф)[i];

        //printf("Writing public symbol %d:x%x %s\n", s.Sseg, s.Soffset, s.Sident);
        nlist_64 sym = проц;
        sym.n_strx = elf_addmangled(s);
        sym.n_type = N_EXT | N_SECT;
        if (s.Sflags & SFLhidden)
            sym.n_type |= N_PEXT; // private extern
        sym.n_desc = 0;
        if (s.Sclass == SCcomdat)
            sym.n_desc = N_WEAK_DEF;
        sym.n_sect = cast(ббайт)s.Sseg;
        if (I64)
        {
            sym.n_value = s.Soffset + SecHdrTab64[SegData[s.Sseg].SDshtidx].addr;
            fobjbuf.пиши(&sym, sym.sizeof);
        }
        else
        {
            nlist sym32 = проц;
            sym32.n_strx = sym.n_strx;
            sym32.n_value = cast(бцел)(s.Soffset + SecHdrTab[SegData[s.Sseg].SDshtidx].addr);
            sym32.n_type = sym.n_type;
            sym32.n_desc = sym.n_desc;
            sym32.n_sect = sym.n_sect;
            fobjbuf.пиши(&sym32, sym32.sizeof);
        }
    }
    for (цел i = 0; i < nexterns; i++)
    {   Symbol *s = (cast(Symbol **)extern_symbuf.буф)[i];
        nlist_64 sym = проц;
        sym.n_strx = elf_addmangled(s);
        sym.n_value = s.Soffset;
        sym.n_type = N_EXT | N_UNDF;
        sym.n_desc = tyfunc(s.ty()) ? REFERENCE_FLAG_UNDEFINED_LAZY
                                     : REFERENCE_FLAG_UNDEFINED_NON_LAZY;
        sym.n_sect = 0;
        if (I64)
            fobjbuf.пиши(&sym, sym.sizeof);
        else
        {
            nlist sym32 = проц;
            sym32.n_strx = sym.n_strx;
            sym32.n_value = cast(бцел)sym.n_value;
            sym32.n_type = sym.n_type;
            sym32.n_desc = sym.n_desc;
            sym32.n_sect = sym.n_sect;
            fobjbuf.пиши(&sym32, sym32.sizeof);
        }
    }
    for (цел i = 0; i < ncomdefs; i++)
    {   Comdef *c = (cast(Comdef *)comdef_symbuf.буф) + i;
        nlist_64 sym = проц;
        sym.n_strx = elf_addmangled(c.sym);
        sym.n_value = c.size * c.count;
        sym.n_type = N_EXT | N_UNDF;
        цел align_;
        if (c.size < 2)
            align_ = 0;          // align_ is expressed as power of 2
        else if (c.size < 4)
            align_ = 1;
        else if (c.size < 8)
            align_ = 2;
        else if (c.size < 16)
            align_ = 3;
        else
            align_ = 4;
        sym.n_desc = cast(ushort)(align_ << 8);
        sym.n_sect = 0;
        if (I64)
            fobjbuf.пиши(&sym, sym.sizeof);
        else
        {
            nlist sym32 = проц;
            sym32.n_strx = sym.n_strx;
            sym32.n_value = cast(бцел)sym.n_value;
            sym32.n_type = sym.n_type;
            sym32.n_desc = sym.n_desc;
            sym32.n_sect = sym.n_sect;
            fobjbuf.пиши(&sym32, sym32.sizeof);
        }
    }
    if (extdef)
    {
        nlist_64 sym = проц;
        sym.n_strx = extdef;
        sym.n_value = 0;
        sym.n_type = N_EXT | N_UNDF;
        sym.n_desc = 0;
        sym.n_sect = 0;
        if (I64)
            fobjbuf.пиши(&sym, sym.sizeof);
        else
        {
            nlist sym32 = проц;
            sym32.n_strx = sym.n_strx;
            sym32.n_value = cast(бцел)sym.n_value;
            sym32.n_type = sym.n_type;
            sym32.n_desc = sym.n_desc;
            sym32.n_sect = sym.n_sect;
            fobjbuf.пиши(&sym32, sym32.sizeof);
        }
        symtab_cmd.nsyms++;
    }
    foffset += symtab_cmd.nsyms * (I64 ? nlist_64.sizeof : nlist.sizeof);

    // Put out ткст table
    foffset = elf_align(I64 ? 8 : 4, foffset);
    symtab_cmd.stroff = foffset;
    symtab_cmd.strsize = cast(бцел)symtab_strings.size();
    fobjbuf.пиши(symtab_strings.буф, symtab_cmd.strsize);
    foffset += symtab_cmd.strsize;

    // Put out indirectsym table, which is in two parts
    foffset = elf_align(I64 ? 8 : 4, foffset);
    dysymtab_cmd.indirectsymoff = foffset;
    if (indirectsymbuf1)
    {   dysymtab_cmd.nindirectsyms += indirectsymbuf1.size() / (Symbol *).sizeof;
        for (цел i = 0; i < dysymtab_cmd.nindirectsyms; i++)
        {   Symbol *s = (cast(Symbol **)indirectsymbuf1.буф)[i];
            fobjbuf.write32(s.Sxtrnnum);
        }
    }
    if (indirectsymbuf2)
    {   цел n = cast(цел)(indirectsymbuf2.size() / (Symbol *).sizeof);
        dysymtab_cmd.nindirectsyms += n;
        for (цел i = 0; i < n; i++)
        {   Symbol *s = (cast(Symbol **)indirectsymbuf2.буф)[i];
            fobjbuf.write32(s.Sxtrnnum);
        }
    }
    foffset += dysymtab_cmd.nindirectsyms * 4;

    /* The correct offsets are now determined, so
     * rewind and fix the header.
     */
    fobjbuf.position(headersize, sizeofcmds);
    if (I64)
    {
        fobjbuf.пиши(&segment_cmd64, segment_cmd64.sizeof);
        fobjbuf.пиши(SECbuf.буф + section_64.sizeof, cast(бцел)((section_cnt - 1) * section_64.sizeof));
    }
    else
    {
        fobjbuf.пиши(&segment_cmd, segment_cmd.sizeof);
        fobjbuf.пиши(SECbuf.буф + section.sizeof, cast(бцел)((section_cnt - 1) * section.sizeof));
    }
    fobjbuf.пиши(&symtab_cmd, symtab_cmd.sizeof);
    fobjbuf.пиши(&dysymtab_cmd, dysymtab_cmd.sizeof);
    fobjbuf.position(foffset, 0);
    fobjbuf.flush();
}

/*****************************
 * Line number support.
 */

/***************************
 * Record файл and line number at segment and смещение.
 * The actual .debug_line segment is put out by dwarf_termfile().
 * Параметры:
 *      srcpos = source файл position
 *      seg = segment it corresponds to
 *      смещение = смещение within seg
 */

проц Obj_linnum(Srcpos srcpos, цел seg, targ_т_мера смещение)
{
    if (srcpos.Slinnum == 0)
        return;

static if (0)
{
    printf("Obj_linnum(seg=%d, смещение=x%lx) ", seg, смещение);
    srcpos.print("");
}

version (Dinrus)
{
    if (!srcpos.Sfilename)
        return;
}
version (SCPP)
{
    if (!srcpos.Sfilptr)
        return;
    sfile_debug(&srcpos_sfile(srcpos));
    Sfile *sf = *srcpos.Sfilptr;
}

    т_мера i;
    seg_data *pseg = SegData[seg];

    // Find entry i in SDlinnum_data[] that corresponds to srcpos имяф
    for (i = 0; 1; i++)
    {
        if (i == pseg.SDlinnum_count)
        {   // Create new entry
            if (pseg.SDlinnum_count == pseg.SDlinnum_max)
            {   // Enlarge массив
                бцел newmax = pseg.SDlinnum_max * 2 + 1;
                //printf("realloc %d\n", newmax * linnum_data.sizeof);
                pseg.SDlinnum_data = cast(linnum_data *)mem_realloc(
                    pseg.SDlinnum_data, newmax * linnum_data.sizeof);
                memset(pseg.SDlinnum_data + pseg.SDlinnum_max, 0,
                    (newmax - pseg.SDlinnum_max) * linnum_data.sizeof);
                pseg.SDlinnum_max = newmax;
            }
            pseg.SDlinnum_count++;
version (Dinrus)
{
            pseg.SDlinnum_data[i].имяф = srcpos.Sfilename;
}
version (SCPP)
{
            pseg.SDlinnum_data[i].filptr = sf;
}
            break;
        }
version (Dinrus)
{
        if (pseg.SDlinnum_data[i].имяф == srcpos.Sfilename)
            break;
}
version (SCPP)
{
        if (pseg.SDlinnum_data[i].filptr == sf)
            break;
}
    }

    linnum_data *ld = &pseg.SDlinnum_data[i];
//    printf("i = %d, ld = x%x\n", i, ld);
    if (ld.linoff_count == ld.linoff_max)
    {
        if (!ld.linoff_max)
            ld.linoff_max = 8;
        ld.linoff_max *= 2;
        ld.linoff = cast(бцел[2]*)mem_realloc(ld.linoff, ld.linoff_max * бцел.sizeof * 2);
    }
    ld.linoff[ld.linoff_count][0] = srcpos.Slinnum;
    ld.linoff[ld.linoff_count][1] = cast(бцел)смещение;
    ld.linoff_count++;
}


/*******************************
 * Set start address
 */

проц Obj_startaddress(Symbol *s)
{
    //dbg_printf("Obj_startaddress(Symbol *%s)\n",s.Sident);
    //obj.startaddress = s;
}

/*******************************
 * Output library имя.
 */

бул Obj_includelib(ткст0 имя)
{
    //dbg_printf("Obj_includelib(имя *%s)\n",имя);
    return нет;
}

/*******************************
* Output linker directive.
*/

бул Obj_linkerdirective(ткст0 имя)
{
    return нет;
}

/**********************************
 * Do we allow нуль sized objects?
 */

бул Obj_allowZeroSize()
{
    return да;
}

/**************************
 * Embed ткст in executable.
 */

проц Obj_exestr(ткст0 p)
{
    //dbg_printf("Obj_exestr(сим *%s)\n",p);
}

/**************************
 * Embed ткст in obj.
 */

проц Obj_user(ткст0 p)
{
    //dbg_printf("Obj_user(сим *%s)\n",p);
}

/*******************************
 * Output a weak extern record.
 */

проц Obj_wkext(Symbol *s1,Symbol *s2)
{
    //dbg_printf("Obj_wkext(Symbol *%s,Symbol *s2)\n",s1.Sident.ptr,s2.Sident.ptr);
}

/*******************************
 * Output файл имя record.
 *
 * Currently assumes that obj_filename will not be called
 *      twice for the same файл.
 */

проц obj_filename(ткст0 modname)
{
    //dbg_printf("obj_filename(сим *%s)\n",modname);
    // Not supported by Mach-O
}

/*******************************
 * Embed compiler version in .obj файл.
 */

проц Obj_compiler()
{
    //dbg_printf("Obj_compiler\n");
}


/**************************************
 * Symbol is the function that calls the static constructors.
 * Put a pointer to it into a special segment that the startup code
 * looks at.
 * Input:
 *      s       static constructor function
 *      dtor    !=0 if leave space for static destructor
 *      seg     1:      user
 *              2:      lib
 *              3:      compiler
 */

проц Obj_staticctor(Symbol *s, цел, цел)
{
    Obj_setModuleCtorDtor(s, да);
}

/**************************************
 * Symbol is the function that calls the static destructors.
 * Put a pointer to it into a special segment that the exit code
 * looks at.
 * Input:
 *      s       static destructor function
 */

проц Obj_staticdtor(Symbol *s)
{
    Obj_setModuleCtorDtor(s, нет);
}


/***************************************
 * Stuff pointer to function in its own segment.
 * Used for static ctor and dtor lists.
 */

проц Obj_setModuleCtorDtor(Symbol *sfunc, бул isCtor)
{
    ткст0 secname = isCtor ? "__mod_init_func" : "__mod_term_func";
    const цел align_ = I64 ? 3 : 2; // align to _tysize[TYnptr]
    const цел flags = isCtor ? S_MOD_INIT_FUNC_POINTERS : S_MOD_TERM_FUNC_POINTERS;
    IDXSEC seg = Obj_getsegment(secname, "__DATA", align_, flags);

    const цел relflags = I64 ? CFoff | CFoffset64 : CFoff;
    const цел sz = Obj_reftoident(seg, SegData[seg].SDoffset, sfunc, 0, relflags);
    SegData[seg].SDoffset += sz;
}


/***************************************
 * Stuff the following данные (instance of struct FuncTable) in a separate segment:
 *      pointer to function
 *      pointer to ehsym
 *      length of function
 */

проц Obj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
{
    //dbg_printf("Obj_ehtables(%s) \n",sfunc.Sident.ptr);

    /* BUG: this should go into a COMDAT if sfunc is in a COMDAT
     * otherwise the duplicates aren't removed.
     */

    цел align_ = I64 ? 3 : 2;            // align to _tysize[TYnptr]
    // The size is (FuncTable).sizeof in deh2.d
    цел seg = Obj_getsegment("__deh_eh", "__DATA", align_, S_REGULAR);

    Outbuffer *буф = SegData[seg].SDbuf;
    if (I64)
    {   Obj_reftoident(seg, буф.size(), sfunc, 0, CFoff | CFoffset64);
        Obj_reftoident(seg, буф.size(), ehsym, 0, CFoff | CFoffset64);
        буф.write64(sfunc.Ssize);
    }
    else
    {   Obj_reftoident(seg, буф.size(), sfunc, 0, CFoff);
        Obj_reftoident(seg, буф.size(), ehsym, 0, CFoff);
        буф.write32(cast(цел)sfunc.Ssize);
    }
}

/*********************************************
 * Put out symbols that define the beginning/end of the .deh_eh section.
 * This gets called if this is the module with "main()" in it.
 */

проц Obj_ehsections()
{
    //printf("Obj_ehsections()\n");
}

/*********************************
 * Setup for Symbol s to go into a COMDAT segment.
 * Output (if s is a function):
 *      cseg            segment index of new current code segment
 *      Offset(cseg)         starting смещение in cseg
 * Возвращает:
 *      "segment index" of COMDAT
 */

цел Obj_comdatsize(Symbol *s, targ_т_мера symsize)
{
    return Obj_comdat(s);
}

цел Obj_comdat(Symbol *s)
{
    ткст0 sectname;
    ткст0 segname;
    цел align_;
    цел flags;

    //printf("Obj_comdat(Symbol* %s)\n",s.Sident.ptr);
    //symbol_print(s);
    symbol_debug(s);

    if (tyfunc(s.ty()))
    {
        sectname = "__textcoal_nt";
        segname = "__TEXT";
        align_ = 2;              // 4 byte alignment
        flags = S_COALESCED | S_ATTR_PURE_INSTRUCTIONS | S_ATTR_SOME_INSTRUCTIONS;
        s.Sseg = Obj_getsegment(sectname, segname, align_, flags);
    }
    else if ((s.ty() & mTYLINK) == mTYthread)
    {
        s.Sfl = FLtlsdata;
        align_ = 4;
        if (I64)
            s.Sseg = objmod.tlsseg().SDseg;
        else
            s.Sseg = Obj_getsegment("__tlscoal_nt", "__DATA", align_, S_COALESCED);
        Obj_data_start(s, 1 << align_, s.Sseg);
    }
    else
    {
        s.Sfl = FLdata;
        sectname = "__datacoal_nt";
        segname = "__DATA";
        align_ = 4;              // 16 byte alignment
        s.Sseg = Obj_getsegment(sectname, segname, align_, S_COALESCED);
        Obj_data_start(s, 1 << align_, s.Sseg);
    }
                                // найди or создай new segment
    if (s.Salignment > (1 << align_))
        SegData[s.Sseg].SDalignment = s.Salignment;
    s.Soffset = SegData[s.Sseg].SDoffset;
    if (s.Sfl == FLdata || s.Sfl == FLtlsdata)
    {   // Code symbols are 'published' by Obj_func_start()

        Obj_pubdef(s.Sseg,s,s.Soffset);
        searchfixlist(s);               // backpatch any refs to this symbol
    }
    return s.Sseg;
}

цел Obj_readonly_comdat(Symbol *s)
{
    assert(0);
}

/***********************************
 * Возвращает:
 *      jump table segment for function s
 */
цел Obj_jmpTableSegment(Symbol *s)
{
    return (config.flags & CFGromable) ? cseg : CDATA;
}

/**********************************
 * Get segment.
 * Input:
 *      align_   segment alignment as power of 2
 * Возвращает:
 *      segment index of found or newly created segment
 */

цел Obj_getsegment(ткст0 sectname, ткст0 segname,
        цел align_, цел flags)
{
    assert(strlen(sectname) <= 16);
    assert(strlen(segname)  <= 16);
    for (цел seg = 1; seg <= seg_count; seg++)
    {   seg_data *pseg = SegData[seg];
        if (I64)
        {
            if (strncmp(SecHdrTab64[pseg.SDshtidx].sectname.ptr, sectname, 16) == 0 &&
                strncmp(SecHdrTab64[pseg.SDshtidx].segname.ptr, segname, 16) == 0)
                return seg;         // return existing segment
        }
        else
        {
            if (strncmp(SecHdrTab[pseg.SDshtidx].sectname.ptr, sectname, 16) == 0 &&
                strncmp(SecHdrTab[pseg.SDshtidx].segname.ptr, segname, 16) == 0)
                return seg;         // return existing segment
        }
    }

    цел seg = ++seg_count;
    if (seg_count >= seg_max)
    {                           // need more room in segment table
        seg_max += 10;
        SegData = cast(seg_data **)mem_realloc(SegData,seg_max * (seg_data *).sizeof);
        memset(&SegData[seg_count], 0, (seg_max - seg_count) * (seg_data *).sizeof);
    }
    assert(seg_count < seg_max);
    if (SegData[seg])
    {   seg_data *pseg = SegData[seg];
        Outbuffer *b1 = pseg.SDbuf;
        Outbuffer *b2 = pseg.SDrel;
        memset(pseg, 0, seg_data.sizeof);
        if (b1)
            b1.устРазм(0);
        if (b2)
            b2.устРазм(0);
        pseg.SDbuf = b1;
        pseg.SDrel = b2;
    }
    else
    {
        seg_data *pseg = cast(seg_data *)mem_calloc(seg_data.sizeof);
        SegData[seg] = pseg;
        if (flags != S_ZEROFILL)
        {
            pseg.SDbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(pseg.SDbuf);
            pseg.SDbuf.enlarge(4096);

            pseg.SDbuf.резервируй(4096);
        }
    }

    //dbg_printf("\tNew segment - %d size %d\n", seg,SegData[seg].SDbuf);
    seg_data *pseg = SegData[seg];

    pseg.SDseg = seg;
    pseg.SDoffset = 0;

    if (I64)
    {
        section_64 *sec = cast(section_64 *)
            SECbuf.writezeros(section_64.sizeof);
        strncpy(sec.sectname.ptr, sectname, 16);
        strncpy(sec.segname.ptr, segname, 16);
        sec._align = align_;
        sec.flags = flags;
    }
    else
    {
        section *sec = cast(section *)
            SECbuf.writezeros(section.sizeof);
        strncpy(sec.sectname.ptr, sectname, 16);
        strncpy(sec.segname.ptr, segname, 16);
        sec._align = align_;
        sec.flags = flags;
    }

    pseg.SDshtidx = section_cnt++;
    pseg.SDaranges_offset = 0;
    pseg.SDlinnum_count = 0;

    //printf("seg_count = %d\n", seg_count);
    return seg;
}

/**********************************
 * Reset code seg to existing seg.
 * Used after a COMDAT for a function is done.
 */

проц Obj_setcodeseg(цел seg)
{
    cseg = seg;
}

/********************************
 * Define a new code segment.
 * Input:
 *      имя            имя of segment, if null then revert to default
 *      suffix  0       use имя as is
 *              1       приставь "_TEXT" to имя
 * Output:
 *      cseg            segment index of new current code segment
 *      Offset(cseg)         starting смещение in cseg
 * Возвращает:
 *      segment index of newly created code segment
 */

цел Obj_codeseg( сим *имя,цел suffix)
{
    //dbg_printf("Obj_codeseg(%s,%x)\n",имя,suffix);
static if (0)
{
    ткст0 sfx = (suffix) ? "_TEXT" : null;

    if (!имя)                          // returning to default code segment
    {
        if (cseg != CODE)               // not the current default
        {
            SegData[cseg].SDoffset = Offset(cseg);
            Offset(cseg) = SegData[CODE].SDoffset;
            cseg = CODE;
        }
        return cseg;
    }

    цел seg = ElfObj_getsegment(имя, sfx, SHT_PROGDEF, SHF_ALLOC|SHF_EXECINSTR, 4);
                                    // найди or создай code segment

    cseg = seg;                         // new code segment index
    Offset(cseg) = 0;
    return seg;
}
else
{
    return 0;
}
}

/*********************************
 * Define segments for Thread Local Storage for 32bit.
 * Output:
 *      seg_tlsseg      set to segment number for TLS segment.
 * Возвращает:
 *      segment for TLS segment
 */

seg_data *Obj_tlsseg()
{
    //printf("Obj_tlsseg(\n");
    if (I32)
    {
        if (seg_tlsseg == UNKNOWN)
            seg_tlsseg = Obj_getsegment("__tls_data", "__DATA", 2, S_REGULAR);
        return SegData[seg_tlsseg];
    }
    else
    {
        if (seg_tlsseg == UNKNOWN)
            seg_tlsseg = Obj_getsegment("__thread_vars", "__DATA", 0, S_THREAD_LOCAL_VARIABLES);
        return SegData[seg_tlsseg];
    }
}


/*********************************
 * Define segments for Thread Local Storage.
 * Output:
 *      seg_tlsseg_bss  set to segment number for TLS segment.
 * Возвращает:
 *      segment for TLS segment
 */

seg_data *Obj_tlsseg_bss()
{

    if (I32)
    {
        /* Because DMD does not support native tls for Mach-O 32bit,
         * it's easier to support if we have all the tls in one segment.
         */
        return Obj_tlsseg();
    }
    else
    {
        // The alignment should actually be alignment of the largest variable in
        // the section, but this seems to work anyway.
        if (seg_tlsseg_bss == UNKNOWN)
            seg_tlsseg_bss = Obj_getsegment("__thread_bss", "__DATA", 3, S_THREAD_LOCAL_ZEROFILL);
        return SegData[seg_tlsseg_bss];
    }
}

/*********************************
 * Define segments for Thread Local Storage данные.
 * Output:
 *      seg_tlsseg_data    set to segment number for TLS данные segment.
 * Возвращает:
 *      segment for TLS данные segment
 */

seg_data *Obj_tlsseg_data()
{
    //printf("Obj_tlsseg_data(\n");
    assert(I64);

    // The alignment should actually be alignment of the largest variable in
    // the section, but this seems to work anyway.
    if (seg_tlsseg_data == UNKNOWN)
        seg_tlsseg_data = Obj_getsegment("__thread_data", "__DATA", 4, S_THREAD_LOCAL_REGULAR);
    return SegData[seg_tlsseg_data];
}

/*******************************
 * Output an alias definition record.
 */

проц Obj_alias(ткст0 n1,ткст0 n2)
{
    //printf("Obj_alias(%s,%s)\n",n1,n2);
    assert(0);
static if (0)
{
    бцел len;
    сим *буфер;

    буфер = cast(сим *) alloca(strlen(n1) + strlen(n2) + 2 * ONS_OHD);
    len = obj_namestring(буфер,n1);
    len += obj_namestring(буфер + len,n2);
    objrecord(ALIAS,буфер,len);
}
}

сим *unsstr (бцел значение)
{
     сим[64] буфер = проц;

    sprintf (буфер.ptr, "%d", значение);
    return буфер.ptr;
}

/*******************************
 * Mangle a имя.
 * Возвращает:
 *      mangled имя
 */

сим *obj_mangle2(Symbol *s,сим *dest)
{
    т_мера len;
    сим *имя;

    //printf("Obj_mangle(s = %p, '%s'), mangle = x%x\n",s,s.Sident.ptr,type_mangle(s.Stype));
    symbol_debug(s);
    assert(dest);
version (SCPP)
{
    имя = CPP ? cpp_mangle(s) : s.Sident.ptr;
}
else version (Dinrus)
{
    // C++ имя mangling is handled by front end
    имя = s.Sident.ptr;
}
else
{
    имя = s.Sident.ptr;
}
    len = strlen(имя);                 // # of bytes in имя
    //dbg_printf("len %d\n",len);
    switch (type_mangle(s.Stype))
    {
        case mTYman_pas:                // if upper case
        case mTYman_for:
            if (len >= DEST_LEN)
                dest = cast(сим *)mem_malloc(len + 1);
            memcpy(dest,имя,len + 1);  // копируй in имя and ending 0
            for (сим *p = dest; *p; p++)
                *p = cast(сим)toupper(*p);
            break;
        case mTYman_std:
        {
static if (TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS)
            бул cond = (tyfunc(s.ty()) && !variadic(s.Stype));
else
            бул cond = (!(config.flags4 & CFG4oldstdmangle) &&
                config.exe == EX_WIN32 && tyfunc(s.ty()) &&
                !variadic(s.Stype));

            if (cond)
            {
                сим *pstr = unsstr(type_paramsize(s.Stype));
                т_мера pstrlen = strlen(pstr);
                т_мера destlen = len + 1 + pstrlen + 1;

                if (destlen > DEST_LEN)
                    dest = cast(сим *)mem_malloc(destlen);
                memcpy(dest,имя,len);
                dest[len] = '@';
                memcpy(dest + 1 + len, pstr, pstrlen + 1);
                break;
            }
            goto case;
        }
        case mTYman_sys:
        case 0:
            if (len >= DEST_LEN)
                dest = cast(сим *)mem_malloc(len + 1);
            memcpy(dest,имя,len+1);// копируй in имя and trailing 0
            break;

        case mTYman_c:
        case mTYman_cpp:
        case mTYman_d:
            if (len >= DEST_LEN - 1)
                dest = cast(сим *)mem_malloc(1 + len + 1);
            dest[0] = '_';
            memcpy(dest + 1,имя,len+1);// копируй in имя and trailing 0
            break;


        default:
debug
{
            printf("mangling %x\n",type_mangle(s.Stype));
            symbol_print(s);
}
            printf("%d\n", type_mangle(s.Stype));
            assert(0);
    }
    //dbg_printf("\t %s\n",dest);
    return dest;
}

/*******************************
 * Export a function имя.
 */

проц Obj_export_symbol(Symbol *s,бцел argsize)
{
    //dbg_printf("Obj_export_symbol(%s,%d)\n",s.Sident.ptr,argsize);
}

/*******************************
 * Update данные information about symbol
 *      align for output and assign segment
 *      if not already specified.
 *
 * Input:
 *      sdata           данные symbol
 *      datasize        output size
 *      seg             default seg if not known
 * Возвращает:
 *      actual seg
 */

цел Obj_data_start(Symbol *sdata, targ_т_мера datasize, цел seg)
{
    targ_т_мера alignbytes;

    //printf("Obj_data_start(%s,size %llu,seg %d)\n",sdata.Sident.ptr,datasize,seg);
    //symbol_print(sdata);

    assert(sdata.Sseg);
    if (sdata.Sseg == UNKNOWN) // if we don't know then there
        sdata.Sseg = seg;      // wasn't any segment override
    else
        seg = sdata.Sseg;
    targ_т_мера смещение = Offset(seg);
    if (sdata.Salignment > 0)
    {   if (SegData[seg].SDalignment < sdata.Salignment)
            SegData[seg].SDalignment = sdata.Salignment;
        alignbytes = ((смещение + sdata.Salignment - 1) & ~(sdata.Salignment - 1)) - смещение;
    }
    else
        alignbytes = _align(datasize, смещение) - смещение;
    if (alignbytes)
        Obj_lidata(seg, смещение, alignbytes);
    sdata.Soffset = смещение + alignbytes;
    return seg;
}

/*******************************
 * Update function info before codgen
 *
 * If code for this function is in a different segment
 * than the current default in cseg, switch cseg to new segment.
 */

проц Obj_func_start(Symbol *sfunc)
{
    //printf("Obj_func_start(%s)\n",sfunc.Sident.ptr);
    symbol_debug(sfunc);

    assert(sfunc.Sseg);
    if (sfunc.Sseg == UNKNOWN)
        sfunc.Sseg = CODE;
    //printf("sfunc.Sseg %d CODE %d cseg %d Coffset x%x\n",sfunc.Sseg,CODE,cseg,Offset(cseg));
    cseg = sfunc.Sseg;
    assert(cseg == CODE || cseg > UDATA);
    Obj_pubdef(cseg, sfunc, Offset(cseg));
    sfunc.Soffset = Offset(cseg);

    dwarf_func_start(sfunc);
}

/*******************************
 * Update function info after codgen
 */

проц Obj_func_term(Symbol *sfunc)
{
    //dbg_printf("Obj_func_term(%s) смещение %x, Coffset %x symidx %d\n",
//          sfunc.Sident.ptr, sfunc.Soffset,Offset(cseg),sfunc.Sxtrnnum);

static if (0)
{
    // fill in the function size
    if (I64)
        SymbolTable64[sfunc.Sxtrnnum].st_size = Offset(cseg) - sfunc.Soffset;
    else
        SymbolTable[sfunc.Sxtrnnum].st_size = Offset(cseg) - sfunc.Soffset;
}
    dwarf_func_term(sfunc);
}

/********************************
 * Output a public definition.
 * Input:
 *      seg =           segment index that symbol is defined in
 *      s .            symbol
 *      смещение =        смещение of имя within segment
 */

проц Obj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
{
    return Obj_pubdef(seg, s, смещение);
}

проц Obj_pubdef(цел seg, Symbol *s, targ_т_мера смещение)
{
    //printf("Obj_pubdef(%d:x%x s=%p, %s)\n", seg, смещение, s, s.Sident.ptr);
    //symbol_print(s);
    symbol_debug(s);

    s.Soffset = смещение;
    s.Sseg = seg;
    switch (s.Sclass)
    {
        case SCglobal:
        case SCinline:
            public_symbuf.пиши((&s)[0 .. 1]);
            break;
        case SCcomdat:
        case SCcomdef:
            public_symbuf.пиши((&s)[0 .. 1]);
            break;
        case SCstatic:
            if (s.Sflags & SFLhidden)
            {
                public_symbuf.пиши((&s)[0 .. 1]);
                break;
            }
            goto default;
        default:
            local_symbuf.пиши((&s)[0 .. 1]);
            break;
    }
    //printf("%p\n", *cast(ук*)public_symbuf.буф);
    s.Sxtrnnum = 1;
}

/*******************************
 * Output an external symbol for имя.
 * Input:
 *      имя    Name to do EXTDEF on
 *              (Not to be mangled)
 * Возвращает:
 *      Symbol table index of the definition
 *      NOTE: Numbers will not be linear.
 */

цел Obj_external_def(ткст0 имя)
{
    //printf("Obj_external_def('%s')\n",имя);
    assert(имя);
    assert(extdef == 0);
    extdef = Obj_addstr(symtab_strings, имя);
    return 0;
}


/*******************************
 * Output an external for existing symbol.
 * Input:
 *      s       Symbol to do EXTDEF on
 *              (Name is to be mangled)
 * Возвращает:
 *      Symbol table index of the definition
 *      NOTE: Numbers will not be linear.
 */

цел Obj_external(Symbol *s)
{
    //printf("Obj_external('%s') %x\n",s.Sident.ptr,s.Svalue);
    symbol_debug(s);
    extern_symbuf.пиши((&s)[0 .. 1]);
    s.Sxtrnnum = 1;
    return 0;
}

/*******************************
 * Output a common block definition.
 * Input:
 *      p .    external идентификатор
 *      size    size in bytes of each elem
 *      count   number of elems
 * Возвращает:
 *      Symbol table index for symbol
 */

цел Obj_common_block(Symbol *s,targ_т_мера size,targ_т_мера count)
{
    //printf("Obj_common_block('%s', size=%d, count=%d)\n",s.Sident.ptr,size,count);
    symbol_debug(s);

    // can't have code or thread local comdef's
    assert(!(s.ty() & (mTYcs | mTYthread)));
    // support for hidden comdefs not implemented
    assert(!(s.Sflags & SFLhidden));

    Comdef comdef = проц;
    comdef.sym = s;
    comdef.size = size;
    comdef.count = cast(цел)count;
    comdef_symbuf.пиши(&comdef, (comdef).sizeof);
    s.Sxtrnnum = 1;
    if (!s.Sseg)
        s.Sseg = UDATA;
    return 0;           // should return проц
}

цел Obj_common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count)
{
    return Obj_common_block(s, size, count);
}

/***************************************
 * Append an iterated данные block of 0s.
 * (uninitialized данные only)
 */

проц Obj_write_zeros(seg_data *pseg, targ_т_мера count)
{
    Obj_lidata(pseg.SDseg, pseg.SDoffset, count);
}

/***************************************
 * Output an iterated данные block of 0s.
 *
 *      For boundary alignment and initialization
 */

проц Obj_lidata(цел seg,targ_т_мера смещение,targ_т_мера count)
{
    //printf("Obj_lidata(%d,%x,%d)\n",seg,смещение,count);
    т_мера idx = SegData[seg].SDshtidx;
    if ((I64 ? SecHdrTab64[idx].flags : SecHdrTab[idx].flags) == S_ZEROFILL)
    {   // Use SDoffset to record size of bss section
        SegData[seg].SDoffset += count;
    }
    else
    {
        Obj_bytes(seg, смещение, cast(бцел)count, null);
    }
}

/***********************************
 * Append byte to segment.
 */

проц Obj_write_byte(seg_data *pseg, бцел byte_)
{
    Obj_byte(pseg.SDseg, pseg.SDoffset, byte_);
}

/************************************
 * Output byte to объект файл.
 */

проц Obj_byte(цел seg,targ_т_мера смещение,бцел byte_)
{
    Outbuffer *буф = SegData[seg].SDbuf;
    цел save = cast(цел)буф.size();
    //dbg_printf("Obj_byte(seg=%d, смещение=x%lx, byte_=x%x)\n",seg,смещение,byte_);
    буф.устРазм(cast(бцел)смещение);
    буф.пишиБайт(byte_);
    if (save > смещение+1)
        буф.устРазм(save);
    else
        SegData[seg].SDoffset = смещение+1;
    //dbg_printf("\tsize now %d\n",буф.size());
}

/***********************************
 * Append bytes to segment.
 */

проц Obj_write_bytes(seg_data *pseg, бцел члобайт, проц *p)
{
    Obj_bytes(pseg.SDseg, pseg.SDoffset, члобайт, p);
}

/************************************
 * Output bytes to объект файл.
 * Возвращает:
 *      члобайт
 */

бцел Obj_bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p)
{
static if (0)
{
    if (!(seg >= 0 && seg <= seg_count))
    {   printf("Obj_bytes: seg = %d, seg_count = %d\n", seg, seg_count);
        *cast(сим*)0=0;
    }
}
    assert(seg >= 0 && seg <= seg_count);
    Outbuffer *буф = SegData[seg].SDbuf;
    if (буф == null)
    {
        //dbg_printf("Obj_bytes(seg=%d, смещение=x%llx, члобайт=%d, p=%p)\n", seg, смещение, члобайт, p);
        //raise(SIGSEGV);
        assert(буф != null);
    }
    цел save = cast(цел)буф.size();
    //dbg_printf("Obj_bytes(seg=%d, смещение=x%lx, члобайт=%d, p=x%x)\n",
            //seg,смещение,члобайт,p);
    буф.position(cast(бцел)смещение, члобайт);
    if (p)
    {
        буф.writen(p,члобайт);
    }
    else
    {   // Zero out the bytes
        буф.clearn(члобайт);
    }
    if (save > смещение+члобайт)
        буф.устРазм(save);
    else
        SegData[seg].SDoffset = смещение+члобайт;
    return члобайт;
}

/*********************************************
 * Add a relocation entry for seg/смещение.
 */

проц Obj_addrel(цел seg, targ_т_мера смещение, Symbol *targsym,
        бцел targseg, цел rtype, цел val = 0)
{
    Relocation rel = проц;
    rel.смещение = смещение;
    rel.targsym = targsym;
    rel.targseg = targseg;
    rel.rtype = cast(ббайт)rtype;
    rel.флаг = 0;
    rel.funcsym = funcsym_p;
    rel.val = cast(short)val;
    seg_data *pseg = SegData[seg];
    if (!pseg.SDrel)
    {
        pseg.SDrel = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(pseg.SDrel);
    }
    pseg.SDrel.пиши(&rel, rel.sizeof);
}

/*******************************
 * Refer to address that is in the данные segment.
 * Input:
 *      seg:смещение =    the address being fixed up
 *      val =           displacement from start of target segment
 *      targetdatum =   target segment number (DATA, CDATA or UDATA, etc.)
 *      flags =         CFoff, CFseg
 * Example:
 *      цел *abc = &def[3];
 *      to размести storage:
 *              Obj_reftodatseg(DATA,смещение,3 * (цел *).sizeof,UDATA);
 */

проц Obj_reftodatseg(цел seg,targ_т_мера смещение,targ_т_мера val,
        бцел targetdatum,цел flags)
{
    Outbuffer *буф = SegData[seg].SDbuf;
    цел save = cast(цел)буф.size();
    буф.устРазм(cast(бцел)смещение);
static if (0)
{
    printf("Obj_reftodatseg(seg:смещение=%d:x%llx, val=x%llx, targetdatum %x, flags %x )\n",
        seg,смещение,val,targetdatum,flags);
}
    assert(seg != 0);
    if (SegData[seg].isCode() && SegData[targetdatum].isCode())
    {
        assert(0);
    }
    Obj_addrel(seg, смещение, null, targetdatum, RELaddr);
    if (I64)
    {
        if (flags & CFoffset64)
        {
            буф.write64(val);
            if (save > смещение + 8)
                буф.устРазм(save);
            return;
        }
    }
    буф.write32(cast(цел)val);
    if (save > смещение + 4)
        буф.устРазм(save);
}

/*******************************
 * Refer to address that is in the current function code (funcsym_p).
 * Only offsets are output, regardless of the memory model.
 * Used to put values in switch address tables.
 * Input:
 *      seg =           where the address is going (CODE or DATA)
 *      смещение =        смещение within seg
 *      val =           displacement from start of this module
 */

проц Obj_reftocodeseg(цел seg,targ_т_мера смещение,targ_т_мера val)
{
    //printf("Obj_reftocodeseg(seg=%d, смещение=x%lx, val=x%lx )\n",seg,cast(бцел)смещение,cast(бцел)val);
    assert(seg > 0);
    Outbuffer *буф = SegData[seg].SDbuf;
    цел save = cast(цел)буф.size();
    буф.устРазм(cast(бцел)смещение);
    val -= funcsym_p.Soffset;
    Obj_addrel(seg, смещение, funcsym_p, 0, RELaddr);
//    if (I64)
//        буф.write64(val);
//    else
        буф.write32(cast(цел)val);
    if (save > смещение + 4)
        буф.устРазм(save);
}

/*******************************
 * Refer to an идентификатор.
 * Input:
 *      seg =   where the address is going (CODE or DATA)
 *      смещение =        смещение within seg
 *      s .            Symbol table entry for идентификатор
 *      val =           displacement from идентификатор
 *      flags =         CFselfrel: self-relative
 *                      CFseg: get segment
 *                      CFoff: get смещение
 *                      CFpc32: [RIP] addressing, val is 0, -1, -2 or -4
 *                      CFoffset64: 8 byte смещение for 64 bit builds
 * Возвращает:
 *      number of bytes in reference (4 or 8)
 */

цел Obj_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val,
        цел flags)
{
    цел retsize = (flags & CFoffset64) ? 8 : 4;
static if (0)
{
    printf("\nObj_reftoident('%s' seg %d, смещение x%llx, val x%llx, flags x%x)\n",
        s.Sident.ptr,seg,cast(бдол)смещение,cast(бдол)val,flags);
    printf("retsize = %d\n", retsize);
    //dbg_printf("Sseg = %d, Sxtrnnum = %d\n",s.Sseg,s.Sxtrnnum);
    symbol_print(s);
}
    assert(seg > 0);
    if (s.Sclass != SClocstat && !s.Sxtrnnum)
    {   // It may get defined later as public or local, so defer
        т_мера numbyteswritten = addtofixlist(s, смещение, seg, val, flags);
        assert(numbyteswritten == retsize);
    }
    else
    {
        if (I64)
        {
            //if (s.Sclass != SCcomdat)
                //val += s.Soffset;
            цел v = 0;
            if (flags & CFpc32)
                v = cast(цел)val;
            if (flags & CFselfrel)
            {
                Obj_addrel(seg, смещение, s, 0, RELrel, v);
            }
            else
            {
                Obj_addrel(seg, смещение, s, 0, RELaddr, v);
            }
        }
        else
        {
            if (SegData[seg].isCode() && flags & CFselfrel)
            {
                if (!jumpTableSeg)
                {
                    jumpTableSeg =
                        Obj_getsegment("__jump_table", "__IMPORT",  0, S_SYMBOL_STUBS | S_ATTR_PURE_INSTRUCTIONS | S_ATTR_SOME_INSTRUCTIONS | S_ATTR_SELF_MODIFYING_CODE);
                }
                seg_data *pseg = SegData[jumpTableSeg];
                if (I64)
                    SecHdrTab64[pseg.SDshtidx].reserved2 = 5;
                else
                    SecHdrTab[pseg.SDshtidx].reserved2 = 5;

                if (!indirectsymbuf1)
                {
                    indirectsymbuf1 = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
                    assert(indirectsymbuf1);
                }
                else
                {   // Look through indirectsym to see if it is already there
                    цел n = cast(цел)(indirectsymbuf1.size() / (Symbol *).sizeof);
                    Symbol **psym = cast(Symbol **)indirectsymbuf1.буф;
                    for (цел i = 0; i < n; i++)
                    {   // Linear search, pretty pathetic
                        if (s == psym[i])
                        {   val = i * 5;
                            goto L1;
                        }
                    }
                }

                val = pseg.SDbuf.size();
                static const сим[5] halts = [ 0xF4,0xF4,0xF4,0xF4,0xF4 ];
                pseg.SDbuf.пиши(halts.ptr, 5);

                // Add symbol s to indirectsymbuf1
                indirectsymbuf1.пиши((&s)[0 .. 1]);
             L1:
                val -= смещение + 4;
                Obj_addrel(seg, смещение, null, jumpTableSeg, RELrel);
            }
            else if (SegData[seg].isCode() &&
                     !(flags & CFindirect) &&
                    ((s.Sclass != SCextern && SegData[s.Sseg].isCode()) || s.Sclass == SClocstat || s.Sclass == SCstatic))
            {
                val += s.Soffset;
                Obj_addrel(seg, смещение, null, s.Sseg, RELaddr);
            }
            else if ((flags & CFindirect) ||
                     SegData[seg].isCode() && !tyfunc(s.ty()))
            {
                if (!pointersSeg)
                {
                    pointersSeg =
                        Obj_getsegment("__pointers", "__IMPORT",  0, S_NON_LAZY_SYMBOL_POINTERS);
                }
                seg_data *pseg = SegData[pointersSeg];

                if (!indirectsymbuf2)
                {
                    indirectsymbuf2 = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
                    assert(indirectsymbuf2);
                }
                else
                {   // Look through indirectsym to see if it is already there
                    цел n = cast(цел)(indirectsymbuf2.size() / (Symbol *).sizeof);
                    Symbol **psym = cast(Symbol **)indirectsymbuf2.буф;
                    for (цел i = 0; i < n; i++)
                    {   // Linear search, pretty pathetic
                        if (s == psym[i])
                        {   val = i * 4;
                            goto L2;
                        }
                    }
                }

                val = pseg.SDbuf.size();
                pseg.SDbuf.writezeros(_tysize[TYnptr]);

                // Add symbol s to indirectsymbuf2
                indirectsymbuf2.пиши((&s)[0 .. 1]);

             L2:
                //printf("Obj_reftoident: seg = %d, смещение = x%x, s = %s, val = x%x, pointersSeg = %d\n", seg, (цел)смещение, s.Sident.ptr, (цел)val, pointersSeg);
                if (flags & CFindirect)
                {
                    Relocation rel = проц;
                    rel.смещение = смещение;
                    rel.targsym = null;
                    rel.targseg = pointersSeg;
                    rel.rtype = RELaddr;
                    rel.флаг = 0;
                    rel.funcsym = null;
                    rel.val = 0;
                    seg_data *pseg2 = SegData[seg];
                    if (!pseg2.SDrel)
                    {
                        pseg2.SDrel = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
                        assert(pseg2.SDrel);
                    }
                    pseg2.SDrel.пиши(&rel, rel.sizeof);
                }
                else
                    Obj_addrel(seg, смещение, null, pointersSeg, RELaddr);
            }
            else
            {   //val -= s.Soffset;
                Obj_addrel(seg, смещение, s, 0, RELaddr);
            }
        }

        Outbuffer *буф = SegData[seg].SDbuf;
        цел save = cast(цел)буф.size();
        буф.position(cast(бцел)смещение, retsize);
        //printf("смещение = x%llx, val = x%llx\n", смещение, val);
        if (retsize == 8)
            буф.write64(val);
        else
            буф.write32(cast(цел)val);
        if (save > смещение + retsize)
            буф.устРазм(save);
    }
    return retsize;
}

/*****************************************
 * Generate far16 thunk.
 * Input:
 *      s       Symbol to generate a thunk for
 */

проц Obj_far16thunk(Symbol *s)
{
    //dbg_printf("Obj_far16thunk('%s')\n", s.Sident.ptr);
    assert(0);
}

/**************************************
 * Mark объект файл as using floating point.
 */

проц Obj_fltused()
{
    //dbg_printf("Obj_fltused()\n");
}

/************************************
 * Close and delete .OBJ файл.
 */

проц objfile_delete()
{
    //удали(fobjname); // delete corrupt output файл
}

/**********************************
 * Terminate.
 */

проц objfile_term()
{
static if(TERMCODE)
{
    mem_free(fobjname);
    fobjname = null;
}
}

/**********************************
  * Write to the объект файл
  */
/+проц objfile_write(FILE *fd, проц *буфер, бцел len)
{
    fobjbuf.пиши(буфер, len);
}+/

цел elf_align(targ_т_мера size, цел foffset)
{
    if (size <= 1)
        return foffset;
    цел смещение = cast(цел)((foffset + size - 1) & ~(size - 1));
    if (смещение > foffset)
        fobjbuf.writezeros(смещение - foffset);
    return смещение;
}

/***************************************
 * Stuff pointer to ModuleInfo in its own segment.
 */

version (Dinrus)
{
проц Obj_moduleinfo(Symbol *scc)
{
    цел align_ = I64 ? 3 : 2; // align to _tysize[TYnptr]

    цел seg = Obj_getsegment("__minfodata", "__DATA", align_, S_REGULAR);
    //printf("Obj_moduleinfo(%s) seg = %d:x%x\n", scc.Sident.ptr, seg, Offset(seg));

static if (0)
{
    тип *t = type_fake(TYint);
    t.Tmangle = mTYman_c;
    сим *p = cast(сим *)malloc(5 + strlen(scc.Sident.ptr) + 1);
    strcpy(p, "SUPER");
    strcpy(p + 5, scc.Sident.ptr);
    Symbol *s_minfo_beg = symbol_name(p, SCglobal, t);
    Obj_pubdef(seg, s_minfo_beg, 0);
}

    цел flags = CFoff;
    if (I64)
        flags |= CFoffset64;
    SegData[seg].SDoffset += Obj_reftoident(seg, Offset(seg), scc, 0, flags);
}
}

/*************************************
 */

проц Obj_gotref(Symbol *s)
{
    //printf("Obj_gotref(%x '%s', %d)\n",s,s.Sident.ptr, s.Sclass);
    switch(s.Sclass)
    {
        case SCstatic:
        case SClocstat:
            s.Sfl = FLgotoff;
            break;

        case SCextern:
        case SCglobal:
        case SCcomdat:
        case SCcomdef:
            s.Sfl = FLgot;
            break;

        default:
            break;
    }
}

/**
 * Возвращает the symbol for the __tlv_bootstrap function.
 *
 * This function is используется in the implementation of native thread local storage.
 * It's используется as a placeholder in the TLV descriptors. The dynamic linker will
 * replace the placeholder with a real function at load time.
 */
Symbol* Obj_tlv_bootstrap()
{
     Symbol* tlv_bootstrap_sym;
    if (!tlv_bootstrap_sym)
        tlv_bootstrap_sym = symbol_name("__tlv_bootstrap", SCextern, type_fake(TYnfunc));
    return tlv_bootstrap_sym;
}


проц Obj_write_pointerRef(Symbol* s, бцел off)
{
}

/******************************************
 * Generate fixup specific to .eh_frame and .gcc_except_table sections.
 * Параметры:
 *      seg = segment of where to пиши fixup
 *      смещение = смещение of where to пиши fixup
 *      s = fixup is a reference to this Symbol
 *      val = displacement from s
 * Возвращает:
 *      number of bytes written at seg:смещение
 */
цел dwarf_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val)
{
    //printf("dwarf_reftoident(seg=%d смещение=x%x s=%s val=x%x\n", seg, (цел)смещение, s.Sident.ptr, (цел)val);
    Obj_reftoident(seg, смещение, s, val + 4, I64 ? CFoff : CFindirect);
    return 4;
}

/*****************************************
 * Generate LSDA and PC_Begin fixups in the __eh_frame segment encoded as DW_EH_PE_pcrel|ptr.
 * 64 bits
 *   LSDA
 *      [0] address x0071 symbolnum 6 pcrel 0 length 3 extern 1 тип 5 RELOC_SUBTRACTOR __Z3foov.eh
 *      [1] address x0071 symbolnum 1 pcrel 0 length 3 extern 1 тип 0 RELOC_UNSIGNED   GCC_except_table2
 *   PC_Begin:
 *      [2] address x0060 symbolnum 6 pcrel 0 length 3 extern 1 тип 5 RELOC_SUBTRACTOR __Z3foov.eh
 *      [3] address x0060 symbolnum 5 pcrel 0 length 3 extern 1 тип 0 RELOC_UNSIGNED   __Z3foov
 *      Want the результат to be  &s - pc
 *      The fixup yields       &s - &fdesym + значение
 *      Therefore              значение = &fdesym - pc
 *      which is the same as   fdesym.Soffset - смещение
 * 32 bits
 *   LSDA
 *      [6] address x0028 pcrel 0 length 2 значение x0 тип 4 RELOC_LOCAL_SECTDIFF
 *      [7] address x0000 pcrel 0 length 2 значение x1dc тип 1 RELOC_PAIR
 *   PC_Begin
 *      [8] address x0013 pcrel 0 length 2 значение x228 тип 4 RELOC_LOCAL_SECTDIFF
 *      [9] address x0000 pcrel 0 length 2 значение x1c7 тип 1 RELOC_PAIR
 * Параметры:
 *      dfseg = segment of where to пиши fixup (eh_frame segment)
 *      смещение = смещение of where to пиши fixup (eh_frame смещение)
 *      s = fixup is a reference to this Symbol (GCC_except_table%d or function_name)
 *      val = displacement from s
 *      fdesym = function_name.eh
 * Возвращает:
 *      number of bytes written at seg:смещение
 */
цел dwarf_eh_frame_fixup(цел dfseg, targ_т_мера смещение, Symbol *s, targ_т_мера val, Symbol *fdesym)
{
    Outbuffer *буф = SegData[dfseg].SDbuf;
    assert(смещение == буф.size());
    assert(fdesym.Sseg == dfseg);
    if (I64)
        буф.write64(val);  // add in 'значение' later
    else
        буф.write32(cast(цел)val);

    Relocation rel;
    rel.смещение = смещение;
    rel.targsym = s;
    rel.targseg = 0;
    rel.rtype = RELaddr;
    rel.флаг = 1;
    rel.funcsym = fdesym;
    rel.val = 0;
    seg_data *pseg = SegData[dfseg];
    if (!pseg.SDrel)
    {
        pseg.SDrel = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(pseg.SDrel);
    }
    pseg.SDrel.пиши(&rel, rel.sizeof);

    return I64 ? 8 : 4;
}

}
}
